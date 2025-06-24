#!/usr/bin/env bash
set -euo pipefail

# 1. Criar o pipe nomeado com nome temporário
pipe=$(mktemp -u)     # gera um nome temporário
mkfifo "$pipe"        # cria o arquivo FIFO com esse nome

# 2. Abrir o pipe no descritor de leitura (3) e escrita (4)
exec 3<>"$pipe"       # abre para leitura e escrita (bidirecional)
rm "$pipe"            # remove do sistema de arquivos (mas continua funcionando via descritor)


processoA() {
echo "23" >&3   # escreve no pipe (descritor 3)
} 

processoB() {
read x <&3
echo "o valor passado eh $x"
} 

processoA & 
pida=$!
processoB & 
pidb=$!


wait $pida
wait $pidb
echo "Mensagem do processo mestre"