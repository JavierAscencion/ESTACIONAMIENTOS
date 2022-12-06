/*
EL PROTOCOLO WIEGAN CONSISTE EN UN TRAMA DE 26 BITS ESTANDAR
CABLE VERDE DATA0 - SEND CERO LOGIC
CABLE WHITE DATA1 - SEND ONE LOGIC
PROCOLOLO WIEGAND
 -1 BIT DE PARIDAD PAR
 -8 BITS CODIGO DE FABRICA
 -16 BITS CODIGO DEL ID
 -1 BIT DE PARIDAD IMPAR
LOS BITS DE PARIDAD NOS SERVIRAN PARA VERIFICAR QUE EL DATO QUE ENVIA LA LECTORA
ES CORRECTO, LOS PRIMEROS 12 BITS SON PARIDAD PAR Y LOS ULTIMOS 12 BITS SON DE
PARIDAD IMPAR.
EL TIEMPO ENTRE SEPARACION DE PULSOS ES DE 2ms CON DURACION DE 50us

CARACTERISTICAS DE LA LECTORA
-LECTOR DE PROXIMIDAD DE 125Khz
-LECTOR DE TARJETAS RFID 26 BITS
-TECLADO WIEGAND 1 BYTE - DATA TOCUCH = NIBBLE_LOW, COMPLEMENTO = NIBBLE_HIHG

//CODIFICACION DEL TOUCH, COMPLEMENTO NIBBLE MAS ALTO
1 == 0xE1, 2 == 0xD2, 3 == 0xC3
4 == 0xB4, 5 == 0xA5, 6 == 0x96
7 == 0x87, 8 == 0x78, 9 == 0x69
* == 0x5A, 0 == 0xF0, # == 0x4B

NOTA: EXISTE LA POSIBILIDAD DE QUE UNA TARJETA SEA COMPATIBLE CON EL NIP
NOTA: LA LECTURA DEL LECTOR ES MENOR O IGUAL DE 300ms
*/
#ifndef _WIEGAND26_H
#define _WIEGAND26_H
#include "lib_external_int0.h"
#include "lib_external_int1.h"
#include "lib_timer2.h"

//VARIABLES CONSTANTES
const unsigned int WIEGAND_TIME_FRAME_RESET = 5000;  //TIEMPO PARA RESETEAR EL NIP
const unsigned int WIEGAND_TIME_FRAME_DELTA = 4500;  //TIEMPO PARA RESETAR POR OVERFLOW
const char WIEGAND_BITS_CARD = 26;
const char WIEGAND_BITS_NIP = 32;             //MAXIMO 32BITS
const char _WIEGAND26_PULSE_TIME_MAX_MS = 5;  //TIEMPO MAXIMO PARA ESPERAR OTRO PULSO

//VARIABLES
static unsigned long WIEGAN26_DATA;
static unsigned long WIEGAN26_BUFFER;
static char WIEGAN26_CONT;
volatile unsigned int WIEGAND_TEMP;

