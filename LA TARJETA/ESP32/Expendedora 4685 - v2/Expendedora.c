/****************************** DESCRIPCION ************************************
Nota: Verificar el overflow en lectura del can


can_user_read_message
*******************************************************************************/

/******************************************************************************/
/******************************* LIBRERIAS ************************************/
/******************************************************************************/
//OTRAS
#include "miscelaneos.h"
#include "string.h"
//HARDWARE
#include "lib_timer1.h"
#include "lib_timer2.h"
#include "lib_timer3.h"
#include "lib_usart.h"
#include "lib_can.h"
//MODULOS
#include "DS1307.h"
#include "impresora_termica.h"
#include "table_eeprom.h"
#include "wiegand26.h"
#include "_lib_cryptography.h"
#include "lcd_4x20.h"

//Impresora
#include "TICKET.h"
/******************************************************************************/
/******************************** PIN OUT *************************************/
/******************************************************************************/
//ENTRADAS:: ENTRADA 2 Y 3 SON INTERRPCIONES EXTERNAS
sfr sbit BOTON_ENTRADA1            at PORTD.B4;  //ENTRADA 1
sfr sbit BOTON_ENTRADA1D           at TRISD.B4;
sfr sbit SENSOR_COCHE              at PORTD.B0;  //ENTRADA 4
sfr sbit SENSOR_COCHED             at TRISD.B0;
sfr sbit BOTON_IMPRIMIR            at PORTD.B1;  //ENTRADA 5
sfr sbit BOTON_IMPRIMIRD           at TRISD.B1;
//SALIDAS
sfr sbit LED_LINK                  at PORTC.B2;  //LED CONEXION TCP
sfr sbit LED_LINKD                 at TRISC.B2;
sfr sbit SALIDA_RELE1              at PORTA.B5;
sfr sbit SALIDA_RELE1D             at TRISA.B5;
sfr sbit SALIDA_RELE2              at PORTE.B0;
sfr sbit SALIDA_RELE2D             at TRISE.B0;
sfr sbit SALIDA_RELE3              at PORTD.B2;
sfr sbit SALIDA_RELE3D             at TRISD.B2;
sfr sbit SALIDA_RELE4              at PORTD.B3;
sfr sbit SALIDA_RELE4D             at TRISD.B3;
sfr sbit SALIDA_RELE5              at PORTD.B7;
sfr sbit SALIDA_RELE5D             at TRISD.B7;
//MODULO RTC DS1307
sfr sbit DS1307_SCL                at PORTE.B1;
sfr sbit DS1307_SCLD               at TRISE.B1;
sfr sbit DS1307_SDA                at PORTD.B6;
sfr sbit DS1307_SDAD               at TRISD.B6;
//MODULO EEPROM 32K
sfr sbit I2C_SCL                   at PORTB.B4;
sfr sbit I2C_SCLD                  at TRISB.B4;
sfr sbit I2C_SDA                   at PORTB.B5;
sfr sbit I2C_SDAD                  at TRISB.B5;
//MODULO LCD
sbit LCD_RS                        at PORTE.B2;
sbit LCD_RS_Direction              at TRISE.B2;
sbit LCD_EN                        at PORTA.B3;
sbit LCD_EN_Direction              at TRISA.B3;
sbit LCD_D4                        at PORTA.B4;
sbit LCD_D4_Direction              at TRISA.B4;
sbit LCD_D5                        at PORTA.B2;
sbit LCD_D5_Direction              at TRISA.B2;
sbit LCD_D6                        at PORTA.B1;
sbit LCD_D6_Direction              at TRISA.B1;
sbit LCD_D7                        at PORTA.B0;
sbit LCD_D7_Direction              at TRISA.B0;
//MODULO ETHERNET
sfr sbit Net_Ethernet_28j60_Rst    at PORTC.B0;
sfr sbit Net_Ethernet_28j60_CS     at PORTC.B1;
sfr sbit Net_Ethernet_28j60_Rst_Direction at TRISC.B0;
sfr sbit Net_Ethernet_28j60_CS_Direction  at TRISC.B1;
sfr sbit SPI_CS                           at PORTC.B1;
sfr sbit SPI_CSD                          at TRISC.B1;


/******************************************************************************/
/******************************* VARIABLES ************************************/
/******************************************************************************/
//CONSTANTES HARDWARE
const int timeAwake = 300;      //Tiempo para despertar al microcontrolador
const long baudiosRate = 9600;  //Velocidad de los baudios

//EVENTOS DEL COCHE
const char CAN_COCHE_IN[] = "CARI";
const char CAN_COCHE_OUT[] = "CARO";
//COMANDOS PARA EL CAN PENSIONADOS
const char CAN_PENSIONADO[] = "PEN";  //COMANDO PENSIONADO
const char CAN_REGISTRAR[] = "REG";   //REGISTRO
const char CAN_ACTUALIZAR[] = "ACT";  //ACTUALIZAR
const char CAN_CONSULTAR[] = "CON";   //CONSULTAR
const char CAN_VIGENCIA[] = "VIG";
const char CAN_PASSBACK[] = "PAS";
const char CAN_PREPAGO[] = "PRE";
const char CAN_SALDO[] = "SLD";
const char CAN_SPECIAL_DATE[] = "SPD";    //Special comando = estatus+date
const char CAN_SPECIAL_SALDO[] = "SPS";   //Special comando = estatus+saldo
const char CAN_SOPORTE[] = "SOP";     //TARJETA DE SOPORTE TECNICO
//COMANDOS PARA EL RTC
const char CAN_RTC[] = "RTC";         //MODIFICA LA HORA DEL RTC
//COMANDOS PARA LAS TABLAS INDIVIDUALES
const char CAN_TABLE[] = "TBL";
const char CAN_TABLE_INFO[] = "INF";
const char CAN_TABLE_ERASE[] = "ERS"; //ERASE
const char CAN_TABLE_RW[] = "TRW";    //PARA LECTURA Y ESCRITURA DE TABLA, WARNING
const char CAN_TABLE_READ[] = "TBR";  //LECTURA DE LA TABLA PARTICULAR
const char CAN_TABLE_WRITE[] = "TBW"; //ESCRITURA DE LA TABLA PARTICULAR
const char CAN_TABLE_GET[] = "GET";
const char CAN_TABLE_SET[] = "SET";
//RESPUESTA DE LA TABLA
const char CAN_TABLE_ERROR[] = "ERROR";
const char CAN_TABLE_MODIFICADO[] = "MODIFICADO";
const char CAN_TABLE_NO_FOUND[] = "NO FOUND";
//EVENTOS HACIA TPV Y COMANDOS ESPECIALES
const char CAN_TPV[] = "TPV";  //EVENTO QUE VA HACIA ETHERNET
const char CAN_IDX[] = "IDX";  //EVENTO ID PENSIONADO
const char CAN_FOL[] = "FOL";  //EVENTO FOLIO
const char CAN_NIP[] = "NIP";  //EVENTO NIP, SE UTLIZA EN PREPAGO Y EVENTO TPV***
const char CAN_TBL[] = "TBL";  //PARA LAS TABLAS
//MODULO
const char CAN_MODULE[] = "E"; //EXPENDEDORA
//EVENTO COMANDOS
const char CAN_CMD[] = "CMD";
const char CAN_KEY[] = "KEY";
const char CAN_CUPO[] = "CUP";
const char CAN_ABRIR[] = "OPN";
const char CAN_OUT[] = "OUT";

char tablePensionados[] = "Pensionados"; //Pensionados registrados y vigentes
char pensionadosID[] = "id";
char pensionadosEstatus[] = "estatus";
char pensionadosVigencia[] = "vigencia";
//TABLE PREPAGOS
char tablePrepago[] = "Prepago";          //Tarjetas de prepago
char prepagoNip[] = "nip";                //4Bytes
char prepagoId[] = "id";                  //4Bytes
char prepagoEstatus[] = "estatus";        //1Byte
char prepagoDate[] = "date";              //12 Caracteres + final
char prepagoSaldo[] = "saldo";            //4Bytes
//TABLA DE SOPORTE TECNICO
char tableSoporte[] = "Soporte";          //Usuarios de soporte tecnico
char soporteID[] = "id";
//TABLA FOLIO
char tableFolio[] = "Folio";             //FOLIO TOTAL DE TODAS LAS EXPENDEDORAS
char folioTotal[] = "total";             //FOLIO TOTAL
long folio;                              //FOLIO
//TABLA TICKET
char tableTicketTPV[] = "TicketTPV";     //Ticket para el TPV
char tableTicketEXP[] = "TicketEXP";           //Almacena el ticket dinamico
const int ticketAddr[] = {0x0100, 0x0114, 0x011F, 0x013D, 0};  //Valida direcciones
char ticketTime[20]               absolute ticketAddr[0];
char ticketFolio[11]              absolute ticketAddr[1];
char ticketCodigo[30]             absolute ticketAddr[2];
char ticketCodigo2[30]            absolute ticketAddr[3];
//TABLE EVENTOS CAN
char tableEventosTCP[] = "EventosTCP";   //EVENTOS HACIA EL SERVIDOR
char tableEventosCAN[] = "EventosCAN";   //EVENTOS DE LOS MODULOS CONECTADOR POR CAN
char eventosRegistro[] = "registro";     //Maximo 30 caracteres
char eventosEstatus[] = "estatus";
//TABLA DE KEYS
char tableKeyOutNip[] = "KeyNip";         //Guarda teclas para salir
char tableKeyOutDate[] = "KeyDate";       //Tabla de salida por fecha
char tableKeyOutFol[] = "KeyFolios";      //Tabla de salida por folios
char keyOutNip[] = "nip";
char keyOutFol[] = "folio";
char keyOutDate[] = "date";
char keyOutEstatus[] = "estatus";
//TOLERANCIA PARA SALIR DEL RANGO
const int TOLERANCIA_OUT = 15*60 + 10;   //Tolerancia de salida + rangoPermisible
//TABLA DE TIEMPO DE SALIDA
char tableToleranciaOut[] = "timeTolerancia";
char tableToleranciaMax[] = "tolerancia";
unsigned int toleranciaOut;
//TABLA PARA VARIABLES EXTRAS
char tableSyncronia[] = "Sincronia";
char tableCupo[] = "Cupo";
char columnaEstado[] = "estado";



//VARIABLES PARA EL TIMER
bool flagTMR3 = false;       //Flag para el timer cada ms
bool flagSecondTMR3 = false; //Bandera de cada segundo de temporizacion

//Variables CAN
const char canIdTPV = 0;    //Id del TPV
char canId = 1;             //El id del pic
long canIp = 0x1E549500;    //Red lan: 30.84.149.0
long canMask = 0xFFFFFFFF;  //Filtrar: 255.255.255.255
char canCommand[64];        //Variable que envia los eventos

//Variables para el heartbeat
const unsigned int TIME_HEARTBEAT = 1*5;   //CADA X MINUTOS ENVIA HEARTBEAT
unsigned int temp_heartbeat = 0;           //Temporizador

//OBJETOS
DS1307 myRTC;

//Variables para el buffer
bool modeBufferEventos = false; //ESTA ENVIADO EVENTOS DE LA TABLA
int pilaBufferCAN;              //PILA DEL BUFFER
int pilaBufferPointer;          //PUNTERO ACTUAL APUNTADA
char bufferEeprom[64];          //Guarda en eeprom los eventos no enviados

//Otros
char msjConst[20];              //Mensajes constantes a ser convertidos
bool canSynchrony;              //Sync
bool cupoLleno;                 //Cupo del pic, para imprmir el boleto
bool abrirBarrera = false;      //Abrir barrera por estado

//Time para la barrera abierta
const char timeSensor = 3;
char tempSensor;
char eSensor = 0;               //Maquina de estados para el sensor
bool estadoSensor = true;       //En uno se activa el senado


