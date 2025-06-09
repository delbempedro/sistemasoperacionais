#!/usr/bin/env bash
set -eou pipefail

directory=$1
[[ -d "$directory" ]] || { echo "Invalid directory"; exit 1; }

biggersize=0
biggerfile=""
smallersize=1000000000000000000000000000000000000000000000000000000000000
smallerfile=""

recursive() {
    local dir="$1"
    for file in "$dir"/*; do

        if [[ -f "$file" ]]; then

            size=$(stat -c%s "$file")
            if (($size>$biggersize)); then
                biggerfile=$file
                biggersize=$size
            fi
            if (($size<$smallersize)); then
                smallerfile=$file
                smallersize=$size
            fi

        elif [[ -d "$file" ]]; then

            recursive "$file"

        fi

    done
}

recursive "$1"

echo "Biggest file is $biggerfile with $biggersize bytes"
echo "Smallest file is $smallerfile with $smallersize bytes"
