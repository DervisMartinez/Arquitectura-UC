.data
	vector: .word 1,2,3
	n: .word 2
.text
	main:
					# ===================================================== #
	la $a0, vector			#            Cargo la direccion del vector		3
	li $a1, 0			#              Cargo el indice izquierdo		#
	lw $a2, n			#                Cargo el indice derecho		#
	li $a3, 4			#    Le asigno el valor que quiero buscar en el vector 	#
					# ===================================================== #
	jal busqueda			#               Llama a la funcio busqueda		#
					# ===================================================== #
	move $a0, $v0			#     Mueve el valor si es -1 es que no lo consiguió	#
	li $v0, 1			# 		       Subrutina			#
	syscall				# 		  Imprime el resultado			#
					# ===================================================== #
	end:				# ===================================================== #
	li $v0,10			#			  FIN				#
	syscall				# ===================================================== #
	
##################################################################################################

	busqueda:			# FUNCION BUSQUEDA
	addi $sp, $sp, -20		# SE HACE LA RESERVACION DE PILA 
	sw $a0, 0($sp)		
	sw $a1, 4($sp)
	sw $a2, 8($sp)
	sw $a3, 12($sp)
	sw $ra, 16($sp)
	
	ble $a1, $a2, sigue		# SI IZQUIERDA > DERECHA ENTONCES -> RETORNA - 1 
	li $v0, -1			# BLE ( IZQUIERDA <= DERECHA ) CONDICION CONTRARIA SI SE CUMPLE SIGUE
	j exit_busqueda			# SALTA A EXIT_BUSQUEDA
	
	sigue:
	sub $t0, $a2, $a1		# derecha - izquierda
	sra $t0, $t0, 1			# ( derecha - izquierda ) / 2
	add $t0, $a1, $t0		# izquierda + ( derecha - izquierda ) / 2
	
	sll $s0, $t0, 2			# medio * 4
	add $s0, $a0, $s0		# dir(vector) = v + medio * 4
	
	lw $t1 , 0($s0)			# $t1 = v[medio]
	
	beq $t1, $a3, medio		# SI ARR[MEDIO] == X
	bgt $t1, $a3, izquierda		# SI ARR[MEDIO] > X
					# SINO ES ARR[MEDIO] < X
	derecha:
	addi $a1, $t0, 1		#$1 = medio + 1
	jal busqueda			# LLAMADA RECURSIVA
	
	j exit_busqueda			# DESPUES DE LA LLAMADA SALTA A EXIT_BUSQUEDA
		
	izquierda:			
	addi $a2, $t0, -1		# $a2 = medio - 1 
	jal busqueda			# LLAMADA RECURSIVA
	
	medio: 				# DESPUES DE LA LLAMADA 
	lw $v0, 0($s0)			# CARGA EL VALOR DEL MEDIO EN $V0 === RETURN MEDIO
	
	exit_busqueda:			# DEVOLUCION DE PILA
	lw $a0, 0($sp)
	lw $a1, 4($sp)
	lw $a2, 8($sp)
	lw $a3, 12($sp)
	lw $ra, 16($sp)
	addi $sp, $sp, 20
	jr $ra				# RETORNA
