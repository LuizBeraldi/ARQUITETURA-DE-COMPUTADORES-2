.data
	vetor: .space 48	# reserva espaço para 12 inteiros (12 * 4 bytes)
	msg1: .asciiz "Digite vetor["
	msg3: .asciiz "Vetor ordenado: "
	msg2: .asciiz "]: "
	msg4: .asciiz "\nSoma valores pares: "
	msg5: .asciiz "\nDigite uma chave k: "
	msg6: .asciiz "Valores maiores que ["
	msg7: .asciiz "] e menores que ["
	msg8: .asciiz "\nValores iguais a ["
	msg9: .asciiz "\nSoma perfeitos: "
	msg10: .asciiz "\nSoma Semiprimos: "
	msg11: .asciiz "\nSomaPerfeito - SomaSemiPrimo: "
	msg12: .asciiz "\nErro: valor nao positivo!"
	
.text
	.globl main
main:
	
	la $a0, vetor	# endereço do vetor como parâmetro
	jal lerVetor	# leitura(vetor)
	move $a0, $v0	# retorna endereço do vetor
		
	li $v0, 4	# codigo SysCall para escrever strings
    	la $a0, msg3	# parâmetro ("Vetor ordenado: ")
    		syscall
    		
    	la $a0, vetor	# endereço do vetor como parâmetro
	jal ordenarVetor	# ordena(vetor)
		
	la $a0, vetor	# endereço do vetor como parâmetro
	jal escreverVetor	# impressão(vetor)
		
	la $a0, vetor	# endereço do vetor como parâmetro
	jal somaPar	# retorna soma valores pares do vetor
		
	li $v0, 4	# codigo SysCall para escrever strings
    	la $a0, msg4	# parâmetro ("\nSoma valores pares: ")
    	syscall
	
	move $a0, $s2	# carrega valor de vetor[i]
	li $v0, 1 	# codigo para impressão de inteiro 
	syscall
		
	la $a0, vetor	# endereço do vetor como parâmetro
	jal diferenteK
		
	la $a0, vetor	# endereço do vetor como parâmetro
	jal igualK
		
	la $a0, vetor	# endereço do vetor como parâmetro
	jal primoPerfeito
		
	li $v0, 4	# codigo SysCall para escrever strings
    	la $a0, msg11	# parâmetro ("\nSomaPerfeito - SomaPrimo: ")
    	syscall
    		
    	sub $s5, $s3, $s4	# R($s5) = somaPerfeito - somaPrimo
		
	move $a0, $s5	# carrega valor de R($s5)
	li $v0, 1 	# codigo para impressão de inteiro 
	syscall
		
	li $v0, 10 	# código para finalizar programa
	syscall

lerVetor:
	move $t0, $a0 	# salva endereço base do vetor em $t0
	move $t1, $t0	# $t1 = endereço de vetor[i]
	li $t2, 0 	# ($t2)i = 0
		
	lV: 	li $v0, 4	# codigo SysCall para escrever strings
    		la $a0, msg1	# parâmetro ("Digite vetor[")
    		syscall
			
		move $a0, $t2	# carrega índice do vetor
		li $v0, 1 	# codigo para impressão de inteiro 
		syscall
			
		li $v0, 4	# codigo SysCall para escrever strings
    		la $a0, msg2	# parâmetro ("]:")
    		syscall
    			
    		li $v0, 5	# codigo SysCall para ler inteiros
    		syscall		# inteiro lido armazenado em $v0
    			
    		sw $v0, ($t1)	# vetor[i] = inteiro lido($v0)
		add $t1, $t1, 4 	# endereço de vetor[i+1]
		addi $t2, $t2, 1	# ($t2)i++
	blt $t2, 12, lV	# se i < 12 retorna loop(lV)
		
	move $v0, $t0	# retorna endereço do vetor
	jr $ra 		# retorna para main
		
	
