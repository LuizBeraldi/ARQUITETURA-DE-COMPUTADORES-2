.data

    Erro: .asciiz "Arquivo nao encontrado!\n"
    soma: .asciiz "\ne)Soma dos valores: "
    pares: .asciiz "\nd)Quantidade de numeros pares: "
	buffer: .asciiz " "
    maiorV: .asciiz "\na)Maior valor: "
    menorV: .asciiz "\nb)Menor valor: "
    Valores: .asciiz "\nValores:\n"
	Arquivo: .asciiz "dados1.txt"
    impares: .asciiz "\nc)Quantidade de numeros impares: "
    produto: .asciiz "\nh)O produto dos elementos: "
    crescente: .asciiz "\nf)Ordem crescente: "
    decrescente: .asciiz "\ng)Ordem decrescente: "
    numCaracteres: .asciiz "\ni)O numero de caracteres no arquivo: "
    

.text

    	li $s1, 0		# $s1 usado para obter o numero separadamente
		li $s2, 0		# $s2 o somatorio final
    	li $s3, 0       # Usado para saber quantos numeros sao impares
    	li $s4, 0       # Usado para saber quantos numeros sao pares
    	li $s5, 1       # Usado pro produto dos valores
    	li $s6, 0       # Quantidade de caracteres do arquivo

    	li $t9, 0      # Usado para saber quantos valores foram digitados

	main:
		la $a0, Arquivo 	# Nome do arquivo
		li $a1, 0 		# Somente leitura

		jal abertura 		# Retorna file descriptor no sucesso

		move $s0, $v0 		# Salva o file descriptor em $s0
		move $a0, $s0 		# Parametro file descriptor
        la $a1, buffer
        li $a2, 1         # Caractere por leitura

        jal contagem

        li $v0, 16 		# Codigo para fechar o arquivo
        move $a0, $s0 		# Parametro file descriptor
		syscall

        	Alocacao:
            	add $s6, $zero, $t0     # Armazena em s6 a quantidade de caracteres do arquivo
            	mul $a0, $t0, 4      # $a0 recebe o valor lido de N por 4(Espaco ocupado por 1 Byte)
            	li $v0, 9       # Codigo SysCall de alocacao dinamica
            	syscall       # Chamada de sistema para alocacao

            	move $a3, $v0    # Move $v0 para $a3, (a3) endereco base do vetor alocado
        	
        la $a0, Arquivo 	# Nome do arquivo
		li $a1, 0 		# Somente leitura

		jal abertura 	# Retorna file descriptor no sucesso

		move $s0, $v0 		# Salva o file descriptor em $s0
		move $a0, $s0 		# Parametro file descriptor
		
		jal percorre 		# Percorre o arquivo novamente calculando os valores lidos e armazenando no vetor

	    li $v0, 16 			# Codigo para fechar o arquivo
		move $a0, $s0 		# Parametro file descriptor
		syscall 		# Fecha o arquivo
		
		la $a0, Valores
		li $v0, 4
		syscall

        jal Escrita_Vetor     # Escrita dos valores lidos
        	
        jal Ordenacao_Vetor		# Ordenacao crescente
        	
        	LetraA:
        		la $a0, maiorV
        		li $v0, 4
				syscall
			
				addi $t0, $t9, -1		# $t0 recebe tamanho do vetor -1
				mul $t0, $t0, 4			# $t0 recebe (N - 1) * 4 bytes
				add $t0, $t0, $a3		# $t0, recebe o endereco somado com a posicao calculada
			
				lw $a0, ($t0)
				li $v0, 1
				syscall
			
        	LetraB:
        		la $a0, menorV
        		li $v0, 4
				syscall

				lw $a0, ($a3)
				li $v0, 1
				syscall
			
        	LetraC:
        		jal LetraCDEH

        		la $a0, impares
				li $v0, 4
				syscall			# Imprime a mensagem de saida

            	move $a0, $s3
				li $v0, 1
				syscall
			
			LetraD:
        		la $a0, pares
				li $v0, 4
				syscall			# Imprime a mensagem de saida

            	move $a0, $s4
				li $v0, 1
				syscall
			
			LetraE:
				la $a0, soma
				li $v0, 4
				syscall		# Imprime a mensagem de saida

            	move $a0, $s2
				li $v0, 1
				syscall
		
			LetraF:
				la $a0, crescente
				li $v0, 4
				syscall		# Imprime a mensagem de saida

            	jal Escrita_Vetor
		
			LetraG:
				la $a0, decrescente
				li $v0, 4
				syscall		# Imprime a mensagem de saida

            	jal Escrita_Decrescente
				
			LetraH:
				la $a0, produto
				li $v0, 4
				syscall		# Imprime a mensagem de saida

            	move $a0, $s5
				li $v0, 1
				syscall
			
        	LetraI:
				la $a0, numCaracteres
				li $v0, 4
				syscall		# Imprime a mensagem de saida

            	move $a0, $s6
				li $v0, 1
				syscall
			
			li $v0, 10 		# Codigo para finalizar o programa
			syscall 	# Finaliza o programa

	contagem:
        	li $v0, 14 		# Codigo de leitura de arquivo
        	syscall

        	addi $t0, $t0, 1
        	bnez $v0, contagem  		# Se $v0 eh diferente do final do arquivo
        	addi $t0, $t0, -1   		# Desconsiderando o final do arquivo

        	jr $ra

	percorre:
		move $a0, $s0
		li $v0, 14 		# Codigo de leitura de arquivo
		la $a1, buffer
		li $a2, 1
		syscall 		# Faz a leitura de 1 caractere e armazena em a1

		beqz $v0, Retorno			# Se chegou ao final do arquivo salta pro label Sair
		
		lb $t1, ($a1)		# $t1 recebe o caractere
		addi $t1, $t1, -48			# Subtrai 48 do caractere para obter o inteiro correspondente ao valor
		
		li $t2, -16		# $t2 recebe -16 (valor inteiro do espaco)
		
		bne $t1, $t2, some		# Se o nao for caractere espaco soma
		beq $t1, $t2, divide		# Se for o espaco divide e zera o s1
		
		j percorre 		# se(ch != EOF), va para contagem
		
		some:
			add $s1, $s1, $t1
			mul $s1, $s1, 10
			j percorre
			
		divide:
            mul $t0, $t9, 4 	# $t0 recebe (posicao*4bytes)
			div $s1, $s1, 10        # Divide o valor por 10 para obter o valor real

            add $t0, $t0, $a3      # $t0 recebe a soma do endereco base do vetor + posicao calculada
            sw $s1, ($t0)      # Armazena o valor no vetor
            addi $t9, $t9, 1        # i++
			li $s1, 0		# Zera o s1
			
			j percorre

		Retorno:	
       			jr $ra 		# Retorna para a main

	LetraCDEH:
		li $t1, 0        # i = 0
        mul $t0, $t1, 4       # $t0 recebe posicao * 4bytes
        add $t0, $t0, $a3     # $t0 recebe o endereco + posicao calculada
        li $t8, 2      # Usado para armazenar o 2 para ser usado na verificacao de par/impar
        	
        Loop:
        	lw $a0, ($t0)     # Carrega em $a0 o valor da posicao (i) do vetor
            		
            add $s2, $s2, $a0
            mul $s5, $s5, $a0     # Adiciona o valor no produto dos valores
            		
            # Verificacao se eh par ou nao
            div $a0, $t8     # Divide o valor por 2
            mfhi, $t0     # $t0 recebe o resto
            beq $t0, $zero, Par    # se o resto eh zero o numero eh par  

            addi $s3, $s3, 1   # senao eh impar e soma em +1 o somatorio dos impares 
			j Continue
			
        	Par:
                addi $s4, $s4, 1    # Somatorio pares +1
                j Continue
                	
                Continue:
                	addi $t1, $t1, 1    # Incrementa o $t1 (i) do vetor em +1
            		mul $t0, $t1, 4   	# $t0 recebe posicao * 4bytes
            		add $t0, $t0, $a3   # $t0 recebe o endereco + posicao calculada
            		blt $t1, $t9, Loop 	# Se $t1(i) for menor que $t9(Tamanho do vetor), vai para o laco de escrita novamente

            		jr $ra 
            		
    	Escrita_Vetor:
        	li $t1, 0      # i = 0
        	mul $t0, $t1, 4     # $t0 recebe posicao * 4bytes
        	add $t0, $t0, $a3     # $t0 recebe o endereco + posicao calculada

       	 	Laco_Escrita:  
            	lw $a0, ($t0)      # Carrega em $a0 o valor da posicao (i) do vetor
            		
            	li $v0, 1     # Codigo syscall para escrita de inteiros        
            	syscall    # Chamada de sistema para escrita do inteiro

            	li $a0, 32    # Codigo SysCall de ASCII para escrever espaco
            	li $v0, 11     # Codigo SysCall para imprimir caracteres
            	syscall     # Chamada de sistema para impressao do espaco
            
            	addi $t1, $t1, 1    # Incrementa o $t2 (i) do vetor em +1
            	mul $t0, $t1, 4     # $t0 recebe posicao * 4bytes
            	add $t0, $t0, $a3    # $t0 recebe o endereco + posicao calculada
            	blt $t1, $t9, Laco_Escrita  	# Se $t1(i) for menor que $t9(Tamanho do vetor), vai para o laco de escrita novamente

            	jr $ra 
	
	Escrita_Decrescente:
		addi $t1, $t9, -1
		mul $t0, $t1, 4     # $t0 recebe posicao * 4bytes
        add $t0, $t0, $a3    # $t0 recebe o endereco + posicao calculada
        	
        	Loop_ED:
        		lw $a0, ($t0)    # Carrega em $a0 o valor da posicao (i) do vetor
            		
            	li $v0, 1     # Codigo syscall para escrita de inteiros        
            	syscall     # Chamada de sistema para escrita do inteiro

            	li $a0, 32   # Codigo SysCall de ASCII para escrever espaco
            	li $v0, 11   # Codigo SysCall para imprimir caracteres
            	syscall      # Chamada de sistema para impressao do espaco
            
            	addi $t1, $t1, -1    # Incrementa o $t2 (i) do vetor em +1
            	mul $t0, $t1, 4        # $t0 recebe posicao * 4bytes
            	add $t0, $t0, $a3    # $t0 recebe o endereco + posicao calculada
            	bge $t1, $zero, Loop_ED     # Se $t1(i) for menor que $t9(Tamanho do vetor), vai para o laco de escrita novamente

            	jr $ra
		
	Ordenacao_Vetor:
		move $t8, $a3	  # $t8 possui o endereco base do vetor
        subi $t3, $t9, 1       # Subtrai 1 do valor de $a1(indice j)

       	Laco1:                              	
            li $t2, 0    # Carrega 0 em $t2(i)
            beq $t2, $t3, Retorno		# Se $t2 for igual a $t3(i == j) entao vai para a funcao Resultado
            move $t1, $t8     # Armazena em $t1 o valor de $t9, t1 sera a posicao i do vetor
            addi $t0, $t1, 4      # $t0 recebe o endereco de vet[i+1]
            
			Laco2:                          
                lw $s0, ($t1)    # $s0 recebe o valor armazenado no endereco $t1(elemento i do vetor)
                lw $s1, ($t0)    # $s1 recebe o valor armazenado no endereco $t4(elemento i+1 do vetor)
               	ble $s0, $s1, Continua	    	# Se o elemento da posicao i for menor que da posicao i+1 avanca para o proximo laco                 
                sw $s1, ($t1)    # Caso seja maior troca de posicao deixando na posicao i o elemento que estava em i+1
                sw $s0, ($t0)    # Caso seja maior troca de posicao deixando na posicao i+1 o elemento que estava em i
           
                Continua:
                    addi $t1, $t1, 4       # Incrementa em $t1 o valor da proxima posicao do vetor
                    addi $t0, $t0, 4     	# Incrementa em $t0 o valor da proxima posicao do vetor
                    addi $t2, $t2, 1      	# Incrementa o indice $t2(i) em +1
                   	blt $t2, $t3, Laco2	    	# Se $t2 for menor que $t3(i < j) entao vai para o label Laco2
                    
            		subi $t3, $t3, 1      	# Subtrai 1 do valor de $t3(indice j)
            		bge $t3, 1, Laco1  	 # Se $t3 for maior ou igual a 1( j >= 1) vai para o label Laco1
            		jr $ra
            
	abertura:
		li $v0, 13 		# Codigo de abertura de arquivo
		syscall 	# Tenta abrir o arquivo

		bgez $v0, a 	    # se(file_descriptor >= 0), va para a

		la $a0, Erro 	# else erro: carrega o endereco da string
		li $v0, 4 	# Codigo de impressao de string
		syscall 	# Imprime o erro

		li $v0, 10 		# Codigo para finalizar o programa
		syscall 	# Finaliza o programa
        
	a: 	
        jr $ra 	    # Retorna para a main