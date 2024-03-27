.data
mat1:    .space 64    # Espaço para 4 elementos inteiros (4x4)
mat2:    .space 64    # Espaço para 4 elementos inteiros (4x4)

prompt1:    .asciiz "\nPrimeira matriz\n"
prompt2:    .asciiz "\nSegunda matriz\n"
prompt3: .asciiz "Digite o elemento da matriz: "
prompt4: .asciiz "\nNumero de valores iguais nas matrizes: "
prompt5: .asciiz "\nSoma das posicoes (linha + coluna) dos elementos iguais: "

.text
.globl main

main:
    li $v0, 4       # syscall para imprimir "\nPrimeira matriz\n"
    la $a0, prompt1
    syscall

    # Ler os elementos da primeira matriz
    la $t0, mat1        # $t0 = endereco de mat1
    li $t1, 0         # contador de elementos lidos

    j ler_mat1      # vai para ler_mat1

ler_mat1:
    beq $t1, 16, ler_mat2   # se todos os elementos foram lidos, ir para a segunda matriz

    li $v0, 4       # syscall para imprimir "Digite o elemento da matriz: "
    la $a0, prompt3
    syscall

    li $v0, 5       # syscall para ler um inteiro
    syscall

    move $t2, $v0   # armazenar o elemento lido
    sw $t2, 0($t0)  # salvar o elemento na matriz 1

    addi $t0, $t0, 4  # avançar para o próximo espaço na matriz 1
    addi $t1, $t1, 1  # incrementar o contador de elementos lidos

    j ler_mat1    # ler o próximo elemento da matriz 1

ler_mat2:
    li $v0, 4       # syscall para imprimir "\nSegunda matriz\n"
    la $a0, prompt2
    syscall

    la $t0, mat2        # $t0 = endereco de mat2
    li $t1, 0         # resetar o contador de elementos lidos para a segunda matriz

    j ler_mat3      # vai para a funcao ler_mat3

ler_mat3:
    beq $t1, 16, comparacao   # se todos os elementos foram lidos, comparar as matrizes

    li $v0, 4       # syscall para imprimir "Digite o elemento da matriz: "
    la $a0, prompt3
    syscall

    li $v0, 5       # syscall para ler um inteiro
    syscall

    move $t2, $v0   # armazenar o elemento lido
    sw $t2, 0($t0)  # salvar o elemento na matriz 2

    addi $t0, $t0, 4  # avançar para o próximo espaço na matriz 2
    addi $t1, $t1, 1  # incrementar o contador de elementos lidos

    j ler_mat3    # ler o próximo elemento da matriz 2

comparacao:
    # Configurar registradores
    li $t3, 0       # contador de valores iguais
    li $t4, 0       # soma das posições

    # Percorrer as matrizes
    la $t0, mat1
    la $t1, mat2

    li $t5, 0       # contador de linha

loop:
    beq $t5, 4, loop_fora   # sair do loop quando todas as linhas forem percorridas

    li $t6, 0       # contador de coluna

loop_dentro:
    beq $t6, 4, proximo   # sair do loop interno quando todas as colunas forem percorridas

    # Carregar elementos das matrizes
    lw $t7, 0($t0)   # carregar elemento da matriz 1
    lw $t8, 0($t1)   # carregar elemento da matriz 2

    # Verificar se os elementos são iguais
    beq $t7, $t8, soma   # se forem iguais, adicionar valores e incrementar contadores

    addi $t6, $t6, 1   # incrementar contador de coluna
    addi $t0, $t0, 4   # avançar para o próximo elemento na matriz 1
    addi $t1, $t1, 4   # avançar para o próximo elemento na matriz 2

    j loop_dentro       # continuar no loop interno

soma:
    add $t3, $t3, 1   # incrementar contador de valores iguais
    add $t4, $t4, $t5 # adicionar linha à soma
    add $t4, $t4, $t6 # adicionar coluna à soma

    addi $t6, $t6, 1   # incrementar contador de coluna
    addi $t0, $t0, 4   # avançar para o próximo elemento na matriz 1
    addi $t1, $t1, 4   # avançar para o próximo elemento na matriz 2
    
    j loop_dentro       # continuar no loop interno

proximo:
    addi $t5, $t5, 1   # incrementar contador de linha

    j loop             # continuar no loop externo

loop_fora:
    sll $t4, $t4, 1

    # Imprimir resultados
    li $v0, 4       # syscall para imprimir string
    la $a0, prompt4
    syscall

    li $v0, 1       # syscall para imprimir inteiro
    move $a0, $t3   # carregar valor do contador de valores iguais
    syscall

    li $v0, 4       # syscall para imprimir string
    la $a0, prompt5
    syscall

    li $v0, 1       # syscall para imprimir inteiro
    move $a0, $t4   # carregar valor da soma das posições
    syscall

    # Encerrar programa
    li $v0, 10      # syscall para encerrar programa
    syscall
