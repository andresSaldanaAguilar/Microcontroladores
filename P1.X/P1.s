;/**@brief ESTE PROGRAMA LEE LOS VALORES COLOCADOS EN EL PUERTO D
; * (RD3, RD2, RD2, RD0) MEDIANTE UN DIP-SWITCH Y LOS COLOCA EN EL 
; * PUERTO B (RB3, RB2, RB1, RB0) DONDE SE TIENEN CONECTADOS LEDS
; * PARA VISUALIZAR LA SALIDA
; * @device: DSPIC30F4013
; */
        .equ __30F4013, 1
        .include "p30F4013.inc"
;******************************************************************************
; BITS DE CONFIGURACIÓN
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
;SE DESACTIVA EL WATCHDOG, SIN USO
;..............................................................................
        config __FWDT, WDT_OFF 
;..............................................................................
;SE ACTIVA EL POWER ON RESET (POR), BROWN OUT RESET (BOR), POWER UP TIMER (PWRT)
;Y EL MASTER CLEAR (MCLR)
;POR: AL MOMENTO DE ALIMENTAR EL DSPIC OCURRE UN RESET CUANDO EL VOLTAJE DE 
;ALIMENTACIÓN ALCANZA UN VOLTAJE DE UMBRAL (VPOR), EL CUAL ES 1.85V
;BOR: ESTE MODULO GENERA UN RESET CUANDO EL VOLTAJE DE ALIMENTACIÓN DECAE
;POR DEBAJO DE UN CIERTO UMBRAL ESTABLECIDO (2.7V) 
;PWRT: MANTIENE AL DSPIC EN RESET POR UN CIERTO TIEMPO ESTABLECIDO, ESTO AYUDA
;A ASEGURAR QUE EL VOLTAJE DE ALIMENTACIÓN SE HA ESTABILIZADO (16ms) 
;..............................................................................
        config __FBORPOR, PBOR_ON & BORV27 & PWRT_16 & MCLR_EN
;..............................................................................
;SE DESACTIVA EL CÓDIGO DE PROTECCIÓN
;..............................................................................
   	config __FGS, CODE_PROT_OFF & GWRP_OFF      

;******************************************************************************
; SECCIÓN DE DECLARACIÓN DE CONSTANTES CON LA DIRECTIVA .EQU (= DEFINE EN C)
;******************************************************************************
        .equ MUESTRAS, 64         ;NÚMERO DE MUESTRAS

;******************************************************************************
; DECLARACIONES GLOBALES
;******************************************************************************
;..............................................................................
;PROPORCIONA ALCANCE GLOBAL A LA FUNCIÓN _wreg_init, ESTO PERMITE LLAMAR A LA 
;FUNCIÓN DESDE UN OTRO PROGRAMA EN ENSAMBLADOR O EN C COLOCANDO LA DECLARACIÓN
;"EXTERN"
;..............................................................................
        .global _wreg_init     
;..............................................................................
;ETIQUETA DE LA PRIMER LINEA DE CÓDIGO
;..............................................................................
        .global __reset          
;..............................................................................
;DECLARACIÓN DE LA ISR DEL TIMER 1 COMO GLOBAL
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
PRENDER:
	MOV	#0x0000,	W2
	BSET	W0,		#0
	MOV	W0,	PORTB
	MOV	#0x0000,	W2
	;MOV	#0x0001,	W1
CICLO:
	BTSC	PORTF,	#RF0		;Verifico si esta presionado el botón
	XOR	#0x0001,	W2	;Si esta presionado hago un switch sobre W2 (que inicialmente es 0)
	;BTSS	PORTF,	#RF0
	;BSET	W2,	#0
	
	BTSC	W2,	#RF0
	CALL	CORRIMIENTO_DERECHA
	
	BTSS	W2,	#RF0
	CALL	CORRIMIENTO_IZQUIERDA

	MOV	W0,	PORTB	
	NOP
	CALL	RETARDO_1S
	GOTO	CICLO
CORRIMIENTO_IZQUIERDA:
	SL	W0,	W0
	CP	W0,	#0x0000
	BRA	Z,	REINICIAR
	RETURN
CORRIMIENTO_DERECHA:
	LSR	W0,	W0
	CP	W0,	#0x0000
	BRA	Z,	REINICIAR2
	RETURN
REINICIAR:
	MOV	#0x0001,    W0
	RETURN
REINICIAR2:
	MOV	#0x8000,    W0
	RETURN
;Rutina que genera un retardo de un segundo
RETARDO_1S:
	PUSH	W0				    ;PUSH.D W0 Es equivalente a estas dos líneas de código
	PUSH	W1				    ;Guardado de valor de registros
	MOV	#1,		W1
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
; */
INI_PERIFERICOS:
	CLR	PORTD
	NOP
	CLR	LATD
	NOP
	SETM	TRISD
	NOP
	
	CLR	PORTB
	NOP
	CLR	LATB
	NOP
	CLR	TRISB
	NOP
	SETM	ADPCFG	;PUERTO DIGITAL
	NOP
	CLR	PORTF
	NOP
	CLR	LATF
	NOP
	BSET	TRISF, #TRISF0
	
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


















