#!/bin/bash

set -e
set -x

if [ ! -d onemkl ]; then
  git clone https://github.com/oneapi-src/oneMKL.git onemkl
fi
