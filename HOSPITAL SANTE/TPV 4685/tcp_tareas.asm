
_bcdToDec:

;miscelaneos.h,10 :: 		char bcdToDec(char dato){
;miscelaneos.h,11 :: 		dato = 10*(swap(dato)&0x0F) + (dato&0x0F);
	MOVF        FARG_bcdToDec_dato+0, 0 
	MOVWF       FARG_Swap_input+0 
	CALL        _Swap+0, 0
	MOVLW       15
	ANDWF       R0, 1 
	MOVLW       10
	MULWF       R0 
	MOVF        PRODL+0, 0 
	MOVWF       R1 
	MOVLW       15
	ANDWF       FARG_bcdToDec_dato+0, 0 
	MOVWF       R0 
	MOVF        R1, 0 
	ADDWF       R0, 1 
	MOVF        R0, 0 
	MOVWF       FARG_bcdToDec_dato+0 
;miscelaneos.h,13 :: 		return dato;
;miscelaneos.h,14 :: 		}
L_end_bcdToDec:
	RETURN      0
; end of _bcdToDec

_decToBcd:

;miscelaneos.h,16 :: 		char decToBcd(char dato){
;miscelaneos.h,17 :: 		dato = swap(dato/10) + (dato%10);
	MOVLW       10
	MOVWF       R4 
	MOVF        FARG_decToBcd_dato+0, 0 
	MOVWF       R0 
	CALL        _Div_8x8_U+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_Swap_input+0 
	CALL        _Swap+0, 0
	MOVF        R0, 0 
	MOVWF       FLOC__decToBcd+0 
	MOVLW       10
	MOVWF       R4 
	MOVF        FARG_decToBcd_dato+0, 0 
	MOVWF       R0 
	CALL        _Div_8x8_U+0, 0
	MOVF        R8, 0 
	MOVWF       R0 
	MOVF        FLOC__decToBcd+0, 0 
	ADDWF       R0, 1 
	MOVF        R0, 0 
	MOVWF       FARG_decToBcd_dato+0 
;miscelaneos.h,19 :: 		return dato;
;miscelaneos.h,20 :: 		}
L_end_decToBcd:
	RETURN      0
; end of _decToBcd

_RomToRam:

;miscelaneos.h,22 :: 		char* RomToRam(const char *origen, char *destino){
;miscelaneos.h,23 :: 		unsigned int cont = 0;
	CLRF        RomToRam_cont_L0+0 
	CLRF        RomToRam_cont_L0+1 
;miscelaneos.h,25 :: 		while(destino[cont] = origen[cont++]);
L_RomToRam0:
	MOVF        RomToRam_cont_L0+0, 0 
	ADDWF       FARG_RomToRam_destino+0, 0 
	MOVWF       R2 
	MOVF        RomToRam_cont_L0+1, 0 
	ADDWFC      FARG_RomToRam_destino+1, 0 
	MOVWF       R3 
	MOVF        RomToRam_cont_L0+0, 0 
	MOVWF       R0 
	MOVF        RomToRam_cont_L0+1, 0 
	MOVWF       R1 
	INFSNZ      RomToRam_cont_L0+0, 1 
	INCF        RomToRam_cont_L0+1, 1 
	MOVF        R0, 0 
	ADDWF       FARG_RomToRam_origen+0, 0 
	MOVWF       TBLPTRL 
	MOVF        R1, 0 
	ADDWFC      FARG_RomToRam_origen+1, 0 
	MOVWF       TBLPTRH 
	MOVLW       0
	ADDWFC      FARG_RomToRam_origen+2, 0 
	MOVWF       TBLPTRU 
	TBLRD*+
	MOVFF       TABLAT+0, R0
	MOVFF       R2, FSR1
	MOVFF       R3, FSR1H
	MOVF        R0, 0 
	MOVWF       POSTINC1+0 
	MOVFF       R2, FSR0
	MOVFF       R3, FSR0H
	MOVF        POSTINC0+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_RomToRam1
	GOTO        L_RomToRam0
L_RomToRam1:
;miscelaneos.h,27 :: 		return destino;
	MOVF        FARG_RomToRam_destino+0, 0 
	MOVWF       R0 
	MOVF        FARG_RomToRam_destino+1, 0 
	MOVWF       R1 
;miscelaneos.h,28 :: 		}
L_end_RomToRam:
	RETURN      0
; end of _RomToRam

_clamp:

;miscelaneos.h,30 :: 		long clamp(long valor, long min, long max){
;miscelaneos.h,31 :: 		if(valor > max)
	MOVLW       128
	XORWF       FARG_clamp_max+3, 0 
	MOVWF       R0 
	MOVLW       128
	XORWF       FARG_clamp_valor+3, 0 
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__clamp74
	MOVF        FARG_clamp_valor+2, 0 
	SUBWF       FARG_clamp_max+2, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__clamp74
	MOVF        FARG_clamp_valor+1, 0 
	SUBWF       FARG_clamp_max+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__clamp74
	MOVF        FARG_clamp_valor+0, 0 
	SUBWF       FARG_clamp_max+0, 0 
L__clamp74:
	BTFSC       STATUS+0, 0 
	GOTO        L_clamp2
;miscelaneos.h,32 :: 		valor = max;
	MOVF        FARG_clamp_max+0, 0 
	MOVWF       FARG_clamp_valor+0 
	MOVF        FARG_clamp_max+1, 0 
	MOVWF       FARG_clamp_valor+1 
	MOVF        FARG_clamp_max+2, 0 
	MOVWF       FARG_clamp_valor+2 
	MOVF        FARG_clamp_max+3, 0 
	MOVWF       FARG_clamp_valor+3 
	GOTO        L_clamp3
L_clamp2:
;miscelaneos.h,33 :: 		else if(valor < min)
	MOVLW       128
	XORWF       FARG_clamp_valor+3, 0 
	MOVWF       R0 
	MOVLW       128
	XORWF       FARG_clamp_min+3, 0 
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__clamp75
	MOVF        FARG_clamp_min+2, 0 
	SUBWF       FARG_clamp_valor+2, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__clamp75
	MOVF        FARG_clamp_min+1, 0 
	SUBWF       FARG_clamp_valor+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__clamp75
	MOVF        FARG_clamp_min+0, 0 
	SUBWF       FARG_clamp_valor+0, 0 
L__clamp75:
	BTFSC       STATUS+0, 0 
	GOTO        L_clamp4
;miscelaneos.h,34 :: 		valor = min;
	MOVF        FARG_clamp_min+0, 0 
	MOVWF       FARG_clamp_valor+0 
	MOVF        FARG_clamp_min+1, 0 
	MOVWF       FARG_clamp_valor+1 
	MOVF        FARG_clamp_min+2, 0 
	MOVWF       FARG_clamp_valor+2 
	MOVF        FARG_clamp_min+3, 0 
	MOVWF       FARG_clamp_valor+3 
L_clamp4:
L_clamp3:
;miscelaneos.h,36 :: 		return valor;
	MOVF        FARG_clamp_valor+0, 0 
	MOVWF       R0 
	MOVF        FARG_clamp_valor+1, 0 
	MOVWF       R1 
	MOVF        FARG_clamp_valor+2, 0 
	MOVWF       R2 
	MOVF        FARG_clamp_valor+3, 0 
	MOVWF       R3 
;miscelaneos.h,37 :: 		}
L_end_clamp:
	RETURN      0
; end of _clamp

_clamp_shift:

