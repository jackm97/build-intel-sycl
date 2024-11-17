#!/bin/bash

set -e

source "$SYCL_PROJECT_ROOT/activation/linux.sh"
source "$SYCL_PROJECT_ROOT/activation/gcc.sh"

python "$SYCL_PROJECT_ROOT/llvm/buildbot/compile.py" -t deploy-sycl-toolchain
python "$SYCL_PROJECT_ROOT/llvm/buildbot/compile.py" -t utils/FileCheck/install
python "$SYCL_PROJECT_ROOT/llvm/buildbot/compile.py" -t utils/count/install
python "$SYCL_PROJECT_ROOT/llvm/buildbot/compile.py" -t utils/not/install
python "$SYCL_PROJECT_ROOT/llvm/buildbot/compile.py" -t utils/lit/install
python "$SYCL_PROJECT_ROOT/llvm/buildbot/compile.py" -t utils/llvm-lit/install
python "$SYCL_PROJECT_ROOT/llvm/buildbot/compile.py" -t install-llvm-size
python "$SYCL_PROJECT_ROOT/llvm/buildbot/compile.py" -t install-llvm-cov
python "$SYCL_PROJECT_ROOT/llvm/buildbot/compile.py" -t install-llvm-profdata
python "$SYCL_PROJECT_ROOT/llvm/buildbot/compile.py" -t install-compiler-rt
python "$SYCL_PROJECT_ROOT/llvm/buildbot/compile.py" -t install

# cp -r "$PREFIX/llvm-sycl/*" "$PREFIX"
# rm -rf "$PREFIX/llvm-sycl"
