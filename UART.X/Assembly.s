        .include "p30F4013.inc"
	.GLOBAL	_ENRTC
	
;******************************************************************************
;DESCRICION:	Funcion ENRTC para configurar el Timer externo en OSCONL
;PARAMETROS: 	APUNTADOR DEl ARREGLO
;RETORNO:	NINGUNO
;******************************************************************************
_ENRTC:
    PUSH	W0
    PUSH	W1
    
    MOV		#OSCCONL,	W2
    
    MOV		#0x46	,	W0
    MOV		#0x57	,	W1
    
    MOV.B	W0	,	[W2]
    MOV.B	W1	,	[W2]
    
    BSET	OSCCONL	,	#LPOSCEN
    
    POP		W1
    POP		W0
    
    RETURN
    