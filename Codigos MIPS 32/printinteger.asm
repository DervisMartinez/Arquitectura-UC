#Print integer
.data
	message: .byte 'm'
.text

	li $v0 , 4 		 #Cargamos ek numero 4 para indicar al sistema que va mostrar un caracter
	la $a0,message 	 
	syscall 		 #ejecuta la accion