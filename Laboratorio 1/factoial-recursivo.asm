.data
prompt:     .asciiz "Ingrese un número: "
resultMsg:  .asciiz "El factorial es: "

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
    move $a0, $v0      # Pasar número como argumento en $a0

    jal factorial      # Llamar a función factorial
    move $t0, $v0      # Guardar resultado en $t0

    # Mostrar resultado
    li $v0, 4          
    la $a0, resultMsg  
    syscall

    li $v0, 1          
    move $a0, $t0      
    syscall

    # Salir
    li $v0, 10         
    syscall

# ----------------------------------------
# int factorial(int n) {
#     if (n <= 1) return 1;
#     return n * factorial(n - 1);
# }
# ----------------------------------------
factorial:
    addi $sp, $sp, -8      # Reservar espacio en la pila
    sw $ra, 4($sp)         # Guardar dirección de retorno
    sw $a0, 0($sp)         # Guardar argumento n

    ble $a0, 1, base_case  # Si n <= 1, retornar 1

    addi $a0, $a0, -1      # n = n - 1
    jal factorial          # Llamada recursiva
    lw $a0, 0($sp)         # Restaurar valor original de n
    mul $v0, $a0, $v0      # v0 = n * factorial(n - 1)
    j end_factorial

base_case:
    li $v0, 1              # Retornar 1

end_factorial:
    lw $ra, 4($sp)         # Restaurar RA
    addi $sp, $sp, 8       # Liberar pila
    jr $ra                 # Retornar
