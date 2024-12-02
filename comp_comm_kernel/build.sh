# detect nvidia gpu architecture (i.e. compute capability)
ARCH=$(nvidia-smi --query-gpu=compute_cap --format=csv,noheader | tr -d '.')

# convert cuda kernel to llvm byte code representation
clang++ $1.cu -S -x cuda -I/usr/include/c++/11/ -I/usr/include/x86_64-linux-gnu/c++/11/ \
        -emit-llvm -O0 -Xclang -disable-llvm-passes --cuda-gpu-arch=sm_$ARCH 

# convert llvm byte code to human readable ir representation
llvm-dis $1-cuda-nvptx64-nvidia-cuda-sm_${ARCH}.bc -o $1.ll

# get rid of optnone flags in the file to make cuda kernel ir accessible to our llvm optimization pass
sed -i 's/optnone//g' $1.ll

# run our llvm loop tiling optimization pass on the cuda kernel
opt -load-pass-plugin=./build/LoopTilingPass/LoopTilingPass.dylib -passes="LoopTilingPass" $1.ll -o $1.ll

# convert optimized llvm ir to ptx assembly
llc -march=nvptx64 -mcpu=sm_${ARCH}  $1.ll -o $1.ptx

# check if the ptx file is well formed (i.e. this should not have any output)
echo "Checking for errors in PTX file..."
ptxas -arch=sm_89 -o /dev/null $1.ptx

# convert the ptx file to a cuda binary (cubin)
nvcc -arch=sm_89 -cubin -o $1_gemm.cubin $1.ptx