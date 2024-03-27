.data
	prompt1: .asciiz "\nmat["
	prompt2: .asciiz "]["
	prompt3: .asciiz "] = "
	LinhasNulas: .asciiz "\nLinhas nulas da matriz: "
	ColunasNulas: .asciiz "\nColunas nulas da matriz: "
		
.text
	main: 
        la $a0, mat		# Endereco base de Mat
        li $a1, 4		# numero de linhas
        li $a2, 3		# numero de colunas

        jal ler_matriz		# ler_matriz(mat, nlin, ncol)
        
        move $a0, $v0		# endereco da matriz lida
        
        jal escrita		# escrita(mat, nlin, ncol)

        move $a0, $v0		# endereco da matriz lida
		
		la $s3, mat
        la $s2, 4
        la $s1, 4

		jal calcular_linhas_colunas_nulas       # (matriz:endereco, linhas:int, colunas:int):int*

        la $a0, LinhasNulas     # syscall para imprimir "\nLinhas nulas da matriz: "
        li $v0, 4
        syscall

        la $a0, $v0     # syscall para imprimir um inteiro
        li $v0, 1
        syscall

        la $a0, ColunasNulas        # syscall para imprimir "\nColunas nulas da matriz: "
        li $v0, 4
        syscall

        la $a0, $v1     # syscall para imprimir um inteiro
        li $v0, 1
        syscall
	
        jal fim_main        # encerra o programa

    indice:
        mul $v0, $t0, $a2		# i * ncol
        add $v0, $v0, $t1		# (i * ncol) + j
        sll $v0, $v0, 2		# [(i * ncol) + j] * 4 (inteiro)
        add $v0, $v0, $a3		# soma o endereco base de mat

        jr $ra		# volta para a funcao        

    ler_matriz:
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

	calcular_endereco_elemento_matriz:      # (i:int, j:int, colunas:int, matriz:endereco):endereco -> calcula o endereço do elemento mat[i][j]
	 
		mul $v0, $a0, $a2       # i * ncol (calcula a posicao do inicio da linha i)
		add $v0, $v0, $a1       # (i * ncol) + j (calcula a posicao do elemento em sua linha)
		sll $v0, $v0, 2     # [(i * ncol) + j] * 4(calcula o deslocamento em bytes para se chegar no elemento mat[i][j])
		add $v0, $v0, $a3       # retona a soma do endereço base da matriz ao deslocamento (i.e, return &mat[i][j])

        beq $s6, $s7, m     # se ($s6 == $s7), va para m
        j n     # se nao, va para n
		
				
	calcular_linhas_colunas_nulas:      # (matriz:endereco, linhas:int, colunas:int):int*
		la $s0, ($a0)       # $s0 = endereço matriz
		addi $s1, $a1, 0        # $s1 = linhas da matriz
		addi $s2, $a2, 0        # $s2 = colunas da matriz
		addi $s3, $zero, 0      # Numero de linhas nulas = 0 
		addi $s4, $zero, 0      # Numero de colunas nulas = 0	
        la $s7, 0
		
		addi $t0, $zero, 0      # i = 0
		addi $t1, $zero, 0      # j = 0
		
		loop_calcular_linhas:
			loop_i_calcular_linhas:
			    addi $t2, $zero, 0      # somaLinha  ($t2) = 0  
                la $t7, 0
		
				loop_j_calcular_linhas:
                    addi $a0, $t0, 0
                    addi $a1, $t1, 0
                    addi $a2, $s2, 0 
                    la $a3, ($s0)
                    la $s6, 0

                    blt $t7, $s1, calcular_endereco_elemento_matriz     # se ($t7 < nlin), va para calcular_endereco_elemento_matriz

                    m:
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
                    la $s6, 1	

                    blt $t7, $s1, calcular_endereco_elemento_matriz     # se ($t7 < nlin), va para calcular_endereco_elemento_matriz

                    n:
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

            jr $ra      # volta para a funcao main
    
    fim_main:
		addi $v0, $zero, 10		# syscall para encerrar o programa
		syscall
