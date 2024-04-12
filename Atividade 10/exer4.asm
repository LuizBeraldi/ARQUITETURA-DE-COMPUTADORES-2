.data

    string1:   .asciiz "Digite n, a e b: "
    string2: .asciiz "Por favor, insira três números inteiros positivos.\n"
    string3: .asciiz "Os "
    string4: .asciiz " primeiros inteiros positivos múltiplos de "
    string5: .asciiz " ou "
    string6: .asciiz " ou ambos são:\n"

.text
    .globl main
    main:
        addi $v0, $0, 4		# syscall para imprimir uma string
        la $a0, string1
        syscall						

        addi $v0, $0, 5		# syscall para ler um inteiro
        syscall						

        move $s0, $v0		# $s0 = $v0

        addi		$v0, $0, 5		# syscall para ler um inteiro
        syscall						
        move 	$s1, $v0		# $s0 = $v0

        addi		$v0, $0, 5		# syscall para ler um inteiro
        syscall						
        move 	$s2, $v0		# $s0 = $v0

        blez $s0, if_positivo	# if ($s0 <= 0), va para if_positivo
        blez $s1, if_positivo	# if ($s1 <= 0), va para if_positivo
        blez $s2, if_positivo	# if ($s2 <= 0), va para if_positivo

        j fim_if_positivo  # senão jump para fim_if_positivo

        if_positivo:
            addi		$v0, $0, 4		# syscall para imprimir uma string
            la		$a0, string2
            syscall			

            addi	$v0, $0, 10		# syscall para encerrar o programa
            syscall					
        
        fim_if_positivo:
            move 	$a0, $s0		# $a0 = $s0
            move 	$a1, $s1		# $a1 = $s1
            move 	$a2, $s2		# $a2 = $s2

            jal		multiplos		# jump to multiplos and save position to $ra
            
            addi	$v0, $0, 10		# syscall para encerrar o programa
            syscall					

    # void multiplos(int n, int a, int b)
    multiplos:
        li		$s0, 0		# $s0 = 0
        li		$s1, 1		# $s1 = 1
        
        move 	$t2, $a0		# $t2 = $a0
        addi		$v0, $0, 4		# syscall para imprimir uma string
        la		$a0, string3
        syscall		

        addi		$v0, $0, 1		# syscall para imprimir um inteiro
        add		$a0, $0, $t2
        syscall			

        addi		$v0, $0, 4		# syscall para imprimir uma string
        la		$a0, string4
        syscall	

        addi		$v0, $0, 1		# syscall para imprimir um inteiro
        add		$a0, $0, $a1
        syscall	

        addi		$v0, $0, 4		# syscall para imprimir uma string
        la		$a0, string5
        syscall		

        addi		$v0, $0, 1		# syscall para imprimir um inteiro
        add		$a0, $0, $a2
        syscall		

        addi		$v0, $0, 4		# syscall para imprimir uma string
        la		$a0, string6
        syscall		

        move 	$a0, $t2		    # $a0 = $t2

        while_not_multiplo:
            bge		$s0, $a0, fim_while_not_multiplo	# if ($s0 >= $a0), va para fim_while_not_multiplo
            
            # Salva os registradores na pilha
            subi $sp, $sp, 12
            sw $ra, 0($sp)
            sw $a0, 4($sp)
            sw $a1, 8($sp)
            move 	$a0, $s1		# $a0 = $s1
            move 	$a1, $a1		# $a1 = $a1

            jal	ehMultiplo	# jump para ehMultiplo e salve a posição em $ra

            # Restaura os registradores da pilha
            lw $ra, 0($sp)
            lw $a0, 4($sp)
            lw $a1, 8($sp)
            addi $sp, $sp, 12
            move 	$t5, $v0		# $t5 = $v0

            # Salva os registradores na pilha
            subi $sp, $sp, 12
            sw $ra, 0($sp)
            sw $a0, 4($sp)
            sw $a1, 8($sp)
            move 	$a0, $s1		# $a0 = $s1
            move 	$a1, $a2		# $a1 = $a2

            jal	ehMultiplo	# jump para ehMultiplo e salve a posição em $ra

            # Restaura os registradores da pilha
            lw $ra, 0($sp)
            lw $a0, 4($sp)
            lw $a1, 8($sp)
            addi $sp, $sp, 12
            or		$v0, $v0, $t5		# $v0 = $v0 | $t5
            
            bnez $v0, if_multiplo_a_b	# if (ehMultiplo(i, a) || ehMultiplo(i, b)) then goto if_multiplo_a_b

            j fim_if_multiplo_a_b  # senão jump para fim_if_multiplo_a_b

            if_multiplo_a_b:
                move 	$t2, $a0		# $t2 = $a0
                addi		$v0, $0, 1		# syscall para imprimir um inteiro
                add		$a0, $0, $s1
                syscall	

                addi		$v0, $0, 11		# syscall para imprimir um caracter
                li		    $a0, 32		    # ' ' (ASCII)
                syscall						

                addi	$s0, $s0, 1			# $s0 = $s0 + 1
                move 	$a0, $t2		    # $a0 = $t2

            fim_if_multiplo_a_b:
                addi	$s1, $s1, 1			# $s1 = $s1 + 1

                j while_not_multiplo # jump para while_not_multiplo

        fim_while_not_multiplo:
            jr $ra

    # int ehMultiplo(int numero, int divisor)
    ehMultiplo:
        li		$v0, 0		        # $v0 = False
        div		$a0, $a1			# $a0 / $a1
        mfhi	$t0					# $t0 = $a0 % $a1 
        beqz	$t0, if_multiplo	# if ($t0 == 0), va para if_multiplo

        j fim_if_multiplo  # senão jump para fim_if_multiplo

        if_multiplo:
            li		$v0, 1		# $v0 = True

        fim_if_multiplo:        
            jr $ra
