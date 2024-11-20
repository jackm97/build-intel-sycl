#!/bin/bash

set -e

mkdir -p "$SYCL_PROJECT_ROOT/llvm/build"

source "$SYCL_PROJECT_ROOT/activation/linux.sh"
source "$SYCL_PROJECT_ROOT/activation/gcc.sh"

if [ -d "$SYCL_PROJECT_ROOT/llvm/build" ]; then
  find "$SYCL_PROJECT_ROOT/llvm/build" -name "CMakeCache.txt" -exec rm {} ";"
fi

# mkdir -p "$SYCL_PROJECT_ROOT/llvm/build/bin"
# cxxflags="--sysroot=$CONDA_BUILD_SYSROOT --gcc-toolchain=$CONDA_PREFIX --target=$HOST $CXXFLAGS"
# cflags="--sysroot=$CONDA_BUILD_SYSROOT --gcc-toolchain=$CONDA_PREFIX --target=$HOST $CFLAGS"
# echo "$cxxflags" >"$SYCL_PROJECT_ROOT/llvm/build/bin/clang++.cfg"
# echo "$LDFLAGS" >>"$SYCL_PROJECT_ROOT/llvm/build/bin/clang++.cfg"
# echo "$cflags" >"$SYCL_PROJECT_ROOT/llvm/build/bin/clang.cfg"
# echo "$LDFLAGS" >>"$SYCL_PROJECT_ROOT/llvm/build/bin/clang.cfg"

python "$SYCL_PROJECT_ROOT"/llvm/buildbot/configure.py \
  --cuda --native_cpu \
  --llvm-external-projects="clang-tools-extra" \
  --cmake-opt="-DCMAKE_C_COMPILER=$C_COMPILER" \
  --cmake-opt="-DCMAKE_C_FLAGS=$CFLAGS" \
  --cmake-opt="-DCMAKE_CXX_COMPILER=$CXX_COMPILER" \
  --cmake-opt="-DCMAKE_CXX_FLAGS=$CXXFLAGS" \
  --cmake-opt="-DCMAKE_C_COMPILER_LAUNCHER=ccache" \
  --cmake-opt="-DCMAKE_CXX_COMPILER_LAUNCHER=ccache" \
  --cmake-opt="-DCMAKE_EXE_LINKER_FLAGS=$LDFLAGS" \
  --cmake-opt="-DCMAKE_SHARED_LINKER_FLAGS=$LDFLAGS" \
  --cmake-opt="-DCMAKE_TOOLCHAIN_FILE=$CMAKE_TOOLCHAIN_FILE" \
  --cmake-opt="-DCMAKE_INSTALL_PREFIX=$INSTALL_PREFIX" \
  --cmake-opt="-DNATIVECPU_USE_OCK=ON" \
  --cmake-opt="-DSYCL_PI_TESTS=OFF" \
  --cmake-opt="-DLLVM_EXPERIMENTAL_TARGETS_TO_BUILD=SPIRV" \
  --cmake-opt="-DCMAKE_SYSROOT=$CMAKE_SYSROOT" \
  --cmake-opt="-DCMAKE_SYSTEM_NAME=Linux" \
  --cmake-opt="-DLLVM_HOST_TRIPLE=$HOST" \
  --cmake-opt="-DCUDA_TOOLKIT_ROOT_DIR=$CUDA_ROOT" \
  --cmake-opt="-DLLVM_USE_LINKER=lld"
