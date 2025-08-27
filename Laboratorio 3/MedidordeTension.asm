.data
    # Direcciones de memoria mapeadas para los registros del dispositivo de tensión arterial
    TensionControl:  .word 0x10000010 # Ejemplo de dirección para el registro de control
    TensionEstado:   .word 0x10000014 # Ejemplo de dirección para el registro de estado
    TensionSistol:   .word 0x10000018 # Ejemplo de dirección para la tensión sistólica
    TensionDiastol:  .word 0x1000001C # Ejemplo de dirección para la tensión diastólica

    # Mensajes para la salida 
    msg_inicio_medicion: .asciiz "Iniciando medición de tensión arterial...\n"
    msg_esperando:       .asciiz "Esperando resultados de la medición...\n"
    msg_medicion_lista:  .asciiz "Medición de tensión completada.\n"
    msg_sistolica:       .asciiz "Tensión Sistólica: "
    msg_diastolica:      .asciiz "Tensión Diastólica: "
    newline:             .asciiz "\n"

.text
.globl main

main:
    # Imprimir mensaje de inicio
    li $v0, 4
    la $a0, msg_inicio_medicion
    syscall

    # Llamar al procedimiento controlador_tension
    jal controlador_tension

    # Los valores de tensión sistólica y diastólica están ahora en $v0 y $v1.
    # Los moveremos a registros "s" para que no se pierdan al usar $v0 para syscalls,
    move $s0, $v0 # $s0 guarda la tensión sistólica
    move $s1, $v1 # $s1 guarda la tensión diastólica

    # Imprimir resultados
    li $v0, 4
    la $a0, msg_medicion_lista
    syscall

    # Imprimir tensión sistólica
    li $v0, 4
    la $a0, msg_sistolica
    syscall
    li $v0, 1          # Còdigo para imprimir entero
    move $a0, $s0      # Cargar el valor de tensión sistólica desde $s0 a $a0 para syscall
    syscall
    li $v0, 4
    la $a0, newline
    syscall

    # Imprimir tensión diastólica
    li $v0, 4
    la $a0, msg_diastolica
    syscall
    li $v0, 1          # Còdigo para imprimir entero
    move $a0, $s1      # Cargar el valor de tensión diastólica desde $s1 a $a0 para syscall
    syscall
    li $v0, 4
    la $a0, newline
    syscall

    # Terminar el programa
    li $v0, 10
    syscall

# -----------------------------------------------------------------------------
# Procedimiento: controlador_tension
# Descripción: Inicia la medición, espera los resultados y los retorna.
# Retorno:
#   $v0: Valor de tensión sistólica
#   $v1: Valor de tensión diastólica
# -----------------------------------------------------------------------------
controlador_tension:
    # 1. Iniciar la medición: Escribir 1 en TensionControl
    li $t0, 1           # Carga el valor 1
    sw $t0, TensionControl # Escribe 1 en el registro de control

    # Imprimir mensaje de espera (para una mejor comprension)
    li $v0, 4
    la $a0, msg_esperando
    syscall

    # 2. Esperar a que TensionEstado tenga el valor de 1 (Polling)
wait_for_measurement:
    lw $t1, TensionEstado # Lee el valor del registro de estado
    li $t2, 0             # Carga el valor 0 para comparar
    beq $t1, $t2, wait_for_measurement # Si TensionEstado es 0, sigue esperando
    # Si llegamos aquí, TensionEstado es 1 y los resultados están listos

    # 3. Leer los resultados: TensionSistol y TensionDiastol
    lw $v0, TensionSistol  # Carga el valor de la tensión sistólica en $v0
    lw $v1, TensionDiastol # Carga el valor de la tensión diastólica en $v1

    jr $ra # Retorna al llamador