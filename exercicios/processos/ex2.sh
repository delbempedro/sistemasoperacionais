#!/usr/bin/env bash
set -eou pipefail

tarefa(){
    local tempo=$1
    sleep $tempo
}

filho(){
    local tempo=$1
    local numero=$2
    local mensagem=$3
    echo "Filho $numero (PID $$) iniciado"
    tarefa $tempo
    echo "Filho $numero (PID $$) finalizado após $tempo segundos"
    echo $mensagem
}

criar_filhos(){
    local numero_de_filhos=$1
    for ((i=1; i<=numero_de_filhos; i++)); do

        echo "[PAI $$] Iniciando criação de $numero_de_filhos processos filhos..."
        (
        tempo=$((RANDOM % 5 + 1))
        filho "$i" "$tempo" "Mensagem para o filho $i "
        ) &
        pid=$!
        pids+=("$pid")
        echo "[PAI $$] Filho $i criado com PID $pid"

    done

}

esperar_filhos() {
    for pid in "${pids[@]}"; do
        wait "$pid"
        echo "[PAI $$] Detectado término do filho com PID $pid"
    done
    echo "[PAI $$] Todos os filhos finalizaram. FIM."
}

main() {
    declare -a pids=()
    local num_filhos="${1:-3}"  # padrão: 3 filhos se nenhum argumento for passado

    criar_filhos "$num_filhos"
    esperar_filhos
}

main "$@"