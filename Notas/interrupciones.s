    
    .include "p30F4013.inc"
    .GLOBAL __INT0Interrupt
    .GLOBAL _Nota_DO
    .GLOBAL _Nota_RE
    .GLOBAL _Nota_MI
    .GLOBAL _Nota_FA
    .GLOBAL _Nota_SOL
    .GLOBAL _Nota_LA
    .GLOBAL _Nota_SI

;Funciones de las notas
;Los valores que son asignados a PR1 dependen de la preescala
_Nota_DO:
    CLR TMR1
    MOV #55,	    PR1
    MOV #0X8020,    T1CON
    RETURN
_Nota_RE:
    CLR TMR1
    MOV #55,	    PR1
    MOV #0X8020,    T1CON
    RETURN
_Nota_MI:
    CLR TMR1
    MOV #55,	    PR1
    MOV #0X8020,    T1CON
    RETURN
_Nota_FA:
    CLR TMR1
    MOV #55,	    PR1
    MOV #0X8020,    T1CON
    RETURN
_Nota_SOL:
    CLR TMR1
    MOV #55,	    PR1
    MOV #0X8020,    T1CON
    RETURN
_Nota_LA:
    CLR TMR1
    MOV #55,	    PR1
    MOV #0X8020,    T1CON
    RETURN

;/**@brief ESTA RUTINA AUMENTA EN UNO EL CONTADOR POR INTERRUPCION DE UN SENSOR
; * @param
; */    
    
__INT0Interrupt:
    
    
FIN_ISR_INT0: 
    


