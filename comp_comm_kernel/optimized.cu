#include <iostream>
#include <cuda_runtime.h>

#define TILE_SIZE 16

// Optimized CUDA kernel for tiled GEMM
__global__ void tiledMatrixMulKernel(const float* A, const float* B, float* C, int M, int N, int K) 
{
    // Shared memory for tiles of A and B
    __shared__ float tileA[TILE_SIZE][TILE_SIZE];
    __shared__ float tileB[TILE_SIZE][TILE_SIZE];

    // Calculate row and column indices for the current thread
    int row = blockIdx.y * TILE_SIZE + threadIdx.y;
    int col = blockIdx.x * TILE_SIZE + threadIdx.x;

    float value = 0.0f;

    // Loop over all tiles of A and B required to compute C[row][col]
    for (int t = 0; t < (K + TILE_SIZE - 1) / TILE_SIZE; ++t) 
    {
        // Load elements into shared memory (with boundary check)
        if (row < M && t * TILE_SIZE + threadIdx.x < K)
        {
            tileA[threadIdx.y][threadIdx.x] = A[row * K + t * TILE_SIZE + threadIdx.x];
        }
        else
        {
            tileA[threadIdx.y][threadIdx.x] = 0.0f;
        }

        if (col < N && t * TILE_SIZE + threadIdx.y < K)
        {
            tileB[threadIdx.y][threadIdx.x] = B[(t * TILE_SIZE + threadIdx.y) * N + col];
        }
        else
        {
            tileB[threadIdx.y][threadIdx.x] = 0.0f;
        }

        __syncthreads(); // Synchronize threads to ensure all tiles are loaded

        // Compute partial product for this tile
        for (int i = 0; i < TILE_SIZE; ++i) 
        {
            value += tileA[threadIdx.y][i] * tileB[i][threadIdx.x];
        }

        __syncthreads(); // Synchronize before loading the next tile
    }

    // Write the result to global memory (with boundary check)
    if (row < M && col < N) 
    {
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
    tiledMatrixMulKernel<<<gridSize, blockSize>>>(d_A, d_B, d_C, M, N, K);

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