;miscelaneos.h,39 :: 		long clamp_shift(long valor, long min, long max){
;miscelaneos.h,40 :: 		if(valor > max)
	MOVLW       128
	XORWF       FARG_clamp_shift_max+3, 0 
	MOVWF       R0 
	MOVLW       128
	XORWF       FARG_clamp_shift_valor+3, 0 
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__clamp_shift77
	MOVF        FARG_clamp_shift_valor+2, 0 
	SUBWF       FARG_clamp_shift_max+2, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__clamp_shift77
	MOVF        FARG_clamp_shift_valor+1, 0 
	SUBWF       FARG_clamp_shift_max+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__clamp_shift77
	MOVF        FARG_clamp_shift_valor+0, 0 
	SUBWF       FARG_clamp_shift_max+0, 0 
L__clamp_shift77:
	BTFSC       STATUS+0, 0 
	GOTO        L_clamp_shift5
;miscelaneos.h,41 :: 		valor = min;
	MOVF        FARG_clamp_shift_min+0, 0 
	MOVWF       FARG_clamp_shift_valor+0 
	MOVF        FARG_clamp_shift_min+1, 0 
	MOVWF       FARG_clamp_shift_valor+1 
	MOVF        FARG_clamp_shift_min+2, 0 
	MOVWF       FARG_clamp_shift_valor+2 
	MOVF        FARG_clamp_shift_min+3, 0 
	MOVWF       FARG_clamp_shift_valor+3 
	GOTO        L_clamp_shift6
L_clamp_shift5:
;miscelaneos.h,42 :: 		else if(valor < min)
	MOVLW       128
	XORWF       FARG_clamp_shift_valor+3, 0 
	MOVWF       R0 
	MOVLW       128
	XORWF       FARG_clamp_shift_min+3, 0 
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__clamp_shift78
	MOVF        FARG_clamp_shift_min+2, 0 
	SUBWF       FARG_clamp_shift_valor+2, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__clamp_shift78
	MOVF        FARG_clamp_shift_min+1, 0 
	SUBWF       FARG_clamp_shift_valor+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__clamp_shift78
	MOVF        FARG_clamp_shift_min+0, 0 
	SUBWF       FARG_clamp_shift_valor+0, 0 
L__clamp_shift78:
	BTFSC       STATUS+0, 0 
	GOTO        L_clamp_shift7
;miscelaneos.h,43 :: 		valor = max;
	MOVF        FARG_clamp_shift_max+0, 0 
	MOVWF       FARG_clamp_shift_valor+0 
	MOVF        FARG_clamp_shift_max+1, 0 
	MOVWF       FARG_clamp_shift_valor+1 
	MOVF        FARG_clamp_shift_max+2, 0 
	MOVWF       FARG_clamp_shift_valor+2 
	MOVF        FARG_clamp_shift_max+3, 0 
	MOVWF       FARG_clamp_shift_valor+3 
L_clamp_shift7:
L_clamp_shift6:
;miscelaneos.h,45 :: 		return valor;
	MOVF        FARG_clamp_shift_valor+0, 0 
	MOVWF       R0 
	MOVF        FARG_clamp_shift_valor+1, 0 
	MOVWF       R1 
	MOVF        FARG_clamp_shift_valor+2, 0 
	MOVWF       R2 
	MOVF        FARG_clamp_shift_valor+3, 0 
	MOVWF       R3 
;miscelaneos.h,46 :: 		}
L_end_clamp_shift:
	RETURN      0
; end of _clamp_shift

_spi_tcp_read:

;spi_tcp.h,28 :: 		char spi_tcp_read(char reg, bool reg_eth){
;spi_tcp.h,29 :: 		SPI_CS = 0;
	BCF         SPI_CS+0, BitPos(SPI_CS+0) 
;spi_tcp.h,30 :: 		SPI1_write(ETH_READ_CMD|reg);
	MOVF        FARG_spi_tcp_read_reg+0, 0 
	MOVWF       FARG_SPI1_Write_data_+0 
	CALL        _SPI1_Write+0, 0
;spi_tcp.h,31 :: 		reg = SPI1_read(0);     //Comando ETH
	CLRF        FARG_SPI1_Read_buffer+0 
	CALL        _SPI1_Read+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_spi_tcp_read_reg+0 
;spi_tcp.h,32 :: 		if(!reg_eth)
	MOVF        FARG_spi_tcp_read_reg_eth+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_spi_tcp_read8
;spi_tcp.h,33 :: 		reg = SPI1_read(0);   //Comando MII ó MAC
	CLRF        FARG_SPI1_Read_buffer+0 
	CALL        _SPI1_Read+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_spi_tcp_read_reg+0 
L_spi_tcp_read8:
;spi_tcp.h,34 :: 		SPI_CS = 1;
	BSF         SPI_CS+0, BitPos(SPI_CS+0) 
;spi_tcp.h,36 :: 		return reg;
	MOVF        FARG_spi_tcp_read_reg+0, 0 
	MOVWF       R0 
;spi_tcp.h,37 :: 		}
L_end_spi_tcp_read:
	RETURN      0
; end of _spi_tcp_read

_spi_tcp_write:

;spi_tcp.h,39 :: 		void spi_tcp_write(char reg, char value){
;spi_tcp.h,40 :: 		SPI_CS = 0;
	BCF         SPI_CS+0, BitPos(SPI_CS+0) 
;spi_tcp.h,41 :: 		SPI1_write(ETH_WRITE_CMD|reg);
	MOVLW       64
	IORWF       FARG_spi_tcp_write_reg+0, 0 
	MOVWF       FARG_SPI1_Write_data_+0 
	CALL        _SPI1_Write+0, 0
;spi_tcp.h,42 :: 		SPI1_write(value);
	MOVF        FARG_spi_tcp_write_value+0, 0 
	MOVWF       FARG_SPI1_Write_data_+0 
	CALL        _SPI1_Write+0, 0
;spi_tcp.h,43 :: 		SPI_CS = 1;
	BSF         SPI_CS+0, BitPos(SPI_CS+0) 
;spi_tcp.h,44 :: 		}
L_end_spi_tcp_write:
	RETURN      0
; end of _spi_tcp_write

_spi_tcp_read_phy:

;spi_tcp.h,46 :: 		unsigned int spi_tcp_read_phy(char regPHY){
;spi_tcp.h,51 :: 		resp[0] = spi_tcp_read(ECON1, true);
	MOVLW       31
	MOVWF       FARG_spi_tcp_read_reg+0 
	MOVLW       1
	MOVWF       FARG_spi_tcp_read_reg_eth+0 
	CALL        _spi_tcp_read+0, 0
	MOVF        R0, 0 
	MOVWF       spi_tcp_read_phy_resp_L0+0 
;spi_tcp.h,52 :: 		banco = resp[0];
	MOVF        R0, 0 
	MOVWF       spi_tcp_read_phy_banco_L0+0 
;spi_tcp.h,53 :: 		resp[0].B0 = 0;
	BCF         spi_tcp_read_phy_resp_L0+0, 0 
;spi_tcp.h,54 :: 		resp[0].B1 = 1;
	BSF         spi_tcp_read_phy_resp_L0+0, 1 
;spi_tcp.h,55 :: 		spi_tcp_write(ECON1, resp[0]);
	MOVLW       31
	MOVWF       FARG_spi_tcp_write_reg+0 
	MOVF        spi_tcp_read_phy_resp_L0+0, 0 
	MOVWF       FARG_spi_tcp_write_value+0 
	CALL        _spi_tcp_write+0, 0
;spi_tcp.h,56 :: 		resp[1] = spi_tcp_read(MICMD, false);
	MOVLW       18
	MOVWF       FARG_spi_tcp_read_reg+0 
	CLRF        FARG_spi_tcp_read_reg_eth+0 
	CALL        _spi_tcp_read+0, 0
	MOVF        R0, 0 
	MOVWF       spi_tcp_read_phy_resp_L0+1 
;spi_tcp.h,58 :: 		spi_tcp_write(MIREGADR, regPHY);
	MOVLW       20
	MOVWF       FARG_spi_tcp_write_reg+0 
	MOVF        FARG_spi_tcp_read_phy_regPHY+0, 0 
	MOVWF       FARG_spi_tcp_write_value+0 
	CALL        _spi_tcp_write+0, 0
;spi_tcp.h,60 :: 		resp[1].B0 = 1;
	BSF         spi_tcp_read_phy_resp_L0+1, 0 
;spi_tcp.h,61 :: 		spi_tcp_write(MICMD, resp[1]);
	MOVLW       18
	MOVWF       FARG_spi_tcp_write_reg+0 
	MOVF        spi_tcp_read_phy_resp_L0+1, 0 
	MOVWF       FARG_spi_tcp_write_value+0 
	CALL        _spi_tcp_write+0, 0
;spi_tcp.h,62 :: 		delay_us(12);              //Asegurar bit
	MOVLW       9
	MOVWF       R13, 0
L_spi_tcp_read_phy9:
	DECFSZ      R13, 1, 1
	BRA         L_spi_tcp_read_phy9
	NOP
	NOP
;spi_tcp.h,64 :: 		resp[0].B0 = 1;
	BSF         spi_tcp_read_phy_resp_L0+0, 0 
;spi_tcp.h,65 :: 		resp[0].B1 = 1;
	BSF         spi_tcp_read_phy_resp_L0+0, 1 
;spi_tcp.h,66 :: 		spi_tcp_write(ECON1, resp[0]);
	MOVLW       31
	MOVWF       FARG_spi_tcp_write_reg+0 
	MOVF        spi_tcp_read_phy_resp_L0+0, 0 
	MOVWF       FARG_spi_tcp_write_value+0 
	CALL        _spi_tcp_write+0, 0
;spi_tcp.h,68 :: 		while(spi_tcp_read(MISTAT, false).B0);   //Esparar a que se desocupe el bit
L_spi_tcp_read_phy10:
	MOVLW       10
	MOVWF       FARG_spi_tcp_read_reg+0 
	CLRF        FARG_spi_tcp_read_reg_eth+0 
	CALL        _spi_tcp_read+0, 0
	BTFSS       R0, 0 
	GOTO        L_spi_tcp_read_phy11
	GOTO        L_spi_tcp_read_phy10
L_spi_tcp_read_phy11:
;spi_tcp.h,70 :: 		resp[0].B0 = 0;
	BCF         spi_tcp_read_phy_resp_L0+0, 0 
;spi_tcp.h,71 :: 		resp[0].B1 = 1;
	BSF         spi_tcp_read_phy_resp_L0+0, 1 
;spi_tcp.h,72 :: 		spi_tcp_write(ECON1, resp[0]);
	MOVLW       31
	MOVWF       FARG_spi_tcp_write_reg+0 
	MOVF        spi_tcp_read_phy_resp_L0+0, 0 
	MOVWF       FARG_spi_tcp_write_value+0 
	CALL        _spi_tcp_write+0, 0
;spi_tcp.h,74 :: 		resp[1].B0 = 0;
	BCF         spi_tcp_read_phy_resp_L0+1, 0 
;spi_tcp.h,75 :: 		spi_tcp_write(MICMD, resp[1]);
	MOVLW       18
	MOVWF       FARG_spi_tcp_write_reg+0 
	MOVF        spi_tcp_read_phy_resp_L0+1, 0 
	MOVWF       FARG_spi_tcp_write_value+0 
	CALL        _spi_tcp_write+0, 0
;spi_tcp.h,77 :: 		getByte(value, 0) = spi_tcp_read(MIRDL, false);
	MOVLW       24
	MOVWF       FARG_spi_tcp_read_reg+0 
	CLRF        FARG_spi_tcp_read_reg_eth+0 
	CALL        _spi_tcp_read+0, 0
	MOVF        R0, 0 
	MOVWF       spi_tcp_read_phy_value_L0+0 
;spi_tcp.h,78 :: 		getByte(value, 1) = spi_tcp_read(MIRDH, false);
	MOVLW       25
	MOVWF       FARG_spi_tcp_read_reg+0 
	CLRF        FARG_spi_tcp_read_reg_eth+0 
	CALL        _spi_tcp_read+0, 0
	MOVF        R0, 0 
	MOVWF       spi_tcp_read_phy_value_L0+1 
;spi_tcp.h,80 :: 		spi_tcp_write(ECON1, banco);
	MOVLW       31
	MOVWF       FARG_spi_tcp_write_reg+0 
	MOVF        spi_tcp_read_phy_banco_L0+0, 0 
	MOVWF       FARG_spi_tcp_write_value+0 
	CALL        _spi_tcp_write+0, 0
;spi_tcp.h,82 :: 		return value;
	MOVF        spi_tcp_read_phy_value_L0+0, 0 
	MOVWF       R0 
	MOVF        spi_tcp_read_phy_value_L0+1, 0 
	MOVWF       R1 
;spi_tcp.h,83 :: 		}
L_end_spi_tcp_read_phy:
	RETURN      0
