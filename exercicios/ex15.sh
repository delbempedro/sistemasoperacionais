#!/usr/bin/env bash
set -eou pipefail

source_path=$1
[[ -d "$source_path" ]] || { echo "Invalid path"; exit 1; }

ext1=$2
ext2=$3

for file in "$source_path"/*."$ext1"; do
    output_file="${file%.$ext1}.$ext2"
    convert "$file" "$output_file"
done
