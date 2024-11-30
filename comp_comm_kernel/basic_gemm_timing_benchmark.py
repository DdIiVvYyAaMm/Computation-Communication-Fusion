import pycuda.driver as cuda
import pycuda.autoinit
import numpy as np
import timeit

def time_kernel(kernel, A_device, B_device, C_device, M, N, K, block_size, grid_size)
    kernel(A_device, B_device, C_device, np.int32(M), np.int32(N), np.int32(K),
           block=block_size, grid=grid_size)

# Load the compiled CUBIN file
# module = cuda.module_from_file("basic_gemm.cubin")
module = cuda.module_from_file("basic_gemm_from_ll.cubin")

# Get the kernel function
kernel = module.get_function("_Z15matrixMulKernelPKfS0_Pfiii")

# Matrix dimensions
M, N, K = 512, 512, 512  # Rows and columns for matrices
TILE_SIZE = 16  # Block size (threads per block)

# Compute grid dimensions
block_size = (TILE_SIZE, TILE_SIZE, 1)
grid_size = ((N + TILE_SIZE - 1) // TILE_SIZE, (M + TILE_SIZE - 1) // TILE_SIZE, 1)

# Host-side matrix initialization
A_host = np.random.rand(M, K).astype(np.float32)
B_host = np.random.rand(K, N).astype(np.float32)
C_host = np.zeros((M, N), dtype=np.float32)

# Allocate device memory
A_device = cuda.mem_alloc(A_host.nbytes)
B_device = cuda.mem_alloc(B_host.nbytes)
C_device = cuda.mem_alloc(C_host.nbytes)

# Copy matrices to the device
cuda.memcpy_htod(A_device, A_host)
cuda.memcpy_htod(B_device, B_host)

# Launch the kernel
execution_time = timeit.timeit(lambda: time_kernel(kernel, A_device, B_device, C_device, M, N, K, block_size, grid_size), number=1000)
average_time_microseconds = (execution_time / 1000) * 1_000_000

print(f"Average execution time: {average_time_microseconds:.5f} microseconds")

# Copy the result matrix back to the host
cuda.memcpy_dtoh(C_host, C_device)

# Validate the result
C_reference = np.dot(A_host, B_host)  # CPU computation for validation
if np.allclose(C_host, C_reference, atol=1e-5):
    print("Matrix multiplication successful!")
else:
    print("Matrix multiplication failed!")
    mismatches = np.where(~np.isclose(C_host, C_reference, atol=1e-5))
    for idx in zip(*mismatches):
        print(f"Mismatch at {idx}: GPU={C_host[idx]}, CPU={C_reference[idx]}")

# Free device memory
A_device.free()
B_device.free()
C_device.free()
