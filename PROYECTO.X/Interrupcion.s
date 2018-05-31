	.include "p30F4013.inc"
	.global  __U2RXInterrupt


__U2RXInterrupt:
    PUSH    W0
    MOV	    U2RXREG, W0
    MOV	    W0, U1TXREG
    NOP
    BCLR    IFS1, #U2RXIF
    POP	    W0
    RETFIE

__T3Interrupt:
    BTG LATD, #LATD0 ;para rectificar una frecuencia de de 256hz
    NOP
    BCLR IFS0, #T3IF
    RETFIE
    
__ADCInterrupt:
    MOV   ADCBUF0, W0
    MOV	  W0,W1
    AND	  #0x003F, W0
    PUSH  W0
    LSR	  W1,#6,W0 
    MOV   W0,W1
    POP   W0
    BSET  W1, #7
    MOV   W0,U1TXREG
    MOV   W1,U1TXREG
    BCLR  IFS0, #ADIF ;unica duda
    RETFIE
    