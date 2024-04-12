# Macro para comparar duas strings (strcmp)
# Saída:   $v0 = 0 se as strings são iguais, negativo se a primeira é menor, positivo se a segunda é menor
.macro strcmp($str1, $str2)
    # Inicializa os índices i
    li $t0, 0
    loop:
        # Carrega os caracteres atuais das strings
        lb $t1, 0($str1)
        lb $t2, 0($str2)

        # Verifica se chegou ao final de alguma das strings
        beqz $t1, fim
        beqz $t2, fim

        # Compara os caracteres
        sub $t3, $t1, $t2
        bnez $t3, feito

        # Incrementa os índices
        addi $str1, $str1, 1
        addi $str2, $str2, 1

        j loop

    fim:
        # Verifica se ambas as strings terminaram
        beqz $t1, checa_t2
        beqz $t2, feito

    checa_t2:
        # Se a segunda string também terminou, as strings são iguais
        beqz $t2, feito
        # A primeira string é menor
        li $t3, -1

        j feito

    feito:
        # Retorna o resultado da comparação
        move $v0, $t3
.end_macro

.data
    arquivo1: .asciiz "arquivo1.txt"
    arquivo2: .asciiz "arquivo2.txt"
    sim: .asciiz "Existe pelo menos uma mesma sequência de palavras de tamanho maior ou igual a 5 em ambos os arquivos.\n"
    nao: .asciiz "Não existe nenhuma mesma sequência de palavras de tamanho maior ou igual a 5 em ambos os arquivos.\n"
    erro: .asciiz "Erro ao abrir arquivo!\n"
    buffer: .asciiz " "
    word1: .space 100
    word2: .space 100

.text
    .globl main
    main:
        li $v0, 13       # Syscall para abrir um arquivo
        la $a0, arquivo1 # Endereço da string com o nome do arquivo
        li $a1, 0        # Somente leitura
        syscall

        bltz $v0, erro_abrir_arquivo # Checa se foi possível  abrir o arquivo (se $v0 < 0)

        j fim_erro_abrir_arquivo  # senão jump para fim_erro_abrir_arquivo

        erro_abrir_arquivo:
            addi		$v0, $0, 4		# system call #4 - print string
            la		$a0, erro
            syscall						# execute

            addi	$v0, $0, 10		# System call 10 - Exit
            syscall					# execute
            
        fim_erro_abrir_arquivo:
            move $s0, $v0           # Guarda o descritor do arquivo na variável

            li $v0, 13       # Syscall 13: Abrir arquivo
            la $a0, arquivo2 # Endereço da string com o nome do arquivo
            li $a1, 0        # Somente leitura
            syscall
            
            bltz $v0, erro_abrir_arquivo # Checa se foi possível  abrir o arquivo (se $v0 < 0)
            move $s1, $v0

        enquanto_words:
            move 	$a0, $s0		# $a0 = $s0
            la		$a1, word1		# &word1

            jal	ler_word				# jump to ler_word and save position to $ra

            blez $v0, fim_enquanto_words  # Chegou ao fim do arquivo
            move 	$a0, $s1		# $a0 = $s1
            la		$a1, word2		# &word2

            jal	ler_word				# jump to ler_word and save position to $ra

            blez $v0, fim_enquanto_words  # Chegou ao fim do arquivo

            la		$a0, word1
            la		$a1, word2
            strcmp($a0, $a1)
            beqz $v0, mesma_palavra

            j else_mesma_palavra	# senão jump para else_mesma_palavra

            mesma_palavra:
                addi		$s2, $s2, 1   # current_sequence_length++;

                j fim_else_mesma_palavra	# jump para fim_else_mesma_palavra

            else_mesma_palavra:
                bgt		$s2, $s3, if_maior_sequencia	# if current_sequence_length > max_sequence_length then goto if_maior_sequencia

                j fim_if_maior_sequencia  # senão jump para fim_if_maior_sequencia

                if_maior_sequencia:
                    move 	$s3, $s2		# max_sequence_length = current_sequence_length
                    
                fim_if_maior_sequencia:
                    li		$s2, 0		# current_sequence_length = 0
            
            fim_else_mesma_palavra:
                j while_words # jump para while_words

        fim_while_words:
            # Fecha o arquivo
            li   $v0, 16       # system call for close file
            move $a0, $s0      # file descriptor to close
            syscall            # close file

            # Fecha o arquivo
            li   $v0, 16       # system call for close file
            move $a0, $s1      # file descriptor to close
            syscall            # close file

            li		$t0, 5		# $t0 = 5
            bge		$s3, $t0, if_maior_igual_5	# if $s3 >= $t0 then goto target

            j else_maior_igual_5	# senão jump para else_maior_igual_5

        if_maior_igual_5:
            addi		$v0, $0, 4		# system call #4 - print string
            la		$a0, sim
            syscall						# execute
        
            j fim_else_maior_igual_5	# jump para fim_else_maior_igual_5

        else_maior_igual_5:
            addi		$v0, $0, 4		# system call #4 - print string
            la		$a0, nao
            syscall						# execute
        
        fim_else_maior_igual_5:
            addi	$v0, $0, 10		# System call 10 - Exit
            syscall					# execute

    # Entrada: $a0 = descriptor do arquivo, $a1 = endereço da palavra
    # Saída: 0 se EOF
    ler_word:
        li $t0, 0 # i = 0
        move $t1, $a1 # &word
        
        while_char:
            li $v0, 14              # Syscall 14: Ler arquivo
            la      $a1, buffer     # $a1 = &buffer
            li		$a2, 1		    # $a2 = 1
            syscall				    # execute

            blez $v0, fim_while_char  # Chegou ao fim do arquivo
            lb $t2, ($a1)
            beqz $t2, fim_while_char  # Verifica se chegou ao final da string (caractere nulo)
            beq $t2, ' ', fim_while_char
            beq $t2, '\t', fim_while_char
            beq $t2, '\n', fim_while_char
            
            add	$t3, $t1, $t0		# $t3 = word[i]
            sb	$t2, 0($t3)		    # word[i] = buffer

            addi $t0, $t0, 1 # Avança para o próximo caractere

            j while_char # jump para while_char

        fim_while_char:
            add	$t3, $t1, $t0		# $t3 = word[i]
            sb	$zero, 0($t3)		# word[i] = \0

            jr $ra
