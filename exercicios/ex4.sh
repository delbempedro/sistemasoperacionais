#!/usr/bin/env bash
set -eou pipefail

source_directory=$1
[[ -d "$source_directory" ]] || { echo "Invalid directory"; exit 1; }
destination_directory=$2
[[ -d "$destination_directory" ]] || { echo "Invalid directory"; exit 1; }

base_name=$(basename "$source_directory")

file_name=$destination_directory/${base_name}_$(date +%Y-%m-%d_%H-%M-%S)".gz"

tar -czf "$file_name" "$source_directory"