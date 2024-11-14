set -e

if [ -z "$PIXI_GCC_ACTIVE" ]; then
  export CXX="$(which g++)"
  export CC="$(which gcc)"
  export PIXI_GCC_ACTIVE="1"
fi
