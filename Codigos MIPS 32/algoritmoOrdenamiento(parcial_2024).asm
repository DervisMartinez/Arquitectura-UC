.data
	vector: .word 5,4,3,2,1
	n: .word 5

.text
	main:
	
	la $a0, vector
	lw $a1, n
	
	jal algoritmoOrdenamiento
	
	end:
	li $v0,10
	syscall

##########################################################################################################################
	
	algoritmoOrdenamiento:
	# Reservación de pila
	addi $sp, $sp, -12
	sw $a0, 0($sp)
	sw $a1, 4($sp)
	sw $ra, 8($sp)
	
	li $t0, 0		# i = 0
	addi $t1, $a1, -1 	# n - 1
	
	for1:
		bge $t0, $t1, exit_for1
		li $t2, 0		# j = 0
		sub $t3, $t1, $t0	# n - 1 - i
	for2:	
		bge $t2, $t3, exit_for2
		
		sll $s0, $t2, 2		# j * 4
		add $s0, $a0, $s0	# vector[j*4] ( dir(vector)+ j * 4 )
		
		lw $t4, 0($s0)		# $t4 = vector[ j ]
		lw $t5, 4($s0)		# $t5 = vector[ j + 1 ]
		
		ble $t4, $t5, no_swap
			# dir vector está en $a0
			move $a1, $t2 		# $a1 = j
			addi $a2, $t2, 1	# $a2 = j + 1
			jal algoritmoIntercambio
			
		no_swap:
		addi $t2, $t2, 1		# j = j + 1
		j for2
		
	exit_for2:
		addi $t0, $t0, 1		# i = i + 1
		j for1
	
	exit_for1:
	# Devolucion de pila
	lw $a0, 0($sp)
	lw $a1, 4($sp)	
	lw $ra, 8($sp)
	addi $sp, $sp, 12
	jr $ra
	
#######################################################################################################################################
	
	algoritmoIntercambio:
	addi $sp, $sp, -16
	sw $a0, 0($sp)
	sw $a1, 4($sp)
	sw $a2, 8($sp)
	sw $ra, 12($sp)
	
	sll $a1, $a1, 2
	add $a1, $a0, $a1
	
	sll $a2, $a2, 2		# $a2 = j * 4
	add $a2, $a0, $a2	# vector[j+4] ( dir(vector)+ j * 4 )
	
	lw $t8, 0($a1)		# $t8 = vector[i]
	lw $t9, 0($a2)		# $t9 = vector[j]
	
	sw $t8, 0($a2)		# vector[i] = $t9
	sw $t9, 0($a1)		# vector[j] = $t8
		
	# Devolucion de pila
	lw $a0, 0($sp)
	lw $a1, 4($sp)	
	lw $a2, 8($sp)
	lw $ra, 12($sp)
	addi $sp, $sp, 16
	jr $ra
	
############################################################################
	