.data 
    mensaje: .asciiz "Elija la operacion a realizar: suma: 1, resta: 2, multiplicacion: 3, division: 4 : "
    resultado: .asciiz "El resultado es: "
    coma: .asciiz ","
    cierre: .asciiz "]"
    

    
.text
	li $s0, 1      # Carga el valor 1 en el registro $s0
	li $t9, 0      # Carga el valor 0 en el registro $t9
	li $t8, 0      # Carga el valor 0 en el registro $t8
	li $t7, 7      # Carga el valor 7 en el registro $t7
	li $t6, 0      # Carga el valor 0 en el registro $t6
#CONVERTIDOR DE PRIMER NUMERO------------------------------------------------------------------
convertir_numero:
	lw $t0, 0x100100a0($t6)    # Carga el valor almacenado en la dirección de memoria calculada por $t6 + 0x100100a0 en $t0
	slt $at, $t8, $t7         # Compara el valor en $t8 con el valor en $t7 y establece $at a 1 si $t8 es menor que $t7
	beq $at, $zero, movernumero1   # Salta a la etiqueta 'movernumero1' si $t8 es mayor o igual a $t7

multi_diez:
    beq $t8, $zero, uno     # Salta a la etiqueta 'uno' si $t8 es igual a 0
    beq $t8, $s0, diez     # Salta a la etiqueta 'diez' si $t8 es igual a 1
    move $t5, $t8    # Mueve el contenido de $t8 a $t5
    addi $t4, $zero, 0    # Carga el valor 0 en el registro $t4
    addi $t1, $zero, 10   # Carga el valor 10 en el registro $t1
    addi $t2, $zero, 10   # Carga el valor 10 en el registro $t2

loop:
   beq $t5, $s0, fin     # Salta a la etiqueta 'fin' si $t5 es igual a 1
   jal multi_diezv2     # Salta a la subrutina 'multi_diezv2' y guarda la dirección de retorno en el registro $ra
loop_s:
   addi $t5, $t5, -1    # Resta 1 al valor en $t5
   beq $t5, $s0, multi   # Salta a la etiqueta 'multi' si $t5 es igual a 1
   move $t1, $t4    # Mueve el contenido de $t4 a $t1
   addi $t4, $zero, 0   # Carga el valor 0 en el registro $t4
   j loop    # Salta a la etiqueta 'loop' (bucle)

   
multi_diezv2:
    li $t3, 0   # Inicializa el registro $t3 en 0, se utilizará como contador del bucle
    addi $t2, $zero, 10  # Inicializa el registro $t2 en 10, se utilizará como límite del bucle

loop2:
    beq $t3, $t2, loop_s   # Comprueba si el contador es igual al límite, salta a la etiqueta loop_s 
    add $t4, $t4, $t1   # Acumula el valor de $t1 en $t4, se utiliza para almacenar la multiplicación
    addi $t3, $t3, 1    # Incrementa el contador en 1
    j loop2   # Salta de vuelta al inicio del bucle

uno:
    addi $t4, $zero, 1   # Inicializa $t4 en 1 
    j multi   # Salta a la etiqueta multi

diez:
    addi $t4, $zero, 10   # Inicializa $t4 en 10 
    j multi   # Salta a la etiqueta multi

multi:
    move $t1, $t4   # Copia el valor de $t4 en $t1 
    move $t2, $t0   # Copia el valor de $t0 en $t2 
    li $t3, 0   # Reinicia el contador a 0
    li $t4, 0   # Reinicia el acumulador a 0

loop_3:
    beq $t3, $t2, done   # Comprueba si el contador es igual al límite, salta a la etiqueta done

    add $t4, $t4, $t1   # Acumula el valor de $t1 en $t4, se utiliza para almacenar la multiplicación
    addi $t3, $t3, 1   # Incrementa el contador en 1
    j loop_3   # Salta de vuelta al inicio del bucle
 

done:
	add $t9,$t9,$t4      # Suma el valor en $t4 al valor en $t9 y guarda el resultado en $t9
	addi $t8,$t8,1       # Incrementa el valor en $t8 en 1
	addi $t6,$t6,4       # Incrementa el valor en $t6 en 4
	j convertir_numero   # Salta a la etiqueta 'convertir_numero'

movernumero1:
	move $s7,$t9         # Mueve el valor en $t9 al registro $s7
	j reset              # Salta a la etiqueta 'reset'

