#!/bin/bash

set -e

export DPCPP_LIB_DIRS="$DPCPP_ROOT/lib:$DPCPP_ROOT:/lib64:$ONEMKL_ROOT/lib:$ONEMKL_ROOT/lib64"

link_path_flags=""
for path in ${DPCPP_LIB_DIRS//:/ }; do
  link_path_flags="-L $path $link_path_flags"
done
export EXTRA_LDFLAGS="$link_path_flags $EXTRA_LDFLAGS"
export LDFLAGS="$link_path_flags $LDFLAGS"

export CMAKE_PREFIX_PATH="$ONEMKL_ROOT:$DPCPP_ROOT:$CMAKE_PREFIX_PATH"

CXX_COMPILER=$(which clang++ || echo "")
export CXX=$CXX_COMPILER
export CXX_COMPILER=$CXX
C_COMPILER=$(which clang || echo "")
export C_COMPILER=$C_COMPILER
export CC=$C_COMPILER

export CXXFLAGS="--cuda-path=$CONDA_PREFIX --gcc-toolchain=$GCC_TOOLCHAIN --gcc-triple=$BUILD -isystem$DPCPP_ROOT/include -isystem$ONEMKL_ROOT/include $CXXFLAGS"
