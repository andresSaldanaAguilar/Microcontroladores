    .include "p30F4013.inc"
    .GLOBAL __T1Interrupt
    .GLOBAL _USEG
    .GLOBAL _DSEG
    .GLOBAL _UMIN
    .GLOBAL _DMIN
    .GLOBAL _UHORA
    .GLOBAL _DHORA
    .GLOBAL _CONT
    
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
    ;Aquí empieza sección de horas, QUE NO ESTÁ TERMINADA
    INC.B   _UHORA
    MOV	    #10,    W0      
    CP.B    _UHORA
    BRA	    NZ,	    FIN_ISR_INT1
    CLR.B   _UHORA 
    ;Como las horas máximas a las que podemos llegar son 24,
    ;Hay que hacer un caso especial para UHORA cuando llegue como máximo a 4
    ;El cual sería después de la segunda vez que llegue a 10, para esto uso cont
    ;Que llevará el conteo de las veces que UHORA a llegado a 10
    ;ESTO ESTÁ INCOMPLETO
    INC.B   _CONT
    MOV	    #1,	    W0
    CP.B    _CONT
    BRA	    Z,	    HORAS
    
    ;Decena de horas, solo hay que verificar que no llegue a más de dos
    INC.B   _DHORA
    MOV	    #3,    W0      
    CP.B    _DHORA
    BRA	    NZ,	    FIN_ISR_INT1
    CLR.B   _DHORA  
FIN_ISR_INT1: 
    BCLR    IFS0,   #INT0IF
    POP	    W0
    RETFIE  
;    RETFIE 
    
;ESTÁ FUNCIÓN DEBERÍA DE AUMENTAR EN UNO EL CONTADOR    
HORAS:
    MOV	    #1,	    W0
    