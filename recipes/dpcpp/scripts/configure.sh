#!/bin/bash

set -e

mkdir -p "$PIXI_PROJECT_ROOT/llvm/build"

find "$PIXI_PROJECT_ROOT/llvm/build" -name CMakeCache.txt -exec rm {} ';'

cp "$PIXI_PROJECT_ROOT"/recipes/dpcpp/SYCLLibdevice.cmake "$PIXI_PROJECT_ROOT"/llvm/libdevice/cmake/modules
python "$PIXI_PROJECT_ROOT"/llvm/buildbot/configure.py \
  --cuda --native_cpu \
  --llvm-external-projects="clang-tools-extra,compiler-rt" \
  --cmake-opt="-DCMAKE_C_COMPILER=$C_COMPILER" \
  --cmake-opt="-DCMAKE_C_FLAGS=$CFLAGS" \
  --cmake-opt="-DCMAKE_CXX_COMPILER=$CXX_COMPILER" \
  --cmake-opt="-DCMAKE_CXX_FLAGS=$CXXFLAGS" \
  --cmake-opt="-DCMAKE_EXE_LINKER_FLAGS=$LDFLAGS" \
  --cmake-opt="-DCMAKE_SHARED_LINKER_FLAGS=$LDFLAGS" \
  --cmake-opt="-DCMAKE_C_COMPILER_LAUNCHER=ccache" \
  --cmake-opt="-DCMAKE_CXX_COMPILER_LAUNCHER=ccache" \
  --cmake-opt="-DCMAKE_SYSROOT=$CONDA_BUILD_SYSROOT" \
  --cmake-opt="-DCMAKE_INSTALL_PREFIX=$DPCPP_ROOT" \
  --cmake-opt="-DLLVM_INSTALL_UTILS=ON" \
  --cmake-opt="-DNATIVECPU_USE_OCK=ON" \
  --cmake-opt="-DSYCL_PI_TESTS=OFF" \
  --cmake-opt="-DLLVM_EXPERIMENTAL_TARGETS_TO_BUILD=SPIRV" \
  --cmake-opt="-DCMAKE_BUILD_TYPE=Release"
