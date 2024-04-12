.data

    inicio:    .word 0
    string1: .asciiz "\nMenu:\n"
    string2: .asciiz "1 - Inserir\n"
    string3: .asciiz "2 - Consultar\n"
    string4: .asciiz "3 - Remover\n"
    string5: .asciiz "4 - Imprimir\n"
    string6: .asciiz "5 - Sair\n"
    string7: .asciiz "Escolha uma opção: "
    inserir: .asciiz "Digite o valor a ser inserido: "
    consultar: .asciiz "Digite o valor a ser consultado: "
    remover: .asciiz "Digite o valor a ser removido: "
    encerrar: .asciiz "Encerrando o programa.\n"
    invalida: .asciiz "Opção inválida.\n"
    valor: .asciiz "Valor "
    lista: .asciiz "Elementos da lista: "
    vazia: .asciiz "Lista vazia.\n"
    notfound: .asciiz " não encontrado na lista.\n"
    found: .asciiz " encontrado na lista.\n"
    removido: .asciiz " removido da lista.\n"
    inserido: .asciiz " inserido com sucesso.\n"

.text
    .globl main
    main:
        while_opcoes:
            addi $v0, $0, 4		# syscall para imprimir uma string
            la $a0, string1
            syscall	

            addi $v0, $0, 4		# syscall para imprimir uma string
            la $a0, string2
            syscall		

            addi $v0, $0, 4		# syscall para imprimir uma string
            la $a0, string3
            syscall		

            addi $v0, $0, 4		# syscall para imprimir uma string
            la $a0, string4
            syscall	

            addi $v0, $0, 4		# syscall para imprimir uma string
            la $a0, string5
            syscall		

            addi $v0, $0, 4		# syscall para imprimir uma string
            la $a0, string6
            syscall		

            addi $v0, $0, 4		# syscall para imprimir uma string
            la $a0, string7
            syscall		

            addi $v0, $0, 5		# syscall para ler um inteiro
            syscall		

            move $s0, $v0		    # choice = $v0

            # switch (choice)
            li $t0, 1		        # $t0 = 1
            beq $s0, $t0, case1	    # if( $s0 == $t0), va para case1
            li $t0, 2		        # $t0 = 2
            beq $s0, $t0, case2	    # if ($s0 == $t0), va para case2
            li $t0, 3		        # $t0 = 3
            beq $s0, $t0, case3	    # if ($s0 == $t0), va para case3
            li $t0, 4		        # $t0 = 4
            beq $s0, $t0, case4	    # if ($s0 == $t0), va para case4
            li $t0, 5		        # $t0 = 5
            beq $s0, $t0, case5	    # if ($s0 == $t0), va para case5
            j default				# jump para default

            case1:
                addi $v0, $0, 4		# syscall para imprimir uma string
                la $a0, inserir
                syscall		

                addi $v0, $0, 5		# syscall para ler um inteiro
                syscall		

                move $s1, $v0            # $s1 = $v0
                la $a0, inicio		    # Node** inicio
                move $a1, $s1		    # $a1 = valor

                jal insert				# jump para insert e salve a posição em $ra
                j fim_switch

            case2:
                addi $v0, $0, 4		# syscall para imprimir uma string
                la $a0, consultar
                syscall		

                addi $v0, $0, 5		# syscall para ler um inteiro
                syscall		

                move $s1, $v0		    # $s1 = $v0
                la $a0, inicio		    # Node** inicio
                lw $a0, ($a0)		    # Node* inicio
                move $a1, $s1		    # $a1 = valor

                jal search				# jump para search e salve a posição em $ra
                j fim_switch

            case3:
                addi $v0, $0, 4		# syscall para imprimir uma string
                la $a0, remover
                syscall		

                addi $v0, $0, 5		# syscall para ler um inteiro
                syscall		

                move $s1, $v0		    # $s1 = $v0
                la $a0, inicio		    # Node** inicio
                move $a1, $s1		    # $a1 = valor

                jal removeItem			# jump para removeItem e salve a posição em $ra
                j fim_switch

            case4:
                la $a0, inicio		    # Node** inicio
                lw $a0, ($a0)		    # Node* inicio

                jal printList			# jump para printList e salve a posição em $ra
                j fim_switch

            case5:
                addi $v0, $0, 4		# syscall para imprimir uma string
                la $a0, encerrar
                syscall		

                j fim_switch

            default:
                addi $v0, $0, 4		# syscall para imprimir uma string
                la $a0, invalida
                syscall	

            fim_switch:
                li $t0, 5		                # $t0 = 5
                beq	$s0, $t0, fim_while_opcoes	# if (choice == 5), va para fim_while_opcoes

                j while_opcoes # jump para while_opcoes

        fim_while_opcoes:
            addi $v0, $0, 10		# syscall para encerrar o programa
            syscall					

    # void insert(Node** inicio, int valor)
    insert:
        # aloca 8 bytes na memória
        move $t2, $a0		# $t2 = $a0
        addi $a0, $0, 8		# sizeof(Node)
        addi $v0, $0, 9		# syscall para alocar memória
        syscall		

        move $a0, $t2		# $a0 = $t2
        move $t0, $v0        # Node* newNode = (Node*)malloc(sizeof(Node));
        sw $a1, 0($t0)		# newNode->data = valor;
        lw $t1, 0($a0)		# *inicio
        sw $t1, 4($t0)		# newNode->next = *inicio;
        sw $t0, 0($a0)		# *inicio = newNode;

        addi $v0, $0, 4		# syscall para imprimir uma string
        la $a0, valor
        syscall		

        addi $v0, $0, 1		# syscall para imprimir um inteiro
        add $a0, $0, $a1
        syscall	

        addi $v0, $0, 4		# syscall para imprimir uma string
        la $a0, inserido
        syscall	

        jr $ra					# jump para $ra

    # void search(Node* inicio, int valor)
    search:
        move $t0, $a0		# current = $a0

        while_search:
            beqz $t0, fim_while_search		# if (current == NULL), va para not_found
        
            lw $t1, 0($t0)		# current->data

            beq $t1, $a1, if_no	# if ($t1 == $a1), va para if_no
            j fim_if_no  # senão jump para fim_if_no

            if_no:
                addi $v0, $0, 4		# syscall para imprimir uma string
                la $a0, valor
                syscall	

                addi $v0, $0, 1		# syscall para imprimir um inteiro
                add $a0, $0, $a1
                syscall		

                addi $v0, $0, 4		# syscall para imprimir uma string
                la $a0, found
                syscall

                jr $ra					# jump para $ra
            
            fim_if_no:
                lw $t0, 4($t0)     # current = current->next; 
            
                j while_search # jump para while_search

        fim_while_search:
            addi $v0, $0, 4		# syscall para imprimir uma string
            la $a0, valor
            syscall			

            addi $v0, $0, 1		# syscall para imprimir um inteiro
            add $a0, $0, $a1
            syscall		

            addi $v0, $0, 4		# syscall para imprimir uma string
            la $a0, notfound
            syscall						

            jr $ra					# jump para $ra

    # void removeItem(Node** inicio, int valor)
    removeItem:
        lw $t0, 0($a0)		# Node* current = *inicio;
        li $t1, 0          # Node* prev = NULL;
        
        while_remove:
            beqz $t0, fim_while_remove # while (current != NULL)

            lw $t2, 0($t0)		# current->data
            beq	$a1, $t2, if_remove	# if $a1 == $t2), va para if_remove

            j fim_if_remove  # senão jump para fim_if_remove

            if_remove:
                beq $t1, $0, if_not_anterior	# if ($t1 == $0), va para if_not_anterior

                j else_not_anterior	# senão jump para else_not_anterior

                if_not_anterior:
                    lw $t2, 4($t0)		# current->next
                    sw $t2, 0($a0)		# *inicio = current->next;
                
                    j fim_else_not_anterior	# jump para fim_else_not_anterior

                else_not_anterior:
                    lw $t2,  4($t0)		# current->next
                    sw $t2,  4($t1)		# prev->next = current->next
                
                fim_else_not_anterior:
                    addi $v0, $0, 4		# syscall para imprimir uma string
                    la $a0, valor
                    syscall			

                    addi $v0, $0, 1		# syscall para imprimir um inteiro
                    add $a0, $0, $a1
                    syscall		

                    addi $v0, $0, 4		# syscall para imprimir uma string
                    la $a0, removido
                    syscall		

                    jr $ra					# jump para $ra
            
            fim_if_remove:
                move $t1, $t0		# prev = current;
                lw $t0, 4($t0)     # current = current->next;
            
                j while_remove # jump para while_remove
        fim_while_remove:
            addi $v0, $0, 4		# syscall para imprimir uma string
            la $a0, valor
            syscall	

            addi $v0, $0, 1		# syscall para imprimir um inteiro
            add	$a0, $0, $a1
            syscall		

            addi $v0, $0, 4		# syscall para imprimir uma string
            la $a0, notfound
            syscall						

            jr $ra					# jump para $ra
        
    # void printList(Node* inicio)
    printList:
        move $t0, $a0		# current = $a0
        beqz $t0, if_vazia  # if inicio == NULL

        j fim_if_vazia      # senão jump para fim_if_vazia

        if_vazia:
            addi $v0, $0, 4		# syscall para imprimir uma string
            la $a0, vazia
            syscall		

            jr $ra

        fim_if_vazia:
            addi $v0, $0, 4		# syscall para imprimir uma string
            la $a0, lista
            syscall						

        while_print:
            beqz $t0, fim_while_print		# if (current == NULL), va para not_found
        
            lw $t1, 0($t0)		# current->data

            addi $v0, $0, 1		# syscall para imprimir um inteiro
            add $a0, $0, $t1
            syscall						

            addi $v0, $0, 11		# syscall para imprimir um caracter
            li $a0, 32             # ' ' (ASCII)
            syscall						

            lw $t0, 4($t0)     # current = current->next; 
        
            j while_print # jump para while_print

        fim_while_print:
            jr $ra					# jump para $ra