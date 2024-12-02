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
#include "llvm/IR/IRBuilder.h"
#include <vector>
#include <string>
#include "LoopTiling.h"
using namespace llvm;

// const int tile_size_1 = 20;
// const int tile_size_2 = 20;
// const int tile_size_3 = 20;
// const int loop_complexity = 3;

// will have to change to handle multiple loops
std::vector<int> lc = {2, 2, 2, 2}; 
std::vector<int> tile_sizes{12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23};
int loop_iter = 0;

// for (A) {
//   for (B) {
//     for (C) {

//     }
//   }
// }
// for (D) {
//   for (E) {
    
//   }
// }

std::vector<Value *> IndVar;
std::vector<Instruction *> SecondInst;
std::vector<Value *> num_iterations;
std::vector<BasicBlock *> LHeader;
std::vector<BasicBlock *> LIncrementer;

std::vector<Instruction *> FirstInst;
std::vector<Value *> FirstOperand;
std::vector<Value *> IndVarLoad;
std::vector<Value *> minOperand1;
std::vector<Value *> minOperand2;
std::vector<Value *> cmpMin;
std::vector<Value *> Min;
std::vector<Value *> Cond;

Instruction *LastInst;
Instruction *firstInst;

Value *InitIndVar;

void flush_variables() {
  IndVar.clear();
  SecondInst.clear();
  num_iterations.clear();
  LHeader.clear();
  LIncrementer.clear();
  FirstInst.clear();
  FirstOperand.clear();
  IndVarLoad.clear();
  minOperand1.clear();
  minOperand2.clear();
  cmpMin.clear();
  Min.clear();
  Cond.clear();
  loop_iter = 0;
}

// void init_variables(llvm::Function &F, llvm::Loop *L, BasicBlock *Preheader, IRBuilder<> &Builder, int loop_complexity, int start_index) {

//   int flag = 1;
//   bool is_outermost = true;
//   bool is_innermost = false;
//   int i  = loop_iter;

//     while (flag) {
//     is_innermost = (L->getSubLoops().size() == 0);
//     if (is_innermost) {
//       IndVar.push_back(Builder.CreateAlloca(Type::getInt32Ty(F.getContext()), nullptr, "IndVar" + std::to_string(i + start_index)));
//       InitIndVar = Builder.CreateLoad(Type::getInt32Ty(F.getContext()), L->getHeader()->getFirstNonPHI()->getOperand(0), "InitIndVar" + std::to_string(loop_iter + start_index));
//       Builder.CreateStore(InitIndVar, IndVar[i]);
//       SecondInst.push_back(L->getHeader()->getFirstNonPHI()->getNextNode());
//       num_iterations.push_back(SecondInst[i]->getOperand(0));
//       LHeader.push_back(BasicBlock::Create(F.getContext(), "LHeader" + std::to_string(i + start_index), &F));
//       LIncrementer.push_back(BasicBlock::Create(F.getContext(), "LIncrementer" + std::to_string(i + start_index), &F));
//       flag = 0;
//       is_outermost = false;
//     }
//     else if (is_outermost) {
//       IndVar.push_back(Builder.CreateAlloca(Type::getInt32Ty(F.getContext()), nullptr, "IndVar" + std::to_string(i + start_index)));
//       InitIndVar = Builder.CreateLoad(Type::getInt32Ty(F.getContext()), L->getHeader()->getFirstNonPHI()->getOperand(0), "InitIndVar" + std::to_string(loop_iter + start_index));
//       Builder.CreateStore(InitIndVar, IndVar[i]);
//       SecondInst.push_back(L->getHeader()->getFirstNonPHI()->getNextNode());
//       num_iterations.push_back(SecondInst[i]->getOperand(0));
//       LHeader.push_back(BasicBlock::Create(F.getContext(), "LHeader" + std::to_string(i + start_index), &F));
//       LIncrementer.push_back(BasicBlock::Create(F.getContext(), "LIncrementer" + std::to_string(i + start_index), &F));
//       L = L->getSubLoops()[0];
//       is_outermost = false;
//     }
//     else {
//       IndVar.push_back(Builder.CreateAlloca(Type::getInt32Ty(F.getContext()), nullptr, "IndVar" + std::to_string(i + start_index)));
//       InitIndVar = Builder.CreateLoad(Type::getInt32Ty(F.getContext()), L->getHeader()->getFirstNonPHI()->getOperand(0), "InitIndVar" + std::to_string(loop_iter + start_index));
//       Builder.CreateStore(InitIndVar, IndVar[i]);
//       SecondInst.push_back(L->getHeader()->getFirstNonPHI()->getNextNode());
//       num_iterations.push_back(SecondInst[i]->getOperand(0));
//       LHeader.push_back(BasicBlock::Create(F.getContext(), "LHeader" + std::to_string(i + start_index), &F));
//       LIncrementer.push_back(BasicBlock::Create(F.getContext(), "LIncrementer" + std::to_string(i + start_index), &F));
//       L = L->getSubLoops()[0];
//       is_outermost = false;
//     }
//     i = i + 1;
//   }