escreverVetor:
	move $t0, $a0	# salva endereço base do vetor em $t0
	move $t1, $t0	# $t1 = endereço de vetor[i]
	li $t2, 0 	# ($t2)i = 0
		
	eV:	lw $a0, ($t1)	# carrega valor de vetor[i]
		li $v0, 1 	# codigo para impressão de inteiro 
		syscall
		
		li $a0, 32	# código ASCII para espaço
		li $v0, 11	# código para impressão de caractere
		syscall
		
		add $t1, $t1, 4 	# endereço de vetor[i+1]
		addi $t2, $t2, 1	# ($t2)i++
	blt $t2, 12, eV	# se i < 12 retorna loop(eV)
		
	move $v0, $t0	# retorna endereço do vetor
	jr $ra 		# retorna para main	
		
	
ordenarVetor:
	move $t0, $a0	# salva endereço base do vetor em $t0
	move $t1, $t0	# $t1 = endereço de vetor[0]
	li $t2, 0 	# i($t2) = 0
	li $t3, 0 	# j($t3) = 0
	li $t5, 11	# n($t5) = 11
		
	oV:	lw $a0, ($t1)	# carrega valor de vetor[j]
		lw $t7, 4($t1) 	# $t7 = vetor[j+1]
		ble $a0, $t7, c0	# se vetor[j] <= vetor[j+1] jump para c0
		# ou seja, se vetor[j] > vetor[j+1] será feita troca
		sw $t7, ($t1)	# vetor[j] = valor de vetor[j+1]
		sw $a0, 4($t1)	# vetor[j+1] = valor de vetor[j]
		
						
	c0:	add $t1, $t1, 4 	# endereço de vetor[j+1]
		addi $t3, $t3, 1	# j($t3)++
		sub $t4, $t5, $t2	# $t4 = n-1 - i
		blt $t3, $t4, oV	# se j < 11-i jump de volta para oV (loop interno)
		addi $t2, $t2, 1	# i($t2)++
		li $t3, 0 		# j($t3) = 0 (reseta valor de j)
		move $t1, $t0		# $t1 = endereço de vetor[0] (reseta vetor)
	blt $t2, $t5, oV	# se i < n-1 jump de volta para oV (loop externo)
		
	move $v0, $t0	# retorna endereço do vetor
	jr $ra 		# retorna para main
		
			
somaPar:
	move $t0, $a0	# salva endereço base do vetor em $t0
	move $t1, $t0	# $t1 = endereço de vetor[i]
	li $t2, 0 	# ($t2)i = 0
	li $t4, 2 	# $t4 = 2
	
	sP:	lw $a0, ($t1)	# carrega valor de vetor[i]
		div $a0, $t4 	# hi = resto da divisao de vetor[i] / 2
		mfhi $t3	# $t3 = conteudo de hi (resto da divisao)
		bne $t3, $zero, c 	# se o resto($t3) != 0 jump para c
		add $s2, $s2, $a0	# soma($s2) += vetor[i]	
						
	c:	add $t1, $t1, 4 	# endereço de vetor[i+1]
		addi $t2, $t2, 1	# ($t2)i++
	blt $t2, 12, sP	# se i < 12 retorna loop(sP)
		
	move $v0, $t0	# retorna endereço do vetor
	jr $ra 		# retorna para main
							
		
diferenteK:
	move $t0, $a0	# salva endereço base do vetor em $t0
	move $t1, $t0	# $t1 = endereço de vetor[i]
	li $t2, 0 	# ($t2)i = 0
	
