#line 1 "D:/PROYECTOS/PARKING/HOSPITAL SANTE/Expendedora 4685/Expendedora.c"
#line 1 "d:/proyectos/parking/hospital sante/expendedora 4685/miscelaneos.h"








void getByte(char var, char offset);







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
#line 1 "d:/proyectos/parking/hospital sante/expendedora 4685/string.h"
#line 1 "d:/proyectos/parking/hospital sante/expendedora 4685/miscelaneos.h"
#line 6 "d:/proyectos/parking/hospital sante/expendedora 4685/string.h"
char string_push(char *texto, char caracter){
 char cont = 0;

 while(texto[cont])
 cont++;

 texto[cont++] = caracter;
 texto[cont] = 0;

 return cont;
}

char string_pop(char *texto){
 char cont = 0, result;


 while(texto[cont])
 cont++;

 if(cont == 0)
 return cont;

 result = texto[--cont];
 texto[cont] = 0;


 return result;
}

char string_add(char *destino, char *addEnd){
 char total = 0, cont = 0;


 while(destino[total])
 total++;

 while(addEnd[cont])
 destino[total++] = addEnd[cont++];
 destino[total] = 0;


 return total;
}

char string_addc(char *destino, const char *addEnd){
 char total = 0, cont = 0;


 while(destino[total])
 total++;

 while(addEnd[cont])
 destino[total++] = addEnd[cont++];
 destino[total] = 0;


 return total;
}

char string_cpy(char *destino, char *origen){
 char cont = 0;

 while(origen[cont])
 destino[cont] = origen[cont++];
 destino[cont] = 0;


 return cont;
}

char string_cpyn(char *destino, char *origen, char size){
 char cont;

 for(cont = 0; cont < size && origen[cont]; cont++)
 destino[cont] = origen[cont];
 destino[cont] = 0;

 return cont;
}

char string_cpyc(char *destino, const char *origen){
 char cont = 0;

 while(origen[cont])
 destino[cont] = origen[cont++];
 destino[cont] = 0;

 return cont;
}

char string_len(char *texto){
 char cont = 0;
 while(texto[cont])
 cont++;

 return cont;
}

 char  string_cmp(char *text1, char *text2){
 char cont = 0;

 while( 1 ){
 if(text1[cont] != text2[cont])
 return  0 ;
 else if(text1[cont] == 0 || text2[cont] == 0)
 break;
 else
 cont++;
 }

 return  1 ;
}

 char  string_cmpc(const char *text1, char *text2){
 char cont = 0;

 while( 1 ){
 if(text1[cont] != text2[cont])
 return  0 ;
 else if(text1[cont] == 0 || text2[cont] == 0)
 break;
 else
 cont++;
 }

 return  1 ;
}

 char  string_cmpn(char *text1, char *text2, char bytes){
 char cont;

 for(cont = 0; cont < bytes; cont++){
 if(text1[cont] != text2[cont])
 return  0 ;
 }

 return  1 ;
}

 char  string_cmpnc(const char *text1, char *text2, char bytes){
 char cont;

 for(cont = 0; cont < bytes; cont++){
 if(text1[cont] != text2[cont])
 return  0 ;
 }

 return  1 ;
}

 char  string_isNumeric(char *cadena){
 char cont = 0;

 while(cadena[cont] != 0){
 if(cadena[cont] < '0' || cadena[cont] > '9')
 return  0 ;
 cont++;
 }

 if(cont != 0)
 return  1 ;
 else
 return  0 ;
}

long stringToNumN(char *cadena, char size){
 char cont;
 long numero = 0;


 for(cont = 0; cont < size && cadena[cont] != 0; cont++){
 numero *= 10;
 numero += cadena[cont]-'0';
 }

 return numero;
}

