#ifndef _LIB_USART_H
#define _LIB_USART_H
#include "string.h"
/*
1) PUEDE CALCULAR DINAMICAMENTE LOS DATOS DE LOS BAUDIOS
2) PUEDE MANDAR DATOS Y RECIBIR DATOS POR INTERRUPCION
3) SE REQUIERE LLAMAR CONSTATEMENTE LA FUNCION usart_do_read_text PARA PROCESAR
   LA INOFMRACION LOS MAS RAPIDO POSIBLE, PORQUE NO ACEPTARA MAS INFORMACION
   HASTA QUE SEA PROCESADA EN BUFFER LO QUE PRODUCIRIA PERDIDA DE DATOS
*/

//CONSTANTES
const char UART_BUFFER_SIZE = 32;  //DEBE SER POTENCIA DE DOS

//Objeto usart
struct MODULE_USART{
  //Variables de usuario
  volatile char message[UART_BUFFER_SIZE];   //Buffer del mensaje recepcionado
  //Variables privadas receptor
  char rx_delimiter;                         //Delimitador del final del texto
  volatile bool rx_new_message;              //Si hay nuevo mensaje recepcionado
  volatile bool rx_overflow;                 //Si hubo sobreflujo en los datos
  volatile char rx_cont;                     //Puntero de escritura
  //Variables privadas transceptor
  volatile bool tx_free;                     //Puede enviar nuevo paquete
  volatile char tx_cont;                     //Quien apunta a otro dato
  char tx_buffer[UART_BUFFER_SIZE];          //Para enviar en su buffer
}usart;

//Constantes
const char USART_NEW_LINE[] = "\r\n";

/************************** FUNCTION PROTOTYPE ********************************/
void usart_user_read_text();


