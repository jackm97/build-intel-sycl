#!/bin/bash

set -e

cd onemkl/build
cmake --build . -- -j$(nproc)
