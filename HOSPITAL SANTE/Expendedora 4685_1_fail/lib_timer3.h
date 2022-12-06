#ifndef _LIB_TIMER3_H
#define _LIB_TIMER3_H

unsigned int sampler3;

//Funcion prototipos
void int_timer3();

/******************************************************************************/
void timer3_open(long time_us, bool powerOn, bool enable, bool priorityHigh){
  char i;

  //Calculo del tiempo
  time_us *= Clock_Mhz();
  time_us /= 4;
  //Buscamos el precaleer idoneo
  for(i = 0; i < 3; i++){
    if(time_us < 65536)
      break;

    time_us /= 2;
  }
  time_us = 65536-time_us;  //Ultima operacion
  sampler3 = time_us;       //Guardamos el valor del timer
  //CONFIGURAR REGISTROS
  T3CON.TMR3ON = 0;       //APAGAR TIMER0
  T3CON.RD16 = 1;         //FORMATO DE 16 BITS
  T3CON.T3CCP1 = 1;      //TIMER3 PARA CLOCK EN CCP1 Y ECCP
  T3CON.T3ECCP1 = 1;      //TIMER3 PARA CLOCK EN CCP1 Y ECCP
  T3CON.T3CKPS0 = i.B0;   //PRESCALER
  T3CON.T3CKPS1 = i.B1;   //PRESCALER
  T3CON.T3SYNC = 0;       //BIT IGNORADO POR USAR CLOCK INTERNO
  T3CON.TMR3CS = 0;       //CLOCK INTERNO FOSC/4

  //CARGAR EL VALOR POR DEFECTO AL TIMER
  TMR3H = getByte(sampler3,1);
  TMR3L = getByte(sampler3,0);

  //OTROS REGISTROS
  PIR2.TMR3IF = 0;            //LIMPIAR BANDERA
  PIE2.TMR3IE = enable;       //ACTIVAR O DESACTIVAR TIMER
  IPR2.TMR3IP = priorityHigh; //TIPO DE PRIORIDAD
  T3CON.TMR3ON = powerOn;     //ENCENDER TIMER
}
/******************************************************************************/
void timer3_enable(bool enable){
  PIE3.TMR3IE = enable;
}
/******************************************************************************/
void timer3_power(bool on){
  T3CON.TMR3ON = on; //ENCENDER TIMER
}
/******************************************************************************/
void timer3_priority(bool hihg){
  IPR2.TMR3IP = hihg; //TIPO DE PRIORIDAD
}
/******************************************************************************/
/******************************* INTERRUPT ************************************/
/*******************************************************************************
void int_timer3(){
  if(PIR2.TMR3IF && PIE2.TMR3IE){
    //CODIGO

    //FINALIZAR INTERRUPCION
    TMR3H = getByte(sampler3,1);
    TMR3L = getByte(sampler3,0);
    PIR2.TMR3IF = 0;   //LIMPÍAR BANDERA
  }
}
*******************************************************************************/
#endif