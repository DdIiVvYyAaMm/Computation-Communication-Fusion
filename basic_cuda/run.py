import pycuda.driver as cuda
import pycuda.autoinit

# Load the CUBIN
module = cuda.module_from_file("new_main.cubin")

# Get the kernel function
kernel = module.get_function("_Z16helloWorldKernelv")

# Launch the kernel
kernel(block=(256, 1, 1), grid=(1, 10))