; end of _spi_tcp_read_phy

_spi_tcp_linked:

;spi_tcp.h,85 :: 		bool spi_tcp_linked(){
;spi_tcp.h,86 :: 		unsigned int aux = spi_tcp_read_phy(PHSTAT2);
	MOVLW       17
	MOVWF       FARG_spi_tcp_read_phy_regPHY+0 
	CALL        _spi_tcp_read_phy+0, 0
	MOVF        R0, 0 
	MOVWF       spi_tcp_linked_aux_L0+0 
	MOVF        R1, 0 
	MOVWF       spi_tcp_linked_aux_L0+1 
;spi_tcp.h,88 :: 		aux = getByte(aux,1).B2;  //Reciclar sabe si el cable esta conectado
	MOVLW       0
	BTFSC       spi_tcp_linked_aux_L0+1, 2 
	MOVLW       1
	MOVWF       spi_tcp_linked_aux_L0+0 
	CLRF        spi_tcp_linked_aux_L0+1 
;spi_tcp.h,90 :: 		return aux;
	MOVF        spi_tcp_linked_aux_L0+0, 0 
	MOVWF       R0 
;spi_tcp.h,91 :: 		}
L_end_spi_tcp_linked:
	RETURN      0
; end of _spi_tcp_linked

_string_ncopy:

;string.h,4 :: 		char* string_ncopy(char *destino, char *origen, char size){
;string.h,7 :: 		for(cont = 0; cont < size && origen[cont]; cont++)
	CLRF        R2 
L_string_ncopy12:
	MOVF        FARG_string_ncopy_size+0, 0 
	SUBWF       R2, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_string_ncopy13
	MOVF        R2, 0 
	ADDWF       FARG_string_ncopy_origen+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_string_ncopy_origen+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_string_ncopy13
L__string_ncopy64:
;string.h,8 :: 		destino[cont] = origen[cont];
	MOVF        R2, 0 
	ADDWF       FARG_string_ncopy_destino+0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      FARG_string_ncopy_destino+1, 0 
	MOVWF       FSR1H 
	MOVF        R2, 0 
	ADDWF       FARG_string_ncopy_origen+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_string_ncopy_origen+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       POSTINC1+0 
;string.h,7 :: 		for(cont = 0; cont < size && origen[cont]; cont++)
	INCF        R2, 1 
;string.h,8 :: 		destino[cont] = origen[cont];
	GOTO        L_string_ncopy12
L_string_ncopy13:
;string.h,9 :: 		destino[cont] = 0;              //Final de cadena
	MOVF        R2, 0 
	ADDWF       FARG_string_ncopy_destino+0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      FARG_string_ncopy_destino+1, 0 
	MOVWF       FSR1H 
	CLRF        POSTINC1+0 
;string.h,11 :: 		return destino;
	MOVF        FARG_string_ncopy_destino+0, 0 
	MOVWF       R0 
	MOVF        FARG_string_ncopy_destino+1, 0 
	MOVWF       R1 
;string.h,12 :: 		}
L_end_string_ncopy:
	RETURN      0
; end of _string_ncopy

_numToString:

;string.h,14 :: 		char* numToString(long valor, char *cadena, short digitos){
;string.h,15 :: 		cadena[digitos--] = 0;//Agregar final de cadena
	MOVF        FARG_numToString_digitos+0, 0 
	ADDWF       FARG_numToString_cadena+0, 0 
	MOVWF       FSR1 
	MOVLW       0
	BTFSC       FARG_numToString_digitos+0, 7 
	MOVLW       255
	ADDWFC      FARG_numToString_cadena+1, 0 
	MOVWF       FSR1H 
	CLRF        POSTINC1+0 
	DECF        FARG_numToString_digitos+0, 1 
;string.h,16 :: 		while(digitos >= 0){
L_numToString17:
	MOVLW       128
	XORWF       FARG_numToString_digitos+0, 0 
	MOVWF       R0 
	MOVLW       128
	XORLW       0
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 0 
	GOTO        L_numToString18
;string.h,18 :: 		cadena[digitos--] = (valor % 10) + '0';
	MOVF        FARG_numToString_digitos+0, 0 
	ADDWF       FARG_numToString_cadena+0, 0 
	MOVWF       FLOC__numToString+0 
	MOVLW       0
	BTFSC       FARG_numToString_digitos+0, 7 
	MOVLW       255
	ADDWFC      FARG_numToString_cadena+1, 0 
	MOVWF       FLOC__numToString+1 
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVWF       R6 
	MOVWF       R7 
	MOVF        FARG_numToString_valor+0, 0 
	MOVWF       R0 
	MOVF        FARG_numToString_valor+1, 0 
	MOVWF       R1 
	MOVF        FARG_numToString_valor+2, 0 
	MOVWF       R2 
	MOVF        FARG_numToString_valor+3, 0 
	MOVWF       R3 
	CALL        _Div_32x32_S+0, 0
	MOVF        R8, 0 
	MOVWF       R0 
	MOVF        R9, 0 
	MOVWF       R1 
	MOVF        R10, 0 
	MOVWF       R2 
	MOVF        R11, 0 
	MOVWF       R3 
	MOVLW       48
	ADDWF       R0, 1 
	MOVFF       FLOC__numToString+0, FSR1
	MOVFF       FLOC__numToString+1, FSR1H
	MOVF        R0, 0 
	MOVWF       POSTINC1+0 
	DECF        FARG_numToString_digitos+0, 1 
;string.h,19 :: 		valor /= 10;
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVWF       R6 
	MOVWF       R7 
	MOVF        FARG_numToString_valor+0, 0 
	MOVWF       R0 
	MOVF        FARG_numToString_valor+1, 0 
	MOVWF       R1 
	MOVF        FARG_numToString_valor+2, 0 
	MOVWF       R2 
	MOVF        FARG_numToString_valor+3, 0 
	MOVWF       R3 
	CALL        _Div_32x32_S+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_numToString_valor+0 
	MOVF        R1, 0 
	MOVWF       FARG_numToString_valor+1 
	MOVF        R2, 0 
	MOVWF       FARG_numToString_valor+2 
	MOVF        R3, 0 
	MOVWF       FARG_numToString_valor+3 
;string.h,20 :: 		}
	GOTO        L_numToString17
L_numToString18:
;string.h,22 :: 		return cadena;
	MOVF        FARG_numToString_cadena+0, 0 
	MOVWF       R0 
	MOVF        FARG_numToString_cadena+1, 0 
	MOVWF       R1 
;string.h,23 :: 		}
L_end_numToString:
	RETURN      0
; end of _numToString

_numToHex:

