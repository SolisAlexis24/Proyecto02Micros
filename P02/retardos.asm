retardo250ms movlw cte1 
		movwf valor1

		tres250 movlw cte2
			 movwf valor2

		dos250 movlw cte3
			movwf valor3

		uno250 decfsz valor3 ;Resta valor3 hasta que sea 0
			goto uno250
			decfsz valor2 ;Resta valor2 hasta que sea 0
			goto dos250
			decfsz valor1 ;Resta valor1 hasta que sea 0
			goto tres250
		return


retardo50ms movlw cte8 
		movwf valor1

		tres50ms movlw cte2
			 movwf valor2

		dos50ms movlw cte3
			movwf valor3

		uno50ms decfsz valor3 ;Resta valor3 hasta que sea 0
			goto uno50ms
			decfsz valor2 ;Resta valor2 hasta que sea 0
			goto dos50ms
			decfsz valor1 ;Resta valor1 hasta que sea 0
			goto tres50ms
		return


retardo2ms movlw cte4 
		movwf valor1

		tres2ms movlw cte6
			 movwf valor2

		dos2ms movlw cte7
			movwf valor3

		uno2ms decfsz valor3 ;Resta valor3 hasta que sea 0
			goto uno2ms
			decfsz valor2 ;Resta valor2 hasta que sea 0
			goto dos2ms
			decfsz valor1 ;Resta valor1 hasta que sea 0
			goto tres2ms
		return

retardo5ms movlw cte5
		movwf valor1

		tres5ms movlw cte6
			 movwf valor2

		dos5ms movlw cte7
			movwf valor3

		uno5ms decfsz valor3 ;Resta valor3 hasta que sea 0
			goto uno5ms
			decfsz valor2 ;Resta valor2 hasta que sea 0
			goto dos5ms
			decfsz valor1 ;Resta valor1 hasta que sea 0
			goto tres5ms
		return

retardo100us movlw cte11
		movwf valor1

		tres100us movlw cte9
			 movwf valor2

		dos100us movlw cte10
			movwf valor3

		uno100us decfsz valor3 ;Resta valor3 hasta que sea 0
			goto uno100us
			decfsz valor2 ;Resta valor2 hasta que sea 0
			goto dos100us
			decfsz valor1 ;Resta valor1 hasta que sea 0
			goto tres100us
		return

