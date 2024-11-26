#!/bin/bash

set -e

oneapi_dir=$(bash -c "cd -- $(dirname -- "${BASH_SOURCE[0]}") &>/dev/null && pwd")
find "$oneapi_dir" -maxdepth 1 -exec cp -r {} "$BUILD_PREFIX" ";"
export LD_LIBRARY_PATH="${LD_LIBRARY_PATH/$BUILD_PREFIX\/lib:/}"
export LD_LIBRARY_PATH="$BUILD_PREFIX/lib:$BUILD_PREFIX/lib64:$LD_LIBRARY_PATH"
export CXXFLAGS="--sysroot=$CONDA_BUILD_SYSROOT --gcc-toolchain=$BUILD_PREFIX --target=$CONDA_TOOLCHAIN_HOST $CXXFLAGS"
export CFLAGS="--sysroot=$CONDA_BUILD_SYSROOT --gcc-toolchain=$BUILD_PREFIX --target=$CONDA_TOOLCHAIN_HOST $CFLAGS"
export LDFLAGS="-L$BUILD_PREFIX/lib64 $LDFLAGS"
echo "$CXXFLAGS" >"$oneapi_dir/bin/clang++.cfg"
echo "$LDFLAGS" >>"$oneapi_dir/bin/clang++.cfg"
echo "$CFLAGS" >"$oneapi_dir/bin/clang.cfg"
echo "$LDFLAGS" >>"$oneapi_dir/bin/clang.cfg"
