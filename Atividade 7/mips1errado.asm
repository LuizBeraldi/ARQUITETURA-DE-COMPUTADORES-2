.data
numeros: .space 1000     # Vetor para armazenar os numeros
prompt1: .asciiz "Digite o tamanho da sequencia de numeros: "
prompt2: .asciiz "Digite os numeros: "
result_msg: .asciiz "A soma do maior segmento eh: "

.text
.globl main

main:
    li $v0, 4
    la $a0, prompt1     # syscall para imprimir "Digite o tamanho da sequencia de numeros: "
    syscall

    li $v0, 5
    syscall     # syscall para ler o tamanho da sequencia de numeros
    move $t0, $v0    # $t0 = tamanho da sequencia

    # Alocar memoria dinamicamente para armazenar os numeros
    li $v0, 9
    li $a0, 4
    mul $a1, $t0, $a0   # $a1 = tam * tam de int (4 bytes)
    syscall
    move $t1, $v0    # $t1 = endereco base do vetor

    li $v0, 4
    la $a0, prompt2     # syscall para imprimir "Digite os numeros: "
    syscall

    # Ler os numeros
    move $t2, $t1    # $t2 = ponteiro atual do vetor
    move $s3, $t0

loop_leitura:
    beq $s3, $zero, max_soma    # Se tam == 0, calcular a soma maxima

    li $v0, 5       # syscall para ler um numero inteiro
    syscall

    sw $v0, 0($t2)   # Armazenar o numero no vetor
    addi $t2, $t2, 4 # Avancar para o proximo elemento do vetor
    addi $s3, $s3, -1    # Decrementar o contador de tamanho
    j loop_leitura

max_soma:
    # Chamar a funcao para encontrar a soma do maior segmento
    move $a0, $t1    # Passar o endereco do vetor como argumento
    move $a1, $t0    # Passar o tamanho do vetor como argumento
    jal soma_maior_segmento

    li $v0, 4
    la $a0, result_msg      # syscall para imprimir "A soma do maior segmento eh: "
    syscall

    li $v0, 2
    mov.s $f12, $f0
    syscall

    li $v0, 10      # termina o programa
    syscall
    
soma_maior_segmento:
    move $t3, $a0     # $t3 = endereco base do vetor
    move $t4, $a1     # $t4 = tam do vetor
    l.s $f2, 0($t3)    # $f2 = max_atual = arr[0]
    l.s $f4, 0($t3)    # $f4 = curr_max = arr[0]
    addi $t4, $t4, -1 # $t4 = tam - 1

max_loop:
    beq $t4, $zero, max_fim
    addi $t3, $t3, 4   # Avancar para o proximo elemento do vetor
    l.s $f6, 0($t3)   # $f6 = arr[i]

    # curr_max = (arr[i] > curr_max + arr[i]) ? arr[i] : (curr_max + arr[i])
    add.s $f8, $f4, $f6
    c.le.s $f6, $f8
    bc1t atualiza_max_atual
    mov.s $f4, $f6
    j atualiza_max_ate_agr

atualiza_max_atual:
    mov.s $f4, $f6

atualiza_max_ate_agr:
    c.le.s $f2, $f4
    bc1t loop_max_fim
    mov.s $f2, $f4

loop_max_fim:
    addi $t4, $t4, -1
    j max_loop

max_fim:
    mov.s $f0, $f2     # $f0 = max_atual
    jr $ra
