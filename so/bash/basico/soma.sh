#!/usr/bin/env bash
set -euo pipefail
######################
###### Entrada argumento e soma dois números:
######################
# Uso: soma.sh <num1> <num2>
# Se faltarem argumentos, assume 0.

a=${1:-0}   # primeiro argumento ou 0
b=${2:-0}   # segundo argumento ou 0

echo "Resultado: $(( a + b ))"