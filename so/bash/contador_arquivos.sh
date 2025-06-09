read -p "tipo do arquivo" arq

cont=$( ls -alh *$arq | wc -l )
echo "Existem $cont arquivos com a extensao $arq"


