#!/usr/bin/env bash
set -euo pipefail
######################
###### Calcula o fatorial de um número:
######################

fatorial() {
  local n=$1 res=1
  (( n < 0 )) && { echo "Erro: número negativo"; return 1; }
  for (( i=2; i<=n; i++ )); do res=$(( res * i )); done
  echo "$res"
}

if [[ $# -ge 1 ]]; then
  k="$1"
else
  read -p "Digite k (≤10): " k
fi

[[ $k =~ ^[0-9]+$ && k -le 10 ]] || { echo "k inválido"; exit 1; }
fatorial "$k"
