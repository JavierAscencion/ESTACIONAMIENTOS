//static DNSServer DNS;

//////////////////////////////////////////////////////////////////////
//INTERRUPCIONES
volatile int interruptCounter;
int totalInterruptCounter;
 
hw_timer_t * timer = NULL;
portMUX_TYPE timerMux = portMUX_INITIALIZER_UNLOCKED;


static std::vector<AsyncClient*> clients; // a list to hold all clients

//int status;     // the Wifi radio's status

//const char* ssid        = "RED ACCESA";
//const char* password    = "037E32E7";

bool eventoTimerTcpPic = false;

Ticker tickerTcpPic;


AsyncHTTPRequest request;
Ticker ticker;
Ticker ticker1;

//Async Request
AsyncHTTPRequest ActualRequest;
AsyncHTTPRequest ConfirmRequest;
//AsyncHTTPRequest GetDataNubeRequest;
//AsyncHTTPRequest LogRequest;

String DatosNuevos ="";

ESP32Time rtc;

//iniciamos el cliente udp para su uso con el server NTP
WiFiUDP ntpUDP;

//NTPClient timeClient(ntpUDP, "north-america.pool.ntp.org",-10800,6000);  //0.mx.pool.ntp.org  //0.central-america.pool.ntp.org
NTPClient timeClient(ntpUDP, "north-america.pool.ntp.org",-18000,6000);  //0.mx.pool.ntp.org  //0.central-america.pool.ntp.org

String option = "";
//char option[] = "";
String DatoCorrectoPicAnterior="";
char Buf[50];
int comandopic=0;
//char datoLeidoEeprom[50];

//char ssid[9] = "loquesea";
//char ssid_guardada[9];

//String urlapi="http://192.168.1.221:8080/api/tutorials";
char urlapi[] = "http://192.168.1.221:8080/api/tutorials";

   
