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
/*                      BITS DE CONFIGURACIÓN                                   */ 
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
/* ALIMENTACIÓN ALCANZA UN VOLTAJE DE UMBRAL (VPOR), EL CUAL ES 1.85V           */
/* BOR: ESTE MODULO GENERA UN RESET CUANDO EL VOLTAJE DE ALIMENTACIÓN DECAE     */
/* POR DEBAJO DE UN CIERTO UMBRAL ESTABLECIDO (2.7V)                            */
/* PWRT: MANTIENE AL DSPIC EN RESET POR UN CIERTO TIEMPO ESTABLECIDO, ESTO      */
/* AYUDA A ASEGURAR QUE EL VOLTAJE DE ALIMENTACIÓN SE HA ESTABILIZADO (16ms)    */
/********************************************************************************/
//_FBORPOR( PBOR_ON & BORV27 & PWRT_16 & MCLR_EN ); 
// FBORPOR
#pragma config FPWRT  = PWRT_16          // POR Timer Value (16ms)
#pragma config BODENV = BORV20           // Brown Out Voltage (2.7V)
#pragma config BOREN  = PBOR_ON          // PBOR Enable (Enabled)
#pragma config MCLRE  = MCLR_EN          // Master Clear Enable (Enabled)
/********************************************************************************/
/*SE DESACTIVA EL CÓDIGO DE PROTECCIÓN                                          */
/********************************************************************************/
//_FGS(CODE_PROT_OFF);      
// FGS
#pragma config GWRP = GWRP_OFF          // General Code Segment Write Protect (Disabled)
#pragma config GCP = CODE_PROT_OFF      // General Segment Code Protection (Disabled)
 
/********************************************************************************/
/* SECCIÓN DE DECLARACIÓN DE CONSTANTES CON DEFINE                              */
/********************************************************************************/
#define EVER 1
#define MUESTRAS 64
 
/********************************************************************************/
/* DECLARACIONES GLOBALES                                                       */
/********************************************************************************/
/*DECLARACIÓN DE LA ISR DEL TIMER 1 USANDO __attribute__                        */
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
//Funciones para las notas
void Nota_DO(void);
void Nota_RE(void);
void Nota_MI(void);
void Nota_FA(void);
void Nota_SOL(void);
void Nota_LA(void);
void Nota_SI(void);

//char cont[5];
//Bandera
unsigned char BP;

int main (void)
{   
    //Inicializamos perifericos
    iniPerifericos();
    //Inicializamos la lcd
    iniLCD8bits();
    //Interrupciones
    iniInterrupciones(); 
    //bandera
    BP = 0;

    
    for(;EVER;)
    {
        if(!PORTFbits.RF0){ //DO
            if(!BP){
                Nota_DO();
                imprimeLCD("NOTA DO");
                BP = 1;
            }
        }
        else if(!PORTFbits.RF1){ //RE
                if(!BP){
                    Nota_RE();
                    imprimeLCD("NOTA RE");
                    BP = 1;
                }
            }
        else if(!PORTFbits.RF2){ //MI
            if(!BP){
                Nota_MI();
                imprimeLCD("NOTA MI");
                BP = 1;
            }
        }
        else if(!PORTFbits.RF3){ //FA
            if(!BP){
                Nota_FA();
                imprimeLCD("NOTA FA");
                BP = 1;
            }
        }
        else if(!PORTFbits.RF4){ //SOL
            if(!BP){
                Nota_SOL();
                imprimeLCD("NOTA SOL");
                BP = 1;
            }
        }
        else if(!PORTFbits.RF5){ //LA
            if(!BP){
                Nota_LA();
                imprimeLCD("NOTA LA");
                BP = 1;
            }
        }
        else if(!PORTFbits.RF6){ //SI
            if(!BP){
                Nota_SI();
                imprimeLCD("NOTA SI");
                BP = 1;
            }
        }
        else{
            BP = 0;
            PORTDbits.RD3 = 0;
            T1CONbits.TON = 0;
        }
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
    //Inicializamos interrupciones
    IFS0bits.INT0IF=0; //Reset INT0 interrupt flag
    IEC0bits.INT0IE=1;  //enable INT0 Interrupt Service Routine.
    IFS1bits.INT1IF=0; //Reset INT1 interrupt flag
    IEC1bits.INT1IE=1;  //enable INT1 Interrupt Service Routine.
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
    
    //Inicializamos puerto F
    PORTF=0;
    Nop();
    LATF=0;
    Nop();
    TRISF=0XFFFF;
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