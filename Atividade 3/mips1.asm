.data
    mat: .space 48      # (4x3) * 4 
    vet: .space 12
    vetR: .space 16

    prompt1: .asciiz "\nInsira o valor de mat["
	prompt2: .asciiz "]["
	prompt3: .asciiz "]: "
    prompt4: .asciiz "\n\nResultado:\n\n"
    prompt5: .asciiz "\nDigite os 3 elementos do vetor: "
    espaco: .asciiz " "
	inteiro: .asciiz "\nDigite um numero: "
	
.text
	main: 
        la $a0, mat		# Endereco base de Mat
        li $a1, 4		# numero de linhas
        li $a2, 3		# numero de colunas

        jal ler_matriz		# ler_matriz(mat, nlin, ncol)
        
        move $a0, $v0		# endereco da matriz lida
        
        jal escrita		# escrita(mat, nlin, ncol)

        move $a0, $v0		# endereco da matriz lida

        la $a0, prompt5     # syscall para imprimir "\nDigite os 3 elementos do vetor: "
		addi $v0, $zero, 4 
		syscall

        jal preencher

        la $a1, vet     # $a1 = endereco inicial de vet

		# produto matriz-vet: A(mxn) x V(nx1) = B(mx1)
		jal matriz_x_vetor      # (matriz:endereco, linhas:int, colunas:int, vet:endereco):endereco -> retorna um vetor com o resultado da multiplicacao

		la $s5, 0($v0)      # $s5 = endereco base do vetor resultado da multiplicacao
		
		la $a0, prompt4     # syscall para apresentar o resultado
		addi $v0, $zero, 4 
		syscall
		
		jal imprimir_vet        # imprime o vetor
		
		jal encerrar        # encerra o programa

	calcular_endereco_elemento_matriz:      # (i:int, j:int, colunas:int, matriz:endereco):endereco -> calcula o endereço do elemento mat[i][j]
		mul $v0, $a0, $a2       # i * ncol (calcula a posicao do inicio da linha i)
		add $v0, $v0, $a1       # (i * ncol) + j (calcula a posicao do elemento em sua linha)
		sll $v0, $v0, 2     # [(i * ncol) + j] * 4(calcula o deslocamento em bytes para se chegar no elemento mat[i][j])
		add $v0, $v0, $a3       # retona a soma do endereço base da matriz ao deslocamento (i.e, return &mat[i][j])

		j k     # va para k
			
	matriz_x_vetor:     # (matriz:endereco, linhas:int, colunas:int, vetor:endereco):endereco -> retorna um vetor com o resultado da multiplicacao
        la $s0, mat
        la $s1, vet
        la $s2, 4       # $s2 = linhas da matriz / tamanho do vetor resultado
        la $s3, 3       # $s3 = colunas da matriz / tamanho do vetor
        
		la $s4, vetR        # $s4 = vetR
		
		addi $t0, $zero, 0      # $t0(i) = 0
		addi $t1, $zero, 0      # $t1(j) = 0
		
		
		loop_mult_i:
			addi $t2, $zero, 0      # $t2 (soma) = 0
			
		loop_mult_j:
			addi $a0, $t0, 0
			addi $a1, $t1, 0
			addi $a2, $s3, 0 
			la $a3, ($s0)
     
            blt $t0, $s2, calcular_endereco_elemento_matriz     # (i:int, j:int, colunas:int, matriz:endereco):endereco

            k:
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

		jr $ra      # volta para a funcao main
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

    preencher:
        li $t1, 0       # $s0 = 0, ira ser nosso contador i=0
        
        la $t0, vet     # $t0 = endereco inicial de vet

        loop_preencher:
            bge $t1, 3, fim_loop       # se $s0 for maior ou igual a 12 o loop se encerra
            
            li $v0, 4       # chama a mensagem para digitar um numero
            la $a0, inteiro
            move $a1, $t1       # passa o contador como argumento
            syscall
            
            li $v0, 5       # syscall para ler um numero inteiro
            syscall
            sw $v0, 0($t0)      # armazena o inteiro no vetor

            addi $t0, $t0, 4        # move para a proxima posicao de vet
            
            addi $t1, $t1, 1        # incrementa o contador, i=i+1
            
            j loop_preencher        # recomeca o loop

        fim_loop:
            jr $ra

    imprimir_vet:
        # imprime os elementos do vetor
        li $t1, 0       # reinicia o contador do loop

        la $t0, vetR   # reinicia o ponteiro do vetor

    preencher_loop:
        bge $t1, 4, vetor_sair     # verifica se o contador eh igual a 12 (numero de elementos)

        lw $a0, 0($t0)      # carrega o proximo elemento do vetor
        li $v0, 1      # syscall para imprimir um inteiro
        syscall
        
        li $v0, 4 
        la $a0, espaco      # da um espaco
        syscall

        addi $t1, $t1, 1    # incrementa o contador

        addi $t0, $t0, 4    # move para o proximo elemento do vetor

        j preencher_loop    # repete o loop

    vetor_sair:
        jr $ra      # volta para a main e executa a proxima instrucao

    encerrar:
        li $v0, 10      # syscall para encerrar o programa
        syscall 
