.data
    SensorControl:  .word 0x10000000 # Un ejemplo de Dirección de memoria mapeada para el registro de control 
    SensorEstado:   .word 0x10000004 # Un ejemplo de Dirección de memoria mapeada para el registro de estado 
    SensorDatos:    .word 0x10000008 # Un ejemplo de Dirección de memoria mapeada para el registro de datos 

    # Mensajes para la salida (opcional, para depuración/información)
    msg_init_ok:    .asciiz "Sensor inicializado correctamente.\n"
    msg_read_ok:    .asciiz "Lectura de temperatura exitosa: "
    msg_read_error: .asciiz "Error al leer temperatura. Reinicialice el sensor.\n"
    msg_not_ready:  .asciiz "Sensor no listo para leer. Intente de nuevo o reinicialice.\n"
    newline:        .asciiz "\n"

.text
.globl main

main:
    # Llamar a InicializarSensor
    jal InicializarSensor

    # Llamar a LeerTemperatura
    jal LeerTemperatura

    # Imprimir resultados de LeerTemperatura (asumiendo que $v0 = valor, $v1 = código)
    move $s0, $v0 # Guarda el valor de la temperatura
    move $s1, $v1 # Guarda el código de retorno

    li $t0, 0
    beq $s1, $t0, print_ok_read # Si el código es 0, fue exitoso
    j print_error_read           # Si el código es -1, fue un error

print_ok_read:
    li $v0, 4
    la $a0, msg_read_ok
    syscall

    li $v0, 1
    move $a0, $s0 # Imprime el valor de la temperatura
    syscall

    li $v0, 4
    la $a0, newline
    syscall
    j end_main

print_error_read:
    li $v0, 4
    la $a0, msg_read_error
    syscall

end_main:
    # Salir del programa
    li $v0, 10
    syscall

# -----------------------------------------------------------------------------
# Procedimiento: InicializarSensor
# Descripción: Inicializa el sensor escribiendo 0x2 en el registro de control.
#              Espera hasta que el registro de estado sea 1 (inicializado).
# -----------------------------------------------------------------------------
InicializarSensor:
    # 1. Escribir 0x2 en SensorControl para inicializar el sensor 
    li $t0, 0x2
    sw $t0, SensorControl

    # 2. Esperar hasta que el registro de estado sea 1 
wait_for_init:
    lw $t1, SensorEstado # Lee el valor del registro de estado 
    li $t2, 1            # Carga el valor 1 para comparar 
    bne $t1, $t2, wait_for_init # Si no es 1, sigue esperando 

    # Sensor inicializado y listo
    li $v0, 4
    la $a0, msg_init_ok
    syscall

    jr $ra # Retorna al llamador

# -----------------------------------------------------------------------------
# Procedimiento: LeerTemperatura
# Descripción: Lee el valor de temperatura. Devuelve dos resultados:
#              el valor leído (en $v0) y un código (en $v1):
#              0 si se ha leído correctamente, -1 en caso de error. 
# -----------------------------------------------------------------------------
LeerTemperatura:
    # 1. Leer el Registro de Estado (SensorEstado) 
    lw $t0, SensorEstado

    # 2. Comprobar el estado [cite: 10, 11, 12]
    li $t1, 1  # Valor para "listo para leer" 
    li $t2, -1 # Valor para "error" 

    beq $t0, $t1, sensor_ready       # Si el estado es 1, el sensor está listo 
    beq $t0, $t2, sensor_error       # Si el estado es -1, hay un error 
    j sensor_not_ready               # Si el estado es 0, no está listo o no hay lectura 

sensor_ready:
    # El sensor está listo, leer SensorDatos 
    lw $v0, SensorDatos # Carga la temperatura en $v0 [cite: 13]
    li $v1, 0           # Código de retorno: 0 (éxito) 
    jr $ra              # Retorna

sensor_error:
    # Se ha producido un error
    li $v0, 0           # Valor de temperatura (puede ser irrelevante en caso de error)
    li $v1, -1          # Código de retorno: -1 (error) 
    jr $ra              # Retorna

sensor_not_ready:
    # El sensor no está listo o aún no hay lectura disponible
    li $v0, 0           # Valor de temperatura (puede ser irrelevante)
    li $v1, -1          # Se devuelve -1 ya que no se pudo leer correctamente 
    jr $ra              # Retorna