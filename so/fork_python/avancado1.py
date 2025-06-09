#!/usr/bin/env python3

import os
import random
import time
import sys

def tarefa(segundos):
    time.sleep(segundos)

def filho(i):
    print(f"[FILHO {i} - PID {os.getpid()}] Iniciado")
    tempo = random.randint(1, 5)
    tarefa(tempo)
    print(f"[FILHO {i} - PID {os.getpid()}] Finalizado após {tempo} segundos")
    os._exit(0)

def main():
    # Captura argumento N ou usa valor padrão 3
    try:
        N = int(sys.argv[1]) if len(sys.argv) > 1 else 3
        if N < 1:
            raise ValueError
    except ValueError:
        print("Uso: ./script.py [número_de_filhos]")
        print("Número de filhos deve ser um inteiro positivo.")
        sys.exit(1)

    print(f"[PAI {os.getpid()}] Iniciando criação de {N} processos filhos...")

    pids = []

    for i in range(1, N + 1):
        pid = os.fork()
        if pid == 0:
            filho(i)
        else:
            pids.append(pid)
            print(f"[PAI {os.getpid()}] Filho {i} criado com PID {pid}")

    for pid in pids:
        terminado, _ = os.waitpid(pid, 0)
        print(f"[PAI {os.getpid()}] Detectado término do filho com PID {terminado}")

    print(f"[PAI {os.getpid()}] Todos os {N} filhos finalizaram. FIM.")

if __name__ == "__main__":
    if os.name != "posix":
        print("Este script requer um sistema Unix-like (Linux ou macOS).", file=sys.stderr)
        sys.exit(1)
    main()
