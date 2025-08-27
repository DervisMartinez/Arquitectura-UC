#Torre de Hanoi

.data
    prompt:     .asciiz "Ingrese el número de discos: "
    move_msg:   .asciiz "Mover disco de "
    to_msg:     .asciiz " a "
    newline:    .asciiz "\n"

.text
    .globl main

main:
    li $v0, 4              # syscall imprimir texto
    la $a0, prompt
    syscall

    li $v0, 5              # syscall leer entero
    syscall
    move $t0, $v0          # guardar en $t0

    move $a0, $t0          # n
    li $a1, 65             # origen = 'A' (ASCII)
    li $a2, 67             # destino = 'C'
    li $a3, 66             # auxiliar = 'B'

    jal hanoi              # llamada recursiva

    li $v0, 10             # salir
    syscall

hanoi:
    # Guardar contexto actual en la pila
    addi $sp, $sp, -20
    sw $ra, 0($sp)
    sw $a0, 4($sp)
    sw $a1, 8($sp)
    sw $a2, 12($sp)
    sw $a3, 16($sp)

    li $t1, 1
    beq $a0, $t1, base_case

    # Paso 1: hanoi(n-1, origen, auxiliar, destino)
    addi $a0, $a0, -1
    move $t2, $a1      # guardar origen
    move $t3, $a2      # guardar destino
    move $t4, $a3      # guardar auxiliar

    move $a1, $t2      # origen
    move $a2, $t4      # auxiliar
    move $a3, $t3      # destino
    jal hanoi

    # Paso 2: imprimir movimiento
    move $a0, $t2      # origen
    move $a1, $t3      # destino
    jal print_move

    # Paso 3: hanoi(n-1, auxiliar, destino, origen)
    lw $a0, 4($sp)     # restaurar n original
    addi $a0, $a0, -1
    move $a1, $t4      # auxiliar
    move $a2, $t3      # destino
    move $a3, $t2      # origen
    jal hanoi

    # Restaurar contexto
    lw $ra, 0($sp)
    lw $a0, 4($sp)
    lw $a1, 8($sp)
    lw $a2, 12($sp)
    lw $a3, 16($sp)
    addi $sp, $sp, 20
    jr $ra

# base_case: n == 1, imprime el movimiento

base_case:
    jal print_move
    lw $ra, 0($sp)
    lw $a0, 4($sp)
    lw $a1, 8($sp)
    lw $a2, 12($sp)
    lw $a3, 16($sp)
    addi $sp, $sp, 20
    jr $ra


print_move:
    # Mostrar "Mover disco de "
    li $v0, 4
    la $a0, move_msg
    syscall

    # Mostrar origen
    li $v0, 11
    move $t0, $a0        # Guardamos origen en $t0
    move $a0, $t0        # Poner el carácter en $a0
    syscall

    # Mostrar " a "
    li $v0, 4
    la $a0, to_msg
    syscall

    # Mostrar destino
    li $v0, 11
    move $t0, $a1        # Guardamos destino en $t0
    move $a0, $t0
    syscall

    # Nueva línea
    li $v0, 4
    la $a0, newline
    syscall

    jr $ra
