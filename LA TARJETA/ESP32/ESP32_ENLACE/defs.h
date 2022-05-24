#ifndef CONFIG_H
#define CONFIG_H

#if !( defined(ESP8266) ||  defined(ESP32) )
  #error This code is intended to run on the ESP8266 or ESP32 platform! Please check your Tools->Board setting.
#endif

// Level from 0-4
#define ASYNC_HTTP_DEBUG_PORT     Serial
#define _ASYNC_HTTP_LOGLEVEL_     1    

// 300s = 5 minutes to not flooding
#define HTTP_REQUEST_INTERVAL    1  //300

// 10s
#define HEARTBEAT_INTERVAL        10


#define SSID "RED ACCESA"
#define PASSWORD "037E32E7"

#define SERVER_HOST_NAME "esp_server"

#define TCP_PORT 132
#define DNS_PORT 53

#define ASYNC_HTTP_REQUEST_GENERIC_VERSION_MIN_TARGET      "AsyncHTTPRequest_Generic v1.7.0"
#define ASYNC_HTTP_REQUEST_GENERIC_VERSION_MIN             1007000

#endif // CONFIG_H

// 10s
#define INTERVAL_TCP_PIC        1

#define EEPROM_SIZE 50



struct Monitorserialesp32
   {  String Get ;       // Nombre del modelo
      String Post ;      // Numero de pines digitales
      String Put ;       // Numero de pines analogicos
      String Delete ;    // Tension de funcionamiento
      String Time;
      String EventosTimer;
   } ;

Monitorserialesp32  DebugESP;
