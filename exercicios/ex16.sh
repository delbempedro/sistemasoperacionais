#!/usr/bin/env bash
set -eou pipefail

source_path=$1

for file in "$source_path"/*; do

    new_named_file="${file// /_}"
    mv "$file" "$new_named_file"

done