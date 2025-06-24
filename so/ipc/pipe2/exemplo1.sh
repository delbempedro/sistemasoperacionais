mkfifo teste.fifo        # cria pipe
echo "mensagem" > teste.fifo    # escreve (bloqueia se ninguém estiver lendo)
cat < teste.fifo         # lê do pipe
