    
    .include "p30F4013.inc"
    .GLOBAL __INT0Interrupt
    .GLOBAL __INT1Interrupt
;/**@brief ESTA RUTINA AUMENTA EN UNO EL CONTADOR POR INTERRUPCION DE UN SENSOR
; * @param
; */    
    
__INT0Interrupt:

__INT1Interrupt:    
    BTG LATD,	#RD3
    RETFIE 
FIN_ISR_INT0: 
    


