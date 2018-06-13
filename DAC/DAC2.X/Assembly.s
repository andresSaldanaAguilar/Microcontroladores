	.include    "p30F4013.inc"
	.GLOBAL	    _RETARDO1S
	.GLOBAL	    _configDSP
	.GLOBAL	    _seno
	
	.GLOBAL	    _WR_DAC
	
	
_configDSP:
    
    BSET    CORCON  ,	#PSV
    
    MOV	    #psvpage(_seno)  ,	W0
    MOV	    W0		    ,	PSVPAG	
    MOV	    #psvoffset(_seno),	W1
    
    MOV	    W1		    ,	XMODSRT
    MOV	    #64*2-1   ,	W2
    ADD	    W2		    ,	W1		,   W2
    MOV	    W2		    ,	XMODEND
    MOV	    #0x8001	    ,	W0
    MOV	    W0		    ,	MODCON
    
    RETURN

	

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

    