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
void iniInterrupciones( void );

//LCD
void desplazaVentana(void);
short int CONV_CODIGO( short int codigo);
extern void iniLCD8bits( void );
extern void datoLCD( unsigned char );
extern void busyFlagLCD( void );
extern void comandoLCD( unsigned char );
extern void imprimeLCD( char msj[] );

//Retardos
extern void retardo1S(void);
extern void RETARDO_HALFS( void );

//Piano
extern void DO( char msj[] );
extern void RE( char msj[] );
extern void MI( char msj[] );
extern void FA( char msj[] );
extern void SOL( char msj[] );
extern void LA( char msj[] );
extern void SI( char msj[] );

//Variables
char mensajeDO[] = "NOTA DO";
char mensajeRE[] = "NOTA RE";
char mensajeMI[] = "NOTA MI";
char mensajeFA[] = "NOTA FA";
char mensajeSOL[] = "NOTA SOL";
char mensajeLA[] = "NOTA LA";
char mensajeSI[] = "NOTA Si";

unsigned char BP;

int main (void)
{
    iniPerifericos();
    
    iniLCD8bits();
    
    IFS0bits.T1IF = 0;
    IEC0bits.T1IE = 1;
    
    BP=0;
        
      
    for(;EVER;)
    {
        if(PORTF == 0x0001)         //DO
        {
            if(BP==0)
            {
                DO(mensajeDO);
                BP = 1;
            }
        }
        else
        {
            if(PORTF == 0x0002)         //RE
            {
                if(BP==0)
                {

                    BP = 1;
                }
            }
            else
            {
                if(PORTF == 0x0004)         //MI
                {
                    if(BP==0)
                    {

                        BP = 1;
                    }
                }
                else
                {
                    if(PORTF == 0x0008)         //FA
                    {
                        if(BP==0)
                        {

                            BP = 1;
                        }
                    }
                    else
                    {
                        if(PORTF == 0x0010)         //SOL
                        {
                            if(BP==0)
                            {

                                BP = 1;
                            }
                        }
                        else
                        {
                            if(PORTF == 0x0020)         //LA
                            {
                                if(BP==0)
                                {

                                    BP = 1;
                                }
                            }
                            else
                            {
                                if(PORTF == 0x0040)         //SI
                                {
                                    if(BP==0)
                                    {

                                        BP = 1;
                                    }
                                }
                                else
                                {
                                    BP = 0;
                                    PORTDbits.RD3 = 0;
                                    T1CONbits.TON = 0;
                                    comandoLCD(1);
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    return 0;
}

void desplazaVentana(){
    comandoLCD(0x18);
    RETARDO_HALFS();
}
/****************************************************************************/
/* DESCRICION:	ESTA RUTINA INICIALIZA LAS INTERRPCIONES    				*/
/* PARAMETROS: NINGUNO                                                      */
/* RETORNO: NINGUNO															*/
/****************************************************************************/
void iniInterrupciones( void )
{
    //Habilitacion de interrupcion del periférico 1
    //Habilitacion de interrupcion del periférico 2
    //Habilitacion de interrupcion del periférico 3
}
/****************************************************************************/
/* DESCRICION:	ESTA RUTINA INICIALIZA LOS PERIFERICOS						*/
/* PARAMETROS: NINGUNO                                                      */
/* RETORNO: NINGUNO															*/
/****************************************************************************/
void iniPerifericos( void )
{
    
    //Entradas
    PORTF = 0;
    Nop();
    LATF = 0;
    Nop();
    TRISF = 0xFFFF;
    Nop();
    
    //Salidas
    PORTB = 0;
    Nop();
    LATB = 0;
    Nop();
    TRISB = 0;
    Nop();
    
    PORTD = 0;
    Nop();
    LATD = 0;
    Nop();
    TRISD = 0;
    Nop();
    
    ADPCFG = 0XFFFF;
}

/********************************************************************************/
/* DESCRICION:	ISR (INTERRUPT SERVICE ROUTINE) DEL TIMER 1						*/
/* LA RUTINA TIENE QUE SER GLOBAL PARA SER UNA ISR								*/	
/* SE USA PUSH.S PARA GUARDAR LOS REGISTROS W0, W1, W2, W3, C, Z, N Y DC EN LOS */
/* REGISTROS SOMBRA																*/
/********************************************************************************/
void __attribute__((__interrupt__)) _T1Interrupt( void )
{
        IFS0bits.T1IF = 0;    //SE LIMPIA LA BANDERA DE INTERRUPCION DEL TIMER 1                      
}
