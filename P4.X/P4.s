;/**@brief ESTE PROGRAMA LEE LOS VALORES COLOCADOS EN EL PUERTO D
; * (RD3, RD2, RD2, RD0) MEDIANTE UN DIP-SWITCH. AL VALOR LEIDO 
; * SE LE APLICA LA OPERACI�N: 
; * IF( RF0 = 1 )
; *	PORTB(3...0) = PORTD(3...0) + 5
; * ELSE	
; *	PORTB(3...0) = PORTD(3...0) - 5	
; * EN EL PUERTO B (RB3, RB2, RB1, RB0) SE TIENEN CONECTADOS LEDS
; * PARA VISUALIZAR LA SALIDA
; * @device: DSPIC30F4013
; */
        .equ __30F4013, 1
        .include "p30F4013.inc"
;******************************************************************************
; BITS DE CONFIGURACI�N
;******************************************************************************
;..............................................................................
;SE DESACTIVA EL CLOCK SWITCHING Y EL FAIL-SAFE CLOCK MONITOR (FSCM) Y SE 
;ACTIVA EL OSCILADOR INTERNO (FAST RC) PARA TRABAJAR
;FSCM: PERMITE AL DISPOSITIVO CONTINUAR OPERANDO AUN CUANDO OCURRA UNA FALLA 
;EN EL OSCILADOR. CUANDO OCURRE UNA FALLA EN EL OSCILADOR SE GENERA UNA TRAMPA
;Y SE CAMBIA EL RELOJ AL OSCILADOR FRC  
;..............................................................................
        config __FOSC, CSW_FSCM_OFF & FRC   
;..............................................................................
;SE DESACTIVA EL WATCHDOG
;..............................................................................
        config __FWDT, WDT_OFF 
;..............................................................................
;SE ACTIVA EL POWER ON RESET (POR), BROWN OUT RESET (BOR), POWER UP TIMER (PWRT)
;Y EL MASTER CLEAR (MCLR)
;POR: AL MOMENTO DE ALIMENTAR EL DSPIC OCURRE UN RESET CUANDO EL VOLTAJE DE 
;ALIMENTACI�N ALCANZA UN VOLTAJE DE UMBRAL (VPOR), EL CUAL ES 1.85V
;BOR: ESTE MODULO GENERA UN RESET CUANDO EL VOLTAJE DE ALIMENTACI�N DECAE
;POR DEBAJO DE UN CIERTO UMBRAL ESTABLECIDO (2.7V) 
;PWRT: MANTIENE AL DSPIC EN RESET POR UN CIERTO TIEMPO ESTABLECIDO, ESTO AYUDA
;A ASEGURAR QUE EL VOLTAJE DE ALIMENTACI�N SE HA ESTABILIZADO (16ms) 
;..............................................................................
        config __FBORPOR, PBOR_ON & BORV27 & PWRT_16 & MCLR_EN
;..............................................................................
;SE DESACTIVA EL C�DIGO DE PROTECCI�N
;..............................................................................
   	config __FGS, CODE_PROT_OFF & GWRP_OFF      

;******************************************************************************
; SECCI�N DE DECLARACI�N DE CONSTANTES CON LA DIRECTIVA .EQU (= DEFINE EN C)
;******************************************************************************
        .equ MUESTRAS, 64         ;N�MERO DE MUESTRAS

;******************************************************************************
; DECLARACIONES GLOBALES
;******************************************************************************
;..............................................................................
;PROPORCIONA ALCANCE GLOBAL A LA FUNCI�N _wreg_init, ESTO PERMITE LLAMAR A LA 
;FUNCI�N DESDE UN OTRO PROGRAMA EN ENSAMBLADOR O EN C COLOCANDO LA DECLARACI�N
;"EXTERN"
;..............................................................................
        .global _wreg_init     
;..............................................................................
;ETIQUETA DE LA PRIMER LINEA DE C�DIGO
;..............................................................................
        .global __reset          
;..............................................................................
;DECLARACI�N DE LA ISR DEL TIMER 1 COMO GLOBAL
;..............................................................................
        .global __T1Interrupt    

