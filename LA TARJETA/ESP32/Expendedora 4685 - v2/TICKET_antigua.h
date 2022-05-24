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

  49
*/



const char ticket[] = {
  //impresoraTerm_open(FONTB,20);
  "\x02141B401B21011B33141B61001D2133\n"

  //impresoraTerm_formato(0x11, JUST_CENTER, true);
  "\x02091D21111B61011B4501\n" //1D21+11+1B61+01+1B45+01"
  "FOLIO:\x050114\n"              //Impresion de Folio
  "ESTACIONAMIENTO JINETES\n"
  
  //Nombre fiscal del estacionamiento
  "\x02091D21001B61011B4500\n\n"
  "Operado por BNI ESTACIONAMIENTOS S.A. de C.V.\n"
  //"SUC. CITI INSUR \n\n"
  "R.F.C.: BES0906299F8 \n"
  "Col.  Reforma Social Miguel Hidalgo CDMX \n"
  "Gral. Garcia Conde Palomas No.16 \n"
  //"Suc: Insurgentes Sur 601\n\n"

  //INFORMACION VITAL
  //"Si requiere factura favor de solicitarla a:\n"
  //"admonsurcorp@bniestacioanmientos.com \n\n"

  //IMPRESION DE FECHA/HORA Y CODIGO DE BARRAS
  //impresoraTerm_formato(0x11, JUST_CENTER, true);
  "\x02091D21111B61011B4501\n\n"
  "\x050100\n"                 //Impresion de hora
  //impresoraTerm_codBarNum(COD_BARRAS_NUMERICO, COD_BARRAS_POS_UNDER, 100, 1);
  "\x02151D66011D48021D68641D77011D6B07\n"
  "g\x05011F\x020100\n"                 //Numero de caracteres para el codigo
  /*
  //Tamaño del QR
  "\x02081D286B0300314308\n"
  //Guardar QR en memoria
  "\x02081D286B1800315030\n"
  "\x05011F"
  //Impresion del QR
  "\x02081D286B0300315130\n"
  */
  
  //Cuerpo del boleto
  "\n\n\x02091D21001B61011B4501\n" //1D21+{11}+1B61+{01}+1B45+{01}"
  "TARIFA: $16 Hora, Fraccion $4 cada 15 min\n" 
  "No hay Tolerancia \n\n"
  "HORARIOS\n"
  "Lunes a viernes de:     7:00 a 19:00\n"
  "Sabados y Domingos de: 10:00 a 15:00\n\n"

  //Clausulas
  "\x02091D21001B61011B4500\n" //1D21+{11}+1B61+{01}+1B45+{01}"
  "ESTA  EMPRESA  Y  SUS  TRABAJADORES  NO  SE HACEN\n"
  "RESPONSABLES  POR  LOS  OBJETOS  NO DECLARADOS  Y\n"
  "MOSTRADOS  PARA  CUSTODIAR  AL  RESPONSABLE  DE  \n"
  "ELABORAR  EL  BOLETO,  Y  NO  SE  ENTREGUE  ESTE \n"
  "BOLETO  HASTA  QUE  RECIBA SU  VEHICULO  A  SU   \n"
  "ENTERA  SATISFACCION IMPORTANTE  LEA  AL  REVERSO\n"
  "DE  ESTE  BOLETO YA  QUE  INDICA  LOS  LIMITES   \n"
  "DE NUESTRA  RESPONSABILIDAD                      \n\n"
  "BOLETO PERDIDO: LLENADO DEL FORMATO CORRESPONDIENTE\n\n"

  "\x02151D66011D48021D68641D77011D6B04\n"
  "\x05011F\x020100\n\n\n"
  
  "ACCESA PARKING AUTOMATIZACION DE ESTACIONAMIENTOS\n"
  "        www.accesa.me    ventas@accesa.me        \n"
  //impresoraTerm_corte(true, 20);
  "\x02041D56425A\n"  //TIPO DE CORTE CON OFFSET
};