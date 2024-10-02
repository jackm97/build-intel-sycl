#!/bin/bash

if [ ! -d llvm ]; then
  git clone https://github.com/intel/llvm -b sycl --depth 1
fi
