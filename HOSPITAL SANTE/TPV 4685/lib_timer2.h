#ifndef _LIB_TIMER2_H
#define _LIB_TIMER2_H

//Funcion prototipos
void int_timer2();

//char sampler2 = 0;
/******************************************************************************/
void timer2_open(long time_us, bool powerOn, bool enable, bool priorityHigh){
  char pres = 1, post, auxPre = 0xFF;
  //Ecuacion: PR2 = time_us*FoscMHz/(post*pres*4)

  //Calculo del tiempo
  time_us *= Clock_Mhz();
  
  //Buscamos el precaleer, postcaler idoneos
  for(pres = 1; pres <= 16; pres *= 4){
    auxPre++;
    for(post = 1; post <= 16; post++){
      if(time_us/(pres*post*4U) <= 255){
        time_us /= 4;
        time_us /= pres;
        time_us /= post;
        PR2 = time_us;
        pres = 16; //Para fozar salir del otro for
        break;
      }
    }
  }
  
  //CONFIGURAR REGISTROS
  T2CON.T2CKPS0 = auxPre.B0;  //Prescaler
  T2CON.T2CKPS1 = auxPre.B1;  //Prescaler
  post--;
  T2CON.T2OUTPS0 = post.B0;   //Postcaler
  T2CON.T2OUTPS1 = post.B1;   //Postcaler
  T2CON.T2OUTPS2 = post.B2;   //Postcaler
  T2CON.T2OUTPS3 = post.B3;   //Postcaler

  //CARGAR EL VALOR POR DEFECTO AL TIMER
  TMR2 = 0;

  //OTROS REGISTROS
  PIR1.TMR2IF = 0;            //LIMPIAR BANDERA
  PIE1.TMR2IE = enable;       //ACTIVAR O DESACTIVAR TIMER
  IPR1.TMR2IP = priorityHigh; //TIPO DE PRIORIDAD
  T2CON.TMR2ON = powerOn;     //ENCENDER TIMER
}
/******************************************************************************/
void timer2_enable(bool enable){
  PIE1.TMR2IE = enable;       //ACTIVAR O DESACTIVAR TIMER
}
/******************************************************************************/
void timer2_power(bool on){
  T2CON.TMR2ON = on;     //ENCENDER TIMER
}
/******************************************************************************/
void timer2_priority(bool hihg){
  IPR1.TMR2IP = hihg; //TIPO DE PRIORIDAD
}
/******************************************************************************/
/******************************* INTERRUPT ************************************/
/*******************************************************************************
void int_timer2(){
  if(PIR1.TMR2IF && PIE1.TMR2IE){
    //CODIGO

    //FINALIZAR INTERRUPCION
    PIR1.TMR2IF = 0;   //LIMPÍAR BANDERA
  }
}
*******************************************************************************/
#endif