chave:	li $v0, 4	# codigo SysCall para escrever strings
    	la $a0, msg5	# parâmetro ("\nDigite uma chave k: ")
    	syscall
    			
    	li $v0, 5	# codigo SysCall para ler inteiros
    	syscall		# inteiro lido armazenado em $v0
    	move $t3, $v0 	# $t3 = chave($v0)
    		
    	# verifica se chave(t3) > 0
    	bgt $t3, $zero, chaveCerta # se chave(t3) > 0 jump chaveCerta
    		
    	li $v0, 4	# codigo SysCall para escrever strings
    	la $a0, msg12	# parâmetro ("\nErro: valor nao positivo!")
    	syscall
    		
    	j chave 	# retorna para leitura da chave K
    		
	chaveCerta:
    	li $v0, 4	# codigo SysCall para escrever strings
    	la $a0, msg6	# parâmetro ("Valores maiores que [")
    	syscall
    		
    	move $a0, $t3	# carrega chave($t3)
	li $v0, 1 	# codigo para impressão de inteiro 
	syscall
		
	li $v0, 4	# codigo SysCall para escrever strings
    	la $a0, msg7	# parâmetro ("] e menores que [")
    	syscall
		
	add $t4, $t3, $t3	# $t4 = 2 * chave($t3)
		
	move $a0, $t4	# carrega 2*chave($t4)
	li $v0, 1 	# codigo para impressão de inteiro 
	syscall
			
	li $v0, 4	# codigo SysCall para escrever strings
    	la $a0, msg2	# parâmetro ("]:")
    	syscall
    				
    	loopK:	lw $a0, ($t1)	# carrega valor de vetor[i]
		ble $a0, $t3, c1 	# se vetor[i] <= chave($t3) jump para c1
		# ou seja, se vetor[i] > chave continua
		
		bge $a0, $t4, c1	# se vetor[i] >= chave($t3) jump para c1
		# ou seja, se vetor[i] < 2*chave será impresso
	
		li $v0, 1 	# codigo para impressão de inteiro 
		syscall
		
		li $a0, 32	# código ASCII para espaço
		li $v0, 11	# código para impressão de caractere
		syscall
						
	c1:	add $t1, $t1, 4 	# endereço de vetor[i+1]
		addi $t2, $t2, 1	# ($t2)i++
	blt $t2, 12, loopK	# se i < 12 retorna loop(maiorK)
		
	move $v0, $t0	# retorna endereço do vetor
	jr $ra 		# retorna para main
		
	
igualK:
    	move $t0, $a0	# salva endereço base do vetor em $t0
	move $t1, $t0	# $t1 = endereço de vetor[i]
	li $t2, 0 	# ($t2)i = 0
	li $t4, 0 	# contador($t4) = 0
		
	li $v0, 4	# codigo SysCall para escrever strings
    	la $a0, msg8	# parâmetro ("\nValores iguais a [")
    	syscall
    		
    	move $a0, $t3	# carrega chave($t3)
	li $v0, 1 	# codigo para impressão de inteiro 
	syscall
			
	li $v0, 4	# codigo SysCall para escrever strings
    	la $a0, msg2	# parâmetro ("]:")
    	syscall
				
	iK:	lw $a0, ($t1)	# carrega valor de vetor[i]
		bne $a0, $t3, c3 	# se vetor[i] != chave($t3) jump para c3
		# ou seja, se vetor[i] == chave incrementa contador
		addi $t4, $t4, 1	# contador($t4)++
						
	c3:	add $t1, $t1, 4 	# endereço de vetor[i+1]
		addi $t2, $t2, 1	# ($t2)i++
	blt $t2, 12, iK	# se i < 12 retorna loop(iK)
		
	move $a0, $t4	# carrega contador($t4)
	li $v0, 1 	# codigo para impressão de inteiro 
	syscall	
		
	move $v0, $t0	# retorna endereço do vetor
	jr $ra 	
		
		
