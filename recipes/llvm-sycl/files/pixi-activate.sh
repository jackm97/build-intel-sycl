#!/bin/bash

set -e

oneapi_dir=$(bash -c "cd -- $(dirname -- "${BASH_SOURCE[0]}") &>/dev/null && pwd")
cp -r "$oneapi_dir"/* "$CONDA_PREFIX"
export LD_LIBRARY_PATH="$CONDA_PREFIX/lib64:$CONDA_PREFIX/lib:$LD_LIBRARY_PATH"
export CXXFLAGS="--sysroot=$CONDA_BUILD_SYSROOT --gcc-toolchain=$CONDA_PREFIX --target=$HOST $CXXFLAGS"
export CFLAGS="--sysroot=$CONDA_BUILD_SYSROOT --gcc-toolchain=$CONDA_PREFIX --target=$HOST $CFLAGS"
echo "$CXXFLAGS" >"$CONDA_PREFIX/bin/clang++.cfg"
echo "$LDFLAGS" >>"$CONDA_PREFIX/bin/clang++.cfg"
echo "$CFLAGS" >"$CONDA_PREFIX/bin/clang.cfg"
echo "$LDFLAGS" >>"$CONDA_PREFIX/bin/clang.cfg"
