#!/usr/bin/env bash
set -euo pipefail

dir="${1:-.}"
[[ -d $dir ]] || { echo "Diretório inválido"; exit 1; }

max_size=0
max_file=""

# Loop por arquivos no diretório (sem recursão)
for f in "$dir"/*; do
  [[ -f $f ]] || continue
  size=$(stat -c%s "$f")   # BSD/macOS usa -f%z  #linux stat -c%s
  if (( size > max_size )); then
    max_size=$size
    max_file=$f
  fi
done

if [[ -n $max_file ]]; then
  echo "Arquivo: ${max_file##*/} — Tamanho: ${max_size} bytes"
else
  echo "Nenhum arquivo regular encontrado."
fi
