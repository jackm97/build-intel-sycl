#!/bin/bash

set -e

export CXXFLAGS="--sysroot='$CONDA_BUILD_SYSROOT' --gcc-install-dir='$GCC_TOOLCHAIN' $CXXFLAGS"
export CFLAGS="--sysroot='$CONDA_BUILD_SYSROOT' --gcc-install-dir='$GCC_TOOLCHAIN' $CFLAGS"

cd "$PIXI_PROJECT_ROOT"/llvm/build
cmake --build "$PIXI_PROJECT_ROOT"/llvm/build --target deploy-sycl-toolchain
cmake --build "$PIXI_PROJECT_ROOT"/llvm/build --target utils/FileCheck/install
cmake --build "$PIXI_PROJECT_ROOT"/llvm/build --target utils/count/install
cmake --build "$PIXI_PROJECT_ROOT"/llvm/build --target utils/not/install
cmake --build "$PIXI_PROJECT_ROOT"/llvm/build --target utils/lit/install
cmake --build "$PIXI_PROJECT_ROOT"/llvm/build --target utils/llvm-lit/install
cmake --build "$PIXI_PROJECT_ROOT"/llvm/build --target install-llvm-size
cmake --build "$PIXI_PROJECT_ROOT"/llvm/build --target install-llvm-cov
cmake --build "$PIXI_PROJECT_ROOT"/llvm/build --target install-llvm-profdata
cmake --build "$PIXI_PROJECT_ROOT"/llvm/build --target install-compiler-rt
cmake --build "$PIXI_PROJECT_ROOT"/llvm/build --target install

cp -r "$PIXI_PROJECT_ROOT"/recipes/dpcpp/files "$DPCPP_ROOT"
