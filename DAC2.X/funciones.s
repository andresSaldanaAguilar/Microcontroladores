.include "p30F4013.inc"
.global _configDSP
.global _WR_DAC
.global _RD_WR_SPI
.global	_seno
    
;variables    
.equ MUESTRAS, 8   
    
_configDSP:
    PUSH	W0
    PUSH	W2
    ;buffer circular
    BSET	CORCON,		    #PSV
    MOV		#psvpage(_seno),    W0
    MOV		W0,		    PSVPAG
    MOV		#psvoffset(_seno),  W1
    MOV		W1,		    XMODSRT		
    MOV		#MUESTRAS*2-1,	    W2
    ADD		W2,		    W1,		    W2
    MOV		W2,		    XMODEND		
    MOV		#0x8001,	    W0
    MOV		W0,		    MODCON		
    
    POP		W2
    POP		W0
    RETURN
	   
		
_WR_DAC:
    PUSH	W0
    PUSH	W1
    MOV		#0x0FFF,	    W1	
    AND		W0,		    W1,		    W0
    BSET	W0,		    #12
    BCLR	PORTA,		    #RA11
    NOP
    BSET	PORTD,		    #RD0
    NOP
    CALL	_RD_WR_SPI
    BSET	PORTA,		    #RA11
    NOP
    BCLR	PORTD,		    #RD0
    NOP
    BSET	PORTD,		    #RD0
    
    POP		W1
    POP		W0
    RETURN
    
_RD_WR_SPI:
    MOV		W0,		   SPI1BUF
    NOP
    BCLR	IFS0,		   #SPI1IF
    NOP
REGRESA:
    BTSS        IFS0,		   #SPI1IF
    GOTO	REGRESA
    MOV		SPI1BUF,    W0
    NOP
    
    RETURN





