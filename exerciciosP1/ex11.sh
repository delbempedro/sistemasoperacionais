#!/usr/bin/env bash
set -eou pipefail

source_file=$1
[[ -f "$source_file" ]] || { echo "Invalid file"; exit 1; }

while read -r hash file; do
    
    if [[ -z "$hash" ]]; then
        continue
    fi

    new_hash=$( sha256sum "$file" | awk '{print $1}')
    if [[ "$new_hash" == "$hash" ]]; then
        echo "The hash of file $file is correct"
    else
        echo "The hash of file $file is incorrect"
    fi

done < "$source_file"