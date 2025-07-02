#!/usr/bin/env python3
import sys
import os
import datetime
import time
from threading import Thread

resultados=[]

def worker(arquivo_origem, pasta_destino, index_thread):

    global resultados

    time = datetime.datetime.now().strftime("%Y-%m-%d_%H-%M-%S")
    nome = os.path.basename(arquivo_origem)
    arquivo_nome = f"{pasta_destino}/{nome}-{time}.tar.gz"

    comand_tar=(f"tar -czf {arquivo_nome} {arquivo_origem} 2> /dev/null")

    status = os.system(comand_tar)
    try:

        if status != 0:
            raise OSError()

        mensagem = f"Success;{nome};{arquivo_nome};"

        resultados[index_thread]=mensagem

    except:

        mensagem = f"Failed;{nome};tar: couldn't read the file: Permission denied;"

        resultados[index_thread]=mensagem
    

def main(lista, destino):
    
    origens=[]
    numero_threads=0
    with open(lista, 'r') as file:
        origens = [line.strip() for line in file]

    numero_threads=len(origens)
    global resultados
    resultados=[None]*numero_threads

    print("Inicia os backups...")
    threads=[]
    for index in range(len(origens)):

        origem = origens[index]
        print(f"Faz o backup {origem}...")
        real_thread = Thread(target=worker, args=(origem, destino, index))

        real_thread.start()

        threads.append(real_thread)

    threads_encerradas=0
    sucessos=[]
    while numero_threads>threads_encerradas:

        print("Verifing...")

        for index in range(len(resultados)):

            resultado = resultados[index]

            if not resultado == None:

                if resultado.split(";")[0] == "Success":
                    print(f"O filho {resultado.split(";")[1]} terminou com sucesso")
                    sucessos.append(resultado.split(";")[-2])
                elif resultado.split(";")[0] == "Failed":
                    print(f"O filho {resultado.split(";")[1]} falhou")
                
                resultados[index] = None

                threads_encerradas+=1

        time.sleep(1)
    
    for thread in threads:
        thread.join()

    print("Os sucessos são:")
    for sucesso in sucessos:
        print(f"    {sucesso}")

if __name__ == "__main__":
    main(sys.argv[1], sys.argv[2])