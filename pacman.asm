inicializarPacman:
    ; Iniciar en la segunda posici�n de la segunda fila para dibujar puntos
    MOVLW 0xC1             ; Comando para mover el cursor a la segunda fila, segunda columna
    CALL enviarComando
    CALL retardo2ms        ; Esperar 2 ms      
	CLRF posicion_pacman

	; ===========Instrucciones para dibujar puntos============
dibuja_puntos:
	MOVLW 0xA5 ;Punto
	CALL enviarDato
	INCF posicion_pacman ;Incrementa la posicion
	MOVF posicion_pacman, W
	SUBLW 0x0E ; 14 iteraciones desde la segunda posicion hasta el penultimo arreglo del display
	BTFSS STATUS, Z ;Si haz alcanzado 14, salta
	goto dibuja_puntos

    MOVLW 0x02             ; Direcci�n del primer car�cter personalizado en la CGRAM
    CALL enviarDato        ; Mostrar el primer car�cter
    CALL retardo250ms      ; Esperar 250 ms

; ===========Instrucciones para dibujar al pacman============   
    MOVLW 0xC0             ; Comando para mover el cursor a la primera fila, primera columna
    MOVWF posicion_pacman  ; Guardar la posici�n inicial
    CALL enviarComando
    CALL retardo2ms        ; Esperar 2 ms
    MOVF posicion_pacman, W       ; Cargar la posici�n actual
    CALL enviarComando     ; Mover el cursor a la posici�n actual
    MOVLW 0x00             ; Direcci�n del primer car�cter personalizado en la CGRAM
    CALL enviarDato        ; Mostrar el primer car�cter
    CALL retardo250ms      ; Esperar 250 ms
	RETURN

animacion_pacman:
	;===========Primera animacion de comer ============
    ; Mostrar la primera figura de Pacman
    ; Borrar la posici�n actual antes de mover el cursor
    MOVF posicion_pacman, W       ; Cargar la posici�n actual
    CALL enviarComando     ; Mover el cursor a la posici�n actual
    MOVLW 0x00             ; Direcci�n del primer car�cter personalizado en la CGRAM
    CALL enviarDato        ; Mostrar el primer car�cter
    CALL retardo250ms      ; Esperar 250 ms

    ; Borrar la posici�n actual antes de mover el cursor
    MOVF posicion_pacman, W       ; Cargar la posici�n actual
    CALL enviarComando     ; Mover el cursor a la posici�n actual
    ; Mostrar la segunda figura de Pacman
    MOVLW 0x01             ; Direcci�n del segundo car�cter personalizado en la CGRAM
    CALL enviarDato        ; Mostrar el segundo car�cter
    CALL retardo250ms      ; Esperar 250 ms
    
    ; Borrar la posici�n actual antes de mover el cursor
    MOVF posicion_pacman, W       ; Cargar la posici�n actual
    CALL enviarComando     ; Mover el cursor a la posici�n actual
    MOVLW ' '              ; Cargar un espacio para borrar
    CALL enviarDato        ; Escribir el espacio

    ; Borrar la posici�n actual antes de mover el cursor
    MOVF posicion_pacman, W       ; Cargar la posici�n actual
    CALL enviarComando     ; Mover el cursor a la posici�n actual

	;===========Segunda animacion de comer ============
    ; Mostrar la primera figura de Pacman
    MOVLW 0x00             ; Direcci�n del primer car�cter personalizado en la CGRAM
    CALL enviarDato        ; Mostrar el primer car�cter
    CALL retardo250ms      ; Esperar 250 ms

    ; Borrar la posici�n actual antes de mover el cursor
    MOVF posicion_pacman, W       ; Cargar la posici�n actual
    CALL enviarComando     ; Mover el cursor a la posici�n actual
    ; Mostrar la segunda figura de Pacman
    MOVLW 0x01             ; Direcci�n del segundo car�cter personalizado en la CGRAM
    CALL enviarDato        ; Mostrar el segundo car�cter
    CALL retardo250ms      ; Esperar 250 ms
    
    ; Borrar la posici�n actual antes de mover el cursor
    MOVF posicion_pacman, W       ; Cargar la posici�n actual
    CALL enviarComando     ; Mover el cursor a la posici�n actual
    MOVLW ' '              ; Cargar un espacio para borrar
    CALL enviarDato        ; Escribir el espacio

    ; =========Se mueve manualmente la posicion del cursor=========
    INCF posicion_pacman, F       ; Incrementar la posici�n
    MOVF posicion_pacman, W       ; Cargar la nueva posici�n
    CALL enviarComando     ; Mover el cursor a la nueva posici�n

	MOVF posicion_pacman, W       ; Cargar la nueva posici�n
	SUBLW 0xD0 			   ; D0 = CF (Ultima posicion del display) + 1
	BTFSS STATUS, Z 	  ;Si llegaste al final del display, reinicia la animacion
    RETURN
	goto inicializarPacman