// }


void handleLoopInitialization(llvm::Function &F, llvm::Loop *L, IRBuilder<> &Builder, int index, int start_index) {
    IndVar.push_back(Builder.CreateAlloca(Type::getInt32Ty(F.getContext()), nullptr, 
                                          "IndVar" + std::to_string(index + start_index)));
    auto *firstNonPHI = L->getHeader()->getFirstNonPHI();
    InitIndVar = Builder.CreateLoad(Type::getInt32Ty(F.getContext()), firstNonPHI->getOperand(0), 
                                    "InitIndVar" + std::to_string(index + start_index));
    Builder.CreateStore(InitIndVar, IndVar[index]);
    SecondInst.push_back(firstNonPHI->getNextNode());
    num_iterations.push_back(SecondInst[index]->getOperand(0));
    LHeader.push_back(BasicBlock::Create(F.getContext(), 
                                         "LHeader" + std::to_string(index + start_index), &F));
    LIncrementer.push_back(BasicBlock::Create(F.getContext(), 
                                              "LIncrementer" + std::to_string(index + start_index), &F));
}

void init_variables(llvm::Function &F, llvm::Loop *L, BasicBlock *Preheader, IRBuilder<> &Builder, 
                    int loop_complexity, int start_index) {
    int flag = 1;
    bool is_outermost = true;
    bool is_innermost = false;
    int i = loop_iter;

    while (flag) {
        is_innermost = (L->getSubLoops().size() == 0);

        if (is_innermost) {
            handleLoopInitialization(F, L, Builder, i, start_index);
            flag = 0;
            is_outermost = false;
        } else if (is_outermost) {
            handleLoopInitialization(F, L, Builder, i, start_index);
            errs() << L->getHeader()->getFirstNonPHI() << "\n";
            L = L->getSubLoops()[0];
            is_outermost = false;
        } else {
            handleLoopInitialization(F, L, Builder, i, start_index);
            L = L->getSubLoops()[0];
            is_outermost = false;
        }

        i++;
    }
}


