	.include    "p30F4013.inc"
	.GLOBAL	    _WR_DAC

_WR_DAC:   
    
    MOV	    #0x0FFF ,	W1
    AND	    W1	    ,	W0	,   W0
    
    BSET    W0	    ,	#12
    
    BCLR    PORTA   ,	#11
    BSET    PORTD   ,	#0
    
    CALL    _RD_WR_SPI
    
    BSET    PORTA   ,	#11
    
    BCLR    PORTD   ,	#0
    
    NOP
    
    BSET    PORTD   ,	#0
    
    RETURN
   
    
    
_RD_WR_SPI:
    
    MOV	    W0	    ,	SPI1BUF
    
    BCLR    IFS0    ,	#SPI1IF
    
_loop:
    BTSS    IFS1    ,	#U2TXIF	
    GOTO    _loop
    
    MOV	    SPI1BUF ,	W0
    
    RETURN

    