;string.h,25 :: 		char* numToHex(long valor, char *cadena, char bytes){
;string.h,26 :: 		char cont = 0;
	CLRF        numToHex_cont_L0+0 
;string.h,29 :: 		while(bytes--){
L_numToHex19:
	MOVF        FARG_numToHex_bytes+0, 0 
	MOVWF       R0 
	DECF        FARG_numToHex_bytes+0, 1 
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_numToHex20
;string.h,31 :: 		cadena[cont] = swap(getByte(valor, bytes))&0x0F;
	MOVF        numToHex_cont_L0+0, 0 
	ADDWF       FARG_numToHex_cadena+0, 0 
	MOVWF       FLOC__numToHex+0 
	MOVLW       0
	ADDWFC      FARG_numToHex_cadena+1, 0 
	MOVWF       FLOC__numToHex+1 
	MOVLW       FARG_numToHex_valor+0
	MOVWF       FSR0 
	MOVLW       hi_addr(FARG_numToHex_valor+0)
	MOVWF       FSR0H 
	MOVF        FARG_numToHex_bytes+0, 0 
	ADDWF       FSR0, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR0H, 1 
	MOVF        POSTINC0+0, 0 
	MOVWF       FARG_Swap_input+0 
	CALL        _Swap+0, 0
	MOVLW       15
	ANDWF       R0, 1 
	MOVFF       FLOC__numToHex+0, FSR1
	MOVFF       FLOC__numToHex+1, FSR1H
	MOVF        R0, 0 
	MOVWF       POSTINC1+0 
;string.h,32 :: 		if(cadena[cont] < 0x0A)
	MOVF        numToHex_cont_L0+0, 0 
	ADDWF       FARG_numToHex_cadena+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_numToHex_cadena+1, 0 
	MOVWF       FSR0H 
	MOVLW       10
	SUBWF       POSTINC0+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_numToHex21
;string.h,33 :: 		cadena[cont] = cadena[cont] + '0';
	MOVF        numToHex_cont_L0+0, 0 
	ADDWF       FARG_numToHex_cadena+0, 0 
	MOVWF       R1 
	MOVLW       0
	ADDWFC      FARG_numToHex_cadena+1, 0 
	MOVWF       R2 
	MOVFF       R1, FSR0
	MOVFF       R2, FSR0H
	MOVLW       48
	ADDWF       POSTINC0+0, 0 
	MOVWF       R0 
	MOVFF       R1, FSR1
	MOVFF       R2, FSR1H
	MOVF        R0, 0 
	MOVWF       POSTINC1+0 
	GOTO        L_numToHex22
L_numToHex21:
;string.h,35 :: 		cadena[cont] = cadena[cont] + '7';  //Compenso la letra A
	MOVF        numToHex_cont_L0+0, 0 
	ADDWF       FARG_numToHex_cadena+0, 0 
	MOVWF       R1 
	MOVLW       0
	ADDWFC      FARG_numToHex_cadena+1, 0 
	MOVWF       R2 
	MOVFF       R1, FSR0
	MOVFF       R2, FSR0H
	MOVLW       55
	ADDWF       POSTINC0+0, 0 
	MOVWF       R0 
	MOVFF       R1, FSR1
	MOVFF       R2, FSR1H
	MOVF        R0, 0 
	MOVWF       POSTINC1+0 
L_numToHex22:
;string.h,36 :: 		cont++;
	INCF        numToHex_cont_L0+0, 1 
;string.h,38 :: 		cadena[cont] = getByte(valor, bytes)&0x0F;
	MOVF        numToHex_cont_L0+0, 0 
	ADDWF       FARG_numToHex_cadena+0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      FARG_numToHex_cadena+1, 0 
	MOVWF       FSR1H 
	MOVLW       FARG_numToHex_valor+0
	MOVWF       FSR0 
	MOVLW       hi_addr(FARG_numToHex_valor+0)
	MOVWF       FSR0H 
	MOVF        FARG_numToHex_bytes+0, 0 
	ADDWF       FSR0, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR0H, 1 
	MOVLW       15
	ANDWF       POSTINC0+0, 0 
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       POSTINC1+0 
;string.h,39 :: 		if(cadena[cont] < 0x0A)
	MOVF        numToHex_cont_L0+0, 0 
	ADDWF       FARG_numToHex_cadena+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_numToHex_cadena+1, 0 
	MOVWF       FSR0H 
	MOVLW       10
	SUBWF       POSTINC0+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_numToHex23
;string.h,40 :: 		cadena[cont] = cadena[cont] + '0';
	MOVF        numToHex_cont_L0+0, 0 
	ADDWF       FARG_numToHex_cadena+0, 0 
	MOVWF       R1 
	MOVLW       0
	ADDWFC      FARG_numToHex_cadena+1, 0 
	MOVWF       R2 
	MOVFF       R1, FSR0
	MOVFF       R2, FSR0H
	MOVLW       48
	ADDWF       POSTINC0+0, 0 
	MOVWF       R0 
	MOVFF       R1, FSR1
	MOVFF       R2, FSR1H
	MOVF        R0, 0 
	MOVWF       POSTINC1+0 
	GOTO        L_numToHex24
L_numToHex23:
;string.h,42 :: 		cadena[cont] = cadena[cont] + '7';  //Compenso la letra A
	MOVF        numToHex_cont_L0+0, 0 
	ADDWF       FARG_numToHex_cadena+0, 0 
	MOVWF       R1 
	MOVLW       0
	ADDWFC      FARG_numToHex_cadena+1, 0 
	MOVWF       R2 
	MOVFF       R1, FSR0
	MOVFF       R2, FSR0H
	MOVLW       55
	ADDWF       POSTINC0+0, 0 
	MOVWF       R0 
	MOVFF       R1, FSR1
	MOVFF       R2, FSR1H
	MOVF        R0, 0 
	MOVWF       POSTINC1+0 
L_numToHex24:
;string.h,43 :: 		cont++;
	INCF        numToHex_cont_L0+0, 1 
;string.h,44 :: 		}
	GOTO        L_numToHex19
L_numToHex20:
;string.h,45 :: 		cadena[cont] = 0;
	MOVF        numToHex_cont_L0+0, 0 
	ADDWF       FARG_numToHex_cadena+0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      FARG_numToHex_cadena+1, 0 
	MOVWF       FSR1H 
	CLRF        POSTINC1+0 
;string.h,47 :: 		return cadena;
	MOVF        FARG_numToHex_cadena+0, 0 
	MOVWF       R0 
	MOVF        FARG_numToHex_cadena+1, 0 
	MOVWF       R1 
;string.h,48 :: 		}
L_end_numToHex:
	RETURN      0
; end of _numToHex

_usart_open:

