getChar macro
    mov ah, 01h
    int 21h
endm

print macro cadena
    mov ah, 09h
    mov dx, offset cadena
    int 21h
endm
 

limpiar macro len, filaOriginal, filaPlantilla
    LOCAL DO, COMPARE, FIN
    PUSH SI
    PUSH AX
    xor si, si
    DO:
        mov al, [filaPlantilla+si]		;AQUI
        mov filaOriginal[si], al
        jmp COMPARE
    COMPARE:
        inc si 				;AQUI
        cmp si, len 		;AQUI
        jb DO
        jmp FIN
    FIN:
        POP AX
        POP SI
endm


ObtenerTexto macro buffer
	LOCAL CONTINUE, FIN
	PUSH SI
	PUSH AX
	xor si, si
	CONTINUE:
		getChar
		cmp al, 0dh
		je FIN
		mov buffer[si], al
		inc si
		jmp CONTINUE
	FIN:
		mov al, '$'
		mov buffer[si], al
	POP AX
	POP SI
endm
 

;******************* IMPRIMIR EN CONSOLA Y ARCHIVOS ******************* 
	imprimirBarcosDisponibles macro len, BN, DA, DJ, AC, PA, vc, f, ln, enter
		LOCAL DO, VERFN, VERFB, VERFP, VERFQ, VERFR, VERFRI, VERVC, VACIO, FIN, COMPARE
		;001b, 010b, 011b, 100b, 101b

		print enter
		PUSH SI
		PUSH AX
		xor si, si
		DO:
			mov al, [f+si] 
			cmp al, 000b
			je VACIO
			cmp al, 001b
			je VERFB
			cmp al, 010b
			je VERFN
			cmp al, 011b
			je VERFP
			cmp al, 100b
			je VERFQ
			cmp al, 101b
			je VERFR
			jmp VERVC
		COMPARE:
			inc si  
			cmp si, len  
			jb DO
			jmp FIN
		VACIO: 
			jmp COMPARE
		VERFB:
			print BN
			print enter
			jmp COMPARE
		VERFN:
			print DA
			print enter
			jmp COMPARE	
		VERFP: 
			print DJ
			print enter
			jmp COMPARE	 
		VERFQ: 
			print AC	
			print enter
			jmp COMPARE	
		VERFR: 
			print PA
			print enter
			jmp COMPARE	
		VERVC:
			print enter
			jmp COMPARE
		FIN:
			POP AX
			POP SI
			print enter
	endm

	obtenerIdBarcoDisponible macro col, pos, BN, DA, DJ, AC, PA, vc, f, ln, enter, msgSeleccionado, BNS, DAS, DJS, ACS, PAS
		LOCAL P1, P2, P3, P4, P5, FIN

		mov al, col
		cmp al, '1'
		je P1
		cmp al, '2'
		je P2
		cmp al, '3'
		je P3
		cmp al, '4'
		je P4
		cmp al, '5'
		je P5 

		P1:
			mov pos, 000b 
			print msgSeleccionado
			print BNS 
			jmp FIN
		P2:
			mov pos, 001b 
			print msgSeleccionado
			print DAS 
			jmp FIN
		P3:
			mov pos, 010b 
			print msgSeleccionado
			print DJS 
			jmp FIN
		P4:
			mov pos, 011b 
			print msgSeleccionado
			print ACS 
			jmp FIN
		P5:
			mov pos, 100b 
			print msgSeleccionado
			print PAS 
			jmp FIN 
		FIN:  
			POP DX
			POP SI
	endm

	limpiarIDBarco macro pos, f, contador
		LOCAL CON1, CON2, CON3, CON4, CON5, FIN
		PUSH SI
		PUSH DX

		xor si, si 
		MOV DL, pos
		MOV DH, 0
		MOV SI, DX 
		mov f[si], 000b 
		
		cmp contador, '0'
		je CON1
		cmp contador, '1'
		je CON2
		cmp contador, '2'
		je CON3
		cmp contador, '3'
		je CON4
		cmp contador, '4'
		je CON5

		CON1:
			mov contador, '1'
			jmp FIN
		CON2:
			mov contador, '2'
			jmp FIN
		CON3:
			mov contador, '3'
			jmp FIN
		CON4:
			mov contador, '4'
			jmp FIN
		CON5:
			mov contador, '5'
			jmp FIN
		FIN:
			POP DX
			POP SI
	endm

	mostrarBarcosX macro f1, col, idBarco, orientacion, fila1, fila2, fila3, fila4, fila5, fila6, fila7, fila8, fila9, fila10, pos2, pos3, pos4, pos5, turno
		LOCAL Fi0, Fi9, Fi8, Fi7, Fi6, Fi5, Fi4, Fi3, Fi2, Fi1, Fi0V, Fi9V, Fi8V, Fi7V, Fi6V, Fi5V, Fi4V, Fi3V, Fi2V, Fi1V, FIN, COL0, COL9, COL8, COL7, COL6, COL5, COL4, COL3, COL2, COL1, SIGUIENTE

		cmp col, 0000b
		je COL0
		cmp col, 0001b
		je COL1
		cmp col, 0010b
		je COL2
		cmp col, 0011b
		je COL3
		cmp col, 0100b
		je COL4
		cmp col, 0101b
		je COL5
		cmp col, 0110b
		je COL6
		cmp col, 0111b
		je COL7
		cmp col, 1000b
		je COL8
		cmp col, 1001b
		je COL9

 		COL0: 
			mov pos2, 0001b
			mov pos3, 0010b
			mov pos4, 0011b
			mov pos5, 0100b
			jmp SIGUIENTE
		COL1: 
			mov pos2, 0010b
			mov pos3, 0011b
			mov pos4, 0100b
			mov pos5, 0101b
			jmp SIGUIENTE
		COL2: 
			mov pos2, 0011b
			mov pos3, 0100b
			mov pos4, 0101b
			mov pos5, 0110b
			jmp SIGUIENTE
		COL3: 
			mov pos2, 0100b
			mov pos3, 0101b
			mov pos4, 0110b
			mov pos5, 0111b
			jmp SIGUIENTE
		COL4: 
			mov pos2, 0101b
			mov pos3, 0110b
			mov pos4, 0111b
			mov pos5, 1000b
			jmp SIGUIENTE
		COL5: 
			mov pos2, 0110b
			mov pos3, 0111b
			mov pos4, 1000b
			mov pos5, 1001b
			jmp SIGUIENTE
		COL6: 
			mov pos2, 0101b
			mov pos3, 0100b
			mov pos4, 0011b
			mov pos5, 0010b
			jmp SIGUIENTE
		COL7:
			mov pos2, 0110b
			mov pos3, 0101b
			mov pos4, 0100b
			mov pos5, 0011b
			jmp SIGUIENTE
		COL8:
			mov pos2, 0111b
			mov pos3, 0110b
			mov pos4, 0101b
			mov pos5, 0100b
			jmp SIGUIENTE
		COL9:
			mov pos2, 1000b
			mov pos3, 0111b
			mov pos4, 0110b
			mov pos5, 0101b
			jmp SIGUIENTE 

		SIGUIENTE:
			cmp f1, '1'
			je Fi1
			cmp f1, '2'
			je Fi2
			cmp f1, '3'
			je Fi3
			cmp f1, '4'
			je Fi4
			cmp f1, '5'
			je Fi5
			cmp f1, '6'
			je Fi6
			cmp f1, '7'
			je Fi7
			cmp f1, '8'
			je Fi8
			cmp f1, '9'
			je Fi9
			cmp f1, '0'
			je Fi0 
			jmp ERROR_COORD
			Fi0: 
				cmp orientacion, '0'
				je Fi0V
				mostrarBarcosY fila10, col, idBarco, orientacion, fila10, fila10, fila10, fila10, turno, pos2, pos3, pos4, pos5
				jmp FIN
			Fi9: 
				cmp orientacion, '0'
				je Fi9V
				mostrarBarcosY fila9, col, idBarco, orientacion, fila9, fila9, fila9, fila9, turno, pos2, pos3, pos4, pos5
				jmp FIN
			Fi8: 
				cmp orientacion, '0'
				je Fi8V
				mostrarBarcosY fila8, col, idBarco, orientacion, fila8, fila8, fila8, fila8, turno, pos2, pos3, pos4, pos5
				jmp FIN
			Fi7: 
				cmp orientacion, '0'
				je Fi7V
				mostrarBarcosY fila7, col, idBarco, orientacion, fila7, fila7, fila7, fila7, turno, pos2, pos3, pos4, pos5
				jmp FIN
			Fi6: 
				cmp orientacion, '0'
				je Fi6V
				mostrarBarcosY fila6, col, idBarco, orientacion, fila6, fila6, fila6, fila6, turno, pos2, pos3, pos4, pos5
				jmp FIN
			Fi5: 
				cmp orientacion, '0'
				je Fi5V
				mostrarBarcosY fila5, col, idBarco, orientacion, fila5, fila5, fila5, fila5, turno, pos2, pos3, pos4, pos5
				jmp FIN
			Fi4:
				cmp orientacion, '0'
				je Fi4V
				mostrarBarcosY fila4, col, idBarco, orientacion, fila4, fila4, fila4, fila4, turno, pos2, pos3, pos4, pos5
				jmp FIN
			Fi3:
				cmp orientacion, '0'
				je Fi3V
				mostrarBarcosY fila3, col, idBarco, orientacion, fila3, fila3, fila3, fila3, turno, pos2, pos3, pos4, pos5
				jmp FIN
			Fi2:
				cmp orientacion, '0'
				je Fi2V
				mostrarBarcosY fila2, col, idBarco, orientacion, fila2, fila2, fila2, fila2, turno, pos2, pos3, pos4, pos5
				jmp FIN
			Fi1:
				cmp orientacion, '0'
				je Fi1V
				mostrarBarcosY fila1, col, idBarco, orientacion, fila1, fila1, fila1, fila1, turno, pos2, pos3, pos4, pos5
				jmp FIN
			Fi0V: 
				mostrarBarcosY fila10, col, idBarco, orientacion, fila9, fila8, fila7, fila6, turno, pos2, pos3, pos4, pos5
				jmp FIN
			Fi9V:  
				mostrarBarcosY fila9, col, idBarco, orientacion, fila8, fila7, fila6, fila5, turno, pos2, pos3, pos4, pos5
				jmp FIN
			Fi8V:  
				mostrarBarcosY fila8, col, idBarco, orientacion, fila7, fila6, fila5, fila4, turno, pos2, pos3, pos4, pos5
				jmp FIN
			Fi7V:  
				mostrarBarcosY fila7, col, idBarco, orientacion, fila6, fila5, fila4, fila3, turno, pos2, pos3, pos4, pos5
				jmp FIN
			Fi6V:  
				mostrarBarcosY fila6, col, idBarco, orientacion, fila7, fila8, fila9, fila10, turno, pos2, pos3, pos4, pos5
				jmp FIN
			Fi5V:  
				mostrarBarcosY fila5, col, idBarco, orientacion, fila6, fila7, fila8, fila9, turno, pos2, pos3, pos4, pos5
				jmp FIN
			Fi4V: 
				mostrarBarcosY fila4, col, idBarco, orientacion, fila5, fila6, fila7, fila8, turno, pos2, pos3, pos4, pos5
				jmp FIN
			Fi3V: 
				mostrarBarcosY fila3, col, idBarco, orientacion, fila4, fila5, fila6, fila7, turno, pos2, pos3, pos4, pos5
				jmp FIN
			Fi2V: 
				mostrarBarcosY fila2, col, idBarco, orientacion, fila3, fila4, fila5, fila6, turno, pos2, pos3, pos4, pos5
				jmp FIN
			Fi1V: 
				mostrarBarcosY fila1, col, idBarco, orientacion, fila2, fila3, fila4, fila5, turno, pos2, pos3, pos4, pos5
				jmp FIN  
			FIN:
	endm

	mostrarBarcosY macro fila, pos, idBarco, orientacion, fila2, fila3, fila4, fila5, turno, pos2, pos3, pos4, pos5
		LOCAL BARCO1V, BARCO2V, BARCO3V, BARCO4V, BARCO5V, BARCO1H, BARCO2H, BARCO3H, BARCO4H, BARCO5H, VERTICAL, HORIZONTAL, FIN, ERROR
		PUSH SI
		PUSH DX
		xor si, si

		mov DL, pos
		mov DH, 0
		mov SI, DX
		
		cmp orientacion, '0'
		je VERTICAL
		cmp orientacion, '1'
		je HORIZONTAL
	

		VERTICAL:
			cmp idBarco, '1'
			je BARCO1V
			cmp idBarco, '2'
			je BARCO2V
			cmp idBarco, '3'
			je BARCO3V
			cmp idBarco, '4'
			je BARCO4V
			cmp idBarco, '5'
			je BARCO5V
			
			BARCO1V:
				cmp fila[si], 000b
				jne ERROR
				cmp fila2[si], 000b
				jne ERROR

				mov fila[si], 001b
				mov fila2[si], 001b 
				jmp FIN
			BARCO2V:
				cmp fila[si], 000b
				jne ERROR
				cmp fila2[si], 000b
				jne ERROR
				cmp fila3[si], 000b
				jne ERROR

				mov fila[si], 010b 
				mov fila2[si], 010b 
				mov fila3[si], 010b 
				jmp FIN
			BARCO3V: 
				cmp fila[si], 000b
				jne ERROR
				cmp fila2[si], 000b
				jne ERROR
				cmp fila3[si], 000b
				jne ERROR

				mov fila[si], 011b 
				mov fila2[si], 011b 
				mov fila3[si], 011b 
				jmp FIN
			BARCO4V:
				cmp fila[si], 000b
				jne ERROR
				cmp fila2[si], 000b
				jne ERROR
				cmp fila3[si], 000b
				jne ERROR
				cmp fila4[si], 000b
				jne ERROR

				mov fila[si], 100b 
				mov fila2[si], 100b 
				mov fila3[si], 100b 
				mov fila4[si], 100b 
				jmp FIN
			BARCO5V:
				cmp fila[si], 000b
				jne ERROR
				cmp fila2[si], 000b
				jne ERROR
				cmp fila3[si], 000b
				jne ERROR
				cmp fila4[si], 000b
				jne ERROR
				cmp fila5[si], 000b
				jne ERROR

				mov fila[si], 101b 
				mov fila2[si], 101b 
				mov fila3[si], 101b 
				mov fila4[si], 101b 
				mov fila5[si], 101b 
				jmp FIN


		HORIZONTAL:   
			cmp idBarco, '1'
			je BARCO1H
			cmp idBarco, '2'
			je BARCO2H
			cmp idBarco, '3'
			je BARCO3H
			cmp idBarco, '4'
			je BARCO4H
			cmp idBarco, '5'
			je BARCO5H
			
			BARCO1H:
				mov DL, pos
				mov DH, 0
				mov SI, DX
				cmp fila[si], 000b
				jne ERROR 

				mov DL, pos2
				mov DH, 0
				mov SI, DX
				cmp fila[si], 000b
				jne ERROR 
 
				 
				mov DL, pos
				mov DH, 0
				mov SI, DX 
				mov fila[si], 001b 
				
				mov DL, pos2
				mov DH, 0
				mov SI, DX 
				mov fila[si], 001b

				jmp FIN
			BARCO2H:
				mov DL, pos
				mov DH, 0
				mov SI, DX
				cmp fila[si], 000b
				jne ERROR 

				mov DL, pos2
				mov DH, 0
				mov SI, DX
				cmp fila[si], 000b
				jne ERROR 

				mov DL, pos3
				mov DH, 0
				mov SI, DX
				cmp fila[si], 000b
				jne ERROR 
				 
				mov DL, pos
				mov DH, 0
				mov SI, DX 
				mov fila[si], 010b 

				mov DL, pos2
				mov DH, 0
				mov SI, DX 
				mov fila[si], 010b 
				
				mov DL, pos3
				mov DH, 0
				mov SI, DX 
				mov fila[si], 010b 

				jmp FIN
			BARCO3H:
				mov DL, pos
				mov DH, 0
				mov SI, DX
				cmp fila[si], 000b
				jne ERROR 

				mov DL, pos2
				mov DH, 0
				mov SI, DX
				cmp fila[si], 000b
				jne ERROR 

				mov DL, pos3
				mov DH, 0
				mov SI, DX
				cmp fila[si], 000b
				jne ERROR 
				 

				mov DL, pos
				mov DH, 0
				mov SI, DX 
				mov fila[si], 011b 
				
				mov DL, pos2
				mov DH, 0
				mov SI, DX 
				mov fila[si], 011b 
				
				mov DL, pos3
				mov DH, 0
				mov SI, DX 
				mov fila[si], 011b 

				jmp FIN
			BARCO4H:
				
				mov DL, pos
				mov DH, 0
				mov SI, DX
				cmp fila[si], 000b
				jne ERROR 

				mov DL, pos2
				mov DH, 0
				mov SI, DX
				cmp fila[si], 000b
				jne ERROR 

				mov DL, pos3
				mov DH, 0
				mov SI, DX
				cmp fila[si], 000b
				jne ERROR 
				
				mov DL, pos4
				mov DH, 0
				mov SI, DX
				cmp fila[si], 000b
				jne ERROR  


				mov DL, pos
				mov DH, 0
				mov SI, DX 
				mov fila[si], 100b 

				mov DL, pos2
				mov DH, 0
				mov SI, DX 
				mov fila[si], 100b 
				
				mov DL, pos3
				mov DH, 0
				mov SI, DX 
				mov fila[si], 100b 
				
				mov DL, pos4
				mov DH, 0
				mov SI, DX 
				mov fila[si], 100b 

				jmp FIN
			BARCO5H:

				mov DL, pos
				mov DH, 0
				mov SI, DX
				cmp fila[si], 000b
				jne ERROR 

				mov DL, pos2
				mov DH, 0
				mov SI, DX
				cmp fila[si], 000b
				jne ERROR 

				mov DL, pos3
				mov DH, 0
				mov SI, DX
				cmp fila[si], 000b
				jne ERROR 
				
				mov DL, pos4
				mov DH, 0
				mov SI, DX
				cmp fila[si], 000b
				jne ERROR 
				
				mov DL, pos5
				mov DH, 0
				mov SI, DX
				cmp fila[si], 000b
				jne ERROR 


				mov DL, pos
				mov DH, 0
				mov SI, DX 
				mov fila[si], 101b 

				mov DL, pos2
				mov DH, 0
				mov SI, DX 
				mov fila[si], 101b 

				mov DL, pos3
				mov DH, 0
				mov SI, DX 
				mov fila[si], 101b 
				
				mov DL, pos4
				mov DH, 0
				mov SI, DX 
				mov fila[si], 101b 
				
				mov DL, pos5
				mov DH, 0
				mov SI, DX 
				mov fila[si], 101b 

				jmp FIN
		
		ERROR:
			jmp ERROROCUPADO
		FIN:	
			;MENSAJE
			POP DX
			POP SI

	endm

	marcarDisparo macro fila, posicionColumna, disparos, barcos, turno
		LOCAL BARCO1V, BARCO2V, BARCO3V, BARCO4V, BARCO5V, NADA, FIN, ERROR
		PUSH SI
		PUSH DX
		xor si, si

		MOV DL, posicionColumna
		MOV DH, 0
		MOV SI, DX
		 

		 
		cmp disparos[si], 110b
		je ERROR
		cmp disparos[si], 111b
		je ERROR
			
		cmp barcos[si], 001b
		je BARCO1V
		cmp barcos[si], 010b 
		je BARCO2V
		cmp barcos[si], 011b
		je BARCO3V
		cmp barcos[si], 100b 
		je BARCO4V
		cmp barcos[si], 101b 
		je BARCO5V
		jmp NADA

		BARCO1V:
			mov disparos[si], 110b 
			mov barcos[si], 110b 
			jmp FIN

		BARCO2V: 
			mov disparos[si], 110b  
			mov barcos[si], 110b  
			jmp FIN

		BARCO3V: 
			mov disparos[si], 110b  
			mov barcos[si], 110b  
			jmp FIN

		BARCO4V: 
			mov disparos[si], 110b  
			mov barcos[si], 110b  
			jmp FIN

		BARCO5V: 
			mov disparos[si], 110b  
			mov barcos[si], 110b  
			jmp FIN

		NADA:
			mov disparos[si], 111b  
			mov barcos[si], 111b  
			jmp FIN 
		ERROR:
			jmp ERRORYADISPARO
		FIN:	
			;MENSAJE
			POP DX
			POP SI

	endm


	imprimir macro len, fichaX, fichaO, y, vc, f, ln, enter, B1, B2, B3, B4, B5
		LOCAL DO, VER1, VER2, VER3, VER4, VER5, VER6, VER7, VERVC, FIN, COMPARE

		;000b->VACIO 	001b->FX 	100b->FO	010b->P		011b->Q		101b->R
		;1100b fichaPb    1101 fichaRb       1111 fichaRIb     1110 fichaQb
		;print ln
		print y
		PUSH SI
		PUSH AX
		xor si, si
		DO:
			mov al, [f+si] 
			cmp al, 001b
			je VER1
			cmp al, 010b
			je VER2
			cmp al, 011b
			je VER3
			cmp al, 100b
			je VER4
			cmp al, 101b
			je VER5
			cmp al, 110b
			je VER6	;FICHA X
			cmp al, 111b
			je VER7 ;FICHA O
			jmp VERVC
		COMPARE:
			inc si  
			cmp si, len  
			jb DO
			jmp FIN
		VER1:
			print B1
			jmp COMPARE
		VER2:
			print B2
			jmp COMPARE	
		VER3: 
			print B3
			jmp COMPARE	
		VER4:
			print B4	
			jmp COMPARE	
		VER5:
			print B5
			jmp COMPARE	
		VER6:
			print fichaX
			jmp COMPARE	
		VER7:
			print fichaO
			jmp COMPARE	
		VERVC:
			print vc
			jmp COMPARE
		FIN:
			POP AX
			POP SI
			print enter
	endm
 

	imprimirHtml macro len, fb, fn, f, vb, vn, tr, ctr, handleFichero
		LOCAL DO, VERFN, VERFB, VERVB, VERVN, FIN, COMPARE
		PUSH SI
		PUSH AX
		xor si, si
		escribirArchivo SIZEOF tr, tr, handleFichero
		DO:
			mov al, [f+si]		;AQUI
			cmp al, 001b
			je VERFB
			cmp al, 100b
			je VERFN
			cmp al, 000b
			je VERVB
			jmp VERVN
		COMPARE:
			inc si 				;AQUI
			cmp si, len 		;AQUI
			jb DO
			jmp FIN
		VERFB:
			escribirArchivo SIZEOF fb, fb, handleFichero
			jmp COMPARE
		VERFN:
			escribirArchivo SIZEOF fn, fn, handleFichero
			jmp COMPARE	
		VERVB:
			escribirArchivo SIZEOF vb, vb, handleFichero
			jmp COMPARE
		VERVN:
			escribirArchivo SIZEOF vn, vn, handleFichero
			jmp COMPARE
		FIN:
			escribirArchivo SIZEOF ctr, ctr, handleFichero
			POP AX
			POP SI
	endm

	imprimirArq macro len, sc, spc, f, char0, char1, char2, char3, char4, handleFichero
		LOCAL DO, VERFN, VERFB, VERFP, VERFQ, VERFR, VERFRI, VERVC, VERFPB, VERFRB, VERFRIB, VERFQB, FIN, COMPARE
		PUSH SI
		PUSH AX
		xor si, si

		mov al, [f+si]
		cmp al, 001b
		je VERFB
		cmp al, 100b
		je VERFN
		cmp al, 010b
		je VERFP
		cmp al, 011b
		je VERFQ
		cmp al, 101b
		je VERFR
		cmp al, 110b
		je VERFRI
		cmp al, 1100b
		je VERFPB
		cmp al, 1101b
		je VERFRIB
		cmp al, 1111b
		je VERFRB
		cmp al, 1110b
		je VERFQB
		jmp VERVC

		DO:
			escribirArchivo SIZEOF sc, sc, handleFichero
			mov al, [f+si]
			cmp al, 001b
			je VERFB
			cmp al, 100b
			je VERFN
			cmp al, 010b
			je VERFP
			cmp al, 011b
			je VERFQ
			cmp al, 101b
			je VERFR
			cmp al, 110b
			je VERFRI
			cmp al, 1100b
			je VERFPB
			cmp al, 1101b
			je VERFRIB
			cmp al, 1111b
			je VERFRB
			cmp al, 1110b
			je VERFQB
			jmp VERVC
		COMPARE:
			inc si 				;AQUI
			cmp si, len 		;AQUI
			jb DO
			jmp FIN
		VERFB:		;FX
			escribirArchivo SIZEOF char1, char1, handleFichero
			jmp COMPARE
		VERFN:		;FO
			escribirArchivo SIZEOF char2, char2, handleFichero
			jmp COMPARE	
		VERVC:		;VACIO
			escribirArchivo SIZEOF char0, char0, handleFichero
			jmp COMPARE
		VERFP:		;P	 
			jmp COMPARE	
		VERFQ:		;Q 
			jmp COMPARE	
		VERFR:		;R
			escribirArchivo SIZEOF char3, char3, handleFichero
			jmp COMPARE	
		VERFRI:		;RI
			escribirArchivo SIZEOF char4, char4, handleFichero 
			jmp COMPARE
		VERFPB:		;BLANCA P
			jmp COMPARE
		VERFRB:		;BLANCA R
			escribirArchivo SIZEOF char3, char3, handleFichero
			jmp COMPARE
		VERFRIB:	;BLANCA RI
			escribirArchivo SIZEOF char4, char4, handleFichero
			jmp COMPARE
		VERFQB:		;BLANCA Q
			jmp COMPARE
		FIN:
			escribirArchivo SIZEOF spc, spc, handleFichero
			POP AX
			POP SI
	endm

