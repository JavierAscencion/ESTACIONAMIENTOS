/////////////////////////////////////////////////////////////////////

void eventosTcpPic()
{ 
  /*
  if (eventoTimerTcpPic){
    Serial.println("timer true.");
    eventoTimerTcpPic = false;
  }
  else{
    Serial.println("timer false");
    eventoTimerTcpPic = true;
  }
  */
  if(DebugESP.EventosTimer == "eventostimer on"){
    Serial.println("timer true.");
  }
   
   eventoTimerTcpPic = true;
    
}
////////////////////////guardar en eeprom/////////////////////////////////////////////////////////////
/*
void writeStringToEEPROM(int addrOffset, const String &strToWrite)
{
  byte len = strToWrite.length();
  EEPROM.write(addrOffset, len);
  for (int i = 0; i < len; i++)
  {
    EEPROM.write(addrOffset + 1 + i, strToWrite[i]);
  }
}

String readStringFromEEPROM(int addrOffset)
{
  int newStrLen = EEPROM.read(addrOffset);
  char data[newStrLen + 1];
  for (int i = 0; i < newStrLen; i++)
  {
    data[i] = EEPROM.read(addrOffset + 1 + i);
  }
  data[newStrLen] = '\ 0'; // !!! NOTE !!! Remove the space between the slash "/" and "0" (I've added a space because otherwise there is a display bug)
  return String(data);
}
*/

//
//void writeStringToEEPROM(int addrOffset, const String &strToWrite)
//{
//  byte len = strToWrite.length();
//  EEPROM.write(addrOffset, len);
//  for (int i = 0; i < len; i++)
//  {
//    EEPROM.write(addrOffset + 1 + i, strToWrite[i]);
//  }
//  EEPROM.commit();
//}
//
//String readStringFromEEPROM(int addrOffset)
//{
//  int newStrLen = EEPROM.read(addrOffset);
//  char data[newStrLen + 1];
//  for (int i = 0; i < newStrLen; i++)
//  {
//    data[i] = EEPROM.read(addrOffset + 1 + i);
//  }
//  data[newStrLen] = '\ 0'; // !!! NOTE !!! Remove the space between the slash "/" and "0" (I've added a space because otherwise there is a display bug)
//  return String(data);
//}

//////////////////////////////////////////////////////////////////////////////////////////////////////
 /* clients events */
static void handleError(void* arg, AsyncClient* client, int8_t error) {
	Serial.printf("\n connection error %s from client %s \n", client->errorToString(error), client->remoteIP().toString().c_str());
}

static void handleData(void* arg, AsyncClient* client, void *data, size_t len) {
  int it;
	Serial.printf("Data received from PIC: %s: ", client->remoteIP().toString().c_str());
 //Serial.println("\n");
	Serial.write((uint8_t*)data, len);
  Serial.println("\n");
   //String resData = String((uint8_t*)data); 
 
             
              String json;
              //StaticJsonDocument<64> doc;
              StaticJsonDocument<156> doc;
              
              //doc["fechaRegistro"] = "08/04/22 11:45:20";
              doc["fechaRegistro"] = timeClient.getFormattedDate(0);
              doc["fechaAtencion"] = "";
              doc["evento"] = (uint8_t*)data;
              doc["estatus"] = "sin leer";
              serializeJson( doc, json );
              //Serial.println("Dato a enviar");
              //Serial.println(json);
               String resData = doc["evento"].as<String>();    
             // Serial.println(resData);
              //Serial.println(strlen(resData));

               byte inicioPos = resData.indexOf('<');     
               byte finPos    = resData.indexOf('>'); 
               String DatoCorrectoPic = resData.substring(inicioPos,finPos+1);
               
               
              
              Serial.println("DatoPIC verificado: " + DatoCorrectoPic);
              //DatoCorrectoPicAnterior = readStringFromEEPROM(0); 
              EEPROM.get(0,Buf);//recoge variable de la posicion 0 y la guarda en Buf
              DatoCorrectoPicAnterior = String(Buf); 
              Serial.println("EEprom: " + DatoCorrectoPicAnterior);
              // writeStringToEEPROM(0, DatoCorrectoPic);

              if (DatoCorrectoPic.equals(DatoCorrectoPicAnterior)) {
                    Serial.println("Dato igual al anterior.");
                } else {
                   Serial.println("Dato diferente.");
                   if(strlen(doc["evento"])<=2){
                Serial.println("Dato de PIC, no contiene informacion valida. Nose envia solicitud POST");
              }
              else{
                Serial.println("Envio de solicitud POST.");
                 sendActualRequest( json );  
                 socketio_monitor("Evento de pic para BD:" + json);
              }
                }

             //writeStringToEEPROM(0, "Nuevo dato.");
             DatoCorrectoPic.toCharArray(Buf, 50);
             EEPROM.put(0,Buf); //guarda variable ssid a partir de primera posicion de eeprom ,la 0
             EEPROM.commit();
             // DatoCorrectoPicAnterior = readStringFromEEPROM(0); 
              
             //DatoCorrectoPicAnterior = DatoCorrectoPic;   
              
              
             

    
	// reply to client
  /*
	if (client->space() > 32 && client->canSend()) {
		//char reply[32];
		//sprintf(reply, "", SERVER_HOST_NAME);
    socketio_monitor("Instruccion de socketio para pic:" + resultcommand);
		client->add("Server sent<-", 13);
		client->send();
	}
 */
}

