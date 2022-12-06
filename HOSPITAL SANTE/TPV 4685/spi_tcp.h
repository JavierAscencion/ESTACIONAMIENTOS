#include "miscelaneos.h"

extern sfr sbit SPI_CS;
extern sfr sbit SPI_CSD;

//COMANDS
const char ETH_READ_CMD = 0x00;
const char ETH_WRITE_CMD = 0x40;

//REGISTER PHY
const char PHLCON = 0x14;       //Configuracion del parpadeo
const char PHSTAT1 = 0x01;      //Info de lectura
const char PHSTAT2 = 0x11;      //Info de lectura
//BRESGISTER BANK ALL
const char ECON1 = 0x1F;
//REGISTER BANK 2
const char MICMD = 0x12;
const char MIREGADR = 0x14;
const char MIWRL = 0x16;
const char MIWRH = 0x17;
const char MIRDL = 0x18;
const char MIRDH = 0x19;
//REGISTER BANK 3
const char MISTAT = 0x0A;


/******************************** FUNCTIONS ***********************************/
char spi_tcp_read(char reg, bool reg_eth){
  SPI_CS = 0;
  SPI1_write(ETH_READ_CMD|reg);
  reg = SPI1_read(0);     //Comando ETH
  if(!reg_eth)
    reg = SPI1_read(0);   //Comando MII ó MAC
  SPI_CS = 1;
  
  return reg;
}
/******************************************************************************/
void spi_tcp_write(char reg, char value){
  SPI_CS = 0;
  SPI1_write(ETH_WRITE_CMD|reg);
  SPI1_write(value);
  SPI_CS = 1;
}
/******************************************************************************/
unsigned int spi_tcp_read_phy(char regPHY){
  char resp[2],banco;        //Respalda los buffer
  unsigned int value;
  
  //Cambiar al banco 2
  resp[0] = spi_tcp_read(ECON1, true);
  banco = resp[0];
  resp[0].B0 = 0;
  resp[0].B1 = 1;
  spi_tcp_write(ECON1, resp[0]);
  resp[1] = spi_tcp_read(MICMD, false);
  //Escribir la direccion deseada de PHY
  spi_tcp_write(MIREGADR, regPHY);
  //Setear el bit0 de MICMD
  resp[1].B0 = 1;
  spi_tcp_write(MICMD, resp[1]);
  delay_us(12);              //Asegurar bit
  //Cambio al banco 3
  resp[0].B0 = 1;
  resp[0].B1 = 1;
  spi_tcp_write(ECON1, resp[0]);
  //Esperar a que llene los datos a los registros
  while(spi_tcp_read(MISTAT, false).B0);   //Esparar a que se desocupe el bit
  //Cambiar al banco 2
  resp[0].B0 = 0;
  resp[0].B1 = 1;
  spi_tcp_write(ECON1, resp[0]);
  //Clear bit0 de MICMD
  resp[1].B0 = 0;
  spi_tcp_write(MICMD, resp[1]);
  //Leemos registros deseados
  getByte(value, 0) = spi_tcp_read(MIRDL, false);
  getByte(value, 1) = spi_tcp_read(MIRDH, false);
  //Regresar al banco inicial
  spi_tcp_write(ECON1, banco);
  
  return value;
}
/******************************************************************************/
bool spi_tcp_linked(){
  unsigned int aux = spi_tcp_read_phy(PHSTAT2);
  
  aux = getByte(aux,1).B2;  //Reciclar sabe si el cable esta conectado
  
  return aux;
}
/******************************************************************************/