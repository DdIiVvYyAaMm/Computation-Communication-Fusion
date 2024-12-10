# Init
We have only tested building our solution on ubuntu 22.04.

Our project depends on building the polygeist project and installing the cuda library and the appropiate driver for your GPU. We have also included our modifications to Triton, however, that is not required to build to use our solution. Prior to building either of them from source. Please make sure that your system has at least 40gb of memory between RAM and swap space. If it does not, then you can add extra swap space using the following commands:

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

## hello_world
This folder contains a cpp file that print hello world by calling a function. It was used to validate that a cpp file could be manually compiled to an executable whilst generating every intermediate representation. This folder is included but not part of our solution.

## Build cubins
`cd comp_comm_kernel`  
`./build.sh`  

# Test
Go back to root directory  

`cd comp_comm_kernel`  
`cd benchmarks`   

Start with this test to validate that the refactored core mat mult class is good    
`python test_simple.py`  

Actuall tests for our solution    
`python test_correctness.py`    
`python test_performance.py`  
