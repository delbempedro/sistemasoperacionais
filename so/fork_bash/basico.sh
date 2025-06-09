#!/usr/bin/env bash
set -euo pipefail


# Função que simula as tarefas dos filhos
tarefa() {
  sleep $1
}

# Função que simula um processo filho
filho() {
  echo "Filho $1 (PID $$) iniciado"
  tarefa $2
  echo "Filho $1 (PID $$) finalizado após $2 segundos"
}

echo "Pai (PID $$) iniciando..."

# Iniciar 3 filhos em background
filho 1 3 &
pid1=$!
filho 2 2 &
pid2=$!
filho 3 4 &
pid3=$!

# Esperar os filhos terminarem
wait $pid1
echo "Pai detectou que Filho 1 terminou"

wait $pid2
echo "Pai detectou que Filho 2 terminou"

wait $pid3
echo "Pai detectou que Filho 3 terminou"

echo "Pai finalizado. Todos os filhos terminaram."
