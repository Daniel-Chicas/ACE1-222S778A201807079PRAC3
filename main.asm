include macros.asm 
.MODEL LARGE 
.386
.STACK 

;*************************************************************** DECLARACION DE VARIABLES ***************************************************************************
.DATA
;**GENERALES
	encabezadoP1 db 0ah, 0ah, 'UNIVERSIDAD DE SAN CARLOS DE GUATEMALA', 10, 'FACULTAD DE INGENIERIA', 10,13, 'ESCUELA DE CIENCIAS Y SISTEMAS', 10,13, 'ARQUITECTURA DE COMPUTADORES Y ENSAMBLADORES 1', 10, 13, 'SECCION: A', '$'
	encabezadoP2 db 0ah, 'NOMBRE: Daniel Estuardo Chicas Carias', 10,13, 'CARNET: 201807079', 10,13, 10,13, '$' 
	menuOpciones db 0ah, '========== MENU PRINCIPAL ==========', 10,13,'1) Iniciar Juego    :D', 10,13,'2) Cargar Partida   :o', 10,13,'3) Salir            :c', 10,13,10,13,'>','$' 
	insertar db 0ah, "> Inserte la posicion para ingresar la pieza: ", "$"

	pruebacarga db 0ah, "CARGA", "$"
	pruebasalir db 0ah, "SALIR", "$" 



;**BANDERAS
	barcosJ1agregados db '0', '$'
	barcosJ2agregados db '0', '$' 

;**ETIQUETAS DE FILAS Y COLUMNAS
	msg_nvo db 0ah, 0dh, '********** NUEVO JUEGO **********', 10,13, '$' ;10, TEMPORAL
	msgBarcos1 db 0ah, 0dh, '>>>>>>>>>>>>>>> AGREGAR BARCOS DEL JUGADOR #1 <<<<<<<<<<<<<<<', 10,13, '$'
	msgBarcos2 db 0ah, 0dh, '>>>>>>>>>>>>>>> AGREGAR BARCOS DEL JUGADOR #2 <<<<<<<<<<<<<<<', 10,13, '$'
						  
	y1 db ' 1  |', '$'
	y2 db ' 2  |', '$'
	y3 db ' 3  |', '$'
	y4 db ' 4  |', '$'
	y5 db ' 5  |', '$'
	y6 db ' 6  |', '$'
	y7 db ' 7  |', '$'
	y8 db ' 8  |', '$'
	y9 db ' 9  |', '$'
	y10 db ' 10 |', '$'
	xcord db 0ah, 0dh, 32,32,32,32,32, ' J     I    H    G    F    E    D    C    B    A', 10,13,'$'

;**FICHAS DEL JUEGO 
	fichaX db  ' X  |', '$'
	fichaO db  ' O  |', '$' 


	B1 db  ' 1  |', '$'
	B2 db  ' 2  |', '$'
	B3 db  ' 3  |', '$'
	B4 db  ' 4  |', '$'
	B5 db  ' 5  |', '$'

	vc db '    |', '$'
	vcB db ' | ', '$'
;**ETIQUETAS DE PARTIDA
	ln db '------------------------------------', 10,13, '$'
	empieza1 db 0ah, 0dh, 'Empieza el jugador 1', 10,13, '$'
	empieza2 db 0ah, 0dh, 'Empieza el jugador 2', 10,13, '$'
	inicioJuego	db 0ah, 0dh, '>>>>>>>>>>>>>>> INICIO DE PARTIDA <<<<<<<<<<<<<<<', 10,13, '$'
	validarAtaque db 0ah, 0dh, '----> Desea Confirmar Ataque? (1: SI / 0: NO)', 10,13, '$'

	tableroSuperior db 0ah, 0dh, '-> MOSTRANDO TABLERO SUPERIOR', 10,13, '$'
	tableroInferior db 0ah, 0dh, '-> TABLERO INFERIOR', 10,13, '$'
	turno1 db 0ah, 0dh, ' > Turno Jugador 1: ', '$'
	turno2 db 0ah, 0dh, ' > Turno Jugador 2: ', '$'
	saltoLinea db 0ah, 0dh, '$' 



;**MANEJO PARA EL INGRESO DE BARCOS
	barcosDisponibles1 db 001b, 010b, 011b, 100b, 101b
	barcosDisponibles2 db 001b, 010b, 011b, 100b, 101b
	bd2 db 001b, 010b, 011b, 100b, 101b

	boteNeumatico db '    1. Bote Neumatico       (2 celdas)', '$'
	destructorAmericano db '    2. Destructor Americano (3 celdas)', '$'
	destructorJapones db '    3. Destructor Japones   (3 celdas)', '$'
	acorazado db '    4. Acorazado            (4 celdas)', '$'
	portaAviones db '    5. Portaviones          (5 celdas)', '$'
	barcosFaltan db 0ah, 0dh, 'Falta Agregar los barcos: ', '$'
	barcoID db 0ah, 0dh, ' --> ID DEL BARCO: ', '$'
	msgdireccionBarco db 0ah, 0dh, 'DIRECCION DEL BARCO (1 = HORIZONTAL / 0 = VERTICAL): ', '$'
	confirmacionBarcos db 0ah, 0dh, '      <<< BARCOS AGREGADOS CORRECTAMENTE (PRESIONE ENTER PARA CONTINUAR) >>> ', 10, 13, '$'
									 
	BNS db '    Bote Neumatico', '$'
	DAS2 db '    Destructor Americano', '$'
	DJS db '    Destructor Japones', '$'
	ACS db '    Acorazado', '$'
	PAS db '    Portaviones', '$'
	msgSel db 0ah, 0dh, '###### Barco Seleccionado ######', '$'

	datosBarco db 0ah, 0dh, 'DATOS PARA COLOCAR EL BARCO: ', '$'
	filaPosicionBarco db 0ah, 0dh, '      Fila: ', '$'
	columnaPosicionBarco db 0ah, 0dh, '      Columna: ', '$'

	datosAtacar db 0ah, 0dh, 'DATOS PARA ATACAR: ', '$'
	msgfilaAtaque db 0ah, 0dh, '      Fila: ', '$'
	msgcolumnaAtaque db 0ah, 0dh, '      Columna: ', '$'


