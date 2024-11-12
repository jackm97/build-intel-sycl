#!/bin/bash

set -e

function setup_dpcpp() {
  if [ -z "$DPCPP_LIB_DIRS" ]; then
    export DPCPP_LIB_DIRS="$DPCPP_ROOT/lib:$DPCPP_ROOT/lib64"

    link_path_flags=""
    for path in ${DPCPP_LIB_DIRS//:/ }; do
      # link_path_flags="$config_ldflags -L $path"
      link_path_flags="-Wl,-rpath,$path -L $path $link_path_flags"
    done
    export DPCPP_LDFLAGS="$link_path_flags"

    export DPCPP_CXXFLAGS="-isystem $DPCPP_ROOT/include"
    export DPCPP_CFLAGS="-isystem $DPCPP_ROOT/include"
  fi
}

function setup_conda() {
  if [ "$DPCPP_CONDA_SETUP_DONE" != "1" ]; then
    gcc_toolchain="$(find "$CONDA_PREFIX/lib/gcc/$HOST" -maxdepth 1 -wholename "*/$HOST/*")"
    export GCC_TOOLCHAIN="$gcc_toolchain"
    export DPCPP_CXXFLAGS="--sysroot=$CONDA_BUILD_SYSROOT --gcc-install-dir=$GCC_TOOLCHAIN $DPCPP_CFLAGS $CXXFLAGS"
    export DPCPP_CFLAGS="--sysroot=$CONDA_BUILD_SYSROOT --gcc-install-dir=$GCC_TOOLCHAIN $DPCPP_CFLAGS $CFLAGS"

    export DPCPP_LDFLAGS="$DPCPP_LDFLAGS $LDFLAGS"

    export CC="$DPCPP_ROOT/bin/clang"
    export CXX="$DPCPP_ROOT/bin/clang++"

    export LD_LIBRARY_PATH="$DPCPP_LIB_DIRS:$CONDA_PREFIX/lib:$LD_LIBRARY_PATH"
  fi
  export DPCPP_CONDA_SETUP_DONE="1"
}

if [ -z "$DPCPP_ROOT" ]; then
  oneapi_dir=$(bash -c "cd -- $(dirname -- "${BASH_SOURCE[0]}") &>/dev/null && pwd")
  export DPCPP_ROOT=$oneapi_dir
fi

setup_dpcpp
export PATH="$DPCPP_ROOT/bin:$PATH"
export LD_LIBRARY_PATH="$DPCPP_LIB_DIRS:$LD_LIBRARY_PATH"
if [ -n "$CONDA_PREFIX" ]; then
  setup_conda
fi
