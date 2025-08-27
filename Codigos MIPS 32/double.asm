.data
	double : .double 5.24
.text
	main: 
	li $v0 , 3 		#Codigonpar imprimir el doble (es el 3)
	ldc1 $f12 , double 	#ldc1 cargar un dato de 64 bits (doubleword) desde memoria al Coprocesador 1
				#$f12 s un registro de punto flotante de 64 bits (double-precision)
	syscall 		#ejecuta la accion
	
	#salir
	li $v0 , 10
	syscall			#salir 
	
	