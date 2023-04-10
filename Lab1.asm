.data
  	resultado: .word 0
  	mensaje: .asciiz "El resultado es: "
  	mensaje_num1: .asciiz "Introduzca el primer n�mero: "
  	mensaje_num2: .asciiz "Introduzca el segundo n�mero: "
  	mensaje_opcion: .asciiz "Seleccione una opci�n (1 = suma, 2 = resta, 3 = multiplicacion): "
 	 mensaje_no_valido: .asciiz "Opci�n no v�lida. Saliendo del programa."

.text
 	# Imprime el mensaje para pedir la opci�n
 	la $a0, mensaje_opcion
  	li $v0, 4
  	syscall
 	 # Lee la opci�n ingresada por el usuario y lo guarda en la direcci�n de memoria 0x10010080
 	li $v0, 5
  	syscall
  	sw $v0, 0x10010080

 	 # Imprime el mensaje para pedir el primer n�mero
  	la $a0, mensaje_num1
  	li $v0, 4
  	syscall
  	# Lee el primer n�mero ingresado por el usuario y lo guarda en la direcci�n de memoria 0x100100a0
 	 li $v0, 5
 	 syscall
 	 sw $v0, 0x100100a0

 	 # Imprime el mensaje para pedir el segundo n�mero
  	la $a0, mensaje_num2
  	li $v0, 4
  	syscall
  	# Lee el segundo n�mero ingresado por el usuario y lo guarda en la direcci�n de memoria 0x100100c0
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
  	add $t5, $t5,$t1 	
  	lw $t4, resultado


  	# Carga la opci�n elegida por el usuario en $t3
  	lw $t3, 0x10010080

  	# Si la opci�n es 1, salta a la etiqueta suma
  	beq $t3, 1, suma
  	# Si la opci�n es 2, salta a la etiqueta resta
  	beq $t3, 2, resta
  	# Si la opci�n no es v�lida, salta a la etiqueta no_valido
  	beq $t3, 3, etiquetamulti
  	j no_valido

suma:
 	 beq $t1, $zero, fin
  	# Si $t1 es distinto de cero, resta 1 a $t1
  	addi $t1, $t1, -1
  	# Suma 1 a $t0
  	addi $t0, $t0, 1
  	# Suma 1 a $t2
  	addi $t2, $t2, 1
  	# Salta a la etiqueta suma
  	
 	 j suma

resta:
  	beq $t1, $zero, fin
  	# Si $t1 es distinto de cero, resta 1 a $t1
  	addi $t1, $t1, -1
  	# Resta 1 a $t0
  	addi $t0, $t0,-1
 	addi $t2, $t2, 1
  	# Salta a la etiqueta resta
  	
  	j resta
  
multiplicacion:
	beq $t1, $zero, finMult # Si t1 es 0, salta a fin
 	sub $t1, $t1, 1 # resta 1 a t1
 	add $t4, $t4, $t0 # agrega t0 a t3
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
 	

no_valido:
  	# Imprime el mensaje para indicar que la opci�n no es v�lida
  	la $a0, mensaje_no_valido
  	li $v0, 4
  	syscall
  	# Salta a la etiqueta fin
  	j fin

fin:
  	# Si $t2 es 0, la opci�n no fue v�lida
  	beq $t2, $zero, no_valido
  	# Guarda el resultado en resultado
  	sw $t0, 0x100100e0
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
  	
finMult:

	bltz $t5, cambiar_signo_resultado
	etiqueta1:
  	# Si $t2 es 0, la opci�n no fue v�lida
  	beq $t2, $zero, no_valido
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

