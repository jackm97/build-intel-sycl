#!/bin/bash

set -e
set -x

extra_opts=""
for var in $CMAKE_ARGS; do
  if [[ ! $var == *"CMAKE_BUILD_TYPE"* ]]; then
    extra_opts="--cmake-opt='$var' $extra_opts"
  fi
done

python "$DPCPP_HOME"/llvm/buildbot/configure.py \
  --cuda --native_cpu \
  --llvm-external-projects="clang-tools-extra,compiler-rt" \
  --cmake-opt="-DCMAKE_CXX_COMPILER=$CXX" \
  --cmake-opt="-DCMAKE_C_COMPILER=$CC" \
  --cmake-opt="-DCMAKE_PREFIX_PATH=${CMAKE_PREFIX_PATH//:/;}" \
  --cmake-opt="-DCMAKE_C_COMPILER_LAUNCHER=ccache" \
  --cmake-opt="-DCMAKE_CXX_COMPILER_LAUNCHER=ccache" \
  --cmake-opt="-DCMAKE_INSTALL_PREFIX=$SYCL_INSTALL_PREFIX" \
  --cmake-opt="-DNATIVECPU_USE_OCK=Off" \
  --cmake-opt="-DSYCL_PI_TESTS=OFF" \
  --cmake-opt="-DLLVM_EXPERIMENTAL_TARGETS_TO_BUILD=SPIRV" \
  --cmake-opt="-DLLVM_INSTALL_UTILS=ON" "$extra_opts"