void tile_loops(llvm::Function &F, llvm::Loop *L, int loop_complexity, std::vector<int> tile_sizes, int start_index) {

  // inside this loop, i will tile the outermost loop that was passed (L)
  // along with all the subloops that are present inside this loop

  llvm::Loop *Lcopy = L;
  int flag = 1;
  bool is_outermost = true;
  bool is_innermost = false;
  BasicBlock *Preheader = L->getLoopPreheader();
  IRBuilder<> Builder(Preheader->getTerminator());

  // before moving on to tiling the loops, create and push all variables that will have to be used
  // you will have to do this loop_complexity number of times
  // call a function called create_variables() that will do this
  // the function will have arguments F, L, Preheader, loop_complexity
  init_variables(F, L, Preheader, Builder, loop_complexity, start_index);
  
  Preheader->getTerminator()->setSuccessor(0, LHeader[loop_iter]);

  while (flag) {
    is_innermost = (Lcopy->getSubLoops().size() == 0);
    // check whether the current loop is the innermost one or not
    if (loop_complexity == 1) {
      Builder.SetInsertPoint(LHeader[loop_iter]);
      FirstInst.push_back(Lcopy->getHeader()->getFirstNonPHI());
      FirstOperand.push_back(FirstInst[loop_iter]->getOperand(0));
      IndVarLoad.push_back(Builder.CreateLoad(Type::getInt32Ty(F.getContext()), IndVar[loop_iter], "IndVarLoad" + std::to_string(loop_iter + start_index)));
      Builder.CreateStore(IndVarLoad[loop_iter], FirstOperand[loop_iter]);
      minOperand1.push_back(Builder.CreateAdd(IndVarLoad[loop_iter], ConstantInt::get(Type::getInt32Ty(F.getContext()), tile_sizes[loop_iter])));
      Value *IterKValue = Builder.CreateLoad(Type::getInt32Ty(F.getContext()), num_iterations[loop_iter], "iterKValue" + std::to_string(loop_iter));
      minOperand2.push_back(IterKValue);
      cmpMin.push_back(Builder.CreateICmpSLT(minOperand1[loop_iter], minOperand2[loop_iter], "cmpMin" + std::to_string(loop_iter + start_index)));
      Min.push_back(Builder.CreateSelect(cmpMin[loop_iter], minOperand1[loop_iter], minOperand2[loop_iter], "Min" + std::to_string(loop_iter + start_index)));
      Cond.push_back(Builder.CreateICmpSLT(IndVarLoad[loop_iter], IterKValue));
      Builder.CreateCondBr(Cond[loop_iter], L->getHeader(), Lcopy->getExitBlock());
      SecondInst[loop_iter]->getNextNode()->setOperand(1, Min[loop_iter]);     
      Builder.SetInsertPoint(LIncrementer[loop_iter]);
      Builder.CreateStore(Builder.CreateAdd(IndVarLoad[loop_iter], ConstantInt::get(Type::getInt32Ty(F.getContext()), tile_sizes[loop_iter])), IndVar[loop_iter]);
      Builder.CreateBr(LHeader[loop_iter]);      
      LastInst = L->getHeader()->getTerminator(); 
      LastInst->setOperand(1, LIncrementer[loop_complexity-1]);     
      flag = 0;
    }
    else if (is_innermost) {
      // if innermost, we do not want to go to the while again
      // tile the current loop
      Builder.SetInsertPoint(LHeader[loop_iter]);
      FirstInst.push_back(Lcopy->getHeader()->getFirstNonPHI());
      FirstOperand.push_back(FirstInst[loop_iter]->getOperand(0));
      IndVarLoad.push_back(Builder.CreateLoad(Type::getInt32Ty(F.getContext()), IndVar[loop_iter], "IndVarLoad" + std::to_string(loop_iter + start_index)));
      Builder.CreateStore(IndVarLoad[loop_iter], FirstOperand[loop_iter]);
      Builder.CreateStore(IndVarLoad[loop_iter+1-loop_complexity], FirstOperand[loop_iter+1-loop_complexity]);
      minOperand1.push_back(Builder.CreateAdd(IndVarLoad[loop_iter], ConstantInt::get(Type::getInt32Ty(F.getContext()), tile_sizes[loop_iter])));
      Value *IterKValue = Builder.CreateLoad(Type::getInt32Ty(F.getContext()), num_iterations[loop_iter], "iterKValue" + std::to_string(loop_iter));
      minOperand2.push_back(IterKValue);
      cmpMin.push_back(Builder.CreateICmpSLT(minOperand1[loop_iter], minOperand2[loop_iter], "cmpMin" + std::to_string(loop_iter + start_index)));
      Min.push_back(Builder.CreateSelect(cmpMin[loop_iter], minOperand1[loop_iter], minOperand2[loop_iter], "Min" + std::to_string(loop_iter + start_index)));
      Cond.push_back(Builder.CreateICmpSLT(IndVarLoad[loop_iter], IterKValue));
      Builder.CreateCondBr(Cond[loop_iter], L->getHeader(), LIncrementer[loop_iter-1]);
      SecondInst[loop_iter]->getNextNode()->setOperand(1, Min[loop_iter]);
      Builder.SetInsertPoint(LIncrementer[loop_iter]);
      Builder.CreateStore(Builder.CreateAdd(IndVarLoad[loop_iter], ConstantInt::get(Type::getInt32Ty(F.getContext()), tile_sizes[loop_iter])), IndVar[loop_iter]);
      Builder.CreateBr(LHeader[loop_iter]);
      LastInst = L->getHeader()->getTerminator(); 
      LastInst->setOperand(1, LIncrementer[loop_complexity-1]);
      firstInst = &(Lcopy->getLoopPreheader()->front());
      firstInst->setOperand(0, IndVarLoad[loop_iter]);     
      flag = 0;
      is_outermost = false;
    }
    else if (is_outermost) {
      // first i.e. outermost loop
      // tile the current loop
      Builder.SetInsertPoint(LHeader[loop_iter]);
      FirstInst.push_back(Lcopy->getHeader()->getFirstNonPHI());
      FirstOperand.push_back(FirstInst[loop_iter]->getOperand(0));
      IndVarLoad.push_back(Builder.CreateLoad(Type::getInt32Ty(F.getContext()), IndVar[loop_iter], "IndVarLoad" + std::to_string(loop_iter + start_index)));
      Builder.CreateStore(IndVarLoad[loop_iter], FirstOperand[loop_iter]);
      Builder.CreateStore(ConstantInt::get(Type::getInt32Ty(F.getContext()), 0), IndVar[loop_iter+1]);
      minOperand1.push_back(Builder.CreateAdd(IndVarLoad[loop_iter], ConstantInt::get(Type::getInt32Ty(F.getContext()), tile_sizes[loop_iter])));
      Value *IterKValue = Builder.CreateLoad(Type::getInt32Ty(F.getContext()), num_iterations[loop_iter], "iterKValue" + std::to_string(loop_iter));
      minOperand2.push_back(IterKValue);
      cmpMin.push_back(Builder.CreateICmpSLT(minOperand1[loop_iter], minOperand2[loop_iter], "cmpMin" + std::to_string(loop_iter + start_index)));
      Min.push_back(Builder.CreateSelect(cmpMin[loop_iter], minOperand1[loop_iter], minOperand2[loop_iter], "Min" + std::to_string(loop_iter + start_index)));
      Cond.push_back(Builder.CreateICmpSLT(IndVarLoad[loop_iter], IterKValue));
      Builder.CreateCondBr(Cond[loop_iter], LHeader[loop_iter+1], Lcopy->getExitBlock());
      SecondInst[loop_iter]->getNextNode()->setOperand(1, Min[loop_iter]);     
      Builder.SetInsertPoint(LIncrementer[loop_iter]);
      Builder.CreateStore(Builder.CreateAdd(IndVarLoad[loop_iter], ConstantInt::get(Type::getInt32Ty(F.getContext()), tile_sizes[loop_iter])), IndVar[loop_iter]);
      Builder.CreateBr(LHeader[loop_iter]);      
      Lcopy = Lcopy->getSubLoops()[0];
      is_outermost = false;
    }
    else {
      // if not innermost, we want to go to the next inner loop
      // tile the current loop
      Builder.SetInsertPoint(LHeader[loop_iter]);
      FirstInst.push_back(Lcopy->getHeader()->getFirstNonPHI());
      FirstOperand.push_back(FirstInst[loop_iter]->getOperand(0));
      IndVarLoad.push_back(Builder.CreateLoad(Type::getInt32Ty(F.getContext()), IndVar[loop_iter], "IndVarLoad" + std::to_string(loop_iter + start_index)));
      Builder.CreateStore(IndVarLoad[loop_iter], FirstOperand[loop_iter]);
      Builder.CreateStore(ConstantInt::get(Type::getInt32Ty(F.getContext()), 0), IndVar[loop_iter+1]);
      minOperand1.push_back(Builder.CreateAdd(IndVarLoad[loop_iter], ConstantInt::get(Type::getInt32Ty(F.getContext()), tile_sizes[loop_iter])));
      Value *IterKValue = Builder.CreateLoad(Type::getInt32Ty(F.getContext()), num_iterations[loop_iter], "iterKValue" + std::to_string(loop_iter));
      minOperand2.push_back(IterKValue);
      cmpMin.push_back(Builder.CreateICmpSLT(minOperand1[loop_iter], minOperand2[loop_iter], "cmpMin" + std::to_string(loop_iter + start_index)));
      Min.push_back(Builder.CreateSelect(cmpMin[loop_iter], minOperand1[loop_iter], minOperand2[loop_iter], "Min" + std::to_string(loop_iter + start_index)));
      Cond.push_back(Builder.CreateICmpSLT(IndVarLoad[loop_iter], IterKValue));
      Builder.CreateCondBr(Cond[loop_iter], LHeader[loop_iter+1], LIncrementer[loop_iter-1]);
      SecondInst[loop_iter]->getNextNode()->setOperand(1, Min[loop_iter]);    
      Builder.SetInsertPoint(LIncrementer[loop_iter]);
      Builder.CreateStore(Builder.CreateAdd(IndVarLoad[loop_iter], ConstantInt::get(Type::getInt32Ty(F.getContext()), tile_sizes[loop_iter])), IndVar[loop_iter]);
      Builder.CreateBr(LHeader[loop_iter]);
      firstInst = &(Lcopy->getLoopPreheader()->front());
      firstInst->setOperand(0, IndVarLoad[loop_iter]);
      Lcopy = Lcopy->getSubLoops()[0];
      is_outermost = false;
    }
  loop_iter = loop_iter + 1;
  }
  return;
}

