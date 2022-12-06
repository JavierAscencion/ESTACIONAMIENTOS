#ifndef _LIB_EXTERNAL_INT1_H
#define _LIB_EXTERNAL_INT1_H

//Funcion prototipos
void int_external_int1();

/******************************************************************************/
void external_int1_open(bool enable, bool edgeOnRising, bool priorityHigh){
  INTCON3.INT1IF = 0;                //LIMPIAR BANDERA
  INTCON2.INTEDG1 = edgeOnRising.B0; //FLANCO DE SUBIDA
  INTCON3.INT1IP = priorityHigh.B0;  //PRIORIDAD DE LA INTERRUPCION
  INTCON3.INT1IE = enable.B0;        //DISPONIBILIDAD
}
/******************************************************************************/
void external_int1_enable(bool enable){
  INTCON3.INT1IE = enable.B0;        //DISPONIBILIDAD
}
/******************************************************************************/
void external_int1_edge(bool onRising){
  INTCON2.INTEDG1 = onRising.B0;     //FLANCO DE SUBIDA
}
/******************************************************************************/
void external_int1_priority(bool high){
  INTCON3.INT1IP = high.B0;          //PRIORIDAD DE LA INTERRUPCION
}
/******************************************************************************/
/******************************* INTERRUPT ************************************/
/*******************************************************************************
void int_external_int1(){
  if(INTCON3.INT1IF && INTCON3.INT1IE){
    //CODIGO
    INTCON3.INT1IF = 0;
  }
}
*******************************************************************************/
#endif