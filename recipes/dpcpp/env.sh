#!/bin/bash

set -e

export DPCPP_HOME=$PIXI_PROJECT_ROOT

if [ -z "$DPCPP_ROOT" ]; then
  export DPCPP_ROOT=~/intel/dpcpp
fi

export CUDA_ROOT="$CONDA_PREFIX/targets/x86_64-linux"

export CUDA_LIB_PATH="$CUDA_ROOT"/lib/stubs

export CMAKE_PREFIX_PATH="$DPCPP_ROOT/tbb/oneapi-tbb-2021.12.0:$CMAKE_PREFIX_PATH"

if [ -z "$TBB_LIBS" ]; then
  tbb_libs=$(ls "$DPCPP_ROOT"/tbb)
  tbb_libs=$DPCPP_ROOT/tbb/$tbb_libs/lib/intel64
  tbb_libs=$tbb_libs/$(ls "$tbb_libs")
  export DPCPP_OCL_DIRS=$DPCPP_ROOT/opencl/runtime/linux/oclcpu/x64
  export DPCPP_OCL_DIRS=$DPCPP_ROOT/opencl/runtime/linux/oclfpgaemu/x64:$DPCPP_OCL_DIRS
  export TBB_LIBS=$tbb_libs
fi

export CC=$CC
export CXX=$CXX

export CXXFLAGS=$CXXFLAGS
export CFLAGS=$CFLAGS

link_path_flags=""
for path in ${TBB_LIBS//:/ }; do
  link_path_flags="-L $path $link_path_flags"
done
for path in ${DPCPP_OCL_DIRS//:/ }; do
  link_path_flags="-L $path $link_path_flags"
done
export EXTRA_LDFLAGS=$link_path_flags
export DPCPP_LD_FLAGS_BACKUP=$LDFLAGS
export LDFLAGS="$link_path_flags $LDFLAGS"

GCC_VERSION=$(ls "$CONDA_PREFIX"/lib/gcc/"$BUILD")
export GCC_VERSION=$GCC_VERSION
export STDCXX_INC_DIR="$CONDA_PREFIX/lib/gcc/$BUILD/$GCC_VERSION/include/c++"
GCC_TOOLCHAIN="$CONDA_PREFIX"
export GCC_TOOLCHAIN=$GCC_TOOLCHAIN
export CMAKE_ARGS="-DCUDAToolkit_ROOT=$CUDA_ROOT -DCUDA_TOOLKIT_ROOT_DIR=$CUDA_ROOT -DCMAKE_SYSROOT=$CONDA_BUILD_SYSROOT -DCMAKE_CXX_STANDARD_INCLUDE_DIRECTORIES='$STDCXX_INC_DIR;$STDCXX_INC_DIR/$BUILD' $CMAKE_ARGS"

ocl_icd_vendors=$OCL_ICD_VENDORS
if [ -f "$CONDA_PREFIX"/etc/conda/deactivate.d/deactivate-opencl-rt.sh ]; then
  source "$CONDA_PREFIX"/etc/conda/deactivate.d/deactivate-opencl-rt.sh
fi
export OCL_ICD_VENDORS=$CONDA_PREFIX/etc/dpcpp/OpenCL/vendors/
mkdir -p "$OCL_ICD_VENDORS"

if [ -d "$ocl_icd_vendors" ]; then
  if [ -d "$ocl_icd_vendors" ]; then
    find "$ocl_icd_vendors" -name "*.icd" -print0 | xargs -I{} -0 ln -sf {} "$OCL_ICD_VENDORS"
    rm -f "$OCL_ICD_VENDORS"/cuda.icd
  fi
  find /etc/OpenCL/vendors/ -name "*.icd" -print0 | xargs -I{} -0 ln -sf {} "$OCL_ICD_VENDORS"

  if [ -d "$DPCPP_ROOT"/etc/OpenCL/vendors ]; then
    find "$DPCPP_ROOT"/etc/OpenCL/vendors -name "*.icd" -print0 | xargs -I{} -0 ln -sf {} "$OCL_ICD_VENDORS"
  fi
fi
