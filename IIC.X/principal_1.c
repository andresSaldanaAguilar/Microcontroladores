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
#define NANCK 0
#define EXITO 1
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

void RETARDO_1S( void );
void START_I2C(void);
void STOP_I2C(void);
void ACK_I2C(void);
void NACK_I2C(void);
void ENVIA_DATO_I2C( unsigned int );
unsigned int RECIBE_DATO_I2C( void );
void enviaUART(unsigned char dato);
int recieverRTCC( void );
int transmitterRTCC( void );
//Variables

int main (void)
{
    iniPerifericos();
    
    //UART BAUDIOS:19200
    U1BRG = 5; // (1.8432*10^6)/(16*19200) = 5
    U1MODE = 0X0420;
    U1STA = 0X8000;
    
    /*TODO: checar funciones de envio y recepcion, inicializacion de SDA y SCL*/
      
    //Habilitacion de perifericos
    U1MODEbits.UARTEN = 1;
    U1STAbits.UTXEN = 1;
    
    U1TXREG = 'H';
    U1TXREG ='O'; 
    U1TXREG ='L';
    U1TXREG ='A';
    /*
    //Metodos
    int val = recieverRTCC();
    if (val == 0){
        enviaUART(0x00);
    }
    transmitterRTCC();
    */
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
    PORTF = 0;
    Nop();
    LATF = 0;
    Nop();
   
    //SCL
    TRISFbits.TRISF3 = 0;
    Nop();
    //SDA
    TRISFbits.TRISF2 = 0;
    Nop();
    
    //UART
    PORTC = 0;
    Nop();
    LATC = 0;
    Nop();
    TRISCbits.TRISC13 = 0;
    Nop();
    TRISCbits.TRISC14 = 1;
    Nop();
    
    ADPCFG = 0XFFFF;
    
}    

int recieverRTCC()
{
    START_I2C();
    ENVIA_DATO_I2C(0XD0);
    if(I2CSTATbits.ACKSTAT == 1)
        return NANCK;
    ENVIA_DATO_I2C(0X00);
    if(I2CSTATbits.ACKSTAT == 1)
        return NANCK;
    ENVIA_DATO_I2C(0X17);
    if(I2CSTATbits.ACKSTAT == 1)
        return NANCK;
    ENVIA_DATO_I2C(0X15);
    if(I2CSTATbits.ACKSTAT == 1)
        return NANCK;
    ENVIA_DATO_I2C(0X13);
    if(I2CSTATbits.ACKSTAT == 1)
        return NANCK;
    ENVIA_DATO_I2C(0X02);
    if(I2CSTATbits.ACKSTAT == 1)
        return NANCK;
    ENVIA_DATO_I2C(0X18);
    if(I2CSTATbits.ACKSTAT == 1)
        return NANCK;
    ENVIA_DATO_I2C(0X06);
    if(I2CSTATbits.ACKSTAT == 1)
        return NANCK;
    ENVIA_DATO_I2C(0X18);
    if(I2CSTATbits.ACKSTAT == 1)
        return NANCK;
    ENVIA_DATO_I2C(0X10);    
    if(I2CSTATbits.ACKSTAT == 1)
        return NANCK;
    STOP_I2C();
    return EXITO; 
}

int transmitterRTCC()
{
    unsigned char datoLeido;
    START_I2C();
    ENVIA_DATO_I2C(0XD1);
    if(I2CSTATbits.ACKSTAT == 1)
        return NANCK;

    /**Recibir n datos**/
    int i;
    for(i = 0 ; i < 7 ; i++){
        datoLeido = RECIBE_DATO_I2C();
        if ( i!= 6){
            ACK_I2C();
        }else{
            NACK_I2C();
        }
        enviaUART(datoLeido);
    }
   
    
    STOP_I2C();
    return EXITO; 
}

void enviaUART(unsigned char dato){
    U1TXREG = dato;
}
