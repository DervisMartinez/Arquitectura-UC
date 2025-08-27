.data
	flotante : .float 5.5
.text
	main :
	
	li $v0 , 2
	lwc1 $f12 , flotante 
	syscall 
	
	li $v0 ,10
	syscall 
	