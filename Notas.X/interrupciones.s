    
    .include "p30F4013.inc"
    .GLOBAL __T1Interrupt
;/**@brief ESTA RUTINA AUMENTA EN UNO EL CONTADOR POR INTERRUPCION DE UN SENSOR
; * @param
; */    
    
;Interrupción del timer, estas vienen definidas en el archivo .gld
;Línea 360
__T1Interrupt:    
    BTG LATD,	#RD3
    BCLR IFS0,	#T1IF
    RETFIE 
    


