#ifndef _MISCELANEOS_H
#define _MISCELANEOS_H

/******************************************************************************/
char bcdToDec(char dato){
  dato = 10*(swap(dato)&0x0F) + (dato&0x0F);
  
  return dato;
}
/******************************************************************************/
char decToBcd(char dato){
  dato = swap(dato/10) + (dato%10);
  
  return dato;
}
/******************************************************************************/
char* RomToRam(const char *origen, char *destino){
  unsigned int cont = 0;
  //Copiar cadena completa con el cero
  while(destino[cont] = origen[cont++]);
  
  return destino;
}
/******************************************************************************/
long clamp(long valor, long min, long max){
  if(valor > max)
    valor = max;
  else if(valor < min)
    valor = min;

  return valor;
}
/******************************************************************************/
long clamp_shift(long valor, long min, long max){
  if(valor > max)
    valor = min;
  else if(valor < min)
    valor = max;

  return valor;
}
/******************************************************************************/
#endif