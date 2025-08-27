# ================================================
# MIPS32: Intercambia v[1] con v[2] y muestra arreglo
# ================================================

.data
array:      .word 10, 20, 30, 40   # Arreglo de 4 enteros
newline:    .asciiz "\n"           # Salto de línea

.text
.globl main

main:
    # Llamar a swap(array, 1)
    la $a0, array     # $a0 = dirección del arreglo
    li $a1, 1         # $a1 = índice k = 1
    jal swap          # llamar a swap(array, 1)

    # Mostrar arreglo actualizado
    jal print_array

    # Terminar programa
    li $v0, 10
    syscall

# ================================================
# void swap(int v[], int k)
# Intercambia v[k] y v[k+1]
# Entradas:
#   $a0 = dirección del arreglo
#   $a1 = índice k
# ================================================
swap:
    sll $t0, $a1, 2       # t0 = k * 4
    add $t1, $a0, $t0     # t1 = &v[k]
    lw  $t2, 0($t1)       # t2 = v[k]

    addi $t3, $a1, 1
    sll $t4, $t3, 2       # t4 = (k+1) * 4
    add $t5, $a0, $t4     # t5 = &v[k+1]
    lw  $t6, 0($t5)       # t6 = v[k+1]

    sw  $t6, 0($t1)       # v[k] = v[k+1]
    sw  $t2, 0($t5)       # v[k+1] = temp

    jr $ra

# ================================================
# void print_array()
# Imprime los 4 elementos del arreglo en consola
# ================================================
print_array:
    li $t0, 0             # índice i = 0

print_loop:
    bge $t0, 4, done_print   # salir si i >= 4

    sll $t1, $t0, 2          # offset = i * 4
    la $t2, array	     # Dirección base del arreglo
    add $t3, $t2, $t1        # dirección de array[i]
    lw  $a0, 0($t3)

    li $v0, 1                # syscall 1 = print_int
    syscall

    li $v0, 4
    la $a0, newline
    syscall

    addi $t0, $t0, 1
    j print_loop

done_print:
    jr $ra
