set -e

if [ -z "$PIXI_GCC_ACTIVE" ]; then
  export LIBRARY_PATH="$LD_LIBRARY_PATH"
  export CFLAGS="--sysroot=$CONDA_BUILD_SYSROOT $CFLAGS"
  export CXXFLAGS="--sysroot=$CONDA_BUILD_SYSROOT $CXXFLAGS"
  export PIXI_GCC_ACTIVE="1"
fi
