#!/usr/bin/env bash
set -eou pipefail

pipe=$(mktemp -u)
mkfifo "$pipe"

exec 3<>"$pipe"

rm "$pipe"

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
        echo "Success;$basename;$backupname;" >&3
    else
        echo "Failed;$basename;tar: couldn't read the file: Permission denied" >&3
    fi

}

num_filhos=0
echo "Initializes backups..."
while IFS= read -r linha || [[ -n "$linha" ]]; do

    echo "Do $linha backup..."
    filho $linha $output_dir &
    num_filhos=$((num_filhos+1))

done < $source_list

#exec 3>&- #fecha a boca do pai

finished_filhos=0
sucesses=()    
while IFS=';' read -r status child return; do

    echo "Verifying..."

    finished_filhos=$((finished_filhos+1))
    if [[ "$status" = "Success" ]]; then
        echo "Child $child finished successfuly"
        sucesses+=("$return")
    else
        echo "Child $child finished unsuccessfuly - Permission denied"
    fi

    if [[ $finished_filhos -eq $num_filhos ]] then

        echo "Successes files are:"
        for child in "${sucesses[@]}"; do
            echo "  $child"
        done
        exit
    
    fi

done <&3