;lib_usart.h,35 :: 		void usart_open(unsigned long baudRate){
;lib_usart.h,37 :: 		TXSTA.CSRC = 0;   //NO IMPORTA, MODO ASYNCHRONO
	BCF         TXSTA+0, 7 
;lib_usart.h,38 :: 		TXSTA.TX9 = 0;    //MODO 8 BITS DE TRANSMISION
	BCF         TXSTA+0, 6 
;lib_usart.h,39 :: 		TXSTA.TXEN = 1;   //DISPONIBLE TX
	BSF         TXSTA+0, 5 
;lib_usart.h,40 :: 		TXSTA.SYNC = 0;   //MODO ASYNCHRONO
	BCF         TXSTA+0, 4 
;lib_usart.h,41 :: 		TXSTA.SENDB = 0;  //ENVIAR ROTURA DE TRANSMISION COMPLETADA ***
	BCF         TXSTA+0, 3 
;lib_usart.h,42 :: 		TXSTA.BRGH = 1;   //0 - LOW SPEED, 1 - HIHG SPEED
	BSF         TXSTA+0, 2 
;lib_usart.h,44 :: 		TXSTA.TX9D = 0;   //BIT DE PARIDAD
	BCF         TXSTA+0, 0 
;lib_usart.h,47 :: 		RCSTA.RX9 = 0;    //MODO 8 BITS RECEPCION
	BCF         RCSTA+0, 6 
;lib_usart.h,48 :: 		RCSTA.SREN = 0;   //NO IMPORTA, MODO ASYNCHRONO
	BCF         RCSTA+0, 5 
;lib_usart.h,49 :: 		RCSTA.CREN = 1;   //DISPONIBLE RX
	BSF         RCSTA+0, 4 
;lib_usart.h,50 :: 		RCSTA.ADDEN = 0;  //DISABLE INTERRUPT POR RECIBIR EL 9BIT
	BCF         RCSTA+0, 3 
;lib_usart.h,51 :: 		RCSTA.SPEN = 1;   //CONFIGURA PINES RX AND TX COMO SERIALES
	BSF         RCSTA+0, 7 
;lib_usart.h,58 :: 		BAUDCON.SCKP = 0; //NO IMPORTA, MODO ASYNCHRONOS
	BCF         BAUDCON+0, 4 
;lib_usart.h,59 :: 		BAUDCON.BRG16 = 1;//MODO 16 BITS
	BSF         BAUDCON+0, 3 
;lib_usart.h,60 :: 		BAUDCON.WUE = 0;  //PIN RX NO ES MONITORIADO EN FLANCO DE BAJADA***
	BCF         BAUDCON+0, 1 
;lib_usart.h,61 :: 		BAUDCON.ABDEN = 0;//DISABLE MODO MEDICION DE BAUDIOS***
	BCF         BAUDCON+0, 0 
;lib_usart.h,65 :: 		baudRate >>= 1;                           //Divido sobre dos
	MOVF        FARG_usart_open_baudRate+0, 0 
	MOVWF       R0 
	MOVF        FARG_usart_open_baudRate+1, 0 
	MOVWF       R1 
	MOVF        FARG_usart_open_baudRate+2, 0 
	MOVWF       R2 
	MOVF        FARG_usart_open_baudRate+3, 0 
	MOVWF       R3 
	RRCF        R3, 1 
	RRCF        R2, 1 
	RRCF        R1, 1 
	RRCF        R0, 1 
	BCF         R3, 7 
	MOVF        R0, 0 
	MOVWF       FARG_usart_open_baudRate+0 
	MOVF        R1, 0 
	MOVWF       FARG_usart_open_baudRate+1 
	MOVF        R2, 0 
	MOVWF       FARG_usart_open_baudRate+2 
	MOVF        R3, 0 
	MOVWF       FARG_usart_open_baudRate+3 
;lib_usart.h,66 :: 		baudRate = (Clock_MHz()*250e3)/baudRate;  //Fosc/(Baudios/2)
	CALL        _Longword2Double+0, 0
	MOVF        R0, 0 
	MOVWF       R4 
	MOVF        R1, 0 
	MOVWF       R5 
	MOVF        R2, 0 
	MOVWF       R6 
	MOVF        R3, 0 
	MOVWF       R7 
	MOVLW       128
	MOVWF       R0 
	MOVLW       150
	MOVWF       R1 
	MOVLW       24
	MOVWF       R2 
	MOVLW       148
	MOVWF       R3 
	CALL        _Div_32x32_FP+0, 0
	CALL        _Double2Longword+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_usart_open_baudRate+0 
	MOVF        R1, 0 
	MOVWF       FARG_usart_open_baudRate+1 
	MOVF        R2, 0 
	MOVWF       FARG_usart_open_baudRate+2 
	MOVF        R3, 0 
	MOVWF       FARG_usart_open_baudRate+3 
;lib_usart.h,67 :: 		baudRate += 1;                            //Sumar uno por compute round
	MOVLW       1
	ADDWF       R0, 0 
	MOVWF       FARG_usart_open_baudRate+0 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FARG_usart_open_baudRate+1 
	MOVLW       0
	ADDWFC      R2, 0 
	MOVWF       FARG_usart_open_baudRate+2 
	MOVLW       0
	ADDWFC      R3, 0 
	MOVWF       FARG_usart_open_baudRate+3 
;lib_usart.h,68 :: 		baudRate >>= 1;                           //Divido sobre dos
	RRCF        FARG_usart_open_baudRate+3, 1 
	RRCF        FARG_usart_open_baudRate+2, 1 
	RRCF        FARG_usart_open_baudRate+1, 1 
	RRCF        FARG_usart_open_baudRate+0, 1 
	BCF         FARG_usart_open_baudRate+3, 7 
;lib_usart.h,69 :: 		baudRate -= 1;                            //Resto -1, formula
	MOVLW       1
	SUBWF       FARG_usart_open_baudRate+0, 1 
	MOVLW       0
	SUBWFB      FARG_usart_open_baudRate+1, 1 
	SUBWFB      FARG_usart_open_baudRate+2, 1 
	SUBWFB      FARG_usart_open_baudRate+3, 1 
;lib_usart.h,70 :: 		SPBRG = getByte(baudRate,0);
	MOVF        FARG_usart_open_baudRate+0, 0 
	MOVWF       SPBRG+0 
;lib_usart.h,71 :: 		SPBRGH = getByte(baudRate,1);
	MOVF        FARG_usart_open_baudRate+1, 0 
	MOVWF       SPBRGH+0 
;lib_usart.h,74 :: 		TRISC.B6 = 0;   //TX
	BCF         TRISC+0, 6 
;lib_usart.h,75 :: 		TRISC.B7 = 1;   //RX
	BSF         TRISC+0, 7 
;lib_usart.h,78 :: 		while(!TXSTA.TRMT);
L_usart_open25:
	BTFSC       TXSTA+0, 1 
	GOTO        L_usart_open26
	GOTO        L_usart_open25
L_usart_open26:
;lib_usart.h,79 :: 		}
L_end_usart_open:
	RETURN      0
; end of _usart_open

_usart_read:

;lib_usart.h,81 :: 		bool usart_read(char *result){
;lib_usart.h,82 :: 		if(PIR1.RCIF){
	BTFSS       PIR1+0, 5 
	GOTO        L_usart_read27
;lib_usart.h,83 :: 		*result = RCREG;
	MOVFF       FARG_usart_read_result+0, FSR1
	MOVFF       FARG_usart_read_result+1, FSR1H
	MOVF        RCREG+0, 0 
	MOVWF       POSTINC1+0 
;lib_usart.h,84 :: 		PIR1.RCIF = 0;
	BCF         PIR1+0, 5 
;lib_usart.h,85 :: 		return true;
	MOVLW       1
	MOVWF       R0 
	GOTO        L_end_usart_read
;lib_usart.h,86 :: 		}
L_usart_read27:
;lib_usart.h,88 :: 		return false;
	CLRF        R0 
;lib_usart.h,89 :: 		}
L_end_usart_read:
	RETURN      0
; end of _usart_read

_usart_write:

;lib_usart.h,91 :: 		void usart_write(char caracter){
;lib_usart.h,92 :: 		TXREG = caracter;
	MOVF        FARG_usart_write_caracter+0, 0 
	MOVWF       TXREG+0 
;lib_usart.h,93 :: 		while(!TXSTA.TRMT);  //Esperar a que el buffer se vacie
L_usart_write28:
	BTFSC       TXSTA+0, 1 
	GOTO        L_usart_write29
	GOTO        L_usart_write28
L_usart_write29:
;lib_usart.h,94 :: 		}
L_end_usart_write:
	RETURN      0
; end of _usart_write

_usart_write_text:

;lib_usart.h,96 :: 		void usart_write_text(char *texto){
;lib_usart.h,97 :: 		char cont = 0;
	CLRF        usart_write_text_cont_L0+0 
;lib_usart.h,99 :: 		while(texto[cont]){
L_usart_write_text30:
	MOVF        usart_write_text_cont_L0+0, 0 
	ADDWF       FARG_usart_write_text_texto+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_usart_write_text_texto+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_usart_write_text31
;lib_usart.h,100 :: 		TXREG = texto[cont++];
	MOVF        usart_write_text_cont_L0+0, 0 
	ADDWF       FARG_usart_write_text_texto+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_usart_write_text_texto+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       TXREG+0 
	INCF        usart_write_text_cont_L0+0, 1 
;lib_usart.h,101 :: 		while(!TXSTA.TRMT);    //Esperar a que el buffer se vacie en evnvio
L_usart_write_text32:
	BTFSC       TXSTA+0, 1 
	GOTO        L_usart_write_text33
	GOTO        L_usart_write_text32
L_usart_write_text33:
;lib_usart.h,102 :: 		}
	GOTO        L_usart_write_text30
L_usart_write_text31:
;lib_usart.h,103 :: 		}
L_end_usart_write_text:
	RETURN      0
; end of _usart_write_text

_usart_enable_rx:

;lib_usart.h,105 :: 		void usart_enable_rx(bool enable, bool priorityHigh, char delimitir){
;lib_usart.h,107 :: 		usart.rx_cont = 0;  //POSICION INICIAL
	CLRF        _usart+19 
;lib_usart.h,108 :: 		usart.rx_delimiter = delimitir;
	MOVF        FARG_usart_enable_rx_delimitir+0, 0 
	MOVWF       _usart+16 
;lib_usart.h,109 :: 		usart.rx_new_message = false;
	CLRF        _usart+17 
;lib_usart.h,110 :: 		usart.rx_overflow = false;
	CLRF        _usart+18 
;lib_usart.h,113 :: 		IPR1.RCIP = priorityHigh;
	BTFSC       FARG_usart_enable_rx_priorityHigh+0, 0 
	GOTO        L__usart_enable_rx91
	BCF         IPR1+0, 5 
	GOTO        L__usart_enable_rx92
L__usart_enable_rx91:
	BSF         IPR1+0, 5 
L__usart_enable_rx92:
;lib_usart.h,114 :: 		PIR1.RCIF = 0;
	BCF         PIR1+0, 5 
;lib_usart.h,115 :: 		PIE1.RCIE = enable;
	BTFSC       FARG_usart_enable_rx_enable+0, 0 
	GOTO        L__usart_enable_rx93
	BCF         PIE1+0, 5 
	GOTO        L__usart_enable_rx94
L__usart_enable_rx93:
	BSF         PIE1+0, 5 
L__usart_enable_rx94:
;lib_usart.h,116 :: 		}
L_end_usart_enable_rx:
	RETURN      0
