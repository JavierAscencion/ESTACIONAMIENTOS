#ifndef _IMPRESORA_TERM_H
#define _IMPRESORA_TERM_H
#include "miscelaneos.h"

//CONSTANTES
const char IMPT_IMPRIME[] = {10, 0};    //IMPRIME TEXTO EN BUFFER CON SALTO DE LINEA
const char IMPT_IMPRIME_CR[] = {13, 0}; //IMPRIME CON RETORNO CON CARRO
const char IMPT_ESTADO[] = {16, 4, 0};  //ESTADO DE LA IMPRESORA CON n[0-4], *FUNCTION
//PROGRAMA: BAUDIOS, PARIDAD, PROTOCOLO, CORTE, DENSIDAD IMPRESION, CARRIE, SENSOR PAPEL, *FUNCTION
const char IMPT_PROG[] = {19, 27, 28, 29, 0}; //PROGRAMACION DE LA IMPRESORA DATOS VOLATILES
//GUARDA INTERLINEADO, INTER-CARACTER, FUENTE DE CARACTER, ANCHO Y ALTO CARACTER
const char IMPT_SAVE_PROG[] = {27, 18, 29, 7, 0};     //PARAMETROS PROGRAMADOS
const char IMPT_SAVE_DEFAULT[] = {27, 19, 29, 8, 0};  //PARAMETROS DE FABRICA
const char IMPT_ESP_CHAR[] = {27, 32, 0};     //ESPACIADO ENTRE CARACTERES n[0-255]
const char IMPT_MODO[] = {27, 33, 0};         //MODO DE IMPRESION, ***
const char IMPT_MODO_SUB[] = {27, 45, 0};     //MODO SUBRAYADO, n[0-2 || 48-50]
const char IMPT_ESP_DEFAULT[] = {27, 50, 0};//ESPACIADO ENTRE LINEAS DE 4.25mm
const char IMPT_ESP_PROG[] = {27, 51, 0};   //ESPACIADO ENTRE LINEAS n[0-255], MAX 1016mm
const char IMPT_INIT[] = {27, 64, 0};       //BORRA BUFER Y RESETEA AJUSTES DE IMPRESION
const char IMPT_NEGRITA[] = {27, 69, 0};    //ACTIVA O DESACTIVA LA LETRA NEGRITA n[0,1]
const char IMPT_REVERSO[] = {27, 73, 0};    //ACTIVA O DESACTIVA EL MODO REVERSO n[0,1]
const char IMPT_IMPRIME_XL[] = {27, 74, 0}; //IMPRIME Y AVANZA EL PAPEL X*n[0-255]
const char IMPT_FUENTE[] = {27, 77, 0};     //FUENTE A OR B n[0,1 || 48,49]
const char IMPT_ROTATE[] = {27, 86, 0};     //ROTACION DE LOS CARACTERES NORMAL, 90°, -90°, n[0-2 || 48-50]
const char IMPT_JUST[] = {27, 97, 0};       //JUSTIFICACION IZQ,CENT,DER n[0-2 || 48-50]
const char IMPT_SPAPEL[] = {27, 99, 52, 0}; //ACTIVA SENSOR DE PARAR IMPRESION SI HAY POCO PAPEL n[0,255] ***
const char IMPT_BPANEL[] = {27, 99, 53, 0}; //ACTIVA O DESACTIVA BOTONES DEL PANEL DE LA IMPRESORA n[0,1]
const char IMPT_IMPRIME_NL[] = {27, 100, 0};//IMPRIME Y AVANZA N LINEAS DE CARACTERES n[0-255]
const char IMPT_CORTE_T[] = {27, 105, 0};   //CORTE TOTAL DEL PAPEL, CADA DOS SEGUNDOS COMANDO
const char IMPT_CORTE_P[] = {27, 109, 0};   //CORTE PARCIAL DEL PAPEL, CADA 2s
const char IMPT_CAJON_MON[] = {27, 112, 0}; //CAJON MONEDERO, CABLE RJ, m[0-1,48-49], 2ms*(t1,t2[0-255])
const char IMPT_FUENTE2[] = {27, 116, 0};   //FUENTE A y B INTERNAS O CARGADAS [INT,CAR-INT,INT-CAR, CAR-CAR] n[0-3]
const char IMPT_MODO_INV[] = {27, 123, 0};  //ACTIVA O DESACTIVA LA IMPRESION INVERSA, VISTA DE SALIDA, n[0,1]
const char IMPT_SIZE_CHAR[] = {29, 33, 0};  //ALTURA POR ANCHO DEL CARACTER n = swap[0-7, 0-7]
const char IMPT_TEST[] = {29, 40, 65, 0};   //TEST DE IMPRESION ***
const char IMPT_LOGO[] = {29, 40, 67, 0};   //BORRA LOGOTIPOS GUARDADOS MEMORIA VOLATIL ***
const char IMPT_MODO_BN[] = {29, 66, 0};    //ACTIVACION Y DESACTIVACION DEL MODO INVERSO BLANCO Y NEGRO n[0,1]
const char IMPT_COD_BAR_POS[] = {29, 72, 0};//POSICION CODIGO DE BARRAS, [NO IMPRIMIR, ENCIMA, ABAJO, ENCIMA&DEBAJO], n[0-3]
const char IMPT_FIRMWARE[] = {29, 73, 0x33, 0};  //FIRMWARE DEL DISPOSITIVO, ***
const char IMPT_MARGEN_IZQ[] = {29, 76, 0}; //ESTABLECE EL MARGEN IZQUIERDO DE IMPRESION [(nL+ nH x 256) x 0.125 mm]
const char IMPT_COD_AZTEC[] = {29, 80, 0};  //CODIGO AZTEC n = NL + 256*NH, NCARACTERES ***
const char IMPT_COD_QR[] = {29, 81, 0};     //CODIGO QR n = NL + 256*NH, NCARACTERES
const char IMPT_CORTE_POS[] = {29, 86, 0};  //POSICION DEL CORTE
const char IMPT_REPORTE[] = {29, 97, 0};    //HABILITA O DESHABILITA REPORTE AUTOMATICO IMPRESORA, n[0-1,48,49]
const char IMPT_COD_BAR_F[] = {29, 102, 0}; //FUENTE PARA EL CODIGO DE BARRAS A OR B n[0-1, 48,49]
const char IMPT_COD_BAR_V[] = {29, 104, 0}; //ALTURA DEL CODIGO DE BARRAS, n[1-255], nDEFAULT = 185
const char IMPT_COD_BAR_C[] = {29, 107, 0}; //CODIGO DE BARRAS IMPRIMIBLE NCARACTERES[1-255]
const char IMPT_COD_BAR_H[] = {29, 119, 0}; //ANGOSTO DEL CODIGO DE BARRAS n[2-6]
//CHECAR TODOS LOS COMANDOS PARA BIT MAPS O IMAGENES, Y NUMERO DE SERIES
//const char IMPT_COD_BITS = {29, 118, 48, 0};   //IMPRIME IMAGEN ***

