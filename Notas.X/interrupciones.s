    
    .include "p30F4013.inc"
    .GLOBAL __T1Interrupt
    .GLOBAL _USEG
    .GLOBAL _DSEG
    .GLOBAL _UMIN
    .GLOBAL _DMIN
    .GLOBAL _UHORA
    .GLOBAL _DHORA
    
;/**@brief ESTA RUTINA AUMENTA EN UNO EL CONTADOR POR INTERRUPCION DE UN SENSOR
; * @param
; */    
    
;Interrupción del timer, estas vienen definidas en el archivo .gld
;Línea 360
__T1Interrupt:    
    PUSH    W0
    INC.B   _USEG
    MOV	    #10,    W0
    CP.B    _USEG
    BRA	    NZ,	    FIN_ISR_INT1
    CLR.B   _USEG
    INC.B   _DSEG
    MOV	    #6,    W0
    CP.B    _DSEG
    BRA	    NZ,	    FIN_ISR_INT1    
    CLR.B   _DSEG
    INC.B   _UMIN
    MOV	    #10,    W0
    CP.B    _UMIN
    BRA	    NZ,	    FIN_ISR_INT1
    CLR.B   _UMIN  
    INC.B   _DMIN
    MOV	    #6,    W0      
    CP.B    _DMIN
    BRA	    NZ,	    FIN_ISR_INT1
    CLR.B   _DMIN   
    
FIN_ISR_INT1: 
    BCLR    IFS0,   #INT0IF
    POP	    W0
    RETFIE  
    RETFIE 
    


