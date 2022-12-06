#line 1 "D:/Proyectos Luis/Estacionamiento beta/TPV 4680/tcp_tareas.c"
#line 1 "d:/proyectos luis/estacionamiento beta/tpv 4680/miscelaneos.h"









char bcdToDec(char dato){
 dato = 10*(swap(dato)&0x0F) + (dato&0x0F);

 return dato;
}

char decToBcd(char dato){
 dato = swap(dato/10) + (dato%10);

 return dato;
}

char* RomToRam(const char *origen, char *destino){
 unsigned int cont = 0;

 while(destino[cont] = origen[cont++]);

 return destino;
}

long clamp(long valor, long min, long max){
 if(valor > max)
 valor = max;
 else if(valor < min)
 valor = min;

 return valor;
}

long clamp_shift(long valor, long min, long max){
 if(valor > max)
 valor = min;
 else if(valor < min)
 valor = max;

 return valor;
}
#line 1 "d:/proyectos luis/estacionamiento beta/tpv 4680/tcp_tareas.h"
void net_ethernet_open();
#line 1 "d:/proyectos luis/estacionamiento beta/tpv 4680/__netethenc28j60.h"
typedef struct {
 char remoteIP[4];
 char remoteMAC[6];
 unsigned int remotePort;
 unsigned int destPort;
 unsigned int dataLength;
 unsigned int broadcastMark;


} UDP_28j60_Dsc;

typedef struct {
char remoteIP[4];
char remoteMAC[6];
unsigned int remotePort;
unsigned int destPort;

unsigned int dataLength;
unsigned int remoteMSS;
unsigned int myWin;
unsigned int myMSS;
unsigned long mySeq;
unsigned long myACK;
char stateTimer;
char retransmitTimer;
unsigned int packetID;
char open;

char ID;
char broadcastMark;
char state;









unsigned int nextSend;
unsigned int lastACK;
unsigned int lastSent;
unsigned int lastWritten;
unsigned int numToSend;
char buffState;
char *txBuffer;


}
SOCKET_28j60_Dsc;
#line 1 "d:/proyectos luis/estacionamiento beta/tpv 4680/spi_tcp.h"
#line 1 "d:/proyectos luis/estacionamiento beta/tpv 4680/miscelaneos.h"
#line 3 "d:/proyectos luis/estacionamiento beta/tpv 4680/spi_tcp.h"
extern sfr sbit SPI_CS;
extern sfr sbit SPI_CSD;


const char ETH_READ_CMD = 0x00;
const char ETH_WRITE_CMD = 0x40;


const char PHLCON = 0x14;
const char PHSTAT1 = 0x01;
const char PHSTAT2 = 0x11;

const char ECON1 = 0x1F;

const char MICMD = 0x12;
const char MIREGADR = 0x14;
const char MIWRL = 0x16;
const char MIWRH = 0x17;
const char MIRDL = 0x18;
const char MIRDH = 0x19;

const char MISTAT = 0x0A;



char spi_tcp_read(char reg,  char  reg_eth){
 SPI_CS = 0;
 SPI1_write(ETH_READ_CMD|reg);
 reg = SPI1_read(0);
 if(!reg_eth)
 reg = SPI1_read(0);
 SPI_CS = 1;

 return reg;
}

void spi_tcp_write(char reg, char value){
 SPI_CS = 0;
 SPI1_write(ETH_WRITE_CMD|reg);
 SPI1_write(value);
 SPI_CS = 1;
}

unsigned int spi_tcp_read_phy(char regPHY){
 char resp[2],banco;
 unsigned int value;


 resp[0] = spi_tcp_read(ECON1,  1 );
 banco = resp[0];
 resp[0].B0 = 0;
 resp[0].B1 = 1;
 spi_tcp_write(ECON1, resp[0]);
 resp[1] = spi_tcp_read(MICMD,  0 );

 spi_tcp_write(MIREGADR, regPHY);

 resp[1].B0 = 1;
 spi_tcp_write(MICMD, resp[1]);
 delay_us(12);

 resp[0].B0 = 1;
 resp[0].B1 = 1;
 spi_tcp_write(ECON1, resp[0]);

 while(spi_tcp_read(MISTAT,  0 ).B0);

 resp[0].B0 = 0;
 resp[0].B1 = 1;
 spi_tcp_write(ECON1, resp[0]);

 resp[1].B0 = 0;
 spi_tcp_write(MICMD, resp[1]);

  ((char*)&value)[0]  = spi_tcp_read(MIRDL,  0 );
  ((char*)&value)[1]  = spi_tcp_read(MIRDH,  0 );

 spi_tcp_write(ECON1, banco);

 return value;
}

 char  spi_tcp_linked(){
 unsigned int aux = spi_tcp_read_phy(PHSTAT2);

 aux =  ((char*)&aux)[1] .B2;

 return aux;
}
#line 1 "d:/proyectos luis/estacionamiento beta/tpv 4680/lib_usart.h"
#line 1 "d:/proyectos luis/estacionamiento beta/tpv 4680/string.h"



