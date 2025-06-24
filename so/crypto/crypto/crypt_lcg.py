#!/usr/bin/env python3
import sys
import optparse

# Gerador LCG
def lcg(seed, a=1664525, c=1013904223, m=2**32, n=1000):
    x = seed
    for _ in range(n):
        x = (a * x + c) % m
        yield x % 256  # Apenas os 8 bits menos significativos

# Função de codificação/decodificação
def xor_crypt(data, seed):
    keystream = lcg(seed, n=len(data))
    return bytes([b ^ k for b, k in zip(data, keystream)])

# Main com optparse
def main():
    parser = optparse.OptionParser(usage="uso: %prog -m <modo> -t <texto> -s <semente>")
    parser.add_option("-m", "--modo", dest="modo", help="modo: encode ou decode")
    parser.add_option("-t", "--texto", dest="texto", help="texto a ser processado")
    parser.add_option("-s", "--seed", dest="seed", type="int", help="semente inteira")

    (options, args) = parser.parse_args()

    if not options.modo or not options.texto or options.seed is None:
        parser.error("Todos os parâmetros -m, -t e -s são obrigatórios.")

    if options.modo not in ['encode', 'decode']:
        parser.error("Modo deve ser 'encode' ou 'decode'.")

    if options.modo == 'encode':
        data = options.texto.encode('utf-8')
        result = xor_crypt(data, options.seed)
        print(result.hex())  # mostra em hexadecimal
    else:  # decode
        try:
            data = bytes.fromhex(options.texto)
        except ValueError:
            sys.exit("Texto inválido: esperava string hexadecimal.")
        result = xor_crypt(data, options.seed)
        print(result.decode('utf-8'))

if __name__ == "__main__":
    main()
