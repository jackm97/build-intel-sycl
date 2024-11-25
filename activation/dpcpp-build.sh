set -e

if [ -z "$DPCPP_ROOT" ]; then
  export DPCPP_ROOT="$HOME/dpcpp"
fi

if [ -z "$PIXI_DPCPP_BUILD_ACTIVE" ]; then
  export CMAKE_PREFIX_PATH="$SYCL_PROJECT_ROOT/llvm/build/lib/cmake:$CMAKE_PREFIX_PATH"
  export PIXI_DPCPP_BUILD_ACTIVE=1
fi
