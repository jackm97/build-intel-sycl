#!/bin/bash
set -e

source "$SYCL_PROJECT_ROOT/activation/linux.sh"
source "$SYCL_PROJECT_ROOT/activation/gcc.sh"

python "$SYCL_PROJECT_ROOT/llvm/buildbot/compile.py" -t deploy-sycl-toolchain
