.data
	msg1: .asciiz "\n\nLeitura do vetor C:\n"
	msg2: .asciiz "\n\nLeitura do vetor D:\n"
	msg3: .asciiz "\nTamanho dos vetores: "
	msg4: .asciiz "\nvet["
	msg5: .asciiz "] = "
	msg6: .asciiz "\n\nVetor resultado: ["
    msg7: .asciiz "]"
	
.text
	main: 
		addi $s0, $zero, 4		# $s0 = tamanho dos elementos em bytes = 4 bytes = sizeof(int)
		
		la $a0, msg3
		jal ler_n
		addi $s1, $v0, 0		# $s1 = tamanho do vetores
		
		# alocando e lendo o vetor C:
		addi $a0, $s1, 0
		addi $a1, $s0, 0
		jal alocar_vetor		# (tamVet:int, tamElemento:int):endereco
		la $s2, ($v0)		# $s2 = endereço base do vetor C
		
		addi $a0, $s2, 0
		addi $a1, $s1, 0
		la $a2, msg1
		jal ler_vetor		# (vet:endereco, tamVet:int, mensagem:string):void
		
		# alocando e lendo o vetor D:
		addi $a0, $s1, 0
		addi $a1, $s0, 0
		jal alocar_vetor		# (tamVet:int, tamElemento:int):endereco
		la $s3, ($v0)		# $s3 = endereço base do vetor D
		
		addi $a0, $s3, 0
		addi $a1, $s1, 0
		la $a2, msg2
		jal ler_vetor		# (vet:endereco, tamVet:int, mensagem:string):void

        # alocando e lendo o vetor E:
        sll $s1, $s1, 1     # vetE = tamanho 8
		addi $a0, $s1, 0
		addi $a1, $s0, 0
		jal alocar_vetor		# (tamVet:int, tamElemento:int):endereco
		la $s5, ($v0)		# $s5 = endereço base do vetor E

		la $a0, ($s2)
		la $a1, ($s3) 
        la $a3, ($s5)
		addi $a2, $s1, 0

		jal loop		# (vetA:endereco, vetB:endereco, tamVet:int):int

        la $a0, msg6		# carrega o endereco da string
		li $v0, 4		# codigo de impressao de string
		syscall		# imprime a string

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
		la $s0, ($a0)		# $s0 = endereço base vetC
		la $s1, ($a1)	 	# $s1 = endereço base vetD
        la $s6, ($a3)       # $s6 = endereço base vetE
		addi $s2, $a2, 0		# $s2 = tamanho vetores
		
		la $t0, 0       # contador do VetE
        la $t7, 0       # contador do VetC e VetD
        la $t1, 0       # i = 0 VetC
		la $t5, 0		# j = 0 VetD
		la $t6, 0		# k = 0 VetE
		
		loop_intercalar:
			vetC_par:
                add $t2, $t1, $s0		# $t2 = deslocamento + endereço base do vetor 1 ($t2 == &vetC[i])
                lw $t3, 0($t2)		# $t3 = vetC[i]

                add $t2, $t6, $s6
                sw $t3, 0($t2)      # VetE[k] = VetC[i]

                addi $t0, $t0, 1        # contador do VetE += 1

			    sll $t6, $t0, 2		# $t6 = 4 * i (i.e, deslocamento)

			beq $t0, $s2, terminar_loop

			vetD_impar:
                add $t2, $t5, $s1		# $t2 = deslocamento + endereço base do vetor 2 ($t2 == &vetD[i])
                lw $t4, 0($t2)		# $t4 = vetD[i]

                add $t2, $t6, $s6
                sw $t4, 0($t2)      # VetE[k] = VetD[j]

                addi $t0, $t0, 1        # contador do VetE += 1
                addi $t7, $t7, 1        # contador do VetC e VetD += 1

                sll $t5, $t7, 2		# $t5 = 4 * i (i.e, deslocamento)
                sll $t1, $t7, 2		# $t1 = 4 * i (i.e, deslocamento)
			    sll $t6, $t0, 2		# $t6 = 4 * i (i.e, deslocamento)

            beq $t0, $s2, terminar_loop     # se($t0 == $s2), va para terminar_loop
            j vetC_par      # se nao, va para vetC_par
		
		terminar_loop:
			jr $ra		# volta para a funcao main
		
	imprimir:		# ($a0 = string, $a1 = inteiro )
        la $t1, 0
        la $t0, 0

        loop_imprimir:
            add $t2, $t1, $a3
            lw $a0, 0($t2)
            li $v0, 1       # syscall para imprimir o respectivo valor do vetor
            syscall

            la $a0, 32      # 32 == codigo ASCII para imprimir um espaco em branco " "
            li $v0, 11
            syscall

            addi $t0, $t0, 1        # j++
            sll $t1, $t0, 2		# $t1 = 4 * i (i.e, deslocamento)
            blt $t0, $a2, loop_imprimir     # se ($t0 < $a2), va para loop_imprimir_matriz

        la $a0, msg7		# carrega o endereco da string
		li $v0, 4		# codigo de impressao de string
		syscall		# imprime a string

		jr $ra		# retornando o controle para o chamador