char* string_ncopy(char *destino, char *origen, char size){
 char cont;

 for(cont = 0; cont < size && origen[cont]; cont++)
 destino[cont] = origen[cont];
 destino[cont] = 0;

 return destino;
}

char* numToString(long valor, char *cadena, short digitos){
 cadena[digitos--] = 0;
 while(digitos >= 0){

 cadena[digitos--] = (valor % 10) + '0';
 valor /= 10;
 }

 return cadena;
}

char* numToHex(long valor, char *cadena, char bytes){
 char cont = 0;


 while(bytes--){

 cadena[cont] = swap( ((char*)&valor)[bytes] )&0x0F;
 if(cadena[cont] < 0x0A)
 cadena[cont] = cadena[cont] + '0';
 else
 cadena[cont] = cadena[cont] + '7';
 cont++;

 cadena[cont] =  ((char*)&valor)[bytes] &0x0F;
 if(cadena[cont] < 0x0A)
 cadena[cont] = cadena[cont] + '0';
 else
 cadena[cont] = cadena[cont] + '7';
 cont++;
 }
 cadena[cont] = 0;

 return cadena;
}
#line 13 "d:/proyectos luis/estacionamiento beta/tpv 4680/lib_usart.h"
const char UART_BUFFER_SIZE = 16;


struct MODULE_USART{

 volatile char message[UART_BUFFER_SIZE];

 char rx_delimiter;
 volatile  char  rx_new_message;
 volatile  char  rx_overflow;
 volatile char rx_cont;

 volatile  char  tx_free;
 volatile char tx_cont;
 char tx_buffer[UART_BUFFER_SIZE];
}usart;


void usart_user_read_text();



void usart_open(unsigned long baudRate){

 TXSTA.CSRC = 0;
 TXSTA.TX9 = 0;
 TXSTA.TXEN = 1;
 TXSTA.SYNC = 0;
 TXSTA.SENDB = 0;
 TXSTA.BRGH = 1;

 TXSTA.TX9D = 0;


 RCSTA.RX9 = 0;
 RCSTA.SREN = 0;
 RCSTA.CREN = 1;
 RCSTA.ADDEN = 0;
 RCSTA.SPEN = 1;






 BAUDCON.SCKP = 0;
 BAUDCON.BRG16 = 1;
 BAUDCON.WUE = 0;
 BAUDCON.ABDEN = 0;



 baudRate >>= 1;
 baudRate = (Clock_MHz()*250e3)/baudRate;
 baudRate += 1;
 baudRate >>= 1;
 baudRate -= 1;
 SPBRG =  ((char*)&baudRate)[0] ;
 SPBRGH =  ((char*)&baudRate)[1] ;


 TRISC.B6 = 0;
 TRISC.B7 = 1;


 while(!TXSTA.TRMT);
}

 char  usart_read(char *result){
 if(PIR1.RCIF){
 *result = RCREG;
 PIR1.RCIF = 0;
 return  1 ;
 }

 return  0 ;
}

void usart_write(char caracter){
 TXREG = caracter;
 while(!TXSTA.TRMT);
}

void usart_write_text(char *texto){
 char cont = 0;

 while(texto[cont]){
 TXREG = texto[cont++];
 while(!TXSTA.TRMT);
 }
}

void usart_enable_rx( char  enable,  char  priorityHigh, char delimitir){

 usart.rx_cont = 0;
 usart.rx_delimiter = delimitir;
 usart.rx_new_message =  0 ;
 usart.rx_overflow =  0 ;


 IPR1.RCIP = priorityHigh;
 PIR1.RCIF = 0;
 PIE1.RCIE = enable;
}

void usart_enable_tx( char  priorityHigh){

 usart.tx_free =  1 ;
 usart.tx_cont = 0;


 IPR1.TXIP = priorityHigh;
 PIR1.TXIF = 0;
 PIE1.TXIE = 0;
}

void usart_do_read_text(){

 if(usart.rx_new_message){
 usart_user_read_text();
 usart.rx_new_message =  0 ;
 }
}

 char  usart_write_text_int(char *texto){

 if(usart.tx_free && TXSTA.TRMT){
 usart.tx_free =  0 ;

 string_ncopy(usart.tx_buffer, texto, UART_BUFFER_SIZE-1);
 usart.tx_cont = 0;
 PIE1.TXIE = 1;
 return  1 ;
 }

 return  0 ;
}