; end of _usart_enable_rx

_usart_enable_tx:

;lib_usart.h,118 :: 		void usart_enable_tx(bool priorityHigh){
;lib_usart.h,120 :: 		usart.tx_free = true;
	MOVLW       1
	MOVWF       _usart+20 
;lib_usart.h,121 :: 		usart.tx_cont = 0;  //POSICION INICIAL
	CLRF        _usart+21 
;lib_usart.h,124 :: 		IPR1.TXIP = priorityHigh;
	BTFSC       FARG_usart_enable_tx_priorityHigh+0, 0 
	GOTO        L__usart_enable_tx96
	BCF         IPR1+0, 4 
	GOTO        L__usart_enable_tx97
L__usart_enable_tx96:
	BSF         IPR1+0, 4 
L__usart_enable_tx97:
;lib_usart.h,125 :: 		PIR1.TXIF = 0;
	BCF         PIR1+0, 4 
;lib_usart.h,126 :: 		PIE1.TXIE = 0;
	BCF         PIE1+0, 4 
;lib_usart.h,127 :: 		}
L_end_usart_enable_tx:
	RETURN      0
; end of _usart_enable_tx

_usart_do_read_text:

;lib_usart.h,129 :: 		void usart_do_read_text(){
;lib_usart.h,131 :: 		if(usart.rx_new_message){
	MOVF        _usart+17, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_usart_do_read_text34
;lib_usart.h,132 :: 		usart_user_read_text();
	CALL        _usart_user_read_text+0, 0
;lib_usart.h,133 :: 		usart.rx_new_message = false;
	CLRF        _usart+17 
;lib_usart.h,134 :: 		}
L_usart_do_read_text34:
;lib_usart.h,135 :: 		}
L_end_usart_do_read_text:
	RETURN      0
; end of _usart_do_read_text

_usart_write_text_int:

;lib_usart.h,137 :: 		bool usart_write_text_int(char *texto){
;lib_usart.h,139 :: 		if(usart.tx_free && TXSTA.TRMT){
	MOVF        _usart+20, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_usart_write_text_int37
	BTFSS       TXSTA+0, 1 
	GOTO        L_usart_write_text_int37
L__usart_write_text_int65:
;lib_usart.h,140 :: 		usart.tx_free = false;
	CLRF        _usart+20 
;lib_usart.h,142 :: 		string_ncopy(usart.tx_buffer, texto, UART_BUFFER_SIZE-1);
	MOVLW       _usart+22
	MOVWF       FARG_string_ncopy_destino+0 
	MOVLW       hi_addr(_usart+22)
	MOVWF       FARG_string_ncopy_destino+1 
	MOVF        FARG_usart_write_text_int_texto+0, 0 
	MOVWF       FARG_string_ncopy_origen+0 
	MOVF        FARG_usart_write_text_int_texto+1, 0 
	MOVWF       FARG_string_ncopy_origen+1 
	MOVLW       15
	MOVWF       FARG_string_ncopy_size+0 
	CALL        _string_ncopy+0, 0
;lib_usart.h,143 :: 		usart.tx_cont = 0;  //POSICION INICIAL
	CLRF        _usart+21 
;lib_usart.h,144 :: 		PIE1.TXIE = 1;
	BSF         PIE1+0, 4 
;lib_usart.h,145 :: 		return true;
	MOVLW       1
	MOVWF       R0 
	GOTO        L_end_usart_write_text_int
;lib_usart.h,146 :: 		}
L_usart_write_text_int37:
;lib_usart.h,148 :: 		return false;
	CLRF        R0 
;lib_usart.h,149 :: 		}
L_end_usart_write_text_int:
	RETURN      0
; end of _usart_write_text_int

_int_usart_rx:

;lib_usart.h,151 :: 		void int_usart_rx(void){
;lib_usart.h,152 :: 		if(PIE1.RCIE && PIR1.RCIF){
	BTFSS       PIE1+0, 5 
	GOTO        L_int_usart_rx40
	BTFSS       PIR1+0, 5 
	GOTO        L_int_usart_rx40
L__int_usart_rx66:
;lib_usart.h,153 :: 		if(!usart.rx_new_message.B0){
	BTFSC       _usart+17, 0 
	GOTO        L_int_usart_rx41
;lib_usart.h,155 :: 		usart.message[usart.rx_cont] = RCREG;
	MOVLW       _usart+0
	MOVWF       FSR1 
	MOVLW       hi_addr(_usart+0)
	MOVWF       FSR1H 
	MOVF        _usart+19, 0 
	ADDWF       FSR1, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR1H, 1 
	MOVF        RCREG+0, 0 
	MOVWF       POSTINC1+0 
;lib_usart.h,157 :: 		if(RCREG == usart.rx_delimiter){
	MOVF        RCREG+0, 0 
	XORWF       _usart+16, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L_int_usart_rx42
;lib_usart.h,159 :: 		usart.rx_new_message.B0 = true;
	BSF         _usart+17, 0 
;lib_usart.h,160 :: 		usart.message[usart.rx_cont] = 0;  //Se le agrega final de cadena
	MOVLW       _usart+0
	MOVWF       FSR1 
	MOVLW       hi_addr(_usart+0)
	MOVWF       FSR1H 
	MOVF        _usart+19, 0 
	ADDWF       FSR1, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR1H, 1 
	CLRF        POSTINC1+0 
;lib_usart.h,162 :: 		usart.rx_cont = 0;
	CLRF        _usart+19 
;lib_usart.h,163 :: 		PIR1.RCIF = 0;
	BCF         PIR1+0, 5 
;lib_usart.h,164 :: 		return;
	GOTO        L_end_int_usart_rx
;lib_usart.h,165 :: 		}
L_int_usart_rx42:
;lib_usart.h,166 :: 		usart.rx_cont++;
	MOVF        _usart+19, 0 
	ADDLW       1
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       _usart+19 
;lib_usart.h,167 :: 		usart.rx_cont &= (UART_BUFFER_SIZE-1);
	MOVLW       15
	ANDWF       _usart+19, 0 
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       _usart+19 
;lib_usart.h,169 :: 		usart.rx_overflow.B0 |= !usart.rx_cont? true:false;
	MOVF        R0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_int_usart_rx43
	MOVLW       1
	MOVWF       R1 
	GOTO        L_int_usart_rx44
L_int_usart_rx43:
	CLRF        R1 
L_int_usart_rx44:
	CLRF        R0 
	BTFSC       _usart+18, 0 
	INCF        R0, 1 
	MOVF        R1, 0 
	IORWF       R0, 1 
	BTFSC       R0, 0 
	GOTO        L__int_usart_rx101
	BCF         _usart+18, 0 
	GOTO        L__int_usart_rx102
L__int_usart_rx101:
	BSF         _usart+18, 0 
L__int_usart_rx102:
;lib_usart.h,170 :: 		}else{
	GOTO        L_int_usart_rx45
L_int_usart_rx41:
;lib_usart.h,171 :: 		RCREG &= 0xFF;  //Realizar and para evitar framing error, *#*
	MOVLW       255
	ANDWF       RCREG+0, 1 
;lib_usart.h,172 :: 		}
L_int_usart_rx45:
;lib_usart.h,173 :: 		PIR1.RCIF = 0;
	BCF         PIR1+0, 5 
;lib_usart.h,174 :: 		}
L_int_usart_rx40:
;lib_usart.h,175 :: 		}
L_end_int_usart_rx:
	RETURN      0
; end of _int_usart_rx

_int_usart_tx:

;lib_usart.h,177 :: 		void int_usart_tx(){
;lib_usart.h,178 :: 		if(PIE1.TXIE && PIR1.TXIF){
	BTFSS       PIE1+0, 4 
	GOTO        L_int_usart_tx48
	BTFSS       PIR1+0, 4 
	GOTO        L_int_usart_tx48
L__int_usart_tx67:
;lib_usart.h,179 :: 		TXREG = usart.tx_buffer[usart.tx_cont++];  //Envia los datos
	MOVLW       _usart+22
	MOVWF       FSR0 
	MOVLW       hi_addr(_usart+22)
	MOVWF       FSR0H 
	MOVF        _usart+21, 0 
	ADDWF       FSR0, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR0H, 1 
	MOVF        POSTINC0+0, 0 
	MOVWF       TXREG+0 
	MOVF        _usart+21, 0 
	ADDLW       1
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       _usart+21 
;lib_usart.h,181 :: 		if(!usart.tx_buffer[usart.tx_cont]){
	MOVLW       _usart+22
	MOVWF       FSR0 
	MOVLW       hi_addr(_usart+22)
	MOVWF       FSR0H 
	MOVF        _usart+21, 0 
	ADDWF       FSR0, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR0H, 1 
	MOVF        POSTINC0+0, 0 
	MOVWF       R0 
	MOVF        R0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_int_usart_tx49
;lib_usart.h,182 :: 		usart.tx_free = true;
	MOVLW       1
	MOVWF       _usart+20 
;lib_usart.h,183 :: 		PIE1.TXIE = 0; //Finaliza transmision
	BCF         PIE1+0, 4 
;lib_usart.h,184 :: 		}
L_int_usart_tx49:
;lib_usart.h,185 :: 		PIR1.TXIF = 0;   //Limpia bandera
	BCF         PIR1+0, 4 
;lib_usart.h,186 :: 		}
L_int_usart_tx48:
;lib_usart.h,187 :: 		}
L_end_int_usart_tx:
	RETURN      0
