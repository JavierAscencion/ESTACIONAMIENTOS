#line 1 "D:/Proyectos Luis/Estacionamiento beta/TPV 4680/tcp.c"
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



char spi_tcp_read(char reg, bool reg_eth){
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


 resp[0] = spi_tcp_read(ECON1, true);
 banco = resp[0];
 resp[0].B0 = 0;
 resp[0].B1 = 1;
 spi_tcp_write(ECON1, resp[0]);
 resp[1] = spi_tcp_read(MICMD, false);

 spi_tcp_write(MIREGADR, regPHY);

 resp[1].B0 = 1;
 spi_tcp_write(MICMD, resp[1]);
 delay_us(12);

 resp[0].B0 = 1;
 resp[0].B1 = 1;
 spi_tcp_write(ECON1, resp[0]);

 while(spi_tcp_read(MISTAT, false).B0);

 resp[0].B0 = 0;
 resp[0].B1 = 1;
 spi_tcp_write(ECON1, resp[0]);

 resp[1].B0 = 0;
 spi_tcp_write(MICMD, resp[1]);

 getByte(value, 0) = spi_tcp_read(MIRDL, false);
 getByte(value, 1) = spi_tcp_read(MIRDH, false);

 spi_tcp_write(ECON1, banco);

 return value;
}

bool spi_tcp_linked(){
 unsigned int aux = spi_tcp_read_phy(PHSTAT2);

 aux = getByte(aux,1).B2;

 return aux;
}
#line 5 "D:/Proyectos Luis/Estacionamiento beta/TPV 4680/tcp.c"
const char peticionGET[] = "GET /";
const char timeReconectTCP = 3;
const char timeCreateNewPort = 5;
const char timePushBuffer = 5;
const unsigned int myPortMin = 123;
const unsigned int myPortMax = 127;

bool sendDataTCP = false;
bool isEmptyBuffer;
bool isConectTCP;
bool isConectServer;
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

 static bool recibe = true;



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


 mysql_search(tablePensionados, pensionadosID, valor, &


 }
#line 155 "D:/Proyectos Luis/Estacionamiento beta/TPV 4680/tcp.c"
 }else{
 cont = 0;
 while(punteroTCP[cont])
 Net_Ethernet_28j60_putByteTCP(punteroTCP[cont++],socket_28j60);

 Net_Ethernet_28j60_putByteTCP('\r',socket_28j60);
 Net_Ethernet_28j60_putByteTCP('\n',socket_28j60);
 sendDataTCP.B0 = false;
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
