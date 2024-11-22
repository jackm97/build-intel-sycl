#!/bin/bash

set -e

oneapi_dir=$(bash -c "cd -- $(dirname -- "${BASH_SOURCE[0]}") &>/dev/null && pwd")
rm -rf "$CONDA_PREFIX/dpcpp"
cp -r "$oneapi_dir" "$CONDA_PREFIX/dpcpp"
oneapi_dir="$CONDA_PREFIX/dpcpp"
export LD_LIBRARY_PATH="$oneapi_dir/lib64:$oneapi_dir/lib:$CONDA_PREFIX/lib:$LD_LIBRARY_PATH"
export CXXFLAGS="--sysroot=$CONDA_BUILD_SYSROOT --gcc-toolchain=$CONDA_PREFIX --target=$HOST --isystem $oneapi_dir/include $CXXFLAGS"
export CFLAGS="--sysroot=$CONDA_BUILD_SYSROOT --gcc-toolchain=$CONDA_PREFIX --target=$HOST --isystem $oneapi_dir/include $CFLAGS"
echo "$CXXFLAGS" >"$oneapi_dir/bin/clang++.cfg"
echo "$LDFLAGS" >>"$oneapi_dir/bin/clang++.cfg"
echo "$CFLAGS" >"$oneapi_dir/bin/clang.cfg"
echo "$LDFLAGS" >>"$oneapi_dir/bin/clang.cfg"
