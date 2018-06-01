.include "p30F4013.inc"
.global	_comandoAT
	
;/**@brief ESTA RUTINA MUESTRA UN MENSAJE EN LA LCD
; * @param W0, APUNTADOR DEL MENSAJE A MOSTRAR
; */
_comandoAT:
    MOV	    W0,	    W1
_RECORRER:
    CLR	    W0
    MOV.B   [W1++], W0 ;en W0 tendremos el parametro y en w1 el apuntador al incio del arreglo
    CP0.B     W0
    BRA	    Z   , _SALIR
    BCLR    IFS1, #U2TXIF
    MOV	    W0  , U2TXREG
    NOP
_CICLO1:    
    BTSS    IFS1, #U2TXIF
    GOTO    _CICLO1
    GOTO    _RECORRER
_SALIR:
    RETURN



