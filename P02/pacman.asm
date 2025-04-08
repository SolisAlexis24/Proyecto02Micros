inicializarPacman:
    ; Iniciar en la segunda posición de la segunda fila para dibujar puntos
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

    MOVLW 0x02             ; Dirección del primer carácter personalizado en la CGRAM
    CALL enviarDato        ; Mostrar el primer carácter
    CALL retardo250ms      ; Esperar 250 ms

; ===========Instrucciones para dibujar al pacman============   
    MOVLW 0xC0             ; Comando para mover el cursor a la primera fila, primera columna
    MOVWF posicion_pacman  ; Guardar la posición inicial
    CALL enviarComando
    CALL retardo2ms        ; Esperar 2 ms
    MOVF posicion_pacman, W       ; Cargar la posición actual
    CALL enviarComando     ; Mover el cursor a la posición actual
    MOVLW 0x00             ; Dirección del primer carácter personalizado en la CGRAM
    CALL enviarDato        ; Mostrar el primer carácter
    CALL retardo250ms      ; Esperar 250 ms
	RETURN

animacion_pacman:
	;===========Primera animacion de comer ============
    ; Mostrar la primera figura de Pacman
    ; Borrar la posición actual antes de mover el cursor
    MOVF posicion_pacman, W       ; Cargar la posición actual
    CALL enviarComando     ; Mover el cursor a la posición actual
    MOVLW 0x00             ; Dirección del primer carácter personalizado en la CGRAM
    CALL enviarDato        ; Mostrar el primer carácter
    CALL retardo250ms      ; Esperar 250 ms

    ; Borrar la posición actual antes de mover el cursor
    MOVF posicion_pacman, W       ; Cargar la posición actual
    CALL enviarComando     ; Mover el cursor a la posición actual
    ; Mostrar la segunda figura de Pacman
    MOVLW 0x01             ; Dirección del segundo carácter personalizado en la CGRAM
    CALL enviarDato        ; Mostrar el segundo carácter
    CALL retardo250ms      ; Esperar 250 ms
    
    ; Borrar la posición actual antes de mover el cursor
    MOVF posicion_pacman, W       ; Cargar la posición actual
    CALL enviarComando     ; Mover el cursor a la posición actual
    MOVLW ' '              ; Cargar un espacio para borrar
    CALL enviarDato        ; Escribir el espacio

    ; Borrar la posición actual antes de mover el cursor
    MOVF posicion_pacman, W       ; Cargar la posición actual
    CALL enviarComando     ; Mover el cursor a la posición actual

	;===========Segunda animacion de comer ============
    ; Mostrar la primera figura de Pacman
    MOVLW 0x00             ; Dirección del primer carácter personalizado en la CGRAM
    CALL enviarDato        ; Mostrar el primer carácter
    CALL retardo250ms      ; Esperar 250 ms

    ; Borrar la posición actual antes de mover el cursor
    MOVF posicion_pacman, W       ; Cargar la posición actual
    CALL enviarComando     ; Mover el cursor a la posición actual
    ; Mostrar la segunda figura de Pacman
    MOVLW 0x01             ; Dirección del segundo carácter personalizado en la CGRAM
    CALL enviarDato        ; Mostrar el segundo carácter
    CALL retardo250ms      ; Esperar 250 ms
    
    ; Borrar la posición actual antes de mover el cursor
    MOVF posicion_pacman, W       ; Cargar la posición actual
    CALL enviarComando     ; Mover el cursor a la posición actual
    MOVLW ' '              ; Cargar un espacio para borrar
    CALL enviarDato        ; Escribir el espacio

    ; =========Se mueve manualmente la posicion del cursor=========
    INCF posicion_pacman, F       ; Incrementar la posición
    MOVF posicion_pacman, W       ; Cargar la nueva posición
    CALL enviarComando     ; Mover el cursor a la nueva posición

	MOVF posicion_pacman, W       ; Cargar la nueva posición
	SUBLW 0xD0 			   ; D0 = CF (Ultima posicion del display) + 1
	BTFSS STATUS, Z 	  ;Si llegaste al final del display, reinicia la animacion
    RETURN
	goto inicializarPacman