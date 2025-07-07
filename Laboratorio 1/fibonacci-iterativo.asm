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
    move $t0, $v0      # Guardar n en $t0

    # Casos base
    li $t1, 0          # F(0)
    li $t2, 1          # F(1)
    beqz $t0, print_result_zero   # Si n == 0, imprimir 0
    li $t3, 1          # i = 1

loop:
    bge $t3, $t0, print_result    # Si i >= n, salir
    add $t4, $t1, $t2             # t4 = F(i-1) + F(i-2)
    move $t1, $t2                # F(i-1) = F(i)
    move $t2, $t4                # F(i) = F(i+1)
    addi $t3, $t3, 1             # i++
    j loop

print_result:
    li $v0, 4
    la $a0, resultMsg
    syscall

    li $v0, 1
    move $a0, $t2
    syscall

    li $v0, 10
    syscall

print_result_zero:
    li $v0, 4
    la $a0, resultMsg
    syscall

    li $v0, 1
    li $a0, 0
    syscall

    li $v0, 10
    syscall
