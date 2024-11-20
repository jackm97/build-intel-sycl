set -e

if [ -z "$DPCPP_ROOT" ]; then
  export DPCPP_ROOT="$HOME/dpcpp"
fi

if [ -z "$PIXI_DPCPP_ACTIVE" ]; then
  source "$DPCPP_ROOT/pixi-activate.sh"
  export MKLROOT="$CONDA_PREFIX"
  export CXX="$CONDA_PREFIX/bin/clang++"
  export CC="$CONDA_PREFIX/bin/clang"
  export OCL_ICD_VENDORS="$CONDA_PREFIX/etc/OpenCL/vendors"
  export PIXI_DPCPP_ACTIVE=1
fi
