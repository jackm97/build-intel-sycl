set -e

if [ -z "$PIXI_LINUX_ACTIVE" ]; then
  if [ -z "$PREFIX" ]; then
    export PREFIX="$CONDA_PREFIX"
  fi
  if [ -n "$PIXI_PROJECT_ROOT" ]; then
    new_root="$PIXI_PROJECT_ROOT/../.."
    export PIXI_PROJECT_ROOT="$new_root"
  fi

  export CUDA_ROOT="$PREFIX/targets/x86_64-linux"
  export CUDA_LIB_PATH="$CUDA_ROOT/lib/stubs:$PREFIX/lib"
  export LD_LIBRARY_PATH="$PREFIX/lib:$CUDA_LIB_PATH:$LD_LIBRARY_PATH"
  export CMAKE_TOOLCHAIN_FILE="$PIXI_PROJECT_ROOT/toolchains/linux.cmake"
  export PIXI_LINUX_ACTIVE="1"
fi
