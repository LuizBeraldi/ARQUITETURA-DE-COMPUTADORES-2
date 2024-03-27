.data
	msg1: .asciiz "\n\nLeitura do vetor:\n"
	msg2: .asciiz "\nTamanho dos vetores: "
	msg3: .asciiz "\nvet["
	msg4: .asciiz "] = "
	msg5: .asciiz "\n\nMaior valor: "
	msg6: .asciiz "\nSua posicao: "
	msg7: .asciiz "\n\nMenor valor: "
	
.text
	main: 
		addi $s0, $zero, 4		# $s0 = tamanho dos elementos em bytes = 4 bytes = sizeof(int)
		
		la $a0, msg2

		jal ler_n

		addi $s1, $v0, 0		# $s1 = tamanho do vetores
		
		# alocando e lendo o vetor A:
		addi $a0, $s1, 0
		addi $a1, $s0, 0
		jal alocar_vetor		# (tamVet:int, tamElemento:int):endereco
		la $s2, ($v0)		# $s2 = endereço base do vetor A
		
		addi $a0, $s2, 0
		addi $a1, $s1, 0
		la $a2, msg1
		jal ler_vetor		# (vet:endereco, tamVet:int, mensagem:string):void
		
		

		la $a0, ($s2)
		addi $a2, $s1, 0

		jal loop		# (vetA:endereco, vetB:endereco, tamVet:int):int
		
		
		la $a0, msg5
		addi $a1, $s4, 0

		jal imprimir
		
		li $v0, 10		# syscall para encerrar o programa
		syscall
	
	ler_n:		# (mensagem:string):int
		
		addi $v0, $zero, 4
		syscall		# syscall para imprimir "\nTamanho dos vetores: "
		
		addi $v0, $zero, 5		# syscall para ler um inteiro
		syscall
		
		jr $ra #retornando o controle para o chamador


	alocar_vetor:		# (tamVet:int, tamElemento:int):endereco
		
		mult $a0, $a1		# tamanhoVetor * tamanhoElemento
		mflo $a0		# $a0 = tamanhoVetor * tamanhoElemento = total de bytes do vetor
		
		addi $v0, $zero, 9
		syscall		# aloca $a0 bytes e guarda o endereço do inicio do bloco em $v0.
		
		jr $ra		# retornando o controle para o chamador	
	
	ler_vetor:		# (vet:endereco, tamVet:int, mensagem:string):void
		addi $sp, $sp, -12		# armazenando valores de $s0/$s1/$s2 na pilha
		sw $s0, 0($sp)
		sw $s1, 4($sp)
		sw $s2, 8($sp)
					 	  
		add $s0, $a1, $zero		# guardar o tamanho do vetor em $s0
		la $s1, ($a0)		# endereço base do vetor
		add $s2, $zero, $zero		# i = 0 
		
		addi $v0, $zero, 4
		la $a0, ($a2)
		syscall		# syscall para imprimir "\n\nLeitura do vetor  :\n"
		
		leitura:
			sll $t0, $s2, 2		# $t0 = 4 * i (i.e, deslocamento)
			add $t0, $t0, $s1		# $t0 = deslocamento + endereço base do vetor ($t0 == &vetor[i])
			
			addi $v0, $zero, 4
			la $a0, msg3
			syscall		# syscall para imprimir: vetor[
			
			addi $v0, $zero, 1
			add $a0, $zero, $s2
			syscall		# syscall para imprimir: i
			
			addi $v0, $zero, 4
			la $a0, msg4
			syscall		# syscall para imprimir: ] = 
			
			addi $v0, $zero, 5
			syscall		# syscall para ler um inteiro
			sw $v0, 0($t0)		# guardar o valor lido em vetor[i]
			
			addi $s2, $s2, 1		# i++
			bne $s2, $s0, leitura		# enquanto(i < numero de elementos do vetor)
		
		lw $s0, 0($sp)		# guardando os valores originais de volta em $s0/$s1/$s2
		lw $s1, 4($sp)
		lw $s2, 8($sp)
		addi $sp, $sp, 12		# desempilhando $s0/$s1/$s2  
		jr $ra		# retornando o controle para o chamador
		
	loop:		# (vetA:endereco, vetB:endereco, tamVet:int):int
		la $s0, ($a0)		# $s0 = endereço base vetA
		addi $s2, $a2, 0		# $s2 = tamanho vetores
		la $t5, -1000
		la $t6, 1000
		
		addi $t0, $zero, 0		# i = 0
		la $t1, 0
		
		loop_somatorio:
			#vetA_par:
			add $t2, $t1, $s0		# $t2 = deslocamento + endereço base do vetor 1 ($t2 == &vetA[i])
			lw $t3, 0($t2)		# $t3 = vetor1[i]

			bgt $t3, $t5, maior		# se($t3 > $t5), va para maior

			m:
				blt $t3, $t6, menor		# se($t3 < $t6), va para menor

			n:
				addi $t0, $t0, 1
				sll $t1, $t0, 2		# $t1 = 4 * i (i.e, deslocamento)

				beq $t0, $s2, terminar_loop

				blt $t0, $s2, loop_somatorio		# se(i<tamVet), va para loop_somatorio
		
		terminar_loop:
			jr $ra		# volta para a funcao main

	maior:
		add $t5, $t3, $zero		# maior
		add $t7, $t0, $zero		# i

		j m

	menor:
		add $t6, $t3, $zero		# menor
		add $s7, $t0, $zero		# i

		j n
		
	imprimir:		# ($a0 = string, $a1 = inteiro )

		addi $v0, $zero, 4 
		syscall		# syscall para imprimir "\n\nMaior valor: "	

		li $v0, 1       # carregar o codigo da syscall para imprimir um inteiro
		move $a0, $t5      # carregar a soma para imprimir
		syscall

		la $a0, msg6		# carrega o endereco da string
		li $v0, 4	 # syscall para imprimir "\nSua posicao: "
		syscall	

		li $v0, 1       # carregar o codigo da syscall para imprimir um inteiro
		move $a0, $t7      # carregar a soma para imprimir
		syscall

		la $a0, msg7		# carrega o endereco da string
		li $v0, 4	 # syscall para imprimir "\n\nMenor valor: "
		syscall		

		li $v0, 1       # carregar o codigo da syscall para imprimir um inteiro
		move $a0, $t6      # carregar a soma para imprimir
		syscall

		la $a0, msg6		# carrega o endereco da string
		li $v0, 4	 # syscall para imprimir "\nSua posicao: "
		syscall	

		li $v0, 1       # carregar o codigo da syscall para imprimir um inteiro
		move $a0, $s7      # carregar a soma para imprimir
		syscall

		jr $ra		# retornando o controle para o chamador