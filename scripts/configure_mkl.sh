#!/bin/bash

export ONEMKL_INSTALL_PREFIX=$SYCL_INSTALL_PREFIX/onemkl

cd onemkl || exit
mkdir -p build
cd build || exit

rm -f CMakeCache.txt

cmake .. -G Ninja \
  -DENABLE_MKLCPU_BACKEND=True \
  -DENABLE_MKLGPU_BACKEND=False \
  -DENABLE_CUBLAS_BACKEND=True \
  -DENABLE_CUSOLVER_BACKEND=True \
  -DENABLE_CURAND_BACKEND=True \
  -DBUILD_FUNCTIONAL_TESTS=False \
  -DBUILD_EXAMPLES=False \
  -DTARGET_DOMAINS="blas lapack" \
  -DCMAKE_INSTALL_PREFIX="$ONEMKL_INSTALL_PREFIX"
