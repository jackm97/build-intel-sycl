export ONEMKL_INSTALL_PREFIX=$SYCL_INSTALL_PREFIX/onemkl
source "$SYCL_INSTALL_PREFIX"/setvars.sh
export CXX_COMPILER=$(which clang++)
export C_COMPILER=$(which clang)
export LIBRARY_PATH=$LD_LIBRARY_PATH
export MKLROOT=$CONDA_PREFIX
