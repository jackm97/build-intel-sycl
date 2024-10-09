export DPCPP_HOME=$PIXI_PROJECT_ROOT
export PATH=$CONDA_PREFIX/bin:$PATH
export LD_LIBRARY_PATH="$CONDA_PREFIX/lib:$LD_LIBRARY_PATH"
export CUDA_LIB_PATH="$CONDA_PREFIX/targets/x86_64-linux/lib/stubs"

for script in "$CONDA_PREFIX"/etc/conda/deactivate.d/deactivate-g*; do source "$script"; done
for script in "$CONDA_PREFIX"/etc/conda/activate.d/activate-clang*; do source "$script"; done
# for script in "$CONDA_PREFIX"/etc/conda/deactivate.d/deactivate-clang*; do source "$script"; done
# for script in "$CONDA_PREFIX"/etc/conda/activate.d/activate-clang*; do source "$script"; done

if [ -z "$SYCL_INSTALL_PREFIX" ]; then
  export SYCL_INSTALL_PREFIX="$PIXI_PROJECT_ROOT/intel/oneapi"
fi

export CMAKE_PREFIX_PATH="$CMAKE_PREFIX_PATH:$SYCL_INSTALL_PREFIX/tbb/oneapi-tbb-2021.12.0"
