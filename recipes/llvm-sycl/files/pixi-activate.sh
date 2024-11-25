#!/bin/bash

set -e

oneapi_dir=$(bash -c "cd -- $(dirname -- "${BASH_SOURCE[0]}") &>/dev/null && pwd")
find "$oneapi_dir" -maxdepth 1 -exec cp -r {} "$BUILD_PREFIX" ";"
export CXXFLAGS="--sysroot=$CONDA_BUILD_SYSROOT --gcc-toolchain=$BUILD_PREFIX --target=$CONDA_TOOLCHAIN_HOST $CXXFLAGS"
export CFLAGS="--sysroot=$CONDA_BUILD_SYSROOT --gcc-toolchain=$BUILD_PREFIX --target=$CONDA_TOOLCHAIN_HOST $CFLAGS"
export LDFLAGS="-Wl,-rpath-link,$BUILD_PREFIX/lib64 -L$BUILD_PREFIX/lib64 $LDFLAGS"
echo "$CXXFLAGS" >"$oneapi_dir/bin/clang++.cfg"
echo "$LDFLAGS" >>"$oneapi_dir/bin/clang++.cfg"
echo "$CFLAGS" >"$oneapi_dir/bin/clang.cfg"
echo "$LDFLAGS" >>"$oneapi_dir/bin/clang.cfg"