primoPerfeito:
	move $t0, $a0	# salva endereço base do vetor em $t0
	move $t1, $t0	# $t1 = endereço de vetor[i]
	li $t2, 0 	# ($t2)i = 0
	li $s1, 0  	# divisor($s1) = 0 (inicializo com 1 dentro da função "perfeito")
	li $s2, 0 	# soma($s2) = 0 (soma referente aos divisores)
	li $s3, 0 	#somaPerfeito($s3) = 0
		
	perfeito:	
		lw $a0, ($t1)		# carrega valor de vetor[i]
			
		ble $a0, $zero, c4	# se vetor[i] <= for zero jump para c4
			
		addi $s1, $s1, 1 	# divisor($s1) += 1
		beq $s1, $a0, verifica	# se divisor($s1) == inteiro($a0) jump para verifica
		div $a0, $s1 	# hi = resto da divisao de vetor[i] / divisor($s1)
		mfhi $t5	# $t5 = conteudo de hi (resto da divisao)
		bne $t5, $zero, perfeito 	# se o resto($t5) != 0 jump de volta
		add $s2, $s2, $s1 	# senao, soma($s2) += divisor($s1)
		j perfeito 	# jump de volta
			
	verifica: 
		bne $s2, $a0, c4 	# se soma($s2) != vetor[i] jump para c4
		add $s3, $s3, $a0	# somaPerfeito($s3) = vetor [i]
	c4:	add $t1, $t1, 4 	# endereço de vetor[i+1]
		addi $t2, $t2, 1	# i($t2)i++
		addi $s1, $zero, 0  	# divisor($s1) = 0 (reseta valor)
		addi $s2, $zero, 0 	# soma($s2) = 0 (reseta valor)
		blt $t2, 12, perfeito	# se i < 12 retorna loop(perfeito)
			
	li $v0, 4	# codigo SysCall para escrever strings
    	la $a0, msg9	# parâmetro ("\nSoma perfeitos: ")
    	syscall
    		
    	move $a0, $s3	# carrega valor de vetor[i]
	li $v0, 1 	# codigo para impressão de inteiro 
	syscall
		
		
	move $t1, $t0	# $t1 = endereço de vetor[i]
	li $t3, 0	# j($t3) = 0 (contador do vetor[12])
	li $s4, 0	# somaPrimo($s4) = 0
	li $t6, 2	# dois($t6) = 2
		
	semiPrimo:
		li $s2, 0	# fatores($s2) = 0
		li $t2, 1 	# i($t2) = 1
		lw $a0, ($t1)	# carrega valor de vetor[i]
		add $s5, $a0, $zero	# $s5 = vetor[i]
			
		ble $s5, $t6, c5	# se vetor[i] <= dois($t6) jump para c5
			
		div $s5, $t6	# lo = vetor[i] / dois($t6)
		mflo $t5	# fim($t5) = conteudo de lo (divisao)
			
	for:	# for(int i=2; i <= fim; i++)
		addi $t2, $t2, 1  # i($t2)++
		bgt $t2, $t5, fim # se i($t2) > fim($t5) encerera loop for
		
			
	while:	# while (num % i == 0)
		div $s5, $t2	# hi = resto da divisao de vetor[i] / i($t2)
		mfhi $t7
			
		bne $t7, $zero, for # se $t7(resto da divisao) != 0 encerra loop while
			
		div $s5, $t2	# lo = vetor[i] / i($t2)
		mflo $s5	# vetor[i]($s5) = vetor[i]($s5) / i($t2)
		addi $s2, $s2, 1	# fatores($s2)++
		j while
			
	fim:
		bne $s2, $t6, c5	# fatores($s2) != dois($t6) 
		add $s4, $s4, $a0	# somaPrimo($s4) += vetor[i]
	c5:	add $t1, $t1, 4 	# endereço de vetor[i+1]
		addi $t3, $t3, 1	# j($t3)++
		blt $t3, 12, semiPrimo	# se j < 12 retorna loop(primo)
			
	li $v0, 4	# codigo SysCall para escrever strings
    	la $a0, msg10	# parâmetro ("\nSoma Semiprimos: ")
    	syscall
    		
    	move $a0, $s4	# carrega valor de vetor[i]
	li $v0, 1 	# codigo para impressão de inteiro 
	syscall
		
	jr $ra
