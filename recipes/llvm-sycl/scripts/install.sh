#!/bin/bash

set -e

cd "$SYCL_PROJECT_ROOT/llvm/build"
cmake --build . -t install -- -j6

cp -r "$SYCL_PROJECT_ROOT"/recipes/llvm-sycl/files/* "$INSTALL_PREFIX"
