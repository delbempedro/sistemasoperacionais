#!/usr/bin/env bash
set -euo pipefail

# Função que simula a tarefa de um filho
tarefa() {
  local tempo=$1
  sleep "$tempo"
}

# Função que representa o corpo do processo filho
filho() {
  local numero=$1
  local tempo=$2
  echo "[FILHO $numero - PID $$] Iniciado"
  tarefa "$tempo"
  echo "[FILHO $numero - PID $$] Finalizado após ${tempo}s"
}

# Função que cria N filhos e armazena os PIDs no vetor
criar_filhos() {
  local num_filhos=$1
  echo "[PAI $$] Iniciando criação de $num_filhos processos filhos..."

  for ((i=1; i<=num_filhos; i++)); do
    (
      tempo=$((RANDOM % 5 + 1))
      filho "$i" "$tempo"
    ) &
    pid=$!
    pids+=("$pid")
    echo "[PAI $$] Filho $i criado com PID $pid"
  done
}

# Função que espera todos os filhos terminarem
esperar_filhos() {
  for pid in "${pids[@]}"; do
    wait "$pid"
    echo "[PAI $$] Detectado término do filho com PID $pid"
  done
  echo "[PAI $$] Todos os filhos finalizaram. FIM."
}

# Programa principal
main() {
  declare -a pids=()
  local num_filhos="${1:-3}"  # padrão: 3 filhos se nenhum argumento for passado

  criar_filhos "$num_filhos"
  esperar_filhos
}

main "$@"
