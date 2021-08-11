'''
Programa: Evidência forense de plágio
'''

# Bibliotecas
import re

# Principal
def main():

    # Chamada de metodos
    ass_cp = le_assinatura()
    textos = le_textos()

    # Chamada de metodo para avaliar textos com plagios
    print("\nO autor do texto {} está infectado com COH-PIAH".format(avalia_textos(textos, ass_cp)))

###################
#     METODOS     #
###################

# Metodo: A funcao le os valores dos tracos linguisticos do modelo
def le_assinatura():

    # Apresentacao
    print("Bem-vindo ao detector automático de COH-PIAH.\n\n")

    # Entrada de dados
    wal = float(input("Entre o tamanho medio de palavra:"))
    ttr = float(input("Entre a relação Type-Token:"))
    hlr = float(input("Entre a Razão Hapax Legomana:"))
    sal = float(input("Entre o tamanho médio de sentença:"))
    sac = float(input("Entre a complexidade média da sentença:"))
    pal = float(input("Entre o tamanho medio de frase:"))

    # Retorno de uma assinatura a ser comparada com os textos fornecidos
    return [wal, ttr, hlr, sal, sac, pal]

# Metodo: Leitura de texto
def le_textos():

    # Variavel
    i = 1
    textos = []  # Lista

    # Entrada de dados
    texto = input("\nDigite o texto " + str(i) + " (aperte enter para sair):")

    # Estrutura de repeticao
    while texto:

        # Acrescimo de texto
        textos.append(texto)

        # Incremento
        i += 1

        # Entrada de dados
        texto = input("\nDigite o texto " + str(i) + " (aperte enter para sair):")

    # Retorno de lista com texto
    return textos

###################
#     FUNCOES     #
###################

# Funcao: Lista de sentencas
def separa_sentencas(texto):

    # Eliminacao pelo sistema de regex
    sentencas = re.split(r'[.!?]+', texto)

    # Estrutura de decisao: Elimando posicao vazia
    if sentencas[-1] == '':

        # Eliminando posicao
        del sentencas[-1]

    # Retorno de uma lista das sentencas dentro do texto
    return sentencas

# Funcao: Lista de frases
def separa_frases(sentenca):

    # Retorno de uma lista das frases dentro da sentenca
    return re.split(r'[,:;]+', sentenca)

# Funcao: Lista de palavras
def separa_palavras(frase):

    # Devolve uma lista das palavras dentro da frase
    return frase.split()

# Funcao: Lista de palavras unicas
def n_palavras_unicas(lista_palavras):

    # Variaveis
    freq = dict()  # Dicionario
    unicas = 0

    # Estrutura de repeticao
    for palavra in lista_palavras:

        # Palavras minusculas
        p = palavra.lower()

        # Estrutura de decisao
        if p in freq:

            if freq[p] == 1:
                unicas -= 1
            freq[p] += 1

        else:
            freq[p] = 1
            unicas += 1

    # Retorno do numero de palavras que aparecem uma unica vez
    return unicas

# Funcao: Lista de palavras diferentes
def n_palavras_diferentes(lista_palavras):

    # Dicionario
    freq = dict()

    # Estrutura de repeticao
    for palavra in lista_palavras:

        # Palavras minusculas
        p = palavra.lower()

        # Estrutura de decisao
        if p in freq:
            freq[p] += 1

        else:
            freq[p] = 1

    # Retorno do numero de palavras diferentes utilizadas
    return len(freq)

# Funcao: Calculo da assinatura do texto
def calcula_assinatura(texto):

    # Retorno da assinatura do texto
    return [tamanho_medio_de_palavra(texto), relacao_Type_Token(texto), razao_Hapax_Legomana(texto),
            tamanho_medio_de_sentenca(texto), complexidade_de_sentenca(texto), tamanho_medio_de_frase(texto)]

# Funcao: Comparacao de assinaturas entre textos
def compara_assinatura(as_a, as_b):

    # Variavel
    som = 0

    # Estrutura de repeticao
    for i in range(0, 6):

        # Calculo
        som += abs(as_a[i] - as_b[i])

    # Similaridade
    similaridade = som / 6

    # Retorno do grau de similaridade nas assinaturas
    return similaridade

