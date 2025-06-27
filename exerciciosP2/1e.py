#!/usr/bin/env python3
import sys
import os
import datetime
from threading import Thread, Lock

sucessos = []
falhas = []

global_lock = Lock()

def worker(arquivo_origem, pasta_destino):

    global sucessos

    time = datetime.datetime.now().strftime("%Y-%m-%d_%H-%M-%S")
    nome = os.path.basename(arquivo_origem)
    arquivo_nome = f"{pasta_destino}/{nome}-{time}.tar.gz"

    comand_tar=(f"tar -czf {arquivo_nome} {arquivo_origem} 2> /dev/null")

    status = os.system(comand_tar)
    try:

        if status != 0:
            raise OSError()

        mensagem = f"Success;{nome};{arquivo_nome};"

        with global_lock:
            sucessos.append(mensagem)

    except:

        mensagem = f"Failed;{nome};tar: couldn't read the file: Permission denied;"

        with global_lock:
            falhas.append(mensagem)
    

def main(lista, destino):
    
    origens=[]
    with open(lista, 'r') as file:
        origens = [line.strip() for line in file]

    print("Inicia os backups...")
    threads=[]
    for origem in origens:

        print(f"Faz o backup {origem}...")
        real_thread = Thread(target=worker, args=(origem, destino))

        real_thread.start()

        threads.append(real_thread)

    
    for thread in threads:
        thread.join()

    print("Verifing...")
    for sucesso in sucessos:
        print(f"O filho {sucesso.split(";")[1]} terminou com sucesso")
    for falha in falhas:
        print(f"O filho {falha.split(";")[1]} falhou")

    print("Os sucessos são:")
    for sucesso in sucessos:
        print(sucesso.split(";")[-2])

if __name__ == "__main__":
    main(sys.argv[1], sys.argv[2])