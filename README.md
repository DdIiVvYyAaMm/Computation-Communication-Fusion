# Init
All instructions assume that you are starting at the root directory
## Build loop tiling pass
`cd LoopTilingPass`   
`mkdir build && cd build`  
`cmake ..`  
`make`

## Build cubins
`cd comp_comm_kernel`  
`./buil.sh`  

# Test
Go back to root directory  

`cd comp_comm_kernel`  
`cd benchmarks`   
`python test_correctness.py`    
`python test_performance.py`  
