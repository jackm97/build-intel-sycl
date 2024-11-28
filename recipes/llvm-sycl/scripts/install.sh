#!/bin/bash

set -e

cd "$PROJECT_ROOT/llvm/build"
cmake --build . -t install -- -j6

cp -r "$PROJECT_ROOT"/recipes/llvm-sycl/files/* "$INSTALL_PREFIX"

if [ -z "$NO_INSTALL_RPATH" ]; then
  NO_INSTALL_RPATH="0"
fi

if [ "$NO_INSTALL_RPATH" != "1" ]; then
  bash "$PROJECT_ROOT/recipes/llvm-sycl/scripts/patch_installed_rpaths.sh"
fi
