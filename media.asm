.data
msg2: .asciiz "Soma: "
msg3: .asciiz "\nMedia: "

.text
.globl main
main:
    li $s2, 0        # soma = 0
    li $s0, 0        # contador = 0

loop:
    li $v0, 5        # ler inteiro
    syscall
    move $s1, $v0   # valor lido

    beq $s1, -1, end   # se for -1, termina

    add $s2, $s2, $s1  # soma += valor
    addi $s0, $s0, 1   # contador++

    j loop

end:
    la $a0, msg2
    li $v0, 4
    syscall

    move $a0, $s2
    li $v0, 1
    syscall

    # calcular média (soma / quantidade)
    div $s2, $s0
    mflo $t0   # resultado da divisão

    # imprimir média
    la $a0, msg3
    li $v0, 4
    syscall

    move $a0, $t0
    li $v0, 1
    syscall

    # encerrar programa
    li $v0, 10
    syscall