/************************** FUNCTION PROTOTYPE ********************************/
bool wiegand26_checkTouch(char bytes);
/******************************************************************************/
void wiegand26_open(){
  external_int0_open(false, false);        //No disponible, flanco de bajada
  external_int1_open(false, false, true);  //No disponible, flanco de bajada
  WIEGAN26_DATA = 0;
  WIEGAN26_CONT = 0;
  WIEGAND_TEMP = 0;
  //Configurar timer2 5ms
  timer2_open(5000, true, true, false);
}
/******************************************************************************/
bool wiegand26_read_card(long *id){
  char i, paridad;
  long aux;
  //Verificar que sea deteccion de tarjeta
  if(WIEGAN26_CONT == 26){
    delay_ms(_WIEGAND26_PULSE_TIME_MAX_MS);  //Para asegurar datos de 26 bits
    //Aseguro los datos de una tarjeta
    if(WIEGAN26_CONT != 26)
      return false;
    //RESPLADAR BUFFER
    WIEGAN26_BUFFER = WIEGAN26_DATA;
    aux = WIEGAN26_BUFFER;
    //RESETEAR BUFFERS
    WIEGAN26_CONT = 0;    //Resetear puntero
    WIEGAN26_DATA = 0;    //Resetear la informacion
    //Verificar que sea una cadena valida, paridad impar
    for(paridad = 0, i = 0; i < 13; i++){
      paridad += getByte(aux,0).B0;
      aux >>= 1;
    }
    //Si no se cumple la paridad impar
    if(paridad % 2 != 1)
      return false;
    //Verificar que sea una cadena valida, paridad par
    for(paridad = 0, i = 0; i < 13; i++){
      paridad += getByte(aux,0).B0;
      aux >>= 1;
    }
    //Si no se cumple la paridad par
    if(paridad % 2 != 0)
      return false;
    //OBTENER EL CODIGO COMPLETO DE LA CARD
    *id = WIEGAN26_BUFFER;
    *id >>= 1;              //Se recorre a la derecha, quitar bit paridad imparidad
    getByte(*id, 3) = 0x00; //Quitamos el bit de paridad par
    return true;
  }
  
  return false;
}
/******************************************************************************/
bool wiegand26_read_nip(int *nip){
  short i;
  //Permite la lectura de 4 teclas
  if(WIEGAN26_CONT == 32){
    delay_ms(_WIEGAND26_PULSE_TIME_MAX_MS);  //Para asegurar datos de 26 bits
    //Aseguro los datos de una tarjeta
    if(WIEGAN26_CONT != 32)
      return false;

    //RESPLADAR BUFFER
    WIEGAN26_BUFFER = WIEGAN26_DATA;
    //RESETEAR BUFFERS
    WIEGAN26_CONT = 0;    //Resetear puntero
    WIEGAN26_DATA = 0;    //Resetear la informacion
    
    //VALIDAR QUE SEAN TECLAS, MAXIMO 4 TECLAS POR VARIABLE LONG
    if(!wiegand26_checkTouch(4))
      return false;
    //VALIDAR QUE NO SEAN SIMBOLOS RAROS "*" y "#"
    for(i = 0; i < 4; i++){
      getByte(WIEGAN26_BUFFER,i) &= 0x0F;
      if(getByte(WIEGAN26_BUFFER,i) == 0x0A || getByte(WIEGAN26_BUFFER,i) == 0x0B)
        return false;
    }
    //DECODIFICAR EL DATO
    *nip = 0;
    for(i = 3; i >= 0; i--){
      *nip *= 10;
      *nip += getByte(WIEGAN26_BUFFER,i);
    }
    return true;
  }

  return false;
}
/******************************************************************************/
void wiegand26_enable(){
  external_int0_enable(true);
  external_int1_enable(true);
}
/******************************************************************************/
bool wiegand26_checkTouch(char bytes){
  char i;
  volatile char nibleH, nibleL;

  //VERIFICAR EL CONTENIDO
  for(i = 0; i < bytes; i++){
    nibleL = ~getByte(WIEGAN26_BUFFER,i);
    nibleL &= 0x0F;
    nibleH = swap(getByte(WIEGAN26_BUFFER,i));
    nibleH &= 0x0F;
    //Se detecto que no es comando
    if(nibleH != nibleL)
      break;
  }
  
  //SI TODOS LOS BYTES COMPARADOS FUERON IGUALES, FUE TECLA DEL TOUCH
  if(i == bytes)
    return true;
  else
    return false;
}
/******************************************************************************/
void int_wiegand26(){
  int_external_int0();
  int_external_int1();
}
/******************************************************************************/
void int_external_int0(){
  if(INTCON.INT0IF && INTCON.INT0IE){
    WIEGAN26_CONT++;
    WIEGAN26_DATA <<= 1;
    WIEGAN26_DATA |= 0;
    //PROTECCION CONTRA OVERFLOW
    WIEGAND_TEMP = 0;
    if(WIEGAN26_CONT > WIEGAND_BITS_NIP)
      WIEGAND_TEMP = WIEGAND_TIME_FRAME_DELTA;
    INTCON.INT0IF = 0;
  }
}
/******************************************************************************/
void int_external_int1(){
  if(INTCON3.INT1IF && INTCON3.INT1IE){
    WIEGAN26_CONT++;
    WIEGAN26_DATA <<= 1;
    WIEGAN26_DATA |= 1;
    //PROTECCION CONTRA OVERFLOW
    WIEGAND_TEMP = 0;
    if(WIEGAN26_CONT > WIEGAND_BITS_NIP)
      WIEGAND_TEMP = WIEGAND_TIME_FRAME_DELTA;
    INTCON3.INT1IF = 0;
  }
}
/******************************************************************************/
void int_timer2(){
  if(PIR1.TMR2IF && PIE1.TMR2IE){
    //UN SEGUNDO
    WIEGAND_TEMP += 5;  //Cada 5ms
    if(WIEGAND_TEMP >= WIEGAND_TIME_FRAME_RESET){
      WIEGAND_TEMP = 0;
      
      if(WIEGAN26_CONT){
        if(!(WIEGAN26_CONT == WIEGAND_BITS_CARD || WIEGAN26_CONT == WIEGAND_BITS_NIP)){
          WIEGAN26_CONT = 0;
          WIEGAN26_DATA = 0;
        }
      }
    }
    //FINALIZAR INTERRUPCION
    PIR1.TMR2IF = 0;   //LIMPÍAR BANDERA
  }
}
/******************************************************************************/
#endif