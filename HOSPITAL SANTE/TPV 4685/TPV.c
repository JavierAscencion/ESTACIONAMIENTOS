/****************************** DESCRIPCION ************************************
Verificar en que momento debo ver la hora
*Falta enviar de nuevo las conexiones de los modulos despues de una desconexion

void Net_Ethernet_28j60_UserTCP(SOCKET_28j60_Dsc *socket);
void pic_init();           //Inicializacion del microcontrolador
void tpv_reconexion();     //Reconexion del tcp
void tpv_pushBuffer();     //Empuja el dato hacia la internet
void tpv_buffer_tcp();     //Vacia buffer del tcp
void tpv_buffer_can();     //Vacia buffer del can
void tpv_temporizadores(); //Cada segundo realiza una accion
*******************************************************************************/
#define bool  char
#define true  1
#define false 0
#define getByte(variable, indice) ((char*)&variable)[indice]
/******************************************************************************/
/******************************* LIBRERIAS ************************************/
/******************************************************************************/
//OTRAS
#include "miscelaneos.h"
#include "string.h"
//HARDWARE
#include "lib_wtd.h"
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
#include "__NetEthEnc28j60.h"
#include "spi_tcp.h"
//OTROS POR ELIMINAR
#include "servidor.h"
/******************************************************************************/
/******************************** PIN OUT *************************************/
/******************************************************************************/
//ENTRADAS: ENTRADA 2 Y 3 SON INTERRPCIONES EXTERNAS
sfr sbit BOTON_ENTRADA1            at PORTD.B4;  //ENTRADA 1
sfr sbit BOTON_ENTRADAD1           at TRISD.B4;
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
//VARIABLES HARDWARE
const int timeAwake = 300;      //Tiempo para despertar al microcontrolador
const long baudiosRate = 9600;  //Velocidad de los baudios

//TABLA PENSIONADO
char tablePensionados[] = "Pensionados"; //PENSIONADOS
char pensionadosID[] = "id";             //ID(HEX)
char pensionadosEstatus[] = "estatus";   //ESTADO DEL COCHE: I=INPUT, O=OUTPUT
char pensionadosVigencia[] = "vigencia"; //VIGENCIA: V=VIGENTE, N=NO VIGENTE
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
//TABLA DE KEYS
char tableKeyOutNip[] = "KeyNip";         //Guarda teclas para salir
char tableKeyOutDate[] = "KeyDate";       //Tabla de salida por fecha
char tableKeyOutFol[] = "KeyFolios";      //Tabla de salida por folios
char keyOutNip[] = "nip";
char keyOutFol[] = "folio";
char keyOutDate[] = "date";
char keyOutEstatus[] = "estatus";
//TABLA DE EVENTOS TCP Y CAN
char tableEventosTCP[] = "EventosTCP";   //EVENTOS HACIA EL SERVIDOR
char tableEventosCAN[] = "EventosCAN";   //EVENTOS DE LOS MODULOS CONECTADOR POR CAN
char eventosRegistro[] = "registro";     //STRING DEL EVENTO
char eventosEstatus[] = "estatus";       //ESTATUS DE ENVIO: 1:POR ENVIAR, 0:ENVIADO
char eventosModulos[] = "modulos";       //MODULOS A SER TRANSMITIDO EL EVENTO
//TABLA TICKETS EXP Y TPV ***
char tableTicketEXP[] = "TicketEXP";     //Almacena el ticket dinamico expendedora
char tableTicketTPV[] = "TicketTPV";     //Ticket para el TPV
char ticketTicket[] = "ticket";          //Nombre de la columna
//TABLA FOLIO
char tableFolio[] = "Folio";             //FOLIO TOTAL DE TODAS LAS EXPENDEDORAS
char folioTotal[] = "total";             //FOLIO TOTAL
long folio;
//TABLA DE TIEMPO DE SALIDA
char tableToleranciaOut[] = "timeTolerancia";
char tableToleranciaMax[] = "tolerancia";
unsigned int toleranciaOut;
//TABLA PARA VARIABLES EXTRAS
char tableSyncronia[] = "Sincronia";
bool canSynchrony;              //Syncronia
char tableCupo[] = "Cupo";
bool cupoLleno;                 //Cupo del pic, para imprmir el boleto
char columnaEstado[] = "estado";
//Tabla de nodos
char tableNodos[] = "Nodos";
char nodosName[] = "name";


//TCP/IP CONSTANTES
const char timeReconectTCP = 3;          //Tiempo(seg) para intentar reconectar el sistema
const char timeCreateNewPort = 5;        //Tiempo(seg) para crear un nuevo puerto seguro
const char timePushBuffer = 5;           //Tiempo(seg) para reenviar el buffer lleno
const unsigned int myPortMin = 123;      //Puerto minimo de conexion
const unsigned int myPortMax = 127;      //Puerto maximo de conexion
//TCP/IP VARIABLES
bool sendDataTCP = false;                //Para saber si es envio
bool isEmptyBuffer;                      //Si esta vacio el buffer
bool isConectTCP;                        //Cable conectado
bool isConectServer;                     //Conexion online desconocida
bool modoBufferTCP = true;               //Permite ailar el siguiente dato
static unsigned int pointer;             //Puntero de la pila
char conectTCP;                          //No se conoce el estado de conexion ***
char *punteroTCP;                        //Hacia donde apunta el mensaje a enviar
char myMacAddr[6] = {0x00, 0x04, 0xA3, 0x76, 0x19, 0x3F};
char myIpAddr[4] = {192, 168, 1, 5};
char ipMask[] = {255, 255, 255, 0};         //Obtener datos cmd: ipconfig /all
char gwIpAddr[] = {192, 168, 1, 1};
char dnsIpAddr[4]  = {192, 168,   1,  1};   //Remote IP address
char ipAddr[] = {192, 168, 1,  38};         //Ip del servidor mi maquina
const char MAX_BYTES_TCP = 64;              //MAXIMOS BYTES DE RECEPCION Y ENVIO
char getRequest[MAX_BYTES_TCP];             //Para las peticiones del servidor
unsigned int portServer = 132;              //Puerto del servidor
unsigned int myPort = myPortMin;            //Establece conexion en este puerto
SOCKET_28j60_Dsc *sock1;
unsigned int tempPushBuffer;                //Para empuja el buffer del enc28j60
unsigned int tempCreateNewPort;             //Para crear un nuevo puerto por no conectar
unsigned int tempReconectTCP;               //Reconexion del TCP
unsigned char tempRepeatTCP;                //Repite dato del buffer
bool heartBeatTCP = false;                  //Deteccion del hearbeat online
int tempHeartBeatTcp;                       //Tiempo del heart beat
const int timeHeartBeatTcp = 1*30;          //Tiempo maximo del ack tcp


//COMANDOS PENSIONADO Y PREPAGO
const char TCP_CAN_PENSIONADO[] = "PEN";
const char TCP_CAN_PREPAGO[] = "PRE";
const char TCP_CAN_SOPORTE[] = "SOP";     //TARJETA DE SOPORTE TECNICO
const char TCP_CAN_REGISTRAR[] = "REG";   //REGISTRO
const char TCP_CAN_ACTUALIZAR[] = "ACT";  //ACTUALIZAR
const char TCP_CAN_VIGENCIA[] = "VIG";    //VIGENCIA
const char TCP_CAN_PASSBACK[] = "PAS";    //ESTATUS
const char TCP_CAN_CONSULTAR[] = "CON";   //CONSULTA DE LA TABLA
const char TCP_CAN_SALDO[] = "SLD";       //SALDO
const char TCP_CAN_NIP[] = "NIP";         //NIP
const char CAN_SPECIAL_DATE[] = "SPD";    //Special comando = estatus+date
const char CAN_SPECIAL_SALDO[] = "SPS";   //Special comando = estatus+saldo
//TABLA MULTIPOROPOSITO
const char TCP_TBL_CONSULTA[] = "CONSULTA:";
const char TCP_TBL_DUPLICADO[] = "DUPLICIDAD";
const char TCP_TBL_REGISTRADO[] = "REGISTRADO";
const char TCP_TBL_LLENA[] = "TABLA LLENA";
const char TCP_TBL_MODIFICADO[] = "MODIFICADO";
const char TCP_TBL_ERROR[] = "ERROR TABLE";
const char TCP_TBL_REG_PREVIO[] = "REG. PREVIO";
const char TCP_TBL_NO_FOUND[] = "NO FOUND";
const char TCP_TBL_OK[] = "OK";
//COMANDOS PARA EL RTC
const char TCP_CAN_RTC[] = "RTC";
//COMANDOS MULTIPROPOSITO
const char TCP_CAN_FOL[] = "FOL";
//COMANDOS TABLA
const char TCP_TABLE_SET[] = "SET";
const char TCP_TABLE_GET[] = "GET";
const char TCP_TABLE[] = "TBL";
const char TCP_TABLE_ERASE[] = "ERS";
const char TCP_TABLE_INFO[] = "INF";
//COMANDOS ESPECIALES
const char TCP_SQL[] = "SQL";       //COMANDOS PARA MYSQL
const char TCP_SQL_ACK[] = "ACK";   //ACK
const char TCP_SQL_WRITE[] = "WRT"; //ESCRITURA EN LA SQL
//RECEPCION POR CAN Y ENVIO POR TCP
const char TCP_CAN_TPV[] = "TPV";       //EVENTO QUE VA HACIA ETHERNET
const char TCP_CAN_EXP[] = "EXP";       //EXP
//MODULO DEL CAN
const char TCP_CAN_MODULE[] = "T";      //TPV
const char TCP_CAN_MODULE_E = 'E';      //EXPENDEDORA
const char TCP_CAN_MODULE_V = 'V';      //VALIDADORA
const char TCP_CAN_MOD[] = "MOD";
//OTROS MENSAJES
const char TCP_MESSAGE_OVERFLOW[] = "MSGOVFMAX";  //MENSAJE DE SOBREFLUJO
//COMANDOS TICKET
const char TCP_CAN_TICKET[] = "TKT";       //TICKET
const char TCP_CAN_ANEXAR[] = "ADD";       //AÑADE DATA AL FINAL
const char TCP_CAN_FINALIZAR[] = "FIN";    //FINALIZAR
const char TCP_CAN_RETRANSMITIR[] = "RTM"; //RETRANSMITIR
const char TCP_CAN_IMPRIMIR[] = "IMP";     //IMPRIMIR
//EVENTO COMANDOS
const char TCP_CAN_CMD[] = "CMD";
const char TCP_CAN_CUPO[] = "CUP";
const char TCP_CAN_ABRIR[] = "OPN";
const char TCP_CAN_MODULE_ALL[] = "ALL";//ALL
const char TCP_CAN_NODOS[] = "NOD";
const char TCP_CAN_RESET[] = "RST";

