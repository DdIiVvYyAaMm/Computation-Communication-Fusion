# Abstract of the Report
AI/ML’s exponential growth requires efficient hard- ware utilization to sustain performance and control costs. General Matrix-Matrix Multiplication (GEMM), a core operation in AI computations, often becomes a bottleneck. This work optimizes GEMM via a custom LLVM-based loop tiling optimization pass, addressing challenges in compiler integration and kernel-level tun- ing.
This paper goes through how our solution evolved from implementing an optimization pass at the MLIR level within a ML compiler to creating a Loop Tiling optimization pass at the LLVM IR level. Additionally, we highlight challenges and limitations of our evolv- ing approach. Testing on NVIDIA RTX 4060 GPUs showed significant gains in L1 cache utilization, memory throughput, and warp eligibility, outperforming base- line and manually optimized solutions across matrix sizes. Future work includes extending these techniques to sparse GEMM, masked attention, and TPU optimiza-tion.

Full Report: [PDF Link](https://drive.google.com/file/d/1SqQdVl234ZFeNeB4C80AN_WB0VJdM6JO/view?usp=sharing)

# Clone
```sh
git clone --recursive https://github.com/Harsh-Sinha/computation-communication-kernel-fusion.git
cd computation-communication-kernel-fusion
```
# Init
We have only tested building our solution on ubuntu 22.04.

Our project depends on building the polygeist project and installing the cuda library and the appropiate driver for your GPU. We have also included our modifications to Triton, however, that is not required to build to use our solution. Prior to building either of them from source, please make sure that your system has at least 40gb of memory between RAM and swap space. If it does not, then you can add extra swap space using the following commands:

```sh
sudo fallocate -l 40G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
```
Make sure you have performed the standard ubuntu init sequence:
```sh
sudo apt update
sudo apt upgrade
sudo apt install -y build-essential
```
Additionally, other dependencies
```sh
sudo apt install -y cmake
sudo apt install -y python3
sudo apt install -y torch
```

## Installing CUDA Library
We have to first properly install all the correct versions of dependencies.
### Update Kernel Version
Install the kernel  
```sh
sudo apt update
sudo apt install -y linux-image-6.5.0-27-generic linux-headers-6.5.0-27-generic
```
Verify that the kernel has been downloaded  
```sh
dpkg --list | grep linux-image
```
Reboot your system
```sh
sudo reboot
```
Once your system has finished rebooting, verify that the kernel was installed properly:
```sh
uname -r
```
### Install GCC 12.3
Install and set your default gcc to 12.3
```sh
sudo apt install -y gcc-12 g++-12
sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-12 60 --slave /usr/bin/g++ g++ /usr/bin/g++-12
```
Verify that it is correctly setup
```sh
gcc --version
```
### Install glibc 2.35
install and verify
```sh
sudo apt upgrade libc6
ldd --version
```
### Install CUDA Driver
Follow steps 1-5 on this article: https://www.cherryservers.com/blog/install-cuda-ubuntu
### Install CUDA
```sh
wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2204/x86_64/cuda-keyring_1.1-1_all.deb
sudo dpkg -i cuda-keyring_1.1-1_all.deb
sudo apt-get update
sudo apt-get -y install cuda-toolkit-12-6
sudo reboot
```
Place the following at the bottom of ‘~/.bashrc’
```sh
export PATH=/usr/local/cuda-12.6/bin${PATH:+:${PATH}}
export LD_LIBRARY_PATH=/usr/local/cuda-12.6/lib64${LD_LIBRARY_PATH:+:${LD_LIBRARY_PATH}}
```
Reload bashrc
```sh
source ~/.bashrc
```
Verify install
```sh
nvcc -V
```

## Install Triton
Navigate to the triton folder and follow build instructions in README located in the folder.

# Dependencies for our solution
Please build in this order to make sure no dependencies are missing.
## Build loop tiling pass
This will build the loop tiling shared object file that we link to in our compilation steps.
```sh
cd LoopTilingPass   
mkdir build
cd build  
cmake ..  
make
```
## Install python dependencies
```sh
pip install pycuda numpy argparse
```

## Install and Build Polygeist
As mentioned on top, make sure you have free memory (40 GB) otherwise increase using swap space. You are required to build this for our solution to work.

Make sure you have ninja, otherwise install it.
```sh
sudo apt install -y ninja-build
```
Install LLD
```sh
sudo apt install -y lld
```
Polygeist is included as a submodule in our git repo. Navigate to the directory, and follow our build instructions below to get it working for our tool.
```sh
cd polygeist
```
Make a build directory.
```sh
mkdir build
cd build
```
Run the CMake.

```sh
cmake -G Ninja ../llvm-project/llvm \
  -DLLVM_ENABLE_PROJECTS="clang;mlir" \
  -DCMAKE_C_COMPILER=$(which clang) \
  -DCMAKE_CXX_COMPILER=$(which clang++) \
  -DLLVM_EXTERNAL_PROJECTS="polygeist" \
  -DLLVM_EXTERNAL_POLYGEIST_SOURCE_DIR=.. \
  -DLLVM_TARGETS_TO_BUILD="host;X86;NVPTX" \
  -DLLVM_ENABLE_ASSERTIONS=ON \
  -DLLVM_USE_LINKER=lld \
  -DPOLYGEIST_USE_LINKER=lld \
  -DPOLYGEIST_ENABLE_CUDA=1 \
  -DCMAKE_BUILD_TYPE=Release
```
If there are any errors at the CMake step, then clear the build.
Go outside the build directory and delete it.
```sh
cd ..
rm -rf build
```
Add this line in the CMakeLists.txt at the root of the polygeist directory
```sh
set(CLANG_TOOL "/usr/bin/clang")
```
Now let's again  make build and cd into it.
```sh
mkdir build
cd build
```
Run the ninja command
```sh
ninja
```
To check the builds
```sh
ninja check-polygeist-opt && ninja check-cgeist
```
If the check tests are all successful, then your Polygeist build is successful. If you are running on a pc with no GPU you will fail all the cuda tests.  

## DO NOT SKIP
Once you have succesfully built you will have to add the following to your environment path.  
`path/to/computation-communication-kernel-fusion/polygeist/build/bin`  

This path should be under your polygeist build folder you created and should be a valid path. It should be the full path and not a relative path. You have to add the following to ~/.bashrc at the bottom:  
```sh
# this should be an actual full path to the binaries installed during the polygeist build
export PATH=/path/to/computation-communication-kernel-fusion/polygeist/build/bin${PATH:+:${PATH}}
```
Reload bashrc
```sh
source ~/.bashrc
```


# Our subfolders
<b>IMPORTANT:</b> If the for any reason the run or benchmark python files do not work than it is most likely because we are referencing the incorrect kernel name to launch the cubin. This occurs because CPP compilation will mangle the kernel name while it compiling. You will have to do the following:  
  
Look at the associated .ptx file and locate the kernel's mangled name  

Locate the string that represents what kernel name we are trying to use (it will either be in the module.get_function or in a array at the top of the file)  

Replace the string with the new mangled kernel name

## basic_cuda
This folder contains our hello world cuda file where we initialize a kernel and launch multiple threads and print the thread id from each thread. This was used to invalidate our approach of cgeist/polygeist to drop a cuda kernel to MLIR representation. We then shifted to using this as a scratchpad to figure out how to convert a cuda kernel into a cuda binary that we could use a python file to launch.
### Building
You can generate a cuda binary by running the following
```sh
./build.sh
```

### Running
Call `run.py` 

## comp_comm_kernel
This folder contains two cuda files: gemm.cu and optimized.cu. The first is a simple gemm kernel implementation that we use as a baseline. The optimized.cu is a manually optimized tiled base matrix multiplication. Additionally, this folder has a build.sh and clean.sh bash scripts that are self explanatory. The build script will generate 3 cuda binaries:  
- original.cu: this is a manually compiled cuda binary of gemm.cu without our llvm optimization pass applied to it
- optimized.cu: this is a manually compiled cuda binary of gemm.cu with our Loop Tiling LLVM pass applied to it
- manually_optimized.cu: this is a manually compiled cuda binary of optimized.cu without our llvm pass applied to it

You can build the cuda binaries by calling `./build.sh`  
  
Once you have built the cuda binaries you can run them using the associated *_gemm_run.py. This file will generate a random matrix of size 512x512, run the kernel on your gpu, and validate that the result computed is valid.  
### Benchmarks
This folder contains all of our python scripts and bash files we used to test and benchmark our solution. The following subsections talk about each test type and what they do
#### test_simple
This tests that our CoreMatMult class works as expected on the original solution cuda binary. This class is the foundation upon which the rest of the benchmarks are ran on.
```sh
# Usage
python test_simple.py
```
#### test_correctness
This test will check each of the solutions (original, optimized, manually optimized) against a sequence of random square matrices that have sizes starting with 512x512 and go up to 2036x2036 in increments of 254. Each solution is tested against their own random sequence of matrices. For each of computed results it will perform a check to verify that the correct output was generated. This was used to verify that our Loop Tiling Optimization pass did not produce incorrect results and that our manual compilation process was not flawed. This was the starting point before we ran any of the other tests (we won't explicitly check for correctness in other tests).
```sh
# Usage
python test_correctness.py
```
#### test_performance
This test will time each solution (original, optimized, manually optimized) against every matrix size starting with 512x512 and go up to 2036x2036 in increments of 254. For each size, on each solution, it will run 10,000 iterations and average the total execution time. Furthermore, on each iteration it will randomize the matrices to ensure we are not receiving any cached results.
```sh
# Usage
python test_performance.py
```
#### test_l2_cache_hit_SOLUTION.sh + SOLUTION_cache_profiler.py
These tests make use of Nvidia Nsight Compute to profile the GPU as the kernel is running. Despite the name being related to caches, these scripts will generate profile data for all pre-defined sets (defined here: https://docs.nvidia.com/nsight-compute/ProfilingGuide/index.html). The bash file is used to make the correct call to Nsight Compute to start profiling all this data. The *_cache_profiler.py is used to run kernels with different matrix sizes multiple times. This allows us to understand how the kernel is performing accross varying workloads.
```sh
# Usage
./test_l2_cache_hit_SOLUTION.sh
# e.g. ./test_l2_cache_hit_original.sh
```
<b>Note: Nvidia Nsight Compute (ncu) should be installed if you have properly installed CUDA from previous instructions.
### results (comp_comm_kernel/benchmarks/results)
This folder contains all the results for the benchmarks described above and helper bash scripts for parsing (no output file for the correctness output). Following sections describe the output files.
#### timing_metrics
This file contains the timing metrics. The 'sizes' array represents all the matrix sizes that each of the solutions (original, optimized, manually optimized) were tested against. The 'times' array is a multidimensional array where the first subarray corresponds to timing metrics for the original solution, the second subarray corresponds to the timing metrics for the optimized solution, and the third subarray corresponds to the timing metrics for the manually optimized solution. Each entry is associated to the averaged timing result for the corresponding matrix size from the 'sizes' array. For example times[0][3] is the timing result for the original solution for matrix size sizes[3].
#### SOLUTION_metrics.txt
These files contain the profile data generated by Nvidia Nsight Compute for each of the solutions (original, optimized, manually optimized). Nvidia Nsight Compute can only provide profile data for one kernel invocation at a time, so there are multiple sets of profile data in the files (1 set for each kernel invocation we made in our SOLUTION_cache_profiler.py). 
#### parse_metric_across_all_files
This bash script allows the user to parse the Nvidia Nsight Compute output files for each solution and average the results across all the kernel invocations for that solution and output it. For example, the nsight compute output files have the following table in them (note there are many 'Sections' for each kernel invocation):
```sh
Section: Compute Workload Analysis
-------------------- ----------- ------------
Metric Name          Metric Unit Metric Value
-------------------- ----------- ------------
Executed Ipc Active   inst/cycle         2.01
Executed Ipc Elapsed  inst/cycle         1.99
Issue Slots Busy               %        50.30
Issued Ipc Active     inst/cycle         2.01
SM Busy                        %        57.50
-------------------- ----------- ------------
```
You can select any such metric name that is a part of any 'Section' in the file. The above is the 'Compute Workload Analysis' Section and available metrics are as follows:
- Executed Ipc Active
- Executed Ipc Elapsed
- Issue Slots Busy
- SM Busy

Here is the usage for the bash script:
```sh
./parse_metric_across_all_files.sh "Executed Ipc Active"
# or more generally
./parse_metric_across_all_files.sh "METRIC_NAME"
```
<b>NOTE: The metric name is case sensitive as we use grep to parse it.  
Sample output:
```sh
Executed Ipc Active average for original
2.04443
Executed Ipc Active average for optimized
2.07014
Executed Ipc Active average for manually optimized
2.48729
```


## hello_world
This folder contains a cpp file that print hello world by calling a function. It was used to validate that a cpp file could be manually compiled to an executable whilst generating every intermediate representation. This folder is included but not part of our solution.
