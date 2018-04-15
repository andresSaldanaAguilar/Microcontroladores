	.include    "p30F4013.inc"
	.EQU	    RS_LCD,	RD0
	.EQU	    RW_LCD,	RD1
	.EQU	    E_LCD,	RD2
	.EQU	    B_FLAG,	RB7
	
	.global	_comandoLCD
	.global	_datoLCD
	.global	_busyFlagLCD
	.global _iniLCD8bits
	.global _imprimeLCD

;******************************************************************************
;DESCRICION:	ESTA RUTINA RECORRE UN ARREGLO DECLARADO EN MEMORIA Y VA IMPRIMIENDO
;		LOS CARACTERES HASTA QUE ENCUENTRA EL TERMINADOR DE CADENA
;PARAMETROS: 	NINGUNO
;RETORNO: 		NINGUNO
;******************************************************************************
_imprimeLCD:   
    MOV	    W0,		W1
    
_nomover:
    CALL    _busyFlagLCD
    CALL    _datoLCD
    
    MOV.B   [W1++],	W0
    AND	    #0x00FF,	W0
    CP0	    W0
    BRA	    Z,	    _SALIR
    GOTO    _nomover
    
    
_SALIR:    
    RETURN
	
;******************************************************************************
;DESCRICION:	ESTA RUTINA INICIALIZA LA PANTALLA LCD
;PARAMETROS: 	NINGUNO
;RETORNO: 		NINGUNO
;******************************************************************************
_iniLCD8bits:
	PUSH W0
    
	CALL	_RETARDO_15ms
	MOV	#0X0030,    W0
	CALL	_comandoLCD
	
	CALL	_RETARDO_15ms
	MOV	#0X0030,    W0
	CALL	_comandoLCD
	
	CALL	_RETARDO_15ms
	MOV	#0X0030,    W0
	CALL	_comandoLCD
	
	CALL	_busyFlagLCD
	MOV	#0X0038,    W0
	CALL	_comandoLCD
	
	CALL	_busyFlagLCD
	MOV	#0X0008,    W0
	CALL	_comandoLCD
	
	CALL	_busyFlagLCD
	MOV	#0X0001,    W0
	CALL	_comandoLCD
	
	CALL	_busyFlagLCD
	MOV	#0X0006,    W0
	CALL	_comandoLCD
	
	CALL	_busyFlagLCD
	MOV	#0X000F,    W0
	CALL	_comandoLCD

	POP	W0
	RETURN
	
;******************************************************************************
;DESCRICION:	ESTA RUTINA REVISA LA BANDERA DE BUSY FLAG EN LA PANTALLA LCD
;		Y TERMINA CUANDO ÉSTA SE DESACTIVA
;PARAMETROS: 	NINGUNO
;RETORNO: 		NINGUNO
;******************************************************************************
	
_busyFlagLCD:
	PUSH	W0
	
	MOV	#0x00FF,    W0
	IOR	TRISB
	NOP
	BCLR	PORTD,	    #RS_LCD
	NOP
	
	BSET	PORTD,	    #RW_LCD
	NOP
	
	BSET	PORTD,	    #E_LCD
	NOP
	
WAIT:
	BTST	PORTB,	    #B_FLAG
	BRA	Z,	    CONTINUE
	GOTO	WAIT
	
CONTINUE:
	
	BCLR	PORTD,	    #E_LCD
	NOP
	
	;ULTIMA PARTE DE LA RUTINA DE BUSY FLAG
	PUSH	W0
	MOV	#0XFF00,    W0
	AND	TRISB
	BCLR	PORTD,	    #RW_LCD
	POP	W0
	;
	
	POP	W0
	
	RETURN
	
;******************************************************************************
;DESCRICION:	ESTA RUTINA EJECUTA UN COMANDO DENTRO DE LA LCD, EL COMANDO 
;		DEBE ESTAR GUARDADO DENTRO DEL REGISTRO W0
;PARAMETROS: 	NINGUNO
;RETORNO: 		NINGUNO
;******************************************************************************
_comandoLCD:
	BCLR	PORTD,	#RS_LCD
	NOP
	BCLR	PORTD,	#RW_LCD
	NOP
	BSET	PORTD,	#E_LCD
	NOP
	MOV.B	WREG,	PORTB
	NOP
	BCLR	PORTD,	#E_LCD
	NOP
	
	RETURN
	
;******************************************************************************
;DESCRICION:	ESTA RUTINA PERMITE ESCRIBIR CARACTERES DENTRO DE LA PANTALLA LCD
;PARAMETROS: 	NINGUNO
;RETORNO: 		NINGUNO
;******************************************************************************
_datoLCD:
	BSET	PORTD,	#RS_LCD
	NOP
	BCLR	PORTD,	#RW_LCD
	NOP
	BSET	PORTD,	#E_LCD
	NOP
	MOV.B	WREG,	PORTB
	NOP
	BCLR	PORTD,	#E_LCD
	NOP
	
	RETURN
	