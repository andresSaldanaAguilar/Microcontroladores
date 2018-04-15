	.include "p30F4013.inc"
	.GLOBAL  __INTOInterrupt
	.GLOBAL  _uni
	.GLOBAL  _dece
	.GLOBAL  _cen
	.GLOBAL  _umi
	

__INT0Interrupt:
    PUSH    W0
    
    INC.B   _uni
    MOV	    #10,    W0
    CP.B    _uni
    BRA	    NZ,	    FIN_ISR_INT0
    
    CLR.B   _uni
    INC.B   _dece
    
    CP.B    _dece
    BRA	    NZ,	    FIN_ISR_INT0
    
    CLR.B   _dece
    INC.B   _cen
    
    CP.B    _cen
    BRA	    NZ,	    FIN_ISR_INT0
    
    CLR.B   _cen
    INC.B   _umi
    
    CP.B    _umi
    BRA	    NZ,	    FIN_ISR_INT0
    
    CLR.B   _umi
    
FIN_ISR_INT0:
    BCLR IFS0,	#INT0IF
    
    POP	    W0
    RETFIE