/******************************** FUNCTIONS ***********************************/
void usart_open(unsigned long baudRate){
  //CONFIGURACION EN MODO ASYNCHRONO
  TXSTA.CSRC = 0;   //NO IMPORTA, MODO ASYNCHRONO
  TXSTA.TX9 = 0;    //MODO 8 BITS DE TRANSMISION
  TXSTA.TXEN = 1;   //DISPONIBLE TX
  TXSTA.SYNC = 0;   //MODO ASYNCHRONO
  TXSTA.SENDB = 0;  //ENVIAR ROTURA DE TRANSMISION COMPLETADA ***
  TXSTA.BRGH = 1;   //0 - LOW SPEED, 1 - HIHG SPEED
  //TXSTA.TRMT      //CONTIENE SI EL BUFFER ESTA VACIO
  TXSTA.TX9D = 0;   //BIT DE PARIDAD
  
  //REGISTRO RX
  RCSTA.RX9 = 0;    //MODO 8 BITS RECEPCION
  RCSTA.SREN = 0;   //NO IMPORTA, MODO ASYNCHRONO
  RCSTA.CREN = 1;   //DISPONIBLE RX
  RCSTA.ADDEN = 0;  //DISABLE INTERRUPT POR RECIBIR EL 9BIT
  RCSTA.SPEN = 1;   //CONFIGURA PINES RX AND TX COMO SERIALES
  //RCSTA.FERR      //ERROR POR ENCUADRE
  //RCSTA.OERR      //ERROR POR DESBORDAMIENTO
  //RCSTA.RX9D      //NOVENO BIT DE RECEPCION
  
  //BAUDCON.ABDOVF; //BRG SE REINICIA POR EL MODO AUTO DETECCION DE LOS BAUDIOS
  //BAUDCON.RCIDL;  //MODO IDLE ACTIVO
  BAUDCON.SCKP = 0; //NO IMPORTA, MODO ASYNCHRONOS
  BAUDCON.BRG16 = 1;//MODO 16 BITS
  BAUDCON.WUE = 0;  //PIN RX NO ES MONITORIADO EN FLANCO DE BAJADA***
  BAUDCON.ABDEN = 0;//DISABLE MODO MEDICION DE BAUDIOS***
  
  //FORMULA BAUDIOS = FOSC/(i*(SFR+1)), i = [4,16,64], SFR = [SPBRG SPBRGH]
  //LOS BAUDIOS MAS PROMIXOS LO DA SFR = round(FOSC/(4*Baudios)-1))
  baudRate >>= 1;                           //Divido sobre dos
  baudRate = (Clock_MHz()*250e3)/baudRate;  //Fosc/(Baudios/2)
  baudRate += 1;                            //Sumar uno por compute round
  baudRate >>= 1;                           //Divido sobre dos
  baudRate -= 1;                            //Resto -1, formula
  SPBRG = getByte(baudRate,0);
  SPBRGH = getByte(baudRate,1);
  
  //CONFIGURAR PINES
  TRISC.B6 = 0;   //TX
  TRISC.B7 = 1;   //RX
  
  //Libera el buffer
  while(!TXSTA.TRMT);
}
/******************************************************************************/
bool usart_read(char *result){
  if(PIR1.RCIF){
    *result = RCREG;
    PIR1.RCIF = 0;
    return true;
  }
  
  return false;
}
/******************************************************************************/
void usart_write(char caracter){
  TXREG = caracter;
  while(!TXSTA.TRMT);  //Esperar a que el buffer se vacie
}
/******************************************************************************/
void usart_write_text(char *texto){
 char cont = 0;
 //SOLO SE ENVIA LOS DATOS SIN EL FINAL DE CADENA
 while(texto[cont]){
   TXREG = texto[cont++];
   while(!TXSTA.TRMT);    //Esperar a que el buffer se vacie en evnvio
 }
}
/******************************************************************************/
void usart_write_textConst(const char *texto){
 char cont = 0;
 //SOLO SE ENVIA LOS DATOS SIN EL FINAL DE CADENA
 while(texto[cont]){
   TXREG = texto[cont++];
   while(!TXSTA.TRMT);    //Esperar a que el buffer se vacie en evnvio
 }
}
/******************************************************************************/
void usart_write_line(char *texto){
 char cont = 0;
 //SOLO SE ENVIA LOS DATOS SIN EL FINAL DE CADENA
 while(texto[cont]){
   TXREG = texto[cont++];
   while(!TXSTA.TRMT);    //Esperar a que el buffer se vacie en evnvio
 }
 //Enviar retorno y salto de linea
 TXREG = USART_NEW_LINE[0];
 while(!TXSTA.TRMT);    //Esperar a que el buffer se vacie en evnvio
 TXREG = USART_NEW_LINE[1];
 while(!TXSTA.TRMT);    //Esperar a que el buffer se vacie en evnvio
}
/******************************************************************************/
void usart_write_lineConst(const char *texto){
 char cont = 0;
 //SOLO SE ENVIA LOS DATOS SIN EL FINAL DE CADENA
 while(texto[cont]){
   TXREG = texto[cont++];
   while(!TXSTA.TRMT);    //Esperar a que el buffer se vacie en evnvio
 }
 //Enviar retorno y salto de linea
 TXREG = USART_NEW_LINE[0];
 while(!TXSTA.TRMT);    //Esperar a que el buffer se vacie en evnvio
 TXREG = USART_NEW_LINE[1];
 while(!TXSTA.TRMT);    //Esperar a que el buffer se vacie en evnvio
}
/******************************************************************************/
void usart_enable_rx(bool enable, bool priorityHigh, char delimitir){
  //Resetear variables
  usart.rx_cont = 0;  //POSICION INICIAL
  usart.rx_delimiter = delimitir;
  usart.rx_new_message = false;
  usart.rx_overflow = false;

  //INTERRUPCION RX
  IPR1.RCIP = priorityHigh;
  PIR1.RCIF = 0;
  PIE1.RCIE = enable;
}
/******************************************************************************/
void usart_enable_tx(bool priorityHigh){
  //Resetear variables
  usart.tx_free = true;
  usart.tx_cont = 0;  //POSICION INICIAL

  //INTERRUPCION RX
  IPR1.TXIP = priorityHigh;
  PIR1.TXIF = 0;
  PIE1.TXIE = 0;
}
/******************************************************************************/
void usart_do_read_text(){
  //Hasta que se procese la informacion puedo recibir nuevo mensaje
  if(usart.rx_new_message){
    usart_user_read_text();
    usart.rx_new_message = false;
  }
}
/******************************************************************************/
bool usart_write_text_int(char *texto){
  //Enviar texto si esta libre termino el ultimo envio y esta vacio el buffer
  if(usart.tx_free && TXSTA.TRMT){
    usart.tx_free = false;
    //Copiar el contenido en buffer, para evitar sobreescritura
    string_cpyn(usart.tx_buffer, texto, UART_BUFFER_SIZE-1);
    usart.tx_cont = 0;  //POSICION INICIAL
    PIE1.TXIE = 1;
    return true;
  }
  
  return false;
}
/******************************************************************************/
void int_usart_rx(void){
  if(PIE1.RCIE && PIR1.RCIF){
    if(!usart.rx_new_message.B0){
      //Apuntar al siguiente dato
      usart.message[usart.rx_cont] = RCREG;
      //Se recibio mensaje
      if(RCREG == usart.rx_delimiter){
        //Evita la sobreescritura, si no se lee rapidamente se perderan datos
        usart.rx_new_message.B0 = true;
        usart.message[usart.rx_cont] = 0;  //Se le agrega final de cadena
        //Tamaño del buffer para ser reseteado
        usart.rx_cont = 0;
        PIR1.RCIF = 0;
        return;
      }
      usart.rx_cont++;
      usart.rx_cont &= (UART_BUFFER_SIZE-1);
      //Calcula si hay sobreflujo en la transmision normal
      usart.rx_overflow.B0 |= !usart.rx_cont? true:false;
    }else{
      RCREG &= 0xFF;  //Realizar and para evitar framing error, *#*
    }
    PIR1.RCIF = 0;
  }
}
/******************************************************************************/
void int_usart_tx(){
  if(PIE1.TXIE && PIR1.TXIF){
    TXREG = usart.tx_buffer[usart.tx_cont++];  //Envia los datos
    //Si es final de cadena finaliza transmision
    if(!usart.tx_buffer[usart.tx_cont]){
      usart.tx_free = true;
      PIE1.TXIE = 0; //Finaliza transmision
    }
    PIR1.TXIF = 0;   //Limpia bandera
  }
}
/******************************************************************************/
/*
CODIGO BETA
    //Apuntar al siguiente dato
    usart.rx_buffer[usart.rx_cont] = RCREG;
    //Se recibio mensaje
    if(RCREG == usart.rx_delimiter){
      //Evita la sobreescritura, si no se lee rapidamente se perderan datos
      if(!usart.rx_new_message.B0){
        usart.rx_new_message.B0 = true;
        usart.message[usart.rx_cont] = 0;  //Se le agrega final de cadena
        while(usart.rx_cont--)
          usart.message[usart.rx_cont] = usart.rx_buffer[usart.rx_cont];
      }
      //Tamaño del buffer para ser reseteado
      usart.rx_cont = 0;
      PIR1.RCIF = 0;
      return;
    }
    usart.rx_cont++;
    usart.rx_cont &= (UART_BUFFER_SIZE-1);
    usart.rx_overflow.B0 |= !usart.rx_cont? true:false; //Con esto sabe si hubo sobreflujo
    PIR1.RCIF = 0;
*/
#endif