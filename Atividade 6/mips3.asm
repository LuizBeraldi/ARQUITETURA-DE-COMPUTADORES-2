.data
    msg1: .asciiz "Digite o numero de alunos: "
    msg2: .asciiz "Digite as 3 notas do aluno "
    msg3: .asciiz ": "
    msg4: .asciiz "\nMedia da classe: "
    msg5: .asciiz "\n\nNumero de aprovados: "
    msg6: .asciiz "\nNumero de reprovados: "
    float0: .float 0.0
    float3: .float 3.0
    float6: .float 6.0
.text
    .globl main
    main:
        la $a0, msg1    
        li $v0, 4          # syscall para imprimir "Digite o número de alunos: "
        syscall

        addi $v0, $0, 5		# syscall para ler um int
        syscall						

        move $s0, $v0		    # n = $v0
        li $t0, 12             # 3*sizeof(float)
        mult $s0, $t0			# $s0 * 4 = Hi e Lo registradores
        mflo $t0                 # n*3*sizeof(float)

        # aloca $t0 bytes de memoria
        add	$a0, $0, $t0        # $t0 bytes para ser alocado
        addi $v0, $0, 9		# syscall para alocar memoria
        syscall					
        move $s1, $v0           # Salva o endereço de int *mat;
        move $a3, $s1

        # for(i = 0; i < $s0; i++)
        li $t0, 0 # Inicializa a varíavel contadora i = 0
        alunos:
            bge $t0, $s0, fim_alunos # Se i >= $s0 então vai para fim_for
        
            # printf("Digite as 3 notas do aluno %d: ", i + 1)
            addi $v0, $0, 4		# syscall para imprimir "Digite as 3 notas do aluno "
            la $a0, msg2
            syscall	

            addi $v0, $0, 1		# system call #1 - print int
            addi $a0, $t0,1 
            syscall		
            				
            addi $v0, $0, 4		# syscall para imprimir ": "
            la $a0, msg3
            syscall					

            # for(j = 0; j < 3; j++)
            li $a2, 3
            li $t1, 0 # Inicializa a varíavel contadora j = 0
            for_notas:
                bge $t1, $a2, fim_for_notas # Se j >= 3 então vai para fim_for
            
                addi $v0, $0, 6		# syscall para ler um float
                syscall					

                jal indice
                s.s $f0, 0($v0)        # salva em notas[i][j]
            
                addi $t1, $t1, 1 # j++
                j for_notas				# jump para for_notas
            fim_for_notas:
            
            l.s $f1, float0

            li $t1, 0		    # $t1 = 0
            jal indice
            l.s $f0, 0($v0)
            add.s $f1, $f1, $f0   # notas[i][0]

            li $t1, 1		    # $t1 = 1
            jal indice
            l.s $f0, 0($v0)
            add.s $f1, $f1, $f0   # notas[i][0] + notas[i][1]

            li $t1, 2		    # $t1 = 2
            jal indice
            l.s $f0, 0($v0)
            add.s $f1, $f1, $f0   # notas[i][0] + notas[i][1] + notas[i][2]

            l.s $f0, float3
            div.s $f1, $f1, $f0   # (notas[i][0] + notas[i][1] + notas[i][2]) / 3.0

            add.s $f12, $f12, $f1 # mediaClasse += mediaAluno
            
            l.s $f0, float6
            c.le.s $f0, $f1 	# if 6.0 <= mediaAluno
            bc1t if_aprovado
            j else_aprovado	# senão jump para else_aprovado

            if_aprovado:
                addi $s2, $s2, 1			#  aprovados++
            
                j fim_else_aprovado	# jump para fim_else_aprovado

            else_aprovado:
                addi $s3, $s3, 1			#  reprovados++
            
            fim_else_aprovado:
            addi $t0, $t0, 1 # i++
            j alunos				# jump para alunos

        fim_alunos:
            mtc1.d $s0, $f0
            cvt.s.w $f0, $f0            # (float)$s0
            div.s $f12, $f12, $f0       # mediaClasse /= n

            addi $v0, $0, 4		# syscall para imprimir "\nMédia da classe: "
            la $a0, msg4
            syscall				

            addi $v0, $0, 2		# syscall para imprimir um float
            mov.s $f12, $f12
            syscall						

            addi $v0, $0, 4		# syscall para imprimir "\n\nNúmero de aprovados: "
            la $a0, msg5
            syscall					

            addi $v0, $0, 1		# syscall para imprimir um int
            add $a0, $0, $s2
            syscall				

            addi $v0, $0, 4		# syscall para imprimir "\nNúmero de reprovados: "
            la $a0, msg6
            syscall					

            addi $v0, $0, 1		# syscall para imprimir um int
            add	$a0, $0, $s3
            syscall					

            addi $v0, $0, 10		# encerra o programa
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


    