//VARIABLES PARA EL TIMER
bool flagTMR3 = false;       //Flag para el timer cada ms
bool flagSecondTMR3 = false; //Bandera de cada segundo de temporizacion

//Variables CAN
const char canId = 0;       //El id del pic
long canIp = 0x1E549500;    //Red lan: 30.84.149.0
long canMask = 0xFFFFFFFF;  //Filtrar: 255.255.255.255
char canCommand[64];        //Variable que envia los eventos
//Estructura para el heartbeat
const int MAX_TIME_CHECK_MOD = 20;  //CADA 20 SEGUNDOS VERIFICA LOS MODULOS
const char MAX_MODULES = 20;        //MAXIMOS MODULOS CONECTADOS
typedef struct{
  bool synchrony;                 //Sincronia
  char modulos;                   //Numero de modulos conectados
  bool canState[MAX_MODULES];     //Verifica si hubo un cambio en conexion
  bool canIdReport[MAX_MODULES];  //Verifica quien reporta si esta vivo
  char canIdMod[MAX_MODULES+1];   //Cola de los nodos con final de cadena
  int canTemp;                    //Temporizador de chequeo
}MODULOS_CAN;
MODULOS_CAN tarjetas;

//OBJETOS
DS1307 myRTC;

//Variables para el buffer TCP y CAN
bool modeBufferToNodo = false;  //Envia hacia el nodo correcto
int pilaBufferTCP;              //Pila del buffer TCP
int pilaBufferCAN;              //Pila del buffer can
int pointerBufferCAN;
char bufferEeprom[64];          //Guarda en eeprom los eventos no enviados

//Otros
char msjConst[20];              //Mensajes constantes a ser convertidos

//Probar pulso de relay impresora
char tempMonedero;
const char timeMaxMonedero = 3;


/******************************************************************************/
/************************** FUNCTION PROTOTYPE ********************************/
/******************************************************************************/
//OTRAS
void lcd_clean_row(char fila);
void buffer_save_send(bool tcpORcan, char *buffer, char *nodosCAN);
//PRINCIPALES
void pic_init();           //Inicializacion del microcontrolador
void tpv_reconexion();     //Reconexion del tcp
void tpv_pushBuffer();     //Empuja el dato hacia la internet
void tpv_buffer_tcp();     //Vacia buffer del tcp
void tpv_buffer_can();     //Vacia buffer del can
void tpv_temporizadores(); //Cada segundo realiza una accion
//Eliminables
//#define CREATE_CODE_TABLE
int tam;

