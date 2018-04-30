    
    .include "p30F4013.inc"
    .GLOBAL __U1RXInterrupt
    .GLOBAL _datoRCV
    .GLOBAL _dato
    
;/**@brief Esta rutina cacha una interrupcion uart
; * @param
; */    
    
__U1RXInterrupt:
    PUSH W0
    MOV  U1RXREG
    MOV  _dato ;solucionar problema
    BSET _datoRCV, #0
    BCLR  IFS0, #U1RXIF ;Careful
    POP  W0
    RETFIE
    
    

    
    
