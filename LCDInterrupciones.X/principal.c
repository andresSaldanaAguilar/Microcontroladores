/**@brief: Este programa muestra los bloques de un 
 * programa en C embebido para el DSPIC, los bloques son:
 * BLOQUE 1. OPCIONES DE CONFIGURACION DEL DSC: OSCILADOR, WATCHDOG,
 * BROWN OUT RESET, POWER ON RESET Y CODIGO DE PROTECCION
 * BLOQUE 2. EQUIVALENCIAS Y DECLARACIONES GLOBALES
 * BLOQUE 3. ESPACIOS DE MEMORIA: PROGRAMA, DATOS X, DATOS Y, DATOS NEAR
 * BLOQUE 4. C�DIGO DE APLICACI�N
 * @device: DSPIC30F4013
 * @oscillator: FRC, 7.3728MHz
 */
#include "p30F4013.h"
/********************************************************************************/
/*                      BITS DE CONFIGURACI�N                                   */ 
/********************************************************************************/
/* SE DESACTIVA EL CLOCK SWITCHING Y EL FAIL-SAFE CLOCK MONITOR (FSCM) Y SE     */
/* ACTIVA EL OSCILADOR INTERNO (FAST RC) PARA TRABAJAR                          */
/* FSCM: PERMITE AL DISPOSITIVO CONTINUAR OPERANDO AUN CUANDO OCURRA UNA FALLA  */
/* EN EL OSCILADOR. CUANDO OCURRE UNA FALLA EN EL OSCILADOR SE GENERA UNA       */
/* TRAMPA Y SE CAMBIA EL RELOJ AL OSCILADOR FRC                                 */
/********************************************************************************/
//_FOSC(CSW_FSCM_OFF & FRC); 
#pragma config FOSFPR = FRC             // Oscillator (Internal Fast RC (No change to Primary Osc Mode bits))
#pragma config FCKSMEN = CSW_FSCM_OFF   // Clock Switching and Monitor (Sw Disabled, Mon Disabled)/********************************************************************************/
/* SE DESACTIVA EL WATCHDOG                                                     */
/********************************************************************************/
//_FWDT(WDT_OFF); 
#pragma config WDT = WDT_OFF            // Watchdog Timer (Disabled)
/********************************************************************************/
/* SE ACTIVA EL POWER ON RESET (POR), BROWN OUT RESET (BOR),                    */ 
/* POWER UP TIMER (PWRT) Y EL MASTER CLEAR (MCLR)                               */
/* POR: AL MOMENTO DE ALIMENTAR EL DSPIC OCURRE UN RESET CUANDO EL VOLTAJE DE   */ 
/* ALIMENTACI�N ALCANZA UN VOLTAJE DE UMBRAL (VPOR), EL CUAL ES 1.85V           */
/* BOR: ESTE MODULO GENERA UN RESET CUANDO EL VOLTAJE DE ALIMENTACI�N DECAE     */
/* POR DEBAJO DE UN CIERTO UMBRAL ESTABLECIDO (2.7V)                            */
/* PWRT: MANTIENE AL DSPIC EN RESET POR UN CIERTO TIEMPO ESTABLECIDO, ESTO      */
/* AYUDA A ASEGURAR QUE EL VOLTAJE DE ALIMENTACI�N SE HA ESTABILIZADO (16ms)    */
/********************************************************************************/
//_FBORPOR( PBOR_ON & BORV27 & PWRT_16 & MCLR_EN ); 
// FBORPOR
#pragma config FPWRT  = PWRT_16          // POR Timer Value (16ms)
#pragma config BODENV = BORV20           // Brown Out Voltage (2.7V)
#pragma config BOREN  = PBOR_ON          // PBOR Enable (Enabled)
#pragma config MCLRE  = MCLR_EN          // Master Clear Enable (Enabled)
/********************************************************************************/
/*SE DESACTIVA EL C�DIGO DE PROTECCI�N                                          */
/********************************************************************************/
//_FGS(CODE_PROT_OFF);      
// FGS
#pragma config GWRP = GWRP_OFF          // General Code Segment Write Protect (Disabled)
#pragma config GCP = CODE_PROT_OFF      // General Segment Code Protection (Disabled)
 
/********************************************************************************/
/* SECCI�N DE DECLARACI�N DE CONSTANTES CON DEFINE                              */
/********************************************************************************/
#define EVER 1
#define MUESTRAS 64
 
/********************************************************************************/
/* DECLARACIONES GLOBALES                                                       */
/********************************************************************************/
/*DECLARACI�N DE LA ISR DEL TIMER 1 USANDO __attribute__                        */
/********************************************************************************/
void __attribute__((__interrupt__)) _T1Interrupt( void );
 
