#!/usr/bin/env python3
import sys
import os
import datetime
from threading import Thread, Lock

sucessos = []
falhas = []

global_lock = Lock()

def thread(arquivo_origem, pasta_destino):

    global sucessos

    time = datetime.datetime.now().strftime("%Y-%m-%d_%H-%M-%S")
    arquivo_nome = f"{pasta_destino}/{arquivo_origem}-{time}.tar.gz"

    comand_tar=(f"tar -czf {arquivo_nome} {arquivo_origem} 2> /dev/null")

    try:

        nome = arquivo_origem.name
        status = os.system(comand_tar)

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
        origem = [line.strip() for line in file]

    threads=[]
    iniciadas=0
    for origem in origens:

        real_thread = Thread(target=thread, args=(origem, destino))

        real_thread.start()

        threads.append(real_thread)

        iniciadas += 1

    encerradas=0
    sucessos_final=[]
    falhas_final=[]
    while encerradas < iniciadas:

        print("Verifing...")

        for sucesso in sucessos:
            if not sucesso in sucessos_final:
                print(sucesso)
                sucessos_final.append(sucesso)
                encerradas +=1

        for falha in falhas:
            if not falha in falhas_final:
                print(falha)
                falhas_final.append(falha)
                encerradas +=1

        time.sleep(1)
    
    for thread in threads:
        thread.join()

    print("Sucessos:")
    for sucesso in sucessos_final:
        print(sucesso)

if __name__ == "__main__":
    main(sys.argv[1], sys.argv[2])