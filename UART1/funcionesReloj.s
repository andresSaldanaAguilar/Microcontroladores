    
    .include "p30F4013.inc"
    .GLOBAL _CONFIG
    .GLOBAL _EN_RTC
   

;Funciones de las notas
;Los valores que son asignados a PR1 y T1CON dependen de la preescala
_CONFIG:
    PUSH	    W0
    
    MOV #0X0420,    W0
    MOV W0,	    U1MODE
    MOV	#0X8000,    W0
    MOV W0,	    U1STA
    MOV	#11,	    W0
    MOV W0,	    U1BRG
    
    POP		    W0
    RETURN
    
_EN_RTC:
    PUSH W0
    PUSH W1    
    MOV	#OSCCONL,   W2
    MOV	#0X46,	    W0
    MOV	#0X57,	    W1
    MOV.B   W0,	    [W2]
    MOV.B   W1,	    [W2]
    BSET    OSCCONL,#LPOSCEN
    POP W0
    POP W1
    RETURN





