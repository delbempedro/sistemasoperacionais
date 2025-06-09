#!/usr/bin/env bash
set -eou pipefail

source_path=$1

declare -A extensions

process(){

    local path=$1

    for file in "$path"/*; do

        if [[ -d "$file" ]]; then

            process $file

        else

            file_name=$(basename "$file")
            extension="${file_name##*.}"

            if [[ "$extension" != "$file_name" ]]; then

                if [[ -v extensions["$extension"] ]]; then
                    ((extensions["$extension"]++))
                else
                    extensions["$extension"]=1
                fi

            fi
        
        fi

    done
}

process $source_path

for extension in "${!extensions[@]}"; do
    echo " .${extension}: ${extensions[$extension]} "
done