// namespace {
//   struct HW2CorrectnessPass : public PassInfoMixin<HW2CorrectnessPass> {

//     PreservedAnalyses run(Function &F, FunctionAnalysisManager &FAM) {
//       llvm::BlockFrequencyAnalysis::Result &bfi = FAM.getResult<BlockFrequencyAnalysis>(F);
//       llvm::BranchProbabilityAnalysis::Result &bpi = FAM.getResult<BranchProbabilityAnalysis>(F);
//       llvm::LoopAnalysis::Result &li = FAM.getResult<LoopAnalysis>(F);

//       // initialize parent iterator
//       int parent_iterator = 0;

//       // create a vector that store cummulative sum of loop complexities
//       // this will be used to keep track of the parent loop of the current loop
//       std::vector<int> cum_sum;
//       int sum = 0;
//       for (int x: lc) {
//         sum = sum + x;
//         cum_sum.push_back(sum);
//       }

//       // iterating over each loop
//       for (llvm::Loop *L: li) {
//         flush_variables();
//         std::vector<int> current_tile_sizes;
//         int left_index = parent_iterator == 0 ? 0 : cum_sum[parent_iterator-1];
//         int right_index = cum_sum[parent_iterator];
//         for (int i = left_index; i < right_index; i++) {
//           current_tile_sizes.push_back(tile_sizes[i]);
//         }
//         tile_loops(F, L, lc[parent_iterator], current_tile_sizes, left_index);
//         parent_iterator = parent_iterator + 1;
//       }

//       return PreservedAnalyses::all();
//     }
//   };
// }

// extern "C" ::llvm::PassPluginLibraryInfo LLVM_ATTRIBUTE_WEAK llvmGetPassPluginInfo() {
//   return {
//     LLVM_PLUGIN_API_VERSION, "HW2Pass", "v0.1",
//     [](PassBuilder &PB) {
//       PB.registerPipelineParsingCallback(
//         [](StringRef Name, FunctionPassManager &FPM,
//         ArrayRef<PassBuilder::PipelineElement>) {
//           if(Name == "fplicm-correctness"){
//             FPM.addPass(HW2CorrectnessPass());
//             return true;
//           }
//           return false;
//         }
//       );
//     }
//   };
// }