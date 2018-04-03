    .include "p30F4013.inc"
    .GLOBAL _INT0Interrupt
    .GLOBAL _uni
    .GLOBAL _dece
    .GLOBAL _cen
    .GLOBAL _umi
_INT0Interrupt:
    PUSH    W0
    INC.B   _uni
    MOV	    #10,    W0
    CP.B	    _uni
    BRA	    NZ	    FIN_ISR_INT0
    CLR.B   _uni
    INC.B   _dece
    ;elioth continuara...
    
FIN_ISR_INT0: 
    BLCR    IFS0,   #INT0IF
    POP	    W0
    RETFIE  


