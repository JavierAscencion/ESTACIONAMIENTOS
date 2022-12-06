/*DESCRIPCIOM
Programador: Luis Otañez Rosete
Objeto:      DS1307_Software

sfr sbit I2C_SCL                   at PORTX.Bx;
sfr sbit I2C_SCLD                  at TRISX.Bx;
sfr sbit I2C_SDA                   at PORTX.Bx;
sfr sbit I2C_SDAD                  at TRISX.Bx;
*/

#ifndef DS1307_SOFT_H
#define DS1307_SOFT_H

//Librerias
#include "miscelaneos.h"
#include "string.h"

// Software I2C connections
extern sfr sbit DS1307_SCL;
extern sfr sbit DS1307_SCLD;
extern sfr sbit DS1307_SDA;
extern sfr sbit DS1307_SDAD;

sfr sbit Soft_I2C_Scl               at DS1307_SCL;
sfr sbit Soft_I2C_Scl_Direction     at DS1307_SCLD;
sfr sbit Soft_I2C_Sda               at DS1307_SDA;
sfr sbit Soft_I2C_Sda_Direction     at DS1307_SDAD;

//Variables
#define DS1307_ADDRESS 0xD0
#define DS1307_READ    0xD1
#define DS1307_WRITE   0xD0
#define DS1307_ACK     1
#define DS1307_NO_ACK  0

