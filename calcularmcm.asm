.data
	#etiquetas 
    prompt1:    .asciiz "Ingresa el primer número: "
    prompt2:    .asciiz "Ingresa el segundo número: "
    resultado:  .asciiz "El MCM es: "
    newline:    .asciiz "\n"

.text
.globl main

main:
    # Mostrar mensaje para primer número
    li $v0, 4 		# cargamos el numero 4 para que va indicar al sistema que va mostrar una cadena de caracteres
    la $a0, prompt1  	#carga la direccion que se va a imprimir (promptl)
    syscall  		#ejecuta la acccion

    # Leer primer número -> $t0
    li $v0, 5		#cargamos la lectura del entero en $v0
    syscall		#ejecuta la accion
    move $t0, $v0   	# Guardamos a en $t0

    # Mostrar mensaje para segundo número
    li $v0, 4		#cargamos el numero 4 para que va indicar al sistema que va mostrar una cadena de caracteres
    la $a0, prompt2	#carga la direccion que se va a imprimir (prompt2)
    syscall		#ejecuta la accion

    # Leer segundo número -> $t1
    li $v0, 5		#cargamnos la lectura del entero en $v0
    syscall		#ejecuta la accion
    move $t1, $v0       # movemos b a $t1 

    # Guardar copias originales para después calcular a * b
    move $t2, $t0  	 # copia de a
    move $t3, $t1  	 # copia de b

euclides_loop:
    beq $t1, $zero, end_euclides   # salta a end_euclides si b == 0, osea salir del bucle

    move $t4, $t1       # temp = b
    div $t0, $t1        # a / b
    mfhi $t1            # b = a % b (resto) osea guardamos el resto 
    move $t0, $t4       # a = temp

    j euclides_loop

end_euclides:
    # Ahora $t0 tiene el MCD
    move $t4, $t0       # Guardamos el MCD en $t4

# Calcular MCM = (a * b) / MCD
    mul $t5, $t2, $t3   # t5 = a * b
    div $t5, $t4        # (a*b)/mcd
    mflo $t6            # t6 = resultado MCM
    
# Mostrar el resultado
    li $v0, 4
    la $a0, resultado
    syscall

    li $v0, 1
    move $a0, $t6       # resultado del MCM
    syscall

    # Nueva línea (opcional)
    li $v0, 4
    la $a0, newline
    syscall

    # Finalizar programa
    li $v0, 10
    syscall
