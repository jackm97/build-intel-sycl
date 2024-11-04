#!/usr/bin/env bash

set -e

find "$PIXI_PROJECT_ROOT"/recipes -wholename "*/scripts/*.sh" -type f -print0 | xargs -0 chmod +x

rm -rf "$DPCPP_ROOT"/scripts
mkdir -p "$DPCPP_ROOT"
