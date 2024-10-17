#!/bin/bash

set -e

if [ ! -d llvm ]; then
  git clone https://github.com/intel/llvm -b sycl-web/sycl-latest-good --depth 1
fi
