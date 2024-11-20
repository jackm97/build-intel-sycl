#!/bin/bash

set -e

source "$SYCL_PROJECT_ROOT/activation/linux.sh"
source "$SYCL_PROJECT_ROOT/activation/gcc.sh"

python "$SYCL_PROJECT_ROOT/llvm/buildbot/compile.py" -t install

cp -r "$SYCL_PROJECT_ROOT"/recipes/llvm-sycl/files/* "$INSTALL_PREFIX"
