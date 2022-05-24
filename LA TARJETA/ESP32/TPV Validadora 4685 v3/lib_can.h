#ifndef _LIB_CAN_H
#define _LIB_CAN_H
#include "miscelaneos.h"
//NOTA: LA LIBRERIA SOLO CONSIDERA LA RECEPCION DE LA MISMA IP CON LA MISMA
//      MASKARA, PERO PERMITE MAS IP ADRRES
//NOTA: No he verificado las funciones set_id, get_id, set_baud
//Las asocianes de los regitros de filtros, disnobles, buffer solo modo 1 y 2
//Verificar las notas: de referencia: Dato: Referencia: Dos dos
/*******************************************************************************
CAN_MODE_LEGACY ó MODO 0:
  DEFAULT ESTADO EN RESET
  3 Transmit Buffers: TXB0, TXB1, TXB2
  2 Receive Buffers: RXB0CON, RXB1CON
  2 Acceptance Masks: RXM0, RXM1
  6 Acceptance Filters: RXF0, RXF1, RXF2, RXF3, RXF4, RXF5

CAN_MODE_ENHANCED_LEGACY ó MODO 1:
  ESTE MODO ES EL MISMO QUE EL CERO PERO CON MAS RECUSOS
  3  Transmit Buffers: TXB0, TXB1, TXB2
  2  Receive Buffers: RXB0, RXB1
  6  Programmable Buffers: B0, B1, B2, B3, B4, B5
     Automatic RTR Handling on: B0, B1, B2, B3, B4, B5
  16 Dynamically assigned acceptance filters: RXF0-RXF15
  2  Dedicated mask registers,RXM0: RXM1
  1  Programmable mask register: RXF15
     Programmable data filter on standard identifier messages: SDFLC

CAN_MODE_ENHANCED_FIFO ó MODO 2
  ESTE MODO SE USA LA TECNICA FIFO EL PRIMERO EN ENTRAR EL PRIMERO EN SALIR
  3  Transmit Buffers: TXB0, TXB1, TXB2
  2  Receive Buffers: RXB0, RXB1
  6  Programmable Buffers: B0, B1, B2, B3, B4, B5
     Automatic RTR Handling on: B0, B1, B2, B3, B4, B5
  16 Acceptance Filters: RXF0-RXF15
  2  Dedicated Mask Registers: RXM0, RXM1
  1  Programmable mask register: RXF15
     Programmable data filter on standard identifier messages: SDFLC
*******************************************************************************/
//VALORES STANDAR DE LA LIBRERIA
const char CAN_SYNC_JUMP_WIDTH = 0;        //RANGE[0-3], INCREMENTAR SI EL OSC ES INESTABLE
const bool CAN_SAMPLE_THRICE_TIMES = true; //TRES MUESTRAS POR POINT
const bool CAN_WAKE_UP_IN_ACTIVITY = true; //ACTIVAR CAN BUS EN ACTIVIDAD
const bool CAN_LINE_FILTER_ON = false;     //DESPERTAR BUS CAN CON FILTER
const bool CAN_USE_DOUBLE_BUFFER = false;  //ESCRIBE EN EL BUFFER 1 SI SE SATURA BUFFER0
const bool CAN_ENABLE_CAPTURE = false;     //RECIBIR MENSAJER POR EL PIN RC2
const bool CAN_ENABLE_DRIVE_HIGH = false;  //PIN CANTX SERA INPUT CUANDO SEA REGRESIVO
const bool CAN_FORMAT_EXTENDED = true;     //FORMATO DE 29BITS Ó 11BITS

//VARIABLES PARA EL PROTOCOLO
const unsigned int CAN_MAX_TIME_ACK = 3000;  //EN MILISEGUNDOS
//CONSTANTES DE RECEPION
const char CAN_RW_EMPTY = 0;
const char CAN_RW_DATA = 1;
const char CAN_RW_REQUEST = 2;
//CONSTANTES DE ENVIO
const char CAN_RW_ENVIADO = 0;
const char CAN_RW_WITHOUT_QUEU = 1;
const char CAN_RW_BUSY = 2;
const char CAN_RW_CORRUPT = 3;
//TAMAÑO DEL BUFFER
const char CAN_LEN_BUFFER_RXTX = 64;    //MULTIMPLOS DE 8 EL BUFFER

//MODO DE OPERACION PARA EL CAN
const char CAN_OPERATION_NORMAL = 0,    //TRANSMITE Y RECIBIE MENSAJE EL BUS
           CAN_OPERATION_DISABLE = 1,   //NO TRANSMITE Y NO RECIBE PERO FUNCIONA INT WAKIF
           CAN_OPERATION_LOOPBACK = 2,  //TRANSMITE LOS DATOS DEL BUFFER TX AL RX
           CAN_OPERATION_LISTEN = 3,    //SOLO ESCUCHA EN EL BUS PERO NO ESCRIBE NADA
           CAN_OPERATION_CONFIG = 4;    //PERMITE LA CONFIGURACION DE LOS REGISTROS DEL BUS CAN
//MODO DEL CAN
const char CAN_MODE_LEGACY = 0,          //MODO 0
           CAN_MODE_ENHANCED_LEGACY = 1, //MODO 1
           CAN_MODE_ENHANCED_FIFO = 2;   //MODO 2