/******************************************************************************/
/********************************** MAIN **************************************/
/******************************************************************************/
void main(){
  //Inicializar el pic
  pic_init();

  while(true){
    //Funciones de ethernet y can
    Net_Ethernet_28j60_doPacket();  //Verifica envio y recepcion tcp
    can_do_work();                  //Verifica envio y recepcion can
    usart_do_read_text();           //Verifica si hay datos en buffer
    //Funciones del modulo
    tpv_temporizadores();           //Incrementa los contadores y verifica conexiones
    tpv_pushBuffer();               //Empuja en el buffer del enc28j60
    tpv_reconexion();               //Reconecta el modulo si sufrio desconexion
    tpv_buffer_tcp();               //Vacia buffer tcp
    tpv_buffer_can();               //Vacia buffer can
  }
}
/******************************* INTERRUPT ************************************/
void interrupt(){
  int_wiegand26();
  int_usart_rx();
}
/******************************************************************************/
void interrupt_low(){
  int_timer1();
  int_timer2();
  int_timer3();
  int_can();
}
/******************************************************************************/
/******************************** FUNCTIONS ***********************************/
/******************************************************************************/
void pic_init(){
  char cont;
  //Configurar el reloj del pic
  OSCCON = 0x40;  //Oscilador externo
  
  //Configuar los pines analogicos
  ADCON1 = 0x0F;  //Todos digitales
  CMCON = 0x07;   //Apagar los comparadores
  
  //Configurar los pines entrada o salida
  SENSOR_COCHED = 1;
  BOTON_IMPRIMIRD = 1;
  LED_LINKD = 0;
  SALIDA_RELE1D = 0;
  SALIDA_RELE2D = 0;
  SALIDA_RELE3D = 0;
  SALIDA_RELE4D = 0;
  SALIDA_RELE5D = 0;
  //Señales por defecto
  SALIDA_RELE1 = 0;
  SALIDA_RELE2 = 0;
  SALIDA_RELE3 = 0;
  SALIDA_RELE4 = 0;
  SALIDA_RELE5 = 0;
  LED_LINK = 0;
  
  //Inicializar la eeprom del pic

  //Inicializar variables por primer energizado
  if(!RCON.POR){
    RCON.POR = 1;  //Reset bit
    RCON.TO_ = 1;
    RCON.PD = 1;
  }
  
  //Inicializar los modulos ADC, TIMERS, SPI, I2C, EEPPROM, Modulos
  timer1_open(200e3, false, true, false);
  timer3_open(200e3, true, true, false);
  usart_open(baudiosRate);
  usart_enable_rx(true, true, 0x0D);
  //Modulos
  DS1307_open();
  lcd_init();
  lcd_cmd(_LCD_CURSOR_OFF);
  lcd_cmd(_LCD_CLEAR);
  mysql_init(32768);
  wiegand26_open();
  wtd_enable(true);
  can_open(canIp, canMask, canId, 4);
  wtd_enable(false);
  can_interrupt(true, false);
  SPI1_Init();                                         //Initialize SPI modulo
  Net_Ethernet_28j60_Init(myMacAddr, myIpAddr, 0x01);  //Full duplex
  Net_Ethernet_28j60_confNetwork(ipMask, gwIpAddr, dnsIpAddr);
  Net_Ethernet_28j60_stackInitTCP();
  
  //Preprogramacion init modules
  wiegand26_enable();
  DS1307_Read(&myRTC, true);
  tarjetas.canTemp = MAX_TIME_CHECK_MOD;
  //Cargar elementos en buffer
  pilaBufferCAN = mysql_count_forced(tableEventosCAN, eventosEstatus, '1');
  pilaBufferTCP = mysql_count_forced(tableEventosTCP, eventosEstatus, '1');
  usart_write_text("Pila TCP: ");
  inttostr(pilaBufferTCP, msjConst);
  usart_write_line(msjConst);
  usart_write_text("Pila CAN: ");
  inttostr(pilaBufferCAN, msjConst);
  usart_write_line(msjConst);
  
  //LECTURA DE LAS VARIABLES EN EEPROM
  mysql_read(tableFolio, folioTotal, 1, &folio);
  mysql_read_string(tableCupo, columnaEstado, 1, &cupoLleno);
  mysql_read_string(tableSyncronia, columnaEstado, 1, &canSynchrony);
  
  //CARGADO DE LOS NODOS
  tarjetas.synchrony = true;
  if(mysql_exist(tableNodos)){
    tarjetas.modulos = myTable.rowAct;
    for(cont = 0; cont < tarjetas.modulos; cont++){
      tarjetas.canState[cont] = false;    //Conexion supuesta
      tarjetas.canIdReport[cont] = true;  //Supone conexion conectada
      mysql_read_string(tableNodos, nodosName, cont+1, &tarjetas.canIdMod[cont]);
    }
    tarjetas.canIdMod[cont] = 0;  //Final de cadena anexado
  }
  numToString(tarjetas.modulos, msjConst, 3);
  usart_write_text("Nodos: ");
  usart_write_line(msjConst);
  
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
  
  //Tabla de nodos
  mysql_create_new(tableNodos, "name&1", 20);
  usart_write_text("Tabla nodos: ");
  longtostr(myTable.size, msjConst);
  usart_write_line(msjConst);
  
  while(true);
  #endif
  /****************************************************************************/
  //Intentar conectar el modulo a tcp, la funcion demora 6 segundos maximo
  Net_Ethernet_28j60_connectTCP(ipAddr, portServer, myPort, &sock1);
  isConectTCP = spi_tcp_linked();       //Cable conectado
  isConectServer = sock1->state == 3;
  usart_write_line("Parking");
  usart_write_line(isConectTCP? "Cable":"Desconectado");
  usart_write_line(isConectServer? "Online":"Offline");
  
  //ESTE CODIGO SERVIRA CUANDO SE USE EL TPV CON MAS FUNCIONABILIDADES
  /*
  //ENVIAR ESTADO SYNCHRONY
  string_cpyc(bufferEeprom, TCP_CAN_CMD);
  string_addc(bufferEeprom, TCP_CAN_PASSBACK);
  string_push(bufferEeprom, canSynchrony+'0');
  buffer_save_send(false, bufferEeprom, tarjetas.canIdMod);
  //ENVIAR ESTADO DEL CUPO
  string_cpyc(bufferEeprom, TCP_CAN_CMD);
  string_addc(bufferEeprom, TCP_CAN_CUPO);
  string_push(bufferEeprom, cupoLleno+'0');
  buffer_save_send(false, bufferEeprom, tarjetas.canIdMod);
  */
  //Tiempo para empezar el pic
  delay_ms(timeAwake);
  lcd_out(1, 1, "TPV");
  string_cpy(bufferEeprom, "INIRST");
  buffer_save_send(true, bufferEeprom, tarjetas.canIdMod);
}
/******************************************************************************/
void tpv_pushBuffer(){
  //Aveces el buffer del tcp se queda congelado, forzar el envio
  static bool pushBuffer = false;
  
  //Algoritmo extra para push del buffer
  if(isConectServer && isConectTCP && !isEmptyBuffer){
    //Si no esta vacio el buffer
    if(!pushBuffer){
      pushBuffer = true;
      tempPushBuffer = 0;
    }
    //Si llego a la meta
    if(tempPushBuffer >= timePushBuffer){
      tempPushBuffer = 0;
      Net_Ethernet_28j60_startSendTCP(sock1);
    }
  }else{
    if(pushBuffer)
      pushBuffer = false;
  }
}
/******************************************************************************/
void tpv_reconexion(){
  static bool conected = true;

  if(isConectTCP){
    if(sock1->state != 3){   //Intenta reconectar TCP
      //Inicializa el proceso de reconexion
      if(conected){
        conected = false;
        tempCreateNewPort = 0;
        tempReconectTCP = 0;
        //Crea la conexion del tcp
        Net_Ethernet_28j60_connectTCP(ipAddr, portServer, myPort, &sock1); //Reconecta
      }
      //Crea nuevo puerto si llega al limite
      if(tempCreateNewPort >= timeCreateNewPort){
        tempCreateNewPort = 0;
        myPort = clamp_shift(++myPort, myPortMin, myPortMax);
      }
      //Si no ha mandado SYN
      if(tempReconectTCP >= timeReconectTCP){
        tempReconectTCP = 0;
        //Mejorar segun el estado de la conexion
        Net_Ethernet_28j60_connectTCP(ipAddr, portServer, myPort, &sock1);
      }
    }else{
      if(!conected)
        conected = true;
    }
  }
}
/******************************************************************************/
void tpv_buffer_tcp(){
  char estatus;
  
  //Vacia buffer hasta que haya conexion y tenga comunicacion
  if(flagTMR3){   //Vacia buffer cada xms
    if(!pilaBufferTCP)
      return;

    //Pregunta conexion del servidor y cable
    if(isConectServer && isConectTCP && isEmptyBuffer && !sendDataTCP && modoBufferTCP){
      if(!mysql_read_forced(tableEventosTCP, eventosEstatus, pointer, &estatus)){
        usart_write_line("Buscando Eventos TCP...");
        //Elemento no enviado, poner en cola
        if(estatus == '1'){
          string_cpyc(bufferEeprom, TCP_CAN_TPV);
          mysql_read_forced(tableEventosTCP, eventosRegistro, pointer, &bufferEeprom[string_len(bufferEeprom)]);
          punteroTCP = bufferEeprom;
          sendDataTCP = true;
          Net_Ethernet_28j60_UserTCP(sock1);
          Net_Ethernet_28j60_startSendTCP(sock1);
          //Iniciar sistema de retroalimentacion
          modoBufferTCP = false;
          tempRepeatTCP = 0;
          return;
        }
      }
      pointer = clamp_shift(++pointer, 1, myTable.row);
    }
  }
}
/******************************************************************************/
void tpv_buffer_can(){
  char estatus;        //Contiene si es dato de envio
  char nodo, tam, cont;
  
  if(flagTMR3){
    flagTMR3 = false;
    
    if(pilaBufferCAN == 0 || !can.conected)
      return;

    //Verificar que este online la tarjeta por can
    if(!can.rxBusy && !can.txQueu && !modeBufferToNodo){
      if(!mysql_read_forced(tableEventosCAN, eventosEstatus, pointerBufferCAN, &estatus)){
        usart_write_line("Buscando Eventos CAN...");
        if(estatus == '1'){
          //Lectura a quien le voy a enviar el dato
          mysql_read_forced(tableEventosCAN, eventosModulos, pointerBufferCAN, bufferEeprom);
          tam = string_len(bufferEeprom);
          if(tam != 0){
            //Convierte el nodo guardado en entero
            nodo = bufferEeprom[--tam];

            //Verifico si el nodo esta offline y desapilo
            for(cont = 0; cont < tarjetas.modulos; cont++){
              if(nodo == tarjetas.canIdMod[cont] && !tarjetas.canState[cont]){
                bufferEeprom[tam] = 0; //Desapilo y guardo
                mysql_write_forced(tableEventosCAN, eventosModulos, pointerBufferCAN, bufferEeprom, string_len(bufferEeprom)+1);
                usart_write_text("NODO DEAD: ");
                numToString(nodo, msjConst, 2);
                usart_write_line(msjConst);
                return;  //No enviar nodo
              }
            }
            //Enviar por el can el dato
            usart_write_text("Enviar a nodo: ");
            numTostring(nodo, msjConst, 2);
            usart_write_line(msjConst);
            
            //Lectura del registro a enviar
            mysql_read_forced(tableEventosCAN, eventosRegistro, pointerBufferCAN, bufferEeprom);
            if(can_write_text(can.ip+nodo, bufferEeprom, 0));
              modeBufferToNodo = true;
            return;  //No apuntar hacia adelante
          }else{
            //Quiza requiera mecanismo de retroalimentacion para saber que el otro lo recibe
            estatus = '0';
            mysql_write_forced(tableEventosCAN, eventosEstatus, pointerBufferCAN, &estatus, 1);
            pilaBufferCAN--;
            usart_write_text("CAN restan: ");
            inttostr(pilaBufferCAN, msjConst);
            usart_write_line(msjConst);
          }
        }
      }
      pointerBufferCAN = clamp_shift(++pointerBufferCAN, 1, myTable.row);
    }
  }
}
/******************************************************************************/
void tpv_temporizadores(){
  const char CAN_REPORT[] = "CANREPORT";
  const char CAN_ONLINE[] = "ONLINE";
  const char CAN_OFFLINE[] = "OFFLINE";
  const char CAN_CMD_PASSBACK_OFFLINE[] = "CMDPAS0";  //ROMPER SINCRONIA
  const char CAN_CMD_PASSBACK_ONLINE[] =  "CMDPAS1";  //RESTABLECER SYNCORNIA
  char cont;
  //Variables que reportan solo en cambio
  static bool isConectedCan = true;
  
  if(flagSecondTMR3){
    flagSecondTMR3 = 0;
    tempPushBuffer++;
    tempCreateNewPort++;
    tempReconectTCP++;
    tarjetas.canTemp++;
    tempHeartBeatTcp++;
    
    //Verifica la condicion del buffer
    isEmptyBuffer = Net_Ethernet_28j60_bufferEmptyTCP(sock1);

    //Verificar conexion del cable
    if(isConectTCP != spi_tcp_linked()){
      isConectTCP = spi_tcp_linked();
      
      if(isConectTCP)
        usart_write_text("CONEXION POR CABLE \r\n");
      else{
        usart_write_text("DESCONEXION POR CABLE \r\n");
        asm reset;      //No es mejor la forma buscar otra
        //Una vez desconectado reconectamos al conector
        /*
        Net_Ethernet_28j60_disconnectTCP(socket_28j60);
        Net_Ethernet_28j60_Init(myMacAddr, myIpAddr, 0x01);  //Full duplex
        Net_Ethernet_28j60_stackInitTCP();
        */
      }
    }
    //Verificar conexion del servidor
    if(isConectServer != (sock1->state == 3)){
      isConectServer = sock1->state == 3;

      if(isConectServer){
        usart_write_text("ONLINE \r\n");
        tempHeartBeatTcp = 0;
        heartBeatTCP = false;
      }else
        usart_write_text("OFFLINE \r\n");
    }
    //Toogle led de link por conexion y conectado al servidor
    if(isConectTCP && isConectServer && can.conected){
      LED_LINK ^= 1;
    }
    //Verifica que yo tenga can
    if(isConectedCan != can.conected){
      usart_write_text("Conexion CAN: ");
      usart_write_line(can.conected? "Conectado":"Desconectado");
      isConectedCan = can.conected;
      //ENVIAR NOTIFICACION DEL CAN
      string_cpyc(bufferEeprom, CAN_REPORT);
      string_addc(bufferEeprom, TCP_CAN_MOD);
      numToHex(can.id, msjConst, 1);
      string_add(bufferEeprom, msjConst);
      string_addc(bufferEeprom, can.conected?CAN_ONLINE:CAN_OFFLINE);
      buffer_save_send(true, bufferEeprom, tarjetas.canIdMod);
    }
    
    //Verifica que los nodos notifiquen que estan conectados
    if(tarjetas.canTemp >= MAX_TIME_CHECK_MOD){
      tarjetas.canTemp = 0;
      //VERIFICAR SI HY ALGUN NODO SUFRIO DESCONEXION
      for(cont = 0; cont < tarjetas.modulos; cont++){
        if(tarjetas.canState[cont] != tarjetas.canIdReport[cont]){
          //Enviar evento por TCP
          string_cpyc(bufferEeprom, CAN_REPORT);
          string_addc(bufferEeprom, TCP_CAN_MOD);
          numToHex(tarjetas.canIdMod[cont], msjConst, 1);
          string_add(bufferEeprom, msjConst);
          string_addc(bufferEeprom, tarjetas.canIdReport[cont]?CAN_ONLINE:CAN_OFFLINE);
          buffer_save_send(true, bufferEeprom, tarjetas.canIdMod);
          tarjetas.canState[cont] = tarjetas.canIdReport[cont];
          //Apilar eventos
          if(tarjetas.synchrony){
            tarjetas.synchrony = false;
            string_cpyc(bufferEeprom, CAN_CMD_PASSBACK_OFFLINE);
            buffer_save_send(false, bufferEeprom, tarjetas.canIdMod);
            usart_write_line(bufferEeprom);
          }
        }
        tarjetas.canIdReport[cont] = false; //Esperar nueva respuesta
      }
      //VERIFICA SI DEBO INFORMAR SOBRE ALGUN ERROR DE SYNCHRONY
      for(cont = 0; cont < tarjetas.modulos; cont++){
        if(!tarjetas.canState[cont])
          break;
      }
      //Si verifico todos los nodos y estaba desyncronizado, establece SYN
      if(cont == tarjetas.modulos){
        if(!tarjetas.synchrony){
          tarjetas.synchrony = true;
          string_cpyc(bufferEeprom, CAN_CMD_PASSBACK_ONLINE);
          usart_write_line(bufferEeprom);
          buffer_save_send(false, bufferEeprom, tarjetas.canIdMod);
        }
      }
    }
    //Verifica que si mando dato y no proceso repito envio
    if(!modoBufferTCP){
      //Cada 5 segundos repio los datos
      if(++tempRepeatTCP >= 5){
        tempRepeatTCP = 0;  //Reiniciar
        if(isEmptyBuffer)
          modoBufferTCP = true;
      }
    }
    
    //Reconecto si no recibi el ACK correcto
    if(tempHeartBeatTcp >= timeHeartBeatTcp){
      tempHeartBeatTcp = 0;
        
      //Si no recibo el heartBeat reconecto
      if(!heartBeatTCP && isConectServer){
        usart_write_line("Offline heartBeat TCP");
        //APILO EVENTO
        string_cpy(bufferEeprom, "ERRHRB");  //ERROR DE HEARBEAT
        buffer_save_send(true, bufferEeprom, tarjetas.canIdMod);
        asm reset;
        //Net_Ethernet_28j60_disconnectTCP(sock1);
        //Net_Ethernet_28j60_Init(myMacAddr, myIpAddr, 0x01);  //Full duplex
        //Net_Ethernet_28j60_stackInitTCP();
      }
      //Reiniciar bandera
      heartBeatTCP = false;
    }
    
    //Betas code
  }
}
/******************************************************************************/
/********************************** OTHERS ************************************/
/******************************************************************************/
void Net_Ethernet_28j60_UserTCP(SOCKET_28j60_Dsc *socket){
  //Evento por tabla
  static bool responderACK = false;
  const char msjSQLACK[] = "<SQLACK>";
  //Mensajes hacia el TPV
  const char FILAS_ACTUALES[] = "FR:";
  const char FILAS_PROG[] = "FP:";
  //Multiple proposito
  static bool overflow = false;
  char respuesta[MAX_BYTES_TCP];  //Para respuesta de peticion
  unsigned int cont;              //Para contadores generales
  char sizeKey, sizeTotal; //Lleva el control del string request
  static unsigned int contRequest = 0;
  //Para las consultas  de las tablas TCP
  char result;         //Resultado de las consultas en tablas: vigencias, estatus
  int fila, filaAux;   //Fila de busquedas
  long idConsulta, idNuevo;
  long nip, saldo;
  char estatus;
  char nodo;
  bool cmdOwn;         //Comando para nosotros mismos

  //Peticiones como servidor y cliente
  if(!sendDataTCP.B0){
    //Solo si hay datos en buffer continuara
    if(!socket->dataLength)
      return;

    //Peticion como servidor
    if(socket->remotePort == portServer && socket->destPort == myPort){  //Modo servidor
      respuesta[0] = 0;
      //Llego un packete valido recepcionar y decodificar, llegan tramas de 30bytes maximos
      for(cont = 0; cont < socket->dataLength && cont < sizeof(getRequest)-1; cont++){
        getRequest[contRequest] = Net_Ethernet_28j60_getByte();
        //Resetear puntero al inicio
        if(getRequest[contRequest] == '<'){
          contRequest = 0;
          overflow = false;
        }else if(getRequest[contRequest] == '>')
          break;
        else if(getRequest[contRequest] == '!'){
          heartBeatTCP = true;
          continue;
        }else{
          if(contRequest == sizeof(getRequest)-1)
            overflow = true;
          contRequest = clamp_shift(++contRequest, 0, sizeof(getRequest)-1);
        }
      }
      if(getRequest[contRequest] != '>')
        return;
      //Poner el final de cadena
      getRequest[contRequest] = 0;
      
      //Si hubo overflow dato dañado
      if(overflow){
        overflow = false;
        string_cpyc(respuesta, TCP_MESSAGE_OVERFLOW);
        numToHex(sizeof(getRequest), msjConst, 1);
        string_add(respuesta, msjConst);
        getRequest[0] = 0;
      }
      
      //Bytes en buffer
      bytetostr(contRequest, msjConst);
      usart_write_text("Bytes: ");
      usart_write_text(msjConst);
      //Mensaje recepcionado
      usart_write_text(" ,Mensaje: ");
      usart_write_line(getRequest);
      
      //Nuevo comando de tablas
      sizeTotal = 0;  //Siempre inivializar en ceros

      //Comando de respuesta para la tabla
      responderACK = false;
      sizeKey = sizeof(TCP_CAN_TPV)-1;
      if(string_cmpnc(TCP_CAN_TPV, &getRequest[sizeTotal], sizeKey)){
        //Copiar el contenido sin TPV
        string_cpy(getRequest, &getRequest[sizeKey]);
        responderACK = true;
      }

      //Verifica que sea comando pensionado
      sizeKey = sizeof(TCP_CAN_PENSIONADO)-1;
      //FORMATO: PEN + ID(HEX) + COMANDO + TEXTO
      if(string_cmpnc(TCP_CAN_PENSIONADO, &getRequest[sizeTotal], sizeKey)){
        //Obtenemos el ID de consulta
        sizeTotal += sizeKey;
        sizeKey = 6;  //3 Bytes en hexadecimal
        string_cpyn(msjConst, &getRequest[sizeTotal], sizeKey);
        idConsulta = hexToNum(msjConst);
        
        //Buscamos el ID de consulta
        result = !mysql_search(tablePensionados, pensionadosID, idConsulta, &fila);
        //Verificar comando registro
        sizeTotal += sizeKey;
        sizeKey = sizeof(TCP_CAN_REGISTRAR)-1;
        //Respuesta al TPV PEN+ID+CMD
        string_cpyn(respuesta, getRequest, sizeTotal+sizeKey);
        //Respuesta a los modulos
        string_cpyn(bufferEeprom, getRequest, sizeTotal+sizeKey);

        //CONSULTAR EL TIPO DE REGISTRO QUE SE DE DEBE CREAR
        if(string_cmpnc(TCP_CAN_REGISTRAR, &getRequest[sizeTotal], sizeKey)){
          //FORMATO: PEN+ID(HEX)+REG+VIGENCIA+ESTATUS
          sizeTotal += sizeKey;
          estatus = !mysql_search(tablePrepago, prepagoID, idConsulta, &filaAux);
          estatus |= !mysql_search(tableSoporte, soporteID, idConsulta, &filaAux);
          
          if(result || estatus){
            string_addc(respuesta, result?TCP_TBL_DUPLICADO:TCP_TBL_REG_PREVIO);
            bufferEeprom[0] = 0; //FORZAR FINAL DE CADENA
          }else{
            //Intenta registrar el usuario
            result = !mysql_write(tablePensionados, pensionadosID, -1, idConsulta, true);
            //Si lo escribio al final llena los demas datos
            if(result){
              mysql_write(tablePensionados,pensionadosVigencia, myTable.rowAct, getRequest[sizeTotal], false);
              mysql_write(tablePensionados,pensionadosEstatus, myTable.rowAct, getRequest[sizeTotal+1], false);
              string_addc(respuesta, TCP_TBL_REGISTRADO);
            }else{
              string_addc(respuesta, TCP_TBL_LLENA);
              bufferEeprom[0] = 0; //FORZAR FINAL DE CADENA
            }
          }
        }else if(string_cmpnc(TCP_CAN_ACTUALIZAR, &getRequest[sizeTotal], sizeKey)){
          //FORMATO: PEN+ID(HEX)+ACT+IDNEW(HEX)+VIGENCIA+ESTATUS
          sizeTotal += sizeKey;
          if(result){
            //Convertir el nuevo ID
            string_cpyn(msjConst, &getRequest[sizeTotal], 6);
            idNuevo = hexToNum(msjConst);
            if(idNuevo != idConsulta)
              result = !mysql_write(tablePensionados, pensionadosID, fila, idNuevo, false);
            result = !mysql_write(tablePensionados, pensionadosVigencia, fila, getRequest[sizeTotal+6], false);
            result = !mysql_write(tablePensionados, pensionadosEstatus, fila, getRequest[sizeTotal+7], false);
            //Enviar tipo evento
            string_addc(respuesta, result?TCP_TBL_MODIFICADO:TCP_TBL_ERROR);
            if(!result)
              bufferEeprom[0] = 0; //FORZAR FINAL DE CADENA
          }else{
            string_addc(respuesta, TCP_TBL_NO_FOUND);
            bufferEeprom[0] = 0; //FORZAR FINAL DE CADENA
          }
        }else if(string_cmpnc(TCP_CAN_CONSULTAR, &getRequest[sizeTotal], sizeKey)){
          //FORMATO: PEN+ID(HEX)+CON
          sizeTotal += sizeKey;
          if(result){
            mysql_read_string(tablePensionados, pensionadosVigencia, fila, &result);
            string_push(respuesta, result);
            mysql_read_string(tablePensionados, pensionadosEstatus, fila, &result);
            string_push(respuesta, result);
            string_addc(respuesta, TCP_CAN_MODULE);
            numToHex(can.id, msjConst, 1);
            string_add(respuesta, msjConst);
          }else{
            string_addc(respuesta, TCP_TBL_NO_FOUND);
            bufferEeprom[0] = 0; //FORZAR FINAL DE CADENA
          }
        }else if(string_cmpnc(TCP_CAN_VIGENCIA, &getRequest[sizeTotal], sizeKey)){
          //FORMATO: PEN+ID(HEX)+VIG+V
          sizeTotal += sizeKey;
          if(result){
            result = !mysql_write(tablePensionados, pensionadosVigencia, fila, getRequest[sizeTotal], false);
            //Enviar tipo evento
            string_addc(respuesta, result?TCP_TBL_MODIFICADO:TCP_TBL_ERROR);
            if(!result)
              bufferEeprom[0] = 0; //FORZAR FINAL DE CADENA
          }else{
            string_addc(respuesta,TCP_TBL_NO_FOUND);
            bufferEeprom[0] = 0; //FORZAR FINAL DE CADENA
          }
        }else if(string_cmpnc(TCP_CAN_PASSBACK, &getRequest[sizeTotal], sizeKey)){
          //FORMATO: PEN+ID(HEX)+VIG+V
          sizeTotal += sizeKey;
          if(result){
            result = !mysql_write(tablePensionados, pensionadosEstatus, fila, getRequest[sizeTotal], false);
            //Enviar tipo evento
            string_addc(respuesta, result?TCP_TBL_MODIFICADO:TCP_TBL_ERROR);
            if(!result)
              bufferEeprom[0] = 0; //FORZAR FINAL DE CADENA
          }else{
            string_addc(respuesta,TCP_TBL_NO_FOUND);
            bufferEeprom[0] = 0; //FORZAR FINAL DE CADENA
          }
        }else{
          bufferEeprom[0] = 0; //FORZAR FINAL DE CADENA
        }
        //RESPONDER POR CAN A LOS MODULOS
        if(string_len(bufferEeprom) != 0){
          numToString(fila, msjConst, 4);
          string_add(bufferEeprom, msjConst);
          string_add(bufferEeprom, &getRequest[sizeTotal]);
          buffer_save_send(false, bufferEeprom, tarjetas.canIdMod);
          usart_write_text("Se guarda: ");
          usart_write_line(bufferEeprom);
        }else{
          usart_write_line("No se genera evento CAN");
        }
      }else if(string_cmpnc(TCP_CAN_RTC, &getRequest[sizeTotal], sizeKey)){
        //FORMATO: RTC+SET+W+HH+MM+SS+DD+MT+YR
        sizeTotal += sizeKey;
        sizeKey = sizeof(TCP_TABLE_SET)-1;
        string_cpyn(respuesta, getRequest, sizeTotal+sizeKey);
        
        //VERIFICO LOS COMANDOS DEL RTC
        if(string_cmpnc(TCP_TABLE_SET, &getRequest[sizeTotal], sizeKey)){
          sizeTotal += sizeKey;
          //Escritura de la fecha
          DS1307_write_string(&myRTC, &getRequest[sizeTotal]);
          string_addc(respuesta, TCP_TBL_MODIFICADO);
          //ENVIAR EVENTO POR CAN A LOS MODULOS: RTC+SET+W+HH+MM+SS+DD+MT+YY
          buffer_save_send(false, getRequest, tarjetas.canIdMod);
          usart_write_text("Se guarda: ");
          usart_write_line(bufferEeprom);
        }else if(string_cmpnc(TCP_TABLE_GET, &getRequest[sizeTotal], sizeKey)){
          sizeTotal += sizeKey;
          //Escritura de la fecha
          DS1307_read(&myRTC, true);
          string_add(respuesta, myRTC.time);
          string_addc(respuesta, TCP_CAN_MODULE);
          numToHex(can.id, msjConst, 1);
          string_add(respuesta, msjConst);
          //ENVIAR EVENTO POR CAN A LOS MODULOS: RTC+SET+W+HH+MM+SS+DD+MT+YY
          buffer_save_send(false, getRequest, tarjetas.canIdMod);
        }
      }else if(string_cmpnc(TCP_CAN_FOL, &getRequest[sizeTotal], sizeKey)){
        string_cpyc(respuesta, TCP_CAN_FOL);
        //FORMATO: FOL+SET+NUM(HEX), 4 DIGITOS
        sizeTotal += sizeKey;
        sizeKey = sizeof(TCP_TABLE_SET)-1;
        //VERIFICO LOS COMANDOS DEL RTC
        if(string_cmpnc(TCP_TABLE_SET, &getRequest[sizeTotal], sizeKey)){
          sizeTotal += sizeKey;
          //Escritura del folio
          folio = hexToNum(&getRequest[sizeTotal]);
          result = !mysql_write(tableFolio, folioTotal, 1, folio, false);
          string_addc(respuesta,result?TCP_TBL_MODIFICADO:TCP_TBL_ERROR);
        }else if(string_cmpnc(TCP_TABLE_GET, &getRequest[sizeTotal], sizeKey)){
          sizeTotal += sizeKey;
          //Lectura del folio
          result = !mysql_read(tableFolio, folioTotal, 1, &folio);
          numToHex(folio, msjConst, 4);
          if(result){
            string_add(respuesta, msjConst);
            string_addc(respuesta, TCP_CAN_MODULE);
            numToHex(can.id, msjConst, 1);
            string_add(respuesta, msjConst);
          }else
            string_addc(respuesta, TCP_TBL_ERROR);
        }
      }else if(string_cmpnc(TCP_CAN_TICKET, &getRequest[sizeTotal], sizeKey)){
        string_cpyc(respuesta, TCP_CAN_TICKET);
        //FORMATO: TKT+EXP/TPV+CMD
        sizeTotal += sizeKey;
        sizeKey = sizeof(TCP_CAN_TICKET)-1;
        //GENERAR RESPUESTA
        string_cpyc(respuesta, TCP_TABLE);
        string_addc(respuesta, TCP_CAN_TICKET);
        //VERIFICO LOS COMANDOS DEL TICKET
        if(string_cmpnc(TCP_CAN_TPV, &getRequest[sizeTotal], sizeKey)){
          sizeTotal += sizeKey;
          sizeKey = sizeof(TCP_TABLE_ERASE)-1;
          //AÑADIR TPV A LA RESPUESTA
          string_addc(respuesta, TCP_CAN_TPV);
          if(string_cmpnc(TCP_TABLE_ERASE, &getRequest[sizeTotal], sizeKey)){
            //FORMATO: TKT+TPV+ERS
            mysql_erase(tableTicketTPV);
          }else if(string_cmpnc(TCP_CAN_ANEXAR, &getRequest[sizeTotal], sizeKey)){
            sizeTotal += sizeKey;
            sizeKey = sizeTotal + string_len(&getRequest[sizeTotal]);
            //Vaciar en eeprom los datos
            for(cont = sizeTotal; cont < sizeKey; cont++)
              mysql_write(tableTicketTPV, ticketTicket, -1, getRequest[cont], true);
          }else if(string_cmpnc(TCP_CAN_FINALIZAR, &getRequest[sizeTotal], sizeKey)){
            //FIN DE CADENA
            mysql_write(tableTicketTPV, ticketTicket, -1, 0, true);
          }else if(string_cmpnc(TCP_CAN_IMPRIMIR, &getRequest[sizeTotal], sizeKey)){
            if(mysql_read_string(tableTicketTPV, ticketTicket, 1, &result)){
              usart_write_line("Emulando boleto");
              for(cont = 1; cont <= myTable.rowAct; cont++){
                mysql_read_string(tableTicketTPV, ticketTicket, cont, &result);
                usart_write(result);
              }
            }
          }
          //Responde con los bytes escritos
          numToString(myTable.rowAct, msjConst, 4);
          string_add(respuesta, msjConst);
        }else if(string_cmpnc(TCP_CAN_EXP, &getRequest[sizeTotal], sizeKey)){
          sizeTotal += sizeKey;
          sizeKey = sizeof(TCP_TABLE_ERASE)-1;
          //AÑADIR TPV A LA RESPUESTA
          string_addc(respuesta, TCP_CAN_EXP);
          if(string_cmpnc(TCP_TABLE_ERASE, &getRequest[sizeTotal], sizeKey)){
            //FORMATO: TKT+TPV+ERS
            mysql_erase(tableTicketEXP);
          }else if(string_cmpnc(TCP_CAN_ANEXAR, &getRequest[sizeTotal], sizeKey)){
            sizeTotal += sizeKey;
            sizeKey = sizeTotal + string_len(&getRequest[sizeTotal]);
            //Vaciar en eeprom los datos
            for(cont = sizeTotal; cont < sizeKey; cont++)
              mysql_write(tableTicketEXP, ticketTicket, -1, getRequest[cont], true);
          }else if(string_cmpnc(TCP_CAN_FINALIZAR, &getRequest[sizeTotal], sizeKey)){
            //FIN DE CADENA
            mysql_write(tableTicketEXP, ticketTicket, -1, 0, true);
          }else if(string_cmpnc(TCP_CAN_IMPRIMIR, &getRequest[sizeTotal], sizeKey)){
            if(mysql_read_string(tableTicketEXP, ticketTicket, 1, &result)){
              usart_write_line("Emulando boleto");
              for(cont = 1; cont <= myTable.rowAct; cont++){
                mysql_read_string(tableTicketEXP, ticketTicket, cont, &result);
                usart_write(result);
              }
              usart_write_line("");
            }
          }
          //Responde con los bytes escritos
          numToString(myTable.rowAct, msjConst, 4);
          string_add(respuesta, msjConst);
        }
      }else if(string_cmpnc(TCP_CAN_PREPAGO, &getRequest[sizeTotal], sizeKey)){
        //Obtenemos el ID de consulta
        sizeTotal += sizeKey;
        sizeKey = 6;  //3 Bytes en hexadecimal
        string_cpyn(msjConst, &getRequest[sizeTotal], sizeKey);
        idConsulta = hexToNum(msjConst);
        //Buscamos el ID de consulta
        result = !mysql_search(tablePrepago, prepagoID, idConsulta, &fila);
        //Verificar comando registro
        sizeTotal += sizeKey;
        sizeKey = sizeof(TCP_CAN_REGISTRAR)-1;
        //Respuesta al TPV PRE+ID+CMD
        string_cpyn(respuesta, getRequest, sizeTotal+sizeKey);
        //Respuesta a los modulos
        string_cpyn(bufferEeprom, getRequest, sizeTotal+sizeKey);
        //CONSULTAR EL TIPO DE REGISTRO QUE SE DE DEBE CREAR
        if(string_cmpnc(TCP_CAN_REGISTRAR, &getRequest[sizeTotal], sizeKey)){
          //FORMATO: PRE+ID(6HEX)+REG+NIP(8HEX)+SALDO(8HEX)+ESTATUS
          sizeTotal += sizeKey;
          //BUSCAMOS QUE NO TENGA REGISTROS EN LA OTRA TABLA
          estatus = !mysql_search(tablePensionados, pensionadosID, idConsulta, &filaAux);
          estatus |= !mysql_search(tableSoporte, soporteID, idConsulta, &filaAux);
          
          if(result || estatus){
            string_addc(respuesta, result?TCP_TBL_DUPLICADO:TCP_TBL_REG_PREVIO);
            bufferEeprom[0] = 0; //FORZAR FINAL DE CADENA
          }else{
            //Intenta registrar el usuario
            result = !mysql_write(tablePrepago, prepagoID, -1, idConsulta, true);
            //Si lo escribio al final llena los demas datos
            if(result){
              string_cpyn(msjConst, &getRequest[sizeTotal], 8);
              nip = hexToNum(msjConst);
              string_cpyn(msjConst, &getRequest[sizeTotal+8], 8);
              saldo = hexToNum(msjConst);
              estatus =  getRequest[sizeTotal+16];
              //Escribir en la tabla
              mysql_write(tablePrepago,prepagoNIP, myTable.rowAct, nip, false);
              mysql_write(tablePrepago,prepagoSaldo, myTable.rowAct, saldo, false);
              mysql_write(tablePrepago,prepagoEstatus, myTable.rowAct, estatus, false);
              string_addc(respuesta, TCP_TBL_REGISTRADO);
            }else{
              string_addc(respuesta, TCP_TBL_LLENA);
              bufferEeprom[0] = 0; //FORZAR FINAL DE CADENA
            }
          }
        }else if(string_cmpnc(TCP_CAN_ACTUALIZAR, &getRequest[sizeTotal], sizeKey)){
          //FORMATO: PRE+ID(6HEX)+ACT+IDNEW(8HEX)+NIP(8HEX)+SALDO(8HEX)+ESTATUS
          sizeTotal += sizeKey;
          if(result){
            //Convertir el nuevo ID
            string_cpyn(msjConst, &getRequest[sizeTotal], 6);
            idNuevo = hexToNum(msjConst);
            string_cpyn(msjConst, &getRequest[sizeTotal+6], 8);
            nip = hexToNum(msjConst);
            string_cpyn(msjConst, &getRequest[sizeTotal+14], 8);
            saldo = hexToNum(msjConst);
            estatus =  getRequest[sizeTotal+22];
            
            if(idNuevo != idConsulta)
              result = !mysql_write(tablePrepago, prepagoID, fila, idNuevo, false);
            result = !mysql_write(tablePrepago,prepagoNIP, fila, nip, false);
            result = !mysql_write(tablePrepago,prepagoSaldo, fila, saldo, false);
            result = !mysql_write(tablePrepago,prepagoEstatus, fila, estatus, false);
            //Enviar tipo evento
            string_addc(respuesta, result?TCP_TBL_MODIFICADO:TCP_TBL_ERROR);
            if(!result)
              bufferEeprom[0] = 0; //FORZAR FINAL DE CADENA
          }else{
            string_addc(respuesta, TCP_TBL_NO_FOUND);
            bufferEeprom[0] = 0; //FORZAR FINAL DE CADENA
          }
        }else if(string_cmpnc(TCP_CAN_CONSULTAR, &getRequest[sizeTotal], sizeKey)){
          //FORMATO: PRE+ID(HEX)+CON
          sizeTotal += sizeKey;
          if(result){
            mysql_read(tablePrepago, prepagoNIP, fila, &nip);
            numToHex(nip, msjConst, 4);
            string_add(respuesta, msjConst);
            mysql_read(tablePrepago, prepagoSaldo, fila, &saldo);
            numToHex(saldo, msjConst, 4);
            string_add(respuesta, msjConst);
            mysql_read_string(tablePrepago, prepagoEstatus, fila, &estatus);
            string_push(respuesta, estatus);
            string_addc(respuesta, TCP_CAN_MODULE);
            numToHex(can.id, msjConst, 1);
            string_add(respuesta, msjConst);
          }else{
            string_addc(respuesta, TCP_TBL_NO_FOUND);
            bufferEeprom[0] = 0; //FORZAR FINAL DE CADENA
          }
        }else if(string_cmpnc(TCP_CAN_NIP, &getRequest[sizeTotal], sizeKey)){
          //FORMATO: PRE+ID(HEX)+NIP+NIP(HEX)
          sizeTotal += sizeKey;
          if(result){
            string_cpyn(msjConst, &getRequest[sizeTotal], 8);
            nip = hexToNum(msjConst);
            result = !mysql_write(tablePrepago, prepagoNIP, fila, nip, false);
            //Enviar tipo evento
            string_addc(respuesta, result?TCP_TBL_MODIFICADO:TCP_TBL_ERROR);
            if(!result)
              bufferEeprom[0] = 0; //FORZAR FINAL DE CADENA
          }else{
            string_addc(respuesta,TCP_TBL_NO_FOUND);
            bufferEeprom[0] = 0; //FORZAR FINAL DE CADENA
          }
        }else if(string_cmpnc(TCP_CAN_SALDO, &getRequest[sizeTotal], sizeKey)){
          //FORMATO: PRE+ID(HEX)+SLD+SALDO(HEX)
          sizeTotal += sizeKey;
          if(result){
            string_cpyn(msjConst, &getRequest[sizeTotal], 8);
            saldo = hexToNum(msjConst);
            result = !mysql_write(tablePrepago, prepagoSaldo, fila, saldo, false);
            //Enviar tipo evento
            string_addc(respuesta, result?TCP_TBL_MODIFICADO:TCP_TBL_ERROR);
            if(!result)
              bufferEeprom[0] = 0; //FORZAR FINAL DE CADENA
          }else{
            string_addc(respuesta,TCP_TBL_NO_FOUND);
            bufferEeprom[0] = 0; //FORZAR FINAL DE CADENA
          }
        }else if(string_cmpnc(TCP_CAN_PASSBACK, &getRequest[sizeTotal], sizeKey)){
          //FORMATO: PRE+ID(HEX)+PAS+ESTATUS
          sizeTotal += sizeKey;
          if(result){
            estatus = getRequest[sizeTotal];
            result = !mysql_write(tablePrepago, prepagoEstatus, fila, estatus, false);
            //Enviar tipo evento
            string_addc(respuesta, result?TCP_TBL_MODIFICADO:TCP_TBL_ERROR);
            if(!result)
              bufferEeprom[0] = 0; //FORZAR FINAL DE CADENA
          }else{
            string_addc(respuesta,TCP_TBL_NO_FOUND);
            bufferEeprom[0] = 0; //FORZAR FINAL DE CADENA
          }
        }else{
          bufferEeprom[0] = 0; //FORZAR FINAL DE CADENA
        }
        //RESPONDER POR CAN A LOS MODULOS
        if(string_len(bufferEeprom) != 0){
          numToString(fila, msjConst, 4);
          string_add(bufferEeprom, msjConst);
          string_add(bufferEeprom, &getRequest[sizeTotal]);
          buffer_save_send(false, bufferEeprom, tarjetas.canIdMod);
          usart_write_text("Se guarda: ");
          usart_write_line(bufferEeprom);
        }else{
          usart_write_line("No se genera evento CAN");
        }
      }else if(string_cmpnc(TCP_CAN_SOPORTE, &getRequest[sizeTotal], sizeKey)){
        //Obtenemos el ID de consulta
        sizeTotal += sizeKey;
        sizeKey = 6;  //3 Bytes en hexadecimal
        string_cpyn(msjConst, &getRequest[sizeTotal], sizeKey);
        idConsulta = hexToNum(msjConst);
        //Buscamos el ID de consulta
        result = !mysql_search(tableSoporte, soporteID, idConsulta, &fila);
        //Verificar comando registro
        sizeTotal += sizeKey;
        sizeKey = sizeof(TCP_CAN_REGISTRAR)-1;
        //Respuesta al TPV PEN+ID+CMD
        string_cpyn(respuesta, getRequest, sizeTotal+sizeKey);
        //Respuesta a los modulos
        string_cpyn(bufferEeprom, getRequest, sizeTotal+sizeKey);
        
        //CONSULTAR EL TIPO DE REGISTRO QUE SE DE DEBE CREAR
        if(string_cmpnc(TCP_CAN_REGISTRAR, &getRequest[sizeTotal], sizeKey)){
          //FORMATO: TEC+ID(HEX)+REG
          sizeTotal += sizeKey;
          estatus = !mysql_search(tablePrepago, prepagoID, idConsulta, &filaAux);
          estatus |= !mysql_search(tablePensionados, pensionadosID, idConsulta, &filaAux);
          
          if(result || estatus){
            string_addc(respuesta, result?TCP_TBL_DUPLICADO:TCP_TBL_REG_PREVIO);
            bufferEeprom[0] = 0; //FORZAR FINAL DE CADENA
          }else{
            //Intenta registrar el usuario
            result = !mysql_write(tableSoporte, soporteID, -1, idConsulta, true);
            //Si lo escribio al final llena los demas datos
            if(result){
              string_addc(respuesta, TCP_TBL_REGISTRADO);
            }else{
              string_addc(respuesta, TCP_TBL_LLENA);
              bufferEeprom[0] = 0; //FORZAR FINAL DE CADENA
            }
          }
        }else if(string_cmpnc(TCP_CAN_CONSULTAR, &getRequest[sizeTotal], sizeKey)){
          //FORMATO: TEX+ID(HEX)+CON
          sizeTotal += sizeKey;
          if(result){
            string_addc(respuesta, TCP_CAN_MODULE);
            numToHex(can.id, msjConst, 1);
            string_add(respuesta, msjConst);
          }else{
            string_addc(respuesta, TCP_TBL_NO_FOUND);
            bufferEeprom[0] = 0; //FORZAR FINAL DE CADENA
          }
        }else{
          bufferEeprom[0] = 0; //FORZAR FINAL DE CADENA
        }
        
        //RESPONDER POR CAN A LOS MODULOS
        if(string_len(bufferEeprom) != 0){
          numToString(fila, msjConst, 4);
          string_add(bufferEeprom, msjConst);
          string_add(bufferEeprom, &getRequest[sizeTotal]);
          buffer_save_send(false, bufferEeprom, tarjetas.canIdMod);
          usart_write_text("Se guarda: ");
          usart_write_line(bufferEeprom);
        }else{
          usart_write_line("No se genera evento CAN");
        }
      }else if(string_cmpnc(TCP_TABLE, &getRequest[sizeTotal], sizeKey)){
        sizeTotal += sizeKey;
        sizeKey = sizeof(TCP_TABLE_ERASE)-1;  //FORMATO ALL/T00/EXX
        //Respuesta al TPV TBL
        string_cpyn(respuesta, getRequest, sizeTotal);
        //Respuesta a los modulos
        string_cpyn(bufferEeprom, getRequest, sizeTotal);
        string_add(bufferEeprom, &getRequest[sizeTotal+sizeKey]);
        //DECIDIR RETRANSMISION
        cmdOwn = true;
        if(string_cmpnc(TCP_CAN_MODULE_ALL, &getRequest[sizeTotal], sizeKey)){
          buffer_save_send(false, bufferEeprom, tarjetas.canIdMod);
        }else{ //PREGUNTAR QUE OTRO NODO DEBO ENVIAR
          if(getRequest[sizeTotal] != TCP_CAN_MODULE[0]){
            cmdOwn = false;
            //Validar que sea E ó V?
            string_cpyn(msjConst, &getRequest[sizeTotal+1], 2);
            nodo = hexToNum(msjConst);
            for(result = 0; result < tarjetas.modulos; result++){
              if(nodo == tarjetas.canIdMod[result]){
                //Apilo nodo de envio
                msjConst[0] = nodo;
                msjConst[1] = 0;  //Fin de cadena anexado
                buffer_save_send(false, bufferEeprom, msjConst);
                break;//No enviar respuesta con TPV si no con el modulo
              }
            }
            //SI EL NODO NO EXISTE CONCATENO ERROR
            if(result == tarjetas.modulos)
              string_addc(respuesta, TCP_TBL_ERROR);
            else
              string_addc(respuesta, TCP_TBL_OK);
          }
        }
        
        //FORMATO: TBL+ALL+ERS
        sizeTotal += sizeKey;
        sizeKey = sizeof(TCP_TABLE_ERASE)-1;

        //EVALUAR CASO
        if(string_cmpnc(TCP_TABLE_ERASE, &getRequest[sizeTotal], sizeKey) && cmdOwn){
          //FORMATO: TBL+NODO+ERS+NAME
          sizeTotal += sizeKey;
          
          if(mysql_erase(&getRequest[sizeTotal])){
            //Nombre de la tabla
            string_addc(respuesta, TCP_TABLE_ERASE);
            string_cpyn(msjConst, &getRequest[sizeTotal], 3);
            string_toUpper(msjConst);
            string_add(respuesta, msjConst);
          }else{
            string_addc(respuesta, TCP_TABLE_ERASE);
            string_addc(respuesta, TCP_TBL_NO_FOUND);
            bufferEeprom[0] = 0;
          }
          //Enviar quien responde
          string_cpyc(msjConst, TCP_CAN_MODULE);
          numToHex(can.id, &msjConst[1], 1);
          string_add(respuesta, msjConst);
        }else if(string_cmpnc(TCP_TABLE_INFO, &getRequest[sizeTotal], sizeKey) && cmdOwn){
          //FORMATO: TBL+NODO+INF+NAME
          sizeTotal += sizeKey;
          if(mysql_exist(&getRequest[sizeTotal])){
            string_addc(respuesta, TCP_TABLE_INFO);
            //Nombre de la tabla
            string_cpyn(msjConst, &getRequest[sizeTotal], 3);
            string_toUpper(msjConst);
            string_add(respuesta, msjConst);
            //Filas actuales
            string_addc(respuesta, FILAS_ACTUALES);
            numToString(myTable.rowAct, msjConst, 4);
            string_add(respuesta, msjConst);
            //Filas prog
            string_addc(respuesta, FILAS_PROG);
            numToString(myTable.row, msjConst, 4);
            string_add(respuesta, msjConst);
          }else{
            string_addc(respuesta, TCP_TABLE_INFO);
            string_addc(respuesta, TCP_TBL_NO_FOUND);
            bufferEeprom[0] = 0;
          }
          //Enviar quien responde
          string_cpyc(msjConst, TCP_CAN_MODULE);
          numToHex(can.id, &msjConst[1], 1);
          string_add(respuesta, msjConst);
        }
      }else if(string_cmpnc(TCP_CAN_CMD, &getRequest[sizeTotal], sizeKey)){
        sizeTotal += sizeKey;
        sizeKey = sizeof(TCP_CAN_MODULE_ALL)-1;
        //Respuesta al TPV TBL
        string_cpyn(respuesta, getRequest, sizeTotal);
        //Respuesta a los modulos
        string_cpyn(bufferEeprom, getRequest, sizeTotal);
        string_add(bufferEeprom, &getRequest[sizeTotal+sizeKey]);
        //DECIDIR RETRANSMISION
        cmdOwn = true;
        if(string_cmpnc(TCP_CAN_MODULE_ALL, &getRequest[sizeTotal], sizeKey)){
          buffer_save_send(false, bufferEeprom, tarjetas.canIdMod);
        }else{ //PREGUNTAR QUE OTRO NODO DEBO ENVIAR
          if(getRequest[sizeTotal] != TCP_CAN_MODULE[0]){
            cmdOwn = false;
            //Validar que sea E ó V?
            string_cpyn(msjConst, &getRequest[sizeTotal+1], 2);
            nodo = hexToNum(msjConst);
            for(result = 0; result < tarjetas.modulos; result++){
              if(nodo == tarjetas.canIdMod[result]){
                //Apilo nodo de envio
                msjConst[0] = nodo;
                msjConst[1] = 0;  //Fin de cadena anexado
                buffer_save_send(false, bufferEeprom, msjConst);
                break;//No enviar respuesta con TPV si no con el modulo
              }
            }
            //SI EL NODO NO EXISTE CONCATENO ERROR
            if(result == tarjetas.modulos)
              string_addc(respuesta, TCP_TBL_ERROR);
            else{
              string_addc(respuesta, TCP_TBL_OK);
            }
          }
        }
        //FORMATO: TBL+ALL+ERS
        sizeTotal += sizeKey;
        sizeKey = sizeof(TCP_TABLE_ERASE)-1;
        //PROGRAMAR EVENTO
      }else if(string_cmpnc(TCP_SQL, &getRequest[sizeTotal], sizeKey)){
        sizeTotal += sizeKey;
        sizeKey = sizeof(TCP_SQL_WRITE)-1;
        
        if(string_cmpnc(TCP_SQL_WRITE, &getRequest[sizeTotal], sizeKey)){
          sizeTotal += sizeKey;

          //Si el dato fue escrito en la DB entonces vacio el siguiente dato
          if(getRequest[sizeTotal] == '1'){
            if(!modoBufferTCP){
              modoBufferTCP = true; //Permite el siguiente envio
              mysql_write_forced(tableEventosTCP, eventosEstatus, pointer, "0", 1);
              pilaBufferTCP = clamp(--pilaBufferTCP, 0, 65535);
              inttostr(pilaBufferTCP, msjConst);
              usart_write_text("Restan: ");
              usart_write_line(msjConst);
            }else{
              usart_write_line("No proceso");
            }
          }
        }
      }else if(string_cmpnc(TCP_CAN_NODOS, &getRequest[sizeTotal], sizeKey)){
        sizeTotal += sizeKey;
        sizeKey = sizeof(TCP_CAN_REGISTRAR)-1;
        //Crear respuesta
        string_cpyc(respuesta, TCP_CAN_NODOS);
        //Evaluar casos
        if(string_cmpnc(TCP_CAN_REGISTRAR, &getRequest[sizeTotal], sizeKey)){
          string_addc(respuesta, TCP_CAN_REGISTRAR);
          sizeTotal +=sizeKey;
          //NOD+REG+HEX(NODO)
          string_cpyn(msjConst, &getRequest[sizeTotal], 2);
          idConsulta = clamp(hexToNum(msjConst), 1, MAX_MODULES);
          
          if(!mysql_search(tableNodos, nodosName, idConsulta, &fila)){
            string_addc(respuesta, TCP_TBL_DUPLICADO);
          }else{
            result = !mysql_write(tableNodos, nodosName, -1, idConsulta, true);
            //Si lo escribio al final llena los demas datos
            if(result)
              string_addc(respuesta, TCP_TBL_REGISTRADO);
            else
              string_addc(respuesta, TCP_TBL_LLENA);
          }
        }else if(string_cmpnc(TCP_CAN_CONSULTAR, &getRequest[sizeTotal], sizeKey)){
          string_addc(respuesta, TCP_CAN_CONSULTAR);
          //NODO+CON
          sizeTotal +=sizeKey;
          
          if(mysql_exist(tableNodos)){
            for(cont = 1; cont <= myTable.rowAct && cont <= MAX_MODULES; cont++){
              mysql_read(tableNodos, nodosName, cont, &idConsulta);
              numToHex(idConsulta, msjConst, 1);
              string_add(respuesta, msjConst);
            }
          }else{
            string_addc(respuesta, TCP_TBL_NO_FOUND);
          }
        }
        //Añadir quien responde
        string_addc(respuesta, TCP_CAN_MODULE);
        numToHex(can.id, msjConst, 1);
        string_add(respuesta, msjConst);
      }else if(string_cmpnc(TCP_CAN_RESET, &getRequest[sizeTotal], sizeKey)){
        asm reset;
      }
      
      //Responder si es version tabla
      if(responderACK){
        responderACK = false;
        cont = 0;
        while(msjSQLACK[cont])
          Net_Ethernet_28j60_putByteTCP(msjSQLACK[cont++],socket_28j60);
      }
      
      //RESPONDER AL SERVIDOR
      Net_Ethernet_28j60_putByteTCP('<',socket_28j60);
      cont = 0;
      while(respuesta[cont])
        Net_Ethernet_28j60_putByteTCP(respuesta[cont++],socket_28j60);
      Net_Ethernet_28j60_putByteTCP('>',socket_28j60);
    }//PROCESA EL PUERTO DESTINO
  }else{ //Se transmite datos hacia la app
    cont = 0;
    Net_Ethernet_28j60_putByteTCP('<',socket_28j60);
    while(punteroTCP[cont])
      Net_Ethernet_28j60_putByteTCP(punteroTCP[cont++],socket_28j60);
    Net_Ethernet_28j60_putByteTCP('>',socket_28j60);
    sendDataTCP.B0 = false;  //Resetear bandera
  }
  //Net_Ethernet_28j60_disconnectTCP(socket_28j60);
}
/******************************************************************************/
unsigned int Net_Ethernet_28j60_UserUDP(SOCKET_28j60_Dsc *socket){
  return 0;
}
/******************************************************************************/
void usart_user_read_text(){
  if(!usart.rx_overflow){
    usart_write_text("Se recibio: ");
    usart_write_text(usart.message);
    usart_write_text("\r\n");
    //Valida informacion: busco en la tabla el boleto
  }else{
    usart.rx_overflow = 0;
    usart_write_text("Dato dañado overflow\r\n");
  }
}
/******************************************************************************/
void can_user_read_message(){
  char sizeKey, sizeTotal; //Para los mensajes
  char estatus;            //Estatus ó passback
  int fila;
  long idConsulta, id;
  long saldo;
  
  //Codigo eliminable
  usart_write_text("Se recibio data por can: ");
  usart_write_line(can.rxBuffer);
  
  //Verificar que tipo de comando fue, passback: PEN+ID(HEX)+COMAND+FILA+I
  sizeTotal = 0;
  sizeKey = sizeof(TCP_CAN_TPV)-1;
  if(string_cmpnc(TCP_CAN_TPV, &can.rxBuffer[sizeTotal], sizeKey)){
    sizeTotal += sizeKey;
    usart_write_line("Evento TPV a ser guardado");
    buffer_save_send(true, &can.rxBuffer[sizeTotal], tarjetas.canIdMod);
  }else if(string_cmpnc(TCP_CAN_PENSIONADO, &can.rxBuffer[sizeTotal], sizeKey)){
    //Obtener el ID
    sizeTotal += sizeKey;
    sizeKey = 6;
    string_cpyn(msjConst, &can.rxBuffer[sizeTotal], sizeKey);
    idConsulta = hexToNum(msjConst);
    //Obtengo el control de accion
    sizeTotal += sizeKey;
    sizeKey = sizeof(TCP_CAN_PASSBACK)-1;
    if(string_cmpnc(TCP_CAN_PASSBACK, &can.rxBuffer[sizeTotal], sizeKey)){
      //Obtener Fila
      sizeTotal += sizeKey;
      sizeKey = 4;
      string_cpyn(msjConst, &can.rxBuffer[sizeTotal], sizeKey);
      fila = stringToNum(msjConst);
      //Obtener el passback
      sizeTotal += sizeKey;
      sizeKey = 1;
      estatus = can.rxBuffer[sizeTotal];
      //Cambiar estatus del passback tabla
      if(!mysql_read(tablePensionados, pensionadosID, fila, &id)){
        if(id == idConsulta){
          mysql_write(tablePensionados, pensionadosEstatus, fila, estatus, false);
          buffer_save_send(false, can.rxBuffer, tarjetas.canIdMod);
        }
      }
    }
  }else if(string_cmpnc(TCP_CAN_PREPAGO, &can.rxBuffer[sizeTotal], sizeKey)){
    //Obtener el ID
    sizeTotal += sizeKey;
    sizeKey = 6;
    string_cpyn(msjConst, &can.rxBuffer[sizeTotal], sizeKey);
    idConsulta = hexToNum(msjConst);
    //Obtengo el control de accion
    sizeTotal += sizeKey;
    sizeKey = sizeof(CAN_SPECIAL_DATE)-1;
    //Procesar comando
    if(string_cmpnc(CAN_SPECIAL_DATE, &can.rxBuffer[sizeTotal], sizeKey)){
      //Obtener Fila
      sizeTotal += sizeKey;
      sizeKey = 4;
      string_cpyn(msjConst, &can.rxBuffer[sizeTotal], sizeKey);
      fila = stringToNum(msjConst);
      //Obtener el passback
      sizeTotal += sizeKey;
      sizeKey = 1;
      estatus = can.rxBuffer[sizeTotal];
      //Obetener la fecha
      sizeTotal += sizeKey;
      sizeKey = 12;
      string_cpyn(msjConst, &can.rxBuffer[sizeTotal], sizeKey);
      //Cambiar estatus del passback y date
      if(!mysql_read(tablePrepago, prepagoID, fila, &id)){
        if(id == idConsulta){
          //Config
          usart_write_line("Modificado PAS+DATE");
          mysql_write(tablePrepago, prepagoEstatus, fila, estatus, false);
          mysql_write_string(tablePrepago, prepagoDate, fila, msjConst, false);
          buffer_save_send(false, can.rxBuffer, tarjetas.canIdMod);
        }
      }
    }else if(string_cmpnc(CAN_SPECIAL_SALDO, &can.rxBuffer[sizeTotal], sizeKey)){
      //Obtener Fila
      sizeTotal += sizeKey;
      sizeKey = 4;
      string_cpyn(msjConst, &can.rxBuffer[sizeTotal], sizeKey);
      fila = stringToNum(msjConst);
      //Obtener el passback
      sizeTotal += sizeKey;
      sizeKey = 1;
      estatus = can.rxBuffer[sizeTotal];
      //Obetener el saldo
      sizeTotal += sizeKey;
      sizeKey = 8;
      string_cpyn(msjConst, &can.rxBuffer[sizeTotal], sizeKey);
      saldo = hexToNum(msjConst);
      //Cambiar estatus del passback y date
      if(!mysql_read(tablePrepago, prepagoID, fila, &id)){
        if(id == idConsulta){
          //Config
          usart_write_line("Modificado PAS+SALDO");
          mysql_write(tablePrepago, prepagoEstatus, fila, estatus, false);
          mysql_write(tablePrepago, prepagoSaldo, fila, saldo, false);
          buffer_save_send(false, can.rxBuffer, tarjetas.canIdMod);
        }
      }
    }else if(string_cmpnc(TCP_CAN_PASSBACK, &can.rxBuffer[sizeTotal], sizeKey)){
      //Obtener Fila
      sizeTotal += sizeKey;
      sizeKey = 4;
      string_cpyn(msjConst, &can.rxBuffer[sizeTotal], sizeKey);
      fila = stringToNum(msjConst);
      //Obtener el passback
      sizeTotal += sizeKey;
      sizeKey = 1;
      estatus = can.rxBuffer[sizeTotal];
      
      //Cambiar estatus del passback
      if(!mysql_read(tablePrepago, prepagoID, fila, &id)){
        if(id == idConsulta){
          //Config
          usart_write_line("Modificado PAS");
          mysql_write(tablePrepago, prepagoEstatus, fila, estatus, false);
          buffer_save_send(false, can.rxBuffer, tarjetas.canIdMod);
        }
      }
    }
  }
}
/******************************************************************************/
void can_user_write_message(){
  char tam;
  if(can.tx_status == CAN_RW_ENVIADO){
    if(modeBufferToNodo){
      usart_write_line("Envio entregado del nodo");
      modeBufferToNodo = false;
      //Desapilar
      mysql_read_forced(tableEventosCAN, eventosModulos, pointerBufferCAN, bufferEeprom);
      tam = string_len(bufferEeprom);
      //Por seguridad
      if(tam != 0){
        bufferEeprom[--tam] = 0;
        mysql_write_forced(tableEventosCAN, eventosModulos, pointerBufferCAN, bufferEeprom, string_len(bufferEeprom)+1);
        
        //Si envio a todos los nodos entonces decido que hacer
        if(tam == 0){
          usart_write_text("Linea completa: ");
          usart_write_line(can.txBuffer);
        }
      }
    }
  }else if(can.tx_status == CAN_RW_CORRUPT){
    //Guardar eventos que no fueron previamente guardados
    if(!modeBufferToNodo){
      buffer_save_send(true, can.txBuffer, tarjetas.canIdMod);
    }else{
      //No guarda eventos ya guardados
      modeBufferToNodo = false;
      usart_write_line("No se pudo enviar al nodo");
    }
  }
}
/******************************************************************************/
void can_user_guardHeartBeat(char idNodo){
  char cont = 0;
  
  //Verificar el nodo que se conecta
  for(cont = 0; cont < tarjetas.modulos; cont++){
    if(idNodo == tarjetas.canIdMod[cont]){
      tarjetas.canIdReport[cont] = true;
      //Mandar online si esta offline, inmediatamente
      if(tarjetas.canState[cont] != tarjetas.canIdReport[cont]){
        //Supongo que el problema del ciclado es aqui
        //tarjetas.canTemp = MAX_TIME_CHECK_MOD;
      }
      break;
    }
  }
}
/******************************************************************************/
void buffer_save_send(bool tcpORcan, char *buffer, char *nodosCAN){
  char estatus;

  if(tcpORcan){
    //Parche de la comita
    if(!isConectServer)
      string_addc(buffer, ",");
    mysql_write_roundTrip(tableEventosTCP, eventosRegistro, buffer, strlen(buffer)+1);
    mysql_read_forced(tableEventosTCP, eventosEstatus, myTable.rowAct, &estatus);
    //Subir buffer si no fue sobreescritura
    if(estatus != '1')
      pilaBufferTCP++;
    //Forzar evento
    mysql_write_forced(tableEventosTCP, eventosEstatus, myTable.rowAct, "1", 1);
    //Mostrar
    usart_write_text("FR: ");
    inttostr(myTable.rowAct, msjConst);
    usart_write_text(msjConst);
    usart_write_text(", FT: ");
    inttostr(pilaBufferTCP, msjConst);
    usart_write_text(msjConst);
    usart_write_line(", Registrado TCP");
  }else{
    //Guardar en buffer eventos si no fue guardado
    mysql_write_roundTrip(tableEventosCAN, eventosRegistro, buffer, string_len(buffer)+1);
    mysql_read_forced(tableEventosCAN, eventosEstatus, myTable.rowAct, &estatus);
    //Subir buffer si no fue sobreescritura
    if(estatus != '1')
      pilaBufferCAN++;
    mysql_write_forced(tableEventosCAN, eventosEstatus, myTable.rowAct, "1", 1);
    //Guardar buffer de los modulos
    //mysql_write_forced(tableEventosCAN, eventosModulos, myTable.rowAct, tarjetas.canIdMod, string_len(tarjetas.canIdMod)+1);
    mysql_write_forced(tableEventosCAN, eventosModulos, myTable.rowAct, nodosCAN, string_len(nodosCAN)+1);
  }
}
/******************************************************************************/
void lcd_clean_row(char fila){
  char i = 20;

  while(i)
    lcd_chr(fila, i--, ' ');
}
/******************************************************************************/
/***************************** INTERRUPCIONES *********************************/
/******************************************************************************/
void int_timer1(){
  static char temp = 0;
  
  if(PIR1.TMR1IF && PIE1.TMR1IE){
    //ESPERAR CADA SEGUNDO PARA APAGAR RELE
    if(++temp >= 5){
      temp = 0;
      SALIDA_RELE1 = 0;  //APAGAR RELE DESPUES DE UN SEGUNDO
      PIE1.TMR1IE = 0;  //DESACTIVAR EL TIMER1
    }

    //FINALIZAR INTERRUPCION
    TMR1H = getByte(sampler1,1);
    TMR1L = getByte(sampler1,0);
    PIR1.TMR1IF = 0;   //LIMPIAR BANDERA
  }
}
/******************************************************************************/
void int_timer3(){
  static char temp = 0;
  
  if(PIR2.TMR3IF && PIE2.TMR3IE){
    can.temp += 200;     //Can protocol
    flagTMR3.B0 = true;  //CADA XMS
    //ESPERAR CADA SEGUNDO PARA APAGAR RELE
    if(++temp >= 5){
      temp = 0;
      flagSecondTMR3.B0 = true;
      Net_Ethernet_28j60_UserTimerSec++;    //Para el protocolo tcp
    }
    //FINALIZAR INTERRUPCION
    TMR3H = getByte(sampler3,1);
    TMR3L = getByte(sampler3,0);
    PIR2.TMR3IF = 0;   //LIMPÍAR BANDERA
  }
}
/******************************************************************************/