reset:
	addi $t6,$zero,0     # Establece el valor de $t6 en 0
	li $t9,0             # Carga el valor 0 en $t9
	li $t8,0             # Carga el valor 0 en $t8
	li $t7,7             # Carga el valor 7 en $t7
	li $t6,0             # Carga el valor 0 en $t6 
	j convertir_numero2  # Salta a la etiqueta 'convertir_numero2'
#CONVERTIDOR DE SEGUNDO NUMERO-----------------------------------------------------------------------------------------
convertir_numero2:
	lw $t0, 0x100100c0($t6)   # Carga el valor almacenado en la dirección de memoria 0x100100c0 + $t6 en $t0
	slt $at, $t8, $t7         # Compara el valor de $t8 con $t7 y establece $at en 1 si $t8 es menor que $t7
	beq $at, $zero, movernumero2   # Salta a 'movernumero2' si $t8 es mayor o igual a $t7


	
    
multi_diez22:
    beq $t8, $zero, uno2       # Salta a 'uno2' si el valor en $t8 es igual a cero
    beq $t8, $s0, diez2       # Salta a 'diez2' si el valor en $t8 es igual al valor en $s0
    move $t5, $t8              # Mueve el valor en $t8 a $t5
    addi $t4, $zero, 0        # Establece el valor de $t4 en 0
    addi $t1, $zero, 10       # Carga el valor 10 en $t1
    addi $t2, $zero, 10       # Carga el valor 10 en $t2

loopnum2:
   beq $t5, $s0, fin          # Salta a 'fin' si el valor en $t5 es igual al valor en $s0
   jal multi_diezv22          # Salta y llama a la etiqueta 'multi_diezv22'
   loop_s2:
   addi $t5, $t5, -1          # Decrementa el valor en $t5 en 1
   beq $t5, $s0, multi2       # Salta a 'multi2' si el valor en $t5 es igual al valor en $s0
   move $t1, $t4              # Mueve el valor en $t4 a $t1
   addi $t4, $zero, 0         # Establece el valor de $t4 en 0
   j loopnum2                 # Salta a 'loopnum2'

multi_diezv22:
    li $t3, 0                  # Carga el valor 0 en $t3
    addi $t2, $zero, 10        # Carga el valor 10 en $t2

loop22:
    beq $t3, $t2, loop_s2      # Salta a 'loop_s2' si el valor en $t3 es igual al valor en $t2
    add $t4, $t4, $t1          # Suma el valor en $t1 al valor en $t4 y guarda el resultado en $t4
    addi $t3, $t3, 1           # Incrementa el valor en $t3 en 1
    j loop22                   # Salta de vuelta al inicio del bucle

    
uno2:
	addi $t4, $zero, 1     # Establece el valor de $t4 en 1
	j multi2               # Salta a 'multi2'

diez2:
	addi $t4, $zero, 10    # Establece el valor de $t4 en 10
	j multi2               # Salta a 'multi2'

multi2:
	move $t1, $t4          # Mueve el valor en $t4 a $t1
	move $t2, $t0          # Mueve el valor en $t0 a $t2
	li $t3, 0              # Carga el valor 0 en $t3
	li $t4, 0              # Carga el valor 0 en $t4

	loop_3_2:
	beq $t3, $t2, done2    # Salta a 'done2' si el valor en $t3 es igual al valor en $t2
    	add $t4, $t4, $t1    # Suma el valor en $t1 al valor en $t4 y guarda el resultado en $t4
    	addi $t3, $t3, 1     # Incrementa el valor en $t3 en 1
    	j loop_3_2            # Salta de vuelta al inicio del bucle

done2:
	add $t9, $t9, $t4     # Suma el valor en $t4 al valor en $t9 y guarda el resultado en $t9
	addi $t8, $t8, 1      # Incrementa el valor en $t8 en 1
	addi $t6, $t6, 4      # Incrementa el valor en $t6 en 4
	j convertir_numero2   # Salta a 'convertir_numero2'

	
movernumero2:
	move $s6, $t9        # Mueve el valor en $t9 a $s6
	j pedir_opcion       # Salta a 'pedir_opcion'
