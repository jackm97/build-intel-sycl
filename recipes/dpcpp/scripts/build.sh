#!/bin/bash
set -e

cmake --build "$PIXI_PROJECT_ROOT"/llvm/build --target clang -- -j$(nproc)
