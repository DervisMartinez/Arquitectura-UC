.data
prompt:     .asciiz "Ingrese un número: "
resultMsg:  .asciiz "El término de Fibonacci es: "

.text
.globl main

main:
    # Mostrar mensaje
    li $v0, 4          
    la $a0, prompt     
    syscall

    # Leer número
    li $v0, 5          
    syscall
    move $a0, $v0      # Guardar n en $a0 (argumento)

    jal fibonacci      # Llamar a fibonacci(n)
    move $t0, $v0      # Guardar resultado

    # Imprimir mensaje
    li $v0, 4          
    la $a0, resultMsg  
    syscall

    # Imprimir resultado
    li $v0, 1
    move $a0, $t0
    syscall

    # Salir
    li $v0, 10
    syscall

# -------------------------------------------
# int fibonacci(int n) {
#     if (n == 0) return 0;
#     if (n == 1) return 1;
#     return fibonacci(n-1) + fibonacci(n-2);
# }
# -------------------------------------------
fibonacci:
    addi $sp, $sp, -12       # Reservar espacio para $ra y $a0, $v0
    sw $ra, 8($sp)
    sw $a0, 4($sp)

    # Caso base: if (n == 0) return 0;
    beqz $a0, fib_zero

    # if (n == 1) return 1;
    li $t1, 1
    beq $a0, $t1, fib_one

    # Llamar a fibonacci(n-1)
    addi $a0, $a0, -1
    jal fibonacci
    move $t2, $v0            # Guardar resultado fibonacci(n-1)

    # Llamar a fibonacci(n-2)
    lw $a0, 4($sp)           # Restaurar n
    addi $a0, $a0, -2
    jal fibonacci
    add $v0, $v0, $t2        # v0 = fib(n-1) + fib(n-2)

    j end_fib

fib_zero:
    li $v0, 0
    j end_fib

fib_one:
    li $v0, 1

end_fib:
    lw $ra, 8($sp)
    addi $sp, $sp, 12
    jr $ra
