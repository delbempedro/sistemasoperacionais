#!/usr/bin/env python3
import os
import tempfile
import sys
import time

# 1. Criar o pipe nomeado com nome temporário
pipe_name = tempfile.mktemp()      # gera um nome temporário
os.mkfifo(pipe_name)               # cria o arquivo FIFO com esse nome

# 2. Abrir o pipe para leitura e escrita (bidirecional)
fd = os.open(pipe_name, os.O_RDWR)
# Remove do sistema de arquivos, mas o FIFO continua acessível via descritor
os.remove(pipe_name)

# Funções que simulam os processos A e B
def processoA(write_fd):
    """Escreve '23' no pipe."""
    os.write(write_fd, b"23\n")


def processoB(read_fd):
    """Lê do pipe e exibe o valor recebido."""
    # Lê até \n
    data = b""
    while not data.endswith(b"\n"):
        chunk = os.read(read_fd, 1)
        if not chunk:
            break
        data += chunk
    x = data.decode().strip()
    print(f"o valor passado eh {x}")


def main():
    # Disparar processo A
    pidA = os.fork()
    if pidA == 0:
        processoA(fd)
        os._exit(0)

    # Disparar processo B
    pidB = os.fork()
    if pidB == 0:
        processoB(fd)
        os._exit(0)

    # Esperar ambos os processos terminarem
    os.waitpid(pidA, 0)
    os.waitpid(pidB, 0)

    # Mensagem final do processo mestre
    print("Mensagem do processo mestre")


if __name__ == "__main__":
    main()
