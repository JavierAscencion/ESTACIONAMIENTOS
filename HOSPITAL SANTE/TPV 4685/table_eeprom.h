/*
Fomato para escribir multiples columnas con defierentes bytes en tamaño
  "NameCol_1&Bytes\n"
  "NameCol_2&Bytes\n"
  "NameCol_3&Bytes\n"
Ejemplo
  "FOLIO&5\n"  //CREA UNA COLUMNA LLAMADA FOLIO CON 5 BYTES
  "REFER&3\n"  //CREA UNA COLUMNA LLAMADA REFER DE 3 BYTES
  "PESO&1\n"   //CREA UNA COLUMNA PESO REFER DE 1 BYTE
  
  NOTA: No enviar mas de dos digitos para las columnas el codigo no lo limite
*/
#ifndef _TABLE_H
#define _TABLE_H
#include "eeprom_i2c_soft.h"
#include "miscelaneos.h"

//RESULTADOS POR CREACION DE TABLA
#define TABLE_CREATE_SUCCESS            0
#define TABLE_CREATE_NAME_OUT_RANGE     1
#define TABLE_CREATE_NAME_COL_OUT_RANGE 2
#define TABLE_CREATE_MEMORY_FULL        3
#define TABLE_CREATE_REPEAT             4
//RESULTADOS POR LEER Y ESCRIBIR EN LA EEPROM
#define TABLE_RW_SUCCESS                0
#define TABLE_RW_NO_EXIST_TABLE         1
#define TABLE_RW_NO_EXIST_NAME_COL      2
#define TABLE_RW_NO_EXIST_ROW           3
#define TABLE_RW_OUT_RANGE              4
#define TABLE_RW_TABLE_FULL             5
#define TABLE_RW_OUT_RANGE_BYTES        6

//MAXIMO TAMAÑO PERMISIBLE PARA LOS NOMBRES DE LA TABLA Y COLUMNA
const char TABLE_MAX_SIZE_NAME = 15;//Nombre mas largo para la tabla y columnas
//ESTRUCTURA
typedef struct{
  char numTables;                  //Numero de tablas guardadas
  char col;                        //Columnas programadas
  unsigned int row;                //Filas programadas
  unsigned int rowAct;             //Filas actuales de llenado de tabla
  char tamCol;                     //Tamaño columna actual apuntada
  char nameAct[TABLE_MAX_SIZE_NAME+1];
  char nameColAct[TABLE_MAX_SIZE_NAME+1];
  unsigned int sizeMax;             //Tamaño maximo permisible
  unsigned int size;                //Tamaño actual
  unsigned int address;             //Address que apunta a la tabla
  unsigned int addressAct;          //Address movible entre columna y otros
  char cont;                        //Auxiliar de conteo
}mysql;

//Crear el objeto estatico
static mysql myTable;               //Mi tabla SQL

//FUNCIONES PROTOTIPO
char _mysql_calculate_address(char *name, char *column);