;********** TABLEROS DE JUGADOR 1 Y 2 
;*000b->VAIO 	001b->FX 	100b->FO
	barcos20J2 db 000b, 000b, 000b, 000b, 000b, 000b, 000b, 000b, 000b, 000b
	barcos19J2 db 000b, 000b, 000b, 000b, 000b, 000b, 000b, 000b, 000b, 000b
	barcos18J2 db 000b, 000b, 000b, 000b, 000b, 000b, 000b, 000b, 000b, 000b
	barcos17J2 db 000b, 000b, 000b, 000b, 000b, 000b, 000b, 000b, 000b, 000b
	barcos16J2 db 000b, 000b, 000b, 000b, 000b, 000b, 000b, 000b, 000b, 000b
	barcos15J2 db 000b, 000b, 000b, 000b, 000b, 000b, 000b, 000b, 000b, 000b
	barcos14J2 db 000b, 000b, 000b, 000b, 000b, 000b, 000b, 000b, 000b, 000b
	barcos13J2 db 000b, 000b, 000b, 000b, 000b, 000b, 000b, 000b, 000b, 000b
	barcos12J2 db 000b, 000b, 000b, 000b, 000b, 000b, 000b, 000b, 000b, 000b
	barcos11J2 db 000b, 000b, 000b, 000b, 000b, 000b, 000b, 000b, 000b, 000b
	;				j	  i		h	 g	   f	 e	   d	  c	    b	  a
	
	barcos20J1 db 000b, 000b, 000b, 000b, 000b, 000b, 000b, 000b, 000b, 000b
	barcos19J1 db 000b, 000b, 000b, 000b, 000b, 000b, 000b, 000b, 000b, 000b
	barcos18J1 db 000b, 000b, 000b, 000b, 000b, 000b, 000b, 000b, 000b, 000b
	barcos17J1 db 000b, 000b, 000b, 000b, 000b, 000b, 000b, 000b, 000b, 000b
	barcos16J1 db 000b, 000b, 000b, 000b, 000b, 000b, 000b, 000b, 000b, 000b
	barcos15J1 db 000b, 000b, 000b, 000b, 000b, 000b, 000b, 000b, 000b, 000b
	barcos14J1 db 000b, 000b, 000b, 000b, 000b, 000b, 000b, 000b, 000b, 000b
	barcos13J1 db 000b, 000b, 000b, 000b, 000b, 000b, 000b, 000b, 000b, 000b
	barcos12J1 db 000b, 000b, 000b, 000b, 000b, 000b, 000b, 000b, 000b, 000b
	barcos11J1 db 000b, 000b, 000b, 000b, 000b, 000b, 000b, 000b, 000b, 000b


	disparos10J2 db 000b, 000b, 000b, 000b, 000b, 000b, 000b, 000b, 000b, 000b
	disparos9J2 db 000b, 000b, 000b, 000b, 000b, 000b, 000b, 000b, 000b, 000b
	disparos8J2 db 000b, 000b, 000b, 000b, 000b, 000b, 000b, 000b, 000b, 000b
	disparos7J2 db 000b, 000b, 000b, 000b, 000b, 000b, 000b, 000b, 000b, 000b
	disparos6J2 db 000b, 000b, 000b, 000b, 000b, 000b, 000b, 000b, 000b, 000b
	disparos5J2 db 000b, 000b, 000b, 000b, 000b, 000b, 000b, 000b, 000b, 000b
	disparos4J2 db 000b, 000b, 000b, 000b, 000b, 000b, 000b, 000b, 000b, 000b
	disparos3J2 db 000b, 000b, 000b, 000b, 000b, 000b, 000b, 000b, 000b, 000b
	disparos2J2 db 000b, 000b, 000b, 000b, 000b, 000b, 000b, 000b, 000b, 000b
	disparos1J2 db 000b, 000b, 000b, 000b, 000b, 000b, 000b, 000b, 000b, 000b


	disparos10J1 db 000b, 000b, 000b, 000b, 000b, 000b, 000b, 000b, 000b, 000b
	disparos9J1 db 000b, 000b, 000b, 000b, 000b, 000b, 000b, 000b, 000b, 000b
	disparos8J1 db 000b, 000b, 000b, 000b, 000b, 000b, 000b, 000b, 000b, 000b
	disparos7J1 db 000b, 000b, 000b, 000b, 000b, 000b, 000b, 000b, 000b, 000b
	disparos6J1 db 000b, 000b, 000b, 000b, 000b, 000b, 000b, 000b, 000b, 000b
	disparos5J1 db 000b, 000b, 000b, 000b, 000b, 000b, 000b, 000b, 000b, 000b
	disparos4J1 db 000b, 000b, 000b, 000b, 000b, 000b, 000b, 000b, 000b, 000b
	disparos3J1 db 000b, 000b, 000b, 000b, 000b, 000b, 000b, 000b, 000b, 000b
	disparos2J1 db 000b, 000b, 000b, 000b, 000b, 000b, 000b, 000b, 000b, 000b
	disparos1J1 db 000b, 000b, 000b, 000b, 000b, 000b, 000b, 000b, 000b, 000b
	

	fi20 db 000b, 000b, 000b, 000b, 000b, 000b, 000b, 000b, 000b, 000b
	fi19 db 000b, 000b, 000b, 000b, 000b, 000b, 000b, 000b, 000b, 000b
	fi18 db 000b, 000b, 000b, 000b, 000b, 000b, 000b, 000b, 000b, 000b
	fi17 db 000b, 000b, 000b, 000b, 000b, 000b, 000b, 000b, 000b, 000b
	fi16 db 000b, 000b, 000b, 000b, 000b, 000b, 000b, 000b, 000b, 000b
	fi15 db 000b, 000b, 000b, 000b, 000b, 000b, 000b, 000b, 000b, 000b
	fi14 db 000b, 000b, 000b, 000b, 000b, 000b, 000b, 000b, 000b, 000b
	fi13 db 000b, 000b, 000b, 000b, 000b, 000b, 000b, 000b, 000b, 000b
	fi12 db 000b, 000b, 000b, 000b, 000b, 000b, 000b, 000b, 000b, 000b
	fi11 db 000b, 000b, 000b, 000b, 000b, 000b, 000b, 000b, 000b, 000b

	fi10 db 000b, 000b, 000b, 000b, 000b, 000b, 000b, 000b, 000b, 000b
	fi9 db 000b, 000b, 000b, 000b, 000b, 000b, 000b, 000b, 000b, 000b
	fi8 db 000b, 000b, 000b, 000b, 000b, 000b, 000b, 000b, 000b, 000b
	fi7 db 000b, 000b, 000b, 000b, 000b, 000b, 000b, 000b, 000b, 000b
	fi6 db 000b, 000b, 000b, 000b, 000b, 000b, 000b, 000b, 000b, 000b
	fi5 db 000b, 000b, 000b, 000b, 000b, 000b, 000b, 000b, 000b, 000b
	fi4 db 000b, 000b, 000b, 000b, 000b, 000b, 000b, 000b, 000b, 000b
	fi3 db 000b, 000b, 000b, 000b, 000b, 000b, 000b, 000b, 000b, 000b
	fi2 db 000b, 000b, 000b, 000b, 000b, 000b, 000b, 000b, 000b, 000b
	fi1 db 000b, 000b, 000b, 000b, 000b, 000b, 000b, 000b, 000b, 000b

