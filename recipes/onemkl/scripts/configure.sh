#!/bin/bash

set -e

cd onemkl || exit
mkdir -p build
cd build || exit

rm -f CMakeCache.txt

cmake .. -G Ninja \
  -DCMAKE_CXX_COMPILER="$CXX_COMPILER" \
  -DCMAKE_C_COMPILER="$C_COMPILER" \
  "$CMAKE_ARGS"
