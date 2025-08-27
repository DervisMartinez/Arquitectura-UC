#operaciones del hardware del computador
# variables 

#calculos aritmeticos: add
#add : 

add $s1 , $s2 , $s3  #significado : $s1  = $s2 + $s3 / tres operandos , datos en registro

#substract : 

sub $s1 , $s2 , $s3 # significado $s1 = $s2 - $s3 / tres operandos : datos en registros 

#add inmediate:

addi $s1 , $s2 , 100 #significado : $s1 = $s2 + 100 / usado para sumar constantes 


#Transferncia de datos 

#load word
lw $s1 ,100($s2) #significado : $sl = memory[$s2 + 100]/ palabra sw memmoria de registro 

#store word
sw $s1,100($s2) #singnificado :memory[$s2 + 100] = $sl / palabra de registro de memoria 

#load half 
