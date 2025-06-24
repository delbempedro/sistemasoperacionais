#!/usr/bin/env bash
set -eou pipefail

directory=$1
[[ -d "$directory" ]] || { echo "Invalid directory"; exit 1; }

biggersize=0
biggerfile=""
smallersize=1000000000000000000000000000000000000000000000000000000000000
smallerfile=""

for file in "$directory"/*; do

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

echo "Biggest file is $biggerfile with $biggersize bytes"
echo "Smallest file is $smallerfile with $smallersize bytes"
