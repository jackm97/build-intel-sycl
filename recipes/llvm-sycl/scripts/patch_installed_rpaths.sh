#!/bin/bash

set -e

# Function to process ELF binaries
echo "Removing conda prefix from RPATHs using patchelf..."

# Find all files under the PREFIX directory
files="$(find "$INSTALL_PREFIX" -type f -exec echo {} ";")"

for file in $files; do
  bash "$PROJECT_ROOT"/recipes/llvm-sycl/scripts/process_binary.sh "$file"
done

echo "Done."

rm -rf "$PROJECT_ROOT/.cache/patch-rpaths"
