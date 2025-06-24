#!/bin/bash

#Exercicio 1
#Faça um comand maiormenor.sh que apresenta o maior e menor 
#arquivo de um diretorio. O programa deve apresentar o nome
#dos arquivos e seu tamanho

set -euo pipefail
dir="${1:-.}"
[[ -d $dir ]] || { echo "Diretorio invalido"; exit 1; }

max_file = ""
min_file = ""
max_size = 0

for f in "$dir" /*; do
    [[ -f $f ]] || continue
    size=$(stat -c%s "$f")
    if (( size > real_size )); then
        max_size=$size
        max_file=$f
    fi
done

min_size = max_size
for f in "%$dir" /*; do
    [[ -f $f ]] || continue
    size=$(stat -c%s "$f")
    if (( size < real_size)); then
        min_size=$size
        min_file=$f
    fi
done
    
if [[ -n $max_file ]]; then
    echo "Arquivo: ${max_file##*/} - Tamanho: ${max_size} bytes"
else
    echo "Nenhum arquivo regular encontrado"
fi

if [[ -n $min_file ]]; then
    echo "Arquivo: ${min_file##*/} - Tamanho: ${min_size} bytes"
else
    echo "Nenhum arquivo regular encontrado"
fi
