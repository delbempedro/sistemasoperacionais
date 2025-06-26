#!/usr/bin/env bash
set -eou pipefail

source_list=$1
[[ -f "$source_list" ]] || { echo "Invalidy file"; exit 1; }

output_dir=$2
[[ -d "$output_dir" ]] || { echo "Invalidy directory"; exit 1; }

filho(){

    file=$1
    output_dir=$2
    basename=$(basename "$file")
    backupname=$output_dir/${basename}_$(date +%Y-%m-%d_%H-%M-%S)".tar.gz"

    if tar -czf "$backupname" "$file" 2> /dev/null; then
        echo "Success;$basename;$backupname;"
    else
        echo "Failed;$basename;tar: couldn't read the file: Permission denied"
    fi

}

{
    num_filhos=0
    echo "Initializes backups..." >&2
    while IFS= read -r linha || [[ -n "$linha" ]]; do

        echo "Do $linha backup..." >&2
        filho $linha $output_dir &
        num_filhos=$((num_filhos+1))

    done < $source_list

    wait
} | {
    finished_filhos=0
    sucesses=()    
    while IFS=';' read -r status child return; do

        echo "Verifying..." >&2

        finished_filhos=$((finished_filhos+1))
        if [[ "$status" = "Success" ]]; then
            echo "Child $child finished successfuly" >&2
            sucesses+=("$return")
        else
            echo "Child $child finished unsuccessfuly - Permission denied" >&2
        fi

    done

    echo "Successes files are:"
    for child in "${sucesses[@]}"; do
        echo $child
    done

}

