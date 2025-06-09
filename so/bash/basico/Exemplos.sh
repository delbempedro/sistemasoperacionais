######################################
Tutorial de Bash com exemplos:
######################################


############################### exemplo 1

#!/usr/bin/env bash
set -euo pipefail
######################
######Hello world:
######################
NOME="usuário"
echo "Olá, ${NOME}!"      #${var} apresenta o conteúdo de var como string


############################### exemplo 2

#!/usr/bin/env bash
set -euo pipefail
######################
######Conteúdo variável:
######################
NOME_sobrenome="Souza"
nomevar="NOME"
echo "$NOME_sobrenome"        # o shell procura a variável NOME_sobrenome
echo "${nomevar}_sobrenome"      # usa NOME e depois concatena "_sobrenome"
var="${nomevar}_sobrenome" 
echo "conteúdo de ${nomevar}_sobrenome = ${!var}"     #apresenta conteúdo da variável

############################### exemplo 3

#!/usr/bin/env bash
set -euo pipefail
######################
###### Entrada teclado e soma dois números:
######################
#
###### entrada teclado
read -p "Digite o primeiro número: " a
read -p "Digite o segundo número: " b
a=${a:-0}  # trata Enter vazio
b=${b:-0}  # Se a variável for vazia atribuir 0
echo "Resultado: $(( a + b ))"



############################### exemplo 4

#!/usr/bin/env bash
set -euo pipefail
######################
###### Entrada argumento e soma dois números:
######################
# Uso: soma.sh <num1> <num2>
# Se faltarem argumentos, assume 0.

a=${1:-0}   # primeiro argumento ou 0
b=${2:-0}   # segundo argumento ou 0

echo "Resultado: $(( a + b ))"


############################### exemplo 5

#!/usr/bin/env bash
set -euo pipefail
######################
###### MOstra os números pares até N:
######################

if [[ $# -ge 1 ]]; then
  N="$1"
else
  read -p "Digite N: " N
fi

[[ $N =~ ^[0-9]+$ ]] || { echo "N deve ser inteiro não-negativo"; exit 1; }

for i in $(seq 0 2 "$N"); do
  printf "%d " "$i"
done
echo


############################### exemplo 6

#!/usr/bin/env bash
set -euo pipefail
######################
###### Calcula o fatorial de um número:
######################

fatorial() {
  local n=$1 res=1
  (( n < 0 )) && { echo "Erro: número negativo"; return 1; }
  for (( i=2; i<=n; i++ )); do res=$(( res * i )); done
  echo "$res"
}

if [[ $# -ge 1 ]]; then
  N="$1"
else
  read -p "Digite k (≤10): " k
fi

[[ $k =~ ^[0-9]+$ && k -le 10 ]] || { echo "k inválido"; exit 1; }
fatorial "$k"

############################### exemplo 7

#!/usr/bin/env bash
set -euo pipefail

dir="${1:-.}"
[[ -d $dir ]] || { echo "Diretório inválido"; exit 1; }

max_size=0
max_file=""

# Loop por arquivos no diretório (sem recursão)
for f in "$dir"/*; do
  [[ -f $f ]] || continue
  size=$(stat -f%z "$f")   # BSD/macOS usa -f%z  #linux stat -c%s
  if (( size > max_size )); then
    max_size=$size
    max_file=$f
  fi
done

if [[ -n $max_file ]]; then
  echo "Arquivo: ${max_file##*/} — Tamanho: ${max_size} bytes"
else
  echo "Nenhum arquivo regular encontrado."
fi


############################### exemplos variaveis do sistema

franky ~> whoami
franky

franky ~> echo $USER
franky

franky ~> pwd
/home/franky

franky ~> cd /tmp
franky tmp> echo $OLDPWD
/home/franky

franky tmp> echo $PWD
/tmp

franky tmp> ls &
[1] 11234
franky tmp> echo $!
11234                # PID do último processo rodado em background

franky tmp> sleep 30 &
[2] 11235
franky tmp> jobs
[1]-  Running                 ls &
[2]+  Running                 sleep 30 &

franky tmp> kill %2
[2]+  Terminated              sleep 30

franky tmp> echo $_
30                  # último argumento do comando anterior (sleep 30)

franky tmp> echo $#
0                   # número de argumentos passados ao script (aqui: nenhum)

franky tmp> echo $$
11233               # PID do shell atual

franky tmp> echo $?
0                   # código de saída do último comando (echo foi bem-sucedido)

franky tmp> false
franky tmp> echo $?
1                   # false sempre retorna código 1

franky tmp> true
franky tmp> echo $?
0                   # true sempre retorna 0

franky tmp> echo $RANDOM
23784               # número aleatório entre 0 e 32767

franky tmp> echo $UID
1000                # ID do usuário franky

franky tmp> echo $HOME
/home/franky

franky tmp> echo $PATH
/usr/local/bin:/usr/bin:/bin:...

franky tmp> echo $HOSTNAME
franky-pc
