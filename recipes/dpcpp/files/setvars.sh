#!/bin/bash
oneapi_dir=$(bash -c "cd -- '$(dirname -- "${BASH_SOURCE[0]}")/..' &>/dev/null && pwd")
export DPCPP_ROOT=$oneapi_dir
export PATH=$DPCPP_ROOT/bin:$PATH

if [ -z "$TBBROOT" ]; then
  tbb_libs=$(ls "$DPCPP_ROOT"/tbb)
  tbb_libs=$DPCPP_ROOT/tbb/$tbb_libs/lib/intel64
  tbb_libs=$tbb_libs/$(ls "$tbb_libs")
  export LD_LIBRARY_PATH=$tbb_libs:$LD_LIBRARY_PATH
  export LD_LIBRARY_PATH=$DPCPP_ROOT/opencl/runtime/linux/oclcpu/x64:$LD_LIBRARY_PATH
  export LD_LIBRARY_PATH=$DPCPP_ROOT/opencl/runtime/linux/oclfpgaemu/x64:$LD_LIBRARY_PATH
  export TBBROOT=$tbb_libs
fi

export LD_LIBRARY_PATH="$DPCPP_ROOT/onemkl/lib:$DPCPP_ROOT/lib:$LD_LIBRARY_PATH"
