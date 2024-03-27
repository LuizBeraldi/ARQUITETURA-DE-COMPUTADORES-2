.data
    msg1: .asciiz "Digite o valor de x em radianos: "
    msg2: .asciiz "Digite o numero de termos (n): "
    msg3: .asciiz "Aproximacao de cos("
    msg4: .asciiz ") com os primeiros "
    msg5: .asciiz " termos: "
    double1: .double 1.0
    doublenegative1: .double -1.0

.text
    .globl main
    main:
        la $a0, msg1 
        li $v0, 4          # syscall para imprimir "Digite o valor de x em radianos: "
        syscall

        addi $v0, $0, 7		
        syscall     # syscall para ler um double

        la $a0, msg2    
        li $v0, 4          # syscall para imprimir "Digite o número de termos (n): "
        syscall

        addi $v0, $0, 5	
        syscall     # syscall para ler um inteiro
        move $s0, $v0

        jal	calcular_cos				# jump to calcular_cos and save position to $ra
        
        addi $v0, $0, 4		# syscall para imprimir "Aproximação de cos("
        la $a0, msg3
        syscall		

        addi $v0, $0, 3		# syscall para imprimir um double
        mov.d $f12, $f0
        syscall	

        addi $v0, $0, 4		# syscall para imprimir ") com os primeiros "
        la $a0, msg4
        syscall	
        
        addi $v0, $0, 1		# syscall para imprimir um inteiro
        add $a0, $0, $s0
        syscall					

        addi $v0, $0, 4		# syscall para imprimir " termos: "
        la $a0, msg5
        syscall				
        
        addi $v0, $0, 3		# syscall para imprimir um double
        mov.d $f12, $f2
        syscall				

        addi $v0, $0, 10		# encerra o programa
        syscall			

    calcular_cos:
        l.d	$f2, double1  # resultado
        l.d	$f4, double1  # termo
        l.d $f14, doublenegative1 # sinal
        l.d $f12, doublenegative1 # -1
        
        # for(i = 1; i <= $s0; i++)
        li $t0, 1 # Inicializa a varíavel contadora i = 1
        for_calcula:
            bgt $t0, $s0, fim_for_calcula # Se i > $s0 então vai para fim_for
        
            sll $t1, $t0, 1			# $t1 = 2*i       
            mtc1.d $t1, $f6
            cvt.d.w $f6, $f6            # (float)$t1
            add.d $f8, $f6, $f12        # (2 * i - 1)
            mul.d $f10, $f0, $f0			# numerador   x * x 
            mul.d $f6, $f6, $f8         # denominador ((2 * i) * (2 * i - 1))
            div.d $f10, $f10, $f6         # x * x / ((2 * i) * (2 * i - 1))
            mul.d $f4, $f4, $f10         # termo *= x * x / ((2 * i) * (2 * i - 1))

            mul.d $f10, $f14, $f4         # sinal * termo
            add.d $f2, $f2, $f10          # resultado += sinal * termo

            mul.d $f14, $f14, $f12       # sinal *= -1
            
            addi $t0, $t0, 1 # i++
            j for_calcula				# jump para for_calcula
        fim_for_calcula:
            jr		$ra					# jump to $ra
        
