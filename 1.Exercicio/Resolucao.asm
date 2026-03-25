.data
v: .word 5, -3, 12, 0, -7, 8, -1, 4   # vetor com 8 elementos

.text
.globl main

main:
    la   $s0, v
    li   $s1, 8

    li   $t0, 0
    li   $s2, 0
    li   $s3, 0

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
    j    fim

menor_igual:
    li   $s4, 0

fim:
    li   $v0, 10
    syscall