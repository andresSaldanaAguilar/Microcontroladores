;/**@brief ESTE PROGRAMA LEE LOS VALORES COLOCADOS EN EL PUERTO D
; * (RD3, RD2, RD2, RD0) MEDIANTE UN DIP-SWITCH Y LOS COLOCA EN EL 
; * PUERTO B (RB3, RB2, RB1, RB0) DONDE SE TIENEN CONECTADOS LEDS
; * PARA VISUALIZAR LA SALIDA
; * @device: DSPIC30F4013
; */
        .equ __30F4013, 1
	;.EQU RS_LCD,	R0
	;.EQU RW_LCD,	R1
	;.EQU E_LCD,	R2
        .include "p30F4013.inc"
	.global	_comandoLCD
	.global _datoLCD
	.global _busyFlagLCD
	.global _iniLCD8bits
	.global _imprimeLCD
	.global _buscaNota
	.global _BP
	

;/**@brief ESTA RUTINA HACE LA LOGICA DEL MAIN DE COMPARACION DE NOTAS, ES EXPERIMENTAL
; * @param W0, APUNTADOR DEL MENSAJE A MOSTRAR
; */
;_buscaNota:
;    PUSH    W0
;    MOV	    #RF0,    W0 ;DO
;    NOP
;    CP0     W0
;    BRA	    NZ,	    B_NOTA_DO
;    MOV	    #RF1,    W0 ;RE
;    NOP
;    CP0     W0
;    BRA	    NZ,	    B_NOTA_RE
;    MOV	    #RF2,    W0 ;MI
;    NOP
;    CP0     W0
;    BRA	    NZ,	    B_NOTA_MI 
;    MOV	    #RF3,    W0 ;FA
;    NOP
;    CP0     W0
;    BRA	    NZ,	    B_NOTA_FA
;    MOV	    #RF4,    W0 ;SOL
;    NOP
;    CP0     W0
;    BRA	    NZ,	    B_NOTA_SOL
;    MOV	    #RF5,    W0 ;LA
;    NOP
;    CP0     W0
;    BRA	    NZ,	    B_NOTA_LA
;    MOV	    #RF6,    W0 ;SI
;    NOP
;    CP0     W0
;    BRA	    NZ,	    B_NOTA_SI  
;    CLR	    _BP
;    ;CLR	    PORTD   #3  
;    ;ticon, con = 0;
;    POP	    W0
;    RETURN
    
;B_NOTA_DO:
;    CP0     _BP
;    ;BRA	    NZ,	    NOTA_DO
;    POP	    W0
;    RETURN
   

;/**@brief ESTA RUTINA MUESTRA UN MENSAJE EN LA LCD
; * @param W0, APUNTADOR DEL MENSAJE A MOSTRAR
; */
_imprimeLCD:
    MOV	    W0,	    W1
    CLR	    W0
RECORRER:
    MOV.B   [W1++], W0 ;en W0 tendremos el parametro y en w1 el apuntador al incio del arreglo
    CP0.B   W0
    BRA	    Z, SALIR
    CALL    _busyFlagLCD
    CALL    _datoLCD
    GOTO    RECORRER
SALIR:
    RETURN
	
;/**@brief ESTa rutina veririca la bandera BF del lcd
; */	RUTINA DE INICIALIZACIPON DE LCD
_iniLCD8bits:
    PUSH    W0
    
    CALL    _RETARDO_30ms
    MOV	    #0x30,	    W0
    CALL    _comandoLCD
    
    CALL    _RETARDO_30ms
    MOV	    #0x30,	    W0
    CALL    _comandoLCD
    
    CALL    _RETARDO_30ms
    MOV	    #0x30,	    W0
    CALL    _comandoLCD
    
    CALL    _busyFlagLCD
    MOV	    #0x38,	    W0
    CALL    _comandoLCD
    CALL    _busyFlagLCD
    MOV	    #0x08,	    W0    
    CALL    _comandoLCD
    CALL    _busyFlagLCD    
    MOV	    #0x01,	    W0  
    CALL    _comandoLCD
    CALL    _busyFlagLCD
    MOV	    #0x06,	    W0  
    CALL    _comandoLCD
    CALL    _busyFlagLCD 
    MOV	    #0x0F,	    W0  
    CALL    _comandoLCD
    
    POP	    W0
    RETURN 
	
;/**@brief ESTa rutina veririca la bandera BF del lcd
; */	
_busyFlagLCD:
    PUSH    W0
    MOV	    #0X00FF,	W0
    IOR	    TRISB	    ;Hace el or con w0 y lo guarda en trisb
    NOP
    BCLR    PORTD,	#RD0
    NOP
    BSET    PORTD,	#RD1
    NOP
    BSET    PORTD,	#RD2
    NOP
LOOP:
    BTSC    PORTB,	#7  ;checando si esta ocupado o no el LCD
    GOTO    LOOP
    BCLR    PORTD,	#RD2
    NOP
    CLR	    W0
    MOV	    #0XFF00,	W0
    AND	    TRISB
    NOP
    BCLR    PORTD,	#RD1
    NOP
    POP	    W0
    RETURN	
	
;/**@brief ESTa rutina manda comandos al lcd, w0 guarda el comando a enviar
; */	
_comandoLCD:
    BCLR    PORTD, #RD0
    NOP
    BCLR    PORTD,  #RD1
    NOP
    BSET    PORTD,  #RD2
    NOP
    MOV.B   WREG,   PORTB
    NOP
    BCLR    PORTD,  #RD2
    NOP
    RETURN
  
_datoLCD:
    BSET    PORTD, #RD0
    NOP
    BCLR    PORTD,  #RD1
    NOP
    BSET    PORTD,  #RD2
    NOP
    MOV.B   WREG,   PORTB
    NOP
    BCLR    PORTD,  #RD2
    NOP
    RETURN
 