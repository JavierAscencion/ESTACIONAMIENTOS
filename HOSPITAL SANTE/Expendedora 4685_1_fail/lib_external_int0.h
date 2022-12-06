#ifndef _LIB_EXTERNAL_INT0_H
#define _LIB_EXTERNAL_INT0_H

//Funcion prototipos
void int_external_int0();

/******************************************************************************/
void external_int0_open(bool enable, bool edgeOnRising){
  INTCON.INT0IF = 0;                  //LIMPIAR BANDERA
  INTCON2.INTEDG0 = edgeOnRising.B0;  //FLANCO DE SUBIDA
  INTCON.INT0IE = enable.B0;          //DISPONIBILIDAD
}
/******************************************************************************/
void external_int0_enable(bool enable){
  INTCON.INT0IE = enable.B0;          //DISPONIBILIDAD
}
/******************************************************************************/
void external_int0_edge(bool onRising){
  INTCON2.INTEDG0 = onRising.B0;      //FLANCO DE SUBIDA
}
/******************************************************************************/
/******************************* INTERRUPT ************************************/
/*******************************************************************************
void int_external_int0(){
  if(INTCON.INT0IF && INTCON.INT0IE){
    //CODIGO
    INTCON.INT0IF = 0;
  }
}
*******************************************************************************/
#endif