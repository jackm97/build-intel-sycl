set -e

if [ -z "$PIXI_LINUX_ACTIVE" ]; then
  if [ -z "$PREFIX" ]; then
    export PREFIX="$CONDA_PREFIX"
  fi
  if [ -z "$INSTALL_PREFIX" ]; then
    export INSTALL_PREFIX="$PREFIX"
  fi
  if [ -z "$SYCL_PROJECT_ROOT" ]; then
    new_root="$PIXI_PROJECT_ROOT/../.."
    export SYCL_PROJECT_ROOT="$new_root"
  fi

  for file in "$PREFIX"/etc/conda/deactivate.d/*; do
    source "$file"
  done

  export CUDA_ROOT="$PREFIX/targets/x86_64-linux"
  export CUDA_LIB_PATH="$CUDA_ROOT/lib/stubs:$PREFIX/lib"
  export LD_LIBRARY_PATH="$PREFIX/lib:$CUDA_LIB_PATH:$LD_LIBRARY_PATH"
  export PIXI_LINUX_ACTIVE="1"
fi
