#!/usr/bin/env bash
set -eou pipefail

source_file=$1
[[ -f "$source_file" ]] || { echo "Invalidy file"; exit 1; }
destination_directory=$2
[[ -d "$destination_directory" ]] || { echo "Invalidy directory"; exit 1; }

for source_directory in $(cat "$source_file"); do 
    echo "$source_directory"
    base_name=$(basename "$source_directory")

    file_name=$destination_directory/${base_name}_$(date +%Y-%m-%d_%H-%M-%S)".gz"

    tar -czf "$file_name" "$source_directory"

done