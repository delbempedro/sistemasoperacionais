def lcg(seed, a=1664525, c=1013904223, m=2**32, n=10):
    """Gera n números pseudoaleatórios com método LCG"""
    numbers = []
    x = seed
    for _ in range(n):
        x = (a * x + c) % m
        numbers.append(x)
    return numbers

# Função de 'hash' usando o LCG
def simple_hash(text, seed=1234):
    hash_val = seed
    for char in text:
        hash_val = (hash_val * ord(char) + 1013904223) % (2**32)
    return hex(hash_val)

# Exemplo de uso
print("Hash de 'hello':", simple_hash("hello"))
print("Hash de 'world':", simple_hash("world"))