import pycuda.driver as cuda
import pycuda.autoinit
import numpy as np

class CoreMatrixMult:

    def __init__(self, cuda_binary, kernel_name, M, N, K, tile_size):
        # load cuda binary
        self.module = module = cuda.module_from_file(cuda_binary)

        # load cuda kernel
        self.kernel = module.get_function(kernel_name)

        # store matrix dimensions and tile size
        self.tile_size = tile_size
        self.M = M
        self.N = N
        self.K = K

        # compute block and grid size to launch kernel with
        self.block_size = (self.tile_size, self.tile_size, 1)
        self.grid_size  = ((N + self.tile_size - 1) // self.tile_size, (M + self.tile_size - 1) // self.tile_size, 1)

    def __del__(self):
        self.free_device_memory()

    def init_matrices_with_random_nums(self):
        self.A_host = np.random.rand(self.M, self.K).astype(np.float32)
        self.B_host = np.random.rand(self.K, self.N).astype(np.float32)
        self.C_host = np.zeros((self.M, self.N), dtype=np.float32)

    def allocate_device_memory(self):
        self.A_device = cuda.mem_alloc(self.A_host.nbytes)
        self.B_device = cuda.mem_alloc(self.B_host.nbytes)
        self.C_device = cuda.mem_alloc(self.C_host.nbytes)

    def copy_matrices_to_device(self):
        cuda.memcpy_htod(self.A_device, self.A_host)
        cuda.memcpy_htod(self.B_device, self.B_host)

    def launch_kernel(self):
        self.kernel(self.A_device, self.B_device, self.C_device,
                    np.int32(self.M), np.int32(self.N), np.int32(self.K),
                    block=self.block_size, grid=self.grid_size)

    def copy_matrix_to_host(self):
        cuda.memcpy_dtoh(self.C_host, self.C_device)
        return self.C_host

    def validate_computation(self):
        successful = False
        C_reference = np.dot(self.A_host, self.B_host)
        if np.allclose(self.C_host, C_reference, atol=1e-5):
            print("Matrix multiplication successful!")
            successful = True
        else:
            print("Matrix multiplication failed!")
            mismatches = np.where(~np.isclose(self.C_host, C_reference, atol=1e-5))
            for idx in zip(*mismatches):
                print(f"Mismatch at {idx}: GPU={self.C_host[idx]}, CPU={C_reference[idx]}")
        return successful

    def free_device_memory(self):
        self.A_device.free()
        self.B_device.free()
        self.C_device.free()


