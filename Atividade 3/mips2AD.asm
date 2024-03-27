.data
	prompt1: .asciiz "\nmat["
	prompt2: .asciiz "]["
	prompt3: .asciiz "] = "
	EhPermutacao: .asciiz "\nA matriz eh de permutacao\n"
	NaoEhPermutacao: .asciiz "\nA matriz nao eh de permutacao\n"
		
.text
	main: 
		la $s0, 3		# $s0 = ordem da matriz(3)
	
		addi $s1, $zero, 4		# $s1 = tamanho dos elementos em bytes = 4 bytes = sizeof(int)
	
		addi $a0, $s0, 0 
		addi $a1, $s0, 0
		addi $a2, $s1, 0

		jal alocar_matriz		# (linhas:int, colunas:int, tamElemento:int):endereco

		la $s2, ($v0)		# $s2 = endereco base da matriz
		
		addi $a0, $s2, 0
		addi $a1, $s0, 0 
		addi $a2, $s0, 0

		jal ler_matriz		# (matriz:endereco, linhas:int, colunas:int):void
		
		addi $a0, $s2, 0
		addi $a1, $s0, 0 
		addi $a2, $s0, 0

		jal imprimir_matriz		# (matriz:endereco, linhas:int, colunas:int):void
		
		addi $a0, $s2, 0
		addi $a1, $s0, 0 

		jal matriz_permutacao		# (matriz:endereco, ordem:int):int

		addi $s3, $v0, 0
		
		beq $s3, $zero, else		# if(matriz é de permutacao)
		
		addi $v0, $zero, 4
		la $a0, EhPermutacao
		syscall
		
		j fim_main		# encerra o programa
		
		else:
			addi $v0, $zero, 4
			la $a0, NaoEhPermutacao
			syscall

			j fim_main		# encerra o programa
		
	alocar_matriz:		# (linhas:int, colunas:int, tamElemento:int):endereco
		mult $a0, $a1 
		mflo $a0		# $a0 = linhas * colunas = numero total de elementos
		
		mult $a0, $a2
		mflo $a0		# $a0 = numero total de elementos * tamanho de um elemento = total de bytes da representacao da matriz na memoria
		
		addi $v0, $zero, 9
		syscall		# aloca $a0 bytes e guarda o endereço do inicio do bloco em $v0
		
		jr $ra		# volta para a funcao main	

	ler_matriz:		# (matriz:endereco, linhas:int, colunas:int):void
		subi $sp, $sp, 12
		sw $s0, 0($sp)
		sw $s1, 4($sp)
		sw $ra, 8($sp)		# vamos chamar um procedimento, entao, precisamos salvar o endereço de retorno de "leitura" na pilha
		
		move $a3, $a0		# $a3 = endereço base matriz
		addi $s0, $a1, 0		# $s0 = numero de linhas
		addi $s1, $a2, 0		# $s1 = numero de colunas
		addi $t0, $zero, 0		# i = 0
		addi $t1, $zero, 0		# j = 0
		
		loop_ler_matriz: 
			la $a0, prompt1
			li $v0, 4
			syscall		# syscall para imprimir "Insira o valor de Mat["
			
			move $a0, $t0
			li $v0, 1
			syscall		# syscall para imprimir o indice "i"
		
			la $a0, prompt2
			li $v0, 4
			syscall		# syscall para imprimir "]["
		
			move $a0, $t1
			li $v0, 1
			syscall		# syscall para imprimir o indice "j"
		
			la $a0, prompt3
			li $v0, 4
			syscall		# syscall para imprimir "]: "
		
			li $v0, 5
			syscall		# lendo o valor de Mat[i][j]
			move $t2, $v0		# $t2 = valor
		
			addi $a0, $t0, 0
			addi $a1, $t1, 0
			addi $a2, $s1, 0

			jal calcular_endereco_elemento_matriz		# (i:int, j:int, colunas:int, matriz:endereco):endereco

			sw $t2, 0($v0)		# Mat[i][j] = $t2
		
			addi $t1, $t1, 1		# j++
			blt $t1, $s1, loop_ler_matriz		# if (j < ncol), va para loop_ler_matriz
		
			li $t1, 0 # j = 0
			addi $t0, $t0, 1 #i++
			blt $t0, $s0, loop_ler_matriz		# if (i < nlin), va para loop_ler_matriz
		
			sw $s0, 0($sp)
			sw $s1, 4($sp)
			lw $ra, 8($sp)		# recuperando o endereco de retorno para a main
			addi $sp, $sp, 12

			jr $ra		# volta para a funcao main

	imprimir_matriz:		# (matriz:endereco, linhas:int, colunas:int):void
		subi $sp, $sp, 12
		sw $s0, 0($sp)
		sw $s1, 4($sp)
		sw $ra, 8($sp)
		
		move $a3, $a0		# $a3 = endereco base matriz
		addi $s0, $a1, 0		# $s0 = numero de linhas
		addi $s1, $a2, 0		# $s1 = numero de colunas
		addi $t0, $zero, 0		# i = 0
		addi $t1, $zero, 0		# j = 0	
	
		la $a0, 10		# 10 == codigo ASCII para imprimir nova linha ('\n')
		li $v0, 11
		syscall
		
		loop_imprimir_matriz: 
			addi $a0, $t0, 0
			addi $a1, $t1, 0
			addi $a2, $s1, 0	

			jal calcular_endereco_elemento_matriz		# (i:int, j:int, colunas:int, matriz:endereco):endereco

			lw $a0, 0($v0)
			li $v0, 1
			syscall		# syscall para imprimir mat[i][j]
	
			la $a0, 32		# 32 == codigo ASCII para imprimir um espaco em branco " "
			li $v0, 11
			syscall
	
			addi $t1, $t1, 1		# j++
			blt $t1, $s1, loop_imprimir_matriz		# if (j < ncol), va para loop_imprimir_matriz
 	
			la $a0, 10		# 10 == codigo ASCII para imprimir uma nova linha ('\n')
			syscall
	
			li $t1, 0		# j = 0
			addi $t0, $t0, 1		# i++
			blt $t0, $s0, loop_imprimir_matriz		# if (i < nlin), va para loop_imprimir_matriz
			li $t0, 0		# i = 0
	 
			lw $s0, 0($sp)
			lw $s1, 4($sp)
			lw $ra, 8($sp)		# recuperando o endereço de retorno para a main
			addi $sp, $sp, 12

			jr $ra		# volta para a funcao main

	calcular_endereco_elemento_matriz:		# (i:int, j:int, colunas:int, matriz:endereco):endereco  -> calcula o endereço do elemento mat[i][j]
		mul $v0, $a0, $a2		# i * ncol (calcula a posicao do inicio da linha i)
		add $v0, $v0, $a1		# (i * ncol) + j (calcula a posicao do elemento em sua linha)
		sll $v0, $v0, 2		# [(i * ncol) + j] * 4(calcula o deslocamento em bytes para se chegar no elemento mat[i][j])
		add $v0, $v0, $a3		# retona a soma do endereço base da matriz ao deslocamento (i.e, return &mat[i][j])

		jr $ra		# volta para a funcao main
		
	imprimir_string_inteiro:		# (a0 = string, a1 = inteiro)
		addi $v0, $zero, 4 
		syscall	
		
		addi $v0, $zero, 1
		addi $a0, $a1, 0
		syscall 

		jr $ra		# volta para a funcao main
		
	matriz_permutacao:		# (matriz:endereco, ordem:int):int
		subi $sp, $sp, 24
		sw $s0, 0($sp)
		sw $s1, 4($sp)
		sw $s2, 8($sp)
		sw $s3, 12($sp)
		sw $s4, 16($sp)
		sw $ra, 20($sp)
	
		la $s0, ($a0)		# $s0 = endereco matriz
		addi $s1, $a1, 0		# $s1 = ordem da matriz
		addi $t0, $zero, 0		# i = 0
		addi $t1, $zero, 0		# j = 0
		addi $s4, $zero, 1		# $s4 = constatante 1		
		addi $v1, $zero, 0		# resultado ($v1) = 0 (falso)			
		 
		loop_e_permutacao:
			loop_i_permutacao:
				addi $s2, $zero, 0		# somaLinha ($s2) = 0  
				addi $s3, $zero, 0		# somaColuna ($s3) = 0 		
		
				loop_j_permutacao:
					addi $a0, $t0, 0
					addi $a1, $t1, 0
					addi $a2, $s1, 0 
					la $a3, ($s0)

					jal calcular_endereco_elemento_matriz		# (i:int, j:int, colunas:int, matriz:endereco):endereco

					lw $t2, 0($v0)		# $t2 = mat[i][j]
				
					addi $a0, $t1, 0
					addi $a1, $t0, 0

					jal calcular_endereco_elemento_matriz		# (i:int, j:int, colunas:int, matriz:endereco):endereco

					lw $t3, 0($v0)		# $t3 = mat[j][i]
				
					add $s2, $s2, $t2		# somaLinha  ($s2) += mat[i][j]  
					add $s3, $s3, $t3		# somaColuna ($s3) += mat[j][i]  
				
					addi $t1, $t1, 1  	  # j++
					blt $t1, $s1, loop_j_permutacao		# if (j < ncol), va para loop_j_permutacao
				
			bne $s2, $s4, fim_permutacao
			bne $s3, $s4, fim_permutacao		# if(somaLinha != 1 || somaColuna != 1) return 0;
			
			addi $t1, $zero, 0		# j = 0
			addi $t0, $t0, 1		# i++
			blt $t0, $s1, loop_i_permutacao #if i<nlin, goto loop_i_permutacao
		
		addi $v1, $v1, 1		# resultado ($v1) = 1 (verdadeiro)	

		fim_permutacao:
			addi $v0, $v1, 0 	
			lw $s0, 0($sp)
			lw $s1, 4($sp)
			lw $s2, 8($sp)
			lw $s3, 12($sp)
			lw $s4, 16($sp)
			lw $ra, 20($sp)
			addi $sp, $sp, 24

			jr $ra		# volta para a funcao main

	fim_main:
		addi $v0, $zero, 10
		syscall