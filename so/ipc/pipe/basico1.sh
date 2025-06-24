#!/usr/bin/env bash
set -euo pipefail


processoA() {
echo "23"
} 

processoB() {
read x
echo "o valor passado eh $x"
} 

processoA | processoB & 

echo "Mensagem do processo mestre"