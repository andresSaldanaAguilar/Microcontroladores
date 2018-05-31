;/**@brief ESTE PROGRAMA LEE LOS VALORES COLOCADOS EN EL PUERTO D
; * (RD3, RD2, RD2, RD0) MEDIANTE UN DIP-SWITCH Y LOS COLOCA EN EL 
; * PUERTO B (RB3, RB2, RB1, RB0) DONDE SE TIENEN CONECTADOS LEDS
; * PARA VISUALIZAR LA SALIDA
; * @device: DSPIC30F4013
; */
        .equ __30F4013, 1
	;.EQU RS_LCD,	R0
	;.EQU RW_LCD,	R1
	;.EQU E_LCD,	R2
        .include "p30F4013.inc"
	.global	_comandoAT
	
;/**@brief ESTA RUTINA MUESTRA UN MENSAJE EN LA LCD
; * @param W0, APUNTADOR DEL MENSAJE A MOSTRAR
; */
_comandoAT:
    MOV	    W0,	    W1
    CLR	    W0
RECORRER:
    MOV.B   [W1++], W0 ;en W0 tendremos el parametro y en w1 el apuntador al incio del arreglo
    CP0.B   W0
    BRA	    Z, SALIR
    BCLR    IFS1, #U2TXIF
    MOV	    U2TXREG, W0
CICLO1:    
    CP0.B   U2TXIF
    BRA	    Z, CICLO1
    GOTO    RECORRER
SALIR:
    RETURN
