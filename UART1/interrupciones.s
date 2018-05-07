    
    .include "p30F4013.inc"
    .global __U1RXInterrupt
    .global _datoRCV
    .global _dato
    
;/**@brief Esta rutina cacha una interrupcion uart
; * @param
; */    
    
__U1RXInterrupt:
    PUSH W0
    MOV  U1RXREG,W0
    MOV  WREG,	 _dato
    MOV  #1,	 W0
    MOV.B  WREG,	 _datoRCV
    BCLR IFS0,	 #U1RXIF
    POP  W0
    RETFIE


    
    
