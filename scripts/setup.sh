#!/usr/bin/env bash

set -e

sudo mkdir -p $SYCL_INSTALL_PREFIX
sudo chown $USER -R $SYCL_INSTALL_PREFIX

rm -rf $SYCL_INSTALL_PREFIX/setvars.sh
touch $SYCL_INSTALL_PREFIX/setvars.sh

script_dir_string='oneapi_dir=$(cwd=$PWD && cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd && cd $cwd)'
echo "#!/bin/bash" | tee $SYCL_INSTALL_PREFIX/setvars.sh
echo $script_dir_string | tee -a $SYCL_INSTALL_PREFIX/setvars.sh

# unset PIXI_ENVIRONMENT_NAME
# rm -rf $SYCL_INSTALL_PREFIX/pixi.*
# rm -rf $SYCL_INSTALL_PREFIX/.pixi
# pixi init $SYCL_INSTALL_PREFIX
# source "$(pixi shell-hook --manifest-path $SYCL_INSTALL_PREFIX/pixi.toml)"
# pixi add cmake python ninja ocl-icd ocl-icd-system cuda "sysroot_linux-64>=2.28" git clinfo glib libstdcxx clangxx_linux-64 clang_linux-64
# echo 'source "$(pixi shell-hook --manifest-path $SYCL_INSTALL_PREFIX/pixi.toml)"' | tee -a $SYCL_INSTALL_PREFIX/setvars.sh

echo 'export PATH=$oneapi_dir/bin:$PATH' | tee -a "$SYCL_INSTALL_PREFIX"/setvars.sh
echo 'export LD_LIBRARY_PATH=$oneapi_dir/lib:$LD_LIBRARY_PATH' | tee -a "$SYCL_INSTALL_PREFIX"/setvars.sh

find "$PIXI_PROJECT_ROOT"/scripts -name "*.sh" -type f -print0 | xargs -0 chmod +x