//RANGO DE LOS REGISTROS
const char FONTA = 0x00;
const char FONTB = 0x01;
const char JUST_LEFT = 0;
const char JUST_CENTER = 1;
const char JUST_RIGHT = 2;
const char COD_BARRAS_POS_HIDDEN = 0;
const char COD_BARRAS_POS_ON = 1;
const char COD_BARRAS_POS_UNDER = 2;
const char COD_BARRAS_POS_BOTH = 3;

const char COD_BARRAS_NUMERICO = 69;   //CODE39
const char COD_BARRAS_ALPHANUM = 73;   //CODE128, CONVIENE EL FORMATO B
const char CUT_POS_ACT = 49;           //CORTA EN LA POSICION ACTUAL
const char CUT_POS_OFFSET = 66;        //CORTE PARCIAL CON OFFSET
//VALOR DE LOS REGISTROS POR DEFECTO
//const char INTERLINEADO_DEFAULT = 40;

//COMANDOS PARA ESCRIBIR TEXTO DINAMICO
const char CMD_IMPRESORA = 0x02;      //ESCRIBE N COMANDOS HACIA LA IMPRESORA
const char CMD_CODIGO_BARRAS = 0x03;  //PARA ESCRIBIR EL CODIGO DE BARRAS
const char CMD_WRITE_BYTE = 0x04;     //ESCRIBE UN BYTE EN UART
const char CMD_TEXT_DINAMIC = 0x05;   //PARA BUSCAR TEXTO DINAMICO


