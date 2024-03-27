.data
newline: .asciiz "\n"         # String para nova linha
m1:
    .asciiz "Salve o Corinthians\n" 
   m2: .asciiz "O campeao dos campeoes\n"
   m3: .asciiz "Eternamente\n"
   m4: .asciiz "Dentro dos nossos cora�oes\n"
   m5: .asciiz "Salve o Corinthians\n"
   m6: .asciiz "De tradi�oes e glorias mil\n"
   m7: .asciiz "Tu es o orgulho\n"
   m8: .asciiz "Dos desportistas do Brasil\n"
   m9: .asciiz "Teu passado e uma bandeira\n"
   m10: .asciiz "Teu presente, uma licao\n"
   m11: .asciiz "Figuras entre os primeiros\n"
   m12: .asciiz "Do nosso esporte bretao\n"
   m13: .asciiz "Corinthians grande\n"
   m14: .asciiz "Sempre altaneiro\n"
   m15: .asciiz "Es do Brasil\n"
   m16: .asciiz "O clube mais brasileiro\n"
   m17: .asciiz "Os teus fieis\n"
   m18: .asciiz "Sempre contigo\n"
   m19: .asciiz "Te amarao\n"
   m20: .asciiz "Ate morrerem de paixao\n"

.text
main:
    # Imprimir o hino do Corinthians
    li $v0, 4           # Carregar o código do sistema para imprimir string
    la $a0, m1    # Carregar o endereço do hino do Corinthians
    syscall             # Chamar o sistema para imprimir

    # Imprimir nova linha no final
    li $v0, 4
    la $a0, newline
    syscall
    
    # Imprimir o hino do Corinthians
    li $v0, 4           # Carregar o código do sistema para imprimir string
    la $a0, m2    # Carregar o endereço do hino do Corinthians
    syscall             # Chamar o sistema para imprimir

    # Imprimir nova linha no final
    li $v0, 4
    la $a0, newline
    syscall
    
    # Imprimir o hino do Corinthians
    li $v0, 4           # Carregar o código do sistema para imprimir string
    la $a0, m3    # Carregar o endereço do hino do Corinthians
    syscall             # Chamar o sistema para imprimir

    # Imprimir nova linha no final
    li $v0, 4
    la $a0, newline
    syscall
    
    # Imprimir o hino do Corinthians
    li $v0, 4           # Carregar o código do sistema para imprimir string
    la $a0, m4    # Carregar o endereço do hino do Corinthians
    syscall             # Chamar o sistema para imprimir

    # Imprimir nova linha no final
    li $v0, 4
    la $a0, newline
    syscall
    
    # Imprimir o hino do Corinthians
    li $v0, 4           # Carregar o código do sistema para imprimir string
    la $a0, m5    # Carregar o endereço do hino do Corinthians
    syscall             # Chamar o sistema para imprimir

    # Imprimir nova linha no final
    li $v0, 4
    la $a0, newline
    syscall
    
    # Imprimir o hino do Corinthians
    li $v0, 4           # Carregar o código do sistema para imprimir string
    la $a0, m6    # Carregar o endereço do hino do Corinthians
    syscall             # Chamar o sistema para imprimir

    # Imprimir nova linha no final
    li $v0, 4
    la $a0, newline
    syscall
    
    # Imprimir o hino do Corinthians
    li $v0, 4           # Carregar o código do sistema para imprimir string
    la $a0, m7    # Carregar o endereço do hino do Corinthians
    syscall             # Chamar o sistema para imprimir

    # Imprimir nova linha no final
    li $v0, 4
    la $a0, newline
    syscall
    
    # Imprimir o hino do Corinthians
    li $v0, 4           # Carregar o código do sistema para imprimir string
    la $a0, m8    # Carregar o endereço do hino do Corinthians
    syscall             # Chamar o sistema para imprimir

    # Imprimir nova linha no final
    li $v0, 4
    la $a0, newline
    syscall
    
    # Imprimir o hino do Corinthians
    li $v0, 4           # Carregar o código do sistema para imprimir string
    la $a0, m9    # Carregar o endereço do hino do Corinthians
    syscall             # Chamar o sistema para imprimir

    # Imprimir nova linha no final
    li $v0, 4
    la $a0, newline
    syscall
    
    # Imprimir o hino do Corinthians
    li $v0, 4           # Carregar o código do sistema para imprimir string
    la $a0, m10    # Carregar o endereço do hino do Corinthians
    syscall             # Chamar o sistema para imprimir

    # Imprimir nova linha no final
    li $v0, 4
    la $a0, newline
    syscall
    
    # Imprimir o hino do Corinthians
    li $v0, 4           # Carregar o código do sistema para imprimir string
    la $a0, m11    # Carregar o endereço do hino do Corinthians
    syscall             # Chamar o sistema para imprimir

    # Imprimir nova linha no final
    li $v0, 4
    la $a0, newline
    syscall
    
    # Imprimir o hino do Corinthians
    li $v0, 4           # Carregar o código do sistema para imprimir string
    la $a0, m12    # Carregar o endereço do hino do Corinthians
    syscall             # Chamar o sistema para imprimir

    # Imprimir nova linha no final
    li $v0, 4
    la $a0, newline
    syscall
    
    # Imprimir o hino do Corinthians
    li $v0, 4           # Carregar o código do sistema para imprimir string
    la $a0, m13    # Carregar o endereço do hino do Corinthians
    syscall             # Chamar o sistema para imprimir

    # Imprimir nova linha no final
    li $v0, 4
    la $a0, newline
    syscall
    
    # Imprimir o hino do Corinthians
    li $v0, 4           # Carregar o código do sistema para imprimir string
    la $a0, m14    # Carregar o endereço do hino do Corinthians
    syscall             # Chamar o sistema para imprimir

    # Imprimir nova linha no final
    li $v0, 4
    la $a0, newline
    syscall
    
    # Imprimir o hino do Corinthians
    li $v0, 4           # Carregar o código do sistema para imprimir string
    la $a0, m15    # Carregar o endereço do hino do Corinthians
    syscall             # Chamar o sistema para imprimir

    # Imprimir nova linha no final
    li $v0, 4
    la $a0, newline
    syscall
    
    # Imprimir o hino do Corinthians
    li $v0, 4           # Carregar o código do sistema para imprimir string
    la $a0, m16    # Carregar o endereço do hino do Corinthians
    syscall             # Chamar o sistema para imprimir

    # Imprimir nova linha no final
    li $v0, 4
    la $a0, newline
    syscall
    
    # Imprimir o hino do Corinthians
    li $v0, 4           # Carregar o código do sistema para imprimir string
    la $a0, m17    # Carregar o endereço do hino do Corinthians
    syscall             # Chamar o sistema para imprimir

    # Imprimir nova linha no final
    li $v0, 4
    la $a0, newline
    syscall
    
    # Imprimir o hino do Corinthians
    li $v0, 4           # Carregar o código do sistema para imprimir string
    la $a0, m18    # Carregar o endereço do hino do Corinthians
    syscall             # Chamar o sistema para imprimir

    # Imprimir nova linha no final
    li $v0, 4
    la $a0, newline
    syscall
    
    # Imprimir o hino do Corinthians
    li $v0, 4           # Carregar o código do sistema para imprimir string
    la $a0, m19    # Carregar o endereço do hino do Corinthians
    syscall             # Chamar o sistema para imprimir

    # Imprimir nova linha no final
    li $v0, 4
    la $a0, newline
    syscall
    
    # Imprimir o hino do Corinthians
    li $v0, 4           # Carregar o código do sistema para imprimir string
    la $a0, m20    # Carregar o endereço do hino do Corinthians
    syscall             # Chamar o sistema para imprimir

    # Imprimir nova linha no final
    li $v0, 4
    la $a0, newline
    syscall


    # Encerrar o programa
    li $v0, 10          # Carregar o código do sistema para encerrar o programa
    syscall