;************************** JUGABILIDAD **********************************

	verificarCoordenadas macro fila, columna
		LOCAL DO1, DO2, LETRA1, LETRA2, LETRA3, LETRA4, LETRA5, LETRA6, LETRA7, LETRA8, LETRA9, LETRA10, NUM1, NUM2, NUM3, NUM4, NUM5, NUM6, NUM7, NUM8, NUM9, NUM10, ULTIMO, FIN

		PUSH SI
		PUSH AX
		

		DO1: 
			cmp columna, 65
			je LETRA1
			cmp columna, 66
			je LETRA2
			cmp columna, 67
			je LETRA3
			cmp columna, 68
			je LETRA4
			cmp columna, 69
			je LETRA5
			cmp columna, 70
			je LETRA6
			cmp columna, 71
			je LETRA7
			cmp columna, 72
			je LETRA8
			cmp columna, 73
			je LETRA9
			cmp columna, 74
			je LETRA10 
			jmp ERROR_COORD
		DO2:  		
			cmp fila, '1'
			je NUM1
			cmp fila, '2'
			je NUM2
			cmp fila, '3'
			je NUM3
			cmp fila, '4'
			je NUM4
			cmp fila, '5'
			je NUM5
			cmp fila, '6'
			je NUM6
			cmp fila, '7'
			je NUM7
			cmp fila, '8'
			je NUM8
			cmp fila, '9'
			je NUM9 
			cmp fila, '0'
			je NUM10
			jmp ERROR_COORD

		LETRA1: 
			mov columna, 65
			jmp DO2


		LETRA2: 
			mov columna, 66
			jmp DO2


		LETRA3: 
			mov columna, 67
			jmp DO2


		LETRA4: 
			mov columna, 68
			jmp DO2


		LETRA5: 
			mov columna, 69
			jmp DO2

		LETRA6: 
			mov columna, 70
			jmp DO2


		LETRA7: 
			mov columna, 71
			jmp DO2


		LETRA8: 
			mov columna, 72
			jmp DO2


		LETRA9: 
			mov columna, 73
			jmp DO2
	
		LETRA10: 
			mov columna, 74
			jmp DO2
	
		NUM1: 
			mov fila, '1'
			jmp ULTIMO

		NUM2: 
			mov fila, '2'
			jmp ULTIMO

		NUM3: 
			mov fila, '3'
			jmp ULTIMO

		NUM4: 
			mov fila, '4'
			jmp ULTIMO

		NUM5: 
			mov fila, '5' 
			jmp ULTIMO

		NUM6: 
			mov fila, '6'
			jmp ULTIMO

		NUM7: 
			mov fila, '7'
			jmp ULTIMO

		NUM8: 
			mov fila, '8'
			jmp ULTIMO

		NUM9: 
			mov fila, '9'
			jmp ULTIMO

		NUM10: 
			mov fila, '0'  
			jmp ULTIMO

		ULTIMO: 
			POP AX
			POP SI
	endm

	obtenerPos macro col, pos
		LOCAL P1, P2, P3, P4, P5, P6, P7, P8, P9, P10, FIN

		cmp col, 74
		je P10
		cmp col, 73
		je P9
		cmp col, 72
		je P8
		cmp col, 71
		je P7
		cmp col, 70
		je P6
		cmp col, 69
		je P5
		cmp col, 68
		je P4
		cmp col, 67
		je P3
		cmp col, 66
		je P2
		cmp col, 65
		je P1

		P10:
			mov pos, 0000b
			jmp FIN
		P9:
			mov pos, 0001b
			jmp FIN
		P8:
			mov pos, 0010b
			jmp FIN
		P7:
			mov pos, 0011b
			jmp FIN
		P6:
			mov pos, 0100b
			jmp FIN
		P5:
			mov pos, 0101b
			jmp FIN
		P4:
			mov pos, 0110b
			jmp FIN
		P3:
			mov pos, 0111b
			jmp FIN
		P2:
			mov pos, 1000b
			jmp FIN
		P1:
			mov pos, 1001b
			jmp FIN
		FIN: 

	endm
 
	colocarXP macro f1, pos1, fila6, fila5, fila4, fila3, fila2, fila1, fila7, turno
		LOCAL F5, F4, F3, FIN, F22, F11
		cmp f1, '1'
		je F11
		cmp f1, '2'
		je F22
		cmp f1, '3'
		je F3
		cmp f1, '4'
		je F4
		cmp f1, '5'
		je F5
		jmp INGRESAR
		F5:
			moverAbajo pos1, fila5, fila4, fila3, fila2, fila1
			colocarYP fila5, pos1, fila6, fila5, fila4, fila3, fila2, fila1, fila7, turno
			je FIN
		F4:
			colocarYP fila4, pos1, fila6, fila5, fila4, fila3, fila2, fila1, fila7, turno
			je FIN
		F3:
			colocarYP fila3, pos1, fila6, fila5, fila4, fila3, fila2, fila1, fila7, turno
			je FIN
		F22:
			colocarYP fila2, pos1, fila6, fila5, fila4, fila3, fila2, fila1, fila7, turno
			je FIN
		F11:
			colocarYP fila1, pos1, fila6, fila5, fila4, fila3, fila2, fila1, fila7, turno
			je FIN
		FIN:
			
	endm

	colocarYP macro f, pos1, fila6, fila5, fila4, fila3, fila2, fila1, fila7, turno
		LOCAL VALIDACION1, CompX, CompO, M1, FIN, M2
		PUSH SI
		PUSH DX
		xor si, si

		MOV DL, pos1
		MOV DH, 0
		MOV SI, DX

		VALIDACION1:
			cmp turno, 0b
			je CompX

			cmp turno, 1b
			je CompO

		CompX:
			cmp f[si], 000b
			je M1;VALIDACION2

			cmp f[si], 100b
			je ERROR_SEL

			jmp FIN

		CompO: 
			cmp f[si], 000b
			je M2;VALIDACION2

			cmp f[si], 001b
			je ERROR_SEL

			jmp FIN

		M1:
			mov f[si], 001b
			jmp FIN;M2

		M2: 
			mov f[si], 100b
			jmp FIN

		FIN:	
			;MENSAJE
			POP DX
			POP SI
	endm
 
