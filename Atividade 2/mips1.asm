.data
	str1: .space 100
	str2: .space 100
	str3: .space 200

	ent1: .asciiz "\nInsira a string 1: "
	ent2: .asciiz "\nInsira a string 2: "
	string_lida: .asciiz "\nA string lida: "
	intercalada: .asciiz "\nIntercalacao das strings: "
	
.text
	main:
		la $a0, ent1		# $a0 = endereço da mensagem a ser impresssa
		la $a1, str1		# $a1 = endereço de str1

		jal leitura_str		# le a str1
		
		la $a0, str1		# passa o endereco de str1 como argumento

		jal tam_str		# calcula o tamanho de str1

		add $s0, $zero, $v0		# $s0 = tamanho de str1
			
		la $a0, string_lida		# $a0 = endereco de string_lida
		la $a1, str1		# $a1 = endereco de str1

		jal imprimir		# vai para a funcao imprimir
		
		la $a0, ent2		# $a0 = endereço da mensagem a ser impresssa
		la $a1, str2		# $a1 = endereço de str2

		jal leitura_str		# le a str2
		
		la $a0, str2		# passa o endereco de str2 como argumento

		jal tam_str		# calcula o tamanho de str2

		add $s1, $zero, $v0		# $s1 = tamanho de str2
		
		la $a0, string_lida		# $a0 = endereço da mensagem a ser impresssa
		la $a1, str2		# $a1 = endereco de str2

		jal imprimir		# vai para a funcao imprimir
		
		# iniciando o processo para intercalar as duas strings
		add $a0, $zero, $s0		# passando o tamanho de str1 como argumento
		add $a1, $zero, $s1		# passando o tamanho de str2 como argumento

		la $a2, str1		# passando o endereço de str1 como argumento
		la $a3, str2		# passando o endereço de str2 como argumento

		jal intercala		# vai para a funcao intercala
		
		la $a0, intercalada		# $a0 = endereço da mensagem a ser impresssa
		la $a1, str3		# $a1 = o endereco de str3

		jal imprimir		# vai para a funcao imprimir
		
		jal finalizar		# va para a funcao finalizar para encerrar o programa
	
	leitura_str:
		li $v0, 4
		syscall
		
		addi $v0, $zero, 8
		la $a0, ($a1)		# $a0 = endereco do segmento de memoria que vai guardar a str
		addi $a1, $zero, 100		# $a1 = 100
		syscall
	
		jr $ra		# volta para a funcao main
	
	imprimir:
		addi $v0, $zero, 4
		syscall		# codigo syscall que ira imprimir string_lida
		
		la $a0, ($a1)		# $a0 = endereco da mensagem e $a1 = endereco da str na funcao main
		syscall 	# codigo syscall que ira imprimir a str
		
		jr $ra		# volta para a funcao main
			
	tam_str:
		addi $sp, $sp, -4
		sw $s0, 0($sp)		# empilhando o(s) registrador(es) save
		
		addi $s0, $zero, 0		# $s0(tamanho de str) = 0
		la $t0, ($a0)		# $t0 = endereço base de str
		addi $t1, $zero, 0		# $t1 = 0 (i = 0)
		
		loop_tam:
			add $t2, $t1, $t0		# $t2 == &str[i]
			
			lbu $t3, 0($t2)		# $t3 = str[i]
			
			beq $t3, $t4, fim_tam		# if ($t3 == '\n'), va para fim_tam
			beq $t3, $zero, fim_tam		# if ($t3 == '\0'), va para fim_tam
				
			addi $s0, $s0, 1		# tamanho da string += 1
			addi $t1, $t1, 1		# i++

			j loop_tam		# va para o loop_tam
			
		fim_tam:
			add $v0, $s0, $zero		# $v0 = tamanho da string
			lw $s0, 0($sp)		# desempilhando o(s) registrador(es) save
			addi $sp, $sp, 4 

			jr $ra		# volta para a funcao main
	
	intercala: # $a2 = endereço de str1, $a3 = endereço de str2
		addi $sp, $sp, -12
		sw $s0, 0($sp)		# $s0 = tamanho da menor str (tamMenorStr)
		sw $s1, 4($sp)		# $s1 = tamanho da maior str (tamMaiorStr)
		sw $s2, 8($sp)
	
	se:	
		slt $t2, $a1, $a0   #if (tamanho(str1) > tamanho(str2)) $t2 = 1; else $t2 = 0;
		beq $t2, $zero, senao 
		
		addi $s1, $a0, 0		# tamMaiorStr = tamanho de str1
		la $t1, ($a2)		# $t1(enderecoMaiorStr) = endereço de str1
		
		addi $s0, $a1, 0		# tamMenorStr = tamanho de str2
		la $t0, ($a3)		# $t0(enderecoMenorStr) = endereco de str2

		j proximo		# va para a funcao proximo
	
	senao:   
		addi $s1, $a1, 0		# tamMaiorStr = tamanho de str2
		la $t1, ($a3)		# $t1(enderecoMaiorStr) = endereco de str2
		
		addi $s0, $a0, 0		# tamMenorStr = tamanho de str1
		la $t0, ($a2)		# $t0(enderecoMenorStr) = endereco de str1
		
	proximo:  	
		addi $t2, $zero, 0		# i = 0;
		addi $t3, $zero, 0		# j = 0;
		la $s2, str3		# $s2 = endereço de str3
		
		intercala_loop1:		# de i=0 até tamanho(MenorStr) - 1
			add $t4, $t2, $t0		# $t4 = &menor[i]
			add $t5, $t2, $t1		# $t5 = &maior[i]
								
			lbu $t6, 0($t4)		# $t6 = MenorStr[i]
			lbu $t7, 0($t5)		# $t7 = MaiorStr[i]
			
			add $t9, $t3, $s2		# $t9 = &str3[j]
			sb $t6, ($t9)		# guarda o caractere atual da MenorStr na string_intercala
			
			addi $t3, $t3, 1		# j++
			add $t9, $t3, $s2		# $t9 = &str3[j]
			sb $t7, ($t9)		# guarda o caractere atual da MaiorStr na string_intercala
			addi $t3, $t3, 1		# j++

			addi $t2, $t2, 1		# i++
			slt $t8, $t2, $s0		# se $t2(i) < tamMenorStr, va para intercala_loop1
			bne $t8, $zero, intercala_loop1
			
		intercala_loop2:		# do i atual até tamanho(MaiorStr) - 1
			slt $t8, $t2, $s1		# se t2(i) >= tamMaiorStr, va para fim
			beq $t8, $zero, fim
			
			add $t5, $t2, $t1		# $t5 = &maior[i]
		 	lbu $t7, 0($t5)		# $t7 = MaiorStr[i]
		 	
		 	add $t9, $t3, $s2		# $t9 = &string_inter[j]
			sb $t7, ($t9)		# guarda o caractere atual da MaiorStr na string_intercala
			addi $t3, $t3, 1		# j++
			
			addi $t2, $t2, 1		# i++
			
			j intercala_loop2		# va para intercala_loop2
	
	fim:
		lw $s0, 0($sp)
		lw $s1, 4($sp)
		lw $s2, 8($sp)
		jr $ra		# volte para a main

	finalizar:
		addi $v0, $zero, 10		# encerrando o programa
		syscall