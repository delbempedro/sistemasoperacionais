#!/usr/bin/env python3

# Gerador LCG simples
def lcg(seed, a=1664525, c=1013904223, m=2**32, n=1000):
    x = seed
    for _ in range(n):
        x = (a * x + c) % m
        yield x % 256  # retorna byte (0–255)

# Função de cifra XOR com keystream
def xor_crypt(data, seed):
    keystream = lcg(seed, n=len(data))
    # Lista onde vamos armazenar os bytes criptografados
    resultado = []  
    # Para cada par de (byte da mensagem, byte da chave)
    for byte_mensagem, byte_chave in zip(data, keystream):
        byte_criptografado = byte_mensagem ^ byte_chave  # XOR
        resultado.append(byte_criptografado)
    # Converte a lista de inteiros para bytes novamente
    return bytes(resultado)

# === CONFIGURAÇÃO ===
modo = 'encode'         # pode ser 'encode' ou 'decode'
mensagem = 'hello world'
semente = 1234
mensagem = '61b14f4a226870d5a3904f'
modo = 'decode'

# === PROCESSAMENTO ===
if modo == 'encode':
    dados = mensagem.encode('utf-8')  # converte texto para bytes
    resultado = xor_crypt(dados, semente)
    print("Texto criptografado (hex):", resultado.hex())

elif modo == 'decode':
    try:
        dados = bytes.fromhex(mensagem)  # assume que a entrada é string hexadecimal
        resultado = xor_crypt(dados, semente)
        print("Texto decodificado:", resultado.decode('utf-8'))
    except ValueError:
        print("Erro: mensagem criptografada deve estar em hexadecimal.")

else:
    print("Erro: modo inválido. Use 'encode' ou 'decode'.")
