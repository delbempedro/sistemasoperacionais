#!/usr/bin/env python3
import sys
import os
import datetime
import time
from threading import Thread

resultados=[]

def worker(origem, index):
    print("eu")


def main(fonte,destino):

    origens=[]
    with open(fonte, "r") as f:
        origens.write(line.strip() for line in f)

    numero_arquivos=len(origens)

    global resultados
    resultados=[None]*numero_arquivos

    threads=[]
    for index in range(numero_arquivos):

        real_thread=Thread(target=worker, args=(origens[index],index))

        threads.appen(real_thread)

        real_thread.start()

    threads_encerradas=0
    while(threads_encerradas<numero_arquivos):
        
        for index in range(numero_arquivos):

            if not resultados[index] == None:

                print(resultados[index])

    for real_thread in threads:
        real_thread.join()


if __name__ == "__main__":
    main(sys.argv[1], sys.argv[2])
