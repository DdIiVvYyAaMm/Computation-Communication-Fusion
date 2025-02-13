import pycuda.driver as cuda
import pycuda.autoinit
import numpy as np

# Load the compiled CUBIN file
module = cuda.module_from_file("manually_optimized_gemm.cubin")

# Get the kernel function
kernel = module.get_function("_Z20tiledMatrixMulKernelPKfS0_Pfiii")

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
kernel(A_device, B_device, C_device, np.int32(M), np.int32(N), np.int32(K),
       block=block_size, grid=grid_size)

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