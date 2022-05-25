//*************************************************************************************************************
#if (ESP8266)
  #include <ESP8266WiFi.h>
#elif (ESP32)
  #include <WiFi.h>
#endif
// To be included only in main(), .ino with setup() to avoid `Multiple Definitions` Linker Error
#include <AsyncHTTPRequest_Generic.h>             // https://github.com/khoih-prog/AsyncHTTPRequest_Generic
#include <Ticker.h>
#include <AsyncTCP.h>
//#include <DNSServer.h>
#include <vector>
#include <ArduinoJson.h>
#include <ESP32Time.h>
#include <NTPClient.h> //importamos la librería del cliente NTP
#include <WiFiUdp.h> // importamos librería UDP para comunicar con NTP
//#include <Ticker.h>
#include <EEPROM.h>
                     
