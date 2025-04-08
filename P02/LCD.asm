inciarDisplay:
	CALL retardo50ms	   ; Esperar a estabilizacion de voltaje
	MOVLW 0x30			   ; Comando 0x30
	CALL enviarComando	   ; Enviar comando
    CALL retardo5ms        ; Esperar 5 ms
	MOVLW 0x30             ; Comando 0x30
	CALL enviarComando	   ; Enviar comando
    CALL retardo100us      ; Esperar 100 us
	MOVLW 0x30             ; Comando 0x30
	CALL enviarComando	   ; Enviar comando
    CALL retardo100us      ; Esperar 100 us
	MOVLW 0x38             ; Comando 0x38, Modo 8 bits, 2 líneas, 5x8
	CALL enviarComando	   ; Enviar comando
	MOVLW 0x0C             ; Comando 0x0C, Display ON, cursor OFF
	CALL enviarComando	   ; Enviar comando
	MOVLW 0x01             ; Comando 0x01, Limpiar pantalla
	CALL enviarComando	   ; Enviar comando
	CALL retardo2ms		   ; Esperar 2 ms
	MOVLW 0x06             ; Comando 0x06, Entrada de datos
	CALL enviarComando	   ; Enviar comando
	RETURN

enviarComando:
    BCF     RS             ; RS = 0 (comando)
    BCF     RW             ; RW = 0 (escritura)
    MOVWF   DATOS          ; Colocar comando en PORTC
    BSF     E              ; E = 1
    CALL    retardo100us   ;Pequeno retardo
    BCF     E              ; E = 0
    RETURN

enviarDato:
    BSF     RS             ; RS = 1 (modo dato)
    BCF     RW             ; RW = 0 (modo escritura)
    MOVWF   DATOS          ; Escribir en el puerto de datos
    BSF     E              ; E = 1 (activar LCD)
    CALL    retardo100us   ; Pequeño retardo
    BCF     E              ; E = 0 (desactivar LCD)
    RETURN
