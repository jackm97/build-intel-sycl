set -e

if [ -z "$DPCPP_ROOT" ]; then
  export DPCPP_ROOT="$HOME/dpcpp"
fi

if [ -z "$PIXI_DPCPP_BUILD_ACTIVE" ]; then
  export PIXI_DPCPP_BUILD_ACTIVE=1
fi
