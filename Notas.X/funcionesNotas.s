    
    .include "p30F4013.inc"
    .GLOBAL _APAGA
    .GLOBAL _EN_RTC
   

;Funciones de las notas
;Los valores que son asignados a PR1 y T1CON dependen de la preescala
_APAGA:
    PUSH	    W0
    CLR TMR1
    MOV #0X8000,    W0
    MOV W0,	    PR1
    MOV	#0X0002,    W0
    MOV W0,	    T1CON
    POP		    W0
    RETURN
_EN_RTC:
    MOV	#OSCCONL,   W2
    MOV	#0X46,	    W0
    MOV	#0X52,	    W1
    MOV.B   W0,	    [W2]
    MOV.B   W1,	    [W2]
    BSET    OSCCONL,#LPOSCEN





