#!/bin/bash

set -e

cd "$SYCL_PROJECT_ROOT" || exit
cd onemkl/build || exit

cmake --install .