#PEDIR LA OPCION A REALIZAR-------------------------------------------------------------------------
pedir_opcion:
    # Imprimir mensaje de selección
    li $v0, 4                  # Cargar el código de la operación de impresión (4) en $v0
    la $a0, mensaje            # Cargar la dirección de memoria del mensaje en $a0
    syscall                    # Realizar la llamada al sistema para imprimir el mensaje
    
    # Recibir el valor por la consola
    li $v0, 5                  # Cargar el código de la operación de lectura (5) en $v0
    syscall                    # Realizar la llamada al sistema para leer el valor ingresado
    
    # Mover el valor de la entrada a $t0
    move $t0, $v0              # Mover el valor ingresado desde $v0 a $t0
    
    # Preguntar la opción realizada
    beq $t0, 1, suma           # Salta a 'suma' si el valor en $t0 es igual a 1
    beq $t0, 2, resta          # Salta a 'resta' si el valor en $t0 es igual a 2
    beq $t0, 3, multiplicacion # Salta a 'multiplicacion' si el valor en $t0 es igual a 3
    beq $t0, 4, division

suma:
	add $t1, $s7, $s6   # Suma el valor en $s7 al valor en $s6 y guarda el resultado en $t1
	
	li $v0, 4                       # Cargar el código de la operación de impresión (4) en $v0
	la $a0, resultado               # Cargar la dirección de memoria de 'resultado' en $a0
	syscall                         # Realizar la llamada al sistema para imprimir

	li $v0, 1                       # Cargar el código de la operación de impresión (4) en $v0
	move $a0, $t1              # Cargar la dirección de memoria de 'resultado' en $a0
	syscall                         # Realizar la llamada al sistema para imprimir

	j reset2            # Salta a 'reset2'

resta:
	sub $t1, $s7, $s6   # Resta el valor en $s6 al valor en $s7 y guarda el resultado en $t1
	
	li $v0, 4                       # Cargar el código de la operación de impresión (4) en $v0
	la $a0, resultado               # Cargar la dirección de memoria de 'resultado' en $a0
	syscall                         # Realizar la llamada al sistema para imprimir

	li $v0, 1                       # Cargar el código de la operación de impresión (4) en $v0
	move $a0, $t1              # Cargar la dirección de memoria de 'resultado' en $a0
	syscall                         # Realizar la llamada al sistema para imprimir
	j reset2            # Salta a 'reset2'

multiplicacion:
	move $t1, $s7       # Mueve el valor en $s7 a $t1
	move $t2, $s6       # Mueve el valor en $s6 a $t2
	li $t3, 0           # Carga el valor 0 en $t3
	li $t4, 0           # Carga el valor 0 en $t4
	j loop_multiplicacion
	
loop_multiplicacion:
    beq $t4, $t2, reset2_multi     # Salta a 'reset2_multi' si el valor en $t4 es igual al valor en $t2
    add $t3, $t3, $t1              # Suma el valor en $t1 al valor en $t3 y guarda el resultado en $t3
    addi $t4, $t4, 1               # Incrementa el valor en $t4 en 1
    j loop_multiplicacion          # Salta de vuelta al inicio del bucle
	
division:
	li $t9, 4        # Cargar el valor 4 en el registro $t9
	li $t5, 0        # Cargar el valor 0 en el registro $t5
	li $s1, 0        # Cargar el valor 0 en el registro $s1
	
	div_entera:
		slt $at, $s7, $s6   # Comparar si el valor en $s7 es menor que el valor en $s6 y guardar el resultado en $at
		bgt $at, $zero, guardar_entero   # Si el resultado de la comparación es mayor que cero (es decir, $s7 > $s6), saltar a la etiqueta 'guardar_entero'
		sub $s7, $s7, $s6   # Restar el valor en $s6 al valor en $s7 y guardar el resultado en $s7
		add $s1, $s1, 1   # Sumar 1 al valor en $s1 y guardar el resultado en $s1
		j div_entera   # Saltar de vuelta a la etiqueta 'div_entera'
		
	guardar_entero:
	move $t1, $s1   # Mover el valor en $s1 al registro $t1
	li $t8, 0   # Cargar el valor 0 en el registro $t8
	li $t2, 10   # Cargar el valor 10 en el registro $t2
	move $a0, $s1   # Mover el contenido de $s1 a $a0 
	li $v0, 1   # Código del sistema para imprimir un entero
	syscall   # Llamar al sistema para imprimir el entero en $a0
	j div_diez_entera   # Saltar a la etiqueta 'div_diez_entera'

	
	div_decimal_multi:
	li $s3, 0         # Cargar el valor 0 en el registro $s3
	div_decimal:
		beq $t5, $t9, guardar_Vdecimal   # Si $t5 es igual a $t9, saltar a la etiqueta 'guardar_Vdecimal'
		slt $at, $s7, $s6   # Comparar si el valor en $s7 es menor que el valor en $s6 y guardar el resultado en $at
		bgt $at, $zero, multi_div   # Si el resultado de la comparación es mayor que cero (es decir, $s7 > $s6), saltar a la etiqueta 'multi_div'
		sub $s7, $s7, $s6   # Restar el valor en $s6 al valor en $s7 y guardar el resultado en $s7
		addi $s3, $s3, 1   # Sumar 1 al valor en $s3 y guardar el resultado en $s3
		j div_decimal   # Saltar de vuelta a la etiqueta 'div_decimal'
	
