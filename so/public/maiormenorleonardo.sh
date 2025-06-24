#!/usr/bin/env bash
set -euo pipefail

dir="${1:-.}"
[[ -d $dir ]] || { echo "Diretório inválido"; exit 1; }

max_size=0
max_file=""
min_size=10000
min_file=""


for f in "$dir"/*; do
  [[ -f $f ]] || continue
  size=$(stat -c%s "$f")   # BSD/macOS usa -f%z  #linux stat -c%s
  if (( size > max_size )); then
    max_size=$size
    max_file=$f
  fi
  if (( size < min_size )); then
    min_size=$size
    min_file=$f
  fi
done

if [[ -n $max_file && -n $min_file ]]; then
  echo "Maior arquivo: ${max_file##*/} — Tamanho: ${max_size} bytes"
  echo "Menor arquivo: ${min_file##*/} — Tamanho: ${min_size} bytes"
else
  echo "Nenhum arquivo regular encontrado."
fi

