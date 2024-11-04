#!/bin/bash
set -e

export CXXFLAGS="--sysroot='$CONDA_BUILD_SYSROOT' --gcc-install-dir='$GCC_TOOLCHAIN' $CXXFLAGS"
export CFLAGS="--sysroot='$CONDA_BUILD_SYSROOT' --gcc-install-dir='$GCC_TOOLCHAIN' $CFLAGS"

cd "$PIXI_PROJECT_ROOT"/llvm/build
cmake --build "$PIXI_PROJECT_ROOT"/llvm/build --target clang -- -j$(nproc)
