from CoreMatrixMult import CoreMatrixMult
import time

cuda_binaries = ["../original_gemm.cubin"]
kernel_names = ["_Z15matrixMulKernelPKfS0_Pfiii"]

sizes = list(range(512, 2049, 254))

# repititions = 100000
repititions = 10


timing = [[] for _ in range(3)]

for i in range(len(cuda_binaries)):
    print("running l2 cache tests for " + cuda_binaries[i])

    for size in sizes:
        total_time = 0.0
        print(size)
        for j in range(repititions):

            multiplier = CoreMatrixMult(cuda_binaries[i], kernel_names[i], size, size, size, 16)
    
            multiplier.init_matrices_with_random_nums()
            multiplier.allocate_device_memory()
            multiplier.copy_matrices_to_device()
            
            start = time.perf_counter()
            multiplier.launch_kernel()
            end = time.perf_counter()

            total_time += (end - start)
        
        avg_time = total_time / float(repititions)
        timing[i].append(avg_time)