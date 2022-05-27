#include "config.h"
#include "update_firmware.h"
#include "config_wifi_esp32.h"
#include "socket-io-lib.h"
#include "defs.h"
#include "vars.h"
#include "interrupt.h"
#include "funcpostasync.h"
#include "functcpasync.h"
//#include "configuraciones.h"

void setup()
{
  Serial.begin(115200);
  while (!Serial)
    ;
  delay(200);
  EEPROM.begin(EEPROM_SIZE);
  // INICIALIZACIÓN DE TIMER

  timer = timerBegin(0, 80, true);
  timerAttachInterrupt(timer, &onTimer, true);
  timerAlarmWrite(timer, 1000000, true);
  timerAlarmEnable(timer);

  rtc.setTime(45, 21, 10, 11, 4, 2022);

  ///////////////// inicializaion para configuracion de wifi ///////////////////////////

  preferences.begin("wifi_access", false);

  if (!init_wifi())
  { // Connect to Wi-Fi fails
    SerialBT.register_callback(callback);
  }
  else
  {
    SerialBT.register_callback(callback_show_ip);
    bluetooth_disconnect = true;
  }
  SerialBT.begin(bluetooth_name);
  //
  while (bluetooth_disconnect == false)
  {
    configurar_wifi();
  }

 
  Serial.print("\nConnected to the WiFi network IP ESP32--0>:");
  Serial.println(WiFi.localIP());

  AsyncServer *server = new AsyncServer(TCP_PORT); // start listening on tcp port 132
  server->onClient(&handleNewClient, server);
  server->begin();

  Serial.print(F("Starting AsyncHTTPRequest_ESP using "));
  Serial.println(ARDUINO_BOARD);
  Serial.println(ASYNC_HTTP_REQUEST_GENERIC_VERSION);

  ////////////////////////////////socket.io//////////////////////////////////////////////////////
  // setup

  WiFiMulti.addAP(SSID, PASSWORD);

  // setReconnectInterval to 10s, new from v2.5.1 to avoid flooding server. Default is 0.5s
  socketIO.setReconnectInterval(10000);

  socketIO.setExtraHeaders("Authorization: 1234567890");

  // server address, port and URL
  // void begin(IPAddress host, uint16_t port, String url = "/socket.io/?EIO=4", String protocol = "arduino");
  // To use default EIO=4 from v2.5.1
  socketIO.begin(serverIP, serverPort);

  // event handler
  socketIO.onEvent(socketIOEvent);

  /////////////////////////////////////////////////////////////////////////////////////////////////

  /**************************NOMBRES PARA FUNCION DE ACTUALIZACION DE FIRMWARE*******************/
  mDashBegin(DEVICE_PASSWORD);
  Serial.println("Se inicio proceso de busqueda de firmware nuevo...");
  ///////////////////////////////////////////////////////////////////////////////////////////////

  timeClient.begin();

  // Serial.print(F("\nAsyncHTTPRequest @ IP : "));
  // Serial.println(WiFi.localIP());

  tickerTcpPic.attach(INTERVAL_TCP_PIC, eventosTcpPic);

  ticker.attach(HTTP_REQUEST_INTERVAL, sendRequest);
  ticker1.attach(HEARTBEAT_INTERVAL, heartBeatPrint);

  request.setDebug(true);
  request.onReadyStateChange(requestCB);
  // Configuracion solicitud asincrona
  ActualRequest.setDebug(true);
  ActualRequest.onReadyStateChange(ActualCB);
  /// confirmacion
  ConfirmRequest.setDebug(true);
  ConfirmRequest.onReadyStateChange(ConfirmCB);

  EEPROM.get(0, Buf); // recoge variable de la posicion 0 y la guarda en Buf
  DatoCorrectoPicAnterior = String(Buf);
  Serial.println("EEprom INI: " + DatoCorrectoPicAnterior);

  // Send first request now
  sendRequest();
}

void loop()
{
  socketIO.loop();
  /////////////////////////////////proceso para configurar wifi ////////////////////////////////

  if (bluetooth_disconnect)
  {
    disconnect_bluetooth();
  }
  if (comando_by_socketio)
  {
    Serial.println("COMANDO STATUS:" + comando_by_socketio);
    if (resultcommand == "CLEAR WIFI")
    {
      preferences.clear();
      Serial.println("DATOS DE WIFI BORRADOS");
      socketio_monitor("DATOS DE WIFI BORRADOS");
    }
    if (resultcommand == "RESTART")
    {
      Serial.println("Reinicio por software...");
      socketio_monitor("Reinicio por software...");
      ESP.restart();
    }
    if (result_command = resultcommand.indexOf('<') >= 0)
    {
      comandopic = true;
    }

    comando_by_socketio = 0;
  }

  //////////////////////////////////////////////////////////////////////////////////////////////

  if (Serial.available() != 0)
  {
    // while(option)
    //  option = Serial.read();
    option = Serial.readStringUntil('\n');
    ////////////////////////encender monitor serial///////////////////////////////////////
    if (option == "enable time")
    {
      DebugESP.Time = "time on";
      return;
    }
    else if (option == "enable get")
    {
      DebugESP.Get = "get on";
      return;
    }
    else if (option == "enable put")
    {
      DebugESP.Put = "put on";
      return;
    }
    else if (option == "enable post")
    {
      DebugESP.Post = "post on";
      return;
    }
    else if (option == "enable eventostimer")
    {
      DebugESP.EventosTimer = "eventostimer on";
      return;
    }
    ////////////////////////////////////////////////////////////////////////////////
    /////////////   apagar monitor serial /////////////////////////////////////////
    if (option == "time off")
    {
      DebugESP.Time = option;
      return;
    }
    else if (option == "get off")
    {
      DebugESP.Get = option;
      return;
    }
    else if (option == "put off")
    {
      DebugESP.Put = option;
      return;
    }
    else if (option == "post off")
    {
      DebugESP.Post = option;
      return;
    }
    else if (option == "eventostimer off")
    {
      DebugESP.EventosTimer = option;
      return;
    }
    //////////////////////////////////////////////////////////////////////////////////////
    else if (option == "off")
    {
      // default es optional
      option = "cancel";
      DebugESP.Time = option;
      DebugESP.Get = option;
      DebugESP.Put = option;
      DebugESP.Post = option;
      DebugESP.Delete = option;
      return;
    }
  }
}
