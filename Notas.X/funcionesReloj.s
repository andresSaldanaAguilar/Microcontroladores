    
    .include "p30F4013.inc"
    .GLOBAL _Nota_DO
    .GLOBAL _Nota_RE
    .GLOBAL _Nota_MI
    .GLOBAL _Nota_FA
    .GLOBAL _Nota_SOL
    .GLOBAL _Nota_LA
    .GLOBAL _Nota_SI

;Funciones de las notas
;Los valores que son asignados a PR1 y T1CON dependen de la preescala
_Nota_DO:
    PUSH	    W0
    CLR TMR1
    MOV #55,	    W0
    MOV W0,	    PR1
    MOV	#0X8020,    W0
    MOV W0,	    T1CON
    POP		    W0
    RETURN
_Nota_RE:
    PUSH	    W0
    CLR TMR1
    MOV #49,	    W0
    MOV W0,	    PR1
    MOV	#0X8020,    W0
    MOV W0,	    T1CON
    POP		    W0
    RETURN
_Nota_MI:
    PUSH	    W0
    CLR TMR1
    MOV #11,	    W0
    MOV W0,	    PR1
    MOV	#0X8030,    W0
    MOV W0,	    T1CON
    POP		    W0
    RETURN
_Nota_FA:
    PUSH	    W0
    CLR TMR1
    MOV #2639,	    W0
    MOV W0,	    PR1
    MOV	#0X8000,    W0
    MOV W0,	    T1CON
    POP		    W0
    RETURN
_Nota_SOL:
    PUSH	    W0
    CLR TMR1
    MOV #2351,	    W0
    MOV W0,	    PR1
    MOV	#0X8000,    W0
    MOV W0,	    T1CON
    POP		    W0
    RETURN
_Nota_LA:
    PUSH	    W0
    CLR TMR1
    MOV #8,	    W0
    MOV W0,	    PR1
    MOV	#0X8030,    W0
    MOV W0,	    T1CON
    POP		    W0
    RETURN
_Nota_SI:
    PUSH	    W0
    CLR TMR1
    MOV #1866,	    W0
    MOV W0,	    PR1
    MOV	#0X8000,    W0
    MOV W0,	    T1CON
    POP		    W0
    RETURN