;*VARIABLES DEL JUEGO
	turno db 0b
	f1 db 1 dup('$') 
	pos1 db 0b   

	filaBarco db 0b, '$'
	columnaBarco db 0b, '$'
	posicionXBarco db 0b, '$'

	filaAtaque db 0b, '$'
	columnaAtaque db 0b, '$'
	posicionXAtaque db 0b, '$'
	confAtaque db 0b, '$'
	
	idBarco db 0b, '$'
	direccionBarco db 0b, '$'
	
	posPin1 db 0b, '$'
	posPin2 db 0b, '$'
	posPin3 db 0b, '$'
	posPin4 db 0b, '$' 
	contador db '0', '$'
  

	separadorPC db ';'
	separadorComa db ',' 
	tipoCoord db 0b 
	division db '------------------------------------------------------------------', '$'    
	msg_errorC db '-- Atencion, Coordenadas Erroneas --', 10,13, '$'
	msg_PosOcupada db 0ah,0dh,'-------- Esta ficha ya fue ocupada por el contrincante --------','$'
	ganaJugador2 db 0ah,0dh,'>>>>>>>>>>>>>> Gana el Jugador 2 ','$'
	ganaJugador1 db 0ah,0dh,'>>>>>>>>>>>>>> Gana el Jugador 1','$'
	msgSalida db 0ah,0dh,'>>>>>>>>>>>>>> INGRESE EL COMANDO EXIT PARA SALIR ','$'

	msg_finalJuego db 0ah,0dh,'-------- El juego ha finalizado :D --------','$'

	barcosSobrevivientes db 0ah, 0dh, '--> Barcos disponibles: ', '$'
	barcosRivales db 0ah, 0dh, '--> Barcos rivales: ', '$'
	
	datosJugador1 db 0ah, 0dh, '--> Datos del Jugador 1: ', '$'
	datosJugador2 db 0ah, 0dh, '--> Datos del Jugador 2: ', '$'

	disparosRealizados db 0ah, 0dh, '       Disparos realizados: ', '$'
	disparosAcertados db 0ah, 0dh, '        Disparos acertados: ', '$'
	disparosFallidos db 0ah, 0dh, '         Disparos fallidos: ', '$'

	contadorBarcosPropios db 0d, '$'
	unidadTotalesJ1 db 0d, '$'
	decenaTotalesJ1 db 0d, '$'
	unidadImpactadosJ1 db 0d, '$'
	decenaImpactadosJ1 db 0d, '$'
	unidadFalladosJ1 db 0d, '$'
	decenaFalladosJ1 db 0d, '$'
	
	contadorBarcosRivales db 0d, '$' 
	unidadTotalesJ2 db 0d, '$'
	decenaTotalesJ2 db 0d, '$'
	unidadImpactadosJ2 db 0d, '$'
	decenaImpactadosJ2 db 0d, '$'
	unidadFalladosJ2 db 0d, '$'
	decenaFalladosJ2 db 0d, '$'
	auxNum db '0', '$'
 
	juga1 db 0ah, 0dh, 'Jugador1', 10, 13
	juga2 db 0ah, 0dh, 'Jugador2', 10, 13

;*VARIABLES FICHERO
	guion db '-'
	bufferHora db 8 dup('0')
	bufferFecha db 8 dup('0')
	rutaArchivo db 100 dup('$')
	bufferLectura db 200 dup('$')
	bufferEscritura db 200 dup('$')
	rutaNomHtml db 'SHOWHTM.htm', 00h
	handleFichero dw ?
	msmError1 db 0ah,0dh,'Error al abrir archivo','$' 
	msmError2 db 0ah,0dh,'Error al leer archivo','$'
	msmError3 db 0ah,0dh,'Error al crear archivo','$'
	msmError4 db 0ah,0dh,'Error al Escribir archivo','$'
	msg_errorOcupado db 0ah,0dh,'-------- EL BARCO NO CABE EN LA POSICION INDICADA --------','$'
	msg_yadisparo db 0ah,0dh,'-------- YA DISPARASTE EN ESTA POSICION --------','$'

;*VARIABLES DE CARGA DEL JUEGO
	char0 db 	'0'
	char1 db 	'1'
	char2 db 	'2'
	char3 db 	'3'
	char4 db 	'4'
	char5 db 	'5'
	
	charX db 	'X'
	charO db 	'O'
	
;*VARIABLES COMANDOS
	comandoFila1 db '1','$'
	comandoFila2 db '2','$'
	comandoFila3 db '3','$'
	comandoFila4 db '4','$'
	comandoFila5 db '5','$'
	comandoFila6 db '6','$'
	comandoFila7 db '7','$'
	comandoFila8 db '8','$'
	comandoFila9 db '9','$'
	comandoFila10 db '10','$'

	comandoExit db 'SALIR','$'
	comandoSave db 'GUARDAR','$'
	comandoShow db 'SHOWHTM', '$' 

	extension db '.arq', '$'
	msg_salir db 0ah, 0dh, '-------- PARTIDA FINALIZADA --------', '$'

	msg_guardar db 0ah, 0dh, '-------- GUARDANDO PARTIDA --------', 10,13,'$'
	cinNomArch db 0ah, 0dh, '>Ingrese nombre para guardar: ', '$'
	msg_guardad db 0ah, 0dh, '-------- Partida Guardada Con Exito --------', '$'

	msg_generar db 0ah, 0dh, '-------- GENERANDO ARCHIVO --------', 10,13,'$'
	infoNomArch db 0ah, 0dh, '>Nombre archivo: SHOWHTM.htm', '$'
	msg_general db 0ah, 0dh, '--- Archivo Creado Con Exito ---', 10,13, '$'

