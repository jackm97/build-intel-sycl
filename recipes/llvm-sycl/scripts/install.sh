#!/bin/bash

set -e

source "$PIXI_PROJECT_ROOT/activation/linux.sh"
source "$PIXI_PROJECT_ROOT/activation/gcc.sh"

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

sudo chown -R $USER $DPCPP_ROOT

mkdir -p "$DPCPP_ROOT"/scripts
cd "$PIXI_PROJECT_ROOT"/recipes/dpcpp/files
cp -r ./* "$DPCPP_ROOT"
find bin/ -type f -exec chmod +x "$DPCPP_ROOT"/{} ";"
