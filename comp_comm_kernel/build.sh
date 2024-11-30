ARCH=$(nvidia-smi --query-gpu=compute_cap --format=csv,noheader | tr -d '.')
# Step 1: Compile CUDA source file to LLVM IR
clang++ $1.cu -S -x cuda -I/usr/include/c++/11/ -I/usr/include/x86_64-linux-gnu/c++/11/ \
        -emit-llvm -O0 -Xclang -disable-llvm-passes --cuda-gpu-arch=sm_$ARCH 

# Step 2: Convert LLVM BC to LLVM IR
llvm-dis $1-cuda-nvptx64-nvidia-cuda-sm_${ARCH}.bc -o $1.ll

sed -i 's/optnone//g' $1.ll

# Step 3: Convert LLVM IR to PTX Assembly
llc -march=nvptx64 -mcpu=sm_89  $1.ll -o $1.ptx

# Step 4: Check the PTX file for errors
echo "Checking for errors in PTX file..."
ptxas -arch=sm_89 -o /dev/null $1.ptx

# Step 5: Generate CUBIN from PTX
nvcc -arch=sm_89 -cubin -o $1_gemm.cubin $1.ptx