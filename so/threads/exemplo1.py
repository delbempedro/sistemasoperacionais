#!/usr/bin/env python3
import sys
import time
from threading import Thread

# Variáveis globais para comunicação entre threads
# Inicializadas como None para serem atribuídas pelas tarefas
A = None
B = None
C = None
R1 = None
R2 = None
R3 = None

# Funções que cada thread vai executar
def tarefa1(t):
    """Thread 1: calcula A e atribui à variável global."""
    global A
    print("Thread 1 iniciado", flush=True)
    time.sleep(t)
    A = 1253
    print("Cálculo de A finalizado", flush=True)


def tarefa2(t):
    """Thread 2: calcula B e atribui à variável global."""
    global B
    print("Thread 2 iniciado", flush=True)
    time.sleep(t)
    B = 3489
    print("Cálculo de B finalizado", flush=True)


def tarefa3(t):
    """Thread 3: calcula C e atribui à variável global."""
    global C
    print("Thread 3 iniciado", flush=True)
    time.sleep(t)
    C = 2964
    print("Cálculo de C finalizado", flush=True)


def tarefa4(t):
    """Thread 4: calcula R1 = A + B e atribui à variável global."""
    global R1, A, B
    print("Thread 4 iniciado", flush=True)
    time.sleep(t)
    R1 = A + B
    print("Cálculo de R1 finalizado", flush=True)


def tarefa5(t):
    """Thread 5: calcula R2 = A + C e atribui à variável global."""
    global R2, A, C
    print("Thread 5 iniciado", flush=True)
    time.sleep(t)
    R2 = A + C
    print("Cálculo de R2 finalizado", flush=True)


def tarefa6(t):
    """Thread 6: calcula R3 = B + C e atribui à variável global."""
    global R3, B, C
    print("Thread 6 iniciado", flush=True)
    time.sleep(t)
    R3 = B + C
    print("Cálculo de R3 finalizado", flush=True)


def main():
    print("Thread mestre iniciando...", flush=True)

    # 1) Iniciar threads 1–3
    t1 = Thread(target=tarefa1, args=(3,))
    t2 = Thread(target=tarefa2, args=(1,))
    t3 = Thread(target=tarefa3, args=(4,))
    t1.start()
    t2.start()
    t3.start()

    # 2) Aguardar término de t1, t2 e t3 para garantir que A, B e C foram atribuídos
    t1.join()
    t2.join()
    t3.join()
    print(f"Mestre recebeu: A={A}, B={B}, C={C}", flush=True)

    # 3) Iniciar threads 4–6
    t4 = Thread(target=tarefa4, args=(2,))
    t5 = Thread(target=tarefa5, args=(2,))
    t6 = Thread(target=tarefa6, args=(2,))
    t4.start()
    t5.start()
    t6.start()

    # 4) Aguardar término de t4, t5 e t6 para garantir que R1, R2 e R3 foram atribuídos
    t4.join()
    t5.join()
    t6.join()
    resultado = R1 + R2 + R3
    print(f"Resultado final R = {resultado}", flush=True)

    print("Thread mestre finalizada. Todas as threads terminaram.", flush=True)

if __name__ == "__main__":
    # Python threads rodam em qualquer plataforma
    main()