void int_usart_rx(void){
 if(PIE1.RCIE && PIR1.RCIF){
 if(!usart.rx_new_message.B0){

 usart.message[usart.rx_cont] = RCREG;

 if(RCREG == usart.rx_delimiter){

 usart.rx_new_message.B0 =  1 ;
 usart.message[usart.rx_cont] = 0;

 usart.rx_cont = 0;
 PIR1.RCIF = 0;
 return;
 }
 usart.rx_cont++;
 usart.rx_cont &= (UART_BUFFER_SIZE-1);

 usart.rx_overflow.B0 |= !usart.rx_cont?  1 : 0 ;
 }else{
 RCREG &= 0xFF;
 }
 PIR1.RCIF = 0;
 }
}

void int_usart_tx(){
 if(PIE1.TXIE && PIR1.TXIF){
 TXREG = usart.tx_buffer[usart.tx_cont++];

 if(!usart.tx_buffer[usart.tx_cont]){
 usart.tx_free =  1 ;
 PIE1.TXIE = 0;
 }
 PIR1.TXIF = 0;
 }
}
#line 10 "D:/Proyectos Luis/Estacionamiento beta/TPV 4680/tcp_tareas.c"
extern char *msjConst;


const char peticionGET[] = "GET /";
const char timeReconectTCP = 3;
const char timeCreateNewPort = 5;
const char timePushBuffer = 5;
const unsigned int myPortMin = 123;
const unsigned int myPortMax = 127;

 char  sendDataTCP =  0 ;
 char  isEmptyBuffer;
 char  isConectTCP;
 char  isConectServer;
char conectTCP;
char *punteroTCP;
char myMacAddr[6] = {0x00, 0x14, 0xA5, 0x76, 0x19, 0x3f} ;
char myIpAddr[4] = {192, 168, 0, 5};
char ipMask[] = {255, 255, 255, 0};
char gwIpAddr[] = {192, 168, 1, 1};
char dnsIpAddr[4] = {192, 168, 1, 1};
char ipAddr[] = {192, 168, 0, 99};
char getRequest[64];
unsigned int portServer = 80;
unsigned int myPort = 123;
SOCKET_28j60_Dsc *sock1;
unsigned int tempPushBuffer;
unsigned int tempCreateNewPort;
unsigned int tempReconectTCP;

const char TCP_PENSIONADO[] = "PEN";
const char TCP_REGISTAR[] = "REG";
const char TCP_ACTUALIZAR[] = "ACT";
const char TCP_CONSULTAR[] = "CON";


void Net_Ethernet_28j60_UserTCP(SOCKET_28j60_Dsc *socket){
 unsigned int cont;
 static unsigned int puntero = 0;
 char vigente;
 long idPensionado, idUser;

 static  char  recibe =  1 ;



 if(!sendDataTCP.B0){

 if(!socket->dataLength)
 return;

 if(socket->remotePort == portServer && socket->destPort == myPort){

 for(cont = 0; cont < socket->dataLength && cont < sizeof(getRequest)-1; cont++)
 getRequest[cont] = Net_Ethernet_28j60_getByte();
 getRequest[cont] = 0;


 inttostr(socket->dataLength,msjConst);
 usart_write_text("Bytes: ");
 usart_write_text(msjConst);
 usart_write_text(" ,");

 usart_write_text("Mensaje: ");
 usart_write_text(getRequest);
 usart_write_text("\r\n");


 if(strncmp(getrequest, RomToRam(peticionGET, msjConst), 5))
 return;





 }
#line 163 "D:/Proyectos Luis/Estacionamiento beta/TPV 4680/tcp_tareas.c"
 }else{
 cont = 0;
 while(punteroTCP[cont])
 Net_Ethernet_28j60_putByteTCP(punteroTCP[cont++],socket_28j60);

 Net_Ethernet_28j60_putByteTCP('\r',socket_28j60);
 Net_Ethernet_28j60_putByteTCP('\n',socket_28j60);
 sendDataTCP.B0 =  0 ;
 }

}

unsigned int Net_Ethernet_28j60_UserUDP(SOCKET_28j60_Dsc *socket){
 return 0;
}

void net_ethernet_open(){
 SPI1_Init();
 Net_Ethernet_28j60_Init(myMacAddr, myIpAddr, 0x01);
 Net_Ethernet_28j60_confNetwork(ipMask, gwIpAddr, dnsIpAddr);
 Net_Ethernet_28j60_stackInitTCP();
}
