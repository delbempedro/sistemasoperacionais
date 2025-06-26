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

    tar -czf "$backupname" "$file"

    echo "The child of $file finished"

}

echo "Initializes backups..."
while IFS= read -r linha || [[ -n "$linha" ]]; do

    echo "Do $linha backup..."
    filho $linha $output_dir &

done < $source_list

wait