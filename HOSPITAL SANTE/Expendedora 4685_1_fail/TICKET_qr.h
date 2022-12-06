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

 
/*
  //BOLETO
  //impresoraTerm_formato(0x11, JUST_CENTER, true);
  "\x02091D21331B61011B4501\n" //1D21+11+1B61+01+1B45+01"
  "TERRAZ INTERLOMAS\n"
  "Operado por BNI ESTACIONAMIENTOS SA DE CV\n"
  "Gral. Garcia Conde Palomas No. 16\n"
  "Col. Reforma Social Miguel Hidalgo CDMX\n"
  "R.F.C BES0906299F8\n\n"
  */
  "\x02091D21331B61011B4501\n" //1D21+11+1B61+01+1B45+01"
  "FOLIO:\x050114\n"              //Impresion de Folio
  //impresoraTerm_formato(0x11, JUST_CENTER, true);
  "\x02091D21111B61011B4501\n\n"
  "\x050100\n"                     //Impresion de hora
  //impresoraTerm_formato(0x00, JUST_CENTER, false);
  "\x02091D21001B61011B4500\n\n"
  //impresoraTerm_codBarNum(COD_BARRAS_NUMERICO, COD_BARRAS_POS_UNDER, 100, 1);
  "\x02151D66011D48021D68641D77011D6B45\n"
  "\x03011F\n"                      //Numero de caracteres para el codigo
  "\n"

  "SIN TOLERANCIA\n"
  "ESTA  EMPRESA  Y SUS TRABAJADORES  NO SE  HACEN\n"
  "RESPONSABLES  POR  LOS OBJETOS  NO DECLARADOS Y\n"
  "MOSTRADOS  PARA  CUSTODIAR  AL  RESPONSABLE  DE\n"
  "ELABORAR  EL  BOLETO, Y  NO  SE  ENTREGUE  ESTE\n"
  "BOLETO  HASTA  QUE  RECIBA  SU  VEHICULO  A  SU\n"
  "ENTERA  SATISFACCION  IMPORTANTE LEA AL REVERSO\n"
  "DE ESTE  BOLETO  YA  QUE INDICA  LOS LIMITES DE\n"
  "NUESTRA RESPONSABILIDAD                        \n"

  

  //LEYENDA
  "En caso de requerir factura envie imagen del boleto a\n"
  "admoninterlomas@bniestacionamiento.com\n\n"

  "WWW.ACCESA.ME, AUTOMATIZACION DE\n"
  "ESTACIONAMIENTOS\n\n"

  //IMPRESION DEL QR
  //Tamaño del QR
  "\x02081D286B0300314308\n"
  //Guardar QR en memoria
  "\x02081D286B1A00315030\n"
  "\x05011F"
  //Impresion del QR
  "\x02081D286B0300315130\n"
  
  //impresoraTerm_corte(true, 20);
  "\x02041D56421E\n"  //TIPO DE CORTE CON OFFSET
  //"\x02021B6D\n"      //COMANDO PARA CORTAR
};