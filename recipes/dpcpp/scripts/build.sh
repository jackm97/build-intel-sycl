#!/bin/bash
set -e

cd "$DPCPP_HOME"/llvm/build
cmake --build "$DPCPP_HOME"/llvm/build --target clang -- -j$(nproc)
