.data
	prompt1: .asciiz "\nmat["
	prompt2: .asciiz "]["
	prompt3: .asciiz "] = "
	LinhasNulas: .asciiz "\nLinhas nulas da matriz: "
	ColunasNulas: .asciiz "\nColunas nulas da matriz: "
		
.text
	main: 
        la $s0, 4       # $s0 = numero de linhas(4)
        la $s1, 4       # $s1 = numero de colunas(4)
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
		
		addi $a0, $s3, 0
		addi $a1, $s0, 0 
		addi $a2, $s1, 0

		jal imprimir_matriz     # (matriz:endereco, linhas:int, colunas:int):void
		
		
		addi $a0, $s3, 0
		addi $a1, $s0, 0 
		addi $a2, $s1, 0

		jal calcular_linhas_colunas_nulas       # (matriz:endereco, linhas:int, colunas:int):int*

		addi $s4, $v0, 0
		addi $s5, $v1, 0
		
		la $a0, LinhasNulas
		addi $a1, $s4, 0

		jal imprimir_string_inteiro      # (a0 = string, a1 = inteiro )
		
		la $a0, ColunasNulas
		addi $a1, $s5, 0

		jal imprimir_string_inteiro      # (a0 = string, a1 = inteiro )
	
        jal fim_main        # encerra o programa

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
            la $a0, prompt1
            li $v0, 4
            syscall     # syscall para imprimir "Insira o valor de Mat["
            
            move $a0, $t0
            li $v0, 1
            syscall     # syscall para imprimir o indice "i"
        
            la $a0, prompt2
            li $v0, 4
            syscall     # syscall para imprimir "]["
        
            move $a0, $t1
            li $v0, 1
            syscall     # syscall para imprimir o indice "j"
        
            la $a0, prompt3
            li $v0, 4
            syscall     # syscall para imprimir "]: "
        
            li $v0, 5
            syscall     # lendo o valor de Mat[i][j]
            move $t2, $v0       # $t2 = valor
        
            addi $a0, $t0, 0
            addi $a1, $t1, 0
            addi $a2, $s1, 0

            jal indice       # (i:int, j:int, colunas:int, matriz:endereco):endereco

            sw $t2, 0($v0)      # Mat[i][j] = t2
        
            addi $t1, $t1, 1        # j++
            blt $t1, $s1, loop_ler_matriz       # if (j < ncol), va para loop_ler_matriz
        
            li $t1, 0       # j = 0
            addi $t0, $t0, 1        # i++
            blt $t0, $s0, loop_ler_matriz       # if (i < nlin), va para loop_ler_matriz
        
            sw $s0, 0($sp)
            sw $s1, 4($sp)
            lw $ra, 8($sp)      # recuperando o endereço de retorno para a main
            addi $sp, $sp, 12

            jr $ra      # volta para a funcao main

	imprimir_matriz:        # (matriz:endereco, linhas:int, colunas:int):void
		subi $sp, $sp, 12
		sw $s0, 0($sp)
		sw $s1, 4($sp)
		sw $ra, 8($sp)
		
		move $a3, $a0       # $a3 = endereco base matriz
		addi $s0, $a1, 0        # $s0 = numero de linhas
		addi $s1, $a2, 0        # $s1 = numero de colunas
		addi $t0, $zero, 0      # i = 0
		addi $t1, $zero, 0      # j = 0	
	
		la $a0, 10      # 10 == codigo ASCII para imprimir uma nova linha ('\n')
		li $v0, 11
		syscall
		
		loop_imprimir_matriz: 
			addi $a0, $t0, 0
			addi $a1, $t1, 0
			addi $a2, $s1, 0		

			jal indice       # (i:int, j:int, colunas:int, matriz:endereco):endereco

			lw $a0, 0($v0)
			
			li $v0, 1
			syscall     # syscall par imprimir mat[i][j]
	
			la $a0, 32      # 32 == codigo ASCII para imprimir um espaco em branco " "
			li $v0, 11
			syscall
	
			addi $t1, $t1, 1        # j++
			blt $t1, $s1, loop_imprimir_matriz      # if (j < ncol), va para loop_imprimir_matriz
 	
			la $a0, 10      # 10 == codigo ASCII para imprimir uma nova linha ('\n')
			syscall
	
			li $t1, 0 #j = 0
			addi $t0, $t0, 1 #i++
			blt $t0, $s0, loop_imprimir_matriz      # if (i < nlin), va para loop_imprimir_matriz
			li $t0, 0       # i = 0
	 
			lw $s0, 0($sp)
			lw $s1, 4($sp)
			lw $ra, 8($sp)      # recuperando o endereço de retorno para a main
			addi $sp, $sp, 12

			jr $ra      # volta para a funcao main

	indice:      # (i:int, j:int, colunas:int, matriz:endereco):endereco -> calcula o endereço do elemento mat[i][j]
	 
		mul $v0, $a0, $a2       # i * ncol (calcula a posicao do inicio da linha i)
		add $v0, $v0, $a1       # (i * ncol) + j (calcula a posicao do elemento em sua linha)
		sll $v0, $v0, 2     # [(i * ncol) + j] * 4(calcula o deslocamento em bytes para se chegar no elemento mat[i][j])
		add $v0, $v0, $a3       # retona a soma do endereço base da matriz ao deslocamento (i.e, return &mat[i][j])

		jr $ra      # volta para a funcao main
		
	imprimir_string_inteiro:     # (a0 = string, a1 = inteiro )

		addi $v0, $zero, 4 
		syscall	
		
		addi $v0, $zero, 1
		addi $a0, $a1, 0
		syscall 

		jr $ra      # volta para a funcao main	
		
				
	calcular_linhas_colunas_nulas:      # (matriz:endereco, linhas:int, colunas:int):int*
		subi $sp, $sp, 24
		sw $s0, 0($sp)
		sw $s1, 4($sp)
		sw $s2, 8($sp)
		sw $s3, 12($sp)
		sw $s4, 16($sp)
		sw $ra, 20($sp)
		  
		la $s0, ($a0)       # $s0 = endereço matriz
		addi $s1, $a1, 0        # $s1 = linhas da matriz
		addi $s2, $a2, 0        # $s2 = colunas da matriz
		addi $s3, $zero, 0      # Numero de linhas nulas = 0 
		addi $s4, $zero, 0      # Numero de colunas nulas = 0	
		
		addi $t0, $zero, 0      # i = 0
		addi $t1, $zero, 0      # j = 0
		
		loop_calcular_linhas:
			loop_i_calcular_linhas:
			    addi $t2, $zero, 0      # somaLinha  ($t2) = 0  
		
				loop_j_calcular_linhas:
                    addi $a0, $t0, 0
                    addi $a1, $t1, 0
                    addi $a2, $s2, 0 
                    la $a3, ($s0)

                    jal indice       # (i:int, j:int, colunas:int, matriz:endereco):endereco

                    lw $t4, 0($v0)      # $t4 = mat[i][j]
                
                    add $t2, $t2, $t4       # somaLinha  ($t2) += mat[i][j] 
                    
                    inc_j_linhas:
                    addi $t1, $t1, 1  	  	# j++
                    blt $t1, $s2, loop_j_calcular_linhas        # if (j < ncol), va para loop_j_calcular
			
			verificar_linha:
                bne $t2, $zero, inc_i_linhas        # if(somaLinha == 0)
                add $s3, $s3, 1     # Numero de linhas nulas++
			
			inc_i_linhas:
                addi $t1, $zero, 0      # j = 0
                addi $t0, $t0, 1        # i++
                blt $t0, $s1, loop_i_calcular_linhas        # if (i < nlin), va para loop_i_calcular			
			
		loop_calcular_colunas:
			addi $t0, $zero, 0      # i = 0
			
			loop_i_calcular_colunas:
			    addi $t3, $zero, 0      # somaColuna ($t3) = 0 		
		
				loop_j_calcular_colunas:
                    addi $a0, $t1, 0
                    addi $a1, $t0, 0
                    addi $a2, $s2, 0 
                    la $a3, ($s0)	

                    jal indice       # (i:int, j:int, colunas:int, matriz:endereco):endereco

                    lw $t4, 0($v0)       # $t4 = mat[j][i]
            
                    add $t3, $t3, $t4       # somaColuna ($t3) += mat[j][i]  
				
				inc_j_colunas:
                    addi $t1, $t1, 1        # j++
                    blt $t1, $s1, loop_j_calcular_colunas       # if (j < nlin), va para loop_j_calcular
			
			verificar_coluna:
                bne $t3, $zero, inc_i_colunas       #if (somaColuna == 0)
                add $s4, $s4, 1     # Numero de colunas nulas++
			
			inc_i_colunas:
                addi $t1, $zero, 0      # j = 0
                addi $t0, $t0, 1        # i++
                blt $t0, $s2, loop_i_calcular_colunas       # if (i < ncol), va para loop_i_calcular
									
		fim_calcular:
            addi $v0, $s3, 0
            addi $v1, $s4, 0
            lw $s0, 0($sp)
            lw $s1, 4($sp)
            lw $s2, 8($sp)
            lw $s3, 12($sp)
            lw $s4, 16($sp)
            lw $ra, 20($sp)
            addi $sp, $sp, 24

            jr $ra      # volta para a funcao main
    
    fim_main:
		addi $v0, $zero, 10		# syscall para encerrar o programa
		syscall
