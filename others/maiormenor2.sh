#!/usr/bin/env bash
set -euo pipefail

diretory="${1:-.}"
[[ -d "$diretory" ]] || { echo "Invalid directory"; exit 1; }

biggersize=0
biggerfile=""
smallersize=100000000000000000
smallerfile=""

recursive() {
    local dir="$1"
    for file in "$dir"/*; do

        if [[ -f "$file" ]]; then

            size=$(stat -c%s "$file")
            if (( size > biggersize )); then
                biggerfile="$file"
                biggersize=$size
            fi
            if (( size < smallersize )); then
                smallerfile="$file"
                smallersize=$size
            fi
            
        elif [[ -d "$file" ]]; then
            recursive "$file"
        fi

    done
}

recursive "$diretory"

echo "Bigger file: $biggerfile ($biggersize bytes)"
echo "Smaller file: $smallerfile ($smallersize bytes)"
