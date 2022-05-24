#ifndef _LIB_WTD_H
#define _LIB_WTD_H

//ESCALA DE 4.096ms, HASTA 2.18 MIN DE WATCHDOG
/******************************************************************************/
void wtd_enable(bool enable){
  asm CLRWDT;
  WDTCON.SWDTEN = enable.B0;
  //segundos = 128*POST/31250, POST = [1,2,4,..,32768]
  //2seg*31250/128, WDTPS = 256
}
/******************************************************************************/
#endif