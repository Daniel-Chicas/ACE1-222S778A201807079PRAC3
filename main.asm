include macros.asm
.MODEL small 
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
	pruebaGeneral db 0ah, 'AQUÍ VOY', '$'
	pruebaGeneralS db 0ah, 'SALÍ', '$'



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
	fichaPb db  '     ', '$'
	fichaQb db  '     ', '$'
	fichaRb db  '     ', '$'
	fichaRIb db '    |', '$'
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
	salto db 0ah, 0dh, 00h



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
	confirmacionBarcos db 0ah, 0dh, '      <<< MATRIZ DE BARCOS AGREGADOS (PRESIONE ENTER PARA CONTINUAR) >>> ', 10, 13, '$'
									 
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
	col1 db 1 dup('$')
	pos1 db 0b
	f2 db 1 dup('$') 
	pos2 db 0b
	barcoSeleccionado db 0b, '$'

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



	aux db 0b

	separadorPC db ';'
	separadorComa db ',' 
	tipoCoord db 0b 
	division db '------------------------------------------------------------------', '$'    
	msg_errorC db '-- Atencion, Coordenadas Erroneas --', 10,13, '$'
	msg_PosOcupada db 0ah,0dh,'-------- Esta ficha ya fue ocupada por el contrincante --------','$' 
	msg_Orilla db 0ah, 0dh, '-------- Solo se pueden seleccionar fichas posicionadas en el perimetro del cuadrado --------', '$'

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
	msg_errorOcupado db 0ah,0dh,'-------- EL BARCO NO CABE EN LA POSICIÓN INDICADA --------','$'
	msg_yadisparo db 0ah,0dh,'-------- YA DISPARASTE EN ESTA POSICIÓN --------','$'

