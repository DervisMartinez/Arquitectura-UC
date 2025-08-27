.data 
	string : .asciiz "Hello World"
.text 
	main : 
	li $v0 , 4 		#cargamos una cadena de caracteres 
	la $a0 , string 	#cargamos la direccion de string a $a0 
	syscall
	
	li $v0 , 10 
	syscall			#finaliza el programa