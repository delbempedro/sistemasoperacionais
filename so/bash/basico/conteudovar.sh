#!/usr/bin/env bash
set -euo pipefail
######################
######Conteúdo variável:
######################
NOME_sobrenome="Souza"
nomevar="NOME"
echo "$NOME_sobrenome"        # o shell procura a variável NOME_sobrenome
echo "${nomevar}_sobrenome"      # usa NOME e depois concatena "_sobrenome"
var="${nomevar}_sobrenome" 
echo "conteúdo de ${nomevar}_sobrenome = ${!var}"     #apresenta conteúdo da variável