;******************* MACROS PARA COMPARACION DE COMANDOS ****************

	comparacionNO1 macro comando, buffer, filaBarco
		LOCAL FIN, SALIDA
		PUSH SI
		PUSH AX
		xor si, si

		mov CX, 50
		mov AX, DS
		mov ES, AX
		lea si, comando
		lea di, buffer
		
		repne cmpsw
		je FIN
		jmp SALIDA
		FIN:
			mov filaBarco, '1'
			jmp SALIDA
		SALIDA: 
			POP AX
			POP SI
	endm

	comparacionNO2 macro comando, buffer, filaBarco
		LOCAL FIN, SALIDA
		PUSH SI
		PUSH AX
		xor si, si

		mov CX, 50
		mov AX, DS
		mov ES, AX
		lea si, comando
		lea di, buffer
		
		repne cmpsw
		je FIN
		jmp SALIDA
		FIN:
			mov filaBarco, '2'
			jmp SALIDA
		SALIDA: 
			POP AX
			POP SI
	endm

	comparacionNO3 macro comando, buffer, filaBarco
		LOCAL FIN, SALIDA
		PUSH SI
		PUSH AX
		xor si, si

		mov CX, 50
		mov AX, DS
		mov ES, AX
		lea si, comando
		lea di, buffer
		
		repne cmpsw
		je FIN
		jmp SALIDA
		FIN:
			mov filaBarco, '3'
			jmp SALIDA
		SALIDA: 
			POP AX
			POP SI
	endm

	comparacionNO4 macro comando, buffer, filaBarco
		LOCAL FIN, SALIDA
		PUSH SI
		PUSH AX
		xor si, si

		mov CX, 50
		mov AX, DS
		mov ES, AX
		lea si, comando
		lea di, buffer
		
		repne cmpsw
		je FIN
		jmp SALIDA
		FIN:
			mov filaBarco, '4'
			jmp SALIDA
		SALIDA: 
			POP AX
			POP SI
	endm

	comparacionNO5 macro comando, buffer, filaBarco
		LOCAL FIN, SALIDA
		PUSH SI
		PUSH AX
		xor si, si

		mov CX, 50
		mov AX, DS
		mov ES, AX
		lea si, comando
		lea di, buffer
		
		repne cmpsw
		je FIN
		jmp SALIDA
		FIN:
			mov filaBarco, '5'
			jmp SALIDA
		SALIDA: 
			POP AX
			POP SI
	endm

	comparacionNO6 macro comando, buffer, filaBarco
		LOCAL FIN, SALIDA
		PUSH SI
		PUSH AX
		xor si, si

		mov CX, 50
		mov AX, DS
		mov ES, AX
		lea si, comando
		lea di, buffer
		
		repne cmpsw
		je FIN
		jmp SALIDA
		FIN:
			mov filaBarco, '6'
			jmp SALIDA
		SALIDA: 
			POP AX
			POP SI
	endm

	comparacionNO7 macro comando, buffer, filaBarco
		LOCAL FIN, SALIDA
		PUSH SI
		PUSH AX
		xor si, si

		mov CX, 50
		mov AX, DS
		mov ES, AX
		lea si, comando
		lea di, buffer
		
		repne cmpsw
		je FIN
		jmp SALIDA
		FIN:
			mov filaBarco, '7'
			jmp SALIDA
		SALIDA: 
			POP AX
			POP SI
	endm

	comparacionNO8 macro comando, buffer, filaBarco
		LOCAL FIN, SALIDA
		PUSH SI
		PUSH AX
		xor si, si

		mov CX, 50
		mov AX, DS
		mov ES, AX
		lea si, comando
		lea di, buffer
		
		repne cmpsw
		je FIN
		jmp SALIDA
		FIN:
			mov filaBarco, '8'
			jmp SALIDA
		SALIDA: 
			POP AX
			POP SI
	endm

	comparacionNO9 macro comando, buffer, filaBarco
		LOCAL FIN, SALIDA
		PUSH SI
		PUSH AX
		xor si, si

		mov CX, 50
		mov AX, DS
		mov ES, AX
		lea si, comando
		lea di, buffer
		
		repne cmpsw
		je FIN
		jmp SALIDA
		FIN:
			mov filaBarco, '9'
			jmp SALIDA
		SALIDA: 
			POP AX
			POP SI
	endm

	comparacionNO10 macro comando, buffer, filaBarco
		LOCAL FIN, SALIDA
		PUSH SI
		PUSH AX
		xor si, si

		mov CX, 50
		mov AX, DS
		mov ES, AX
		lea si, comando
		lea di, buffer
		
		repne cmpsw
		je FIN
		jmp SALIDA
		FIN:
			mov filaBarco, '0'
			jmp SALIDA
		SALIDA: 
			POP AX
			POP SI
	endm


	comparacion1 macro comandoE, buffer
		PUSH SI
		PUSH AX
		xor si, si

		mov CX, 50
		mov AX, DS
		mov ES, AX
		lea si, comandoE
		lea di, buffer
		
		repne cmpsw
		je MenuPrincipal

		POP AX
		POP SI
	endm

	comparacion2 macro comandoS, buffer
		PUSH SI
		PUSH AX
		xor si, si

		mov CX, 50
		mov AX, DS
		mov ES, AX
		lea si, comandoS
		lea di, buffer
		repne cmpsw
		je SAVE
		
		POP AX
		POP SI
	endm

	comparacion3 macro comandoS, buffer
		PUSH SI
		PUSH AX
		xor si, si

		mov CX, 50
		mov AX, DS
		mov ES, AX

		lea si, comandoS
		lea di, buffer
		repne cmpsw
		je SHOW
		
		POP AX
		POP SI
	endm


