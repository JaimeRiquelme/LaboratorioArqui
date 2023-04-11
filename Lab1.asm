.data
  	resultado: .word 0
  	diez: .word 10
	cuatro : .word 4 #Cantidad de digitos que tendra el decimal
  	mensaje: .asciiz "El resultado es "
  	mensaje_num1: .asciiz "Introduzca el primer número: "
  	mensaje_num2: .asciiz "Introduzca el segundo número: "
  	mensaje_opcion: .asciiz "Seleccione una opción (1 = suma, 2 = resta, 3 = multiplicacion): "
  	error: .asciiz  "\nNo se puede colocar 0 en el denominador "
  	coma: .asciiz ","
  	

.text

#----------Procedimiento para pedir valores por consola y guardar en las direcciones pedidas-------------------------
	lw $t7, diez($zero)
	lw $t9,cuatro($zero)
 	# Imprime el mensaje para pedir la opción
 	la $a0, mensaje_opcion
  	li $v0, 4
  	syscall
 	 # Lee la opción ingresada por el usuario y lo guarda en la dirección de memoria 0x10010080
 	li $v0, 5
  	syscall
  	sw $v0, 0x10010080

 	 # Imprime el mensaje para pedir el primer número
  	la $a0, mensaje_num1
  	li $v0, 4
  	syscall
  	# Lee el primer número ingresado por el usuario y lo guarda en la dirección de memoria 0x100100a0
 	 li $v0, 5
 	 syscall
 	 sw $v0, 0x100100a0

 	 # Imprime el mensaje para pedir el segundo número
  	la $a0, mensaje_num2
  	li $v0, 4
  	syscall
  	# Lee el segundo número ingresado por el usuario y lo guarda en la dirección de memoria 0x100100c0
  	li $v0, 5
  	syscall
  	sw $v0, 0x100100c0

  	# Carga el valor de num1 en $t0
  	lw $t0, 0x100100a0
  	# Carga el valor de num2 en $t1
  	lw $t1, 0x100100c0
  	# Inicializa $t2 en cero
  	addi $t2, $zero, 0
  	addi $t5, $zero,0 	
  	lw $t4, resultado


  	# Carga la opción elegida por el usuario en $t3
  	lw $t3, 0x10010080

  	# Si la opción es 1, salta a la etiqueta suma
  	beq $t3, 1, suma
  	# Si la opción es 2, salta a la etiqueta resta
  	beq $t3, 2, resta
  	# Si la opción es 3, salta a la etiqueta multiplicacion
  	beq $t3, 3, etiquetamulti
  	# Si la opcion es 4, salta a la etiqueta division
  	beq $t3, 4, division


suma:
 	beq $t1, $zero, fin_suma_y_resta
  	# Si $t1 es distinto de cero, resta 1 a $t1
  	addi $t1, $t1, -1
  	# Suma 1 a $t0
  	addi $t0, $t0, 1
  	# Suma 1 a $t2
  	addi $t2, $t2, 1
  	# Salta a la etiqueta suma
  	
 	 j suma

resta:
  	beq $t1, $zero, fin_suma_y_resta
  	# Si $t1 es distinto de cero, resta 1 a $t1
  	addi $t1, $t1, -1
  	# Resta 1 a $t0
  	addi $t0, $t0,-1
 	addi $t2, $t2, 1
  	# Salta a la etiqueta resta
  	
  	j resta
  
multiplicacion:
	add $t5, $t5,$t1
	beq $t1, $zero, fin_multi # Si t1 es 0, salta a fin
 	sub $t1, $t1, 1 # resta 1 a t1
 	add $t4, $t4, $t0 # agrega t0 a t4
 	addi $t2, $t2, 1
 	j multiplicacion # salta a multiplicacion
 	



 	
etiquetamulti:
	bltz $t1, cambiar_signo
	j multiplicacion		
 	
cambiar_signo:
	neg $t1, $t1
	j multiplicacion
	
cambiar_signo_resultado:
	neg $t4, $t4
	jal etiqueta1
 	
fin_multi:
	move $t0, $t4
	j fin_suma_y_resta
	
	
fin_suma_y_resta:

  	# Guarda el resultado en resultado
  	sw $t0, 0x100100e0
  	# Imprime el mensaje
  	la $a0, mensaje
  	li $v0, 4
  	syscall
	
  	# Imprimir corchete de apertura
    	li $v0, 11
    	li $a0, '['
    	syscall

    	# Encontrar el número de dígitos del resultado
    	move $t3, $t0
    	li $t4, 1
    	
nDigitos:
   	li $t5, 10
    	div $t3, $t5
   	mflo $t3
   	beqz $t3, mostrarDigitos
   	addi $t4, $t4, 1
   	j nDigitos
   	 
