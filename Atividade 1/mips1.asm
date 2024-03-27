.data
vet: .space 48
tam: .word 12
soma_pares: .word 0

bubble: .asciiz "\n\nOs valores em ordem crescente: "
espaco: .asciiz " "
inteiro: .asciiz "\nDigite um numero: "
prompt_k: .asciiz "\n\nDigite a chave k: "
igual_ks: .asciiz"\nO numero de valores do vetor que sao iguais a k: "
valores_k: .asciiz "\nOs valores do vetor que estao entre k e k*2, sao: "
pula_linha: .asciiz "\n"
num_perfeito: .asciiz "\n\nSoma dos numeros perfeitos: "
vetor_inicial: .asciiz "\nO vetor inicial: "
somatorio_par: .asciiz "\nA soma dos pares: "
soma_semiprimo: .asciiz "\n\nSoma dos numeros semiprimos: "
perfeito_primo: .asciiz "\n\nSoma dos perfeitos - soma dos semiprimos: "


.text
.globl main

main:
	jal preencher      # chamo preencher para preencher o vetor com os valores do usuario e para mostrar na tela

    jal bubble_sort     # chamo o bubble_sort para ordenar o vetor
	
	jal soma_par    # chamo o soma_par para soma os pares do vetor

    jal chave_k     # chamo o chave_k para mostrar os valores entre k e k*2

    jal diferente_k     # chamo o diferente_k para mostrar os valores do vetor que sao iguais a k

    jal primo_perfeito # chamo o primo_perfeito para fazer a soma dos números inteiros perfeitos menos a soma dos números inteiros semiprimos

    jal fim_programa       # chamo o fim_programa para encerrar o codigo
	
preencher:
    li $t1, 0       # $s0 = 0, ira ser nosso contador i=0
    
	la $t0, vet     # $t0 = endereco inicial de vet

    loop_preencher:
        bge $t1, 12, fim_loop       # se $s0 for maior ou igual a 12 o loop se encerra
        
        li $v0, 4       # chama a mensagem para digitar um numero
        la $a0, inteiro
        move $a1, $t1       # passa o contador como argumento
        syscall
        
        li $v0, 5       # syscall para ler um numero inteiro
        syscall
        sw $v0, 0($t0)      # armazena o inteiro no vetor

        addi $t0, $t0, 4        # move para a proxima posicao de vet
        
        addi $t1, $t1, 1        # incrementa o contador, i=i+1
        
        j loop_preencher        # recomeca o loop
	
fim_loop:
    li $v0, 4,		# imprime a mensagem para mostrar o vetor inserido pelo usuario
	la $a0, vetor_inicial
	syscall

    # imprime os elementos do vetor
    li $t1, 0       # reinicia o contador do loop

    la $t0, vet   # reinicia o ponteiro do vetor

preencher_loop:
    bge $t1, 12, vetor_sair     # verifica se o contador eh igual a 12 (numero de elementos)

    lw $a0, 0($t0)      # carrega o proximo elemento do vetor
    li $v0, 1      # syscall para imprimir um inteiro
    syscall
    
    li $v0, 4 
    la $a0, espaco      # da um espaco
    syscall

    addi $t1, $t1, 1    # incrementa o contador

    addi $t0, $t0, 4    # move para o proximo elemento do vetor

    j preencher_loop    # repete o loop

vetor_sair:
    jr $ra      # volta para a main e executa a proxima instrucao

bubble_sort:
    la $s2, vet		# carrega o endereco do vetor em $s7

	li $s0, 0		# inicializa o contador 1 do loop 1

	li $s3, 11 		# n - 1
	
	li $s1, 0 		# inicializa o contador 2 do loop 2

	li $t3, 0		# inicializa o contador para imprimir os valores

	li $t4, 12      # $t4 == tamanho do vetor

	li $v0, 4,		# imprime a mensagem para mostrar os valores em ordem crescente
	la $a0, bubble
	syscall

bubble_loop:
	sll $t7, $s1, 2			# multiplica $s1 por 2 e guarda no $t7

	add $t7, $s2, $t7 	    # coloca o valor do vetor em $t7

	lw $t0, 0($t7)  	# carrega o vet[j]	

	lw $t1, 4($t7) 		# carrega o vet[j+1]

	slt $t2, $t0, $t1		#se t0 < t1
	bne $t2, $zero, bubble_incrementa

	sw $t1, 0($t7) 		# troca

	sw $t0, 4($t7)

bubble_incrementa:	
	addi $s1, $s1, 1		# incrementa $s1

	sub $s5, $s3, $s0 		# subtrai $s0 de $s6

	bne  $s1, $s5, bubble_loop			# se $s1 != 11, va para bubble_loop

    addi $s0, $s0, 1 		# se nao, soma 1 em $s0

	li $s1, 0 		# reseta $s1 para 0

	bne  $s0, $s3, bubble_loop     # vai para o loop com $s1 = $s1 + 1
	
