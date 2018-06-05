        .include "p30F4013.inc"

	.global __U2RXInterrupt
	.global __T1Interrupt
	.global __T3Interrupt
	
		
__U2RXInterrupt:
    PUSH W0
    
    MOV U2RXREG, W0
    MOV W0,	U1TXREG
    NOP

    BCLR    IFS1,   #U2RXIF
    POP	    W0
    RETFIE
__T1Interrupt:
    BTG LATD, #LATD0
    NOP
    RETFIE
__T3Interrupt:
    MOV [W1++], W0
    CALL WR_DAC
    RETFIE