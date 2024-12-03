from CoreMatrixMult import CoreMatrixMult

def run_test(cuda_binary, kernel_name, M, N, K, tile_size):
    multiplier = CoreMatrixMult(cuda_binary, kernel_name, M, N, K, tile_size)
    
    multiplier.init_matrices_with_random_nums()
    multiplier.allocate_device_memory()
    multiplier.copy_matrices_to_device()

    multiplier.launch_kernel()
    
    multiplier.copy_matrix_to_host()

    ret = multiplier.validate_computation()

    if (not ret):
        print(cuda_binary + " failed correctness check for matrix sizes=" + str(M) + ", " + str(N) + ", " + str(K))


# validate manual build process and our optimization pass
cuda_binaries = ["../original_gemm.cubin", "../optimized_gemm.cubin", "../manually_optimized_gemm.cubin"]
kernel_names = ["_Z15matrixMulKernelPKfS0_Pfiii", "_Z15matrixMulKernelPKfS0_Pfiii", "_Z20tiledMatrixMulKernelPKfS0_Pfiii"]

sizes = list(range(512, 2049, 254))

for i in range(len(cuda_binaries)):
    print("running correctness tests for " + cuda_binaries[i])

    for size in sizes:
        run_test(cuda_binaries[i], kernel_names[i], size, size, size, 16)
