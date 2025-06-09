#!/usr/bin/env bash
set -euo pipefail
######################
###### Entrada teclado e soma dois números:
######################
#
###### entrada teclado
read -p "Digite o primeiro número: " a
read -p "Digite o segundo número: " b
a=${a:-0}  # trata Enter vazio
b=${b:-0}  # Se a variável for vazia atribuir 0
echo "Resultado: $(( a + b ))"