;*VARIABLES DE CARGA DEL JUEGO
	char0 db 	'0'
	char1 db 	'X'
	char2 db 	'O'
	char3 db 	'3'
	char4 db 	'4'
	
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

	comandoExit db 'EXIT','$'
	comandoSave db 'SAVE','$'
	comandoShow db 'SHOWHTM', '$'
	comandoP db 	'P', '$'
	comandoQ db 	'Q', '$'
	comandoR db 	'R', '$'
	comandoRI db 	'RI', '$'

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
	fichaB db 0ah, 0dh, 9, '		<td bgcolor="cadetblue">X</td>', 00h
	fichaN db 0ah, 0dh, 9, '		<td bgcolor="burlywood">O</td>', 00h
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
    
    NUEVO:
		print msg_nvo 
		limpiar SIZEOF fi20, barcos20J1, fi20
		limpiar SIZEOF fi19, barcos19J1, fi19
		limpiar SIZEOF fi18, barcos18J1, fi18
		limpiar SIZEOF fi17, barcos17J1, fi17
		limpiar SIZEOF fi16, barcos16J1, fi16
		limpiar SIZEOF fi15, barcos15J1, fi15
		limpiar SIZEOF fi14, barcos14J1, fi14
		limpiar SIZEOF fi13, barcos13J1, fi13
		limpiar SIZEOF fi12, barcos12J1, fi12
		limpiar SIZEOF fi11, barcos11J1, fi11

		limpiar SIZEOF fi10, disparos10J1, fi10
		limpiar SIZEOF fi9, disparos9J1, fi9
		limpiar SIZEOF fi8, disparos8J1, fi8
		limpiar SIZEOF fi7, disparos7J1, fi7
		limpiar SIZEOF fi6, disparos6J1, fi6
		limpiar SIZEOF fi5, disparos5J1, fi5
		limpiar SIZEOF fi4, disparos4J1, fi4
		limpiar SIZEOF fi3, disparos3J1, fi3
		limpiar SIZEOF fi2, disparos2J1, fi2
		limpiar SIZEOF fi1, disparos1J1, fi1

		limpiar SIZEOF fi20, barcos20J2, fi20
		limpiar SIZEOF fi19, barcos19J2, fi19
		limpiar SIZEOF fi18, barcos18J2, fi18
		limpiar SIZEOF fi17, barcos17J2, fi17
		limpiar SIZEOF fi16, barcos16J2, fi16
		limpiar SIZEOF fi15, barcos15J2, fi15
		limpiar SIZEOF fi14, barcos14J2, fi14
		limpiar SIZEOF fi13, barcos13J2, fi13
		limpiar SIZEOF fi12, barcos12J2, fi12
		limpiar SIZEOF fi11, barcos11J2, fi11

		limpiar SIZEOF fi10, disparos10J2, fi10
		limpiar SIZEOF fi9, disparos9J2, fi9
		limpiar SIZEOF fi8, disparos8J2, fi8
		limpiar SIZEOF fi7, disparos7J2, fi7
		limpiar SIZEOF fi6, disparos6J2, fi6
		limpiar SIZEOF fi5, disparos5J2, fi5
		limpiar SIZEOF fi4, disparos4J2, fi4
		limpiar SIZEOF fi3, disparos3J2, fi3
		limpiar SIZEOF fi2, disparos2J2, fi2
		limpiar SIZEOF fi1, disparos1J2, fi1

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
		je AGREGARBARCOSJ1 ;TODO REGRESAR A ESTE
		;je JUG1
	EMPIEZAJ2:
		print empieza2
		print ln	
		getChar
		cmp al, 13
		jne EMPIEZAJ2
		je AGREGARBARCOSJ2 ;TODO REGRESAR A ESTE
		;je JUG2
	AGREGARBARCOSJ1: 
		CICLOJ1:
			print msgBarcos1
			imprimir SIZEOF barcos11J1, fichaX, fichaO, y1, vc, barcos11J1, ln, saltoLinea, B1, B2, B3, B4, B5
			imprimir SIZEOF barcos12J1, fichaX, fichaO, y2, vc, barcos12J1, ln, saltoLinea, B1, B2, B3, B4, B5
			imprimir SIZEOF barcos13J1, fichaX, fichaO, y3, vc, barcos13J1, ln, saltoLinea, B1, B2, B3, B4, B5
			imprimir SIZEOF barcos14J1, fichaX, fichaO, y4, vc, barcos14J1, ln, saltoLinea, B1, B2, B3, B4, B5
			imprimir SIZEOF barcos15J1, fichaX, fichaO, y5, vc, barcos15J1, ln, saltoLinea, B1, B2, B3, B4, B5
			imprimir SIZEOF barcos16J1, fichaX, fichaO, y6, vc, barcos16J1, ln, saltoLinea, B1, B2, B3, B4, B5
			imprimir SIZEOF barcos17J1, fichaX, fichaO, y7, vc, barcos17J1, ln, saltoLinea, B1, B2, B3, B4, B5
			imprimir SIZEOF barcos18J1, fichaX, fichaO, y8, vc, barcos18J1, ln, saltoLinea, B1, B2, B3, B4, B5
			imprimir SIZEOF barcos19J1, fichaX, fichaO, y9, vc, barcos19J1, ln, saltoLinea, B1, B2, B3, B4, B5
			imprimir SIZEOF barcos20J1, fichaX, fichaO, y10, vc, barcos20J1, ln, saltoLinea, B1, B2, B3, B4, B5
			print xcord
			print division

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
			
			jmp SALIDACICLOJ1
		SALIDACICLOJ1: 
			cmp contador, '5'
			jb CICLOJ1 
			POP AX
			POP SI 
		
		
		print confirmacionBarcos
		imprimir SIZEOF barcos11J1, fichaX, fichaO, y1, vc, barcos11J1, ln, saltoLinea, B1, B2, B3, B4, B5
		imprimir SIZEOF barcos12J1, fichaX, fichaO, y2, vc, barcos12J1, ln, saltoLinea, B1, B2, B3, B4, B5
		imprimir SIZEOF barcos13J1, fichaX, fichaO, y3, vc, barcos13J1, ln, saltoLinea, B1, B2, B3, B4, B5
		imprimir SIZEOF barcos14J1, fichaX, fichaO, y4, vc, barcos14J1, ln, saltoLinea, B1, B2, B3, B4, B5
		imprimir SIZEOF barcos15J1, fichaX, fichaO, y5, vc, barcos15J1, ln, saltoLinea, B1, B2, B3, B4, B5
		imprimir SIZEOF barcos16J1, fichaX, fichaO, y6, vc, barcos16J1, ln, saltoLinea, B1, B2, B3, B4, B5
		imprimir SIZEOF barcos17J1, fichaX, fichaO, y7, vc, barcos17J1, ln, saltoLinea, B1, B2, B3, B4, B5
		imprimir SIZEOF barcos18J1, fichaX, fichaO, y8, vc, barcos18J1, ln, saltoLinea, B1, B2, B3, B4, B5
		imprimir SIZEOF barcos19J1, fichaX, fichaO, y9, vc, barcos19J1, ln, saltoLinea, B1, B2, B3, B4, B5
		imprimir SIZEOF barcos20J1, fichaX, fichaO, y10, vc, barcos20J1, ln, saltoLinea, B1, B2, B3, B4, B5
		print xcord
		print division


		getChar
		

		mov contador, '0'
		mov barcosJ1agregados, '1'
		cmp barcosJ2agregados, '0'
		je AGREGARBARCOSJ2  
		jmp MENSAJEINICIOJUEGO
	
	AGREGARBARCOSJ2:
		 
		CICLOJ2: 
			print msgBarcos2
			imprimir SIZEOF barcos11J2, fichaX, fichaO, y1, vc, barcos11J2, ln, saltoLinea, B1, B2, B3, B4, B5 
			imprimir SIZEOF barcos12J2, fichaX, fichaO, y2, vc, barcos12J2, ln, saltoLinea, B1, B2, B3, B4, B5
			imprimir SIZEOF barcos13J2, fichaX, fichaO, y3, vc, barcos13J2, ln, saltoLinea, B1, B2, B3, B4, B5
			imprimir SIZEOF barcos14J2, fichaX, fichaO, y4, vc, barcos14J2, ln, saltoLinea, B1, B2, B3, B4, B5
			imprimir SIZEOF barcos15J2, fichaX, fichaO, y5, vc, barcos15J2, ln, saltoLinea, B1, B2, B3, B4, B5
			imprimir SIZEOF barcos16J2, fichaX, fichaO, y6, vc, barcos16J2, ln, saltoLinea, B1, B2, B3, B4, B5
			imprimir SIZEOF barcos17J2, fichaX, fichaO, y7, vc, barcos17J2, ln, saltoLinea, B1, B2, B3, B4, B5
			imprimir SIZEOF barcos18J2, fichaX, fichaO, y8, vc, barcos18J2, ln, saltoLinea, B1, B2, B3, B4, B5
			imprimir SIZEOF barcos19J2, fichaX, fichaO, y9, vc, barcos19J2, ln, saltoLinea, B1, B2, B3, B4, B5
			imprimir SIZEOF barcos20J2, fichaX, fichaO, y10, vc, barcos20J2, ln, saltoLinea, B1, B2, B3, B4, B5
			print xcord
			print division

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
			
			jmp SALIDACICLOJ2
		SALIDACICLOJ2:
			cmp contador, '5'
			jb CICLOJ2
			POP AX
			POP SI 
			
		print confirmacionBarcos
		imprimir SIZEOF barcos11J2, fichaX, fichaO, y1, vc, barcos11J2, ln, saltoLinea, B1, B2, B3, B4, B5 
		imprimir SIZEOF barcos12J2, fichaX, fichaO, y2, vc, barcos12J2, ln, saltoLinea, B1, B2, B3, B4, B5
		imprimir SIZEOF barcos13J2, fichaX, fichaO, y3, vc, barcos13J2, ln, saltoLinea, B1, B2, B3, B4, B5
		imprimir SIZEOF barcos14J2, fichaX, fichaO, y4, vc, barcos14J2, ln, saltoLinea, B1, B2, B3, B4, B5
		imprimir SIZEOF barcos15J2, fichaX, fichaO, y5, vc, barcos15J2, ln, saltoLinea, B1, B2, B3, B4, B5
		imprimir SIZEOF barcos16J2, fichaX, fichaO, y6, vc, barcos16J2, ln, saltoLinea, B1, B2, B3, B4, B5
		imprimir SIZEOF barcos17J2, fichaX, fichaO, y7, vc, barcos17J2, ln, saltoLinea, B1, B2, B3, B4, B5
		imprimir SIZEOF barcos18J2, fichaX, fichaO, y8, vc, barcos18J2, ln, saltoLinea, B1, B2, B3, B4, B5
		imprimir SIZEOF barcos19J2, fichaX, fichaO, y9, vc, barcos19J2, ln, saltoLinea, B1, B2, B3, B4, B5
		imprimir SIZEOF barcos20J2, fichaX, fichaO, y10, vc, barcos20J2, ln, saltoLinea, B1, B2, B3, B4, B5
		print xcord
		print division
		getChar
		
		mov contador, '0'
		mov barcosJ2agregados, '1' 
		cmp barcosJ1agregados, '0'
		je AGREGARBARCOSJ1
		jmp MENSAJEINICIOJUEGO

	MENSAJEINICIOJUEGO:
		print inicioJuego
		getChar
		cmp al, 13
		jne MENSAJEINICIOJUEGO
		jmp INGRESAR
	INGRESAR:
		cmp turno, '1'
		je JUG1
		cmp turno, '2'
		je JUG2
		jmp MenuPrincipal
	JUG1: 
		print tableroSuperior
		imprimir SIZEOF disparos1J1, fichaX, fichaO, y1, vc, disparos1J1, ln, saltoLinea, B1, B2, B3, B4, B5
		imprimir SIZEOF disparos2J1, fichaX, fichaO, y2, vc, disparos2J1, ln, saltoLinea, B1, B2, B3, B4, B5
		imprimir SIZEOF disparos3J1, fichaX, fichaO, y3, vc, disparos3J1, ln, saltoLinea, B1, B2, B3, B4, B5
		imprimir SIZEOF disparos4J1, fichaX, fichaO, y4, vc, disparos4J1, ln, saltoLinea, B1, B2, B3, B4, B5
		imprimir SIZEOF disparos5J1, fichaX, fichaO, y5, vc, disparos5J1, ln, saltoLinea, B1, B2, B3, B4, B5
		imprimir SIZEOF disparos6J1, fichaX, fichaO, y6, vc, disparos6J1, ln, saltoLinea, B1, B2, B3, B4, B5
		imprimir SIZEOF disparos7J1, fichaX, fichaO, y7, vc, disparos7J1, ln, saltoLinea, B1, B2, B3, B4, B5
		imprimir SIZEOF disparos8J1, fichaX, fichaO, y8, vc, disparos8J1, ln, saltoLinea, B1, B2, B3, B4, B5
		imprimir SIZEOF disparos9J1, fichaX, fichaO, y9, vc, disparos9J1, ln, saltoLinea, B1, B2, B3, B4, B5
		imprimir SIZEOF disparos10J1, fichaX, fichaO, y10, vc, disparos10J1, ln, saltoLinea, B1, B2, B3, B4, B5
		print xcord
		print division
		
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
			marcarDisparo filaAtaque, posicionXAtaque, disparos1J1, barcos11J2, turno
			jmp FINATAQUE1
		MARCAD2:
			marcarDisparo filaAtaque, posicionXAtaque, disparos2J1, barcos12J2, turno
			jmp FINATAQUE1
		MARCAD3:
			marcarDisparo filaAtaque, posicionXAtaque, disparos3J1, barcos13J2, turno
			jmp FINATAQUE1
		MARCAD4:
			marcarDisparo filaAtaque, posicionXAtaque, disparos4J1, barcos14J2, turno
			jmp FINATAQUE1
		MARCAD5:
			marcarDisparo filaAtaque, posicionXAtaque, disparos5J1, barcos15J2, turno
			jmp FINATAQUE1
		MARCAD6:
			marcarDisparo filaAtaque, posicionXAtaque, disparos6J1, barcos16J2, turno
			jmp FINATAQUE1
		MARCAD7:
			marcarDisparo filaAtaque, posicionXAtaque, disparos7J1, barcos17J2, turno
			jmp FINATAQUE1
		MARCAD8:
			marcarDisparo filaAtaque, posicionXAtaque, disparos8J1, barcos18J2, turno
			jmp FINATAQUE1
		MARCAD9:
			marcarDisparo filaAtaque, posicionXAtaque, disparos9J1, barcos19J2, turno
			jmp FINATAQUE1
		MARCAD10:
			marcarDisparo filaAtaque, posicionXAtaque, disparos10J1, barcos20J2, turno
			jmp FINATAQUE1
		FINATAQUE1:
			print tableroSuperior
			imprimir SIZEOF disparos1J1, fichaX, fichaO, y1, vc, disparos1J1, ln, saltoLinea, B1, B2, B3, B4, B5
			imprimir SIZEOF disparos2J1, fichaX, fichaO, y2, vc, disparos2J1, ln, saltoLinea, B1, B2, B3, B4, B5
			imprimir SIZEOF disparos3J1, fichaX, fichaO, y3, vc, disparos3J1, ln, saltoLinea, B1, B2, B3, B4, B5
			imprimir SIZEOF disparos4J1, fichaX, fichaO, y4, vc, disparos4J1, ln, saltoLinea, B1, B2, B3, B4, B5
			imprimir SIZEOF disparos5J1, fichaX, fichaO, y5, vc, disparos5J1, ln, saltoLinea, B1, B2, B3, B4, B5
			imprimir SIZEOF disparos6J1, fichaX, fichaO, y6, vc, disparos6J1, ln, saltoLinea, B1, B2, B3, B4, B5
			imprimir SIZEOF disparos7J1, fichaX, fichaO, y7, vc, disparos7J1, ln, saltoLinea, B1, B2, B3, B4, B5
			imprimir SIZEOF disparos8J1, fichaX, fichaO, y8, vc, disparos8J1, ln, saltoLinea, B1, B2, B3, B4, B5
			imprimir SIZEOF disparos9J1, fichaX, fichaO, y9, vc, disparos9J1, ln, saltoLinea, B1, B2, B3, B4, B5
			imprimir SIZEOF disparos10J1, fichaX, fichaO, y10, vc, disparos10J1, ln, saltoLinea, B1, B2, B3, B4, B5
			print xcord
			print division
			getChar 
			print tableroInferior
			imprimir SIZEOF barcos11J1, fichaX, fichaO, y1, vc, barcos11J1, ln, saltoLinea, B1, B2, B3, B4, B5
			imprimir SIZEOF barcos12J1, fichaX, fichaO, y2, vc, barcos12J1, ln, saltoLinea, B1, B2, B3, B4, B5
			imprimir SIZEOF barcos13J1, fichaX, fichaO, y3, vc, barcos13J1, ln, saltoLinea, B1, B2, B3, B4, B5
			imprimir SIZEOF barcos14J1, fichaX, fichaO, y4, vc, barcos14J1, ln, saltoLinea, B1, B2, B3, B4, B5
			imprimir SIZEOF barcos15J1, fichaX, fichaO, y5, vc, barcos15J1, ln, saltoLinea, B1, B2, B3, B4, B5
			imprimir SIZEOF barcos16J1, fichaX, fichaO, y6, vc, barcos16J1, ln, saltoLinea, B1, B2, B3, B4, B5
			imprimir SIZEOF barcos17J1, fichaX, fichaO, y7, vc, barcos17J1, ln, saltoLinea, B1, B2, B3, B4, B5
			imprimir SIZEOF barcos18J1, fichaX, fichaO, y8, vc, barcos18J1, ln, saltoLinea, B1, B2, B3, B4, B5
			imprimir SIZEOF barcos19J1, fichaX, fichaO, y9, vc, barcos19J1, ln, saltoLinea, B1, B2, B3, B4, B5
			imprimir SIZEOF barcos20J1, fichaX, fichaO, y10, vc, barcos20J1, ln, saltoLinea, B1, B2, B3, B4, B5
			print xcord
			print division

			getChar 
			jmp CAMBIAR_TURNO

	JUG2:		
		print tableroSuperior
		imprimir SIZEOF disparos1J2, fichaX, fichaO, y1, vc, disparos1J2, ln, saltoLinea, B1, B2, B3, B4, B5
		imprimir SIZEOF disparos2J2, fichaX, fichaO, y2, vc, disparos2J2, ln, saltoLinea, B1, B2, B3, B4, B5
		imprimir SIZEOF disparos3J2, fichaX, fichaO, y3, vc, disparos3J2, ln, saltoLinea, B1, B2, B3, B4, B5
		imprimir SIZEOF disparos4J2, fichaX, fichaO, y4, vc, disparos4J2, ln, saltoLinea, B1, B2, B3, B4, B5
		imprimir SIZEOF disparos5J2, fichaX, fichaO, y5, vc, disparos5J2, ln, saltoLinea, B1, B2, B3, B4, B5
		imprimir SIZEOF disparos6J2, fichaX, fichaO, y6, vc, disparos6J2, ln, saltoLinea, B1, B2, B3, B4, B5
		imprimir SIZEOF disparos7J2, fichaX, fichaO, y7, vc, disparos7J2, ln, saltoLinea, B1, B2, B3, B4, B5
		imprimir SIZEOF disparos8J2, fichaX, fichaO, y8, vc, disparos8J2, ln, saltoLinea, B1, B2, B3, B4, B5
		imprimir SIZEOF disparos9J2, fichaX, fichaO, y9, vc, disparos9J2, ln, saltoLinea, B1, B2, B3, B4, B5
		imprimir SIZEOF disparos10J2, fichaX, fichaO, y10, vc, disparos10J2, ln, saltoLinea, B1, B2, B3, B4, B5
		print xcord
		print division

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
			marcarDisparo filaAtaque, posicionXAtaque, disparos1J2, barcos11J1, turno
			jmp FINATAQUE2
		MARCAD2_2:
			marcarDisparo filaAtaque, posicionXAtaque, disparos2J2, barcos12J1, turno
			jmp FINATAQUE2
		MARCAD3_2:
			marcarDisparo filaAtaque, posicionXAtaque, disparos3J2, barcos13J1, turno
			jmp FINATAQUE2
		MARCAD4_2:
			marcarDisparo filaAtaque, posicionXAtaque, disparos4J2, barcos14J1, turno
			jmp FINATAQUE2
		MARCAD5_2:
			marcarDisparo filaAtaque, posicionXAtaque, disparos5J2, barcos15J1, turno
			jmp FINATAQUE2
		MARCAD6_2:
			marcarDisparo filaAtaque, posicionXAtaque, disparos6J2, barcos16J1, turno
			jmp FINATAQUE2
		MARCAD7_2:
			marcarDisparo filaAtaque, posicionXAtaque, disparos7J2, barcos17J1, turno
			jmp FINATAQUE2
		MARCAD8_2:
			marcarDisparo filaAtaque, posicionXAtaque, disparos8J2, barcos18J1, turno
			jmp FINATAQUE2
		MARCAD9_2:
			marcarDisparo filaAtaque, posicionXAtaque, disparos9J2, barcos19J1, turno
			jmp FINATAQUE2
		MARCAD10_2:
			marcarDisparo filaAtaque, posicionXAtaque, disparos10J2, barcos20J1, turno
			jmp FINATAQUE2
		FINATAQUE2:
			print tableroSuperior
			imprimir SIZEOF disparos1J2, fichaX, fichaO, y1, vc, disparos1J2, ln, saltoLinea, B1, B2, B3, B4, B5
			imprimir SIZEOF disparos2J2, fichaX, fichaO, y2, vc, disparos2J2, ln, saltoLinea, B1, B2, B3, B4, B5
			imprimir SIZEOF disparos3J2, fichaX, fichaO, y3, vc, disparos3J2, ln, saltoLinea, B1, B2, B3, B4, B5
			imprimir SIZEOF disparos4J2, fichaX, fichaO, y4, vc, disparos4J2, ln, saltoLinea, B1, B2, B3, B4, B5
			imprimir SIZEOF disparos5J2, fichaX, fichaO, y5, vc, disparos5J2, ln, saltoLinea, B1, B2, B3, B4, B5
			imprimir SIZEOF disparos6J2, fichaX, fichaO, y6, vc, disparos6J2, ln, saltoLinea, B1, B2, B3, B4, B5
			imprimir SIZEOF disparos7J2, fichaX, fichaO, y7, vc, disparos7J2, ln, saltoLinea, B1, B2, B3, B4, B5
			imprimir SIZEOF disparos8J2, fichaX, fichaO, y8, vc, disparos8J2, ln, saltoLinea, B1, B2, B3, B4, B5
			imprimir SIZEOF disparos9J2, fichaX, fichaO, y9, vc, disparos9J2, ln, saltoLinea, B1, B2, B3, B4, B5
			imprimir SIZEOF disparos10J2, fichaX, fichaO, y10, vc, disparos10J2, ln, saltoLinea, B1, B2, B3, B4, B5
			print xcord
			print division
			getChar
			print tableroInferior
			imprimir SIZEOF barcos11J2, fichaX, fichaO, y1, vc, barcos11J2, ln, saltoLinea, B1, B2, B3, B4, B5 
			imprimir SIZEOF barcos12J2, fichaX, fichaO, y2, vc, barcos12J2, ln, saltoLinea, B1, B2, B3, B4, B5
			imprimir SIZEOF barcos13J2, fichaX, fichaO, y3, vc, barcos13J2, ln, saltoLinea, B1, B2, B3, B4, B5
			imprimir SIZEOF barcos14J2, fichaX, fichaO, y4, vc, barcos14J2, ln, saltoLinea, B1, B2, B3, B4, B5
			imprimir SIZEOF barcos15J2, fichaX, fichaO, y5, vc, barcos15J2, ln, saltoLinea, B1, B2, B3, B4, B5
			imprimir SIZEOF barcos16J2, fichaX, fichaO, y6, vc, barcos16J2, ln, saltoLinea, B1, B2, B3, B4, B5
			imprimir SIZEOF barcos17J2, fichaX, fichaO, y7, vc, barcos17J2, ln, saltoLinea, B1, B2, B3, B4, B5
			imprimir SIZEOF barcos18J2, fichaX, fichaO, y8, vc, barcos18J2, ln, saltoLinea, B1, B2, B3, B4, B5
			imprimir SIZEOF barcos19J2, fichaX, fichaO, y9, vc, barcos19J2, ln, saltoLinea, B1, B2, B3, B4, B5
			imprimir SIZEOF barcos20J2, fichaX, fichaO, y10, vc, barcos20J2, ln, saltoLinea, B1, B2, B3, B4, B5
			print xcord
			print division		
			getChar
 			jmp CAMBIAR_TURNO
	CAMBIAR_TURNO:
		cmp turno, '2'
		je A_JUG1
		cmp turno, '1'
		je A_JUG2


	A_JUG1:
		mov turno, '1'
		jmp INGRESAR

	A_JUG2:
		mov turno, '2'
		jmp INGRESAR

    CARGAR:
		print pruebacarga
		jmp MenuPrincipal

    SALIR:
		mov ah, 4ch
		int 21h

	VolverTurno:
		cmp turno, '1'
		je JUG1
		cmp turno, '2'
		je JUG2
		jmp MenuPrincipal

