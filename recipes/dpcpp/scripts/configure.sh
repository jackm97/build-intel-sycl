#!/bin/bash

set -e

extra_opts=""
for var in $CMAKE_ARGS; do
  if [[ ! $var = *"CMAKE_BUILD_TYPE"* ]]; then
    extra_opts="--cmake-opt=$var $extra_opts"
  fi
done
# echo "$extra_opts"

mkdir -p "$PIXI_PROJECT_ROOT/llvm/build"
find "$PIXI_PROJECT_ROOT/llvm/build" -name CMakeCache.txt -exec rm {} ';'
cp "$PIXI_PROJECT_ROOT"/recipes/dpcpp/SYCLLibdevice.cmake "$PIXI_PROJECT_ROOT"/llvm/libdevice/cmake/modules

python "$DPCPP_HOME"/llvm/buildbot/configure.py \
  --cuda --native_cpu \
  --llvm-external-projects="clang-tools-extra,compiler-rt" \
  --cmake-opt="-DCMAKE_C_COMPILER=$C_COMPILER" \
  --cmake-opt="-DCMAKE_C_FLAGS=$CFLAGS" \
  --cmake-opt="-DCMAKE_CXX_COMPILER=$CXX_COMPILER" \
  --cmake-opt="-DCMAKE_CXX_FLAGS=$CXXFLAGS" \
  --cmake-opt="-DCMAKE_C_COMPILER_LAUNCHER=ccache" \
  --cmake-opt="-DCMAKE_CXX_COMPILER_LAUNCHER=ccache" \
  --cmake-opt="-DCMAKE_SYSROOT=$CONDA_BUILD_SYSROOT" \
  --cmake-opt="-DCMAKE_INSTALL_PREFIX=$DPCPP_ROOT" \
  --cmake-opt="-DLLVM_INSTALL_UTILS=ON" \
  --cmake-opt="-DNATIVECPU_USE_OCK=ON" \
  --cmake-opt="-DSYCL_PI_TESTS=OFF" \
  --cmake-opt="-DLLVM_EXPERIMENTAL_TARGETS_TO_BUILD=SPIRV" \
  "$extra_opts"