; end of _int_usart_tx

_Net_Ethernet_28j60_UserTCP:

;tcp_tareas.c,46 :: 		void Net_Ethernet_28j60_UserTCP(SOCKET_28j60_Dsc *socket){
;tcp_tareas.c,56 :: 		if(!sendDataTCP.B0){
	BTFSC       _sendDataTCP+0, 0 
	GOTO        L_Net_Ethernet_28j60_UserTCP50
;tcp_tareas.c,58 :: 		if(!socket->dataLength)
	MOVLW       14
	ADDWF       FARG_Net_Ethernet_28j60_UserTCP_socket+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_Net_Ethernet_28j60_UserTCP_socket+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       R0 
	MOVF        POSTINC0+0, 0 
	MOVWF       R1 
	MOVF        R0, 0 
	IORWF       R1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L_Net_Ethernet_28j60_UserTCP51
;tcp_tareas.c,59 :: 		return;
	GOTO        L_end_Net_Ethernet_28j60_UserTCP
L_Net_Ethernet_28j60_UserTCP51:
;tcp_tareas.c,61 :: 		if(socket->remotePort == portServer && socket->destPort == myPort){  //Modo servidor
	MOVLW       10
	ADDWF       FARG_Net_Ethernet_28j60_UserTCP_socket+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_Net_Ethernet_28j60_UserTCP_socket+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       R1 
	MOVF        POSTINC0+0, 0 
	MOVWF       R2 
	MOVF        R2, 0 
	XORWF       _portServer+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__Net_Ethernet_28j60_UserTCP105
	MOVF        _portServer+0, 0 
	XORWF       R1, 0 
L__Net_Ethernet_28j60_UserTCP105:
	BTFSS       STATUS+0, 2 
	GOTO        L_Net_Ethernet_28j60_UserTCP54
	MOVLW       12
	ADDWF       FARG_Net_Ethernet_28j60_UserTCP_socket+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_Net_Ethernet_28j60_UserTCP_socket+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       R1 
	MOVF        POSTINC0+0, 0 
	MOVWF       R2 
	MOVF        R2, 0 
	XORWF       _myPort+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__Net_Ethernet_28j60_UserTCP106
	MOVF        _myPort+0, 0 
	XORWF       R1, 0 
L__Net_Ethernet_28j60_UserTCP106:
	BTFSS       STATUS+0, 2 
	GOTO        L_Net_Ethernet_28j60_UserTCP54
L__Net_Ethernet_28j60_UserTCP69:
;tcp_tareas.c,63 :: 		for(cont = 0; cont < socket->dataLength && cont < sizeof(getRequest)-1; cont++)
	CLRF        Net_Ethernet_28j60_UserTCP_cont_L0+0 
	CLRF        Net_Ethernet_28j60_UserTCP_cont_L0+1 
L_Net_Ethernet_28j60_UserTCP55:
	MOVLW       14
	ADDWF       FARG_Net_Ethernet_28j60_UserTCP_socket+0, 0 
	MOVWF       FSR2 
	MOVLW       0
	ADDWFC      FARG_Net_Ethernet_28j60_UserTCP_socket+1, 0 
	MOVWF       FSR2H 
	MOVF        POSTINC2+0, 0 
	MOVWF       R1 
	MOVF        POSTINC2+0, 0 
	MOVWF       R2 
	MOVF        R2, 0 
	SUBWF       Net_Ethernet_28j60_UserTCP_cont_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__Net_Ethernet_28j60_UserTCP107
	MOVF        R1, 0 
	SUBWF       Net_Ethernet_28j60_UserTCP_cont_L0+0, 0 
L__Net_Ethernet_28j60_UserTCP107:
	BTFSC       STATUS+0, 0 
	GOTO        L_Net_Ethernet_28j60_UserTCP56
	MOVLW       0
	SUBWF       Net_Ethernet_28j60_UserTCP_cont_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__Net_Ethernet_28j60_UserTCP108
	MOVLW       63
	SUBWF       Net_Ethernet_28j60_UserTCP_cont_L0+0, 0 
L__Net_Ethernet_28j60_UserTCP108:
	BTFSC       STATUS+0, 0 
	GOTO        L_Net_Ethernet_28j60_UserTCP56
L__Net_Ethernet_28j60_UserTCP68:
;tcp_tareas.c,64 :: 		getRequest[cont] = Net_Ethernet_28j60_getByte();
	MOVLW       _getRequest+0
	ADDWF       Net_Ethernet_28j60_UserTCP_cont_L0+0, 0 
	MOVWF       FLOC__Net_Ethernet_28j60_UserTCP+0 
	MOVLW       hi_addr(_getRequest+0)
	ADDWFC      Net_Ethernet_28j60_UserTCP_cont_L0+1, 0 
	MOVWF       FLOC__Net_Ethernet_28j60_UserTCP+1 
	CALL        _Net_Ethernet_28j60_getByte+0, 0
	MOVFF       FLOC__Net_Ethernet_28j60_UserTCP+0, FSR1
	MOVFF       FLOC__Net_Ethernet_28j60_UserTCP+1, FSR1H
	MOVF        R0, 0 
	MOVWF       POSTINC1+0 
;tcp_tareas.c,63 :: 		for(cont = 0; cont < socket->dataLength && cont < sizeof(getRequest)-1; cont++)
	INFSNZ      Net_Ethernet_28j60_UserTCP_cont_L0+0, 1 
	INCF        Net_Ethernet_28j60_UserTCP_cont_L0+1, 1 
;tcp_tareas.c,64 :: 		getRequest[cont] = Net_Ethernet_28j60_getByte();
	GOTO        L_Net_Ethernet_28j60_UserTCP55
L_Net_Ethernet_28j60_UserTCP56:
;tcp_tareas.c,65 :: 		getRequest[cont] = 0;
	MOVLW       _getRequest+0
	ADDWF       Net_Ethernet_28j60_UserTCP_cont_L0+0, 0 
	MOVWF       FSR1 
	MOVLW       hi_addr(_getRequest+0)
	ADDWFC      Net_Ethernet_28j60_UserTCP_cont_L0+1, 0 
	MOVWF       FSR1H 
	CLRF        POSTINC1+0 
;tcp_tareas.c,68 :: 		inttostr(socket->dataLength,msjConst);
	MOVLW       14
	ADDWF       FARG_Net_Ethernet_28j60_UserTCP_socket+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_Net_Ethernet_28j60_UserTCP_socket+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       FARG_IntToStr_input+0 
	MOVF        POSTINC0+0, 0 
	MOVWF       FARG_IntToStr_input+1 
	MOVF        _msjConst+0, 0 
	MOVWF       FARG_IntToStr_output+0 
	MOVF        _msjConst+1, 0 
	MOVWF       FARG_IntToStr_output+1 
	CALL        _IntToStr+0, 0
;tcp_tareas.c,69 :: 		usart_write_text("Bytes: ");
	MOVLW       ?lstr1_tcp_tareas+0
	MOVWF       FARG_usart_write_text_texto+0 
	MOVLW       hi_addr(?lstr1_tcp_tareas+0)
	MOVWF       FARG_usart_write_text_texto+1 
	CALL        _usart_write_text+0, 0
;tcp_tareas.c,70 :: 		usart_write_text(msjConst);
	MOVF        _msjConst+0, 0 
	MOVWF       FARG_usart_write_text_texto+0 
	MOVF        _msjConst+1, 0 
	MOVWF       FARG_usart_write_text_texto+1 
	CALL        _usart_write_text+0, 0
;tcp_tareas.c,71 :: 		usart_write_text(" ,");
	MOVLW       ?lstr2_tcp_tareas+0
	MOVWF       FARG_usart_write_text_texto+0 
	MOVLW       hi_addr(?lstr2_tcp_tareas+0)
	MOVWF       FARG_usart_write_text_texto+1 
	CALL        _usart_write_text+0, 0
;tcp_tareas.c,73 :: 		usart_write_text("Mensaje: ");
	MOVLW       ?lstr3_tcp_tareas+0
	MOVWF       FARG_usart_write_text_texto+0 
	MOVLW       hi_addr(?lstr3_tcp_tareas+0)
	MOVWF       FARG_usart_write_text_texto+1 
	CALL        _usart_write_text+0, 0
;tcp_tareas.c,74 :: 		usart_write_text(getRequest);
	MOVLW       _getRequest+0
	MOVWF       FARG_usart_write_text_texto+0 
	MOVLW       hi_addr(_getRequest+0)
	MOVWF       FARG_usart_write_text_texto+1 
	CALL        _usart_write_text+0, 0
;tcp_tareas.c,75 :: 		usart_write_text("\r\n");
	MOVLW       ?lstr4_tcp_tareas+0
	MOVWF       FARG_usart_write_text_texto+0 
	MOVLW       hi_addr(?lstr4_tcp_tareas+0)
	MOVWF       FARG_usart_write_text_texto+1 
	CALL        _usart_write_text+0, 0
;tcp_tareas.c,78 :: 		if(strncmp(getrequest, RomToRam(peticionGET, msjConst), 5))
	MOVLW       _peticionGET+0
	MOVWF       FARG_RomToRam_origen+0 
	MOVLW       hi_addr(_peticionGET+0)
	MOVWF       FARG_RomToRam_origen+1 
	MOVLW       higher_addr(_peticionGET+0)
	MOVWF       FARG_RomToRam_origen+2 
	MOVF        _msjConst+0, 0 
	MOVWF       FARG_RomToRam_destino+0 
	MOVF        _msjConst+1, 0 
	MOVWF       FARG_RomToRam_destino+1 
	CALL        _RomToRam+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_strncmp_s2+0 
	MOVF        R1, 0 
	MOVWF       FARG_strncmp_s2+1 
	MOVLW       _getRequest+0
	MOVWF       FARG_strncmp_s1+0 
	MOVLW       hi_addr(_getRequest+0)
	MOVWF       FARG_strncmp_s1+1 
	MOVLW       5
	MOVWF       FARG_strncmp_len+0 
	CALL        _strncmp+0, 0
	MOVF        R0, 0 
	IORWF       R1, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L_Net_Ethernet_28j60_UserTCP60
;tcp_tareas.c,79 :: 		return;
	GOTO        L_end_Net_Ethernet_28j60_UserTCP
L_Net_Ethernet_28j60_UserTCP60:
;tcp_tareas.c,85 :: 		}
L_Net_Ethernet_28j60_UserTCP54:
;tcp_tareas.c,163 :: 		}else{ //Se transmite datos hacia la app
	GOTO        L_Net_Ethernet_28j60_UserTCP61
L_Net_Ethernet_28j60_UserTCP50:
;tcp_tareas.c,164 :: 		cont = 0;
	CLRF        Net_Ethernet_28j60_UserTCP_cont_L0+0 
	CLRF        Net_Ethernet_28j60_UserTCP_cont_L0+1 
;tcp_tareas.c,165 :: 		while(punteroTCP[cont])
L_Net_Ethernet_28j60_UserTCP62:
	MOVF        Net_Ethernet_28j60_UserTCP_cont_L0+0, 0 
	ADDWF       _punteroTCP+0, 0 
	MOVWF       FSR0 
	MOVF        Net_Ethernet_28j60_UserTCP_cont_L0+1, 0 
	ADDWFC      _punteroTCP+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_Net_Ethernet_28j60_UserTCP63
;tcp_tareas.c,166 :: 		Net_Ethernet_28j60_putByteTCP(punteroTCP[cont++],socket_28j60);
	MOVF        Net_Ethernet_28j60_UserTCP_cont_L0+0, 0 
	ADDWF       _punteroTCP+0, 0 
	MOVWF       FSR0 
	MOVF        Net_Ethernet_28j60_UserTCP_cont_L0+1, 0 
	ADDWFC      _punteroTCP+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       FARG_Net_Ethernet_28j60_putByteTCP_ch+0 
	MOVLW       _socket_28j60+0
	MOVWF       FARG_Net_Ethernet_28j60_putByteTCP_socket_28j60+0 
	MOVLW       hi_addr(_socket_28j60+0)
	MOVWF       FARG_Net_Ethernet_28j60_putByteTCP_socket_28j60+1 
	CALL        _Net_Ethernet_28j60_putByteTCP+0, 0
	INFSNZ      Net_Ethernet_28j60_UserTCP_cont_L0+0, 1 
	INCF        Net_Ethernet_28j60_UserTCP_cont_L0+1, 1 
	GOTO        L_Net_Ethernet_28j60_UserTCP62
L_Net_Ethernet_28j60_UserTCP63:
;tcp_tareas.c,168 :: 		Net_Ethernet_28j60_putByteTCP('\r',socket_28j60);
	MOVLW       13
	MOVWF       FARG_Net_Ethernet_28j60_putByteTCP_ch+0 
	MOVLW       _socket_28j60+0
	MOVWF       FARG_Net_Ethernet_28j60_putByteTCP_socket_28j60+0 
	MOVLW       hi_addr(_socket_28j60+0)
	MOVWF       FARG_Net_Ethernet_28j60_putByteTCP_socket_28j60+1 
	CALL        _Net_Ethernet_28j60_putByteTCP+0, 0
;tcp_tareas.c,169 :: 		Net_Ethernet_28j60_putByteTCP('\n',socket_28j60);
	MOVLW       10
	MOVWF       FARG_Net_Ethernet_28j60_putByteTCP_ch+0 
	MOVLW       _socket_28j60+0
	MOVWF       FARG_Net_Ethernet_28j60_putByteTCP_socket_28j60+0 
	MOVLW       hi_addr(_socket_28j60+0)
	MOVWF       FARG_Net_Ethernet_28j60_putByteTCP_socket_28j60+1 
	CALL        _Net_Ethernet_28j60_putByteTCP+0, 0
;tcp_tareas.c,170 :: 		sendDataTCP.B0 = false;  //Resetear bandera
	BCF         _sendDataTCP+0, 0 
;tcp_tareas.c,171 :: 		}
L_Net_Ethernet_28j60_UserTCP61:
;tcp_tareas.c,173 :: 		}
L_end_Net_Ethernet_28j60_UserTCP:
	RETURN      0
