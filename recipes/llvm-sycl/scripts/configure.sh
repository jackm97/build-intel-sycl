#!/bin/bash

set -e

mkdir -p "$SYCL_PROJECT_ROOT/llvm/build"

if [ -d "$SYCL_PROJECT_ROOT/llvm" ]; then
  find "$SYCL_PROJECT_ROOT/llvm" -name "CMakeCache.txt" -exec rm {} ";"
fi

mkdir -p "$SYCL_PROJECT_ROOT/llvm/build/bin"
clangxx_flags="--sysroot=$CONDA_BUILD_SYSROOT --gcc-toolchain=$CONDA_PREFIX --target=$HOST $CXXFLAGS"
clang_flags="--sysroot=$CONDA_BUILD_SYSROOT --gcc-toolchain=$CONDA_PREFIX --target=$HOST $CFLAGS"
echo "$clangxx_flags" >"$SYCL_PROJECT_ROOT/llvm/build/bin/clang++.cfg"
echo "$LDFLAGS" >>"$SYCL_PROJECT_ROOT/llvm/build/bin/clang++.cfg"
echo "$clang_flags" >"$SYCL_PROJECT_ROOT/llvm/build/bin/clang.cfg"
echo "$LDFLAGS" >>"$SYCL_PROJECT_ROOT/llvm/build/bin/clang.cfg"

cd "$SYCL_PROJECT_ROOT/llvm/build"

cmake_cmd="cmake -G Ninja ../llvm $CMAKE_ARGS \
  -DCMAKE_TOOLCHAIN_FILE='$SYCL_PROJECT_ROOT/toolchains/linux.cmake' \
  -DLLVM_HOST_TRIPLE='$HOST' \
  -DLLVM_DEFAULT_TARGET_TRIPLE=$HOST \
  -DLLVM_NATIVE_TOOL_DIR=$SYCL_PROJECT_ROOT/llvm/build/NATIVE/bin \
  -DLLVM_ENABLE_BACKTRACES=ON \
  -DLLVM_ENABLE_DUMP=ON \
  -DLLVM_ENABLE_LIBEDIT=OFF \
  -DLLVM_ENABLE_LIBXML2=FORCE_ON \
  -DLLVM_ENABLE_RTTI=ON \
  -DLLVM_ENABLE_TERMINFO=OFF \
  -DLLVM_ENABLE_ZLIB=FORCE_ON \
  -DLLVM_ENABLE_ZSTD=FORCE_ON \
  -DLLVM_USE_STATIC_ZSTD=FORCE_ON \
  -DLLVM_INCLUDE_UTILS=ON \
  -DLLVM_INSTALL_UTILS=ON \
  -DLLVM_ENABLE_ASSERTIONS=ON \
  -DLLVM_TARGETS_TO_BUILD='X86;NVPTX' \
  -DLLVM_EXPERIMENTAL_TARGETS_TO_BUILD='SPIRV' \
  -DLLVM_EXTERNAL_PROJECTS='sycl;llvm-spirv;opencl;xpti;xptifw;libdevice;sycl-jit' \
  -DLLVM_EXTERNAL_OPENCL_SOURCE_DIR='$SYCL_PROJECT_ROOT/llvm/clang' \
  -DLLVM_EXTERNAL_SYCL_SOURCE_DIR='$SYCL_PROJECT_ROOT/llvm/sycl' \
  -DLLVM_EXTERNAL_LLVM_SPIRV_SOURCE_DIR='$SYCL_PROJECT_ROOT/llvm/llvm-spirv' \
  -DLLVM_EXTERNAL_OPENCL_SOURCE_DIR='$SYCL_PROJECT_ROOT/llvm/opencl' \
  -DLLVM_EXTERNAL_XPTI_SOURCE_DIR='$SYCL_PROJECT_ROOT/llvm/xpti' \
  -DXPTI_SOURCE_DIR='$SYCL_PROJECT_ROOT/llvm/xpti' \
  -DLLVM_ENABLE_PROJECTS='clang;clang-tools-extra;libclc;lld;sycl;llvm-spirv;opencl;xpti;xptifw;libdevice;sycl-jit' \
  -DLLVM_ENABLE_RUNTIMES='compiler-rt;openmp' \
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

echo "$cmake_cmd"

bash -c "$cmake_cmd"
