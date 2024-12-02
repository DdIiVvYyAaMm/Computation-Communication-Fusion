#include <iostream>
#include <cuda_runtime.h>

// CUDA kernel for matrix multiplication
__global__ void matrixMulKernel(const float* A, const float* B, float* C, int M, int N, int K) 
{
    int row = blockIdx.y * blockDim.y + threadIdx.y;
    int col = blockIdx.x * blockDim.x + threadIdx.x;

    if (row < M && col < N) 
    {
        float value = 0;
        for (int i = 0; i < K; ++i) 
        {
            value += A[row * K + i] * B[i * N + col];
        }
        C[row * N + col] = value;
    }
}

int main(int argc, char* argv[]) 
{
    // matrix dimensions
    int M = 512;
    int N = 512; 
    int K = 512; 

    size_t sizeA = M * K * sizeof(float);
    size_t sizeB = K * N * sizeof(float);
    size_t sizeC = M * N * sizeof(float);

    // allocate memory
    float* h_A = (float*)malloc(sizeA);
    float* h_B = (float*)malloc(sizeB);
    float* h_C = (float*)malloc(sizeC);

    // create a random matrix
    auto rand_max = static_cast<float>(RAND_MAX);
    for (int i = 0; i < M * K; ++i)
    { 
        h_A[i] = static_cast<float>(rand()) / rand_max;
    }
    for (int i = 0; i < K * N; ++i)
    {
         h_B[i] = static_cast<float>(rand()) / rand_max;
    }

    // allocate memory on the device
    float *d_A, *d_B, *d_C;
    cudaMalloc(&d_A, sizeA);
    cudaMalloc(&d_B, sizeB);
    cudaMalloc(&d_C, sizeC);

    // setup comms
    cudaMemcpy(d_A, h_A, sizeA, cudaMemcpyHostToDevice);
    cudaMemcpy(d_B, h_B, sizeB, cudaMemcpyHostToDevice);

    dim3 blockSize(16, 16);
    dim3 gridSize((N + blockSize.x - 1) / blockSize.x,
                  (M + blockSize.y - 1) / blockSize.y); 

    // launch CUDA kernel
    matrixMulKernel<<<gridSize, blockSize>>>(d_A, d_B, d_C, M, N, K);

    // wait for the GPU to finish
    cudaDeviceSynchronize();

    // Device-to-Host (D2H) communication
    cudaMemcpy(h_C, d_C, sizeC, cudaMemcpyDeviceToHost);

    // validate
    bool correct = true;
    for (int i = 0; i < M && correct; ++i) 
    {
        for (int j = 0; j < N && correct; ++j) 
        {
            float expected = 0;
            for (int k = 0; k < K; ++k)
            {
                expected += h_A[i * K + k] * h_B[k * N + j];
            }
            if (fabs(h_C[i * N + j] - expected) > 1e-5) 
            {
                correct = false;
                std::cout << "Mismatch at (" << i << ", " << j << "): "
                          << "GPU result = " << h_C[i * N + j]
                          << ", Expected = " << expected << "\n";
            }
        }
    }

    if (correct) 
    {
        std::cout << "Matrix multiplication successful!\n";
    } 
    else
    {
        std::cout << "Matrix multiplication failed!\n";
    }

    // free all memory
    cudaFree(d_A);
    cudaFree(d_B);
    cudaFree(d_C);

    free(h_A);
    free(h_B);
    free(h_C);

    return 0;
}