multi_div:
	li $s0, 10   # Cargar el valor 10 en el registro $s0
	li $s1, 0   # Cargar el valor 0 en el registro $s1
	li $s2, 0   # Cargar el valor 0 en el registro $s2
	add $t5, $t5, 1   # Sumar 1 al valor en $t5 y guardar el resultado en $t5
	loop_multi_div:
		beq $s0, $zero, move_div_multi   # Si $s0 es igual a cero, saltar a la etiqueta 'move_div_multi'
		add $s1, $s1, $s7   # Sumar el valor en $s7 al valor en $s1 y guardar el resultado en $s1
		add $s2, $s2, $s3   # Sumar el valor en $s3 al valor en $s2 y guardar el resultado en $s2
		sub $s0, $s0, 1   # Restar 1 al valor en $s0 y guardar el resultado en $s0
		j loop_multi_div   # Saltar de vuelta a la etiqueta 'loop_multi_div'
	
	move_div_multi:
		move $s7, $s1   # Mover el valor en $s1 al registro $s7
		move $s3, $s2   # Mover el valor en $s2 al registro $s3
		j div_decimal   # Saltar a la etiqueta 'div_decimal'


guardar_Vdecimal:
	move $t1, $s3   # Mover el valor en $s3 al registro $t1
	li $t8, 0   # Cargar el valor 0 en el registro $t8
	li $t2, 10   # Cargar el valor 10 en el registro $t2
	move $a0, $s3   # Mover el contenido de $s3 a $a0 
	li $v0, 1   # Código del sistema para imprimir un entero
	syscall   # Llamar al sistema para imprimir el entero en $a0
	j div_diez_decimal   # Saltar a la etiqueta 'div_diez_decimal'

	
		
#guardar valores del entero		
div_diez_entera:
	move $t6, $t1   # Mueve el contenido de $t1 a $t6
	li $t7, 0      # Carga el valor 0 en $t7

loop_divdiez_entera:
	slt $t3, $t1, $t2   # Establece $t3 a 1 si $t1 es menor que $t2, de lo contrario 0
	bgt $t3, $zero, guardar2_entera   # Salta a guardar2 si $t3 es mayor que 0 (es decir, si $t1 es mayor que $t2)
	slt $t3, $t6, $t2   # Establece $t3 a 1 si $t6 es menor que $t2, de lo contrario 0
	bgt $t3, $zero, guardar_entera   # Salta a guardar si $t3 es mayor que 0 (es decir, si $t6 es mayor que $t2)
	sub $t6, $t6, 10   # Resta 10 de $t6
	addi $t7, $t7, 1   # Incrementa $t7 en 1
	j loop_divdiez_entera   # Salta a loop_divdiez

guardar_entera:
	sw $t6, 0x100100e0($t8)   # Almacena el valor de $t6 en la dirección de memoria 0x100100e0 + $t8
	
	move $t1, $t7   # Mueve el contenido de $t7 a $t1
	li $t7, 0   # Carga el valor 0 en $t7
	add $t8, $t8, 4   # Suma 4 a $t8 
	j div_diez_entera   # Salta a div_diez

guardar2_entera:
	sw $t6, 0x100100e0($t8)   # Almacena el valor de $t6 en la dirección de memoria 0x100100e0 + $t8

	li $v0, 4   # Código del sistema para imprimir una cadena
	la $a0, coma   # Carga la dirección de memoria de la cadena "cierre" en $a0
	syscall   # Llama al sistema para imprimir la cadena en $a0

	j div_decimal_multi   # Salta a fin
	
	
	