;******************************************************************************
;CONSTANTES ALMACENADAS EN EL ESPACIO DE LA MEMORIA DE PROGRAMA
;******************************************************************************
        .section .myconstbuffer, code
;..............................................................................
;ALINEA LA SIGUIENTE PALABRA ALMACENADA EN LA MEMORIA 
;DE PROGRAMA A UNA DIRECCION MULTIPLO DE 2
;..............................................................................
        .palign 2                

ps_coeff:
        .hword   0x0002, 0x0003, 0x0005, 0x000A
BOLETA:
	.byte 0X6D,0X7E,0X30,0X5F,0X5F,0X79,0X7E,0X79,0X5B,0X70,0 ;arreglo, inicializacion

;******************************************************************************
;VARIABLES NO INICIALIZADAS EN EL ESPACIO X DE LA MEMORIA DE DATOS
;******************************************************************************
         .section .xbss, bss, xmemory

x_input: .space 2*MUESTRAS        ;RESERVANDO ESPACIO (EN BYTES) A LA VARIABLE

;******************************************************************************
;VARIABLES NO INICIALIZADAS EN EL ESPACIO Y DE LA MEMORIA DE DATOS
;******************************************************************************

          .section .ybss, bss, ymemory

y_input:  .space 2*MUESTRAS       ;RESERVANDO ESPACIO (EN BYTES) A LA VARIABLE
;******************************************************************************
;VARIABLES NO INICIALIZADAS LA MEMORIA DE DATOS CERCANA (NEAR), LOCALIZADA
;EN LOS PRIMEROS 8KB DE RAM
;******************************************************************************
          .section .nbss, bss, near

var1:     .space 2               ;LA VARIABLE VAR1 RESERVA 1 WORD DE ESPACIO

;******************************************************************************
;SECCION DE CODIGO EN LA MEMORIA DE PROGRAMA
;******************************************************************************
.text					;INICIO DE LA SECCION DE CODIGO

__reset:
        MOV	#__SP_init, 	W15	;INICIALIZA EL STACK POINTER

        MOV 	#__SPLIM_init, 	W0     	;INICIALIZA EL REGISTRO STACK POINTER LIMIT 
        MOV 	W0, 		SPLIM

        NOP                       	;UN NOP DESPUES DE LA INICIALIZACION DE SPLIM

        CALL 	_WREG_INIT          	;SE LLAMA A LA RUTINA DE INICIALIZACION DE REGISTROS
                                  	;OPCIONALMENTE USAR RCALL EN LUGAR DE CALL
        CALL    INI_PERIFERICOS
	
	;MOV	#0,		    W3 ;estado
	CLR	W3
	
;memoria del programa
CICLO:
    	MOV	#tblpage(BOLETA),   W0
	MOV	W0,		    TBLPAG
	MOV	#tbloffset(BOLETA), W1 ;leemos byte en byte el arreglo
	GOTO	LEER
CICLO2:
	MOV	#tblpage(BOLETA),   W0
	MOV	W0,		    TBLPAG
	MOV	#tbloffset(BOLETA+10), W1 ;leemos byte en byte el arreglo 
				    ;Aqu� esta bien truqueado
LEER:
	MOV	PORTF,		W2 ;cargamos lo que este en el push button
	NOP
	
	;CP	W2	,#1
	;BRA	Z,	ESTADO	;si el estado del push es uno, entonces procedemos a cambiar de rotacion
	BTSC	W2,	#0		;Verifico si esta presionado el bot�n
	XOR	#0x0001,	W3	;Si esta presionado hago un switch sobre W3 (que inicialmente es 0)
	
	CP	W3	,#0
	BRA	Z,	DERECHA	;si estado = 0, hacia la derecha
	CP	W3	,#1
	BRA	Z,	IZQUIERDA	;si estado = 1, hacia la izquierda
	

DERECHA:	
	CLR	W4		    ;Variable que sirve para saber si venimos de la derecha o no
	TBLRDL.B [W1++],	    W0
	CP0.B	W0 ;compare es una resta (aqu� comparamos si es igual a 0)
	BRA	Z,		    CICLO
		
	MOV.B	WREG,		    PORTB
	NOP
	CALL RETARDO_1S
	GOTO	LEER
	
