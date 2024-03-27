.data
	mat: .space 64		# (4x4) * 4 (inteiro)

	prompt1: .asciiz "\nInsira o valor de mat["
	prompt2: .asciiz "]["
	prompt3: .asciiz "]: "

    sub: .asciiz "\nSoma da diagonal superior - soma da diagonal inferior: "
    maior_superior: .asciiz "\n\nO maior valor da diagonal superior: "
    menor_inferior: .asciiz "\n\nO menor valor da diagonal inferior: "
    bubble: .asciiz "\n\nA matriz em ordem crescente"
    espaco: .asciiz " "

.text
main:
	la $a0, mat		# Endereco base de Mat
	li $a1, 4		# numero de linhas
	li $a2, 4		# numero de colunas

	jal leitura		# leitura(mat, nlin, ncol)

	move $a0, $v0		# endereco da matriz lida

	jal escrita		# escrita(mat, nlin, ncol)

    jal imprimir		# usada para imprimir os resultados do programa

    jal bubble_sort		# usada para ordenar a matriz

	li $v0, 10		# codigo para finalizar o programa
	syscall		# finaliza o programa

indice:
	mul $v0, $t0, $a2		# i * ncol
	add $v0, $v0, $t1		# (i * ncol) + j
	sll $v0, $v0, 2		# [(i * ncol) + j] * 4 (inteiro)
	add $v0, $v0, $a3		# soma o endereco base de mat

	jr $ra		# volta para a funcao

leitura:
	subi $sp, $sp, 4		# espaco para um item na pilha
	sw $ra, ($sp)		# salva o retorno para a main
	move $a3, $a0		# aux = endereco base de mat
    li $t3, 0       # verifica a posicao de i
    li $t4, 1       # verifica a posicao de j
    li $t5, 0       # somatorio dos elementos da diagonal superior
    li $t6, 0       # somatorio dos elementos da diagonal inferior
    li $t7, 0       # indice do contador das diagonais
    li $s1, 0       # maior valor da diagonal superior
    li $s2, 100     # menor valor da diagonal inferior

	l:
		la $a0, prompt1		# carrega o endereco da string
		li $v0, 4		# codigo de impressao de string
		syscall		# imprime a string

		move $a0, $t0		# valor de i para impressao
		li $v0, 1		#  codigo de impressao de inteiro
		syscall		# imprime o inteiro

		la $a0, prompt2		# carrega o endereco da string
		li $v0, 4		# codigo de impressao de string
		syscall		# imprime a string

		move $a0, $t1		# valor de j para impressao
		li $v0, 1		# codigo de impressao de inteiro
		syscall		# impreme j

		la $a0, prompt3		# carrega o endereco da string
		li $v0, 4		# codigo de impressao de string
		syscall		# imprime a string

		li $v0, 5		# codigo de leitura de inteiro
		syscall		# imprime a string

        beq $t3, $t0, igual_i		# if($t3 == i), va para igual_i

        k:
            move $t2, $v0		# aux = valor lido

            jal indice		# calcula o endereco de mat[i][j]

            sw $t2, ($v0)		# mat[i][j] = aux
            addi $t1, $t1, 1		# j++

            blt $t1, $a2, l		# if(j < ncol), va para l

            li $t1, 0		# j = 0
            addi $t0, $t0, 1		# i++

            blt $t0, $a1, l		# if(i < nlin), va para l

            li $t0, 0		# i =0

            lw $ra, ($sp)		# recupera o retorno para a main
            addi $sp, $sp, 4		# libera o espaco na pilha
            move $v0, $a3		# endereco base da matriz para o retorno

            jr $ra		# volta para a funcao main

escrita:
	subi $sp, $sp, 4		# espaco para um item na pilha
	sw $ra, ($sp)		# salva o retorno para a main
	move $a3, $a0		# aux = endereco base de mat

	e:
		jal indice		# calcula o endereco base de mat[i][j]

		lw $a0, ($v0)		# valor em mat[i][j]
		li $v0, 1		# codigo de impressao de inteiro
		syscall		# imprime mat[i][j]

		la $a0, 32		# codigo ASCII para espaco
		li $v0, 11		# codigo de impressao de caracter
		syscall		# imprime o espaco

		addi $t1, $t1, 1		# j++
		blt $t1, $a2, e		# if(j < ncol), va para e

		la $a0, 10		# codigo ASCII para impressao de uma nova linha (\n)
		syscall		# pula a linha

		li $t1, 0		# j = 0
		addi $t0, $t0, 1		# i++
		blt $t0, $a1, e 		# if(i < nlin), va para e
		li $t0, 0		# i = 0
		lw $ra, ($sp)		# recupera o retorno para a main
		addi $sp, $sp, 4		# libera o espaco na pilha
		move $v0, $a3		# endereco base da matriz para o retorno

		la $a0, 10		# codigo ASCII para impressao de uma nova linha (\n)
		li $v0, 11
		syscall		# pula a linha

		jr $ra		# retorna para a main

igual_i:
    beq $t4, $t1, igual_j		# if($t4 == j), va para igual_j

    j k		# se nao, retorna para k

