.data 
str: .space 100
strx: .space 100

prompt1: .asciiz " eh um palindromo!\n\n"
prompt2: .asciiz " nao eh um palindromo!\n\n"
iniciar: .asciiz "\nDigite a string: "

.text
main:
    la $a0, iniciar
    li $v0, 4
    syscall		# syscall para imprimir na tela a mensagem para o usuario digitar a string

    la $a0, str		# guarda o endereco de str em $a0

    li $a1, 100
    li $v0, 8
    syscall		# syscall para ler a string do usuario

sanitizacao:		# faz a sanatizacao da string para checar 0-9, A-Z e a-z
    la $t1, strx		# string sanitizada

    loop:
        lb $t7, ($a0)		# carrega o valor atual de str
        beq $t7, 10, verificaPalindromo		# se ($t7 == \n), va para verificaPalindromo
        bgt $t7, 47, teste1		# se ($t7 > / (ASCII antes do numero "0")), va para teste1

        j nao_colocar_strx		# se o byte nao estiver no intervalo ASCII desejado, ele nao sera adicionado a strx

        teste1: 
			blt $t7, 58, colocar_strx		# se ($t7 < : (ASCII depois do numero "9")), va para colocar_strx (intervalo 0-9)
			bgt $t7, 64, teste2		# se ($t7 > @ (ASCII antes da letra "A")), va para teste2

			j nao_colocar_strx

        teste2: 
			blt $t7, 91, colocar_strx		# se ($t7 < ] (ASCII depois da letra "Z")), va para colocar_strx  (intervalo A-Z)
			bgt $t7, 96, teste3		# se ($t7 > ` (ASCII antes da letra "a")), va para teste3

			j nao_colocar_strx		# se o byte nao estiver no intervalo ASCII desejado, ele nao sera adicionado a strx

        teste3: 
			blt $t7, 123, colocar_strx		# se ($t7 < { (ASCII depois de "z")), va para colocar_strx (intervalo a-z)

			j nao_colocar_strx		# se o byte nao estiver no intervalo ASCII desejado, ele nao sera adicionado a strx

    colocar_strx:		# verifica se a letra eh minuscula ou maiuscula, se for minuscula, transforma em maiuscula antes de adicionar no vetor
        bgt $t7, 96, ficar_maiuscula		# se ($t7 > ` (ASCII antes da letra "a")), va para ficar_maiuscula

        j nao_fazer_maiuscula		# vai para o loop nao_fazer_maiuscula para adicionar a letra no vetor

        ficar_maiuscula: 
			addi $t7, $t7, -32		# transforma a letra minuscula na mesma letra so que maiuscula

        nao_fazer_maiuscula:
			sb $t7, ($t1)
			addi $a0, $a0, 1 		# incrementa cada trecho da memoria
			addi $t1, $t1, 1

			j loop		# va para loop

    nao_colocar_strx:		# caso venha nessa funcao, o caracter nao sera adicionado no vetor
        addi $a0, $a0, 1		# incrementa a entrada do usuario

        j loop		# va para loop

verificaPalindromo:
    la $t4, strx		# $t4 recebe o endereco de strx

    sb $zero, ($a0)
    addi $t1, $t1, -1		# decrementa do final de $t1, incrementa do comeco de $t4

    loop_iguais:		# se as duas strings sao iguais, comeca dos dois finais
        lb $t3, ($t4)
        lb $t2, ($t1)		# carrega os bytes para testar
        beq $t3, $t2, proximo		# continua a checar se os bytes forem iguais

        j nao_eh_palindromo		# nao eh necessario checar o resto da string se um dos bytes nao eh igual

        proximo: 
			jal testar_localizacao		# teste para ter certeza que nao estamos no ultimo byte

			addi $t4, $t4, 1		# incrementa $t4 mais proximo do meio
			addi $t1, $t1, -1		# decrementa $t1 mais proximo do meio (ao contrario)

			j loop_iguais		# continua a proximo interacao do loop

        j nao_eh_palindromo		# caso a string nao seja um palindromo, va para nao_eh_palindromo

    testar_localizacao:		# recebe os enderecos atuais de $t3(para frente) e $a0(para tras)
        beq $t4, $t1, eh_palindromo		# se ($t4 == $t1), va para eh_palindromo
        addi $t1, $t1, -1		# decrementa $t1
        beq $t4, $t1, eh_palindromo		# teste para saber se precisamos checar mais caracteres
        addi $t1, $t1, 1		# quando no meio, os enderecos irao ser iguais 

        jr $ra		# volta para a funcao "proximo"
		
    eh_palindromo:
        la $a0, str
        li $v0, 4
        syscall		# syscall para imprimir a string str

        la $a0, prompt1
        syscall		# syscall para imprimir a mensagem "eh um palindromo!"

        j encerrar		# va para a funcao "encerrar"

    nao_eh_palindromo:
        la $a0, str
        li $v0, 4
        syscall		# syscall para imprimir a string str

        la $a0, prompt2
        syscall		# syscall para imprimir a mensagem "nao eh um palindromo!"

        j encerrar		# va para a funcao "encerrar"

encerrar:
    li $v0, 10
    syscall		# syscall para encerrar o programa