mostrarDigitos:
    	# Imprimir dígitos
    	li $t5, 10
   	 move $t3, $t0
loopDiv:
   	 divu $t3, $t5
   	 mfhi $t6
   	 mflo $t3
   	 li $v0, 1
    	move $a0, $t6
   	 syscall

   	 # Imprimir coma si no es el último dígito
   	 addi $t4, $t4, -1
   	 bgtz $t4, coma2
    	j corcheteCierre

coma2:
   	 li $v0, 11
   	 li $a0, ','
    	syscall
    	j loopDiv

corcheteCierre:
    	# Imprimir corchete de cierre
    	li $v0, 11
    	li $a0, ']'
    	syscall

    	# Imprimir un salto de línea
    	li $v0, 11
    	li $a0, '\n'
    	syscall

    	# Terminar la ejecución del programa
   	 li $v0, 10
    	syscall 
  	
finMult:

	bltz $t5, cambiar_signo_resultado
	etiqueta1:
  	# Guarda el resultado en resultado
  	sw $t4, 0x100100e0
  	# Imprime el mensaje
  	la $a0, mensaje
  	li $v0, 4
  	syscall
  	# Carga el resultado desde la memoria y lo imprime
  	lw $a0, 0x100100e0
  	li $v0, 1
  	syscall

  	# Sale del programa
  	li $v0, 10
  	syscall
  	
division:
  	add $s1,$zero,$zero #inicializa contador $s1 = 0.
	add $s2,$zero,$zero #inicializa contador $s2 = 0.
	add $s3,$zero,$zero #inicializa contador $s3 = 0 .
	add $t4,$zero,$zero # $t4 = 0.
	
	beq $t1 , $zero , salida_rapida  #Caso donde el denominador es igual a 0.
	slt $t3, $t0 , $zero		 #Si el numerador es menor que 0 => $t3 = 1 , en caso contrario $t3 = 0.
	slt $t4, $t1 , $zero  		 #Si el denominador es menor que 0 => $t4 = 1 , en caso contrario $t4 = 0.
	bne $t3 , $t4, modificacion1	 #Caso donde sean distintos signos , por ende el resultado debe ser negativo . Te dirije hacia la etiqueta "modificacion1".
	beq $t3 , $t4, modificacion2	 #Caso donde tanto el numerador como el denominador son del mismo signo , por ende su resultado sera positivo. Te dirije hacia la etiqueta "modificacion2".
	
	
	
	#-----------------------------------------------------------------------------------
	#Procedimiento en el cual hace el conteo para obtener la parte entera y fraccionaria. (sirve este loop solamente para el caso en que ambos tengan igual signo)
	
	
loop:
	slt $t3, $t0 , $t1	#Pregunta si el valor en $t0 es menor que el denominador , si es True = 1 , false = 0 .
	beq $t3 , 1, exit 	#caso base : para cuando el valor que esta en $t0 sea menor que el denominador  . te dirije a la etiqueta "exit".
	sub $t0 , $t0 ,$t1	#Se resta el numerador y el denominador
	addi $s1 , $s1 , 1	#se incrementa el contador (parte entera , hace referencia a cuantas veces cabe el denominador en el numerador)
	j loop			#se hace la recursion
			
	
exit:
    li $v0, 1      # carga el código de servicio de la función de imprimir un entero
    move $a0, $s1  # mueve el contenido de $s1 en $a0 para ser impreso
    syscall        # llama al servicio del sistema para imprimir el número
    li $v0, 4      # carga el código de servicio de la función de imprimir una cadena
    la $a0, coma   # carga la dirección de la cadena en $a0
    syscall        # llama al servicio del sistema para imprimir la coma
    j parte_fraccionaria  # salta a la etiqueta "parte_fraccionaria"

		
		
	
loop2:
	slt $t3, $t0 , $t1    	#Pregunta si el valor en $t0 es menor que el denominador , si es True = 1 , false = 0 .
	beq $t3 , 1, terminar 	#caso base : para cuando el valor que esta en $t0 sea menor que el denominador  . te dirije a la etiqueta "terminar".
	sub $t0 , $t0 ,$t1	#Se resta el resto y el denominador
	addi $s1 , $s1 , 1	#se incrementa el contador
	j loop2			#se hace la recursion
		
	
	
parte_fraccionaria:
	beq $s2 , $t9, exit2  	#Pregunta si el contador $s2 = 2   
	add $t5 , $t0, $zero  	# $t5 = resto
	add $t6 , $t6, $zero 	# $t6 = 0
	lw $s3 , resultado
	jal multi		#Se hace el salto a multi , para realizar la multiplicacion resto*10
	lw $t7 , diez
	lw $t6, resultado
	add $s1,$zero,$zero    	#se reinicia el contador $s1 en 0
	jal loop2		#Se hace el salto hacia loop2
	addi $s2 , $s2 , 1	#se incrementa el contador
	j parte_fraccionaria  	#se hace la recursion
		
		
		
