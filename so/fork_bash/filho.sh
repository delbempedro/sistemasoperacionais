#!/usr/bin/env bash
set -euo pipefail


# Função que simula as tarefas dos filhos
tarefa() {
  sleep $1
  a=$2
  b=$((a+1))
}

echo "Filho $1 (PID $$) iniciado"
tarefa $2 $2
echo "Filho $1 - varival a = $a"
echo "Filho $1 - varival b = $b"
echo "Filho $1 (PID $$) finalizado após $2 segundos"

