.data
prompt:     .asciiz "Ingrese un número: "
resultMsg:  .asciiz "El factorial es: "

.text
.globl main

main:
    # Mostrar mensaje de entrada
    li $v0, 4          
    la $a0, prompt     
    syscall

    # Leer número del usuario
    li $v0, 5          
    syscall            
    move $t0, $v0      # Guardar número en $t0

    # Inicializar resultado = 1
    li $t1, 1          # $t1 = resultado

    # Loop: desde $t0 hasta 1
loop:
    blez $t0, done     # Si $t0 <= 0, salir del bucle
    mul $t1, $t1, $t0  # resultado *= $t0
    subi $t0, $t0, 1   # $t0--
    j loop

done:
    # Mostrar mensaje del resultado
    li $v0, 4          
    la $a0, resultMsg  
    syscall

    # Imprimir resultado
    li $v0, 1          
    move $a0, $t1      
    syscall

    # Salir del programa
    li $v0, 10         
    syscall
