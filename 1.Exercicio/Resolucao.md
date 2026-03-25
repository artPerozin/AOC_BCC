# 📋 Análise Ultra Detalhada — Código MIPS Assembly

---

## 1. Visão Geral do Programa

Este programa em MIPS Assembly percorre um vetor de inteiros, **soma os valores positivos** e **conta os valores negativos**. Ao final, verifica se a soma dos positivos é maior que 20, armazenando um flag (`$s4`) com o resultado (`1` = maior, `0` = menor ou igual).

---

## 2. Segmento de Dados (`.data`)

```asm
v: .word 5, -3, 12, 0, -7, 8, -1, 4
```

| Índice | Valor | Endereço relativo |
|--------|-------|-------------------|
| v[0]   | 5     | v + 0             |
| v[1]   | -3    | v + 4             |
| v[2]   | 12    | v + 8             |
| v[3]   | 0     | v + 12            |
| v[4]   | -7    | v + 16            |
| v[5]   | 8     | v + 20            |
| v[6]   | -1    | v + 24            |
| v[7]   | 4     | v + 28            |

- Cada `.word` ocupa **4 bytes** (32 bits) na memória.
- O vetor possui **8 elementos**.
- Endereços são consecutivos e crescentes.

---

## 3. Segmento de Código (`.text`)

### 3.1 Inicialização dos Registradores

```asm
la   $s0, v      # $s0 ← endereço base do vetor v
li   $s1, 8      # $s1 ← 8 (tamanho do vetor / número de iterações)

li   $t0, 0      # $t0 ← 0 (índice i do loop, começa em 0)
li   $s2, 0      # $s2 ← 0 (acumulador: soma dos positivos)
li   $s3, 0      # $s3 ← 0 (contador: quantidade de negativos)
```

| Registrador | Papel | Valor inicial |
|-------------|-------|---------------|
| `$s0` | Ponteiro base do vetor `v` | `&v` |
| `$s1` | Limite do loop (tamanho = 8) | `8` |
| `$t0` | Índice `i` (0 a 7) | `0` |
| `$s2` | Soma dos positivos | `0` |
| `$s3` | Contador de negativos | `0` |

---

### 3.2 Loop Principal (`loop`)

```asm
loop:
    beq  $t0, $s1, fim_loop    # se i == 8, sai do loop
    sll  $t2, $t0, 2           # $t2 ← i * 4 (offset em bytes)
    add  $t3, $s0, $t2         # $t3 ← &v[i] (endereço do elemento atual)
    lw   $t1, 0($t3)           # $t1 ← v[i] (carrega o valor)
```

#### Por que `sll $t2, $t0, 2`?

Como cada `.word` tem 4 bytes, o offset de memória do índice `i` é `i × 4`. O shift left lógico de 2 bits equivale a multiplicar por 4 de forma eficiente:

```
i = 0 → offset = 0  bytes → acessa v[0]
i = 1 → offset = 4  bytes → acessa v[1]
i = 2 → offset = 8  bytes → acessa v[2]
...
i = 7 → offset = 28 bytes → acessa v[7]
```

---

### 3.3 Verificação de Positivo (`blez`)

```asm
blez $t1, verifica_negativo    # se v[i] <= 0, NÃO soma (pula)
add  $s2, $s2, $t1             # senão: $s2 += v[i] (soma só positivos)
```

- `blez` = *Branch if Less than or Equal to Zero*
- Se `v[i] <= 0` → pula a soma e vai para `verifica_negativo`
- Se `v[i] > 0` → executa `add $s2, $s2, $t1`, somando ao acumulador

> ⚠️ **Atenção ao zero:** O zero (`v[3] = 0`) **não é somado** (pois `blez` inclui o zero), e **não é contado como negativo** (pois `bltz` não o captura).

---

### 3.4 Verificação de Negativo (`bltz`)

```asm
verifica_negativo:
    bltz $t1, incrementa_negativo   # se v[i] < 0, incrementa contador
    j    continua

incrementa_negativo:
    addi $s3, $s3, 1                # $s3++
```

- `bltz` = *Branch if Less Than Zero*
- Se `v[i] < 0` → `$s3++`
- Se `v[i] >= 0` (zero ou positivo) → pula direto para `continua`

---

### 3.5 Incremento do Índice e Retorno ao Loop

```asm
continua:
    addi $t0, $t0, 1    # i++
    j    loop           # volta ao início do loop
```

---

### 3.6 Pós-loop: Verificação da Soma

```asm
fim_loop:
    li   $t4, 20
    ble  $s2, $t4, menor_igual    # se $s2 <= 20, pula para menor_igual

maior:
    li   $s4, 1                   # flag = 1 (soma > 20)
    j    fim

menor_igual:
    li   $s4, 0                   # flag = 0 (soma <= 20)
```

