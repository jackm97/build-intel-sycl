#!/bin/bash

set -e

oneapi_dir=$(bash -c "cd -- $(dirname -- "${BASH_SOURCE[0]}") &>/dev/null && pwd")
cp -r "$oneapi_dir/*" "$CONDA_PREFIX"
export CXXFLAGS="--sysroot=$CONDA_BUILD_SYSROOT --gcc-toolchain=$CONDA_PREFIX --target=$HOST $CXXFLAGS"
export CFLAGS="--sysroot=$CONDA_BUILD_SYSROOT --gcc-toolchain=$CONDA_PREFIX --target=$HOST $CFLAGS"
export LDFLAGS="-Wl,rpath,$CONDA_PREFIX/lib64 -L$CONDA_PREFIX/lib64 $LDFLAGS"
echo "$CXXFLAGS" >"$oneapi_dir/bin/clang++.cfg"
echo "$LDFLAGS" >>"$oneapi_dir/bin/clang++.cfg"
echo "$CFLAGS" >"$oneapi_dir/bin/clang.cfg"
echo "$LDFLAGS" >>"$oneapi_dir/bin/clang.cfg"
