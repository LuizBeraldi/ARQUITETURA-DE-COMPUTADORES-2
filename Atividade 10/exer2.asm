.data

    string1: .asciiz "Digite o valor de k: "
    string2: .asciiz "Digite o valor de n: "
    string3: .asciiz "Por favor, insira inteiros positivos para k e n.\n"
    string4: .asciiz " elevado a "
    string5: .asciiz " é igual a "

.text
    .globl main
    main:
        addi $v0, $0, 4		# syscall para imprimir uma string
        la $a0, string1
        syscall

        addi $v0, $0, 5		# syscall para ler um inteiro
        syscall

        move $s0, $v0		# $s0 = $v0

        addi $v0, $0, 4		# systcall para imprimir uma string
        la $a0, string2
        syscall	

        addi $v0, $0, 5		# syscall para ler um inteiro
        syscall	

        move $s1, $v0		# $s1 = $v0

        bltz $s0, if_inteiro_positivo	# if ($s0 < 0), va para if_inteiro_positivo
        bltz $s1, if_inteiro_positivo	# if ($s1 < 0), va para if_inteiro_positivo

        j fim_if_inteiro_positivo  # senão jump para fim_if_inteiro_positivo

        if_inteiro_positivo:
            addi $v0, $0, 4		# syscall para imprimir uma string
            la $a0, string3
            syscall	

            addi $v0, $0, 10		# Syscall para encerrar o programa
            syscall	
        
        fim_if_inteiro_positivo:
            addi $v0, $0, 1		# syscall para imprimir um inteiro
            add	$a0, $0, $s0
            syscall	

            addi $v0, $0, 4		# syscall para imprimir uma string
            la $a0, string4
            syscall	

            addi $v0, $0, 1		# syscall para imprimir um inteiro
            add	$a0, $0, $s1
            syscall		

            addi $v0, $0, 4		# syscall para imprimir uma string
            la $a0, string5
            syscall	

            move $a0, $s0		# $a0 = $s0
            move $a1, $s1		# $a1 = $s1

            jal potencia				# jump para potencia e salva a posição em $ra
            
            move $a0, $v0		# $a0 = $v0
            addi $v0, $0, 1		# syscall para imprimir um inteiro
            syscall		

            addi $v0, $0, 10		# Syscall para encerrar o programa
            syscall	

    # int potencia(int k, int n)
    potencia:
        # Salva os registrador $ra na pilha
        subi $sp, $sp, 4
        sw $ra, 0($sp)

        beqz $a1, if_parada	# if ($a1 == 0), va para if_parada

        j else_parada	# senão jump para else_parada

        if_parada:
            li $v0, 1   # $v0 = 1
            # Restaura os registrador $ra da pilha
            lw $ra, 0($sp)
            addi $sp, $sp, 4
            jr $ra      # return 1;

            j fim_else_parada	# jump para fim_else_parada

        else_parada:
            move $a0, $a0		    # $a0 = $a0
            subi $a1, $a1, 1			# $a1 = $a1 - 1

            jal	potencia			# jump para potencia e salve a posição em $ra

            # Restaura os registrador $ra da pilha
            lw $ra, 0($sp)
            addi $sp, $sp, 4
            mult $a0, $v0			# $a0 * $v0 = Hi e Lo registradores
            mflo $v0					# copia Lo para $v0

            jr $ra					# jump para $ra

        fim_else_parada: