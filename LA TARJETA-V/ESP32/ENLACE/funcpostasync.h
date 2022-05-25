void heartBeatPrint()
{
  static int num = 1;
  String now = rtc.getTime("%A, %B %d %Y %H:%M:%S");

  int segundos = rtc.getSecond();
  int minutos = rtc.getMinute();

  int hora = rtc.getHour();
  String horario = rtc.getAmPm();

  int hora_24 = rtc.getHour(true);

  int dia = rtc.getDay();
  int mes = rtc.getMonth();
  int year = rtc.getYear();

  //Serial.println(now);

  timeClient.update(); //sincronizamos con el server NTP

  if(DebugESP.Time == "time on"){
  Serial.println(timeClient.getFormattedDate(0));
  socketio_monitor(timeClient.getFormattedDate(0));
  }
//Imprimimos por puerto serie la hora actual
/*
  if (WiFi.status() == WL_CONNECTED)
    Serial.print(F("H"));        // H means connected to WiFi
  else
   // Serial.print(F("F"));        // F means not connected to WiFi

  if (num == 80)
  {
   // Serial.println();
    num = 1;
  }
  else if (num++ % 10 == 0)
  {
   // Serial.print(F(" "));
  }
  */
}

void sendRequest() 
{
  static bool requestOpenResult;

  if(DebugESP.Get=="get on"){
      Serial.println("GET->");
      socketio_monitor("GET->");
  //Serial.println();
  }

  
  if (request.readyState() == readyStateUnsent || request.readyState() == readyStateDone)
  {
    //requestOpenResult = request.open("GET","http://192.168.1.221:8080/api/tutorials");
    requestOpenResult = request.open("GET",urlapi);
    
    if (requestOpenResult)
    {
      // Only send() if open() returns true, or crash
      request.send();
    }
    else
    {
      Serial.println(F("Can't send bad request GET"));
      socketio_monitor("Can't send bad request GET");
    }
  }
  else
  {
    Serial.println(F("Can't send request GET"));
    socketio_monitor("Can't send request GET");
  }
}

void requestCB(void* optParm, AsyncHTTPRequest* request, int readyState) 
{
  (void) optParm;
  
  if (readyState == readyStateDone) 
  {

     DatosNuevos = request->responseText();
     if(DebugESP.Get=="get on"){
       Serial.println("REQ.GET<-");
       socketio_monitor("REQ.GET<-");
       Serial.println(DatosNuevos);
       socketio_monitor(DatosNuevos);
       Serial.println("<");
       socketio_monitor("<");
     }
   
    
    request->setDebug(false);
  }
}


void sendActualRequest(String message) {
  static bool requestOpenResult;

  if(DebugESP.Post == "post on"){
    Serial.println("POST->");
    socketio_monitor("POST->");
    Serial.println(message);
    socketio_monitor(message);
  }
  
  
  if (ActualRequest.readyState() == readyStateUnsent || ActualRequest.readyState() == readyStateDone)
  {
    requestOpenResult = ActualRequest.open("POST","http://192.168.1.221:8080/api/tutorials");
    ActualRequest.setReqHeader("content-type","application/json");

    
    if (requestOpenResult)
    {
      // Only send() if open() returns true, or crash
     // Serial.println("se envia solicitud POST: ");
     // Serial.println(message);
      ActualRequest.send(message);
    }
    else
    {
      Serial.println(F("Can't send bad request POST"));
      socketio_monitor("Can't send bad request POST");
    }
  }
  else
  {
    Serial.println(F("Can't send request POST"));
    socketio_monitor("Can't send request POST");
  }
}

void ActualCB(void* optParm, AsyncHTTPRequest* request, int readyState) 
{
  (void) optParm;
  
  if (readyState == readyStateDone) 
  {
    if(DebugESP.Post == "post on"){
     Serial.println("REQ.POST<-");
     socketio_monitor("REQ.POST<-");
    Serial.println(request->responseText());
    socketio_monitor(request->responseText());
    Serial.println("<"); 
    socketio_monitor("<");
    }
    
    
    request->setDebug(false);
  }
}

void sendConfirmRequest(String message) {
  static bool requestOpenResult;

  if(DebugESP.Put == "put on"){
    Serial.println("PUT->");
    socketio_monitor("PUT->");
    Serial.println(message);
    socketio_monitor(message);
  }

  
  
  if (ConfirmRequest.readyState() == readyStateUnsent || ConfirmRequest.readyState() == readyStateDone)
  {
    DynamicJsonDocument doc(1024);
    deserializeJson(doc, message);
    String idEvento = doc["id"].as<String>();
    //clima = dataJsonDes["weather"]["main"].as<String>();

    //Serial.println("Jon:<");
    //Serial.println(message);
    //Serial.println(">");
    //Serial.println("IdEvento:<");
    //Serial.println(idEvento);
    //Serial.println(">");
    
    //String idEvento = message.substring(6, 7);
    String urlserver = "http://192.168.1.221:8080/api/tutorials/";
    String urlserver_id = urlserver + idEvento;

    char sendurlid[150];
    urlserver_id.toCharArray(sendurlid, 150);
    
    //Serial.println("<");
    //Serial.println(idEvento);
    //Serial.println(">");
    requestOpenResult = ConfirmRequest.open("PUT",sendurlid);
    ConfirmRequest.setReqHeader("content-type","application/json");

    
    if (requestOpenResult)
    {
      // Only send() if open() returns true, or crash
      ConfirmRequest.send(message);
    }
    else
    {
      Serial.println(F("Can't send bad request PUT"));
      socketio_monitor("Can't send bad request PUT");
    }
  }
  else
  {
    Serial.println(F("Can't send request PUT"));
    socketio_monitor("Can't send request PUT");
  }
}

void ConfirmCB(void* optParm, AsyncHTTPRequest* request, int readyState) 
{
  (void) optParm;
  
  if (readyState == readyStateDone) 
  {
    if(DebugESP.Put == "put on"){
      Serial.println("REQ.PUT<-");
      socketio_monitor("REQ.PUT<-");
      Serial.println(request->responseText());
      socketio_monitor(request->responseText());
      Serial.println("<");
      socketio_monitor("<");
    }

    
    request->setDebug(false);
  }
}