/********************************* STRUCT *************************************/
typedef struct{
  char seconds;
  char minutes;
  char hours;
  char dayOfWeek;   //Dia de la semana
  char day;         //Dia del mes
  char month;       //Mes
  char year;
  char time[20];    //Formato W-HH:MM:SS DD/MM/YY, W = Dia de la semana
}DS1307;
/*************************** FUNCTIONS PROTOTYPE ******************************/
char* DS1307_date(DS1307 *myDS, bool formatComplet);
/******************************** FUNCTIONS ***********************************/
void DS1307_open(){
  Soft_I2C_Init();         //Initialize Soft I2C communication
}
/******************************************************************************/
void DS1307_write(DS1307 *myDS, char DOW, char HH, char MM, char SS, char DD, char MTH, char YY){
  //Formato W-HH:MM:SS DD/MM/YY
  Soft_I2C_Start();               // Issue start signal
  Soft_I2C_Write(DS1307_ADDRESS); // Address DS1307, see DS1307 datasheet
  Soft_I2C_Write(0x00);           // Start from address 0
  
  //Escribir en el RTC
  Soft_I2C_Write(decToBcd(SS));   //Segundos
  Soft_I2C_Write(decToBcd(MM));   //Minutos
  Soft_I2C_Write(decToBcd(HH));   //Horas
  Soft_I2C_Write(decToBcd(DOW));  //Dia del mes
  Soft_I2C_Write(decToBcd(DD));   //Dia del mes
  Soft_I2C_Write(decToBcd(MTH));  //Mes
  Soft_I2C_Write(decToBcd(YY));   //Año
  Soft_I2C_Write(0x80);           //Register SQW
  Soft_I2C_Stop();                // Issue stop signal
  
  //Respaldar en el RTC
  myDS->seconds = SS;
  myDS->minutes = MM;
  myDS->hours = HH;
  myDS->dayOfWeek = DOW;
  myDS->day = DD;
  myDS->month = MTH;
  myDS->year = YY;
  
  //Formato W-HH:MM:SS DD/MM/YY, W = Dia de la semana
  DS1307_date(myDS, true);
}
/******************************************************************************/
bool DS1307_write_string(DS1307 *myDS, char *date){
  //Formato W-HH:MM:SS DD/MM/YY = 13 Caracteres
  if(string_len(date) != 13 || !string_isNumeric(date))
    return false;

  //Decodificar la cadena
  myDS->dayOfWeek = stringToNumN(&date[0], 1);
  myDS->hours = stringToNumN(&date[1], 2);
  myDs->minutes = stringToNumN(&date[3], 2);
  myDS->seconds = stringToNumN(&date[5], 2);
  myDS->day = stringToNumN(&date[7], 2);
  myDS->month = stringToNumN(&date[9], 2);
  myDS->year = stringToNumN(&date[11], 2);
  
  Soft_I2C_Start();               // Issue start signal
  Soft_I2C_Write(DS1307_ADDRESS); // Address DS1307, see DS1307 datasheet
  Soft_I2C_Write(0x00);           // Start from address 0

  //Escribir en el RTC
  Soft_I2C_Write(decToBcd(myDS->seconds));   //Segundos
  Soft_I2C_Write(decToBcd(myDS->minutes));   //Minutos
  Soft_I2C_Write(decToBcd(myDs->hours));     //Horas
  Soft_I2C_Write(decToBcd(myDS->dayOfWeek)); //Dia de la semana
  Soft_I2C_Write(decToBcd(myDS->day));       //Dia del mes
  Soft_I2C_Write(decToBcd(myDS->month));     //Mes
  Soft_I2C_Write(decToBcd(myDS->year));      //Año
  Soft_I2C_Write(0x80);                      //Register SQW
  Soft_I2C_Stop();                           // Issue stop signal

  //Formato W-HH:MM:SS DD/MM/YY, W = Dia de la semana
  DS1307_date(myDS, true);
}
/******************************************************************************/
char* DS1307_read(DS1307 *myDS, bool formatComplet){
  Soft_I2C_Start();               // Issue start signal
  Soft_I2C_Write(DS1307_ADDRESS); // Address DS1307, see DS1307 datasheet
  Soft_I2C_Write(0x00);           // Start from address 0
  Soft_I2C_Start();               // Issue repeated start signal
  Soft_I2C_Write(DS1307_READ);    // Address DS1307 for reading R/W=1

  myDS->seconds = Soft_I2C_Read(DS1307_ACK);      // Read seconds
  myDS->minutes = Soft_I2C_Read(DS1307_ACK);      // Read minutes
  myDS->hours = Soft_I2C_Read(DS1307_ACK);        // Read hours
  myDS->dayOfWeek = Soft_I2C_Read(DS1307_ACK);    // Read day of week
  myDS->day = Soft_I2C_Read(DS1307_ACK);          // Read day of month
  myDS->month = Soft_I2C_Read(DS1307_ACK);        // Read mes del año
  myDS->year = Soft_I2C_Read(DS1307_NO_ACK);      // Read years
  Soft_I2C_Stop();                                // Issue stop signal
  
  //Convertir los valores a decimales
  myDS->seconds = bcdToDec(0x7F&myDS->seconds);   //Por el canal CH DS1307
  myDS->minutes = bcdToDec(myDS->minutes);
  myDS->hours = bcdToDec(myDS->hours);
  myDS->dayOfWeek = bcdToDec(myDS->dayOfWeek);
  myDS->day = bcdToDec(myDS->daY);
  myDS->month = bcdToDec(myDS->month);
  myDS->year = bcdToDec(myDS->year);

  //Formato W-HH:MM:SS DD/MM/YY, W = Dia de la semana
  DS1307_date(myDS, formatComplet);

  return myDS->time;
}
/******************************************************************************/
char* DS1307_date(DS1307 *myDS, bool formatComplet){
  char cont = 0;
  
  //Formato W-HH:MM:SS DD/MM/YY, W = Dia de la semana
  //Dia de la semana
  numToString(myDs->dayOfWeek, &myDs->time[cont++], 1);
  if(formatComplet)
    myDS->time[cont++] = '-';
  //Horas
  numToString(myDs->hours, &myDs->time[cont], 2);
  cont += 2;
  if(formatComplet)
    myDS->time[cont++] = ':';
  //Minutos
  numToString(myDs->minutes, &myDs->time[cont], 2);
  cont += 2;
  if(formatComplet)
    myDS->time[cont++] = ':';
  //Segundos
  numToString(myDs->seconds, &myDs->time[cont], 2);
  cont += 2;
  if(formatComplet)
    myDS->time[cont++] = ' ';
  //Dia del mes
  numToString(myDs->day, &myDs->time[cont], 2);
  cont += 2;
  if(formatComplet)
    myDS->time[cont++] = '/';
  //Mes
  numToString(myDs->month, &myDs->time[cont], 2);
  cont += 2;
  if(formatComplet)
    myDS->time[cont++] = '/';
  //Año
  numToString(myDs->year, &myDs->time[cont], 2);
  cont += 2;
  myDS->time[cont] = 0;  //Final de cadena
  
  return myDS->time;
}
/******************************************************************************/
long DS1307_getSeconds(char *HHMMSS){
  char cont = 0;
  long segundos = -1;

  if(string_len(HHMMSS) == 6){
    segundos = 0;
    //Decodificar la cadena
    while(HHMMSS[cont] != 0){
      segundos *= 60;
      segundos += stringToNumN(&HHMMSS[cont], 2);
      cont += 2;
    }
  }
  
  return segundos;
}
/******************************************************************************/
#endif