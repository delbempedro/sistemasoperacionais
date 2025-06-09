#!/usr/bin/env bash
set -eou pipefail

source_path=$1
[[ -d "$source_path" ]] || { echo "Invalid path"; exit 1; }
output_file=$2
[[ -f "$output_file" ]] || { echo "Invalid file"; exit 1; }

echo $( ls $source_path )

echo > $output_file
for file in "$source_path"/*; do

    echo $( sha256sum $file ) >> $output_file

done