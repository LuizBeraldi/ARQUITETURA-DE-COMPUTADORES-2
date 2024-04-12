.data

    string1:   .asciiz "Digite o tamanho dos vetores: "
    string2:   .asciiz "Digite os elementos do vetor V1:\n"
    string3: .asciiz "Vetor V2 invertido:\n"
    space: .asciiz " "

.text
    .globl main
    main:
        addi $v0, $0, 4		# syscall para imprimir uma string
        la $a0, string1
        syscall

        addi $v0, $0, 5		# syscall para ler um inteiro
        syscall	

        move $s0, $v0		# $s0 = $v0

        li $t0, 4              # sizeof(int)
        mult $s0, $t0			# $v0 * 4 = Hi e Lo registradores
        mflo $t0				    # copia Lo para $t0

        # Aloca $t0 bytes na memória
        add	$a0, $0, $t0    # $t0 bytes para serem alocados
        addi	$v0, $0, 9		# syscall para alocar memória
        syscall

        move $s1, $v0           # Salva o endereço de int *V1;

        # Aloca $t0 bytes na memória
        add	$a0, $0, $t0    # $t0 bytes para serem alocados
        addi $v0, $0, 9		# syscall para alocar memória
        syscall	
        
        move $s2, $v0           # Salva o endereço de int *V2;

        addi $v0, $0, 4		# syscall para imprimir uma string
        la $a0, string2
        syscall

        # for(i = 0; i < $s0; i++)
        li $t0, 0 # Inicializa a varíavel contadora i = 0

        for_ler_numeros:
            bge $t0, $s0, fim_for_ler_numeros # Se (i >= $s0), va para fim_for
        
            sll $t1, $t0, 2	            # i*sizeof(int)
            add $t1, $s1, $t1	        # &V1[i]
            addi $v0, $0, 5		# syscall para ler um inteiro
            syscall

            sw	$v0, 0($t1)		        # V1[i]
        
            addi $t0, $t0, 1 # i++

            j for_ler_numeros		# jump para for_ler_numeros

        fim_for_ler_numeros:
            move $a0, $s1		# $a0 = $s1
            move $a1, $s2		# $a1 = $s2
            move $a2, $s0		# $a2 = $s0

            jal inverte_vetor

            addi $v0, $0, 4		# syscall para imprimir uma string
            la $a0, string3
            syscall	

            # for(i = 0; i < $s0; i++)
            li $t0, 0 # Inicializa a varíavel contadora i = 0

        for_vetor_2:
            bge $t0, $s0, fim_for_vetor_2 # Se (i >= $s0), va para fim_for
        
            sll $t1, $t0, 2	# i*sizeof(int)
            add $t1, $s2, $t1	# &V2[i]
            lw $t1, 0($t1)	# V2[i]

            addi $v0, $0, 1		# syscall para imprimir um inteiro
            add $a0, $0, $t1
            syscall	

            addi $v0, $0, 4		# syscall para imprimir uma string
            la $a0, space
            syscall
        
            addi $t0, $t0, 1 # i++

            j for_vetor_2		# jump para for_vetor_2

        fim_for_vetor_2:
            addi	$v0, $0, 10		# System call 10 - Exit
            syscall					# execute

    # void inverte_vetor(int V1[], int V2[], int N)
    inverte_vetor:
        # for(i = 0; i < $a2; i++)
        li $t0, 0 # Inicializa a varíavel contadora i = 0

        for_inverte:
            bge $t0, $a2, fim_for_inverte # Se i >= $a2 então vai para fim_for

            sll  $t1, $a2, 2 # N*sizeof(int)
            sll  $t2, $t0, 2 # i*sizeof(int)
            sub	 $t1, $t1, $t2		# $t1 = $t1 - $t2
            subi $t1, $t1, 4		# $t1 = $t1 - 1*sizeof(int)
            add  $t1, $a0, $t1	# &V1[N - i - 1]
            lw $t1, 0($t1)	    # V1[N - i - 1]

            sll $t2, $t0, 2	# i*sizeof(int)
            add $t2, $a1, $t2	# &V2[i]
            sw $t1, 0($t2)	# V2[i] = V1[N - i - 1];
        
            addi $t0, $t0, 1 # i++

            j for_inverte		# jump para for_inverte

        fim_for_inverte:
            jr $ra					# jump to $ra