#!/usr/bin/env python3

import os
import time
import sys

def tarefa(segundos):
    time.sleep(segundos)

def filho(numero, segundos):
    print(f"Filho {numero} (PID {os.getpid()}) iniciado")
    tarefa(segundos)
    print(f"Filho {numero} (PID {os.getpid()}) finalizado após {segundos} segundos")
    os._exit(0)  # termina o processo filho

def main():
    print(f"Pai (PID {os.getpid()}) iniciando...")

    tempos = [3, 2, 4]
    pids = []

    for i, tempo in enumerate(tempos, 1):
        pid = os.fork()
        if pid == 0:
            # Código executado no filho
            filho(i, tempo)
        else:
            # Código executado no pai
            pids.append((i, pid))

    # Pai espera os filhos terminarem
    for i, pid in pids:
        terminado, _ = os.waitpid(pid, 0)
        print(f"Pai detectou que Filho {i} terminou (PID {terminado})")

    print("Pai finalizado. Todos os filhos terminaram.")

if __name__ == "__main__":
    if os.name != "posix":
        print("Este script requer um sistema Unix-like (Linux, macOS).", file=sys.stderr)
        sys.exit(1)
    main()