igual_j:
    beq $t7, 0, superior		# testa todos os valores, para saber em que somatorio tem que colocar
    beq $t7, 1, superior
    beq $t7, 2, superior
    beq $t7, 5, superior
    beq $t7, 6, superior
    beq $t7, 10, superior

	beq $t7, 3, inferior
	beq $t7, 7, inferior
    beq $t7, 8, inferior
	beq $t7, 11, inferior
    beq $t7, 12, inferior
    beq $t7, 13, inferior

    verificar:
        bne $t4, 3, diferente		# if(j != 3), va para diferente

        li $t4, 0		# j = 0
        addi $t3, $t3, 1		# i = i + 1

    fim_verificar:
        addi $t7, $t7, 1		# contador = contador + 1

        j k		# volta para o loop k

superior:
    add $t5, $t5, $v0		# somaSuperior = somaSuperior + valor atual da matriz
    bge $v0, $s1, maior		# verifica se o valor eh o maior valor da diagonal superior

    j verificar		# vai para o loop verificar

    maior:
        move $s1, $v0		# passa o valor da matriz para o registrador

        j verificar		# vai para o loop verificar

inferior:
    add $t6, $t6, $v0		# somaInferior = somaInferior + valor atual da matriz
    ble $v0, $s2, menor		# verifica se o valor eh o menor valor da diagonal inferior

    j verificar		# vai para o loop verificar

    menor:
        move $s2, $v0		# passa o valor da matriz para o registrador

        j verificar		# vai para o loop verificar

diferente:
    addi $t4, $t4, 1		# j = j + 1

    j fim_verificar		# vai para a funcao fim_verificar

imprimir:
    sub $t3, $t5, $t6		# $t3 = somaSuperior - somaInferior

	la $a0, sub		# carrega o endereco da string
	li $v0, 4		# codigo de impressao de string
	syscall		# imprime a string

	li $v0, 1       # carregar o codigo da syscall para imprimir um inteiro
    move $a0, $t3      # carregar a soma para imprimir
    syscall

    la $a0, maior_superior		# carrega o endereco da string
	li $v0, 4		# codigo de impressao de string
	syscall		# imprime a string

	li $v0, 1       # carregar o codigo da syscall para imprimir um inteiro
    move $a0, $s1      # carregar a soma para imprimir
    syscall

    la $a0, menor_inferior		# carrega o endereco da string
	li $v0, 4		# codigo de impressao de string
	syscall		# imprime a string

	li $v0, 1       # carregar o codigo da syscall para imprimir um inteiro
    move $a0, $s2      # carregar a soma para imprimir
    syscall

	jr $ra		# volta para a funcao main


bubble_sort:
    la $s2, mat		# carrega o endereco do vetor em $s7

	li $s0, 0		# inicializa o contador 1 do loop 1

	li $s3, 15 		# n - 1
	
	li $s1, 0 		# inicializa o contador 2 do loop 2

	li $t3, 0		# inicializa o contador para imprimir os valores

	li $t4, 16      # $t4 == tamanho do vetor

	li $v0, 4,		# imprime a mensagem para mostrar os valores em ordem crescente
	la $a0, bubble
	syscall

    la $a0, 10		# codigo ASCII para impressao de uma nova linha (\n)
	li $v0, 11
	syscall		# pula a linha

bubble_loop:
	sll $t7, $s1, 2			# multiplica $s1 por 2 e guarda no $t7

	add $t7, $s2, $t7 	    # coloca o valor do vetor em $t7

	lw $t0, 0($t7)  	# carrega o vet[j]	

	lw $t1, 4($t7) 		# carrega o vet[j+1]


	slt $t2, $t0, $t1		#se t0 < t1
	bne $t2, $zero, bubble_incrementa

	sw $t1, 0($t7) 		# troca

	sw $t0, 4($t7)

bubble_incrementa:	

	addi $s1, $s1, 1		# incrementa $s1

	sub $s5, $s3, $s0 		# subtrai $s0 de $s6

	bne  $s1, $s5, bubble_loop			# se $s1 != 11, va para bubble_loop

    addi $s0, $s0, 1 		# se nao, soma 1 em $s0

	li $s1, 0 		# reseta $s1 para 0

	bne  $s0, $s3, bubble_loop     # vai para o loop com $s1 = $s1 + 1
	
bubble_imprimir:
	beq $t3, $t4, bubble_sair	# se $t3 == $t4 va para o bubble_sair
	
	lw $t5, 0($s2)		# carrega do vet

    beq $t3, 4, pula_quatro		# if($t3 == 4 || 8 || 12), va para pula_quatro
    beq $t3, 8, pula_quatro		# serve para fazer a forma da matriz
    beq $t3, 12, pula_quatro

    continua:
        li $v0, 1		# imprime o numero na tela
        move $a0, $t5
        syscall

        li $v0, 4 
        la $a0, espaco      # da um espaco
        syscall
        
        addi $s2, $s2, 4	# incrementa o vetor

        addi $t3, $t3, 1    # incrementa o contador

        j bubble_imprimir
    
    pula_quatro:
        la $a0, 10		# codigo ASCII para impressao de uma nova linha (\n)
	    li $v0, 11
	    syscall		# pula a linha
    
        j continua		# volta para o loop continua

bubble_sair:
    jr $ra      # volta para a main e executa a proxima instrucao