;************************************************************************************ COMANDOS **********************************************************************
	SAVE:
		print msg_guardar
		print cinNomArch
		Ruta rutaArchivo
		crearArchivo rutaArchivo,handleFichero
		abrirArchivo rutaArchivo,handleFichero  
		;imprimirArq SIZEOF fila5, separadorComa, separadorPC, fila5, char0, char1, char2, char3, char4, handleFichero
		;imprimirArq SIZEOF fila4, separadorComa, separadorPC, fila4, char0, char1, char2, char3, char4, handleFichero
		;imprimirArq SIZEOF fila3, separadorComa, separadorPC, fila3, char0, char1, char2, char3, char4, handleFichero
		;imprimirArq SIZEOF fila2, separadorComa, separadorPC, fila2, char0, char1, char2, char3, char4, handleFichero
		;imprimirArq SIZEOF fila1, separadorComa, separadorPC, fila1, char0, char1, char2, char3, char4, handleFichero 
		cerrarArchivo handleFichero
		print msg_guardad
		jmp VolverTurno

	SHOW:
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
		;imprimirHtml SIZEOF fila5, fichaB, fichaN, fila5, VacioB, VacioN, tr, ctr, handleFichero
		;imprimirHtml SIZEOF fila4, fichaB, fichaN, fila4, VacioB, VacioN, tr, ctr, handleFichero
		;imprimirHtml SIZEOF fila3, fichaB, fichaN, fila3, VacioB, VacioN, tr, ctr, handleFichero
		;imprimirHtml SIZEOF fila2, fichaB, fichaN, fila2, VacioB, VacioN, tr, ctr, handleFichero
		;imprimirHtml SIZEOF fila1, fichaB, fichaN, fila1, VacioB, VacioN, tr, ctr, handleFichero 
		escribirArchivo  SIZEOF finHtml, finHtml, handleFichero
		cerrarArchivo handleFichero
		print msg_general
		jmp VolverTurno
	
;************************************************************************************ ERRORES ***********************************************************************
	
    ErrorLeer:
	    print msmError2
	   	getChar

	ERROR_COORD:
		print msg_errorC
		jmp VolverTurno 

	ERROR_SEL:
		print msg_PosOcupada
		jmp VolverTurno 
	
	ERROR_ORILLA:
		print msg_Orilla
		jmp VolverTurno
	
	ErrorCrear:
	    print msmError3
	    getChar
	    jmp VolverTurno

	ErrorAbrir:
	    print msmError1
	   	getChar
	   	jmp VolverTurno
	ErrorEscribir:
	    print msmError4
	   	jmp VolverTurno
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
		je CONFIRMAATAQUE1
		cmp turno, '2'
		je CONFIRMAATAQUE2


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