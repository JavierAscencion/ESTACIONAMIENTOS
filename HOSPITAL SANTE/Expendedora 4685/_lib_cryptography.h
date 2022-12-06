#ifndef _LIB_CRYPTOGRAPHY_H
#define _LIB_CRYPTOGRAPHY_H

/******************************************************************************/
void encrypt_basic(char *cadena){
  char cont = 0;
  
  while(cadena[cont]){
    if(cadena[cont] == '0')
      cadena[cont] = '2';
    else if(cadena[cont] == '1')
      cadena[cont] = '0';
    else if(cadena[cont] == '2')
      cadena[cont] = '8';
    else if(cadena[cont] == '3')
      cadena[cont] = '9';
    else if(cadena[cont] == '4')
      cadena[cont] = '7';
    else if(cadena[cont] == '5')
      cadena[cont] = '6';
    else if(cadena[cont] == '6')
      cadena[cont] = '4';
    else if(cadena[cont] == '7')
      cadena[cont] = '5';
    else if(cadena[cont] == '8')
      cadena[cont] = '3';
    else if(cadena[cont] == '9')
      cadena[cont] = '1';
    cont++;
  }
}
/******************************************************************************/
void decrypt_basic(char *cadena){
  char cont = 0;
  
  while(cadena[cont]){
    if(cadena[cont] == '0')
      cadena[cont] = '1';
    else if(cadena[cont] == '1')
      cadena[cont] = '9';
    else if(cadena[cont] == '2')
      cadena[cont] = '0';
    else if(cadena[cont] == '3')
      cadena[cont] = '8';
    else if(cadena[cont] == '4')
      cadena[cont] = '6';
    else if(cadena[cont] == '5')
      cadena[cont] = '7';
    else if(cadena[cont] == '6')
      cadena[cont] = '5';
    else if(cadena[cont] == '7')
      cadena[cont] = '4';
    else if(cadena[cont] == '8')
      cadena[cont] = '2';
    else if(cadena[cont] == '9')
      cadena[cont] = '3';
    cont++;
  }
}
/******************************************************************************/

#endif