bubble_imprimir:
	beq $t3, $t4, bubble_sair	# se $t3 == $t4 va para o bubble_sair
	
	lw $t5, 0($s2)		# carrega do vet
	
	li $v0, 1		# imprime o numero na tela
	move $a0, $t5
	syscall

	li $v0, 4 
    la $a0, espaco      # da um espaco
    syscall
	
	addi $s2, $s2, 4	# incrementa o vetor

	addi $t3, $t3, 1    # incrementa o contador

	j bubble_imprimir

bubble_sair:
    jr $ra      # volta para a main e executa a proxima instrucao
    
soma_par: 
    la $t0, vet     # carregar o endereco do vetor na $t0
    
    la $t1, tam         # carregar o endereco da variavel tamanho na $t1 e o valor em $t1

    lw $t1, 0($t1)
    
    li $t2, 0       # inicializar a soma com 0

    # Loop para percorrer o vetor
    loop_soma:
        lw $t3, 0($t0)      # carregar o valor atual do vetor
        
        andi $t4, $t3, 1       # verificar se o numero eh par

        bne $t4, $zero, impar

        add $t2, $t2, $t3       # somar o numero par a soma

        impar:
            addi $t0, $t0, 4        # avancar para o proximo elemento do vetor
            
            addi $t1, $t1, -1       # decrementar o contador
            
            bnez $t1, loop_soma     # verificar se chegamos ao final do vetor

    sw $t2, soma_pares      # armazenar a soma na variavel 'soma'

    li $v0, 4       # pula linha
    la $a0, pula_linha
    syscall
    
    li $v0, 4       # imprimir a soma
    la $a0, somatorio_par
    syscall
    
    li $v0, 1       # carregar o codigo da syscall para imprimir um inteiro
    lw $a0, soma_pares      # carregar a soma para imprimir
    syscall

    jr $ra      # volta para a main e executa a proxima instrucao

chave_k:
    la $t0, vet     # reinicia o ponteiro do vetor

    li $v0, 4       # chama a mensagem para digitar um numero
    la $a0, prompt_k
    move $a1, $t1       # passa o contador como argumento
    syscall

    li $v0, 5       # carrega o codigo da syscall para ler um inteiro
    syscall
    move $t2, $v0       # armazena o valor de k em $t2

    sll $t7, $t2, 1     # multiplica k por 2 e armazena em $t7

    li $t4, 0       # inicializa o contador i=0

    la $a0, valores_k
    li $v0, 4       # chama a mensagem de resultado
    syscall

    loop_k:
        beq $t4, 12, sair_k

        lw $t3, 0($t0)      # carregar o valor atual do vetor

        bgt $t3, $t2, menor_2k      # se $t3 > $t2, va para menor_2k

        addi $t4, $t4, 1        # incrementa o contador

        addi $t0, $t0, 4        # move para o proximo elemento do vetor

        j loop_k
    
    menor_2k:   
        addi $t4, $t4, 1        # incrementa o contador

        addi $t0, $t0, 4        # move para o proximo elemento do vetor

        blt $t3, $t7, imprimir_k        # se $t3 < $t7, va para imprimir_k

        j loop_k        # volta para o loop loop_k
    
    imprimir_k:
        li $v0, 1       # carregar o codigo da syscall para imprimir um inteiro
        move $a0, $t3       # carregar o elemento do vetor para imprimir
        syscall

        li $v0, 4       # chama a mensagem para dar espaço
        la $a0, espaco
        syscall
    
        j loop_k

    sair_k:
        jr $ra      # volta para a main e executa a proxima instrucao

diferente_k:
    la $t0, vet     # reinicia o ponteiro do vetor

    li $t4, 0       # inicializa o contador i=0

    li $t6, 0       # usado como contador para os numeros iguais a k

    loop_k_igual:
        beq $t4, 12, imprimir_igual

        lw $t3, 0($t0)      # carregar o valor atual do vetor

        beq $t3, $t2, igual_k       # se $t3 == $t2, va para igual_k

        addi $t4, $t4, 1        # incrementa o contador

        addi $t0, $t0, 4        # move para o proximo elemento do vetor

        j loop_k_igual

    igual_k:
        addi $t6, $t6, 1        # incrementa o contador para numeros iguais a k

        addi $t4, $t4, 1        # incrementa o contador

        addi $t0, $t0, 4        # move para o proximo elemento do vetor

        j loop_k_igual

    imprimir_igual:
        li $v0, 4       # pula a linha
        la $a0, pula_linha
        syscall

        li $v0, 4       # chama a mensagem de resultado
        la $a0, igual_ks
        syscall

        move $a0, $t6       # carregar o contador de numeros iguais a k
        li $v0, 1       # carregar o codigo da syscall para imprimir um inteiro
        syscall
    
        jr $ra      # volta para a main e executa a proxima instrucao

