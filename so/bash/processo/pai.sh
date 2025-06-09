#!/usr/bin/env bash
set -euo pipefail

echo "Pai (PID $$) iniciando..."

# Iniciar 3 filhos em background
./filho.sh 1 3 &
pid1=$!
./filho.sh 2 2 &
pid2=$!
./filho.sh 3 4 &
pid3=$!

# Esperar os filhos terminarem
wait $pid1
echo "Pai detectou que Filho 1 terminou"

wait $pid2
echo "Pai detectou que Filho 2 terminou"

wait $pid3
echo "Pai detectou que Filho 3 terminou"

echo "Pai finalizado. Todos os filhos terminaram."
