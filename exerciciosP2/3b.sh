#!/usr/bin/env bash
set -eou pipefail

diretorio=$1

arquivo_destino=$2

mkdir -p /tmp/backup/

[[ -d "$diretorio" ]] || { echo "Diretório $diretorio inválido"; exit 1; }

filho(){

    file=$1
    arquivo_destino=$2

    hash=$(sha256sum "$file")

    name=$(basename $file)

    echo "$hash" > /tmp/backup/$name
}

#apaga a versão anterior do diretório
rm -f $arquivo_destino

numero_filhos=0
for file in "$diretorio"/*; do

    filho $file $arquivo_destino &

    numero_filhos=$((numero_filhos+1))

done

filhos_encerrados=0
while (( $filhos_encerrados < $numero_filhos )); do

    for file in /tmp/backup/*; do

        echo "Verificando..."

        if [[ -f $file ]] then

            mensagem=$(cat $file)

            filho_encerrado=$mensagem

            echo "O filho $mensagem terminou"

            echo $mensagem >> $arquivo_destino

            filhos_encerrados=$((filhos_encerrados+1))

            rm $file

        fi

        sleep 1

    done

    echo "Todos os filhos terminaram"

done

wait