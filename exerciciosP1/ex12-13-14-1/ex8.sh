#!/usr/bin/env bash
set -eou pipefail

file_source=$1
[[ -f "$file_source" ]] || { echo "Invalid file"; exit 1; }
destination_file=$2
[[ -f "$destination_file" ]] || { echo "Invalid file"; exit 1; }

echo "LOG FILE:" > $destination_file

for url in $(cat "$file_source"); do

    echo "$url:" >> $destination_file
    echo "Time of process:" >> $destination_file
    status=$(TIMEFORMAT='%S'; { time curl -s -o /dev/null -w "%{http_code}" "$url" ; } 2>> $destination_file)

    date=$(date +%Y-%m-%d_%H-%M-%S)
    echo "Date: $date" >> $destination_file
    if [[ $status -ge 200 && $status -lt 400 ]]; then
        echo "The site $url is active (Status Code: $status)" >> $destination_file
    else
        echo "The site $url is inactive (Status Code: $status)" >> $destination_file
    fi

done