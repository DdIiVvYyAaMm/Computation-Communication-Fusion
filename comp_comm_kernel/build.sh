#!/bin/bash

compile_cu_to_ll()
{   
    local input=$1

    echo "compiling ${input}.cu to ${input}.ll"

    # convert cuda kernel to llvm byte code representation
    clang++ ${input}.cu -S -x cuda -I/usr/include/c++/11/ -I/usr/include/x86_64-linux-gnu/c++/11/ \
            -emit-llvm -O0 -Xclang -disable-llvm-passes --cuda-gpu-arch=sm_$ARCH 
    
    # convert llvm byte code to human readable ir representation
    llvm-dis ${input}-cuda-nvptx64-nvidia-cuda-sm_${ARCH}.bc -o ${input}.ll
    
    # get rid of optnone flags in the file to make cuda kernel ir accessible to our llvm optimization pass
    sed -i 's/optnone//g' ${input}.ll
}

compile_ll_to_cubin() 
{
    local input=$1
    local output=$2

    echo "compiling ${input}.ll to ${output}.cubin"

    # convert optimized llvm ir to ptx assembly
    llc -march=nvptx64 -mcpu=sm_${ARCH} "$input.ll" -o "$input.ptx"

    # check if the ptx file is well formed (i.e. this should not have any output)
    echo "Checking for errors in $input.ptx..."
    ptxas -arch=sm_${ARCH} -o /dev/null "$input.ptx"

    # convert the ptx file to a cuda binary (cubin)
    nvcc -arch=sm_${ARCH} -cubin -o "${output}_gemm.cubin" "$input.ptx"
}

# detect nvidia gpu architecture (i.e. compute capability)
ARCH=89
#$(nvidia-smi --query-gpu=compute_cap --format=csv,noheader | tr -d '.')

compile_cu_to_ll "gemm"
compile_cu_to_ll "optimized"

mv optimized.ll manually_optimized.ll

# determine correct file extension for OS
PASS_ROOT_FOLDER=./../LoopTilingPass
OS=$(uname)
PASS_EXTENSION=dylib
if [[ "$OS" == "Linux" ]]; then
    PASS_EXTENSION=so
fi

# run our llvm loop tiling optimization pass on the cuda kernel
opt -load-pass-plugin=${PASS_ROOT_FOLDER}/build/LoopTilingPass.${PASS_EXTENSION} -passes="LoopTilingPass" gemm.ll -o optimized.ll

mv gemm.ll original.ll

# compile both original and optimized llvm ir to cubin files
compile_ll_to_cubin "original"
compile_ll_to_cubin "optimized"
compile_ll_to_cubin "manually_optimized"