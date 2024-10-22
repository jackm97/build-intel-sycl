#!/bin/bash

set -e

function setup_dpcpp() {
  if [ -z "$DPCPP_LIB_DIRS" ]; then
    export PATH="$DPCPP_ROOT/bin:$PATH"
    export DPCPP_LIB_DIRS="$DPCPP_ROOT/lib:$DPCPP_ROOT/lib64"

    link_path_flags=""
    for path in ${DPCPP_LIB_DIRS//:/ }; do
      link_path_flags="-L $path $link_path_flags"
    done
    export DPCPP_LDFLAGS="$link_path_flags"

    export DPCPP_CXXFLAGS="-isystem $DPCPP_ROOT/include"

    if [ "$DPCPP_SKIP_LD_PATH" != "1" ]; then
      export LD_LIBRARY_PATH="$DPCPP_LIB_DIRS:$LD_LIBRARY_PATH"
    fi
  fi
}

function setup_onemkl() {
  if [ -z "$ONEMKL_LIB_DIRS" ]; then
    export ONEMKL_ROOT="$DPCPP_ROOT/onemkl"
    export ONEMKL_LIB_DIRS="$ONEMKL_ROOT/lib:$ONEMKL_ROOT/lib64"

    link_path_flags=""
    for path in ${ONEMKL_LIB_DIRS//:/ }; do
      link_path_flags="-L $path $link_path_flags"
    done
    export ONEMKL_LDFLAGS="$link_path_flags"

    export ONEMKL_CXXFLAGS="-isystem $ONEMKL_ROOT/include"

    if [ "$DPCPP_SKIP_LD_PATH" != "1" ]; then
      export LD_LIBRARY_PATH="$ONEMKL_LIB_DIRS:$LD_LIBRARY_PATH"
    fi
  fi
}

function populate_compiler_cfg() {
  mkdir -p "$DPCPP_ROOT/bin"
  config_cxxflags="$DPCPP_CXXFLAGS"
  config_ldflags="$DPCPP_LDFLAGS"
  if [ "$COMPILING_ONEMKL" != "1" ]; then
    if [ "$COMPILING_DPCPP" != "1" ]; then
      config_ldflags="$config_ldflags $ONEMKL_LDFLAGS"
      config_cxxflags="$config_cxxflags $ONEMKL_CXXFLAGS"
    fi
  fi

  echo "$config_cxxflags" >"$DPCPP_ROOT/bin/clang.cfg"
  echo "" >>"$DPCPP_ROOT/bin/clang.cfg"
  echo "$config_ldflags" >>"$DPCPP_ROOT/bin/clang.cfg"
  echo "$config_cxxflags" >"$DPCPP_ROOT/bin/clang++.cfg"
  echo "" >>"$DPCPP_ROOT/bin/clang++.cfg"
  echo "$config_ldflags" >>"$DPCPP_ROOT/bin/clang++.cfg"
}

function setup_conda() {
  if [ "$DPCPP_CONDA_SETUP_DONE" != "1" ]; then
    export CUDA_ROOT="$CONDA_PREFIX/targets/x86_64-linux"
    export CUDA_LIB_PATH="$CUDA_ROOT"/lib/stubs

    GCC_VERSION=$(ls "$CONDA_PREFIX"/lib/gcc/"$HOST")
    export GCC_VERSION=$GCC_VERSION
    export STDCXX_INC_DIR="$CONDA_PREFIX/lib/gcc/$HOST/$GCC_VERSION/include/c++"
    GCC_TOOLCHAIN="$CONDA_PREFIX"
    export GCC_TOOLCHAIN=$GCC_TOOLCHAIN
    export DPCPP_GCC_TOOLCHAIN_CXXFLAGS="--sysroot $CONDA_BUILD_SYSROOT --gcc-toolchain=$GCC_TOOLCHAIN --gcc-triple=$HOST -isystem $STDCXX_INC_DIR -isystem $STDCXX_INC_DIR/$HOST"
    export CMAKE_ARGS="-DCUDAToolkit_ROOT=$CUDA_ROOT -DCUDA_TOOLKIT_ROOT_DIR=$CUDA_ROOT -DCMAKE_SYSROOT=$CONDA_BUILD_SYSROOT $CMAKE_ARGS"

    unset CXXFLAGS
    unset CPPFLAGS
    unset CFLAGS
    . "$CONDA_PREFIX/etc/conda/activate.d/activate-gcc_linux-64.sh"
    . "$CONDA_PREFIX/etc/conda/activate.d/activate-gxx_linux-64.sh"

    mkdir -p "$DPCPP_ROOT/bin"
    config_cxxflags="$DPCPP_CXXFLAGS"
    config_ldflags="$DPCPP_LDFLAGS"
    if [ "$COMPILING_ONEMKL" != "1" ]; then
      if [ "$COMPILING_DPCPP" != "1" ]; then
        config_ldflags="$config_ldflags $ONEMKL_LDFLAGS"
        config_cxxflags="$config_cxxflags $ONEMKL_CXXFLAGS"
      fi
    fi

    if [ "$COMPILING_DPCPP" != "1" ]; then
      ln -sf "$DPCPP_ROOT/bin/clang" "$DPCPP_ROOT/bin/$HOST-clang"
      ln -sf "$DPCPP_ROOT/bin/clang++" "$DPCPP_ROOT/bin/$HOST-clang++"

      export CC_FOR_BUILD="$DPCPP_ROOT/bin/$HOST-clang"
      export CXX_FOR_BUILD="$DPCPP_ROOT/bin/$HOST-clang++"
      export CCFLAGS="--config $DPCPP_ROOT/bin/$HOST-clang.cfg $CXXFLAGS"
      export CXXFLAGS="--config $DPCPP_ROOT/bin/$HOST-clang++.cfg $CXXFLAGS"
    fi

    echo "$DPCPP_GCC_TOOLCHAIN_CXXFLAGS $config_cxxflags -isystem $CONDA_PREFIX/include" >"$DPCPP_ROOT/bin/$HOST-clang.cfg"
    echo "" >>"$DPCPP_ROOT/bin/$HOST-clang.cfg"
    echo "$config_ldflags" >>"$DPCPP_ROOT/bin/$HOST-clang.cfg"
    echo "$DPCPP_GCC_TOOLCHAIN_CXXFLAGS $config_cxxflags -isystem $CONDA_PREFIX/include" >"$DPCPP_ROOT/bin/$HOST-clang++.cfg"
    echo "" >>"$DPCPP_ROOT/bin/$HOST-clang++.cfg"
    echo "$config_ldflags -L$CUDA_LIB_PATH -L$CONDA_PREFIX/lib -L$CONDA_BUILD_SYSROOT/lib -L$CONDA_BUILD_SYSROOT/lib64" >>"$DPCPP_ROOT/bin/$HOST-clang++.cfg"

    export C_COMPILER=$CC_FOR_BUILD
    export CXX_COMPILER=$CXX_FOR_BUILD
    export CC=$CC_FOR_BUILD
    export CXX=$CXX_FOR_BUILD

    if [ "$DPCPP_SKIP_LD_PATH" != "1" ]; then
      export LD_LIBRARY_PATH="$DPCPP_LIB_DIRS:$ONEMKL_LIB_DIRS:$CONDA_PREFIX/lib:$CUDA_LIB_PATH:$LD_LIBRARY_PATH"
    fi
  fi
  export DPCPP_CONDA_SETUP_DONE="1"
}

if [ -z "$DPCPP_ROOT" ]; then
  oneapi_dir=$(bash -c "cd -- '$(dirname -- "${BASH_SOURCE[0]}")' &>/dev/null && pwd")
  export DPCPP_ROOT=$oneapi_dir
fi

rm -f "$DPCPP_ROOT"/bin/*.cfg

setup_dpcpp
setup_onemkl
if [ -n "$CONDA_PREFIX" ]; then
  setup_conda
else
  populate_compiler_cfg
fi
