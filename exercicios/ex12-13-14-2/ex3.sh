#!/usr/bin/env bash
set -eou pipefail

directory=$1
[[ -d "$directory" ]] || { echo "Invalid directory"; exit 1; }


find "$directory" -type d | while read -r current_dir; do

    echo "Directory $current_dir"

    biggersize=0
    biggerfile=""
    smallersize=1000000000000000000000000000000000000000000000000000000000000
    smallerfile=""

    for file in "$current_dir"/*; do

        [[ -f "$file" ]] || continue

        size=$(stat -c%s "$file")
        if (($size>$biggersize)); then
            biggerfile=$file
            biggersize=$size
        fi
        if (($size<$smallersize)); then
            smallerfile=$file
            smallersize=$size
        fi

    done

    if [[ -z "$biggerfile" ]] then
        echo "  Is nothing there"
    else
        echo "  Biggest file is $biggerfile with $biggersize bytes"
        echo "  Smallest file is $smallerfile with $smallersize bytes"
    fi

done