terminar:
	li $v0,1
	la $a0,0($s1) #imprime la parte fraccionaria
	syscall
	jr $ra
	
exit2: 
	#se termina el programa.
	li $v0, 10
	syscall
	
#------------------------------------------------------------------------
#procedimiento cuando ambos numeros son del mismo signo , por ende el resultado es positivo
	
modificacion2: 
	beq $t3 , 1 , traformacion1  #verifica si es el caso en que ambos son negativos , pero toma en consideracion uno solamente , ya que, con revisar simplemente 1 se conoce el signo del otro
	j loop  #En caso de que $t3 = 0 , estaremos en la situacion en que ambos son positivos , por consecuente realiza el salto para comenzar el loop
		
		
traformacion1: #caso donde ambos son negativos , por lo que se procede a transformarlos a postivos para poder trabajarlos mejor con el loop.
	add $t3 , $t0 , $t0   # Se guarda en $t3 el doble del numerador.
	sub $t0 , $t0 , $t3   # Se cambia el numerador a postivo mediante la resta entre el valor original y su doble.
	
	add $t3 , $t1 , $t1   # Se guarda en $t3 el doble del denominador.
	sub $t1 , $t1 , $t3   # Se cambia el denominador a postivo mediante la resta entre el valor original y su doble.
	j loop #se hace el salto al loop
	
	

#------------------------------------------------------------------------
loop_:
	slt $t3, $t0 , $t1
	beq $t3 , 1, exit_ 
	sub $t0 , $t0 ,$t1
	addi $s1 , $s1 , 1
	j loop_
			
	
exit_:  #unico variante en comparacion del loop anterior es en el que la parte entera se cambia a negativo
	add $t3 , $s1 , $s1
	sub $s1 , $s1 , $t3  #se cambia el signo de la parte entera y se guarda en $s1
	li $v0,1
	la $a0,0($s1) #se imprime el contenido de $s1 , siendo esta la parte entera de con signo negativo
	syscall
	#se muestra en pantalla una coma para separar las coordenadas del vector.
	li $v0, 4
	la $a0, coma
	syscall
	j parte_fraccionaria_
		
		
	
loop2_:
	slt $t3, $t0 , $t1
	beq $t3 , 1, terminar_ 
	sub $t0 , $t0 ,$t1
	addi $s1 , $s1 , 1
	j loop2_
		
	
	
parte_fraccionaria_:
	beq $s2 , $t9, exit2_
	add $t5 , $t0, $zero
	add $t6 , $t7, $zero
	jal multi
	add $s1,$zero,$zero
	jal loop2_
	addi $s2 , $s2 , 1
	j parte_fraccionaria_
		
		
		
terminar_:
	li $v0,1
	la $a0,0($s1)
	syscall
	jr $ra
	#colocar el salto debajo del lopp
	
exit2_: 
	#se termina el programa.
	li $v0, 10
	syscall
		
#------------------------------------------------------------------------
#procedimiento cuando son distinto signos, por ende hay que saber cual es el esta negativo.
#se hara uso del mismo loop que el caso donde ambos tienen el mismo caso , solamente con una pequeña modificacion, en el cual la parte entera se pasa a negativo
	
modificacion1:  
	beq $t3 , 1 , traformacion2  #Si #t3 = 1 da a entender que el numerador era con el signo negativo , por esto se cambiara a positivo.
	beq $t4 , 1 , traformacion3  #Si #t4 = 1 da a entender que el denominador era con el signo negativo , por esto se cambiara a positivo.
		
traformacion2: #caso donde el nuemrador es el negativo y se tranforma a postivo para trabajarlo de buena manera en el loop_
	add $t3 , $t0 , $t0  
	sub $t0 , $t0 , $t3
	j loop_
		
traformacion3:  #caso donde el denominador es el negativo y se tranforma a postivo para trabajarlo de buena manera en el loop_
	add $t3 , $t1 , $t1
	sub $t1 , $t1 , $t3
	j loop_

#----------------------------------------------------------------------
#valores reservados para la multi es $t5 $t6
#multiplicacion que funciona solo caso +
	
multi:
	beq $t7 , $zero, exitmulti 
	addi $t7, $t7 , -1
	add $t6, $t6,$t5	
	j multi
	
	
exitmulti:
	move $t0, $t6
	jr $ra
	
	
#----------------------------------------------------------------------
#salida cuando el denominador es igual a 0
	
salida_rapida:
	li $v0, 4
	la $a0, error
	syscall
	li $v0, 10
	syscall

 	

