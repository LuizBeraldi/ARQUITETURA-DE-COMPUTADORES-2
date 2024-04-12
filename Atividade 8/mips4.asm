.data

    nomeArquivo: .asciiz "matriz.txt"
    outputArquivo: .asciiz "matriz_saida.txt"
    espaco: .asciiz " "
    enter: .asciiz "\r\n"
    erro: .asciiz "Erro ao abrir arquivo!\n"
    buffer: .asciiz " "

.text
    .globl main
    main:
        # Abrir o arquivo de entrada
        li $v0, 13       # Syscall 13: Abrir arquivo
        la $a0, nomeArquivo # Endereço da string com o nome do arquivo
        li $a1, 0        # Somente leitura
        syscall

        bltz $v0, erro_abrir_arquivo # Checa se foi possível  abrir o arquivo (se $v0 < 0)

        j fim_erro  # senão jump para fim_erro

        erro_abrir_arquivo:
            addi		$v0, $0, 4		# system call #4 - print string
            la		$a0, erro
            syscall						# execute
            addi	$v0, $0, 10		# System call 10 - Exit
            syscall					# execute

        fim_erro:
            move $s0, $v0           # Guarda o descritor do arquivo na variável

            jal fscanfInt
            move 	$s1, $v0		# $s1 = linhas
            jal fscanfInt
            move 	$s2, $v0		# $s2 = colunas
            jal fscanfInt
            move 	$s3, $v0		# $s3 = n_anuladas

            mul $t0, $s1, $s2   # Multiplica linha * coluna
            mul $t0, $t0, 4     # Multiplica linha * coluna * sizeof(int)

            # Aloca $t0 bytes de memória
            move	$a0, $t0		# $t0 bytes para serem alocados
            addi	$v0, $0, 9		# Syscall para alocar memória
            syscall
            move 	$a3, $v0		# $a3 = $v0
            
            move 	$a2, $s2

            # for(i = 0; i < $s1; i++)
            li $t0, 0 # Inicializa a varíavel contadora i = 0

        for_linhas:
            bge $t0, $s1, fim_for_linhas # Se (i >= $s1), va para fim_for
        
            # for(j = 0; j < $s2; j++)
            li $t1, 0 # Inicializa a varíavel contadora j = 0
            for_colunas:
                bge $t1, $s2, fim_for_colunas # Se (j >= $s2), va para fim_for
            
                jal indice      # &matriz[i][j]
                li	$t2, 1		# $t2 = 1
                sw	$t2, ($v0)  # matriz[i][j]
            
                addi $t1, $t1, 1 # j++

                j for_colunas		# jump para for_colunas

            fim_for_colunas:
                addi $t0, $t0, 1 # i++

                j for_linhas		# jump para for_linhas

        fim_for_linhas:
            # for(i = 0; i < $s3; i++)
            li $t9, 0 # Inicializa a varíavel contadora i = 0

        for_anuladas:
            bge $t9, $s3, fim_for_anuladas # Se (i >= $s3), va para fim_for
        
                jal fscanfInt           # pula o '\n'
                jal fscanfInt           
                move 	$t8, $v0		# $t8 = linha
                jal fscanfInt
                move 	$t0, $t8		# $t0 = $t8
                move 	$t1, $v0		# $t1 = coluna
                move 	$a2, $s2

                jal indice      # &matriz[linha][coluna]

                sw	$zero, ($v0)  # matriz[i][j]
        
            addi $t9, $t9, 1 # i++

            j for_anuladas		# jump para for_anuladas

        fim_for_anuladas:
            # Fecha o arquivo de entrada
            li   $v0, 16       # syscall para fechar o arquivo
            move $a0, $s0
            syscall            # fecha o arquivo

            # Abrir o arquivo de saída
            li $v0, 13       # Syscall para abrir arquivo
            la $a0, outputArquivo # Endereço da string com o nome do arquivo
            li $a1, 1       # Somente escrita
            syscall

            bltz $v0, erro_abrir_arquivo # Checa se foi possível  abrir o arquivo (se $v0 < 0)
            move $s0, $v0           # Guarda o descritor do arquivo na variável

            # for(i = 0; i < $s1; i++)
            li $t0, 0 # Inicializa a varíavel contadora i = 0

        for_escrita_linhas:
            bge $t0, $s1, fim_for_escrita_linhas # Se (i >= $s1), va para fim_for
        
            # for(j = 0; j < $s2; j++)
            li $t1, 0 # Inicializa a varíavel contadora j = 0

            for_escrita_colunas:
                bge $t1, $s2, fim_for_escrita_colunas # Se (j >= $s2), va para fim_for
            
                move $a2, $s2		# $a2 = $s2

                jal indice      # &matriz[i][j]

                lw		$a0, ($v0)		# $a0 = matriz[i][j]

                jal	fprintInt	# jump de fprintInt e salva a posição no $ra
                
                la $a1, espaco
                li $a2, 1
                li $v0, 15								# codigo para escrita em arquivo
                syscall									# escreve o " - " no arquivo
            
                addi $t1, $t1, 1 # j++
                j for_escrita_colunas		# jump para for_escrita_colunas

            fim_for_escrita_colunas:
                la $a1, enter
                li $a2, 2
                li $v0, 15								#codigo para escrita em arquivo
                syscall	
            
                addi $t0, $t0, 1 # i++

                j for_escrita_linhas		# jump para for_escrita_linhas
        fim_for_escrita_linhas:

            # Fecha o arquivo de saída
            li   $v0, 16       # syscall para fechar um arquivo
            move $a0, $s0 
            syscall            # fecha o arquivo

            addi	$v0, $0, 10		# syscall para encerrar o programa
            syscall

    indice:     # Calcula o índice baseado nos índices i e j e retorna o endereço
        #   $t0 - i (índice da linha)
        #   $t1 - j (índice da coluna)
        #   $a2 - Número de colunas
        #   $a3 - Endereço base da matriz (mat)

        mul $v0, $t0, $a2 # i * ncol
        add $v0, $v0, $t1 # (i * ncol) + j
        sll $v0, $v0, 2 # [(i * ncol) + j] * 4 (inteiro)
        add $v0, $v0, $a3 # Soma o endereço base de mat

        jr $ra # Retorna para o caller

    fscanfInt:
        li $t1, 0
        li $t3, 48  # ASCII '0'
        li $t4, 57  # ASCII '9'

        while_number:
            li $v0, 14              # Syscall para ler um arquivo
            move 	$a0, $s0		# $a0 = $s0
            la      $a1, buffer     # $a1 = &buffer
            li		$a2, 1		    # $a2 = 1
            syscall     # execute

            blez $v0, fim_while_number  # Chegou ao fim do arquivo
            lb $t2, ($a1)
            blt $t2, $t3, fim_while_number
            bgt $t2, $t4, fim_while_number

            sub $t2, $t2, $t3  # Subtrai o valor ASCII '0'
            mul $t1, $t1, 10   # Multiplica o acumulador por 10
            add $t1, $t1, $t2  # Adiciona o dígito ao acumulador

            j while_number # jump para while_number

        fim_while_number:
            move 	$v0, $t1		# $v0 = $t1

            jr		$ra					# jump to $ra

	fprintInt:      # $a0 - valor que será convertido e impresso
        subi $sp, $sp, 4 # Espaço para 1 item na pilha
        sw $ra, ($sp) # Salva o retorno para a main

		la $a1, buffer
		li $v0, 0								#zera v0 e t2(i) que serao contadores
		li $t2, 0	

		jal intToString	

		move $a0, $s0
		la $a1, buffer
		move $a2, $v0							# Quantidade de caracteres para escrita
		li $v0, 15								# codigo para escrita em arquivo
		syscall									# escreve o inteiro que esta em s1 no arquivo

        lw $ra, ($sp) # Recupera o retorno para a main
        addi $sp, $sp, 4 # Libera o espaço na pilha

        jr $ra # Retorna para a main

	intToString:
		div $a0, $a0, 10						# n = n/10
		mfhi $t3								# $t3 = resto
		subi $sp, $sp, 4
		sw $t3, ($sp)							# armazena o resto na pilha
		addi $v0, $v0, 1						# caracteres++

		bnez $a0, intToString					# se n for diferente de 0 salta pro intString novamente
		Laco:
			lw $t3, ($sp)						# recupera o resto da pilha e libera espaco da mesma
			addi $sp, $sp, 4

			add $t3, $t3, 48					# converte unidade para caractere
			sb $t3, ($a1)						# armazena $t3 no buffer2
			addi $a1, $a1, 1					# incrementa endereco do buffer
			addi $t2, $t2, 1					# i++
			bne $t2, $v0, Laco					# se i for diferente do numero de caracteres salta pro laco novamente
			sb $zero, ($a1)						# armazena zero no buffer de saida

			jr $ra
        