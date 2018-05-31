/**@brief: Este programa muestra los bloques de un 
 * programa en C embebido para el DSPIC, los bloques son:
 * BLOQUE 1. OPCIONES DE CONFIGURACION DEL DSC: OSCILADOR, WATCHDOG,
 * BROWN OUT RESET, POWER ON RESET Y CODIGO DE PROTECCION
 * BLOQUE 2. EQUIVALENCIAS Y DECLARACIONES GLOBALES
 * BLOQUE 3. ESPACIOS DE MEMORIA: PROGRAMA, DATOS X, DATOS Y, DATOS NEAR
 * BLOQUE 4. CÓDIGO DE APLICACIÓN
 * @device: DSPIC30F4013
 * @oscillator: FRC, 7.3728MHz
 */
#include "p30F4013.h"
/********************************************************************************/
/* 						BITS DE CONFIGURACIÓN									*/	
/********************************************************************************/
/* SE DESACTIVA EL CLOCK SWITCHING Y EL FAIL-SAFE CLOCK MONITOR (FSCM) Y SE 	*/
/* ACTIVA EL OSCILADOR INTERNO (FAST RC) PARA TRABAJAR							*/
/* FSCM: PERMITE AL DISPOSITIVO CONTINUAR OPERANDO AUN CUANDO OCURRA UNA FALLA 	*/
/* EN EL OSCILADOR. CUANDO OCURRE UNA FALLA EN EL OSCILADOR SE GENERA UNA 		*/
/* TRAMPA Y SE CAMBIA EL RELOJ AL OSCILADOR FRC  								*/
/********************************************************************************/
//_FOSC(CSW_FSCM_OFF & FRC); 
#pragma config FOSFPR = FRC             // Oscillator (Internal Fast RC (No change to Primary Osc Mode bits))
#pragma config FCKSMEN = CSW_FSCM_OFF   // Clock Switching and Monitor (Sw Disabled, Mon Disabled)/********************************************************************************/
/* SE DESACTIVA EL WATCHDOG														*/
/********************************************************************************/
//_FWDT(WDT_OFF); 
#pragma config WDT = WDT_OFF            // Watchdog Timer (Disabled)
/********************************************************************************/
/* SE ACTIVA EL POWER ON RESET (POR), BROWN OUT RESET (BOR), 					*/	
/* POWER UP TIMER (PWRT) Y EL MASTER CLEAR (MCLR)								*/
/* POR: AL MOMENTO DE ALIMENTAR EL DSPIC OCURRE UN RESET CUANDO EL VOLTAJE DE 	*/	
/* ALIMENTACIÓN ALCANZA UN VOLTAJE DE UMBRAL (VPOR), EL CUAL ES 1.85V			*/
/* BOR: ESTE MODULO GENERA UN RESET CUANDO EL VOLTAJE DE ALIMENTACIÓN DECAE		*/
/* POR DEBAJO DE UN CIERTO UMBRAL ESTABLECIDO (2.7V) 							*/
/* PWRT: MANTIENE AL DSPIC EN RESET POR UN CIERTO TIEMPO ESTABLECIDO, ESTO 		*/
/* AYUDA A ASEGURAR QUE EL VOLTAJE DE ALIMENTACIÓN SE HA ESTABILIZADO (16ms) 	*/
/********************************************************************************/
//_FBORPOR( PBOR_ON & BORV27 & PWRT_16 & MCLR_EN ); 
// FBORPOR
#pragma config FPWRT  = PWRT_16          // POR Timer Value (16ms)
#pragma config BODENV = BORV20           // Brown Out Voltage (2.7V)
#pragma config BOREN  = PBOR_ON          // PBOR Enable (Enabled)
#pragma config MCLRE  = MCLR_EN          // Master Clear Enable (Enabled)
/********************************************************************************/
/*SE DESACTIVA EL CÓDIGO DE PROTECCIÓN											*/
/********************************************************************************/
//_FGS(CODE_PROT_OFF);      
// FGS
#pragma config GWRP = GWRP_OFF          // General Code Segment Write Protect (Disabled)
#pragma config GCP = CODE_PROT_OFF      // General Segment Code Protection (Disabled)

/********************************************************************************/
/* SECCIÓN DE DECLARACIÓN DE CONSTANTES CON DEFINE								*/
/********************************************************************************/
#define EVER 1
#define MUESTRAS 64

/********************************************************************************/
/* DECLARACIONES GLOBALES														*/
/********************************************************************************/
/*DECLARACIÓN DE LA ISR DEL TIMER 1 USANDO __attribute__						*/
/********************************************************************************/
void __attribute__((__interrupt__)) _T1Interrupt( void );

