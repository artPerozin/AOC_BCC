.data
v: .word 5, -3, 1, 0, -7, 8, -1, 4   # vetor com 8 elementos

msg_soma:   .asciiz "Soma dos positivos: "
msg_neg:    .asciiz "Quantidade de negativos: "
msg_maior:  .asciiz "Soma > 20? (1=sim, 0=nao): "
newline:    .asciiz "\n"

.text
.globl main

main:
    la   $s0, v
    li   $s1, 8

    li   $t0, 0
    li   $s2, 0        # soma dos positivos
    li   $s3, 0        # contagem de negativos

loop:
    beq  $t0, $s1, fim_loop
    sll  $t2, $t0, 2
    add  $t3, $s0, $t2
    lw   $t1, 0($t3)

    blez $t1, verifica_negativo
    add  $s2, $s2, $t1

verifica_negativo:
    bltz $t1, incrementa_negativo
    j    continua

incrementa_negativo:
    addi $s3, $s3, 1

continua:
    addi $t0, $t0, 1
    j    loop

fim_loop:
    li   $t4, 20
    ble  $s2, $t4, menor_igual

maior:
    li   $s4, 1
    j    exibe

menor_igual:
    li   $s4, 0

exibe:
    # Exibe "Soma dos positivos: "
    li   $v0, 4
    la   $a0, msg_soma
    syscall

    # Exibe valor de $s2
    li   $v0, 1
    move $a0, $s2
    syscall

    # Quebra de linha
    li   $v0, 4
    la   $a0, newline
    syscall

    # Exibe "Quantidade de negativos: "
    li   $v0, 4
    la   $a0, msg_neg
    syscall

    # Exibe valor de $s3
    li   $v0, 1
    move $a0, $s3
    syscall

    # Quebra de linha
    li   $v0, 4
    la   $a0, newline
    syscall

    # Exibe "Soma > 20? (1=sim, 0=nao): "
    li   $v0, 4
    la   $a0, msg_maior
    syscall

    # Exibe valor de $s4
    li   $v0, 1
    move $a0, $s4
    syscall

    # Quebra de linha final
    li   $v0, 4
    la   $a0, newline
    syscall

    # Encerra o programa
    li   $v0, 10
    syscall