//VARIABLES DE CONTROL PARA EL ESTADO DE ENVIO
const char CAN_PROTOCOL_INIT = 0,  //INICIA LA COMUNICACION CON OTRO DISPOSITIVO
           CAN_PROTOCOL_QUEU = 1,  //ENCOLA LOS DATOS
           CAN_PROTOCOL_END = 2,   //FINALIZA LA COMUNICACION
           CAN_PROTOCOL_BUSY = 3,  //EL BUS ESTA RECIBIENDO DATOS DE OTRO ID
           CAN_PROTOCOL_FREE = 4,  //EL BUS PERMITE LA RECEPCION DE DATOS
           CAN_PROTOCOL_HEARTBEAT = 255;      //HEARTBEAT DETECTADO

/*
//BUFFER PROGRAMABLES
const char CAN_BUFFER_0 = 0x04,
           CAN_BUFFER_1 = 0x08,
           CAN_BUFFER_2 = 0x10,
           CAN_BUFFER_3 = 0x20,
           CAN_BUFFER_4 = 0x40,
           CAN_BUFFER_5 = 0x80;
//FILTER
const unsigned int CAN_FILTER_0 = 0x0001,
                   CAN_FILTER_1 = 0x0002,
                   CAN_FILTER_2 = 0x0004,
                   CAN_FILTER_3 = 0x0008,
                   CAN_FILTER_4 = 0x0010,
                   CAN_FILTER_5 = 0x0020,
                   CAN_FILTER_6 = 0x0040,
                   CAN_FILTER_7 = 0x0080,
                   CAN_FILTER_8 = 0x0100,
                   CAN_FILTER_9 = 0x0200,
                   CAN_FILTER_10 = 0x0400,
                   CAN_FILTER_11 = 0x0800,
                   CAN_FILTER_12 = 0x1000,
                   CAN_FILTER_13 = 0x2000,
                   CAN_FILTER_14 = 0x4000,
                   CAN_FILTER_15 = 0x8000;
*/


//Define estructura
typedef struct{
  //Datos del modulo can
  long ip;           //Ip del modulo can
  long ipAddress;    //ip + id, Red del modulo + identificador de la red
  long mask;         //Maskara del protolo
  char id;           //Id del modulo
  //Otros banderas de interrupcion
  bool conected;
  //Otras variables del modulo
  char mode;         //Tipo de modo de operacion 0,1,2
  bool overflow;     //Sobreflujo buffer, ***
  short numFilter;   //Filtro que fue recepcionado
  //Buffer multiprosito
  char bufferTX[8];    //Permite solamente 8 bytes por hardaware tx
  char bufferRX[8];    //Permite solamente 8 bytes por hardaware tx
  //Variables de transmision
  bool txQueu;       //Datos en cola
  char tx_status;    //Estado de la transmision
  char txSize;       //Datos a enviar
  char txPriority;   //Prioridad
  long txId;         //Nodo a ser enviado
  char txBuffer[CAN_LEN_BUFFER_RXTX]; //Buffer que almacena la data a enviar
  //Variables de recepcion
  bool rxRequest;    //Solicitud
  bool rxBusy;       //Actualmente esta escuchando un mensaje
  char rxBuffer[CAN_LEN_BUFFER_RXTX]; //Buffer que guarda el mensaje leido
  char rxSize;       //Datos a repcionados
  char rxId;         //Guarda el id del actual que estableion comunicacion
  //VARIABLES EXTRAS
  unsigned int temp;
}MODULE_CAN;
//VARIABLE
MODULE_CAN can;