;*HTML
	inicioHtml db '<html>', 10,13, '<head>', 10,13,9, '<title>201807079</title>', 10,13, '</head>', 10,13, '<body bgcolor=#A9A9A9>', 10,13,9, '<H1 align="center">', 00h ;20D08C;FED7CE
	cierreH1 db '</H1>', 10,13, 00h
	inicioTabla db 9, '<center>', 10,13, '<table border=0 cellspacing=2 cellpadding=2>', 10,13, 00h ; bgcolor=#005b96
	tr db 9,9, '<tr align=center>', 00h
	ctr db 0ah, 0dh, 9,9, '</tr>', 10,13, 00h
	finHtml db 9, '</table>', 10,13, '</center>', 10,13, '</body>', 10,13, '</html>', 00h
	fichaXH db 0ah, 0dh, 9, '		<td bgcolor="cadetblue">X</td>', 00h
	fichaOH db 0ah, 0dh, 9, '		<td bgcolor="burlywood">O</td>', 00h
	
	ficha1H db 0ah, 0dh, 9, '		<td bgcolor="blue">1</td>', 00h
	ficha2H db 0ah, 0dh, 9, '		<td bgcolor="rellow">2</td>', 00h
	ficha3H db 0ah, 0dh, 9, '		<td bgcolor="red">3</td>', 00h
	ficha4H db 0ah, 0dh, 9, '		<td bgcolor="orange">4</td>', 00h
	ficha5H db 0ah, 0dh, 9, '		<td bgcolor="grey">5</td>', 00h

	VacioB db 0ah, 0dh, 9, '		<td bgcolor="white" width=47px; height=125px;> </td>', 00h
	VacioN db 0ah, 0dh, 9, '		<td bgcolor="brown" width=47px; height=125px;> </td>', 00h



;***************************************************************** DECLARACION DE CODIGO ****************************************************************************