/********************************************************************************/
/* CONSTANTES ALMACENADAS EN EL ESPACIO DE LA MEMORIA DE PROGRAMA               */
/********************************************************************************/
int ps_coeff __attribute__ ((aligned (2), space(prog)));
/********************************************************************************/
/* VARIABLES NO INICIALIZADAS EN EL ESPACIO X DE LA MEMORIA DE DATOS            */
/********************************************************************************/
int x_input[MUESTRAS] __attribute__ ((space(xmemory)));
/********************************************************************************/
/* VARIABLES NO INICIALIZADAS EN EL ESPACIO Y DE LA MEMORIA DE DATOS            */
/********************************************************************************/
int y_input[MUESTRAS] __attribute__ ((space(ymemory)));
/********************************************************************************/
/* VARIABLES NO INICIALIZADAS LA MEMORIA DE DATOS CERCANA (NEAR), LOCALIZADA    */
/* EN LOS PRIMEROS 8KB DE RAM                                                   */
/********************************************************************************/
int var1 __attribute__ ((near));

void iniPerifericos( void );
void iniInterrupciones( void );
void RETARDO_1S( void );
void RETARDO_15ms( void );
void INT0Interrupt (void);
void iniLCD8bits( void );
void datoLCD( unsigned char);  
void busyFlagLCD( void ); 
void comandoLCD( unsigned char );
void imprimeLCD (char msj[]);

char cont[5];
//Variables para llevar conteo en la lcd
unsigned char uni, dec, cen, umi;

int main (void)
{   
    //Inicializamos perifericos
    iniPerifericos();
    //Inicializamos la lcd
    iniLCD8bits();
    //Imprimimos que iniciara el conteo
    imprimeLCD("Conteo:");
    //Variables para conteo todas inician en cero
    umi=0;
    cen=0;
    dec=0;
    uni=0;
    //Interrupciones
    iniInterrupciones(); 
    
    for(;EVER;)
    {
        //Pasamos el valor que tengan las variables
        //del conteo a ascii
        //la primera vez que se pasa por aqu� se convierten en cero
        cont[0]=umi+0x30;
        cont[1]=cen+0x30;
        cont[2]=dec+0x30;
        cont[3]=uni+0x30;
        cont[4]=0;
        //RETARDO_15ms();
        //RETARDO_15ms();
        imprimeLCD(cont);
        busyFlagLCD(); 
        comandoLCD(0x87);
    }
     
    return 0;
}
/****************************************************************************/
/* DESCRICION:  ESTA RUTINA INICIALIZA LAS INTERRPCIONES                    */
/* PARAMETROS: NINGUNO                                                      */
/* RETORNO: NINGUNO                                                         */
/****************************************************************************/
void iniInterrupciones( void )
{
    // Reset Interrupt flags.
    IFS1bits.INT1IF = 0;    //Reset INT0 interrupt flag
    IFS1bits.INT2IF = 0;    //Reset INT0 interrupt flag
 
    //Inicializamos interrupciones
    IFS0bits.INT0IF=0; //Reset INT0 interrupt flag
    IEC0bits.INT0IE=1;  //enable INT0 Interrupt Service Routine.
    INTCON2bits.INT0EP=1; // Interrupt edge polarity.
    
    // Set Interrupt Priority.
    IPC0bits.INT0IP = 1;    // set low priority.

}
/****************************************************************************/
/* DESCRICION:  ESTA RUTINA INICIALIZA LOS PERIFERICOS                      */
/* PARAMETROS: NINGUNO                                                      */
/* RETORNO: NINGUNO                                                         */
/****************************************************************************/
void iniPerifericos( void )
{   
    //Inicializamos puerto D
    PORTD = 0;
    Nop();
    LATD = 0;
    Nop();
    TRISD = 0;
    Nop();    
    
    //Inicializamos puerto B
    PORTB=0;
    Nop();
    LATB=0;
    Nop();
    TRISB=0;
    Nop();
    
    //Inicializamos puerto A
    PORTA=0;
    Nop();
    LATA=0;
    Nop();
    TRISA=0XFFFF;
    Nop();
    
    //Deshabilitamos analogico digital
    ADPCFG=0XFFFF;    
}
 
/********************************************************************************/
/* DESCRICION:  ISR (INTERRUPT SERVICE ROUTINE) DEL TIMER 1                     */
/* LA RUTINA TIENE QUE SER GLOBAL PARA SER UNA ISR                              */ 
/* SE USA PUSH.S PARA GUARDAR LOS REGISTROS W0, W1, W2, W3, C, Z, N Y DC EN LOS */
/* REGISTROS SOMBRA                                                             */
/********************************************************************************/
void __attribute__((__interrupt__)) _T1Interrupt( void )
{
        IFS0bits.T1IF = 0;    //SE LIMPIA LA BANDERA DE INTERRUPCION DEL TIMER 1                      
}