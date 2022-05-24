#ifndef _STRING_H
#define _STRING_H
#include "miscelaneos.h"

/******************************************************************************/
char string_push(char *texto, char caracter){
  char cont = 0;
  //Encuentra fin de cadena
  while(texto[cont])
    cont++;
  
  texto[cont++] = caracter;
  texto[cont] = 0;  //Agregar final de cadena
  //Devuelve el tamaño del string
  return cont;
}
/******************************************************************************/
char string_pop(char *texto){
  char cont = 0, result;
  
  //Encuentra fin de cadena
  while(texto[cont])
    cont++;
  //Retornar vacio
  if(cont == 0)
    return cont;
  //Popear
  result = texto[--cont];
  texto[cont] = 0;  //Agregar final de cadena
  
  //Devuelve el caracter popeado
  return result;
}
/******************************************************************************/
char string_add(char *destino, char *addEnd){
  char total = 0, cont = 0;
  
  //Buscar final de cadena
  while(destino[total])
    total++;
  //Copiar los elementos al final
  while(addEnd[cont])
    destino[total++] = addEnd[cont++];
  destino[total] = 0;
  
  //Retorna el tamaño final de la cadena
  return total;
}
/******************************************************************************/
char string_addc(char *destino, const char *addEnd){
  char total = 0, cont = 0;

  //Buscar final de cadena
  while(destino[total])
    total++;
  //Copiar los elementos al final
  while(addEnd[cont])
    destino[total++] = addEnd[cont++];
  destino[total] = 0;

  //Retorna el tamaño final de la cadena
  return total;
}
/******************************************************************************/
char string_cpy(char *destino, char *origen){
  char cont = 0;

  while(origen[cont])
    destino[cont] = origen[cont++];
  destino[cont] = 0;              //Final de cadena
  
  //Retorna el peso copiado
  return cont;
}
/******************************************************************************/
char string_cpyn(char *destino, char *origen, char size){
  char cont;
  
  for(cont = 0; cont < size && origen[cont]; cont++)
    destino[cont] = origen[cont];
  destino[cont] = 0;              //Final de cadena
  
  return cont;
}
/******************************************************************************/
char string_cpyc(char *destino, const char *origen){
  char cont = 0;

  while(origen[cont])
    destino[cont] = origen[cont++];
  destino[cont] = 0;              //Final de cadena

  return cont;
}
/******************************************************************************/
char string_len(char *texto){
  char cont = 0;
  while(texto[cont])
    cont++;
  //Devuelve el tamaño del string
  return cont;
}
/******************************************************************************/
bool string_cmp(char *text1, char *text2){
  char cont = 0;

  while(true){
    if(text1[cont] != text2[cont])
      return false;
    else if(text1[cont] == 0 || text2[cont] == 0)
      break;
    else
      cont++;
  }
  
  return true;
}
/******************************************************************************/
bool string_cmpc(const char *text1, char *text2){
  char cont = 0;

  while(true){
    if(text1[cont] != text2[cont])
      return false;
    else if(text1[cont] == 0 || text2[cont] == 0)
      break;
    else
      cont++;
  }

  return true;
}
/******************************************************************************/
bool string_cmpn(char *text1, char *text2, char bytes){
  char cont;

  for(cont = 0; cont < bytes; cont++){
    if(text1[cont] != text2[cont])
      return false;
  }

  return true;
}
/******************************************************************************/
bool string_cmpnc(const char *text1, char *text2, char bytes){
  char cont;
  
  for(cont = 0; cont < bytes; cont++){
    if(text1[cont] != text2[cont])
      return false;
  }
  
  return true;
}
/******************************************************************************/
bool string_isNumeric(char *cadena){
  char cont = 0;
  
  while(cadena[cont] != 0){
    if(cadena[cont] < '0' || cadena[cont] > '9')
      return false;
    cont++;
  }
  //Si hay datos
  if(cont != 0)
    return true;
  else
    return false;
}
/******************************************************************************/
long stringToNumN(char *cadena, char size){
  char cont;
  long numero = 0;

  //Convertir a numero
  for(cont = 0; cont < size && cadena[cont] != 0; cont++){
    numero *= 10;
    numero += cadena[cont]-'0';
  }

  return numero;
}
/******************************************************************************/
long stringToNum(char *cadena){
  short cont = 0;
  long numero = 0;

  //Convertir a numero
  while(cadena[cont]){
    numero *= 10;
    numero += cadena[cont++]-'0';
  }

  return numero;
}
/******************************************************************************/
char* numToString(long valor, char *cadena, short digitos){
  cadena[digitos--] = 0;//Agregar final de cadena
  while(digitos >= 0){
    //Realizar la conversion
    cadena[digitos--] = (valor % 10) + '0';
    valor /= 10;
  }

  return cadena;
}
/******************************************************************************/
char* numToHex(long valor, char *cadena, char bytes){
  char cont = 0;

  //Convierte las posciones
  while(bytes--){
    //Bits mas significativos
    cadena[cont] = Swap(getByte(valor, bytes))&0x0F;
    if(cadena[cont] < 0x0A)
      cadena[cont] = cadena[cont] + '0';
    else
      cadena[cont] = cadena[cont] + '7';  //Compenso la letra A
    cont++;
    //Bits menos significativos
    cadena[cont] = getByte(valor, bytes)&0x0F;
    if(cadena[cont] < 0x0A)
      cadena[cont] = cadena[cont] + '0';
    else
      cadena[cont] = cadena[cont] + '7';  //Compenso la letra A
    cont++;
  }
  cadena[cont] = 0;

  return cadena;
}
/******************************************************************************/
long hexToNum(char *hex){
  char cont;
  char ref = strlen(hex)-1;
  long valor = 0;

  //Solo aceptar maximo 4 bytes, 8 caracteres
  for(cont = 0; cont < 8 && hex[cont]; cont++, ref--){
    //Obtenemos los bytes menos significativos
    if(hex[cont] >= '0' && hex[cont] <= '9')
      getByte(valor, ref/2) |= hex[cont] - '0';
    else if(hex[cont] >= 'a' && hex[cont] <= 'f')
      getByte(valor, ref/2) |= 10+(hex[cont] - 'a');
    else if(hex[cont] >= 'A' && hex[cont] <= 'F')
      getByte(valor, ref/2) |= 10+(hex[cont] - 'A');
    else
      break;  //Fallo la conversion

    //Preguntar si debo hacer swap
    if(ref % 2 == 1)
      getByte(valor, ref/2) = Swap(getByte(valor, ref/2));
  }

  return valor;
}
/******************************************************************************/
char* string_toUpper(char *cadena){
  char cont = 0;
  while(cadena[cont] != 0){
    if(cadena[cont] >= 'a' && cadena[cont] <= 'z')
      cadena[cont] -= 'a'-'A'; //a = 97, A = 65
    cont++;
  }
  return cadena;
}
/******************************************************************************/
#endif