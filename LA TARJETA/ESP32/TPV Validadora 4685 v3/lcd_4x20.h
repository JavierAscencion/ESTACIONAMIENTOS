extern sfr sbit LCD_D4;
extern sfr sbit LCD_D4_Direction;
extern sfr sbit LCD_D5;
extern sfr sbit LCD_D5_Direction;
extern sfr sbit LCD_D6;
extern sfr sbit LCD_D6_Direction;
extern sfr sbit LCD_D7;
extern sfr sbit LCD_D7_Direction;
extern sfr sbit LCD_RS;
extern sfr sbit LCD_RS_Direction;
extern sfr sbit LCD_EN;
extern sfr sbit LCD_EN_Direction;

// These are the line addresses for most 4x20 LCDs. 
#define LCD_LINE_1_ADDRESS 0x00 
#define LCD_LINE_2_ADDRESS 0x40 
#define LCD_LINE_3_ADDRESS 0x14 
#define LCD_LINE_4_ADDRESS 0x54 
//======================================== 
#define lcd_type 2   // 0=5x7, 1=5x10, 2=2 lines(or more) 
//Constantes
#define _LCD_CURSOR_OFF   0x0C
#define _LCD_CLEAR        0x01


/******************************************************************************/
void lcd_send_nibble(char nibble){
  LCD_D4 = nibble.B0;
  LCD_D5 = nibble.B1;
  LCD_D6 = nibble.B2;
  LCD_D7 = nibble.B3;
  asm nop;
  asm nop;
  LCD_EN = 1;
  Delay_us(2);
  LCD_EN = 0;
}
/******************************************************************************/
void lcd_send_byte(char address, char enviar){
  LCD_RS = 0;
  Delay_us(60);
  
  if(address)
    LCD_RS = 1;
  else
    LCD_RS = 0;
  asm nop;

  //Apagar EN
  LCD_EN = 0;
  //Mandar nibble
  lcd_send_nibble(Swap(enviar));
  lcd_send_nibble(enviar);
} 
/******************************************************************************/
void lcd_init(){
   char i;
   
   //Init pines
   LCD_D4_Direction = 0;
   LCD_D5_Direction = 0;
   LCD_D6_Direction = 0;
   LCD_D7_Direction = 0;
   LCD_RS_Direction = 0;
   LCD_EN_Direction = 0;
   
   //Init pines
   LCD_RS = 0;
   LCD_EN = 0;
   //Estabilizacion de energia
   Delay_ms(15);
   //Manddar dato
   for(i = 0; i < 3; i++){
     lcd_send_nibble(0x03);
     Delay_ms(5);
   } 
   //Mandar function
   lcd_send_nibble(0x02); 
   //Siguiente datos
   lcd_send_byte(0, 0x28);  //Set mode: 4-bit, 2+ lines, 5x8 dots
   Delay_ms(5);
   lcd_send_byte(0, 0x0C);  //Display on
   Delay_ms(5);
   lcd_send_byte(0, 0x01);  //Clear display
   Delay_ms(5);
   lcd_send_byte(0, 0x06);  //Increment cursor
   Delay_ms(5);
} 
/******************************************************************************/
void lcd_gotoxy(char fila, char col){
  if(fila == 1)
    fila = LCD_LINE_1_ADDRESS;
  else if(fila == 2)
    fila = LCD_LINE_2_ADDRESS;
  else if(fila == 3)
    fila = LCD_LINE_3_ADDRESS;
  else if(fila == 4)
    fila = LCD_LINE_4_ADDRESS;
  else
    fila = LCD_LINE_1_ADDRESS;

  fila += (col-1);
  fila |= 0x80;

  lcd_send_byte(0, fila);
} 
/******************************************************************************/
void lcd_chr(char fila, char col, char c){
  lcd_gotoxy(fila, col);
  lcd_send_byte(1, c);
} 
/******************************************************************************/
void lcd_out(char fila, char col, char *texto){
  char cont = 0;
  
  lcd_gotoxy(fila, col);
  while(texto[cont])
    lcd_send_byte(1, texto[cont++]);
}
/******************************************************************************/
void lcd_outConst(char fila, char col, const char *texto){
  char cont = 0;

  lcd_gotoxy(fila, col);
  while(texto[cont])
    lcd_send_byte(1, texto[cont++]);
}
/******************************************************************************/
void lcd_cmd(char comando){
  lcd_send_byte(0, comando);
  Delay_ms(2);
}
/******************************************************************************/