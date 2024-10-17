#!/bin/bash

set -e

if [ -f "$DPCPP_ROOT"/scripts/setvars.sh ]; then
  source "$DPCPP_ROOT"/scripts/setvars.sh
fi

link_path_flags=""
for path in ${LD_LIBRARY_PATH//:/ }; do
  link_path_flags="$link_path_flags -L $path"
done
export EXTRA_LDFLAGS=$link_path_flags
export LDFLAGS="$LDFLAGS $link_path_flags"

export CMAKE_PREFIX_PATH="$ONEMKL_ROOT:$DPCPP_ROOT:$CMAKE_PREFIX_PATH"

CXX_COMPILER=$(which clang++)
export CXX=$CXX_COMPILER
export CXX_COMPILER=$CXX
export CC=$(which clang)
export C_COMPILER=$CC

export CXXFLAGS="--cuda-path=$CONDA_PREFIX --gcc-toolchain=$GCC_TOOLCHAIN --gcc-triple=$BUILD -isystem$DPCPP_ROOT/include -isystem$ONEMKL_ROOT/include $CXXFLAGS"
