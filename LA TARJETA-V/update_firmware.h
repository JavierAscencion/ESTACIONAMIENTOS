/*
  To upload through terminal you can use: curl -F "image=@firmware.bin" esp32-webupdate.local/update
*/
/*
#include <WebServer.h>
#include <ESPmDNS.h>
#include <HTTPUpdateServer.h>

const char* host = "esp32-webupdate";

WebServer httpServer(80);
HTTPUpdateServer httpUpdater;
*/
#define MDASH_APP_NAME "EnlaceBD-LaTarjeta_v1.0"
#include <mDash.h>
#define DEVICE_PASSWORD "6lEERwl3CJkndlrZB91rcAQ"

///////////////////cli monitor /////////////////////////////////////////////
//static void initWiFi(const char *ssid, const char *pass) {
//  if (ssid != NULL) WiFi.begin((char *) ssid, pass);  // WiFi is configured
//  if (ssid == NULL) WiFi.softAP("CliAP", pass);  // Not configured, start AP
//}
/////////////////////////////////////////////////////////////////////////////
