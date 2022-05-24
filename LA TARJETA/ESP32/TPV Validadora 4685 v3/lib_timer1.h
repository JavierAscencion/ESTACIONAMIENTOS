#ifndef _LIB_TIMER1_H
#define _LIB_TIMER1_H

unsigned int sampler1;

//Funcion prototipos
void int_timer1();

/******************************************************************************/
void timer1_open(long time_us, bool powerOn, bool enable, bool priorityHigh){
  char i;
  
  //Calculo del tiempo
  time_us *= Clock_MHz();
  time_us /= 4;
  //Buscamos el precaleer idoneo
  for(i = 0; i < 3; i++){
    if(time_us < 65536)
      break;

    time_us /= 2;
  }
  time_us = 65536-time_us;  //Ultima operacion
  sampler1 = time_us;       //Guardamos el valor del timer
  //CONFIGURAR REGISTROS
  T1CON.TMR1ON = 0;       //APAGAR TIMER0
  T1CON.RD16 = 1;         //FORMATO DE 16 BITS
  T1CON.T1CKPS0 = i.B0;   //PRESCALER
  T1CON.T1CKPS1 = i.B1;   //PRESCALER
  T1CON.T1OSCEN = 0;      //SEÑAL EXTERNA APAGADA
  T1CON.T1SYNC = 0;       //BIT IGNORADO POR USAR CLOCK INTERNO
  T1CON.TMR1CS = 0;       //CLOCK INTERNO FOSC/4

  //CARGAR EL VALOR POR DEFECTO AL TIMER
  TMR1H = getByte(sampler1,1);
  TMR1L = getByte(sampler1,0);

  //OTROS REGISTROS
  PIR1.TMR1IF = 0;            //LIMPIAR BANDERA
  PIE1.TMR1IE = enable;       //ACTIVAR O DESACTIVAR TIMER
  IPR1.TMR1IP = priorityHigh; //TIPO DE PRIORIDAD
  T1CON.TMR1ON = powerOn;     //ENCENDER TIMER
}
/******************************************************************************/
void timer1_enable(bool enable){
  PIE1.TMR1IE = enable;
}
/******************************************************************************/
void timer1_power(bool on){
  T1CON.TMR1ON = on; //ENCENDER TIMER
}
/******************************************************************************/
void timer1_priority(bool hihg){
  IPR1.TMR1IP = hihg; //TIPO DE PRIORIDAD
}
/******************************************************************************/
void timer1_reset(){
  TMR1H = getByte(sampler1,1);
  TMR1L = getByte(sampler1,0);
}
/******************************************************************************/
/******************************* INTERRUPT ************************************/
/*******************************************************************************
void int_timer1(){
  if(PIR1.TMR1IF && PIE1.TMR1IE){
    //CODIGO
    
    //FINALIZAR INTERRUPCION
    TMR1H = getByte(sampler1,1);
    TMR1L = getByte(sampler1,0);
    PIR1.TMR1IF = 0;   //LIMPÍAR BANDERA
  }
}
*******************************************************************************/
#endif