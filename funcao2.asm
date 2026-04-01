.data
msg1: .asciiz "Digite um valor: \n"
msg2: .asciiz "O valor maior: \n"

.text
.globl main

main:
    # leitura do primeiro valor
    la $a0, msg1
    li $v0, 4
    syscall

    li $v0, 5
    syscall
    move $a0, $v0   # primeiro número em $a0

    # leitura do segundo valor
    la $a0, msg1
    li $v0, 4
    syscall

    li $v0, 5
    syscall
    move $a1, $v0   # segundo número em $a1

    # chamada da função
    jal maior

    # imprime mensagem
    la $a0, msg2
    li $v0, 4
    syscall

    # imprime resultado (em $v0)
    move $a0, $v0
    li $v0, 1
    syscall

end:
    li $v0, 10
    syscall

# função maior(a0, a1)
maior:
    addi $sp, $sp, -4
    sw $ra, 0($sp)

    slt $t0, $a0, $a1   # t0 = 1 se a0 < a1
    beq $t0, $zero, retorna_a0

    move $v0, $a1       # retorna a1
    j fim

retorna_a0:
    move $v0, $a0       # retorna a0

fim:
    lw $ra, 0($sp)
    addi $sp, $sp, 4
    jr $ra