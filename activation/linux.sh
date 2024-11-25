#!/bin/bash
set -e

if [ -z "$PIXI_LINUX_ACTIVE" ]; then
  if [ -z "$BUILD_PREFIX" ]; then
    export BUILD_PREFIX="$CONDA_PREFIX"
  fi
  if [ -z "$PREFIX" ]; then
    export PREFIX="$CONDA_PREFIX"
  fi
  if [ -z "$INSTALL_PREFIX" ]; then
    export INSTALL_PREFIX="$PREFIX"
  fi
  if [ -z "$PROJECT_ROOT" ]; then
    export PROJECT_ROOT="$PIXI_PROJECT_ROOT/../.."
  fi
  if [ -z "$CONDA_TOOLCHAIN_HOST" ]; then
    export CONDA_TOOLCHAIN_HOST="$HOST"
  fi
  export CUDA_ROOT="$BUILD_PREFIX/targets/x86_64-linux"
  export CUDA_LIB_PATH="$CUDA_ROOT/lib/stubs"
  export PROJECT_TOOLCHAIN_FILE="$PROJECT_ROOT/toolchains/linux.cmake"
  if [ -d "$PIXI_PROJECT_ROOT/vcpkg" ]; then
    export VCPKG_ROOT="$PROJECT_ROOT/vcpkg"
  fi
  export PIXI_LINUX_ACTIVE="1"
fi
