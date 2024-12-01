# cmake_minimum_required(VERSION 3.20)
# find_package(LLVM REQUIRED CONFIG)
# list(APPEND CMAKE_MODULE_PATH "${LLVM_CMAKE_DIR}")
# include(AddLLVM)

# separate_arguments(LLVM_DEFINITIONS_LIST NATIVE_COMMAND ${LLVM_DEFINITIONS})
# add_definitions(${LLVM_DEFINITIONS_LIST})
# include_directories(${LLVM_INCLUDE_DIRS})

# add_subdirectory(LoopTilingPass)

cmake_minimum_required(VERSION 3.20)
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
find_package(LLVM REQUIRED CONFIG)
list(APPEND CMAKE_MODULE_PATH "${LLVM_CMAKE_DIR}")
include(AddLLVM)

separate_arguments(LLVM_DEFINITIONS_LIST NATIVE_COMMAND ${LLVM_DEFINITIONS})
add_definitions(${LLVM_DEFINITIONS_LIST})
include_directories(${LLVM_INCLUDE_DIRS})

add_subdirectory(LoopTilingPass)
target_link_libraries(LoopTilingPass "$<$<PLATFORM_ID:Darwin>:-undefined dynamic_lookup>")