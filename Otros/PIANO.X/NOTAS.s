        .include "p30F4013.inc"
	.GLOBAL	_DO
	.GLOBAL	_RE
	.GLOBAL	_MI
	.GLOBAL	_FA
	.GLOBAL	_SOL
	.GLOBAL	_LA
	.GLOBAL	_SI
	.GLOBAL	_ISR_T1
	
;******************************************************************************
;DESCRICION:	NOTA DO
;PARAMETROS: 	APUNTADOR DEl ARREGLO
;RETORNO:	NINGUNO
;******************************************************************************
_DO:
    MOV		#0x0000	    ,	W2
    MOV		W2	    ,	TMR1
    MOV		#0x0037	    ,	W2
    MOV		W2	    ,	PR1
    MOV		#0x8020	    ,	W2
    MOV		W2	    ,	T1CON
    
    CALL	_imprimeLCD
    
    RETURN
    
    
;******************************************************************************
;DESCRICION:	NOTA RE
;PARAMETROS: 	APUNTADOR DEl ARREGLO
;RETORNO:	NINGUNO
;******************************************************************************
_RE:
    MOV		#0x0000	    ,	W2
    MOV		W2	    ,	TMR1
    MOV		#0x0031	    ,	W2
    MOV		W2	    ,	PR1
    MOV		#0x8020	    ,	W2
    MOV		W2	    ,	T1CON
    
    CALL	_imprimeLCD
    
    RETURN
    
    
;******************************************************************************
;DESCRICION:	NOTA MI
;PARAMETROS: 	APUNTADOR DEl ARREGLO
;RETORNO:	NINGUNO
;******************************************************************************
_MI:
    MOV		#0x0000	    ,	W2
    MOV		W2	    ,	TMR1
    MOV		#0x000B	    ,	W2
    MOV		W2	    ,	PR1
    MOV		#0x8030	    ,	W2
    MOV		W2	    ,	T1CON
    
    CALL	_imprimeLCD
    
    RETURN
    
    
;******************************************************************************
;DESCRICION:	NOTA FA
;PARAMETROS: 	APUNTADOR DEl ARREGLO
;RETORNO:	NINGUNO
;******************************************************************************
_FA:
    MOV		#0x0000	    ,	W2
    MOV		W2	    ,	TMR1
    MOV		#0x0A4F    ,	W2
    MOV		W2	    ,	PR1
    MOV		#0x8000	    ,	W2
    MOV		W2	    ,	T1CON
    
    CALL	_imprimeLCD
    
    RETURN
    
    
;******************************************************************************
;DESCRICION:	NOTA SOL
;PARAMETROS: 	APUNTADOR DEl ARREGLO
;RETORNO:	NINGUNO
;******************************************************************************
_SOL:
    MOV		#0x0000	    ,	W2
    MOV		W2	    ,	TMR1
    MOV		#0x092F    ,	W2
    MOV		W2	    ,	PR1
    MOV		#0x8000	    ,	W2
    MOV		W2	    ,	T1CON
    
    CALL	_imprimeLCD
    
    RETURN
    
    
;******************************************************************************
;DESCRICION:	NOTA LA
;PARAMETROS: 	APUNTADOR DEl ARREGLO
;RETORNO:	NINGUNO
;******************************************************************************
_lA:
    MOV		#0x0000	    ,	W2
    MOV		W2	    ,	TMR1
    MOV		#0x0008    ,	W2
    MOV		W2	    ,	PR1
    MOV		#0x8030	    ,	W2
    MOV		W2	    ,	T1CON
    
    CALL	_imprimeLCD
    
    RETURN
    
    
;******************************************************************************
;DESCRICION:	NOTA SI
;PARAMETROS: 	APUNTADOR DEl ARREGLO
;RETORNO:	NINGUNO
;******************************************************************************
_SI:
    MOV		#0x0000	    ,	W2
    MOV		W2	    ,	TMR1
    MOV		#0x074A     ,	W2
    MOV		W2	    ,	PR1
    MOV		#0x8000	    ,	W2
    MOV		W2	    ,	T1CON
    
    CALL	_imprimeLCD
    
    RETURN
    

;******************************************************************************
;DESCRICION:	NOTA ISR
;PARAMETROS: 	NINGUNO
;RETORNO:	NINGUNO
;******************************************************************************
    
_ISR_T1:
    BTG	    LATD    ,	#RD3
    RETURN


