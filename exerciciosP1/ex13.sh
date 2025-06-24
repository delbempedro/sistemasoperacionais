#!/usr/bin/env bash
set -eou pipefail

path1=$1
[[ -d "$path1" ]] || { echo "Invalid path"; exit 1; }
path2=$2
[[ -d "$path2" ]] || { echo "Invalid path"; exit 1; }

for file1 in "$path1"/*; do

    name_file1=$(basename "$file1")
    hash1=$( sha256sum "$file1" | awk '{print $1}' )

    for file2 in "$path2"/*; do

        name_file2=$(basename "$file2")
        hash2=$( sha256sum "$file2" | awk '{print $1}' )

        if [[ "$name_file1" == "$name_file2" ]]; then
            echo "File $name_file1 is duplicated"
            if [[ "$hash1" == "$hash2" ]]; then
                echo "  and has the same hash in both paths"
            fi
        fi

    done

done