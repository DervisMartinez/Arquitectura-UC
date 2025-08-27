.data
	numero : .word 10

.text 
	main : 
	li  $v0 , 1 		#Cargamos el numero 4 para indicar al sistema que va mostrar un caracter
	lw  $a0 , numero 	#cargamos al registro 4a0 lo que hay dentor de Numero 
	syscall 		#ejecuta la accion 
	
	li $v0 , 10 
	syscall 
	
