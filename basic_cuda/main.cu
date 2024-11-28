#include <cuda_runtime.h> // Required for CUDA runtime API
#include <stdio.h>        // Required for printf

// CUDA kernel
__global__ void helloWorldKernel() {
    printf("Hello, World from GPU thread %d!\n", threadIdx.x);
}

int main() {
    // Launch the kernel with 1 block and 10 threads
    helloWorldKernel<<<1, 10>>>();

    // Wait for the GPU to finish before accessing results
    cudaDeviceSynchronize();

    return 0;
}