/************************** FUNCTION PROTOTYPE ********************************/
void can_set_mode(const char CAN_MODE);
void can_set_operation(const char CAN_OPERATION);
void can_set_baud(unsigned int speed_us);
void can_set_id(char *address, long value);
long can_get_id(char *address);
bool can_write(long id, char *datos, char size, char priority, bool rtr);
char can_read(long *id, char *datos, char *size);
//Funciones para leer y escribir
void can_user_read_message();
void can_user_write_message();
void can_user_guardHeartBeat(char idNodo);
/******************************** FUNCTIONS ***********************************/
bool can_write_text(long ipAddress, char *texto, char priority){
  //Verifico que no este ocupado el trasmisor y el receptor
  if(!can.txQueu && !can.rxBusy){
    can.txSize = 0;
    can.txQueu = true;
    can.txId = ipAddress;      //Conecta a la red + el id
    can.txPriority = priority;
    //Vaciar el contenido en tx buffer
    while(true){
      can.txBuffer[can.txSize] = texto[can.txSize];
      //Si encuentra final de cadena sale
      if(texto[can.txSize])
        can.txSize++;
      else
        break;
    }
    can.temp = 0;
    return true; //Datos encolados
  }
  //No puede encolar datos en buffer
  return false;
}
/******************************************************************************/
void can_do_write_message(){
  static bool finalizar;
  static char maquinaE = 0;
  static char datosEnviados;
  char cont;
  long id;
  
  //Mientras no encole datos no enviara nada
  if(!can.txQueu)
    return; //CAN_RW_WITHOUT_QUEU;

  //PROTEGER MAQUINA DE ESTADOS POR TEMPORIZADOR
  if(can.temp >= CAN_MAX_TIME_ACK){
    maquinaE = 0;
    can.txQueu = false;
    //Ejucar accion si no pudo enviar la informacion
    can.tx_status = CAN_RW_CORRUPT;
    can_user_write_message();
  }
  
  //Inicia trasmision con un saludo
  if(maquinaE == 0){  //Mando datos al buffer
    maquinaE = 2;
    datosEnviados = 0;
    finalizar = false;
    can.bufferTX[0] = can.id;             //Id del que envia
    can.bufferTX[1] = CAN_PROTOCOL_INIT;  //Inicia comunicacion con el otro dispo
    can_write(can.txId, can.bufferTX, 2, can.txPriority, false);
    can.temp = 0;
  }else if(maquinaE == 1){
    finalizar = !can.txBuffer[datosEnviados];
    //ID DEL QUE ENVIA LOS DATOS
    can.bufferTX[0] = can.id;
    //ENVIA PALABRA DE CONTROL SEGUN EL BUFFER
    can.bufferTX[1] = can.txBuffer[datosEnviados]?CAN_PROTOCOL_QUEU:CAN_PROTOCOL_END;
    for(cont = 2; cont < 8 && can.txBuffer[datosEnviados]; cont++)
      can.bufferTX[cont] = can.txBuffer[datosEnviados++];

    //ENVIA LOS DATOS POR CAN
    can_write(can.txId, can.bufferTX, cont, can.txPriority, false);
    maquinaE++;  //Avanza al siguiente estado
    can.temp = 0;
  }else if(maquinaE == 2){  //Escucha si recibio los datos
    if(can_read(&id, can.bufferRX, &can.rxSize) == CAN_RW_DATA){
      if(id == can.ipAddress){
        //Manda instrucion de que recibio datos
        if(can.bufferRX[0] == getByte(can.txId, 0)){
          if(can.bufferRX[1] == CAN_PROTOCOL_FREE){
            //maquinaE += can.txBuffer[datosEnviados]? -1: 1;
            maquinaE += !finalizar? -1:1;
            can.temp = 0;
          }else if(can.bufferRX[1] == CAN_PROTOCOL_INIT){  
            //Ambos intentan conectarse al mismo tiempo
            can.bufferTX[0] = can.id;             //Id del que envia
            can.bufferTX[1] = CAN_PROTOCOL_BUSY;  //Inicia comunicacion con el otro dispo
            can_write(can.txId, can.bufferTX, 2, 3, false);
            //Le retransmito el start
            maquinaE = 0;
          }else if(can.bufferRX[1] == CAN_PROTOCOL_BUSY){
            maquinaE = 0;
            can.txQueu = false;
            //Ejucar accion si no pudo enviar la informacion
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
    can.txQueu = false;
    finalizar  = false;
    can.tx_status = CAN_RW_ENVIADO;
    can_user_write_message();  //DATOS ENVIADOS CON EXITO
  }
  
  can.tx_status = 0;
  //return CAN_RW_BUSY;   //Verificar esta condicion
}
/******************************************************************************/
void can_do_read_message(){
  static char len = 0;
  long id;
  char cont;
  
  //Mientras este ocupado el transmisor no recepciona nada
  if(can.txQueu)
    return;

  //PROTEJO EL MENSAJE POR TEMPORIZADOR
  if(can.rxBusy){
    if(can.temp >= CAN_MAX_TIME_ACK){
      can.rxBusy = false;
      return;
    }
  }
  
  //Procesa el tipo de solicitud
  if(can_read(&id, can.bufferRX, &can.rxSize) == CAN_RW_DATA){
    if(id == can.ipAddress){  //LA IP CONTIENE EL NUMERO DE RED+ID
      //VERIFICA SI ES HEARTBEAT
      if(can.bufferRX[1] == CAN_PROTOCOL_HEARTBEAT){
        can_user_guardHeartBeat(can.bufferRX[0]);
        return;
      }
      //COMUNICACION SOLO CON EL MODULO ACTUAL SE COMUNICA
      if(can.rxBusy){
        //No fue el nodo correcto
        if(can.rxId != can.bufferRX[0]){
          can.bufferTX[0] = can.id;
          can.bufferTX[1] = CAN_PROTOCOL_BUSY;
          can_write(can.ip+can.bufferRX[0], can.bufferTX, 2, 3, false);
          return;
        }
      }
      //PALABRA DE CONTROL [1]
      if(can.bufferRX[1] == CAN_PROTOCOL_INIT){  //INICIA LA PRIMERA COMUNICACION
        can.rxId = can.bufferRX[0];  //ID del transmisor
        can.rxBusy = true;
        len = 0;
        can.temp = 0;
      }else if(!can.rxBusy){
        //Envio mensaje de error, para que rompa la comunicacion
        return;
      }else if(can.bufferRX[1] == CAN_PROTOCOL_QUEU){ //ENCOLA LOS DATOS
        //Guardos los datos recepcionados
        for(cont = 2; cont < can.rxSize && len < CAN_LEN_BUFFER_RXTX-1; cont++)
          can.rxBuffer[len++] = can.bufferRX[cont];
        can.rxBuffer[len] = 0;
        can.temp = 0;
      }else if(can.bufferRX[1] == CAN_PROTOCOL_END){  //FINALIZA COMUNICACION
        can.rxBuffer[len] = 0;  //Agregar final de cadena
        len = 0;
      }
      
      //Verificar si debo condicionar por palabra de control***
      can.bufferTX[0] = can.id;
      can.bufferTX[1] = CAN_PROTOCOL_FREE;  //Modulo libre
      can_write(can.ip+can.bufferRX[0], can.bufferTX, 2, 3, false);
      
      //Finalizar comunicacion
      if(can.bufferRX[1] == CAN_PROTOCOL_END){
        can_user_read_message();
        can.rxBusy = false;
      }
    }
  }
}
/******************************************************************************/
void can_open(long ip, long mask, char id, char speed_us){
  //COPIAR VARIABLES
  can.ip = ip;
  can.mask = mask;
  can.ipAddress = ip + id;
  can.id = id;
  
  //Inicilizar variables
  can.conected = true;
  can.tx_status = 0;      //Estado cero por defecto
  can.txQueu = false;     //No ha encolado datos para transmitir
  can.rxBusy = false;     //No esta escuhando ningun mensaje
  
  can_set_operation(CAN_OPERATION_CONFIG);
  can_set_mode(CAN_MODE_LEGACY);
  can_set_baud(speed_us);
  //SETEAR LOS BUFFER DE RECEPCION
  RXB0CON = 0;
  RXB0CON.RXM0 = 0;  //RECIBE TODOS LOS MENSAJES VALIDOS, STANDAR Ó EXTENDED
  RXB0CON.RXM1 = 0;  //SEGUN EL BIT EXIDEN EN EL REGISTRO RXFnSIDL
  RXB0CON.RXB0DBEN = CAN_USE_DOUBLE_BUFFER;
  RXB1CON = 0;
  //ESTADO DE LOS PINES EN REPOSO
  CIOCON.ENDRHI = CAN_ENABLE_DRIVE_HIGH;
  CIOCON.CANCAP = CAN_ENABLE_CAPTURE;

  //CONFIGURAR MASKARAS Y FILTROS, MSEL ASOCIA EL FILTRO CON LA MASKARA
  can_set_id(&RXM0EIDL, mask);    //MASKARA 0, ACEPTA X ID
  can_set_id(&RXM1EIDL, mask);    //MASKARA 1, ACEPTA X ID
  //FILTROS
  can_set_id(&RXF0EIDL, can.ipAddress);  //FILTRO 0 ASOCIADO CON LA MASKARA 0
  can_set_id(&RXF1EIDL, can.ipAddress);  //FILTRO 1 ASOCIADO CON LA MASKARA 0
  can_set_id(&RXF2EIDL, can.ipAddress);  //FILTRO 2 ASOCIADO CON LA MASKARA 1
  can_set_id(&RXF3EIDL, can.ipAddress);  //FILTRO 3 ASOCIADO CON LA MASKARA 1
  can_set_id(&RXF4EIDL, can.ipAddress);  //FILTRO 4 ASOCIADO CON LA MASKARA 1
  can_set_id(&RXF5EIDL, can.ipAddress);  //FILTRO 5 ASOCIADO CON LA MASKARA 1
  //CONFIGURACION DE FILTROS DINAMICOS, MODO 1 Y 2
  can_set_id(&RXF6EIDL, 0);       //FILTRO 6
  can_set_id(&RXF7EIDL, 0);       //FILTRO 7
  can_set_id(&RXF8EIDL, 0);       //FILTRO 8
  can_set_id(&RXF9EIDL, 0);       //FILTRO 9
  can_set_id(&RXF10EIDL, 0);      //FILTRO 10
  can_set_id(&RXF11EIDL, 0);      //FILTRO 11
  can_set_id(&RXF12EIDL, 0);      //FILTRO 12
  can_set_id(&RXF13EIDL, 0);      //FILTRO 13
  can_set_id(&RXF14EIDL, 0);      //FILTRO 14
  can_set_id(&RXF15EIDL, 0);      //FILTRO 15
  
  //LOS FILTROS SE PUEDEN ASOCIAR CON LOS ESCUCHAS/RECEPTORES. MODO 1 Y 2
  //LOS FILTROS SE PUEDEN ASOCIAR A LAS MASKARAS 0,1,FILTRO15. MODO 1 Y 2
  //LOS FILTROS PUEDEN SER ACTIVADOS O DESACTIVADOS. MODO 1 Y 2
  //"RXFCONn, SDFLC, RXFBCONn"
  
  //CONFIGURAR PINES
  TRISB.B2 = 0;  //CANAL TX
  TRISB.B3 = 1;  //CANAL RX
  
  //MODO NORMAL DE OPERACION
  can_set_operation(CAN_OPERATION_NORMAL);
}
/******************************************************************************/
void can_set_baud(unsigned int speed_us){
  char Tqp, pre;
  /*
    ECUACION: Tq(us) = speed(us)/Tqp
           Tqp = Tq permisible por datasheet Tqp = [8-25]
    ECUACION: Tq = 2*(BRP+1)/Fosc
    ECUACION: SYNC[1] + PROPSEG[1-8] + PHSEG1[1-8] >= PHSEG2[1-8]
    ECUACION: PHSEG2 >= SWJ
    ECUACION: bitTime = TQ*(SYNC[1] + PROPSEG[1-8] + PHSEG1[1-8] + PHSEG2[1-8])
    ECUACION TbitTime = 1/bitTimE
  */

  //Encontramos el valor de Tqp
  speed_us *= Clock_MHz();
  speed_us /= 2;
  for(Tqp = 25; Tqp >= 8; Tqp--){
    if(speed_us % Tqp == 0){
      pre = speed_us/Tqp;
      if(pre >= 1 && pre <= 64){
        //Rellenar el valor del oscilador
        BRGCON1 = --pre;            //Bit menos significativo
        BRGCON1.SJW0 = CAN_SYNC_JUMP_WIDTH.B0;
        BRGCON1.SJW1 = CAN_SYNC_JUMP_WIDTH.B1;
        Tqp--;                       //Restar 1Tq por SYNC
        break;
      }
    }
  }
  //Llenar los valores deseables, divir Tqp para SEG1, SEG2 y PROPRAGACION
  for(pre = 16; pre >= 2; pre -= 2){
    if(Tqp > pre){
      pre >>= 1; //DIVIDE SOBRE DOS
      pre--;     //AJUSTAR VALORES DE 0-7
      //ESTABLCER PHASE 1
      BRGCON2.SEG2PHTS = 1;      //PHASE 2 PROGRAMABLE
      BRGCON2.SAM = CAN_SAMPLE_THRICE_TIMES.B0;
      BRGCON2.SEG1PH0 = pre.B0;
      BRGCON2.SEG1PH1 = pre.B1;
      BRGCON2.SEG1PH2 = pre.B2;
      //ESTABLECER PHASE 2
      BRGCON3.WAKDIS = !CAN_WAKE_UP_IN_ACTIVITY;
      BRGCON3.WAKFIL = CAN_LINE_FILTER_ON;
      BRGCON3.SEG2PH0 = pre.B0;
      BRGCON3.SEG2PH1 = pre.B1;
      BRGCON3.SEG2PH2 = pre.B2;
      //PROGRAMAR PROPAGACION
      pre = Tqp - 2*(pre+1);  //Obtener el resto de Tq
      pre--;                  //Ajustar de 0-7
      BRGCON2.PRSEG0 = pre.B0;
      BRGCON2.PRSEG1 = pre.B1;
      BRGCON2.PRSEG2 = pre.B2;
      break;
    }
  }
}
/******************************************************************************/
char can_read(long *id, char *datos, char *size){
  char *receptor, *regLen, *buffer, *bufferBX;
  char ref;  //Auxiliar

  //Encontramos si algun buffer esta lleno
  if(RXB0CON.RXFUL){  //Mensaje en buffer
    bufferBX = &RXB0CON;
    regLen = &RXB0DLC;
    receptor = &RXB0EIDL;
    buffer = &RXB0D0;
    ref = can.mode == CAN_MODE_LEGACY? 0x00:0x10;
    can.overflow = COMSTAT.RXB0OVFL;
    COMSTAT.RXB0OVFL = 0;  //Limpiar sobreflujo
    
    if(can.mode == CAN_MODE_LEGACY)
      can.numFilter = RXB0CON.FILHIT0;
    else
      can.numFilter = RXB0CON & 0x1F;
  }else if(RXB1CON.RXFUL){  //Mensaje en buffer
    bufferBX = &RXB1CON;
    regLen = &RXB0DLC;
    receptor = &RXB1EIDL;
    buffer = &RXB1D0;
    ref = can.mode == CAN_MODE_LEGACY? 0x0A:0x10;          //CHECAR POR EL MODO
    ref |= can.mode == CAN_MODE_ENHANCED_LEGACY? 0x01:0x00;
    can.overflow = COMSTAT.RXB1OVFL;
    COMSTAT.RXB1OVFL = 0;  //Limpiar sobreflujo
    if(can.mode == CAN_MODE_LEGACY)
      can.numFilter = RXB0CON.RXB0DBEN? RXB1CON&0x07: -1;
    else
      can.numFilter = RXB1CON & 0x1F;
  }else if(can.mode == CAN_MODE_LEGACY){
    return CAN_RW_EMPTY;  //No se recibio nada
  }

  //MODO LEGACY
  if(can.mode == CAN_MODE_LEGACY){
    CANCON &= 0xF1;
    CANCON |= ref;   //BITS WIN
  }else{   //MODO 1 Y 2
    //Preguntar por el resto de los recceptores  B0CONR.rxful && !BSEL0.b0txen
    if(!BSEL0.B0TXEN && B0CON.RXFUL){
      bufferBX = &B0CON;
      regLen = &B0DLC;
      receptor = &B0EIDL;
      buffer = &B0D0;
      can.overflow = COMSTAT.RXB0OVFL;
      COMSTAT.RXB0OVFL = 0;  //Limpiar sobreflujo
      can.numFilter = B0CON & 0x1F;
      ref = 0x12;
    }else if(!BSEL0.B1TXEN && B1CON.RXFUL){
      bufferBX = &B1CON;
      regLen = &B1DLC;
      receptor = &B1EIDL;
      buffer = &B1D0;
      can.overflow = COMSTAT.RXB0OVFL;
      COMSTAT.RXB0OVFL = 0;  //Limpiar sobreflujo
      can.numFilter = B1CON & 0x1F;
      ref = 0x13;
    }else if(!BSEL0.B2TXEN && B2CON.RXFUL){
      bufferBX = &B2CON;
      regLen = &B2DLC;
      receptor = &B2EIDL;
      buffer = &B2D0;
      can.overflow = COMSTAT.RXB0OVFL;
      COMSTAT.RXB0OVFL = 0;  //Limpiar sobreflujo
      can.numFilter = B2CON & 0x1F;
      ref = 0x14;
    }else if(!BSEL0.B3TXEN && B3CON.RXFUL){
      bufferBX = &B3CON;
      regLen = &B3DLC;
      receptor = &B3EIDL;
      buffer = &B3D0;
      can.overflow = COMSTAT.RXB0OVFL;
      COMSTAT.RXB0OVFL = 0;  //Limpiar sobreflujo
      can.numFilter = B3CON & 0x1F;
      ref = 0x15;
    }else if(!BSEL0.B4TXEN && B4CON.RXFUL){
      bufferBX = &B4CON;
      regLen = &B4DLC;
      receptor = &B4EIDL;
      buffer = &B4D0;
      can.overflow = COMSTAT.RXB0OVFL;
      COMSTAT.RXB0OVFL = 0;  //Limpiar sobreflujo
      can.numFilter = B4CON & 0x1F;
      ref = 0x16;
    }else if(!BSEL0.B5TXEN && B5CON.RXFUL){
      bufferBX = &B5CON;
      regLen = &B5DLC;
      receptor = &B5EIDL;
      buffer = &B5D0;
      can.overflow = COMSTAT.RXB0OVFL;
      COMSTAT.RXB0OVFL = 0;  //Limpiar sobreflujo
      can.numFilter = B5CON & 0x1F;
      ref = 0x17;
    }else{
      return CAN_RW_EMPTY;
    }
    //ESTABLECER EL TRANSMISOR
    ECANCON &= 0xE0;
    ECANCON |= ref;     //BITS EWIN
  }

  //RECEPCION DE LOS DATOS
  *size = (*regLen)&0x0F;
  can.rxRequest = (*regLen).B6;
  //OBTENER EL ID
  *id = can_get_id(receptor);
  //OBTENER LOS DATOS
  for(ref = 0; ref < *size && ref < 8; ref++)
    datos[ref] = buffer[ref];

  //LIMPIAR BANDERA DE RXFUL
  (*bufferBX).B7 = 0;    //RESETEAR BANDERA

  //LIMPIAR BIT DE INTERRUPCION
  if(bufferBX == &RXB0CON)
    PIR3.RXB0IF = 0;     //VERIFICAR EN MODO 2
  else if(bufferBX == &RXB1CON)
    PIR3.RXB1IF = 0;     //EN MODO 0, LIMPIA BUFFER BX1
  else
    PIR3.RXB1IF = 0;     //MODO 1 y 2, ESTE BIT SIRVE PARA N BUFFERS

  //CAMBIAR AL MODO RECEPTOR DEL BUFFER CERO
  if(can.mode == CAN_MODE_LEGACY){
    CANCON &= 0xF1;
    CANCON |= 0x00;   //BITS WIN, LISTEN BUFFER0
  }else{
    ECANCON &= 0xE0;
    ECANCON |= 0x16;  //BITS EWIN, RX0 INTERRUPT
  }

  if(!can.rxRequest)
    return CAN_RW_DATA;      //Datos en buffer
  else
   return CAN_RW_REQUEST;    //Peticion solicitada
}
/******************************************************************************/
bool can_write(long id, char *datos, char size, char priority, bool rtr){
  //regLen regsitro que en envia rtr y numero de bytes a ser enviados
  char *transmisor, *mascara, *regLen, *buffer;
  char ref;  //Auxiliar
  
  //ENCONTRAR TRANSMISOR LIBRE, MODO LEGACY
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
    return false;  //No encontro a nadie para enviar en modo legacy
  }
  
  if(can.mode == CAN_MODE_LEGACY){
    //ESTABLECER EL TRANSMISOR
    CANCON &= 0xF1;
    CANCON |= ref;   //BITS WIN
  }else{  //MODO 1 Y 2
    //Preguntar por el resto de los transmisores
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
      return false;
    }
    //ESTABLECER EL TRANSMISOR
    ECANCON &= 0xE0;
    ECANCON |= ref;     //BITS EWIN
  }

  //ESTABLECER PRIORIDAD
  (*transmisor).B0 = priority.B0;  //BIT TXPRI0
  (*transmisor).B1 = priority.B1;  //BIT TXPRI1
  //ESTABLECER TX MASCARA
  can_set_id(mascara, id);
  //ESTABLECER LOS BYTES A ENVIAR MAXIMO 8
  *regLen = size;
  (*regLen).B6 = rtr; //TXRTR Solicitud remota del receptor
  //LLENAR EL BUFFER
  for(ref = 0; ref < size && ref < 8; ref++)
    buffer[ref] = datos[ref];
  //DISPONIBLE INTERRUPCION
  (*transmisor).B3 = 1;  //ACTIVAR PIN TXREQ, LIMPIA BANDERAS TXABT, TXLARB y TXERR
  
  //CAMBIAR AL MODO RECEPTOR DEL BUFFER CERO
  if(can.mode == CAN_MODE_LEGACY){
    CANCON &= 0xF1;
    CANCON |= 0x00;   //BITS WIN, LISTEN BUFFER0
  }else{
    ECANCON &= 0xE0;
    ECANCON |= 0x16;  //BITS EWIN, RX0 INTERRUPT
  }
  
  return true;
}
/******************************************************************************/
void can_set_operation(const char CAN_OPERATION){
  CANCON.REQOP0 = CAN_OPERATION.B0;
  CANCON.REQOP1 = CAN_OPERATION.B1;
  CANCON.REQOP2 = CAN_OPERATION.B2;

  while(CANSTAT.OPMODE0 != CANCON.REQOP0 ||
        CANSTAT.OPMODE1 != CANCON.REQOP1 ||
        CANSTAT.OPMODE2 != CANCON.REQOP2);
}
/******************************************************************************/
void can_set_mode(const char CAN_MODE){
  char modeAct = 0;
  //Respaldar modo operacion
  modeAct.B0 = CANSTAT.OPMODE0;
  modeAct.B1 = CANSTAT.OPMODE1;
  modeAct.B2 = CANSTAT.OPMODE2;
  //Configurar la modalidad
  can_set_operation(CAN_OPERATION_CONFIG);  //Se debe poner se en modo config
  ECANCON.MDSEL0 = CAN_MODE.B0;
  ECANCON.MDSEL1 = CAN_MODE.B1;
  can_set_operation(modeAct);
  can.mode = CAN_MODE;
}
/******************************************************************************/
void can_set_id(char *address, long value){
  //CONFIGURA LOS REGISTROS xxxxEIDL, xxxxEIDH, xxxxSIDL and xxxxSIDH
  if(CAN_FORMAT_EXTENDED){
    address[0] = getByte(value, 0);        //EIDL
    address[-1] = getByte(value, 1);        //EIDh
    address[-2] = getByte(value, 2) & 0x03; //SIDL, BITS 16,17
    address[-2].B3 = 1;   //ACEPT MESSAGE SEGUN EL FORMATO STAND Ó EXT
    value <<= 3;         //RECORRE TRES POSIONES A LA IZQUIERDA
    address[-2] |= getByte(value, 2) & 0xE0;//SIDL, BITS 18,19,20
    address[-3] = getByte(value, 3);        //SIDH 21-27
  }else{
    address[0] = 0;                        //EIDL
    address[-1] = 0;                        //EIDh
    address[-2] = 0x80;   //ACEPT MESSAGE SEGUN EL FORMATO STAND Ó EXT
    address[-2].B5 = getByte(value, 0).B0;  //SIDL
    address[-2].B6 = getByte(value, 0).B1;  //SIDL
    address[-2].B7 = getByte(value, 0).B2;  //SIDL
    value >>= 3;         //RECORRE TRES POSIONES A LA IZQUIERDA
    address[-3] = getByte(value, 0);        //SIDH 21-27
  }
}
/******************************************************************************/
long can_get_id(char *address){
  long value = 0;
  
  if(CAN_FORMAT_EXTENDED){
    getByte(value,0) = address[0];        //EIDL
    getByte(value,1) = address[-1];        //EIDh
    getByte(value,2) = address[-2] & 0x03; //SIDL, BITS 16,17
    getByte(value,2).B2 = address[-2].B5;  //SIDL, BITS 18
    getByte(value,2).B3 = address[-2].B6;  //SIDL, BITS 19
    getByte(value,2).B4 = address[-2].B7;  //SIDL, BITS 20
    getByte(value,2).B5 = address[-3].B0;
    getByte(value,2).B6 = address[-3].B1;
    getByte(value,2).B7 = address[-3].B2;
    getByte(value,3) = address[-3]>>3;     //SIDH
  }else{
    getByte(value,0).B0 = address[-2].B5;  //SIDL, BITS 18
    getByte(value,0).B1 = address[-2].B6;  //SIDL, BITS 19
    getByte(value,0).B2 = address[-2].B7;  //SIDL, BITS 20
    getByte(value,0) |= address[-3]<<3;
    getByte(value,1).B0 = address[-3].B5;
    getByte(value,1).B1 = address[-3].B6;
    getByte(value,1).B2 = address[-3].B7;
  }
  
  return value;
}
/******************************************************************************/
void can_abort(bool enable){
  CANCON.ABAT = enable;
}
/******************************************************************************/
void can_interrupt(bool enable, bool hihgPriprity){
  //LIMPIAR BANDERAS
  //PIR3.ERRIF = 0;  //Multiples causas de error buffer, usar a conciencia interrupt
  PIR3.TXB0IF = 0;
  PIR3.TXB1IF = 0;
  PIR3.TXBnIF = 0;
  //PRIORIDAD DE INTERRUPCION
  //IPR3.ERRIP = hihgPriprity;
  IPR3.TXB0IP = hihgPriprity;
  IPR3.TXB1IP = hihgPriprity;
  IPR3.TXBnIP = hihgPriprity;
  //DISPONIBILIDAD
  //PIE3.ERRIE = enable;
  PIE3.TXB0IE = enable;
  PIE3.TXB1IE = enable;
  PIE3.TXBnIE = enable;
  //REGISTRO DE INT TXBX  MODO 1 Y 2
  /*
  TXBIE.TXB0IE = 1;
  TXBIE.TXB1IE = 1;
  TXBIE.TXB2IE = 1;
  */
}
/******************************************************************************/
void can_desonexion(){
  if(can.conected){
    if(TXB0CON.TXERR || TXB1CON.TXERR || TXB2CON.TXERR){
      if(TXB0CON.TXERR) //!TXB0CON.TXABT
        TXB0CON.TXREQ = 1;  //CANCELA ENVIO
      if(TXB1CON.TXERR) //!TXB1CON.TXABT
        TXB1CON.TXREQ = 1;  //CANCELA ENVIO
      if(TXB2CON.TXERR) //!TXB2CON.TXABT
        TXB2CON.TXREQ = 1;  //CANCELA ENVIO
      can.conected = false;
    }
  }
}
/******************************************************************************/
void can_do_work(){
  can_do_read_message();
  can_do_write_message();
  can_desonexion();
}
/******************************************************************************/
void int_can(){
  /*
  //SI RECIBIO MULTIPLES ERRORES RESETA PIC
  if(PIE3.ERRIE && PIR3.ERRIF){
    PIR3.ERRIF = false;
  }
  */
  //SI HUBO ENVIO DE DATOS
  if(PIE3.TXB0IE && PIR3.TXB0IF){
    can.conected.B0 = true;
    PIR3.TXB0IF = 0;
  }
  if(PIE3.TXB1IE && PIR3.TXB1IF){
    can.conected.B0 = true;
    PIR3.TXB1IF = 0;
  }
  if(PIE3.TXBnIE && PIR3.TXBnIF){
    can.conected.B0 = true;
    PIR3.TXBnIF = 0;
  }
}
/******************************************************************************/










/******************************************************************************
void can_program_buffer(char CAN_BUFFER_PROG, bool transmitter){
  //SOLO DISPONIBLE EN MODO 1 y 2
  if(transmitter)
    BSEL0 |= CAN_BUFFER_PROG;
  else
    BSEL0 &= ~CAN_BUFFER_PROG;
}
******************************************************************************
void can_filter(unsigned int CAN_FILTER_PROG, bool enable){
  //RESPALDAR ULTIMO ESTADO, NOTA: SOLO DISPONIBLE EN MODO 1 Y 2, modo operacion***
  if(enable){
    RXFCON0 |= getByte(CAN_FILTER_PROG,0);
    RXFCON1 |= getByte(CAN_FILTER_PROG,1);
  }else{
    RXFCON0 &= ~getByte(CAN_FILTER_PROG,0);
    RXFCON1 &= ~getByte(CAN_FILTER_PROG,1);
  }
}
******************************************************************************
void can_filter_associate(char CAN_FILTER_NUM, char bufferDestino){
  //CAN_FILTER_NUM: Rango[0-7] para asociar RX0,RX1,B0-B5
  //bufferDestino: RX0,RX1,B0-B5
  char *pointer = &RXFBCON0;

  pointer = pointer+CAN_FILTER_NUM;
  *pointer = bufferDestino;
}
******************************************************************************/
#endif


/*
Programar funcion que envie por n buffer la data


////////////////////////////////////////////////////////////////////////////////
//
// can_associate_filter_to_mask
//
//   Associates a given filter to a given mask
//
//   Parameters:
//      mask - the mask that is to be associated with the filter
//         enumerated as
//            ACCEPTANCE_MASK_0
//            ACCEPTANCE_MASK_1
//            FILTER_15
//            NO_MASK
//
//      filter - the filter that is to be associated with the mask
//         enumerated as
//               F0BP-F15BP - Filters 0 - 15
//
//
//   Returns:
//      void
//
// More information can be found on Acceptance Filters in the PIC18F4580
// datasheet, Section 23.8
//
////////////////////////////////////////////////////////////////////////////////
void can_associate_filter_to_mask(CAN_MASK_FILTER_ASSOCIATE mask, CAN_FILTER_ASSOCIATION filter)
{
   unsigned int *ptr;

   curmode = CANSTAT.opmode;

   can_set_mode(CAN_OP_CONFIG);

   ptr=(filter>>2)|0x0DF0;

   if((filter & 0x03)==0)
   {
      *ptr&=0xfc;
      *ptr|=mask;
   }
   else if((filter & 0x03)==1)
   {
      *ptr&=0xf3;
      *ptr|=mask<<2;
   }
   else if((filter & 0x03)==2)
   {
      *ptr&=0xcf;
      *ptr|=mask<<4;
   }
   else if((filter & 0x03)==3)
   {
      *ptr&=0x3f;
      *ptr|=mask<<6;
   }

   can_set_mode(curmode);
}

////////////////////////////////////////////////////////////////////////////////
//
// can_FIFO_getd
//
// Retrieves data in Mode 2
//
// Parameters:
//      id - The ID of the sender
//      data - Address of the array to store the data in
//      len - number of data bytes to read
//      stat - status structure to return information about the receive register
//
// Returns:
//      int1 - TRUE if there was data in the buffer, FALSE if there wasn't
//
// More information can be found on the FIFO mode in the PIC18F4580 datasheet
// section 23.7.3
//
////////////////////////////////////////////////////////////////////////////////
int1 can_fifo_getd(unsigned int32 &id, unsigned int *data, unsigned int &len, struct rx_stat &stat )
{

   unsigned int i;
   unsigned int *ptr;

   if(!COMSTAT_MODE_2.fifoempty)          // if there is no data in the buffer
      return(0);                          // return false;

   ECANCON.ewin=CANCON_MODE_2.fp | 0x10;
   stat.buffer=CANCON_MODE_2.fp;

   //CAN_INT_RXB1IF=0;                    // moved to end of function

   stat.err_ovfl=COMSTAT_MODE_2.rxnovfl;
   COMSTAT_MODE_2.rxnovfl = 0;
   stat.filthit=RXB0CON_MODE_2.filthit;

   len = RXBaDLC.dlc;
   stat.rtr=RXBaDLC.rtr;

   stat.ext=TXRXBaSIDL.ext;
   id=can_get_id((int8 *)TXRXBaID,stat.ext);

   ptr = &TXRXBaD0;
   for ( i = 0; i < len; i++ ) {
       *data = *ptr;
       data++;
       ptr++;
   }

   RXB0CON_MODE_2.rxful=0;

   CAN_INT_RXB1IF=0;

   // return to default addressing
   ECANCON.ewin=RX0;

   stat.inv=CAN_INT_IRXIF;
   CAN_INT_IRXIF = 0;

   return(1);
}

////////////////////////////////////////////////////////////////////////////////
//
// can_t0_putd - can_t2_putd
// can_b0_putd - can_b5_putd
//
// places data to be transferred in a specified buffer
//
// Parameters:
//      id - id that will be sent with the data
//    data - pointer to the data
//      len - number of data bytes (0-8)
//      pri - priority (0-3)
//      ext - extended or not
//    rtr - request remote transfer
//
// Returns:
//      TRUE if data is successfully loaded into the buffer
//      FALSE if data can not be loaded into the buffer
//
//   Notes
//      - make sure that the desired buffer is set to be a transfer buffer
//        using the can_enable_b_transfer ( ) function
//
// More information can be found on using the transfer buffers in the PICF4580
//   datasheet section 23.6
//
////////////////////////////////////////////////////////////////////////////////

// transfer buffer 0
int1 can_t0_putd(unsigned int32 id, unsigned int *data, unsigned int len, unsigned int pri, int1 ext, int1 rtr)
{
   unsigned int *ptr;

   if(TXB0CON.txreq)
      return ( FALSE );

   can_set_id( (int8 *)TXB0ID, id, ext );

   TXB0DLC.dlc = len;

   TXB0CON.txpri = pri;

   TXB0DLC.rtr = rtr;

   ptr = &TXB0D0;

   for(;len>0;len--)
   {
      *ptr = *data;
      ptr++;
      data++;
   }

   TXB0CON.txreq = 1;

   return ( TRUE );
}
*/