# Funcao: Avaliacao de textos
def avalia_textos(textos, ass_cp):

    # Lista de textos
    lista_similaridade = []

    # Estrutura de repeticao
    for i in range(0, len(textos)):
        as_texto = calcula_assinatura(textos[i])
        grau_similaridade = compara_assinatura(as_texto, ass_cp)
        lista_similaridade.append(grau_similaridade)

    # Posicao
    # pos = int(min(lista_similaridade))
    pos = lista_similaridade.index((min(lista_similaridade))) + 1

    # Retorno do numero (1 a n) do texto com maior probabilidade de ter sido infectado por COH-PIAH
    # return "\nO autor do texto " + str(pos) + " está infectado com COH-PIAH"
    return pos

####################
#     CALCULOS     #
####################

# Funcao: Tamanho medio de palavra
def tamanho_medio_de_palavra(texto):

    return numero_total_de_caractere_palavra(texto) / numero_total_de_palavras(texto)

# Funcao: Relacao Type Token
def relacao_Type_Token(texto):

    return numero_total_de_palavras_diferentes(texto) / numero_total_de_palavras(texto)

# Funcao: Razao_Hapax_Legomana
def razao_Hapax_Legomana(texto):

    return numero_total_de_palavras_unicas(texto) / numero_total_de_palavras(texto)

# Funcao: Tamanho medio de sentenca
def tamanho_medio_de_sentenca(texto):

    return numero_total_de_caractere_sentenca(texto) / numero_total_de_sentencas(texto)

# Funcao: Complexidade de sentenca
def complexidade_de_sentenca(texto):

    return numero_total_de_frases(texto) / numero_total_de_sentencas(texto)

# Funcao: Tamanho medio de frase
def tamanho_medio_de_frase(texto):

    return numero_total_de_caractere_frase(texto) / numero_total_de_frases(texto)

###################
#     SUPORTE     #
###################

def numero_total_de_caractere_palavra(texto):

    # Numero de frases
    num_car = 0

    # Lista de sentencas
    lista_sentenca = separa_sentencas(texto)[:]

    # Lista de frases
    lista_frases = []
    for i in lista_sentenca:
        lista_frases += separa_frases(i)

    # Lista de palavras
    lista_palavras = []
    for i in lista_frases:
        lista_palavras += separa_palavras(i)

    # Soma dos tamanhos das palavras
    for i in lista_palavras:
        num_car += len(i)

    return num_car

def numero_total_de_caractere_frase(texto):

    # Numero de frases
    num_car = 0

    # Lista de sentencas
    lista_sentenca = separa_sentencas(texto)[:]

    # Lista de frases
    lista_frases = []
    for i in lista_sentenca:
        lista_frases += separa_frases(i)

    # Soma total de caracteres
    for i in lista_frases:
        num_car += len(i)

    return num_car

def numero_total_de_caractere_sentenca(texto):

    # Numero de frases
    num_car = 0

    # Lista de sentencas
    lista_sentenca = separa_sentencas(texto)[:]

    # Soma total de caracteres
    lista_frases = []
    for i in lista_sentenca:
        num_car += len(i)

    return num_car

def numero_total_de_frases(texto):

    lista_sentenca = separa_sentencas(texto)

    # Numero de frases
    num_fras = 0

    for i in lista_sentenca:
        num_fras += len(separa_frases(i))

    return num_fras

def numero_total_de_sentencas(texto):

    # Lista de sentencas
    lista_sentenca = separa_sentencas(texto)

    # Número total de sentenças
    return len(lista_sentenca)

def numero_total_de_palavras(texto):

    # Lista de sentencas
    lista_sentenca = separa_sentencas(texto)

    # Lista de frases
    lista_frases = []
    for i in lista_sentenca:
        lista_frases += separa_frases(i)

    # Lista de palavras
    lista_palavras = []
    for i in lista_frases:
        lista_palavras += separa_palavras(i)

    num_pal = len(lista_palavras)

    return num_pal

def numero_total_de_palavras_unicas(texto):

    # Lista de sentencas
    lista_sentenca = separa_sentencas(texto)

    # Lista de frases
    lista_frases = []
    for i in lista_sentenca:
        lista_frases += separa_frases(i)

    # Lista de palavras
    lista_palavras = []
    for i in lista_frases:
        lista_palavras += separa_palavras(i)

    # Numero de palavras unicas
    return n_palavras_unicas(lista_palavras)

def numero_total_de_palavras_diferentes(texto):

    # Lista de sentencas
    lista_sentenca = separa_sentencas(texto)

    # Lista de frases
    lista_frases = []
    for i in lista_sentenca:
        lista_frases += separa_frases(i)

    # Lista de palavras
    lista_palavras = []
    for i in lista_frases:
        lista_palavras += separa_palavras(i)

    # Numero de palavras unicas
    return n_palavras_diferentes(lista_palavras)

# Execucao
if __name__ == '__main__':
    main()
