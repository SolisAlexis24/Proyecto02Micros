cargarCaracteresAnimacion:
    ; Definir el primer carácter personalizado (Pacman 1)
    MOVLW 0x40             ; Dirección de inicio de la CGRAM (0x40 + 0 * 8)
    CALL enviarComando     ; Enviar comando para escribir en la CGRAM
    CALL retardo2ms        ; Esperar 2 ms
    MOVLW 0x00             ; Fila 1
    CALL enviarDato
    MOVLW 0x0E             ; Fila 2
    CALL enviarDato
    MOVLW 0x1B             ; Fila 3
    CALL enviarDato
    MOVLW 0x1F             ; Fila 4
    CALL enviarDato
    MOVLW 0x1F             ; Fila 5
    CALL enviarDato
    MOVLW 0x1F             ; Fila 6
    CALL enviarDato
    MOVLW 0x0E             ; Fila 7
    CALL enviarDato
    MOVLW 0x00             ; Fila 8
    CALL enviarDato

    ; Definir el segundo carácter personalizado (Pacman 2)
    MOVLW 0x48             ; Dirección de inicio de la CGRAM (0x40 + 1 * 8)
    CALL enviarComando     ; Enviar comando para escribir en la CGRAM
    CALL retardo2ms        ; Esperar 2 ms
    MOVLW 0x00             ; Fila 1
    CALL enviarDato
    MOVLW 0x0F             ; Fila 2
    CALL enviarDato
    MOVLW 0x1A             ; Fila 3
    CALL enviarDato
    MOVLW 0x1C             ; Fila 4
    CALL enviarDato
    MOVLW 0x1C             ; Fila 5
    CALL enviarDato
    MOVLW 0x1E             ; Fila 6
    CALL enviarDato
    MOVLW 0x0F             ; Fila 7
    CALL enviarDato
    MOVLW 0x00             ; Fila 8
    CALL enviarDato

    ; Definir el segundo carácter personalizado (Fantasma)
    MOVLW 0x50             ; Dirección de inicio de la CGRAM (0x40 + 2 * 8)
    CALL enviarComando     ; Enviar comando para escribir en la CGRAM
    CALL retardo2ms        ; Esperar 2 ms
    MOVLW 0x04             ; Fila 1
    CALL enviarDato
    MOVLW 0x0E             ; Fila 2
    CALL enviarDato
    MOVLW 0x1F             ; Fila 3
    CALL enviarDato
    MOVLW 0x15             ; Fila 4
    CALL enviarDato
    MOVLW 0x1F             ; Fila 5
    CALL enviarDato
    MOVLW 0x11             ; Fila 6
    CALL enviarDato
    MOVLW 0x1F             ; Fila 7
    CALL enviarDato
    MOVLW 0x1F             ; Fila 8
    CALL enviarDato


    RETURN