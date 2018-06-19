.include "p30F4013.inc"
.global __T3Interrupt
.global __T1Interrupt

__T1Interrupt:
    BTG	    LATD,	#LATD2 
    NOP
    BCLR    IFS0,	#T1IF
    NOP
    RETFIE  
    
__T3Interrupt:
    PUSH W0
    MOV	    [W1++],	W0
    CALL    _WR_DAC
    BTG	    LATD,	#LATD3 
    NOP
    BCLR    IFS0,	#T3IF
    NOP
    POP W0
    RETFIE
    

    
    