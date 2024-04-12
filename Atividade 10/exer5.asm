.data

    string1: .asciiz "Digite um número: "
    string2: .asciiz "O hiperfatorial de "
    string3: .asciiz " é "

.text
    .globl main
    main:
        addi $v0, $0, 4		# syscall para imprimir uma string
        la $a0, string1
        syscall		

        addi $v0, $0, 5		# syscall para ler um inteiro
        syscall		

        move $s0, $v0		# $s0 = $v0

        addi $v0, $0, 4		# syscall para imprimir uma string
        la $a0, string2
        syscall						

        addi $v0, $0, 1		# syscall para imprimir um inteiro
        add	$a0, $0, $s0
        syscall						

        addi $v0, $0, 4		# syscall para imprimir uma string
        la $a0, string3
        syscall						
        
        move $a0, $s0		# $a0 = $s0

        jal	hyperfactorial				# jump para hyperfactorial e salve a posição em $ra

        move $a0, $v0		# $a0 = $v0
        addi $v0, $0, 1		# syscall para imprimir um inteiro
        syscall					

        addi $v0, $0, 10		# syscall para encerrar o programa
        syscall					

    # int hyperfactorial(int N)
    hyperfactorial:
        beqz $a0, if_stop	# if ($a0 = 0), va para if_stop

        j else_stop	# senão jump para else_stop

        if_stop:
            li $v0, 1		        # $v0 = 1
            jr $ra					# jump para $ra
            j fim_else_stop	# jump para fim_else_stop

        else_stop:
            # Salva os registradores na pilha
            subi $sp, $sp, 8
            sw $ra, 0($sp)
            sw $a0, 4($sp)
            move $a0, $a0		# $a0 = $a0
            move $a1, $a0		# $a1 = $a0

            jal potencia	    # jump para potencia e salve a posição em $ra

            # Restaura os registradores da pilha
            lw $ra, 0($sp)
            lw $a0, 4($sp)
            addi $sp, $sp, 8
            move $t0, $v0		# $t0 = $v0

            # Salva os registradores na pilha
            subi $sp, $sp, 12
            sw $ra, 0($sp)
            sw $a0, 4($sp)
            sw $t0, 8($sp)
            subi $a0, $a0, 1			# $a0 = $a0 - 1

            jal	hyperfactorial	# jump para hyperfactorial e salve a posição em $ra

            # Restaura os registradores da pilha
            lw $ra, 0($sp)
            lw $a0, 4($sp)
            lw $t0, 8($sp)
            addi $sp, $sp, 12

            mult $v0, $t0			# $v0 * $t0 = Hi e Lo registradores
            mflo $v0					# copia Lo para $v0

            jr $ra					# jump para $ra

        fim_else_stop:

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