- `ble` = *Branch if Less than or Equal*
- Compara a soma dos positivos (`$s2`) com 20
- Define `$s4 = 1` se soma > 20, ou `$s4 = 0` se soma ≤ 20

---

### 3.7 Encerramento

```asm
fim:
    li   $v0, 10    # syscall 10 = exit
    syscall
```

---

## 4. Rastreamento Completo da Execução (Passo a Passo)

| Iteração | `i` (`$t0`) | `v[i]` (`$t1`) | Ação positivo | Ação negativo | `$s2` (soma) | `$s3` (neg) |
|----------|-------------|----------------|---------------|---------------|--------------|-------------|
| 0        | 0           | 5              | +5 (soma)     | —             | 5            | 0           |
| 1        | 1           | -3             | — (skip)      | +1 (conta)    | 5            | 1           |
| 2        | 2           | 12             | +12 (soma)    | —             | 17           | 1           |
| 3        | 3           | 0              | — (skip, ≤0)  | — (não < 0)   | 17           | 1           |
| 4        | 4           | -7             | — (skip)      | +1 (conta)    | 17           | 2           |
| 5        | 5           | 8              | +8 (soma)     | —             | 25           | 2           |
| 6        | 6           | -1             | — (skip)      | +1 (conta)    | 25           | 3           |
| 7        | 7           | 4              | +4 (soma)     | —             | 29           | 3           |

---

## 5. Estado Final dos Registradores

| Registrador | Descrição | Valor Final |
|-------------|-----------|-------------|
| `$s0` | Endereço base de `v` | `&v` (fixo) |
| `$s1` | Tamanho do vetor | `8` |
| `$t0` | Índice após o loop | `8` |
| `$t1` | Último `v[i]` lido | `4` (v[7]) |
| `$t2` | Último offset calculado | `28` (7 × 4) |
| `$t3` | Último endereço acessado | `&v + 28` |
| `$s2` | **Soma dos positivos** | **29** (5+12+8+4) |
| `$s3` | **Contagem de negativos** | **3** (-3, -7, -1) |
| `$t4` | Limiar de comparação | `20` |
| `$s4` | **Flag de comparação** | **1** (29 > 20) |
| `$v0` | Código de syscall | `10` (exit) |

---

## 6. Fluxo de Controle (Diagrama)

```
main
 │
 ├── Inicializa $s0, $s1, $t0, $s2, $s3
 │
 └── [loop]
      ├── i == 8? ──YES──► [fim_loop]
      │                          │
      │                    $s2 <= 20? ──YES──► $s4 = 0 ──► [fim]
      │                          │
      │                    NO ──► $s4 = 1 ──► [fim]
      │
      ├── Calcula endereço: $t3 = $s0 + (i * 4)
      ├── Carrega: $t1 = v[i]
      │
      ├── v[i] <= 0?
      │    ├── YES → [verifica_negativo]
      │    └── NO  → $s2 += v[i] → [verifica_negativo]
      │
      ├── [verifica_negativo]
      │    ├── v[i] < 0? YES → $s3++ → [continua]
      │    └──           NO  → [continua]
      │
      └── [continua]: i++ → volta ao [loop]
```

---

## 7. Resumo dos Resultados Esperados

| Métrica | Valor |
|---------|-------|
| Soma dos elementos positivos | **29** |
| Quantidade de elementos negativos | **3** |
| Zero foi somado? | **Não** |
| Zero foi contado como negativo? | **Não** |
| Soma > 20? | **Sim** → `$s4 = 1` |

---

## 8. Possíveis Bugs / Pontos de Atenção

1. **O zero não é somado, mas também não é contado como negativo.** Isso é intencional pela lógica `blez`/`bltz`, mas vale documentar explicitamente.

2. **Não há impressão de resultados.** O programa termina com `syscall 10` sem exibir `$s2`, `$s3` ou `$s4` — em SPIM/MARS, os valores ficam nos registradores mas não aparecem no console sem syscalls adicionais (ex: `li $v0, 1` para imprimir inteiro).

3. **O label `verifica_negativo` é alcançado por dois caminhos diferentes:**
   - Via `blez` (quando v[i] ≤ 0)
   - Por fall-through após `add $s2, $s2, $t1` (quando v[i] > 0)
   
   Isso é correto e intencional — ambos os caminhos precisam verificar o negativo.

4. **O registrador `$s4` só é definido após o loop.** Se o loop nunca executar (vetor vazio), `$s4` ficaria indefinido — mas como `$s1 = 8`, isso nunca ocorre neste código.