//VARIABLES
//Nota esta variable la uso para la funcion xtoi dinamic text, warning
static char buffer[5];    //Para lo comandos de la impresora


/************************** FUNCTION PROTOTYPE ********************************/


/******************************************************************************/
void impresoraTerm_cmd(const char *comando){
  char cont = 0;
  
  //Mandar comando sin final de cadena
  RomToRam(comando,buffer);
  while(buffer[cont])
    usart_write(buffer[cont++]);
}
/******************************************************************************/
void impresoraTerm_cmd2(const char *comando, char valor){
  char cont = 0;
  //Mandar comando sin final de cadena
  RomToRam(comando,buffer);
  while(buffer[cont])
    usart_write(buffer[cont++]);
  //VALOR FINAL DEL COMANDO
  usart_write(valor);
}
/******************************************************************************/
void impresoraTerm_open(bool typeFont, char interlineado){
  //Inizaliza la impresora, limpia buffer y resetea comandos
  impresoraTerm_cmd(IMPT_INIT);
  //Fuente tipo A, no negrita, no subrayado, simple ancho y alto
  impresoraTerm_cmd2(IMPT_MODO, typeFont);
  //Interlineado
  impresoraTerm_cmd2(IMPT_ESP_PROG, interlineado); //Espaciado
  //Justificacion
  impresoraTerm_cmd2(IMPT_JUST, JUST_LEFT);        //Izquierda
  //Tamaño de la letra por defecto
  impresoraTerm_cmd2(IMPT_SIZE_CHAR, 0x33);        //Tamño 3x3 points
}
/******************************************************************************/
void impresoraTerm_formato(char size, char just, bool negrita){
  //Tamaño de la letra por defecto
  impresoraTerm_cmd2(IMPT_SIZE_CHAR, size);
  //Justificacion
  impresoraTerm_cmd2(IMPT_JUST, just);
  //Justificacion
  impresoraTerm_cmd2(IMPT_NEGRITA, negrita);
}
/******************************************************************************/
void impresoraTerm_writeLine(char *texto){
  char cont = 0;
  
  //Lineas de 255 caracteres
  while(texto[cont])
    usart_write(texto[cont++]);

  impresoraTerm_cmd(IMPT_IMPRIME);
}
/******************************************************************************/
bool impresoraTerm_writeTextStatic(const char *texto, char rateBytes){
  static unsigned int cont = 0;  //Guarda la posicion

  //Salto de linea o final de cadena
  while(texto[cont] && rateBytes--){
    usart_write(texto[cont]);
    
    if(texto[cont] == '\n'){
      cont++;
      break;
    }
    cont++;  //Siguiente posicion
  }
  
  if(!texto[cont]){
    cont = 0;
    return true; //Finalizo de imprimir
  }
  
  return false;  //No ha terminado de imprimir
}
/******************************************************************************/
void impresoraTerm_writeDinamicText(char *texto, const int *address){
  char ADRR_ERROR[] = "#ERR_ADDR#";  //Optimizar esta variable
  char cont = 0, cont2, comandos;
  char *ticketPointer;
  int dir;

  //Salto de linea o final de cadena
  while(texto[cont]){
    if(texto[cont] == CMD_IMPRESORA){  //ENVIA N CARACTERES DE COMANDOS HACIA LA IMPRESORA
      //OBTENER DOS CARACTERES PARA ESCRIBIR N COMANDOS
      cont++;
      for(cont2 = 0; cont2 < 2 && texto[cont]; cont2++)
        buffer[cont2] = texto[cont++];
      buffer[cont2] = 0; //Fin de cadena
      
      //MANDO COMANDOS HACIA LA IMPRESORA
      comandos = atoi(buffer);
      while(comandos--){
        //Convertir el hexadeciaml en numero
        for(cont2 = 0; cont2 < 2 && texto[cont]; cont2++)
          buffer[cont2] = texto[cont++];
        buffer[cont2] = 0; //Fin de cadena
        cont2 = xtoi(buffer);
        usart_write(cont2);
      }
      //Omitir salto de linea
      if(texto[cont] == '\n')
        cont++; //Por el final de cadena
    }else if(texto[cont] == CMD_CODIGO_BARRAS || texto[cont] == CMD_TEXT_DINAMIC){  //Comando para escribir variables dinamicas
      //Reutilizar variable
      comandos = texto[cont];
      
      //Apunto a un error de address por defecto
      ticketPointer = ADRR_ERROR;
      //Obtener cuatro bytes del puntero variable, formato hex
      cont++;
      for(cont2 = 0; cont2 < 4 && texto[cont]; cont2++)
        buffer[cont2] = texto[cont++];
      buffer[cont2] = 0; //Fin de cadena
      //Copiar direccion
      dir = xtoi(buffer);
      
      //Verificamos si la direccion es valida
      cont2 = 0;
      while(address[cont2]){
        if(dir == address[cont2++]){
          //Copiar puntero
          getByte(ticketPointer, 0) = getByte(dir, 0);
          getByte(ticketPointer, 1) = getByte(dir, 1);
          break;
        }
      }
      
      //Si es comando de codigo de barras
      if(comandos == CMD_CODIGO_BARRAS)
        usart_write(strlen(ticketPointer));
      
      //Imprimo el valor del puntero variable
      cont2 = 0;
      while(ticketPointer[cont2])
         usart_write(ticketPointer[cont2++]);
    }else if(texto[cont] == CMD_WRITE_BYTE){  //Modo beta
      //OBTIENE EL OFFSET DE LA IMPRESORA
      cont++;
      for(cont2 = 0; cont2 < 2 && texto[cont]; cont2++)
        buffer[cont2] = texto[cont++];
      buffer[cont2] = 0; //Fin de cadena

      //MANDO COMANDOS HACIA LA IMPRESORA, DISTANCIA DE CORTE
      cont2 = xtoi(buffer);
      usart_write(cont2);

      //Omitir final de cadena
      if(texto[cont])
        cont++; //Por el final de cadena
    }else{  //Caracter normal
      //Imprimir valor dinamico
      usart_write(texto[cont++]);
    }
  }
}
/******************************************************************************/
void impresoraTerm_codBarNum(char *codigo, char format, char altura, char ancho){
  impresoraTerm_cmd2(IMPT_COD_BAR_POS, format);  //Mostrar codigo de barras
  impresoraTerm_cmd2(IMPT_COD_BAR_V, altura);    //Altura del codigo de barras 1-255
  impresoraTerm_cmd2(IMPT_COD_BAR_H, ancho);     //Ancho codigo de barras 2-6
  //Imprimir codigo de barras, longitud y caracteres
  impresoraTerm_cmd2(IMPT_COD_BAR_C, COD_BARRAS_NUMERICO);
  usart_write(strlen(codigo));
  usart_write_text(codigo);
}
/******************************************************************************/
void impresoraTerm_corte(bool cutPartial, char offset){
  impresoraTerm_cmd2(IMPT_CORTE_POS, offset? CUT_POS_OFFSET: CUT_POS_ACT);
  //Envia offset si es necesario
  if(offset)
    usart_write(offset);
  //Realizar corte segun el tipo de corte
  //impresoraTerm_cmd(cutPartial? IMPT_CORTE_P:IMPT_CORTE_T);
}
/******************************************************************************/
#endif