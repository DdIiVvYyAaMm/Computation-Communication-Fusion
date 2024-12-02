#include "llvm/Analysis/BlockFrequencyInfo.h"
#include "llvm/Analysis/BranchProbabilityInfo.h"
#include "llvm/Analysis/LoopInfo.h"
#include "llvm/Analysis/LoopIterator.h"
#include "llvm/Analysis/LoopPass.h"
#include "llvm/IR/CFG.h"
#include "llvm/IR/Instructions.h"
#include "llvm/IR/LLVMContext.h"
#include "llvm/IR/PassManager.h"
#include "llvm/Passes/PassBuilder.h"
#include "llvm/Passes/PassPlugin.h"
#include "llvm/Support/Debug.h"
#include "llvm/Support/raw_ostream.h"
#include "llvm/Transforms/Scalar/LoopPassManager.h"
#include "llvm/Transforms/Utils/BasicBlockUtils.h"
#include "llvm/Transforms/Utils/LoopUtils.h"
#include "LoopTiling.h"
#include "llvm/Analysis/LoopNestAnalysis.h"

using namespace llvm;
using namespace std;

#include <vector>
#include <cmath>

class Polynomial {
private:
    std::vector<int> coeffs;

public:
    Polynomial(const std::vector<int>& coeffs) : coeffs(coeffs) {}

    static Polynomial unit(const int scalar, const int order) {
        std::vector<int> result(order + 1, 0);
        result[order] = scalar;
        return Polynomial(result);
    }

    Polynomial add(const Polynomial& other) const {
        std::vector<int> result(std::max(coeffs.size(), other.coeffs.size()));
        for (size_t i = 0; i < result.size(); i++) {
            if (i < coeffs.size()) result[i] += coeffs[i];
            if (i < other.coeffs.size()) result[i] += other.coeffs[i];
        }
        return Polynomial(result);
    }

    int evaluate(int x) const {
        int result = 0;
        for (int i = coeffs.size() - 1; i >= 0; i--) {
            result = result * x + coeffs[i];
        }
        return result;
    }

    int order() const {
        return coeffs.size() - 1;
    }
};

// End copilot-generated code

//  6  def generate_polynomial(outer_variables, loop):
//  7     poly = []
//  8     for instruction in loop:
//  9         if instruction is a loop header:
// 10             p1 = generate_polynomial(
// 11  		      outer_variables + [get_loop_induction_variable(loop)],
// 12  		      instruction
// 13                  )
// 14             skip to end of loop
// 15         else if instruction is start of array access:
// 16             calculate how many “outer_variables” are used as indeces of the 17  			array access
// 18             poly[dimensions of array access] += 1
// 19             skip to end of array access

using namespace llvm;
using namespace std;


vector<Value*> get_loop_induction_variables(LoopInfo& LI, ScalarEvolution& SE, BasicBlock& block) {
    vector<Value*> result;
    Loop* loop = LI.getLoopFor(&block);
    while (loop != nullptr) {
        Value* induction_variable = loop->getInductionVariable(SE);
        if (induction_variable != nullptr) {
            result.push_back(induction_variable);
        }
        loop = loop->getParentLoop();
    }
    return result;
}

Polynomial working_set(LoopInfo& LI, ScalarEvolution& SE, Loop* loop) {
    Polynomial poly({0});
    for (BasicBlock* block : loop->getBlocks()) {
        vector<Value*> induction_variables = get_loop_induction_variables(LI, SE, *block);
        for (Instruction& instruction : *block) {
          if (llvm::isa<LoadInst>(instruction) || llvm::isa<StoreInst>(instruction)) {
            llvm::Value *origin;
            if (llvm::isa<LoadInst>(instruction)) {
              LoadInst *load = cast<LoadInst>(&instruction);
              origin = load->getPointerOperand();
            } else {
              StoreInst *store = cast<StoreInst>(&instruction);
              origin = store->getPointerOperand();
            }
            //const DataLayout &DL = instruction.getModule()->getDataLayout();
            unsigned size = 4;
            int dimension = 0;
            while (origin != nullptr && llvm::isa<GetElementPtrInst>(origin)) {
              GetElementPtrInst *gep = cast<GetElementPtrInst>(origin);
              origin = gep->getPointerOperand();
              dimension++;
            }
            poly = poly.add(Polynomial::unit(size, dimension));
          }


          // if (llvm::isa<GetElementPtrInst>(instruction)) {
          //   errs() << "Found GEP\n";
          //   GetElementPtrInst* gep = cast<GetElementPtrInst>(&instruction);
          //   errs() << "Found array access\n";
          //   int dimensions = gep->getNumIndices();
          //   errs() << dimensions << "\n";
          //   poly = poly.add(Polynomial::unit(dimensions));
          // }
        }
    }
    return poly;
}

