	.include "p30F4013.inc"
	.global  __U1RXInterrupt
	.global  _datoRCV
	.global  _dato
	
	

__U1RXInterrupt:
    PUSH	W0   
    MOV		U1RXREG    ,	W0
    MOV		W0	    ,	_dato
    MOV		#1	    ,	W0
    MOV		W0	    ,	_datoRCV 
    BCLR	IFS0,	#U1RXIF   
    POP		W0
    RETFIE
    