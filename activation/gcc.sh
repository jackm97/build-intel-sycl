set -e

if [ -z "$PIXI_GCC_ACTIVE" ]; then
  for file in "$PREFIX"/etc/conda/activate.d/*gcc*; do
    source "$file"
  done
  for file in "$PREFIX"/etc/conda/activate.d/*gxx*; do
    source "$file"
  done
  export CXX="$(which g++)"
  export CC="$(which gcc)"
  export CFLAGS="--sysroot=$CONDA_BUILD_SYSROOT $CFLAGS"
  export CXXFLAGS="--sysroot=$CONDA_BUILD_SYSROOT $CXXFLAGS"
  export PIXI_GCC_ACTIVE="1"
fi
