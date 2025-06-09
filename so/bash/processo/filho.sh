#!/usr/bin/env bash
set -euo pipefail


# Função que simula as tarefas dos filhos
tarefa() {
  sleep $1
}

echo "Filho $1 (PID $$) iniciado"
tarefa $2 $2
echo "Filho $1 (PID $$) finalizado após $2 segundos"

