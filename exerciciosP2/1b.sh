#!/usr/bin/env bash
set -eou pipefail

source_list=$1
[[ -f "$source_list" ]] || { echo "Invalidy file"; exit 1; }

output_dir=$2
[[ -d "$output_dir" ]] || { echo "Invalidy directory"; exit 1; }

mkdir -p /tmp/backup/

filho(){

    file=$1
    output_dir=$2
    basename=$(basename "$file")
    backupname=$output_dir/${basename}_$(date +%Y-%m-%d_%H-%M-%S)".tar.gz"

    feedbackname="/tmp/backup/$basename.log"

    if tar -czf "$backupname" "$file" 2> /dev/null; then
        echo "Success;$basename;$backupname;" > $feedbackname
    else
        echo "Failed;$basename;tar: couldn't read the file: Permission denied" > $feedbackname
    fi

}

num_filhos=0
echo "Initializes backups..."
while IFS= read -r linha || [[ -n "$linha" ]]; do

    echo "Do $linha backup..."
    filho $linha $output_dir &
    num_filhos=$((num_filhos+1))

done < $source_list

finished_filhos=0
sucesses=()
while (( num_filhos > finished_filhos )); do

    echo "Verifying..."

    for report_file in /tmp/backup/*.log; do

        if [[ -f "$report_file" ]] then

            finished_filhos=$((finished_filhos+1))
            IFS=';' read -r status child return < "$report_file"
            if [[ "$status" = "Success" ]]; then
                echo "Child $child finished successfuly"
                sucesses+=("$return")
            else
                echo "Child $child finished unsuccessfuly - Permission denied"
            fi
            rm $report_file

        fi

    done

    sleep 1

done

echo "Seccesses files are:"
for child in "${sucesses[@]}"; do
    echo $child
done

wait