#!/usr/bin/env bash
set -euo pipefail

# 1. Criar o pipe nomeado com nome temporário
pipe=$(mktemp -u)     # gera um nome temporário
mkfifo "$pipe"        # cria o arquivo FIFO com esse nome

# 2. Abrir o pipe no descritor de leitura (3) e escrita (4)
exec 3<>"$pipe"       # abre para leitura e escrita (bidirecional)
rm "$pipe"            # remove do sistema de arquivos (mas continua funcionando via descritor)

# 3. Criar processo filho
(
  echo "Olá do filho com PID $$!" >&3   # escreve no pipe (descritor 3)
  exit 0
) &

# 4. Pai espera o filho
wait
######## facultativo

# 5. Pai lê a mensagem do pipe
read -r mensagem <&3
echo "[PAI $$] Recebeu: \"$mensagem\""

# 6. Fecha os descritores
exec 3>&-