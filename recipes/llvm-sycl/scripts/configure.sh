#!/bin/bash

set -e

mkdir -p "$PIXI_PROJECT_ROOT/llvm/build"

source "$PIXI_PROJECT_ROOT/activation/linux.sh"
source "$PIXI_PROJECT_ROOT/activation/gcc.sh"

python "$PIXI_PROJECT_ROOT"/llvm/buildbot/configure.py \
  --cuda --native_cpu \
  --llvm-external-projects="clang-tools-extra,compiler-rt" \
  --cmake-opt="-DCMAKE_C_COMPILER=$C_COMPILER" \
  --cmake-opt="-DCMAKE_C_FLAGS=$CFLAGS" \
  --cmake-opt="-DCMAKE_CXX_COMPILER=$CXX_COMPILER" \
  --cmake-opt="-DCMAKE_CXX_FLAGS=$CXXFLAGS" \
  --cmake-opt="-DCMAKE_C_COMPILER_LAUNCHER=ccache" \
  --cmake-opt="-DCMAKE_CXX_COMPILER_LAUNCHER=ccache" \
  --cmake-opt="-DCMAKE_TOOLCHAIN_FILE=$CMAKE_TOOLCHAIN_FILE" \
  --cmake-opt="-DCMAKE_INSTALL_PREFIX=$PREFIX" \
  --cmake-opt="-DLLVM_INSTALL_UTILS=ON" \
  --cmake-opt="-DNATIVECPU_USE_OCK=OFF" \
  --cmake-opt="-DSYCL_PI_TESTS=OFF" \
  --cmake-opt="-DLLVM_EXPERIMENTAL_TARGETS_TO_BUILD=SPIRV"
