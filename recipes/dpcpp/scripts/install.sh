#!/bin/bash

set -e

cd "$DPCPP_HOME"/llvm/build
cmake --build "$DPCPP_HOME"/llvm/build --target deploy-sycl-toolchain
cmake --build "$DPCPP_HOME"/llvm/build --target utils/FileCheck/install
cmake --build "$DPCPP_HOME"/llvm/build --target utils/count/install
cmake --build "$DPCPP_HOME"/llvm/build --target utils/not/install
cmake --build "$DPCPP_HOME"/llvm/build --target utils/lit/install
cmake --build "$DPCPP_HOME"/llvm/build --target utils/llvm-lit/install
cmake --build "$DPCPP_HOME"/llvm/build --target install-llvm-size
cmake --build "$DPCPP_HOME"/llvm/build --target install-llvm-cov
cmake --build "$DPCPP_HOME"/llvm/build --target install-llvm-profdata
cmake --build "$DPCPP_HOME"/llvm/build --target install-compiler-rt
cmake --build "$DPCPP_HOME"/llvm/build --target install

sudo chown -R $USER $DPCPP_ROOT

mkdir -p "$DPCPP_ROOT"/scripts
cd "$PIXI_PROJECT_ROOT"/recipes/dpcpp/files
cp -r ./* "$DPCPP_ROOT"
find bin/ -type f -exec chmod +x "$DPCPP_ROOT"/{} ";"
