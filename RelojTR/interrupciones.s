    
    .include "p30F4013.inc"
    .GLOBAL __T1Interrupt
    .GLOBAL _USEG
    .GLOBAL _DSEG
    .GLOBAL _UMIN
    .GLOBAL _DMIN
    .GLOBAL _UHORA
    .GLOBAL _DHORA
    
;/**@brief ESTA RUTINA funciona como un reloj en tiempo real
; * @param
; */    
    
;Interrupción del timer, estas vienen definidas en el archivo .gld
;Línea 360
__T1Interrupt:    
    PUSH    W0
    INC.B   _USEG
    MOV	    #10,    W0
    CP.B    _USEG		    ;Comparamos el valor de USEG con W0
    BRA	    NZ,	    FIN_ISR_INT1    ;Brinca si no es cero
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
    INC.B   _UHORA
    ;Aquí voy a comparar la decena de hora
    MOV	    #2,	    W0
    CP.B    _DHORA
    BRA	    Z,	    VEINTICUATRO_HORAS	    ;Si esto es cero, significa que ya estamos en la hora 20 al menos
    MOV	    #10,    W0      
    CP.B    _UHORA
    BRA	    NZ,	    FIN_ISR_INT1
    CLR.B   _UHORA 
    INC.B   _DHORA
FIN_ISR_INT1: 
    BCLR    IFS0,   #INT0IF
    POP	    W0
    RETFIE  
    
;Ya estamos en la hora 20 al menos
VEINTICUATRO_HORAS:
    MOV	    #4,	    W0		    ;Hay que ver si la UHORA no es 4
    CP.B    _UHORA
    BRA	    NZ,	    FIN_ISR_INT1    ;Si no es 4, entonces terminamos
    ;Si si es 4, reinicio todo porque ya pasaron 24 horas
    CLR.B   _USEG
    CLR.B   _DSEG
    CLR.B   _UMIN
    CLR.B   _DMIN
    CLR.B   _UHORA
    CLR.B   _DHORA
    CALL    FIN_ISR_INT1
    
    