static void handleDisconnect(void* arg, AsyncClient* client) {
	Serial.printf("Client %s disconnected \n", client->remoteIP().toString().c_str());
  clients.clear();
}

static void handleTimeOut(void* arg, AsyncClient* client, uint32_t time) {
	Serial.printf("\n client ACK timeout ip: %s \n", client->remoteIP().toString().c_str());
}


static void TimerACK(void* arg, AsyncClient* client){
      //eventosTcpPic();
      if( eventoTimerTcpPic == true ){
        eventoTimerTcpPic = false;
       portENTER_CRITICAL(&timerMux);
    interruptCounter--;
    portEXIT_CRITICAL(&timerMux);
 
    totalInterruptCounter++;
 
    //Serial.print("An interrupt as occurred. Total number: ");
    //Serial.println(totalInterruptCounter);
      // reply to client
  if (client->space() > 32 && client->canSend()) {
    //char reply[2];
    char datoschar[250];


                    if(comandopic){
                      Serial.println("COMANDO RECIVIDO:");
                resultcommand.toCharArray(datoschar,250);
                if(client->canSend()){
                Serial.println("Instruccion de socketio para pic:" + resultcommand);
                socketio_monitor("Instruccion de socketio para pic:" + resultcommand);
                client->add(datoschar, strlen(datoschar));
                client->send();
                //sendConfirmRequest( stringreplace );  
               }
                comandopic= false;
               }
    
    

    //if(DatosNuevos!=""){
     int pos=DatosNuevos.indexOf("estatus");
     if (pos>=0) {
     
     
      ////// confirmar a api que se envio a cliente TCP el dato nuevo /////////////
      String stringreplace = "";
              stringreplace = DatosNuevos;
              stringreplace.replace("[","");
              stringreplace.replace("]","");
              
              stringreplace.replace("sin leer","leido");
              //Serial.println("<");
              //Serial.println(DatosNuevos);
              //Serial.println("-");
              //Serial.println(stringreplace);
              //Serial.println(">");
              DatosNuevos = "";

////////////////////////deserializar campo "evento", para enviar este dato al cliente TCP//////////////////
    DynamicJsonDocument eventodoc(1024);
    deserializeJson(eventodoc, stringreplace);
    String datoEvento = eventodoc["evento"].as<String>();
    //clima = dataJsonDes["weather"]["main"].as<String>();

    //Serial.println("strinJon:<");
    //Serial.println(stringreplace);
    //Serial.println(">");
    //Serial.println("DATOEvento:<");
    //Serial.println(datoEvento);
    //Serial.println(">");
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////
               datoEvento.toCharArray(datoschar, 250);

             //  else{
               //Serial.println("status client tcp:"+ client->canSend());
               //Serial.println("status client tcp:");
               if(client->canSend()){
                Serial.println("Instruccion para pic:" + datoEvento);
                socketio_monitor("Instruccion para pic:" + datoEvento);
                client->add(datoschar, strlen(datoschar));
                client->send();
                sendConfirmRequest( stringreplace );  
               }
              // }
    
     //////////////////////////////////////////////////////////////////////////////
              pos = 0;
    }

    //client->add("@", strlen(reply));
    client->add("!", 1);
    client->send();
   // reply ="";
  }
}
}

/* server events */
static void handleNewClient(void* arg, AsyncClient* client) {
	Serial.printf("New client has been connected to server, ip Client: %s", client->remoteIP().toString().c_str());
  Serial.print("\n");
  socketio_monitor("NUEVO SOCKET TCP-PIC CONECTADO!");

	// add to list
	clients.push_back(client);
	
	// register events
	client->onData(&handleData, NULL);
	client->onError(&handleError, NULL);
	client->onDisconnect(&handleDisconnect, NULL);
	client->onTimeout(&handleTimeOut, NULL);

  client->onPoll(&TimerACK, NULL);

}
