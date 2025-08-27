#Factorial 
.data
    prompt:     .asciiz "Ingrese un número para calcular su factorial: "
    resultado:  .asciiz "El factorial es: "
    salto:      .asciiz "\n"

.text
    .globl main         # Declaramos la etiqueta 'main' como global para que el programa inicie allí

main:
    # Mostrar mensaje de entrada
    li $v0, 4            # Código de syscall 4: imprimir cadena
    la $a0, prompt       # Cargar dirección del mensaje en $a0
    syscall              # Imprimir mensaje

    # Leer número del usuario
    li $v0, 5            # Código de syscall 5: leer entero  
    syscall              # Ejecutar syscall
    move $t0, $v0        # Guardar número leído en $t0 (n)

    # Inicializar valores para el cálculo del factorial
    li $t1, 1            # $t1 = resultado (inicialmente 1)
    li $t2, 1            # $t2 = contador i = 1

factorial_loop:
    bgt $t2, $t0, end_factorial  # Si i > n, terminar bucle

    mul $t1, $t1, $t2     # resultado *= i ? $t1 = $t1 * $t2
    addi $t2, $t2, 1      # i++

    j factorial_loop      # Repetir bucle

end_factorial:
    # Mostrar mensaje antes del resultado
    li $v0, 4
    la $a0, resultado
    syscall

    # Imprimir resultado del factorial
    move $a0, $t1         # Pasamos el resultado a $a0
    li $v0, 1             # Código de syscall 1: imprimir entero
    syscall

    # Imprimir salto de línea
    li $v0, 4
    la $a0, salto
    syscall

    # Terminar el programa
    li $v0, 10            # Código de syscall 10: salir
    syscall
