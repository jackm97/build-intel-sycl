#!/bin/bash

set -e

mkdir -p "$PROJECT_ROOT/llvm/build"

if [ -d "$PROJECT_ROOT/llvm" ]; then
  find "$PROJECT_ROOT/llvm" -name "CMakeCache.txt" -exec rm {} ";"
fi

mkdir -p "$PROJECT_ROOT/llvm/build/bin"
mkdir -p "$PROJECT_ROOT/llvm/build/NATIVE/bin"
clangxx_flags="--sysroot=$CONDA_BUILD_SYSROOT --gcc-toolchain=$BUILD_PREFIX --target=$CONDA_TOOLCHAIN_HOST $CXXFLAGS"
clang_flags="--sysroot=$CONDA_BUILD_SYSROOT --gcc-toolchain=$BUILD_PREFIX --target=$CONDA_TOOLCHAIN_HOST $CFLAGS"
echo "$clangxx_flags" >"$PROJECT_ROOT/llvm/build/NATIVE/bin/clang++.cfg"
echo "$LDFLAGS" >>"$PROJECT_ROOT/llvm/build/NATIVE/bin/clang++.cfg"
echo "$clang_flags" >"$PROJECT_ROOT/llvm/build/NATIVE/bin/clang.cfg"
echo "$LDFLAGS" >>"$PROJECT_ROOT/llvm/build/NATIVE/bin/clang.cfg"
echo "$clangxx_flags" >"$PROJECT_ROOT/llvm/build/bin/clang++.cfg"
echo "$LDFLAGS" >>"$PROJECT_ROOT/llvm/build/bin/clang++.cfg"
echo "$clang_flags" >"$PROJECT_ROOT/llvm/build/bin/clang.cfg"
echo "$LDFLAGS" >>"$PROJECT_ROOT/llvm/build/bin/clang.cfg"

if [[ ${CONDA_BUILD_CROSS_COMPILATION:-0} == "1" ]]; then
  export CMAKE_ARGS="-DLLVM_HOST_TRIPLE='$CONDA_TOOLCHAIN_HOST' $CMAKE_ARGS"
fi

cmake_cmd="cmake -G Ninja ../llvm $CMAKE_ARGS \
  -DCMAKE_TOOLCHAIN_FILE='$PROJECT_ROOT/toolchains/linux.cmake' \
  -DLLVM_LIBDIR_SUFFIX='' \
  -DLLVM_ENABLE_BACKTRACES=ON \
  -DLLVM_ENABLE_DUMP=ON \
  -DLLVM_ENABLE_LIBEDIT=OFF \
  -DLLVM_ENABLE_LIBXML2=FORCE_ON \
  -DLLVM_ENABLE_RTTI=ON \
  -DLLVM_ENABLE_ZLIB=FORCE_ON \
  -DLLVM_ENABLE_ZSTD=FORCE_ON \
  -DLLVM_USE_STATIC_ZSTD=FORCE_ON \
  -DLLVM_INCLUDE_UTILS=ON \
  -DLLVM_INSTALL_UTILS=ON \
  -DLLVM_ENABLE_ASSERTIONS=ON \
  -DLLVM_TARGETS_TO_BUILD='X86;NVPTX' \
  -DLLVM_EXPERIMENTAL_TARGETS_TO_BUILD='SPIRV' \
  -DLLVM_EXTERNAL_PROJECTS='sycl;llvm-spirv;opencl;xpti;xptifw;libdevice;sycl-jit' \
  -DLLVM_EXTERNAL_OPENCL_SOURCE_DIR='$PROJECT_ROOT/llvm/clang' \
  -DLLVM_EXTERNAL_SYCL_SOURCE_DIR='$PROJECT_ROOT/llvm/sycl' \
  -DLLVM_EXTERNAL_LLVM_SPIRV_SOURCE_DIR='$PROJECT_ROOT/llvm/llvm-spirv' \
  -DLLVM_EXTERNAL_OPENCL_SOURCE_DIR='$PROJECT_ROOT/llvm/opencl' \
  -DLLVM_EXTERNAL_XPTI_SOURCE_DIR='$PROJECT_ROOT/llvm/xpti' \
  -DXPTI_SOURCE_DIR='$PROJECT_ROOT/llvm/xpti' \
  -DLLVM_ENABLE_PROJECTS='clang;clang-tools-extra;libclc;lld;sycl;llvm-spirv;opencl;xpti;xptifw;libdevice;sycl-jit;compiler-rt;openmp' \
  -DSYCL_BUILD_PI_HIP_PLATFORM='' \
  -DLLVM_BUILD_TOOLS=ON \
  -DSYCL_ENABLE_WERROR=OFF \
  -DCMAKE_INSTALL_PREFIX='$INSTALL_PREFIX' \
  -DSYCL_INCLUDE_TESTS=ON \
  -DLLVM_ENABLE_DOXYGEN=OFF \
  -DLLVM_ENABLE_SPHINX=FALSE \
  -DBUILD_SHARED_LIBS=OFF \
  -DSYCL_ENABLE_XPTI_TRACING=ON \
  -DLLVM_ENABLE_LLD=ON \
  -DXPTI_ENABLE_WERROR=OFF \
  -DSYCL_CLANG_EXTRA_FLAGS='$clangxx_flags' \
  -DSYCL_ENABLE_BACKENDS='opencl;native_cpu;level_zero;cuda' \
  -DSYCL_ENABLE_EXTENSION_JIT=ON \
  -DSYCL_ENABLE_MAJOR_RELEASE_PREVIEW_LIB=ON \
  -DLIBCLC_TARGETS_TO_BUILD='nvptx64--nvidiacl' \
  -DLIBCLC_GENERATE_REMANGLED_VARIANTS=ON \
  -DLIBCLC_NATIVECPU_HOST_TARGET=ON \
  -DLLVM_ENABLE_RTTI=ON"

cd "$PROJECT_ROOT/llvm/build"

bash -c "$cmake_cmd"
