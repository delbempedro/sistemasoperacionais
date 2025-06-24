#!/usr/bin/env bash
set -euo pipefail

echo "PID do processo: $$"
echo "--- Descritores padrão ---"
echo "stdin  (fd 0) → $(readlink /proc/$$/fd/0)"
echo "stdout (fd 1) → $(readlink /proc/$$/fd/1)"
echo "stderr (fd 2) → $(readlink /proc/$$/fd/2)"

echo ""
echo "--- Criando pipe nomeado ---"
pipe=$(mktemp -u)
mkfifo "$pipe"
exec 3<>"$pipe"     # abre bidirecionalmente (leitura e escrita) no descritor 3
rm "$pipe"          # remove o nome do pipe (descritor continua ativo)

echo "Pipe nomeado associado ao descritor 3"
echo ""

# Ver todos os descritores abertos
echo "--- Descritores de arquivos abertos ---"
ls -l /proc/$$/fd

echo ""
echo "--- Escrevendo no descritor 3 (pipe) ---"
(
  echo "Mensagem do processo filho (PID $$)" >&3
  sleep 1
) &

# Lê a mensagem do pipe
read -r msg <&3
echo "[PAI $$] Leu do pipe (fd 3): $msg"

# Fechar o descritor
exec 3>&-
echo "--- Descritor 3 fechado ---"
