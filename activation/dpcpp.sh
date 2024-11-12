set -e

if [ -z "$DPCPP_ROOT" ]; then
  export DPCPP_ROOT="$HOME/intel/oneapi"
fi

gcc_toolchain="$(find "$CONDA_PREFIX/lib/gcc/$HOST" -maxdepth 1 -wholename "*/$HOST/*")"
export GCC_TOOLCHAIN="$gcc_toolchain"
if [ -z "$PIXI_DPCPP_ACTIVE" ]; then
  sysroot=$CONDA_BUILD_SYSROOT
  host=$HOST
  for file in $CONDA_PREFIX/etc/conda/deactivate.d/*; do
    . $file
  done
  export CONDA_BUILD_SYSROOT=$sysroot
  export HOST=$host
  . "$DPCPP_ROOT/setvars.sh" --include-intel-llvm
  export CXX="$(which icpx)"
  export CC="$(which icx)"
  export CXXFLAGS="--sysroot=$CONDA_BUILD_SYSROOT --gcc-toolchain=$CONDA_PREFIX --target=$HOST -isystem $CONDA_PREFIX/include"
  export CFLAGS="--sysroot=$CONDA_BUILD_SYSROOT --gcc-toolchain=$CONDA_PREFIX --target=$HOST -isystem $CONDA_PREFIX/include"
  export CMAKE_TOOLCHAIN_FILE="$PIXI_PROJECT_ROOT/toolchains/dpcpp-linux.cmake"
  export PIXI_DPCPP_ACTIVE=1
fi
