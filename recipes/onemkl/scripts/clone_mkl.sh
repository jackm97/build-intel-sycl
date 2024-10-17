#!/bin/bash

set -e

if [ ! -d onemkl ]; then
  git clone https://github.com/oneapi-src/oneMKL.git onemkl
fi
