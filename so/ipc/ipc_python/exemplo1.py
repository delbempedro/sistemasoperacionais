#!/usr/bin/env python3
import os
import sys
import time

# Funções que cada filho vão executar
def filho1(fd_write, t):
    """Filho 1: calcula A e escreve no pipe."""
    print(f"Filho 1 (PID {os.getpid()}) iniciado", flush=True)
    time.sleep(t)
    a = 1253
    os.write(fd_write, f"{a}\n".encode())
    print("Cálculo de A finalizado", flush=True)
    sys.exit(0)

def filho2(fd_write, t):
    """Filho 2: calcula B e escreve no pipe."""
    print(f"Filho 2 (PID {os.getpid()}) iniciado", flush=True)
    time.sleep(t)
    b = 3489
    os.write(fd_write, f"{b}\n".encode())
    print("Cálculo de B finalizado", flush=True)
    sys.exit(0)

def filho3(fd_write, t):
    """Filho 3: calcula C e escreve no pipe."""
    print(f"Filho 3 (PID {os.getpid()}) iniciado", flush=True)
    time.sleep(t)
    c = 2964
    os.write(fd_write, f"{c}\n".encode())
    print("Cálculo de C finalizado", flush=True)
    sys.exit(0)

def filho4(fd_write, t, a, b):
    """Filho 4: calcula R1 = a + b e escreve no pipe."""
    print(f"Filho 4 (PID {os.getpid()}) iniciado", flush=True)
    time.sleep(t)
    r1 = a + b
    os.write(fd_write, f"{r1}\n".encode())
    print("Cálculo de R1 finalizado", flush=True)
    sys.exit(0)

def filho5(fd_write, t, a, c):
    """Filho 5: calcula R2 = a + c e escreve no pipe."""
    print(f"Filho 5 (PID {os.getpid()}) iniciado", flush=True)
    time.sleep(t)
    r2 = a + c
    os.write(fd_write, f"{r2}\n".encode())
    print("Cálculo de R2 finalizado", flush=True)
    sys.exit(0)

def filho6(fd_write, t, b, c):
    """Filho 6: calcula R3 = b + c e escreve no pipe."""
    print(f"Filho 6 (PID {os.getpid()}) iniciado", flush=True)
    time.sleep(t)
    r3 = b + c
    os.write(fd_write, f"{r3}\n".encode())
    print("Cálculo de R3 finalizado", flush=True)
    sys.exit(0)

def read_int_from_fd(fd):
    """Lê uma linha do descritor e converte para inteiro."""
    data = b""
    while not data.endswith(b"\n"):
        chunk = os.read(fd, 1)
        if not chunk:
            break
        data += chunk
    try:
        return int(data.decode().strip())
    except ValueError:
        return 0

# Fecha todos os ends de pipes que não serão usados pelo filho
# e fecha a ponta de leitura do pipe que será mantido.
def close_unused(pipes, keep_key):
    for key, (r_fd, w_fd) in pipes.items():
        if key != keep_key:
            # fecha leitura e escrita de pipes não usados
            for fd in (r_fd, w_fd):
                try:
                    os.close(fd)
                except OSError:
                    pass
        else:
            # fecha só a leitura do pipe que será usado
            try:
                os.close(r_fd)
            except OSError:
                pass


def main():
    print(f"Pai (PID {os.getpid()}) iniciando...", flush=True)

    # 1) Criar seis pipes (cada um retorna um par de fds: read_fd, write_fd)
    pipe_a = os.pipe()   # para A
    pipe_b = os.pipe()   # para B
    pipe_c = os.pipe()   # para C
    pipe_r1 = os.pipe()  # para R1
    pipe_r2 = os.pipe()  # para R2
    pipe_r3 = os.pipe()  # para R3

    pipes = {
        'a': pipe_a,
        'b': pipe_b,
        'c': pipe_c,
        'r1': pipe_r1,
        'r2': pipe_r2,
        'r3': pipe_r3
    }

    # 2) Fork dos Filhos 1–3
    pid1 = os.fork()
    if pid1 == 0:
        # Filho 1: só usa write de 'a'
        close_unused(pipes, keep_key='a')
        filho1(pipes['a'][1], 3)

    pid2 = os.fork()
    if pid2 == 0:
        # Filho 2: só usa write de 'b'
        close_unused(pipes, keep_key='b')
        filho2(pipes['b'][1], 1)

    pid3 = os.fork()
    if pid3 == 0:
        # Filho 3: só usa write de 'c'
        close_unused(pipes, keep_key='c')
        filho3(pipes['c'][1], 4)

    # 3) Pai: fecha todas as pontas de escrita de A, B, C
    os.close(pipe_a[1])
    os.close(pipe_b[1])
    os.close(pipe_c[1])

    # 4) Pai lê A, B e C
    a = read_int_from_fd(pipe_a[0])
    b = read_int_from_fd(pipe_b[0])
    c = read_int_from_fd(pipe_c[0])
    print(f"Pai recebeu: A={a}, B={b}, C={c}", flush=True)

    # 5) Fork dos Filhos 4–6
    pid4 = os.fork()
    if pid4 == 0:
        close_unused(pipes, keep_key='r1')
        filho4(pipes['r1'][1], 2, a, b)

    pid5 = os.fork()
    if pid5 == 0:
        close_unused(pipes, keep_key='r2')
        filho5(pipes['r2'][1], 2, a, c)

    pid6 = os.fork()
    if pid6 == 0:
        close_unused(pipes, keep_key='r3')
        filho6(pipes['r3'][1], 2, b, c)

    # 6) Pai fecha pontas de escrita de R1, R2, R3
    os.close(pipe_r1[1])
    os.close(pipe_r2[1])
    os.close(pipe_r3[1])

    # 7) Pai lê R1, R2 e R3
    r1 = read_int_from_fd(pipe_r1[0])
    r2 = read_int_from_fd(pipe_r2[0])
    r3 = read_int_from_fd(pipe_r3[0])
    r = r1 + r2 + r3
    print(f"Resultado final R = {r}", flush=True)

    # 8) Espera todos os filhos
    for pid in (pid1, pid2, pid3, pid4, pid5, pid6):
        os.waitpid(pid, 0)
        print(f"Pai detectou que Filho com PID {pid} terminou", flush=True)

    # 9) Fecha todas as pontas de leitura remanescentes
    for key in pipes:
        try:
            os.close(pipes[key][0])
        except OSError:
            pass

    print("Pai finalizado. Todos os filhos terminaram.", flush=True)

if __name__ == "__main__":
    if os.name != "posix":
        print("Este script requer um sistema Unix-like.", file=sys.stderr)
        sys.exit(1)
    main()