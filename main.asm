#include<p16f877.inc>


valor1 equ h'21'
valor2 equ h'22'
valor3 equ h'23'
posicion_pacman equ h'24'
;Retardos tradicionales
cte1 equ .25 ;Retardo de 500 ms
cte2 equ .83
cte3 equ .200
cte4 equ .2 ;Retardo de 2 ms
cte5 equ .5 ;Retado de 5 ms
;Para retardos peques
cte6 equ .83
cte7 equ .20
cte8 equ .5 ;Retardo 50 ms
cte9 equ .83
;para retardos mas peques
cte10 equ .2
cte11 equ .1 ;Retardo de 100 us



#define RS PORTA, 0 ;RS EN PORTA(0)
#define RW PORTA, 1; RW EN PORTA(1)
#define E PORTA, 2; E EN PORTA(2)
#define DATOS PORTD; DATOS ENVIADOS AL PORTC

org 0
goto inicio
org 5

inicio:
	BSF STATUS,5
	BCF STATUS,6 ; Se cambia al banco 1

	; Configurar puerto B como salida
	MOVLW 0x00
	MOVWF TRISD 
		
	; Configura puerto A como salida
	MOVLW 0x06
	MOVWF ADCON1	
	MOVLW 0x00
	MOVWF TRISA 

	BCF STATUS,5 ; Se regresa al banco 0
	CLRF PORTD ; Se limpia puerto D
	CLRF PORTA; Se limpia el puerto A
	CALL inciarDisplay
	CALL cargarCaracteresAnimacion
	CALL inicializarPacman

bucle_principal:
	CALL animacion_pacman
	goto bucle_principal





#include "caracteres.asm"
#include "retardos.asm"
#include "LCD.asm"
#include "pacman.asm"
  
end