/******************************** FUNCTIONS ***********************************/
void mysql_reset(){
  myTable.numTables = 0;
  myTable.size = 3;   //Tamaño actual ocupado, num tables y tamaño actual
  //Escribe en la cero en la posicion cero eeprom
  eeprom_i2c_write(0x0000, &myTable.numTables, 1);
  eeprom_i2c_write(0x0001,(char*)&myTable.size, 2);
}
/******************************************************************************/
void mysql_init(unsigned int memoryMax){
  //Inicializar variables
  myTable.col = 0;
  myTable.row = 0;
  myTable.rowAct = 0;
  myTable.nameAct[0] = 0;          //Inicializar cadena en cero
  myTable.nameColAct[0] = 0;
  myTable.sizeMax = memoryMax;
  //Inicializo la eeprom
  eeprom_i2c_open();  //Preguntamos si deseo resetear la memoria
  eeprom_i2c_read(0x0000,&myTable.numTables, 1);
  eeprom_i2c_read(0x0001,(char*)&myTable.size, 2);
}
/******************************************************************************/
bool mysql_exist(char *name){
  myTable.address = 0x0003;  //Direccion 3 para lectura
  myTable.nameColAct[0] = 0; //Resetear mensaje
  
  for(myTable.cont = 0; myTable.cont < myTable.numTables; myTable.cont++){
    //Extraemos el nombre de la tabla en memoria
    eeprom_i2c_read(myTable.address, myTable.nameAct, TABLE_MAX_SIZE_NAME+1);
    //Comparamos si es igual rompemos for
    if(!strncmp(name, myTable.nameAct, TABLE_MAX_SIZE_NAME+1))
      break;
    //Leemos el tamaño de la tabla actual
    eeprom_i2c_read(myTable.address+TABLE_MAX_SIZE_NAME+1, (char*)&myTable.address, 2);
  }
  //Mandar condicion si rompio ciclo
  if(myTable.cont < myTable.numTables){
    myTable.addressAct = myTable.address;   //Copiar direccion casa de la tabla
    //Obter filas actuales, filas y columnas
    myTable.addressAct += TABLE_MAX_SIZE_NAME+3;
    eeprom_i2c_read(myTable.addressAct,(char*)&myTable.rowAct, 2);
    eeprom_i2c_read(myTable.addressAct+2,(char*)&myTable.row, 2);
    eeprom_i2c_read(myTable.addressAct+4,&myTable.col, 1); //Filas totales de busqueda
    return true;
  }else{
    myTable.nameAct[0] = 0;
    return false;
  }
}
/******************************************************************************/
char mysql_create_new(char *name, char *columnas, int filas){
  unsigned int tam, acum = 0;   //Tamño a ser escrito
  char cad[4], i, col;          //Para convertir el texto en entero
  char aux;                     //Verifica el tamaño del name col

  //Si excede el tamaño la cadena no crea la tabla
  if(strlen(name) > TABLE_MAX_SIZE_NAME){
    return TABLE_CREATE_NAME_OUT_RANGE;     //Excede el tamaño del nombre permisible
  }
  //Preguntamos si no existe la tabla
  if(!mysql_exist(name)){
    //Realizamos precalculo de uso a guardar
    col = 0;
    myTable.cont = 0;
    tam = TABLE_MAX_SIZE_NAME+1;   //Tamaño por el nombre
    tam += 2;                      //Contiene el tamaño de la tabla
    tam += 2;                      //Contiene la fila actual
    tam += 2;                      //Contiene las filas programadas
    tam += 1;                      //Contiene la columnas programadas
    
    //Calculamos el tamaño a ser insertado
    aux = 0;
    while(columnas[myTable.cont]){
      aux++;
      //Tamaño a ser concatenado
      if(columnas[myTable.cont++] == '&'){
        //Preguntar que no exceda el nombre de la cadena de columna
        if(aux > TABLE_MAX_SIZE_NAME+1){
          return TABLE_CREATE_NAME_COL_OUT_RANGE;  //Excede el tamaño del nombre de la columna
        }
        aux = 0;                        //Resetear
        tam += TABLE_MAX_SIZE_NAME+1;   //Agregamos el texto de la columna
        tam += 1;                       //El espacio ocupado por la columna
        //Extraemos los digitos a ser escritos para las columnas
        i = 0;    //Para guardar la cadena numero
        while(columnas[myTable.cont] != '\n' && columnas[myTable.cont])
          cad[i++] = columnas[myTable.cont++];
        col++;                       //Nueva columna
        cad[i] = 0;                  //Agregar final de cadena
        tam += filas*atoi(cad);      //Filas*col
      }
    }
    
    //Si no excede el tamaño creo la tabla
    if(myTable.size+tam < myTable.sizeMax){
      aux = 0;
      tam += myTable.size;
      //Grabar el nombre de la tabla
      eeprom_i2c_write(myTable.size, name, strlen(name)+1);
      myTable.size += TABLE_MAX_SIZE_NAME+1;  //Sumar cantidad actual
      //Apunta a la sigueinte tabla
      eeprom_i2c_write(myTable.size, (char*)&tam, 2);
      myTable.size += 2;
      //Guardar las filas actuales cero
      myTable.rowAct = 0;  //Reutilizar para filas actuales
      eeprom_i2c_write(myTable.size, (char*)&myTable.rowAct, 2);
      myTable.size += 2;
      //Guardar el numero de filas maximas
      eeprom_i2c_write(myTable.size, (char*)&filas, 2);
      myTable.size += 2;
      //Guardar el numero de columnas
      eeprom_i2c_write(myTable.size, &col, 1);
      myTable.size += 1;
      //Los nombres de celda mas espacio total por columna
      myTable.cont = 0;    //Contador actual
      tam = myTable.size;  //Reutilizar el dato momentaneamente
      //Escribir en memoria las columnas
      while(columnas[myTable.cont]){
        //Graba el dato
        eeprom_i2c_write(tam++, &columnas[myTable.cont++], 1);
        //Si es concatenacion graba el fin de cadena primero
        if(columnas[myTable.cont] == '&'){
          myTable.cont++;
          eeprom_i2c_write(tam++, &aux, 1);        //Final de cadena
          myTable.size += TABLE_MAX_SIZE_NAME+1;   //Agregamos el texto de la columna
          //Extraemos los digitos a ser escritos para las columnas
          i = 0;    //Para guardar la cadena numero
          while(columnas[myTable.cont]){
            cad[i++] = columnas[myTable.cont++];
            if(columnas[myTable.cont] == '\n'){
              myTable.cont++;
              break;
            }
          }
          cad[i] = 0;                  //Agregar final de cadena
          col = atoi(cad);
          eeprom_i2c_write(myTable.size, &col, 1); //Agregamos los bytes a usar por col
          myTable.size += 1;                       //Agregamos el texto de la columna
          acum += col*filas;
          //myTable.size += col*filas;
          tam = myTable.size;
        }
      }
      myTable.size += acum;  //Respaldamos el contenido total
      myTable.numTables++;   //Agregar tabla y tamaño actuales
      eeprom_i2c_write(0x0000, &myTable.numTables, 1);
      eeprom_i2c_write(0x0001,(char*)&myTable.size, 2);
      //Resetear mensajes
    }else{
      return TABLE_CREATE_MEMORY_FULL;  //Memoria agotada
    }
  }else{
    return TABLE_CREATE_REPEAT;    //Ya existe la tabla
  }
  
  return TABLE_CREATE_SUCCESS;      //Tabla creada con exito
}
/******************************************************************************/
char mysql_read_string(char *name, char *column, int fila, char *result){
  char res = _mysql_calculate_address(name, column);
  
  //Preguntar si hubo algun problema
  if(res)
    return res;

  //Realizar busqueda de informacion
  if(fila >= 1 && fila <= myTable.rowAct)
    eeprom_i2c_read(myTable.addressAct+(fila-1)*myTable.tamCol, result, myTable.tamCol);
  else{
    return TABLE_RW_NO_EXIST_ROW;   //Fila inexistente
  }
  
  return TABLE_RW_SUCCESS;     //Exito en la busqueda
}
/******************************************************************************/
char mysql_read(char *name, char *column, int fila, long *result){
  char res = _mysql_calculate_address(name, column);
  
  //Preguntar si hubo algun problema
  if(res)
    return res;

  //Resetear el valor
  *result = 0;
  
  //Realizar busqueda de informacion
  if(fila >= 1 && fila <= myTable.rowAct){
    if(myTable.tamCol <= 4)
      eeprom_i2c_read(myTable.addressAct+(fila-1)*myTable.tamCol, (char*)&(*result), myTable.tamCol);
    else{
      return TABLE_RW_OUT_RANGE_BYTES;
    }
  }else{
    return TABLE_RW_NO_EXIST_ROW;   //Fila inexistente
  }

  return TABLE_RW_SUCCESS;
}
/******************************************************************************/
char mysql_read_forced(char *name, char *column, int fila, char *result){
  char res = _mysql_calculate_address(name, column);

  //Preguntar si hubo algun problema
  if(res)
    return res;

  //Realizar busqueda de informacion
  if(fila >= 1 && fila <= myTable.row)
    eeprom_i2c_read(myTable.addressAct+(fila-1)*myTable.tamCol, result, myTable.tamCol);
  else
    return TABLE_RW_NO_EXIST_ROW;   //Fila inexistente

  return TABLE_RW_SUCCESS;     //Exito en la busqueda
}
/******************************************************************************/
char mysql_write_string(char *name, char *column, int fila, char *texto, bool endWrite){
  char res = _mysql_calculate_address(name, column);

  //Preguntar si hubo algun problema
  if(res)
    return res;
  
  //Escribir busqueda
  myTable.cont = strlen(texto)+1;   //Calcular el tamaño de la cadena a escribir
  //El texto es demasiado largo para guardar
  if(myTable.cont > myTable.tamCol){
    return TABLE_RW_OUT_RANGE;
  }
  //Metodo de guardado, final de linea o existente
  if(endWrite){
    if(myTable.rowAct < myTable.row){
      eeprom_i2c_write(myTable.addressAct+myTable.rowAct*myTable.tamCol, texto, myTable.cont);
      myTable.rowAct++;
      eeprom_i2c_write(myTable.address+TABLE_MAX_SIZE_NAME+3, (char*)&myTable.rowAct, 2);
    }else{
      return TABLE_RW_TABLE_FULL;   //Memoria llena de la tabla
    }
  }else if(fila >= 1 && fila <= myTable.rowAct)
    eeprom_i2c_write(myTable.addressAct+(fila-1)*myTable.tamCol, texto, myTable.cont);
  else{
    return TABLE_RW_NO_EXIST_ROW;   //Fila inexistente
  }
  
  return TABLE_RW_SUCCESS;     //Exito en grabacion
}
/******************************************************************************/
char mysql_write(char *name, char *column, int fila, long value, bool endWrite){
  char res = _mysql_calculate_address(name, column);

  //Preguntar si hubo algun problema
  if(res)
    return res;

  //El texto es demasiado largo para guardar
  myTable.cont = myTable.tamCol;
  if(myTable.cont > 4){
    return TABLE_RW_OUT_RANGE_BYTES;
  }
  //Metodo de guardado, final de linea o existente
  if(endWrite){
    if(myTable.rowAct < myTable.row){
      eeprom_i2c_write(myTable.addressAct+myTable.rowAct*myTable.tamCol, (char*)&value, myTable.cont);
      myTable.rowAct++;
      eeprom_i2c_write(myTable.address+TABLE_MAX_SIZE_NAME+3, (char*)&myTable.rowAct, 2);
    }else
      return TABLE_RW_TABLE_FULL;   //Memoria llena de la tabla
  }else if(fila >= 1 && fila <= myTable.rowAct)
    eeprom_i2c_write(myTable.addressAct+(fila-1)*myTable.tamCol, (char*)&value, myTable.cont);
  else
    return TABLE_RW_NO_EXIST_ROW;   //Fila inexistente

  return TABLE_RW_SUCCESS;     //Exito en grabacion
}
/******************************************************************************/
char mysql_write_forced(char *name, char *column, int fila, char *texto, char bytes){
  char res = _mysql_calculate_address(name, column);

  //Preguntar si hubo algun problema
  if(res)
    return res;

  //El texto es demasiado largo para guardar
  if(bytes > myTable.tamCol)
    return TABLE_RW_OUT_RANGE;

  //Escriba en la fila n
  if(fila >= 1 && fila <= myTable.row)
    eeprom_i2c_write(myTable.addressAct+(fila-1)*myTable.tamCol, texto, bytes);
  else
    return TABLE_RW_NO_EXIST_ROW;   //Fila inexistente

  return TABLE_RW_SUCCESS;     //Exito en grabacion
}
/******************************************************************************/
char mysql_write_roundTrip(char *name, char *column, char *texto, char bytes){
  char res = _mysql_calculate_address(name, column);

  //Preguntar si hubo algun problema
  if(res)
    return res;

  //El texto es demasiado largo para guardar
  if(bytes > myTable.tamCol)
    return TABLE_RW_OUT_RANGE;

  //Rotar buffer
  myTable.rowAct = clamp_shift(++myTable.rowAct, 1, myTable.row);
  eeprom_i2c_write(myTable.address+TABLE_MAX_SIZE_NAME+3, (char*)&myTable.rowAct, 2);
  eeprom_i2c_write(myTable.addressAct+(myTable.rowAct-1)*myTable.tamCol, texto, bytes);

  return TABLE_RW_SUCCESS;     //Exito en grabacion
}
/******************************************************************************/
bool mysql_erase(char *name){
  //Preguntar si hubo algun problema
  if(!mysql_exist(name))
    return false;

  //Borra tabla
  myTable.rowAct = 0;
  eeprom_i2c_write(myTable.address+TABLE_MAX_SIZE_NAME+3, (char*)&myTable.rowAct, 2);
  return true;
}
/******************************************************************************/
char mysql_search(char *tabla, char *columna, long buscar, int *fila){
  long busqueda;
  
  //Buscamos el dato
  if(mysql_exist(tabla)){
    for(*fila = 1; *fila <= myTable.rowAct; (*fila)++){
      //Leemos las filas
      if(!mysql_read(tabla, columna, *fila, &busqueda)){
        if(buscar == busqueda)
          return TABLE_RW_SUCCESS;
      }
    }
    return TABLE_RW_NO_EXIST_ROW;
  }
  
  return TABLE_RW_NO_EXIST_TABLE;
}
/******************************************************************************/
char mysql_search_forced(char *tabla, char *columna, long buscar, int *fila){
  long busqueda;

  //Buscamos el dato
  if(mysql_exist(tabla)){
    for(*fila = 1; *fila <= myTable.row; (*fila)++){
      //Leemos las filas
      if(!mysql_read(tabla, columna, *fila, &busqueda)){
        if(buscar == busqueda)
          return TABLE_RW_SUCCESS;
      }
    }
    return TABLE_RW_NO_EXIST_ROW;
  }

  return TABLE_RW_NO_EXIST_TABLE;
}
/******************************************************************************/
int mysql_count(char *tabla, char *columna, long buscar){
  int coincidencias = 0;
  long busqueda;

  //Buscamos el dato
  if(mysql_exist(tabla)){
    for(myTable.cont = 1; myTable.cont <= myTable.rowAct; myTable.cont++){
      //Leemos las filas
      if(!mysql_read(tabla, columna, myTable.cont, &busqueda)){
        if(buscar == busqueda)
          coincidencias++;
      }
    }
  }

  return coincidencias;
}
/******************************************************************************/
int mysql_count_forced(char *tabla, char *columna, long buscar){
  int coincidencias = 0;
  long busqueda = 0;

  //Buscamos el dato
  if(mysql_exist(tabla)){
    for(myTable.cont = 1; myTable.cont <= myTable.row; myTable.cont++){
      //Leemos las filas
      if(!mysql_read_forced(tabla, columna, myTable.cont, (char*)&busqueda)){
        if(buscar == busqueda)
          coincidencias++;
      }
    }
  }

  return coincidencias;
}
/******************************************************************************/
/********************************** OTHERS ************************************/
/******************************************************************************/
char _mysql_calculate_address(char *name, char *column){
  unsigned int addressAux = 0;
  
  //Buscar si existe la tabla
  if(strncmp(name, myTable.nameAct, TABLE_MAX_SIZE_NAME+1)){
    if(!mysql_exist(name)){
      return TABLE_RW_NO_EXIST_TABLE;  //No existe la tabla buscada
    }
  }
  //Preguntamos si existe la col
  if(strncmp(column, myTable.nameColAct, TABLE_MAX_SIZE_NAME+1)){
    myTable.addressAct = myTable.address;   //Copiar direccion casa de la tabla
    //Obter filas actuales, filas y columnas
    myTable.addressAct += TABLE_MAX_SIZE_NAME+3;
    eeprom_i2c_read(myTable.addressAct,(char*)&myTable.rowAct, 2);
    eeprom_i2c_read(myTable.addressAct+2,(char*)&myTable.row, 2);
    eeprom_i2c_read(myTable.addressAct+4,&myTable.col, 1); //Filas totales de busqueda
    //Verificamos todas las columnas
    myTable.addressAct += (4+1);   //Apuntamos a la primera columna name
    addressAux = myTable.addressAct;
    addressAux += myTable.col*(TABLE_MAX_SIZE_NAME+1+1); //Apuntar a los datos
    
    //Buscamos la columna deseada
    for(myTable.cont = 0; myTable.cont < myTable.col; myTable.cont++){
      //Extraemos el nombre de la tabla en memoria
      eeprom_i2c_read(myTable.addressAct, myTable.nameColAct, TABLE_MAX_SIZE_NAME+1);
      //Apuntamos a la siguiente direccion
      myTable.addressAct += TABLE_MAX_SIZE_NAME+1;
      eeprom_i2c_read(myTable.addressAct, &myTable.tamCol, 1); //1 de esta direccion
      myTable.addressAct += 1;
      //Preguntamos el nombre de la fila si existe
      if(!strncmp(column, myTable.nameColAct, TABLE_MAX_SIZE_NAME+1))
        break;
        
      addressAux += myTable.tamCol*myTable.row;   //Acumular las columnas para saber la direccion
      //myTable.addressAct += (*tamCol)*myTable.row;   //Apuntar a la siguiente columna
    }
    //No existe columna buscada
    if(myTable.cont >= myTable.col){
      myTable.nameColAct[0] = 0;
      return TABLE_RW_NO_EXIST_NAME_COL;
    }
    myTable.addressAct = addressAux;
  }
  
  return TABLE_RW_SUCCESS;
}
/******************************************************************************/
#endif