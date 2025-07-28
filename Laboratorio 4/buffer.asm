.data
buffer:     .space 100     # Buffer circular de 100 caracteres
head:       .word 0
tail:       .word 0
msg_start:  .asciiz "Inicio de lectura por teclado durante 20 segundos...\n"
msg_end:    .asciiz "\nTiempo terminado. Contenido del buffer:\n"
newline:    .asciiz "\n"

.text
.globl main

main:
    # Habilita interrupciones
    li $v0, 32        # Servicio para habilitar interrupciones
    syscall

    li $v0, 34        # Habilita interrupciones del temporizador
    syscall

    li $v0, 35        # Habilita interrupciones del teclado
    syscall

    li $v0, 4
    la $a0, msg_start
    syscall

    # Iniciar temporizador de 20 segundos (20000 ms)
    li $a0, 20000
    li $v0, 33
    syscall

loop:
    j loop   # Espera indefinida, interrupciones hacen todo el trabajo

# ---------------------------
# Rutina de Interrupción de Teclado (vector 0x80000180)
.ktext 0x80000180
    mfc0 $k0, $13       # Leer Cause
    mfc0 $k1, $14       # Leer EPC

    li $t0, 0x00000800  # Bit 11 = interrupción teclado
    and $t1, $k0, $t0
    beqz $t1, check_timer

    # Leer caracter
    li $v0, 12
    syscall
    move $t2, $v0       # Guardar en $t2

    # Guardar en buffer circular
    la $t3, tail
    lw $t4, 0($t3)
    la $t5, buffer
    add $t5, $t5, $t4
    sb $t2, 0($t5)

    # Incrementa tail y aplica % 100
    addi $t4, $t4, 1
    li $t6, 100
    remu $t4, $t4, $t6
    sw $t4, 0($t3)

    # Limpiar interrupción y regresar
    mtc0 $k1, $14       # Restaurar EPC
    eret

check_timer:
    li $t0, 0x00008000  # Bit 15 = interrupción temporizador
    and $t1, $k0, $t0
    beqz $t1, exit_irq

    # Imprimir contenido del buffer
    li $v0, 4
    la $a0, msg_end
    syscall

    la $t3, head
    lw $t4, 0($t3)
    la $t6, tail
    lw $t5, 0($t6)

print_loop:
    beq $t4, $t5, clear_buffer

    la $t7, buffer
    add $t7, $t7, $t4
    lb $a0, 0($t7)

    li $v0, 11
    syscall

    addi $t4, $t4, 1
    li $t8, 100
    remu $t4, $t4, $t8
    j print_loop

clear_buffer:
    sw $t5, 0($t3)   # head = tail

    li $v0, 4
    la $a0, newline
    syscall

    # Reiniciar temporizador
    li $a0, 20000
    li $v0, 33
    syscall

exit_irq:
    mtc0 $k1, $14
    eret
