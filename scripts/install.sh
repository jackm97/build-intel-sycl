#!/bin/bash

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

sudo chown -R $USER $SYCL_INSTALL_PREFIX
