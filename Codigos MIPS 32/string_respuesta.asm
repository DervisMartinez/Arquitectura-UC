.data 
	message1: .asciiz "Di tu nombre"
	message2: .asciiz "Hola"
	name : .space 20  #.space reserva N bytes de memoria 
.text 

main: 
	li ,$v0 ,4 	#Cargamos el numero 4 para indicar al sistema que va mostrar un caracter
	la $a0 ,message1 
	syscall 	#ejeucuta la accion

	li $v0 ,8 	#Cargamos el numero 8 para indicar al sistema que va mostrar un string
	la $a0 , name 
	li $a1 ,20 	#indicamos el tamaño 
	syscall 
	
	li $v0 ,4
	la $a0 , message2
	syscall
	
	li $v0,4
	la $a0 ,name
	syscall 

	#termina el programa 
	li ,$v0 ,10
	syscall