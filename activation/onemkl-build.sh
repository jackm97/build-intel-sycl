set -e

if [ -z "$DPCPP_ROOT" ]; then
  export DPCPP_ROOT="$HOME/dpcpp"
fi

if [ -z "$PIXI_ONEMKL_BUILD_ACTIVE" ]; then
  source "$DPCPP_ROOT/pixi-activate.sh"
  export MKLROOT="$BUILD_PREFIX"
  export CXX="$BUILD_PREFIX/bin/clang++"
  export CC="$BUILD_PREFIX/bin/clang"
  export OCL_ICD_VENDORS="$BUILD_PREFIX/etc/OpenCL/vendors"
  export PIXI_ONEMKL_BUILD_ACTIVE=1
fi