/******************************************************************************/
/************************** FUNCTION PROTOTYPE ********************************/
/******************************************************************************/
//OTRAS
void lcd_clean_row(char fila);
void buffer_save_send(bool guardar, char *buffer);
void can_heartbeat();
//PRINCIPALES
void pic_init();                   //Inicializacion del microcontrolador
void expendedora_checkTarjeta();   //Verifica tarjetas pasada por el wiegand
bool expendedora_ticket();         //Impresion del ticket por EEPROM
void expendedora_imprimir();       //Imprime ticket
void expendedora_bufferEventos();  //Envia los eventos por buffer
void expendedora_temporizadores(); //Temporiza eventos
void expendedora_barrera();        //Barrera apertura


//Eliminables
bool limpiarLCD = false;
char tempLCD = 0;
long tam;
//#define CREATE_CODE_TABLE
//#define debug_usart

/******************************************************************************/
/********************************** MAIN **************************************/
/******************************************************************************/
void main(){
  //Inicializar el pic
  pic_init();
  
  while(true){
    can_do_work();                  //Tareas can open
    expendedora_checkTarjeta();     //Verifica la tarjeta del pensionado
    expendedora_imprimir();         //Imprime ticket
    expendedora_bufferEventos();
    expendedora_temporizadores();
    expendedora_barrera();
  }
}
/******************************* INTERRUPT ************************************/
void interrupt(){
  int_wiegand26();
  //int_usart_rx();
}
/******************************************************************************/
void interrupt_low(){
  int_timer1();
  int_timer2();
  int_timer3();
  //int_usart_tx();
  int_can();
}
/******************************************************************************/
/******************************** FUNCTIONS ***********************************/
/******************************************************************************/
void pic_init(){
  //Configurar el reloj del pic
  OSCCON = 0x40;  //Oscilador externo
  
  //Configuar los pines analogicos
  ADCON1 = 0x0F;  //Todos digitales
  CMCON = 0x07;   //Apagar los comparadores
  
  //Configurar los pines entrada o salida
  SENSOR_COCHED = 1;
  BOTON_IMPRIMIRD = 1;
  BOTON_ENTRADA1D = 1;
  LED_LINKD = 0;
  SALIDA_RELE1D = 0;
  SALIDA_RELE2D = 0;
  SALIDA_RELE3D = 0;
  SALIDA_RELE4D = 0;
  SALIDA_RELE5D = 0;
  //Se�ales por defecto
  SALIDA_RELE1 = 0;
  SALIDA_RELE2 = 0;
  SALIDA_RELE3 = 0;
  SALIDA_RELE4 = 0;
  SALIDA_RELE5 = 0;
  LED_LINK = 0;
  
  //Inicializar la eeprom del pic
  canId = eeprom_read(0);
  
  //Inicializar los modulos ADC, TIMERS, SPI, I2C, EEPPROM, Modulos
  timer1_open(50e3, true, false, false);
  timer3_open(50e3, true, true, false);
  usart_open(baudiosRate);
  //usart_enable_rx(true, true, 0x0D);
  //usart_enable_tx(false);
  //Modulos
  DS1307_open();
  lcd_init();
  lcd_cmd(_LCD_CURSOR_OFF);
  lcd_cmd(_LCD_CLEAR);
  mysql_init(32768);
  wiegand26_open();
  can_open(canIp, canMask, canId, 4);
  can_interrupt(true, false);

  //Preprogramacion init modules
  lcd_clean_row(1);
  lcd_out(1, 1, "Inicializando...");
  #ifdef debug_usart
  usart_write_line("Energia establecida");
  #endif
  wiegand26_enable();
  DS1307_Read(&myRTC, true);
  //Cargar elementos en buffer
  pilaBufferCAN = mysql_count_forced(tableEventosCAN, eventosEstatus, '1');
  #ifdef debug_usart
  usart_write_text("Pila: ");
  inttostr(pilabufferCAN, msjConst);
  usart_write_line(msjConst);
  #endif
  //Cargar folio guardado
  mysql_read(tableFolio, folioTotal, 1, &folio);
  mysql_read_string(tableCupo, columnaEstado, 1, &cupoLleno);
  mysql_read_string(tableSyncronia, columnaEstado, 1, &canSynchrony);
  
  //ACTIVAR INTERRUPCIONES
  RCON.IPEN = 1;     //ACTIVAR NIVELES DE INTERRUPCION
  INTCON.PEIE = 1;   //ACTIVAR INTERRUPCIONES PERIFERICAS
  INTCON.GIE = 1;    //ACTIVAR INTERRUPCIONES GLOBALES
  //Reset provocado por BrownOut, PowerOn, MCLR, !RCON.BOR || !RCON.POR || !RCON.RI
  /****************************************************************************/
  #ifdef CREATE_CODE_TABLE
  usart_write_line("Iniciando tablas...");
  //NOTA CUIDADO EN LA GRABACION POR LA ENERGIA DE LA PLACA GUARDA MAL UNOS DATOS
  delay_ms(10000);
  mysql_reset();

  //Crer tabla de ticket, 3200 bytes paquetes de 64 maximo
  mysql_create_new(tableTicketTPV, "ticket&1", 3200);
  //for(tam = 0; tam < sizeof(ticketTPV); tam++)
    //mysql_write(tableTicketTPV, "ticket", -1, ticketTPV[tam], true);
  usart_write_text("Tabla ticket TPV: ");
  longtostr(myTable.size, msjConst);
  usart_write_line(msjConst);

  //Crer tabla de ticket, 3200 bytes paquetes de 64 maximo
  mysql_create_new(tableTicketEXP, "ticket&1", 3200);
  usart_write_text("Tabla ticket EXP: ");
  longtostr(myTable.size, msjConst);
  usart_write_line(msjConst);

  //Crear tabla de pensionados
  mysql_create_new(tablePensionados, "id&4\nvigencia&1\nestatus&1", 1000);
  usart_write_text("Tabla pensionados: ");
  longtostr(myTable.size, msjConst);
  usart_write_line(msjConst);

  //Crear tabla de tarjeta por cobro
  mysql_create_new(tablePrepago, "id&4\nnip&4\nestatus&1\ndate&13\nsaldo&4", 100);
  usart_write_text("Tabla prepago: ");
  longtostr(myTable.size, msjConst);
  usart_write_line(msjConst);

  //Crear tabla de soporte
  mysql_create_new(tableSoporte, "id&4", 5);
  usart_write_text("Tabla soporte: ");
  longtostr(myTable.size, msjConst);
  usart_write_line(msjConst);

  //Crear tabla de eventos CAN, 20 modulos + final de cadena
  mysql_create_new(tableEventosCAN,"registro&40\nmodulos&21\nestatus&1", 100);
  for(tam = 0; tam < 100; tam++)
    mysql_write_roundTrip(tableEventosCAN, eventosEstatus, "0", 1); //No enviar
  usart_write_text("Tabla eventos can: ");
  longtostr(myTable.size, msjConst);
  usart_write_line(msjConst);

  //Crea tabla de eventos tcp
  mysql_create_new(tableEventosTCP, "registro&40\nestatus&1", 100);
  for(tam = 0; tam < 100; tam++)
    mysql_write_roundTrip(tableEventosTCP, eventosEstatus, "0", 1); //No enviar
  usart_write_text("Tabla eventos TCP: ");
  longtostr(myTable.size, msjConst);
  usart_write_line(msjConst);

  //Tabla eventos key nip, circular
  mysql_create_new(tableKeyOutNip,"nip&4\ndate&13\nestatus&1", 50);
  for(tam = 1; tam <= 50; tam++)
    mysql_write(tableKeyOutNip, eventosEstatus, tam, '0', true); //No enviar
  usart_write_text("Tabla key nips: ");
  longtostr(myTable.size, msjConst);
  usart_write_line(msjConst);

  //Tabla eventos key date, circular
  mysql_create_new(tableKeyOutDate,"date&13\n", 50);
  for(tam = 1; tam <= 50; tam++)
    mysql_write_string(tableKeyOutDate, keyOutDate, tam, "", true); //Fecha vacia
  usart_write_text("Tabla key date: ");
  longtostr(myTable.size, msjConst);
  usart_write_line(msjConst);

  //Tabla eventos key fol, circular
  mysql_create_new(tableKeyOutFol,"folio&4\ndate&13\nestatus&1", 50);
  for(tam = 1; tam <= 50; tam++)
    mysql_write(tableKeyOutFol, eventosEstatus, tam, '0', true); //No enviar
  usart_write_text("Tabla key folios: ");
  longtostr(myTable.size, msjConst);
  usart_write_line(msjConst);

  //Tabla folios
  mysql_create_new(tableFolio,"total&4", 1);
  mysql_write(tableFolio, folioTotal, -1, 0, true);
  usart_write_text("Tabla folio: ");
  longtostr(myTable.size, msjConst);
  usart_write_line(msjConst);

  //Tabla syncronia
  mysql_create_new(tableSyncronia, "estado&1", 1);
  mysql_write(tableSyncronia, columnaEstado, -1, false, true);
  usart_write_text("Tabla syncronia: ");
  longtostr(myTable.size, msjConst);
  usart_write_line(msjConst);

  //Tabla cupo
  mysql_create_new(tableCupo, "estado&1", 1);
  mysql_write(tableCupo, columnaEstado, -1, false, true);
  usart_write_text("Tabla cupo: ");
  longtostr(myTable.size, msjConst);
  usart_write_line(msjConst);

  //Tabla de tolerancia
  mysql_create_new(tableToleranciaOut, "tolerancia&2", 1);
  mysql_write(tableToleranciaOut, tableToleranciaOut, -1, 15*60, true);
  usart_write_text("Tabla tolerancia: ");
  longtostr(myTable.size, msjConst);
  usart_write_line(msjConst);
  
  #endif
  /****************************************************************************/
  //Tiempo para despertar el pic
  delay_ms(timeAwake);
  #ifdef debug_usart
  usart_write_line("Expendedora");
  #endif
  lcd_clean_row(1);

  lcd_out(1, 5, "Expendedora");
}
/******************************************************************************/
void expendedora_barrera(){
  static bool sensor = false;
  const char CAN_BAR[] = "BAR";
  const char BARRERA_ABIERTA[] = "OPEN";

  if(BOTON_ENTRADA1 && !sensor.B0){
    sensor.B0 = true;
    //CREAR EVENTO
    string_cpyc(bufferEeprom, CAN_TPV);
    string_addc(bufferEeprom, CAN_BAR);         //BAR
    string_addc(bufferEeprom, BARRERA_ABIERTA);
    DS1307_read(&myRTC, false);
    string_add(bufferEeprom, &myRTC.time[1]);
    //Reponde modulo
    string_addc(bufferEeprom, CAN_MODULE);
    numToHex(canId, msjConst, 1);
    string_add(bufferEeprom, msjConst);
    buffer_save_send(false, bufferEeprom);
    #ifdef debug_usart
    usart_write_line("Barrera abierta");
    #endif
    delay_ms(50);
  }else if(!BOTON_ENTRADA1 && sensor){
    sensor.B0 = false;
    delay_ms(50);
  }
  
  /*
  //Detectar coche entra o sale
  if(eSensor == 0){
    if(BOTON_ENTRADA1 == estadoSensor.B0){
      tempSensor = 0;
      eSensor++;
      lcd_chr(1,18,'B');
      //Si hubo permiso de abrirla
      if(abrirBarrera)
        return;
      //Manda evento de barrera abierta
      lcd_chr(1,19,'F');
      //CREAR EVENTO
      string_cpyc(bufferEeprom, CAN_TPV);
      string_addc(bufferEeprom, CAN_BAR);         //BAR
      string_addc(bufferEeprom, BARRERA_ABIERTA);
      DS1307_read(&myRTC, false);
      string_add(bufferEeprom, &myRTC.time[1]);
      //Reponde modulo
      string_addc(bufferEeprom, CAN_MODULE);
      numToHex(canId, msjConst, 1);
      string_add(bufferEeprom, msjConst);
      buffer_save_send(false, bufferEeprom);
      #ifdef debug_usart
      usart_write_line("Barrera abierta");
      #endif
    }
  }else if(eSensor == 1){
    if(BOTON_ENTRADA1 == !estadoSensor.B0 && tempSensor >= timeSensor){
      tempSensor = 0;
      eSensor++;
      lcd_chr(1,18,' ');
      lcd_chr(1,19,' ');
      delay_ms(50);  //Estabiliza la se�al
    }
  }else if(eSensor == 2){  //Reiniciar ciclo del sensado
    if(tempSensor >= timeSensor){
      abrirBarrera = false;
      eSensor = 0;
    }
  }
  */
}
/******************************************************************************/
void expendedora_temporizadores(){
  static char isCanConect = -1;
  
  if(flagSecondTMR3){
    flagSecondTMR3 = false;
    can_heartbeat();              //Envia heartbeat
    tempSensor++;
    
    //Otros datos
    if(isCanConect != can.conected){
      #ifdef debug_usart
      usart_write_text("Conexion CAN: ");
      usart_write_line(can.conected? "Conectado":"Desconectado");
      #endif
      isCanConect = can.conected;
    }
    //Mostrar hora
    DS1307_Read(&myRTC,true);
    string_cpyn(msjConst, &myRTC.time[2], 8);
    lcd_out(4, 2, msjConst);
    string_cpyn(msjConst, &myRTC.time[11], 8);
    lcd_out(4, 12, msjConst);
    //Refrecar lcd por evento de lcd
    if(limpiarLCD){
      if(++tempLCD >= 5){
        limpiarLCD = false;
        tempLCD = 0;
        lcd_clean_row(1);
        lcd_clean_row(2);
        lcd_clean_row(3);
        lcd_clean_row(4);
        lcd_out(1, 5, "Expendedora");
        //Anexar los sensores listos
        if(BOTON_ENTRADA1)
          lcd_chr(1,18,'B');
        if(SENSOR_COCHE)
          lcd_chr(1,20,'C');
      }
    }
  }
}
/******************************************************************************/
void expendedora_checkTarjeta(){
  //CONSTANTES DE ACCESO
  const char ACCESO_DENEGADO[] = "NNNN";  //ACCESO DENEGADO
  const char VIGENTE = 'V';
  const char ESTATUS_PAS = CAN_MODULE[0] == 'E'? 'O':'I';//MODULE E � V, ESTADO PARA SALIR O ENTRRAR
  const char ESTATUS_MOD = CAN_MODULE[0] == 'E'? 'I':'O';//MODULE E � V, EVENTO GENERADO POR ENTRAR O SALIR
  const char ESTATUS_BREAK = '-';
  const char ESTATUS_NOT = 'N';
  //EVENTOS PARA EL TPV
  const char TPV_NO_VIGENCIA = 'V';
  const char TPV_PASSBACK = 'P';
  const char TPV_ACCESO = 'A';
  const char TPV_DESCONOCIDO = 'D';
  const char TPV_SIN_SALDO = 'S';
  const char TPV_OUT_TIME = 'T';
  //VARIABLES
  static bool buscarID = false, buscarNIP = false;
  static int fila;         //Fila repcionada
  static int nip;          //Nip teclado
  static long id;          //Tarjeta fisica
  char vigencia, estatus;  //Estatus del pensionado[V/N] y del coche[I/O]
  char acceso[5];          //Acceso: accedio + passback + vigencia + conocido
  long saldo;              //Saldo
  //Para nip de entrada
  long seconds;            //Segundos actuales
  char fecha[13];          //Fecha guardada
  bool isOtherToday;       //No es la fecha de hoy
  
  //Recibir protocolo wiegand
  if(wiegand26_read_card(&id)){
    limpiarLCD = true;
    tempLCD = 0;
    if(!buscarID && !buscarNIP)
      buscarID = true;
    lcd_clean_row(1);
    lcd_out(1, 1, "CARD: ");
    longtostr(id, msjConst);
    lcd_out(1, sizeof("CARD: "), msjConst);
    #ifdef debug_usart
    usart_write_text("CARD: ");
    longtostr(id, msjConst);
    usart_write_line(msjConst);
    #endif
  }else if(wiegand26_read_nip(&nip)){
    limpiarLCD = true;
    tempLCD = 0;
    if(!buscarID && !buscarNIP)
      buscarNIP = true;
    lcd_clean_row(1);
    lcd_out(1, 1, " NIP: ");
    numToString(nip, msjConst, 4);
    //longtostr(nip, msjConst);
    lcd_out(1, sizeof(" NIP: "), msjConst);
    #ifdef debug_usart
    usart_write_text("NIP: ");
    longtostr(nip, msjConst);
    usart_write_line(msjConst);
    #endif
  }
  
  //Abrir si es tarjeta soporte tecnico
  if(buscarID){
    if(!mysql_search(tableSoporte, soporteID, id, &fila)){
      /*
      //Abrir barrera
      eSensor = 0;  //Reiniciar maquina de estados
      abrirBarrera = true;
      SALIDA_RELE1 = 1;
      SALIDA_RELE2 = 1;
      timer1_reset();
      timer1_enable(true);
      */
      usart_write_line("Card soport block");
      lcd_clean_row(3);
      lcd_out(3,1,"Tarjeta bloqueada");
      buscarID = false;
      /*
      //Enviar mensaje al TPV
      string_cpyc(canCommand, CAN_TPV);
      string_addc(canCommand, CAN_SOPORTE);       //SOP
      numToHex(id, msjConst, 3);
      string_add(canCommand, msjConst);           //IDX + RFID(HEX)
      DS1307_read(&myRTC, false);
      string_add(canCommand, &myRTC.time[1]);     //IDX + ID(HEX) + DATE
      //Reponde modulo
      string_addc(canCommand, CAN_MODULE);
      numToHex(canId, msjConst, 1);
      string_add(canCommand, msjConst);
      buffer_save_send(true, canCommand);
      */
    }
  }

  //No generar evento si no hay coche
  if(!SENSOR_COCHE){
    if(buscarNIP || buscarID){
      buscarNIP = false;
      buscarID = false;
      lcd_clean_row(3);
      lcd_out(3,1,"No se detecta auto");
    }
  }
  
  //Busquedas por id
  if(buscarID){
    buscarID = false;
    //Obtener los datos para ser enviados
    DS1307_read(&myRTC, false);
    //Enviar mensaje al TPV
    string_cpyc(canCommand, CAN_TPV);
    string_addc(canCommand, CAN_IDX);       //IDX
    numToHex(id, msjConst, 3);
    string_add(canCommand, msjConst);       //IDX + RFID(HEX)
    string_add(canCommand, &myRTC.time[1]); //IDX + ID(HEX) + DATE
    //Copiar evento
    string_cpyc(acceso, ACCESO_DENEGADO);   //Sin Acceso, Sin vigencia, no passback, desconocida id
    
    //Buscamos pensionados
    if(!mysql_search(tablePensionados, pensionadosID, id, &fila)){
      //Replace cadena
      canCommand[3] = CAN_PENSIONADO[0];
      canCommand[4] = CAN_PENSIONADO[1];
      canCommand[5] = CAN_PENSIONADO[2];
      //Leo los estatus del usuario
      mysql_read_string(tablePensionados, pensionadosVigencia, fila, &vigencia);
      mysql_read_string(tablePensionados, pensionadosEstatus, fila, &estatus);
      //acceso[0] = '-';    //Acceso
      //acceso[1] = '-';    //Vigencia
      //acceso[2] = '-';    //Passback
      //acceso[3] = '-';    //Tarjeta desconocida

      //Vericamos los estados del passback y vigencia
      if(vigencia == VIGENTE && (estatus == ESTATUS_PAS || estatus == ESTATUS_BREAK || !canSynchrony || !can.conected)){
        //Permiso para abrir la barrera
        eSensor = 0;  //Reiniciar maquina de estados
        abrirBarrera = true;
        SALIDA_RELE1 = 1;
        SALIDA_RELE2 = 1;
        timer1_reset();
        timer1_enable(true);
        acceso[0] = TPV_ACCESO;     //Acceso

        if(!can.conected || !canSynchrony || estatus == ESTATUS_BREAK)
          acceso[2] = ESTATUS_BREAK;   //Estado del passback roto
        //Actualizar estado de la tabla
        estatus = (!can.conected || !canSynchrony)? ESTATUS_BREAK:ESTATUS_MOD;
        mysql_write(tablePensionados, pensionadosEstatus, fila, estatus, false);
        lcd_clean_row(2);
        lcd_out(2, 1, "Acceso aceptado");
        #ifdef debug_usart
        usart_write_line("Pensionado aceptado: ");
        usart_write(estatus);
        usart_write_line("");
        #endif
      }else{
        if(vigencia == ESTATUS_NOT){
          acceso[1] = TPV_NO_VIGENCIA;    //Vigencia
          lcd_clean_row(2);
          lcd_out(2, 1, "Vigencia terminada");
          #ifdef debug_usart
          usart_write_line("Vigencia terminada");
          #endif
        }else if(estatus == ESTATUS_MOD){
          acceso[2] = TPV_PASSBACK;   //Estado del passback
          lcd_clean_row(2);
          lcd_out(2,1,"Passback activo");
          #ifdef debug_usart
          usart_write_line("Passback activo del pensionado");
          #endif
        }
      }
      //Copiar el contenido del acceso
      string_add(canCommand, acceso);
      //GUARDAR EVENTO DEL CAN-PASSBACK: PEN+ID(HEX)+COMAND+FILA+CONTENIDO
      string_cpyc(bufferEeprom, CAN_PENSIONADO);
      numTohex(id, msjConst, 3);
      string_add(bufferEeprom, msjConst);
      string_addc(bufferEeprom, CAN_PASSBACK);   //CODIGO DE ACCION
      numToString(fila, msjConst, 4);
      string_add(bufferEeprom, msjConst);
      //ENVIAR VALOR DEL PASSBAK O ESTADO DEL COCHE
      msjConst[0] = estatus;
      msjConst[1] = 0;
      string_add(bufferEeprom, msjConst);
      //Guardo en el buffer
      buffer_save_send(true, bufferEeprom);
    }else if(!mysql_search(tablePrepago, pensionadosID, id, &fila)){
      //Replace cadena
      canCommand[3] = CAN_PREPAGO[0];
      canCommand[4] = CAN_PREPAGO[1];
      canCommand[5] = CAN_PREPAGO[2];

      //Vericamos los estados del saldo y pasback
      mysql_read_string(tablePrepago, prepagoEstatus, fila, &estatus);
      mysql_read(tablePrepago, prepagoSaldo, fila, &saldo);
      if(saldo >= 3600 && (estatus == ESTATUS_PAS || estatus == ESTATUS_BREAK || !canSynchrony || !can.conected)){
        //Permiso para abrir la barrera
        eSensor = 0;  //Reiniciar maquina de estados
        abrirBarrera = true;
        SALIDA_RELE1 = 1;
        SALIDA_RELE2 = 1;
        timer1_reset();
        timer1_enable(true);
        acceso[0] = TPV_ACCESO;     //Acceso
        
        if(!can.conected || !canSynchrony || estatus == ESTATUS_BREAK)
          acceso[2] = ESTATUS_BREAK;   //Estado del passback roto
        //Actualizar estado de la tabla
        estatus = (!can.conected || !canSynchrony)? ESTATUS_BREAK:ESTATUS_MOD;
        mysql_write(tablePrepago, prepagoEstatus, fila, estatus, false);
        lcd_clean_row(2);
        lcd_out(2,1,"Acceso aceptado");
        #ifdef debug_usart
        usart_write_line("Prepago aceptado: ");
        usart_write(estatus);
        usart_write_line("");
        #endif
      }else{
        if(saldo < 3600){
          acceso[1] = TPV_SIN_SALDO;  //Sin saldo
          lcd_clean_row(2);
          lcd_out(2,1,"Saldo terminado");
          #ifdef debug_usart
          usart_write_line("Saldo terminado");
          #endif
        }else if(estatus == ESTATUS_MOD){
          acceso[2] = TPV_PASSBACK;   //Estado del passback
          lcd_clean_row(2);
          lcd_out(2,1,"Passback activo");
          #ifdef debug_usart
          usart_write_line("Passback activo prepago");
          #endif
        }
      }
      //Copiar el contenido del acceso
      string_add(canCommand, acceso);
      //GUARDAR EVENTO DEL CAN-SALDO: PRE+ID(HEX)+COMAND+FILA+CONTENIDO
      string_cpyc(bufferEeprom, CAN_PREPAGO);
      numTohex(id, msjConst, 3);
      string_add(bufferEeprom, msjConst);
      if(acceso[0] == TPV_ACCESO)
        string_addc(bufferEeprom, CAN_SPECIAL_DATE);   //CODIGO DE ACCION
      else
        string_addc(bufferEeprom, CAN_PASSBACK);
      numToString(fila, msjConst, 4);
      string_add(bufferEeprom, msjConst);
      //ENVIAR VALOR DEL PASSBAK O ESTADO DEL COCHE
      msjConst[0] = estatus;
      msjConst[1] = 0;
      string_add(bufferEeprom, msjConst);
      //ENVIAR FECHA
      DS1307_read(&myRTC, false);
      string_add(bufferEeprom, &myRTC.time[1]);
      //Guardo en el buffer
      buffer_save_send(true, bufferEeprom);
    }else{
      lcd_clean_row(2);
      lcd_out(2,1,"Tarjeta desconocida");
      #ifdef debug_usart
      usart_write_line("Tarjeta no registrada");
      #endif
      //Tarjeta desconocida
      acceso[3] = TPV_DESCONOCIDO;      //Tarjeta desconocida
      string_add(canCommand, acceso);
    }
    //Reponde modulo
    string_addc(canCommand, CAN_MODULE);
    numToHex(canId, msjConst, 1);
    string_add(canCommand, msjConst);
    buffer_save_send(false, canCommand);
  }else if(buscarNIP){
    buscarNIP = false;
    //Obtener los datos para ser enviados
    DS1307_read(&myRTC, false);
    //CREAR EVENTO DEL TPV
    string_cpyc(canCommand, CAN_TPV);
    string_addc(canCommand, CAN_NIP);       //NIP
    numToString(nip, msjConst, 4);
    string_add(canCommand, msjConst);       //NIP + NIP(DEC)
    string_add(canCommand, &myRTC.time[1]); //NIP + NIP(DEC) + DATE
    //Control de acceso
    string_cpyc(acceso, ACCESO_DENEGADO);   //sin acceso, sin Saldo, sin passback, desconocida nip
    
    //Buscamos si existe en la tabla de prepago
    if(!mysql_search(tablePrepago, prepagoNip, nip, &fila)){
      //Vericamos los estados del saldo y pasback
      mysql_read_string(tablePrepago, prepagoEstatus, fila, &estatus);
      mysql_read(tablePrepago, prepagoSaldo, fila, &saldo);
      mysql_read(tablePrepago, prepagoID, fila, &id);
      //Evaluar caso
      if(saldo >= 3600 && (estatus == ESTATUS_PAS || estatus == ESTATUS_BREAK || !canSynchrony || !can.conected)){
        //Abrir barrera
        eSensor = 0;  //Reiniciar maquina de estados
        abrirBarrera = true;
        SALIDA_RELE1 = 1;
        SALIDA_RELE2 = 1;
        timer1_reset();
        timer1_enable(true);
        //Reportar que entro el auto
        acceso[0] = TPV_ACCESO;    //Acceso
        
        if(!can.conected || !canSynchrony || estatus == ESTATUS_BREAK)
          acceso[2] = ESTATUS_BREAK;   //Estado del passback roto
        //Actualizar estado de la tabla
        estatus = (!can.conected || !canSynchrony)? ESTATUS_BREAK:ESTATUS_MOD;
        mysql_write(tablePrepago, prepagoEstatus, fila, estatus, false);
        lcd_clean_row(2);
        lcd_out(2,1,"Acceso aceptado");
        #ifdef debug_usart
        usart_write_line("Prepago aceptado por nip: ");
        usart_write(estatus);
        usart_write_line("");
        #endif
      }else{
        if(saldo < 3600){
          acceso[1] = TPV_SIN_SALDO;  //Sin saldo
          lcd_clean_row(2);
          lcd_out(2,1,"Saldo agotado");
          #ifdef debug_usart
          usart_write_line("Saldo terminado");
          #endif
        }else if(estatus == ESTATUS_MOD){
          acceso[2] = TPV_PASSBACK;   //Estado del passback
          lcd_clean_row(2);
          lcd_out(2,1,"Passback activo");
          #ifdef debug_usart
          usart_write_line("Passback activo prepago");
          #endif
        }
      }
      //Copiar el contenido del acceso
      string_add(canCommand, acceso);
      //GUARDAR EVENTO DEL CAN-SALDO: PRE+ID(HEX)+COMAND+FILA+CONTENIDO
      string_cpyc(bufferEeprom, CAN_PREPAGO);
      numTohex(id, msjConst, 3);
      string_add(bufferEeprom, msjConst);
      if(acceso[0] == TPV_ACCESO)
        string_addc(bufferEeprom, CAN_SPECIAL_DATE);   //CODIGO DE ACCION
      else
        string_addc(bufferEeprom, CAN_PASSBACK);
      numToString(fila, msjConst, 4);
      string_add(bufferEeprom, msjConst);
      //ENVIAR VALOR DEL PASSBAK O ESTADO DEL COCHE
      string_push(bufferEeprom, estatus);
      //ENVIAR FECHA
      DS1307_read(&myRTC, false);
      string_add(bufferEeprom, &myRTC.time[1]);
      //Guardo en el buffer
      buffer_save_send(true, bufferEeprom);
    }else if(!mysql_search_forced(tableKeyOutNip, keyOutNip, nip, &fila)){
      //Replace cadena
      canCommand[3] = CAN_KEY[0];
      canCommand[4] = CAN_KEY[1];
      canCommand[5] = CAN_KEY[2];
      mysql_read_forced(tableKeyOutNip, keyOutEstatus, fila, &estatus);
      mysql_read_forced(tableKeyOutNip, keyOutDate, fila, fecha);
      fecha[12] = 0; //Agregar final de cadena, proteccion
      DS1307_read(&myRTC, false);
      //Mensajes
      #ifdef debug_usart
      usart_write_text("Fecha registro: ");
      usart_write_line(fecha);
      usart_write_text("Fecha salida: ");
      usart_write_line(&myRTC.time[1]);
      #endif
      //Obtener la diferencia entre tiempo de entrada y salida
      string_cpyn(msjConst, &myRTC.time[1], 6);
      seconds = DS1307_getSeconds(msjConst);
      string_cpyn(msjConst, fecha, 6);
      seconds -= DS1307_getSeconds(msjConst);
      seconds = clamp(seconds, 0, TOLERANCIA_OUT); //Saturar en este rango

      //Verificar que la fecha concuerde
      string_cpy(msjConst, &myRTC.time[1]);
      isOtherToday = !string_cmpn(&msjConst[6], &fecha[6], 2);
      isOtherToday |= !string_cmpn(&msjConst[8], &fecha[8], 2);
      isOtherToday |= !string_cmpn(&msjConst[10], &fecha[10], 2);

      //Leer si la llave no fue usada
      if(estatus == '1' && seconds < TOLERANCIA_OUT && !isOtherToday){
        //Permiso para abrir la barrera
        eSensor = 0;  //Reiniciar maquina de estados
        abrirBarrera = true;
        SALIDA_RELE1 = 1;
        SALIDA_RELE2 = 1;
        timer1_reset();
        timer1_enable(true);
        //Reportar que entro el auto
        acceso[0] = TPV_ACCESO;    //Acceso
        //if(!can.conected || !canSynchrony || estatus == ESTATUS_BREAK)
          //acceso[2] = ESTATUS_BREAK;   //Estado del passback roto
        //Borrar el registro de salida, posiblemente fecha
        mysql_write_forced(tableKeyOutNip, keyOutEstatus, fila, "0", 1);
        lcd_clean_row(2);
        lcd_out(2,1,"NIP aceptado");
        #ifdef debug_usart
        usart_write_text("Se encontro el nip(key) salida: ");
        longtostr(nip, msjConst);
        usart_write_line(msjConst);
        #endif
      }else if(estatus == '0'){
        acceso[2] = TPV_PASSBACK;   //Llave ya utilizada
        lcd_clean_row(2);
        lcd_out(2,1,"NIP desconocido*");
        #ifdef debug_usart
        usart_write_text("Llave ya utilizada");
        longtostr(nip, msjConst);
        usart_write_line(msjConst);
        #endif
      }else if(isOtherToday || seconds >= TOLERANCIA_OUT){
        acceso[1] = TPV_OUT_TIME;  //FECHA EN FUERA DE RANGO
        lcd_clean_row(2);
        lcd_out(2,1,"NIP invalido*");
        #ifdef debug_usart
        usart_write_line(isOtherToday?"Llave de otro dia":"Tiempo agotado");
        #endif
      }
      //Copiar el contenido del acceso
      string_add(canCommand, acceso);
    }else{
      lcd_clean_row(2);
      lcd_out(2,1,"Nip descnocido");
      #ifdef debug_usart
      usart_write_line("NIP descnocido");
      #endif
      acceso[3] = TPV_DESCONOCIDO;
      string_add(canCommand,acceso);
    }
    //Reponde modulo
    string_addc(canCommand, CAN_MODULE);
    numToHex(canId, msjConst, 1);
    string_add(canCommand, msjConst);
    buffer_save_send(false, canCommand);
  }
}
/******************************************************************************/
void expendedora_imprimir(){  
  const char convenio[] = "11";
  static bool btnCoche = false;
  static char imprimir = 0x00;  //Dos estados para desactivar la impresion
  static char tiempoEvento[20];
  
  //Detectar coche entra o sale
  if(SENSOR_COCHE && !btnCoche){
    btnCoche = true;
    lcd_chr(1,20,'C');
    //CREAR EVENTO DEL COCHE
    string_cpyc(bufferEeprom, CAN_TPV);
    string_addc(bufferEeprom, CAN_COCHE_IN);
    DS1307_read(&myRTC, false);
    string_add(bufferEeprom, &myRTC.time[1]);
    //Reponde modulo
    string_addc(bufferEeprom, CAN_MODULE);
    numToHex(canId, msjConst, 1);
    string_add(bufferEeprom, msjConst);
    buffer_save_send(false, bufferEeprom);
    #ifdef debug_usart
    usart_write_line("Coche presente");
    #endif
  }else if(!SENSOR_COCHE && btnCoche){
    btnCoche = false;
    lcd_chr(1,20,' ');
    //CREAR EVENTO DEL COCHE
    string_cpyc(bufferEeprom, CAN_TPV);
    string_addc(bufferEeprom, CAN_COCHE_OUT);
    DS1307_read(&myRTC, false);
    string_add(bufferEeprom, &myRTC.time[1]);
    //Reponde modulo
    string_addc(bufferEeprom, CAN_MODULE);
    numToHex(canId, msjConst, 1);
    string_add(bufferEeprom, msjConst);
    buffer_save_send(false, bufferEeprom);
    #ifdef debug_usart
    usart_write_line("Coche saliendo");
    #endif
  }
  
  //Imprimir ticket si oprimio el otro boton
  if(BOTON_IMPRIMIR){
    if(!imprimir && SENSOR_COCHE){
      limpiarLCD = true;
      tempLCD = 0;
    
      if(cupoLleno){
        lcd_clean_row(1);
        lcd_out(3,1,"Cupo lleno");
        #ifdef debug_usart
        usart_write_line("Cupo lleno");
        #endif
        return;
      }
      //Imprimir ticket
      imprimir = 0x03;      //Imprimiendo y esperar se�al en bajo
      lcd_clean_row(3);
      lcd_out(3,1,"Imprimendo...");
      #ifdef debug_usart
      usart_write_line("Imprimiendo boleto");
      #endif
      //Obtiene las variables para la impresion del ticket
      folio = clamp_shift(++folio, 1, 9999999); //FORMATO DE 7 DIGITOS
      numToString(folio, ticketFolio, 7);
      DS1307_read(&myRTC, true);                //Obtiene la hora actual
      string_cpy(ticketTime, &myRTC.time[2]);
      //CODIGO DE BARRAS AUXILIAR PARA LA EXPENDEDORA PARTICULAR
      DS1307_read(&myRTC, false);                //Obtiene la hora actual
      string_cpy(ticketCodigo, &myRTC.time[1]);  //B:13, W-HH:MM:SS DD/MT/YY
      string_cpy(tiempoEvento, &myRTC.time[1]);
      //Codigo particular
      string_pop(ticketCodigo);
      string_pop(ticketCodigo);
      numToString(myRTC.year, msjConst, 3);
      string_add(ticketCodigo, msjConst);
      string_push(ticketCodigo, '1');
      string_add(ticketCodigo, ticketFolio);     //B:7
      string_addc(ticketCodigo, convenio);
      //string_addc(ticketCodigo, CAN_MODULE);
      //numToHex(can.id, msjConst, 1);
      //string_add(ticketCodigo, msjConst);
      //string_addc(ticketCodigo, convenio);      //B:2
      encrypt_basic(ticketCodigo);
      
      //Guardar folio
      mysql_write(tableFolio, folioTotal, 1, folio, false);
      #ifdef debug_usart
      usart_write_text("Ticket: ");
      usart_write_line(ticketCodigo);
      #endif
    }
  }
  
  //Imprimir boleto por tiempo
  if(imprimir){
    //Imprimiendo por pausas
    if(imprimir.B0){
      if(expendedora_ticket()){
        imprimir.B0 = false;
        lcd_clean_row(3);
        lcd_out(3, 4, "Tome su boleto");
        #ifdef debug_usart
        usart_write_line("Boleto impreso");
        #endif
        //Abrir barrera una vez impreso el boleto
        eSensor = 0;  //Reiniciar maquina de estados
        abrirBarrera = true;
        SALIDA_RELE1 = 1;
        SALIDA_RELE2 = 1;
        timer1_reset();
        timer1_enable(true);
        //Enviar por can el dato
        string_cpyc(canCommand, CAN_TPV);      //TPV
        string_addc(canCommand, CAN_FOL);      //FOL
        numToHex(folio, ticketFolio, 4);
        string_add(canCommand, ticketFolio);   //FOL + FOL(HEX)
        //DS1307_date(&myRTC, false);
        //string_add(canCommand, &myRTC.time[1]);//FOL + FOL(HEX) + DATE
        string_add(canCommand, tiempoEvento);
        string_addc(canCommand, CAN_MODULE);   //FOL + FOL(HEX) + DATE + E
        numToHex(canId, msjConst, 1);          //CONVIERTE EL NODO EN NUM
        string_add(canCommand, msjConst);      //FOL + FOL(HEX) + DATE + E + ID(HEX)
        //Enviar por TPV el evento
        buffer_save_send(false, canCommand);
      }
    }
    //Si coche no es dectado permite reimpresion
    if(imprimir.B1){
      if(!SENSOR_COCHE){
        imprimir.B1 = false;
        delay_ms(50);        //Posible delay por los sensores
      }
    }
  }
}
/******************************************************************************/
bool expendedora_ticket(){
  static unsigned int puntero = 0;  //Direccion del address
  char buffer[64+1];    //Final de cadena
  char cont = 0;

  //IMPRIME EL BOLETO POR PARTES
  cont = 0;
  /*
  if(!mysql_read_string(tableTicket, "ticket", 1, &buffer[cont])){
    eeprom_i2c_read(myTable.addressAct+puntero, buffer, sizeof(buffer)-1);

    //Analizo si donde queda el final de cadena
    for(cont = sizeof(buffer)-1; cont > 0; cont--){
      if(buffer[cont] == '\n' || puntero == myTable.rowAct){
        puntero += ++cont;
        break;
      }
    }
  }*/
  
  while(ticket[puntero] != 0){
    buffer[cont++] = ticket[puntero++];

    if(buffer[cont-1] == '\n')
      break;
  }
  
  buffer[cont] = 0;
  //Escribe por uart
  impresoraTerm_writeDinamicText(buffer, ticketAddr);

  //Verifica si termino de imprimir
  if(ticket[puntero] == 0/*puntero == myTable.rowAct-1 || puntero == myTable.rowAct*/){
    puntero = 0;
    return true;
  }
  
  return false;
}
/******************************************************************************/
void expendedora_bufferEventos(){
  //Enviar datos cada Xms para no saturar la linea
  char estatus;
  
  //Si buffer esta vacio o desconectado
  if(!pilaBufferCAN || !can.conected)
    return;

  //Si esta libre el puerto can
  if(!can.txQueu && !can.rxBusy && !modeBufferEventos){
    //Busca elemento de la fila hacer enviado
    if(!mysql_read_forced(tableEventosCAN, eventosEstatus, pilaBufferPointer, &estatus)){
      //Busqueda
      #ifdef debug_usart
      usart_write_text("Pila: ");
      inttostr(pilaBufferCAN,msjConst);
      usart_write_text(msjConst);
      usart_write_text(" ,Buscando fila: ");
      inttostr(pilaBufferPointer, msjConst);
      usart_write_line(msjConst);
      #endif
      if(estatus == '1'){  //Data no enviada
        mysql_read_string(tableEventosCAN, eventosRegistro, pilaBufferPointer, bufferEeprom);
        //Vacia hacia el buffer
        if(can_write_text(can.ip+canIdTPV, bufferEeprom, 0)){
          modeBufferEventos = true;
        }
        #ifdef debug_usart
        usart_write_text("Fila: ");
        inttostr(pilaBufferPointer, msjConst);
        usart_write_text(msjConst);
        usart_write_text(", ");
        usart_write_text("Se envia: ");
        usart_write_line(bufferEeprom);
        #endif
        return;
      }
    }
    //Apuntar a la fila siguiente
    pilaBufferPointer = clamp_shift(++pilaBufferPointer, 1, myTable.row);
  }
}
/******************************************************************************/
/********************************** OTHERS ************************************/
/******************************************************************************/
void lcd_clean_row(char fila){
  char i = 20;

  while(i)
    lcd_chr(fila, i--, ' ');
}
/******************************************************************************/
void can_user_read_message(){
  //Mensaje de respuesta al TPV
  const char FILAS_ACTUALES[] = "FR:";
  const char FILAS_PROG[] = "FP:";
  char sizeKey, sizeTotal;
  int fila;
  char vigencia, estatus;
  long idConsulta, idNew, id;
  long nip, saldo, auxNip;
  
  //Se recibe dato por can
  #ifdef debug_usart
  usart_write_text("Se recibe can: ");
  usart_write_line(can.rxBuffer);
  #endif
  limpiarLCD = true;
  tempLCD = 0;
  lcd_clean_row(3);
  lcd_out(3,17,"MSG");

  //Verifica que sea comando dirigido hacia mi
  sizeTotal = 0;
  sizeKey = sizeof(CAN_PENSIONADO)-1;  //PENSIONADO: PEN+ID(HEX)+CMD+FILA+MENSAJE
  if(string_cmpnc(CAN_PENSIONADO, &can.rxBuffer[sizeTotal], sizeKey)){
    //OBTENER EL ID
    sizeTotal += sizeKey;
    sizeKey = 6;  //3 Bytes en hexadecimal
    string_cpyn(msjConst, &can.rxBuffer[sizeTotal], sizeKey);
    idConsulta = hexToNum(msjConst);
    //Obtiene el tipo de evento a ejecutar
    sizeTotal += sizeKey;
    sizeKey = sizeof(CAN_REGISTRAR)-1;  //COMANDO 3BYTES
    //OBTENER LA FILA
    string_cpyn(msjConst, &can.rxBuffer[sizeTotal+sizeKey], 4); //4 numeros fila
    fila = stringToNum(msjConst);
    //VERIFICAR LOS CAMANDOS
    if(string_cmpnc(CAN_REGISTRAR, &can.rxBuffer[sizeTotal], sizeKey)){
      //OFFSET DE LA FILA
      sizeTotal += sizeKey;
      sizeKey = 4;  //4 POR LA FILA
      //FORMATO: PEN+ID(HEX)+REG+FILA+V+O
      idNew = idConsulta;
      //Obtener la vigencia
      sizeTotal += sizeKey;
      sizeKey = 1;  //1 Byte
      vigencia = can.rxBuffer[sizeTotal];
      //Obtiene el status del coche
      sizeTotal += sizeKey;
      sizeKey = 1;  //1 Byte
      estatus = can.rxBuffer[sizeTotal];
      //VERIFICA QUE NO HAYA SIDO REGISTRADO
      if(mysql_read(tablePensionados, pensionadosID, fila, &id) == TABLE_RW_NO_EXIST_ROW){
        if(fila == myTable.rowAct+1){
          if(!mysql_write(tablePensionados, pensionadosID, -1, idNew, true)){
            #ifdef debug_usart
            usart_write_line("Pensionado registrado");
            #endif
            mysql_write(tablePensionados, pensionadosID, fila, idNew, false);
            mysql_write(tablePensionados, pensionadosVigencia, fila, vigencia, false);
            mysql_write(tablePensionados, pensionadosEstatus, fila, estatus, false);
          }
        }
      }
    }else if(string_cmpnc(CAN_ACTUALIZAR, &can.rxBuffer[sizeTotal], sizeKey)){
      //OFFSET DE LA FILA
      sizeTotal += sizeKey;
      sizeKey = 4;  //4 POR LA FILA
      //FORMATO: PEN+ID(HEX)+ACT+FILA+IDNEW(HEX)+VIGENCIA+ESTATUS
      sizeTotal += sizeKey;
      sizeKey = 6;  //3 Bytes en hexadecimal
      string_cpyn(msjConst, &can.rxBuffer[sizeTotal], sizeKey);
      idNew = hexToNum(msjConst);
      //Obtiene la vigencia
      sizeTotal += sizeKey;
      sizeKey = 1;  //1 Byte
      vigencia = can.rxBuffer[sizeTotal];
      //Obtiene el status del coche
      sizeTotal += sizeKey;
      sizeKey = 1;  //1 Byte
      estatus = can.rxBuffer[sizeTotal];
      
      //Busca la fila y actualiza el id, vigencia y estatus
      if(!mysql_read(tablePensionados,pensionadosID, fila, &id)){
        if(id == idConsulta){
          #ifdef debug_usart
          usart_write_line("Pensionado actualizado");
          #endif
          mysql_write(tablePensionados, pensionadosID, fila, idNew, false);
          mysql_write(tablePensionados, pensionadosVigencia, fila, vigencia, false);
          mysql_write(tablePensionados, pensionadosEstatus, fila, estatus, false);
        }
      }
    }else if(string_cmpnc(CAN_VIGENCIA, &can.rxBuffer[sizeTotal], sizeKey)){
      //OFFSET DE LA FILA
      sizeTotal += sizeKey;
      sizeKey = 4;  //4 POR LA FILA
      //FORMATO: PEN+ID(HEX)+VIG+FILA+V/N
      sizeTotal += sizeKey;
      sizeKey = 1;  //1 Byte
      vigencia = can.rxBuffer[sizeTotal];
      //Busca la fila y actualiza el id, vigencia
      if(!mysql_read(tablePensionados,pensionadosID, fila, &id)){
        if(id == idConsulta){
          #ifdef debug_usart
          usart_write_line("Pensionado vigencia");
          #endif
          mysql_write(tablePensionados, pensionadosVigencia, fila, vigencia, false);
        }
      }
    }else if(string_cmpnc(CAN_PASSBACK, &can.rxBuffer[sizeTotal], sizeKey)){
      //OFFSET DE LA FILA
      sizeTotal += sizeKey;
      sizeKey = 4;  //4 POR LA FILA
      //FORMATO: PEN+ID+PAS+FILA+ESTATUS
      sizeTotal += sizeKey;
      sizeKey = 1;
      estatus = can.rxBuffer[sizeTotal];
      //Cambiar estatus del passback tabla
      if(!mysql_read(tablePensionados, pensionadosID, fila, &id)){
        if(id == idConsulta){
          #ifdef debug_usart
          usart_write_line("Pensionado passback");
          #endif
          mysql_write(tablePensionados, pensionadosEstatus, fila, estatus, false);
        }
      }
    }else if(string_cmpnc(CAN_CONSULTAR, &can.rxBuffer[sizeTotal], sizeKey)){
      //OFFSET DE LA FILA
      sizeTotal += sizeKey;
      sizeKey = 4;  //4 POR LA FILA
      //FORMATO: PEN+ID(HEX)+CON+FILA
      string_cpyc(bufferEeprom, CAN_TPV);
      string_cpyn(&bufferEeprom[sizeof(CAN_TPV)-1], can.rxBuffer, sizeTotal);
      if(!mysql_read(tablePensionados, pensionadosID, fila, &id)){
        if(idConsulta == id){
          #ifdef debug_usart
          usart_write_line("Pensionado consulta");
          #endif
          mysql_read_string(tablePensionados, pensionadosVigencia, fila, &vigencia);
          mysql_read_string(tablePensionados, pensionadosEstatus, fila, &estatus);
          //Enviar respuesta PEN+ID(HEX)+CON+V+O+MODULE
          string_push(bufferEeprom, vigencia);
          string_push(bufferEeprom, estatus);
          string_addc(bufferEeprom, CAN_MODULE);
          numToHex(can.id, msjConst, 1);
          string_add(bufferEeprom, msjConst);
        }else{
          string_addc(bufferEeprom, CAN_TABLE_NO_FOUND);
        }
      }else{
        string_addc(bufferEeprom, CAN_TABLE_ERROR);
      }
      //Responder consulta
      buffer_save_send(true, bufferEeprom);
    }
  }else if(string_cmpnc(CAN_RTC, &can.rxBuffer[sizeTotal], sizeKey)){
    sizeTotal += sizeKey;
    sizeKey = sizeof(CAN_TABLE_SET)-1;
    //Modifica la hora del RTC
    if(string_cmpnc(CAN_TABLE_SET, &can.rxBuffer[sizeTotal], sizeKey)){
      sizeTotal += sizeKey;
      DS1307_write_string(&myRTC,&can.rxBuffer[sizeTotal]);
      #ifdef debug_usart
      usart_write_text("RTC modificando fecha: ");
      DS1307_read(&myRTC, true);
      usart_write_line(myRTC.time);
      #endif
    }else if(string_cmpnc(CAN_TABLE_GET, &can.rxBuffer[sizeTotal], sizeKey)){
      sizeTotal += sizeKey;
      DS1307_read(&myRTC,true);
      string_cpyc(bufferEeprom, CAN_TPV);
      string_addc(bufferEeprom, CAN_RTC);
      string_addc(bufferEeprom, CAN_TABLE_GET);
      string_add(bufferEeprom, myRTC.time);
      string_addc(bufferEeprom, CAN_MODULE);
      numToHex(can.id, msjConst, 1);
      string_add(bufferEeprom, msjConst);
      buffer_save_send(true, bufferEeprom);
      #ifdef debug_usart
      usart_write_line("RTC conculta");
      #endif
    }
  }else if(string_cmpnc(CAN_PREPAGO, &can.rxBuffer[sizeTotal], sizeKey)){
    //OBTENER EL ID
    sizeTotal += sizeKey;
    sizeKey = 6;  //3 Bytes en hexadecimal
    string_cpyn(msjConst, &can.rxBuffer[sizeTotal], sizeKey);
    idConsulta = hexToNum(msjConst);
    //Obtiene el tipo de evento a ejecutar
    sizeTotal += sizeKey;
    sizeKey = sizeof(CAN_REGISTRAR)-1;  //COMANDO 3BYTES
    //OBTENER LA FILA
    string_cpyn(msjConst, &can.rxBuffer[sizeTotal+sizeKey], 4); //4 numeros fila
    fila = stringToNum(msjConst);

    //VERIFICAR LOS CAMANDOS
    if(string_cmpnc(CAN_REGISTRAR, &can.rxBuffer[sizeTotal], sizeKey)){
      //OFFSET DE LA FILA
      sizeTotal += sizeKey;
      sizeKey = 4;  //4 POR LA FILA
      //FORMATO: PRE+ID(6HEX)+REG+NIP(8HEX)+SALDO(8HEX)+ESTATUS
      idNew = idConsulta;
      //Obtener la NIP
      sizeTotal += sizeKey;
      sizeKey = 8;  //8 Byte
      string_cpyn(msjConst, &can.rxBuffer[sizeTotal], sizeKey);
      nip = hexToNum(msjConst);
      //Obtener saldo
      sizeTotal += sizeKey;
      sizeKey = 8;  //8 Byte
      string_cpyn(msjConst, &can.rxBuffer[sizeTotal], sizeKey);
      saldo = hexToNum(msjConst);
      //Obtiene el status del coche
      sizeTotal += sizeKey;
      sizeKey = 1;  //1 Byte
      estatus = can.rxBuffer[sizeTotal];
      //VERIFICA QUE NO HAYA SIDO REGISTRADO
      if(mysql_read(tablePrepago, prepagoID, fila, &id) == TABLE_RW_NO_EXIST_ROW){
        if(fila == myTable.rowAct+1){
          if(!mysql_write(tablePrepago, prepagoID, -1, idNew, true)){
            //mysql_write(tablePrepago, prepagoID, fila, idNew, false);
            mysql_write(tablePrepago, prepagoNip, fila, nip, false);
            mysql_write(tablePrepago, prepagoSaldo, fila, saldo, false);
            mysql_write(tablePrepago, prepagoEstatus, fila, estatus, false);
            mysql_write_string(tablePrepago, prepagoDate, fila, "", false);
            #ifdef debug_usart
            usart_write_line("Prepago registrado");
            #endif
          }
        }
      }
    }else if(string_cmpnc(CAN_ACTUALIZAR, &can.rxBuffer[sizeTotal], sizeKey)){
      //OFFSET DE LA FILA
      sizeTotal += sizeKey;
      sizeKey = 4;  //4 POR LA FILA
      //FORMATO: PRE+ID(6HEX)+ACT+IDNEW(8HEX)+NIP(8HEX)+SALDO(8HEX)+ESTATUS
      sizeTotal += sizeKey;
      sizeKey = 6;  //3 Bytes en hexadecimal
      string_cpyn(msjConst, &can.rxBuffer[sizeTotal], sizeKey);
      idNew = hexToNum(msjConst);
      //Obtener la NIP
      sizeTotal += sizeKey;
      sizeKey = 8;  //8 Byte
      string_cpyn(msjConst, &can.rxBuffer[sizeTotal], sizeKey);
      nip = hexToNum(msjConst);
      //Obtener saldo
      sizeTotal += sizeKey;
      sizeKey = 8;  //8 Byte
      string_cpyn(msjConst, &can.rxBuffer[sizeTotal], sizeKey);
      saldo = hexToNum(msjConst);
      //Obtiene el status del coche
      sizeTotal += sizeKey;
      sizeKey = 1;  //1 Byte
      estatus = can.rxBuffer[sizeTotal];

      //Busca la fila y actualiza
      if(!mysql_read(tablePrepago, prepagoID, fila, &id)){
        if(id == idConsulta){
          mysql_write(tablePrepago, prepagoID, fila, idNew, false);
          mysql_write(tablePrepago, prepagoNip, fila, nip, false);
          mysql_write(tablePrepago, prepagoSaldo, fila, saldo, false);
          mysql_write(tablePrepago, prepagoEstatus, fila, estatus, false);
          #ifdef debug_usart
          usart_write_line("Prepago actualizado");
          #endif
        }
      }
    }else if(string_cmpnc(CAN_CONSULTAR, &can.rxBuffer[sizeTotal], sizeKey)){
      //OFFSET DE LA FILA
      sizeTotal += sizeKey;
      sizeKey = 4;  //4 POR LA FILA
      //FORMATO: PRE+ID(HEX)+CON+FILA
      string_cpyc(bufferEeprom, CAN_TPV);
      string_cpyn(&bufferEeprom[sizeof(CAN_TPV)-1], can.rxBuffer, sizeTotal);
      if(!mysql_read(tablePrepago, prepagoID, fila, &id)){
        if(idConsulta == id){
          mysql_read(tablePrepago, prepagoNip, fila, &nip);
          mysql_read(tablePrepago, prepagoSaldo, fila, &saldo);
          mysql_read_string(tablePrepago, prepagoEstatus, fila, &estatus);
          //Enviar respuesta PRE+ID(HEX)+CON+NIP(HEX)+SALDO(HEX)+ESTATUS+MODULE
          numToHex(nip, msjConst, 4);
          string_add(bufferEeprom, msjConst);
          numToHex(saldo, msjConst, 4);
          string_add(bufferEeprom, msjConst);
          string_push(bufferEeprom, estatus);
          string_addc(bufferEeprom, CAN_MODULE);
          numToHex(can.id, msjConst, 1);
          string_add(bufferEeprom, msjConst);
          #ifdef debug_usart
          usart_write_line("Prepago consulta");
          #endif
        }else{
          string_addc(bufferEeprom, CAN_TABLE_NO_FOUND);
        }
      }
      //Responder consulta
      buffer_save_send(true, bufferEeprom);
    }else if(string_cmpnc(CAN_NIP, &can.rxBuffer[sizeTotal], sizeKey)){
      //OFFSET DE LA FILA
      sizeTotal += sizeKey;
      sizeKey = 4;  //4 POR LA FILA
      //FORMATO: PRE+ID(HEX)+NIP+NIP(HEX)
      sizeTotal += sizeKey;
      sizeKey = 8;  //8 Byte
      string_cpyn(msjConst, &can.rxBuffer[sizeTotal], sizeKey);
      nip = hexToNum(msjConst);
      //Busca la fila y actualiza el id, vigencia
      if(!mysql_read(tablePrepago, prepagoID, fila, &id)){
        if(id == idConsulta){
          mysql_write(tablePrepago, prepagoNip, fila, nip, false);
          #ifdef debug_usart
          usart_write_line("Prepago nip");
          #endif
        }
      }
    }else if(string_cmpnc(CAN_SALDO, &can.rxBuffer[sizeTotal], sizeKey)){
      //OFFSET DE LA FILA
      sizeTotal += sizeKey;
      sizeKey = 4;  //4 POR LA FILA
      //FORMATO: PRE+ID(HEX)+SLD+SALDO(HEX)
      sizeTotal += sizeKey;
      sizeKey = 8;  //8 Byte
      string_cpyn(msjConst, &can.rxBuffer[sizeTotal], sizeKey);
      saldo = hexToNum(msjConst);
      //Cambiar estatus del saldo tabla
      if(!mysql_read(tablePrepago, prepagoID, fila, &id)){
        if(id == idConsulta){
          mysql_write(tablePrepago, prepagoSaldo, fila, saldo, false);
          #ifdef debug_usart
          usart_write_line("Prepago saldo");
          #endif
        }
      }
    }else if(string_cmpnc(CAN_PASSBACK, &can.rxBuffer[sizeTotal], sizeKey)){
      //OFFSET DE LA FILA
      sizeTotal += sizeKey;
      sizeKey = 4;  //4 POR LA FILA
     //Crear mensaje: ID + PAS + ESTATUS
      sizeTotal += sizeKey;
      sizeKey = 1;
      estatus = can.rxBuffer[sizeTotal];
      //Cambiar estatus del passback tabla
      if(!mysql_read(tablePrepago, prepagoID, fila, &id)){
        if(id == idConsulta){
          mysql_write(tablePrepago, prepagoEstatus, fila, estatus, false);
          #ifdef debug_usart
          usart_write_line("Prepago passback");
          #endif
        }
      }
    }else if(string_cmpnc(CAN_SPECIAL_DATE, &can.rxBuffer[sizeTotal], sizeKey)){
      //OFFSET DE LA FILA
      sizeTotal += sizeKey;
      sizeKey = 4;  //4 POR LA FILA
      //FORMATO: PEN+ID+SPC+FILA+ESTATUS+DATE(12)
      sizeTotal += sizeKey;
      sizeKey = 1;
      estatus = can.rxBuffer[sizeTotal];
      //OBTENER DATE
      sizeTotal += sizeKey;
      sizeKey = 12;
      string_cpyn(msjConst, &can.rxBuffer[sizeTotal], sizeKey);
      //Cambiar estatus del passback tabla
      if(!mysql_read(tablePrepago, prepagoID, fila, &id)){
        if(id == idConsulta){
          mysql_write(tablePrepago, prepagoEstatus, fila, estatus, false);
          mysql_write_string(tablePrepago, prepagoDate, fila, msjConst, false);
          #ifdef debug_usart
          usart_write_line("Prepago pas+date");
          #endif
        }
      }
    }else if(string_cmpnc(CAN_SPECIAL_SALDO, &can.rxBuffer[sizeTotal], sizeKey)){
      //OFFSET DE LA FILA
      sizeTotal += sizeKey;
      sizeKey = 4;  //4 POR LA FILA
      //FORMATO: PEN+ID+SPC+FILA+ESTATUS+SALDO(8)
      sizeTotal += sizeKey;
      sizeKey = 1;
      estatus = can.rxBuffer[sizeTotal];
      //OBTENER SALDO
      sizeTotal += sizeKey;
      sizeKey = 8;
      string_cpyn(msjConst, &can.rxBuffer[sizeTotal], sizeKey);
      saldo = hexToNum(msjConst);
      //Cambiar estatus del passback tabla
      if(!mysql_read(tablePrepago, prepagoID, fila, &id)){
        if(id == idConsulta){
          mysql_write(tablePrepago, prepagoEstatus, fila, estatus, false);
          mysql_write(tablePrepago, prepagoSaldo, fila, saldo, false);
          #ifdef debug_usart
          usart_write_line("Prepago pas+saldo");
          #endif
        }
      }
    }else{
      string_addc(bufferEeprom, CAN_TABLE_ERROR);
    }
  }else if(string_cmpnc(CAN_SOPORTE, &can.rxBuffer[sizeTotal], sizeKey)){
    //OBTENER EL ID
    sizeTotal += sizeKey;
    sizeKey = 6;  //3 Bytes en hexadecimal
    string_cpyn(msjConst, &can.rxBuffer[sizeTotal], sizeKey);
    idConsulta = hexToNum(msjConst);
    //Obtiene el tipo de evento a ejecutar
    sizeTotal += sizeKey;
    sizeKey = sizeof(CAN_REGISTRAR)-1;  //COMANDO 3BYTES
    //OBTENER LA FILA
    string_cpyn(msjConst, &can.rxBuffer[sizeTotal+sizeKey], 4); //4 numeros fila
    fila = stringToNum(msjConst);
    //VERIFICAR LOS CAMANDOS
    if(string_cmpnc(CAN_REGISTRAR, &can.rxBuffer[sizeTotal], sizeKey)){
      //OFFSET DE LA FILA
      sizeTotal += sizeKey;
      sizeKey = 4;  //4 POR LA FILA
      //FORMATO: PEN+ID(HEX)+REG+FILA
      idNew = idConsulta;
      //VERIFICA QUE NO HAYA SIDO REGISTRADO
      if(mysql_read(tableSoporte, soporteID, fila, &id) == TABLE_RW_NO_EXIST_ROW){
        if(fila == myTable.rowAct+1){
          if(!mysql_write(tableSoporte, soporteID, -1, idNew, true)){
            #ifdef debug_usart
            usart_write_line("Soporte registrado");
            #endif
            mysql_write(tableSoporte, soporteID, fila, idNew, false);
          }
        }
      }
    }else if(string_cmpnc(CAN_CONSULTAR, &can.rxBuffer[sizeTotal], sizeKey)){
      //OFFSET DE LA FILA
      sizeTotal += sizeKey;
      sizeKey = 4;  //4 POR LA FILA
      //FORMATO: PEN+ID(HEX)+CON+FILA
      string_cpyc(bufferEeprom, CAN_TPV);
      string_cpyn(&bufferEeprom[sizeof(CAN_TPV)-1], can.rxBuffer, sizeTotal);
      if(!mysql_read(tableSoporte, soporteID, fila, &id)){
        if(idConsulta == id){
          #ifdef debug_usart
          usart_write_line("Consulta soporte");
          #endif
          //Enviar respuesta PEN+ID(HEX)+CON+MODULE
          string_addc(bufferEeprom, CAN_MODULE);
          numToHex(can.id, msjConst, 1);
          string_add(bufferEeprom, msjConst);
        }else{
          string_addc(bufferEeprom, CAN_TABLE_NO_FOUND);
        }
      }else{
        string_addc(bufferEeprom, CAN_TABLE_ERROR);
      }
      //Responder consulta
      buffer_save_send(true, bufferEeprom);
    }
  }else if(string_cmpnc(CAN_TABLE, &can.rxBuffer[sizeTotal], sizeKey)){
    sizeTotal += sizeKey;
    sizeKey = sizeof(CAN_TABLE_ERASE)-1;  //FORMATO ALL/T00/EXX

    //Crear respuesta
    string_cpyc(bufferEeprom, CAN_TPV);
    string_addc(bufferEeprom, CAN_TABLE);
    
    //VERIFICA EL COMANDO ESPECIAL
    if(string_cmpnc(CAN_TABLE_ERASE, &can.rxBuffer[sizeTotal], sizeKey)){
      sizeTotal += sizeKey;
      if(mysql_erase(&can.rxBuffer[sizeTotal])){
        string_addc(bufferEeprom, CAN_TABLE_ERASE);
        //Nombre de la tabla
        string_cpyn(msjConst, &can.rxBuffer[sizeTotal], 3);
        string_toUpper(msjConst);
        string_add(bufferEeprom, msjConst);
      }else{
        string_addc(bufferEeprom, CAN_TABLE_NO_FOUND);
      }
      #ifdef debug_usart
      usart_write_text("Tabla borrada: ");
      usart_write_line(&can.rxBuffer[sizeTotal]);
      #endif
    }else if(string_cmpnc(CAN_TABLE_INFO, &can.rxBuffer[sizeTotal], sizeKey)){
      //FORMATO: TBL+INF+NAME
      sizeTotal += sizeKey;

      if(mysql_exist(&can.rxBuffer[sizeTotal])){
        string_addc(bufferEeprom, CAN_TABLE_INFO);
        //Nombre de la tabla
        string_cpyn(msjConst, &can.rxBuffer[sizeTotal], 3);
        string_toUpper(msjConst);
        string_add(bufferEeprom, msjConst);
        //Filas actuales
        string_addc(bufferEeprom, FILAS_ACTUALES);
        numToString(myTable.rowAct, msjConst, 4);
        string_add(bufferEeprom, msjConst);
        //Filas prog
        string_addc(bufferEeprom, FILAS_PROG);
        numToString(myTable.row, msjConst, 4);
        string_add(bufferEeprom, msjConst);
        #ifdef debug_usart
        usart_write_text("Tabla consulta: ");
        usart_write_line(bufferEeprom);
        #endif
      }else{
        string_addc(bufferEeprom, CAN_TABLE_NO_FOUND);
      }
    }else if(string_cmpnc(CAN_PASSBACK, &can.rxBuffer[sizeTotal], sizeKey)){
      //FORMATO: TBL+PAS+NAME
      sizeTotal += sizeKey;
      
      //ROMPE EL PASSBACK DE PENSIONADOS, PREPAGO
      if(mysql_exist(&can.rxBuffer[sizeTotal])){
        string_addc(bufferEeprom, CAN_PASSBACK);
        //Nombre de la tabla
        string_cpyn(msjConst, &can.rxBuffer[sizeTotal], 3);
        string_toUpper(msjConst);
        string_add(bufferEeprom, msjConst);
        
        //PONER EL VALOR DE ESTATUS CON EL VALOR INDICADO
        for(fila = 1; fila <= myTable.rowAct; fila++)
          mysql_write(&can.rxBuffer[sizeTotal], pensionadosEstatus, fila, '-', false);

        //Repetir proceso para saber si lo logro
        if(!mysql_write(&can.rxBuffer[sizeTotal], pensionadosEstatus, 1, '-', false))
          string_addc(bufferEeprom, CAN_TABLE_MODIFICADO);
        else
          string_addc(bufferEeprom,CAN_TABLE_ERROR);
      }else{
        string_addc(bufferEeprom, CAN_TABLE_NO_FOUND);
      }
    }
    //Enviar quien responde
    string_cpyc(msjConst, CAN_MODULE);
    numToHex(can.id, &msjConst[1], 1);
    string_add(bufferEeprom, msjConst);
    //Responder consulta
    buffer_save_send(true, bufferEeprom);
  }else if(string_cmpnc(CAN_TABLE_RW, &can.rxBuffer[sizeTotal], sizeKey)){
    //FORMATO: TRW + FILA + NAMETABLE + TBR/TBW
    sizeTotal += sizeKey;
    sizeKey = 4;
    string_cpyn(msjConst, &can.rxBuffer[sizeTotal], sizeKey);
    fila = stringToNum(msjConst);
    //Obtener nombre de la tabla
    sizeTotal += sizeKey;
    sizeKey = sizeof(CAN_PENSIONADO)-1;
    //CREAR EVENTO DE RESPUESTA: TBL+E+NODO(HEX)+[MENSAJE]
    string_cpyc(bufferEeprom, CAN_TBL);
    string_addc(bufferEeprom, CAN_MODULE);
    numToHex(can.id, msjConst, 1);
    string_add(bufferEeprom, msjConst);
    
    //TABLA DE PENSIONADOS
    if(string_cmpnc(CAN_PENSIONADO, &can.rxBuffer[sizeTotal], sizeKey)){
      //FORMATO FINAL: TBL+E+NODO(HEX)+PEN+[ID+V+O]/ERROR
      string_addc(bufferEeprom, CAN_PENSIONADO);
      sizeTotal += sizeKey;
      sizeKey = sizeof(CAN_TABLE_READ)-1;
      //LECTURA DE LA TABLA
      if(string_cmpnc(CAN_TABLE_READ, &can.rxBuffer[sizeTotal], sizeKey)){
        if(!mysql_read(tablePensionados, pensionadosID, fila, &id)){
          //usart_write_line("Lectura de la tabla");
          mysql_read_string(tablePensionados, pensionadosVigencia, fila, &vigencia);
          mysql_read_string(tablePensionados, pensionadosEstatus, fila, &estatus);
          //Enviar respuesta TBL+E+NODO(HEX)+PEN+ID+V+O
          numToHex(id, msjConst, 3);
          string_add(bufferEeprom, msjConst);
          string_push(bufferEeprom, vigencia);
          string_push(bufferEeprom, estatus);
        }else{
          string_addc(bufferEeprom, CAN_TABLE_ERROR);
        }
      }else if(string_cmpnc(CAN_TABLE_WRITE, &can.rxBuffer[sizeTotal], sizeKey)){
        sizeTotal += sizeKey;
        sizeKey = 6;  //3 Bytes en hexadecimal
        string_cpyn(msjConst, &can.rxBuffer[sizeTotal], sizeKey);
        idNew = hexToNum(msjConst);
        //Obtiene la vigencia
        sizeTotal += sizeKey;
        sizeKey = 1;  //1 Byte
        vigencia = can.rxBuffer[sizeTotal];
        //Obtiene el status del coche
        sizeTotal += sizeKey;
        sizeKey = 1;  //1 Byte
        estatus = can.rxBuffer[sizeTotal];
        
        if(!mysql_write(tablePensionados, pensionadosID, fila, id, false)){
          //usart_write_line("Escritura de la tabla");
          mysql_write(tablePensionados, pensionadosVigencia, fila, vigencia, false);
          mysql_write(tablePensionados, pensionadosEstatus, fila, estatus, false);
          //Enviar respuesta TBL+E+NODO(HEX)+PEN+ID+V+O
          string_addc(bufferEeprom, CAN_TABLE_MODIFICADO);
        }else{
          string_addc(bufferEeprom, CAN_TABLE_ERROR);
        }
      }
    }
  }else if(string_cmpnc(CAN_CMD, &can.rxBuffer[sizeTotal], sizeKey)){
    sizeTotal += sizeKey;
    sizeKey = sizeof(CAN_PASSBACK)-1;

    if(string_cmpnc(CAN_PASSBACK, &can.rxBuffer[sizeTotal], sizeKey)){
      sizeTotal += sizeKey;

      if(can.rxBuffer[sizeTotal] == '1')
        canSynchrony = true;
      else
        canSynchrony = false;
      mysql_write(tableSyncronia, columnaEstado, 1, canSynchrony, false);
      
      //Mostrar mensaje
      lcd_clean_row(3);
      lcd_out(3,1,canSynchrony? "Sincronizado":"Desincronizado");
      //Responder
      string_cpyc(bufferEeprom, CAN_TPV);        //SYN
      string_addc(bufferEeprom, CAN_CMD);
      string_addc(bufferEeprom, CAN_PASSBACK);
      string_push(buffereeprom, canSynchrony+'0');
      //Enviar quien responde
      string_cpyc(msjConst, CAN_MODULE);
      numToHex(can.id, &msjConst[1], 1);
      string_add(bufferEeprom, msjConst);
      //Responder consulta
      buffer_save_send(true, bufferEeprom);
      
      #ifdef debug_usart
      usart_write_line(canSynchrony? "Sincronizado":"Desincronizado");
      #endif
    }else if(string_cmpnc(CAN_CUPO, &can.rxBuffer[sizeTotal], sizeKey)){
      sizeTotal += sizeKey;

      if(can.rxBuffer[sizeTotal] == '1')
        cupoLleno = true;
      else
        cupoLleno = false;
      mysql_write(tableCupo, columnaEstado, 1, cupoLleno, false);
      //Mostrar mensaje
      lcd_clean_row(3);
      lcd_out(3,1,cupoLleno? "Cupo lleno":"Cupo disponible");
      //Responder
      string_cpyc(bufferEeprom, CAN_TPV);        //SYN
      string_addc(bufferEeprom, CAN_CMD);
      string_addc(bufferEeprom, CAN_CUPO);
      string_push(buffereeprom, cupoLleno+'0');
      //Enviar quien responde
      string_cpyc(msjConst, CAN_MODULE);
      numToHex(can.id, &msjConst[1], 1);
      string_add(bufferEeprom, msjConst);
      //Responder consulta
      buffer_save_send(true, bufferEeprom);
      
      #ifdef debug_usart
      usart_write_line(cupoLleno? "Cupo lleno":"Cupo disponible");
      #endif
    }else if(string_cmpnc(CAN_ABRIR, &can.rxBuffer[sizeTotal], sizeKey)){
      //Abrir barrera una vez impreso el boleto
      eSensor = 0;  //Reiniciar maquina de estados
      abrirBarrera = true;
      SALIDA_RELE1 = 1;
      SALIDA_RELE2 = 1;
      timer1_reset();
      timer1_enable(true);
      //Responder
      string_cpyc(bufferEeprom, CAN_TPV);        //SYN
      string_addc(bufferEeprom, CAN_CMD);
      string_addc(bufferEeprom, CAN_ABRIR);
      string_push(buffereeprom, '1');            //Abrio la barrera
      //Enviar quien responde
      string_cpyc(msjConst, CAN_MODULE);
      numToHex(can.id, &msjConst[1], 1);
      string_add(bufferEeprom, msjConst);
      //Responder consulta
      buffer_save_send(true, bufferEeprom);
      #ifdef debug_usart
      usart_write_line("Abriendo barrera");
      #endif
    }else if(string_cmpnc(CAN_KEY, &can.rxBuffer[sizeTotal], sizeKey)){
      sizeTotal += sizeKey;
      sizeKey = sizeof(CAN_NIP)-1;

      if(string_cmpnc(CAN_NIP, &can.rxBuffer[sizeTotal], sizeKey)){
        sizeTotal += sizeKey;
        string_cpyn(msjConst, &can.rxBuffer[sizeTotal], 8);
        nip = hexToNum(msjConst);
        //Fecha
        string_cpyn(msjConst, &can.rxBuffer[sizeTotal+8], 12);
        //Buscar coincidencia previa
        if(!mysql_search_forced(tableKeyOutNip, keyOutNip, nip, &fila)){
          estatus = '0';
          mysql_write_forced(tableKeyOutNip, keyOutEstatus, fila, &estatus, sizeof(estatus));
          auxNip = -1;  //Nip invalido
          mysql_write_forced(tableKeyOutNip, keyOutNip, fila, (char*)&auxNip, sizeof(auxNip));
        }
        //Siempre apuntar al futuro
        mysql_write_roundTrip(tableKeyOutNip, keyOutEstatus, "1", 1);
        mysql_write_forced(tableKeyOutNip, keyOutNip, myTable.rowAct, (char*)&nip, sizeof(nip));
        mysql_write_forced(tableKeyOutNip, keyOutDate, myTable.rowAct, msjConst, string_len(msjConst)+1);

        //Responder que se inscribio el nip
        string_cpyc(bufferEeprom, CAN_TPV);
        string_addc(bufferEeprom, CAN_OUT);
        string_addc(bufferEeprom, CAN_KEY);
        string_addc(bufferEeprom, CAN_NIP);
        numToHex(nip, msjConst, 4);
        string_add(bufferEeprom, msjConst);
        string_addc(bufferEeprom, CAN_REGISTRAR);
        //Reponde modulo
        string_addc(bufferEeprom, CAN_MODULE);
        numToHex(canId, msjConst, 1);
        string_add(bufferEeprom, msjConst);
        //Guardo el evento para enviarlo
        buffer_save_send(true, bufferEeprom);
        
        #ifdef debug_usart
        usart_write_line("Guardado nip key");
        #endif
      }
    }else if(string_cmpnc(CAN_FOL, &can.rxBuffer[sizeTotal], sizeKey)){
      sizeTotal += sizeKey;
      sizeKey = sizeof(CAN_TABLE_GET)-1;

      if(string_cmpnc(CAN_TABLE_GET, &can.rxBuffer[sizeTotal], sizeKey)){
        sizeTotal += sizeKey;
        string_cpyc(bufferEeprom, CAN_TPV);
        string_addc(bufferEeprom, CAN_FOL);
        string_addc(bufferEeprom, CAN_TABLE_GET);
        //Lectura del folio
        mysql_read(tableFolio, folioTotal, 1, &folio);
        numToHex(folio, msjConst, 4);
        string_add(bufferEeprom, msjConst);
        string_addc(bufferEeprom, CAN_MODULE);
        numToHex(can.id, msjConst, 1);
        string_add(bufferEeprom, msjConst);
        buffer_save_send(true, bufferEeprom);
        #ifdef debug_usart
        usart_write_line("Folio consulta");
        #endif
      }else if(string_cmpnc(CAN_TABLE_SET, &can.rxBuffer[sizeTotal], sizeKey)){
        sizeTotal += sizeKey;
        string_cpyn(msjConst, &can.rxBuffer[sizeTotal], 8);
        folio = hexToNum(msjConst);
        mysql_write(tableFolio, folioTotal, 1, folio, false);
        #ifdef debug_usart
        usart_write_text("Nuevo folio: ");
        usart_write_line(msjConst);
        #endif
      }
    }
  }
}
/******************************************************************************/
void can_user_write_message(){
  if(can.tx_status == CAN_RW_ENVIADO){
    if(modeBufferEventos){
      modeBufferEventos = false;
      pilaBufferCAN--;
      mysql_write_forced(tableEventosCAN, eventosEstatus, pilaBufferPointer, "0", 1);
      
      #ifdef debug_usart
      usart_write_line("CAN mensaje entragado");
      #endif
    }
  }else if(can.tx_status == CAN_RW_CORRUPT){
    //Guardar eventos que no fueron previamente guardados
    if(!modeBufferEventos){
      buffer_save_send(true, can.txBuffer);
      #ifdef debug_usart
      usart_write_line("CAN no pudo enviar, save eeprom");
      #endif
    }else{
      //No guarda eventos ya guardados
      modeBufferEventos = false;
      #ifdef debug_usart
      usart_write_line("CAN fallo envio en eeprom");
      #endif
    }
  }
}
/******************************************************************************/
void can_user_guardHeartBeat(char idNodo){
  //Sin inplementacion
}
/******************************************************************************/
void can_heartbeat(){
  char cmdHeartBeat[2];

  //Si llega el tiempo necesario mando el heartbeat
  if(++temp_heartbeat >= TIME_HEARTBEAT){
    temp_heartbeat = 0;
    cmdHeartBeat[0] = can.id;
    cmdHeartBeat[1] = CAN_PROTOCOL_HEARTBEAT;
    can_write(can.ip+canIdTPV, cmdHeartBeat, sizeof(cmdHeartBeat), 3, false);
  }
}
/******************************************************************************/
void buffer_save_send(bool guardar, char *buffer){
  char result;
  
  if(!guardar){
    if(!can_write_text(can.ip+canIdTPV, buffer, 0))
      guardar = true;
  }
  //Guardar en buffer
  if(guardar){
    if(!mysql_write_roundTrip(tableEventosCAN, eventosRegistro, buffer, strlen(buffer)+1)){
      mysql_read_forced(tableEventosCAN, eventosEstatus, myTable.rowAct, &result);
      //Subir buffer si no fue sobreescritura
      if(result != '1')
        pilaBufferCAN++;
      mysql_write_forced(tableEventosCAN, eventosEstatus, myTable.rowAct, "1", 1);

      #ifdef debug_usart
      usart_write_text("Fila: ");
      inttostr(myTable.rowAct, msjConst);
      usart_write_text(msjConst);
      usart_write_text(", ");
      usart_write_text("Guardar: ");
      usart_write_line(buffer);
      #endif
    }
  }
}
/******************************************************************************/
/***************************** INTERRUPCIONES *********************************/
/******************************************************************************/
void int_timer1(){
  static char temp = 0;
  
  if(PIR1.TMR1IF && PIE1.TMR1IE){
    //ESPERAR CADA SEGUNDO PARA APAGAR RELE
    if(++temp >= 20){
      temp = 0;
      SALIDA_RELE1 = 0; //APAGAR RELE DESPUES DE UN SEGUNDO
      SALIDA_RELE2 = 0;
      PIE1.TMR1IE = 0;  //DESACTIVAR EL TIMER1
    }

    //FINALIZAR INTERRUPCION
    TMR1H = getByte(sampler1,1);
    TMR1L = getByte(sampler1,0);
    PIR1.TMR1IF = 0;   //LIMP�AR BANDERA
  }
}
/******************************************************************************/
void int_timer3(){
  static char temp = 0;
  
  if(PIR2.TMR3IF && PIE2.TMR3IE){
    can.temp += 50;     //Can protocol
    flagTMR3.B0 = true;
    
    //Contar segundos
    if(++temp >= 20){
      if(can.conected)
        LED_LINK ^= 1;
      temp = 0;
      flagSecondTMR3.B0 = true;
    }
    //FINALIZAR INTERRUPCION
    TMR3H = getByte(sampler3,1);
    TMR3L = getByte(sampler3,0);
    PIR2.TMR3IF = 0;   //LIMP�AR BANDERA
  }
}
/******************************************************************************/