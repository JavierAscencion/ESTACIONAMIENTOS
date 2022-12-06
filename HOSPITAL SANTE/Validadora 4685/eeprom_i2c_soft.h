#ifndef _EEPROM_I2C_SOFT_H
#define _EEPROM_I2C_SOFT_H
#include "I2C_Soft.h"

// Software I2C connections
extern sfr sbit I2C_SCL;
extern sfr sbit I2C_SCLD;
extern sfr sbit I2C_SDA;
extern sfr sbit I2C_SDAD;

//VARIABLES CONSTANTES
#define ACK           1
#define NO_ACK        0

//DIRECCIONES
const char EEPROM_ADDRESS_24LC256 = 0xA0;


/******************************** FUNCTIONS ***********************************/
void eeprom_i2c_open(){
  I2C_soft_init();         //Initialize Soft I2C communication}
}
/******************************************************************************/
void eeprom_i2c_write(unsigned int address, char *datos, char size){
  char cont = 0;
  
  while(cont < size){
    I2C_soft_start();                       // Issue start signal
    // Address EEPROM, see 24LC256 datasheet
    I2C_soft_write(EEPROM_ADDRESS_24LC256); //Escritura e multiples bytes
    I2C_soft_write(getByte(address,1));     // Start from address hihg
    I2C_soft_write(getByte(address,0));     // Start from address low
    //Maximo 64 bytes por page
    for(; cont < size; cont++){
      I2C_soft_write(datos[cont]);           // Byte para ser escrito
      if(++address%64 == 0){
        cont++;
        break;
      }
    }
    I2C_soft_stop();                         // Issue stop signal
    //Acelera la escritura
    while(true){
      I2C_soft_start();
      if(!I2C_soft_write(EEPROM_ADDRESS_24LC256))
        break;
    }
    I2C_soft_stop();      // Issue stop signal
  }
}
/******************************************************************************/
void eeprom_i2c_read(unsigned int address, char *datos, char size){
  char cont;

  I2C_soft_start();                       // Issue start signal
  // Address EEPROM, see 24LC256 datasheet
  I2C_soft_write(EEPROM_ADDRESS_24LC256); //Escritura e multiples bytes
  I2C_soft_write(getByte(address,1));     // Start from address hihg
  I2C_soft_write(getByte(address,0));     // Start from address low
  I2C_soft_start();                       // Issue repeated start signal
  I2C_soft_write(EEPROM_ADDRESS_24LC256|0x01);    // Address EEPROM_ADDRESS_24LC256 for reading R/W=1
  //Lectura de la eeprom, n-1 datos con ACK
  for(cont = 0; cont < size-1; cont++)
    datos[cont] = I2C_soft_read(ACK);
  datos[cont] = I2C_soft_read(NO_ACK);
  I2C_soft_stop();                                // Issue stop signal
}
/******************************************************************************/
#endif