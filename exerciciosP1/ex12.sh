#!/usr/bin/env bash
set -eou pipefail

path1=$1
[[ -d "$path1" ]] || { echo "Invalid path"; exit 1; }
path2=$2
[[ -d "$path2" ]] || { echo "Invalid path"; exit 1; }

for file1 in "$path1"/*; do

    name_file1=$(basename "$file1")

    for file2 in "$path2"/*; do

        name_file2=$(basename "$file2")

        if [[ "$name_file1" == "$name_file2" ]]; then
            echo "File $name_file1 is duplicated"
        fi

    done

done