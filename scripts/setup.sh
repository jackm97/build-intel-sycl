#!/usr/bin/env bash

sudo mdkir -p $SYCL_INSTALL_PREFIX
sudo chown -R $SYCL_INSTALL_PREFIX
rm $SYCL_INSTALL_PREFIX/setvars.sh
touch $SYCL_INSTALL_PREFIX/setvars.sh

script_dir_string='oneapi_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)'

echo $script_dir_string | tee $SYCL_INSTALL_PREFIX/setvars.sh

echo 'export PATH=$oneapi_dir/bin:$PATH' | tee -a "$SYCL_INSTALL_PREFIX"/setvars.sh
echo 'export LD_LIBRARY_PATH=$oneapi_dir/lib:$LD_LIBRARY_PATH' | tee -a "$SYCL_INSTALL_PREFIX"/setvars.sh

find "$PIXI_PROJECT_ROOT"/scripts -name "*.sh" -type f -print0 | xargs -0 chmod +x
