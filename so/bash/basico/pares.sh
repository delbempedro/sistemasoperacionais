#!/usr/bin/env bash
set -euo pipefail
######################
###### MOstra os números pares até N:
######################

if [[ $# -ge 1 ]]; then
  N="$1"
else
  read -p "Digite N: " N
fi

[[ $N =~ ^[0-9]+$ ]] || { echo "N deve ser inteiro não-negativo"; exit 1; }

for i in $(seq 0 2 "$N"); do
  printf "%d " "$i"
done
echo
