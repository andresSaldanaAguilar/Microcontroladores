.include "p30F4013.inc" ;aqui estan definidos todos los archivos de todos los registros

.global _RETARDO_1S
.global _RETARDO_15mS
.global _RETARDO_5mS
;/**@brief ESTA RUTINA GENERA UN RETARDO DE 1 SEG APROX
; */
_RETARDO_1S:
	PUSH	W0  ; PUSH.D W0
	PUSH	W1
	
	MOV	#10,	    W1
CICLO2_1S:
    
	CLR	W0	
CICLO1_1S:	
	DEC	W0,	    W0
	BRA	NZ,	    CICLO1_1S	
    
	DEC	W1,	    W1
	BRA	NZ,	    CICLO2_1S
	
	POP	W1  ; POP.D W0
	POP	W0
	RETURN
	
_RETARDO_15mS:
    CALL _RETARDO_5mS
    CALL _RETARDO_5mS
    CALL _RETARDO_5mS
    RETURN
	
_RETARDO_5mS:
    ;continuara...
    RETURN
	


