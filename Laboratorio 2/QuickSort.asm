#Algoritmo de ordenamiento QuickSor

# =========================================================
# MIPS32 Implementation of QuickSort (on fixed-size array)
# =========================================================

.data
array:      .word 30, 10, 40, 20, 50
size:       .word 5
newline:    .asciiz "\n"
space:      .asciiz " "

.text
.globl main

main:
    # Cargar el tamaño del arreglo
    la $t0, size
    lw $t1, 0($t0)     # $t1 = 5

    # Llamar quickSort(array, 0, size-1)
    la $a0, array      # $a0 = dirección base del arreglo
    li $a1, 0          # low = 0
    addi $a2, $t1, -1  # high = size - 1
    jal quickSort

    # Imprimir el arreglo ordenado
    jal print_array

    # Salir del programa
    li $v0, 10
    syscall

quickSort:
    add $t0, $a1, $zero     # t0 = low
    add $t1, $a2, $zero     # t1 = high
    bge $t0, $t1, quick_return  # si low >= high ? retornar

    # Guardar registros
    addi $sp, $sp, -12
    sw $ra, 0($sp)
    sw $a1, 4($sp)
    sw $a2, 8($sp)

    # Llamar partition()
    jal partition
    move $t2, $v0           # $t2 = índice del pivote

    # quickSort(array, low, pi - 1)
    lw $a1, 4($sp)
    addi $a2, $v0, -1
    jal quickSort

    # quickSort(array, pi + 1, high)
    lw $a1, 8($sp)
    addi $a1, $t2, 1
    lw $a2, 8($sp)
    jal quickSort

    # Restaurar registros
    lw $ra, 0($sp)
    addi $sp, $sp, 12
    jr $ra

quick_return:
    jr $ra

partition:
    # Obtener valor del pivote: array[high]
    sll $t1, $a2, 2
    add $t2, $a0, $t1
    lw $t0, 0($t2)        # t0 = pivot

    addi $t3, $a1, -1     # i = low - 1
    add $t5, $a1, $zero   # j = low

partition_loop:
    bge $t5, $a2, end_partition

    sll $t6, $t5, 2
    add $t7, $a0, $t6
    lw  $t8, 0($t7)       # array[j]

    ble $t8, $t0, swap_it
    j skip_swap

swap_it:
    addi $t3, $t3, 1
    sll $t9, $t3, 2
    add $s0, $a0, $t9
    lw  $s1, 0($s0)
    sw  $t8, 0($s0)
    sw  $s1, 0($t7)

skip_swap:
    addi $t5, $t5, 1
    j partition_loop

end_partition:
    addi $t3, $t3, 1
    sll  $t6, $t3, 2
    add  $t7, $a0, $t6
    sll  $t1, $a2, 2
    add  $t2, $a0, $t1
    lw   $t8, 0($t7)
    lw   $t9, 0($t2)
    sw   $t9, 0($t7)
    sw   $t8, 0($t2)

    move $v0, $t3       # retornar índice del pivote
    jr $ra

print_array:
    li $t0, 0        # índice = 0
    li $t1, 5        # tamaño del arreglo

print_loop:
    bge $t0, $t1, print_done
    sll $t2, $t0, 2
    la  $t3, array
    add $t4, $t3, $t2
    lw  $a0, 0($t4)

    li  $v0, 1       # imprimir entero
    syscall

    li  $v0, 4
    la  $a0, space   # espacio entre números
    syscall

    addi $t0, $t0, 1
    j print_loop


print_done:
    li  $v0, 4		#le indicamos al sistema que va a mostrar un entero 
    la  $a0, newline	#carga la etiqueta newline a la Direccion $a0 
    syscall		#Ejecuta la Accion
    jr $ra
