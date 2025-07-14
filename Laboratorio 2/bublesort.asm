.data
array:      .word 8, 4, 2, 6, 1   # Arreglo a ordenar
size:       .word 5               # Tamaño del arreglo
newline:    .asciiz "\n"

.text
.globl main

main:
    la $t0, array         # $t0 = dirección base del arreglo
    lw $t6, size          # $t6 = tamaño del arreglo
    addi $t6, $t6, -1     # $t6 = n - 1 (límites de iteración exterior)

outer_loop:
    li $t1, 0             # i = 0
    li $t7, 0             # bandera de intercambio

inner_loop:
    # Verificamos si i >= n - 1
    bge $t1, $t6, check_flag

    # Cargar array[i] y array[i+1]
    mul $t2, $t1, 4       # desplazamiento = i * 4
    add $t3, $t0, $t2     # dirección de array[i]
    lw $t4, 0($t3)        # $t4 = array[i]
    lw $t5, 4($t3)        # $t5 = array[i+1]

    # Comparar y hacer swap si es necesario
    ble $t4, $t5, no_swap

    # swap(array[i], array[i+1])
    sw $t5, 0($t3)
    sw $t4, 4($t3)
    li $t7, 1             # bandera = 1 (hubo intercambio)

no_swap:
    addi $t1, $t1, 1
    j inner_loop

check_flag:
    beq $t7, $zero, end_sort
    addi $t6, $t6, -1     # reducir tamaño de comparación
    bgtz $t6, outer_loop

end_sort:
    # Imprimir arreglo ordenado
    la $t0, array
    lw $t6, size
    li $t1, 0

print_loop:
    bge $t1, $t6, exit
    mul $t2, $t1, 4
    add $t3, $t0, $t2
    lw $a0, 0($t3)
    li $v0, 1
    syscall

    # Imprimir salto de línea
    li $v0, 4
    la $a0, newline
    syscall

    addi $t1, $t1, 1
    j print_loop

exit:
    li $v0, 10
    syscall
