from CoreMatrixMult import CoreMatrixMult

cuda_binary = "../original_gemm.cubin"
kernel_name = "_Z15matrixMulKernelPKfS0_Pfiii"
size = 512
multiplier = CoreMatrixMult(cuda_binary, kernel_name, size, size, size, 16)
    
multiplier.init_matrices_with_random_nums()
multiplier.allocate_device_memory()
multiplier.copy_matrices_to_device()

multiplier.launch_kernel()

multiplier.copy_matrix_to_host()

multiplier.validate_computation()