.code
main proc
	Inicio:
		mov dx, @data
		mov ds, dx
		print encabezadoP1
		print encabezadoP2
		getChar
		cmp al, 13
		jne Inicio
		je MenuPrincipal

	MenuPrincipal:
		print menuOpciones 
		getChar
		cmp al, '1'
		je NUEVO
		cmp al, '2'
		je CARGAR
		cmp al, '3'
		je SALIR 
		jne MenuPrincipal
	SAVE:
		print msg_guardar
		print cinNomArch
		Ruta rutaArchivo
		crearArchivo rutaArchivo,handleFichero
		abrirArchivo rutaArchivo,handleFichero  
 
		imprimirArq SIZEOF barcos11J1, separadorComa, separadorPC, barcos11J1, char0, char1, char2, char3, char4, char5, charX, charO, handleFichero
		imprimirArq SIZEOF barcos12J1, separadorComa, separadorPC, barcos12J1, char0, char1, char2, char3, char4, char5, charX, charO, handleFichero
		imprimirArq SIZEOF barcos13J1, separadorComa, separadorPC, barcos13J1, char0, char1, char2, char3, char4, char5, charX, charO, handleFichero
		imprimirArq SIZEOF barcos14J1, separadorComa, separadorPC, barcos14J1, char0, char1, char2, char3, char4, char5, charX, charO, handleFichero
		imprimirArq SIZEOF barcos15J1, separadorComa, separadorPC, barcos15J1, char0, char1, char2, char3, char4, char5, charX, charO, handleFichero
		imprimirArq SIZEOF barcos16J1, separadorComa, separadorPC, barcos16J1, char0, char1, char2, char3, char4, char5, charX, charO, handleFichero
		imprimirArq SIZEOF barcos17J1, separadorComa, separadorPC, barcos17J1, char0, char1, char2, char3, char4, char5, charX, charO, handleFichero
		imprimirArq SIZEOF barcos18J1, separadorComa, separadorPC, barcos18J1, char0, char1, char2, char3, char4, char5, charX, charO, handleFichero
		imprimirArq SIZEOF barcos19J1, separadorComa, separadorPC, barcos19J1, char0, char1, char2, char3, char4, char5, charX, charO, handleFichero 
		imprimirArq SIZEOF barcos20J1, separadorComa, separadorPC, barcos20J1, char0, char1, char2, char3, char4, char5, charX, charO, handleFichero
 

		cerrarArchivo handleFichero
		print msg_guardad 
		getChar

		mov bufferLectura, '$'
		print bufferLectura
		cmp turno, '1'
		je JUG1
		cmp turno, '2'
		je JUG2 

	SHOW:
		cmp turno, '1'
		je SHOW1
		cmp turno, '2'
		je SHOW2

	SHOW1:
		
		print msg_generar
		print infoNomArch
		crearArchivo rutaNomHtml,handleFichero
		abrirArchivo rutaNomHtml,handleFichero 
		escribirArchivo SIZEOF inicioHtml, inicioHtml, handleFichero
		fecha
		hora
		escribirArchivo SIZEOF bufferFecha, bufferFecha, handleFichero
		escribirArchivo SIZEOF guion, guion, handleFichero
		escribirArchivo SIZEOF bufferHora, bufferHora, handleFichero
		escribirArchivo SIZEOF cierreH1, cierreH1, handleFichero
		escribirArchivo SIZEOF inicioTabla, inicioTabla, handleFichero 

		imprimirHtml SIZEOF disparos1J1, fichaXH, FICHAOH, disparos1J1, VacioB, VacioN, tr, ctr, ficha1H, ficha2H, ficha3H, ficha4H, ficha5H, handleFichero
		imprimirHtml SIZEOF disparos2J1, fichaXH, FICHAOH, disparos2J1, VacioB, VacioN, tr, ctr, ficha1H, ficha2H, ficha3H, ficha4H, ficha5H, handleFichero
		imprimirHtml SIZEOF disparos3J1, fichaXH, FICHAOH, disparos3J1, VacioB, VacioN, tr, ctr, ficha1H, ficha2H, ficha3H, ficha4H, ficha5H, handleFichero
		imprimirHtml SIZEOF disparos4J1, fichaXH, FICHAOH, disparos4J1, VacioB, VacioN, tr, ctr, ficha1H, ficha2H, ficha3H, ficha4H, ficha5H, handleFichero
		imprimirHtml SIZEOF disparos5J1, fichaXH, FICHAOH, disparos5J1, VacioB, VacioN, tr, ctr, ficha1H, ficha2H, ficha3H, ficha4H, ficha5H, handleFichero
		imprimirHtml SIZEOF disparos6J1, fichaXH, FICHAOH, disparos6J1, VacioB, VacioN, tr, ctr, ficha1H, ficha2H, ficha3H, ficha4H, ficha5H, handleFichero
		imprimirHtml SIZEOF disparos7J1, fichaXH, FICHAOH, disparos7J1, VacioB, VacioN, tr, ctr, ficha1H, ficha2H, ficha3H, ficha4H, ficha5H, handleFichero
		imprimirHtml SIZEOF disparos8J1, fichaXH, FICHAOH, disparos8J1, VacioB, VacioN, tr, ctr, ficha1H, ficha2H, ficha3H, ficha4H, ficha5H, handleFichero
		imprimirHtml SIZEOF disparos9J1, fichaXH, FICHAOH, disparos9J1, VacioB, VacioN, tr, ctr, ficha1H, ficha2H, ficha3H, ficha4H, ficha5H, handleFichero
		imprimirHtml SIZEOF disparos10J1, fichaXH, FICHAOH, disparos10J1, VacioB, VacioN, tr, ctr, ficha1H, ficha2H, ficha3H, ficha4H, ficha5H, handleFichero


		escribirArchivo  SIZEOF finHtml, finHtml, handleFichero
		cerrarArchivo handleFichero
		print msg_general
		cmp turno, '1'
		je JUG1
		cmp turno, '2'
		je JUG2 

	SHOW2:


		print msg_generar
		print infoNomArch
		crearArchivo rutaNomHtml,handleFichero
		abrirArchivo rutaNomHtml,handleFichero 

		escribirArchivo SIZEOF inicioHtml, inicioHtml, handleFichero
		fecha
		hora
		escribirArchivo SIZEOF bufferFecha, bufferFecha, handleFichero
		escribirArchivo SIZEOF guion, guion, handleFichero
		escribirArchivo SIZEOF bufferHora, bufferHora, handleFichero
		escribirArchivo SIZEOF cierreH1, cierreH1, handleFichero
		escribirArchivo SIZEOF inicioTabla, inicioTabla, handleFichero 
		  
		  
		imprimirHtml SIZEOF disparos1J2, fichaXH, FICHAOH, disparos1J2, VacioB, VacioN, tr, ctr, ficha1H, ficha2H, ficha3H, ficha4H, ficha5H, handleFichero
		imprimirHtml SIZEOF disparos2J2, fichaXH, FICHAOH, disparos2J2, VacioB, VacioN, tr, ctr, ficha1H, ficha2H, ficha3H, ficha4H, ficha5H, handleFichero
		imprimirHtml SIZEOF disparos3J2, fichaXH, FICHAOH, disparos3J2, VacioB, VacioN, tr, ctr, ficha1H, ficha2H, ficha3H, ficha4H, ficha5H, handleFichero
		imprimirHtml SIZEOF disparos4J2, fichaXH, FICHAOH, disparos4J2, VacioB, VacioN, tr, ctr, ficha1H, ficha2H, ficha3H, ficha4H, ficha5H, handleFichero
		imprimirHtml SIZEOF disparos5J2, fichaXH, FICHAOH, disparos5J2, VacioB, VacioN, tr, ctr, ficha1H, ficha2H, ficha3H, ficha4H, ficha5H, handleFichero
		imprimirHtml SIZEOF disparos6J2, fichaXH, FICHAOH, disparos6J2, VacioB, VacioN, tr, ctr, ficha1H, ficha2H, ficha3H, ficha4H, ficha5H, handleFichero
		imprimirHtml SIZEOF disparos7J2, fichaXH, FICHAOH, disparos7J2, VacioB, VacioN, tr, ctr, ficha1H, ficha2H, ficha3H, ficha4H, ficha5H, handleFichero
		imprimirHtml SIZEOF disparos8J2, fichaXH, FICHAOH, disparos8J2, VacioB, VacioN, tr, ctr, ficha1H, ficha2H, ficha3H, ficha4H, ficha5H, handleFichero
		imprimirHtml SIZEOF disparos9J2, fichaXH, FICHAOH, disparos9J2, VacioB, VacioN, tr, ctr, ficha1H, ficha2H, ficha3H, ficha4H, ficha5H, handleFichero
		imprimirHtml SIZEOF disparos10J2, fichaXH, FICHAOH, disparos10J2, VacioB, VacioN, tr, ctr, ficha1H, ficha2H, ficha3H, ficha4H, ficha5H, handleFichero
		
		escribirArchivo  SIZEOF finHtml, finHtml, handleFichero
		cerrarArchivo handleFichero
		print msg_general
		cmp turno, '1'
		je JUG1
		cmp turno, '2'
		je JUG2 
	
	CARGAR:
		jmp MenuPrincipal
    NUEVO:
		print msg_nvo  

		limpiar SIZEOF bd2, barcosDisponibles1, bd2
		limpiar SIZEOF bd2, barcosDisponibles2, bd2
 
		CALL ObtenerRandom 
		mov turno, dl ;Guarda el turno del jugador

		cmp turno, '1'
		je EMPIEZAJ1
		cmp turno, '2'
		je EMPIEZAJ2
 
	EMPIEZAJ1:
		print empieza1	
		print ln	
		getChar
		cmp al, 13
		jne EMPIEZAJ1
		je AGREGARBARCOSJ1
	EMPIEZAJ2:
		print empieza2
		print ln	
		getChar
		cmp al, 13
		jne EMPIEZAJ2
		je AGREGARBARCOSJ2
	AGREGARBARCOSJ1: 
		CICLOJ1:
			print msgBarcos1
			imprimirTableroInferior

			print barcosFaltan 
			imprimirBarcosDisponibles SIZEOF barcosDisponibles1, boteNeumatico, destructorAmericano, destructorJapones, acorazado, portaAviones, vcB, barcosDisponibles1, ln, saltoLinea
			print barcoID
			getChar
			mov idBarco, al 

			obtenerIdBarcoDisponible idBarco, pos1, boteNeumatico, destructorAmericano, destructorJapones, acorazado, portaAviones, vcB, barcosDisponibles1, ln, saltoLinea, msgSel, BNS, DAS2, DJS, ACS, PAS

			print msgdireccionBarco
			getChar
			mov direccionBarco, al

			print datosBarco
			print columnaPosicionBarco
			getChar
			mov columnaBarco, al

			print filaPosicionBarco
			ObtenerTexto bufferLectura
			comparacion1 comandoExit, bufferLectura
			comparacion2 comandoSave, bufferLectura
			comparacion3 comandoShow, bufferLectura
			comparacionNO1 comandoFila1, bufferLectura, filaBarco
			comparacionNO2 comandoFila2, bufferLectura, filaBarco
			comparacionNO3 comandoFila3, bufferLectura, filaBarco
			comparacionNO4 comandoFila4, bufferLectura, filaBarco
			comparacionNO5 comandoFila5, bufferLectura, filaBarco
			comparacionNO6 comandoFila6, bufferLectura, filaBarco
			comparacionNO7 comandoFila7, bufferLectura, filaBarco
			comparacionNO8 comandoFila8, bufferLectura, filaBarco
			comparacionNO9 comandoFila9, bufferLectura, filaBarco
			comparacionNO10 comandoFila10, bufferLectura, filaBarco
	
			verificarCoordenadas filaBarco, columnaBarco
			obtenerPos columnaBarco, posicionXBarco
			
			mostrarBarcosX filaBarco, posicionXBarco, idBarco, direccionBarco, barcos11J1, barcos12J1, barcos13J1, barcos14J1, barcos15J1, barcos16J1, barcos17J1, barcos18J1, barcos19J1, barcos20J1, posPin1, posPin2, posPin3, posPin4, turno 
			limpiarIDBarco pos1, barcosDisponibles1, contador
			 
			cmp contador, '5'
			jb CICLOJ1 
			POP AX
			POP SI 
		
		
		print confirmacionBarcos 
		getChar
		

		mov contador, '0'
		mov barcosJ1agregados, '1'
		mov turno, '2'
		cmp barcosJ2agregados, '0'
		je AGREGARBARCOSJ2  
		jmp MENSAJEINICIOJUEGO
	
	AGREGARBARCOSJ2:
		 
		CICLOJ2: 
			print msgBarcos2
			imprimirBarcos2

			print barcosFaltan 
			imprimirBarcosDisponibles SIZEOF barcosDisponibles2, boteNeumatico, destructorAmericano, destructorJapones, acorazado, portaAviones, vcB, barcosDisponibles2, ln, saltoLinea
			print barcoID
			getChar
			mov idBarco, al 

			obtenerIdBarcoDisponible idBarco, pos1, boteNeumatico, destructorAmericano, destructorJapones, acorazado, portaAviones, vcB, barcosDisponibles2, ln, saltoLinea, msgSel, BNS, DAS2, DJS, ACS, PAS

			print msgdireccionBarco
			getChar
			mov direccionBarco, al

			print datosBarco
			print columnaPosicionBarco
			getChar
			mov columnaBarco, al

			print filaPosicionBarco
			ObtenerTexto bufferLectura
			comparacion1 comandoExit, bufferLectura
			comparacion2 comandoSave, bufferLectura
			comparacion3 comandoShow, bufferLectura
			comparacionNO1 comandoFila1, bufferLectura, filaBarco
			comparacionNO2 comandoFila2, bufferLectura, filaBarco
			comparacionNO3 comandoFila3, bufferLectura, filaBarco
			comparacionNO4 comandoFila4, bufferLectura, filaBarco
			comparacionNO5 comandoFila5, bufferLectura, filaBarco
			comparacionNO6 comandoFila6, bufferLectura, filaBarco
			comparacionNO7 comandoFila7, bufferLectura, filaBarco
			comparacionNO8 comandoFila8, bufferLectura, filaBarco
			comparacionNO9 comandoFila9, bufferLectura, filaBarco
			comparacionNO10 comandoFila10, bufferLectura, filaBarco
	
			verificarCoordenadas filaBarco, columnaBarco
			obtenerPos columnaBarco, posicionXBarco
			
			mostrarBarcosX filaBarco, posicionXBarco, idBarco, direccionBarco, barcos11J2, barcos12J2, barcos13J2, barcos14J2, barcos15J2, barcos16J2, barcos17J2, barcos18J2, barcos19J2, barcos20J2, posPin1, posPin2, posPin3, posPin4, turno 
			limpiarIDBarco pos1, barcosDisponibles2, contador
			 
			cmp contador, '5'
			jb CICLOJ2
			POP AX
			POP SI 
			
		print confirmacionBarcos 
		getChar
		
		mov contador, '0'
		mov barcosJ2agregados, '1' 
		mov turno, '1'
		cmp barcosJ1agregados, '0'
		je AGREGARBARCOSJ1
		jmp MENSAJEINICIOJUEGO

	MENSAJEINICIOJUEGO:
		print inicioJuego
		getChar
		cmp al, 13
		jne MENSAJEINICIOJUEGO
		cmp turno, '1'
		je JUG1
		cmp turno, '2'
		je JUG2
		jmp MenuPrincipal 
	JUG1: 
		print tableroSuperior
		imprimirTableroSuperior
		
		print turno1
		print datosAtacar
		print msgcolumnaAtaque
		getChar
		mov columnaAtaque, al

		print msgfilaAtaque
		ObtenerTexto bufferLectura 
		comparacion1 comandoExit, bufferLectura
		comparacion2 comandoSave, bufferLectura
		comparacion3 comandoShow, bufferLectura
		comparacionNO1 comandoFila1, bufferLectura, filaAtaque
		comparacionNO2 comandoFila2, bufferLectura, filaAtaque
		comparacionNO3 comandoFila3, bufferLectura, filaAtaque
		comparacionNO4 comandoFila4, bufferLectura, filaAtaque
		comparacionNO5 comandoFila5, bufferLectura, filaAtaque
		comparacionNO6 comandoFila6, bufferLectura, filaAtaque
		comparacionNO7 comandoFila7, bufferLectura, filaAtaque
		comparacionNO8 comandoFila8, bufferLectura, filaAtaque
		comparacionNO9 comandoFila9, bufferLectura, filaAtaque
		comparacionNO10 comandoFila10, bufferLectura, filaAtaque

		verificarCoordenadas filaAtaque, columnaAtaque
		obtenerPos columnaAtaque, posicionXAtaque
		print validarAtaque
		getChar
		mov confAtaque, al
		cmp confAtaque, '1'
		je CONFIRMAATAQUE1
		jmp JUG1

	CONFIRMAATAQUE1: 
 
		cmp filaAtaque, '1'
		je MARCAD1
		cmp filaAtaque, '2'
		je MARCAD2
		cmp filaAtaque, '3'
		je MARCAD3
		cmp filaAtaque, '4'
		je MARCAD4
		cmp filaAtaque, '5'
		je MARCAD5
		cmp filaAtaque, '6'
		je MARCAD6
		cmp filaAtaque, '7'
		je MARCAD7
		cmp filaAtaque, '8'
		je MARCAD8
		cmp filaAtaque, '9'
		je MARCAD9
		cmp filaAtaque, '0'
		je MARCAD10
		
		MARCAD1:
			marcarDisparo filaAtaque, posicionXAtaque, disparos1J1, barcos11J2, turno, unidadTotalesJ1, decenaTotalesJ1, unidadImpactadosJ1, decenaImpactadosJ1, unidadFalladosJ1, decenaFalladosJ1
			jmp FINATAQUE1
		MARCAD2:
			marcarDisparo filaAtaque, posicionXAtaque, disparos2J1, barcos12J2, turno, unidadTotalesJ1, decenaTotalesJ1, unidadImpactadosJ1, decenaImpactadosJ1, unidadFalladosJ1, decenaFalladosJ1
			jmp FINATAQUE1
		MARCAD3:
			marcarDisparo filaAtaque, posicionXAtaque, disparos3J1, barcos13J2, turno, unidadTotalesJ1, decenaTotalesJ1, unidadImpactadosJ1, decenaImpactadosJ1, unidadFalladosJ1, decenaFalladosJ1
			jmp FINATAQUE1
		MARCAD4:
			marcarDisparo filaAtaque, posicionXAtaque, disparos4J1, barcos14J2, turno, unidadTotalesJ1, decenaTotalesJ1, unidadImpactadosJ1, decenaImpactadosJ1, unidadFalladosJ1, decenaFalladosJ1
			jmp FINATAQUE1
		MARCAD5:
			marcarDisparo filaAtaque, posicionXAtaque, disparos5J1, barcos15J2, turno, unidadTotalesJ1, decenaTotalesJ1, unidadImpactadosJ1, decenaImpactadosJ1, unidadFalladosJ1, decenaFalladosJ1
			jmp FINATAQUE1
		MARCAD6:
			marcarDisparo filaAtaque, posicionXAtaque, disparos6J1, barcos16J2, turno, unidadTotalesJ1, decenaTotalesJ1, unidadImpactadosJ1, decenaImpactadosJ1, unidadFalladosJ1, decenaFalladosJ1
			jmp FINATAQUE1
		MARCAD7:
			marcarDisparo filaAtaque, posicionXAtaque, disparos7J1, barcos17J2, turno, unidadTotalesJ1, decenaTotalesJ1, unidadImpactadosJ1, decenaImpactadosJ1, unidadFalladosJ1, decenaFalladosJ1
			jmp FINATAQUE1
		MARCAD8:
			marcarDisparo filaAtaque, posicionXAtaque, disparos8J1, barcos18J2, turno, unidadTotalesJ1, decenaTotalesJ1, unidadImpactadosJ1, decenaImpactadosJ1, unidadFalladosJ1, decenaFalladosJ1
			jmp FINATAQUE1
		MARCAD9:
			marcarDisparo filaAtaque, posicionXAtaque, disparos9J1, barcos19J2, turno, unidadTotalesJ1, decenaTotalesJ1, unidadImpactadosJ1, decenaImpactadosJ1, unidadFalladosJ1, decenaFalladosJ1
			jmp FINATAQUE1
		MARCAD10:
			marcarDisparo filaAtaque, posicionXAtaque, disparos10J1, barcos20J2, turno, unidadTotalesJ1, decenaTotalesJ1, unidadImpactadosJ1, decenaImpactadosJ1, unidadFalladosJ1, decenaFalladosJ1
			jmp FINATAQUE1
		FINATAQUE1:
  
			print tableroSuperior
			imprimirTableroSuperior
			getChar 
			;print tableroInferior
			;imprimirTableroInferior
			;getChar 
 
			cmp decenaImpactadosJ1, 1d
			je CASITERMINAJUGADOR1

			cmp turno, '2'
			je A_JUG1
			cmp turno, '1'
			je A_JUG2
	CASITERMINAJUGADOR1:
		cmp unidadImpactadosJ1, 7d
		je GANADORJUGADOR1
 
		cmp turno, '2'
		je A_JUG1
		cmp turno, '1'
		je A_JUG2

	GANADORJUGADOR1: 
		print ganaJugador1
		getChar
		jmp IMPRIMIRDATOSJUGADORES

	JUG2:		
		print tableroSuperior
		imprimirTbaleroSuperior2

		print turno2 

		print datosAtacar
		print msgcolumnaAtaque
		getChar
		mov columnaAtaque, al

		print msgfilaAtaque
		ObtenerTexto bufferLectura
		comparacion1 comandoExit, bufferLectura
		comparacion2 comandoSave, bufferLectura
		comparacion3 comandoShow, bufferLectura
		comparacionNO1 comandoFila1, bufferLectura, filaAtaque
		comparacionNO2 comandoFila2, bufferLectura, filaAtaque
		comparacionNO3 comandoFila3, bufferLectura, filaAtaque
		comparacionNO4 comandoFila4, bufferLectura, filaAtaque
		comparacionNO5 comandoFila5, bufferLectura, filaAtaque
		comparacionNO6 comandoFila6, bufferLectura, filaAtaque
		comparacionNO7 comandoFila7, bufferLectura, filaAtaque
		comparacionNO8 comandoFila8, bufferLectura, filaAtaque
		comparacionNO9 comandoFila9, bufferLectura, filaAtaque
		comparacionNO10 comandoFila10, bufferLectura, filaAtaque

		verificarCoordenadas filaAtaque, columnaAtaque
		obtenerPos columnaAtaque, posicionXAtaque
		print validarAtaque
		getChar
		mov confAtaque, al
		cmp confAtaque, '1'
		je CONFIRMAATAQUE2
		jmp JUG2

	CONFIRMAATAQUE2:
		cmp filaAtaque, '1'
		je MARCAD1_2
		cmp filaAtaque, '2'
		je MARCAD2_2
		cmp filaAtaque, '3'
		je MARCAD3_2
		cmp filaAtaque, '4'
		je MARCAD4_2
		cmp filaAtaque, '5'
		je MARCAD5_2
		cmp filaAtaque, '6'
		je MARCAD6_2
		cmp filaAtaque, '7'
		je MARCAD7_2
		cmp filaAtaque, '8'
		je MARCAD8_2
		cmp filaAtaque, '9'
		je MARCAD9_2
		cmp filaAtaque, '0'
		je MARCAD10_2
		
		MARCAD1_2:
			marcarDisparo filaAtaque, posicionXAtaque, disparos1J2, barcos11J1, turno, unidadTotalesJ2, decenaTotalesJ2, unidadImpactadosJ2, decenaImpactadosJ2, unidadFalladosJ2, decenaFalladosJ2
			jmp FINATAQUE2
		MARCAD2_2:
			marcarDisparo filaAtaque, posicionXAtaque, disparos2J2, barcos12J1, turno, unidadTotalesJ2, decenaTotalesJ2, unidadImpactadosJ2, decenaImpactadosJ2, unidadFalladosJ2, decenaFalladosJ2
			jmp FINATAQUE2
		MARCAD3_2:
			marcarDisparo filaAtaque, posicionXAtaque, disparos3J2, barcos13J1, turno, unidadTotalesJ2, decenaTotalesJ2, unidadImpactadosJ2, decenaImpactadosJ2, unidadFalladosJ2, decenaFalladosJ2
			jmp FINATAQUE2
		MARCAD4_2:
			marcarDisparo filaAtaque, posicionXAtaque, disparos4J2, barcos14J1, turno, unidadTotalesJ2, decenaTotalesJ2, unidadImpactadosJ2, decenaImpactadosJ2, unidadFalladosJ2, decenaFalladosJ2
			jmp FINATAQUE2
		MARCAD5_2:
			marcarDisparo filaAtaque, posicionXAtaque, disparos5J2, barcos15J1, turno, unidadTotalesJ2, decenaTotalesJ2, unidadImpactadosJ2, decenaImpactadosJ2, unidadFalladosJ2, decenaFalladosJ2
			jmp FINATAQUE2
		MARCAD6_2:
			marcarDisparo filaAtaque, posicionXAtaque, disparos6J2, barcos16J1, turno, unidadTotalesJ2, decenaTotalesJ2, unidadImpactadosJ2, decenaImpactadosJ2, unidadFalladosJ2, decenaFalladosJ2
			jmp FINATAQUE2
		MARCAD7_2:
			marcarDisparo filaAtaque, posicionXAtaque, disparos7J2, barcos17J1, turno, unidadTotalesJ2, decenaTotalesJ2, unidadImpactadosJ2, decenaImpactadosJ2, unidadFalladosJ2, decenaFalladosJ2
			jmp FINATAQUE2
		MARCAD8_2:
			marcarDisparo filaAtaque, posicionXAtaque, disparos8J2, barcos18J1, turno, unidadTotalesJ2, decenaTotalesJ2, unidadImpactadosJ2, decenaImpactadosJ2, unidadFalladosJ2, decenaFalladosJ2
			jmp FINATAQUE2
		MARCAD9_2:
			marcarDisparo filaAtaque, posicionXAtaque, disparos9J2, barcos19J1, turno, unidadTotalesJ2, decenaTotalesJ2, unidadImpactadosJ2, decenaImpactadosJ2, unidadFalladosJ2, decenaFalladosJ2
			jmp FINATAQUE2
		MARCAD10_2:
			marcarDisparo filaAtaque, posicionXAtaque, disparos10J2, barcos20J1, turno, unidadTotalesJ2, decenaTotalesJ2, unidadImpactadosJ2, decenaImpactadosJ2, unidadFalladosJ2, decenaFalladosJ2
			jmp FINATAQUE2
		FINATAQUE2:
			print tableroSuperior
			imprimirTbaleroSuperior2
			getChar
			;print tableroInferior
			;imprimirBarcos2	
			;getChar
			
 

			cmp decenaImpactadosJ2, 1d
			je CASITERMINAJUGADOR2
			
			cmp turno, '2'
			je A_JUG1
			cmp turno, '1'
			je A_JUG2

	CASITERMINAJUGADOR2:
		cmp unidadImpactadosJ2, 7d
		je GANADORJUGADOR2
		cmp turno, '2'
		je A_JUG1
		cmp turno, '1'
		je A_JUG2

	GANADORJUGADOR2:
		print ganaJugador2
		getChar    
		jmp IMPRIMIRDATOSJUGADORES

		 

	IMPRIMIRDATOSJUGADORES:
		print datosJugador1
		print disparosRealizados
		imprimirNumeros decenaTotalesJ1, auxNum
		imprimirNumeros unidadTotalesJ1, auxNum

		print disparosAcertados
		imprimirNumeros decenaImpactadosJ1, auxNum
		imprimirNumeros unidadImpactadosJ1, auxNum
		
		print disparosFallidos
		imprimirNumeros decenaFalladosJ1, auxNum
		imprimirNumeros unidadFalladosJ1 , auxNum

		print datosJugador2
		print disparosAcertados
		imprimirNumeros decenaTotalesJ2, auxNum
		imprimirNumeros unidadTotalesJ2, auxNum

		print disparosAcertados
		imprimirNumeros decenaImpactadosJ2, auxNum
		imprimirNumeros unidadImpactadosJ2, auxNum
		
		print disparosFallidos
		imprimirNumeros decenaFalladosJ2, auxNum
		imprimirNumeros unidadFalladosJ2, auxNum 

		print msgSalida
		ObtenerTexto bufferLectura
		comparacion1S1 comandoExit, bufferLectura

		jmp MENUAUXILIAR

 
