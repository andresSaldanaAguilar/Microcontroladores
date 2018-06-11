	.include "p30F4013.inc"
	.global	 __T1Interrupt
	.global  __T3Interrupt
	
__T1Interrupt:
    
    BTG	    LATD    ,	#RD2
    NOP
    BCLR    IFS0    ,	#T1IF
    
    RETFIE
    
	
__T3Interrupt:
    
    MOV	    [W1++]  ,	W0
    CALL    _WR_DAC
    
    RETFIE
    
    