bool fits(Polynomial* poly, int cacheSize, int tileSize) {
  return poly->evaluate(tileSize) <= cacheSize;
}

//#include "workingset.cpp"

namespace {
  
  struct LoopTilingPass : public PassInfoMixin<LoopTilingPass> {
    PreservedAnalyses run(Function &F, FunctionAnalysisManager &FAM) {
        if (F.getName().starts_with("noTile_")) {
          return PreservedAnalyses::all();
        }
        errs() << "Running LoopTilingPass on " << F.getName() << "\n";
        auto &SE = FAM.getResult<ScalarEvolutionAnalysis>(F);
        auto &LI = FAM.getResult<LoopAnalysis>(F);
        int startIndex = 0;
        for(Loop* L : LI) {
          Polynomial poly = working_set(LI, SE, L);


          int tileSize = getTileSize(LI, SE, L);
          int loopDepth = 0;
          // for (Loop *InnerLoop : L->getSubLoops()) {
          //   loopDepth = max(loopDepth, (int) InnerLoop->getLoopDepth());
          // }
          llvm::Loop *Lcopy = L;
          int flag = 1;
          bool is_outermost = true;
          bool is_innermost = false;
          
          while (flag) {
            is_innermost = (Lcopy->getSubLoops().size() == 0);
            // check whether the current loop is the innermost one or not
            if (is_innermost) {
              flag = 0;
              is_outermost = false;
            }
            else if (is_outermost) {
              Lcopy = Lcopy->getSubLoops()[0];
              is_outermost = false;
            }
            else {
              Lcopy = Lcopy->getSubLoops()[0];
              is_outermost = false;
            }
          loopDepth += 1;
          }
          vector<int> tileSizes;
          for(int i = 0; i < loopDepth; i++) {
            tileSizes.push_back(tileSize);
          }
          errs () << "Loop Depth: " << loopDepth << "\n";
          errs () << "Tile Size: " << tileSize << "\n";
          errs () << "Start Index: " << startIndex << "\n";
          flush_variables();
          tile_loops(F, L, loopDepth, tileSizes, startIndex);
          startIndex += loopDepth;
        }
        return PreservedAnalyses::all();
    };

    int getTileSize(LoopInfo& LI, ScalarEvolution& SE, Loop* loop) {
      Polynomial poly = working_set(LI, SE, loop);
      int cacheSize = 32768;
      int leastTileSize = 1;
      int maxTileSize = static_cast<int>(std::round(std::pow(cacheSize, 1.0 / (max(poly.order(), 1)))));
      int tileSize = INT_LEAST32_MIN;
      while(leastTileSize <= maxTileSize) {
        int midTileSize = (leastTileSize + maxTileSize) / 2;
        if(fits(&poly, cacheSize, midTileSize)) {
          tileSize = max(tileSize, midTileSize);
          leastTileSize = midTileSize + 1;
        } else {
          maxTileSize = midTileSize - 1;
        }
      }
      return tileSize;
    }
  };

  // void tileLoop(vector<int>* lc, vector<int>* tileSizes) {
  //   // Atharva and Indrajeet's function
  // }
}

extern "C" ::llvm::PassPluginLibraryInfo LLVM_ATTRIBUTE_WEAK llvmGetPassPluginInfo() {
  return {
    LLVM_PLUGIN_API_VERSION, "LoopTilingPass", "v0.1",
    [](PassBuilder &PB) {
      PB.registerPipelineParsingCallback(
        [](StringRef Name, FunctionPassManager &FPM,
        ArrayRef<PassBuilder::PipelineElement>) {
          if(Name == "LoopTilingPass"){
            FPM.addPass(LoopTilingPass());
            return true;
          }
          return false;
        }
      );
    }
  };
}