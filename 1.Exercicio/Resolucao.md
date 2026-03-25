.data
v: .word 5, -3, 12, 0, -7, 8, -1, 4   # vetor de inteiros

.text
.globl main

main:

    # -------- Inicialização --------

    la   $s0, v        # carrega o endereço base do vetor em $s0
    li   $s1, 8        # define o tamanho do vetor (n = 8)

    li   $t0, 0        # i = 0 (índice do loop)
    li   $s2, 0        # soma dos positivos = 0
    li   $s3, 0        # contador de negativos = 0

# -------- Início do Loop --------
loop:

    beq  $t0, $s1, fim_loop  
    # se i == n, sai do loop

    sll  $t2, $t0, 2  
    # t2 = i * 4 (cada inteiro ocupa 4 bytes)

    add  $t3, $s0, $t2  
    # t3 = endereço base + offset → endereço de v[i]

    lw   $t1, 0($t3)  
    # carrega o valor de v[i] em $t1

# -------- Parte 1: Soma dos positivos --------

    blez $t1, verifica_negativo  
    # se v[i] <= 0, NÃO soma

    add  $s2, $s2, $t1  
    # soma += v[i]

# -------- Parte 2: Contagem de negativos --------

verifica_negativo:

    bltz $t1, incrementa_negativo  
    # se v[i] < 0, vai incrementar contador

    j    continua  
    # caso contrário, continua o loop

incrementa_negativo:

    addi $s3, $s3, 1  
    # contador de negativos++

# -------- Continuação do Loop --------

continua:

    addi $t0, $t0, 1  
    # i++

    j    loop  
    # volta para o início do loop

# -------- Fim do Loop --------

fim_loop:

# -------- Parte 3: Condição final --------

    li   $t4, 20  
    # carrega o valor 20 para comparação

    ble  $s2, $t4, menor_igual  
    # se soma <= 20, vai para menor_igual

# caso soma > 20

maior:

    li   $s4, 1  
    # define resultado como 1

    j    fim  
    # pula para o final

# caso soma <= 20

menor_igual:

    li   $s4, 0  
    # define resultado como 0

# -------- Encerramento --------

fim:

    li   $v0, 10  
    # código de syscall para encerrar programa

    syscall  
    # finaliza execução