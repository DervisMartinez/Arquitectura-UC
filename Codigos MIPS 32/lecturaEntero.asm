.data 
	mensaje1: .asciiz "ingresa un numero:" 
	mensaje2: .asciiz "este es tu numero"
.text
	main:
		li $v0 , 4  		#cargamos el numero 4 para indicarle al sistema que muestre un caracter 
		la $a0 , mensaje1
		syscall
		
		li $v0 ,5 		#caragamos el numero 5 para recibir un entero 
		move $t0 ,$v0		#copiar el valor de un registro a otro.
		syscall 
		
		li $v0 ,4
		la $a0,mensaje2 
		syscall 
		
		li $v0 ,1
		move $a0 ,$t0
		syscall
		
		