;************************************************************************************ ERRORES ***********************************************************************
	 MENUAUXILIAR: 
		print menuOpciones 
		getChar
		cmp al, '1'
		je NUEVO
		cmp al, '2'
		je CARGAR
		cmp al, '3'
		je SALIR 
		jne MENUAUXILIAR
    ErrorLeer:
	    print msmError2
	   	getChar

	ERROR_COORD:
		print msg_errorC
		cmp turno, '1'
		je JUG1
		cmp turno, '2'
		je JUG2
		jmp MENUAUXILIAR
 	ErrorCrear:
	    print msmError3
	    getChar
		cmp turno, '1'
		je JUG1
		cmp turno, '2'
		je JUG2
		jmp MENUAUXILIAR

	ErrorAbrir:
	    print msmError1
	   	getChar
		cmp turno, '1'
		je JUG1
		cmp turno, '2'
		je JUG2
		jmp MENUAUXILIAR
	ErrorEscribir:
	    print msmError4
		cmp turno, '1'
		je JUG1
		cmp turno, '2'
		je JUG2
		jmp MENUAUXILIAR
	ERROROCUPADO:
		print msg_errorOcupado
		getChar
		cmp turno, '1'
		je AGREGARBARCOSJ1
		cmp turno, '2'
		je AGREGARBARCOSJ2
	ERRORYADISPARO:
		print msg_yadisparo
		getChar
		cmp turno, '1'
		je JUG1
		cmp turno, '2'
		je JUG2

	A_JUG1:
		mov turno, '1'
		cmp turno, '1'
		je JUG1
		cmp turno, '2'
		je JUG2
		jmp MenuPrincipal

	A_JUG2:
		mov turno, '2'
		cmp turno, '1'
		je JUG1
		cmp turno, '2'
		je JUG2
		jmp MenuPrincipal
	FINJUEGO:
		print msg_finalJuego
		getChar
    
	SALIR:
		mov ah, 4ch
		int 21h


;************************************************************************************ COMANDOS **********************************************************************




main endp


Siguiente proc
	AAM
	MOV BX,AX
	MOV DL,BH      ; Since the values are in BX, BH Part
	ADD DL,30H     ; ASCII Adjustment
	MOV bufferFecha[si], DL
	inc si 

	MOV DL,BL      ; BL Part 
	ADD DL,30H     ; ASCII Adjustment
	MOV bufferFecha[si], DL
	inc si 

	ret
Siguiente endp

Sig proc
	AAM
	MOV BX,AX
	MOV DL,BH      ; Since the values are in BX, BH Part
	ADD DL,30H     ; ASCII Adjustment
	MOV bufferHora[si], DL
	inc si 

	MOV DL,BL      ; BL Part 
	ADD DL,30H     ; ASCII Adjustment
	MOV bufferHora[si], DL
	inc si 

	ret
Sig endp

ObtenerRandom proc
	RAND:
	RANDINICIO:
		mov ah, 00h
		int 1ah

		mov ax, dx
		xor dx, dx
		mov cx, 2
		div cx

		add dl, '1'
		ret
ObtenerRandom endp
 


end