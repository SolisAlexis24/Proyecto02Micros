inicializarMensaje:
    MOVLW 0x8F       ; Colocar el cursor en la �ltima posici�n de la primera l�nea
    MOVWF posicionMensaje
	CALL enviarComando
    CLRF overflow
    CLRF contadorOver
	CLRF temp    ; Reiniciar el �ndice antes de escribir el mensaje
    CALL mostrarMensaje 
    RETURN  

animarMensaje:
    MOVFW overflow	
    XORLW 0x01
    BTFSC STATUS, Z  
    GOTO animarOverflow

    CALL borrarPrimeraFila
    MOVF posicionMensaje, W
    CALL enviarComando

    CLRF temp    ; Reiniciar el �ndice antes de escribir el mensaje
    CALL mostrarMensaje ; Llamar a la rutina de escritura
	DECF posicionMensaje, F

    ; Verificar si llegamos al borde izquierdo (0x80)
    MOVF posicionMensaje, W
    XORLW 0x80
    BTFSS STATUS, Z      
    RETURN                

    ; Si lleg� a 0x80, activar overflow
    BSF overflow, 0       
    MOVLW 0x8F       ; Colocar el cursor en la �ltima posici�n de la primera l�nea
    MOVWF posicionMensaje
    CLRF contadorOver   
    RETURN               

animarOverflow:
    CALL borrarPrimeraFila
    MOVLW 0x80           
    CALL enviarComando

    ; Escribir el mensaje omitiendo los primeros "contadorOver" caracteres
    CLRF temp
	MOVF contadorOver, W ; 
	MOVWF temp
	CALL mostrarMensaje

    ; Incrementar contador para omitir m�s caracteres en la siguiente iteraci�n
    INCF contadorOver, F

	MOVF contadorOver, W
	XORLW 0x17 ;22 caracteres (longitud del mensaje)
	BTFSC STATUS, Z      
    CLRF overflow        
    
    RETURN            


borrarPrimeraFila:
    MOVLW 0x80  
    CALL enviarComando
    MOVLW 16
    MOVWF char_ptr
borrarLoop:
    MOVLW ' '   
    CALL enviarDato
    DECFSZ char_ptr, F
    GOTO borrarLoop
    RETURN


; Rutina para mostrar el mensaje completo
mostrarMensaje:
    MOVF    temp, W     ; Cargar �ndice
    CALL    escribirMensaje ; Obtener car�cter
	MOVWF   charTmp
	XORLW   0x00
    BTFSC   STATUS, Z   ; Verificar si es cero (fin de cadena)
    RETURN              ; Terminar si es fin de cadena
	MOVF 	charTmp, W
    CALL    enviarDato  ; Mostrar car�cter en LCD
    INCF    temp, F     ; Incrementar �ndice
    GOTO    mostrarMensaje ; Repetir

; M�todo seguro para tablas grandes
escribirMensaje:
    MOVWF   temp        ; Guardar el �ndice temporalmente
    MOVLW   HIGH tabla_mensaje  ; Cargar parte alta de la direcci�n
    MOVWF   PCLATH      ; Configurar PCLATH
    MOVF    temp, W     ; Recuperar el �ndice
    ADDWF   PCL, F      ; Sumar al contador de programa

tabla_mensaje:
    RETLW   'E'
    RETLW   'q'
    RETLW   'u'
    RETLW   'i'
    RETLW   'p'
    RETLW   'o'
    RETLW   ':'
    RETLW   '9'
    RETLW   ' '
    RETLW   'I'
    RETLW   'a'
    RETLW   'n'
    RETLW   ' '
    RETLW   'J'
    RETLW   'u'
    RETLW   'a'
    RETLW   'n'
    RETLW   ' '
    RETLW   'G'
    RETLW   'a'
    RETLW   'e'
    RETLW   'l'
    RETLW   0           ; Fin de cadena
