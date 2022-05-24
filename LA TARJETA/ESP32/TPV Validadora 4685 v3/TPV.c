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
#include "_lib_cryptography.h"
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
#include "lcd_4x20.h"
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
//TOLERANCIA PARA SALIR DEL RANGO
const int TOLERANCIA_OUT = 15*60 + 10;  //Tolerancia de salida + rangoPermisible
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
char ipAddr[] = {192, 168, 1, 112};          //Ip del servidor mi maquina //1.55   125      247    //161 esp oficina
const char MAX_BYTES_TCP = 64;              //MAXIMOS BYTES DE RECEPCION Y ENVIO
char getRequest[MAX_BYTES_TCP];             //Para las peticiones del servidor
unsigned int portServer = 132;              //Puerto del servidor  //132
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
const char TCP_TBL_ERROR[] = "ERROR";
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
const char TCP_CAN_TPV[] = "TPV";   //EVENTO QUE VA HACIA ETHERNET
const char TCP_CAN_EXP[] = "EXP";   //EXP
const char TCP_CAN_VAL[] = "VAL";   //VAL
const char TCP_CAN_IDX[] = "IDX";   //EVENTO ID
//MODULO DEL CAN
const char TCP_CAN_MODULE[] = "T";      //TPV
const char TCP_CAN_MODULE_E[]= "E";      //EXPENDEDORA
const char TCP_CAN_MODULE_V[] = "V";      //VALIDADORA
const char TCP_CAN_MOD[] = "MOD";
//OTROS MENSAJES
const char TCP_MESSAGE_OVERFLOW[] = "MSGOVFMAX";  //MENSAJE DE SOBREFLUJO
//COMANDOS TICKET
const char TCP_CAN_TICKET[] = "TKT";       //TICKET
const char TCP_CAN_ANEXAR[] = "ADD";       //A�ADE DATA AL FINAL
const char TCP_CAN_FINALIZAR[] = "FIN";    //FINALIZAR
const char TCP_CAN_RETRANSMITIR[] = "RTM"; //RETRANSMITIR
const char TCP_CAN_IMPRIMIR[] = "IMP";     //IMPRIMIR
//EVENTO COMANDOS
const char TCP_CAN_CMD[] = "CMD";
const char TCP_CAN_KEY[] = "KEY";
const char TCP_CAN_OUT[] = "OUT";
const char TCP_CAN_CUPO[] = "CUP";
const char TCP_CAN_ABRIR[] = "OPN";
const char TCP_CAN_MODULE_ALL[] = "ALL";//ALL
const char TCP_CAN_MODULE_TyV[] = "TyV";
const char TCP_CAN_NODOS[] = "NOD";
const char TCP_CAN_RESET[] = "RST";
//EVENTOS VALIDADORA
const char ACCESO_DENEGADO[] = "NNNN";  //ACCESO DENEGADO
const char VIGENTE = 'V';
const char ESTATUS_PAS = TCP_CAN_MODULE_V[0] == 'E'? 'O':'I';//MODULE E � V, ESTADO PARA SALIR O ENTRRAR
const char ESTATUS_MOD = TCP_CAN_MODULE_V[0] == 'E'? 'I':'O';//MODULE E � V, EVENTO GENERADO POR ENTRAR O SALIR
const char ESTATUS_BREAK = '-';
const char ESTATUS_NOT = 'N';
//EVENTOS PARA EL TPV
const char TPV_NO_VIGENCIA = 'V';
const char TPV_PASSBACK = 'P';
const char TPV_ACCESO = 'A';
const char TPV_DESCONOCIDO = 'D';
const char TPV_SIN_SALDO = 'S';
const char TPV_OUT_TIME = 'T';

//VARIABLES PARA EL TIMER
bool flagTMR3 = false;       //Flag para el timer cada ms
bool flagSecondTMR3 = false; //Bandera de cada segundo de temporizacion

//Variables CAN
const char canId = 0;       //El id del pic
char canIdVal;
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

//Banderas de retroalimentacion wiegand
char legioTemp = 0;

//Otros
char msjConst[20];              //Mensajes constantes a ser convertidos
bool abrirBarrera = false;      //Abrir barrera por estado
//Time para la barrera abierta
const char timeSensor = 3;
char tempSensor;
char eSensor = 0;               //Maquina de estados para el sensor
bool estadoSensor = true;       //En uno se activa el senado
//Variables para el lcd
bool limpiarLCD = false;
char tempLCD = 0;
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
//Funciones de validadora
void validadora_checkTarjeta();  //Verifica tarjetas pasada por el wiegand
void validadora_temporizadores();
void validadora_barrera();
void validadora_monedero();