#guardar valores decimales---------------------------------
	
div_diez_decimal:
	move $t6, $t1   # Mueve el contenido de $t1 a $t6
	li $t7, 0      # Carga el valor 0 en $t7

loop_divdiez_decimal:
	slt $t3, $t1, $t2   # Establece $t3 a 1 si $t1 es menor que $t2, de lo contrario 0
	bgt $t3, $zero, guardar2_decimal   # Salta a guardar2 si $t3 es mayor que 0 (es decir, si $t1 es mayor que $t2)
	slt $t3, $t6, $t2   # Establece $t3 a 1 si $t6 es menor que $t2, de lo contrario 0
	bgt $t3, $zero, guardar_decimal  # Salta a guardar si $t3 es mayor que 0 (es decir, si $t6 es mayor que $t2)
	sub $t6, $t6, 10   # Resta 10 de $t6
	addi $t7, $t7, 1   # Incrementa $t7 en 1
	j loop_divdiez_decimal   # Salta a loop_divdiez

guardar_decimal:
	sw $t6, 0x10010100($t8)   # Almacena el valor de $t6 en la dirección de memoria 0x10010100 + $t8
	
	move $t1, $t7   # Mueve el contenido de $t7 a $t1
	li $t7, 0   # Carga el valor 0 en $t7
	add $t8, $t8, 4   # Suma 4 a $t8 
	j div_diez_decimal   # Salta a div_diez

guardar2_decimal:
	sw $t6, 0x10010100($t8)   # Almacena el valor de $t6 en la dirección de memoria 0x10010100 + $t8
	j fin   # Salta a fin

    


reset2:
	li $t8, 0                       # Carga el valor 0 en $t8
	li $t2, 10                      # Carga el valor 10 en $t2
	j div_diez                      # Salta a 'div_diez'

reset2_multi:
	move $t1, $t3                   # Mueve el valor en $t3 a $t1
	
	li $v0, 4                       # Cargar el código de la operación de impresión (4) en $v0
	la $a0, resultado               # Cargar la dirección de memoria de 'resultado' en $a0
	syscall                         # Realizar la llamada al sistema para imprimir

	li $v0, 1                       # Cargar el código de la operación de impresión (4) en $v0
	move $a0, $t1              # Cargar la dirección de memoria de 'resultado' en $a0
	syscall                         # Realizar la llamada al sistema para imprimir
	
	li $t8, 0                       # Carga el valor 0 en $t8
	li $t2, 10                      # Carga el valor 10 en $t2
	j div_diez                      # Salta a 'div_diez'

div_diez:
	move $t6, $t1   # Mueve el contenido de $t1 a $t6
	li $t7, 0      # Carga el valor 0 en $t7

loop_divdiez:
	slt $t3, $t1, $t2   # Establece $t3 a 1 si $t1 es menor que $t2, de lo contrario 0
	bgt $t3, $zero, guardar2   # Salta a guardar2 si $t3 es mayor que 0 (es decir, si $t1 es mayor que $t2)
	slt $t3, $t6, $t2   # Establece $t3 a 1 si $t6 es menor que $t2, de lo contrario 0
	bgt $t3, $zero, guardar   # Salta a guardar si $t3 es mayor que 0 (es decir, si $t6 es mayor que $t2)
	sub $t6, $t6, 10   # Resta 10 de $t6
	addi $t7, $t7, 1   # Incrementa $t7 en 1
	j loop_divdiez   # Salta a loop_divdiez

guardar:
	sw $t6, 0x100100e0($t8)   # Almacena el valor de $t6 en la dirección de memoria 0x100100e0 + $t8

	move $t1, $t7   # Mueve el contenido de $t7 a $t1
	li $t7, 0   # Carga el valor 0 en $t7
	add $t8, $t8, 4   # Suma 4 a $t8 
	j div_diez   # Salta a div_diez

guardar2:
	sw $t6, 0x100100e0($t8)   # Almacena el valor de $t6 en la dirección de memoria 0x100100e0 + $t8
	j fin   # Salta a fin


			
fin:
	
	li $v0, 10  # Código del sistema para terminar el programa
       syscall # Llama al sistema para terminar el programa
	


	
	
    
    
    
