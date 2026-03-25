.data
vet: .word 5, 5, 5, 1, 2, 3   # vetor de exemplo

.text
.globl main

main:
    li $s3, 0          # i = 0
    li $s5, 5          # k = 5
    la $s6, vet        # base do vetor

loop:
    sll  $t0, $s3, 2        # t0 = i * 4
    add  $t1, $s6, $t0      # t1 = &vet[i]
    lw   $t2, 0($t1)        # t2 = vet[i]
    bne  $t2, $s5, end      # se vet[i] != k, sai
    addi $s3, $s3, 1        # i++
    addi $t1, $t1, 4        # próximo elemento
    addi $t2, $s5, 10       # k + 10
    sw   $t2, 0($t1)        # vet[i] = k + 10

    j loop

end:
    li $v0, 10              # syscall exit
    syscall
