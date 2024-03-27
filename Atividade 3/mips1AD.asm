.data
	prompt1: .asciiz "\nDigite uma matriz[4][3]:\n"
	prompt2: .asciiz "\nMatriz["
	prompt3: .asciiz "]["
	prompt4: .asciiz "] = "
	prompt5: .asciiz "\nDigite um vetor de 3 elementos:\n"
	prompt6: .asciiz "\nVetor["
	prompt7: .asciiz "\n\nResultado:\n\n"
	vezes: .asciiz "\nx\n\n"
	igual: .asciiz "\n=\n\n"
	
.text
	main: 
		addi $v0, $zero, 4
		la $a0, prompt1     # syscall que pede para o usuario digitar a matriz
		syscall		
		
		addi $s0, $zero, 4
		addi $s1, $zero, 3
		addi $s2, $zero, 4      # $s2 = tamanho dos elementos em bytes = 4 bytes = sizeof(int)
	
		addi $a0, $s0, 0 
		addi $a1, $s1, 0
		addi $a2, $s2, 0

		jal alocar_matriz       # (linhas:int, colunas:int, tamElemento:int):endereco

		la $s3, ($v0)       # $s3 = endereco base da matriz
		
		addi $a0, $s3, 0
		addi $a1, $s0, 0 
		addi $a2, $s1, 0

		jal ler_matriz      # (matriz:endereco, linhas:int, colunas:int):void
		
		addi $a0, $s1, 0
		addi $a1, $s2, 0

		jal alocar_vetor        # (tamVet:int, tamElemento:int):endereco

		la $s4, ($v0)       # $s4 = endereco base de vet
		
		addi $a0, $s4, 0
		addi $a1, $s1, 0

		jal ler_vetor       # (vet:endereco, tamVet:int):void

		# produto matriz-vet: A(mxn) x V(nx1) = B(mx1)
		addi $a0, $s3, 0
		addi $a1, $s0, 0 
		addi $a2, $s1, 0
		addi $a3, $s4, 0

		jal matriz_x_vetor      # (matriz:endereco, linhas:int, colunas:int, vet:endereco):endereco -> retorna um vetor com o resultado da multiplicacao

		la $s5, 0($v0)      # $s5 = endereco base do vetor resultado da multiplicacao
		
		la $a0, prompt7     # syscall para apresentar o resultado
		addi $v0, $zero, 4 
		syscall
		
		addi $a0, $s3, 0
		addi $a1, $s0, 0 
		addi $a2, $s1, 0
		jal imprimir_matriz     # (matriz:endereco, linhas:int, colunas:int):void
		
		addi $v0, $zero, 4 
		la $a0, vezes
		syscall     # syscall para imprimir o "x"
		
		addi $a0, $s4, 0
		addi $a1, $s1, 0 
		addi $a2, $zero, 1
		jal imprimir_matriz     # (matriz:endereco, linhas:int, colunas:int):void
		
		addi $v0, $zero, 4 
		la $a0, igual
		syscall     # syscall para imprimir o "="
		
		addi $a0, $s5, 0
		addi $a1, $s0, 0 
		addi $a2, $zero, 1
		jal imprimir_matriz     # (matriz:endereco, linhas:int, colunas:int):void
		
		jal encerrar
		
	alocar_matriz:      # (linhas:int, colunas:int, tamElemento:int):endereco
		mult $a0, $a1 
		mflo $a0        # $a0 = linhas * colunas = numero total de elementos
		
		mult $a0, $a2
		mflo $a0        # $a0 = numero total de elementos * tamanho de um elemento = total de bytes da representacao da matriz na memoria
		
		addi $v0, $zero, 9
		syscall     # aloca $a0 bytes e guarda o endereço do inicio do bloco em $v0
		
		jr $ra      # volta para a funcao main	
		

	ler_matriz:     # (matriz:endereco, linhas:int, colunas:int):void
		subi $sp, $sp, 12
		sw $s0, 0($sp)
		sw $s1, 4($sp)
		sw $ra, 8($sp)      # vamos chamar um procedimento, entao, precisamos salvar o endereço de retorno de "leitura" na pilha
		
		move $a3, $a0       # $a3 = endereco base matriz
		addi $s0, $a1, 0        # $s0 = numero de linhas
		addi $s1, $a2, 0        # $s1 = numero de colunas
		addi $t0, $zero, 0      # i = 0
		addi $t1, $zero, 0      # j = 0
		
		loop_ler_matriz: 
            la $a0, prompt2
            li $v0, 4
            syscall     # syscall para imprimir mat[
            
            move $a0, $t0
            li $v0, 1
            syscall     # syscall para imprimir o indice i em mat[i][]
        
            la $a0, prompt3
            li $v0, 4
            syscall     # syscall para imprimir os colchetes "]["
        
            move $a0, $t1
            li $v0, 1
            syscall     # syscall para imprimir o indice j em mat[][j]
        
            la $a0, prompt4
            li $v0, 4
            syscall     # syscall para imprimir o colchete "]: "
        
            li $v0, 5
            syscall     # lendo o valor de Mat[i][j]
            move $t2, $v0       # $t2 = valor
        
            addi $a0, $t0, 0
            addi $a1, $t1, 0
            addi $a2, $s1, 0

            jal calcular_endereco_elemento_matriz       # (i:int, j:int, colunas:int, matriz:endereco):endereco

            sw $t2, 0($v0)      # Mat[i][j] = $t2
        
            addi $t1, $t1, 1        # j++
            blt $t1, $s1, loop_ler_matriz       # if (j < ncol), va para loop_ler_matriz
        
            li $t1, 0       # j = 0
            addi $t0, $t0, 1        # i++
            blt $t0, $s0, loop_ler_matriz       # if i< n lin, va para loop_ler_matriz
        
            sw $s0, 0($sp)
            sw $s1, 4($sp)
            lw $ra, 8($sp)      # recuperando o endereco de retorno para a main
            addi $sp, $sp, 12
            
            jr $ra      # volta para a funcao main

	imprimir_matriz:        # (matriz:endereco, linhas:int, colunas:int):void
		subi $sp, $sp, 12
		sw $s0, 0($sp)
		sw $s1, 4($sp)
		sw $ra, 8($sp)
		
		move $a3, $a0       # $a3 = endereço base matriz
		addi $s0, $a1, 0        # $s0 = numero de linhas
		addi $s1, $a2, 0        # $s1 = numero de colunas
		addi $t0, $zero, 0      # i = 0
		addi $t1, $zero, 0      # j = 0	
	
		loop_imprimir_matriz: 
			addi $a0, $t0, 0
			addi $a1, $t1, 0
			addi $a2, $s1, 0

			jal calcular_endereco_elemento_matriz       # (i:int, j:int, colunas:int, matriz:endereco):endereco

			lw $a0, 0($v0)
			
			li $v0, 1
			syscall     # syscall para imprimir mat[i][j]
	
			la $a0, 32      # 32 == codigo ASCII para imprimir um espaco em branco " "
			li $v0, 11
			syscall
	
			addi $t1, $t1, 1        # j++
			blt $t1, $s1, loop_imprimir_matriz      # if (j < ncol), va para loop_imprimir_matriz
 	
			la $a0, 10      # 10 == codigo ASCII para nova linha ('\n')
			syscall
	
			li $t1, 0       # j = 0
			addi $t0, $t0, 1        # i++
			blt $t0, $s0, loop_imprimir_matriz      # if (i < nlin), va para loop_imprimir_matriz
			li $t0, 0       # i = 0
	 
			lw $s0, 0($sp)
			lw $s1, 4($sp)
			lw $ra, 8($sp)      # recuperando o endereco de retorno para a main
			addi $sp, $sp, 12

			jr $ra      # volta para a funcao main

	calcular_endereco_elemento_matriz:      # (i:int, j:int, colunas:int, matriz:endereco):endereco -> calcula o endereço do elemento mat[i][j]
		mul $v0, $a0, $a2       # i * ncol (calcula a posicao do inicio da linha i)
		add $v0, $v0, $a1       # (i * ncol) + j (calcula a posicao do elemento em sua linha)
		sll $v0, $v0, 2     # [(i * ncol) + j] * 4(calcula o deslocamento em bytes para se chegar no elemento mat[i][j])
		add $v0, $v0, $a3       # retona a soma do endereço base da matriz ao deslocamento (i.e, return &mat[i][j])

		jr $ra      # volta para a funcao main
	
	alocar_vetor:       # (tamVet:int, tamElemento:int):endereco
		mult $a0, $a1
		mflo $a0        # $a0 = tamVet * tamElemento = total de bytes do vetor
		
		addi $v0, $zero, 9
		syscall     # aloca $a0 bytes e guarda o endereço do inicio do bloco em $v0
		
		jr $ra      # volta para a funcao main
		
	ler_vetor:      # (vetor:endereco, tamVet:int):void
		addi $sp, $sp, -12      # armazenando valores de $s0/$s1/$s2 na pilha
		sw $s0, 0($sp)
		sw $s1, 4($sp)
		sw $s2, 8($sp)
					 	  
		add $s0, $a1, $zero     # guardar o tamanho do vetor em $s0
		la $s1, ($a0)       # endereço base do vetor
		add $s2, $zero, $zero       # i = 0 
		
		addi $v0, $zero, 4
		la $a0, prompt5
		syscall     # syscall para imprimir "\nDigite um vetor de 3 elementos:\n"
		
		leitura:
			sll $t0, $s2, 2     # $t0 = 4 * i (i.e, deslocamento)
			add $t0, $t0, $s1       # $t0 = deslocamento + endereco base do vetor (t0 == &vetor[i])
			
			addi $v0, $zero, 4
			la $a0, prompt6
			syscall     # syscall para imprimir "vetor["
			
			addi $v0, $zero, 1
			add $a0, $zero, $s2
			syscall     # syscall para imprimir o indice "i"
			
			addi $v0, $zero, 4
			la $a0, prompt4
			syscall     # syscall para imprimir "] =" 
			
			addi $v0, $zero, 5
			syscall     # syscall para ler um inteiro "vetor[i]"
			sw $v0, 0($t0)      # guardar o valor lido em vetor[i]
			
			addi $s2, $s2, 1        # i++
			bne $s2, $s0, leitura       # while(i < numero de elementos do vetor)
		
		lw $s0, 0($sp)      # guardando os valores originais de volta em $s0/$s1/$s2
		lw $s1, 4($sp)
		lw $s2, 8($sp)
		addi $sp, $sp, 12       # desempilhando $s0/$s1/$s2

		jr $ra      # volta para a funcao main
			
	imprimir_string_inteiro:     #($a0 = string, $a1 = inteiro)
		addi $v0, $zero, 4 
		syscall	
		
		addi $v0, $zero, 1
		addi $a0, $a1, 0
		syscall 

		jr $ra      # volta para a funcao main	
			
	matriz_x_vetor:     # (matriz:endereco, linhas:int, colunas:int, vetor:endereco):endereco -> retorna um vetor com o resultado da multiplicacao
		addi $sp, $sp, -24      # armazenando valores de $s0/$s1/$s2/$s3/$s4 na pilha
		sw $s0, 0($sp)
		sw $s1, 4($sp)
		sw $s2, 8($sp)
		sw $s3, 12($sp)
		sw $s4, 16($sp)
		sw $ra, 20($sp)
		
		la $s0, ($a0)       # $s0 = endereco base matriz
		la $s1, ($a3)       # $s1 = endereco base vetor
		addi $s2, $a1, 0        # $s2 = linhas da matriz / tamanho do vetor resultado
		addi $s3, $a2, 0        # $s3 = colunas da matriz / tamanho do vetor
		
		# alocando vetor resultado:
		addi $a0, $s2, 0
		addi $a1, $zero, 4

		jal alocar_vetor        # (tamVet:int, tamElemento:int):endereco

		la $s4, ($v0)
		
		addi $t0, $zero, 0      # $t0(i) = 0
		addi $t1, $zero, 0      # $t1(j) = 0
		
		
		loop_mult_i:
			addi $t2, $zero, 0      # $t2 (soma) = 0
			
		loop_mult_j:
			addi $a0, $t0, 0
			addi $a1, $t1, 0
			addi $a2, $s3, 0 
			la $a3, ($s0)

			jal calcular_endereco_elemento_matriz       # (i:int, j:int, colunas:int, matriz:endereco):endereco

			lw $t3, 0($v0)      # $t3 = mat[i][j]
			
			sll $t4, $t1, 2     # $t4 = j * 4 (i.e, deslocamento)
			add $t4, $t4, $s1       # $t4 = &vet[j]
			lw $t5, 0($t4)      # $t5 = vet[j]
			
			mult $t3, $t5
			mflo $t5        # $t5 = mat[i][j] * vet[j]
			
			add $t2, $t2, $t5       # $t2 (soma) += mat[i][j] * vet[j]
			
			addi $t1, $t1, 1        # j++
			blt $t1, $s3, loop_mult_j       # if (j < ncol), va para loop_mult_j
 	
 	
 			sll $t4, $t0, 2     # $t4 = i * 4 (i.e, deslocamento)
			add $t4, $t4, $s4       # $t4 = &vetResultado[i]
			sw $t2, 0($t4)      # vetResultado[i] = soma
 	
			addi $t1, $zero, 0      # j = 0
			addi $t0, $t0, 1        # i++
			blt $t0, $s2, loop_mult_i       # if (i < nlin), va para loop_mult_i

		la $v0, ($s4)
		lw $s0, 0($sp)
		lw $s1, 4($sp)
		lw $s2, 8($sp)
		lw $s3, 12($sp)
		lw $s4, 16($sp)
		lw $ra, 20($sp)
		addi $sp, $sp, 24

		jr $ra      # volta para a funcao main

    encerrar:
        li $v0, 10      # syscall para encerrar o programa
		syscall 