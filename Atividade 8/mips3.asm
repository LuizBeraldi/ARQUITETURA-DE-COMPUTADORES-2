.data
    vet:    .word 5, 10, 15, 20   # vetor inicial
    i:      .word 0                # índice
    elem:   .word 0                # elemento
    arq:    .asciiz "vet.txt"      # nome do arquivo
    erro_abertura:  .asciiz "Erro ao abrir o arquivo.\n"
.text
    .globl main
    main:
        # Abrir arquivo para escrita e leitura binária
        li $v0, 13              # código do sistema para abrir arquivo
        la $a0, arq             # nome do arquivo
        li $a1, 9               # modo de abertura (w+b)
        li $a2, 0               # permissões (não importa para modo w+b)
        syscall

        # Verificar se o arquivo foi aberto com sucesso
        bnez $v0, arquivo_aberto
        li $v0, 4               # código do sistema para imprimir string
        la $a0, erro_abertura   # mensagem de erro
        syscall

        j fim

arquivo_aberto:
        move $s0, $v0           # salvar o ponteiro do arquivo em $s0

        # Escrever o vetor no arquivo
        li $v0, 15              # código do sistema para escrever em arquivo
        move $a0, $s0           # ponteiro do arquivo
        la $a1, vet             # endereço do vetor
        li $a2, 16              # tamanho do vetor (4 * sizeof(int))
        syscall

        # Ler o índice do usuário
        li $v0, 5               # código do sistema para ler inteiro
        syscall
        
        move $t0, $v0           # salvar o índice em $t0

        # Verificar se o índice está dentro dos limites
        bltz $t0, fim            # se i < 0, terminar
        li $t1, 3               # limite superior do índice
        bgt $t0, $t1, fim       # se i > 3, terminar

        # Posicionar o cursor no elemento i
        li $v0, 19              # código do sistema para mover cursor de arquivo
        move $a0, $s0           # ponteiro do arquivo
        li $v1, 0               # offset (0)
        move $a2, $t0           # deslocamento em bytes (i * sizeof(int))
        li $a3, 0               # origem (SEEK_SET)
        syscall

        # Ler o elemento i do arquivo
        li $v0, 14              # código do sistema para ler de arquivo
        move $a0, $s0           # ponteiro do arquivo
        la $a1, elem            # endereço do elemento
        li $a2, 4               # tamanho do elemento (sizeof(int))
        syscall

        # Incrementar o elemento lido
        lw $t2, elem            # carregar o elemento em $t2
        addi $t2, $t2, 1        # incrementar o elemento
        sw $t2, elem            # armazenar o elemento de volta

        # Voltar 1 posição (reposicionar no elemento i)
        li $v0, 19              # código do sistema para mover cursor de arquivo
        move $a0, $s0           # ponteiro do arquivo
        li $v1, 0               # offset (0)
        li $a2, -4              # deslocamento em bytes (-sizeof(int))
        li $a3, 1               # origem (SEEK_CUR)
        syscall

        # Escrever o elemento atualizado no arquivo
        li $v0, 15              # código do sistema para escrever em arquivo
        move $a0, $s0           # ponteiro do arquivo
        la $a1, elem            # endereço do elemento
        li $a2, 4               # tamanho do elemento (sizeof(int))
        syscall

        # Voltar ao início do arquivo
        li $v0, 19              # código do sistema para mover cursor de arquivo
        move $a0, $s0           # ponteiro do arquivo
        li $v1, 0               # offset (0)
        li $a2, 0               # deslocamento em bytes (0)
        li $a3, 0               # origem (SEEK_SET)
        syscall

        # Ler todo o arquivo no vetor
        li $v0, 14              # código do sistema para ler de arquivo
        move $a0, $s0           # ponteiro do arquivo
        la $a1, vet             # endereço do vetor
        li $a2, 16              # tamanho do vetor (4 * sizeof(int))
        syscall

        # Imprimir o vetor alterado
        li $v0, 1               # código do sistema para imprimir inteiro
        la $a0, vet             # endereço do vetor
        li $a1, 4               # tamanho do vetor

print_loop:
        lw $a0, 0($a0)          # carregar elemento do vetor
        syscall

        li $v0, 11              # código do sistema para imprimir espaço
        li $a0, 32              # espaço (' ')
        syscall

        addiu $a1, $a1, -1      # decrementar contador
        bnez $a1, print_loop    # se não chegou ao final, continuar imprimindo

fim:
        # Fecha o arquivo
        li $v0, 16              # código do sistema para fechar arquivo
        move $a0, $s0           # ponteiro do arquivo
        syscall

        # Terminar o programa
        li $v0, 10              # código do sistema para terminar o programa
        syscall


