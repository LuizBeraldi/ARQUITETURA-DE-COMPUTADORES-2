.data
	msg1: .asciiz "\n\nLeitura do vetor A:\n"
	msg2: .asciiz "\n\nLeitura do vetor B:\n"
	msg3: .asciiz "\nTamanho dos vetores: "
	msg4: .asciiz "\nvet["
	msg5: .asciiz "] = "
	msg6: .asciiz "\n\nPares de VetA - Impares de VetB = "
	
.text
	main: 
		addi $s0, $zero, 4		# $s0 = tamanho dos elementos em bytes = 4 bytes = sizeof(int)
		
		la $a0, msg3
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
		
		# alocando e lendo o vetor B:
		addi $a0, $s1, 0
		addi $a1, $s0, 0
		jal alocar_vetor		# (tamVet:int, tamElemento:int):endereco
		la $s3, ($v0)		# $s3 = endereço base do vetor B
		
		addi $a0, $s3, 0
		addi $a1, $s1, 0
		la $a2, msg2
		jal ler_vetor		# (vet:endereco, tamVet:int, mensagem:string):void

		la $a0, ($s2)
		la $a1, ($s3) 
		addi $a2, $s1, 0

		jal loop		# (vetA:endereco, vetB:endereco, tamVet:int):int

		sub $t3, $t5, $t6		# $t3 = soma dos pares de vetA - soma dos impares de vetB
		addi $s4, $t3, 0		# $s4 = $t3
		
		
		la $a0, msg6
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
			la $a0, msg4
			syscall		# syscall para imprimir: vetor[
			
			addi $v0, $zero, 1
			add $a0, $zero, $s2
			syscall		# syscall para imprimir: i
			
			addi $v0, $zero, 4
			la $a0, msg5
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
		la $s1, ($a1)	 	# $s1 = endereço base vetB
		addi $s2, $a2, 0		# $s2 = tamanho vetores
		
		addi $t0, $zero, 0		# i = 0
		addi $v0, $zero, 0		# resultado = 0
		la $t1, 0
		
		loop_somatorio:
			#vetA_par:
			add $t2, $t1, $s0		# $t2 = deslocamento + endereço base do vetor 1 ($t2 == &vetA[i])
			lw $t3, 0($t2)		# $t3 = vetor1[i]

			add $t5, $t3, $t5

			addi $t0, $t0, 1
			sll $t1, $t0, 2		# $t1 = 4 * i (i.e, deslocamento)

			beq $t0, $s2, terminar_loop

			#vetB_impar:
			add $t2, $t1, $s1		# $t2 = deslocamento + endereço base do vetor 2 ($t2 == &vetB[i])
			lw $t4, 0($t2)		# $t4 = vetor2[i]

			add $t6, $t4, $t6

			addi $t0, $t0, 1  	   # i++
			sll $t1, $t0, 2		# $t1 = 4 * i (i.e, deslocamento)

			blt $t0, $s2, loop_somatorio		# se(i<tamVet), va para loop_somatorio
		
		terminar_loop:
			jr $ra		# volta para a funcao main
		
	imprimir:		# ($a0 = string, $a1 = inteiro )

		addi $v0, $zero, 4 
		syscall		# syscall para imprimir "\n\nPares de VetA - Impares de VetB = "
		
		addi $v0, $zero, 1
		addi $a0, $a1, 0
		syscall

		jr $ra		# retornando o controle para o chamador
