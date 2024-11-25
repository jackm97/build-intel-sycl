set(CMAKE_SYSTEM_NAME Linux)

set(CMAKE_C_COMPILER "$ENV{CC}")
set(CMAKE_CXX_COMPILER "$ENV{CXX}")

# location of the target environment
set(CMAKE_FIND_ROOT_PATH "$ENV{CONDA_PREFIX}" "$ENV{CONDA_BUILD_SYSROOT}"
                         "$ENV{SYCL_PROJECT_ROOT}/llvm/build/NATIVE")

set(CMAKE_SYSROOT "$ENV{CONDA_BUILD_SYSROOT}")

if(NOT "$ENV{CUDA_ROOT}" STREQUAL "")
  set(CUDA_TOOLKIT_ROOT_DIR "$ENV{CUDA_ROOT}")
endif()

if(NOT "$ENV{VCPKG_ROOT}" STREQUAL "")
  set(VCPKG_CXX_FLAGS "$ENV{CXXFLAGS}")
  set(VCPKG_C_FLAGS "$ENV{CFLAGS}")
  set(VCPKG_LINKER_FLAGS "$ENV{LDFLAGS}")
  include("$ENV{VCPKG_ROOT}/scripts/buildsystems/vcpkg.cmake
    ")
endif()
