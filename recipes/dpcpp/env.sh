#!/bin/bash

set -e

export DPCPP_HOME=$PIXI_PROJECT_ROOT

if [ -z "$DPCPP_ROOT" ]; then
  export DPCPP_ROOT=~/intel/dpcpp
fi

export ONEMKL_ROOT=$DPCPP_ROOT/onemkl

# for script in "$CONDA_PREFIX"/etc/conda/deactivate.d/deactivate-g*; do source "$script"; done
# for script in "$CONDA_PREFIX"/etc/conda/deactivate.d/deactivate-binutils*; do source "$script"; done
# for script in "$CONDA_PREFIX"/etc/conda/activate.d/activate-clang*; do source "$script"; done
export CUDA_ROOT="$CONDA_PREFIX/targets/x86_64-linux"
# for name in $(find "$CUDA_ROOT/" -print0 | xargs -0 echo); do
#   if [[ "$name" = *"$CUDA_ROOT/bin"* ]]; then
#     continue
#   fi
#   stripped_name=${name##"$CUDA_ROOT/"}
#   if [ "$stripped_name" = "" ]; then
#     continue
#   fi
#   if [ -d "$name" ]; then
#     mkdir -p "$CONDA_PREFIX"/"$stripped_name"
#   else
#     ln -sf "$name" "$CONDA_PREFIX"/"$stripped_name"
#   fi
# done

export PATH="$CONDA_PREFIX"/bin:$PATH
export CUDA_LIB_PATH="$CUDA_ROOT"/lib/stubs
export LD_LIBRARY_PATH="$CONDA_PREFIX"/lib:"$CUDA_ROOT"/lib/stubs:"$LD_LIBRARY_PATH"

export CMAKE_PREFIX_PATH="$DPCPP_ROOT/tbb/oneapi-tbb-2021.12.0:$CMAKE_PREFIX_PATH"

if [ -d "$DPCPP_ROOT"/tbb ]; then
  tbb_libs="$(ls "$DPCPP_ROOT"/tbb)"
  tbb_libs="$DPCPP_ROOT/tbb/$tbb_libs/lib/intel64"
  tbb_libs="$tbb_libs/$(ls "$tbb_libs")"
  export LD_LIBRARY_PATH=$tbb_libs:$LD_LIBRARY_PATH
  export LD_LIBRARY_PATH=$DPCPP_ROOT/opencl/runtime/linux/oclcpu/x64:$LD_LIBRARY_PATH
  export LD_LIBRARY_PATH=$DPCPP_ROOT/opencl/runtime/linux/oclfpgaemu/x64:$LD_LIBRARY_PATH
  export TBBROOT=$tbb_libs
fi

# export CC=$CONDA_BACKUP_CC
# export CXX=$CONDA_BACKUP_CXX
export CC=$CC
export CXX=$CXX
# export CXX_COMPILER=$CXX
# export C_COMPILER=$CC

# export CXXFLAGS=$CONDA_BACKUP_CXXFLAGS
# export CFLAGS=$CONDA_BACKUP_CFLAGS
export CXXFLAGS=$CXXFLAGS
export CFLAGS=$CFLAGS

link_path_flags=""
for path in ${LD_LIBRARY_PATH//:/ }; do
  link_path_flags="$link_path_flags -L $path"
done
export EXTRA_LDFLAGS=$link_path_flags
export LDFLAGS="$LDFLAGS $link_path_flags"

GCC_VERSION=$(ls "$CONDA_PREFIX"/lib/gcc/"$BUILD")
export GCC_VERSION=$GCC_VERSION
export STDCXX_INC_DIR="$CONDA_PREFIX/lib/gcc/$BUILD/$GCC_VERSION/include/c++"
GCC_TOOLCHAIN="$CONDA_PREFIX"
export GCC_TOOLCHAIN=$GCC_TOOLCHAIN
# cxxflags="--sysroot=$CONDA_BUILD_SYSROOT -isystem $STDCXX_INC_DIR -isystem $STDCXX_INC_DIR/$BUILD $CXXFLAGS"
# export CXXFLAGS=$cxxflags
#  -DCMAKE_SYSROOT=$CONDA_BUILD_SYSROOTexport CMAKE_ARGS="-DCUDAToolkit_ROOT=$CUDA_ROOT -DCUDA_TOOLKIT_ROOT_DIR=$CUDA_ROOT -DCMAKE_SYSROOT=$CONDA_BUILD_SYSROOT $CONDA_BACKUP_CMAKE_ARGS"
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
