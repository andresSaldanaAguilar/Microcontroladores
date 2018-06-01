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
    PUSH  W0
    BTG LATD, #LATD0 ;para rectificar una frecuencia de de 256hz
    NOP
    BCLR IFS0, #T3IF
    POP   W0
    RETFIE

    
__ADCInterrupt:
    PUSH    W0
    PUSH    W1   
    MOV	    ADCBUF0, W0
    MOV	    W0,	     W1
    AND	    #0x003F, W0      ; PARTE BAJA -> W0
    LSR	    W1,	     #6, W1  ; PARTE ALTA -> W1
    BSET    W1,	     #7
    BCLR    W0,	     #7
    MOV	    W0,	     U2TXREG ;ENVIO DE PARTE BAJA
    NOP
    MOV	    W1,	     U2TXREG ;ENVIO DE PARTE ALTA
    NOP	    ;--
    BCLR    IFS0,    #ADIF   
    POP	    W1
    POP	    W0
    RETFIE
    