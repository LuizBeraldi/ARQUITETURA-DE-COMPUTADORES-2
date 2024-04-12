.data

    string1: .asciiz "Digite um número: "
    string2: .asciiz "O "
    string3: .asciiz "-ésimo número de Catalan é "

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

        jal	catalan

        move $a0, $v0		# $a0 = $v0
        addi $v0, $0, 1		# syscall para imprimir um inteiro
        syscall						

        addi $v0, $0, 10		# syscall para encerrar o programa
        syscall					

    # int catalan(int n)
    catalan:
        # Salva os registradores na pilha
        subi $sp, $sp, 8
        sw $ra, 0($sp)
        sw $a0, 4($sp)
        sll	$a0, $a0, 1			# $a0 = $a0 * 2

        jal	fatorial				# jump para fatorial e salve a posição em $ra

        # Restaura os registradores da pilha
        lw $ra, 0($sp)
        lw $a0, 4($sp)
        addi $sp, $sp, 8
        move $t0, $v0		# $t0 = $v0

        # Salva os registradores na pilha
        subi $sp, $sp, 8
        sw $ra, 0($sp)
        sw $a0, 4($sp)
        addi $a0, $a0, 1			# $a0 = $a0 + 1    

        jal	fatorial				# jump para fatorial e salve a posição em $ra

        # Restaura os registradores da pilha
        lw $ra, 0($sp)
        lw $a0, 4($sp)
        addi $sp, $sp, 8
        move $t1, $v0		# $t1 = $v0

        # Salva os registradores na pilha
        subi $sp, $sp, 8
        sw $ra, 0($sp)
        sw $a0, 4($sp)
        move $a0, $a0		# $a0 = $a0     

        jal	fatorial				# jump para fatorial e salve a posição em $ra

        # Restaura os registradores da pilha
        lw $ra, 0($sp)
        lw $a0, 4($sp)
        addi $sp, $sp, 8
        move $t2, $v0		# $t2 = $v0

        mult $t1, $t2			# $t1 * $t2 = Hi e Lo registradores
        mflo $t1					# copy Lo para $t1
        div	$t0, $t1			# $t0 / $t1
        mflo $v0					# $v0 = floor($t0 / $t1)

        jr $ra					# jump para $ra

    # int fatorial(int n)
    fatorial:
        beqz $a0, if_fatorial	# if ($a0 = 0),va para if_fatorial

        j else_fatorial	# senão jump para else_fatorial

        if_fatorial:
            li $v0, 1		# $v0 = 1

            jr $ra			# jump para $ra
        
            j fim_else_fatorial	# jump para fim_else_fatorial

        else_fatorial:
            # Salva os registradores na pilha
            subi $sp, $sp, 8
            sw $ra, 0($sp)
            sw $a0, 4($sp)
            subi $a0, $a0, 1		# $a0 = $a0 - 1

            jal	fatorial		# jump para fatorial e salve a posição em $ra

            # Restaura os registradores da pilha
            lw $ra, 0($sp)
            lw $a0, 4($sp)
            addi $sp, $sp, 8
            
            mult $a0, $v0			# $a0 * $v0 = Hi e Lo registradores
            mflo $v0					# copy Lo para $v0
            
            jr $ra					# jump para $ra
            
        fim_else_fatorial: