#!/bin/bash
set -e

cd "$PIXI_PROJECT_ROOT"/llvm/build
cmake --build "$PIXI_PROJECT_ROOT"/llvm/build --target clang -- -j$(nproc)
