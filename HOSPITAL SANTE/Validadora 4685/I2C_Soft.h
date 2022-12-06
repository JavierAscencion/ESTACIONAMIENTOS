/*
Programador: Luis Otañez Rosete
Libreria para dos I2Cx
Frecuencia 250Khz
*/
#ifndef _I2C_SOFT_H
#define _I2C_SOFT_H

//Pines para el primer modulo
extern sfr sbit I2C_SCL;
extern sfr sbit I2C_SCLD;
extern sfr sbit I2C_SDA;
extern sfr sbit I2C_SDAD;

/******************************************************************************/
void I2C_soft_init(){
  //Configuramos como entradas
  I2C_SCLD = 1;
  I2C_SDAD = 1;
}
/******************************************************************************/
void I2C_soft_start(){
  //Sirve esto por si hay que repetir start
  I2C_SDAD = 1;
  I2C_SCLD = 1;
  delay_us(2);
  //Poner SDA en bajo
  I2C_SDAD = 0;
  I2C_SDA = 0;  //Señal en bajo
  delay_us(2);
  //Poner SCL en bajo
  I2C_SCLD = 0;
  I2C_SCL = 0;  //Señal en bajo
}
/******************************************************************************/
void I2C_soft_stop(){
  I2C_SDAD = 0;  //Configuro de salida por seguridad
  I2C_SDA = 0;   //Mando cero por el protocolo
  delay_us(2);
  I2C_SCLD = 1;
  delay_us(2);
  I2C_SDAD = 1;
}
/******************************************************************************/
bool I2C_soft_write(char dato){
  char i;
  
  //Mandar el dato
  for(i = 0; i < 8; i++){
    I2C_SDA = dato.B7;  //El valor del bit
    I2C_SCL = 1;        //Activar dato
    delay_us(2);
    dato <<= 1;         //Recorro hacia la izquierda
    I2C_SCL = 0;
    delay_us(2);
  }
  
  //Configurar SDA para recibir el ACK
  I2C_SDAD = 1;
  asm nop;
  I2C_SCL = 1;     //Mandar el púlso para recibir el ACK
  delay_us(2);
  i.B0 = I2C_SDA;  //Guardo el valor del ACK
  I2C_SCL = 0;
  I2C_SDAD = 0;    //Configurar como salida el pin

  return i.B0;
}
/******************************************************************************/
char I2C_soft_read(bool ACK){
  char i, result = 0;
  
  //Configuar pin SDA para recibir el byte
  I2C_SDAD = 1;

  for(i = 0; i < 8; i++){
    result <<= 1;
    I2C_SCL = 1;
    delay_us(2);
    //Guardamo bit
    if(I2C_SDA)
      result |= 0x01;
    I2C_SCL = 0;
    delay_us(2);
  }
  
  //Configuarar como salida SDA
  I2C_SDAD = 0;
  I2C_SDA = !ACK.B0;  //Señal negada
  asm nop;
  I2C_SCL = 1;
  delay_us(2);
  I2C_SCL = 0;
  
  return result;
}
/******************************************************************************/
#endif