#!/usr/bin/env bash
set -euo pipefail

#
# Antes de qualquer fork, criamos os pipes e abrimos cada um em modo
# de leitura+escrita (<>), para que os descritores sejam herdados pelos filhos.
#

# 1) Cria os pipes nomeados
mkfifo pipe_a pipe_b pipe_c pipe_r1 pipe_r2 pipe_r3

# 2) Abre cada pipe em leitura+escrita (FDs 3,4,5 para A,B,C; 6,7,8 para R1,R2,R3)
#    Dessa forma, o pai mantém um “lado de escrita” aberto mesmo se o filho só
#    for abrir para escrita depois, evitando bloqueio no open().
exec 3<>pipe_a
exec 4<>pipe_b
exec 5<>pipe_c

exec 6<>pipe_r1
exec 7<>pipe_r2
exec 8<>pipe_r3

# 3) Remova os nomes dos pipes do sistema de arquivos (os FDs continuarão válidos)
rm pipe_a pipe_b pipe_c pipe_r1 pipe_r2 pipe_r3

#
#  Agora que cada pipe está aberto nos FDs 3..8, qualquer fork herda esses FDs
#  e, quando o filho fizer “echo ... >&3”, ele escreverá no pipe_a por meio
#  desse mesmo FD. O pai pode ler em “<&3” sem travar no open().
#

# === Funções filhos ===

filho1() {
  echo "Filho 1 (PID $$) iniciado"
  sleep "$1"
  # Escreve no pipe_a via FD 3:
  echo "1253" >&3
  echo "Cálculo de A finalizado"
}

filho2() {
  echo "Filho 2 (PID $$) iniciado"
  sleep "$1"
  # Escreve no pipe_b via FD 4:
  echo "3489" >&4
  echo "Cálculo de B finalizado"
}

filho3() {
  echo "Filho 3 (PID $$) iniciado"
  sleep "$1"
  # Escreve no pipe_c via FD 5:
  echo "2964" >&5
  echo "Cálculo de C finalizado"
}

filho4() {
  echo "Filho 4 (PID $$) iniciado"
  sleep "$1"
  # Escreve no pipe_r1 via FD 6:
  echo $(( $2 + $3 )) >&6
  echo "Cálculo de R1 finalizado"
}

filho5() {
  echo "Filho 5 (PID $$) iniciado"
  sleep "$1"
  # Escreve no pipe_r2 via FD 7:
  echo $(( $2 + $3 )) >&7
  echo "Cálculo de R2 finalizado"
}

filho6() {
  echo "Filho 6 (PID $$) iniciado"
  sleep "$1"
  # Escreve no pipe_r3 via FD 8:
  echo $(( $2 + $3 )) >&8
  echo "Cálculo de R3 finalizado"
}

# === Início do pai ===
echo "Pai (PID $$) iniciando..."

# 4) Iniciar filhos A, B e C (que herdam os FDs 3,4,5 abertos)
filho1 3 & pid1=$!
filho2 1 & pid2=$!
filho3 4 & pid3=$!

# 5) Ler, do pipe A,B e C, os valores produzidos
read -r a <&3
read -r b <&4
read -r c <&5

echo "Pai recebeu: A=$a, B=$b, C=$c"

# 6) Iniciar filhos dependentes (R1, R2 e R3), passando os valores lidos
filho4 2 "$a" "$b" & pid4=$!
filho5 2 "$a" "$c" & pid5=$!
filho6 2 "$b" "$c" & pid6=$!

# 7) Ler, dos pipes finais (R1, R2, R3), os resultados
read -r r1 <&6
read -r r2 <&7
read -r r3 <&8

(( r = r1 + r2 + r3 ))
echo "Resultado final R = $r"

# 8) Esperar todos os filhos terminarem (sinal de término gerará SIGCHLD,
#    mas o pai não ficará travado no `read` pois já abriu os pipes antes)
wait "$pid1" && echo "Pai detectou que Filho 1 terminou"
wait "$pid2" && echo "Pai detectou que Filho 2 terminou"
wait "$pid3" && echo "Pai detectou que Filho 3 terminou"
wait "$pid4" && echo "Pai detectou que Filho 4 terminou"
wait "$pid5" && echo "Pai detectou que Filho 5 terminou"
wait "$pid6" && echo "Pai detectou que Filho 6 terminou"

# 9) Fechar descritores abertos
exec 3<&- 4<&- 5<&- 6<&- 7<&- 8<&-

echo "Pai finalizado. Todos os filhos terminaram."
