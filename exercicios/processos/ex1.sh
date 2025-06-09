#!/usr/bin/env bash
set -eou pipefail

tarefa(){
    sleep $1
}

filho(){
    echo "Filho $1 (PID $$) iniciado"
    tarefa $2
    echo "Filho $1 (PID $$) finalizado após $2 segundos"
}

filho 1 3 &
pid1=$!
filho 2 2 &
pid2=$!
filho 3 4 &
pid3=$!
filho 4 3 &
pid4=$!
filho 5 1 &
pid5=$!


wait $pid1
echo "Pai detectou que Filho 1 terminou"

wait $pid2
echo "Pai detectou que Filho 2 terminou"

wait $pid3
echo "Pai detectou que Filho 3 terminou"

wait $pid4
echo "Pai detectou que Filho 4 terminou"

wait $pid5
echo "Pai detectou que Filho 5 terminou"

echo "Pai finalizado. Todos os filhos terminaram."