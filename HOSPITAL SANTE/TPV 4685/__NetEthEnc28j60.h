typedef struct {
  char remoteIP[4];       // Remote IP address
  char remoteMAC[6];      // Remote MAC address
  unsigned int remotePort;// Remote TCP port
  unsigned int destPort;  // Destination TCP port
  unsigned int dataLength;// Current TCP payload size
  unsigned int broadcastMark;// =0 -> Not broadcast;

                             //=1 ->  Broadcast
} UDP_28j60_Dsc;

typedef struct {
char remoteIP[4];        // Remote IP address
char remoteMAC[6];       // Remote MAC address
unsigned int remotePort; // Remote TCP port
unsigned int  destPort;  // Dest. TCP port

unsigned int  dataLength;// TCP payload size
unsigned int  remoteMSS; // Remote MSS
unsigned int  myWin;     // My Window
unsigned int  myMSS;     // My Max Segment Size
unsigned long mySeq;     // My Current sequence
unsigned long myACK;     // ACK
char stateTimer;         // State timer
char retransmitTimer;    // Retransmit timer
unsigned int packetID;   // ID of packet
char open;               // =0 -> Socket free;
                         //=1 -> Socket busy
char ID;                 // ID of socket
char broadcastMark;
char state;         // State table:
                    // 0 - Connection closed
                    // 1 - Wait ACK on SYN
                    // 3 - Conn. established
                    // 4 - SYN response wait
                    // 5 - FIN segment sent
                    // 6 - Wait on remote FIN
                    // 7 - Retransmit packet.

// Buffer.................//
unsigned int nextSend;    //
unsigned int lastACK;     //
unsigned int lastSent;    //
unsigned int lastWritten; //
unsigned int numToSend;   //
char         buffState;   //
char        *txBuffer;    //
//........................//

}
SOCKET_28j60_Dsc;

//Predefiniciones
void Net_Ethernet_28j60_UserTCP(SOCKET_28j60_Dsc *socket);