# detect nvidia gpu architecture (i.e. compute capability)
ARCH=$(nvidia-smi --query-gpu=compute_cap --format=csv,noheader | tr -d '.')

# convert cuda kernel to llvm byte code representation
clang++ main.cu -S -x cuda -I/usr/include/c++/11/ -I/usr/include/x86_64-linux-gnu/c++/11/ \
        -emit-llvm -O0 -Xclang -disable-llvm-passes --cuda-gpu-arch=sm_$ARCH 

# convert llvm byte code to human readable ir representation
llc -march=nvptx64 -mcpu=sm_$ARCH main-cuda-nvptx64-nvidia-cuda-sm_$ARCH.bc -o main.ptx

# check if the ptx file is well formed (i.e. this should not have any output)
echo "Checking for errors in PTX file..."
ptxas -arch=sm_$ARCH -o /dev/null main.ptx

# convert the ptx file to a cuda binary (cubin)
nvcc -arch=sm_$ARCH -cubin -o kernel.cubin main.ptx