;*************************** MACROS PARA LOS ARCHIVOS *******************************
	Ruta macro buffer
		LOCAL INICIO,FIN
		xor si,si
		INICIO:
			getChar
			cmp al,0dh
			je FIN
			mov buffer[si],al
			inc si
			jmp INICIO
		FIN:
			mov buffer[si],00h;AÑADIR EL .ARQ
	endm

	crearArchivo macro buffer,handle
		mov ah,3ch
		mov cx,00h
		lea dx,buffer
		int 21h
		mov handle,ax
		jc ErrorCrear
	endm

	abrirArchivo macro ruta,handle
		mov ah,3dh
		mov al,10b
		lea dx,ruta
		int 21h
		mov handle,ax
		jc ErrorAbrir
	endm

	leerArchivo macro numbytes,buffer,handle
		mov ah,3fh
		mov bx,handle
		mov cx,numbytes
		lea dx,buffer
		int 21h
		jc ErrorLeer
	endm

	cerrarArchivo macro handle
		mov ah,3eh
		mov handle,bx
		int 21h
	endm

	escribirArchivo macro numbytes,buffer,handle
		mov ah, 40h
		mov bx,handle
		mov cx,numbytes
		lea dx,buffer
		int 21h
		jc ErrorEscribir
	endm

	fecha macro
		LOCAL getD, getM, getA
		PUSH SI
		PUSH AX
		xor si, si

		MOV AH,2AH    ; To get System Time
		INT 21H
		
		getD:
			MOV AL,DL     ; Hour is in CH
			CALL Siguiente
			MOV AL, 2fh		; '/'
			MOV bufferFecha[si], AL
			inc si
		getM:
			MOV AL,DH     ; Minutes is in CL
			CALL Siguiente
			MOV AL, 2fh		; '/'
			MOV bufferFecha[si], AL
			inc si
		getA:
			MOV AL,DH     ; Seconds is in DH
			ADD CX,0F830H ; To negate the effects of 16bit value,
			MOV AX,CX     ; since AAM is applicable only for AL (YYYY -> YY)
			CALL Siguiente

		POP AX
		POP SI
	endm

	hora macro
		LOCAL getH, getM, getS
		PUSH SI
		PUSH AX
		xor si, si

		MOV AH,2CH    ; To get System Time
		INT 21H
		
		getH:
			MOV AL,CH     ; Hour is in CH
			CALL Sig
			MOV AL, 3ah		; ':'
			MOV bufferHora[si], AL
			inc si
		getM:
			MOV AL,CL     ; Minutes is in CL
			CALL Sig
			MOV AL, 3ah		; ':'
			MOV bufferHora[si], AL
			inc si
		getS:
			MOV AL,DH     ; Seconds is in DH
			CALL Sig

		POP AX
		POP SI
	endm
	