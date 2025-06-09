#!/usr/bin/env bash
set -euo pipefail


# Função que simula as tarefas dos filhos
filho1() {
    echo "Filho 1 $1 (PID $$) iniciado"
    echo "Calculando A..."

    # Simula o trabalho de um filho
    sleep $1
    a="1234"

    echo "$a" >> f1.dat
    echo "1" >> t1.dat
    echo "Calculo de A finalizado"
}
filho2() {
    echo "Filho 2 $1 (PID $$) iniciado"
    echo "Calculando A..."

    # Simula o trabalho de um filho
    sleep $1
    a="5678"

    echo "$a" >> f2.dat
    echo "1" >> t2.dat
    echo "Calculo de  finalizado"
}

filho3() {
    echo "Filho 3 $1 (PID $$) iniciado"
    echo "Calculando A..."

    # Simula o trabalho de um filho
    sleep $1
    a="9123"

    echo "$a" >> f3.dat
    echo "1" >> t3.dat
    echo "Calculo de A finalizado"
}