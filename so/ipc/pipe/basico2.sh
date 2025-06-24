#!/usr/bin/env bash
set -euo pipefail
pipe=fifo_teste

# cria e remove se já existir
[[ -p $pipe ]] || mkfifo $pipe

processoA() {
echo "23" > $pipe   
} 

processoB() {
read x < $pipe
echo "o valor passado eh $x"
} 

processoA & 
pida=$!
processoB & 
pidb=$!


wait $pida
wait $pidb
echo "Mensagem do processo mestre"


