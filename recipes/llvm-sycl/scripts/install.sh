#!/bin/bash

set -e

cd "$PROJECT_ROOT/llvm/build"
cmake --build . -t install -- -j6

cp -r "$PROJECT_ROOT"/recipes/llvm-sycl/files/* "$INSTALL_PREFIX"
