#!/bin/bash
set -e

source "$PIXI_PROJECT_ROOT/activation/linux.sh"
source "$PIXI_PROJECT_ROOT/activation/gcc.sh"

cd "$PIXI_PROJECT_ROOT"/llvm/build
cmake --build "$PIXI_PROJECT_ROOT"/llvm/build --target clang -- -j$(nproc)
