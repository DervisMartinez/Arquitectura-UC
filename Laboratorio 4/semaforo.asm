.data
display: .space 8  # Reservamos 8 bytes para la pantalla (2 píxeles de 32 bits cada uno)

ROJO:     .word 0xFF0000    
AMARILLO: .word 0xFFFF00    
VERDE:    .word 0x00FF00    

TIEMPO_ROJO:     .word 5      # 50 segundos para el color rojo
TIEMPO_AMARILLO: .word 5        # 20 segundos para el color amarillo
TIEMPO_VERDE:    .word 5        # 30 segundos para el color verde

.text
.globl main

main:
    j SEMAFORO_ROJO  # Comienza el ciclo con la luz roja

SEMAFORO_ROJO:
    li $t0, 0xFF0000       # Color rojo
    la $t3, display        # Dirección base de la pantalla
    lw $t1, TIEMPO_ROJO    # Tiempo de espera para el color rojo
    jal PINTAR_PANTALLA    # Pintar pantalla de rojo
    jal ESPERAR_TIEMPO     # Esperar el tiempo correspondiente para rojo
    j SEMAFORO_AMARILLO    # Cambiar al estado amarillo

SEMAFORO_AMARILLO:
    li $t0, 0xFFFF00       # Color amarillo
    la $t3, display        # Dirección base de la pantalla
    lw $t1, TIEMPO_AMARILLO # Tiempo de espera para el color amarillo
    jal PINTAR_PANTALLA    # Pintar pantalla de amarillo
    jal ESPERAR_TIEMPO     # Esperar el tiempo correspondiente para amarillo
    j SEMAFORO_VERDE       # Cambiar al estado verde

SEMAFORO_VERDE:
    li $t0, 0x00FF00       # Color verde
    la $t3, display        # Dirección base de la pantalla
    lw $t1, TIEMPO_VERDE   # Tiempo de espera para el color verde
    jal PINTAR_PANTALLA    # Pintar pantalla de verde
    jal ESPERAR_TIEMPO     # Esperar el tiempo correspondiente para verde
    j SEMAFORO_ROJO        # Regresar al estado rojo

PINTAR_PANTALLA:
    li $t2, 4              # Número de píxeles a pintar (2 píxeles de 32 bits)
PINTAR_LOOP:
    beq $t2, $zero, EXIT_PINTAR_PANTALLA  # Si ya pintamos todos, salir
    sw $t0, 0($t3)         # Guardar el color en la posición actual
    addi $t3, $t3, 4       # Mover al siguiente píxel (4 bytes por píxel)
    subi $t2, $t2, 1       # Reducir el contador
    j PINTAR_LOOP          # Repetir el bucle

EXIT_PINTAR_PANTALLA:
    jr $ra                 # Regresar a la rutina principal

ESPERAR_TIEMPO:
    # $t1 contiene el número de segundos a esperar
    li $t2, 0              # Inicializar el contador de tiempo (en milisegundos)
    li $t3, 1000           # 1000 milisegundos por segundo

ESPERAR_LOOP:
    # Incrementar el contador de tiempo
    addi $t2, $t2, 1       # Incrementar el contador
    bge $t2, $t1, FIN_ESPERA  # Si hemos esperado los segundos necesarios, salir
    li $v0, 32             # Syscall 32 para esperar un segundo
    li $a0, 1000           # 1000 milisegundos (1 segundo)
    syscall                # Llamada al sistema para esperar 1 segundo
    j ESPERAR_LOOP         # Repetir hasta cumplir el tiempo

FIN_ESPERA:
    jr $ra                  # Regresar a la rutina principal
