.data
	mat: .space 36		# (3x3) * 4 (inteiro)

	prompt1: .asciiz "\nInsira o valor de mat["
	prompt2: .asciiz "]["
	prompt3: .asciiz "]: "
	prompt4: .asciiz "\nSoma dos valores da diagonal secundaria: "

.text
main:
	la $a0, mat		# Endereco base de Mat
	li $a1, 3		# numero de linhas
	li $a2, 3		# numero de colunas

	jal leitura		# leitura(mat, nlin, ncol)

	move $a0, $v0		# endereco da matriz lida

	jal escrita		# escrita(mat, nlin, ncol)

	jal somatorio		# imprime a soma da diagonal secundaria

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
	li $t5, 0		# variavel que sera usada para verificar a posicao para a soma
	li $t6, 2		# variavel que tambem sera usada para verificar a posicao para a soma
	li $t4, 0		# soma

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

		beq $t0, $t5, igual_i		# if(i == $t5), va para igual_i

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
	beq $t1, $t6, igual_j		# if(j == $t6), va para igual_j

	j k		# retorna para a funcao k

igual_j:
	add $t4, $t4, $v0		# soma = soma + mat[i][j]

	addi $t5, $t5, 1		# $t5 = $t5 + 1
	subi $t6, $t6, 1		# $t6 = %t6 - 1

	j k		# retorna para a funcao k

somatorio:
	la $a0, 10		# codigo ASCII para impressao de uma nova linha (\n)
	li $v0, 11
	syscall		# pula a linha

	la $a0, prompt4		# carrega o endereco da string
	li $v0, 4		# codigo de impressao de string
	syscall		# imprime a string

	li $v0, 1       # carregar o codigo da syscall para imprimir um inteiro
    move $a0, $t4      # carregar a soma para imprimir
    syscall

	jr $ra		# volta para a funcao main