IZQUIERDA:	
	TBLRDL.B [--W1],	    W0	    ;Retrocedemos el apuntador en 1 por el �ltimo incremento hecho en derecha
	BTSS	W4,	#0		    ;Si es cero, ejecuta la siguiente instrucci�n, esto es para cuando viene de derecha
	TBLRDL.B [--W1],	    W0	    ;Obtenemos ahora si el valor anterior al que tiene W0 actualmente
	MOV	#1,	W4
	CP0.B	W0 ;compare es una resta 
	BRA	Z,		    CICLO2
		
	MOV.B	WREG,		    PORTB
	NOP
	CALL RETARDO_1S
	GOTO	LEER
	
ESTADO:
	BTSS	W3	,#0 ;si vale uno, no sumamos
	INC	W3	,W3	
	NOP
	BTSC	W3	,#0 ;si vale cero, no restamos
	DEC	W3	,W3
	NOP
	GOTO	LEER

;Rutina que genera un retardo de un segundo
RETARDO_1S:
	PUSH	W0				    ;PUSH.D W0 Es equivalente a estas dos l?neas de c?digo
	PUSH	W1				    ;Guardado de valor de registros
	MOV	#5,		W1
CICLO2_1S:
	CLR	W0
CICLO_1S:
	DEC	W0,		W0		    ; si pasa por la Alu por lo cual NZ se afecta
	BRA	NZ,		CICLO_1S
	
	DEC	W1,		W1
	BRA	NZ,		CICLO2_1S	    ; El decremento hace que el 0 se convierta en 65536
	POP	W1				    ; Recuperar valor del registro, es recomendable hacerlo
	POP	W0
	RETURN	

;/**@brief ESTA RUTINA INICIALIZA LOS PERIFERICOS DEL DSC
; * PORTD: 
; * RD0 - ENTRADA, DIPSWITCH 0 
; * RD1 - ENTRADA, DIPSWITCH 1 
; * RD2 - ENTRADA, DIPSWITCH 2 
; * RD3 - ENTRADA, DIPSWITCH 3 
; * PORTB: 
; * RB0 - SALIDA, LED 0 
; * RB1 - SALIDA, LED 1 
; * RB2 - SALIDA, LED 2 
; * RB3 - SALIDA, LED 3 
; * PORTF: 
; * RF0 - ENTRADA, PUSH BUTTON 
; */
INI_PERIFERICOS:
;	CLR	PORTD
;	NOP
;	CLR	LATD
;	NOP
;	MOV	#0X000F,	W0
;	MOV	W0,		TRISD
;	NOP
	
	CLR	PORTB
	NOP
	CLR	LATB
	NOP
	CLR	TRISB
	NOP
	SETM	ADPCFG

	CLR	PORTF
	NOP
	CLR	LATF
	NOP
	CLR	TRISF
	NOP
	BSET	TRISF,	    #TRISF0
	NOP
	
        RETURN

;/**@brief ESTA RUTINA INICIALIZA LOS REGISTROS Wn A 0X0000
; */
_WREG_INIT:
        CLR 	W0
        MOV 	W0, 				W14
        REPEAT 	#12
        MOV 	W0, 				[++W14]
        CLR 	W14
        RETURN

;/**@brief ISR (INTERRUPT SERVICE ROUTINE) DEL TIMER 1
; * SE USA PUSH.S PARA GUARDAR LOS REGISTROS W0, W1, W2, W3, 
; * C, Z, N Y DC EN LOS REGISTROS SOMBRA
; */
__T1Interrupt:
        PUSH.S 


        BCLR IFS0, #T1IF           ;SE LIMPIA LA BANDERA DE INTERRUPCION DEL TIMER 1

        POP.S

        RETFIE                     ;REGRESO DE LA ISR


.END                               ;TERMINACION DEL CODIGO DE PROGRAMA EN ESTE ARCHIVO











