.data
msg:    .asciiz "Digite um numero: "
msg2:   .asciiz "O fatorial é: "

.text
.globl main

main:
    # imprime mensagem
    la $a0, msg
    li $v0, 4
    syscall

    # lê número
    li $v0, 5
    syscall
    move $s1, $v0   # n

    li $s0, 1       # resultado = 1

while:
    beqz $s1, print_result   # se n == 0, sai do loop
    mul $s0, $s0, $s1       # resultado *= n
    addi $s1, $s1, -1       # n--
    j while

print_result:
    # imprime mensagem
    la $a0, msg2
    li $v0, 4
    syscall

    # imprime resultado
    move $a0, $s0
    li $v0, 1
    syscall

end:
    li $v0, 10
    syscall