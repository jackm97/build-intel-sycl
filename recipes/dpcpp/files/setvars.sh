#!/bin/bash

set -e

function setup_dpcpp() {
  if [ -z "$ONEMKL_LIB_DIRS" ]; then
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

function setup_ocl() {
  if [ -z "$TBB_LIBS" ]; then
    if [ -d "$DPCPP_ROOT"/tbb ]; then
      tbb_libs=$(ls "$DPCPP_ROOT"/tbb)
      tbb_libs=$DPCPP_ROOT/tbb/$tbb_libs/lib/intel64
      tbb_libs=$tbb_libs/$(ls "$tbb_libs")
      export DPCPP_OCL_DIRS=$DPCPP_ROOT/opencl/runtime/linux/oclcpu/x64
      export DPCPP_OCL_DIRS=$DPCPP_ROOT/opencl/runtime/linux/oclfpgaemu/x64:$DPCPP_OCL_DIRS
      export TBB_LIBS=$tbb_libs
    fi

    for path in ${TBB_LIBS//:/ }; do
      link_path_flags="-L $path $link_path_flags"
    done
    for path in ${DPCPP_OCL_DIRS//:/ }; do
      link_path_flags="-L $path $link_path_flags"
    done
    export DPCPP_OCL_LDFLAGS="$link_path_flags"

    if [ "$DPCPP_SKIP_LD_PATH" != "1" ]; then
      export LD_LIBRARY_PATH=$tbb_libs:$LD_LIBRARY_PATH
      export LD_LIBRARY_PATH=$DPCPP_ROOT/opencl/runtime/linux/oclcpu/x64:$LD_LIBRARY_PATH
      export LD_LIBRARY_PATH=$DPCPP_ROOT/opencl/runtime/linux/oclfpgaemu/x64:$LD_LIBRARY_PATH
    fi
  fi
}

function setup_conda() {
  if [ "$DPCPP_CONDA_SETUP_DONE" != "1" ]; then
    export CUDA_ROOT="$CONDA_PREFIX/targets/x86_64-linux"
    export CUDA_LIB_PATH="$CUDA_ROOT"/lib/stubs

    GCC_VERSION=$(ls "$CONDA_PREFIX"/lib/gcc/"$BUILD")
    export GCC_VERSION=$GCC_VERSION
    export STDCXX_INC_DIR="$CONDA_PREFIX/lib/gcc/$BUILD/$GCC_VERSION/include/c++"
    GCC_TOOLCHAIN="$CONDA_PREFIX"
    export GCC_TOOLCHAIN=$GCC_TOOLCHAIN
    export DPCPP_GCC_TOOLCHAIN_CXXFLAGS="--gcc-toolchain=$GCC_TOOLCHAIN --gcc-triple=$BUILD -isystem $STDCXX_INC_DIR -isystem $STDCXX_INC_DIR/$BUILD"
    export CMAKE_PREFIX_PATH="$DPCPP_ROOT/tbb/oneapi-tbb-2021.12.0:$CMAKE_PREFIX_PATH"
    export CMAKE_ARGS="-DCUDAToolkit_ROOT=$CUDA_ROOT -DCUDA_TOOLKIT_ROOT_DIR=$CUDA_ROOT -DCMAKE_SYSROOT=$CONDA_BUILD_SYSROOT $CMAKE_ARGS"

    export C_COMPILER=$CC
    export CXX_COMPILER=$CXX
    export CXXFLAGS=$CXXFLAGS
    export CFLAGS=$CFLAGS

    ocl_icd_vendors=$OCL_ICD_VENDORS
    if [ -f "$CONDA_PREFIX"/etc/conda/deactivate.d/deactivate-opencl-rt.sh ]; then
      source "$CONDA_PREFIX"/etc/conda/deactivate.d/deactivate-opencl-rt.sh
    fi
    export OCL_ICD_VENDORS=$CONDA_PREFIX/etc/dpcpp/OpenCL/vendors/
    mkdir -p "$OCL_ICD_VENDORS"

    if [ -d "$OCL_ICD_VENDORS" ]; then
      if [ -d "$ocl_icd_vendors" ]; then
        find "$ocl_icd_vendors" -name "*.icd" -print0 | xargs -I{} -0 ln -sf {} "$OCL_ICD_VENDORS"
        rm -f "$OCL_ICD_VENDORS"/cuda.icd
      fi
      find /etc/OpenCL/vendors/ -name "*.icd" -print0 | xargs -I{} -0 ln -sf {} "$OCL_ICD_VENDORS"

      if [ -d "$DPCPP_ROOT"/etc/OpenCL/vendors ]; then
        find "$DPCPP_ROOT"/etc/OpenCL/vendors -name "*.icd" -print0 | xargs -I{} -0 ln -sf {} "$OCL_ICD_VENDORS"
      fi
    fi

    export LDFLAGS="$DPCPP_OCL_LDFLAGS $LDFLAGS"

    if [ "$COMPILING_ONEMKL" != "1" ]; then
      if [ "$COMPILING_DPCPP" != "1" ]; then
        export CXXFLAGS="-isystem $ONEMKL_ROOT/include $CXXFLAGS"
        export LDFLAGS="$ONEMKL_LDFLAGS $LDFLAGS"
        export CMAKE_PREFIX_PATH="$ONEMKL_ROOT:$CMAKE_PREFIX_PATH"
      fi
    fi

    if [ "$COMPILING_DPCPP" != "1" ]; then
      export LDFLAGS="$DPCPP_LDFLAGS $LDFLAGS"
      export CXX_COMPILER="$DPCPP_ROOT/bin/clang++"
      export C_COMPILER="$DPCPP_ROOT/bin/clang"
      export CXXFLAGS="$DPCPP_GCC_TOOLCHAIN_CXXFLAGS -isystem $DPCPP_ROOT/include $CXXFLAGS"
      export CMAKE_PREFIX_PATH="$DPCPP_ROOT:$CMAKE_PREFIX_PATH"
    fi

    export CXX="$CXX_COMPILER"
    export CC="$C_COMPILER"
  fi
  export DPCPP_CONDA_SETUP_DONE="1"
}

if [ -z "$DPCPP_ROOT" ]; then
  oneapi_dir=$(bash -c "cd -- '$(dirname -- "${BASH_SOURCE[0]}")' &>/dev/null && pwd")
  export DPCPP_ROOT=$oneapi_dir
fi

setup_ocl
setup_dpcpp
setup_onemkl
if [ -n "$CONDA_PREFIX" ]; then
  setup_conda
fi
