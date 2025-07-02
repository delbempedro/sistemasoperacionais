#!/usr/bin/env bash
set -eou pipefail

diretorio=$1

arquivo_destino=$2

[[ -d "$diretorio" ]] || { echo "Diretório $diretorio inválido"; exit 1; }

filho(){

    file=$1
    arquivo_destino=$2

    hash=$(sha256sum "$file")

    echo "$hash" >> $arquivo_destino

}

#apaga a versão anterior do diretório
rm -f $arquivo_destino

for file in "$diretorio"/*; do

    echo "O filho $file começou"

    filho $file $arquivo_destino &

done

wait

echo "Todos os filhos terminaram"