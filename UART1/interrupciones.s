    
    .include "p30F4013.inc"
    .GLOBAL __U1RXInterrupt
    .GLOBAL _datoRCV
    .GLOBAL _dato
    
;/**@brief Esta rutina cacha una interrupcion uart
; * @param
; */    
    
__U1RXInterrupt:
    PUSH W0
    MOV  U1RXREG,W0
    MOV  W0,	 _dato
    MOV  #1,	 W0
    MOV  W0,	 _datoRCV
    BCLR IFS0,	 #U1RXIF
    POP  W0
    RETFIE


    
    
