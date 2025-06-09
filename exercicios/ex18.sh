#!/usr/bin/env bash
set -eou pipefail

days=$1
source_path=$2

backup(){

    local path=$1

    for file in "$path"/*; do

        if [[ -d "$file" ]]; then
            backup $file
        else

            modified_date=$(date -r "$file" +%s)
            actual_date=$(date +%s)
            difference=$(( actual_date - modified_date ))
            modified_days=$(( difference / 86400 ))

            if [[ "$modified_days" -gt "$days" ]]; then
                tar -czf "ex18/$(basename "$file").tar.gz" "$file"
            fi
        fi

    done

}

backup $source_path