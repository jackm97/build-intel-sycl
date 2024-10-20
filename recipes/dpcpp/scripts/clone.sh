#!/bin/bash

set -e

if [ ! -d llvm ]; then
  git clone https://github.com/intel/llvm -b nightly-2024-10-16 --depth 1
fi
