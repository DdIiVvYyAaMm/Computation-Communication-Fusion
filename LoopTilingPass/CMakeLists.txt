cmake_minimum_required(VERSION 3.5)

project(LoopTilingPass)

find_package(LLVM REQUIRED)

add_definitions(${LLVM_DEFINITIONS})
include_directories(${LLVM_INCLUDE_DIRS})
link_directories(${LLVM_LIBRARY_DIRS})

include(AddLLVM)
add_llvm_pass_plugin(${PROJECT_NAME} looptilingpass.cpp loop_tiler_final.cpp)