#!/bin/bash

cd onemkl/build || exit

cmake --install .

echo 'export CMAKE_PREFIX_PATH=$oneapi_dir/onemkl:$CMAKE_PREFIX_PATH' | tee -a "$SYCL_INSTALL_PREFIX"/setvars.sh
echo 'export LD_LIBRARY_PATH=$oneapi_dir/onemkl/lib:$LD_LIBRARY_PATH' | tee -a "$SYCL_INSTALL_PREFIX"/setvars.sh
