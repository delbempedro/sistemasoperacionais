#!/usr/bin/env bash
set -euo pipefail

# Variáveis de controle
t1_ok=0
t2_ok=0
t3_ok=0
t4_ok=0
t5_ok=0
t6_ok=0

# Funções filhos 

filho1() {
  echo "Filho 1 (PID $$) iniciado"
  echo "Calculando A ..."
  sleep "$1"
  a=1253
  echo "$a" > f1.dat
  echo "1" > t1.dat
  echo "Cálculo de A finalizado"
}

filho2() {
  echo "Filho 2 (PID $$) iniciado"
  echo "Calculando B ..."
  sleep "$1"
  a=3489
  echo "$a" > f2.dat
  echo "1" > t2.dat
  echo "Cálculo de B finalizado"
}

filho3() {
  echo "Filho 3 (PID $$) iniciado"
  echo "Calculando C ..."
  sleep "$1"
  a=2964
  echo "$a" > f3.dat
  echo "1" > t3.dat
  echo "Cálculo de C finalizado"
}

filho4() {
  echo "Filho 4 (PID $$) iniciado"
  echo "Calculando R1 ..."
  sleep "$1"
  a=$(( $2 + $3 ))
  echo "$a" > f4.dat
  echo "1" > t4.dat
  echo "Cálculo de R1 finalizado"
}

filho5() {
  echo "Filho 5 (PID $$) iniciado"
  echo "Calculando R2 ..."
  sleep "$1"
  a=$(( $2 + $3 ))
  echo "$a" > f5.dat
  echo "1" > t5.dat
  echo "Cálculo de R2 finalizado"
}

filho6() {
  echo "Filho 6 (PID $$) iniciado"
  echo "Calculando R3 ..."
  sleep "$1"
  a=$(( $2 + $3 ))
  echo "$a" > f6.dat
  echo "1" > t6.dat
  echo "Cálculo de R3 finalizado"
}

echo "Pai (PID $$) iniciando..."

# Iniciar 3 filhos iniciais em background
filho1 3 &
pid1=$!
filho2 1 &
pid2=$!
filho3 4 &
pid3=$!

# Loop de controle
while true; do 
  if [[ $t1_ok -eq 0 && -f t1.dat ]]; then
    echo "Filho 1 terminou"
    t1_ok=1
    a=$(cat f1.dat)
  fi  

  if [[ $t2_ok -eq 0 && -f t2.dat ]]; then
    echo "Filho 2 terminou"
    t2_ok=1
    b=$(cat f2.dat)
  fi

  if [[ $t3_ok -eq 0 && -f t3.dat ]]; then
    echo "Filho 3 terminou"
    t3_ok=1
    c=$(cat f3.dat)
  fi

  if [[ $t4_ok -eq 0 && $t1_ok -eq 1 && $t2_ok -eq 1 ]]; then
    echo "Chamando Filho 4"
    t4_ok=1
    filho4 4 "$a" "$b" &
    pid4=$!
  fi  

  if [[ $t5_ok -eq 0 && $t1_ok -eq 1 && $t3_ok -eq 1 ]]; then
    echo "Chamando Filho 5"
    t5_ok=1
    filho5 3 "$a" "$c" &
    pid5=$!
  fi

  if [[ $t6_ok -eq 0 && $t2_ok -eq 1 && $t3_ok -eq 1 ]]; then
    echo "Chamando Filho 6"
    t6_ok=1
    filho6 5 "$b" "$c" &
    pid6=$!
  fi 

  if [[ $t4_ok -eq 1 && $t5_ok -eq 1 && $t6_ok -eq 1 && -f t4.dat && -f t5.dat && -f t6.dat ]]; then
    echo "Todos os filhos terminaram"
    echo "Calculando R final..."
    r1=$(cat f4.dat)
    r2=$(cat f5.dat)
    r3=$(cat f6.dat)
    (( r = r1 + r2 + r3 ))
    echo "R = $r"
    break
  fi  

  sleep 0.5
done

# Esperar todos os filhos
wait $pid1 && echo "Pai detectou que Filho 1 terminou"
wait $pid2 && echo "Pai detectou que Filho 2 terminou"
wait $pid3 && echo "Pai detectou que Filho 3 terminou"
wait $pid4 && echo "Pai detectou que Filho 4 terminou"
wait $pid5 && echo "Pai detectou que Filho 5 terminou"
wait $pid6 && echo "Pai detectou que Filho 6 terminou"

echo "Pai finalizado. Todos os filhos terminaram."
