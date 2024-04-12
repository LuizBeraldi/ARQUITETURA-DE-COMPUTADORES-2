.data

    string1: .asciiz "Digite o valor de n: "
    string2: .asciiz "Por favor, insira um número positivo.\n"
    string3: .asciiz "Combinações das primeiras "
    string4: .asciiz " letras do alfabeto:\n"

.text
    .globl main
    main:
        addi $v0, $0, 4		# syscall para imprimir uma string
        la $a0, string1
        syscall	

        addi $v0, $0, 5		# syscall para ler um inteiro
        syscall	

        move $s0, $v0		    # $s0 = n

        blez $s0, if_positivo	# if ($s0 <= 0), va para if_positivo

        j fim_if_positivo  # senão jump para fim_if_positivo

        if_positivo:
            addi $v0, $0, 4		# syscall para imprimir uma string
            la $a0, string2
            syscall

            addi $v0, $0, 10		# Syscall para encerrar o programa
            syscall
        
        fim_if_positivo:
            # Aloca $s0 bytes na memória
            add $a0, $0, $s0	# $s0 bytes para serem alocados
            addi $v0, $0, 9		# syscall para alocar memória
            syscall	

            move $s1, $v0           # Salva o endereço de char letras[n];

            # for(i = 0; i < $s0; i++)
            li $t0, 0 # Inicializa a varíavel contadora i = 0

        for_letras:
            bge $t0, $s0, fim_for_letras # Se (i >= $s0), va para fim_for
        
            addi $t2, $t0, 65			# $t2 = i + 'A' (ASCII)
            add $t1, $s1, $t0	        # &letras[i]
            sb $t2, 0($t1)	            # letras[i] = 'A' + i;
        
            addi $t0, $t0, 1 # i++

            j for_letras		# jump para for_letras

        fim_for_letras:
        addi $v0, $0, 4		# syscall para imprimir uma string
        la $a0, string3
        syscall		

        addi $v0, $0, 1		# syscall para imprimir um inteiro
        add	$a0, $0, $s0
        syscall	

        addi $v0, $0, 4		# syscall para imprimir uma string
        la $a0, string4
        syscall	

        move $a0, $s1		# $a0 = $s1
        li $a1, 0		    # $a1 = 0
        move $a2, $s0		# $a2 = $s0
        jal	permutar		# jump para permutar e salve a posição em $ra

        addi $v0, $0, 10		# Syscall para encerrar o programa
        syscall	
    
    # void permutar(char letras[], int inicio, int n) 
    permutar:
        beq	$a1, $a2, if_permutar	# if ($a1 == $a2), va para if_permutar

        j else_permutar	# senão jump para else_permutar

        if_permutar:
            move 	$t2, $a0		# $t2 = $a0
            # for(i = 0; i < $a2; i++)
            li $t0, 0 # Inicializa a varíavel contadora i = 0
            for_print:
                bge $t0, $a2, fim_for_print # Se (i >= $a2), va para fim_for

                add $t1, $t2, $t0	# &letras[i]
                lb  $a0, 0($t1)	    # letras[i]
                addi		$v0, $0, 11		# syscall para imprimir um caracter
                syscall		
            
                addi $t0, $t0, 1 # i++

                j for_print		# jump para for_print

            fim_for_print:
                addi $v0, $0, 11		# system call #11 - print char
                li $a0, 10		    # \n
                syscall
            
                j fim_else_permutar	# jump para fim_else_permutar

        else_permutar:
            # for(i = $a1; i < $a2; i++)
            move $t0, $a1 # Inicializa a varíavel contadora i = $a1

            for_permutar:
                bge $t0, $a2, fim_for_permutar # Se (i >= $a2), va para fim_for

                add $t1, $a0, $a1	# &letras[inicio]
                lb  $t2, 0($t1)	    # temp = letras[inicio]
                add $t3, $a0, $t0	# &letras[i]
                lb  $t4, 0($t3)	    # letras[i]
                sb  $t4, 0($t1)	    # letras[inicio] = letras[i]
                sb  $t2, 0($t3)	    # letras[i] = temp

                # Salva o registrador $ra na pilha
                subi $sp, $sp, 20
                sw $ra, 0($sp)
                sw $a0, 4($sp)
                sw $a1, 8($sp)
                sw $a2, 12($sp)
                sw $t0, 16($sp)
                move $a0, $a0		# $a0 = $a0
                addi $a1, $a1, 1	    # $a1 = $a1 + 1
                move $a2, $a2		# $a2 = $a2

                jal permutar

                # Restaura o registrador $ra da pilha
                lw $ra, 0($sp)
                lw $a0, 4($sp)
                lw $a1, 8($sp)
                lw $a2, 12($sp)
                lw $t0, 16($sp)
                addi $sp, $sp, 20

                add $t1, $a0, $a1	# &letras[inicio]
                lb  $t2, 0($t1)	    # temp = letras[inicio]
                add $t3, $a0, $t0	# &letras[i]
                lb  $t4, 0($t3)	    # letras[i]
                sb  $t4, 0($t1)	    # letras[inicio] = letras[i]
                sb  $t2, 0($t3)	    # letras[i] = temp
            
                addi $t0, $t0, 1 # i++

                j for_permutar		# jump para for_permutar

            fim_for_permutar:
        fim_else_permutar:
            jr $ra	# jump para $ra
        
        