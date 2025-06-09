#!/usr/bin/env bash
set -euo pipefail
######################
###### Encontra o maior arquivo em um diretório:
######################

dir="${1:-.}"
[[ -d $dir ]] || { echo "Diretório inválido"; exit 1; }

read -r size file < <(
  find "$dir" -maxdepth 1 -type f -printf '%s %p\n' |
  sort -nr | head -1
)

read -r lsize lfile < <(
  find "$dir" -maxdepth 1 -type f -printf '%s %p\n' |
  sort -n | head -1
)


if [[ -n ${file:-} ]]; then
  echo "Arquivo: ${file##*/} — Tamanho: ${size} bytes"
  echo "Arquivo: ${lfile##*/} — Tamanho: ${lsize} bytes"

else
  echo "Nenhum arquivo regular encontrado."
fi