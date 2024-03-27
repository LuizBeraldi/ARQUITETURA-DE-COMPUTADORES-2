.data
    msg1: .asciiz "Digite o tamanho da sequencia: "
    msg2: .asciiz "Digite os numeros da sequencia:\n"
    msg3: .asciiz "O segmento de soma maxima eh de "
    msg4: .asciiz ", indo de "
    msg5: .asciiz " ate "

    .align 3  # Alinha os próximos dados em uma fronteira de 2^3 = 8 bytes
    max_seg: .space 16  # Tamanho total da estrutura (4 bytes para int + 4 bytes para int + 8 bytes para double)
    atual_seg: .space 16  # Tamanho total da estrutura (4 bytes para int + 4 bytes para int + 8 bytes para double)
    float0: .float 0.0
    
.text
    .globl main
    main:
        li $v0, 4
        la $a0, msg1        # syscall para imprimir "Digite o tamanho da sequência: "
        syscall

        li $v0, 5
        syscall     # syscall para ler um inteiro
        move $s0, $v0  # n = $v0

        # Calcula o tamanho necessário para o vetor de doubles
        li $t0, 8  # sizeof(double) = 8 bytes
        mul $t0, $t0, $s0  # n * sizeof(double)

        # Aloca memória para o vetor de doubles
        move $a0, $t0
        li $v0, 9  # syscall para alocar memoria
        syscall
        move $s1, $v0  # Salva o endereço do vetor

        # aloca $t0 bytes de memoria
        add	$a0, $0, $t0        # $t0 bytes para serem alocados
        addi	$v0, $0, 9		# syscall para alocar memoria
        syscall	
        move $s1, $v0           # Salva o endereço de int *vet;

        la $a0, msg2   
        li $v0, 4          # syscall para imprimir "Digite os números da sequência:\n"
        syscall

        # for(i = 0; i < n; i++)
        li $t0, 0  # Inicializa contador i = 0

        for_numeros:
            bge $t0, $s0, fim_for_numeros  # Se i >= n, vai para fim_for

            # Calcula o endereço para a posição i no vetor
            mul $t1, $t0, 8  # 8 bytes por double
            add $t2, $s1, $t1  # Endereço de numeros[i]

            li $v0, 7       # syscall para ler um double
            syscall
            s.d $f0, 0($t2)  # Armazena o valor lido no vetor

            addi $t0, $t0, 1 # Incrementa i
            j for_numeros

        fim_for_numeros:
            jal encontrar_maior_segmento				# jump to encontrar_maior_segmento e salva a posicao para $ra
            
            addi $v0, $0, 4		# syscall para imprimir "O segmento de soma máxima é de "
            la $a0, msg3
            syscall				
            
            addi $v0, $0, 3		# syscall para imprimir um double
            l.d $f12, max_seg+8
            syscall					

            addi $v0, $0, 4		# syscall para imprimir ", indo de "
            la $a0, msg4
            syscall				

            addi $v0, $0, 3		# syscall para imprimir um double
            lw $t0, max_seg
            mul $t0, $t0, 8         # 8 bytes por double
            add $t0, $s1, $t0       # Endereço de numeros[i]
            l.d	$f12, 0($t0)
            syscall					

            addi $v0, $0, 4		# syscall para imprimir " até "
            la $a0, msg5
            syscall				

            addi $v0, $0, 3		# syscall para imprimir um double
            lw	$t0, max_seg+4
            mul $t0, $t0, 8         # 8 bytes por double
            add $t0, $s1, $t0       # Endereço de numeros[i]
            l.d $f12, 0($t0)
            syscall				

            addi $v0, $0, 10		# encerra o programa
            syscall			

    encontrar_maior_segmento:
        l.d $f0, 0($s1)
        s.d $f0, max_seg+8  # Armazena o valor em max_seg+8
        s.d $f0, atual_seg+8  # Armazena o valor em atual_seg+8

        # for(i = 1; i < $s0; i++)
        li $t0, 1 # Inicializa a varíavel contadora i = 1

        for_procura:
            bge $t0, $s0, fim_for_procura # Se i >= $s0 então vai para fim_for
        
            l.d	$f0, atual_seg+8 # atual_seg.soma
            l.d	$f2, float0 # 0.0
            c.lt.d $f0,$f2 # atual_seg.soma < 0
            bc1t if_1
            j else	# senão jump para else

            if_1:
                sw $t0, atual_seg		    # atual_seg.inicio = i
                sw $t0, atual_seg+4		# atual_seg.fim = i

                mul $t1, $t0, 8         # 8 bytes por double
                add $t2, $s1, $t1       # Endereço de numeros[i]
                l.d $f4, 0($t2)         # *numeros[i]
                s.d $f4, atual_seg+8    # atual_seg.soma = numeros[i]
            
                j fim_else	# jump para fim_else

            else:
                lw $t1, atual_seg+4		# t1 = atual_seg.fim
                addi $t1, $t1, 1             # fim++
                sw $t1, atual_seg+4		# atual_seg.fim++

                mul $t1, $t0, 8         # 8 bytes por double
                add $t2, $s1, $t1       # Endereço de numeros[i]
                l.d $f4, 0($t2)         # *numeros[i]
                add.d $f0, $f0, $f4      # atual_seg.soma += numeros[i]
                s.d $f0, atual_seg+8    # Atualiza atual_seg.soma
            
            fim_else:
                l.d $f2, max_seg+8   # $f2 recebe max_seg.soma
                c.lt.d $f2,$f0 # atual_seg.soma > max_seg.soma
                bc1t if_2
                j fim_if_2  # senão jump para fim_if_2

                if_2:
                
                    # max_seg = atual_seg
                    lw $t1, atual_seg
                    lw $t2, atual_seg+4
                    l.d $f0, atual_seg+8

                    sw $t1, max_seg	  # max_seg.inicio = atual_seg.inicio
                    sw $t2, max_seg+4    # max_seg.fim = atual_seg.fim
                    s.d $f0, max_seg+8    # max_seg.soma = atual_seg.soma
                
                fim_if_2:
                    addi $t0, $t0, 1 # i++
                    j for_procura				# jump para for_procura

        fim_for_procura:
            jr $ra					# jump to $ra