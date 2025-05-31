.data                # Sección de datos
mensaje: .asciiz "Hola, mundo!\n"  # Cadena a imprimir (con salto de línea)

.text                # Sección de código
main:
    # Imprimir el mensaje
    li $v0, 4         # Código de syscall para imprimir string (4)
    la $a0, mensaje    # Carga la dirección de la cadena en $a0
    syscall           # Llamada al sistema

    # Salir del programa
    li $v0, 10        # Código de syscall para exit (10)
    syscall           # Llamada al sistema