//Eliminables
//#define CREATE_CODE_TABLE
#define debug_usart
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
    //Funciones del modulo ETHERNET
    tpv_temporizadores();           //Incrementa los contadores y verifica conexiones
    tpv_pushBuffer();               //Empuja en el buffer del enc28j60
    tpv_reconexion();               //Reconecta el modulo si sufrio desconexion
    tpv_buffer_tcp();               //Vacia buffer tcp
    tpv_buffer_can();               //Vacia buffer can
    //Funciones de la validadora
    validadora_checkTarjeta();      //Verifica la tarjeta del pensionado
    //validadora_barrera();
    //validadora_monedero();
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
  SALIDA_RELE3D = 1;
  SALIDA_RELE4D = 1;
  SALIDA_RELE5D = 0;
  //Se�ales por defecto
  SALIDA_RELE1 = 0;
  SALIDA_RELE2 = 0;
  SALIDA_RELE3 = 0;
  SALIDA_RELE4 = 0;
  SALIDA_RELE5 = 0;
  LED_LINK = 0;
  
  //Inicializar la eeprom del pic
  canIdVal = EEPROM_Read(0);
  
  //Inicializar variables por primer energizado
  if(!RCON.POR){
    RCON.POR = 1;  //Reset bit
    RCON.TO_ = 1;
    RCON.PD = 1;
  }
  
  //Inicializar los modulos ADC, TIMERS, SPI, I2C, EEPPROM, Modulos
  timer1_open(50e3, true, false, false);
  timer3_open(50e3, true, true, false);
  usart_open(baudiosRate);
  //usart_enable_rx(true, true, 0x0D);
  //Modulos
  DS1307_open();
  lcd_init();
  lcd_cmd(_LCD_CURSOR_OFF);
  lcd_cmd(_LCD_CLEAR);
  mysql_init(65535);
  wiegand26_open();
  wtd_enable(true);
  can_open(canIp, canMask, canId, 4);
  wtd_enable(false);
  can_interrupt(true, false);
  usart_write_line("Config network");
  lcd_outConst(1, 1, "Init net...");
  SPI1_Init();                                         //Initialize SPI modulo
  Net_Ethernet_28j60_Init(myMacAddr, myIpAddr, 0x01);  //Full duplex
  Net_Ethernet_28j60_confNetwork(ipMask, gwIpAddr, dnsIpAddr);
  Net_Ethernet_28j60_stackInitTCP();
  
  //Preprogramacion init modules
  lcd_outConst(1, 1, "Inicializando pic");
  wiegand26_enable();
  DS1307_read(&myRTC, true);
  tarjetas.canTemp = MAX_TIME_CHECK_MOD;
  //Cargar elementos en buffer
  pilaBufferCAN = mysql_count_forced(tableEventosCAN, eventosEstatus, '1');
  pilaBufferTCP = mysql_count_forced(tableEventosTCP, eventosEstatus, '1');
  usart_write_textConst("Pila TCP: ");
  IntToStr(pilaBufferTCP, msjConst);
  usart_write_line(msjConst);
  usart_write_textConst("Pila CAN: ");
  IntToStr(pilaBufferCAN, msjConst);
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
  usart_write_textConst("Nodos: ");
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
  usart_write_textConst("Tabla ticket TPV: ");
  LongToStr(myTable.size, msjConst);
  usart_write_line(msjConst);
  
  //Crer tabla de ticket, 3200 bytes paquetes de 64 maximo
  mysql_create_new(tableTicketEXP, "ticket&1", 3200);
  usart_write_textConst("Tabla ticket EXP: ");
  LongToStr(myTable.size, msjConst);
  usart_write_line(msjConst);

  //Crear tabla de pensionados
  mysql_create_new(tablePensionados, "id&4\nvigencia&1\nestatus&1", 1000);
  usart_write_textConst("Tabla pensionados: ");
  LongToStr(myTable.size, msjConst);
  usart_write_line(msjConst);

  //Crear tabla de tarjeta por cobro
  mysql_create_new(tablePrepago, "id&4\nnip&4\nestatus&1\ndate&13\nsaldo&4", 100);
  usart_write_textConst("Tabla prepago: ");
  LongToStr(myTable.size, msjConst);
  usart_write_line(msjConst);

  //Crear tabla de soporte
  mysql_create_new(tableSoporte, "id&4", 5);
  usart_write_textConst("Tabla soporte: ");
  LongToStr(myTable.size, msjConst);
  usart_write_line(msjConst);

  //Crear tabla de eventos CAN, 20 modulos + final de cadena
  mysql_create_new(tableEventosCAN,"registro&40\nmodulos&21\nestatus&1", 100);
  for(tam = 0; tam < 100; tam++)
    mysql_write_roundTrip(tableEventosCAN, eventosEstatus, "0", 1); //No enviar
  usart_write_textConst("Tabla eventos can: ");
  LongToStr(myTable.size, msjConst);
  usart_write_line(msjConst);
  
  //Crea tabla de eventos tcp
  mysql_create_new(tableEventosTCP, "registro&40\nestatus&1", 100);
  for(tam = 0; tam < 100; tam++)
    mysql_write_roundTrip(tableEventosTCP, eventosEstatus, "0", 1); //No enviar
  usart_write_textConst("Tabla eventos TCP: ");
  LongToStr(myTable.size, msjConst);
  usart_write_line(msjConst);
  
  //Tabla eventos key nip, circular
  mysql_create_new(tableKeyOutNip,"nip&4\ndate&13\nestatus&1", 50);
  for(tam = 1; tam <= 50; tam++)
    mysql_write(tableKeyOutNip, eventosEstatus, tam, '0', true); //No enviar
  usart_write_textConst("Tabla key nips: ");
  LongToStr(myTable.size, msjConst);
  usart_write_line(msjConst);

  //Tabla eventos key date, circular
  mysql_create_new(tableKeyOutDate,"date&13\n", 50);
  for(tam = 1; tam <= 50; tam++)
    mysql_write_string(tableKeyOutDate, keyOutDate, tam, "", true); //Fecha vacia
  usart_write_textConst("Tabla key date: ");
  LongToStr(myTable.size, msjConst);
  usart_write_line(msjConst);

  //Tabla eventos key fol, circular
  mysql_create_new(tableKeyOutFol,"folio&4\ndate&13\nestatus&1", 50);
  for(tam = 1; tam <= 50; tam++)
    mysql_write(tableKeyOutFol, eventosEstatus, tam, '0', true); //No enviar
  usart_write_textConst("Tabla key folios: ");
  LongToStr(myTable.size, msjConst);
  usart_write_line(msjConst);
  
  //Tabla folios
  mysql_create_new(tableFolio,"total&4", 1);
  mysql_write(tableFolio, folioTotal, -1, 0, true);
  usart_write_textConst("Tabla folio: ");
  LongToStr(myTable.size, msjConst);
  usart_write_line(msjConst);
  
  //Tabla syncronia
  mysql_create_new(tableSyncronia, "estado&1", 1);
  mysql_write(tableSyncronia, columnaEstado, -1, false, true);
  usart_write_textConst("Tabla syncronia: ");
  LongToStr(myTable.size, msjConst);
  usart_write_line(msjConst);

  //Tabla cupo
  mysql_create_new(tableCupo, "estado&1", 1);
  mysql_write(tableCupo, columnaEstado, -1, false, true);
  usart_write_textConst("Tabla cupo: ");
  LongToStr(myTable.size, msjConst);
  usart_write_line(msjConst);
  
  //Tabla de tolerancia
  mysql_create_new(tableToleranciaOut, "tolerancia&2", 1);
  mysql_write(tableToleranciaOut, tableToleranciaOut, -1, 15*60, true);
  usart_write_textConst("Tabla tolerancia: ");
  LongToStr(myTable.size, msjConst);
  usart_write_line(msjConst);
  
  //Tabla de nodos
  mysql_create_new(tableNodos, "name&1", 20);
  usart_write_textConst("Tabla nodos: ");
  LongToStr(myTable.size, msjConst);
  usart_write_line(msjConst);
  #endif
  /****************************************************************************/
  //Intentar conectar el modulo a tcp, la funcion demora 6 segundos maximo
  Net_Ethernet_28j60_connectTCP(ipAddr, portServer, myPort, &sock1);
  isConectTCP = spi_tcp_linked();       //Cable conectado
  isConectServer = sock1->state == 3;
  usart_write_lineConst("Parking");
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
  Delay_ms(timeAwake);
  lcd_clean_row(1);
  lcd_outConst(1, 6, "TPV Val");
  string_cpy(bufferEeprom, "INIRST");
  buffer_save_send(true, bufferEeprom, tarjetas.canIdMod);
}
/******************************************************************************/
void validadora_barrera(){
  static bool sensor = false;
  const char CAN_BAR[] = "BAR";
  const char BARRERA_ABIERTA[] = "OPEN";
  
  if(BOTON_ENTRADA1 && !sensor.B0){
    sensor.B0 = true;
    //CREAR EVENTO
    //string_cpyc(bufferEeprom, TCP_CAN_TPV);
    string_cpyc(bufferEeprom, CAN_BAR);         //BAR
    string_addc(bufferEeprom, BARRERA_ABIERTA);
    DS1307_read(&myRTC, false);
    string_add(bufferEeprom, &myRTC.time[1]);
    //Reponde modulo
    string_addc(bufferEeprom, TCP_CAN_MODULE_V);
    numToHex(canIdVal, msjConst, 1);
    string_add(bufferEeprom, msjConst);       //NODO(HEX)
    buffer_save_send(true, bufferEeprom, tarjetas.canIdMod);
    usart_write_lineConst("Barrera abierta");
    Delay_ms(50);
  }else if(!BOTON_ENTRADA1 && sensor){
    sensor.B0 = false;
    Delay_ms(50);
  }
}
/******************************************************************************/
void validadora_monedero(){
  static bool sensado = false;
  static bool startRelay = false;
  static char pulsosMonederos = 0;
  const char timeMonedero = 2;
  
  //Secuencia de monedero
  if(BOTON_IMPRIMIR && !sensado){
    usart_write_line("Monedero start");
    sensado = true;
    if(!startRelay)
      tempMonedero = 0;
    //Iniciar activacion del relevador
    startRelay = true;
    pulsosMonederos++;
  }else if(!BOTON_IMPRIMIR && sensado){
    sensado = false;
    Delay_ms(50);
  }
  //Comenzar la secuencia
  if(startRelay){
    if(tempMonedero >= timeMaxMonedero){
      if(pulsosMonederos == 1){
        //Si no ha sido activado el rele, lo activamos
        if(!SALIDA_RELE1){
          eSensor = 0;
          abrirBarrera = true;
          SALIDA_RELE1 = 1;
          SALIDA_RELE2 = 1;
          timer1_reset();
          timer1_enable(true);
          usart_write_line("Activando rele modo monedero");
        }else
          usart_write_line("Rele ya activado");
      }else{
        usart_write_line("Modo corte de caja");
      }
      //Reiniciar estados
      pulsosMonederos = 0;
      startRelay = false;
    }
  }
}
/******************************************************************************/
void validadora_checkTarjeta(){
  //VARIABLES
  static bool buscarID = false, buscarNIP = false;
  static int fila;         //Fila repcionada
  static int nip;          //Nip teclado
  static long id;          //Tarjeta fisica
  char vigencia, estatus;  //Estatus del pensionado[V/N] y del coche[I/O]
  char acceso[5];          //Acceso: accedio + passback + vigencia + conocido
  long saldo;              //Saldo
  long seconds;            //Segundos actuales
  char fecha[13];          //Fecha guardada
  bool isOtherToday;       //No es la fecha de hoy
  //Tecaldo
  static bool flagTeclado = false;
  char keys[5];

  //Recibir protocolo wiegand
  if(wiegand26_read_card(&id)){
    limpiarLCD = true;
    tempLCD = 0;
    if(!buscarID && !buscarNIP)
      buscarID = true;
    lcd_clean_row(1);
    lcd_outConst(1, 1, "CARD: ");
    LongToStr(id, msjConst);
    lcd_out(1, sizeof("CARD: "), msjConst);
    #ifdef debug_usart
    usart_write_textConst("CARD: ");
    LongToStr(id, msjConst);
    usart_write_line(msjConst);
    #endif
  }else if(wiegand26_read_nip(&nip)){
    limpiarLCD = true;
    tempLCD = 0;
    if(!buscarID && !buscarNIP)
      buscarNIP = true;
    lcd_clean_row(1);
    lcd_outConst(1, 1, " NIP: ");
    numToString(nip, msjConst, 4);
    //LongToStr(nip, msjConst);
    lcd_out(1, sizeof(" NIP: "), msjConst);
    #ifdef debug_usart
    usart_write_textConst("NIP: ");
    LongToStr(nip, msjConst);
    usart_write_line(msjConst);
    #endif
    flagTeclado = false;
  }else if(wiegand26_read_key(keys)){
    lcd_clean_row(1);
    lcd_outConst(1, 1, " NIP: ");
    lcd_out(1, sizeof(" NIP: "), keys);
    flagTeclado = true;
  }else if(flagTeclado && WIEGAN26_CONT == 0){
    flagTeclado = false;
    lcd_clean_row(1);
    lcd_outConst(1, 1, "NIP Cancelado");
    limpiarLCD = true;
    tempLCD = 0;
  }


  //Abrir si es tarjeta soporte tecnico
  if(buscarID){
    if(!mysql_search(tableSoporte, soporteID, id, &fila)){
      eSensor = 0;  //Reiniciar maquina de estados
      abrirBarrera = true;
      SALIDA_RELE1 = 1;
      SALIDA_RELE2 = 1;
      timer1_reset();
      timer1_enable(true);
      //Indicador verde
      legioTemp = 0;
      SALIDA_RELE3 = 1;
      //Mostrar mensaje en lcd
      lcd_clean_row(3);
      lcd_outConst(3,1,"Tarjeta de soporte");
      buscarID = false;
      //Enviar mensaje al TPV
      string_cpyc(canCommand, TCP_CAN_SOPORTE);       //SOP
      numToHex(id, msjConst, 3);
      string_add(canCommand, msjConst);           //IDX + RFID(HEX)
      DS1307_read(&myRTC, false);
      string_add(canCommand, &myRTC.time[1]);     //IDX + ID(HEX) + DATE
      //Reponde modulo
      string_addc(canCommand, TCP_CAN_MODULE_V);
      numToHex(canIdVal, msjConst, 1);
      string_add(canCommand, msjConst);       //NODO(HEX)
      buffer_save_send(true, canCommand, tarjetas.canIdMod);
    }
  }

  //Busquedas por id
  if(buscarID){
    buscarID = false;
    //Obtener los datos para ser enviados
    DS1307_read(&myRTC, false);
    //Enviar mensaje al TPV
    string_cpyc(canCommand, TCP_CAN_TPV);
    string_addc(canCommand, TCP_CAN_IDX);   //IDX
    numToHex(id, msjConst, 3);
    string_add(canCommand, msjConst);       //IDX + RFID(HEX)
    string_add(canCommand, &myRTC.time[1]); //IDX + ID(HEX) + DATE
    //Evento generado
    string_cpyc(acceso, ACCESO_DENEGADO);   //Sin Acceso, Sin vigencia, no passback, desconocida id

    //Buscamos pensionados
    if(!mysql_search(tablePensionados, pensionadosID, id, &fila)){
      //Replace cadena
      canCommand[3] = TCP_CAN_PENSIONADO[0];
      canCommand[4] = TCP_CAN_PENSIONADO[1];
      canCommand[5] = TCP_CAN_PENSIONADO[2];
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
        //Indicador verde
        legioTemp = 0;
        SALIDA_RELE3 = 1;
        acceso[0] = TPV_ACCESO;     //Acceso

        if(!can.conected || !canSynchrony || estatus == ESTATUS_BREAK)
          acceso[2] = ESTATUS_BREAK;   //Estado del passback roto
        //Actualizar estado de la tabla
        estatus = (!can.conected || !canSynchrony)? ESTATUS_BREAK:ESTATUS_MOD;
        mysql_write(tablePensionados, pensionadosEstatus, fila, estatus, false);
        //Mensajes
        lcd_clean_row(2);
        lcd_outConst(2, 1, "Acceso aceptado");
        #ifdef debug_usart
        usart_write_lineConst("Pensionado aceptado: ");
        usart_write(estatus);
        usart_write_lineConst("");
        #endif
      }else{
        if(vigencia == ESTATUS_NOT){
          acceso[1] = TPV_NO_VIGENCIA;    //Vigencia
          lcd_clean_row(2);
          lcd_outConst(2, 1, "Vigencia terminada");
          #ifdef debug_usart
          usart_write_lineConst("Vigencia terminada");
          #endif
          //Indicador rojo
          legioTemp = 0;
          SALIDA_RELE4 = 1;
        }else if(estatus == ESTATUS_MOD){
          acceso[2] = TPV_PASSBACK;   //Estado del passback
          lcd_clean_row(2);
          lcd_outConst(2,1,"Passback activo");
          #ifdef debug_usart
          usart_write_lineConst("Passback activo del pensionado");
          #endif
          //Indicador rojo
          legioTemp = 0;
          SALIDA_RELE4 = 1;
        }
      }
      //Copiar el contenido del acceso
      string_add(canCommand, acceso);
      //GUARDAR EVENTO DEL CAN-PASSBACK: PEN+ID(HEX)+COMAND+FILA+CONTENIDO
      string_cpyc(bufferEeprom, TCP_CAN_PENSIONADO);
      numToHex(id, msjConst, 3);
      string_add(bufferEeprom, msjConst);
      string_addc(bufferEeprom, TCP_CAN_PASSBACK);   //CODIGO DE ACCION
      numToString(fila, msjConst, 4);
      string_add(bufferEeprom, msjConst);
      //ENVIAR VALOR DEL PASSBAK O ESTADO DEL COCHE
      msjConst[0] = estatus;
      msjConst[1] = 0;
      string_add(bufferEeprom, msjConst);
      //Guardo en el buffer
      buffer_save_send(false, bufferEeprom, tarjetas.canIdMod);
    }else if(!mysql_search(tablePrepago, pensionadosID, id, &fila)){
      //Replace cadena
      canCommand[3] = TCP_CAN_PREPAGO[0];
      canCommand[4] = TCP_CAN_PREPAGO[1];
      canCommand[5] = TCP_CAN_PREPAGO[2];

      //Vericamos los estados del saldo y pasback
      mysql_read_string(tablePrepago, prepagoEstatus, fila, &estatus);
      mysql_read(tablePrepago, prepagoSaldo, fila, &saldo);
      mysql_read_string(tablePrepago, prepagoDate, fila, fecha);

      //Nunca negar salida
      if(/*saldo > 0 && */(estatus == ESTATUS_PAS || estatus == ESTATUS_BREAK || !canSynchrony || !can.conected)){
        //Permiso para abrir la barrera
        eSensor = 0;  //Reiniciar maquina de estados
        abrirBarrera = true;
        SALIDA_RELE1 = 1;
        SALIDA_RELE2 = 1;
        timer1_reset();
        timer1_enable(true);
        acceso[0] = TPV_ACCESO;    //Acceso

        if(!can.conected || !canSynchrony || estatus == ESTATUS_BREAK)
          acceso[2] = ESTATUS_BREAK;   //Estado del passback roto
        //Actualizar estado de la tabla
        estatus = (!can.conected || !canSynchrony)? ESTATUS_BREAK:ESTATUS_MOD;
        mysql_write(tablePrepago, prepagoEstatus, fila, estatus, false);
        //Obtener diferencia de fechas, tomar fecha actual
        DS1307_read(&myRTC, false);   //Fecha actual de corte
        string_cpyn(msjConst, &myRTC.time[1], 6);
        seconds = DS1307_getSeconds(msjConst);
        //Obtener fecha de inicio de entrada
        string_cpyn(msjConst, fecha, 6);  //Obtener fecha
        seconds -= DS1307_getSeconds(msjConst);
        saldo -= clamp(seconds, 0, 999999); //No exceder 24hrs
        saldo /= 3600;  //Redondea en horas
        saldo *= 3600;  //Obtiene las horas totales
        //Guardar el nuevo saldo
        mysql_write(tablePrepago, prepagoSaldo, fila, saldo, false);

        //Mensajes LCD
        lcd_clean_row(2);
        lcd_clean_row(3);
        lcd_outConst(2,1,"Acceso aceptado");
        lcd_out(3,1,"Saldo(hrs): ");
        ByteToStr(saldo/3600, msjConst);
        lcd_out(3,13,msjConst);
        #ifdef debug_usart
        usart_write_lineConst("Prepago aceptado: ");
        usart_write(estatus);
        usart_write_lineConst("");
        //REALIZAMOS CORTE DE DINERO SI SALIO
        usart_write_textConst("Fecha de entrada: ");
        usart_write_line(fecha);
        usart_write_textConst("Fecha de salida: ");
        usart_write_line(myRTC.time);
        usart_write_textConst("Segundos de cobro: ");
        LongToStr(seconds, msjConst);
        usart_write_line(msjConst);
        usart_write_textConst("Dinero restante: ");
        LongToStr(saldo, msjConst);
        usart_write_line(msjConst);
        #endif
      }else{
        //Activa bandera para saber si salio con deuda
        if(saldo <= 0){
          acceso[1] = TPV_SIN_SALDO;  //Sin saldo
          lcd_clean_row(2);
          lcd_outConst(2,1,"Saldo terminado");
          #ifdef debug_usart
          usart_write_lineConst("Saldo terminado");
          #endif
        }else if(estatus == ESTATUS_MOD){
          acceso[2] = TPV_PASSBACK;   //Estado del passback
          lcd_clean_row(2);
          lcd_outConst(2,1,"Passback activo");
          #ifdef debug_usart
          usart_write_lineConst("Passback activo prepago");
          #endif
        }
      }
      //Copiar el contenido del acceso
      string_add(canCommand, acceso);
      //GUARDAR EVENTO DEL CAN-SALDO: PRE+ID(HEX)+COMAND+FILA+CONTENIDO
      string_cpyc(bufferEeprom, TCP_CAN_PREPAGO);
      numToHex(id, msjConst, 3);
      string_add(bufferEeprom, msjConst);
      if(acceso[0] == TPV_ACCESO)
        string_addc(bufferEeprom, CAN_SPECIAL_SALDO);   //CODIGO DE ACCION
      else
        string_addc(bufferEeprom, TCP_CAN_PASSBACK);   //CODIGO DE ACCION
      numToString(fila, msjConst, 4);
      string_add(bufferEeprom, msjConst);
      //ENVIAR VALOR DEL PASSBAK O ESTADO DEL COCHE
      string_push(bufferEeprom, estatus);
      //ENVIAR SALDO, depende situacion de acceso
      numToHex(saldo, msjConst, 4);
      string_add(bufferEeprom, msjConst);
      //Guardo en el buffer
      buffer_save_send(false, bufferEeprom, tarjetas.canIdMod);
    }else{
      lcd_clean_row(2);
      lcd_outConst(2,1,"Tarjeta desconocida");
      #ifdef debug_usart
      usart_write_lineConst("Tarjeta no registrada");
      #endif
      //Tarjeta desconocida
      acceso[3] = TPV_DESCONOCIDO;      //Tarjeta desconocida
      string_add(canCommand, acceso);
      //Indicador rojo
      legioTemp = 0;
      SALIDA_RELE4 = 1;
    }
    //Responde el nodo
    //string_addc(canCommand, TCP_CAN_MODULE);    //T
    string_addc(canCommand, TCP_CAN_MODULE_V);
    numToHex(canIdVal, msjConst, 1);
    string_add(canCommand, msjConst);       //NODO(HEX)
    buffer_save_send(true, &canCommand[3], tarjetas.canIdMod);
  }else if(buscarNIP){
    buscarNIP = false;
    //Obtener los datos para ser enviados
    DS1307_read(&myRTC, false);
    //CREAR EVENTO DEL TPV
    string_cpyc(canCommand, TCP_CAN_TPV);
    string_addc(canCommand, TCP_CAN_NIP);       //NIP
    numToString(nip, msjConst, 4);
    string_add(canCommand, msjConst);       //NIP + NIP(DEC)
    string_add(canCommand, &myRTC.time[1]); //NIP + NIP(DEC) + DATE
    //Cadena a ser modificada
    string_cpyc(acceso, ACCESO_DENEGADO);   //sin acceso, sin Saldo, sin passback, desconocida nip

    //Buscamos si existe en la tabla de prepago
    if(!mysql_search(tablePrepago, prepagoNip, nip, &fila)){
      //Vericamos los estados del saldo y pasback
      mysql_read_string(tablePrepago, prepagoEstatus, fila, &estatus);
      mysql_read(tablePrepago, prepagoSaldo, fila, &saldo);
      mysql_read(tablePrepago, prepagoId, fila, &id);
      //Evaluar caso
      if(saldo >= 3600 && (estatus == ESTATUS_PAS || estatus == ESTATUS_BREAK || !canSynchrony || !can.conected)){
        //Permiso para abrir la barrera
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
        //Obtener diferencia de fechas, tomar fecha actual
        DS1307_read(&myRTC, false);   //Fecha actual de corte
        string_cpyn(msjConst, &myRTC.time[1], 6);
        seconds = DS1307_getSeconds(msjConst);
        //Obtener fecha de inicio de entrada
        string_cpyn(msjConst, fecha, 6);  //Obtener fecha
        seconds -= DS1307_getSeconds(msjConst);
        saldo -= clamp(seconds, 0, 999999); //No exceder 24hrs
        saldo /= 3600;  //Redondea en horas
        saldo *= 3600;  //Obtiene las horas totales
        //Guardar el nuevo saldo
        mysql_write(tablePrepago, prepagoSaldo, fila, saldo, false);

        //Mensajes LCD
        lcd_clean_row(2);
        lcd_clean_row(3);
        lcd_outConst(2,1,"Acceso aceptado");
        lcd_outConst(3,1,"Saldo(hrs): ");
        ByteToStr(saldo/3600, msjConst);
        lcd_out(3,13,msjConst);
        #ifdef debug_usart
        usart_write_lineConst("Prepago aceptado por nip: ");
        usart_write(estatus);
        usart_write_lineConst("");
        //REALIZAMOS CORTE DE DINERO SI SALIO
        usart_write_textConst("Fecha de entrada: ");
        usart_write_line(fecha);
        usart_write_textConst("Fecha de salida: ");
        usart_write_line(myRTC.time);
        usart_write_textConst("Segundos de cobro: ");
        LongToStr(seconds, msjConst);
        usart_write_line(msjConst);
        usart_write_textConst("Dinero restante: ");
        LongToStr(saldo, msjConst);
        usart_write_line(msjConst);
        #endif
      }else{
        if(saldo < 3600){
          acceso[1] = TPV_SIN_SALDO;  //Sin saldo
          lcd_clean_row(2);
          lcd_outConst(2,1,"Saldo agotado");
          #ifdef debug_usart
          usart_write_lineConst("Saldo terminado");
          #endif
        }else if(estatus == ESTATUS_MOD){
          acceso[2] = TPV_PASSBACK;   //Estado del passback
          lcd_clean_row(2);
          lcd_outConst(2,1,"Passback activo");
          #ifdef debug_usart
          usart_write_lineConst("Passback activo prepago");
          #endif
        }
      }
      //Copiar el contenido del acceso
      string_add(canCommand, acceso);
      //GUARDAR EVENTO DEL CAN-SALDO: PRE+ID(HEX)+COMAND+FILA+CONTENIDO
      string_cpyc(bufferEeprom, TCP_CAN_PREPAGO);
      numToHex(id, msjConst, 3);
      string_add(bufferEeprom, msjConst);
      if(acceso[0] == TPV_ACCESO)
        string_addc(bufferEeprom, CAN_SPECIAL_SALDO);   //CODIGO DE ACCION
      else
        string_addc(bufferEeprom, TCP_CAN_PASSBACK);   //CODIGO DE ACCION
      numToString(fila, msjConst, 4);
      string_add(bufferEeprom, msjConst);
      //ENVIAR VALOR DEL PASSBAK O ESTADO DEL COCHE
      string_push(bufferEeprom, estatus);
      //ENVIAR Saldo
      numToHex(saldo, msjConst, 4);
      string_add(bufferEeprom, msjConst);
      //Guardo en el buffer
      buffer_save_send(false, bufferEeprom, tarjetas.canIdMod);
    }else if(!mysql_search_forced(tableKeyOutNip, keyOutNip, nip, &fila)){
      //Replace cadena
      canCommand[3] = TCP_CAN_KEY[0];
      canCommand[4] = TCP_CAN_KEY[1];
      canCommand[5] = TCP_CAN_KEY[2];
      mysql_read_forced(tableKeyOutNip, keyOutEstatus, fila, &estatus);
      mysql_read_forced(tableKeyOutNip, keyOutDate, fila, fecha);
      fecha[12] = 0; //Agregar final de cadena, proteccion
      DS1307_read(&myRTC, false);
      //Mensajes
      #ifdef debug_usart
      usart_write_textConst("Fecha registro: ");
      usart_write_line(fecha);
      usart_write_textConst("Fecha salida: ");
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
        //Indicador verde
        legioTemp = 0;
        SALIDA_RELE3 = 1;
        //Reportar que entro el auto
        acceso[0] = TPV_ACCESO;    //Acceso
        //if(!can.conected || !canSynchrony || estatus == ESTATUS_BREAK)
          //acceso[2] = ESTATUS_BREAK;   //Estado del passback roto
        //Borrar el registro de salida, posiblemente fecha
        mysql_write_forced(tableKeyOutNip, keyOutEstatus, fila, "0", 1);
        lcd_clean_row(2);
        lcd_outConst(2,1,"NIP aceptado");
        #ifdef debug_usart
        usart_write_textConst("Se encontro el nip(key) salida: ");
        LongToStr(nip, msjConst);
        usart_write_line(msjConst);
        #endif
      }else if(estatus == '0'){
        acceso[2] = TPV_PASSBACK;   //Llave ya utilizada
        lcd_clean_row(2);
        lcd_outConst(2,1,"NIP desconocido*");
        #ifdef debug_usart
        usart_write_textConst("Llave ya utilizada");
        LongToStr(nip, msjConst);
        usart_write_line(msjConst);
        #endif
        //Indicador rojo
        legioTemp = 0;
        SALIDA_RELE4 = 1;
      }else if(isOtherToday || seconds >= TOLERANCIA_OUT){
        acceso[1] = TPV_OUT_TIME;  //FECHA EN FUERA DE RANGO
        lcd_clean_row(2);
        lcd_outConst(2,1,"NIP invalido*");
        #ifdef debug_usart
        usart_write_line(isOtherToday?"Llave de otro dia":"Tiempo agotado");
        #endif
        //Indicador rojo
        legioTemp = 0;
        SALIDA_RELE4 = 1;
      }
      //Copiar el contenido del acceso
      string_add(canCommand, acceso);
    }else{
      lcd_clean_row(2);
      lcd_outConst(2,1,"Nip desconocido");
      #ifdef debug_usart
      usart_write_lineConst("NIP descnocido");
      #endif
      acceso[3] = TPV_DESCONOCIDO;
      string_add(canCommand,acceso);
      //Indicador rojo
      legioTemp = 0;
      SALIDA_RELE4 = 1;
    }
    //Responde el nodo
    string_addc(canCommand, TCP_CAN_MODULE_V);
    numToHex(canIdVal, msjConst, 1);
    string_add(canCommand, msjConst);       //NODO(HEX)
    buffer_save_send(true, &canCommand[3], tarjetas.canIdMod);
  }
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
        usart_write_lineConst("Buscando Eventos TCP...");
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
        usart_write_lineConst("Buscando Eventos CAN...");
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
                usart_write_textConst("NODO DEAD: ");
                numToString(nodo, msjConst, 2);
                usart_write_line(msjConst);
                return;  //No enviar nodo
              }
            }
            //Enviar por el can el dato
            usart_write_textConst("Enviar a nodo: ");
            numToString(nodo, msjConst, 2);
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
            usart_write_textConst("CAN restan: ");
            IntToStr(pilaBufferCAN, msjConst);
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
    tempSensor++;
    tempMonedero++;
    //Verifica la condicion del buffer
    isEmptyBuffer = Net_Ethernet_28j60_bufferEmptyTCP(sock1);

    //Verificar conexion del cable
    if(isConectTCP != spi_tcp_linked()){
      isConectTCP = spi_tcp_linked();
      
      if(isConectTCP)
        usart_write_textConst("CONEXION POR CABLE \r\n");
      else{
        usart_write_textConst("DESCONEXION POR CABLE \r\n");
        asm reset;      //No es mejor la forma buscar otra
        //Una vez desconectado reconectamos al conector
        //Net_Ethernet_28j60_Init(myMacAddr, myIpAddr, 0x01);  //Full duplex
        //Net_Ethernet_28j60_stackInitTCP();
      }
    }
    //Verificar conexion del servidor
    if(isConectServer != (sock1->state == 3)){
      isConectServer = sock1->state == 3;

      if(isConectServer){
        usart_write_textConst("ONLINE \r\n");
        tempHeartBeatTcp = 0;
        heartBeatTCP = false;
      }else
        usart_write_textConst("OFFLINE \r\n");
    }
    //Toogle led de link por conexion y conectado al servidor
    if(isConectTCP && isConectServer && can.conected){
      LED_LINK ^= 1;
    }
    //Verifica que yo tenga can
    if(isConectedCan != can.conected){
      usart_write_textConst("Conexion CAN: ");
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
            usart_write_line(bufferEeprom);
            //buffer_save_send(false, bufferEeprom, tarjetas.canIdMod);
            //canSynchrony = false;
            //mysql_write(tableSyncronia, columnaEstado, 1, canSynchrony, false);
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
          //buffer_save_send(false, bufferEeprom, tarjetas.canIdMod);
          //canSynchrony = true;
          //mysql_write(tableSyncronia, columnaEstado, 1, canSynchrony, false);
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
    if(isConectServer){
      if(tempHeartBeatTcp >= timeHeartBeatTcp){
        tempHeartBeatTcp = 0;
        //Si no recibo el heartBeat reconecto
        if(!heartBeatTCP){
          usart_write_lineConst("Offline heartBeat TCP");
          //APILO EVENTO
          string_cpy(bufferEeprom, "ERRHRB");  //ERROR DE HEARBEAT
          buffer_save_send(true, bufferEeprom, tarjetas.canIdMod);
          asm reset;
          //Net_Ethernet_28j60_disconnectTCP(socket_28j60);
          //Net_Ethernet_28j60_Init(myMacAddr, myIpAddr, 0x01);  //Full duplex
          //Net_Ethernet_28j60_stackInitTCP();
        }
        //Reiniciar bandera
        heartBeatTCP = false;
      }
    }
    
    //Mostrar hora
    DS1307_read(&myRTC,true);
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
        lcd_outConst(1, 6, "TPV Val");
        //Anexar los sensores listos
        if(BOTON_ENTRADA1)
          lcd_chr(1,18,'B');
        //if(SENSOR_COCHE)
          //lcd_chr(1,20,'C');
      }
    }
    //Betas code
    /*
    bytetostr(WIEGAN26_CONT, msjConst);
    usart_write_text("Valor cont: ");
    usart_write_line(msjConst);
    */
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
  //NEW WORDS
  long auxNip;
  
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
      
      //Si hubo overflow dato da�ado
      if(overflow){
        overflow = false;
        string_cpyc(respuesta, TCP_MESSAGE_OVERFLOW);
        numToHex(sizeof(getRequest), msjConst, 1);
        string_add(respuesta, msjConst);
        getRequest[0] = 0;
      }
      
      //Bytes en buffer
      ByteToStr(contRequest, msjConst);
      usart_write_textConst("Bytes: ");
      usart_write_text(msjConst);
      //Mensaje recepcionado
      usart_write_textConst(" ,Mensaje: ");
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
          estatus = !mysql_search(tablePrepago, prepagoId, idConsulta, &filaAux);
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
          usart_write_textConst("Se guarda: ");
          usart_write_line(bufferEeprom);
        }else{
          usart_write_lineConst("No se genera evento CAN");
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
          usart_write_textConst("Se guarda: ");
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
          //A�ADIR TPV A LA RESPUESTA
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
              usart_write_lineConst("Emulando boleto");
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
          //A�ADIR TPV A LA RESPUESTA
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
              usart_write_lineConst("Emulando boleto");
              for(cont = 1; cont <= myTable.rowAct; cont++){
                mysql_read_string(tableTicketEXP, ticketTicket, cont, &result);
                usart_write(result);
              }
              usart_write_lineConst("");
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
        result = !mysql_search(tablePrepago, prepagoId, idConsulta, &fila);
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
            result = !mysql_write(tablePrepago, prepagoId, -1, idConsulta, true);
            //Si lo escribio al final llena los demas datos
            if(result){
              string_cpyn(msjConst, &getRequest[sizeTotal], 8);
              nip = hexToNum(msjConst);
              string_cpyn(msjConst, &getRequest[sizeTotal+8], 8);
              saldo = hexToNum(msjConst);
              estatus =  getRequest[sizeTotal+16];
              //Escribir en la tabla
              mysql_write(tablePrepago,prepagoNip, myTable.rowAct, nip, false);
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
              result = !mysql_write(tablePrepago, prepagoId, fila, idNuevo, false);
            result = !mysql_write(tablePrepago,prepagoNip, fila, nip, false);
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
            mysql_read(tablePrepago, prepagoNip, fila, &nip);
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
            result = !mysql_write(tablePrepago, prepagoNip, fila, nip, false);
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
          usart_write_textConst("Se guarda: ");
          usart_write_line(bufferEeprom);
        }else{
          usart_write_lineConst("No se genera evento CAN");
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
          estatus = !mysql_search(tablePrepago, prepagoId, idConsulta, &filaAux);
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
          usart_write_textConst("Se guarda: ");
          usart_write_line(bufferEeprom);
        }else{
          usart_write_lineConst("No se genera evento CAN");
        }
      }else if(string_cmpnc(TCP_TABLE, &getRequest[sizeTotal], sizeKey)){  
        //TBLALLPASPensionados
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
            //Validar que sea E � V?
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
        }else if(string_cmpnc(TCP_CAN_PASSBACK, &getRequest[sizeTotal], sizeKey) && cmdOwn){
          //FORMATO: TBL+PAS+NAME
          sizeTotal += sizeKey;
          //ROMPE EL PASSBACK DE PENSIONADOS, PREPAGO
          if(mysql_exist(&getRequest[sizeTotal])){
            string_addc(respuesta, TCP_CAN_PASSBACK);
            //Nombre de la tabla
            string_cpyn(msjConst, &getRequest[sizeTotal], 3);
            string_toUpper(msjConst);
            string_add(respuesta, msjConst);
            //PONER EL VALOR DE ESTATUS CON EL VALOR INDICADO
            for(fila = 1; fila <= myTable.rowAct; fila++)
              mysql_write(&getRequest[sizeTotal], pensionadosEstatus, fila, '-', false);
            //Repetir proceso para saber si lo logro
            if(!mysql_write(&getRequest[sizeTotal], pensionadosEstatus, 1, '-', false))
              string_addc(respuesta, TCP_TBL_MODIFICADO);
            else
              string_addc(respuesta,TCP_TBL_ERROR);
          }else{
            string_addc(respuesta, TCP_TBL_NO_FOUND);
          }
          //Enviar quien responde
          string_cpyc(msjConst, TCP_CAN_MODULE);
          numToHex(can.id, &msjConst[1], 1);
          string_add(respuesta, msjConst);
        }
      }else if(string_cmpnc(TCP_CAN_CMD, &getRequest[sizeTotal], sizeKey)){
        sizeTotal += sizeKey;
        sizeKey = sizeof(TCP_CAN_MODULE_ALL)-1;
        //Respuesta al TPV. CMD
        string_cpyn(respuesta, getRequest, sizeTotal);
        //Respuesta a los modulos
        string_cpyn(bufferEeprom, getRequest, sizeTotal);
        string_add(bufferEeprom, &getRequest[sizeTotal+sizeKey]);
        //DECIDIR RETRANSMISION
        cmdOwn = true;
        if(string_cmpnc(TCP_CAN_MODULE_ALL, &getRequest[sizeTotal], sizeKey)){
          buffer_save_send(false, bufferEeprom, tarjetas.canIdMod);
        }else if( string_cmpnc(TCP_CAN_MODULE_TyV, &getRequest[sizeTotal], sizeKey) ){
          //CMD+TyV+COMMAND
          for(result = 0; result < tarjetas.modulos; result++){
            nodo = tarjetas.canIdMod[result];
            if(nodo % 2 == 0){ //Si es validadora
              //Apilo nodo de envio
              msjConst[0] = nodo;
              msjConst[1] = 0;  //Fin de cadena anexado
              buffer_save_send(false, bufferEeprom, msjConst);
              break;//No enviar respuesta con TPV si no con el modulo
            }
          }
        }else{ //PREGUNTAR QUE OTRO NODO DEBO ENVIAR
          if(getRequest[sizeTotal] != TCP_CAN_MODULE[0]){
            cmdOwn = false;
            //Validar que sea E � V?
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
        //FORMATO: CMD+ALL+Comando
        sizeTotal += sizeKey;
        sizeKey = sizeof(TCP_CAN_MODULE_ALL)-1;
        //PROGRAMAR EVENTO
        usart_write_line(&getRequest[sizeTotal]);  //Mostrar el comando

        if(string_cmpnc(TCP_CAN_PASSBACK, &getRequest[sizeTotal], sizeKey) && cmdOwn){
          //FORMATO: CMD+NOD+PAS+STATUS
          sizeTotal += sizeKey;
          //ROMPE EL PASSBACK DE PENSIONADOS
          canSynchrony = getRequest[sizeTotal] == '1';
          mysql_write(tableSyncronia, columnaEstado, 1, canSynchrony, false);
          usart_write_lineConst(canSynchrony?"Sincronizado":"Desincronizado");
        }else if(string_cmpnc(TCP_CAN_KEY, &getRequest[sizeTotal], sizeKey) && cmdOwn){
          //CMD+NOD+KEY
          sizeTotal += sizeKey;
          sizeKey = sizeof(TCP_CAN_KEY)-1;

          if(string_cmpnc(TCP_CAN_NIP, &getRequest[sizeTotal], sizeKey)){
            //CMD+V02+KEY+NIP+00001E34+184036011221
            //CMD+NOD+KEY+NIP+NIP(8hex)+hhmmssDDMMYY
            sizeTotal += sizeKey;
            string_cpyn(msjConst, &getRequest[sizeTotal], 8);
            nip = hexToNum(msjConst);
            //Fecha
            string_cpyn(msjConst, &getRequest[sizeTotal+8], 12);
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

            //Guardo el evento para enviarlo
            usart_write_line("KEY NIP saved!");
          }
        }
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
              IntToStr(pilaBufferTCP, msjConst);
              usart_write_textConst("Restan: ");
              usart_write_line(msjConst);
            }else{
              usart_write_lineConst("No proceso");
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
        //A�adir quien responde
        string_addc(respuesta, TCP_CAN_MODULE);
        numToHex(can.id, msjConst, 1);
        string_add(respuesta, msjConst);
      }else if(string_cmpnc(TCP_CAN_RESET, &getRequest[sizeTotal], sizeKey)){
        asm reset;
      }else if(string_cmpnc(TCP_CAN_ABRIR, &getRequest[sizeTotal], sizeKey)){
        //Abrir barrera una vez impreso el boleto: OPN
        eSensor = 0;  //Reiniciar maquina de estados
        abrirBarrera = true;
        SALIDA_RELE1 = 1;
        SALIDA_RELE2 = 1;
        timer1_reset();
        timer1_enable(true);
        //Responder
        string_cpyc(bufferEeprom, TCP_CAN_TPV);        //SYN
        string_addc(bufferEeprom, TCP_CAN_CMD);
        string_addc(bufferEeprom, TCP_CAN_ABRIR);
        string_push(bufferEeprom, '1');            //Abrio la barrera
        //Enviar quien responde
        string_cpyc(msjConst, TCP_CAN_MODULE);
        numToHex(can.id, &msjConst[1], 1);
        string_add(bufferEeprom, msjConst);
        //Responder consulta
        buffer_save_send(true, bufferEeprom, tarjetas.canIdMod);
        #ifdef debug_usart
        usart_write_lineConst("Abriendo barrera");
        #endif
      }else if(string_cmpnc(TCP_CAN_KEY, &getRequest[sizeTotal], sizeKey)){
        sizeTotal += sizeKey;
        sizeKey = sizeof(TCP_CAN_KEY)-1;

        if(string_cmpnc(TCP_CAN_NIP, &getRequest[sizeTotal], sizeKey)){
          sizeTotal += sizeKey;
          string_cpyn(msjConst, &getRequest[sizeTotal], 8);
          nip = hexToNum(msjConst);
          //Fecha
          string_cpyn(msjConst, &getRequest[sizeTotal+8], 12);
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
          string_cpyc(bufferEeprom, TCP_CAN_TPV);
          string_addc(bufferEeprom, TCP_CAN_OUT);
          string_addc(bufferEeprom, TCP_CAN_KEY);
          string_addc(bufferEeprom, TCP_CAN_NIP);
          numToHex(nip, msjConst, 4);
          string_add(bufferEeprom, msjConst);
          string_addc(bufferEeprom, TCP_CAN_REGISTRAR);
          //Reponde modulo
          string_addc(bufferEeprom, TCP_CAN_MODULE);
          numToHex(canId, msjConst, 1);
          string_add(bufferEeprom, msjConst);
          //Guardo el evento para enviarlo
          buffer_save_send(true, bufferEeprom, tarjetas.canIdMod);
        
          #ifdef debug_usart
          usart_write_line("Guardado nip key");
          #endif
        }
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
  bool isOtherToday;
  char tam, estatus;
  int fila;
  long seconds, folLectora;
  char acceso[5];          //Acceso: accedio + passback + vigencia + conocido
  
  //Limpiar LCD
  limpiarLCD = true;
  tempLCD = 0;
    
  //Formato : HHMMSSDD?, encryptado
  if(!usart.rx_overflow){
    #ifdef debug_usart
    usart_write_textConst("RS232: ");
    usart_write_line(usart.message);
    #endif
    
    //Validar longitud: 9 Fecha encryptada, 7 Folio
    tam = string_len(usart.message);
    if(!(tam == 9 || tam == 7)){
      lcd_clean_row(3);
      lcd_outConst(3, 1, "*Llave invalida S*");
      #ifdef debug_usart
      usart_write_lineConst("Key NO cumple con el tama�o");
      #endif
      return;
    }else if(!string_isNumeric(usart.message)){
      lcd_clean_row(3);
      lcd_outConst(3, 1, "*Llave invalida F*");
      #ifdef debug_usart
      usart_write_lineConst("Key NO");
      #endif
      return;
    }
    
    //Valida respecto al formato leido, fol � fecha
    if(tam == 7){
      folLectora = stringToNum(usart.message);
      
      //Busqueda de folio
      if(!mysql_search_forced(tableKeyOutFol, keyOutFol, folLectora, &fila)){
        mysql_read_forced(tableKeyOutFol, keyOutEstatus, fila, &estatus);
        mysql_read_forced(tableKeyOutFol, keyOutDate, fila, &bufferEeprom);
        bufferEeprom[12] = 0;  //Agregar final de cadena, proteccion
        //Lectura del reloj
        DS1307_read(&myRTC, false);
          
        //Obtener la diferencia entre tiempo de entrada y salida
        string_cpyn(msjConst, &myRTC.time[1], 6);
        seconds = DS1307_getSeconds(msjConst);
        string_cpyn(msjConst, bufferEeprom, 6);
        seconds -= DS1307_getSeconds(msjConst);
        seconds = clamp(seconds, 0, TOLERANCIA_OUT); //Saturar en este rango

        //Verificar que la fecha concuerde
        string_cpy(msjConst, &myRTC.time[1]);
        isOtherToday = !string_cmpn(&msjConst[6], &bufferEeprom[6], 2);
        isOtherToday |= !string_cmpn(&msjConst[8], &bufferEeprom[8], 2);
        isOtherToday |= !string_cmpn(&msjConst[10], &bufferEeprom[10], 2);
          
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
          mysql_write_forced(tableKeyOutFol, keyOutEstatus, fila, "0", 1);
          lcd_clean_row(2);
          lcd_outConst(2,1,"Llave aceptada");
          #ifdef debug_usart
          usart_write_textConst("Se encontro el fol(key) salida: ");
          LongToStr(folLectora, msjConst);
          usart_write_line(msjConst);
          #endif
        }else if(estatus == '0'){
          acceso[2] = TPV_PASSBACK;   //Llave ya utilizada
          lcd_clean_row(2);
          lcd_outConst(2,1,"*Folio desconocido P*");
          #ifdef debug_usart
          usart_write_textConst("Fol Key utilizada");
          LongToStr(folLectora, msjConst);
          usart_write_line(msjConst);
          #endif
        }else if(isOtherToday || seconds >= TOLERANCIA_OUT){
          acceso[1] = TPV_OUT_TIME;  //FECHA EN FUERA DE RANGO
          lcd_clean_row(2);
          lcd_outConst(2,1,"*Folio invalido T*");
          #ifdef debug_usart
          usart_write_line(isOtherToday?"Llave de otro dia":"Tiempo agotado");
          #endif
        }
      }else{
        //Si no encontro el folio no es llave de salida
        lcd_clean_row(3);
        lcd_outConst(3, 1, "*Llave invalida I*");
        #ifdef debug_usart
        usart_write_lineConst("Key fol inexistente");
        #endif
      }
    }else{
      //Validacion por fecha
      decrypt_basic(usart.message);

      //Busqueda por fecha
      if(mysql_exist(tableKeyOutDate)){
        for(fila = 1; fila <= myTable.row; fila++){
          //No olvidar el tama�o
          if(!mysql_read_forced(tableKeyOutDate, keyOutDate, fila, bufferEeprom)){
            bufferEeprom[12] = 0; //Forzar final de cadena
            if(string_cmp(usart.message, bufferEeprom)){
              lcd_clean_row(3);
              lcd_outConst(3,1,"Llave utilizada");
              #ifdef debug_usart
              usart_write_lineConst("Key date llave fue ya utilizada");
              #endif
              return;
            }
          }
        }
      }
      //Procesar y guardar una nueva fecha detectada
      DS1307_read(&myRTC, false);
      string_cpyn(msjConst, &usart.message[6] , 2);

      if(stringToNum(msjConst) == myRTC.day){
        //Obtener la diferencia entre tiempo de entrada y salida
        string_cpyn(msjConst, &myRTC.time[1], 6);
        seconds = DS1307_getSeconds(msjConst);
        string_cpyn(msjConst, usart.message, 6);
        seconds -= DS1307_getSeconds(msjConst);
        seconds = clamp(seconds, 0, TOLERANCIA_OUT); //Saturar en este rango

        //Mensajes
        if(seconds < TOLERANCIA_OUT){
          //Guardo el registro previo
          mysql_write_roundTrip(tableKeyOutDate, keyOutDate, usart.message, string_len(usart.message)+1);
          //Permiso para abrir la barrera
          eSensor = 0;  //Reiniciar maquina de estados
          abrirBarrera = true;
          SALIDA_RELE1 = 1;
          SALIDA_RELE2 = 1;
          timer1_reset();
          timer1_enable(true);
          //Mensajes LCD
          lcd_clean_row(3);
          lcd_outConst(3, 1, "Acceso aceptado");
          #ifdef debug_usart
          usart_write_lineConst("Key date acceso aceptado por fecha");
          #endif
        }else{
          //Mensajes LCD
          lcd_clean_row(3);
          lcd_outConst(3, 1, "Tiempo agotado");
          #ifdef debug_usart
          usart_write_lineConst("Key date excedio el tiempo de salida");
          #endif
        }
      }else{
        lcd_clean_row(3);
        lcd_outConst(3,1,"*Llave invalida D*");
        #ifdef debug_usart
        usart_write_lineConst("Key date esta llave es de otro dia");
        #endif
      }
    }
  }else{
    usart.rx_overflow = 0;
    lcd_clean_row(3);
    lcd_outConst(3,1,"Lectura da�ada");
    #ifdef debug_usart
    usart_write_lineConst("RS232: Dato da�ado, overflow");
    #endif
  }
}
/******************************************************************************/
void can_user_read_message(){
  char sizeKey, sizeTotal; //Para los mensajes
  char estatus;            //Estatus � passback
  int fila;
  long idConsulta, id;
  long saldo;
  
  //Codigo eliminable
  usart_write_textConst("Se recibio data por can: ");
  usart_write_line(can.rxBuffer);
  
  //Verificar que tipo de comando fue, passback: PEN+ID(HEX)+COMAND+FILA+I
  sizeTotal = 0;
  sizeKey = sizeof(TCP_CAN_TPV)-1;
  if(string_cmpnc(TCP_CAN_TPV, &can.rxBuffer[sizeTotal], sizeKey)){
    sizeTotal += sizeKey;
    usart_write_lineConst("Evento TPV a ser guardado");
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
      if(!mysql_read(tablePrepago, prepagoId, fila, &id)){
        if(id == idConsulta){
          //Config
          usart_write_lineConst("Modificado PAS+DATE");
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
      if(!mysql_read(tablePrepago, prepagoId, fila, &id)){
        if(id == idConsulta){
          //Config
          usart_write_lineConst("Modificado PAS+SALDO");
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
      if(!mysql_read(tablePrepago, prepagoId, fila, &id)){
        if(id == idConsulta){
          //Config
          usart_write_lineConst("Modificado PAS");
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
      usart_write_lineConst("Envio entregado del nodo");
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
          usart_write_textConst("Linea completa: ");
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
      usart_write_lineConst("No se pudo enviar al nodo");
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
    usart_write_textConst("FR: ");
    IntToStr(myTable.rowAct, msjConst);
    usart_write_text(msjConst);
    usart_write_textConst(", FT: ");
    IntToStr(pilaBufferTCP, msjConst);
    usart_write_text(msjConst);
    usart_write_lineConst(", Registrado TCP");
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
    if(++temp >= 20){
      temp = 0;
      SALIDA_RELE1 = 0; //APAGAR RELE DESPUES DE UN SEGUNDO
      SALIDA_RELE2 = 0;
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
    can.temp += 50;     //Can protocol
    legioTemp++;        //Lectura wiegand
    flagTMR3.B0 = true;
    //Acceso aceptado
    if(SALIDA_RELE3){
      if(legioTemp >= 20)  //Un segundo
        SALIDA_RELE3 = 0;
    }
    //Acceso denegado
    if(SALIDA_RELE4){
      if(legioTemp >= 6)  //300ms
        SALIDA_RELE4 = 0;
    }
    //ESPERAR CADA SEGUNDO PARA APAGAR RELE
    if(++temp >= 20){
      temp = 0;
      flagSecondTMR3.B0 = true;
      Net_Ethernet_28j60_UserTimerSec++;    //Para el protocolo tcp
    }
    //FINALIZAR INTERRUPCION
    TMR3H = getByte(sampler3,1);
    TMR3L = getByte(sampler3,0);
    PIR2.TMR3IF = 0;   //LIMP�AR BANDERA
  }
}
/******************************************************************************/