; end of _Net_Ethernet_28j60_UserTCP

_Net_Ethernet_28j60_UserUDP:

;tcp_tareas.c,175 :: 		unsigned int Net_Ethernet_28j60_UserUDP(SOCKET_28j60_Dsc *socket){
;tcp_tareas.c,176 :: 		return 0;
	CLRF        R0 
	CLRF        R1 
;tcp_tareas.c,177 :: 		}
L_end_Net_Ethernet_28j60_UserUDP:
	RETURN      0
; end of _Net_Ethernet_28j60_UserUDP

_net_ethernet_open:

;tcp_tareas.c,179 :: 		void net_ethernet_open(){
;tcp_tareas.c,180 :: 		SPI1_Init();                                         //Initialize SPI modulo
	CALL        _SPI1_Init+0, 0
;tcp_tareas.c,181 :: 		Net_Ethernet_28j60_Init(myMacAddr, myIpAddr, 0x01);  //Full duplex
	MOVLW       _myMacAddr+0
	MOVWF       FARG_Net_Ethernet_28j60_Init_mac+0 
	MOVLW       hi_addr(_myMacAddr+0)
	MOVWF       FARG_Net_Ethernet_28j60_Init_mac+1 
	MOVLW       _myIpAddr+0
	MOVWF       FARG_Net_Ethernet_28j60_Init_ip+0 
	MOVLW       hi_addr(_myIpAddr+0)
	MOVWF       FARG_Net_Ethernet_28j60_Init_ip+1 
	MOVLW       1
	MOVWF       FARG_Net_Ethernet_28j60_Init_fullDuplex+0 
	CALL        _Net_Ethernet_28j60_Init+0, 0
;tcp_tareas.c,182 :: 		Net_Ethernet_28j60_confNetwork(ipMask, gwIpAddr, dnsIpAddr);
	MOVLW       _ipMask+0
	MOVWF       FARG_Net_Ethernet_28j60_confNetwork_ipMask+0 
	MOVLW       hi_addr(_ipMask+0)
	MOVWF       FARG_Net_Ethernet_28j60_confNetwork_ipMask+1 
	MOVLW       _gwIpAddr+0
	MOVWF       FARG_Net_Ethernet_28j60_confNetwork_gwIpAddr+0 
	MOVLW       hi_addr(_gwIpAddr+0)
	MOVWF       FARG_Net_Ethernet_28j60_confNetwork_gwIpAddr+1 
	MOVLW       _dnsIpAddr+0
	MOVWF       FARG_Net_Ethernet_28j60_confNetwork_dnsIpAddr+0 
	MOVLW       hi_addr(_dnsIpAddr+0)
	MOVWF       FARG_Net_Ethernet_28j60_confNetwork_dnsIpAddr+1 
	CALL        _Net_Ethernet_28j60_confNetwork+0, 0
;tcp_tareas.c,183 :: 		Net_Ethernet_28j60_stackInitTCP();
	CALL        _Net_Ethernet_28j60_stackInitTCP+0, 0
;tcp_tareas.c,184 :: 		}
L_end_net_ethernet_open:
	RETURN      0
; end of _net_ethernet_open
