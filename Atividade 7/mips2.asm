.data
	cpf:  	 .space 14  #xxxxxxxxx-xx\n\0
	msg1: 	 .asciiz "\nDigite o CPF (xxxxxxxxx-xx):\n"
	msg2:		 .asciiz "\nCPF: "
	msgErro: 	 .asciiz "\nO formato do cpf esta invalido.\nPor favor, tente novamente usando o seguinte formato: xxxxxxxxx-xx.\n"
	msgValido:	 .asciiz "\nO CPF informado eh valido.\n"
	msgInvalido: .asciiz "\nO CPF informado eh invalido.\n"
	nova_linha:	 .asciiz "\n"
	
.text
	main:
		# lendo o CPF
		la $a0, msg1		# passando como parametro o endereço da mensagem a ser impressa
		la $a1, cpf		 # passando como parametro o endereço do segmento de memoria que vai guardar da string a ser lida
		jal leitura_string
		
		la $a0, cpf
		jal checar_formato_cpf		# checando se o formato do CPF esta correto
		addi $s0, $v0, 0
		
		bne $s0, $zero, checando_cpf		# se(formato do cpf eh valido), va para checando_cpf 
		
		addi $v0, $zero, 4
		la $a0, msgErro		# syscall para a mensagem de erro do CPF
		syscall 
		
		j fim_main
		
		checando_cpf:		# checando se o CPF eh valido
			la $a0, msg2
			la $a1, cpf
			jal imprimir_string
			
			la $a0, cpf
			jal checar_cpf
			addi $s0, $v0, 0
			
			beq $s0, $zero, else		# se(cpf é valido)
			
			addi $v0, $zero, 4
			la $a0, msgValido
			syscall
			
			j fim_main
		
		else:			   #else
			addi $v0, $zero, 4
			la $a0, msgInvalido
			syscall
			
		fim_main:
			addi $v0, $zero, 10		# finalizando o programa
			syscall
		
	leitura_string:
		li $v0, 4
		syscall
		
		addi $v0, $zero, 8
		la $a0, ($a1)
		addi $a1, $zero, 14
		syscall
	
		jr $ra
	
	tamanho_string:
		addi $sp, $sp, -24
		sw $s0, 0($sp)		# empilhando registrador
		sw $t0, 4($sp)
		sw $t1, 8($sp)
		sw $t2, 12($sp)
		sw $t3, 16($sp)
		sw $t4, 20($sp)
		
		addi $s0, $zero, 0		# tam da string = 0
		la $t0, ($a0)      # $t0 = endereco base da string
		addi $t1, $zero, 0		# $t1 = 0 (i = 0)
		
		lbu $t4, nova_linha		# $t4 = '\n'
		
		loop_tamanho:
			add $t2, $t1, $t0		# $t2 = deslocamento + endereço base do vetor ($t2 == &string[i])
			
			lbu $t3, 0($t2)		# $t3 = string[i]
			
			beq $t3, $t4, fim_tamanho		# se($t3 == '\n'), sair do loop
			beq $t3, $zero, fim_tamanho		# se($t3 == '\0'), sair do loop
				
			addi $s0, $s0, 1		# tamanho da string += 1
			addi $t1, $t1, 1		# i++
			j loop_tamanho
			
		fim_tamanho:
			add $v0, $s0, $zero		# $v0 = tamanho da string
			lw $s0, 0($sp)		# desempilhando registrador(es) 
			lw $t0, 4($sp)
			lw $t1, 8($sp)
			lw $t2, 12($sp)
			lw $t3, 16($sp)
			lw $t4, 20($sp)
			addi $sp, $sp, 24 
			jr $ra
		
	imprimir_string: #(a0 = endereço da mensagem a ser impressa antes, a1 = endereço da string a ser impressa)
		addi $v0, $zero, 4
		syscall		# syscall para imprimir "\nCPF: "
		
		la $a0, ($a1)
		syscall		# "a string a ser impressa"
		
		jr $ra
		
	checar_formato_cpf:
		addi $sp, $sp, -12
		sw $ra, 0($sp)
		sw $s0, 4($sp)
		sw $s1, 8($sp)
		
		addi $s0, $zero, 0		# resultado = 0 (falso)
		la $t0, ($a0)		# $t0 = endereco base da string
		addi $t1, $zero, 0		# $t1 (i) = 0 
		 
		# constantes:
		addi $t9, $zero, 12		# $t9 = constante 12 = tamanho correto para o cpf
		addi $t8, $zero, 45		# $t8 = constante 45 = codigo ASCII para "-"
		addi $t7, $zero, 57 	# $t7 = constante 57 = codigo ASCII para "9"
		lbu $s1, nova_linha		# $s1 = constante 10 = codigo ASCII para "\n"
		
		jal tamanho_string
		addi $t2, $v0, 0	
		bne $t2, $t9, fim_checar_formato		# se(length(cpf) != 12), return 0;
		
		addi $t9, $zero, 9		# $t9 = constante 9 = indice do caractere "-" no cpf
		
		loop_checar_formato:
			add $t2, $t0, $t1   	   # $t2 = &cpf[i]
			lbu $t3, 0($t2)   	   # $t3 = cpf[i]
			beq $t3, $s1, setar_resultado_checar_formato
			beq $t3, $zero, setar_resultado_checar_formato		# while(nextChar(cpf) != '\n' && nextChar(cpf) != '\0')
			
			bne $t1, $t9 loop_i_diferente_9		# se(i == 9)
			
			bne $t3, $t8, fim_checar_formato		# se(cpf[9] != '-') return 0;
			b loop_checar_formato_inc_i
			
			loop_i_diferente_9:
			slti $t4, $t3, 48   	    # coloque $t4 para 1 se a char atual ascii eh menor do que 48 ("0")
							    # obs: 48 = codigo ASCII para "0"
			sgt $t5, $t3, $t7  	    # coloque $t5 para 1 se a char atual ascii code eh maior que 57 ("9")
				
			add $t6, $t4, $t5	  
			bne $t6, $zero, fim_checar_formato		# se a char atual esta no intervalo "0"-"9", entao $t4 ou $t5 eh falso e isso eh um digito valido do CPF, se nao return 0;
		
			loop_checar_formato_inc_i:
				addi $t1, $t1, 1		# i++
				j loop_checar_formato
		
		setar_resultado_checar_formato:
			sb $zero, 0($t2)		# elimina um possivel caracter '\n' no indice 12 da string cpf
			addi $s0, $s0, 1		# resultado = 1 (verdadeiro). se nos chegamos ate aqui significa que o cpf passou todos os testes e eh valido   
			
		fim_checar_formato:
			addi $v0, $s0, 0
			lw $ra, 0($sp)
			lw $s0, 4($sp)
			sw $s1, 8($sp)
			addi $sp, $sp, 12
			jr $ra
		
	checar_cpf:
		addi $sp, $sp, -12
		sw $ra, 0($sp)
		sw $s0, 4($sp)
		sw $s1, 8($sp)
		
		addi $s0, $zero, 0		# soma 0 = 0
		addi $s1, $zero, 0		# soma 1 = 0
		la $t0, ($a0) 	  # $t0 = endereço base da string.
		addi $t1, $zero, 0 		# $t1 (i) = 0
		addi $t2, $zero, 10		# $t2 (j) = 10 
		addi $t9, $zero, 9		# $t9 = contante 9
		
		loop_checar:
			add $t3, $t0, $t1		# $t3 = &cpf[i]
			lbu $t4, 0($t3)		# $t4 = cpf[i]
			lbu $t5, 1($t3)    	# $t5 = cpf[i+1]
			
			sb $zero, 1($t3)		# cpf[i+1] = '\0'
			la $a0, ($t3)
			jal stringParaInt
			addi $t6, $v0, 0		# $t6 = atoi(cpf[i])
			
			mult $t6, $t2    
			mflo $t7  		 # $t7 = digito atual * j
			add $s0, $s0, $t7		# $s0 += (digito atual * j)
	
			add $s1, $s1, $t7
			add $s1, $s1, $t6		# 4s1 += (digito atual * (j+1))
			
			sub $t2, $t2, 1    # j--
			sb $t5, 1($t3)     # cpf[i+1] = valor original.
			
			addi $t1, $t1, 1   # i++
			blt  $t1, $t9, loop_checar		# while(i<9)
		
		addi $t2, $zero, 2		# $t2 = constante 2
		addi $t3, $zero, 11		# $t3 = constante 11
		
		digitoVerificador1:
			div $s0, $t3	  		
			mfhi $t4		  # $t4 = resultado1 = soma0 % 11
			addi $t5, $zero, 0		# $t5 = digitoVerificador1 = 0
			
			blt $t4, $t2, digitoVerificador2		# se(resultado1 >= 2)
			sub $t5, $t3, $t4		# digitoVerificador1 = 11 - resultado1
		
		digitoVerificador2:	
			sll $t6, $t5, 1     
			add $s1, $s1, $t6		# soma1 += 2 * digitoVerificador1
			
			div $s1, $t3	  		
			mfhi $t4		  # $t4 = resultado2 = soma1 % 11
			addi $t6, $zero, 0		# $t6 = digitoVerificador2 = 0
			
			blt $t4, $t2, checagem		# se(resultado2 >= 2)
			sub $t6, $t3, $t4      # digitoVerificador2 = 11 - resultado2
		
		checagem:		# $t5 = digitoVerificador1, $t6 = digitoVerificador2
			addi $t2, $zero, 10		# $t2 = constante 10
			add $a0, $t0, $t2		# $a0 = &cpf[10] (endereco do primeiro digito verificador do cpf passado para este procedimento)
			jal stringParaInt
			addi $t3, $v0, 0     # $t3 = numero verificador do cpf passado.
			
			mult $t5, $t2 
			mflo $t4             # $t4 = digitoVerificador1 * 10
			add $t4, $t4, $t6    # $t4 = numero verificador calculado a partir dos 9 primeiros digitos do cpf passado.
			
			addi $v0, $zero, 0      
			bne $t3, $t4, fim_checar
			addi $v0, $zero, 1      # se($t3 == $t4) return 1 se nao return 0;
		
		fim_checar:
			lw $ra, 0($sp)
			lw $s0, 4($sp)
			lw $s1, 8($sp)
			addi $sp, $sp, 12
			jr $ra
	
	stringParaInt:
			addi $sp, $sp, -28
			sw $s0, 0($sp)
			sw $s1, 4($sp)
			sw $t1, 8($sp)
			sw $t2, 12($sp)
			sw $t3, 16($sp)
			sw $t7, 20($sp)
			sw $t8, 24($sp)
						
			addi $s0, $zero, 0  # resultado = 0
			la $s1, ($a0)	  # $s1 = endereço numero (string)
			addi $t1, $zero, 0		# $t1 (i) = 0 
			addi $t7, $zero, 10		# $t7 = contatante 10	
			addi $t8, $zero, 48		# $t8 = 48 = '\0' ASCII code
																				
			loop_string_int:
				add $t2, $s1, $t1		# $t2 = endereço string + deslocamento (t2 = &string[i])
				lbu $t3, 0($t2)		# $t3 = string[i]
				
				beq $t3, $zero, fim_string_int 		# while(*string != '\0')
				
				# resultado = (resultado * 10) + (*string - '0');
				mult $s0, $t7
				mflo $s0	       # resultado *= 10
				
				sub $t2, $t3, $t8  # $t2 = (*string - '0')
				add $s0, $s0, $t2 
				
				addi $t1, $t1, 1		# i++
				j loop_string_int
				
			fim_string_int:
				addi $v0, $s0, 0						
				lw $s0, 0($sp)
				lw $s1, 4($sp)
				lw $t1, 8($sp)
				lw $t2, 12($sp)
				lw $t3, 16($sp)
				lw $t7, 20($sp)
				lw $t8, 24($sp)
				addi $sp, $sp, 28
				jr $ra