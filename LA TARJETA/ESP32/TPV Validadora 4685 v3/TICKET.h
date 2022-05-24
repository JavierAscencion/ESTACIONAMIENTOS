/*
  //Formato del folio
  impresoraTerm_formato(0x11, JUST_CENTER, true);
  
  //Tamaño de la letra por defecto
  impresoraTerm_cmd2(IMPT_SIZE_CHAR, size);
  //Justificacion
  impresoraTerm_cmd2(IMPT_JUST, just);
  //Justificacion
  impresoraTerm_cmd2(IMPT_NEGRITA, negrita);
         size       just      Negrita
  29, 33, 0, 27, 97, 1, 27, 69, 0
  
  //Impresora
  impresoraTerm_cmd2(IMPT_COD_BAR_POS, format);  //Mostrar codigo de barras
  impresoraTerm_cmd2(IMPT_COD_BAR_V, altura);    //Altura del codigo de barras 1-255
  impresoraTerm_cmd2(IMPT_COD_BAR_H, ancho);     //Ancho codigo de barras 2-6
  //Imprimir codigo de barras, longitud y caracteres
  impresoraTerm_cmd2(IMPT_COD_BAR_C, COD_BARRAS_NUMERICO);
         Abajo        Alto        Ancho       CODEXX
  29, 72, 2, 29, 104, 100, 29, 119, 2, 29, 107, 69

*/
  
const char ticket[] = {
  //impresoraTerm_open(FONTB,20);
  "\x02141B401B21011B33141B61001D2133\n"
  //impresoraTerm_formato(0x11, JUST_CENTER, true);
  "\x02091D21111B61011B4501\n"
  "FOLIO:\x050114\n"              //Impresion de Folio
  "PROMOTORA PARKIG A D B S.C \n"
  //impresoraTerm_formato(0x00, JUST_CENTER, false);
  "\x02091D21001B61011B4500\n\n"
  "Av. Mexico No. 700 Ofna. 308 \n"
  "Col. San Jeronimo Aculco,C.P. 10200. \n"
  "Delegacion: Magdalena Contreras, Ciudad de Mexico \n"
  "SUC. ARCOS DE BELEN 31 \n"
  "RFC:OET 130911 BRA \n"
  //impresoraTerm_formato(0x11, JUST_CENTER, true);
  "\x02091D21111B61011B4501\n\n"
  "\x050100\n"                              //Impresion de hora
  //impresoraTerm_formato(0x00, JUST_CENTER, false);
  "\x02091D21001B61011B4500\n\n"
  //impresoraTerm_codBarNum(codigo, COD_BARRAS_POS_UNDER, 100, 1);
  "\x02121D48021D68641D77011D6B45\n"
  "\x03011F\n"                      //Numero de caracteres para el codigo
  /*
  "LOS OBJETOS NO DEJADOS  EN CUSTODIA \n"
  "AL VALET PARKING NO SON RESPONSABILIDAD \n"
  "DE LA EMPRESA \n"
  "REPORTAR OBJETOS DE VALOR: SI__ NO__ \n"
  "___________________________________________ \n"
  "___________________________________________ \n"
  //impresoraTerm_formato(0x10, JUST_CENTER, false);
  "\x02091D21101B61011B4500\n"
  "MARCA:__________________ \n"
  "PLACA:__________________ \n"
  "COLOR:__________________ \n"
  //impresoraTerm_formato(0x00, JUST_CENTER, false);
  "\x02091D21001B61011B4500\n"
  "OPERADOR QUE RECIBE:______________________________ \n"
  "OPERADOR QUE ENTREGA:_____________________________ \n"
  //IMPRIME DIBUJO
  "  ________________________(_)______ \n"
  "  /      |        |         |       \\ \n"
  " /  _____\\________|_________/________\\ \n"
  "(|-- |      |          |     \\       (o) \n"
  " |   |      |          |     |       | | \n"
  "[|   |      |          |     |       | | \n"
  "[|   |      |          |     |       | | \n"
  " |   |      |          |     |       | | \n"
  "(|---|______|__________|_____/_______(o) \n"
  " \\      /        |         \\         / \n"
  "  \\_____|________|_________|________/ \n"
  "                  ( ) \n"
  //CUERPO DEL TICKET
  "TARIFA:$30 Hora o Fraccion\n"
  "Horarios: lunes a viernes de 7:00 a 19:00\n" 
  "Y sabados y domingos de 10:00 a 15:00 \n"
  "PENSION:\n"
  "12 hrs - $1,100 + IVA\n" 
  "24 hrs - $1,300 + IVA\n"
  "Solo Noche - $750 + IVA\n"
  "CONVENIO:\n"
  "Tarifa promocion de $80 por 6 horas\n"
  "TOLERANCIA:\n"
  " 5 minutos\n"
  "A partir de la segunda hora se fracciona cada 15 minutos\n"
  "  0 - 15 mins    $8\n"
  " 16 - 30 mins    $8\n" 
  " 31 - 45 mins    $7\n" 
  " 46 - 60 mins    $7\n"
  "ESTA  EMPRESA  Y SUS TRABAJADORES  NO SE  HACEN\n"
  "RESPONSABLES  POR  LOS OBJETOS  NO DECLARADOS Y\n"
  "MOSTRADOS  PARA  CUSTODIAR  AL  RESPONSABLE  DE\n"
  "ELABORAR  EL  BOLETO, Y  NO  SE  ENTREGUE  ESTE\n"
  "BOLETO  HASTA  QUE  RECIBA  SU  VEHICULO  A  SU\n"
  "ENTERA  SATISFACCION  IMPORTANTE LEA AL REVERSO\n"
  "DE ESTE  BOLETO  YA  QUE INDICA  LOS LIMITES DE\n"
  "NUESTRA RESPONSABILIDAD                        \n"
  "ESTACIONAMIENTO OPERADO POR\n"
  "BNI ESTACIONAMIENTOS\n"
  "ACCESA PARKING AUTOMATIZACION DE ESTACIONAMIENTOS\n"
  */
  "www.accesa.me    ventas@accesa.me\n"
  //impresoraTerm_corte(true, 20);
  "\x02041D56421E\n"  //TIPO DE CORTE CON OFFSET
  //"\x02021B6D\n"      //COMANDO PARA CORTAR
};