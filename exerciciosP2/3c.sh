#!/usr/bin/env bash
set -eou pipefail

diretorio=$1
arquivo_destino=$2

pipe=$(mktemp -u)
mkfifo "$pipe"

exec 3<>"$pipe"

rm "$pipe"

filho(){

    file=$1

    sha256sum $file >&3

}

rm -f $arquivo_destino

numero_filhos=0
for file in "$diretorio"/*; do

    echo "O filho $file começou"
    filho $file &

    numero_filhos=$((numero_filhos+1))

done

filhos_encerrados=0
while IFS="  " read -r hash filho; do

    echo "Checando..."

    filhos_encerrados=$((filhos_encerrados+1))
    echo "O filho $filho terminou"
    echo $hash $filho >> $arquivo_destino

    if [[ $filhos_encerrados -eq $numero_filhos ]]; then
    
        echo "Todos os filhos terminaram"
        exit

    fi

    sleep 1

done <&3