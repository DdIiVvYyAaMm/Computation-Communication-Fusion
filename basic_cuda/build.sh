# Step 1: Compile CUDA source file to LLVM IR
clang++ main.cu -S -x cuda -I/usr/include/c++/11/ -I/usr/include/x86_64-linux-gnu/c++/11/ \
        -emit-llvm -O0 -Xclang -disable-llvm-passes --cuda-gpu-arch=sm_89 

# Step 2: Convert LLVM IR to PTX Assembly
llc -march=nvptx64 -mcpu=sm_89  main-cuda-nvptx64-nvidia-cuda-sm_89.bc -o main.ptx

# Step 3: Check the PTX file for errors
echo "Checking for errors in PTX file..."
ptxas -arch=sm_89 -o /dev/null main.ptx

# Step 4: Generate CUBIN from PTX
nvcc -arch=sm_89 -cubin -o kernel.cubin main.ptx