long stringToNum(char *cadena){
 short cont = 0;
 long numero = 0;


 while(cadena[cont]){
 numero *= 10;
 numero += cadena[cont++]-'0';
 }

 return numero;
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

long hexToNum(char *hex){
 char cont;
 char ref = strlen(hex)-1;
 long valor = 0;


 for(cont = 0; cont < 8 && hex[cont]; cont++, ref--){

 if(hex[cont] >= '0' && hex[cont] <= '9')
  ((char*)&valor)[ref/2]  |= hex[cont] - '0';
 else if(hex[cont] >= 'a' && hex[cont] <= 'f')
  ((char*)&valor)[ref/2]  |= 10+(hex[cont] - 'a');
 else if(hex[cont] >= 'A' && hex[cont] <= 'F')
  ((char*)&valor)[ref/2]  |= 10+(hex[cont] - 'A');
 else
 break;


 if(ref % 2 == 1)
  ((char*)&valor)[ref/2]  = swap( ((char*)&valor)[ref/2] );
 }

 return valor;
}

char* string_toUpper(char *cadena){
 char cont = 0;
 while(cadena[cont] != 0){
 if(cadena[cont] >= 'a' && cadena[cont] <= 'z')
 cadena[cont] -= 'a'-'A';
 cont++;
 }
 return cadena;
}
#line 1 "d:/proyectos/parking/hospital sante/expendedora 4685/lib_timer1.h"



unsigned int sampler1;


void int_timer1();


void timer1_open(long time_us,  char  powerOn,  char  enable,  char  priorityHigh){
 char i;


 time_us *= Clock_Mhz();
 time_us /= 4;

 for(i = 0; i < 3; i++){
 if(time_us < 65536)
 break;

 time_us /= 2;
 }
 time_us = 65536-time_us;
 sampler1 = time_us;

 T1CON.TMR1ON = 0;
 T1CON.RD16 = 1;
 T1CON.T1CKPS0 = i.B0;
 T1CON.T1CKPS1 = i.B1;
 T1CON.T1OSCEN = 0;
 T1CON.T1SYNC = 0;
 T1CON.TMR1CS = 0;


 TMR1H =  ((char*)&sampler1)[1] ;
 TMR1L =  ((char*)&sampler1)[0] ;


 PIR1.TMR1IF = 0;
 PIE1.TMR1IE = enable;
 IPR1.TMR1IP = priorityHigh;
 T1CON.TMR1ON = powerOn;
}

void timer1_enable( char  enable){
 PIE1.TMR1IE = enable;
}

void timer1_power( char  on){
 T1CON.TMR1ON = on;
}

void timer1_priority( char  hihg){
 IPR1.TMR1IP = hihg;
}

void timer1_reset(){
 TMR1H =  ((char*)&sampler1)[1] ;
 TMR1L =  ((char*)&sampler1)[0] ;
}
#line 1 "d:/proyectos/parking/hospital sante/expendedora 4685/lib_timer2.h"




void int_timer2();



void timer2_open(long time_us,  char  powerOn,  char  enable,  char  priorityHigh){
 char pres = 1, post, auxPre = 0xFF;



 time_us *= Clock_Mhz();


 for(pres = 1; pres <= 16; pres *= 4){
 auxPre++;
 for(post = 1; post <= 16; post++){
 if(time_us/(pres*post*4U) <= 255){
 time_us /= 4;
 time_us /= pres;
 time_us /= post;
 PR2 = time_us;
 pres = 16;
 break;
 }
 }
 }


 T2CON.T2CKPS0 = auxPre.B0;
 T2CON.T2CKPS1 = auxPre.B1;
 post--;
 T2CON.T2OUTPS0 = post.B0;
 T2CON.T2OUTPS1 = post.B1;
 T2CON.T2OUTPS2 = post.B2;
 T2CON.T2OUTPS3 = post.B3;


 TMR2 = 0;


 PIR1.TMR2IF = 0;
 PIE1.TMR2IE = enable;
 IPR1.TMR2IP = priorityHigh;
 T2CON.TMR2ON = powerOn;
}

void timer2_enable( char  enable){
 PIE1.TMR2IE = enable;
}

void timer2_power( char  on){
 T2CON.TMR2ON = on;
}

void timer2_priority( char  hihg){
 IPR1.TMR2IP = hihg;
}
#line 1 "d:/proyectos/parking/hospital sante/expendedora 4685/lib_timer3.h"



unsigned int sampler3;


void int_timer3();


void timer3_open(long time_us,  char  powerOn,  char  enable,  char  priorityHigh){
 char i;


 time_us *= Clock_Mhz();
 time_us /= 4;

 for(i = 0; i < 3; i++){
 if(time_us < 65536)
 break;

 time_us /= 2;
 }
 time_us = 65536-time_us;
 sampler3 = time_us;

 T3CON.TMR3ON = 0;
 T3CON.RD16 = 1;
 T3CON.T3CCP1 = 1;
 T3CON.T3ECCP1 = 1;
 T3CON.T3CKPS0 = i.B0;
 T3CON.T3CKPS1 = i.B1;
 T3CON.T3SYNC = 0;
 T3CON.TMR3CS = 0;


 TMR3H =  ((char*)&sampler3)[1] ;
 TMR3L =  ((char*)&sampler3)[0] ;


 PIR2.TMR3IF = 0;
 PIE2.TMR3IE = enable;
 IPR2.TMR3IP = priorityHigh;
 T3CON.TMR3ON = powerOn;
}

void timer3_enable( char  enable){
 PIE3.TMR3IE = enable;
}

void timer3_power( char  on){
 T3CON.TMR3ON = on;
}

void timer3_priority( char  hihg){
 IPR2.TMR3IP = hihg;
}
#line 1 "d:/proyectos/parking/hospital sante/expendedora 4685/lib_usart.h"
#line 1 "d:/proyectos/parking/hospital sante/expendedora 4685/string.h"
#line 13 "d:/proyectos/parking/hospital sante/expendedora 4685/lib_usart.h"
const char UART_BUFFER_SIZE = 32;


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


const char USART_NEW_LINE[] = "\r\n";


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

void usart_write_line(char *texto){
 char cont = 0;

 while(texto[cont]){
 TXREG = texto[cont++];
 while(!TXSTA.TRMT);
 }

 TXREG = USART_NEW_LINE[0];
 while(!TXSTA.TRMT);
 TXREG = USART_NEW_LINE[1];
 while(!TXSTA.TRMT);
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

 string_cpyn(usart.tx_buffer, texto, UART_BUFFER_SIZE-1);
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
#line 1 "d:/proyectos/parking/hospital sante/expendedora 4685/lib_can.h"
#line 1 "d:/proyectos/parking/hospital sante/expendedora 4685/miscelaneos.h"
#line 40 "d:/proyectos/parking/hospital sante/expendedora 4685/lib_can.h"
const char CAN_SYNC_JUMP_WIDTH = 0;
const  char  CAN_SAMPLE_THRICE_TIMES =  1 ;
const  char  CAN_WAKE_UP_IN_ACTIVITY =  1 ;
const  char  CAN_LINE_FILTER_ON =  0 ;
const  char  CAN_USE_DOUBLE_BUFFER =  0 ;
const  char  CAN_ENABLE_CAPTURE =  0 ;
const  char  CAN_ENABLE_DRIVE_HIGH =  0 ;
const  char  CAN_FORMAT_EXTENDED =  1 ;


const unsigned int CAN_MAX_TIME_ACK = 3000;

const char CAN_RW_EMPTY = 0;
const char CAN_RW_DATA = 1;
const char CAN_RW_REQUEST = 2;

const char CAN_RW_ENVIADO = 0;
const char CAN_RW_WITHOUT_QUEU = 1;
const char CAN_RW_BUSY = 2;
const char CAN_RW_CORRUPT = 3;

const char CAN_LEN_BUFFER_RXTX = 64;


const char CAN_OPERATION_NORMAL = 0,
 CAN_OPERATION_DISABLE = 1,
 CAN_OPERATION_LOOPBACK = 2,
 CAN_OPERATION_LISTEN = 3,
 CAN_OPERATION_CONFIG = 4;

const char CAN_MODE_LEGACY = 0,
 CAN_MODE_ENHANCED_LEGACY = 1,
 CAN_MODE_ENHANCED_FIFO = 2;

const char CAN_PROTOCOL_INIT = 0,
 CAN_PROTOCOL_QUEU = 1,
 CAN_PROTOCOL_END = 2,
 CAN_PROTOCOL_BUSY = 3,
 CAN_PROTOCOL_FREE = 4,
 CAN_PROTOCOL_HEARTBEAT = 255;
#line 110 "d:/proyectos/parking/hospital sante/expendedora 4685/lib_can.h"
typedef struct{

 long ip;
 long ipAddress;
 long mask;
 char id;

  char  conected;

 char mode;
  char  overflow;
 short numFilter;

 char bufferTX[8];
 char bufferRX[8];

  char  txQueu;
 char tx_status;
 char txSize;
 char txPriority;
 long txId;
 char txBuffer[CAN_LEN_BUFFER_RXTX];

  char  rxRequest;
  char  rxBusy;
 char rxBuffer[CAN_LEN_BUFFER_RXTX];
 char rxSize;
 char rxId;

 unsigned int temp;
}MODULE_CAN;

MODULE_CAN can;


void can_set_mode(const char CAN_MODE);
void can_set_operation(const char CAN_OPERATION);
void can_set_baud(unsigned int speed_us);
void can_set_id(char *address, long value);
long can_get_id(char *address);
 char  can_write(long id, char *datos, char size, char priority,  char  rtr);
char can_read(long *id, char *datos, char *size);

void can_user_read_message();
void can_user_write_message();
void can_user_guardHeartBeat(char idNodo);

 char  can_write_text(long ipAddress, char *texto, char priority){

 if(!can.txQueu && !can.rxBusy){
 can.txSize = 0;
 can.txQueu =  1 ;
 can.txId = ipAddress;
 can.txPriority = priority;

 while( 1 ){
 can.txBuffer[can.txSize] = texto[can.txSize];

 if(texto[can.txSize])
 can.txSize++;
 else
 break;
 }
 can.temp = 0;
 return  1 ;
 }

 return  0 ;
}

void can_do_write_message(){
 static  char  finalizar;
 static char maquinaE = 0;
 static char datosEnviados;
 char cont;
 long id;


 if(!can.txQueu)
 return;


 if(can.temp >= CAN_MAX_TIME_ACK){
 maquinaE = 0;
 can.txQueu =  0 ;

 can.tx_status = CAN_RW_CORRUPT;
 can_user_write_message();
 }


 if(maquinaE == 0){
 maquinaE = 2;
 datosEnviados = 0;
 finalizar =  0 ;
 can.bufferTX[0] = can.id;
 can.bufferTX[1] = CAN_PROTOCOL_INIT;
 can_write(can.txId, can.bufferTX, 2, can.txPriority,  0 );
 can.temp = 0;
 }else if(maquinaE == 1){
 finalizar = !can.txBuffer[datosEnviados];

 can.bufferTX[0] = can.id;

 can.bufferTX[1] = can.txBuffer[datosEnviados]?CAN_PROTOCOL_QUEU:CAN_PROTOCOL_END;
 for(cont = 2; cont < 8 && can.txBuffer[datosEnviados]; cont++)
 can.bufferTX[cont] = can.txBuffer[datosEnviados++];


 can_write(can.txId, can.bufferTX, cont, can.txPriority,  0 );
 maquinaE++;
 can.temp = 0;
 }else if(maquinaE == 2){
 if(can_read(&id, can.bufferRX, &can.rxSize) == CAN_RW_DATA){
 if(id == can.ipAddress){

 if(can.bufferRX[0] ==  ((char*)&can.txId)[0] ){
 if(can.bufferRX[1] == CAN_PROTOCOL_FREE){

 maquinaE += !finalizar? -1:1;
 can.temp = 0;
 }else if(can.bufferRX[1] == CAN_PROTOCOL_INIT){

 can.bufferTX[0] = can.id;
 can.bufferTX[1] = CAN_PROTOCOL_BUSY;
 can_write(can.txId, can.bufferTX, 2, 3,  0 );

 maquinaE = 0;
 }else if(can.bufferRX[1] == CAN_PROTOCOL_BUSY){
 maquinaE = 0;
 can.txQueu =  0 ;

 can.tx_status = CAN_RW_CORRUPT;
 can_user_write_message();
 }
 }else{
 if(can.bufferRX[1] == CAN_PROTOCOL_HEARTBEAT){
 can_user_guardHeartBeat(can.bufferRX[0]);
 return;
 }
 }
 }
 }
 }else if(maquinaE == 3){
 maquinaE = 0;
 can.txQueu =  0 ;
 finalizar =  0 ;
 can.tx_status = CAN_RW_ENVIADO;
 can_user_write_message();
 }

 can.tx_status = 0;

}

void can_do_read_message(){
 static char len = 0;
 long id;
 char cont;


 if(can.txQueu)
 return;


 if(can.rxBusy){
 if(can.temp >= CAN_MAX_TIME_ACK){
 can.rxBusy =  0 ;
 return;
 }
 }


 if(can_read(&id, can.bufferRX, &can.rxSize) == CAN_RW_DATA){
 if(id == can.ipAddress){

 if(can.bufferRX[1] == CAN_PROTOCOL_HEARTBEAT){
 can_user_guardHeartBeat(can.bufferRX[0]);
 return;
 }

 if(can.rxBusy){

 if(can.rxId != can.bufferRX[0]){
 can.bufferTX[0] = can.id;
 can.bufferTX[1] = CAN_PROTOCOL_BUSY;
 can_write(can.ip+can.bufferRX[0], can.bufferTX, 2, 3,  0 );
 return;
 }
 }

 if(can.bufferRX[1] == CAN_PROTOCOL_INIT){
 can.rxId = can.bufferRX[0];
 can.rxBusy =  1 ;
 len = 0;
 can.temp = 0;
 }else if(!can.rxBusy){

 return;
 }else if(can.bufferRX[1] == CAN_PROTOCOL_QUEU){

 for(cont = 2; cont < can.rxSize && len < CAN_LEN_BUFFER_RXTX-1; cont++)
 can.rxBuffer[len++] = can.bufferRX[cont];
 can.rxBuffer[len] = 0;
 can.temp = 0;
 }else if(can.bufferRX[1] == CAN_PROTOCOL_END){
 can.rxBuffer[len] = 0;
 len = 0;
 }


 can.bufferTX[0] = can.id;
 can.bufferTX[1] = CAN_PROTOCOL_FREE;
 can_write(can.ip+can.bufferRX[0], can.bufferTX, 2, 3,  0 );


 if(can.bufferRX[1] == CAN_PROTOCOL_END){
 can_user_read_message();
 can.rxBusy =  0 ;
 }
 }
 }
}

void can_open(long ip, long mask, char id, char speed_us){

 can.ip = ip;
 can.mask = mask;
 can.ipAddress = ip + id;
 can.id = id;


 can.conected =  1 ;
 can.tx_status = 0;
 can.txQueu =  0 ;
 can.rxBusy =  0 ;

 can_set_operation(CAN_OPERATION_CONFIG);
 can_set_mode(CAN_MODE_LEGACY);
 can_set_baud(speed_us);

 RXB0CON = 0;
 RXB0CON.RXM0 = 0;
 RXB0CON.RXM1 = 0;
 RXB0CON.RXB0DBEN = CAN_USE_DOUBLE_BUFFER;
 RXB1CON = 0;

 CIOCON.ENDRHI = CAN_ENABLE_DRIVE_HIGH;
 CIOCON.CANCAP = CAN_ENABLE_CAPTURE;


 can_set_id(&RXM0EIDL, mask);
 can_set_id(&RXM1EIDL, mask);

 can_set_id(&RXF0EIDL, can.ipAddress);
 can_set_id(&RXF1EIDL, can.ipAddress);
 can_set_id(&RXF2EIDL, can.ipAddress);
 can_set_id(&RXF3EIDL, can.ipAddress);
 can_set_id(&RXF4EIDL, can.ipAddress);
 can_set_id(&RXF5EIDL, can.ipAddress);

 can_set_id(&RXF6EIDL, 0);
 can_set_id(&RXF7EIDL, 0);
 can_set_id(&RXF8EIDL, 0);
 can_set_id(&RXF9EIDL, 0);
 can_set_id(&RXF10EIDL, 0);
 can_set_id(&RXF11EIDL, 0);
 can_set_id(&RXF12EIDL, 0);
 can_set_id(&RXF13EIDL, 0);
 can_set_id(&RXF14EIDL, 0);
 can_set_id(&RXF15EIDL, 0);







 TRISB.B2 = 0;
 TRISB.B3 = 1;


 can_set_operation(CAN_OPERATION_NORMAL);
}

void can_set_baud(unsigned int speed_us){
 char Tqp, pre;
#line 408 "d:/proyectos/parking/hospital sante/expendedora 4685/lib_can.h"
 speed_us *= Clock_Mhz();
 speed_us /= 2;
 for(Tqp = 25; Tqp >= 8; Tqp--){
 if(speed_us % Tqp == 0){
 pre = speed_us/Tqp;
 if(pre >= 1 && pre <= 64){

 BRGCON1 = --pre;
 BRGCON1.SJW0 = CAN_SYNC_JUMP_WIDTH.B0;
 BRGCON1.SJW1 = CAN_SYNC_JUMP_WIDTH.B1;
 Tqp--;
 break;
 }
 }
 }

 for(pre = 16; pre >= 2; pre -= 2){
 if(Tqp > pre){
 pre >>= 1;
 pre--;

 BRGCON2.SEG2PHTS = 1;
 BRGCON2.SAM = CAN_SAMPLE_THRICE_TIMES.B0;
 BRGCON2.SEG1PH0 = pre.B0;
 BRGCON2.SEG1PH1 = pre.B1;
 BRGCON2.SEG1PH2 = pre.B2;

 BRGCON3.WAKDIS = !CAN_WAKE_UP_IN_ACTIVITY;
 BRGCON3.WAKFIL = CAN_LINE_FILTER_ON;
 BRGCON3.SEG2PH0 = pre.B0;
 BRGCON3.SEG2PH1 = pre.B1;
 BRGCON3.SEG2PH2 = pre.B2;

 pre = Tqp - 2*(pre+1);
 pre--;
 BRGCON2.PRSEG0 = pre.B0;
 BRGCON2.PRSEG1 = pre.B1;
 BRGCON2.PRSEG2 = pre.B2;
 break;
 }
 }
}

char can_read(long *id, char *datos, char *size){
 char *receptor, *regLen, *buffer, *bufferBX;
 char ref;


 if(RXB0CON.RXFUL){
 bufferBX = &RXB0CON;
 regLen = &RXB0DLC;
 receptor = &RXB0EIDL;
 buffer = &RXB0D0;
 ref = can.mode == CAN_MODE_LEGACY? 0x00:0x10;
 can.overflow = COMSTAT.RXB0OVFL;
 COMSTAT.RXB0OVFL = 0;

 if(can.mode == CAN_MODE_LEGACY)
 can.numFilter = RXB0CON.FILHIT0;
 else
 can.numFilter = RXB0CON & 0x1F;
 }else if(RXB1CON.RXFUL){
 bufferBX = &RXB1CON;
 regLen = &RXB0DLC;
 receptor = &RXB1EIDL;
 buffer = &RXB1D0;
 ref = can.mode == CAN_MODE_LEGACY? 0x0A:0x10;
 ref |= can.mode == CAN_MODE_ENHANCED_LEGACY? 0x01:0x00;
 can.overflow = COMSTAT.RXB1OVFL;
 COMSTAT.RXB1OVFL = 0;
 if(can.mode == CAN_MODE_LEGACY)
 can.numFilter = RXB0CON.RXB0DBEN? RXB1CON&0x07: -1;
 else
 can.numFilter = RXB1CON & 0x1F;
 }else if(can.mode == CAN_MODE_LEGACY){
 return CAN_RW_EMPTY;
 }


 if(can.mode == CAN_MODE_LEGACY){
 CANCON &= 0xF1;
 CANCON |= ref;
 }else{

 if(!BSEL0.B0TXEN && B0CON.RXFUL){
 bufferBX = &B0CON;
 regLen = &B0DLC;
 receptor = &B0EIDL;
 buffer = &B0D0;
 can.overflow = COMSTAT.RXB0OVFL;
 COMSTAT.RXB0OVFL = 0;
 can.numFilter = B0CON & 0x1F;
 ref = 0x12;
 }else if(!BSEL0.B1TXEN && B1CON.RXFUL){
 bufferBX = &B1CON;
 regLen = &B1DLC;
 receptor = &B1EIDL;
 buffer = &B1D0;
 can.overflow = COMSTAT.RXB0OVFL;
 COMSTAT.RXB0OVFL = 0;
 can.numFilter = B1CON & 0x1F;
 ref = 0x13;
 }else if(!BSEL0.B2TXEN && B2CON.RXFUL){
 bufferBX = &B2CON;
 regLen = &B2DLC;
 receptor = &B2EIDL;
 buffer = &B2D0;
 can.overflow = COMSTAT.RXB0OVFL;
 COMSTAT.RXB0OVFL = 0;
 can.numFilter = B2CON & 0x1F;
 ref = 0x14;
 }else if(!BSEL0.B3TXEN && B3CON.RXFUL){
 bufferBX = &B3CON;
 regLen = &B3DLC;
 receptor = &B3EIDL;
 buffer = &B3D0;
 can.overflow = COMSTAT.RXB0OVFL;
 COMSTAT.RXB0OVFL = 0;
 can.numFilter = B3CON & 0x1F;
 ref = 0x15;
 }else if(!BSEL0.B4TXEN && B4CON.RXFUL){
 bufferBX = &B4CON;
 regLen = &B4DLC;
 receptor = &B4EIDL;
 buffer = &B4D0;
 can.overflow = COMSTAT.RXB0OVFL;
 COMSTAT.RXB0OVFL = 0;
 can.numFilter = B4CON & 0x1F;
 ref = 0x16;
 }else if(!BSEL0.B5TXEN && B5CON.RXFUL){
 bufferBX = &B5CON;
 regLen = &B5DLC;
 receptor = &B5EIDL;
 buffer = &B5D0;
 can.overflow = COMSTAT.RXB0OVFL;
 COMSTAT.RXB0OVFL = 0;
 can.numFilter = B5CON & 0x1F;
 ref = 0x17;
 }else{
 return CAN_RW_EMPTY;
 }

 ECANCON &= 0xE0;
 ECANCON |= ref;
 }


 *size = (*regLen)&0x0F;
 can.rxRequest = (*regLen).B6;

 *id = can_get_id(receptor);

 for(ref = 0; ref < *size && ref < 8; ref++)
 datos[ref] = buffer[ref];


 (*bufferBX).B7 = 0;


 if(bufferBX == &RXB0CON)
 PIR3.RXB0IF = 0;
 else if(bufferBX == &RXB1CON)
 PIR3.RXB1IF = 0;
 else
 PIR3.RXB1IF = 0;


 if(can.mode == CAN_MODE_LEGACY){
 CANCON &= 0xF1;
 CANCON |= 0x00;
 }else{
 ECANCON &= 0xE0;
 ECANCON |= 0x16;
 }

 if(!can.rxRequest)
 return CAN_RW_DATA;
 else
 return CAN_RW_REQUEST;
}

 char  can_write(long id, char *datos, char size, char priority,  char  rtr){

 char *transmisor, *mascara, *regLen, *buffer;
 char ref;


 if(!TXB0CON.TXREQ){
 transmisor = &TXB0CON;
 mascara = &TXB0EIDL;
 regLen = &TXB0DLC;
 buffer = &TXB0D0;
 ref = can.mode == CAN_MODE_LEGACY? 0x08:0x03;
 }else if(!TXB1CON.TXREQ){
 transmisor = &TXB1CON;
 mascara = &TXB1EIDL;
 regLen = &TXB1DLC;
 buffer = &TXB1D0;
 ref = can.mode == CAN_MODE_LEGACY? 0x06:0x04;
 }else if(!TXB2CON.TXREQ){
 transmisor = &TXB2CON;
 mascara = &TXB2EIDL;
 regLen = &TXB2DLC;
 buffer = &TXB2D0;
 ref = can.mode == CAN_MODE_LEGACY? 0x04:0x05;
 }else if(can.mode == CAN_MODE_LEGACY){
 return  0 ;
 }

 if(can.mode == CAN_MODE_LEGACY){

 CANCON &= 0xF1;
 CANCON |= ref;
 }else{

 if(BSEL0.B0TXEN && !B0CON.TXREQ){
 transmisor = &B0CON;
 mascara = &B0EIDL;
 regLen = &B0DLC;
 buffer = &B0D0;
 ref = 0x12;
 }else if(BSEL0.B1TXEN && !B1CON.TXREQ){
 transmisor = &B1CON;
 mascara = &B1EIDL;
 regLen = &B1DLC;
 buffer = &B1D0;
 ref = 0x13;
 }else if(BSEL0.B2TXEN && !B2CON.TXREQ){
 transmisor = &B2CON;
 mascara = &B2EIDL;
 regLen = &B2DLC;
 buffer = &B2D0;
 ref = 0x14;
 }else if(BSEL0.B3TXEN && !B3CON.TXREQ){
 transmisor = &B3CON;
 mascara = &B3EIDL;
 regLen = &B3DLC;
 buffer = &B3D0;
 ref = 0x15;
 }else if(BSEL0.B4TXEN && !B4CON.TXREQ){
 transmisor = &B4CON;
 mascara = &B4EIDL;
 regLen = &B4DLC;
 buffer = &B4D0;
 ref = 0x16;
 }else if(BSEL0.B5TXEN && !B5CON.TXREQ){
 transmisor = &B5CON;
 mascara = &B5EIDL;
 regLen = &B5DLC;
 buffer = &B5D0;
 ref = 0x17;
 }else{
 return  0 ;
 }

 ECANCON &= 0xE0;
 ECANCON |= ref;
 }


 (*transmisor).B0 = priority.B0;
 (*transmisor).B1 = priority.B1;

 can_set_id(mascara, id);

 *regLen = size;
 (*regLen).B6 = rtr;

 for(ref = 0; ref < size && ref < 8; ref++)
 buffer[ref] = datos[ref];

 (*transmisor).B3 = 1;


 if(can.mode == CAN_MODE_LEGACY){
 CANCON &= 0xF1;
 CANCON |= 0x00;
 }else{
 ECANCON &= 0xE0;
 ECANCON |= 0x16;
 }

 return  1 ;
}

void can_set_operation(const char CAN_OPERATION){
 CANCON.REQOP0 = CAN_OPERATION.B0;
 CANCON.REQOP1 = CAN_OPERATION.B1;
 CANCON.REQOP2 = CAN_OPERATION.B2;

 while(CANSTAT.OPMODE0 != CANCON.REQOP0 ||
 CANSTAT.OPMODE1 != CANCON.REQOP1 ||
 CANSTAT.OPMODE2 != CANCON.REQOP2);
}

void can_set_mode(const char CAN_MODE){
 char modeAct = 0;

 modeAct.B0 = CANSTAT.OPMODE0;
 modeAct.B1 = CANSTAT.OPMODE1;
 modeAct.B2 = CANSTAT.OPMODE2;

 can_set_operation(CAN_OPERATION_CONFIG);
 ECANCON.MDSEL0 = CAN_MODE.B0;
 ECANCON.MDSEL1 = CAN_MODE.B1;
 can_set_operation(modeAct);
 can.mode = CAN_MODE;
}

void can_set_id(char *address, long value){

 if(CAN_FORMAT_EXTENDED){
 address[0] =  ((char*)&value)[0] ;
 address[-1] =  ((char*)&value)[1] ;
 address[-2] =  ((char*)&value)[2]  & 0x03;
 address[-2].B3 = 1;
 value <<= 3;
 address[-2] |=  ((char*)&value)[2]  & 0xE0;
 address[-3] =  ((char*)&value)[3] ;
 }else{
 address[0] = 0;
 address[-1] = 0;
 address[-2] = 0x80;
 address[-2].B5 =  ((char*)&value)[0] .B0;
 address[-2].B6 =  ((char*)&value)[0] .B1;
 address[-2].B7 =  ((char*)&value)[0] .B2;
 value >>= 3;
 address[-3] =  ((char*)&value)[0] ;
 }
}

long can_get_id(char *address){
 long value = 0;

 if(CAN_FORMAT_EXTENDED){
  ((char*)&value)[0]  = address[0];
  ((char*)&value)[1]  = address[-1];
  ((char*)&value)[2]  = address[-2] & 0x03;
  ((char*)&value)[2] .B2 = address[-2].B5;
  ((char*)&value)[2] .B3 = address[-2].B6;
  ((char*)&value)[2] .B4 = address[-2].B7;
  ((char*)&value)[2] .B5 = address[-3].B0;
  ((char*)&value)[2] .B6 = address[-3].B1;
  ((char*)&value)[2] .B7 = address[-3].B2;
  ((char*)&value)[3]  = address[-3]>>3;
 }else{
  ((char*)&value)[0] .B0 = address[-2].B5;
  ((char*)&value)[0] .B1 = address[-2].B6;
  ((char*)&value)[0] .B2 = address[-2].B7;
  ((char*)&value)[0]  |= address[-3]<<3;
  ((char*)&value)[1] .B0 = address[-3].B5;
  ((char*)&value)[1] .B1 = address[-3].B6;
  ((char*)&value)[1] .B2 = address[-3].B7;
 }

 return value;
}

void can_abort( char  enable){
 CANCON.ABAT = enable;
}

void can_interrupt( char  enable,  char  hihgPriprity){


 PIR3.TXB0IF = 0;
 PIR3.TXB1IF = 0;
 PIR3.TXBnIF = 0;


 IPR3.TXB0IP = hihgPriprity;
 IPR3.TXB1IP = hihgPriprity;
 IPR3.TXBnIP = hihgPriprity;


 PIE3.TXB0IE = enable;
 PIE3.TXB1IE = enable;
 PIE3.TXBnIE = enable;
#line 792 "d:/proyectos/parking/hospital sante/expendedora 4685/lib_can.h"
}

void can_desonexion(){
 if(can.conected){
 if(TXB0CON.TXERR || TXB1CON.TXERR || TXB2CON.TXERR){
 if(TXB0CON.TXERR)
 TXB0CON.TXREQ = 1;
 if(TXB1CON.TXERR)
 TXB1CON.TXREQ = 1;
 if(TXB2CON.TXERR)
 TXB2CON.TXREQ = 1;
 can.conected =  0 ;
 }
 }
}

void can_do_work(){
 can_do_read_message();
 can_do_write_message();
 can_desonexion();
}

void int_can(){
#line 822 "d:/proyectos/parking/hospital sante/expendedora 4685/lib_can.h"
 if(PIE3.TXB0IE && PIR3.TXB0IF){
 can.conected.B0 =  1 ;
 PIR3.TXB0IF = 0;
 }
 if(PIE3.TXB1IE && PIR3.TXB1IF){
 can.conected.B0 =  1 ;
 PIR3.TXB1IF = 0;
 }
 if(PIE3.TXBnIE && PIR3.TXBnIF){
 can.conected.B0 =  1 ;
 PIR3.TXBnIF = 0;
 }
}
#line 1 "d:/proyectos/parking/hospital sante/expendedora 4685/ds1307.h"
#line 1 "d:/proyectos/parking/hospital sante/expendedora 4685/miscelaneos.h"
#line 1 "d:/proyectos/parking/hospital sante/expendedora 4685/string.h"
#line 19 "d:/proyectos/parking/hospital sante/expendedora 4685/ds1307.h"
extern sfr sbit DS1307_SCL;
extern sfr sbit DS1307_SCLD;
extern sfr sbit DS1307_SDA;
extern sfr sbit DS1307_SDAD;

sfr sbit Soft_I2C_Scl at DS1307_SCL;
sfr sbit Soft_I2C_Scl_Direction at DS1307_SCLD;
sfr sbit Soft_I2C_Sda at DS1307_SDA;
sfr sbit Soft_I2C_Sda_Direction at DS1307_SDAD;









typedef struct{
 char seconds;
 char minutes;
 char hours;
 char dayOfWeek;
 char day;
 char month;
 char year;
 char time[20];
}DS1307;

char* DS1307_date(DS1307 *myDS,  char  formatComplet);

void DS1307_open(){
 Soft_I2C_Init();
}

void DS1307_write(DS1307 *myDS, char DOW, char HH, char MM, char SS, char DD, char MTH, char YY){

 Soft_I2C_Start();
 Soft_I2C_Write( 0xD0 );
 Soft_I2C_Write(0x00);


 Soft_I2C_Write(decToBcd(SS));
 Soft_I2C_Write(decToBcd(MM));
 Soft_I2C_Write(decToBcd(HH));
 Soft_I2C_Write(decToBcd(DOW));
 Soft_I2C_Write(decToBcd(DD));
 Soft_I2C_Write(decToBcd(MTH));
 Soft_I2C_Write(decToBcd(YY));
 Soft_I2C_Write(0x80);
 Soft_I2C_Stop();


 myDS->seconds = SS;
 myDS->minutes = MM;
 myDS->hours = HH;
 myDS->dayOfWeek = DOW;
 myDS->day = DD;
 myDS->month = MTH;
 myDS->year = YY;


 DS1307_date(myDS,  1 );
}

 char  DS1307_write_string(DS1307 *myDS, char *date){

 if(string_len(date) != 13 || !string_isNumeric(date))
 return  0 ;


 myDS->dayOfWeek = stringToNumN(&date[0], 1);
 myDS->hours = stringToNumN(&date[1], 2);
 myDs->minutes = stringToNumN(&date[3], 2);
 myDS->seconds = stringToNumN(&date[5], 2);
 myDS->day = stringToNumN(&date[7], 2);
 myDS->month = stringToNumN(&date[9], 2);
 myDS->year = stringToNumN(&date[11], 2);

 Soft_I2C_Start();
 Soft_I2C_Write( 0xD0 );
 Soft_I2C_Write(0x00);


 Soft_I2C_Write(decToBcd(myDS->seconds));
 Soft_I2C_Write(decToBcd(myDS->minutes));
 Soft_I2C_Write(decToBcd(myDs->hours));
 Soft_I2C_Write(decToBcd(myDS->dayOfWeek));
 Soft_I2C_Write(decToBcd(myDS->day));
 Soft_I2C_Write(decToBcd(myDS->month));
 Soft_I2C_Write(decToBcd(myDS->year));
 Soft_I2C_Write(0x80);
 Soft_I2C_Stop();


 DS1307_date(myDS,  1 );
}

char* DS1307_read(DS1307 *myDS,  char  formatComplet){
 Soft_I2C_Start();
 Soft_I2C_Write( 0xD0 );
 Soft_I2C_Write(0x00);
 Soft_I2C_Start();
 Soft_I2C_Write( 0xD1 );

 myDS->seconds = Soft_I2C_Read( 1 );
 myDS->minutes = Soft_I2C_Read( 1 );
 myDS->hours = Soft_I2C_Read( 1 );
 myDS->dayOfWeek = Soft_I2C_Read( 1 );
 myDS->day = Soft_I2C_Read( 1 );
 myDS->month = Soft_I2C_Read( 1 );
 myDS->year = Soft_I2C_Read( 0 );
 Soft_I2C_Stop();


 myDS->seconds = bcdToDec(0x7F&myDS->seconds);
 myDS->minutes = bcdToDec(myDS->minutes);
 myDS->hours = bcdToDec(myDS->hours);
 myDS->dayOfWeek = bcdToDec(myDS->dayOfWeek);
 myDS->day = bcdToDec(myDS->daY);
 myDS->month = bcdToDec(myDS->month);
 myDS->year = bcdToDec(myDS->year);


 DS1307_date(myDS, formatComplet);

 return myDS->time;
}

char* DS1307_date(DS1307 *myDS,  char  formatComplet){
 char cont = 0;



 numToString(myDs->dayOfWeek, &myDs->time[cont++], 1);
 if(formatComplet)
 myDS->time[cont++] = '-';

 numToString(myDs->hours, &myDs->time[cont], 2);
 cont += 2;
 if(formatComplet)
 myDS->time[cont++] = ':';

 numToString(myDs->minutes, &myDs->time[cont], 2);
 cont += 2;
 if(formatComplet)
 myDS->time[cont++] = ':';

 numToString(myDs->seconds, &myDs->time[cont], 2);
 cont += 2;
 if(formatComplet)
 myDS->time[cont++] = ' ';

 numToString(myDs->day, &myDs->time[cont], 2);
 cont += 2;
 if(formatComplet)
 myDS->time[cont++] = '/';

 numToString(myDs->month, &myDs->time[cont], 2);
 cont += 2;
 if(formatComplet)
 myDS->time[cont++] = '/';

 numToString(myDs->year, &myDs->time[cont], 2);
 cont += 2;
 myDS->time[cont] = 0;

 return myDS->time;
}

long DS1307_getSeconds(char *HHMMSS){
 char cont = 0;
 long segundos = -1;

 if(string_len(HHMMSS) == 6){
 segundos = 0;

 while(HHMMSS[cont] != 0){
 segundos *= 60;
 segundos += stringToNumN(&HHMMSS[cont], 2);
 cont += 2;
 }
 }

 return segundos;
}
#line 1 "d:/proyectos/parking/hospital sante/expendedora 4685/impresora_termica.h"
#line 1 "d:/proyectos/parking/hospital sante/expendedora 4685/miscelaneos.h"
#line 6 "d:/proyectos/parking/hospital sante/expendedora 4685/impresora_termica.h"
const char IMPT_IMPRIME[] = {10, 0};
const char IMPT_IMPRIME_CR[] = {13, 0};
const char IMPT_ESTADO[] = {16, 4, 0};

const char IMPT_PROG[] = {19, 27, 28, 29, 0};

const char IMPT_SAVE_PROG[] = {27, 18, 29, 7, 0};
const char IMPT_SAVE_DEFAULT[] = {27, 19, 29, 8, 0};
const char IMPT_ESP_CHAR[] = {27, 32, 0};
const char IMPT_MODO[] = {27, 33, 0};
const char IMPT_MODO_SUB[] = {27, 45, 0};
const char IMPT_ESP_DEFAULT[] = {27, 50, 0};
const char IMPT_ESP_PROG[] = {27, 51, 0};
const char IMPT_INIT[] = {27, 64, 0};
const char IMPT_NEGRITA[] = {27, 69, 0};
const char IMPT_REVERSO[] = {27, 73, 0};
const char IMPT_IMPRIME_XL[] = {27, 74, 0};
const char IMPT_FUENTE[] = {27, 77, 0};
const char IMPT_ROTATE[] = {27, 86, 0};
const char IMPT_JUST[] = {27, 97, 0};
const char IMPT_SPAPEL[] = {27, 99, 52, 0};
const char IMPT_BPANEL[] = {27, 99, 53, 0};
const char IMPT_IMPRIME_NL[] = {27, 100, 0};
const char IMPT_CORTE_T[] = {27, 105, 0};
const char IMPT_CORTE_P[] = {27, 109, 0};
const char IMPT_CAJON_MON[] = {27, 112, 0};
const char IMPT_FUENTE2[] = {27, 116, 0};
const char IMPT_MODO_INV[] = {27, 123, 0};
const char IMPT_SIZE_CHAR[] = {29, 33, 0};
const char IMPT_TEST[] = {29, 40, 65, 0};
const char IMPT_LOGO[] = {29, 40, 67, 0};
const char IMPT_MODO_BN[] = {29, 66, 0};
const char IMPT_COD_BAR_POS[] = {29, 72, 0};
const char IMPT_FIRMWARE[] = {29, 73, 0x33, 0};
const char IMPT_MARGEN_IZQ[] = {29, 76, 0};
const char IMPT_COD_AZTEC[] = {29, 80, 0};
const char IMPT_COD_QR[] = {29, 81, 0};
const char IMPT_CORTE_POS[] = {29, 86, 0};
const char IMPT_REPORTE[] = {29, 97, 0};
const char IMPT_COD_BAR_F[] = {29, 102, 0};
const char IMPT_COD_BAR_V[] = {29, 104, 0};
const char IMPT_COD_BAR_C[] = {29, 107, 0};
const char IMPT_COD_BAR_H[] = {29, 119, 0};




const char FONTA = 0x00;
const char FONTB = 0x01;
const char JUST_LEFT = 0;
const char JUST_CENTER = 1;
const char JUST_RIGHT = 2;
const char COD_BARRAS_POS_HIDDEN = 0;
const char COD_BARRAS_POS_ON = 1;
const char COD_BARRAS_POS_UNDER = 2;
const char COD_BARRAS_POS_BOTH = 3;

const char COD_BARRAS_NUMERICO = 69;
const char COD_BARRAS_ALPHANUM = 73;
const char CUT_POS_ACT = 49;
const char CUT_POS_OFFSET = 66;




const char CMD_IMPRESORA = 0x02;
const char CMD_CODIGO_BARRAS = 0x03;
const char CMD_WRITE_BYTE = 0x04;
const char CMD_TEXT_DINAMIC = 0x05;




static char buffer[5];






void impresoraTerm_cmd(const char *comando){
 char cont = 0;


 RomToRam(comando,buffer);
 while(buffer[cont])
 usart_write(buffer[cont++]);
}

void impresoraTerm_cmd2(const char *comando, char valor){
 char cont = 0;

 RomToRam(comando,buffer);
 while(buffer[cont])
 usart_write(buffer[cont++]);

 usart_write(valor);
}

void impresoraTerm_open( char  typeFont, char interlineado){

 impresoraTerm_cmd(IMPT_INIT);

 impresoraTerm_cmd2(IMPT_MODO, typeFont);

 impresoraTerm_cmd2(IMPT_ESP_PROG, interlineado);

 impresoraTerm_cmd2(IMPT_JUST, JUST_LEFT);

 impresoraTerm_cmd2(IMPT_SIZE_CHAR, 0x33);
}

void impresoraTerm_formato(char size, char just,  char  negrita){

 impresoraTerm_cmd2(IMPT_SIZE_CHAR, size);

 impresoraTerm_cmd2(IMPT_JUST, just);

 impresoraTerm_cmd2(IMPT_NEGRITA, negrita);
}

void impresoraTerm_writeLine(char *texto){
 char cont = 0;


 while(texto[cont])
 usart_write(texto[cont++]);

 impresoraTerm_cmd(IMPT_IMPRIME);
}

 char  impresoraTerm_writeTextStatic(const char *texto, char rateBytes){
 static unsigned int cont = 0;


 while(texto[cont] && rateBytes--){
 usart_write(texto[cont]);

 if(texto[cont] == '\n'){
 cont++;
 break;
 }
 cont++;
 }

 if(!texto[cont]){
 cont = 0;
 return  1 ;
 }

 return  0 ;
}

void impresoraTerm_writeDinamicText(char *texto, const int *address){
 char ADRR_ERROR[] = "#ERR_ADDR#";
 char cont = 0, cont2, comandos;
 char *ticketPointer;
 int dir;


 while(texto[cont]){
 if(texto[cont] == CMD_IMPRESORA){

 cont++;
 for(cont2 = 0; cont2 < 2 && texto[cont]; cont2++)
 buffer[cont2] = texto[cont++];
 buffer[cont2] = 0;


 comandos = atoi(buffer);
 while(comandos--){

 for(cont2 = 0; cont2 < 2 && texto[cont]; cont2++)
 buffer[cont2] = texto[cont++];
 buffer[cont2] = 0;
 cont2 = xtoi(buffer);
 usart_write(cont2);
 }

 if(texto[cont] == '\n')
 cont++;
 }else if(texto[cont] == CMD_CODIGO_BARRAS || texto[cont] == CMD_TEXT_DINAMIC){

 comandos = texto[cont];


 ticketPointer = ADRR_ERROR;

 cont++;
 for(cont2 = 0; cont2 < 4 && texto[cont]; cont2++)
 buffer[cont2] = texto[cont++];
 buffer[cont2] = 0;

 dir = xtoi(buffer);


 cont2 = 0;
 while(address[cont2]){
 if(dir == address[cont2++]){

  ((char*)&ticketPointer)[0]  =  ((char*)&dir)[0] ;
  ((char*)&ticketPointer)[1]  =  ((char*)&dir)[1] ;
 break;
 }
 }


 if(comandos == CMD_CODIGO_BARRAS)
 usart_write(strlen(ticketPointer));


 cont2 = 0;
 while(ticketPointer[cont2])
 usart_write(ticketPointer[cont2++]);
 }else if(texto[cont] == CMD_WRITE_BYTE){

 cont++;
 for(cont2 = 0; cont2 < 2 && texto[cont]; cont2++)
 buffer[cont2] = texto[cont++];
 buffer[cont2] = 0;


 cont2 = xtoi(buffer);
 usart_write(cont2);


 if(texto[cont])
 cont++;
 }else{

 usart_write(texto[cont++]);
 }
 }
}

void impresoraTerm_codBarNum(char *codigo, char format, char altura, char ancho){
 impresoraTerm_cmd2(IMPT_COD_BAR_POS, format);
 impresoraTerm_cmd2(IMPT_COD_BAR_V, altura);
 impresoraTerm_cmd2(IMPT_COD_BAR_H, ancho);

 impresoraTerm_cmd2(IMPT_COD_BAR_C, COD_BARRAS_NUMERICO);
 usart_write(strlen(codigo));
 usart_write_text(codigo);
}

void impresoraTerm_corte( char  cutPartial, char offset){
 impresoraTerm_cmd2(IMPT_CORTE_POS, offset? CUT_POS_OFFSET: CUT_POS_ACT);

 if(offset)
 usart_write(offset);


}
#line 1 "d:/proyectos/parking/hospital sante/expendedora 4685/table_eeprom.h"
#line 1 "d:/proyectos/parking/hospital sante/expendedora 4685/eeprom_i2c_soft.h"
#line 1 "d:/proyectos/parking/hospital sante/expendedora 4685/i2c_soft.h"
#line 10 "d:/proyectos/parking/hospital sante/expendedora 4685/i2c_soft.h"
extern sfr sbit I2C_SCL;
extern sfr sbit I2C_SCLD;
extern sfr sbit I2C_SDA;
extern sfr sbit I2C_SDAD;


void I2C_soft_init(){

 I2C_SCLD = 1;
 I2C_SDAD = 1;
}

void I2C_soft_start(){

 I2C_SDAD = 1;
 I2C_SCLD = 1;
 delay_us(2);

 I2C_SDAD = 0;
 I2C_SDA = 0;
 delay_us(2);

 I2C_SCLD = 0;
 I2C_SCL = 0;
}

void I2C_soft_stop(){
 I2C_SDAD = 0;
 I2C_SDA = 0;
 delay_us(2);
 I2C_SCLD = 1;
 delay_us(2);
 I2C_SDAD = 1;
}

 char  I2C_soft_write(char dato){
 char i;


 for(i = 0; i < 8; i++){
 I2C_SDA = dato.B7;
 I2C_SCL = 1;
 delay_us(2);
 dato <<= 1;
 I2C_SCL = 0;
 delay_us(2);
 }


 I2C_SDAD = 1;
 asm nop;
 I2C_SCL = 1;
 delay_us(2);
 i.B0 = I2C_SDA;
 I2C_SCL = 0;
 I2C_SDAD = 0;

 return i.B0;
}

char I2C_soft_read( char  ACK){
 char i, result = 0;


 I2C_SDAD = 1;

 for(i = 0; i < 8; i++){
 result <<= 1;
 I2C_SCL = 1;
 delay_us(2);

 if(I2C_SDA)
 result |= 0x01;
 I2C_SCL = 0;
 delay_us(2);
 }


 I2C_SDAD = 0;
 I2C_SDA = !ACK.B0;
 asm nop;
 I2C_SCL = 1;
 delay_us(2);
 I2C_SCL = 0;

 return result;
}
#line 6 "d:/proyectos/parking/hospital sante/expendedora 4685/eeprom_i2c_soft.h"
extern sfr sbit I2C_SCL;
extern sfr sbit I2C_SCLD;
extern sfr sbit I2C_SDA;
extern sfr sbit I2C_SDAD;






const char EEPROM_ADDRESS_24LC256 = 0xA0;



void eeprom_i2c_open(){
 I2C_soft_init();
}

void eeprom_i2c_write(unsigned int address, char *datos, char size){
 char cont = 0;

 while(cont < size){
 I2C_soft_start();

 I2C_soft_write(EEPROM_ADDRESS_24LC256);
 I2C_soft_write( ((char*)&address)[1] );
 I2C_soft_write( ((char*)&address)[0] );

 for(; cont < size; cont++){
 I2C_soft_write(datos[cont]);
 if(++address%64 == 0){
 cont++;
 break;
 }
 }
 I2C_soft_stop();

 while( 1 ){
 I2C_soft_start();
 if(!I2C_soft_write(EEPROM_ADDRESS_24LC256))
 break;
 }
 I2C_soft_stop();
 }
}

void eeprom_i2c_read(unsigned int address, char *datos, char size){
 char cont;

 I2C_soft_start();

 I2C_soft_write(EEPROM_ADDRESS_24LC256);
 I2C_soft_write( ((char*)&address)[1] );
 I2C_soft_write( ((char*)&address)[0] );
 I2C_soft_start();
 I2C_soft_write(EEPROM_ADDRESS_24LC256|0x01);

 for(cont = 0; cont < size-1; cont++)
 datos[cont] = I2C_soft_read( 1 );
 datos[cont] = I2C_soft_read( 0 );
 I2C_soft_stop();
}
#line 1 "d:/proyectos/parking/hospital sante/expendedora 4685/miscelaneos.h"
#line 34 "d:/proyectos/parking/hospital sante/expendedora 4685/table_eeprom.h"
const char TABLE_MAX_SIZE_NAME = 15;

typedef struct{
 char numTables;
 char col;
 unsigned int row;
 unsigned int rowAct;
 char tamCol;
 char nameAct[TABLE_MAX_SIZE_NAME+1];
 char nameColAct[TABLE_MAX_SIZE_NAME+1];
 unsigned int sizeMax;
 unsigned int size;
 unsigned int address;
 unsigned int addressAct;
 char cont;
}mysql;


static mysql myTable;


char _mysql_calculate_address(char *name, char *column);



void mysql_reset(){
 myTable.numTables = 0;
 myTable.size = 3;

 eeprom_i2c_write(0x0000, &myTable.numTables, 1);
 eeprom_i2c_write(0x0001,(char*)&myTable.size, 2);
}

void mysql_init(unsigned int memoryMax){

 myTable.col = 0;
 myTable.row = 0;
 myTable.rowAct = 0;
 myTable.nameAct[0] = 0;
 myTable.nameColAct[0] = 0;
 myTable.sizeMax = memoryMax;

 eeprom_i2c_open();
 eeprom_i2c_read(0x0000,&myTable.numTables, 1);
 eeprom_i2c_read(0x0001,(char*)&myTable.size, 2);
}

 char  mysql_exist(char *name){
 myTable.address = 0x0003;
 myTable.nameColAct[0] = 0;

 for(myTable.cont = 0; myTable.cont < myTable.numTables; myTable.cont++){

 eeprom_i2c_read(myTable.address, myTable.nameAct, TABLE_MAX_SIZE_NAME+1);

 if(!strncmp(name, myTable.nameAct, TABLE_MAX_SIZE_NAME+1))
 break;

 eeprom_i2c_read(myTable.address+TABLE_MAX_SIZE_NAME+1, (char*)&myTable.address, 2);
 }

 if(myTable.cont < myTable.numTables){
 myTable.addressAct = myTable.address;

 myTable.addressAct += TABLE_MAX_SIZE_NAME+3;
 eeprom_i2c_read(myTable.addressAct,(char*)&myTable.rowAct, 2);
 eeprom_i2c_read(myTable.addressAct+2,(char*)&myTable.row, 2);
 eeprom_i2c_read(myTable.addressAct+4,&myTable.col, 1);
 return  1 ;
 }else{
 myTable.nameAct[0] = 0;
 return  0 ;
 }
}

char mysql_create_new(char *name, char *columnas, int filas){
 unsigned int tam, acum = 0;
 char cad[4], i, col;
 char aux;


 if(strlen(name) > TABLE_MAX_SIZE_NAME){
 return  1 ;
 }


 if(!mysql_exist(name)){

 col = 0;
 myTable.cont = 0;
 tam = TABLE_MAX_SIZE_NAME+1;
 tam += 2;
 tam += 2;
 tam += 2;
 tam += 1;


 aux = 0;
 while(columnas[myTable.cont]){
 aux++;

 if(columnas[myTable.cont++] == '&'){

 if(aux > TABLE_MAX_SIZE_NAME+1){
 return  2 ;
 }
 aux = 0;
 tam += TABLE_MAX_SIZE_NAME+1;
 tam += 1;

 i = 0;
 while(columnas[myTable.cont] != '\n' && columnas[myTable.cont])
 cad[i++] = columnas[myTable.cont++];
 col++;
 cad[i] = 0;
 tam += filas*atoi(cad);
 }
 }


 if(myTable.size+tam < myTable.sizeMax){
 aux = 0;
 tam += myTable.size;

 eeprom_i2c_write(myTable.size, name, strlen(name)+1);
 myTable.size += TABLE_MAX_SIZE_NAME+1;

 eeprom_i2c_write(myTable.size, (char*)&tam, 2);
 myTable.size += 2;

 myTable.rowAct = 0;
 eeprom_i2c_write(myTable.size, (char*)&myTable.rowAct, 2);
 myTable.size += 2;

 eeprom_i2c_write(myTable.size, (char*)&filas, 2);
 myTable.size += 2;

 eeprom_i2c_write(myTable.size, &col, 1);
 myTable.size += 1;

 myTable.cont = 0;
 tam = myTable.size;

 while(columnas[myTable.cont]){

 eeprom_i2c_write(tam++, &columnas[myTable.cont++], 1);

 if(columnas[myTable.cont] == '&'){
 myTable.cont++;
 eeprom_i2c_write(tam++, &aux, 1);
 myTable.size += TABLE_MAX_SIZE_NAME+1;

 i = 0;
 while(columnas[myTable.cont]){
 cad[i++] = columnas[myTable.cont++];
 if(columnas[myTable.cont] == '\n'){
 myTable.cont++;
 break;
 }
 }
 cad[i] = 0;
 col = atoi(cad);
 eeprom_i2c_write(myTable.size, &col, 1);
 myTable.size += 1;
 acum += col*filas;

 tam = myTable.size;
 }
 }
 myTable.size += acum;
 myTable.numTables++;
 eeprom_i2c_write(0x0000, &myTable.numTables, 1);
 eeprom_i2c_write(0x0001,(char*)&myTable.size, 2);

 }else{
 return  3 ;
 }
 }else{
 return  4 ;
 }

 return  0 ;
}

char mysql_read_string(char *name, char *column, int fila, char *result){
 char res = _mysql_calculate_address(name, column);


 if(res)
 return res;


 if(fila >= 1 && fila <= myTable.rowAct)
 eeprom_i2c_read(myTable.addressAct+(fila-1)*myTable.tamCol, result, myTable.tamCol);
 else{
 return  3 ;
 }

 return  0 ;
}

char mysql_read(char *name, char *column, int fila, long *result){
 char res = _mysql_calculate_address(name, column);


 if(res)
 return res;


 *result = 0;


 if(fila >= 1 && fila <= myTable.rowAct){
 if(myTable.tamCol <= 4)
 eeprom_i2c_read(myTable.addressAct+(fila-1)*myTable.tamCol, (char*)&(*result), myTable.tamCol);
 else{
 return  6 ;
 }
 }else{
 return  3 ;
 }

 return  0 ;
}

char mysql_read_forced(char *name, char *column, int fila, char *result){
 char res = _mysql_calculate_address(name, column);


 if(res)
 return res;


 if(fila >= 1 && fila <= myTable.row)
 eeprom_i2c_read(myTable.addressAct+(fila-1)*myTable.tamCol, result, myTable.tamCol);
 else
 return  3 ;

 return  0 ;
}

char mysql_write_string(char *name, char *column, int fila, char *texto,  char  endWrite){
 char res = _mysql_calculate_address(name, column);


 if(res)
 return res;


 myTable.cont = strlen(texto)+1;

 if(myTable.cont > myTable.tamCol){
 return  4 ;
 }

 if(endWrite){
 if(myTable.rowAct < myTable.row){
 eeprom_i2c_write(myTable.addressAct+myTable.rowAct*myTable.tamCol, texto, myTable.cont);
 myTable.rowAct++;
 eeprom_i2c_write(myTable.address+TABLE_MAX_SIZE_NAME+3, (char*)&myTable.rowAct, 2);
 }else{
 return  5 ;
 }
 }else if(fila >= 1 && fila <= myTable.rowAct)
 eeprom_i2c_write(myTable.addressAct+(fila-1)*myTable.tamCol, texto, myTable.cont);
 else{
 return  3 ;
 }

 return  0 ;
}

char mysql_write(char *name, char *column, int fila, long value,  char  endWrite){
 char res = _mysql_calculate_address(name, column);


 if(res)
 return res;


 myTable.cont = myTable.tamCol;
 if(myTable.cont > 4){
 return  6 ;
 }

 if(endWrite){
 if(myTable.rowAct < myTable.row){
 eeprom_i2c_write(myTable.addressAct+myTable.rowAct*myTable.tamCol, (char*)&value, myTable.cont);
 myTable.rowAct++;
 eeprom_i2c_write(myTable.address+TABLE_MAX_SIZE_NAME+3, (char*)&myTable.rowAct, 2);
 }else
 return  5 ;
 }else if(fila >= 1 && fila <= myTable.rowAct)
 eeprom_i2c_write(myTable.addressAct+(fila-1)*myTable.tamCol, (char*)&value, myTable.cont);
 else
 return  3 ;

 return  0 ;
}

char mysql_write_forced(char *name, char *column, int fila, char *texto, char bytes){
 char res = _mysql_calculate_address(name, column);


 if(res)
 return res;


 if(bytes > myTable.tamCol)
 return  4 ;


 if(fila >= 1 && fila <= myTable.row)
 eeprom_i2c_write(myTable.addressAct+(fila-1)*myTable.tamCol, texto, bytes);
 else
 return  3 ;

 return  0 ;
}

char mysql_write_roundTrip(char *name, char *column, char *texto, char bytes){
 char res = _mysql_calculate_address(name, column);


 if(res)
 return res;


 if(bytes > myTable.tamCol)
 return  4 ;


 myTable.rowAct = clamp_shift(++myTable.rowAct, 1, myTable.row);
 eeprom_i2c_write(myTable.address+TABLE_MAX_SIZE_NAME+3, (char*)&myTable.rowAct, 2);
 eeprom_i2c_write(myTable.addressAct+(myTable.rowAct-1)*myTable.tamCol, texto, bytes);

 return  0 ;
}

 char  mysql_erase(char *name){

 if(!mysql_exist(name))
 return  0 ;


 myTable.rowAct = 0;
 eeprom_i2c_write(myTable.address+TABLE_MAX_SIZE_NAME+3, (char*)&myTable.rowAct, 2);
 return  1 ;
}

char mysql_search(char *tabla, char *columna, long buscar, int *fila){
 long busqueda;


 if(mysql_exist(tabla)){
 for(*fila = 1; *fila <= myTable.rowAct; (*fila)++){

 if(!mysql_read(tabla, columna, *fila, &busqueda)){
 if(buscar == busqueda)
 return  0 ;
 }
 }
 return  3 ;
 }

 return  1 ;
}

char mysql_search_forced(char *tabla, char *columna, long buscar, int *fila){
 long busqueda;


 if(mysql_exist(tabla)){
 for(*fila = 1; *fila <= myTable.row; (*fila)++){

 if(!mysql_read(tabla, columna, *fila, &busqueda)){
 if(buscar == busqueda)
 return  0 ;
 }
 }
 return  3 ;
 }

 return  1 ;
}

int mysql_count(char *tabla, char *columna, long buscar){
 int coincidencias = 0;
 long busqueda;


 if(mysql_exist(tabla)){
 for(myTable.cont = 1; myTable.cont <= myTable.rowAct; myTable.cont++){

 if(!mysql_read(tabla, columna, myTable.cont, &busqueda)){
 if(buscar == busqueda)
 coincidencias++;
 }
 }
 }

 return coincidencias;
}

int mysql_count_forced(char *tabla, char *columna, long buscar){
 int coincidencias = 0;
 long busqueda = 0;


 if(mysql_exist(tabla)){
 for(myTable.cont = 1; myTable.cont <= myTable.row; myTable.cont++){

 if(!mysql_read_forced(tabla, columna, myTable.cont, (char*)&busqueda)){
 if(buscar == busqueda)
 coincidencias++;
 }
 }
 }

 return coincidencias;
}



char _mysql_calculate_address(char *name, char *column){
 unsigned int addressAux = 0;


 if(strncmp(name, myTable.nameAct, TABLE_MAX_SIZE_NAME+1)){
 if(!mysql_exist(name)){
 return  1 ;
 }
 }

 if(strncmp(column, myTable.nameColAct, TABLE_MAX_SIZE_NAME+1)){
 myTable.addressAct = myTable.address;

 myTable.addressAct += TABLE_MAX_SIZE_NAME+3;
 eeprom_i2c_read(myTable.addressAct,(char*)&myTable.rowAct, 2);
 eeprom_i2c_read(myTable.addressAct+2,(char*)&myTable.row, 2);
 eeprom_i2c_read(myTable.addressAct+4,&myTable.col, 1);

 myTable.addressAct += (4+1);
 addressAux = myTable.addressAct;
 addressAux += myTable.col*(TABLE_MAX_SIZE_NAME+1+1);


 for(myTable.cont = 0; myTable.cont < myTable.col; myTable.cont++){

 eeprom_i2c_read(myTable.addressAct, myTable.nameColAct, TABLE_MAX_SIZE_NAME+1);

 myTable.addressAct += TABLE_MAX_SIZE_NAME+1;
 eeprom_i2c_read(myTable.addressAct, &myTable.tamCol, 1);
 myTable.addressAct += 1;

 if(!strncmp(column, myTable.nameColAct, TABLE_MAX_SIZE_NAME+1))
 break;

 addressAux += myTable.tamCol*myTable.row;

 }

 if(myTable.cont >= myTable.col){
 myTable.nameColAct[0] = 0;
 return  2 ;
 }
 myTable.addressAct = addressAux;
 }

 return  0 ;
}
#line 1 "d:/proyectos/parking/hospital sante/expendedora 4685/wiegand26.h"
#line 1 "d:/proyectos/parking/hospital sante/expendedora 4685/lib_external_int0.h"




void int_external_int0();


void external_int0_open( char  enable,  char  edgeOnRising){
 INTCON.INT0IF = 0;
 INTCON2.INTEDG0 = edgeOnRising.B0;
 INTCON.INT0IE = enable.B0;
}

void external_int0_enable( char  enable){
 INTCON.INT0IE = enable.B0;
}

void external_int0_edge( char  onRising){
 INTCON2.INTEDG0 = onRising.B0;
}
#line 1 "d:/proyectos/parking/hospital sante/expendedora 4685/lib_external_int1.h"




void int_external_int1();


void external_int1_open( char  enable,  char  edgeOnRising,  char  priorityHigh){
 INTCON3.INT1IF = 0;
 INTCON2.INTEDG1 = edgeOnRising.B0;
 INTCON3.INT1IP = priorityHigh.B0;
 INTCON3.INT1IE = enable.B0;
}

void external_int1_enable( char  enable){
 INTCON3.INT1IE = enable.B0;
}

void external_int1_edge( char  onRising){
 INTCON2.INTEDG1 = onRising.B0;
}

void external_int1_priority( char  high){
 INTCON3.INT1IP = high.B0;
}
#line 1 "d:/proyectos/parking/hospital sante/expendedora 4685/lib_timer2.h"
#line 36 "d:/proyectos/parking/hospital sante/expendedora 4685/wiegand26.h"
const unsigned int WIEGAND_TIME_FRAME_RESET = 5000;
const unsigned int WIEGAND_TIME_FRAME_DELTA = 4500;
const char WIEGAND_BITS_CARD = 26;
const char WIEGAND_BITS_NIP = 32;
const char _WIEGAND26_PULSE_TIME_MAX_MS = 5;


static unsigned long WIEGAN26_DATA;
static unsigned long WIEGAN26_BUFFER;
static char WIEGAN26_CONT;
volatile unsigned int WIEGAND_TEMP;


 char  wiegand26_checkTouch(char bytes);

void wiegand26_open(){
 external_int0_open( 0 ,  0 );
 external_int1_open( 0 ,  0 ,  1 );
 WIEGAN26_DATA = 0;
 WIEGAN26_CONT = 0;
 WIEGAND_TEMP = 0;

 timer2_open(5000,  1 ,  1 ,  0 );
}

 char  wiegand26_read_card(long *id){
 char i, paridad;
 long aux;

 if(WIEGAN26_CONT == 26){
 delay_ms(_WIEGAND26_PULSE_TIME_MAX_MS);

 if(WIEGAN26_CONT != 26)
 return  0 ;

 WIEGAN26_BUFFER = WIEGAN26_DATA;
 aux = WIEGAN26_BUFFER;

 WIEGAN26_CONT = 0;
 WIEGAN26_DATA = 0;

 for(paridad = 0, i = 0; i < 13; i++){
 paridad +=  ((char*)&aux)[0] .B0;
 aux >>= 1;
 }

 if(paridad % 2 != 1)
 return  0 ;

 for(paridad = 0, i = 0; i < 13; i++){
 paridad +=  ((char*)&aux)[0] .B0;
 aux >>= 1;
 }

 if(paridad % 2 != 0)
 return  0 ;

 *id = WIEGAN26_BUFFER;
 *id >>= 1;
  ((char*)&*id)[3]  = 0x00;
 return  1 ;
 }

 return  0 ;
}

 char  wiegand26_read_nip(int *nip){
 short i;

 if(WIEGAN26_CONT == 32){
 delay_ms(_WIEGAND26_PULSE_TIME_MAX_MS);

 if(WIEGAN26_CONT != 32)
 return  0 ;


 WIEGAN26_BUFFER = WIEGAN26_DATA;

 WIEGAN26_CONT = 0;
 WIEGAN26_DATA = 0;


 if(!wiegand26_checkTouch(4))
 return  0 ;

 for(i = 0; i < 4; i++){
  ((char*)&WIEGAN26_BUFFER)[i]  &= 0x0F;
 if( ((char*)&WIEGAN26_BUFFER)[i]  == 0x0A ||  ((char*)&WIEGAN26_BUFFER)[i]  == 0x0B)
 return  0 ;
 }

 *nip = 0;
 for(i = 3; i >= 0; i--){
 *nip *= 10;
 *nip +=  ((char*)&WIEGAN26_BUFFER)[i] ;
 }
 return  1 ;
 }

 return  0 ;
}

void wiegand26_enable(){
 external_int0_enable( 1 );
 external_int1_enable( 1 );
}

 char  wiegand26_checkTouch(char bytes){
 char i;
 volatile char nibleH, nibleL;


 for(i = 0; i < bytes; i++){
 nibleL = ~ ((char*)&WIEGAN26_BUFFER)[i] ;
 nibleL &= 0x0F;
 nibleH = swap( ((char*)&WIEGAN26_BUFFER)[i] );
 nibleH &= 0x0F;

 if(nibleH != nibleL)
 break;
 }


 if(i == bytes)
 return  1 ;
 else
 return  0 ;
}

void int_wiegand26(){
 int_external_int0();
 int_external_int1();
}

void int_external_int0(){
 if(INTCON.INT0IF && INTCON.INT0IE){
 WIEGAN26_CONT++;
 WIEGAN26_DATA <<= 1;
 WIEGAN26_DATA |= 0;

 WIEGAND_TEMP = 0;
 if(WIEGAN26_CONT > WIEGAND_BITS_NIP)
 WIEGAND_TEMP = WIEGAND_TIME_FRAME_DELTA;
 INTCON.INT0IF = 0;
 }
}

void int_external_int1(){
 if(INTCON3.INT1IF && INTCON3.INT1IE){
 WIEGAN26_CONT++;
 WIEGAN26_DATA <<= 1;
 WIEGAN26_DATA |= 1;

 WIEGAND_TEMP = 0;
 if(WIEGAN26_CONT > WIEGAND_BITS_NIP)
 WIEGAND_TEMP = WIEGAND_TIME_FRAME_DELTA;
 INTCON3.INT1IF = 0;
 }
}

void int_timer2(){
 if(PIR1.TMR2IF && PIE1.TMR2IE){

 WIEGAND_TEMP += 5;
 if(WIEGAND_TEMP >= WIEGAND_TIME_FRAME_RESET){
 WIEGAND_TEMP = 0;

 if(WIEGAN26_CONT){
 if(!(WIEGAN26_CONT == WIEGAND_BITS_CARD || WIEGAN26_CONT == WIEGAND_BITS_NIP)){
 WIEGAN26_CONT = 0;
 WIEGAN26_DATA = 0;
 }
 }
 }

 PIR1.TMR2IF = 0;
 }
}
#line 1 "d:/proyectos/parking/hospital sante/expendedora 4685/_lib_cryptography.h"




void encrypt_basic(char *cadena){
 char cont = 0;

 while(cadena[cont]){
 if(cadena[cont] == '0')
 cadena[cont] = '2';
 else if(cadena[cont] == '1')
 cadena[cont] = '0';
 else if(cadena[cont] == '2')
 cadena[cont] = '8';
 else if(cadena[cont] == '3')
 cadena[cont] = '9';
 else if(cadena[cont] == '4')
 cadena[cont] = '7';
 else if(cadena[cont] == '5')
 cadena[cont] = '6';
 else if(cadena[cont] == '6')
 cadena[cont] = '4';
 else if(cadena[cont] == '7')
 cadena[cont] = '5';
 else if(cadena[cont] == '8')
 cadena[cont] = '3';
 else if(cadena[cont] == '9')
 cadena[cont] = '1';
 cont++;
 }
}

void decrypt_basic(char *cadena){
 char cont = 0;

 while(cadena[cont]){
 if(cadena[cont] == '0')
 cadena[cont] = '1';
 else if(cadena[cont] == '1')
 cadena[cont] = '9';
 else if(cadena[cont] == '2')
 cadena[cont] = '0';
 else if(cadena[cont] == '3')
 cadena[cont] = '8';
 else if(cadena[cont] == '4')
 cadena[cont] = '6';
 else if(cadena[cont] == '5')
 cadena[cont] = '7';
 else if(cadena[cont] == '6')
 cadena[cont] = '5';
 else if(cadena[cont] == '7')
 cadena[cont] = '4';
 else if(cadena[cont] == '8')
 cadena[cont] = '2';
 else if(cadena[cont] == '9')
 cadena[cont] = '3';
 cont++;
 }
}
#line 1 "d:/proyectos/parking/hospital sante/expendedora 4685/ticket.h"
#line 25 "d:/proyectos/parking/hospital sante/expendedora 4685/ticket.h"
const char ticket[] = {

 "\x02141B401B21011B33141B61001D2133\n"





 "\x02091D21331B61011B4501\n"
 "FOLIO:\x050114\n"

 "\x02091D21111B61011B4501\n\n"



 "ESTACIONAMIENTO HES\n"



 "\x02091D21001B61011B4500\n\n"

 "AVE. DEMOCRACIA 162,"
 "SEGUNDA SECC, 90780\n"
 "XICOHTZINCO, TLAX.\n\n"


 "\x02091D21111B61011B4501\n\n"

 "\x050100\n"

 "\x02091D21001B61011B4500\n\n"

 "\x02151D66011D48021D68641D77011D6B45\n"
 "\x03011F\n"
 "\n"

 "TARIFA: $10.00 PRIMERA HORA O FRACCION\n"
 "DESPUES DE PRIMERA HORA $5.00 SUBSECUENTES\n\n"
 "TOLERANCIA 15 MIN\n\n"
 "PRECIO DE BOLETO PERDIDO $150.00\n\n"
 "LA EMPRESA  NO  SE HACE RESPONSABLE POR OBJETOS\n"
 "DEJADOS  EN  SU INTERIOR, ASI COMO AUTOPARTES Y\n"
 "NINGUN  TIPO  DE  DANO  REALIZADO POR TERCEROS,\n"
 "AL SER  UN  ESTACIONAMIENTO  DE  AUTOSERVICIO. \n\n"




 "WWW.ACCESA.ME, AUTOMATIZACION DE\n"
 "ESTACIONAMIENTOS\n\n"



 "\x02081D286B0300314308\n"

 "\x02081D286B1A00315030\n"
 "\x05011F"

 "\x02081D286B0300315130\n"


 "\x02041D56421E\n"

};
#line 33 "D:/PROYECTOS/PARKING/HOSPITAL SANTE/Expendedora 4685/Expendedora.c"
sfr sbit BOTON_ENTRADA1 at PORTD.B4;
sfr sbit BOTON_ENTRADA1D at TRISD.B4;
sfr sbit SENSOR_COCHE at PORTD.B0;
sfr sbit SENSOR_COCHED at TRISD.B0;
sfr sbit BOTON_IMPRIMIR at PORTD.B1;
sfr sbit BOTON_IMPRIMIRD at TRISD.B1;

sfr sbit LED_LINK at PORTC.B2;
sfr sbit LED_LINKD at TRISC.B2;
sfr sbit SALIDA_RELE1 at PORTA.B5;
sfr sbit SALIDA_RELE1D at TRISA.B5;
sfr sbit SALIDA_RELE2 at PORTE.B0;
sfr sbit SALIDA_RELE2D at TRISE.B0;
sfr sbit SALIDA_RELE3 at PORTD.B2;
sfr sbit SALIDA_RELE3D at TRISD.B2;
sfr sbit SALIDA_RELE4 at PORTD.B3;
sfr sbit SALIDA_RELE4D at TRISD.B3;
sfr sbit SALIDA_RELE5 at PORTD.B7;
sfr sbit SALIDA_RELE5D at TRISD.B7;

sfr sbit DS1307_SCL at PORTE.B1;
sfr sbit DS1307_SCLD at TRISE.B1;
sfr sbit DS1307_SDA at PORTD.B6;
sfr sbit DS1307_SDAD at TRISD.B6;

sfr sbit I2C_SCL at PORTB.B4;
sfr sbit I2C_SCLD at TRISB.B4;
sfr sbit I2C_SDA at PORTB.B5;
sfr sbit I2C_SDAD at TRISB.B5;

sbit LCD_RS at PORTE.B2;
sbit LCD_RS_Direction at TRISE.B2;
sbit LCD_EN at PORTA.B3;
sbit LCD_EN_Direction at TRISA.B3;
sbit LCD_D4 at PORTA.B4;
sbit LCD_D4_Direction at TRISA.B4;
sbit LCD_D5 at PORTA.B2;
sbit LCD_D5_Direction at TRISA.B2;
sbit LCD_D6 at PORTA.B1;
sbit LCD_D6_Direction at TRISA.B1;
sbit LCD_D7 at PORTA.B0;
sbit LCD_D7_Direction at TRISA.B0;

sfr sbit Net_Ethernet_28j60_Rst at PORTC.B0;
sfr sbit Net_Ethernet_28j60_CS at PORTC.B1;
sfr sbit Net_Ethernet_28j60_Rst_Direction at TRISC.B0;
sfr sbit Net_Ethernet_28j60_CS_Direction at TRISC.B1;
sfr sbit SPI_CS at PORTC.B1;
sfr sbit SPI_CSD at TRISC.B1;






const int timeAwake = 300;

const long baudiosRate = 38400;


const char CAN_COCHE_IN[] = "CARI";
const char CAN_COCHE_OUT[] = "CARO";

const char CAN_PENSIONADO[] = "PEN";
const char CAN_REGISTRAR[] = "REG";
const char CAN_ACTUALIZAR[] = "ACT";
const char CAN_CONSULTAR[] = "CON";
const char CAN_VIGENCIA[] = "VIG";
const char CAN_PASSBACK[] = "PAS";
const char CAN_PREPAGO[] = "PRE";
const char CAN_SALDO[] = "SLD";
const char CAN_SPECIAL_DATE[] = "SPD";
const char CAN_SPECIAL_SALDO[] = "SPS";
const char CAN_SOPORTE[] = "SOP";

const char CAN_RTC[] = "RTC";

const char CAN_TABLE[] = "TBL";
const char CAN_TABLE_INFO[] = "INF";
const char CAN_TABLE_ERASE[] = "ERS";
const char CAN_TABLE_RW[] = "TRW";
const char CAN_TABLE_READ[] = "TBR";
const char CAN_TABLE_WRITE[] = "TBW";
const char CAN_TABLE_GET[] = "GET";
const char CAN_TABLE_SET[] = "SET";

const char CAN_TABLE_ERROR[] = "ERROR";
const char CAN_TABLE_MODIFICADO[] = "MODIFICADO";
const char CAN_TABLE_NO_FOUND[] = "NO FOUND";

const char CAN_TPV[] = "TPV";
const char CAN_IDX[] = "IDX";
const char CAN_FOL[] = "FOL";
const char CAN_NIP[] = "NIP";
const char CAN_TBL[] = "TBL";

const char CAN_MODULE[] = "E";

const char CAN_CMD[] = "CMD";
const char CAN_KEY[] = "KEY";
const char CAN_CUPO[] = "CUP";
const char CAN_ABRIR[] = "OPN";
const char CAN_OUT[] = "OUT";

char tablePensionados[] = "Pensionados";
char pensionadosID[] = "id";
char pensionadosEstatus[] = "estatus";
char pensionadosVigencia[] = "vigencia";

char tablePrepago[] = "Prepago";
char prepagoNip[] = "nip";
char prepagoId[] = "id";
char prepagoEstatus[] = "estatus";
char prepagoDate[] = "date";
char prepagoSaldo[] = "saldo";

char tableSoporte[] = "Soporte";
char soporteID[] = "id";

char tableFolio[] = "Folio";
char folioTotal[] = "total";
long folio;

char tableTicketTPV[] = "TicketTPV";
char tableTicketEXP[] = "TicketEXP";
const int ticketAddr[] = {0x0100, 0x0114, 0x011F, 0x013D, 0};
char ticketTime[20] absolute ticketAddr[0];
char ticketFolio[11] absolute ticketAddr[1];
char ticketCodigo[30] absolute ticketAddr[2];
char ticketCodigo2[30] absolute ticketAddr[3];

char tableEventosTCP[] = "EventosTCP";
char tableEventosCAN[] = "EventosCAN";
char eventosRegistro[] = "registro";
char eventosEstatus[] = "estatus";

char tableKeyOutNip[] = "KeyNip";
char tableKeyOutDate[] = "KeyDate";
char tableKeyOutFol[] = "KeyFolios";
char keyOutNip[] = "nip";
char keyOutFol[] = "folio";
char keyOutDate[] = "date";
char keyOutEstatus[] = "estatus";

const int TOLERANCIA_OUT = 15*60 + 10;

char tableToleranciaOut[] = "timeTolerancia";
char tableToleranciaMax[] = "tolerancia";
unsigned int toleranciaOut;

char tableSyncronia[] = "Sincronia";
char tableCupo[] = "Cupo";
char columnaEstado[] = "estado";




 char  flagTMR3 =  0 ;
 char  flagSecondTMR3 =  0 ;


const char canIdTPV = 0;
char canId = 1;
long canIp = 0x1E549500;
long canMask = 0xFFFFFFFF;
char canCommand[64];


const unsigned int TIME_HEARTBEAT = 1*5;
unsigned int temp_heartbeat = 0;


DS1307 myRTC;


 char  modeBufferEventos =  0 ;
int pilaBufferCAN;
int pilaBufferPointer;
char bufferEeprom[64];


char msjConst[20];
 char  canSynchrony;
 char  cupoLleno;
 char  abrirBarrera =  0 ;


const char timeSensor = 1;
char tempSensor;






void lcd_clean_row(char fila);
void buffer_save_send( char  guardar, char *buffer);
void can_heartbeat();

void pic_init();
void expendedora_checkTarjeta();
 char  expendedora_ticket();
void expendedora_imprimir();
void expendedora_bufferEventos();
void expendedora_temporizadores();
void expendedora_barrera();



 char  limpiarLCD =  0 ;
char tempLCD = 0;
long tam;






void main(){

 pic_init();

 while( 1 ){
 can_do_work();
 expendedora_checkTarjeta();
 expendedora_imprimir();
 expendedora_bufferEventos();
 expendedora_temporizadores();
 expendedora_barrera();
 }
}

void interrupt(){
 int_wiegand26();

}

void interrupt_low(){
 int_timer1();
 int_timer2();
 int_timer3();

 int_can();
}



void pic_init(){

 OSCCON = 0x40;


 ADCON1 = 0x0F;
 CMCON = 0x07;


 SENSOR_COCHED = 1;
 BOTON_IMPRIMIRD = 1;
 BOTON_ENTRADA1D = 1;
 LED_LINKD = 0;
 SALIDA_RELE1D = 0;
 SALIDA_RELE2D = 0;
 SALIDA_RELE3D = 0;
 SALIDA_RELE4D = 0;
 SALIDA_RELE5D = 0;

 SALIDA_RELE1 = 0;
 SALIDA_RELE2 = 0;
 SALIDA_RELE3 = 0;
 SALIDA_RELE4 = 0;
 SALIDA_RELE5 = 0;
 LED_LINK = 0;


 canId = eeprom_read(0);


 timer1_open(200e3,  1 ,  0 ,  0 );
 timer3_open(200e3,  1 ,  1 ,  0 );
 usart_open(baudiosRate);



 DS1307_open();
 lcd_init();
 lcd_cmd(_LCD_CURSOR_OFF);
 lcd_cmd(_LCD_CLEAR);
 mysql_init(32768);
 wiegand26_open();
 can_open(canIp, canMask, canId, 4);
 can_interrupt( 1 ,  0 );


 lcd_clean_row(1);
 lcd_out(1, 1, "Inicializando...");
#line 331 "D:/PROYECTOS/PARKING/HOSPITAL SANTE/Expendedora 4685/Expendedora.c"
 wiegand26_enable();
 DS1307_Read(&myRTC,  1 );

 pilaBufferCAN = mysql_count_forced(tableEventosCAN, eventosEstatus, '1');
#line 341 "D:/PROYECTOS/PARKING/HOSPITAL SANTE/Expendedora 4685/Expendedora.c"
 mysql_read(tableFolio, folioTotal, 1, &folio);
 mysql_read_string(tableCupo, columnaEstado, 1, &cupoLleno);
 mysql_read_string(tableSyncronia, columnaEstado, 1, &canSynchrony);


 RCON.IPEN = 1;
 INTCON.PEIE = 1;
 INTCON.GIE = 1;
#line 460 "D:/PROYECTOS/PARKING/HOSPITAL SANTE/Expendedora 4685/Expendedora.c"
 delay_ms(timeAwake);
#line 464 "D:/PROYECTOS/PARKING/HOSPITAL SANTE/Expendedora 4685/Expendedora.c"
 lcd_clean_row(1);

 lcd_out(1, 5, "Expendedora");
}

void expendedora_barrera(){
 static  char  sensor =  0 ;
 const char CAN_BAR[] = "BAR";
 const char BARRERA_ABIERTA[] = "OPEN";

 if(BOTON_ENTRADA1 && !sensor.B0){
 sensor.B0 =  1 ;

 string_cpyc(bufferEeprom, CAN_TPV);
 string_addc(bufferEeprom, CAN_BAR);
 string_addc(bufferEeprom, BARRERA_ABIERTA);
 DS1307_read(&myRTC,  0 );
 string_add(bufferEeprom, &myRTC.time[1]);

 string_addc(bufferEeprom, CAN_MODULE);
 numToHex(canId, msjConst, 1);
 string_add(bufferEeprom, msjConst);
 buffer_save_send( 0 , bufferEeprom);
#line 490 "D:/PROYECTOS/PARKING/HOSPITAL SANTE/Expendedora 4685/Expendedora.c"
 delay_ms(50);
 }else if(!BOTON_ENTRADA1 && sensor){
 sensor.B0 =  0 ;
 delay_ms(50);
 }
}

void expendedora_temporizadores(){
 static char isCanConect = -1;

 if(flagSecondTMR3){
 flagSecondTMR3 =  0 ;
 can_heartbeat();
 tempSensor++;


 if(isCanConect != can.conected){
#line 511 "D:/PROYECTOS/PARKING/HOSPITAL SANTE/Expendedora 4685/Expendedora.c"
 isCanConect = can.conected;
 }

 DS1307_Read(&myRTC, 1 );
 string_cpyn(msjConst, &myRTC.time[2], 8);
 lcd_out(4, 2, msjConst);
 string_cpyn(msjConst, &myRTC.time[11], 8);
 lcd_out(4, 12, msjConst);

 if(limpiarLCD){
 if(++tempLCD >= 5){
 limpiarLCD =  0 ;
 tempLCD = 0;
 lcd_clean_row(1);
 lcd_clean_row(2);
 lcd_clean_row(3);
 lcd_clean_row(4);
 lcd_out(1, 5, "Expendedora");

 if(BOTON_ENTRADA1)
 lcd_chr(1,18,'B');
 if(SENSOR_COCHE)
 lcd_chr(1,20,'C');
 }
 }
 }
}

void expendedora_checkTarjeta(){

 const char ACCESO_DENEGADO[] = "NNNN";
 const char VIGENTE = 'V';
 const char ESTATUS_PAS = CAN_MODULE[0] == 'E'? 'O':'I';
 const char ESTATUS_MOD = CAN_MODULE[0] == 'E'? 'I':'O';
 const char ESTATUS_BREAK = '-';
 const char ESTATUS_NOT = 'N';

 const char TPV_NO_VIGENCIA = 'V';
 const char TPV_PASSBACK = 'P';
 const char TPV_ACCESO = 'A';
 const char TPV_DESCONOCIDO = 'D';
 const char TPV_SIN_SALDO = 'S';
 const char TPV_OUT_TIME = 'T';

 static  char  buscarID =  0 , buscarNIP =  0 ;
 static int fila;
 static int nip;
 static long id;
 char vigencia, estatus;
 char acceso[5];
 long saldo;

 long seconds;
 char fecha[13];
  char  isOtherToday;


 if(wiegand26_read_card(&id)){
 limpiarLCD =  1 ;
 tempLCD = 0;
 if(!buscarID && !buscarNIP)
 buscarID =  1 ;
 lcd_clean_row(1);
 lcd_out(1, 1, "CARD: ");
 longtostr(id, msjConst);
 lcd_out(1, sizeof("CARD: "), msjConst);
#line 582 "D:/PROYECTOS/PARKING/HOSPITAL SANTE/Expendedora 4685/Expendedora.c"
 }else if(wiegand26_read_nip(&nip)){
 limpiarLCD =  1 ;
 tempLCD = 0;
 if(!buscarID && !buscarNIP)
 buscarNIP =  1 ;
 lcd_clean_row(1);
 lcd_out(1, 1, " NIP: ");
 numToString(nip, msjConst, 4);

 lcd_out(1, sizeof(" NIP: "), msjConst);
#line 597 "D:/PROYECTOS/PARKING/HOSPITAL SANTE/Expendedora 4685/Expendedora.c"
 }


 if(buscarID){
 if(!mysql_search(tableSoporte, soporteID, id, &fila)){
#line 610 "D:/PROYECTOS/PARKING/HOSPITAL SANTE/Expendedora 4685/Expendedora.c"
 lcd_clean_row(3);
 lcd_out(3,1,"Tarjeta bloqueada");
 buscarID =  0 ;
#line 627 "D:/PROYECTOS/PARKING/HOSPITAL SANTE/Expendedora 4685/Expendedora.c"
 }
 }


 if(!SENSOR_COCHE){
 if(buscarNIP || buscarID){
 buscarNIP =  0 ;
 buscarID =  0 ;
 lcd_clean_row(3);
 lcd_out(3,1,"No se detecta auto");
 }
 }


 if(buscarID){
 buscarID =  0 ;

 DS1307_read(&myRTC,  0 );

 string_cpyc(canCommand, CAN_TPV);
 string_addc(canCommand, CAN_IDX);
 numToHex(id, msjConst, 3);
 string_add(canCommand, msjConst);
 string_add(canCommand, &myRTC.time[1]);

 string_cpyc(acceso, ACCESO_DENEGADO);


 if(!mysql_search(tablePensionados, pensionadosID, id, &fila)){

 canCommand[3] = CAN_PENSIONADO[0];
 canCommand[4] = CAN_PENSIONADO[1];
 canCommand[5] = CAN_PENSIONADO[2];

 mysql_read_string(tablePensionados, pensionadosVigencia, fila, &vigencia);
 mysql_read_string(tablePensionados, pensionadosEstatus, fila, &estatus);






 if(vigencia == VIGENTE && (estatus == ESTATUS_PAS || estatus == ESTATUS_BREAK || !canSynchrony || !can.conected)){

 abrirBarrera =  1 ;
 SALIDA_RELE1 = 1;
 SALIDA_RELE2 = 1;
 timer1_reset();
 timer1_enable( 1 );
 acceso[0] = TPV_ACCESO;

 if(!can.conected || !canSynchrony || estatus == ESTATUS_BREAK)
 acceso[2] = ESTATUS_BREAK;

 estatus = (!can.conected || !canSynchrony)? ESTATUS_BREAK:ESTATUS_MOD;
 mysql_write(tablePensionados, pensionadosEstatus, fila, estatus,  0 );
 lcd_clean_row(2);
 lcd_out(2, 1, "Acceso aceptado");
#line 690 "D:/PROYECTOS/PARKING/HOSPITAL SANTE/Expendedora 4685/Expendedora.c"
 }else{
 if(vigencia == ESTATUS_NOT){
 acceso[1] = TPV_NO_VIGENCIA;
 lcd_clean_row(2);
 lcd_out(2, 1, "Vigencia terminada");
#line 698 "D:/PROYECTOS/PARKING/HOSPITAL SANTE/Expendedora 4685/Expendedora.c"
 }else if(estatus == ESTATUS_MOD){
 acceso[2] = TPV_PASSBACK;
 lcd_clean_row(2);
 lcd_out(2,1,"Passback activo");
#line 705 "D:/PROYECTOS/PARKING/HOSPITAL SANTE/Expendedora 4685/Expendedora.c"
 }
 }

 string_add(canCommand, acceso);

 string_cpyc(bufferEeprom, CAN_PENSIONADO);
 numTohex(id, msjConst, 3);
 string_add(bufferEeprom, msjConst);
 string_addc(bufferEeprom, CAN_PASSBACK);
 numToString(fila, msjConst, 4);
 string_add(bufferEeprom, msjConst);

 msjConst[0] = estatus;
 msjConst[1] = 0;
 string_add(bufferEeprom, msjConst);

 buffer_save_send( 1 , bufferEeprom);
 }else if(!mysql_search(tablePrepago, pensionadosID, id, &fila)){

 canCommand[3] = CAN_PREPAGO[0];
 canCommand[4] = CAN_PREPAGO[1];
 canCommand[5] = CAN_PREPAGO[2];


 mysql_read_string(tablePrepago, prepagoEstatus, fila, &estatus);
 mysql_read(tablePrepago, prepagoSaldo, fila, &saldo);
 if(saldo >= 3600 && (estatus == ESTATUS_PAS || estatus == ESTATUS_BREAK || !canSynchrony || !can.conected)){

 abrirBarrera =  1 ;
 SALIDA_RELE1 = 1;
 SALIDA_RELE2 = 1;
 timer1_reset();
 timer1_enable( 1 );
 acceso[0] = TPV_ACCESO;

 if(!can.conected || !canSynchrony || estatus == ESTATUS_BREAK)
 acceso[2] = ESTATUS_BREAK;

 estatus = (!can.conected || !canSynchrony)? ESTATUS_BREAK:ESTATUS_MOD;
 mysql_write(tablePrepago, prepagoEstatus, fila, estatus,  0 );
 lcd_clean_row(2);
 lcd_out(2,1,"Acceso aceptado");
#line 752 "D:/PROYECTOS/PARKING/HOSPITAL SANTE/Expendedora 4685/Expendedora.c"
 }else{
 if(saldo < 3600){
 acceso[1] = TPV_SIN_SALDO;
 lcd_clean_row(2);
 lcd_out(2,1,"Saldo terminado");
#line 760 "D:/PROYECTOS/PARKING/HOSPITAL SANTE/Expendedora 4685/Expendedora.c"
 }else if(estatus == ESTATUS_MOD){
 acceso[2] = TPV_PASSBACK;
 lcd_clean_row(2);
 lcd_out(2,1,"Passback activo");
#line 767 "D:/PROYECTOS/PARKING/HOSPITAL SANTE/Expendedora 4685/Expendedora.c"
 }
 }

 string_add(canCommand, acceso);

 string_cpyc(bufferEeprom, CAN_PREPAGO);
 numTohex(id, msjConst, 3);
 string_add(bufferEeprom, msjConst);
 if(acceso[0] == TPV_ACCESO)
 string_addc(bufferEeprom, CAN_SPECIAL_DATE);
 else
 string_addc(bufferEeprom, CAN_PASSBACK);
 numToString(fila, msjConst, 4);
 string_add(bufferEeprom, msjConst);

 msjConst[0] = estatus;
 msjConst[1] = 0;
 string_add(bufferEeprom, msjConst);

 DS1307_read(&myRTC,  0 );
 string_add(bufferEeprom, &myRTC.time[1]);

 buffer_save_send( 1 , bufferEeprom);
 }else{
 lcd_clean_row(2);
 lcd_out(2,1,"Tarjeta desconocida");
#line 797 "D:/PROYECTOS/PARKING/HOSPITAL SANTE/Expendedora 4685/Expendedora.c"
 acceso[3] = TPV_DESCONOCIDO;
 string_add(canCommand, acceso);
 }

 string_addc(canCommand, CAN_MODULE);
 numToHex(canId, msjConst, 1);
 string_add(canCommand, msjConst);
 buffer_save_send( 0 , canCommand);
 }else if(buscarNIP){
 buscarNIP =  0 ;

 DS1307_read(&myRTC,  0 );

 string_cpyc(canCommand, CAN_TPV);
 string_addc(canCommand, CAN_NIP);
 numToString(nip, msjConst, 4);
 string_add(canCommand, msjConst);
 string_add(canCommand, &myRTC.time[1]);

 string_cpyc(acceso, ACCESO_DENEGADO);


 if(!mysql_search(tablePrepago, prepagoNip, nip, &fila)){

 mysql_read_string(tablePrepago, prepagoEstatus, fila, &estatus);
 mysql_read(tablePrepago, prepagoSaldo, fila, &saldo);
 mysql_read(tablePrepago, prepagoID, fila, &id);

 if(saldo >= 3600 && (estatus == ESTATUS_PAS || estatus == ESTATUS_BREAK || !canSynchrony || !can.conected)){

 abrirBarrera =  1 ;
 SALIDA_RELE1 = 1;
 SALIDA_RELE2 = 1;
 timer1_reset();
 timer1_enable( 1 );

 acceso[0] = TPV_ACCESO;

 if(!can.conected || !canSynchrony || estatus == ESTATUS_BREAK)
 acceso[2] = ESTATUS_BREAK;

 estatus = (!can.conected || !canSynchrony)? ESTATUS_BREAK:ESTATUS_MOD;
 mysql_write(tablePrepago, prepagoEstatus, fila, estatus,  0 );
 lcd_clean_row(2);
 lcd_out(2,1,"Acceso aceptado");
#line 847 "D:/PROYECTOS/PARKING/HOSPITAL SANTE/Expendedora 4685/Expendedora.c"
 }else{
 if(saldo < 3600){
 acceso[1] = TPV_SIN_SALDO;
 lcd_clean_row(2);
 lcd_out(2,1,"Saldo agotado");
#line 855 "D:/PROYECTOS/PARKING/HOSPITAL SANTE/Expendedora 4685/Expendedora.c"
 }else if(estatus == ESTATUS_MOD){
 acceso[2] = TPV_PASSBACK;
 lcd_clean_row(2);
 lcd_out(2,1,"Passback activo");
#line 862 "D:/PROYECTOS/PARKING/HOSPITAL SANTE/Expendedora 4685/Expendedora.c"
 }
 }

 string_add(canCommand, acceso);

 string_cpyc(bufferEeprom, CAN_PREPAGO);
 numTohex(id, msjConst, 3);
 string_add(bufferEeprom, msjConst);
 if(acceso[0] == TPV_ACCESO)
 string_addc(bufferEeprom, CAN_SPECIAL_DATE);
 else
 string_addc(bufferEeprom, CAN_PASSBACK);
 numToString(fila, msjConst, 4);
 string_add(bufferEeprom, msjConst);

 string_push(bufferEeprom, estatus);

 DS1307_read(&myRTC,  0 );
 string_add(bufferEeprom, &myRTC.time[1]);

 buffer_save_send( 1 , bufferEeprom);
 }else if(!mysql_search_forced(tableKeyOutNip, keyOutNip, nip, &fila)){

 canCommand[3] = CAN_KEY[0];
 canCommand[4] = CAN_KEY[1];
 canCommand[5] = CAN_KEY[2];
 mysql_read_forced(tableKeyOutNip, keyOutEstatus, fila, &estatus);
 mysql_read_forced(tableKeyOutNip, keyOutDate, fila, fecha);
 fecha[12] = 0;
 DS1307_read(&myRTC,  0 );
#line 900 "D:/PROYECTOS/PARKING/HOSPITAL SANTE/Expendedora 4685/Expendedora.c"
 string_cpyn(msjConst, &myRTC.time[1], 6);
 seconds = DS1307_getSeconds(msjConst);
 string_cpyn(msjConst, fecha, 6);
 seconds -= DS1307_getSeconds(msjConst);
 seconds = clamp(seconds, 0, TOLERANCIA_OUT);


 string_cpy(msjConst, &myRTC.time[1]);
 isOtherToday = !string_cmpn(&msjConst[6], &fecha[6], 2);
 isOtherToday |= !string_cmpn(&msjConst[8], &fecha[8], 2);
 isOtherToday |= !string_cmpn(&msjConst[10], &fecha[10], 2);


 if(estatus == '1' && seconds < TOLERANCIA_OUT && !isOtherToday){

 abrirBarrera =  1 ;
 SALIDA_RELE1 = 1;
 SALIDA_RELE2 = 1;
 timer1_reset();
 timer1_enable( 1 );

 acceso[0] = TPV_ACCESO;



 mysql_write_forced(tableKeyOutNip, keyOutEstatus, fila, "0", 1);
 lcd_clean_row(2);
 lcd_out(2,1,"NIP aceptado");
#line 933 "D:/PROYECTOS/PARKING/HOSPITAL SANTE/Expendedora 4685/Expendedora.c"
 }else if(estatus == '0'){
 acceso[2] = TPV_PASSBACK;
 lcd_clean_row(2);
 lcd_out(2,1,"NIP desconocido*");
#line 942 "D:/PROYECTOS/PARKING/HOSPITAL SANTE/Expendedora 4685/Expendedora.c"
 }else if(isOtherToday || seconds >= TOLERANCIA_OUT){
 acceso[1] = TPV_OUT_TIME;
 lcd_clean_row(2);
 lcd_out(2,1,"NIP invalido*");
#line 949 "D:/PROYECTOS/PARKING/HOSPITAL SANTE/Expendedora 4685/Expendedora.c"
 }

 string_add(canCommand, acceso);
 }else{
 lcd_clean_row(2);
 lcd_out(2,1,"Nip descnocido");
#line 958 "D:/PROYECTOS/PARKING/HOSPITAL SANTE/Expendedora 4685/Expendedora.c"
 acceso[3] = TPV_DESCONOCIDO;
 string_add(canCommand,acceso);
 }

 string_addc(canCommand, CAN_MODULE);
 numToHex(canId, msjConst, 1);
 string_add(canCommand, msjConst);
 buffer_save_send( 0 , canCommand);
 }
}

void expendedora_imprimir(){
 const char convenio[] = "11";
 static  char  btnCoche =  0 ;
 static char imprimir = 0x00;
 char tiempoEvento[20];


 if(SENSOR_COCHE && !btnCoche){
 btnCoche =  1 ;
 lcd_chr(1,20,'C');

 string_cpyc(bufferEeprom, CAN_TPV);
 string_addc(bufferEeprom, CAN_COCHE_IN);
 DS1307_read(&myRTC,  0 );
 string_add(bufferEeprom, &myRTC.time[1]);

 string_addc(bufferEeprom, CAN_MODULE);
 numToHex(canId, msjConst, 1);
 string_add(bufferEeprom, msjConst);
 buffer_save_send( 0 , bufferEeprom);
#line 992 "D:/PROYECTOS/PARKING/HOSPITAL SANTE/Expendedora 4685/Expendedora.c"
 }else if(!SENSOR_COCHE && btnCoche){
 btnCoche =  0 ;
 lcd_chr(1,20,' ');

 string_cpyc(bufferEeprom, CAN_TPV);
 string_addc(bufferEeprom, CAN_COCHE_OUT);
 DS1307_read(&myRTC,  0 );
 string_add(bufferEeprom, &myRTC.time[1]);

 string_addc(bufferEeprom, CAN_MODULE);
 numToHex(canId, msjConst, 1);
 string_add(bufferEeprom, msjConst);
 buffer_save_send( 0 , bufferEeprom);
#line 1008 "D:/PROYECTOS/PARKING/HOSPITAL SANTE/Expendedora 4685/Expendedora.c"
 }


 if(BOTON_IMPRIMIR){
 if(!imprimir && SENSOR_COCHE){
 limpiarLCD =  1 ;
 tempLCD = 0;

 if(cupoLleno){
 lcd_clean_row(1);
 lcd_out(3,1,"Cupo lleno");
#line 1022 "D:/PROYECTOS/PARKING/HOSPITAL SANTE/Expendedora 4685/Expendedora.c"
 return;
 }

 imprimir = 0x03;
 lcd_clean_row(3);
 lcd_out(3,1,"Imprimendo...");
#line 1032 "D:/PROYECTOS/PARKING/HOSPITAL SANTE/Expendedora 4685/Expendedora.c"
 folio = clamp_shift(++folio, 1, 9999999);
 numToString(folio, ticketFolio, 7);
 DS1307_read(&myRTC,  1 );
 string_cpy(ticketTime, &myRTC.time[2]);

 DS1307_read(&myRTC,  0 );
 string_cpy(ticketCodigo, &myRTC.time[1]);
 string_cpy(tiempoEvento, &myRTC.time[1]);

 string_pop(ticketCodigo);
 string_pop(ticketCodigo);
 numToString(myRTC.year, msjConst, 3);
 string_add(ticketCodigo, msjConst);
 string_push(ticketCodigo, '1');
 string_add(ticketCodigo, ticketFolio);
 string_addc(ticketCodigo, convenio);




 encrypt_basic(ticketCodigo);


 mysql_write(tableFolio, folioTotal, 1, folio,  0 );
#line 1060 "D:/PROYECTOS/PARKING/HOSPITAL SANTE/Expendedora 4685/Expendedora.c"
 }
 }


 if(imprimir){

 if(imprimir.B0){
 if(expendedora_ticket()){
 imprimir.B0 =  0 ;
 lcd_clean_row(3);
 lcd_out(3, 4, "Tome su boleto");
#line 1075 "D:/PROYECTOS/PARKING/HOSPITAL SANTE/Expendedora 4685/Expendedora.c"
 abrirBarrera =  1 ;
 SALIDA_RELE1 = 1;
 SALIDA_RELE2 = 1;
 timer1_reset();
 timer1_enable( 1 );

 string_cpyc(canCommand, CAN_TPV);
 string_addc(canCommand, CAN_FOL);
 numToHex(folio, ticketFolio, 4);
 string_add(canCommand, ticketFolio);


 string_add(canCommand, tiempoEvento);
 string_addc(canCommand, CAN_MODULE);
 numToHex(canId, msjConst, 1);
 string_add(canCommand, msjConst);

 buffer_save_send( 0 , canCommand);
 }
 }

 if(imprimir.B1){
 if(!SENSOR_COCHE){
 imprimir.B1 =  0 ;
 delay_ms(50);
 }
 }
 }
}

 char  expendedora_ticket(){
 static unsigned int puntero = 0;
 char buffer[64+1];
 char cont = 0;


 cont = 0;
#line 1125 "D:/PROYECTOS/PARKING/HOSPITAL SANTE/Expendedora 4685/Expendedora.c"
 while(ticket[puntero] != 0){
 buffer[cont++] = ticket[puntero++];

 if(buffer[cont-1] == '\n')
 break;
 }

 buffer[cont] = 0;

 impresoraTerm_writeDinamicText(buffer, ticketAddr);


 if(ticket[puntero] == 0 ){
 puntero = 0;
 return  1 ;
 }

 return  0 ;
}

void expendedora_bufferEventos(){

 char estatus;


 if(!pilaBufferCAN || !can.conected)
 return;


 if(!can.txQueu && !can.rxBusy && !modeBufferEventos){

 if(!mysql_read_forced(tableEventosCAN, eventosEstatus, pilaBufferPointer, &estatus)){
#line 1166 "D:/PROYECTOS/PARKING/HOSPITAL SANTE/Expendedora 4685/Expendedora.c"
 if(estatus == '1'){
 mysql_read_string(tableEventosCAN, eventosRegistro, pilaBufferPointer, bufferEeprom);

 if(can_write_text(can.ip+canIdTPV, bufferEeprom, 0)){
 modeBufferEventos =  1 ;
 }
#line 1180 "D:/PROYECTOS/PARKING/HOSPITAL SANTE/Expendedora 4685/Expendedora.c"
 return;
 }
 }

 pilaBufferPointer = clamp_shift(++pilaBufferPointer, 1, myTable.row);
 }
}



void lcd_clean_row(char fila){
 char i = 20;

 while(i)
 lcd_chr(fila, i--, ' ');
}

void can_user_read_message(){

 const char FILAS_ACTUALES[] = "FR:";
 const char FILAS_PROG[] = "FP:";
 char sizeKey, sizeTotal;
 int fila;
 char vigencia, estatus;
 long idConsulta, idNew, id;
 long nip, saldo, auxNip;
#line 1212 "D:/PROYECTOS/PARKING/HOSPITAL SANTE/Expendedora 4685/Expendedora.c"
 limpiarLCD =  1 ;
 tempLCD = 0;
 lcd_clean_row(3);
 lcd_out(3,17,"MSG");


 sizeTotal = 0;
 sizeKey = sizeof(CAN_PENSIONADO)-1;
 if(string_cmpnc(CAN_PENSIONADO, &can.rxBuffer[sizeTotal], sizeKey)){

 sizeTotal += sizeKey;
 sizeKey = 6;
 string_cpyn(msjConst, &can.rxBuffer[sizeTotal], sizeKey);
 idConsulta = hexToNum(msjConst);

 sizeTotal += sizeKey;
 sizeKey = sizeof(CAN_REGISTRAR)-1;

 string_cpyn(msjConst, &can.rxBuffer[sizeTotal+sizeKey], 4);
 fila = stringToNum(msjConst);

 if(string_cmpnc(CAN_REGISTRAR, &can.rxBuffer[sizeTotal], sizeKey)){

 sizeTotal += sizeKey;
 sizeKey = 4;

 idNew = idConsulta;

 sizeTotal += sizeKey;
 sizeKey = 1;
 vigencia = can.rxBuffer[sizeTotal];

 sizeTotal += sizeKey;
 sizeKey = 1;
 estatus = can.rxBuffer[sizeTotal];

 if(mysql_read(tablePensionados, pensionadosID, fila, &id) ==  3 ){
 if(fila == myTable.rowAct+1){
 if(!mysql_write(tablePensionados, pensionadosID, -1, idNew,  1 )){
#line 1254 "D:/PROYECTOS/PARKING/HOSPITAL SANTE/Expendedora 4685/Expendedora.c"
 mysql_write(tablePensionados, pensionadosID, fila, idNew,  0 );
 mysql_write(tablePensionados, pensionadosVigencia, fila, vigencia,  0 );
 mysql_write(tablePensionados, pensionadosEstatus, fila, estatus,  0 );
 }
 }
 }
 }else if(string_cmpnc(CAN_ACTUALIZAR, &can.rxBuffer[sizeTotal], sizeKey)){

 sizeTotal += sizeKey;
 sizeKey = 4;

 sizeTotal += sizeKey;
 sizeKey = 6;
 string_cpyn(msjConst, &can.rxBuffer[sizeTotal], sizeKey);
 idNew = hexToNum(msjConst);

 sizeTotal += sizeKey;
 sizeKey = 1;
 vigencia = can.rxBuffer[sizeTotal];

 sizeTotal += sizeKey;
 sizeKey = 1;
 estatus = can.rxBuffer[sizeTotal];


 if(!mysql_read(tablePensionados,pensionadosID, fila, &id)){
 if(id == idConsulta){
#line 1284 "D:/PROYECTOS/PARKING/HOSPITAL SANTE/Expendedora 4685/Expendedora.c"
 mysql_write(tablePensionados, pensionadosID, fila, idNew,  0 );
 mysql_write(tablePensionados, pensionadosVigencia, fila, vigencia,  0 );
 mysql_write(tablePensionados, pensionadosEstatus, fila, estatus,  0 );
 }
 }
 }else if(string_cmpnc(CAN_VIGENCIA, &can.rxBuffer[sizeTotal], sizeKey)){

 sizeTotal += sizeKey;
 sizeKey = 4;

 sizeTotal += sizeKey;
 sizeKey = 1;
 vigencia = can.rxBuffer[sizeTotal];

 if(!mysql_read(tablePensionados,pensionadosID, fila, &id)){
 if(id == idConsulta){
#line 1303 "D:/PROYECTOS/PARKING/HOSPITAL SANTE/Expendedora 4685/Expendedora.c"
 mysql_write(tablePensionados, pensionadosVigencia, fila, vigencia,  0 );
 }
 }
 }else if(string_cmpnc(CAN_PASSBACK, &can.rxBuffer[sizeTotal], sizeKey)){

 sizeTotal += sizeKey;
 sizeKey = 4;

 sizeTotal += sizeKey;
 sizeKey = 1;
 estatus = can.rxBuffer[sizeTotal];

 if(!mysql_read(tablePensionados, pensionadosID, fila, &id)){
 if(id == idConsulta){
#line 1320 "D:/PROYECTOS/PARKING/HOSPITAL SANTE/Expendedora 4685/Expendedora.c"
 mysql_write(tablePensionados, pensionadosEstatus, fila, estatus,  0 );
 }
 }
 }else if(string_cmpnc(CAN_CONSULTAR, &can.rxBuffer[sizeTotal], sizeKey)){

 sizeTotal += sizeKey;
 sizeKey = 4;

 string_cpyc(bufferEeprom, CAN_TPV);
 string_cpyn(&bufferEeprom[sizeof(CAN_TPV)-1], can.rxBuffer, sizeTotal);
 if(!mysql_read(tablePensionados, pensionadosID, fila, &id)){
 if(idConsulta == id){
#line 1335 "D:/PROYECTOS/PARKING/HOSPITAL SANTE/Expendedora 4685/Expendedora.c"
 mysql_read_string(tablePensionados, pensionadosVigencia, fila, &vigencia);
 mysql_read_string(tablePensionados, pensionadosEstatus, fila, &estatus);

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

 buffer_save_send( 1 , bufferEeprom);
 }
 }else if(string_cmpnc(CAN_RTC, &can.rxBuffer[sizeTotal], sizeKey)){
 sizeTotal += sizeKey;
 sizeKey = sizeof(CAN_TABLE_SET)-1;

 if(string_cmpnc(CAN_TABLE_SET, &can.rxBuffer[sizeTotal], sizeKey)){
 sizeTotal += sizeKey;
 DS1307_write_string(&myRTC,&can.rxBuffer[sizeTotal]);
#line 1364 "D:/PROYECTOS/PARKING/HOSPITAL SANTE/Expendedora 4685/Expendedora.c"
 }else if(string_cmpnc(CAN_TABLE_GET, &can.rxBuffer[sizeTotal], sizeKey)){
 sizeTotal += sizeKey;
 DS1307_read(&myRTC, 1 );
 string_cpyc(bufferEeprom, CAN_TPV);
 string_addc(bufferEeprom, CAN_RTC);
 string_addc(bufferEeprom, CAN_TABLE_GET);
 string_add(bufferEeprom, myRTC.time);
 string_addc(bufferEeprom, CAN_MODULE);
 numToHex(can.id, msjConst, 1);
 string_add(bufferEeprom, msjConst);
 buffer_save_send( 1 , bufferEeprom);
#line 1378 "D:/PROYECTOS/PARKING/HOSPITAL SANTE/Expendedora 4685/Expendedora.c"
 }
 }else if(string_cmpnc(CAN_PREPAGO, &can.rxBuffer[sizeTotal], sizeKey)){

 sizeTotal += sizeKey;
 sizeKey = 6;
 string_cpyn(msjConst, &can.rxBuffer[sizeTotal], sizeKey);
 idConsulta = hexToNum(msjConst);

 sizeTotal += sizeKey;
 sizeKey = sizeof(CAN_REGISTRAR)-1;

 string_cpyn(msjConst, &can.rxBuffer[sizeTotal+sizeKey], 4);
 fila = stringToNum(msjConst);


 if(string_cmpnc(CAN_REGISTRAR, &can.rxBuffer[sizeTotal], sizeKey)){

 sizeTotal += sizeKey;
 sizeKey = 4;

 idNew = idConsulta;

 sizeTotal += sizeKey;
 sizeKey = 8;
 string_cpyn(msjConst, &can.rxBuffer[sizeTotal], sizeKey);
 nip = hexToNum(msjConst);

 sizeTotal += sizeKey;
 sizeKey = 8;
 string_cpyn(msjConst, &can.rxBuffer[sizeTotal], sizeKey);
 saldo = hexToNum(msjConst);

 sizeTotal += sizeKey;
 sizeKey = 1;
 estatus = can.rxBuffer[sizeTotal];

 if(mysql_read(tablePrepago, prepagoID, fila, &id) ==  3 ){
 if(fila == myTable.rowAct+1){
 if(!mysql_write(tablePrepago, prepagoID, -1, idNew,  1 )){

 mysql_write(tablePrepago, prepagoNip, fila, nip,  0 );
 mysql_write(tablePrepago, prepagoSaldo, fila, saldo,  0 );
 mysql_write(tablePrepago, prepagoEstatus, fila, estatus,  0 );
 mysql_write_string(tablePrepago, prepagoDate, fila, "",  0 );
#line 1425 "D:/PROYECTOS/PARKING/HOSPITAL SANTE/Expendedora 4685/Expendedora.c"
 }
 }
 }
 }else if(string_cmpnc(CAN_ACTUALIZAR, &can.rxBuffer[sizeTotal], sizeKey)){

 sizeTotal += sizeKey;
 sizeKey = 4;

 sizeTotal += sizeKey;
 sizeKey = 6;
 string_cpyn(msjConst, &can.rxBuffer[sizeTotal], sizeKey);
 idNew = hexToNum(msjConst);

 sizeTotal += sizeKey;
 sizeKey = 8;
 string_cpyn(msjConst, &can.rxBuffer[sizeTotal], sizeKey);
 nip = hexToNum(msjConst);

 sizeTotal += sizeKey;
 sizeKey = 8;
 string_cpyn(msjConst, &can.rxBuffer[sizeTotal], sizeKey);
 saldo = hexToNum(msjConst);

 sizeTotal += sizeKey;
 sizeKey = 1;
 estatus = can.rxBuffer[sizeTotal];


 if(!mysql_read(tablePrepago, prepagoID, fila, &id)){
 if(id == idConsulta){
 mysql_write(tablePrepago, prepagoID, fila, idNew,  0 );
 mysql_write(tablePrepago, prepagoNip, fila, nip,  0 );
 mysql_write(tablePrepago, prepagoSaldo, fila, saldo,  0 );
 mysql_write(tablePrepago, prepagoEstatus, fila, estatus,  0 );
#line 1462 "D:/PROYECTOS/PARKING/HOSPITAL SANTE/Expendedora 4685/Expendedora.c"
 }
 }
 }else if(string_cmpnc(CAN_CONSULTAR, &can.rxBuffer[sizeTotal], sizeKey)){

 sizeTotal += sizeKey;
 sizeKey = 4;

 string_cpyc(bufferEeprom, CAN_TPV);
 string_cpyn(&bufferEeprom[sizeof(CAN_TPV)-1], can.rxBuffer, sizeTotal);
 if(!mysql_read(tablePrepago, prepagoID, fila, &id)){
 if(idConsulta == id){
 mysql_read(tablePrepago, prepagoNip, fila, &nip);
 mysql_read(tablePrepago, prepagoSaldo, fila, &saldo);
 mysql_read_string(tablePrepago, prepagoEstatus, fila, &estatus);

 numToHex(nip, msjConst, 4);
 string_add(bufferEeprom, msjConst);
 numToHex(saldo, msjConst, 4);
 string_add(bufferEeprom, msjConst);
 string_push(bufferEeprom, estatus);
 string_addc(bufferEeprom, CAN_MODULE);
 numToHex(can.id, msjConst, 1);
 string_add(bufferEeprom, msjConst);
#line 1488 "D:/PROYECTOS/PARKING/HOSPITAL SANTE/Expendedora 4685/Expendedora.c"
 }else{
 string_addc(bufferEeprom, CAN_TABLE_NO_FOUND);
 }
 }

 buffer_save_send( 1 , bufferEeprom);
 }else if(string_cmpnc(CAN_NIP, &can.rxBuffer[sizeTotal], sizeKey)){

 sizeTotal += sizeKey;
 sizeKey = 4;

 sizeTotal += sizeKey;
 sizeKey = 8;
 string_cpyn(msjConst, &can.rxBuffer[sizeTotal], sizeKey);
 nip = hexToNum(msjConst);

 if(!mysql_read(tablePrepago, prepagoID, fila, &id)){
 if(id == idConsulta){
 mysql_write(tablePrepago, prepagoNip, fila, nip,  0 );
#line 1510 "D:/PROYECTOS/PARKING/HOSPITAL SANTE/Expendedora 4685/Expendedora.c"
 }
 }
 }else if(string_cmpnc(CAN_SALDO, &can.rxBuffer[sizeTotal], sizeKey)){

 sizeTotal += sizeKey;
 sizeKey = 4;

 sizeTotal += sizeKey;
 sizeKey = 8;
 string_cpyn(msjConst, &can.rxBuffer[sizeTotal], sizeKey);
 saldo = hexToNum(msjConst);

 if(!mysql_read(tablePrepago, prepagoID, fila, &id)){
 if(id == idConsulta){
 mysql_write(tablePrepago, prepagoSaldo, fila, saldo,  0 );
#line 1528 "D:/PROYECTOS/PARKING/HOSPITAL SANTE/Expendedora 4685/Expendedora.c"
 }
 }
 }else if(string_cmpnc(CAN_PASSBACK, &can.rxBuffer[sizeTotal], sizeKey)){

 sizeTotal += sizeKey;
 sizeKey = 4;

 sizeTotal += sizeKey;
 sizeKey = 1;
 estatus = can.rxBuffer[sizeTotal];

 if(!mysql_read(tablePrepago, prepagoID, fila, &id)){
 if(id == idConsulta){
 mysql_write(tablePrepago, prepagoEstatus, fila, estatus,  0 );
#line 1545 "D:/PROYECTOS/PARKING/HOSPITAL SANTE/Expendedora 4685/Expendedora.c"
 }
 }
 }else if(string_cmpnc(CAN_SPECIAL_DATE, &can.rxBuffer[sizeTotal], sizeKey)){

 sizeTotal += sizeKey;
 sizeKey = 4;

 sizeTotal += sizeKey;
 sizeKey = 1;
 estatus = can.rxBuffer[sizeTotal];

 sizeTotal += sizeKey;
 sizeKey = 12;
 string_cpyn(msjConst, &can.rxBuffer[sizeTotal], sizeKey);

 if(!mysql_read(tablePrepago, prepagoID, fila, &id)){
 if(id == idConsulta){
 mysql_write(tablePrepago, prepagoEstatus, fila, estatus,  0 );
 mysql_write_string(tablePrepago, prepagoDate, fila, msjConst,  0 );
#line 1567 "D:/PROYECTOS/PARKING/HOSPITAL SANTE/Expendedora 4685/Expendedora.c"
 }
 }
 }else if(string_cmpnc(CAN_SPECIAL_SALDO, &can.rxBuffer[sizeTotal], sizeKey)){

 sizeTotal += sizeKey;
 sizeKey = 4;

 sizeTotal += sizeKey;
 sizeKey = 1;
 estatus = can.rxBuffer[sizeTotal];

 sizeTotal += sizeKey;
 sizeKey = 8;
 string_cpyn(msjConst, &can.rxBuffer[sizeTotal], sizeKey);
 saldo = hexToNum(msjConst);

 if(!mysql_read(tablePrepago, prepagoID, fila, &id)){
 if(id == idConsulta){
 mysql_write(tablePrepago, prepagoEstatus, fila, estatus,  0 );
 mysql_write(tablePrepago, prepagoSaldo, fila, saldo,  0 );
#line 1590 "D:/PROYECTOS/PARKING/HOSPITAL SANTE/Expendedora 4685/Expendedora.c"
 }
 }
 }else{
 string_addc(bufferEeprom, CAN_TABLE_ERROR);
 }
 }else if(string_cmpnc(CAN_SOPORTE, &can.rxBuffer[sizeTotal], sizeKey)){

 sizeTotal += sizeKey;
 sizeKey = 6;
 string_cpyn(msjConst, &can.rxBuffer[sizeTotal], sizeKey);
 idConsulta = hexToNum(msjConst);

 sizeTotal += sizeKey;
 sizeKey = sizeof(CAN_REGISTRAR)-1;

 string_cpyn(msjConst, &can.rxBuffer[sizeTotal+sizeKey], 4);
 fila = stringToNum(msjConst);

 if(string_cmpnc(CAN_REGISTRAR, &can.rxBuffer[sizeTotal], sizeKey)){

 sizeTotal += sizeKey;
 sizeKey = 4;

 idNew = idConsulta;

 if(mysql_read(tableSoporte, soporteID, fila, &id) ==  3 ){
 if(fila == myTable.rowAct+1){
 if(!mysql_write(tableSoporte, soporteID, -1, idNew,  1 )){
#line 1621 "D:/PROYECTOS/PARKING/HOSPITAL SANTE/Expendedora 4685/Expendedora.c"
 mysql_write(tableSoporte, soporteID, fila, idNew,  0 );
 }
 }
 }
 }else if(string_cmpnc(CAN_CONSULTAR, &can.rxBuffer[sizeTotal], sizeKey)){

 sizeTotal += sizeKey;
 sizeKey = 4;

 string_cpyc(bufferEeprom, CAN_TPV);
 string_cpyn(&bufferEeprom[sizeof(CAN_TPV)-1], can.rxBuffer, sizeTotal);
 if(!mysql_read(tableSoporte, soporteID, fila, &id)){
 if(idConsulta == id){
#line 1638 "D:/PROYECTOS/PARKING/HOSPITAL SANTE/Expendedora 4685/Expendedora.c"
 string_addc(bufferEeprom, CAN_MODULE);
 numToHex(can.id, msjConst, 1);
 string_add(bufferEeprom, msjConst);
 }else{
 string_addc(bufferEeprom, CAN_TABLE_NO_FOUND);
 }
 }else{
 string_addc(bufferEeprom, CAN_TABLE_ERROR);
 }

 buffer_save_send( 1 , bufferEeprom);
 }
 }else if(string_cmpnc(CAN_TABLE, &can.rxBuffer[sizeTotal], sizeKey)){
 sizeTotal += sizeKey;
 sizeKey = sizeof(CAN_TABLE_ERASE)-1;


 string_cpyc(bufferEeprom, CAN_TPV);
 string_addc(bufferEeprom, CAN_TABLE);


 if(string_cmpnc(CAN_TABLE_ERASE, &can.rxBuffer[sizeTotal], sizeKey)){
 sizeTotal += sizeKey;
 if(mysql_erase(&can.rxBuffer[sizeTotal])){
 string_addc(bufferEeprom, CAN_TABLE_ERASE);

 string_cpyn(msjConst, &can.rxBuffer[sizeTotal], 3);
 string_toUpper(msjConst);
 string_add(bufferEeprom, msjConst);
 }else{
 string_addc(bufferEeprom, CAN_TABLE_NO_FOUND);
 }
#line 1674 "D:/PROYECTOS/PARKING/HOSPITAL SANTE/Expendedora 4685/Expendedora.c"
 }else if(string_cmpnc(CAN_TABLE_INFO, &can.rxBuffer[sizeTotal], sizeKey)){

 sizeTotal += sizeKey;

 if(mysql_exist(&can.rxBuffer[sizeTotal])){
 string_addc(bufferEeprom, CAN_TABLE_INFO);

 string_cpyn(msjConst, &can.rxBuffer[sizeTotal], 3);
 string_toUpper(msjConst);
 string_add(bufferEeprom, msjConst);

 string_addc(bufferEeprom, FILAS_ACTUALES);
 numToString(myTable.rowAct, msjConst, 4);
 string_add(bufferEeprom, msjConst);

 string_addc(bufferEeprom, FILAS_PROG);
 numToString(myTable.row, msjConst, 4);
 string_add(bufferEeprom, msjConst);
#line 1696 "D:/PROYECTOS/PARKING/HOSPITAL SANTE/Expendedora 4685/Expendedora.c"
 }else{
 string_addc(bufferEeprom, CAN_TABLE_NO_FOUND);
 }
 }else if(string_cmpnc(CAN_PASSBACK, &can.rxBuffer[sizeTotal], sizeKey)){

 sizeTotal += sizeKey;


 if(mysql_exist(&can.rxBuffer[sizeTotal])){
 string_addc(bufferEeprom, CAN_PASSBACK);

 string_cpyn(msjConst, &can.rxBuffer[sizeTotal], 3);
 string_toUpper(msjConst);
 string_add(bufferEeprom, msjConst);


 for(fila = 1; fila <= myTable.rowAct; fila++)
 mysql_write(&can.rxBuffer[sizeTotal], pensionadosEstatus, fila, '-',  0 );


 if(!mysql_write(&can.rxBuffer[sizeTotal], pensionadosEstatus, 1, '-',  0 ))
 string_addc(bufferEeprom, CAN_TABLE_MODIFICADO);
 else
 string_addc(bufferEeprom,CAN_TABLE_ERROR);
 }else{
 string_addc(bufferEeprom, CAN_TABLE_NO_FOUND);
 }
 }

 string_cpyc(msjConst, CAN_MODULE);
 numToHex(can.id, &msjConst[1], 1);
 string_add(bufferEeprom, msjConst);

 buffer_save_send( 1 , bufferEeprom);
 }else if(string_cmpnc(CAN_TABLE_RW, &can.rxBuffer[sizeTotal], sizeKey)){

 sizeTotal += sizeKey;
 sizeKey = 4;
 string_cpyn(msjConst, &can.rxBuffer[sizeTotal], sizeKey);
 fila = stringToNum(msjConst);

 sizeTotal += sizeKey;
 sizeKey = sizeof(CAN_PENSIONADO)-1;

 string_cpyc(bufferEeprom, CAN_TBL);
 string_addc(bufferEeprom, CAN_MODULE);
 numToHex(can.id, msjConst, 1);
 string_add(bufferEeprom, msjConst);


 if(string_cmpnc(CAN_PENSIONADO, &can.rxBuffer[sizeTotal], sizeKey)){

 string_addc(bufferEeprom, CAN_PENSIONADO);
 sizeTotal += sizeKey;
 sizeKey = sizeof(CAN_TABLE_READ)-1;

 if(string_cmpnc(CAN_TABLE_READ, &can.rxBuffer[sizeTotal], sizeKey)){
 if(!mysql_read(tablePensionados, pensionadosID, fila, &id)){

 mysql_read_string(tablePensionados, pensionadosVigencia, fila, &vigencia);
 mysql_read_string(tablePensionados, pensionadosEstatus, fila, &estatus);

 numToHex(id, msjConst, 3);
 string_add(bufferEeprom, msjConst);
 string_push(bufferEeprom, vigencia);
 string_push(bufferEeprom, estatus);
 }else{
 string_addc(bufferEeprom, CAN_TABLE_ERROR);
 }
 }else if(string_cmpnc(CAN_TABLE_WRITE, &can.rxBuffer[sizeTotal], sizeKey)){
 sizeTotal += sizeKey;
 sizeKey = 6;
 string_cpyn(msjConst, &can.rxBuffer[sizeTotal], sizeKey);
 idNew = hexToNum(msjConst);

 sizeTotal += sizeKey;
 sizeKey = 1;
 vigencia = can.rxBuffer[sizeTotal];

 sizeTotal += sizeKey;
 sizeKey = 1;
 estatus = can.rxBuffer[sizeTotal];

 if(!mysql_write(tablePensionados, pensionadosID, fila, id,  0 )){

 mysql_write(tablePensionados, pensionadosVigencia, fila, vigencia,  0 );
 mysql_write(tablePensionados, pensionadosEstatus, fila, estatus,  0 );

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
 canSynchrony =  1 ;
 else
 canSynchrony =  0 ;
 mysql_write(tableSyncronia, columnaEstado, 1, canSynchrony,  0 );


 lcd_clean_row(3);
 lcd_out(3,1,canSynchrony? "Sincronizado":"Desincronizado");

 string_cpyc(bufferEeprom, CAN_TPV);
 string_addc(bufferEeprom, CAN_CMD);
 string_addc(bufferEeprom, CAN_PASSBACK);
 string_push(buffereeprom, canSynchrony+'0');

 string_cpyc(msjConst, CAN_MODULE);
 numToHex(can.id, &msjConst[1], 1);
 string_add(bufferEeprom, msjConst);

 buffer_save_send( 1 , bufferEeprom);
#line 1821 "D:/PROYECTOS/PARKING/HOSPITAL SANTE/Expendedora 4685/Expendedora.c"
 }else if(string_cmpnc(CAN_CUPO, &can.rxBuffer[sizeTotal], sizeKey)){
 sizeTotal += sizeKey;

 if(can.rxBuffer[sizeTotal] == '1')
 cupoLleno =  1 ;
 else
 cupoLleno =  0 ;
 mysql_write(tableCupo, columnaEstado, 1, cupoLleno,  0 );

 lcd_clean_row(3);
 lcd_out(3,1,cupoLleno? "Cupo lleno":"Cupo disponible");

 string_cpyc(bufferEeprom, CAN_TPV);
 string_addc(bufferEeprom, CAN_CMD);
 string_addc(bufferEeprom, CAN_CUPO);
 string_push(buffereeprom, cupoLleno+'0');

 string_cpyc(msjConst, CAN_MODULE);
 numToHex(can.id, &msjConst[1], 1);
 string_add(bufferEeprom, msjConst);

 buffer_save_send( 1 , bufferEeprom);
#line 1847 "D:/PROYECTOS/PARKING/HOSPITAL SANTE/Expendedora 4685/Expendedora.c"
 }else if(string_cmpnc(CAN_ABRIR, &can.rxBuffer[sizeTotal], sizeKey)){

 abrirBarrera =  1 ;
 SALIDA_RELE1 = 1;
 SALIDA_RELE2 = 1;
 timer1_reset();
 timer1_enable( 1 );

 string_cpyc(bufferEeprom, CAN_TPV);
 string_addc(bufferEeprom, CAN_CMD);
 string_addc(bufferEeprom, CAN_ABRIR);
 string_push(buffereeprom, '1');

 string_cpyc(msjConst, CAN_MODULE);
 numToHex(can.id, &msjConst[1], 1);
 string_add(bufferEeprom, msjConst);

 buffer_save_send( 1 , bufferEeprom);
#line 1868 "D:/PROYECTOS/PARKING/HOSPITAL SANTE/Expendedora 4685/Expendedora.c"
 }else if(string_cmpnc(CAN_KEY, &can.rxBuffer[sizeTotal], sizeKey)){
 sizeTotal += sizeKey;
 sizeKey = sizeof(CAN_NIP)-1;

 if(string_cmpnc(CAN_NIP, &can.rxBuffer[sizeTotal], sizeKey)){
 sizeTotal += sizeKey;
 string_cpyn(msjConst, &can.rxBuffer[sizeTotal], 8);
 nip = hexToNum(msjConst);

 string_cpyn(msjConst, &can.rxBuffer[sizeTotal+8], 12);

 if(!mysql_search_forced(tableKeyOutNip, keyOutNip, nip, &fila)){
 estatus = '0';
 mysql_write_forced(tableKeyOutNip, keyOutEstatus, fila, &estatus, sizeof(estatus));
 auxNip = -1;
 mysql_write_forced(tableKeyOutNip, keyOutNip, fila, (char*)&auxNip, sizeof(auxNip));
 }

 mysql_write_roundTrip(tableKeyOutNip, keyOutEstatus, "1", 1);
 mysql_write_forced(tableKeyOutNip, keyOutNip, myTable.rowAct, (char*)&nip, sizeof(nip));
 mysql_write_forced(tableKeyOutNip, keyOutDate, myTable.rowAct, msjConst, string_len(msjConst)+1);


 string_cpyc(bufferEeprom, CAN_TPV);
 string_addc(bufferEeprom, CAN_OUT);
 string_addc(bufferEeprom, CAN_KEY);
 string_addc(bufferEeprom, CAN_NIP);
 numToHex(nip, msjConst, 4);
 string_add(bufferEeprom, msjConst);
 string_addc(bufferEeprom, CAN_REGISTRAR);

 string_addc(bufferEeprom, CAN_MODULE);
 numToHex(canId, msjConst, 1);
 string_add(bufferEeprom, msjConst);

 buffer_save_send( 1 , bufferEeprom);
#line 1908 "D:/PROYECTOS/PARKING/HOSPITAL SANTE/Expendedora 4685/Expendedora.c"
 }
 }else if(string_cmpnc(CAN_FOL, &can.rxBuffer[sizeTotal], sizeKey)){
 sizeTotal += sizeKey;
 sizeKey = sizeof(CAN_TABLE_GET)-1;

 if(string_cmpnc(CAN_TABLE_GET, &can.rxBuffer[sizeTotal], sizeKey)){
 sizeTotal += sizeKey;
 string_cpyc(bufferEeprom, CAN_TPV);
 string_addc(bufferEeprom, CAN_FOL);
 string_addc(bufferEeprom, CAN_TABLE_GET);

 mysql_read(tableFolio, folioTotal, 1, &folio);
 numToHex(folio, msjConst, 4);
 string_add(bufferEeprom, msjConst);
 string_addc(bufferEeprom, CAN_MODULE);
 numToHex(can.id, msjConst, 1);
 string_add(bufferEeprom, msjConst);
 buffer_save_send( 1 , bufferEeprom);
#line 1929 "D:/PROYECTOS/PARKING/HOSPITAL SANTE/Expendedora 4685/Expendedora.c"
 }else if(string_cmpnc(CAN_TABLE_SET, &can.rxBuffer[sizeTotal], sizeKey)){
 sizeTotal += sizeKey;
 string_cpyn(msjConst, &can.rxBuffer[sizeTotal], 8);
 folio = hexToNum(msjConst);
 mysql_write(tableFolio, folioTotal, 1, folio,  0 );
#line 1938 "D:/PROYECTOS/PARKING/HOSPITAL SANTE/Expendedora 4685/Expendedora.c"
 }
 }
 }
}

void can_user_write_message(){
 if(can.tx_status == CAN_RW_ENVIADO){
 if(modeBufferEventos){
 modeBufferEventos =  0 ;
 pilaBufferCAN--;
 mysql_write_forced(tableEventosCAN, eventosEstatus, pilaBufferPointer, "0", 1);
#line 1953 "D:/PROYECTOS/PARKING/HOSPITAL SANTE/Expendedora 4685/Expendedora.c"
 }
 }else if(can.tx_status == CAN_RW_CORRUPT){

 if(!modeBufferEventos){
 buffer_save_send( 1 , can.txBuffer);
#line 1961 "D:/PROYECTOS/PARKING/HOSPITAL SANTE/Expendedora 4685/Expendedora.c"
 }else{

 modeBufferEventos =  0 ;
#line 1967 "D:/PROYECTOS/PARKING/HOSPITAL SANTE/Expendedora 4685/Expendedora.c"
 }
 }
}

void can_user_guardHeartBeat(char idNodo){

}

void can_heartbeat(){
 char cmdHeartBeat[2];


 if(++temp_heartbeat >= TIME_HEARTBEAT){
 temp_heartbeat = 0;
 cmdHeartBeat[0] = can.id;
 cmdHeartBeat[1] = CAN_PROTOCOL_HEARTBEAT;
 can_write(can.ip+canIdTPV, cmdHeartBeat, sizeof(cmdHeartBeat), 3,  0 );
 }
}

void buffer_save_send( char  guardar, char *buffer){
 char result;

 if(!guardar){
 if(!can_write_text(can.ip+canIdTPV, buffer, 0))
 guardar =  1 ;
 }

 if(guardar){
 if(!mysql_write_roundTrip(tableEventosCAN, eventosRegistro, buffer, strlen(buffer)+1)){
 mysql_read_forced(tableEventosCAN, eventosEstatus, myTable.rowAct, &result);

 if(result != '1')
 pilaBufferCAN++;
 mysql_write_forced(tableEventosCAN, eventosEstatus, myTable.rowAct, "1", 1);
#line 2011 "D:/PROYECTOS/PARKING/HOSPITAL SANTE/Expendedora 4685/Expendedora.c"
 }
 }
}



void int_timer1(){
 static char temp = 0;

 if(PIR1.TMR1IF && PIE1.TMR1IE){

 if(++temp >= 5){
 temp = 0;
 SALIDA_RELE1 = 0;
 SALIDA_RELE2 = 0;
 PIE1.TMR1IE = 0;
 }


 TMR1H =  ((char*)&sampler1)[1] ;
 TMR1L =  ((char*)&sampler1)[0] ;
 PIR1.TMR1IF = 0;
 }
}

void int_timer3(){
 static char temp = 0;

 if(PIR2.TMR3IF && PIE2.TMR3IE){
 can.temp += 200;
 flagTMR3.B0 =  1 ;


 if(++temp >= 5){
 if(can.conected)
 LED_LINK ^= 1;
 temp = 0;
 flagSecondTMR3.B0 =  1 ;
 }

 TMR3H =  ((char*)&sampler3)[1] ;
 TMR3L =  ((char*)&sampler3)[0] ;
 PIR2.TMR3IF = 0;
 }
}