primo_perfeito:
    la $t0, vet         # reinicia o ponteiro de vet

    move $t1, $t0       # $t1 recebe o endereco de vet[i]

	li $t2, 0 	    # ($t2)i = 0

	li $s1, 0  	    # divisor($s1) = 0

	li $s2, 0 	    # soma($s2) = 0

	li $s3, 0 	    # soma_perfeito($s3) = 0
		
	perfeito:	
		lw $a0, ($t1)		    # carrega valor de vet[i]
			
		ble $a0, $zero, f1	    # se vet[i] <= for zero, jump para f1
			
		addi $s1, $s1, 1 	    # divisor($s1) += 1

		beq $s1, $a0, verifica	    # se divisor($s1) == inteiro($a0), va para verifica

		div $a0, $s1 	    # hi = resto da divisao de vet[i] / divisor($s1)

		mfhi $t5	    # $t5 = conteudo de hi

		bne $t5, $zero, perfeito 	    # se o resto($t5) != 0, volta para perfeito

		add $s2, $s2, $s1 	    # senao, soma($s2) += divisor($s1)

		j perfeito
			
	verifica: 
		bne $s2, $a0, f1 	    # se soma($s2) != vet[i], va para f1

		add $s3, $s3, $a0	    # soma_perfeito($s3) = vet[i]

	f1:	
        add $t1, $t1, 4 	    # endereco de vet[i+1]

		addi $t2, $t2, 1	    # i($t2)i++

		addi $s1, $zero, 0      # reseta o valor de divisor

		addi $s2, $zero, 0 	    # reseta o valor de soma

		blt $t2, 12, perfeito	    # se i < 12, va para perfeito
			
	li $v0, 4	    # codigo SysCall para escrever strings
    la $a0, num_perfeito
    syscall
        
    move $a0, $s3	    # carrega valor de vet[i]
	li $v0, 1 	    # codigo para impressao de um inteiro 
	syscall
		
		
	move $t1, $t0	    # $t1 = endereco de vet[i]

	li $t3, 0	    # j($t3) = 0

	li $s4, 0	    # somaPrimo($s4) = 0

	li $t6, 2	    # dois($t6) = 2
		
	semi_primo:
		li $s2, 0	    # fatores($s2) = 0

		li $t2, 1 	    # i($t2) = 1

		lw $a0, ($t1)	    # carrega valor de vet[i]

		add $s5, $a0, $zero	    # $s5 = vet[i]
			
		ble $s5, $t6, f2	    # se vet[i] <= dois($t6), va para f2
			
		div $s5, $t6	    # lo = vet[i] / dois($t6)

		mflo $t5	    # fim($t5) = conteudo de lo
			
	loop_para:	    # para(int i=2; i <= fim; i++)
		addi $t2, $t2, 1     # i($t2)++

		bgt $t2, $t5, fim_primo     # se i($t2) > fim($t5), va para fim_primo
		
			
	loop_enquanto:	    # while (num % i == 0)
		div $s5, $t2	    # hi = resto da divisao de vet[i] / i($t2)

		mfhi $t7
			
		bne $t7, $zero, loop_para        # se $t7 != 0, va para o loop_para
			
		div $s5, $t2	    # lo = vetor[i] / i($t2)

		mflo $s5	    # vetor[i]($s5) = vetor[i]($s5) / i($t2)

		addi $s2, $s2, 1	    # fatores($s2)++

		j loop_enquanto
			
	fim_primo:
		bne $s2, $t6, f2	    # fatores($s2) != dois($t6) 

		add $s4, $s4, $a0	    # somaPrimo($s4) += vet[i]

	f2:	
        add $t1, $t1, 4 	    # endereco de vet[i+1]

		addi $t3, $t3, 1	    # j($t3)++

		blt $t3, 12, semi_primo	    # se j < 12, va para semi_primo
			
	li $v0, 4	    # codigo SysCall para escrever strings
    la $a0, soma_semiprimo
    syscall
        
    move $a0, $s4	    # carrega valor de vet[i]
	li $v0, 1       # codigo syscall para impressao de inteiro 
	syscall

    li $v0, 4       # codigo SysCall para escrever strings
    la $a0, perfeito_primo
    syscall
        
    sub $s5, $s3, $s4       # $s5 = soma dos perfeitos - soma dos semiprimos
		
	move $a0, $s5       # imprime o valor de $s5
	li $v0, 1       # codigo para impressao de inteiro 
	syscall
		
	jr $ra      # volta para a main

fim_programa:
    li $v0, 10      # Carrega o codigo da syscall para sair do programa
    syscall
