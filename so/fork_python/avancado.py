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
    os._exit(0)  # Finaliza o processo filho

def main():
    print(f"[PAI {os.getpid()}] Iniciando criação dos processos filhos...")

    pids = []

    for i in range(1, 4):
        pid = os.fork()
        if pid == 0:
            # Código do filho
            filho(i)
        else:
            # Código do pai
            pids.append(pid)
            print(f"[PAI {os.getpid()}] Filho {i} criado com PID {pid}")

    for pid in pids:
        terminado, _ = os.waitpid(pid, 0)
        print(f"[PAI {os.getpid()}] Detectado término do filho com PID {terminado}")

    print(f"[PAI {os.getpid()}] Todos os filhos finalizaram. FIM.")

if __name__ == "__main__":
    if os.name != "posix":
        print("Este script requer um sistema Unix-like (Linux ou macOS).", file=sys.stderr)
        sys.exit(1)
    main()