/********************************************************************************/
/* CONSTANTES ALMACENADAS EN EL ESPACIO DE LA MEMORIA DE PROGRAMA				*/
/********************************************************************************/
int ps_coeff __attribute__ ((aligned (2), space(prog)));
/********************************************************************************/
/* VARIABLES NO INICIALIZADAS EN EL ESPACIO X DE LA MEMORIA DE DATOS			*/
/********************************************************************************/
int x_input[MUESTRAS] __attribute__ ((space(xmemory)));
/********************************************************************************/
/* VARIABLES NO INICIALIZADAS EN EL ESPACIO Y DE LA MEMORIA DE DATOS			*/
/********************************************************************************/
int y_input[MUESTRAS] __attribute__ ((space(ymemory)));
/********************************************************************************/
/* VARIABLES NO INICIALIZADAS LA MEMORIA DE DATOS CERCANA (NEAR), LOCALIZADA	*/
/* EN LOS PRIMEROS 8KB DE RAM													*/
/********************************************************************************/
int var1 __attribute__ ((near));

//Inicialización
void iniPerifericos( void );
void iniWIFI(void);
void configWIFI(void);
void RETARDO_1S( void );
void comandoAT(char msj[]);

char RST[] = {'A','T','+','R','S','T',13,10,0};
char CWMODE[] = {'A','T','+','C','W','M','O','D','E','=','1',13,10,0};
char CIPMUX[] = {'A','T','+','C','I','P','M','U','X','=','0',13,10,0};
char CWJAP[] = {'A','T','+','C','W','J','A','P','=','\"','W','I','F','I','i','p','n','\"',',','\"','\"',13,10,0};
char CIFSR[] = {'A','T','+','C','I','F','S','R',13,10,0};
char CIPSTART[] = {'A','T','+','C','I','P','S','T','A','R','T','=','\"','T','C','P','\"',',','\"','1','2','7','.','0','.','0','.','1','\"',',','8','0','0','0',13,10,0};
char CIPSEND[] = {'A','T','+','C','I','P','S','E','N','D','=','4',13,10,0};

//Variables

int main (void)
{
    iniPerifericos();
    
    //UART1 BAUDIOS:115200
    U1BRG  = 0; // (1.8432*10^6)/(16*115200) = 0
    U1MODE = 0X0420; //uart disable, usa los alternos, autobaudaje
    U1STA  = 0X8000;
    
    //UART2 BAUDIOS:115200
    U2BRG  = 0; // (1.8432*10^6)/(16*115200) = 0
    U2MODE = 0X0020; //uart disable,no usa los alternos, autobaudaje??
    U2STA  = 0X8000;
    
    //Interrupciones de uart2
    IFS1bits.U2RXIF= 0;
    IEC1bits.U2RXIE= 1;
    
    iniWIFI();
    configWIFI();
    
    //Habilitamos el uart1 y uart2
    U1MODEbits.UARTEN = 1;
    U2MODEbits.UARTEN = 1;

    U2TXREG = 'H';
    U2TXREG = 'O';
    U2TXREG = 'L';
    U2TXREG = 'A';
    
    for(;EVER;)
    { 
        Nop();
    }
    
    return 0;
}

/****************************************************************************/
/* DESCRICION:	ESTA RUTINA INICIALIZA LOS PERIFERICOS						*/
/* PARAMETROS: NINGUNO                                                      */
/* RETORNO: NINGUNO															*/
/****************************************************************************/
void iniPerifericos( void )
{   
    //Perifericos C
    PORTC = 0;
    Nop();
    LATC = 0;
    Nop();
    //TRISCbits.TRISC13 = 0;
    //Nop();
    TRISCbits.TRISC14 = 1;
    Nop();
    
    //Perifericos F
    TRISFbits.TRISF5 = 1; //U2RX
    Nop();
    TRISFbits.TRISF4 = 0; //U2TX
    Nop();
    PORTF = 0;
    Nop();
    LATF = 0;
    Nop();
}

void iniWIFI(void){
    PORTBbits.RB8 = 1;
    
    RETARDO_1S();
    RETARDO_1S();
    RETARDO_1S();
    
    PORTDbits.RD1 = 1;
    
    RETARDO_1S();
    
    PORTDbits.RD1 = 0;
    
    RETARDO_1S();

    PORTDbits.RD1 = 1; 
    
    RETARDO_1S();  
}

void configWIFI(void){
    comandoAT(RST);
    comandoAT(CWMODE);
    comandoAT(CIPMUX);
    comandoAT(CWJAP);
    comandoAT(CIFSR);
    comandoAT(CIPSTART);
    comandoAT(CIPSEND);    
}


