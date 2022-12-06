
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
	CALL        _Div_8X8_U+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_Swap_input+0 
	CALL        _Swap+0, 0
	MOVF        R0, 0 
	MOVWF       FLOC__decToBcd+0 
	MOVLW       10
	MOVWF       R4 
	MOVF        FARG_decToBcd_dato+0, 0 
	MOVWF       R0 
	CALL        _Div_8X8_U+0, 0
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
	GOTO        L__clamp1028
	MOVF        FARG_clamp_valor+2, 0 
	SUBWF       FARG_clamp_max+2, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__clamp1028
	MOVF        FARG_clamp_valor+1, 0 
	SUBWF       FARG_clamp_max+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__clamp1028
	MOVF        FARG_clamp_valor+0, 0 
	SUBWF       FARG_clamp_max+0, 0 
L__clamp1028:
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
	GOTO        L__clamp1029
	MOVF        FARG_clamp_min+2, 0 
	SUBWF       FARG_clamp_valor+2, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__clamp1029
	MOVF        FARG_clamp_min+1, 0 
	SUBWF       FARG_clamp_valor+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__clamp1029
	MOVF        FARG_clamp_min+0, 0 
	SUBWF       FARG_clamp_valor+0, 0 
L__clamp1029:
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
	GOTO        L__clamp_shift1031
	MOVF        FARG_clamp_shift_valor+2, 0 
	SUBWF       FARG_clamp_shift_max+2, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__clamp_shift1031
	MOVF        FARG_clamp_shift_valor+1, 0 
	SUBWF       FARG_clamp_shift_max+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__clamp_shift1031
	MOVF        FARG_clamp_shift_valor+0, 0 
	SUBWF       FARG_clamp_shift_max+0, 0 
L__clamp_shift1031:
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
	GOTO        L__clamp_shift1032
	MOVF        FARG_clamp_shift_min+2, 0 
	SUBWF       FARG_clamp_shift_valor+2, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__clamp_shift1032
	MOVF        FARG_clamp_shift_min+1, 0 
	SUBWF       FARG_clamp_shift_valor+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__clamp_shift1032
	MOVF        FARG_clamp_shift_min+0, 0 
	SUBWF       FARG_clamp_shift_valor+0, 0 
L__clamp_shift1032:
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

_map:

;miscelaneos.h,48 :: 		long map(long valor, long in_min, long in_max, long out_min, long out_max){
;miscelaneos.h,50 :: 		valor -= in_min;
	MOVF        FARG_map_valor+0, 0 
	MOVWF       R4 
	MOVF        FARG_map_valor+1, 0 
	MOVWF       R5 
	MOVF        FARG_map_valor+2, 0 
	MOVWF       R6 
	MOVF        FARG_map_valor+3, 0 
	MOVWF       R7 
	MOVF        FARG_map_in_min+0, 0 
	SUBWF       R4, 1 
	MOVF        FARG_map_in_min+1, 0 
	SUBWFB      R5, 1 
	MOVF        FARG_map_in_min+2, 0 
	SUBWFB      R6, 1 
	MOVF        FARG_map_in_min+3, 0 
	SUBWFB      R7, 1 
	MOVF        R4, 0 
	MOVWF       FARG_map_valor+0 
	MOVF        R5, 0 
	MOVWF       FARG_map_valor+1 
	MOVF        R6, 0 
	MOVWF       FARG_map_valor+2 
	MOVF        R7, 0 
	MOVWF       FARG_map_valor+3 
;miscelaneos.h,51 :: 		valor *= (out_max - out_min);
	MOVF        FARG_map_out_max+0, 0 
	MOVWF       R0 
	MOVF        FARG_map_out_max+1, 0 
	MOVWF       R1 
	MOVF        FARG_map_out_max+2, 0 
	MOVWF       R2 
	MOVF        FARG_map_out_max+3, 0 
	MOVWF       R3 
	MOVF        FARG_map_out_min+0, 0 
	SUBWF       R0, 1 
	MOVF        FARG_map_out_min+1, 0 
	SUBWFB      R1, 1 
	MOVF        FARG_map_out_min+2, 0 
	SUBWFB      R2, 1 
	MOVF        FARG_map_out_min+3, 0 
	SUBWFB      R3, 1 
	CALL        _Mul_32x32_U+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_map_valor+0 
	MOVF        R1, 0 
	MOVWF       FARG_map_valor+1 
	MOVF        R2, 0 
	MOVWF       FARG_map_valor+2 
	MOVF        R3, 0 
	MOVWF       FARG_map_valor+3 
;miscelaneos.h,52 :: 		valor /= (in_max - in_min);
	MOVF        FARG_map_in_max+0, 0 
	MOVWF       R4 
	MOVF        FARG_map_in_max+1, 0 
	MOVWF       R5 
	MOVF        FARG_map_in_max+2, 0 
	MOVWF       R6 
	MOVF        FARG_map_in_max+3, 0 
	MOVWF       R7 
	MOVF        FARG_map_in_min+0, 0 
	SUBWF       R4, 1 
	MOVF        FARG_map_in_min+1, 0 
	SUBWFB      R5, 1 
	MOVF        FARG_map_in_min+2, 0 
	SUBWFB      R6, 1 
	MOVF        FARG_map_in_min+3, 0 
	SUBWFB      R7, 1 
	CALL        _Div_32x32_S+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_map_valor+0 
	MOVF        R1, 0 
	MOVWF       FARG_map_valor+1 
	MOVF        R2, 0 
	MOVWF       FARG_map_valor+2 
	MOVF        R3, 0 
	MOVWF       FARG_map_valor+3 
;miscelaneos.h,53 :: 		valor += out_min;
	MOVF        FARG_map_out_min+0, 0 
	ADDWF       R0, 1 
	MOVF        FARG_map_out_min+1, 0 
	ADDWFC      R1, 1 
	MOVF        FARG_map_out_min+2, 0 
	ADDWFC      R2, 1 
	MOVF        FARG_map_out_min+3, 0 
	ADDWFC      R3, 1 
	MOVF        R0, 0 
	MOVWF       FARG_map_valor+0 
	MOVF        R1, 0 
	MOVWF       FARG_map_valor+1 
	MOVF        R2, 0 
	MOVWF       FARG_map_valor+2 
	MOVF        R3, 0 
	MOVWF       FARG_map_valor+3 
;miscelaneos.h,54 :: 		return valor;
;miscelaneos.h,55 :: 		}
L_end_map:
	RETURN      0
; end of _map

_string_push:

;string.h,6 :: 		char string_push(char *texto, char caracter){
;string.h,7 :: 		char cont = 0;
	CLRF        string_push_cont_L0+0 
;string.h,9 :: 		while(texto[cont])
L_string_push8:
	MOVF        string_push_cont_L0+0, 0 
	ADDWF       FARG_string_push_texto+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_string_push_texto+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_string_push9
;string.h,10 :: 		cont++;
	INCF        string_push_cont_L0+0, 1 
	GOTO        L_string_push8
L_string_push9:
;string.h,12 :: 		texto[cont++] = caracter;
	MOVF        string_push_cont_L0+0, 0 
	ADDWF       FARG_string_push_texto+0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      FARG_string_push_texto+1, 0 
	MOVWF       FSR1H 
	MOVF        FARG_string_push_caracter+0, 0 
	MOVWF       POSTINC1+0 
	INCF        string_push_cont_L0+0, 1 
;string.h,13 :: 		texto[cont] = 0;  //Agregar final de cadena
	MOVF        string_push_cont_L0+0, 0 
	ADDWF       FARG_string_push_texto+0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      FARG_string_push_texto+1, 0 
	MOVWF       FSR1H 
	CLRF        POSTINC1+0 
;string.h,15 :: 		return cont;
	MOVF        string_push_cont_L0+0, 0 
	MOVWF       R0 
;string.h,16 :: 		}
L_end_string_push:
	RETURN      0
; end of _string_push

_string_pop:

;string.h,18 :: 		char string_pop(char *texto){
;string.h,19 :: 		char cont = 0, result;
	CLRF        string_pop_cont_L0+0 
;string.h,22 :: 		while(texto[cont])
L_string_pop10:
	MOVF        string_pop_cont_L0+0, 0 
	ADDWF       FARG_string_pop_texto+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_string_pop_texto+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_string_pop11
;string.h,23 :: 		cont++;
	INCF        string_pop_cont_L0+0, 1 
	GOTO        L_string_pop10
L_string_pop11:
;string.h,25 :: 		if(cont == 0)
	MOVF        string_pop_cont_L0+0, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_string_pop12
;string.h,26 :: 		return cont;
	MOVF        string_pop_cont_L0+0, 0 
	MOVWF       R0 
	GOTO        L_end_string_pop
L_string_pop12:
;string.h,28 :: 		result = texto[--cont];
	DECF        string_pop_cont_L0+0, 1 
	MOVF        string_pop_cont_L0+0, 0 
	ADDWF       FARG_string_pop_texto+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      FARG_string_pop_texto+1, 0 
	MOVWF       R1 
	MOVFF       R0, FSR0
	MOVFF       R1, FSR0H
	MOVF        POSTINC0+0, 0 
	MOVWF       R2 
;string.h,29 :: 		texto[cont] = 0;  //Agregar final de cadena
	MOVFF       R0, FSR1
	MOVFF       R1, FSR1H
	CLRF        POSTINC1+0 
;string.h,32 :: 		return result;
	MOVF        R2, 0 
	MOVWF       R0 
;string.h,33 :: 		}
L_end_string_pop:
	RETURN      0
; end of _string_pop

_string_add:

;string.h,35 :: 		char string_add(char *destino, char *addEnd){
;string.h,36 :: 		char total = 0, cont = 0;
	CLRF        string_add_total_L0+0 
	CLRF        string_add_cont_L0+0 
;string.h,39 :: 		while(destino[total])
L_string_add13:
	MOVF        string_add_total_L0+0, 0 
	ADDWF       FARG_string_add_destino+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_string_add_destino+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_string_add14
;string.h,40 :: 		total++;
	INCF        string_add_total_L0+0, 1 
	GOTO        L_string_add13
L_string_add14:
;string.h,42 :: 		while(addEnd[cont])
L_string_add15:
	MOVF        string_add_cont_L0+0, 0 
	ADDWF       FARG_string_add_addEnd+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_string_add_addEnd+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_string_add16
;string.h,43 :: 		destino[total++] = addEnd[cont++];
	MOVF        string_add_total_L0+0, 0 
	ADDWF       FARG_string_add_destino+0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      FARG_string_add_destino+1, 0 
	MOVWF       FSR1H 
	MOVF        string_add_cont_L0+0, 0 
	ADDWF       FARG_string_add_addEnd+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_string_add_addEnd+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       POSTINC1+0 
	INCF        string_add_total_L0+0, 1 
	INCF        string_add_cont_L0+0, 1 
	GOTO        L_string_add15
L_string_add16:
;string.h,44 :: 		destino[total] = 0;
	MOVF        string_add_total_L0+0, 0 
	ADDWF       FARG_string_add_destino+0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      FARG_string_add_destino+1, 0 
	MOVWF       FSR1H 
	CLRF        POSTINC1+0 
;string.h,47 :: 		return total;
	MOVF        string_add_total_L0+0, 0 
	MOVWF       R0 
;string.h,48 :: 		}
L_end_string_add:
	RETURN      0
; end of _string_add

_string_addc:

;string.h,50 :: 		char string_addc(char *destino, const char *addEnd){
;string.h,51 :: 		char total = 0, cont = 0;
	CLRF        string_addc_total_L0+0 
	CLRF        string_addc_cont_L0+0 
;string.h,54 :: 		while(destino[total])
L_string_addc17:
	MOVF        string_addc_total_L0+0, 0 
	ADDWF       FARG_string_addc_destino+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_string_addc_destino+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_string_addc18
;string.h,55 :: 		total++;
	INCF        string_addc_total_L0+0, 1 
	GOTO        L_string_addc17
L_string_addc18:
;string.h,57 :: 		while(addEnd[cont])
L_string_addc19:
	MOVF        string_addc_cont_L0+0, 0 
	ADDWF       FARG_string_addc_addEnd+0, 0 
	MOVWF       TBLPTRL 
	MOVLW       0
	ADDWFC      FARG_string_addc_addEnd+1, 0 
	MOVWF       TBLPTRH 
	MOVLW       0
	ADDWFC      FARG_string_addc_addEnd+2, 0 
	MOVWF       TBLPTRU 
	TBLRD*+
	MOVFF       TABLAT+0, R0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_string_addc20
;string.h,58 :: 		destino[total++] = addEnd[cont++];
	MOVF        string_addc_total_L0+0, 0 
	ADDWF       FARG_string_addc_destino+0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      FARG_string_addc_destino+1, 0 
	MOVWF       FSR1H 
	MOVF        string_addc_cont_L0+0, 0 
	ADDWF       FARG_string_addc_addEnd+0, 0 
	MOVWF       TBLPTRL 
	MOVLW       0
	ADDWFC      FARG_string_addc_addEnd+1, 0 
	MOVWF       TBLPTRH 
	MOVLW       0
	ADDWFC      FARG_string_addc_addEnd+2, 0 
	MOVWF       TBLPTRU 
	TBLRD*+
	MOVFF       TABLAT+0, R0
	MOVF        R0, 0 
	MOVWF       POSTINC1+0 
	INCF        string_addc_total_L0+0, 1 
	INCF        string_addc_cont_L0+0, 1 
	GOTO        L_string_addc19
L_string_addc20:
;string.h,59 :: 		destino[total] = 0;
	MOVF        string_addc_total_L0+0, 0 
	ADDWF       FARG_string_addc_destino+0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      FARG_string_addc_destino+1, 0 
	MOVWF       FSR1H 
	CLRF        POSTINC1+0 
;string.h,62 :: 		return total;
	MOVF        string_addc_total_L0+0, 0 
	MOVWF       R0 
;string.h,63 :: 		}
L_end_string_addc:
	RETURN      0
; end of _string_addc

_string_cpy:

;string.h,65 :: 		char string_cpy(char *destino, char *origen){
;string.h,66 :: 		char cont = 0;
	CLRF        string_cpy_cont_L0+0 
;string.h,68 :: 		while(origen[cont])
L_string_cpy21:
	MOVF        string_cpy_cont_L0+0, 0 
	ADDWF       FARG_string_cpy_origen+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_string_cpy_origen+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_string_cpy22
;string.h,69 :: 		destino[cont] = origen[cont++];
	MOVF        string_cpy_cont_L0+0, 0 
	ADDWF       FARG_string_cpy_destino+0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      FARG_string_cpy_destino+1, 0 
	MOVWF       FSR1H 
	MOVF        string_cpy_cont_L0+0, 0 
	ADDWF       FARG_string_cpy_origen+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_string_cpy_origen+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       POSTINC1+0 
	INCF        string_cpy_cont_L0+0, 1 
	GOTO        L_string_cpy21
L_string_cpy22:
;string.h,70 :: 		destino[cont] = 0;              //Final de cadena
	MOVF        string_cpy_cont_L0+0, 0 
	ADDWF       FARG_string_cpy_destino+0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      FARG_string_cpy_destino+1, 0 
	MOVWF       FSR1H 
	CLRF        POSTINC1+0 
;string.h,73 :: 		return cont;
	MOVF        string_cpy_cont_L0+0, 0 
	MOVWF       R0 
;string.h,74 :: 		}
L_end_string_cpy:
	RETURN      0
; end of _string_cpy

_string_cpyn:

;string.h,76 :: 		char string_cpyn(char *destino, char *origen, char size){
;string.h,79 :: 		for(cont = 0; cont < size && origen[cont]; cont++)
	CLRF        R1 
L_string_cpyn23:
	MOVF        FARG_string_cpyn_size+0, 0 
	SUBWF       R1, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_string_cpyn24
	MOVF        R1, 0 
	ADDWF       FARG_string_cpyn_origen+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_string_cpyn_origen+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_string_cpyn24
L__string_cpyn953:
;string.h,80 :: 		destino[cont] = origen[cont];
	MOVF        R1, 0 
	ADDWF       FARG_string_cpyn_destino+0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      FARG_string_cpyn_destino+1, 0 
	MOVWF       FSR1H 
	MOVF        R1, 0 
	ADDWF       FARG_string_cpyn_origen+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_string_cpyn_origen+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       POSTINC1+0 
;string.h,79 :: 		for(cont = 0; cont < size && origen[cont]; cont++)
	INCF        R1, 1 
;string.h,80 :: 		destino[cont] = origen[cont];
	GOTO        L_string_cpyn23
L_string_cpyn24:
;string.h,81 :: 		destino[cont] = 0;              //Final de cadena
	MOVF        R1, 0 
	ADDWF       FARG_string_cpyn_destino+0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      FARG_string_cpyn_destino+1, 0 
	MOVWF       FSR1H 
	CLRF        POSTINC1+0 
;string.h,83 :: 		return cont;
	MOVF        R1, 0 
	MOVWF       R0 
;string.h,84 :: 		}
L_end_string_cpyn:
	RETURN      0
; end of _string_cpyn

_string_cpyc:

;string.h,86 :: 		char string_cpyc(char *destino, const char *origen){
;string.h,87 :: 		char cont = 0;
	CLRF        string_cpyc_cont_L0+0 
;string.h,89 :: 		while(origen[cont])
L_string_cpyc28:
	MOVF        string_cpyc_cont_L0+0, 0 
	ADDWF       FARG_string_cpyc_origen+0, 0 
	MOVWF       TBLPTRL 
	MOVLW       0
	ADDWFC      FARG_string_cpyc_origen+1, 0 
	MOVWF       TBLPTRH 
	MOVLW       0
	ADDWFC      FARG_string_cpyc_origen+2, 0 
	MOVWF       TBLPTRU 
	TBLRD*+
	MOVFF       TABLAT+0, R0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_string_cpyc29
;string.h,90 :: 		destino[cont] = origen[cont++];
	MOVF        string_cpyc_cont_L0+0, 0 
	ADDWF       FARG_string_cpyc_destino+0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      FARG_string_cpyc_destino+1, 0 
	MOVWF       FSR1H 
	MOVF        string_cpyc_cont_L0+0, 0 
	ADDWF       FARG_string_cpyc_origen+0, 0 
	MOVWF       TBLPTRL 
	MOVLW       0
	ADDWFC      FARG_string_cpyc_origen+1, 0 
	MOVWF       TBLPTRH 
	MOVLW       0
	ADDWFC      FARG_string_cpyc_origen+2, 0 
	MOVWF       TBLPTRU 
	TBLRD*+
	MOVFF       TABLAT+0, R0
	MOVF        R0, 0 
	MOVWF       POSTINC1+0 
	INCF        string_cpyc_cont_L0+0, 1 
	GOTO        L_string_cpyc28
L_string_cpyc29:
;string.h,91 :: 		destino[cont] = 0;              //Final de cadena
	MOVF        string_cpyc_cont_L0+0, 0 
	ADDWF       FARG_string_cpyc_destino+0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      FARG_string_cpyc_destino+1, 0 
	MOVWF       FSR1H 
	CLRF        POSTINC1+0 
;string.h,93 :: 		return cont;
	MOVF        string_cpyc_cont_L0+0, 0 
	MOVWF       R0 
;string.h,94 :: 		}
L_end_string_cpyc:
	RETURN      0
; end of _string_cpyc

_string_len:

;string.h,96 :: 		char string_len(char *texto){
;string.h,97 :: 		char cont = 0;
	CLRF        string_len_cont_L0+0 
;string.h,98 :: 		while(texto[cont])
L_string_len30:
	MOVF        string_len_cont_L0+0, 0 
	ADDWF       FARG_string_len_texto+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_string_len_texto+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_string_len31
;string.h,99 :: 		cont++;
	INCF        string_len_cont_L0+0, 1 
	GOTO        L_string_len30
L_string_len31:
;string.h,101 :: 		return cont;
	MOVF        string_len_cont_L0+0, 0 
	MOVWF       R0 
;string.h,102 :: 		}
L_end_string_len:
	RETURN      0
; end of _string_len

_string_cmp:

;string.h,104 :: 		bool string_cmp(char *text1, char *text2){
;string.h,105 :: 		char cont = 0;
	CLRF        string_cmp_cont_L0+0 
;string.h,107 :: 		while(true){
L_string_cmp32:
;string.h,108 :: 		if(text1[cont] != text2[cont])
	MOVF        string_cmp_cont_L0+0, 0 
	ADDWF       FARG_string_cmp_text1+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_string_cmp_text1+1, 0 
	MOVWF       FSR0H 
	MOVF        string_cmp_cont_L0+0, 0 
	ADDWF       FARG_string_cmp_text2+0, 0 
	MOVWF       FSR2 
	MOVLW       0
	ADDWFC      FARG_string_cmp_text2+1, 0 
	MOVWF       FSR2H 
	MOVF        POSTINC0+0, 0 
	XORWF       POSTINC2+0, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L_string_cmp34
;string.h,109 :: 		return false;
	CLRF        R0 
	GOTO        L_end_string_cmp
L_string_cmp34:
;string.h,110 :: 		else if(text1[cont] == 0 || text2[cont] == 0)
	MOVF        string_cmp_cont_L0+0, 0 
	ADDWF       FARG_string_cmp_text1+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_string_cmp_text1+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	XORLW       0
	BTFSC       STATUS+0, 2 
	GOTO        L__string_cmp954
	MOVF        string_cmp_cont_L0+0, 0 
	ADDWF       FARG_string_cmp_text2+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_string_cmp_text2+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	XORLW       0
	BTFSC       STATUS+0, 2 
	GOTO        L__string_cmp954
	GOTO        L_string_cmp38
L__string_cmp954:
;string.h,111 :: 		break;
	GOTO        L_string_cmp33
L_string_cmp38:
;string.h,113 :: 		cont++;
	INCF        string_cmp_cont_L0+0, 1 
;string.h,114 :: 		}
	GOTO        L_string_cmp32
L_string_cmp33:
;string.h,116 :: 		return true;
	MOVLW       1
	MOVWF       R0 
;string.h,117 :: 		}
L_end_string_cmp:
	RETURN      0
; end of _string_cmp

_string_cmpc:

;string.h,119 :: 		bool string_cmpc(const char *text1, char *text2){
;string.h,120 :: 		char cont = 0;
	CLRF        string_cmpc_cont_L0+0 
;string.h,122 :: 		while(true){
L_string_cmpc40:
;string.h,123 :: 		if(text1[cont] != text2[cont])
	MOVF        string_cmpc_cont_L0+0, 0 
	ADDWF       FARG_string_cmpc_text1+0, 0 
	MOVWF       TBLPTRL 
	MOVLW       0
	ADDWFC      FARG_string_cmpc_text1+1, 0 
	MOVWF       TBLPTRH 
	MOVLW       0
	ADDWFC      FARG_string_cmpc_text1+2, 0 
	MOVWF       TBLPTRU 
	TBLRD*+
	MOVFF       TABLAT+0, R1
	MOVF        string_cmpc_cont_L0+0, 0 
	ADDWF       FARG_string_cmpc_text2+0, 0 
	MOVWF       FSR2 
	MOVLW       0
	ADDWFC      FARG_string_cmpc_text2+1, 0 
	MOVWF       FSR2H 
	MOVF        R1, 0 
	XORWF       POSTINC2+0, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L_string_cmpc42
;string.h,124 :: 		return false;
	CLRF        R0 
	GOTO        L_end_string_cmpc
L_string_cmpc42:
;string.h,125 :: 		else if(text1[cont] == 0 || text2[cont] == 0)
	MOVF        string_cmpc_cont_L0+0, 0 
	ADDWF       FARG_string_cmpc_text1+0, 0 
	MOVWF       TBLPTRL 
	MOVLW       0
	ADDWFC      FARG_string_cmpc_text1+1, 0 
	MOVWF       TBLPTRH 
	MOVLW       0
	ADDWFC      FARG_string_cmpc_text1+2, 0 
	MOVWF       TBLPTRU 
	TBLRD*+
	MOVFF       TABLAT+0, R1
	MOVF        R1, 0 
	XORLW       0
	BTFSC       STATUS+0, 2 
	GOTO        L__string_cmpc955
	MOVF        string_cmpc_cont_L0+0, 0 
	ADDWF       FARG_string_cmpc_text2+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_string_cmpc_text2+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	XORLW       0
	BTFSC       STATUS+0, 2 
	GOTO        L__string_cmpc955
	GOTO        L_string_cmpc46
L__string_cmpc955:
;string.h,126 :: 		break;
	GOTO        L_string_cmpc41
L_string_cmpc46:
;string.h,128 :: 		cont++;
	INCF        string_cmpc_cont_L0+0, 1 
;string.h,129 :: 		}
	GOTO        L_string_cmpc40
L_string_cmpc41:
;string.h,131 :: 		return true;
	MOVLW       1
	MOVWF       R0 
;string.h,132 :: 		}
L_end_string_cmpc:
	RETURN      0
; end of _string_cmpc

_string_cmpn:

;string.h,134 :: 		bool string_cmpn(char *text1, char *text2, char bytes){
;string.h,137 :: 		for(cont = 0; cont < bytes; cont++){
	CLRF        R1 
L_string_cmpn48:
	MOVF        FARG_string_cmpn_bytes+0, 0 
	SUBWF       R1, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_string_cmpn49
;string.h,138 :: 		if(text1[cont] != text2[cont])
	MOVF        R1, 0 
	ADDWF       FARG_string_cmpn_text1+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_string_cmpn_text1+1, 0 
	MOVWF       FSR0H 
	MOVF        R1, 0 
	ADDWF       FARG_string_cmpn_text2+0, 0 
	MOVWF       FSR2 
	MOVLW       0
	ADDWFC      FARG_string_cmpn_text2+1, 0 
	MOVWF       FSR2H 
	MOVF        POSTINC0+0, 0 
	XORWF       POSTINC2+0, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L_string_cmpn51
;string.h,139 :: 		return false;
	CLRF        R0 
	GOTO        L_end_string_cmpn
L_string_cmpn51:
;string.h,137 :: 		for(cont = 0; cont < bytes; cont++){
	INCF        R1, 1 
;string.h,140 :: 		}
	GOTO        L_string_cmpn48
L_string_cmpn49:
;string.h,142 :: 		return true;
	MOVLW       1
	MOVWF       R0 
;string.h,143 :: 		}
L_end_string_cmpn:
	RETURN      0
; end of _string_cmpn

_string_cmpnc:

;string.h,145 :: 		bool string_cmpnc(const char *text1, char *text2, char bytes){
;string.h,148 :: 		for(cont = 0; cont < bytes; cont++){
	CLRF        R2 
L_string_cmpnc52:
	MOVF        FARG_string_cmpnc_bytes+0, 0 
	SUBWF       R2, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_string_cmpnc53
;string.h,149 :: 		if(text1[cont] != text2[cont])
	MOVF        R2, 0 
	ADDWF       FARG_string_cmpnc_text1+0, 0 
	MOVWF       TBLPTRL 
	MOVLW       0
	ADDWFC      FARG_string_cmpnc_text1+1, 0 
	MOVWF       TBLPTRH 
	MOVLW       0
	ADDWFC      FARG_string_cmpnc_text1+2, 0 
	MOVWF       TBLPTRU 
	TBLRD*+
	MOVFF       TABLAT+0, R1
	MOVF        R2, 0 
	ADDWF       FARG_string_cmpnc_text2+0, 0 
	MOVWF       FSR2 
	MOVLW       0
	ADDWFC      FARG_string_cmpnc_text2+1, 0 
	MOVWF       FSR2H 
	MOVF        R1, 0 
	XORWF       POSTINC2+0, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L_string_cmpnc55
;string.h,150 :: 		return false;
	CLRF        R0 
	GOTO        L_end_string_cmpnc
L_string_cmpnc55:
;string.h,148 :: 		for(cont = 0; cont < bytes; cont++){
	INCF        R2, 1 
;string.h,151 :: 		}
	GOTO        L_string_cmpnc52
L_string_cmpnc53:
;string.h,153 :: 		return true;
	MOVLW       1
	MOVWF       R0 
;string.h,154 :: 		}
L_end_string_cmpnc:
	RETURN      0
; end of _string_cmpnc

_string_isNumeric:

;string.h,156 :: 		bool string_isNumeric(char *cadena){
;string.h,157 :: 		char cont = 0;
	CLRF        string_isNumeric_cont_L0+0 
;string.h,159 :: 		while(cadena[cont] != 0){
L_string_isNumeric56:
	MOVF        string_isNumeric_cont_L0+0, 0 
	ADDWF       FARG_string_isNumeric_cadena+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_string_isNumeric_cadena+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	XORLW       0
	BTFSC       STATUS+0, 2 
	GOTO        L_string_isNumeric57
;string.h,160 :: 		if(cadena[cont] < '0' || cadena[cont] > '9')
	MOVF        string_isNumeric_cont_L0+0, 0 
	ADDWF       FARG_string_isNumeric_cadena+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_string_isNumeric_cadena+1, 0 
	MOVWF       FSR0H 
	MOVLW       48
	SUBWF       POSTINC0+0, 0 
	BTFSS       STATUS+0, 0 
	GOTO        L__string_isNumeric956
	MOVF        string_isNumeric_cont_L0+0, 0 
	ADDWF       FARG_string_isNumeric_cadena+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_string_isNumeric_cadena+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	SUBLW       57
	BTFSS       STATUS+0, 0 
	GOTO        L__string_isNumeric956
	GOTO        L_string_isNumeric60
L__string_isNumeric956:
;string.h,161 :: 		return false;
	CLRF        R0 
	GOTO        L_end_string_isNumeric
L_string_isNumeric60:
;string.h,162 :: 		cont++;
	INCF        string_isNumeric_cont_L0+0, 1 
;string.h,163 :: 		}
	GOTO        L_string_isNumeric56
L_string_isNumeric57:
;string.h,165 :: 		if(cont != 0)
	MOVF        string_isNumeric_cont_L0+0, 0 
	XORLW       0
	BTFSC       STATUS+0, 2 
	GOTO        L_string_isNumeric61
;string.h,166 :: 		return true;
	MOVLW       1
	MOVWF       R0 
	GOTO        L_end_string_isNumeric
L_string_isNumeric61:
;string.h,168 :: 		return false;
	CLRF        R0 
;string.h,169 :: 		}
L_end_string_isNumeric:
	RETURN      0
; end of _string_isNumeric

_stringToNumN:

;string.h,171 :: 		long stringToNumN(char *cadena, char size){
;string.h,173 :: 		long numero = 0;
	CLRF        stringToNumN_numero_L0+0 
	CLRF        stringToNumN_numero_L0+1 
	CLRF        stringToNumN_numero_L0+2 
	CLRF        stringToNumN_numero_L0+3 
;string.h,176 :: 		for(cont = 0; cont < size && cadena[cont] != 0; cont++){
	CLRF        stringToNumN_cont_L0+0 
L_stringToNumN63:
	MOVF        FARG_stringToNumN_size+0, 0 
	SUBWF       stringToNumN_cont_L0+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_stringToNumN64
	MOVF        stringToNumN_cont_L0+0, 0 
	ADDWF       FARG_stringToNumN_cadena+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_stringToNumN_cadena+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	XORLW       0
	BTFSC       STATUS+0, 2 
	GOTO        L_stringToNumN64
L__stringToNumN957:
;string.h,177 :: 		numero *= 10;
	MOVF        stringToNumN_numero_L0+0, 0 
	MOVWF       R0 
	MOVF        stringToNumN_numero_L0+1, 0 
	MOVWF       R1 
	MOVF        stringToNumN_numero_L0+2, 0 
	MOVWF       R2 
	MOVF        stringToNumN_numero_L0+3, 0 
	MOVWF       R3 
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVWF       R6 
	MOVWF       R7 
	CALL        _Mul_32x32_U+0, 0
	MOVF        R0, 0 
	MOVWF       stringToNumN_numero_L0+0 
	MOVF        R1, 0 
	MOVWF       stringToNumN_numero_L0+1 
	MOVF        R2, 0 
	MOVWF       stringToNumN_numero_L0+2 
	MOVF        R3, 0 
	MOVWF       stringToNumN_numero_L0+3 
;string.h,178 :: 		numero += cadena[cont]-'0';
	MOVF        stringToNumN_cont_L0+0, 0 
	ADDWF       FARG_stringToNumN_cadena+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_stringToNumN_cadena+1, 0 
	MOVWF       FSR0H 
	MOVLW       48
	SUBWF       POSTINC0+0, 0 
	MOVWF       R4 
	CLRF        R5 
	MOVLW       0
	SUBWFB      R5, 1 
	MOVF        R4, 0 
	ADDWF       R0, 0 
	MOVWF       stringToNumN_numero_L0+0 
	MOVF        R5, 0 
	ADDWFC      R1, 0 
	MOVWF       stringToNumN_numero_L0+1 
	MOVLW       0
	BTFSC       R5, 7 
	MOVLW       255
	ADDWFC      R2, 0 
	MOVWF       stringToNumN_numero_L0+2 
	MOVLW       0
	BTFSC       R5, 7 
	MOVLW       255
	ADDWFC      R3, 0 
	MOVWF       stringToNumN_numero_L0+3 
;string.h,176 :: 		for(cont = 0; cont < size && cadena[cont] != 0; cont++){
	INCF        stringToNumN_cont_L0+0, 1 
;string.h,179 :: 		}
	GOTO        L_stringToNumN63
L_stringToNumN64:
;string.h,181 :: 		return numero;
	MOVF        stringToNumN_numero_L0+0, 0 
	MOVWF       R0 
	MOVF        stringToNumN_numero_L0+1, 0 
	MOVWF       R1 
	MOVF        stringToNumN_numero_L0+2, 0 
	MOVWF       R2 
	MOVF        stringToNumN_numero_L0+3, 0 
	MOVWF       R3 
;string.h,182 :: 		}
L_end_stringToNumN:
	RETURN      0
; end of _stringToNumN

_stringToNum:

;string.h,184 :: 		long stringToNum(char *cadena){
;string.h,185 :: 		short cont = 0;
	CLRF        stringToNum_cont_L0+0 
	CLRF        stringToNum_numero_L0+0 
	CLRF        stringToNum_numero_L0+1 
	CLRF        stringToNum_numero_L0+2 
	CLRF        stringToNum_numero_L0+3 
;string.h,189 :: 		while(cadena[cont]){
L_stringToNum68:
	MOVF        stringToNum_cont_L0+0, 0 
	ADDWF       FARG_stringToNum_cadena+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	BTFSC       stringToNum_cont_L0+0, 7 
	MOVLW       255
	ADDWFC      FARG_stringToNum_cadena+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_stringToNum69
;string.h,190 :: 		numero *= 10;
	MOVF        stringToNum_numero_L0+0, 0 
	MOVWF       R0 
	MOVF        stringToNum_numero_L0+1, 0 
	MOVWF       R1 
	MOVF        stringToNum_numero_L0+2, 0 
	MOVWF       R2 
	MOVF        stringToNum_numero_L0+3, 0 
	MOVWF       R3 
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVWF       R6 
	MOVWF       R7 
	CALL        _Mul_32x32_U+0, 0
	MOVF        R0, 0 
	MOVWF       stringToNum_numero_L0+0 
	MOVF        R1, 0 
	MOVWF       stringToNum_numero_L0+1 
	MOVF        R2, 0 
	MOVWF       stringToNum_numero_L0+2 
	MOVF        R3, 0 
	MOVWF       stringToNum_numero_L0+3 
;string.h,191 :: 		numero += cadena[cont++]-'0';
	MOVF        stringToNum_cont_L0+0, 0 
	ADDWF       FARG_stringToNum_cadena+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	BTFSC       stringToNum_cont_L0+0, 7 
	MOVLW       255
	ADDWFC      FARG_stringToNum_cadena+1, 0 
	MOVWF       FSR0H 
	MOVLW       48
	SUBWF       POSTINC0+0, 0 
	MOVWF       R4 
	CLRF        R5 
	MOVLW       0
	SUBWFB      R5, 1 
	MOVF        R4, 0 
	ADDWF       R0, 0 
	MOVWF       stringToNum_numero_L0+0 
	MOVF        R5, 0 
	ADDWFC      R1, 0 
	MOVWF       stringToNum_numero_L0+1 
	MOVLW       0
	BTFSC       R5, 7 
	MOVLW       255
	ADDWFC      R2, 0 
	MOVWF       stringToNum_numero_L0+2 
	MOVLW       0
	BTFSC       R5, 7 
	MOVLW       255
	ADDWFC      R3, 0 
	MOVWF       stringToNum_numero_L0+3 
	INCF        stringToNum_cont_L0+0, 1 
;string.h,192 :: 		}
	GOTO        L_stringToNum68
L_stringToNum69:
;string.h,194 :: 		return numero;
	MOVF        stringToNum_numero_L0+0, 0 
	MOVWF       R0 
	MOVF        stringToNum_numero_L0+1, 0 
	MOVWF       R1 
	MOVF        stringToNum_numero_L0+2, 0 
	MOVWF       R2 
	MOVF        stringToNum_numero_L0+3, 0 
	MOVWF       R3 
;string.h,195 :: 		}
L_end_stringToNum:
	RETURN      0
; end of _stringToNum

_numToString:

;string.h,197 :: 		char* numToString(long valor, char *cadena, short digitos){
;string.h,198 :: 		cadena[digitos--] = 0;//Agregar final de cadena
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
;string.h,199 :: 		while(digitos >= 0){
L_numToString70:
	MOVLW       128
	XORWF       FARG_numToString_digitos+0, 0 
	MOVWF       R0 
	MOVLW       128
	XORLW       0
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 0 
	GOTO        L_numToString71
;string.h,201 :: 		cadena[digitos--] = (valor % 10) + '0';
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
;string.h,202 :: 		valor /= 10;
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
;string.h,203 :: 		}
	GOTO        L_numToString70
L_numToString71:
;string.h,205 :: 		return cadena;
	MOVF        FARG_numToString_cadena+0, 0 
	MOVWF       R0 
	MOVF        FARG_numToString_cadena+1, 0 
	MOVWF       R1 
;string.h,206 :: 		}
L_end_numToString:
	RETURN      0
; end of _numToString

_numToHex:

;string.h,208 :: 		char* numToHex(long valor, char *cadena, char bytes){
;string.h,209 :: 		char cont = 0;
	CLRF        numToHex_cont_L0+0 
;string.h,212 :: 		while(bytes--){
L_numToHex72:
	MOVF        FARG_numToHex_bytes+0, 0 
	MOVWF       R0 
	DECF        FARG_numToHex_bytes+0, 1 
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_numToHex73
;string.h,214 :: 		cadena[cont] = swap(getByte(valor, bytes))&0x0F;
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
;string.h,215 :: 		if(cadena[cont] < 0x0A)
	MOVF        numToHex_cont_L0+0, 0 
	ADDWF       FARG_numToHex_cadena+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_numToHex_cadena+1, 0 
	MOVWF       FSR0H 
	MOVLW       10
	SUBWF       POSTINC0+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_numToHex74
;string.h,216 :: 		cadena[cont] = cadena[cont] + '0';
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
	GOTO        L_numToHex75
L_numToHex74:
;string.h,218 :: 		cadena[cont] = cadena[cont] + '7';  //Compenso la letra A
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
L_numToHex75:
;string.h,219 :: 		cont++;
	INCF        numToHex_cont_L0+0, 1 
;string.h,221 :: 		cadena[cont] = getByte(valor, bytes)&0x0F;
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
;string.h,222 :: 		if(cadena[cont] < 0x0A)
	MOVF        numToHex_cont_L0+0, 0 
	ADDWF       FARG_numToHex_cadena+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_numToHex_cadena+1, 0 
	MOVWF       FSR0H 
	MOVLW       10
	SUBWF       POSTINC0+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_numToHex76
;string.h,223 :: 		cadena[cont] = cadena[cont] + '0';
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
	GOTO        L_numToHex77
L_numToHex76:
;string.h,225 :: 		cadena[cont] = cadena[cont] + '7';  //Compenso la letra A
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
L_numToHex77:
;string.h,226 :: 		cont++;
	INCF        numToHex_cont_L0+0, 1 
;string.h,227 :: 		}
	GOTO        L_numToHex72
L_numToHex73:
;string.h,228 :: 		cadena[cont] = 0;
	MOVF        numToHex_cont_L0+0, 0 
	ADDWF       FARG_numToHex_cadena+0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      FARG_numToHex_cadena+1, 0 
	MOVWF       FSR1H 
	CLRF        POSTINC1+0 
;string.h,230 :: 		return cadena;
	MOVF        FARG_numToHex_cadena+0, 0 
	MOVWF       R0 
	MOVF        FARG_numToHex_cadena+1, 0 
	MOVWF       R1 
;string.h,231 :: 		}
L_end_numToHex:
	RETURN      0
; end of _numToHex

_hexToNum:

;string.h,233 :: 		long hexToNum(char *hex){
;string.h,235 :: 		char ref = strlen(hex)-1;
	MOVF        FARG_hexToNum_hex+0, 0 
	MOVWF       FARG_strlen_s+0 
	MOVF        FARG_hexToNum_hex+1, 0 
	MOVWF       FARG_strlen_s+1 
	CALL        _strlen+0, 0
	MOVLW       1
	SUBWF       R0, 1 
	MOVLW       0
	SUBWFB      R1, 1 
	MOVF        R0, 0 
	MOVWF       hexToNum_ref_L0+0 
;string.h,236 :: 		long valor = 0;
	CLRF        hexToNum_valor_L0+0 
	CLRF        hexToNum_valor_L0+1 
	CLRF        hexToNum_valor_L0+2 
	CLRF        hexToNum_valor_L0+3 
;string.h,239 :: 		for(cont = 0; cont < 8 && hex[cont]; cont++, ref--){
	CLRF        hexToNum_cont_L0+0 
L_hexToNum78:
	MOVLW       8
	SUBWF       hexToNum_cont_L0+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_hexToNum79
	MOVF        hexToNum_cont_L0+0, 0 
	ADDWF       FARG_hexToNum_hex+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_hexToNum_hex+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_hexToNum79
L__hexToNum961:
;string.h,241 :: 		if(hex[cont] >= '0' && hex[cont] <= '9')
	MOVF        hexToNum_cont_L0+0, 0 
	ADDWF       FARG_hexToNum_hex+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_hexToNum_hex+1, 0 
	MOVWF       FSR0H 
	MOVLW       48
	SUBWF       POSTINC0+0, 0 
	BTFSS       STATUS+0, 0 
	GOTO        L_hexToNum85
	MOVF        hexToNum_cont_L0+0, 0 
	ADDWF       FARG_hexToNum_hex+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_hexToNum_hex+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	SUBLW       57
	BTFSS       STATUS+0, 0 
	GOTO        L_hexToNum85
L__hexToNum960:
;string.h,242 :: 		getByte(valor, ref/2) |= hex[cont] - '0';
	MOVF        hexToNum_ref_L0+0, 0 
	MOVWF       R0 
	RRCF        R0, 1 
	BCF         R0, 7 
	MOVLW       hexToNum_valor_L0+0
	MOVWF       R1 
	MOVLW       hi_addr(hexToNum_valor_L0+0)
	MOVWF       R2 
	MOVF        R0, 0 
	ADDWF       R1, 1 
	BTFSC       STATUS+0, 0 
	INCF        R2, 1 
	MOVF        hexToNum_cont_L0+0, 0 
	ADDWF       FARG_hexToNum_hex+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_hexToNum_hex+1, 0 
	MOVWF       FSR0H 
	MOVLW       48
	SUBWF       POSTINC0+0, 0 
	MOVWF       R0 
	MOVFF       R1, FSR0
	MOVFF       R2, FSR0H
	MOVF        POSTINC0+0, 0 
	IORWF       R0, 1 
	MOVFF       R1, FSR1
	MOVFF       R2, FSR1H
	MOVF        R0, 0 
	MOVWF       POSTINC1+0 
	GOTO        L_hexToNum86
L_hexToNum85:
;string.h,243 :: 		else if(hex[cont] >= 'a' && hex[cont] <= 'f')
	MOVF        hexToNum_cont_L0+0, 0 
	ADDWF       FARG_hexToNum_hex+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_hexToNum_hex+1, 0 
	MOVWF       FSR0H 
	MOVLW       97
	SUBWF       POSTINC0+0, 0 
	BTFSS       STATUS+0, 0 
	GOTO        L_hexToNum89
	MOVF        hexToNum_cont_L0+0, 0 
	ADDWF       FARG_hexToNum_hex+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_hexToNum_hex+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	SUBLW       102
	BTFSS       STATUS+0, 0 
	GOTO        L_hexToNum89
L__hexToNum959:
;string.h,244 :: 		getByte(valor, ref/2) |= 10+(hex[cont] - 'a');
	MOVF        hexToNum_ref_L0+0, 0 
	MOVWF       R0 
	RRCF        R0, 1 
	BCF         R0, 7 
	MOVLW       hexToNum_valor_L0+0
	MOVWF       R1 
	MOVLW       hi_addr(hexToNum_valor_L0+0)
	MOVWF       R2 
	MOVF        R0, 0 
	ADDWF       R1, 1 
	BTFSC       STATUS+0, 0 
	INCF        R2, 1 
	MOVF        hexToNum_cont_L0+0, 0 
	ADDWF       FARG_hexToNum_hex+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_hexToNum_hex+1, 0 
	MOVWF       FSR0H 
	MOVLW       97
	SUBWF       POSTINC0+0, 0 
	MOVWF       R0 
	MOVLW       10
	ADDWF       R0, 1 
	MOVFF       R1, FSR0
	MOVFF       R2, FSR0H
	MOVF        POSTINC0+0, 0 
	IORWF       R0, 1 
	MOVFF       R1, FSR1
	MOVFF       R2, FSR1H
	MOVF        R0, 0 
	MOVWF       POSTINC1+0 
	GOTO        L_hexToNum90
L_hexToNum89:
;string.h,245 :: 		else if(hex[cont] >= 'A' && hex[cont] <= 'F')
	MOVF        hexToNum_cont_L0+0, 0 
	ADDWF       FARG_hexToNum_hex+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_hexToNum_hex+1, 0 
	MOVWF       FSR0H 
	MOVLW       65
	SUBWF       POSTINC0+0, 0 
	BTFSS       STATUS+0, 0 
	GOTO        L_hexToNum93
	MOVF        hexToNum_cont_L0+0, 0 
	ADDWF       FARG_hexToNum_hex+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_hexToNum_hex+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	SUBLW       70
	BTFSS       STATUS+0, 0 
	GOTO        L_hexToNum93
L__hexToNum958:
;string.h,246 :: 		getByte(valor, ref/2) |= 10+(hex[cont] - 'A');
	MOVF        hexToNum_ref_L0+0, 0 
	MOVWF       R0 
	RRCF        R0, 1 
	BCF         R0, 7 
	MOVLW       hexToNum_valor_L0+0
	MOVWF       R1 
	MOVLW       hi_addr(hexToNum_valor_L0+0)
	MOVWF       R2 
	MOVF        R0, 0 
	ADDWF       R1, 1 
	BTFSC       STATUS+0, 0 
	INCF        R2, 1 
	MOVF        hexToNum_cont_L0+0, 0 
	ADDWF       FARG_hexToNum_hex+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_hexToNum_hex+1, 0 
	MOVWF       FSR0H 
	MOVLW       65
	SUBWF       POSTINC0+0, 0 
	MOVWF       R0 
	MOVLW       10
	ADDWF       R0, 1 
	MOVFF       R1, FSR0
	MOVFF       R2, FSR0H
	MOVF        POSTINC0+0, 0 
	IORWF       R0, 1 
	MOVFF       R1, FSR1
	MOVFF       R2, FSR1H
	MOVF        R0, 0 
	MOVWF       POSTINC1+0 
	GOTO        L_hexToNum94
L_hexToNum93:
;string.h,248 :: 		break;  //Fallo la conversion
	GOTO        L_hexToNum79
L_hexToNum94:
L_hexToNum90:
L_hexToNum86:
;string.h,251 :: 		if(ref % 2 == 1)
	MOVLW       1
	ANDWF       hexToNum_ref_L0+0, 0 
	MOVWF       R1 
	MOVF        R1, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_hexToNum95
;string.h,252 :: 		getByte(valor, ref/2) = swap(getByte(valor, ref/2));
	MOVF        hexToNum_ref_L0+0, 0 
	MOVWF       R0 
	RRCF        R0, 1 
	BCF         R0, 7 
	MOVLW       hexToNum_valor_L0+0
	MOVWF       FLOC__hexToNum+0 
	MOVLW       hi_addr(hexToNum_valor_L0+0)
	MOVWF       FLOC__hexToNum+1 
	MOVF        R0, 0 
	ADDWF       FLOC__hexToNum+0, 1 
	BTFSC       STATUS+0, 0 
	INCF        FLOC__hexToNum+1, 1 
	MOVLW       hexToNum_valor_L0+0
	MOVWF       FSR0 
	MOVLW       hi_addr(hexToNum_valor_L0+0)
	MOVWF       FSR0H 
	MOVF        R0, 0 
	ADDWF       FSR0, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR0H, 1 
	MOVF        POSTINC0+0, 0 
	MOVWF       FARG_Swap_input+0 
	CALL        _Swap+0, 0
	MOVFF       FLOC__hexToNum+0, FSR1
	MOVFF       FLOC__hexToNum+1, FSR1H
	MOVF        R0, 0 
	MOVWF       POSTINC1+0 
L_hexToNum95:
;string.h,239 :: 		for(cont = 0; cont < 8 && hex[cont]; cont++, ref--){
	INCF        hexToNum_cont_L0+0, 1 
	DECF        hexToNum_ref_L0+0, 1 
;string.h,253 :: 		}
	GOTO        L_hexToNum78
L_hexToNum79:
;string.h,255 :: 		return valor;
	MOVF        hexToNum_valor_L0+0, 0 
	MOVWF       R0 
	MOVF        hexToNum_valor_L0+1, 0 
	MOVWF       R1 
	MOVF        hexToNum_valor_L0+2, 0 
	MOVWF       R2 
	MOVF        hexToNum_valor_L0+3, 0 
	MOVWF       R3 
;string.h,256 :: 		}
L_end_hexToNum:
	RETURN      0
; end of _hexToNum

_string_toUpper:

;string.h,258 :: 		char* string_toUpper(char *cadena){
;string.h,259 :: 		char cont = 0;
	CLRF        string_toUpper_cont_L0+0 
;string.h,260 :: 		while(cadena[cont] != 0){
L_string_toUpper96:
	MOVF        string_toUpper_cont_L0+0, 0 
	ADDWF       FARG_string_toUpper_cadena+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_string_toUpper_cadena+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	XORLW       0
	BTFSC       STATUS+0, 2 
	GOTO        L_string_toUpper97
;string.h,261 :: 		if(cadena[cont] >= 'a' && cadena[cont] <= 'z')
	MOVF        string_toUpper_cont_L0+0, 0 
	ADDWF       FARG_string_toUpper_cadena+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_string_toUpper_cadena+1, 0 
	MOVWF       FSR0H 
	MOVLW       97
	SUBWF       POSTINC0+0, 0 
	BTFSS       STATUS+0, 0 
	GOTO        L_string_toUpper100
	MOVF        string_toUpper_cont_L0+0, 0 
	ADDWF       FARG_string_toUpper_cadena+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_string_toUpper_cadena+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	SUBLW       122
	BTFSS       STATUS+0, 0 
	GOTO        L_string_toUpper100
L__string_toUpper962:
;string.h,262 :: 		cadena[cont] -= 'a'-'A'; //a = 97, A = 65
	MOVF        string_toUpper_cont_L0+0, 0 
	ADDWF       FARG_string_toUpper_cadena+0, 0 
	MOVWF       R1 
	MOVLW       0
	ADDWFC      FARG_string_toUpper_cadena+1, 0 
	MOVWF       R2 
	MOVFF       R1, FSR0
	MOVFF       R2, FSR0H
	MOVLW       32
	SUBWF       POSTINC0+0, 0 
	MOVWF       R0 
	MOVFF       R1, FSR1
	MOVFF       R2, FSR1H
	MOVF        R0, 0 
	MOVWF       POSTINC1+0 
L_string_toUpper100:
;string.h,263 :: 		cont++;
	INCF        string_toUpper_cont_L0+0, 1 
;string.h,264 :: 		}
	GOTO        L_string_toUpper96
L_string_toUpper97:
;string.h,265 :: 		return cadena;
	MOVF        FARG_string_toUpper_cadena+0, 0 
	MOVWF       R0 
	MOVF        FARG_string_toUpper_cadena+1, 0 
	MOVWF       R1 
;string.h,266 :: 		}
L_end_string_toUpper:
	RETURN      0
; end of _string_toUpper

_wtd_enable:

;lib_wtd.h,6 :: 		void wtd_enable(bool enable){
;lib_wtd.h,7 :: 		asm CLRWDT;
	CLRWDT
;lib_wtd.h,8 :: 		WDTCON.SWDTEN = enable.B0;
	BTFSC       FARG_wtd_enable_enable+0, 0 
	GOTO        L__wtd_enable1054
	BCF         WDTCON+0, 0 
	GOTO        L__wtd_enable1055
L__wtd_enable1054:
	BSF         WDTCON+0, 0 
L__wtd_enable1055:
;lib_wtd.h,11 :: 		}
L_end_wtd_enable:
	RETURN      0
; end of _wtd_enable

_timer1_open:

;lib_timer1.h,10 :: 		void timer1_open(long time_us, bool powerOn, bool enable, bool priorityHigh){
;lib_timer1.h,14 :: 		time_us *= Clock_Mhz();
	MOVF        FARG_timer1_open_time_us+0, 0 
	MOVWF       R0 
	MOVF        FARG_timer1_open_time_us+1, 0 
	MOVWF       R1 
	MOVF        FARG_timer1_open_time_us+2, 0 
	MOVWF       R2 
	MOVF        FARG_timer1_open_time_us+3, 0 
	MOVWF       R3 
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVWF       R6 
	MOVWF       R7 
	CALL        _Mul_32x32_U+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_timer1_open_time_us+0 
	MOVF        R1, 0 
	MOVWF       FARG_timer1_open_time_us+1 
	MOVF        R2, 0 
	MOVWF       FARG_timer1_open_time_us+2 
	MOVF        R3, 0 
	MOVWF       FARG_timer1_open_time_us+3 
;lib_timer1.h,15 :: 		time_us /= 4;
	MOVLW       4
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVWF       R6 
	MOVWF       R7 
	CALL        _Div_32x32_S+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_timer1_open_time_us+0 
	MOVF        R1, 0 
	MOVWF       FARG_timer1_open_time_us+1 
	MOVF        R2, 0 
	MOVWF       FARG_timer1_open_time_us+2 
	MOVF        R3, 0 
	MOVWF       FARG_timer1_open_time_us+3 
;lib_timer1.h,17 :: 		for(i = 0; i < 3; i++){
	CLRF        timer1_open_i_L0+0 
L_timer1_open101:
	MOVLW       3
	SUBWF       timer1_open_i_L0+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_timer1_open102
;lib_timer1.h,18 :: 		if(time_us < 65536)
	MOVLW       128
	XORWF       FARG_timer1_open_time_us+3, 0 
	MOVWF       R0 
	MOVLW       128
	XORLW       0
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__timer1_open1057
	MOVLW       1
	SUBWF       FARG_timer1_open_time_us+2, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__timer1_open1057
	MOVLW       0
	SUBWF       FARG_timer1_open_time_us+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__timer1_open1057
	MOVLW       0
	SUBWF       FARG_timer1_open_time_us+0, 0 
L__timer1_open1057:
	BTFSC       STATUS+0, 0 
	GOTO        L_timer1_open104
;lib_timer1.h,19 :: 		break;
	GOTO        L_timer1_open102
L_timer1_open104:
;lib_timer1.h,21 :: 		time_us /= 2;
	RRCF        FARG_timer1_open_time_us+3, 1 
	RRCF        FARG_timer1_open_time_us+2, 1 
	RRCF        FARG_timer1_open_time_us+1, 1 
	RRCF        FARG_timer1_open_time_us+0, 1 
	BCF         FARG_timer1_open_time_us+3, 7 
	BTFSC       FARG_timer1_open_time_us+3, 6 
	BSF         FARG_timer1_open_time_us+3, 7 
	BTFSS       FARG_timer1_open_time_us+3, 7 
	GOTO        L__timer1_open1058
	BTFSS       STATUS+0, 0 
	GOTO        L__timer1_open1058
	MOVLW       1
	ADDWF       FARG_timer1_open_time_us+0, 1 
	MOVLW       0
	ADDWFC      FARG_timer1_open_time_us+1, 1 
	ADDWFC      FARG_timer1_open_time_us+2, 1 
	ADDWFC      FARG_timer1_open_time_us+3, 1 
L__timer1_open1058:
;lib_timer1.h,17 :: 		for(i = 0; i < 3; i++){
	INCF        timer1_open_i_L0+0, 1 
;lib_timer1.h,22 :: 		}
	GOTO        L_timer1_open101
L_timer1_open102:
;lib_timer1.h,23 :: 		time_us = 65536-time_us;  //Ultima operacion
	MOVLW       0
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	MOVLW       1
	MOVWF       R2 
	MOVLW       0
	MOVWF       R3 
	MOVF        FARG_timer1_open_time_us+0, 0 
	SUBWF       R0, 1 
	MOVF        FARG_timer1_open_time_us+1, 0 
	SUBWFB      R1, 1 
	MOVF        FARG_timer1_open_time_us+2, 0 
	SUBWFB      R2, 1 
	MOVF        FARG_timer1_open_time_us+3, 0 
	SUBWFB      R3, 1 
	MOVF        R0, 0 
	MOVWF       FARG_timer1_open_time_us+0 
	MOVF        R1, 0 
	MOVWF       FARG_timer1_open_time_us+1 
	MOVF        R2, 0 
	MOVWF       FARG_timer1_open_time_us+2 
	MOVF        R3, 0 
	MOVWF       FARG_timer1_open_time_us+3 
;lib_timer1.h,24 :: 		sampler1 = time_us;       //Guardamos el valor del timer
	MOVF        R0, 0 
	MOVWF       _sampler1+0 
	MOVF        R1, 0 
	MOVWF       _sampler1+1 
;lib_timer1.h,26 :: 		T1CON.TMR1ON = 0;       //APAGAR TIMER0
	BCF         T1CON+0, 0 
;lib_timer1.h,27 :: 		T1CON.RD16 = 1;         //FORMATO DE 16 BITS
	BSF         T1CON+0, 7 
;lib_timer1.h,28 :: 		T1CON.T1CKPS0 = i.B0;   //PRESCALER
	BTFSC       timer1_open_i_L0+0, 0 
	GOTO        L__timer1_open1059
	BCF         T1CON+0, 4 
	GOTO        L__timer1_open1060
L__timer1_open1059:
	BSF         T1CON+0, 4 
L__timer1_open1060:
;lib_timer1.h,29 :: 		T1CON.T1CKPS1 = i.B1;   //PRESCALER
	BTFSC       timer1_open_i_L0+0, 1 
	GOTO        L__timer1_open1061
	BCF         T1CON+0, 5 
	GOTO        L__timer1_open1062
L__timer1_open1061:
	BSF         T1CON+0, 5 
L__timer1_open1062:
;lib_timer1.h,30 :: 		T1CON.T1OSCEN = 0;      //SEÑAL EXTERNA APAGADA
	BCF         T1CON+0, 3 
;lib_timer1.h,31 :: 		T1CON.T1SYNC = 0;       //BIT IGNORADO POR USAR CLOCK INTERNO
	BCF         T1CON+0, 2 
;lib_timer1.h,32 :: 		T1CON.TMR1CS = 0;       //CLOCK INTERNO FOSC/4
	BCF         T1CON+0, 1 
;lib_timer1.h,35 :: 		TMR1H = getByte(sampler1,1);
	MOVF        _sampler1+1, 0 
	MOVWF       TMR1H+0 
;lib_timer1.h,36 :: 		TMR1L = getByte(sampler1,0);
	MOVF        _sampler1+0, 0 
	MOVWF       TMR1L+0 
;lib_timer1.h,39 :: 		PIR1.TMR1IF = 0;            //LIMPIAR BANDERA
	BCF         PIR1+0, 0 
;lib_timer1.h,40 :: 		PIE1.TMR1IE = enable;       //ACTIVAR O DESACTIVAR TIMER
	BTFSC       FARG_timer1_open_enable+0, 0 
	GOTO        L__timer1_open1063
	BCF         PIE1+0, 0 
	GOTO        L__timer1_open1064
L__timer1_open1063:
	BSF         PIE1+0, 0 
L__timer1_open1064:
;lib_timer1.h,41 :: 		IPR1.TMR1IP = priorityHigh; //TIPO DE PRIORIDAD
	BTFSC       FARG_timer1_open_priorityHigh+0, 0 
	GOTO        L__timer1_open1065
	BCF         IPR1+0, 0 
	GOTO        L__timer1_open1066
L__timer1_open1065:
	BSF         IPR1+0, 0 
L__timer1_open1066:
;lib_timer1.h,42 :: 		T1CON.TMR1ON = powerOn;     //ENCENDER TIMER
	BTFSC       FARG_timer1_open_powerOn+0, 0 
	GOTO        L__timer1_open1067
	BCF         T1CON+0, 0 
	GOTO        L__timer1_open1068
L__timer1_open1067:
	BSF         T1CON+0, 0 
L__timer1_open1068:
;lib_timer1.h,43 :: 		}
L_end_timer1_open:
	RETURN      0
; end of _timer1_open

_timer1_enable:

;lib_timer1.h,45 :: 		void timer1_enable(bool enable){
;lib_timer1.h,46 :: 		PIE1.TMR1IE = enable;
	BTFSC       FARG_timer1_enable_enable+0, 0 
	GOTO        L__timer1_enable1070
	BCF         PIE1+0, 0 
	GOTO        L__timer1_enable1071
L__timer1_enable1070:
	BSF         PIE1+0, 0 
L__timer1_enable1071:
;lib_timer1.h,47 :: 		}
L_end_timer1_enable:
	RETURN      0
; end of _timer1_enable

_timer1_power:

;lib_timer1.h,49 :: 		void timer1_power(bool on){
;lib_timer1.h,50 :: 		T1CON.TMR1ON = on; //ENCENDER TIMER
	BTFSC       FARG_timer1_power_on+0, 0 
	GOTO        L__timer1_power1073
	BCF         T1CON+0, 0 
	GOTO        L__timer1_power1074
L__timer1_power1073:
	BSF         T1CON+0, 0 
L__timer1_power1074:
;lib_timer1.h,51 :: 		}
L_end_timer1_power:
	RETURN      0
; end of _timer1_power

_timer1_priority:

;lib_timer1.h,53 :: 		void timer1_priority(bool hihg){
;lib_timer1.h,54 :: 		IPR1.TMR1IP = hihg; //TIPO DE PRIORIDAD
	BTFSC       FARG_timer1_priority_hihg+0, 0 
	GOTO        L__timer1_priority1076
	BCF         IPR1+0, 0 
	GOTO        L__timer1_priority1077
L__timer1_priority1076:
	BSF         IPR1+0, 0 
L__timer1_priority1077:
;lib_timer1.h,55 :: 		}
L_end_timer1_priority:
	RETURN      0
; end of _timer1_priority

_timer1_reset:

;lib_timer1.h,57 :: 		void timer1_reset(){
;lib_timer1.h,58 :: 		TMR1H = getByte(sampler1,1);
	MOVF        _sampler1+1, 0 
	MOVWF       TMR1H+0 
;lib_timer1.h,59 :: 		TMR1L = getByte(sampler1,0);
	MOVF        _sampler1+0, 0 
	MOVWF       TMR1L+0 
;lib_timer1.h,60 :: 		}
L_end_timer1_reset:
	RETURN      0
; end of _timer1_reset

_timer2_open:

;lib_timer2.h,9 :: 		void timer2_open(long time_us, bool powerOn, bool enable, bool priorityHigh){
;lib_timer2.h,10 :: 		char pres = 1, post, auxPre = 0xFF;
	MOVLW       1
	MOVWF       timer2_open_pres_L0+0 
	MOVLW       255
	MOVWF       timer2_open_auxPre_L0+0 
;lib_timer2.h,14 :: 		time_us *= Clock_Mhz();
	MOVF        FARG_timer2_open_time_us+0, 0 
	MOVWF       R0 
	MOVF        FARG_timer2_open_time_us+1, 0 
	MOVWF       R1 
	MOVF        FARG_timer2_open_time_us+2, 0 
	MOVWF       R2 
	MOVF        FARG_timer2_open_time_us+3, 0 
	MOVWF       R3 
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVWF       R6 
	MOVWF       R7 
	CALL        _Mul_32x32_U+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_timer2_open_time_us+0 
	MOVF        R1, 0 
	MOVWF       FARG_timer2_open_time_us+1 
	MOVF        R2, 0 
	MOVWF       FARG_timer2_open_time_us+2 
	MOVF        R3, 0 
	MOVWF       FARG_timer2_open_time_us+3 
;lib_timer2.h,17 :: 		for(pres = 1; pres <= 16; pres *= 4){
	MOVLW       1
	MOVWF       timer2_open_pres_L0+0 
L_timer2_open105:
	MOVF        timer2_open_pres_L0+0, 0 
	SUBLW       16
	BTFSS       STATUS+0, 0 
	GOTO        L_timer2_open106
;lib_timer2.h,18 :: 		auxPre++;
	INCF        timer2_open_auxPre_L0+0, 1 
;lib_timer2.h,19 :: 		for(post = 1; post <= 16; post++){
	MOVLW       1
	MOVWF       timer2_open_post_L0+0 
L_timer2_open108:
	MOVF        timer2_open_post_L0+0, 0 
	SUBLW       16
	BTFSS       STATUS+0, 0 
	GOTO        L_timer2_open109
;lib_timer2.h,20 :: 		if(time_us/(pres*post*4U) <= 255){
	MOVF        timer2_open_pres_L0+0, 0 
	MULWF       timer2_open_post_L0+0 
	MOVF        PRODL+0, 0 
	MOVWF       R1 
	MOVF        PRODH+0, 0 
	MOVWF       R2 
	MOVF        R1, 0 
	MOVWF       R4 
	MOVF        R2, 0 
	MOVWF       R5 
	RLCF        R4, 1 
	BCF         R4, 0 
	RLCF        R5, 1 
	RLCF        R4, 1 
	BCF         R4, 0 
	RLCF        R5, 1 
	MOVLW       0
	BTFSC       R5, 7 
	MOVLW       255
	MOVWF       R6 
	MOVWF       R7 
	MOVF        FARG_timer2_open_time_us+0, 0 
	MOVWF       R0 
	MOVF        FARG_timer2_open_time_us+1, 0 
	MOVWF       R1 
	MOVF        FARG_timer2_open_time_us+2, 0 
	MOVWF       R2 
	MOVF        FARG_timer2_open_time_us+3, 0 
	MOVWF       R3 
	CALL        _Div_32x32_S+0, 0
	MOVLW       128
	MOVWF       R4 
	MOVLW       128
	XORWF       R3, 0 
	SUBWF       R4, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__timer2_open1080
	MOVF        R2, 0 
	SUBLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L__timer2_open1080
	MOVF        R1, 0 
	SUBLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L__timer2_open1080
	MOVF        R0, 0 
	SUBLW       255
L__timer2_open1080:
	BTFSS       STATUS+0, 0 
	GOTO        L_timer2_open111
;lib_timer2.h,21 :: 		time_us /= 4;
	MOVLW       4
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVWF       R6 
	MOVWF       R7 
	MOVF        FARG_timer2_open_time_us+0, 0 
	MOVWF       R0 
	MOVF        FARG_timer2_open_time_us+1, 0 
	MOVWF       R1 
	MOVF        FARG_timer2_open_time_us+2, 0 
	MOVWF       R2 
	MOVF        FARG_timer2_open_time_us+3, 0 
	MOVWF       R3 
	CALL        _Div_32x32_S+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_timer2_open_time_us+0 
	MOVF        R1, 0 
	MOVWF       FARG_timer2_open_time_us+1 
	MOVF        R2, 0 
	MOVWF       FARG_timer2_open_time_us+2 
	MOVF        R3, 0 
	MOVWF       FARG_timer2_open_time_us+3 
;lib_timer2.h,22 :: 		time_us /= pres;
	MOVF        timer2_open_pres_L0+0, 0 
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVWF       R6 
	MOVWF       R7 
	CALL        _Div_32x32_S+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_timer2_open_time_us+0 
	MOVF        R1, 0 
	MOVWF       FARG_timer2_open_time_us+1 
	MOVF        R2, 0 
	MOVWF       FARG_timer2_open_time_us+2 
	MOVF        R3, 0 
	MOVWF       FARG_timer2_open_time_us+3 
;lib_timer2.h,23 :: 		time_us /= post;
	MOVF        timer2_open_post_L0+0, 0 
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVWF       R6 
	MOVWF       R7 
	CALL        _Div_32x32_S+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_timer2_open_time_us+0 
	MOVF        R1, 0 
	MOVWF       FARG_timer2_open_time_us+1 
	MOVF        R2, 0 
	MOVWF       FARG_timer2_open_time_us+2 
	MOVF        R3, 0 
	MOVWF       FARG_timer2_open_time_us+3 
;lib_timer2.h,24 :: 		PR2 = time_us;
	MOVF        R0, 0 
	MOVWF       PR2+0 
;lib_timer2.h,25 :: 		pres = 16; //Para fozar salir del otro for
	MOVLW       16
	MOVWF       timer2_open_pres_L0+0 
;lib_timer2.h,26 :: 		break;
	GOTO        L_timer2_open109
;lib_timer2.h,27 :: 		}
L_timer2_open111:
;lib_timer2.h,19 :: 		for(post = 1; post <= 16; post++){
	INCF        timer2_open_post_L0+0, 1 
;lib_timer2.h,28 :: 		}
	GOTO        L_timer2_open108
L_timer2_open109:
;lib_timer2.h,17 :: 		for(pres = 1; pres <= 16; pres *= 4){
	RLCF        timer2_open_pres_L0+0, 1 
	BCF         timer2_open_pres_L0+0, 0 
	RLCF        timer2_open_pres_L0+0, 1 
	BCF         timer2_open_pres_L0+0, 0 
;lib_timer2.h,29 :: 		}
	GOTO        L_timer2_open105
L_timer2_open106:
;lib_timer2.h,32 :: 		T2CON.T2CKPS0 = auxPre.B0;  //Prescaler
	BTFSC       timer2_open_auxPre_L0+0, 0 
	GOTO        L__timer2_open1081
	BCF         T2CON+0, 0 
	GOTO        L__timer2_open1082
L__timer2_open1081:
	BSF         T2CON+0, 0 
L__timer2_open1082:
;lib_timer2.h,33 :: 		T2CON.T2CKPS1 = auxPre.B1;  //Prescaler
	BTFSC       timer2_open_auxPre_L0+0, 1 
	GOTO        L__timer2_open1083
	BCF         T2CON+0, 1 
	GOTO        L__timer2_open1084
L__timer2_open1083:
	BSF         T2CON+0, 1 
L__timer2_open1084:
;lib_timer2.h,34 :: 		post--;
	DECF        timer2_open_post_L0+0, 1 
;lib_timer2.h,35 :: 		T2CON.T2OUTPS0 = post.B0;   //Postcaler
	BTFSC       timer2_open_post_L0+0, 0 
	GOTO        L__timer2_open1085
	BCF         T2CON+0, 3 
	GOTO        L__timer2_open1086
L__timer2_open1085:
	BSF         T2CON+0, 3 
L__timer2_open1086:
;lib_timer2.h,36 :: 		T2CON.T2OUTPS1 = post.B1;   //Postcaler
	BTFSC       timer2_open_post_L0+0, 1 
	GOTO        L__timer2_open1087
	BCF         T2CON+0, 4 
	GOTO        L__timer2_open1088
L__timer2_open1087:
	BSF         T2CON+0, 4 
L__timer2_open1088:
;lib_timer2.h,37 :: 		T2CON.T2OUTPS2 = post.B2;   //Postcaler
	BTFSC       timer2_open_post_L0+0, 2 
	GOTO        L__timer2_open1089
	BCF         T2CON+0, 5 
	GOTO        L__timer2_open1090
L__timer2_open1089:
	BSF         T2CON+0, 5 
L__timer2_open1090:
;lib_timer2.h,38 :: 		T2CON.T2OUTPS3 = post.B3;   //Postcaler
	BTFSC       timer2_open_post_L0+0, 3 
	GOTO        L__timer2_open1091
	BCF         T2CON+0, 6 
	GOTO        L__timer2_open1092
L__timer2_open1091:
	BSF         T2CON+0, 6 
L__timer2_open1092:
;lib_timer2.h,41 :: 		TMR2 = 0;
	CLRF        TMR2+0 
;lib_timer2.h,44 :: 		PIR1.TMR2IF = 0;            //LIMPIAR BANDERA
	BCF         PIR1+0, 1 
;lib_timer2.h,45 :: 		PIE1.TMR2IE = enable;       //ACTIVAR O DESACTIVAR TIMER
	BTFSC       FARG_timer2_open_enable+0, 0 
	GOTO        L__timer2_open1093
	BCF         PIE1+0, 1 
	GOTO        L__timer2_open1094
L__timer2_open1093:
	BSF         PIE1+0, 1 
L__timer2_open1094:
;lib_timer2.h,46 :: 		IPR1.TMR2IP = priorityHigh; //TIPO DE PRIORIDAD
	BTFSC       FARG_timer2_open_priorityHigh+0, 0 
	GOTO        L__timer2_open1095
	BCF         IPR1+0, 1 
	GOTO        L__timer2_open1096
L__timer2_open1095:
	BSF         IPR1+0, 1 
L__timer2_open1096:
;lib_timer2.h,47 :: 		T2CON.TMR2ON = powerOn;     //ENCENDER TIMER
	BTFSC       FARG_timer2_open_powerOn+0, 0 
	GOTO        L__timer2_open1097
	BCF         T2CON+0, 2 
	GOTO        L__timer2_open1098
L__timer2_open1097:
	BSF         T2CON+0, 2 
L__timer2_open1098:
;lib_timer2.h,48 :: 		}
L_end_timer2_open:
	RETURN      0
; end of _timer2_open

_timer2_enable:

;lib_timer2.h,50 :: 		void timer2_enable(bool enable){
;lib_timer2.h,51 :: 		PIE1.TMR2IE = enable;       //ACTIVAR O DESACTIVAR TIMER
	BTFSC       FARG_timer2_enable_enable+0, 0 
	GOTO        L__timer2_enable1100
	BCF         PIE1+0, 1 
	GOTO        L__timer2_enable1101
L__timer2_enable1100:
	BSF         PIE1+0, 1 
L__timer2_enable1101:
;lib_timer2.h,52 :: 		}
L_end_timer2_enable:
	RETURN      0
; end of _timer2_enable

_timer2_power:

;lib_timer2.h,54 :: 		void timer2_power(bool on){
;lib_timer2.h,55 :: 		T2CON.TMR2ON = on;     //ENCENDER TIMER
	BTFSC       FARG_timer2_power_on+0, 0 
	GOTO        L__timer2_power1103
	BCF         T2CON+0, 2 
	GOTO        L__timer2_power1104
L__timer2_power1103:
	BSF         T2CON+0, 2 
L__timer2_power1104:
;lib_timer2.h,56 :: 		}
L_end_timer2_power:
	RETURN      0
; end of _timer2_power

_timer2_priority:

;lib_timer2.h,58 :: 		void timer2_priority(bool hihg){
;lib_timer2.h,59 :: 		IPR1.TMR2IP = hihg; //TIPO DE PRIORIDAD
	BTFSC       FARG_timer2_priority_hihg+0, 0 
	GOTO        L__timer2_priority1106
	BCF         IPR1+0, 1 
	GOTO        L__timer2_priority1107
L__timer2_priority1106:
	BSF         IPR1+0, 1 
L__timer2_priority1107:
;lib_timer2.h,60 :: 		}
L_end_timer2_priority:
	RETURN      0
; end of _timer2_priority

_timer3_open:

;lib_timer3.h,10 :: 		void timer3_open(long time_us, bool powerOn, bool enable, bool priorityHigh){
;lib_timer3.h,14 :: 		time_us *= Clock_Mhz();
	MOVF        FARG_timer3_open_time_us+0, 0 
	MOVWF       R0 
	MOVF        FARG_timer3_open_time_us+1, 0 
	MOVWF       R1 
	MOVF        FARG_timer3_open_time_us+2, 0 
	MOVWF       R2 
	MOVF        FARG_timer3_open_time_us+3, 0 
	MOVWF       R3 
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVWF       R6 
	MOVWF       R7 
	CALL        _Mul_32x32_U+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_timer3_open_time_us+0 
	MOVF        R1, 0 
	MOVWF       FARG_timer3_open_time_us+1 
	MOVF        R2, 0 
	MOVWF       FARG_timer3_open_time_us+2 
	MOVF        R3, 0 
	MOVWF       FARG_timer3_open_time_us+3 
;lib_timer3.h,15 :: 		time_us /= 4;
	MOVLW       4
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVWF       R6 
	MOVWF       R7 
	CALL        _Div_32x32_S+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_timer3_open_time_us+0 
	MOVF        R1, 0 
	MOVWF       FARG_timer3_open_time_us+1 
	MOVF        R2, 0 
	MOVWF       FARG_timer3_open_time_us+2 
	MOVF        R3, 0 
	MOVWF       FARG_timer3_open_time_us+3 
;lib_timer3.h,17 :: 		for(i = 0; i < 3; i++){
	CLRF        timer3_open_i_L0+0 
L_timer3_open112:
	MOVLW       3
	SUBWF       timer3_open_i_L0+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_timer3_open113
;lib_timer3.h,18 :: 		if(time_us < 65536)
	MOVLW       128
	XORWF       FARG_timer3_open_time_us+3, 0 
	MOVWF       R0 
	MOVLW       128
	XORLW       0
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__timer3_open1109
	MOVLW       1
	SUBWF       FARG_timer3_open_time_us+2, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__timer3_open1109
	MOVLW       0
	SUBWF       FARG_timer3_open_time_us+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__timer3_open1109
	MOVLW       0
	SUBWF       FARG_timer3_open_time_us+0, 0 
L__timer3_open1109:
	BTFSC       STATUS+0, 0 
	GOTO        L_timer3_open115
;lib_timer3.h,19 :: 		break;
	GOTO        L_timer3_open113
L_timer3_open115:
;lib_timer3.h,21 :: 		time_us /= 2;
	RRCF        FARG_timer3_open_time_us+3, 1 
	RRCF        FARG_timer3_open_time_us+2, 1 
	RRCF        FARG_timer3_open_time_us+1, 1 
	RRCF        FARG_timer3_open_time_us+0, 1 
	BCF         FARG_timer3_open_time_us+3, 7 
	BTFSC       FARG_timer3_open_time_us+3, 6 
	BSF         FARG_timer3_open_time_us+3, 7 
	BTFSS       FARG_timer3_open_time_us+3, 7 
	GOTO        L__timer3_open1110
	BTFSS       STATUS+0, 0 
	GOTO        L__timer3_open1110
	MOVLW       1
	ADDWF       FARG_timer3_open_time_us+0, 1 
	MOVLW       0
	ADDWFC      FARG_timer3_open_time_us+1, 1 
	ADDWFC      FARG_timer3_open_time_us+2, 1 
	ADDWFC      FARG_timer3_open_time_us+3, 1 
L__timer3_open1110:
;lib_timer3.h,17 :: 		for(i = 0; i < 3; i++){
	INCF        timer3_open_i_L0+0, 1 
;lib_timer3.h,22 :: 		}
	GOTO        L_timer3_open112
L_timer3_open113:
;lib_timer3.h,23 :: 		time_us = 65536-time_us;  //Ultima operacion
	MOVLW       0
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	MOVLW       1
	MOVWF       R2 
	MOVLW       0
	MOVWF       R3 
	MOVF        FARG_timer3_open_time_us+0, 0 
	SUBWF       R0, 1 
	MOVF        FARG_timer3_open_time_us+1, 0 
	SUBWFB      R1, 1 
	MOVF        FARG_timer3_open_time_us+2, 0 
	SUBWFB      R2, 1 
	MOVF        FARG_timer3_open_time_us+3, 0 
	SUBWFB      R3, 1 
	MOVF        R0, 0 
	MOVWF       FARG_timer3_open_time_us+0 
	MOVF        R1, 0 
	MOVWF       FARG_timer3_open_time_us+1 
	MOVF        R2, 0 
	MOVWF       FARG_timer3_open_time_us+2 
	MOVF        R3, 0 
	MOVWF       FARG_timer3_open_time_us+3 
;lib_timer3.h,24 :: 		sampler3 = time_us;       //Guardamos el valor del timer
	MOVF        R0, 0 
	MOVWF       _sampler3+0 
	MOVF        R1, 0 
	MOVWF       _sampler3+1 
;lib_timer3.h,26 :: 		T3CON.TMR3ON = 0;       //APAGAR TIMER0
	BCF         T3CON+0, 0 
;lib_timer3.h,27 :: 		T3CON.RD16 = 1;         //FORMATO DE 16 BITS
	BSF         T3CON+0, 7 
;lib_timer3.h,28 :: 		T3CON.T3CCP1 = 1;      //TIMER3 PARA CLOCK EN CCP1 Y ECCP
	BSF         T3CON+0, 3 
;lib_timer3.h,29 :: 		T3CON.T3ECCP1 = 1;      //TIMER3 PARA CLOCK EN CCP1 Y ECCP
	BSF         T3CON+0, 6 
;lib_timer3.h,30 :: 		T3CON.T3CKPS0 = i.B0;   //PRESCALER
	BTFSC       timer3_open_i_L0+0, 0 
	GOTO        L__timer3_open1111
	BCF         T3CON+0, 4 
	GOTO        L__timer3_open1112
L__timer3_open1111:
	BSF         T3CON+0, 4 
L__timer3_open1112:
;lib_timer3.h,31 :: 		T3CON.T3CKPS1 = i.B1;   //PRESCALER
	BTFSC       timer3_open_i_L0+0, 1 
	GOTO        L__timer3_open1113
	BCF         T3CON+0, 5 
	GOTO        L__timer3_open1114
L__timer3_open1113:
	BSF         T3CON+0, 5 
L__timer3_open1114:
;lib_timer3.h,32 :: 		T3CON.T3SYNC = 0;       //BIT IGNORADO POR USAR CLOCK INTERNO
	BCF         T3CON+0, 2 
;lib_timer3.h,33 :: 		T3CON.TMR3CS = 0;       //CLOCK INTERNO FOSC/4
	BCF         T3CON+0, 1 
;lib_timer3.h,36 :: 		TMR3H = getByte(sampler3,1);
	MOVF        _sampler3+1, 0 
	MOVWF       TMR3H+0 
;lib_timer3.h,37 :: 		TMR3L = getByte(sampler3,0);
	MOVF        _sampler3+0, 0 
	MOVWF       TMR3L+0 
;lib_timer3.h,40 :: 		PIR2.TMR3IF = 0;            //LIMPIAR BANDERA
	BCF         PIR2+0, 1 
;lib_timer3.h,41 :: 		PIE2.TMR3IE = enable;       //ACTIVAR O DESACTIVAR TIMER
	BTFSC       FARG_timer3_open_enable+0, 0 
	GOTO        L__timer3_open1115
	BCF         PIE2+0, 1 
	GOTO        L__timer3_open1116
L__timer3_open1115:
	BSF         PIE2+0, 1 
L__timer3_open1116:
;lib_timer3.h,42 :: 		IPR2.TMR3IP = priorityHigh; //TIPO DE PRIORIDAD
	BTFSC       FARG_timer3_open_priorityHigh+0, 0 
	GOTO        L__timer3_open1117
	BCF         IPR2+0, 1 
	GOTO        L__timer3_open1118
L__timer3_open1117:
	BSF         IPR2+0, 1 
L__timer3_open1118:
;lib_timer3.h,43 :: 		T3CON.TMR3ON = powerOn;     //ENCENDER TIMER
	BTFSC       FARG_timer3_open_powerOn+0, 0 
	GOTO        L__timer3_open1119
	BCF         T3CON+0, 0 
	GOTO        L__timer3_open1120
L__timer3_open1119:
	BSF         T3CON+0, 0 
L__timer3_open1120:
;lib_timer3.h,44 :: 		}
L_end_timer3_open:
	RETURN      0
; end of _timer3_open

_timer3_enable:

;lib_timer3.h,46 :: 		void timer3_enable(bool enable){
;lib_timer3.h,47 :: 		PIE3.TMR3IE = enable;
	BTFSC       FARG_timer3_enable_enable+0, 0 
	GOTO        L__timer3_enable1122
	BCF         PIE3+0, 1 
	GOTO        L__timer3_enable1123
L__timer3_enable1122:
	BSF         PIE3+0, 1 
L__timer3_enable1123:
;lib_timer3.h,48 :: 		}
L_end_timer3_enable:
	RETURN      0
; end of _timer3_enable

_timer3_power:

;lib_timer3.h,50 :: 		void timer3_power(bool on){
;lib_timer3.h,51 :: 		T3CON.TMR3ON = on; //ENCENDER TIMER
	BTFSC       FARG_timer3_power_on+0, 0 
	GOTO        L__timer3_power1125
	BCF         T3CON+0, 0 
	GOTO        L__timer3_power1126
L__timer3_power1125:
	BSF         T3CON+0, 0 
L__timer3_power1126:
;lib_timer3.h,52 :: 		}
L_end_timer3_power:
	RETURN      0
; end of _timer3_power

_timer3_priority:

;lib_timer3.h,54 :: 		void timer3_priority(bool hihg){
;lib_timer3.h,55 :: 		IPR2.TMR3IP = hihg; //TIPO DE PRIORIDAD
	BTFSC       FARG_timer3_priority_hihg+0, 0 
	GOTO        L__timer3_priority1128
	BCF         IPR2+0, 1 
	GOTO        L__timer3_priority1129
L__timer3_priority1128:
	BSF         IPR2+0, 1 
L__timer3_priority1129:
;lib_timer3.h,56 :: 		}
L_end_timer3_priority:
	RETURN      0
; end of _timer3_priority

_usart_open:

;lib_usart.h,38 :: 		void usart_open(unsigned long baudRate){
;lib_usart.h,40 :: 		TXSTA.CSRC = 0;   //NO IMPORTA, MODO ASYNCHRONO
	BCF         TXSTA+0, 7 
;lib_usart.h,41 :: 		TXSTA.TX9 = 0;    //MODO 8 BITS DE TRANSMISION
	BCF         TXSTA+0, 6 
;lib_usart.h,42 :: 		TXSTA.TXEN = 1;   //DISPONIBLE TX
	BSF         TXSTA+0, 5 
;lib_usart.h,43 :: 		TXSTA.SYNC = 0;   //MODO ASYNCHRONO
	BCF         TXSTA+0, 4 
;lib_usart.h,44 :: 		TXSTA.SENDB = 0;  //ENVIAR ROTURA DE TRANSMISION COMPLETADA ***
	BCF         TXSTA+0, 3 
;lib_usart.h,45 :: 		TXSTA.BRGH = 1;   //0 - LOW SPEED, 1 - HIHG SPEED
	BSF         TXSTA+0, 2 
;lib_usart.h,47 :: 		TXSTA.TX9D = 0;   //BIT DE PARIDAD
	BCF         TXSTA+0, 0 
;lib_usart.h,50 :: 		RCSTA.RX9 = 0;    //MODO 8 BITS RECEPCION
	BCF         RCSTA+0, 6 
;lib_usart.h,51 :: 		RCSTA.SREN = 0;   //NO IMPORTA, MODO ASYNCHRONO
	BCF         RCSTA+0, 5 
;lib_usart.h,52 :: 		RCSTA.CREN = 1;   //DISPONIBLE RX
	BSF         RCSTA+0, 4 
;lib_usart.h,53 :: 		RCSTA.ADDEN = 0;  //DISABLE INTERRUPT POR RECIBIR EL 9BIT
	BCF         RCSTA+0, 3 
;lib_usart.h,54 :: 		RCSTA.SPEN = 1;   //CONFIGURA PINES RX AND TX COMO SERIALES
	BSF         RCSTA+0, 7 
;lib_usart.h,61 :: 		BAUDCON.SCKP = 0; //NO IMPORTA, MODO ASYNCHRONOS
	BCF         BAUDCON+0, 4 
;lib_usart.h,62 :: 		BAUDCON.BRG16 = 1;//MODO 16 BITS
	BSF         BAUDCON+0, 3 
;lib_usart.h,63 :: 		BAUDCON.WUE = 0;  //PIN RX NO ES MONITORIADO EN FLANCO DE BAJADA***
	BCF         BAUDCON+0, 1 
;lib_usart.h,64 :: 		BAUDCON.ABDEN = 0;//DISABLE MODO MEDICION DE BAUDIOS***
	BCF         BAUDCON+0, 0 
;lib_usart.h,68 :: 		baudRate >>= 1;                           //Divido sobre dos
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
;lib_usart.h,69 :: 		baudRate = (Clock_MHz()*250e3)/baudRate;  //Fosc/(Baudios/2)
	CALL        _longword2double+0, 0
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
	CALL        _double2longword+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_usart_open_baudRate+0 
	MOVF        R1, 0 
	MOVWF       FARG_usart_open_baudRate+1 
	MOVF        R2, 0 
	MOVWF       FARG_usart_open_baudRate+2 
	MOVF        R3, 0 
	MOVWF       FARG_usart_open_baudRate+3 
;lib_usart.h,70 :: 		baudRate += 1;                            //Sumar uno por compute round
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
;lib_usart.h,71 :: 		baudRate >>= 1;                           //Divido sobre dos
	RRCF        FARG_usart_open_baudRate+3, 1 
	RRCF        FARG_usart_open_baudRate+2, 1 
	RRCF        FARG_usart_open_baudRate+1, 1 
	RRCF        FARG_usart_open_baudRate+0, 1 
	BCF         FARG_usart_open_baudRate+3, 7 
;lib_usart.h,72 :: 		baudRate -= 1;                            //Resto -1, formula
	MOVLW       1
	SUBWF       FARG_usart_open_baudRate+0, 1 
	MOVLW       0
	SUBWFB      FARG_usart_open_baudRate+1, 1 
	SUBWFB      FARG_usart_open_baudRate+2, 1 
	SUBWFB      FARG_usart_open_baudRate+3, 1 
;lib_usart.h,73 :: 		SPBRG = getByte(baudRate,0);
	MOVF        FARG_usart_open_baudRate+0, 0 
	MOVWF       SPBRG+0 
;lib_usart.h,74 :: 		SPBRGH = getByte(baudRate,1);
	MOVF        FARG_usart_open_baudRate+1, 0 
	MOVWF       SPBRGH+0 
;lib_usart.h,77 :: 		TRISC.B6 = 0;   //TX
	BCF         TRISC+0, 6 
;lib_usart.h,78 :: 		TRISC.B7 = 1;   //RX
	BSF         TRISC+0, 7 
;lib_usart.h,81 :: 		while(!TXSTA.TRMT);
L_usart_open116:
	BTFSC       TXSTA+0, 1 
	GOTO        L_usart_open117
	GOTO        L_usart_open116
L_usart_open117:
;lib_usart.h,82 :: 		}
L_end_usart_open:
	RETURN      0
; end of _usart_open

_usart_read:

;lib_usart.h,84 :: 		bool usart_read(char *result){
;lib_usart.h,85 :: 		if(PIR1.RCIF){
	BTFSS       PIR1+0, 5 
	GOTO        L_usart_read118
;lib_usart.h,86 :: 		*result = RCREG;
	MOVFF       FARG_usart_read_result+0, FSR1
	MOVFF       FARG_usart_read_result+1, FSR1H
	MOVF        RCREG+0, 0 
	MOVWF       POSTINC1+0 
;lib_usart.h,87 :: 		PIR1.RCIF = 0;
	BCF         PIR1+0, 5 
;lib_usart.h,88 :: 		return true;
	MOVLW       1
	MOVWF       R0 
	GOTO        L_end_usart_read
;lib_usart.h,89 :: 		}
L_usart_read118:
;lib_usart.h,91 :: 		return false;
	CLRF        R0 
;lib_usart.h,92 :: 		}
L_end_usart_read:
	RETURN      0
; end of _usart_read

_usart_write:

;lib_usart.h,94 :: 		void usart_write(char caracter){
;lib_usart.h,95 :: 		TXREG = caracter;
	MOVF        FARG_usart_write_caracter+0, 0 
	MOVWF       TXREG+0 
;lib_usart.h,96 :: 		while(!TXSTA.TRMT);  //Esperar a que el buffer se vacie
L_usart_write119:
	BTFSC       TXSTA+0, 1 
	GOTO        L_usart_write120
	GOTO        L_usart_write119
L_usart_write120:
;lib_usart.h,97 :: 		}
L_end_usart_write:
	RETURN      0
; end of _usart_write

_usart_write_text:

;lib_usart.h,99 :: 		void usart_write_text(char *texto){
;lib_usart.h,100 :: 		char cont = 0;
	CLRF        usart_write_text_cont_L0+0 
;lib_usart.h,102 :: 		while(texto[cont]){
L_usart_write_text121:
	MOVF        usart_write_text_cont_L0+0, 0 
	ADDWF       FARG_usart_write_text_texto+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_usart_write_text_texto+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_usart_write_text122
;lib_usart.h,103 :: 		TXREG = texto[cont++];
	MOVF        usart_write_text_cont_L0+0, 0 
	ADDWF       FARG_usart_write_text_texto+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_usart_write_text_texto+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       TXREG+0 
	INCF        usart_write_text_cont_L0+0, 1 
;lib_usart.h,104 :: 		while(!TXSTA.TRMT);    //Esperar a que el buffer se vacie en evnvio
L_usart_write_text123:
	BTFSC       TXSTA+0, 1 
	GOTO        L_usart_write_text124
	GOTO        L_usart_write_text123
L_usart_write_text124:
;lib_usart.h,105 :: 		}
	GOTO        L_usart_write_text121
L_usart_write_text122:
;lib_usart.h,106 :: 		}
L_end_usart_write_text:
	RETURN      0
; end of _usart_write_text

_usart_write_line:

;lib_usart.h,108 :: 		void usart_write_line(char *texto){
;lib_usart.h,109 :: 		char cont = 0;
	CLRF        usart_write_line_cont_L0+0 
;lib_usart.h,111 :: 		while(texto[cont]){
L_usart_write_line125:
	MOVF        usart_write_line_cont_L0+0, 0 
	ADDWF       FARG_usart_write_line_texto+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_usart_write_line_texto+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_usart_write_line126
;lib_usart.h,112 :: 		TXREG = texto[cont++];
	MOVF        usart_write_line_cont_L0+0, 0 
	ADDWF       FARG_usart_write_line_texto+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_usart_write_line_texto+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       TXREG+0 
	INCF        usart_write_line_cont_L0+0, 1 
;lib_usart.h,113 :: 		while(!TXSTA.TRMT);    //Esperar a que el buffer se vacie en evnvio
L_usart_write_line127:
	BTFSC       TXSTA+0, 1 
	GOTO        L_usart_write_line128
	GOTO        L_usart_write_line127
L_usart_write_line128:
;lib_usart.h,114 :: 		}
	GOTO        L_usart_write_line125
L_usart_write_line126:
;lib_usart.h,116 :: 		TXREG = USART_NEW_LINE[0];
	MOVLW       13
	MOVWF       TXREG+0 
;lib_usart.h,117 :: 		while(!TXSTA.TRMT);    //Esperar a que el buffer se vacie en evnvio
L_usart_write_line129:
	BTFSC       TXSTA+0, 1 
	GOTO        L_usart_write_line130
	GOTO        L_usart_write_line129
L_usart_write_line130:
;lib_usart.h,118 :: 		TXREG = USART_NEW_LINE[1];
	MOVLW       10
	MOVWF       TXREG+0 
;lib_usart.h,119 :: 		while(!TXSTA.TRMT);    //Esperar a que el buffer se vacie en evnvio
L_usart_write_line131:
	BTFSC       TXSTA+0, 1 
	GOTO        L_usart_write_line132
	GOTO        L_usart_write_line131
L_usart_write_line132:
;lib_usart.h,120 :: 		}
L_end_usart_write_line:
	RETURN      0
; end of _usart_write_line

_usart_enable_rx:

;lib_usart.h,122 :: 		void usart_enable_rx(bool enable, bool priorityHigh, char delimitir){
;lib_usart.h,124 :: 		usart.rx_cont = 0;  //POSICION INICIAL
	CLRF        _usart+35 
;lib_usart.h,125 :: 		usart.rx_delimiter = delimitir;
	MOVF        FARG_usart_enable_rx_delimitir+0, 0 
	MOVWF       _usart+32 
;lib_usart.h,126 :: 		usart.rx_new_message = false;
	CLRF        _usart+33 
;lib_usart.h,127 :: 		usart.rx_overflow = false;
	CLRF        _usart+34 
;lib_usart.h,130 :: 		IPR1.RCIP = priorityHigh;
	BTFSC       FARG_usart_enable_rx_priorityHigh+0, 0 
	GOTO        L__usart_enable_rx1136
	BCF         IPR1+0, 5 
	GOTO        L__usart_enable_rx1137
L__usart_enable_rx1136:
	BSF         IPR1+0, 5 
L__usart_enable_rx1137:
;lib_usart.h,131 :: 		PIR1.RCIF = 0;
	BCF         PIR1+0, 5 
;lib_usart.h,132 :: 		PIE1.RCIE = enable;
	BTFSC       FARG_usart_enable_rx_enable+0, 0 
	GOTO        L__usart_enable_rx1138
	BCF         PIE1+0, 5 
	GOTO        L__usart_enable_rx1139
L__usart_enable_rx1138:
	BSF         PIE1+0, 5 
L__usart_enable_rx1139:
;lib_usart.h,133 :: 		}
L_end_usart_enable_rx:
	RETURN      0
; end of _usart_enable_rx

_usart_enable_tx:

;lib_usart.h,135 :: 		void usart_enable_tx(bool priorityHigh){
;lib_usart.h,137 :: 		usart.tx_free = true;
	MOVLW       1
	MOVWF       _usart+36 
;lib_usart.h,138 :: 		usart.tx_cont = 0;  //POSICION INICIAL
	CLRF        _usart+37 
;lib_usart.h,141 :: 		IPR1.TXIP = priorityHigh;
	BTFSC       FARG_usart_enable_tx_priorityHigh+0, 0 
	GOTO        L__usart_enable_tx1141
	BCF         IPR1+0, 4 
	GOTO        L__usart_enable_tx1142
L__usart_enable_tx1141:
	BSF         IPR1+0, 4 
L__usart_enable_tx1142:
;lib_usart.h,142 :: 		PIR1.TXIF = 0;
	BCF         PIR1+0, 4 
;lib_usart.h,143 :: 		PIE1.TXIE = 0;
	BCF         PIE1+0, 4 
;lib_usart.h,144 :: 		}
L_end_usart_enable_tx:
	RETURN      0
; end of _usart_enable_tx

_usart_do_read_text:

;lib_usart.h,146 :: 		void usart_do_read_text(){
;lib_usart.h,148 :: 		if(usart.rx_new_message){
	MOVF        _usart+33, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_usart_do_read_text133
;lib_usart.h,149 :: 		usart_user_read_text();
	CALL        _usart_user_read_text+0, 0
;lib_usart.h,150 :: 		usart.rx_new_message = false;
	CLRF        _usart+33 
;lib_usart.h,151 :: 		}
L_usart_do_read_text133:
;lib_usart.h,152 :: 		}
L_end_usart_do_read_text:
	RETURN      0
; end of _usart_do_read_text

_usart_write_text_int:

;lib_usart.h,154 :: 		bool usart_write_text_int(char *texto){
;lib_usart.h,156 :: 		if(usart.tx_free && TXSTA.TRMT){
	MOVF        _usart+36, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_usart_write_text_int136
	BTFSS       TXSTA+0, 1 
	GOTO        L_usart_write_text_int136
L__usart_write_text_int963:
;lib_usart.h,157 :: 		usart.tx_free = false;
	CLRF        _usart+36 
;lib_usart.h,159 :: 		string_cpyn(usart.tx_buffer, texto, UART_BUFFER_SIZE-1);
	MOVLW       _usart+38
	MOVWF       FARG_string_cpyn_destino+0 
	MOVLW       hi_addr(_usart+38)
	MOVWF       FARG_string_cpyn_destino+1 
	MOVF        FARG_usart_write_text_int_texto+0, 0 
	MOVWF       FARG_string_cpyn_origen+0 
	MOVF        FARG_usart_write_text_int_texto+1, 0 
	MOVWF       FARG_string_cpyn_origen+1 
	MOVLW       31
	MOVWF       FARG_string_cpyn_size+0 
	CALL        _string_cpyn+0, 0
;lib_usart.h,160 :: 		usart.tx_cont = 0;  //POSICION INICIAL
	CLRF        _usart+37 
;lib_usart.h,161 :: 		PIE1.TXIE = 1;
	BSF         PIE1+0, 4 
;lib_usart.h,162 :: 		return true;
	MOVLW       1
	MOVWF       R0 
	GOTO        L_end_usart_write_text_int
;lib_usart.h,163 :: 		}
L_usart_write_text_int136:
;lib_usart.h,165 :: 		return false;
	CLRF        R0 
;lib_usart.h,166 :: 		}
L_end_usart_write_text_int:
	RETURN      0
; end of _usart_write_text_int

_int_usart_rx:

;lib_usart.h,168 :: 		void int_usart_rx(void){
;lib_usart.h,169 :: 		if(PIE1.RCIE && PIR1.RCIF){
	BTFSS       PIE1+0, 5 
	GOTO        L_int_usart_rx139
	BTFSS       PIR1+0, 5 
	GOTO        L_int_usart_rx139
L__int_usart_rx964:
;lib_usart.h,170 :: 		if(!usart.rx_new_message.B0){
	BTFSC       _usart+33, 0 
	GOTO        L_int_usart_rx140
;lib_usart.h,172 :: 		usart.message[usart.rx_cont] = RCREG;
	MOVLW       _usart+0
	MOVWF       FSR1 
	MOVLW       hi_addr(_usart+0)
	MOVWF       FSR1H 
	MOVF        _usart+35, 0 
	ADDWF       FSR1, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR1H, 1 
	MOVF        RCREG+0, 0 
	MOVWF       POSTINC1+0 
;lib_usart.h,174 :: 		if(RCREG == usart.rx_delimiter){
	MOVF        RCREG+0, 0 
	XORWF       _usart+32, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L_int_usart_rx141
;lib_usart.h,176 :: 		usart.rx_new_message.B0 = true;
	BSF         _usart+33, 0 
;lib_usart.h,177 :: 		usart.message[usart.rx_cont] = 0;  //Se le agrega final de cadena
	MOVLW       _usart+0
	MOVWF       FSR1 
	MOVLW       hi_addr(_usart+0)
	MOVWF       FSR1H 
	MOVF        _usart+35, 0 
	ADDWF       FSR1, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR1H, 1 
	CLRF        POSTINC1+0 
;lib_usart.h,179 :: 		usart.rx_cont = 0;
	CLRF        _usart+35 
;lib_usart.h,180 :: 		PIR1.RCIF = 0;
	BCF         PIR1+0, 5 
;lib_usart.h,181 :: 		return;
	GOTO        L_end_int_usart_rx
;lib_usart.h,182 :: 		}
L_int_usart_rx141:
;lib_usart.h,183 :: 		usart.rx_cont++;
	MOVF        _usart+35, 0 
	ADDLW       1
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       _usart+35 
;lib_usart.h,184 :: 		usart.rx_cont &= (UART_BUFFER_SIZE-1);
	MOVLW       31
	ANDWF       _usart+35, 0 
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       _usart+35 
;lib_usart.h,186 :: 		usart.rx_overflow.B0 |= !usart.rx_cont? true:false;
	MOVF        R0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_int_usart_rx142
	MOVLW       1
	MOVWF       R1 
	GOTO        L_int_usart_rx143
L_int_usart_rx142:
	CLRF        R1 
L_int_usart_rx143:
	CLRF        R0 
	BTFSC       _usart+34, 0 
	INCF        R0, 1 
	MOVF        R1, 0 
	IORWF       R0, 1 
	BTFSC       R0, 0 
	GOTO        L__int_usart_rx1146
	BCF         _usart+34, 0 
	GOTO        L__int_usart_rx1147
L__int_usart_rx1146:
	BSF         _usart+34, 0 
L__int_usart_rx1147:
;lib_usart.h,187 :: 		}else{
	GOTO        L_int_usart_rx144
L_int_usart_rx140:
;lib_usart.h,188 :: 		RCREG &= 0xFF;  //Realizar and para evitar framing error, *#*
	MOVLW       255
	ANDWF       RCREG+0, 1 
;lib_usart.h,189 :: 		}
L_int_usart_rx144:
;lib_usart.h,190 :: 		PIR1.RCIF = 0;
	BCF         PIR1+0, 5 
;lib_usart.h,191 :: 		}
L_int_usart_rx139:
;lib_usart.h,192 :: 		}
L_end_int_usart_rx:
	RETURN      0
; end of _int_usart_rx

_int_usart_tx:

;lib_usart.h,194 :: 		void int_usart_tx(){
;lib_usart.h,195 :: 		if(PIE1.TXIE && PIR1.TXIF){
	BTFSS       PIE1+0, 4 
	GOTO        L_int_usart_tx147
	BTFSS       PIR1+0, 4 
	GOTO        L_int_usart_tx147
L__int_usart_tx965:
;lib_usart.h,196 :: 		TXREG = usart.tx_buffer[usart.tx_cont++];  //Envia los datos
	MOVLW       _usart+38
	MOVWF       FSR0 
	MOVLW       hi_addr(_usart+38)
	MOVWF       FSR0H 
	MOVF        _usart+37, 0 
	ADDWF       FSR0, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR0H, 1 
	MOVF        POSTINC0+0, 0 
	MOVWF       TXREG+0 
	MOVF        _usart+37, 0 
	ADDLW       1
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       _usart+37 
;lib_usart.h,198 :: 		if(!usart.tx_buffer[usart.tx_cont]){
	MOVLW       _usart+38
	MOVWF       FSR0 
	MOVLW       hi_addr(_usart+38)
	MOVWF       FSR0H 
	MOVF        _usart+37, 0 
	ADDWF       FSR0, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR0H, 1 
	MOVF        POSTINC0+0, 0 
	MOVWF       R0 
	MOVF        R0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_int_usart_tx148
;lib_usart.h,199 :: 		usart.tx_free = true;
	MOVLW       1
	MOVWF       _usart+36 
;lib_usart.h,200 :: 		PIE1.TXIE = 0; //Finaliza transmision
	BCF         PIE1+0, 4 
;lib_usart.h,201 :: 		}
L_int_usart_tx148:
;lib_usart.h,202 :: 		PIR1.TXIF = 0;   //Limpia bandera
	BCF         PIR1+0, 4 
;lib_usart.h,203 :: 		}
L_int_usart_tx147:
;lib_usart.h,204 :: 		}
L_end_int_usart_tx:
	RETURN      0
; end of _int_usart_tx

_can_write_text:

;lib_can.h,157 :: 		bool can_write_text(long ipAddress, char *texto, char priority){
;lib_can.h,159 :: 		if(!can.txQueu && !can.rxBusy){
	MOVF        _can+33, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_can_write_text151
	MOVF        _can+106, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_can_write_text151
L__can_write_text966:
;lib_can.h,160 :: 		can.txSize = 0;
	CLRF        _can+35 
;lib_can.h,161 :: 		can.txQueu = true;
	MOVLW       1
	MOVWF       _can+33 
;lib_can.h,162 :: 		can.txId = ipAddress;      //Conecta a la red + el id
	MOVF        FARG_can_write_text_ipAddress+0, 0 
	MOVWF       _can+37 
	MOVF        FARG_can_write_text_ipAddress+1, 0 
	MOVWF       _can+38 
	MOVF        FARG_can_write_text_ipAddress+2, 0 
	MOVWF       _can+39 
	MOVF        FARG_can_write_text_ipAddress+3, 0 
	MOVWF       _can+40 
;lib_can.h,163 :: 		can.txPriority = priority;
	MOVF        FARG_can_write_text_priority+0, 0 
	MOVWF       _can+36 
;lib_can.h,165 :: 		while(true){
L_can_write_text152:
;lib_can.h,166 :: 		can.txBuffer[can.txSize] = texto[can.txSize];
	MOVLW       _can+41
	MOVWF       FSR1 
	MOVLW       hi_addr(_can+41)
	MOVWF       FSR1H 
	MOVF        _can+35, 0 
	ADDWF       FSR1, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR1H, 1 
	MOVF        _can+35, 0 
	ADDWF       FARG_can_write_text_texto+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_can_write_text_texto+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       POSTINC1+0 
;lib_can.h,168 :: 		if(texto[can.txSize])
	MOVF        _can+35, 0 
	ADDWF       FARG_can_write_text_texto+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_can_write_text_texto+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_can_write_text154
;lib_can.h,169 :: 		can.txSize++;
	MOVF        _can+35, 0 
	ADDLW       1
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       _can+35 
	GOTO        L_can_write_text155
L_can_write_text154:
;lib_can.h,171 :: 		break;
	GOTO        L_can_write_text153
L_can_write_text155:
;lib_can.h,172 :: 		}
	GOTO        L_can_write_text152
L_can_write_text153:
;lib_can.h,173 :: 		can.temp = 0;
	CLRF        _can+173 
	CLRF        _can+174 
;lib_can.h,174 :: 		return true; //Datos encolados
	MOVLW       1
	MOVWF       R0 
	GOTO        L_end_can_write_text
;lib_can.h,175 :: 		}
L_can_write_text151:
;lib_can.h,177 :: 		return false;
	CLRF        R0 
;lib_can.h,178 :: 		}
L_end_can_write_text:
	RETURN      0
; end of _can_write_text

_can_do_write_message:

;lib_can.h,180 :: 		void can_do_write_message(){
;lib_can.h,188 :: 		if(!can.txQueu)
	MOVF        _can+33, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_can_do_write_message156
;lib_can.h,189 :: 		return; //CAN_RW_WITHOUT_QUEU;
	GOTO        L_end_can_do_write_message
L_can_do_write_message156:
;lib_can.h,192 :: 		if(can.temp >= CAN_MAX_TIME_ACK){
	MOVLW       11
	SUBWF       _can+174, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__can_do_write_message1151
	MOVLW       184
	SUBWF       _can+173, 0 
L__can_do_write_message1151:
	BTFSS       STATUS+0, 0 
	GOTO        L_can_do_write_message157
;lib_can.h,193 :: 		maquinaE = 0;
	CLRF        can_do_write_message_maquinaE_L0+0 
;lib_can.h,194 :: 		can.txQueu = false;
	CLRF        _can+33 
;lib_can.h,196 :: 		can.tx_status = CAN_RW_CORRUPT;
	MOVLW       3
	MOVWF       _can+34 
;lib_can.h,197 :: 		can_user_write_message();
	CALL        _can_user_write_message+0, 0
;lib_can.h,198 :: 		}
L_can_do_write_message157:
;lib_can.h,201 :: 		if(maquinaE == 0){  //Mando datos al buffer
	MOVF        can_do_write_message_maquinaE_L0+0, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_can_do_write_message158
;lib_can.h,202 :: 		maquinaE = 2;
	MOVLW       2
	MOVWF       can_do_write_message_maquinaE_L0+0 
;lib_can.h,203 :: 		datosEnviados = 0;
	CLRF        can_do_write_message_datosEnviados_L0+0 
;lib_can.h,204 :: 		finalizar = false;
	CLRF        can_do_write_message_finalizar_L0+0 
;lib_can.h,205 :: 		can.bufferTX[0] = can.id;             //Id del que envia
	MOVF        _can+12, 0 
	MOVWF       _can+17 
;lib_can.h,206 :: 		can.bufferTX[1] = CAN_PROTOCOL_INIT;  //Inicia comunicacion con el otro dispo
	CLRF        _can+18 
;lib_can.h,207 :: 		can_write(can.txId, can.bufferTX, 2, can.txPriority, false);
	MOVF        _can+37, 0 
	MOVWF       FARG_can_write_id+0 
	MOVF        _can+38, 0 
	MOVWF       FARG_can_write_id+1 
	MOVF        _can+39, 0 
	MOVWF       FARG_can_write_id+2 
	MOVF        _can+40, 0 
	MOVWF       FARG_can_write_id+3 
	MOVLW       _can+17
	MOVWF       FARG_can_write_datos+0 
	MOVLW       hi_addr(_can+17)
	MOVWF       FARG_can_write_datos+1 
	MOVLW       2
	MOVWF       FARG_can_write_size+0 
	MOVF        _can+36, 0 
	MOVWF       FARG_can_write_priority+0 
	CLRF        FARG_can_write_rtr+0 
	CALL        _can_write+0, 0
;lib_can.h,208 :: 		can.temp = 0;
	CLRF        _can+173 
	CLRF        _can+174 
;lib_can.h,209 :: 		}else if(maquinaE == 1){
	GOTO        L_can_do_write_message159
L_can_do_write_message158:
	MOVF        can_do_write_message_maquinaE_L0+0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_can_do_write_message160
;lib_can.h,210 :: 		finalizar = !can.txBuffer[datosEnviados];
	MOVLW       _can+41
	MOVWF       R0 
	MOVLW       hi_addr(_can+41)
	MOVWF       R1 
	MOVF        can_do_write_message_datosEnviados_L0+0, 0 
	ADDWF       R0, 1 
	BTFSC       STATUS+0, 0 
	INCF        R1, 1 
	MOVFF       R0, FSR0
	MOVFF       R1, FSR0H
	MOVF        POSTINC0+0, 1 
	MOVLW       1
	BTFSS       STATUS+0, 2 
	MOVLW       0
	MOVWF       can_do_write_message_finalizar_L0+0 
;lib_can.h,212 :: 		can.bufferTX[0] = can.id;
	MOVF        _can+12, 0 
	MOVWF       _can+17 
;lib_can.h,214 :: 		can.bufferTX[1] = can.txBuffer[datosEnviados]?CAN_PROTOCOL_QUEU:CAN_PROTOCOL_END;
	MOVFF       R0, FSR0
	MOVFF       R1, FSR0H
	MOVF        POSTINC0+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_can_do_write_message161
	MOVLW       1
	MOVWF       ?FLOC___can_do_write_messageT679+0 
	GOTO        L_can_do_write_message162
L_can_do_write_message161:
	MOVLW       2
	MOVWF       ?FLOC___can_do_write_messageT679+0 
L_can_do_write_message162:
	MOVF        ?FLOC___can_do_write_messageT679+0, 0 
	MOVWF       _can+18 
;lib_can.h,215 :: 		for(cont = 2; cont < 8 && can.txBuffer[datosEnviados]; cont++)
	MOVLW       2
	MOVWF       can_do_write_message_cont_L0+0 
L_can_do_write_message163:
	MOVLW       8
	SUBWF       can_do_write_message_cont_L0+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_can_do_write_message164
	MOVLW       _can+41
	MOVWF       FSR0 
	MOVLW       hi_addr(_can+41)
	MOVWF       FSR0H 
	MOVF        can_do_write_message_datosEnviados_L0+0, 0 
	ADDWF       FSR0, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR0H, 1 
	MOVF        POSTINC0+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_can_do_write_message164
L__can_do_write_message967:
;lib_can.h,216 :: 		can.bufferTX[cont] = can.txBuffer[datosEnviados++];
	MOVLW       _can+17
	MOVWF       FSR1 
	MOVLW       hi_addr(_can+17)
	MOVWF       FSR1H 
	MOVF        can_do_write_message_cont_L0+0, 0 
	ADDWF       FSR1, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR1H, 1 
	MOVLW       _can+41
	MOVWF       FSR0 
	MOVLW       hi_addr(_can+41)
	MOVWF       FSR0H 
	MOVF        can_do_write_message_datosEnviados_L0+0, 0 
	ADDWF       FSR0, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR0H, 1 
	MOVF        POSTINC0+0, 0 
	MOVWF       POSTINC1+0 
	INCF        can_do_write_message_datosEnviados_L0+0, 1 
;lib_can.h,215 :: 		for(cont = 2; cont < 8 && can.txBuffer[datosEnviados]; cont++)
	INCF        can_do_write_message_cont_L0+0, 1 
;lib_can.h,216 :: 		can.bufferTX[cont] = can.txBuffer[datosEnviados++];
	GOTO        L_can_do_write_message163
L_can_do_write_message164:
;lib_can.h,219 :: 		can_write(can.txId, can.bufferTX, cont, can.txPriority, false);
	MOVF        _can+37, 0 
	MOVWF       FARG_can_write_id+0 
	MOVF        _can+38, 0 
	MOVWF       FARG_can_write_id+1 
	MOVF        _can+39, 0 
	MOVWF       FARG_can_write_id+2 
	MOVF        _can+40, 0 
	MOVWF       FARG_can_write_id+3 
	MOVLW       _can+17
	MOVWF       FARG_can_write_datos+0 
	MOVLW       hi_addr(_can+17)
	MOVWF       FARG_can_write_datos+1 
	MOVF        can_do_write_message_cont_L0+0, 0 
	MOVWF       FARG_can_write_size+0 
	MOVF        _can+36, 0 
	MOVWF       FARG_can_write_priority+0 
	CLRF        FARG_can_write_rtr+0 
	CALL        _can_write+0, 0
;lib_can.h,220 :: 		maquinaE++;  //Avanza al siguiente estado
	INCF        can_do_write_message_maquinaE_L0+0, 1 
;lib_can.h,221 :: 		can.temp = 0;
	CLRF        _can+173 
	CLRF        _can+174 
;lib_can.h,222 :: 		}else if(maquinaE == 2){  //Escucha si recibio los datos
	GOTO        L_can_do_write_message168
L_can_do_write_message160:
	MOVF        can_do_write_message_maquinaE_L0+0, 0 
	XORLW       2
	BTFSS       STATUS+0, 2 
	GOTO        L_can_do_write_message169
;lib_can.h,223 :: 		if(can_read(&id, can.bufferRX, &can.rxSize) == CAN_RW_DATA){
	MOVLW       can_do_write_message_id_L0+0
	MOVWF       FARG_can_read_id+0 
	MOVLW       hi_addr(can_do_write_message_id_L0+0)
	MOVWF       FARG_can_read_id+1 
	MOVLW       _can+25
	MOVWF       FARG_can_read_datos+0 
	MOVLW       hi_addr(_can+25)
	MOVWF       FARG_can_read_datos+1 
	MOVLW       _can+171
	MOVWF       FARG_can_read_size+0 
	MOVLW       hi_addr(_can+171)
	MOVWF       FARG_can_read_size+1 
	CALL        _can_read+0, 0
	MOVF        R0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_can_do_write_message170
;lib_can.h,224 :: 		if(id == can.ipAddress){
	MOVF        can_do_write_message_id_L0+3, 0 
	XORWF       _can+7, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__can_do_write_message1152
	MOVF        can_do_write_message_id_L0+2, 0 
	XORWF       _can+6, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__can_do_write_message1152
	MOVF        can_do_write_message_id_L0+1, 0 
	XORWF       _can+5, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__can_do_write_message1152
	MOVF        can_do_write_message_id_L0+0, 0 
	XORWF       _can+4, 0 
L__can_do_write_message1152:
	BTFSS       STATUS+0, 2 
	GOTO        L_can_do_write_message171
;lib_can.h,226 :: 		if(can.bufferRX[0] == getByte(can.txId, 0)){
	MOVF        _can+25, 0 
	XORWF       _can+37, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L_can_do_write_message172
;lib_can.h,227 :: 		if(can.bufferRX[1] == CAN_PROTOCOL_FREE){
	MOVF        _can+26, 0 
	XORLW       4
	BTFSS       STATUS+0, 2 
	GOTO        L_can_do_write_message173
;lib_can.h,229 :: 		maquinaE += !finalizar? -1:1;
	MOVF        can_do_write_message_finalizar_L0+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_can_do_write_message174
	MOVLW       255
	MOVWF       ?FLOC___can_do_write_messageT710+0 
	GOTO        L_can_do_write_message175
L_can_do_write_message174:
	MOVLW       1
	MOVWF       ?FLOC___can_do_write_messageT710+0 
L_can_do_write_message175:
	MOVF        ?FLOC___can_do_write_messageT710+0, 0 
	ADDWF       can_do_write_message_maquinaE_L0+0, 1 
;lib_can.h,230 :: 		can.temp = 0;
	CLRF        _can+173 
	CLRF        _can+174 
;lib_can.h,231 :: 		}else if(can.bufferRX[1] == CAN_PROTOCOL_INIT){
	GOTO        L_can_do_write_message176
L_can_do_write_message173:
	MOVF        _can+26, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_can_do_write_message177
;lib_can.h,233 :: 		can.bufferTX[0] = can.id;             //Id del que envia
	MOVF        _can+12, 0 
	MOVWF       _can+17 
;lib_can.h,234 :: 		can.bufferTX[1] = CAN_PROTOCOL_BUSY;  //Inicia comunicacion con el otro dispo
	MOVLW       3
	MOVWF       _can+18 
;lib_can.h,235 :: 		can_write(can.txId, can.bufferTX, 2, 3, false);
	MOVF        _can+37, 0 
	MOVWF       FARG_can_write_id+0 
	MOVF        _can+38, 0 
	MOVWF       FARG_can_write_id+1 
	MOVF        _can+39, 0 
	MOVWF       FARG_can_write_id+2 
	MOVF        _can+40, 0 
	MOVWF       FARG_can_write_id+3 
	MOVLW       _can+17
	MOVWF       FARG_can_write_datos+0 
	MOVLW       hi_addr(_can+17)
	MOVWF       FARG_can_write_datos+1 
	MOVLW       2
	MOVWF       FARG_can_write_size+0 
	MOVLW       3
	MOVWF       FARG_can_write_priority+0 
	CLRF        FARG_can_write_rtr+0 
	CALL        _can_write+0, 0
;lib_can.h,237 :: 		maquinaE = 0;
	CLRF        can_do_write_message_maquinaE_L0+0 
;lib_can.h,238 :: 		}else if(can.bufferRX[1] == CAN_PROTOCOL_BUSY){
	GOTO        L_can_do_write_message178
L_can_do_write_message177:
	MOVF        _can+26, 0 
	XORLW       3
	BTFSS       STATUS+0, 2 
	GOTO        L_can_do_write_message179
;lib_can.h,239 :: 		maquinaE = 0;
	CLRF        can_do_write_message_maquinaE_L0+0 
;lib_can.h,240 :: 		can.txQueu = false;
	CLRF        _can+33 
;lib_can.h,242 :: 		can.tx_status = CAN_RW_CORRUPT;
	MOVLW       3
	MOVWF       _can+34 
;lib_can.h,243 :: 		can_user_write_message();
	CALL        _can_user_write_message+0, 0
;lib_can.h,244 :: 		}
L_can_do_write_message179:
L_can_do_write_message178:
L_can_do_write_message176:
;lib_can.h,245 :: 		}else{
	GOTO        L_can_do_write_message180
L_can_do_write_message172:
;lib_can.h,246 :: 		if(can.bufferRX[1] == CAN_PROTOCOL_HEARTBEAT){
	MOVF        _can+26, 0 
	XORLW       255
	BTFSS       STATUS+0, 2 
	GOTO        L_can_do_write_message181
;lib_can.h,247 :: 		can_user_guardHeartBeat(can.bufferRX[0]);
	MOVF        _can+25, 0 
	MOVWF       FARG_can_user_guardHeartBeat_idNodo+0 
	CALL        _can_user_guardHeartBeat+0, 0
;lib_can.h,248 :: 		return;
	GOTO        L_end_can_do_write_message
;lib_can.h,249 :: 		}
L_can_do_write_message181:
;lib_can.h,250 :: 		}
L_can_do_write_message180:
;lib_can.h,251 :: 		}
L_can_do_write_message171:
;lib_can.h,252 :: 		}
L_can_do_write_message170:
;lib_can.h,253 :: 		}else if(maquinaE == 3){
	GOTO        L_can_do_write_message182
L_can_do_write_message169:
	MOVF        can_do_write_message_maquinaE_L0+0, 0 
	XORLW       3
	BTFSS       STATUS+0, 2 
	GOTO        L_can_do_write_message183
;lib_can.h,254 :: 		maquinaE = 0;
	CLRF        can_do_write_message_maquinaE_L0+0 
;lib_can.h,255 :: 		can.txQueu = false;
	CLRF        _can+33 
;lib_can.h,256 :: 		finalizar  = false;
	CLRF        can_do_write_message_finalizar_L0+0 
;lib_can.h,257 :: 		can.tx_status = CAN_RW_ENVIADO;
	CLRF        _can+34 
;lib_can.h,258 :: 		can_user_write_message();  //DATOS ENVIADOS CON EXITO
	CALL        _can_user_write_message+0, 0
;lib_can.h,259 :: 		}
L_can_do_write_message183:
L_can_do_write_message182:
L_can_do_write_message168:
L_can_do_write_message159:
;lib_can.h,261 :: 		can.tx_status = 0;
	CLRF        _can+34 
;lib_can.h,263 :: 		}
L_end_can_do_write_message:
	RETURN      0
; end of _can_do_write_message

_can_do_read_message:

;lib_can.h,265 :: 		void can_do_read_message(){
;lib_can.h,271 :: 		if(can.txQueu)
	MOVF        _can+33, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_can_do_read_message184
;lib_can.h,272 :: 		return;
	GOTO        L_end_can_do_read_message
L_can_do_read_message184:
;lib_can.h,275 :: 		if(can.rxBusy){
	MOVF        _can+106, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_can_do_read_message185
;lib_can.h,276 :: 		if(can.temp >= CAN_MAX_TIME_ACK){
	MOVLW       11
	SUBWF       _can+174, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__can_do_read_message1154
	MOVLW       184
	SUBWF       _can+173, 0 
L__can_do_read_message1154:
	BTFSS       STATUS+0, 0 
	GOTO        L_can_do_read_message186
;lib_can.h,277 :: 		can.rxBusy = false;
	CLRF        _can+106 
;lib_can.h,278 :: 		return;
	GOTO        L_end_can_do_read_message
;lib_can.h,279 :: 		}
L_can_do_read_message186:
;lib_can.h,280 :: 		}
L_can_do_read_message185:
;lib_can.h,283 :: 		if(can_read(&id, can.bufferRX, &can.rxSize) == CAN_RW_DATA){
	MOVLW       can_do_read_message_id_L0+0
	MOVWF       FARG_can_read_id+0 
	MOVLW       hi_addr(can_do_read_message_id_L0+0)
	MOVWF       FARG_can_read_id+1 
	MOVLW       _can+25
	MOVWF       FARG_can_read_datos+0 
	MOVLW       hi_addr(_can+25)
	MOVWF       FARG_can_read_datos+1 
	MOVLW       _can+171
	MOVWF       FARG_can_read_size+0 
	MOVLW       hi_addr(_can+171)
	MOVWF       FARG_can_read_size+1 
	CALL        _can_read+0, 0
	MOVF        R0, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_can_do_read_message187
;lib_can.h,284 :: 		if(id == can.ipAddress){  //LA IP CONTIENE EL NUMERO DE RED+ID
	MOVF        can_do_read_message_id_L0+3, 0 
	XORWF       _can+7, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__can_do_read_message1155
	MOVF        can_do_read_message_id_L0+2, 0 
	XORWF       _can+6, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__can_do_read_message1155
	MOVF        can_do_read_message_id_L0+1, 0 
	XORWF       _can+5, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__can_do_read_message1155
	MOVF        can_do_read_message_id_L0+0, 0 
	XORWF       _can+4, 0 
L__can_do_read_message1155:
	BTFSS       STATUS+0, 2 
	GOTO        L_can_do_read_message188
;lib_can.h,286 :: 		if(can.bufferRX[1] == CAN_PROTOCOL_HEARTBEAT){
	MOVF        _can+26, 0 
	XORLW       255
	BTFSS       STATUS+0, 2 
	GOTO        L_can_do_read_message189
;lib_can.h,287 :: 		can_user_guardHeartBeat(can.bufferRX[0]);
	MOVF        _can+25, 0 
	MOVWF       FARG_can_user_guardHeartBeat_idNodo+0 
	CALL        _can_user_guardHeartBeat+0, 0
;lib_can.h,288 :: 		return;
	GOTO        L_end_can_do_read_message
;lib_can.h,289 :: 		}
L_can_do_read_message189:
;lib_can.h,291 :: 		if(can.rxBusy){
	MOVF        _can+106, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_can_do_read_message190
;lib_can.h,293 :: 		if(can.rxId != can.bufferRX[0]){
	MOVF        _can+172, 0 
	XORWF       _can+25, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L_can_do_read_message191
;lib_can.h,294 :: 		can.bufferTX[0] = can.id;
	MOVF        _can+12, 0 
	MOVWF       _can+17 
;lib_can.h,295 :: 		can.bufferTX[1] = CAN_PROTOCOL_BUSY;
	MOVLW       3
	MOVWF       _can+18 
;lib_can.h,296 :: 		can_write(can.ip+can.bufferRX[0], can.bufferTX, 2, 3, false);
	MOVF        _can+25, 0 
	ADDWF       _can+0, 0 
	MOVWF       FARG_can_write_id+0 
	MOVLW       0
	ADDWFC      _can+1, 0 
	MOVWF       FARG_can_write_id+1 
	MOVLW       0
	ADDWFC      _can+2, 0 
	MOVWF       FARG_can_write_id+2 
	MOVLW       0
	ADDWFC      _can+3, 0 
	MOVWF       FARG_can_write_id+3 
	MOVLW       _can+17
	MOVWF       FARG_can_write_datos+0 
	MOVLW       hi_addr(_can+17)
	MOVWF       FARG_can_write_datos+1 
	MOVLW       2
	MOVWF       FARG_can_write_size+0 
	MOVLW       3
	MOVWF       FARG_can_write_priority+0 
	CLRF        FARG_can_write_rtr+0 
	CALL        _can_write+0, 0
;lib_can.h,297 :: 		return;
	GOTO        L_end_can_do_read_message
;lib_can.h,298 :: 		}
L_can_do_read_message191:
;lib_can.h,299 :: 		}
L_can_do_read_message190:
;lib_can.h,301 :: 		if(can.bufferRX[1] == CAN_PROTOCOL_INIT){  //INICIA LA PRIMERA COMUNICACION
	MOVF        _can+26, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_can_do_read_message192
;lib_can.h,302 :: 		can.rxId = can.bufferRX[0];  //ID del transmisor
	MOVF        _can+25, 0 
	MOVWF       _can+172 
;lib_can.h,303 :: 		can.rxBusy = true;
	MOVLW       1
	MOVWF       _can+106 
;lib_can.h,304 :: 		len = 0;
	CLRF        can_do_read_message_len_L0+0 
;lib_can.h,305 :: 		can.temp = 0;
	CLRF        _can+173 
	CLRF        _can+174 
;lib_can.h,306 :: 		}else if(!can.rxBusy){
	GOTO        L_can_do_read_message193
L_can_do_read_message192:
	MOVF        _can+106, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_can_do_read_message194
;lib_can.h,308 :: 		return;
	GOTO        L_end_can_do_read_message
;lib_can.h,309 :: 		}else if(can.bufferRX[1] == CAN_PROTOCOL_QUEU){ //ENCOLA LOS DATOS
L_can_do_read_message194:
	MOVF        _can+26, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_can_do_read_message196
;lib_can.h,311 :: 		for(cont = 2; cont < can.rxSize && len < CAN_LEN_BUFFER_RXTX-1; cont++)
	MOVLW       2
	MOVWF       can_do_read_message_cont_L0+0 
L_can_do_read_message197:
	MOVF        _can+171, 0 
	SUBWF       can_do_read_message_cont_L0+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_can_do_read_message198
	MOVLW       128
	MOVWF       R0 
	MOVLW       128
	XORLW       0
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__can_do_read_message1156
	MOVLW       63
	SUBWF       can_do_read_message_len_L0+0, 0 
L__can_do_read_message1156:
	BTFSC       STATUS+0, 0 
	GOTO        L_can_do_read_message198
L__can_do_read_message968:
;lib_can.h,312 :: 		can.rxBuffer[len++] = can.bufferRX[cont];
	MOVLW       _can+107
	MOVWF       FSR1 
	MOVLW       hi_addr(_can+107)
	MOVWF       FSR1H 
	MOVF        can_do_read_message_len_L0+0, 0 
	ADDWF       FSR1, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR1H, 1 
	MOVLW       _can+25
	MOVWF       FSR0 
	MOVLW       hi_addr(_can+25)
	MOVWF       FSR0H 
	MOVF        can_do_read_message_cont_L0+0, 0 
	ADDWF       FSR0, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR0H, 1 
	MOVF        POSTINC0+0, 0 
	MOVWF       POSTINC1+0 
	INCF        can_do_read_message_len_L0+0, 1 
;lib_can.h,311 :: 		for(cont = 2; cont < can.rxSize && len < CAN_LEN_BUFFER_RXTX-1; cont++)
	INCF        can_do_read_message_cont_L0+0, 1 
;lib_can.h,312 :: 		can.rxBuffer[len++] = can.bufferRX[cont];
	GOTO        L_can_do_read_message197
L_can_do_read_message198:
;lib_can.h,313 :: 		can.rxBuffer[len] = 0;
	MOVLW       _can+107
	MOVWF       FSR1 
	MOVLW       hi_addr(_can+107)
	MOVWF       FSR1H 
	MOVF        can_do_read_message_len_L0+0, 0 
	ADDWF       FSR1, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR1H, 1 
	CLRF        POSTINC1+0 
;lib_can.h,314 :: 		can.temp = 0;
	CLRF        _can+173 
	CLRF        _can+174 
;lib_can.h,315 :: 		}else if(can.bufferRX[1] == CAN_PROTOCOL_END){  //FINALIZA COMUNICACION
	GOTO        L_can_do_read_message202
L_can_do_read_message196:
	MOVF        _can+26, 0 
	XORLW       2
	BTFSS       STATUS+0, 2 
	GOTO        L_can_do_read_message203
;lib_can.h,316 :: 		can.rxBuffer[len] = 0;  //Agregar final de cadena
	MOVLW       _can+107
	MOVWF       FSR1 
	MOVLW       hi_addr(_can+107)
	MOVWF       FSR1H 
	MOVF        can_do_read_message_len_L0+0, 0 
	ADDWF       FSR1, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR1H, 1 
	CLRF        POSTINC1+0 
;lib_can.h,317 :: 		len = 0;
	CLRF        can_do_read_message_len_L0+0 
;lib_can.h,318 :: 		}
L_can_do_read_message203:
L_can_do_read_message202:
L_can_do_read_message193:
;lib_can.h,321 :: 		can.bufferTX[0] = can.id;
	MOVF        _can+12, 0 
	MOVWF       _can+17 
;lib_can.h,322 :: 		can.bufferTX[1] = CAN_PROTOCOL_FREE;  //Modulo libre
	MOVLW       4
	MOVWF       _can+18 
;lib_can.h,323 :: 		can_write(can.ip+can.bufferRX[0], can.bufferTX, 2, 3, false);
	MOVF        _can+25, 0 
	ADDWF       _can+0, 0 
	MOVWF       FARG_can_write_id+0 
	MOVLW       0
	ADDWFC      _can+1, 0 
	MOVWF       FARG_can_write_id+1 
	MOVLW       0
	ADDWFC      _can+2, 0 
	MOVWF       FARG_can_write_id+2 
	MOVLW       0
	ADDWFC      _can+3, 0 
	MOVWF       FARG_can_write_id+3 
	MOVLW       _can+17
	MOVWF       FARG_can_write_datos+0 
	MOVLW       hi_addr(_can+17)
	MOVWF       FARG_can_write_datos+1 
	MOVLW       2
	MOVWF       FARG_can_write_size+0 
	MOVLW       3
	MOVWF       FARG_can_write_priority+0 
	CLRF        FARG_can_write_rtr+0 
	CALL        _can_write+0, 0
;lib_can.h,326 :: 		if(can.bufferRX[1] == CAN_PROTOCOL_END){
	MOVF        _can+26, 0 
	XORLW       2
	BTFSS       STATUS+0, 2 
	GOTO        L_can_do_read_message204
;lib_can.h,327 :: 		can_user_read_message();
	CALL        _can_user_read_message+0, 0
;lib_can.h,328 :: 		can.rxBusy = false;
	CLRF        _can+106 
;lib_can.h,329 :: 		}
L_can_do_read_message204:
;lib_can.h,330 :: 		}
L_can_do_read_message188:
;lib_can.h,331 :: 		}
L_can_do_read_message187:
;lib_can.h,332 :: 		}
L_end_can_do_read_message:
	RETURN      0
; end of _can_do_read_message

_can_open:

;lib_can.h,334 :: 		void can_open(long ip, long mask, char id, char speed_us){
;lib_can.h,336 :: 		can.ip = ip;
	MOVF        FARG_can_open_ip+0, 0 
	MOVWF       _can+0 
	MOVF        FARG_can_open_ip+1, 0 
	MOVWF       _can+1 
	MOVF        FARG_can_open_ip+2, 0 
	MOVWF       _can+2 
	MOVF        FARG_can_open_ip+3, 0 
	MOVWF       _can+3 
;lib_can.h,337 :: 		can.mask = mask;
	MOVF        FARG_can_open_mask+0, 0 
	MOVWF       _can+8 
	MOVF        FARG_can_open_mask+1, 0 
	MOVWF       _can+9 
	MOVF        FARG_can_open_mask+2, 0 
	MOVWF       _can+10 
	MOVF        FARG_can_open_mask+3, 0 
	MOVWF       _can+11 
;lib_can.h,338 :: 		can.ipAddress = ip + id;
	MOVF        FARG_can_open_id+0, 0 
	ADDWF       FARG_can_open_ip+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      FARG_can_open_ip+1, 0 
	MOVWF       R1 
	MOVLW       0
	ADDWFC      FARG_can_open_ip+2, 0 
	MOVWF       R2 
	MOVLW       0
	ADDWFC      FARG_can_open_ip+3, 0 
	MOVWF       R3 
	MOVF        R0, 0 
	MOVWF       _can+4 
	MOVF        R1, 0 
	MOVWF       _can+5 
	MOVF        R2, 0 
	MOVWF       _can+6 
	MOVF        R3, 0 
	MOVWF       _can+7 
;lib_can.h,339 :: 		can.id = id;
	MOVF        FARG_can_open_id+0, 0 
	MOVWF       _can+12 
;lib_can.h,342 :: 		can.conected = true;
	MOVLW       1
	MOVWF       _can+13 
;lib_can.h,343 :: 		can.tx_status = 0;      //Estado cero por defecto
	CLRF        _can+34 
;lib_can.h,344 :: 		can.txQueu = false;     //No ha encolado datos para transmitir
	CLRF        _can+33 
;lib_can.h,345 :: 		can.rxBusy = false;     //No esta escuhando ningun mensaje
	CLRF        _can+106 
;lib_can.h,347 :: 		can_set_operation(CAN_OPERATION_CONFIG);
	MOVLW       4
	MOVWF       FARG_can_set_operation_CAN_OPERATION+0 
	CALL        _can_set_operation+0, 0
;lib_can.h,348 :: 		can_set_mode(CAN_MODE_LEGACY);
	CLRF        FARG_can_set_mode_CAN_MODE+0 
	CALL        _can_set_mode+0, 0
;lib_can.h,349 :: 		can_set_baud(speed_us);
	MOVF        FARG_can_open_speed_us+0, 0 
	MOVWF       FARG_can_set_baud_speed_us+0 
	MOVLW       0
	MOVWF       FARG_can_set_baud_speed_us+1 
	CALL        _can_set_baud+0, 0
;lib_can.h,351 :: 		RXB0CON = 0;
	CLRF        RXB0CON+0 
;lib_can.h,352 :: 		RXB0CON.RXM0 = 0;  //RECIBE TODOS LOS MENSAJES VALIDOS, STANDAR Ó EXTENDED
	BCF         RXB0CON+0, 5 
;lib_can.h,353 :: 		RXB0CON.RXM1 = 0;  //SEGUN EL BIT EXIDEN EN EL REGISTRO RXFnSIDL
	BCF         RXB0CON+0, 6 
;lib_can.h,354 :: 		RXB0CON.RXB0DBEN = CAN_USE_DOUBLE_BUFFER;
	BCF         RXB0CON+0, 2 
;lib_can.h,355 :: 		RXB1CON = 0;
	CLRF        RXB1CON+0 
;lib_can.h,357 :: 		CIOCON.ENDRHI = CAN_ENABLE_DRIVE_HIGH;
	BCF         CIOCON+0, 5 
;lib_can.h,358 :: 		CIOCON.CANCAP = CAN_ENABLE_CAPTURE;
	BCF         CIOCON+0, 4 
;lib_can.h,361 :: 		can_set_id(&RXM0EIDL, mask);    //MASKARA 0, ACEPTA X ID
	MOVLW       RXM0EIDL+0
	MOVWF       FARG_can_set_id_address+0 
	MOVLW       hi_addr(RXM0EIDL+0)
	MOVWF       FARG_can_set_id_address+1 
	MOVF        FARG_can_open_mask+0, 0 
	MOVWF       FARG_can_set_id_value+0 
	MOVF        FARG_can_open_mask+1, 0 
	MOVWF       FARG_can_set_id_value+1 
	MOVF        FARG_can_open_mask+2, 0 
	MOVWF       FARG_can_set_id_value+2 
	MOVF        FARG_can_open_mask+3, 0 
	MOVWF       FARG_can_set_id_value+3 
	CALL        _can_set_id+0, 0
;lib_can.h,362 :: 		can_set_id(&RXM1EIDL, mask);    //MASKARA 1, ACEPTA X ID
	MOVLW       RXM1EIDL+0
	MOVWF       FARG_can_set_id_address+0 
	MOVLW       hi_addr(RXM1EIDL+0)
	MOVWF       FARG_can_set_id_address+1 
	MOVF        FARG_can_open_mask+0, 0 
	MOVWF       FARG_can_set_id_value+0 
	MOVF        FARG_can_open_mask+1, 0 
	MOVWF       FARG_can_set_id_value+1 
	MOVF        FARG_can_open_mask+2, 0 
	MOVWF       FARG_can_set_id_value+2 
	MOVF        FARG_can_open_mask+3, 0 
	MOVWF       FARG_can_set_id_value+3 
	CALL        _can_set_id+0, 0
;lib_can.h,364 :: 		can_set_id(&RXF0EIDL, can.ipAddress);  //FILTRO 0 ASOCIADO CON LA MASKARA 0
	MOVLW       RXF0EIDL+0
	MOVWF       FARG_can_set_id_address+0 
	MOVLW       hi_addr(RXF0EIDL+0)
	MOVWF       FARG_can_set_id_address+1 
	MOVF        _can+4, 0 
	MOVWF       FARG_can_set_id_value+0 
	MOVF        _can+5, 0 
	MOVWF       FARG_can_set_id_value+1 
	MOVF        _can+6, 0 
	MOVWF       FARG_can_set_id_value+2 
	MOVF        _can+7, 0 
	MOVWF       FARG_can_set_id_value+3 
	CALL        _can_set_id+0, 0
;lib_can.h,365 :: 		can_set_id(&RXF1EIDL, can.ipAddress);  //FILTRO 1 ASOCIADO CON LA MASKARA 0
	MOVLW       RXF1EIDL+0
	MOVWF       FARG_can_set_id_address+0 
	MOVLW       hi_addr(RXF1EIDL+0)
	MOVWF       FARG_can_set_id_address+1 
	MOVF        _can+4, 0 
	MOVWF       FARG_can_set_id_value+0 
	MOVF        _can+5, 0 
	MOVWF       FARG_can_set_id_value+1 
	MOVF        _can+6, 0 
	MOVWF       FARG_can_set_id_value+2 
	MOVF        _can+7, 0 
	MOVWF       FARG_can_set_id_value+3 
	CALL        _can_set_id+0, 0
;lib_can.h,366 :: 		can_set_id(&RXF2EIDL, can.ipAddress);  //FILTRO 2 ASOCIADO CON LA MASKARA 1
	MOVLW       RXF2EIDL+0
	MOVWF       FARG_can_set_id_address+0 
	MOVLW       hi_addr(RXF2EIDL+0)
	MOVWF       FARG_can_set_id_address+1 
	MOVF        _can+4, 0 
	MOVWF       FARG_can_set_id_value+0 
	MOVF        _can+5, 0 
	MOVWF       FARG_can_set_id_value+1 
	MOVF        _can+6, 0 
	MOVWF       FARG_can_set_id_value+2 
	MOVF        _can+7, 0 
	MOVWF       FARG_can_set_id_value+3 
	CALL        _can_set_id+0, 0
;lib_can.h,367 :: 		can_set_id(&RXF3EIDL, can.ipAddress);  //FILTRO 3 ASOCIADO CON LA MASKARA 1
	MOVLW       RXF3EIDL+0
	MOVWF       FARG_can_set_id_address+0 
	MOVLW       hi_addr(RXF3EIDL+0)
	MOVWF       FARG_can_set_id_address+1 
	MOVF        _can+4, 0 
	MOVWF       FARG_can_set_id_value+0 
	MOVF        _can+5, 0 
	MOVWF       FARG_can_set_id_value+1 
	MOVF        _can+6, 0 
	MOVWF       FARG_can_set_id_value+2 
	MOVF        _can+7, 0 
	MOVWF       FARG_can_set_id_value+3 
	CALL        _can_set_id+0, 0
;lib_can.h,368 :: 		can_set_id(&RXF4EIDL, can.ipAddress);  //FILTRO 4 ASOCIADO CON LA MASKARA 1
	MOVLW       RXF4EIDL+0
	MOVWF       FARG_can_set_id_address+0 
	MOVLW       hi_addr(RXF4EIDL+0)
	MOVWF       FARG_can_set_id_address+1 
	MOVF        _can+4, 0 
	MOVWF       FARG_can_set_id_value+0 
	MOVF        _can+5, 0 
	MOVWF       FARG_can_set_id_value+1 
	MOVF        _can+6, 0 
	MOVWF       FARG_can_set_id_value+2 
	MOVF        _can+7, 0 
	MOVWF       FARG_can_set_id_value+3 
	CALL        _can_set_id+0, 0
;lib_can.h,369 :: 		can_set_id(&RXF5EIDL, can.ipAddress);  //FILTRO 5 ASOCIADO CON LA MASKARA 1
	MOVLW       RXF5EIDL+0
	MOVWF       FARG_can_set_id_address+0 
	MOVLW       hi_addr(RXF5EIDL+0)
	MOVWF       FARG_can_set_id_address+1 
	MOVF        _can+4, 0 
	MOVWF       FARG_can_set_id_value+0 
	MOVF        _can+5, 0 
	MOVWF       FARG_can_set_id_value+1 
	MOVF        _can+6, 0 
	MOVWF       FARG_can_set_id_value+2 
	MOVF        _can+7, 0 
	MOVWF       FARG_can_set_id_value+3 
	CALL        _can_set_id+0, 0
;lib_can.h,371 :: 		can_set_id(&RXF6EIDL, 0);       //FILTRO 6
	MOVLW       RXF6EIDL+0
	MOVWF       FARG_can_set_id_address+0 
	MOVLW       hi_addr(RXF6EIDL+0)
	MOVWF       FARG_can_set_id_address+1 
	CLRF        FARG_can_set_id_value+0 
	CLRF        FARG_can_set_id_value+1 
	CLRF        FARG_can_set_id_value+2 
	CLRF        FARG_can_set_id_value+3 
	CALL        _can_set_id+0, 0
;lib_can.h,372 :: 		can_set_id(&RXF7EIDL, 0);       //FILTRO 7
	MOVLW       RXF7EIDL+0
	MOVWF       FARG_can_set_id_address+0 
	MOVLW       hi_addr(RXF7EIDL+0)
	MOVWF       FARG_can_set_id_address+1 
	CLRF        FARG_can_set_id_value+0 
	CLRF        FARG_can_set_id_value+1 
	CLRF        FARG_can_set_id_value+2 
	CLRF        FARG_can_set_id_value+3 
	CALL        _can_set_id+0, 0
;lib_can.h,373 :: 		can_set_id(&RXF8EIDL, 0);       //FILTRO 8
	MOVLW       RXF8EIDL+0
	MOVWF       FARG_can_set_id_address+0 
	MOVLW       hi_addr(RXF8EIDL+0)
	MOVWF       FARG_can_set_id_address+1 
	CLRF        FARG_can_set_id_value+0 
	CLRF        FARG_can_set_id_value+1 
	CLRF        FARG_can_set_id_value+2 
	CLRF        FARG_can_set_id_value+3 
	CALL        _can_set_id+0, 0
;lib_can.h,374 :: 		can_set_id(&RXF9EIDL, 0);       //FILTRO 9
	MOVLW       RXF9EIDL+0
	MOVWF       FARG_can_set_id_address+0 
	MOVLW       hi_addr(RXF9EIDL+0)
	MOVWF       FARG_can_set_id_address+1 
	CLRF        FARG_can_set_id_value+0 
	CLRF        FARG_can_set_id_value+1 
	CLRF        FARG_can_set_id_value+2 
	CLRF        FARG_can_set_id_value+3 
	CALL        _can_set_id+0, 0
;lib_can.h,375 :: 		can_set_id(&RXF10EIDL, 0);      //FILTRO 10
	MOVLW       RXF10EIDL+0
	MOVWF       FARG_can_set_id_address+0 
	MOVLW       hi_addr(RXF10EIDL+0)
	MOVWF       FARG_can_set_id_address+1 
	CLRF        FARG_can_set_id_value+0 
	CLRF        FARG_can_set_id_value+1 
	CLRF        FARG_can_set_id_value+2 
	CLRF        FARG_can_set_id_value+3 
	CALL        _can_set_id+0, 0
;lib_can.h,376 :: 		can_set_id(&RXF11EIDL, 0);      //FILTRO 11
	MOVLW       RXF11EIDL+0
	MOVWF       FARG_can_set_id_address+0 
	MOVLW       hi_addr(RXF11EIDL+0)
	MOVWF       FARG_can_set_id_address+1 
	CLRF        FARG_can_set_id_value+0 
	CLRF        FARG_can_set_id_value+1 
	CLRF        FARG_can_set_id_value+2 
	CLRF        FARG_can_set_id_value+3 
	CALL        _can_set_id+0, 0
;lib_can.h,377 :: 		can_set_id(&RXF12EIDL, 0);      //FILTRO 12
	MOVLW       RXF12EIDL+0
	MOVWF       FARG_can_set_id_address+0 
	MOVLW       hi_addr(RXF12EIDL+0)
	MOVWF       FARG_can_set_id_address+1 
	CLRF        FARG_can_set_id_value+0 
	CLRF        FARG_can_set_id_value+1 
	CLRF        FARG_can_set_id_value+2 
	CLRF        FARG_can_set_id_value+3 
	CALL        _can_set_id+0, 0
;lib_can.h,378 :: 		can_set_id(&RXF13EIDL, 0);      //FILTRO 13
	MOVLW       RXF13EIDL+0
	MOVWF       FARG_can_set_id_address+0 
	MOVLW       hi_addr(RXF13EIDL+0)
	MOVWF       FARG_can_set_id_address+1 
	CLRF        FARG_can_set_id_value+0 
	CLRF        FARG_can_set_id_value+1 
	CLRF        FARG_can_set_id_value+2 
	CLRF        FARG_can_set_id_value+3 
	CALL        _can_set_id+0, 0
;lib_can.h,379 :: 		can_set_id(&RXF14EIDL, 0);      //FILTRO 14
	MOVLW       RXF14EIDL+0
	MOVWF       FARG_can_set_id_address+0 
	MOVLW       hi_addr(RXF14EIDL+0)
	MOVWF       FARG_can_set_id_address+1 
	CLRF        FARG_can_set_id_value+0 
	CLRF        FARG_can_set_id_value+1 
	CLRF        FARG_can_set_id_value+2 
	CLRF        FARG_can_set_id_value+3 
	CALL        _can_set_id+0, 0
;lib_can.h,380 :: 		can_set_id(&RXF15EIDL, 0);      //FILTRO 15
	MOVLW       RXF15EIDL+0
	MOVWF       FARG_can_set_id_address+0 
	MOVLW       hi_addr(RXF15EIDL+0)
	MOVWF       FARG_can_set_id_address+1 
	CLRF        FARG_can_set_id_value+0 
	CLRF        FARG_can_set_id_value+1 
	CLRF        FARG_can_set_id_value+2 
	CLRF        FARG_can_set_id_value+3 
	CALL        _can_set_id+0, 0
;lib_can.h,388 :: 		TRISB.B2 = 0;  //CANAL TX
	BCF         TRISB+0, 2 
;lib_can.h,389 :: 		TRISB.B3 = 1;  //CANAL RX
	BSF         TRISB+0, 3 
;lib_can.h,392 :: 		can_set_operation(CAN_OPERATION_NORMAL);
	CLRF        FARG_can_set_operation_CAN_OPERATION+0 
	CALL        _can_set_operation+0, 0
;lib_can.h,393 :: 		}
L_end_can_open:
	RETURN      0
; end of _can_open

_can_set_baud:

;lib_can.h,395 :: 		void can_set_baud(unsigned int speed_us){
;lib_can.h,408 :: 		speed_us *= Clock_Mhz();
	MOVF        FARG_can_set_baud_speed_us+0, 0 
	MOVWF       R0 
	MOVF        FARG_can_set_baud_speed_us+1, 0 
	MOVWF       R1 
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_can_set_baud_speed_us+0 
	MOVF        R1, 0 
	MOVWF       FARG_can_set_baud_speed_us+1 
;lib_can.h,409 :: 		speed_us /= 2;
	MOVF        R0, 0 
	MOVWF       FARG_can_set_baud_speed_us+0 
	MOVF        R1, 0 
	MOVWF       FARG_can_set_baud_speed_us+1 
	RRCF        FARG_can_set_baud_speed_us+1, 1 
	RRCF        FARG_can_set_baud_speed_us+0, 1 
	BCF         FARG_can_set_baud_speed_us+1, 7 
;lib_can.h,410 :: 		for(Tqp = 25; Tqp >= 8; Tqp--){
	MOVLW       25
	MOVWF       can_set_baud_Tqp_L0+0 
L_can_set_baud205:
	MOVLW       8
	SUBWF       can_set_baud_Tqp_L0+0, 0 
	BTFSS       STATUS+0, 0 
	GOTO        L_can_set_baud206
;lib_can.h,411 :: 		if(speed_us % Tqp == 0){
	MOVF        can_set_baud_Tqp_L0+0, 0 
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVF        FARG_can_set_baud_speed_us+0, 0 
	MOVWF       R0 
	MOVF        FARG_can_set_baud_speed_us+1, 0 
	MOVWF       R1 
	CALL        _Div_16X16_U+0, 0
	MOVF        R8, 0 
	MOVWF       R0 
	MOVF        R9, 0 
	MOVWF       R1 
	MOVLW       0
	XORWF       R1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__can_set_baud1159
	MOVLW       0
	XORWF       R0, 0 
L__can_set_baud1159:
	BTFSS       STATUS+0, 2 
	GOTO        L_can_set_baud208
;lib_can.h,412 :: 		pre = speed_us/Tqp;
	MOVF        can_set_baud_Tqp_L0+0, 0 
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVF        FARG_can_set_baud_speed_us+0, 0 
	MOVWF       R0 
	MOVF        FARG_can_set_baud_speed_us+1, 0 
	MOVWF       R1 
	CALL        _Div_16X16_U+0, 0
	MOVF        R0, 0 
	MOVWF       can_set_baud_pre_L0+0 
;lib_can.h,413 :: 		if(pre >= 1 && pre <= 64){
	MOVLW       1
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 0 
	GOTO        L_can_set_baud211
	MOVF        can_set_baud_pre_L0+0, 0 
	SUBLW       64
	BTFSS       STATUS+0, 0 
	GOTO        L_can_set_baud211
L__can_set_baud969:
;lib_can.h,415 :: 		BRGCON1 = --pre;            //Bit menos significativo
	DECF        can_set_baud_pre_L0+0, 1 
	MOVF        can_set_baud_pre_L0+0, 0 
	MOVWF       BRGCON1+0 
;lib_can.h,416 :: 		BRGCON1.SJW0 = CAN_SYNC_JUMP_WIDTH.B0;
	BCF         BRGCON1+0, 6 
;lib_can.h,417 :: 		BRGCON1.SJW1 = CAN_SYNC_JUMP_WIDTH.B1;
	BCF         BRGCON1+0, 7 
;lib_can.h,418 :: 		Tqp--;                       //Restar 1Tq por SYNC
	DECF        can_set_baud_Tqp_L0+0, 1 
;lib_can.h,419 :: 		break;
	GOTO        L_can_set_baud206
;lib_can.h,420 :: 		}
L_can_set_baud211:
;lib_can.h,421 :: 		}
L_can_set_baud208:
;lib_can.h,410 :: 		for(Tqp = 25; Tqp >= 8; Tqp--){
	DECF        can_set_baud_Tqp_L0+0, 1 
;lib_can.h,422 :: 		}
	GOTO        L_can_set_baud205
L_can_set_baud206:
;lib_can.h,424 :: 		for(pre = 16; pre >= 2; pre -= 2){
	MOVLW       16
	MOVWF       can_set_baud_pre_L0+0 
L_can_set_baud212:
	MOVLW       2
	SUBWF       can_set_baud_pre_L0+0, 0 
	BTFSS       STATUS+0, 0 
	GOTO        L_can_set_baud213
;lib_can.h,425 :: 		if(Tqp > pre){
	MOVF        can_set_baud_Tqp_L0+0, 0 
	SUBWF       can_set_baud_pre_L0+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_can_set_baud215
;lib_can.h,426 :: 		pre >>= 1; //DIVIDE SOBRE DOS
	MOVF        can_set_baud_pre_L0+0, 0 
	MOVWF       R0 
	RRCF        R0, 1 
	BCF         R0, 7 
	MOVF        R0, 0 
	MOVWF       can_set_baud_pre_L0+0 
;lib_can.h,427 :: 		pre--;     //AJUSTAR VALORES DE 0-7
	DECF        R0, 1 
	MOVF        R0, 0 
	MOVWF       can_set_baud_pre_L0+0 
;lib_can.h,429 :: 		BRGCON2.SEG2PHTS = 1;      //PHASE 2 PROGRAMABLE
	BSF         BRGCON2+0, 7 
;lib_can.h,430 :: 		BRGCON2.SAM = CAN_SAMPLE_THRICE_TIMES.B0;
	BSF         BRGCON2+0, 6 
;lib_can.h,431 :: 		BRGCON2.SEG1PH0 = pre.B0;
	BTFSC       can_set_baud_pre_L0+0, 0 
	GOTO        L__can_set_baud1160
	BCF         BRGCON2+0, 3 
	GOTO        L__can_set_baud1161
L__can_set_baud1160:
	BSF         BRGCON2+0, 3 
L__can_set_baud1161:
;lib_can.h,432 :: 		BRGCON2.SEG1PH1 = pre.B1;
	BTFSC       can_set_baud_pre_L0+0, 1 
	GOTO        L__can_set_baud1162
	BCF         BRGCON2+0, 4 
	GOTO        L__can_set_baud1163
L__can_set_baud1162:
	BSF         BRGCON2+0, 4 
L__can_set_baud1163:
;lib_can.h,433 :: 		BRGCON2.SEG1PH2 = pre.B2;
	BTFSC       can_set_baud_pre_L0+0, 2 
	GOTO        L__can_set_baud1164
	BCF         BRGCON2+0, 5 
	GOTO        L__can_set_baud1165
L__can_set_baud1164:
	BSF         BRGCON2+0, 5 
L__can_set_baud1165:
;lib_can.h,435 :: 		BRGCON3.WAKDIS = !CAN_WAKE_UP_IN_ACTIVITY;
	BCF         BRGCON3+0, 7 
;lib_can.h,436 :: 		BRGCON3.WAKFIL = CAN_LINE_FILTER_ON;
	BCF         BRGCON3+0, 6 
;lib_can.h,437 :: 		BRGCON3.SEG2PH0 = pre.B0;
	BTFSC       can_set_baud_pre_L0+0, 0 
	GOTO        L__can_set_baud1166
	BCF         BRGCON3+0, 0 
	GOTO        L__can_set_baud1167
L__can_set_baud1166:
	BSF         BRGCON3+0, 0 
L__can_set_baud1167:
;lib_can.h,438 :: 		BRGCON3.SEG2PH1 = pre.B1;
	BTFSC       can_set_baud_pre_L0+0, 1 
	GOTO        L__can_set_baud1168
	BCF         BRGCON3+0, 1 
	GOTO        L__can_set_baud1169
L__can_set_baud1168:
	BSF         BRGCON3+0, 1 
L__can_set_baud1169:
;lib_can.h,439 :: 		BRGCON3.SEG2PH2 = pre.B2;
	BTFSC       can_set_baud_pre_L0+0, 2 
	GOTO        L__can_set_baud1170
	BCF         BRGCON3+0, 2 
	GOTO        L__can_set_baud1171
L__can_set_baud1170:
	BSF         BRGCON3+0, 2 
L__can_set_baud1171:
;lib_can.h,441 :: 		pre = Tqp - 2*(pre+1);  //Obtener el resto de Tq
	MOVF        R0, 0 
	ADDLW       1
	MOVWF       R2 
	MOVF        R2, 0 
	MOVWF       R0 
	RLCF        R0, 1 
	BCF         R0, 0 
	MOVF        R0, 0 
	SUBWF       can_set_baud_Tqp_L0+0, 0 
	MOVWF       can_set_baud_pre_L0+0 
;lib_can.h,442 :: 		pre--;                  //Ajustar de 0-7
	DECF        can_set_baud_pre_L0+0, 1 
;lib_can.h,443 :: 		BRGCON2.PRSEG0 = pre.B0;
	BTFSC       can_set_baud_pre_L0+0, 0 
	GOTO        L__can_set_baud1172
	BCF         BRGCON2+0, 0 
	GOTO        L__can_set_baud1173
L__can_set_baud1172:
	BSF         BRGCON2+0, 0 
L__can_set_baud1173:
;lib_can.h,444 :: 		BRGCON2.PRSEG1 = pre.B1;
	BTFSC       can_set_baud_pre_L0+0, 1 
	GOTO        L__can_set_baud1174
	BCF         BRGCON2+0, 1 
	GOTO        L__can_set_baud1175
L__can_set_baud1174:
	BSF         BRGCON2+0, 1 
L__can_set_baud1175:
;lib_can.h,445 :: 		BRGCON2.PRSEG2 = pre.B2;
	BTFSC       can_set_baud_pre_L0+0, 2 
	GOTO        L__can_set_baud1176
	BCF         BRGCON2+0, 2 
	GOTO        L__can_set_baud1177
L__can_set_baud1176:
	BSF         BRGCON2+0, 2 
L__can_set_baud1177:
;lib_can.h,446 :: 		break;
	GOTO        L_can_set_baud213
;lib_can.h,447 :: 		}
L_can_set_baud215:
;lib_can.h,424 :: 		for(pre = 16; pre >= 2; pre -= 2){
	MOVLW       2
	SUBWF       can_set_baud_pre_L0+0, 1 
;lib_can.h,448 :: 		}
	GOTO        L_can_set_baud212
L_can_set_baud213:
;lib_can.h,449 :: 		}
L_end_can_set_baud:
	RETURN      0
; end of _can_set_baud

_can_read:

;lib_can.h,451 :: 		char can_read(long *id, char *datos, char *size){
;lib_can.h,456 :: 		if(RXB0CON.RXFUL){  //Mensaje en buffer
	BTFSS       RXB0CON+0, 7 
	GOTO        L_can_read216
;lib_can.h,457 :: 		bufferBX = &RXB0CON;
	MOVLW       RXB0CON+0
	MOVWF       can_read_bufferBX_L0+0 
	MOVLW       hi_addr(RXB0CON+0)
	MOVWF       can_read_bufferBX_L0+1 
;lib_can.h,458 :: 		regLen = &RXB0DLC;
	MOVLW       RXB0DLC+0
	MOVWF       can_read_regLen_L0+0 
	MOVLW       hi_addr(RXB0DLC+0)
	MOVWF       can_read_regLen_L0+1 
;lib_can.h,459 :: 		receptor = &RXB0EIDL;
	MOVLW       RXB0EIDL+0
	MOVWF       can_read_receptor_L0+0 
	MOVLW       hi_addr(RXB0EIDL+0)
	MOVWF       can_read_receptor_L0+1 
;lib_can.h,460 :: 		buffer = &RXB0D0;
	MOVLW       RXB0D0+0
	MOVWF       can_read_buffer_L0+0 
	MOVLW       hi_addr(RXB0D0+0)
	MOVWF       can_read_buffer_L0+1 
;lib_can.h,461 :: 		ref = can.mode == CAN_MODE_LEGACY? 0x00:0x10;
	MOVF        _can+14, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_can_read217
	CLRF        ?FLOC___can_readT871+0 
	GOTO        L_can_read218
L_can_read217:
	MOVLW       16
	MOVWF       ?FLOC___can_readT871+0 
L_can_read218:
	MOVF        ?FLOC___can_readT871+0, 0 
	MOVWF       can_read_ref_L0+0 
;lib_can.h,462 :: 		can.overflow = COMSTAT.RXB0OVFL;
	MOVLW       0
	BTFSC       COMSTAT+0, 7 
	MOVLW       1
	MOVWF       _can+15 
;lib_can.h,463 :: 		COMSTAT.RXB0OVFL = 0;  //Limpiar sobreflujo
	BCF         COMSTAT+0, 7 
;lib_can.h,465 :: 		if(can.mode == CAN_MODE_LEGACY)
	MOVF        _can+14, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_can_read219
;lib_can.h,466 :: 		can.numFilter = RXB0CON.FILHIT0;
	MOVLW       0
	BTFSC       RXB0CON+0, 0 
	MOVLW       1
	MOVWF       _can+16 
	GOTO        L_can_read220
L_can_read219:
;lib_can.h,468 :: 		can.numFilter = RXB0CON & 0x1F;
	MOVLW       31
	ANDWF       RXB0CON+0, 0 
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       _can+16 
L_can_read220:
;lib_can.h,469 :: 		}else if(RXB1CON.RXFUL){  //Mensaje en buffer
	GOTO        L_can_read221
L_can_read216:
	BTFSS       RXB1CON+0, 7 
	GOTO        L_can_read222
;lib_can.h,470 :: 		bufferBX = &RXB1CON;
	MOVLW       RXB1CON+0
	MOVWF       can_read_bufferBX_L0+0 
	MOVLW       hi_addr(RXB1CON+0)
	MOVWF       can_read_bufferBX_L0+1 
;lib_can.h,471 :: 		regLen = &RXB0DLC;
	MOVLW       RXB0DLC+0
	MOVWF       can_read_regLen_L0+0 
	MOVLW       hi_addr(RXB0DLC+0)
	MOVWF       can_read_regLen_L0+1 
;lib_can.h,472 :: 		receptor = &RXB1EIDL;
	MOVLW       RXB1EIDL+0
	MOVWF       can_read_receptor_L0+0 
	MOVLW       hi_addr(RXB1EIDL+0)
	MOVWF       can_read_receptor_L0+1 
;lib_can.h,473 :: 		buffer = &RXB1D0;
	MOVLW       RXB1D0+0
	MOVWF       can_read_buffer_L0+0 
	MOVLW       hi_addr(RXB1D0+0)
	MOVWF       can_read_buffer_L0+1 
;lib_can.h,474 :: 		ref = can.mode == CAN_MODE_LEGACY? 0x0A:0x10;          //CHECAR POR EL MODO
	MOVF        _can+14, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_can_read223
	MOVLW       10
	MOVWF       ?FLOC___can_readT884+0 
	GOTO        L_can_read224
L_can_read223:
	MOVLW       16
	MOVWF       ?FLOC___can_readT884+0 
L_can_read224:
	MOVF        ?FLOC___can_readT884+0, 0 
	MOVWF       can_read_ref_L0+0 
;lib_can.h,475 :: 		ref |= can.mode == CAN_MODE_ENHANCED_LEGACY? 0x01:0x00;
	MOVF        _can+14, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_can_read225
	MOVLW       1
	MOVWF       ?FLOC___can_readT886+0 
	GOTO        L_can_read226
L_can_read225:
	CLRF        ?FLOC___can_readT886+0 
L_can_read226:
	MOVF        ?FLOC___can_readT886+0, 0 
	IORWF       can_read_ref_L0+0, 1 
;lib_can.h,476 :: 		can.overflow = COMSTAT.RXB1OVFL;
	MOVLW       0
	BTFSC       COMSTAT+0, 6 
	MOVLW       1
	MOVWF       _can+15 
;lib_can.h,477 :: 		COMSTAT.RXB1OVFL = 0;  //Limpiar sobreflujo
	BCF         COMSTAT+0, 6 
;lib_can.h,478 :: 		if(can.mode == CAN_MODE_LEGACY)
	MOVF        _can+14, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_can_read227
;lib_can.h,479 :: 		can.numFilter = RXB0CON.RXB0DBEN? RXB1CON&0x07: -1;
	BTFSS       RXB0CON+0, 2 
	GOTO        L_can_read228
	MOVLW       7
	ANDWF       RXB1CON+0, 0 
	MOVWF       ?FLOC___can_readT894+0 
	GOTO        L_can_read229
L_can_read228:
	MOVLW       255
	MOVWF       ?FLOC___can_readT894+0 
L_can_read229:
	MOVF        ?FLOC___can_readT894+0, 0 
	MOVWF       _can+16 
	GOTO        L_can_read230
L_can_read227:
;lib_can.h,481 :: 		can.numFilter = RXB1CON & 0x1F;
	MOVLW       31
	ANDWF       RXB1CON+0, 0 
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       _can+16 
L_can_read230:
;lib_can.h,482 :: 		}else if(can.mode == CAN_MODE_LEGACY){
	GOTO        L_can_read231
L_can_read222:
	MOVF        _can+14, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_can_read232
;lib_can.h,483 :: 		return CAN_RW_EMPTY;  //No se recibio nada
	CLRF        R0 
	GOTO        L_end_can_read
;lib_can.h,484 :: 		}
L_can_read232:
L_can_read231:
L_can_read221:
;lib_can.h,487 :: 		if(can.mode == CAN_MODE_LEGACY){
	MOVF        _can+14, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_can_read233
;lib_can.h,488 :: 		CANCON &= 0xF1;
	MOVLW       241
	ANDWF       CANCON+0, 1 
;lib_can.h,489 :: 		CANCON |= ref;   //BITS WIN
	MOVF        can_read_ref_L0+0, 0 
	IORWF       CANCON+0, 1 
;lib_can.h,490 :: 		}else{   //MODO 1 Y 2
	GOTO        L_can_read234
L_can_read233:
;lib_can.h,492 :: 		if(!BSEL0.B0TXEN && B0CON.RXFUL){
	BTFSC       BSEL0+0, 2 
	GOTO        L_can_read237
	BTFSS       B0CON+0, 7 
	GOTO        L_can_read237
L__can_read976:
;lib_can.h,493 :: 		bufferBX = &B0CON;
	MOVLW       B0CON+0
	MOVWF       can_read_bufferBX_L0+0 
	MOVLW       hi_addr(B0CON+0)
	MOVWF       can_read_bufferBX_L0+1 
;lib_can.h,494 :: 		regLen = &B0DLC;
	MOVLW       B0DLC+0
	MOVWF       can_read_regLen_L0+0 
	MOVLW       hi_addr(B0DLC+0)
	MOVWF       can_read_regLen_L0+1 
;lib_can.h,495 :: 		receptor = &B0EIDL;
	MOVLW       B0EIDL+0
	MOVWF       can_read_receptor_L0+0 
	MOVLW       hi_addr(B0EIDL+0)
	MOVWF       can_read_receptor_L0+1 
;lib_can.h,496 :: 		buffer = &B0D0;
	MOVLW       B0D0+0
	MOVWF       can_read_buffer_L0+0 
	MOVLW       hi_addr(B0D0+0)
	MOVWF       can_read_buffer_L0+1 
;lib_can.h,497 :: 		can.overflow = COMSTAT.RXB0OVFL;
	MOVLW       0
	BTFSC       COMSTAT+0, 7 
	MOVLW       1
	MOVWF       _can+15 
;lib_can.h,498 :: 		COMSTAT.RXB0OVFL = 0;  //Limpiar sobreflujo
	BCF         COMSTAT+0, 7 
;lib_can.h,499 :: 		can.numFilter = B0CON & 0x1F;
	MOVLW       31
	ANDWF       B0CON+0, 0 
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       _can+16 
;lib_can.h,500 :: 		ref = 0x12;
	MOVLW       18
	MOVWF       can_read_ref_L0+0 
;lib_can.h,501 :: 		}else if(!BSEL0.B1TXEN && B1CON.RXFUL){
	GOTO        L_can_read238
L_can_read237:
	BTFSC       BSEL0+0, 3 
	GOTO        L_can_read241
	BTFSS       B1CON+0, 7 
	GOTO        L_can_read241
L__can_read975:
;lib_can.h,502 :: 		bufferBX = &B1CON;
	MOVLW       B1CON+0
	MOVWF       can_read_bufferBX_L0+0 
	MOVLW       hi_addr(B1CON+0)
	MOVWF       can_read_bufferBX_L0+1 
;lib_can.h,503 :: 		regLen = &B1DLC;
	MOVLW       B1DLC+0
	MOVWF       can_read_regLen_L0+0 
	MOVLW       hi_addr(B1DLC+0)
	MOVWF       can_read_regLen_L0+1 
;lib_can.h,504 :: 		receptor = &B1EIDL;
	MOVLW       B1EIDL+0
	MOVWF       can_read_receptor_L0+0 
	MOVLW       hi_addr(B1EIDL+0)
	MOVWF       can_read_receptor_L0+1 
;lib_can.h,505 :: 		buffer = &B1D0;
	MOVLW       B1D0+0
	MOVWF       can_read_buffer_L0+0 
	MOVLW       hi_addr(B1D0+0)
	MOVWF       can_read_buffer_L0+1 
;lib_can.h,506 :: 		can.overflow = COMSTAT.RXB0OVFL;
	MOVLW       0
	BTFSC       COMSTAT+0, 7 
	MOVLW       1
	MOVWF       _can+15 
;lib_can.h,507 :: 		COMSTAT.RXB0OVFL = 0;  //Limpiar sobreflujo
	BCF         COMSTAT+0, 7 
;lib_can.h,508 :: 		can.numFilter = B1CON & 0x1F;
	MOVLW       31
	ANDWF       B1CON+0, 0 
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       _can+16 
;lib_can.h,509 :: 		ref = 0x13;
	MOVLW       19
	MOVWF       can_read_ref_L0+0 
;lib_can.h,510 :: 		}else if(!BSEL0.B2TXEN && B2CON.RXFUL){
	GOTO        L_can_read242
L_can_read241:
	BTFSC       BSEL0+0, 4 
	GOTO        L_can_read245
	BTFSS       B2CON+0, 7 
	GOTO        L_can_read245
L__can_read974:
;lib_can.h,511 :: 		bufferBX = &B2CON;
	MOVLW       B2CON+0
	MOVWF       can_read_bufferBX_L0+0 
	MOVLW       hi_addr(B2CON+0)
	MOVWF       can_read_bufferBX_L0+1 
;lib_can.h,512 :: 		regLen = &B2DLC;
	MOVLW       B2DLC+0
	MOVWF       can_read_regLen_L0+0 
	MOVLW       hi_addr(B2DLC+0)
	MOVWF       can_read_regLen_L0+1 
;lib_can.h,513 :: 		receptor = &B2EIDL;
	MOVLW       B2EIDL+0
	MOVWF       can_read_receptor_L0+0 
	MOVLW       hi_addr(B2EIDL+0)
	MOVWF       can_read_receptor_L0+1 
;lib_can.h,514 :: 		buffer = &B2D0;
	MOVLW       B2D0+0
	MOVWF       can_read_buffer_L0+0 
	MOVLW       hi_addr(B2D0+0)
	MOVWF       can_read_buffer_L0+1 
;lib_can.h,515 :: 		can.overflow = COMSTAT.RXB0OVFL;
	MOVLW       0
	BTFSC       COMSTAT+0, 7 
	MOVLW       1
	MOVWF       _can+15 
;lib_can.h,516 :: 		COMSTAT.RXB0OVFL = 0;  //Limpiar sobreflujo
	BCF         COMSTAT+0, 7 
;lib_can.h,517 :: 		can.numFilter = B2CON & 0x1F;
	MOVLW       31
	ANDWF       B2CON+0, 0 
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       _can+16 
;lib_can.h,518 :: 		ref = 0x14;
	MOVLW       20
	MOVWF       can_read_ref_L0+0 
;lib_can.h,519 :: 		}else if(!BSEL0.B3TXEN && B3CON.RXFUL){
	GOTO        L_can_read246
L_can_read245:
	BTFSC       BSEL0+0, 5 
	GOTO        L_can_read249
	BTFSS       B3CON+0, 7 
	GOTO        L_can_read249
L__can_read973:
;lib_can.h,520 :: 		bufferBX = &B3CON;
	MOVLW       B3CON+0
	MOVWF       can_read_bufferBX_L0+0 
	MOVLW       hi_addr(B3CON+0)
	MOVWF       can_read_bufferBX_L0+1 
;lib_can.h,521 :: 		regLen = &B3DLC;
	MOVLW       B3DLC+0
	MOVWF       can_read_regLen_L0+0 
	MOVLW       hi_addr(B3DLC+0)
	MOVWF       can_read_regLen_L0+1 
;lib_can.h,522 :: 		receptor = &B3EIDL;
	MOVLW       B3EIDL+0
	MOVWF       can_read_receptor_L0+0 
	MOVLW       hi_addr(B3EIDL+0)
	MOVWF       can_read_receptor_L0+1 
;lib_can.h,523 :: 		buffer = &B3D0;
	MOVLW       B3D0+0
	MOVWF       can_read_buffer_L0+0 
	MOVLW       hi_addr(B3D0+0)
	MOVWF       can_read_buffer_L0+1 
;lib_can.h,524 :: 		can.overflow = COMSTAT.RXB0OVFL;
	MOVLW       0
	BTFSC       COMSTAT+0, 7 
	MOVLW       1
	MOVWF       _can+15 
;lib_can.h,525 :: 		COMSTAT.RXB0OVFL = 0;  //Limpiar sobreflujo
	BCF         COMSTAT+0, 7 
;lib_can.h,526 :: 		can.numFilter = B3CON & 0x1F;
	MOVLW       31
	ANDWF       B3CON+0, 0 
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       _can+16 
;lib_can.h,527 :: 		ref = 0x15;
	MOVLW       21
	MOVWF       can_read_ref_L0+0 
;lib_can.h,528 :: 		}else if(!BSEL0.B4TXEN && B4CON.RXFUL){
	GOTO        L_can_read250
L_can_read249:
	BTFSC       BSEL0+0, 6 
	GOTO        L_can_read253
	BTFSS       B4CON+0, 7 
	GOTO        L_can_read253
L__can_read972:
;lib_can.h,529 :: 		bufferBX = &B4CON;
	MOVLW       B4CON+0
	MOVWF       can_read_bufferBX_L0+0 
	MOVLW       hi_addr(B4CON+0)
	MOVWF       can_read_bufferBX_L0+1 
;lib_can.h,530 :: 		regLen = &B4DLC;
	MOVLW       B4DLC+0
	MOVWF       can_read_regLen_L0+0 
	MOVLW       hi_addr(B4DLC+0)
	MOVWF       can_read_regLen_L0+1 
;lib_can.h,531 :: 		receptor = &B4EIDL;
	MOVLW       B4EIDL+0
	MOVWF       can_read_receptor_L0+0 
	MOVLW       hi_addr(B4EIDL+0)
	MOVWF       can_read_receptor_L0+1 
;lib_can.h,532 :: 		buffer = &B4D0;
	MOVLW       B4D0+0
	MOVWF       can_read_buffer_L0+0 
	MOVLW       hi_addr(B4D0+0)
	MOVWF       can_read_buffer_L0+1 
;lib_can.h,533 :: 		can.overflow = COMSTAT.RXB0OVFL;
	MOVLW       0
	BTFSC       COMSTAT+0, 7 
	MOVLW       1
	MOVWF       _can+15 
;lib_can.h,534 :: 		COMSTAT.RXB0OVFL = 0;  //Limpiar sobreflujo
	BCF         COMSTAT+0, 7 
;lib_can.h,535 :: 		can.numFilter = B4CON & 0x1F;
	MOVLW       31
	ANDWF       B4CON+0, 0 
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       _can+16 
;lib_can.h,536 :: 		ref = 0x16;
	MOVLW       22
	MOVWF       can_read_ref_L0+0 
;lib_can.h,537 :: 		}else if(!BSEL0.B5TXEN && B5CON.RXFUL){
	GOTO        L_can_read254
L_can_read253:
	BTFSC       BSEL0+0, 7 
	GOTO        L_can_read257
	BTFSS       B5CON+0, 7 
	GOTO        L_can_read257
L__can_read971:
;lib_can.h,538 :: 		bufferBX = &B5CON;
	MOVLW       B5CON+0
	MOVWF       can_read_bufferBX_L0+0 
	MOVLW       hi_addr(B5CON+0)
	MOVWF       can_read_bufferBX_L0+1 
;lib_can.h,539 :: 		regLen = &B5DLC;
	MOVLW       B5DLC+0
	MOVWF       can_read_regLen_L0+0 
	MOVLW       hi_addr(B5DLC+0)
	MOVWF       can_read_regLen_L0+1 
;lib_can.h,540 :: 		receptor = &B5EIDL;
	MOVLW       B5EIDL+0
	MOVWF       can_read_receptor_L0+0 
	MOVLW       hi_addr(B5EIDL+0)
	MOVWF       can_read_receptor_L0+1 
;lib_can.h,541 :: 		buffer = &B5D0;
	MOVLW       B5D0+0
	MOVWF       can_read_buffer_L0+0 
	MOVLW       hi_addr(B5D0+0)
	MOVWF       can_read_buffer_L0+1 
;lib_can.h,542 :: 		can.overflow = COMSTAT.RXB0OVFL;
	MOVLW       0
	BTFSC       COMSTAT+0, 7 
	MOVLW       1
	MOVWF       _can+15 
;lib_can.h,543 :: 		COMSTAT.RXB0OVFL = 0;  //Limpiar sobreflujo
	BCF         COMSTAT+0, 7 
;lib_can.h,544 :: 		can.numFilter = B5CON & 0x1F;
	MOVLW       31
	ANDWF       B5CON+0, 0 
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       _can+16 
;lib_can.h,545 :: 		ref = 0x17;
	MOVLW       23
	MOVWF       can_read_ref_L0+0 
;lib_can.h,546 :: 		}else{
	GOTO        L_can_read258
L_can_read257:
;lib_can.h,547 :: 		return CAN_RW_EMPTY;
	CLRF        R0 
	GOTO        L_end_can_read
;lib_can.h,548 :: 		}
L_can_read258:
L_can_read254:
L_can_read250:
L_can_read246:
L_can_read242:
L_can_read238:
;lib_can.h,550 :: 		ECANCON &= 0xE0;
	MOVLW       224
	ANDWF       ECANCON+0, 1 
;lib_can.h,551 :: 		ECANCON |= ref;     //BITS EWIN
	MOVF        can_read_ref_L0+0, 0 
	IORWF       ECANCON+0, 1 
;lib_can.h,552 :: 		}
L_can_read234:
;lib_can.h,555 :: 		*size = (*regLen)&0x0F;
	MOVFF       can_read_regLen_L0+0, FSR0
	MOVFF       can_read_regLen_L0+1, FSR0H
	MOVFF       FARG_can_read_size+0, FSR1
	MOVFF       FARG_can_read_size+1, FSR1H
	MOVLW       15
	ANDWF       POSTINC0+0, 0 
	MOVWF       POSTINC1+0 
;lib_can.h,556 :: 		can.rxRequest = (*regLen).B6;
	MOVFF       can_read_regLen_L0+0, FSR0
	MOVFF       can_read_regLen_L0+1, FSR0H
	MOVF        POSTINC0+0, 0 
	MOVWF       R0 
	MOVLW       0
	BTFSC       R0, 6 
	MOVLW       1
	MOVWF       _can+105 
;lib_can.h,558 :: 		*id = can_get_id(receptor);
	MOVF        can_read_receptor_L0+0, 0 
	MOVWF       FARG_can_get_id_address+0 
	MOVF        can_read_receptor_L0+1, 0 
	MOVWF       FARG_can_get_id_address+1 
	CALL        _can_get_id+0, 0
	MOVFF       FARG_can_read_id+0, FSR1
	MOVFF       FARG_can_read_id+1, FSR1H
	MOVF        R0, 0 
	MOVWF       POSTINC1+0 
	MOVF        R1, 0 
	MOVWF       POSTINC1+0 
	MOVF        R2, 0 
	MOVWF       POSTINC1+0 
	MOVF        R3, 0 
	MOVWF       POSTINC1+0 
;lib_can.h,560 :: 		for(ref = 0; ref < *size && ref < 8; ref++)
	CLRF        can_read_ref_L0+0 
L_can_read259:
	MOVFF       FARG_can_read_size+0, FSR2
	MOVFF       FARG_can_read_size+1, FSR2H
	MOVF        POSTINC2+0, 0 
	SUBWF       can_read_ref_L0+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_can_read260
	MOVLW       8
	SUBWF       can_read_ref_L0+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_can_read260
L__can_read970:
;lib_can.h,561 :: 		datos[ref] = buffer[ref];
	MOVF        can_read_ref_L0+0, 0 
	ADDWF       FARG_can_read_datos+0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      FARG_can_read_datos+1, 0 
	MOVWF       FSR1H 
	MOVF        can_read_ref_L0+0, 0 
	ADDWF       can_read_buffer_L0+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      can_read_buffer_L0+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       POSTINC1+0 
;lib_can.h,560 :: 		for(ref = 0; ref < *size && ref < 8; ref++)
	INCF        can_read_ref_L0+0, 1 
;lib_can.h,561 :: 		datos[ref] = buffer[ref];
	GOTO        L_can_read259
L_can_read260:
;lib_can.h,564 :: 		(*bufferBX).B7 = 0;    //RESETEAR BANDERA
	MOVFF       can_read_bufferBX_L0+0, FSR1
	MOVFF       can_read_bufferBX_L0+1, FSR1H
	BCF         POSTINC1+0, 7 
;lib_can.h,567 :: 		if(bufferBX == &RXB0CON)
	MOVF        can_read_bufferBX_L0+1, 0 
	XORLW       hi_addr(RXB0CON+0)
	BTFSS       STATUS+0, 2 
	GOTO        L__can_read1179
	MOVLW       RXB0CON+0
	XORWF       can_read_bufferBX_L0+0, 0 
L__can_read1179:
	BTFSS       STATUS+0, 2 
	GOTO        L_can_read264
;lib_can.h,568 :: 		PIR3.RXB0IF = 0;     //VERIFICAR EN MODO 2
	BCF         PIR3+0, 0 
	GOTO        L_can_read265
L_can_read264:
;lib_can.h,569 :: 		else if(bufferBX == &RXB1CON)
	MOVF        can_read_bufferBX_L0+1, 0 
	XORLW       hi_addr(RXB1CON+0)
	BTFSS       STATUS+0, 2 
	GOTO        L__can_read1180
	MOVLW       RXB1CON+0
	XORWF       can_read_bufferBX_L0+0, 0 
L__can_read1180:
	BTFSS       STATUS+0, 2 
	GOTO        L_can_read266
;lib_can.h,570 :: 		PIR3.RXB1IF = 0;     //EN MODO 0, LIMPIA BUFFER BX1
	BCF         PIR3+0, 1 
	GOTO        L_can_read267
L_can_read266:
;lib_can.h,572 :: 		PIR3.RXB1IF = 0;     //MODO 1 y 2, ESTE BIT SIRVE PARA N BUFFERS
	BCF         PIR3+0, 1 
L_can_read267:
L_can_read265:
;lib_can.h,575 :: 		if(can.mode == CAN_MODE_LEGACY){
	MOVF        _can+14, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_can_read268
;lib_can.h,576 :: 		CANCON &= 0xF1;
	MOVLW       241
	ANDWF       CANCON+0, 1 
;lib_can.h,577 :: 		CANCON |= 0x00;   //BITS WIN, LISTEN BUFFER0
;lib_can.h,578 :: 		}else{
	GOTO        L_can_read269
L_can_read268:
;lib_can.h,579 :: 		ECANCON &= 0xE0;
	MOVLW       224
	ANDWF       ECANCON+0, 1 
;lib_can.h,580 :: 		ECANCON |= 0x16;  //BITS EWIN, RX0 INTERRUPT
	MOVLW       22
	IORWF       ECANCON+0, 1 
;lib_can.h,581 :: 		}
L_can_read269:
;lib_can.h,583 :: 		if(!can.rxRequest)
	MOVF        _can+105, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_can_read270
;lib_can.h,584 :: 		return CAN_RW_DATA;      //Datos en buffer
	MOVLW       1
	MOVWF       R0 
	GOTO        L_end_can_read
L_can_read270:
;lib_can.h,586 :: 		return CAN_RW_REQUEST;    //Peticion solicitada
	MOVLW       2
	MOVWF       R0 
;lib_can.h,587 :: 		}
L_end_can_read:
	RETURN      0
; end of _can_read

_can_write:

;lib_can.h,589 :: 		bool can_write(long id, char *datos, char size, char priority, bool rtr){
;lib_can.h,595 :: 		if(!TXB0CON.TXREQ){
	BTFSC       TXB0CON+0, 3 
	GOTO        L_can_write272
;lib_can.h,596 :: 		transmisor = &TXB0CON;
	MOVLW       TXB0CON+0
	MOVWF       can_write_transmisor_L0+0 
	MOVLW       hi_addr(TXB0CON+0)
	MOVWF       can_write_transmisor_L0+1 
;lib_can.h,597 :: 		mascara = &TXB0EIDL;
	MOVLW       TXB0EIDL+0
	MOVWF       can_write_mascara_L0+0 
	MOVLW       hi_addr(TXB0EIDL+0)
	MOVWF       can_write_mascara_L0+1 
;lib_can.h,598 :: 		regLen = &TXB0DLC;
	MOVLW       TXB0DLC+0
	MOVWF       can_write_regLen_L0+0 
	MOVLW       hi_addr(TXB0DLC+0)
	MOVWF       can_write_regLen_L0+1 
;lib_can.h,599 :: 		buffer = &TXB0D0;
	MOVLW       TXB0D0+0
	MOVWF       can_write_buffer_L0+0 
	MOVLW       hi_addr(TXB0D0+0)
	MOVWF       can_write_buffer_L0+1 
;lib_can.h,600 :: 		ref = can.mode == CAN_MODE_LEGACY? 0x08:0x03;
	MOVF        _can+14, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_can_write273
	MOVLW       8
	MOVWF       ?FLOC___can_writeT1013+0 
	GOTO        L_can_write274
L_can_write273:
	MOVLW       3
	MOVWF       ?FLOC___can_writeT1013+0 
L_can_write274:
	MOVF        ?FLOC___can_writeT1013+0, 0 
	MOVWF       can_write_ref_L0+0 
;lib_can.h,601 :: 		}else if(!TXB1CON.TXREQ){
	GOTO        L_can_write275
L_can_write272:
	BTFSC       TXB1CON+0, 3 
	GOTO        L_can_write276
;lib_can.h,602 :: 		transmisor = &TXB1CON;
	MOVLW       TXB1CON+0
	MOVWF       can_write_transmisor_L0+0 
	MOVLW       hi_addr(TXB1CON+0)
	MOVWF       can_write_transmisor_L0+1 
;lib_can.h,603 :: 		mascara = &TXB1EIDL;
	MOVLW       TXB1EIDL+0
	MOVWF       can_write_mascara_L0+0 
	MOVLW       hi_addr(TXB1EIDL+0)
	MOVWF       can_write_mascara_L0+1 
;lib_can.h,604 :: 		regLen = &TXB1DLC;
	MOVLW       TXB1DLC+0
	MOVWF       can_write_regLen_L0+0 
	MOVLW       hi_addr(TXB1DLC+0)
	MOVWF       can_write_regLen_L0+1 
;lib_can.h,605 :: 		buffer = &TXB1D0;
	MOVLW       TXB1D0+0
	MOVWF       can_write_buffer_L0+0 
	MOVLW       hi_addr(TXB1D0+0)
	MOVWF       can_write_buffer_L0+1 
;lib_can.h,606 :: 		ref = can.mode == CAN_MODE_LEGACY? 0x06:0x04;
	MOVF        _can+14, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_can_write277
	MOVLW       6
	MOVWF       ?FLOC___can_writeT1021+0 
	GOTO        L_can_write278
L_can_write277:
	MOVLW       4
	MOVWF       ?FLOC___can_writeT1021+0 
L_can_write278:
	MOVF        ?FLOC___can_writeT1021+0, 0 
	MOVWF       can_write_ref_L0+0 
;lib_can.h,607 :: 		}else if(!TXB2CON.TXREQ){
	GOTO        L_can_write279
L_can_write276:
	BTFSC       TXB2CON+0, 3 
	GOTO        L_can_write280
;lib_can.h,608 :: 		transmisor = &TXB2CON;
	MOVLW       TXB2CON+0
	MOVWF       can_write_transmisor_L0+0 
	MOVLW       hi_addr(TXB2CON+0)
	MOVWF       can_write_transmisor_L0+1 
;lib_can.h,609 :: 		mascara = &TXB2EIDL;
	MOVLW       TXB2EIDL+0
	MOVWF       can_write_mascara_L0+0 
	MOVLW       hi_addr(TXB2EIDL+0)
	MOVWF       can_write_mascara_L0+1 
;lib_can.h,610 :: 		regLen = &TXB2DLC;
	MOVLW       TXB2DLC+0
	MOVWF       can_write_regLen_L0+0 
	MOVLW       hi_addr(TXB2DLC+0)
	MOVWF       can_write_regLen_L0+1 
;lib_can.h,611 :: 		buffer = &TXB2D0;
	MOVLW       TXB2D0+0
	MOVWF       can_write_buffer_L0+0 
	MOVLW       hi_addr(TXB2D0+0)
	MOVWF       can_write_buffer_L0+1 
;lib_can.h,612 :: 		ref = can.mode == CAN_MODE_LEGACY? 0x04:0x05;
	MOVF        _can+14, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_can_write281
	MOVLW       4
	MOVWF       ?FLOC___can_writeT1029+0 
	GOTO        L_can_write282
L_can_write281:
	MOVLW       5
	MOVWF       ?FLOC___can_writeT1029+0 
L_can_write282:
	MOVF        ?FLOC___can_writeT1029+0, 0 
	MOVWF       can_write_ref_L0+0 
;lib_can.h,613 :: 		}else if(can.mode == CAN_MODE_LEGACY){
	GOTO        L_can_write283
L_can_write280:
	MOVF        _can+14, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_can_write284
;lib_can.h,614 :: 		return false;  //No encontro a nadie para enviar en modo legacy
	CLRF        R0 
	GOTO        L_end_can_write
;lib_can.h,615 :: 		}
L_can_write284:
L_can_write283:
L_can_write279:
L_can_write275:
;lib_can.h,617 :: 		if(can.mode == CAN_MODE_LEGACY){
	MOVF        _can+14, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_can_write285
;lib_can.h,619 :: 		CANCON &= 0xF1;
	MOVLW       241
	ANDWF       CANCON+0, 1 
;lib_can.h,620 :: 		CANCON |= ref;   //BITS WIN
	MOVF        can_write_ref_L0+0, 0 
	IORWF       CANCON+0, 1 
;lib_can.h,621 :: 		}else{  //MODO 1 Y 2
	GOTO        L_can_write286
L_can_write285:
;lib_can.h,623 :: 		if(BSEL0.B0TXEN && !B0CON.TXREQ){
	BTFSS       BSEL0+0, 2 
	GOTO        L_can_write289
	BTFSC       B0CON+0, 3 
	GOTO        L_can_write289
L__can_write983:
;lib_can.h,624 :: 		transmisor = &B0CON;
	MOVLW       B0CON+0
	MOVWF       can_write_transmisor_L0+0 
	MOVLW       hi_addr(B0CON+0)
	MOVWF       can_write_transmisor_L0+1 
;lib_can.h,625 :: 		mascara = &B0EIDL;
	MOVLW       B0EIDL+0
	MOVWF       can_write_mascara_L0+0 
	MOVLW       hi_addr(B0EIDL+0)
	MOVWF       can_write_mascara_L0+1 
;lib_can.h,626 :: 		regLen = &B0DLC;
	MOVLW       B0DLC+0
	MOVWF       can_write_regLen_L0+0 
	MOVLW       hi_addr(B0DLC+0)
	MOVWF       can_write_regLen_L0+1 
;lib_can.h,627 :: 		buffer = &B0D0;
	MOVLW       B0D0+0
	MOVWF       can_write_buffer_L0+0 
	MOVLW       hi_addr(B0D0+0)
	MOVWF       can_write_buffer_L0+1 
;lib_can.h,628 :: 		ref = 0x12;
	MOVLW       18
	MOVWF       can_write_ref_L0+0 
;lib_can.h,629 :: 		}else if(BSEL0.B1TXEN && !B1CON.TXREQ){
	GOTO        L_can_write290
L_can_write289:
	BTFSS       BSEL0+0, 3 
	GOTO        L_can_write293
	BTFSC       B1CON+0, 3 
	GOTO        L_can_write293
L__can_write982:
;lib_can.h,630 :: 		transmisor = &B1CON;
	MOVLW       B1CON+0
	MOVWF       can_write_transmisor_L0+0 
	MOVLW       hi_addr(B1CON+0)
	MOVWF       can_write_transmisor_L0+1 
;lib_can.h,631 :: 		mascara = &B1EIDL;
	MOVLW       B1EIDL+0
	MOVWF       can_write_mascara_L0+0 
	MOVLW       hi_addr(B1EIDL+0)
	MOVWF       can_write_mascara_L0+1 
;lib_can.h,632 :: 		regLen = &B1DLC;
	MOVLW       B1DLC+0
	MOVWF       can_write_regLen_L0+0 
	MOVLW       hi_addr(B1DLC+0)
	MOVWF       can_write_regLen_L0+1 
;lib_can.h,633 :: 		buffer = &B1D0;
	MOVLW       B1D0+0
	MOVWF       can_write_buffer_L0+0 
	MOVLW       hi_addr(B1D0+0)
	MOVWF       can_write_buffer_L0+1 
;lib_can.h,634 :: 		ref = 0x13;
	MOVLW       19
	MOVWF       can_write_ref_L0+0 
;lib_can.h,635 :: 		}else if(BSEL0.B2TXEN && !B2CON.TXREQ){
	GOTO        L_can_write294
L_can_write293:
	BTFSS       BSEL0+0, 4 
	GOTO        L_can_write297
	BTFSC       B2CON+0, 3 
	GOTO        L_can_write297
L__can_write981:
;lib_can.h,636 :: 		transmisor = &B2CON;
	MOVLW       B2CON+0
	MOVWF       can_write_transmisor_L0+0 
	MOVLW       hi_addr(B2CON+0)
	MOVWF       can_write_transmisor_L0+1 
;lib_can.h,637 :: 		mascara = &B2EIDL;
	MOVLW       B2EIDL+0
	MOVWF       can_write_mascara_L0+0 
	MOVLW       hi_addr(B2EIDL+0)
	MOVWF       can_write_mascara_L0+1 
;lib_can.h,638 :: 		regLen = &B2DLC;
	MOVLW       B2DLC+0
	MOVWF       can_write_regLen_L0+0 
	MOVLW       hi_addr(B2DLC+0)
	MOVWF       can_write_regLen_L0+1 
;lib_can.h,639 :: 		buffer = &B2D0;
	MOVLW       B2D0+0
	MOVWF       can_write_buffer_L0+0 
	MOVLW       hi_addr(B2D0+0)
	MOVWF       can_write_buffer_L0+1 
;lib_can.h,640 :: 		ref = 0x14;
	MOVLW       20
	MOVWF       can_write_ref_L0+0 
;lib_can.h,641 :: 		}else if(BSEL0.B3TXEN && !B3CON.TXREQ){
	GOTO        L_can_write298
L_can_write297:
	BTFSS       BSEL0+0, 5 
	GOTO        L_can_write301
	BTFSC       B3CON+0, 3 
	GOTO        L_can_write301
L__can_write980:
;lib_can.h,642 :: 		transmisor = &B3CON;
	MOVLW       B3CON+0
	MOVWF       can_write_transmisor_L0+0 
	MOVLW       hi_addr(B3CON+0)
	MOVWF       can_write_transmisor_L0+1 
;lib_can.h,643 :: 		mascara = &B3EIDL;
	MOVLW       B3EIDL+0
	MOVWF       can_write_mascara_L0+0 
	MOVLW       hi_addr(B3EIDL+0)
	MOVWF       can_write_mascara_L0+1 
;lib_can.h,644 :: 		regLen = &B3DLC;
	MOVLW       B3DLC+0
	MOVWF       can_write_regLen_L0+0 
	MOVLW       hi_addr(B3DLC+0)
	MOVWF       can_write_regLen_L0+1 
;lib_can.h,645 :: 		buffer = &B3D0;
	MOVLW       B3D0+0
	MOVWF       can_write_buffer_L0+0 
	MOVLW       hi_addr(B3D0+0)
	MOVWF       can_write_buffer_L0+1 
;lib_can.h,646 :: 		ref = 0x15;
	MOVLW       21
	MOVWF       can_write_ref_L0+0 
;lib_can.h,647 :: 		}else if(BSEL0.B4TXEN && !B4CON.TXREQ){
	GOTO        L_can_write302
L_can_write301:
	BTFSS       BSEL0+0, 6 
	GOTO        L_can_write305
	BTFSC       B4CON+0, 3 
	GOTO        L_can_write305
L__can_write979:
;lib_can.h,648 :: 		transmisor = &B4CON;
	MOVLW       B4CON+0
	MOVWF       can_write_transmisor_L0+0 
	MOVLW       hi_addr(B4CON+0)
	MOVWF       can_write_transmisor_L0+1 
;lib_can.h,649 :: 		mascara = &B4EIDL;
	MOVLW       B4EIDL+0
	MOVWF       can_write_mascara_L0+0 
	MOVLW       hi_addr(B4EIDL+0)
	MOVWF       can_write_mascara_L0+1 
;lib_can.h,650 :: 		regLen = &B4DLC;
	MOVLW       B4DLC+0
	MOVWF       can_write_regLen_L0+0 
	MOVLW       hi_addr(B4DLC+0)
	MOVWF       can_write_regLen_L0+1 
;lib_can.h,651 :: 		buffer = &B4D0;
	MOVLW       B4D0+0
	MOVWF       can_write_buffer_L0+0 
	MOVLW       hi_addr(B4D0+0)
	MOVWF       can_write_buffer_L0+1 
;lib_can.h,652 :: 		ref = 0x16;
	MOVLW       22
	MOVWF       can_write_ref_L0+0 
;lib_can.h,653 :: 		}else if(BSEL0.B5TXEN && !B5CON.TXREQ){
	GOTO        L_can_write306
L_can_write305:
	BTFSS       BSEL0+0, 7 
	GOTO        L_can_write309
	BTFSC       B5CON+0, 3 
	GOTO        L_can_write309
L__can_write978:
;lib_can.h,654 :: 		transmisor = &B5CON;
	MOVLW       B5CON+0
	MOVWF       can_write_transmisor_L0+0 
	MOVLW       hi_addr(B5CON+0)
	MOVWF       can_write_transmisor_L0+1 
;lib_can.h,655 :: 		mascara = &B5EIDL;
	MOVLW       B5EIDL+0
	MOVWF       can_write_mascara_L0+0 
	MOVLW       hi_addr(B5EIDL+0)
	MOVWF       can_write_mascara_L0+1 
;lib_can.h,656 :: 		regLen = &B5DLC;
	MOVLW       B5DLC+0
	MOVWF       can_write_regLen_L0+0 
	MOVLW       hi_addr(B5DLC+0)
	MOVWF       can_write_regLen_L0+1 
;lib_can.h,657 :: 		buffer = &B5D0;
	MOVLW       B5D0+0
	MOVWF       can_write_buffer_L0+0 
	MOVLW       hi_addr(B5D0+0)
	MOVWF       can_write_buffer_L0+1 
;lib_can.h,658 :: 		ref = 0x17;
	MOVLW       23
	MOVWF       can_write_ref_L0+0 
;lib_can.h,659 :: 		}else{
	GOTO        L_can_write310
L_can_write309:
;lib_can.h,660 :: 		return false;
	CLRF        R0 
	GOTO        L_end_can_write
;lib_can.h,661 :: 		}
L_can_write310:
L_can_write306:
L_can_write302:
L_can_write298:
L_can_write294:
L_can_write290:
;lib_can.h,663 :: 		ECANCON &= 0xE0;
	MOVLW       224
	ANDWF       ECANCON+0, 1 
;lib_can.h,664 :: 		ECANCON |= ref;     //BITS EWIN
	MOVF        can_write_ref_L0+0, 0 
	IORWF       ECANCON+0, 1 
;lib_can.h,665 :: 		}
L_can_write286:
;lib_can.h,668 :: 		(*transmisor).B0 = priority.B0;  //BIT TXPRI0
	MOVFF       can_write_transmisor_L0+0, FSR1
	MOVFF       can_write_transmisor_L0+1, FSR1H
	BTFSC       FARG_can_write_priority+0, 0 
	GOTO        L__can_write1182
	BCF         POSTINC1+0, 0 
	GOTO        L__can_write1183
L__can_write1182:
	BSF         POSTINC1+0, 0 
L__can_write1183:
;lib_can.h,669 :: 		(*transmisor).B1 = priority.B1;  //BIT TXPRI1
	MOVFF       can_write_transmisor_L0+0, FSR1
	MOVFF       can_write_transmisor_L0+1, FSR1H
	BTFSC       FARG_can_write_priority+0, 1 
	GOTO        L__can_write1184
	BCF         POSTINC1+0, 1 
	GOTO        L__can_write1185
L__can_write1184:
	BSF         POSTINC1+0, 1 
L__can_write1185:
;lib_can.h,671 :: 		can_set_id(mascara, id);
	MOVF        can_write_mascara_L0+0, 0 
	MOVWF       FARG_can_set_id_address+0 
	MOVF        can_write_mascara_L0+1, 0 
	MOVWF       FARG_can_set_id_address+1 
	MOVF        FARG_can_write_id+0, 0 
	MOVWF       FARG_can_set_id_value+0 
	MOVF        FARG_can_write_id+1, 0 
	MOVWF       FARG_can_set_id_value+1 
	MOVF        FARG_can_write_id+2, 0 
	MOVWF       FARG_can_set_id_value+2 
	MOVF        FARG_can_write_id+3, 0 
	MOVWF       FARG_can_set_id_value+3 
	CALL        _can_set_id+0, 0
;lib_can.h,673 :: 		*regLen = size;
	MOVFF       can_write_regLen_L0+0, FSR1
	MOVFF       can_write_regLen_L0+1, FSR1H
	MOVF        FARG_can_write_size+0, 0 
	MOVWF       POSTINC1+0 
;lib_can.h,674 :: 		(*regLen).B6 = rtr; //TXRTR Solicitud remota del receptor
	MOVFF       can_write_regLen_L0+0, FSR1
	MOVFF       can_write_regLen_L0+1, FSR1H
	BTFSC       FARG_can_write_rtr+0, 0 
	GOTO        L__can_write1186
	BCF         POSTINC1+0, 6 
	GOTO        L__can_write1187
L__can_write1186:
	BSF         POSTINC1+0, 6 
L__can_write1187:
;lib_can.h,676 :: 		for(ref = 0; ref < size && ref < 8; ref++)
	CLRF        can_write_ref_L0+0 
L_can_write311:
	MOVF        FARG_can_write_size+0, 0 
	SUBWF       can_write_ref_L0+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_can_write312
	MOVLW       8
	SUBWF       can_write_ref_L0+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_can_write312
L__can_write977:
;lib_can.h,677 :: 		buffer[ref] = datos[ref];
	MOVF        can_write_ref_L0+0, 0 
	ADDWF       can_write_buffer_L0+0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      can_write_buffer_L0+1, 0 
	MOVWF       FSR1H 
	MOVF        can_write_ref_L0+0, 0 
	ADDWF       FARG_can_write_datos+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_can_write_datos+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       POSTINC1+0 
;lib_can.h,676 :: 		for(ref = 0; ref < size && ref < 8; ref++)
	INCF        can_write_ref_L0+0, 1 
;lib_can.h,677 :: 		buffer[ref] = datos[ref];
	GOTO        L_can_write311
L_can_write312:
;lib_can.h,679 :: 		(*transmisor).B3 = 1;  //ACTIVAR PIN TXREQ, LIMPIA BANDERAS TXABT, TXLARB y TXERR
	MOVFF       can_write_transmisor_L0+0, FSR1
	MOVFF       can_write_transmisor_L0+1, FSR1H
	BSF         POSTINC1+0, 3 
;lib_can.h,682 :: 		if(can.mode == CAN_MODE_LEGACY){
	MOVF        _can+14, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_can_write316
;lib_can.h,683 :: 		CANCON &= 0xF1;
	MOVLW       241
	ANDWF       CANCON+0, 1 
;lib_can.h,684 :: 		CANCON |= 0x00;   //BITS WIN, LISTEN BUFFER0
;lib_can.h,685 :: 		}else{
	GOTO        L_can_write317
L_can_write316:
;lib_can.h,686 :: 		ECANCON &= 0xE0;
	MOVLW       224
	ANDWF       ECANCON+0, 1 
;lib_can.h,687 :: 		ECANCON |= 0x16;  //BITS EWIN, RX0 INTERRUPT
	MOVLW       22
	IORWF       ECANCON+0, 1 
;lib_can.h,688 :: 		}
L_can_write317:
;lib_can.h,690 :: 		return true;
	MOVLW       1
	MOVWF       R0 
;lib_can.h,691 :: 		}
L_end_can_write:
	RETURN      0
; end of _can_write

_can_set_operation:

;lib_can.h,693 :: 		void can_set_operation(const char CAN_OPERATION){
;lib_can.h,694 :: 		CANCON.REQOP0 = CAN_OPERATION.B0;
	BTFSC       FARG_can_set_operation_CAN_OPERATION+0, 0 
	GOTO        L__can_set_operation1189
	BCF         CANCON+0, 5 
	GOTO        L__can_set_operation1190
L__can_set_operation1189:
	BSF         CANCON+0, 5 
L__can_set_operation1190:
;lib_can.h,695 :: 		CANCON.REQOP1 = CAN_OPERATION.B1;
	BTFSC       FARG_can_set_operation_CAN_OPERATION+0, 1 
	GOTO        L__can_set_operation1191
	BCF         CANCON+0, 6 
	GOTO        L__can_set_operation1192
L__can_set_operation1191:
	BSF         CANCON+0, 6 
L__can_set_operation1192:
;lib_can.h,696 :: 		CANCON.REQOP2 = CAN_OPERATION.B2;
	BTFSC       FARG_can_set_operation_CAN_OPERATION+0, 2 
	GOTO        L__can_set_operation1193
	BCF         CANCON+0, 7 
	GOTO        L__can_set_operation1194
L__can_set_operation1193:
	BSF         CANCON+0, 7 
L__can_set_operation1194:
;lib_can.h,698 :: 		while(CANSTAT.OPMODE0 != CANCON.REQOP0 ||
L_can_set_operation318:
;lib_can.h,699 :: 		CANSTAT.OPMODE1 != CANCON.REQOP1 ||
	BTFSC       CANSTAT+0, 5 
	GOTO        L__can_set_operation1195
	BTFSS       CANCON+0, 5 
	GOTO        L__can_set_operation1196
	GOTO        L__can_set_operation984
L__can_set_operation1195:
	BTFSS       CANCON+0, 5 
	GOTO        L__can_set_operation984
L__can_set_operation1196:
	BTFSC       CANSTAT+0, 6 
	GOTO        L__can_set_operation1197
	BTFSS       CANCON+0, 6 
	GOTO        L__can_set_operation1198
	GOTO        L__can_set_operation984
L__can_set_operation1197:
	BTFSS       CANCON+0, 6 
	GOTO        L__can_set_operation984
L__can_set_operation1198:
;lib_can.h,700 :: 		CANSTAT.OPMODE2 != CANCON.REQOP2);
	BTFSC       CANSTAT+0, 7 
	GOTO        L__can_set_operation1199
	BTFSS       CANCON+0, 7 
	GOTO        L__can_set_operation1200
	GOTO        L__can_set_operation984
L__can_set_operation1199:
	BTFSS       CANCON+0, 7 
	GOTO        L__can_set_operation984
L__can_set_operation1200:
	GOTO        L_can_set_operation319
L__can_set_operation984:
	GOTO        L_can_set_operation318
L_can_set_operation319:
;lib_can.h,701 :: 		}
L_end_can_set_operation:
	RETURN      0
; end of _can_set_operation

_can_set_mode:

;lib_can.h,703 :: 		void can_set_mode(const char CAN_MODE){
;lib_can.h,704 :: 		char modeAct = 0;
	CLRF        can_set_mode_modeAct_L0+0 
;lib_can.h,706 :: 		modeAct.B0 = CANSTAT.OPMODE0;
	BTFSC       CANSTAT+0, 5 
	GOTO        L__can_set_mode1202
	BCF         can_set_mode_modeAct_L0+0, 0 
	GOTO        L__can_set_mode1203
L__can_set_mode1202:
	BSF         can_set_mode_modeAct_L0+0, 0 
L__can_set_mode1203:
;lib_can.h,707 :: 		modeAct.B1 = CANSTAT.OPMODE1;
	BTFSC       CANSTAT+0, 6 
	GOTO        L__can_set_mode1204
	BCF         can_set_mode_modeAct_L0+0, 1 
	GOTO        L__can_set_mode1205
L__can_set_mode1204:
	BSF         can_set_mode_modeAct_L0+0, 1 
L__can_set_mode1205:
;lib_can.h,708 :: 		modeAct.B2 = CANSTAT.OPMODE2;
	BTFSC       CANSTAT+0, 7 
	GOTO        L__can_set_mode1206
	BCF         can_set_mode_modeAct_L0+0, 2 
	GOTO        L__can_set_mode1207
L__can_set_mode1206:
	BSF         can_set_mode_modeAct_L0+0, 2 
L__can_set_mode1207:
;lib_can.h,710 :: 		can_set_operation(CAN_OPERATION_CONFIG);  //Se debe poner se en modo config
	MOVLW       4
	MOVWF       FARG_can_set_operation_CAN_OPERATION+0 
	CALL        _can_set_operation+0, 0
;lib_can.h,711 :: 		ECANCON.MDSEL0 = CAN_MODE.B0;
	BTFSC       FARG_can_set_mode_CAN_MODE+0, 0 
	GOTO        L__can_set_mode1208
	BCF         ECANCON+0, 6 
	GOTO        L__can_set_mode1209
L__can_set_mode1208:
	BSF         ECANCON+0, 6 
L__can_set_mode1209:
;lib_can.h,712 :: 		ECANCON.MDSEL1 = CAN_MODE.B1;
	BTFSC       FARG_can_set_mode_CAN_MODE+0, 1 
	GOTO        L__can_set_mode1210
	BCF         ECANCON+0, 7 
	GOTO        L__can_set_mode1211
L__can_set_mode1210:
	BSF         ECANCON+0, 7 
L__can_set_mode1211:
;lib_can.h,713 :: 		can_set_operation(modeAct);
	MOVF        can_set_mode_modeAct_L0+0, 0 
	MOVWF       FARG_can_set_operation_CAN_OPERATION+0 
	CALL        _can_set_operation+0, 0
;lib_can.h,714 :: 		can.mode = CAN_MODE;
	MOVF        FARG_can_set_mode_CAN_MODE+0, 0 
	MOVWF       _can+14 
;lib_can.h,715 :: 		}
L_end_can_set_mode:
	RETURN      0
; end of _can_set_mode

_can_set_id:

;lib_can.h,717 :: 		void can_set_id(char *address, long value){
;lib_can.h,720 :: 		address[0] = getByte(value, 0);        //EIDL
	MOVFF       FARG_can_set_id_address+0, FSR1
	MOVFF       FARG_can_set_id_address+1, FSR1H
	MOVF        FARG_can_set_id_value+0, 0 
	MOVWF       POSTINC1+0 
;lib_can.h,721 :: 		address[-1] = getByte(value, 1);        //EIDh
	MOVLW       255
	ADDWF       FARG_can_set_id_address+0, 0 
	MOVWF       FSR1 
	MOVLW       255
	ADDWFC      FARG_can_set_id_address+1, 0 
	MOVWF       FSR1H 
	MOVF        FARG_can_set_id_value+1, 0 
	MOVWF       POSTINC1+0 
;lib_can.h,722 :: 		address[-2] = getByte(value, 2) & 0x03; //SIDL, BITS 16,17
	MOVLW       254
	ADDWF       FARG_can_set_id_address+0, 0 
	MOVWF       FSR1 
	MOVLW       255
	ADDWFC      FARG_can_set_id_address+1, 0 
	MOVWF       FSR1H 
	MOVLW       3
	ANDWF       FARG_can_set_id_value+2, 0 
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       POSTINC1+0 
;lib_can.h,723 :: 		address[-2].B3 = 1;   //ACEPT MESSAGE SEGUN EL FORMATO STAND Ó EXT
	MOVLW       254
	ADDWF       FARG_can_set_id_address+0, 0 
	MOVWF       FSR1 
	MOVLW       255
	ADDWFC      FARG_can_set_id_address+1, 0 
	MOVWF       FSR1H 
	BSF         POSTINC1+0, 3 
;lib_can.h,724 :: 		value <<= 3;         //RECORRE TRES POSIONES A LA IZQUIERDA
	MOVLW       3
	MOVWF       R0 
	MOVF        R0, 0 
L__can_set_id1213:
	BZ          L__can_set_id1214
	RLCF        FARG_can_set_id_value+0, 1 
	BCF         FARG_can_set_id_value+0, 0 
	RLCF        FARG_can_set_id_value+1, 1 
	RLCF        FARG_can_set_id_value+2, 1 
	RLCF        FARG_can_set_id_value+3, 1 
	ADDLW       255
	GOTO        L__can_set_id1213
L__can_set_id1214:
;lib_can.h,725 :: 		address[-2] |= getByte(value, 2) & 0xE0;//SIDL, BITS 18,19,20
	MOVLW       254
	ADDWF       FARG_can_set_id_address+0, 0 
	MOVWF       R1 
	MOVLW       255
	ADDWFC      FARG_can_set_id_address+1, 0 
	MOVWF       R2 
	MOVLW       224
	ANDWF       FARG_can_set_id_value+2, 0 
	MOVWF       R0 
	MOVFF       R1, FSR0
	MOVFF       R2, FSR0H
	MOVF        POSTINC0+0, 0 
	IORWF       R0, 1 
	MOVFF       R1, FSR1
	MOVFF       R2, FSR1H
	MOVF        R0, 0 
	MOVWF       POSTINC1+0 
;lib_can.h,726 :: 		address[-3] = getByte(value, 3);        //SIDH 21-27
	MOVLW       253
	ADDWF       FARG_can_set_id_address+0, 0 
	MOVWF       FSR1 
	MOVLW       255
	ADDWFC      FARG_can_set_id_address+1, 0 
	MOVWF       FSR1H 
	MOVF        FARG_can_set_id_value+3, 0 
	MOVWF       POSTINC1+0 
;lib_can.h,736 :: 		}
L_can_set_id323:
;lib_can.h,737 :: 		}
L_end_can_set_id:
	RETURN      0
; end of _can_set_id

_can_get_id:

;lib_can.h,739 :: 		long can_get_id(char *address){
;lib_can.h,740 :: 		long value = 0;
	CLRF        can_get_id_value_L0+0 
	CLRF        can_get_id_value_L0+1 
	CLRF        can_get_id_value_L0+2 
	CLRF        can_get_id_value_L0+3 
;lib_can.h,743 :: 		getByte(value,0) = address[0];        //EIDL
	MOVFF       FARG_can_get_id_address+0, FSR0
	MOVFF       FARG_can_get_id_address+1, FSR0H
	MOVF        POSTINC0+0, 0 
	MOVWF       can_get_id_value_L0+0 
;lib_can.h,744 :: 		getByte(value,1) = address[-1];        //EIDh
	MOVLW       255
	ADDWF       FARG_can_get_id_address+0, 0 
	MOVWF       FSR0 
	MOVLW       255
	ADDWFC      FARG_can_get_id_address+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       can_get_id_value_L0+1 
;lib_can.h,745 :: 		getByte(value,2) = address[-2] & 0x03; //SIDL, BITS 16,17
	MOVLW       254
	ADDWF       FARG_can_get_id_address+0, 0 
	MOVWF       R1 
	MOVLW       255
	ADDWFC      FARG_can_get_id_address+1, 0 
	MOVWF       R2 
	MOVFF       R1, FSR0
	MOVFF       R2, FSR0H
	MOVLW       3
	ANDWF       POSTINC0+0, 0 
	MOVWF       can_get_id_value_L0+2 
;lib_can.h,746 :: 		getByte(value,2).B2 = address[-2].B5;  //SIDL, BITS 18
	MOVFF       R1, FSR0
	MOVFF       R2, FSR0H
	MOVF        POSTINC0+0, 0 
	MOVWF       R0 
	BTFSC       R0, 5 
	GOTO        L__can_get_id1216
	BCF         can_get_id_value_L0+2, 2 
	GOTO        L__can_get_id1217
L__can_get_id1216:
	BSF         can_get_id_value_L0+2, 2 
L__can_get_id1217:
;lib_can.h,747 :: 		getByte(value,2).B3 = address[-2].B6;  //SIDL, BITS 19
	MOVFF       R1, FSR0
	MOVFF       R2, FSR0H
	MOVF        POSTINC0+0, 0 
	MOVWF       R0 
	BTFSC       R0, 6 
	GOTO        L__can_get_id1218
	BCF         can_get_id_value_L0+2, 3 
	GOTO        L__can_get_id1219
L__can_get_id1218:
	BSF         can_get_id_value_L0+2, 3 
L__can_get_id1219:
;lib_can.h,748 :: 		getByte(value,2).B4 = address[-2].B7;  //SIDL, BITS 20
	MOVFF       R1, FSR0
	MOVFF       R2, FSR0H
	MOVF        POSTINC0+0, 0 
	MOVWF       R0 
	BTFSC       R0, 7 
	GOTO        L__can_get_id1220
	BCF         can_get_id_value_L0+2, 4 
	GOTO        L__can_get_id1221
L__can_get_id1220:
	BSF         can_get_id_value_L0+2, 4 
L__can_get_id1221:
;lib_can.h,749 :: 		getByte(value,2).B5 = address[-3].B0;
	MOVLW       253
	ADDWF       FARG_can_get_id_address+0, 0 
	MOVWF       R1 
	MOVLW       255
	ADDWFC      FARG_can_get_id_address+1, 0 
	MOVWF       R2 
	MOVFF       R1, FSR0
	MOVFF       R2, FSR0H
	MOVF        POSTINC0+0, 0 
	MOVWF       R0 
	BTFSC       R0, 0 
	GOTO        L__can_get_id1222
	BCF         can_get_id_value_L0+2, 5 
	GOTO        L__can_get_id1223
L__can_get_id1222:
	BSF         can_get_id_value_L0+2, 5 
L__can_get_id1223:
;lib_can.h,750 :: 		getByte(value,2).B6 = address[-3].B1;
	MOVFF       R1, FSR0
	MOVFF       R2, FSR0H
	MOVF        POSTINC0+0, 0 
	MOVWF       R0 
	BTFSC       R0, 1 
	GOTO        L__can_get_id1224
	BCF         can_get_id_value_L0+2, 6 
	GOTO        L__can_get_id1225
L__can_get_id1224:
	BSF         can_get_id_value_L0+2, 6 
L__can_get_id1225:
;lib_can.h,751 :: 		getByte(value,2).B7 = address[-3].B2;
	MOVFF       R1, FSR0
	MOVFF       R2, FSR0H
	MOVF        POSTINC0+0, 0 
	MOVWF       R0 
	BTFSC       R0, 2 
	GOTO        L__can_get_id1226
	BCF         can_get_id_value_L0+2, 7 
	GOTO        L__can_get_id1227
L__can_get_id1226:
	BSF         can_get_id_value_L0+2, 7 
L__can_get_id1227:
;lib_can.h,752 :: 		getByte(value,3) = address[-3]>>3;     //SIDH
	MOVFF       R1, FSR0
	MOVFF       R2, FSR0H
	MOVF        POSTINC0+0, 0 
	MOVWF       R1 
	MOVF        R1, 0 
	MOVWF       can_get_id_value_L0+3 
	RRCF        can_get_id_value_L0+3, 1 
	BCF         can_get_id_value_L0+3, 7 
	RRCF        can_get_id_value_L0+3, 1 
	BCF         can_get_id_value_L0+3, 7 
	RRCF        can_get_id_value_L0+3, 1 
	BCF         can_get_id_value_L0+3, 7 
;lib_can.h,761 :: 		}
L_can_get_id325:
;lib_can.h,763 :: 		return value;
	MOVF        can_get_id_value_L0+0, 0 
	MOVWF       R0 
	MOVF        can_get_id_value_L0+1, 0 
	MOVWF       R1 
	MOVF        can_get_id_value_L0+2, 0 
	MOVWF       R2 
	MOVF        can_get_id_value_L0+3, 0 
	MOVWF       R3 
;lib_can.h,764 :: 		}
L_end_can_get_id:
	RETURN      0
; end of _can_get_id

_can_abort:

;lib_can.h,766 :: 		void can_abort(bool enable){
;lib_can.h,767 :: 		CANCON.ABAT = enable;
	BTFSC       FARG_can_abort_enable+0, 0 
	GOTO        L__can_abort1229
	BCF         CANCON+0, 4 
	GOTO        L__can_abort1230
L__can_abort1229:
	BSF         CANCON+0, 4 
L__can_abort1230:
;lib_can.h,768 :: 		}
L_end_can_abort:
	RETURN      0
; end of _can_abort

_can_interrupt:

;lib_can.h,770 :: 		void can_interrupt(bool enable, bool hihgPriprity){
;lib_can.h,773 :: 		PIR3.TXB0IF = 0;
	BCF         PIR3+0, 2 
;lib_can.h,774 :: 		PIR3.TXB1IF = 0;
	BCF         PIR3+0, 3 
;lib_can.h,775 :: 		PIR3.TXBnIF = 0;
	BCF         PIR3+0, 4 
;lib_can.h,778 :: 		IPR3.TXB0IP = hihgPriprity;
	BTFSC       FARG_can_interrupt_hihgPriprity+0, 0 
	GOTO        L__can_interrupt1232
	BCF         IPR3+0, 2 
	GOTO        L__can_interrupt1233
L__can_interrupt1232:
	BSF         IPR3+0, 2 
L__can_interrupt1233:
;lib_can.h,779 :: 		IPR3.TXB1IP = hihgPriprity;
	BTFSC       FARG_can_interrupt_hihgPriprity+0, 0 
	GOTO        L__can_interrupt1234
	BCF         IPR3+0, 3 
	GOTO        L__can_interrupt1235
L__can_interrupt1234:
	BSF         IPR3+0, 3 
L__can_interrupt1235:
;lib_can.h,780 :: 		IPR3.TXBnIP = hihgPriprity;
	BTFSC       FARG_can_interrupt_hihgPriprity+0, 0 
	GOTO        L__can_interrupt1236
	BCF         IPR3+0, 4 
	GOTO        L__can_interrupt1237
L__can_interrupt1236:
	BSF         IPR3+0, 4 
L__can_interrupt1237:
;lib_can.h,783 :: 		PIE3.TXB0IE = enable;
	BTFSC       FARG_can_interrupt_enable+0, 0 
	GOTO        L__can_interrupt1238
	BCF         PIE3+0, 2 
	GOTO        L__can_interrupt1239
L__can_interrupt1238:
	BSF         PIE3+0, 2 
L__can_interrupt1239:
;lib_can.h,784 :: 		PIE3.TXB1IE = enable;
	BTFSC       FARG_can_interrupt_enable+0, 0 
	GOTO        L__can_interrupt1240
	BCF         PIE3+0, 3 
	GOTO        L__can_interrupt1241
L__can_interrupt1240:
	BSF         PIE3+0, 3 
L__can_interrupt1241:
;lib_can.h,785 :: 		PIE3.TXBnIE = enable;
	BTFSC       FARG_can_interrupt_enable+0, 0 
	GOTO        L__can_interrupt1242
	BCF         PIE3+0, 4 
	GOTO        L__can_interrupt1243
L__can_interrupt1242:
	BSF         PIE3+0, 4 
L__can_interrupt1243:
;lib_can.h,792 :: 		}
L_end_can_interrupt:
	RETURN      0
; end of _can_interrupt

_can_desonexion:

;lib_can.h,794 :: 		void can_desonexion(){
;lib_can.h,795 :: 		if(can.conected){
	MOVF        _can+13, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_can_desonexion326
;lib_can.h,796 :: 		if(TXB0CON.TXERR || TXB1CON.TXERR || TXB2CON.TXERR){
	BTFSC       TXB0CON+0, 4 
	GOTO        L__can_desonexion985
	BTFSC       TXB1CON+0, 4 
	GOTO        L__can_desonexion985
	BTFSC       TXB2CON+0, 4 
	GOTO        L__can_desonexion985
	GOTO        L_can_desonexion329
L__can_desonexion985:
;lib_can.h,797 :: 		if(TXB0CON.TXERR) //!TXB0CON.TXABT
	BTFSS       TXB0CON+0, 4 
	GOTO        L_can_desonexion330
;lib_can.h,798 :: 		TXB0CON.TXREQ = 1;  //CANCELA ENVIO
	BSF         TXB0CON+0, 3 
L_can_desonexion330:
;lib_can.h,799 :: 		if(TXB1CON.TXERR) //!TXB1CON.TXABT
	BTFSS       TXB1CON+0, 4 
	GOTO        L_can_desonexion331
;lib_can.h,800 :: 		TXB1CON.TXREQ = 1;  //CANCELA ENVIO
	BSF         TXB1CON+0, 3 
L_can_desonexion331:
;lib_can.h,801 :: 		if(TXB2CON.TXERR) //!TXB2CON.TXABT
	BTFSS       TXB2CON+0, 4 
	GOTO        L_can_desonexion332
;lib_can.h,802 :: 		TXB2CON.TXREQ = 1;  //CANCELA ENVIO
	BSF         TXB2CON+0, 3 
L_can_desonexion332:
;lib_can.h,803 :: 		can.conected = false;
	CLRF        _can+13 
;lib_can.h,804 :: 		}
L_can_desonexion329:
;lib_can.h,805 :: 		}
L_can_desonexion326:
;lib_can.h,806 :: 		}
L_end_can_desonexion:
	RETURN      0
; end of _can_desonexion

_can_do_work:

;lib_can.h,808 :: 		void can_do_work(){
;lib_can.h,809 :: 		can_do_read_message();
	CALL        _can_do_read_message+0, 0
;lib_can.h,810 :: 		can_do_write_message();
	CALL        _can_do_write_message+0, 0
;lib_can.h,811 :: 		can_desonexion();
	CALL        _can_desonexion+0, 0
;lib_can.h,812 :: 		}
L_end_can_do_work:
	RETURN      0
; end of _can_do_work

_int_can:

;lib_can.h,814 :: 		void int_can(){
;lib_can.h,822 :: 		if(PIE3.TXB0IE && PIR3.TXB0IF){
	BTFSS       PIE3+0, 2 
	GOTO        L_int_can335
	BTFSS       PIR3+0, 2 
	GOTO        L_int_can335
L__int_can988:
;lib_can.h,823 :: 		can.conected.B0 = true;
	BSF         _can+13, 0 
;lib_can.h,824 :: 		PIR3.TXB0IF = 0;
	BCF         PIR3+0, 2 
;lib_can.h,825 :: 		}
L_int_can335:
;lib_can.h,826 :: 		if(PIE3.TXB1IE && PIR3.TXB1IF){
	BTFSS       PIE3+0, 3 
	GOTO        L_int_can338
	BTFSS       PIR3+0, 3 
	GOTO        L_int_can338
L__int_can987:
;lib_can.h,827 :: 		can.conected.B0 = true;
	BSF         _can+13, 0 
;lib_can.h,828 :: 		PIR3.TXB1IF = 0;
	BCF         PIR3+0, 3 
;lib_can.h,829 :: 		}
L_int_can338:
;lib_can.h,830 :: 		if(PIE3.TXBnIE && PIR3.TXBnIF){
	BTFSS       PIE3+0, 4 
	GOTO        L_int_can341
	BTFSS       PIR3+0, 4 
	GOTO        L_int_can341
L__int_can986:
;lib_can.h,831 :: 		can.conected.B0 = true;
	BSF         _can+13, 0 
;lib_can.h,832 :: 		PIR3.TXBnIF = 0;
	BCF         PIR3+0, 4 
;lib_can.h,833 :: 		}
L_int_can341:
;lib_can.h,834 :: 		}
L_end_int_can:
	RETURN      0
; end of _int_can

_DS1307_open:

;ds1307.h,50 :: 		void DS1307_open(){
;ds1307.h,51 :: 		Soft_I2C_Init();         //Initialize Soft I2C communication
	CALL        _Soft_I2C_Init+0, 0
;ds1307.h,52 :: 		}
L_end_DS1307_open:
	RETURN      0
; end of _DS1307_open

_DS1307_write:

;ds1307.h,54 :: 		void DS1307_write(DS1307 *myDS, char DOW, char HH, char MM, char SS, char DD, char MTH, char YY){
;ds1307.h,56 :: 		Soft_I2C_Start();               // Issue start signal
	CALL        _Soft_I2C_Start+0, 0
;ds1307.h,57 :: 		Soft_I2C_Write(DS1307_ADDRESS); // Address DS1307, see DS1307 datasheet
	MOVLW       208
	MOVWF       FARG_Soft_I2C_Write_data_+0 
	CALL        _Soft_I2C_Write+0, 0
;ds1307.h,58 :: 		Soft_I2C_Write(0x00);           // Start from address 0
	CLRF        FARG_Soft_I2C_Write_data_+0 
	CALL        _Soft_I2C_Write+0, 0
;ds1307.h,61 :: 		Soft_I2C_Write(decToBcd(SS));   //Segundos
	MOVF        FARG_DS1307_write_SS+0, 0 
	MOVWF       FARG_decToBcd_dato+0 
	CALL        _decToBcd+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_Soft_I2C_Write_data_+0 
	CALL        _Soft_I2C_Write+0, 0
;ds1307.h,62 :: 		Soft_I2C_Write(decToBcd(MM));   //Minutos
	MOVF        FARG_DS1307_write_MM+0, 0 
	MOVWF       FARG_decToBcd_dato+0 
	CALL        _decToBcd+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_Soft_I2C_Write_data_+0 
	CALL        _Soft_I2C_Write+0, 0
;ds1307.h,63 :: 		Soft_I2C_Write(decToBcd(HH));   //Horas
	MOVF        FARG_DS1307_write_HH+0, 0 
	MOVWF       FARG_decToBcd_dato+0 
	CALL        _decToBcd+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_Soft_I2C_Write_data_+0 
	CALL        _Soft_I2C_Write+0, 0
;ds1307.h,64 :: 		Soft_I2C_Write(decToBcd(DOW));  //Dia del mes
	MOVF        FARG_DS1307_write_DOW+0, 0 
	MOVWF       FARG_decToBcd_dato+0 
	CALL        _decToBcd+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_Soft_I2C_Write_data_+0 
	CALL        _Soft_I2C_Write+0, 0
;ds1307.h,65 :: 		Soft_I2C_Write(decToBcd(DD));   //Dia del mes
	MOVF        FARG_DS1307_write_DD+0, 0 
	MOVWF       FARG_decToBcd_dato+0 
	CALL        _decToBcd+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_Soft_I2C_Write_data_+0 
	CALL        _Soft_I2C_Write+0, 0
;ds1307.h,66 :: 		Soft_I2C_Write(decToBcd(MTH));  //Mes
	MOVF        FARG_DS1307_write_MTH+0, 0 
	MOVWF       FARG_decToBcd_dato+0 
	CALL        _decToBcd+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_Soft_I2C_Write_data_+0 
	CALL        _Soft_I2C_Write+0, 0
;ds1307.h,67 :: 		Soft_I2C_Write(decToBcd(YY));   //Año
	MOVF        FARG_DS1307_write_YY+0, 0 
	MOVWF       FARG_decToBcd_dato+0 
	CALL        _decToBcd+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_Soft_I2C_Write_data_+0 
	CALL        _Soft_I2C_Write+0, 0
;ds1307.h,68 :: 		Soft_I2C_Write(0x80);           //Register SQW
	MOVLW       128
	MOVWF       FARG_Soft_I2C_Write_data_+0 
	CALL        _Soft_I2C_Write+0, 0
;ds1307.h,69 :: 		Soft_I2C_Stop();                // Issue stop signal
	CALL        _Soft_I2C_Stop+0, 0
;ds1307.h,72 :: 		myDS->seconds = SS;
	MOVFF       FARG_DS1307_write_myDS+0, FSR1
	MOVFF       FARG_DS1307_write_myDS+1, FSR1H
	MOVF        FARG_DS1307_write_SS+0, 0 
	MOVWF       POSTINC1+0 
;ds1307.h,73 :: 		myDS->minutes = MM;
	MOVLW       1
	ADDWF       FARG_DS1307_write_myDS+0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      FARG_DS1307_write_myDS+1, 0 
	MOVWF       FSR1H 
	MOVF        FARG_DS1307_write_MM+0, 0 
	MOVWF       POSTINC1+0 
;ds1307.h,74 :: 		myDS->hours = HH;
	MOVLW       2
	ADDWF       FARG_DS1307_write_myDS+0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      FARG_DS1307_write_myDS+1, 0 
	MOVWF       FSR1H 
	MOVF        FARG_DS1307_write_HH+0, 0 
	MOVWF       POSTINC1+0 
;ds1307.h,75 :: 		myDS->dayOfWeek = DOW;
	MOVLW       3
	ADDWF       FARG_DS1307_write_myDS+0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      FARG_DS1307_write_myDS+1, 0 
	MOVWF       FSR1H 
	MOVF        FARG_DS1307_write_DOW+0, 0 
	MOVWF       POSTINC1+0 
;ds1307.h,76 :: 		myDS->day = DD;
	MOVLW       4
	ADDWF       FARG_DS1307_write_myDS+0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      FARG_DS1307_write_myDS+1, 0 
	MOVWF       FSR1H 
	MOVF        FARG_DS1307_write_DD+0, 0 
	MOVWF       POSTINC1+0 
;ds1307.h,77 :: 		myDS->month = MTH;
	MOVLW       5
	ADDWF       FARG_DS1307_write_myDS+0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      FARG_DS1307_write_myDS+1, 0 
	MOVWF       FSR1H 
	MOVF        FARG_DS1307_write_MTH+0, 0 
	MOVWF       POSTINC1+0 
;ds1307.h,78 :: 		myDS->year = YY;
	MOVLW       6
	ADDWF       FARG_DS1307_write_myDS+0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      FARG_DS1307_write_myDS+1, 0 
	MOVWF       FSR1H 
	MOVF        FARG_DS1307_write_YY+0, 0 
	MOVWF       POSTINC1+0 
;ds1307.h,81 :: 		DS1307_date(myDS, true);
	MOVF        FARG_DS1307_write_myDS+0, 0 
	MOVWF       FARG_DS1307_date_myDS+0 
	MOVF        FARG_DS1307_write_myDS+1, 0 
	MOVWF       FARG_DS1307_date_myDS+1 
	MOVLW       1
	MOVWF       FARG_DS1307_date_formatComplet+0 
	CALL        _DS1307_date+0, 0
;ds1307.h,82 :: 		}
L_end_DS1307_write:
	RETURN      0
; end of _DS1307_write

_DS1307_write_string:

;ds1307.h,84 :: 		bool DS1307_write_string(DS1307 *myDS, char *date){
;ds1307.h,86 :: 		if(string_len(date) != 13 || !string_isNumeric(date))
	MOVF        FARG_DS1307_write_string_date+0, 0 
	MOVWF       FARG_string_len_texto+0 
	MOVF        FARG_DS1307_write_string_date+1, 0 
	MOVWF       FARG_string_len_texto+1 
	CALL        _string_len+0, 0
	MOVF        R0, 0 
	XORLW       13
	BTFSS       STATUS+0, 2 
	GOTO        L__DS1307_write_string989
	MOVF        FARG_DS1307_write_string_date+0, 0 
	MOVWF       FARG_string_isNumeric_cadena+0 
	MOVF        FARG_DS1307_write_string_date+1, 0 
	MOVWF       FARG_string_isNumeric_cadena+1 
	CALL        _string_isNumeric+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L__DS1307_write_string989
	GOTO        L_DS1307_write_string344
L__DS1307_write_string989:
;ds1307.h,87 :: 		return false;
	CLRF        R0 
	GOTO        L_end_DS1307_write_string
L_DS1307_write_string344:
;ds1307.h,90 :: 		myDS->dayOfWeek = stringToNumN(&date[0], 1);
	MOVLW       3
	ADDWF       FARG_DS1307_write_string_myDS+0, 0 
	MOVWF       FLOC__DS1307_write_string+0 
	MOVLW       0
	ADDWFC      FARG_DS1307_write_string_myDS+1, 0 
	MOVWF       FLOC__DS1307_write_string+1 
	MOVF        FARG_DS1307_write_string_date+0, 0 
	MOVWF       FARG_stringToNumN_cadena+0 
	MOVF        FARG_DS1307_write_string_date+1, 0 
	MOVWF       FARG_stringToNumN_cadena+1 
	MOVLW       1
	MOVWF       FARG_stringToNumN_size+0 
	CALL        _stringToNumN+0, 0
	MOVFF       FLOC__DS1307_write_string+0, FSR1
	MOVFF       FLOC__DS1307_write_string+1, FSR1H
	MOVF        R0, 0 
	MOVWF       POSTINC1+0 
;ds1307.h,91 :: 		myDS->hours = stringToNumN(&date[1], 2);
	MOVLW       2
	ADDWF       FARG_DS1307_write_string_myDS+0, 0 
	MOVWF       FLOC__DS1307_write_string+0 
	MOVLW       0
	ADDWFC      FARG_DS1307_write_string_myDS+1, 0 
	MOVWF       FLOC__DS1307_write_string+1 
	MOVLW       1
	ADDWF       FARG_DS1307_write_string_date+0, 0 
	MOVWF       FARG_stringToNumN_cadena+0 
	MOVLW       0
	ADDWFC      FARG_DS1307_write_string_date+1, 0 
	MOVWF       FARG_stringToNumN_cadena+1 
	MOVLW       2
	MOVWF       FARG_stringToNumN_size+0 
	CALL        _stringToNumN+0, 0
	MOVFF       FLOC__DS1307_write_string+0, FSR1
	MOVFF       FLOC__DS1307_write_string+1, FSR1H
	MOVF        R0, 0 
	MOVWF       POSTINC1+0 
;ds1307.h,92 :: 		myDs->minutes = stringToNumN(&date[3], 2);
	MOVLW       1
	ADDWF       FARG_DS1307_write_string_myDS+0, 0 
	MOVWF       FLOC__DS1307_write_string+0 
	MOVLW       0
	ADDWFC      FARG_DS1307_write_string_myDS+1, 0 
	MOVWF       FLOC__DS1307_write_string+1 
	MOVLW       3
	ADDWF       FARG_DS1307_write_string_date+0, 0 
	MOVWF       FARG_stringToNumN_cadena+0 
	MOVLW       0
	ADDWFC      FARG_DS1307_write_string_date+1, 0 
	MOVWF       FARG_stringToNumN_cadena+1 
	MOVLW       2
	MOVWF       FARG_stringToNumN_size+0 
	CALL        _stringToNumN+0, 0
	MOVFF       FLOC__DS1307_write_string+0, FSR1
	MOVFF       FLOC__DS1307_write_string+1, FSR1H
	MOVF        R0, 0 
	MOVWF       POSTINC1+0 
;ds1307.h,93 :: 		myDS->seconds = stringToNumN(&date[5], 2);
	MOVF        FARG_DS1307_write_string_myDS+0, 0 
	MOVWF       FLOC__DS1307_write_string+0 
	MOVF        FARG_DS1307_write_string_myDS+1, 0 
	MOVWF       FLOC__DS1307_write_string+1 
	MOVLW       5
	ADDWF       FARG_DS1307_write_string_date+0, 0 
	MOVWF       FARG_stringToNumN_cadena+0 
	MOVLW       0
	ADDWFC      FARG_DS1307_write_string_date+1, 0 
	MOVWF       FARG_stringToNumN_cadena+1 
	MOVLW       2
	MOVWF       FARG_stringToNumN_size+0 
	CALL        _stringToNumN+0, 0
	MOVFF       FLOC__DS1307_write_string+0, FSR1
	MOVFF       FLOC__DS1307_write_string+1, FSR1H
	MOVF        R0, 0 
	MOVWF       POSTINC1+0 
;ds1307.h,94 :: 		myDS->day = stringToNumN(&date[7], 2);
	MOVLW       4
	ADDWF       FARG_DS1307_write_string_myDS+0, 0 
	MOVWF       FLOC__DS1307_write_string+0 
	MOVLW       0
	ADDWFC      FARG_DS1307_write_string_myDS+1, 0 
	MOVWF       FLOC__DS1307_write_string+1 
	MOVLW       7
	ADDWF       FARG_DS1307_write_string_date+0, 0 
	MOVWF       FARG_stringToNumN_cadena+0 
	MOVLW       0
	ADDWFC      FARG_DS1307_write_string_date+1, 0 
	MOVWF       FARG_stringToNumN_cadena+1 
	MOVLW       2
	MOVWF       FARG_stringToNumN_size+0 
	CALL        _stringToNumN+0, 0
	MOVFF       FLOC__DS1307_write_string+0, FSR1
	MOVFF       FLOC__DS1307_write_string+1, FSR1H
	MOVF        R0, 0 
	MOVWF       POSTINC1+0 
;ds1307.h,95 :: 		myDS->month = stringToNumN(&date[9], 2);
	MOVLW       5
	ADDWF       FARG_DS1307_write_string_myDS+0, 0 
	MOVWF       FLOC__DS1307_write_string+0 
	MOVLW       0
	ADDWFC      FARG_DS1307_write_string_myDS+1, 0 
	MOVWF       FLOC__DS1307_write_string+1 
	MOVLW       9
	ADDWF       FARG_DS1307_write_string_date+0, 0 
	MOVWF       FARG_stringToNumN_cadena+0 
	MOVLW       0
	ADDWFC      FARG_DS1307_write_string_date+1, 0 
	MOVWF       FARG_stringToNumN_cadena+1 
	MOVLW       2
	MOVWF       FARG_stringToNumN_size+0 
	CALL        _stringToNumN+0, 0
	MOVFF       FLOC__DS1307_write_string+0, FSR1
	MOVFF       FLOC__DS1307_write_string+1, FSR1H
	MOVF        R0, 0 
	MOVWF       POSTINC1+0 
;ds1307.h,96 :: 		myDS->year = stringToNumN(&date[11], 2);
	MOVLW       6
	ADDWF       FARG_DS1307_write_string_myDS+0, 0 
	MOVWF       FLOC__DS1307_write_string+0 
	MOVLW       0
	ADDWFC      FARG_DS1307_write_string_myDS+1, 0 
	MOVWF       FLOC__DS1307_write_string+1 
	MOVLW       11
	ADDWF       FARG_DS1307_write_string_date+0, 0 
	MOVWF       FARG_stringToNumN_cadena+0 
	MOVLW       0
	ADDWFC      FARG_DS1307_write_string_date+1, 0 
	MOVWF       FARG_stringToNumN_cadena+1 
	MOVLW       2
	MOVWF       FARG_stringToNumN_size+0 
	CALL        _stringToNumN+0, 0
	MOVFF       FLOC__DS1307_write_string+0, FSR1
	MOVFF       FLOC__DS1307_write_string+1, FSR1H
	MOVF        R0, 0 
	MOVWF       POSTINC1+0 
;ds1307.h,98 :: 		Soft_I2C_Start();               // Issue start signal
	CALL        _Soft_I2C_Start+0, 0
;ds1307.h,99 :: 		Soft_I2C_Write(DS1307_ADDRESS); // Address DS1307, see DS1307 datasheet
	MOVLW       208
	MOVWF       FARG_Soft_I2C_Write_data_+0 
	CALL        _Soft_I2C_Write+0, 0
;ds1307.h,100 :: 		Soft_I2C_Write(0x00);           // Start from address 0
	CLRF        FARG_Soft_I2C_Write_data_+0 
	CALL        _Soft_I2C_Write+0, 0
;ds1307.h,103 :: 		Soft_I2C_Write(decToBcd(myDS->seconds));   //Segundos
	MOVFF       FARG_DS1307_write_string_myDS+0, FSR0
	MOVFF       FARG_DS1307_write_string_myDS+1, FSR0H
	MOVF        POSTINC0+0, 0 
	MOVWF       FARG_decToBcd_dato+0 
	CALL        _decToBcd+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_Soft_I2C_Write_data_+0 
	CALL        _Soft_I2C_Write+0, 0
;ds1307.h,104 :: 		Soft_I2C_Write(decToBcd(myDS->minutes));   //Minutos
	MOVLW       1
	ADDWF       FARG_DS1307_write_string_myDS+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_DS1307_write_string_myDS+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       FARG_decToBcd_dato+0 
	CALL        _decToBcd+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_Soft_I2C_Write_data_+0 
	CALL        _Soft_I2C_Write+0, 0
;ds1307.h,105 :: 		Soft_I2C_Write(decToBcd(myDs->hours));     //Horas
	MOVLW       2
	ADDWF       FARG_DS1307_write_string_myDS+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_DS1307_write_string_myDS+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       FARG_decToBcd_dato+0 
	CALL        _decToBcd+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_Soft_I2C_Write_data_+0 
	CALL        _Soft_I2C_Write+0, 0
;ds1307.h,106 :: 		Soft_I2C_Write(decToBcd(myDS->dayOfWeek)); //Dia de la semana
	MOVLW       3
	ADDWF       FARG_DS1307_write_string_myDS+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_DS1307_write_string_myDS+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       FARG_decToBcd_dato+0 
	CALL        _decToBcd+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_Soft_I2C_Write_data_+0 
	CALL        _Soft_I2C_Write+0, 0
;ds1307.h,107 :: 		Soft_I2C_Write(decToBcd(myDS->day));       //Dia del mes
	MOVLW       4
	ADDWF       FARG_DS1307_write_string_myDS+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_DS1307_write_string_myDS+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       FARG_decToBcd_dato+0 
	CALL        _decToBcd+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_Soft_I2C_Write_data_+0 
	CALL        _Soft_I2C_Write+0, 0
;ds1307.h,108 :: 		Soft_I2C_Write(decToBcd(myDS->month));     //Mes
	MOVLW       5
	ADDWF       FARG_DS1307_write_string_myDS+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_DS1307_write_string_myDS+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       FARG_decToBcd_dato+0 
	CALL        _decToBcd+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_Soft_I2C_Write_data_+0 
	CALL        _Soft_I2C_Write+0, 0
;ds1307.h,109 :: 		Soft_I2C_Write(decToBcd(myDS->year));      //Año
	MOVLW       6
	ADDWF       FARG_DS1307_write_string_myDS+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_DS1307_write_string_myDS+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       FARG_decToBcd_dato+0 
	CALL        _decToBcd+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_Soft_I2C_Write_data_+0 
	CALL        _Soft_I2C_Write+0, 0
;ds1307.h,110 :: 		Soft_I2C_Write(0x80);                      //Register SQW
	MOVLW       128
	MOVWF       FARG_Soft_I2C_Write_data_+0 
	CALL        _Soft_I2C_Write+0, 0
;ds1307.h,111 :: 		Soft_I2C_Stop();                           // Issue stop signal
	CALL        _Soft_I2C_Stop+0, 0
;ds1307.h,114 :: 		DS1307_date(myDS, true);
	MOVF        FARG_DS1307_write_string_myDS+0, 0 
	MOVWF       FARG_DS1307_date_myDS+0 
	MOVF        FARG_DS1307_write_string_myDS+1, 0 
	MOVWF       FARG_DS1307_date_myDS+1 
	MOVLW       1
	MOVWF       FARG_DS1307_date_formatComplet+0 
	CALL        _DS1307_date+0, 0
;ds1307.h,115 :: 		}
L_end_DS1307_write_string:
	RETURN      0
; end of _DS1307_write_string

_DS1307_read:

;ds1307.h,117 :: 		char* DS1307_read(DS1307 *myDS, bool formatComplet){
;ds1307.h,118 :: 		Soft_I2C_Start();               // Issue start signal
	CALL        _Soft_I2C_Start+0, 0
;ds1307.h,119 :: 		Soft_I2C_Write(DS1307_ADDRESS); // Address DS1307, see DS1307 datasheet
	MOVLW       208
	MOVWF       FARG_Soft_I2C_Write_data_+0 
	CALL        _Soft_I2C_Write+0, 0
;ds1307.h,120 :: 		Soft_I2C_Write(0x00);           // Start from address 0
	CLRF        FARG_Soft_I2C_Write_data_+0 
	CALL        _Soft_I2C_Write+0, 0
;ds1307.h,121 :: 		Soft_I2C_Start();               // Issue repeated start signal
	CALL        _Soft_I2C_Start+0, 0
;ds1307.h,122 :: 		Soft_I2C_Write(DS1307_READ);    // Address DS1307 for reading R/W=1
	MOVLW       209
	MOVWF       FARG_Soft_I2C_Write_data_+0 
	CALL        _Soft_I2C_Write+0, 0
;ds1307.h,124 :: 		myDS->seconds = Soft_I2C_Read(DS1307_ACK);      // Read seconds
	MOVF        FARG_DS1307_read_myDS+0, 0 
	MOVWF       FLOC__DS1307_read+0 
	MOVF        FARG_DS1307_read_myDS+1, 0 
	MOVWF       FLOC__DS1307_read+1 
	MOVLW       1
	MOVWF       FARG_Soft_I2C_Read_ack+0 
	MOVLW       0
	MOVWF       FARG_Soft_I2C_Read_ack+1 
	CALL        _Soft_I2C_Read+0, 0
	MOVFF       FLOC__DS1307_read+0, FSR1
	MOVFF       FLOC__DS1307_read+1, FSR1H
	MOVF        R0, 0 
	MOVWF       POSTINC1+0 
;ds1307.h,125 :: 		myDS->minutes = Soft_I2C_Read(DS1307_ACK);      // Read minutes
	MOVLW       1
	ADDWF       FARG_DS1307_read_myDS+0, 0 
	MOVWF       FLOC__DS1307_read+0 
	MOVLW       0
	ADDWFC      FARG_DS1307_read_myDS+1, 0 
	MOVWF       FLOC__DS1307_read+1 
	MOVLW       1
	MOVWF       FARG_Soft_I2C_Read_ack+0 
	MOVLW       0
	MOVWF       FARG_Soft_I2C_Read_ack+1 
	CALL        _Soft_I2C_Read+0, 0
	MOVFF       FLOC__DS1307_read+0, FSR1
	MOVFF       FLOC__DS1307_read+1, FSR1H
	MOVF        R0, 0 
	MOVWF       POSTINC1+0 
;ds1307.h,126 :: 		myDS->hours = Soft_I2C_Read(DS1307_ACK);        // Read hours
	MOVLW       2
	ADDWF       FARG_DS1307_read_myDS+0, 0 
	MOVWF       FLOC__DS1307_read+0 
	MOVLW       0
	ADDWFC      FARG_DS1307_read_myDS+1, 0 
	MOVWF       FLOC__DS1307_read+1 
	MOVLW       1
	MOVWF       FARG_Soft_I2C_Read_ack+0 
	MOVLW       0
	MOVWF       FARG_Soft_I2C_Read_ack+1 
	CALL        _Soft_I2C_Read+0, 0
	MOVFF       FLOC__DS1307_read+0, FSR1
	MOVFF       FLOC__DS1307_read+1, FSR1H
	MOVF        R0, 0 
	MOVWF       POSTINC1+0 
;ds1307.h,127 :: 		myDS->dayOfWeek = Soft_I2C_Read(DS1307_ACK);    // Read day of week
	MOVLW       3
	ADDWF       FARG_DS1307_read_myDS+0, 0 
	MOVWF       FLOC__DS1307_read+0 
	MOVLW       0
	ADDWFC      FARG_DS1307_read_myDS+1, 0 
	MOVWF       FLOC__DS1307_read+1 
	MOVLW       1
	MOVWF       FARG_Soft_I2C_Read_ack+0 
	MOVLW       0
	MOVWF       FARG_Soft_I2C_Read_ack+1 
	CALL        _Soft_I2C_Read+0, 0
	MOVFF       FLOC__DS1307_read+0, FSR1
	MOVFF       FLOC__DS1307_read+1, FSR1H
	MOVF        R0, 0 
	MOVWF       POSTINC1+0 
;ds1307.h,128 :: 		myDS->day = Soft_I2C_Read(DS1307_ACK);          // Read day of month
	MOVLW       4
	ADDWF       FARG_DS1307_read_myDS+0, 0 
	MOVWF       FLOC__DS1307_read+0 
	MOVLW       0
	ADDWFC      FARG_DS1307_read_myDS+1, 0 
	MOVWF       FLOC__DS1307_read+1 
	MOVLW       1
	MOVWF       FARG_Soft_I2C_Read_ack+0 
	MOVLW       0
	MOVWF       FARG_Soft_I2C_Read_ack+1 
	CALL        _Soft_I2C_Read+0, 0
	MOVFF       FLOC__DS1307_read+0, FSR1
	MOVFF       FLOC__DS1307_read+1, FSR1H
	MOVF        R0, 0 
	MOVWF       POSTINC1+0 
;ds1307.h,129 :: 		myDS->month = Soft_I2C_Read(DS1307_ACK);        // Read mes del año
	MOVLW       5
	ADDWF       FARG_DS1307_read_myDS+0, 0 
	MOVWF       FLOC__DS1307_read+0 
	MOVLW       0
	ADDWFC      FARG_DS1307_read_myDS+1, 0 
	MOVWF       FLOC__DS1307_read+1 
	MOVLW       1
	MOVWF       FARG_Soft_I2C_Read_ack+0 
	MOVLW       0
	MOVWF       FARG_Soft_I2C_Read_ack+1 
	CALL        _Soft_I2C_Read+0, 0
	MOVFF       FLOC__DS1307_read+0, FSR1
	MOVFF       FLOC__DS1307_read+1, FSR1H
	MOVF        R0, 0 
	MOVWF       POSTINC1+0 
;ds1307.h,130 :: 		myDS->year = Soft_I2C_Read(DS1307_NO_ACK);      // Read years
	MOVLW       6
	ADDWF       FARG_DS1307_read_myDS+0, 0 
	MOVWF       FLOC__DS1307_read+0 
	MOVLW       0
	ADDWFC      FARG_DS1307_read_myDS+1, 0 
	MOVWF       FLOC__DS1307_read+1 
	CLRF        FARG_Soft_I2C_Read_ack+0 
	CLRF        FARG_Soft_I2C_Read_ack+1 
	CALL        _Soft_I2C_Read+0, 0
	MOVFF       FLOC__DS1307_read+0, FSR1
	MOVFF       FLOC__DS1307_read+1, FSR1H
	MOVF        R0, 0 
	MOVWF       POSTINC1+0 
;ds1307.h,131 :: 		Soft_I2C_Stop();                                // Issue stop signal
	CALL        _Soft_I2C_Stop+0, 0
;ds1307.h,134 :: 		myDS->seconds = bcdToDec(0x7F&myDS->seconds);   //Por el canal CH DS1307
	MOVF        FARG_DS1307_read_myDS+0, 0 
	MOVWF       FLOC__DS1307_read+0 
	MOVF        FARG_DS1307_read_myDS+1, 0 
	MOVWF       FLOC__DS1307_read+1 
	MOVFF       FARG_DS1307_read_myDS+0, FSR0
	MOVFF       FARG_DS1307_read_myDS+1, FSR0H
	MOVF        POSTINC0+0, 0 
	MOVWF       R0 
	MOVLW       127
	ANDWF       R0, 0 
	MOVWF       FARG_bcdToDec_dato+0 
	CALL        _bcdToDec+0, 0
	MOVFF       FLOC__DS1307_read+0, FSR1
	MOVFF       FLOC__DS1307_read+1, FSR1H
	MOVF        R0, 0 
	MOVWF       POSTINC1+0 
;ds1307.h,135 :: 		myDS->minutes = bcdToDec(myDS->minutes);
	MOVLW       1
	ADDWF       FARG_DS1307_read_myDS+0, 0 
	MOVWF       FLOC__DS1307_read+0 
	MOVLW       0
	ADDWFC      FARG_DS1307_read_myDS+1, 0 
	MOVWF       FLOC__DS1307_read+1 
	MOVFF       FLOC__DS1307_read+0, FSR0
	MOVFF       FLOC__DS1307_read+1, FSR0H
	MOVF        POSTINC0+0, 0 
	MOVWF       FARG_bcdToDec_dato+0 
	CALL        _bcdToDec+0, 0
	MOVFF       FLOC__DS1307_read+0, FSR1
	MOVFF       FLOC__DS1307_read+1, FSR1H
	MOVF        R0, 0 
	MOVWF       POSTINC1+0 
;ds1307.h,136 :: 		myDS->hours = bcdToDec(myDS->hours);
	MOVLW       2
	ADDWF       FARG_DS1307_read_myDS+0, 0 
	MOVWF       FLOC__DS1307_read+0 
	MOVLW       0
	ADDWFC      FARG_DS1307_read_myDS+1, 0 
	MOVWF       FLOC__DS1307_read+1 
	MOVFF       FLOC__DS1307_read+0, FSR0
	MOVFF       FLOC__DS1307_read+1, FSR0H
	MOVF        POSTINC0+0, 0 
	MOVWF       FARG_bcdToDec_dato+0 
	CALL        _bcdToDec+0, 0
	MOVFF       FLOC__DS1307_read+0, FSR1
	MOVFF       FLOC__DS1307_read+1, FSR1H
	MOVF        R0, 0 
	MOVWF       POSTINC1+0 
;ds1307.h,137 :: 		myDS->dayOfWeek = bcdToDec(myDS->dayOfWeek);
	MOVLW       3
	ADDWF       FARG_DS1307_read_myDS+0, 0 
	MOVWF       FLOC__DS1307_read+0 
	MOVLW       0
	ADDWFC      FARG_DS1307_read_myDS+1, 0 
	MOVWF       FLOC__DS1307_read+1 
	MOVFF       FLOC__DS1307_read+0, FSR0
	MOVFF       FLOC__DS1307_read+1, FSR0H
	MOVF        POSTINC0+0, 0 
	MOVWF       FARG_bcdToDec_dato+0 
	CALL        _bcdToDec+0, 0
	MOVFF       FLOC__DS1307_read+0, FSR1
	MOVFF       FLOC__DS1307_read+1, FSR1H
	MOVF        R0, 0 
	MOVWF       POSTINC1+0 
;ds1307.h,138 :: 		myDS->day = bcdToDec(myDS->daY);
	MOVLW       4
	ADDWF       FARG_DS1307_read_myDS+0, 0 
	MOVWF       FLOC__DS1307_read+0 
	MOVLW       0
	ADDWFC      FARG_DS1307_read_myDS+1, 0 
	MOVWF       FLOC__DS1307_read+1 
	MOVFF       FLOC__DS1307_read+0, FSR0
	MOVFF       FLOC__DS1307_read+1, FSR0H
	MOVF        POSTINC0+0, 0 
	MOVWF       FARG_bcdToDec_dato+0 
	CALL        _bcdToDec+0, 0
	MOVFF       FLOC__DS1307_read+0, FSR1
	MOVFF       FLOC__DS1307_read+1, FSR1H
	MOVF        R0, 0 
	MOVWF       POSTINC1+0 
;ds1307.h,139 :: 		myDS->month = bcdToDec(myDS->month);
	MOVLW       5
	ADDWF       FARG_DS1307_read_myDS+0, 0 
	MOVWF       FLOC__DS1307_read+0 
	MOVLW       0
	ADDWFC      FARG_DS1307_read_myDS+1, 0 
	MOVWF       FLOC__DS1307_read+1 
	MOVFF       FLOC__DS1307_read+0, FSR0
	MOVFF       FLOC__DS1307_read+1, FSR0H
	MOVF        POSTINC0+0, 0 
	MOVWF       FARG_bcdToDec_dato+0 
	CALL        _bcdToDec+0, 0
	MOVFF       FLOC__DS1307_read+0, FSR1
	MOVFF       FLOC__DS1307_read+1, FSR1H
	MOVF        R0, 0 
	MOVWF       POSTINC1+0 
;ds1307.h,140 :: 		myDS->year = bcdToDec(myDS->year);
	MOVLW       6
	ADDWF       FARG_DS1307_read_myDS+0, 0 
	MOVWF       FLOC__DS1307_read+0 
	MOVLW       0
	ADDWFC      FARG_DS1307_read_myDS+1, 0 
	MOVWF       FLOC__DS1307_read+1 
	MOVFF       FLOC__DS1307_read+0, FSR0
	MOVFF       FLOC__DS1307_read+1, FSR0H
	MOVF        POSTINC0+0, 0 
	MOVWF       FARG_bcdToDec_dato+0 
	CALL        _bcdToDec+0, 0
	MOVFF       FLOC__DS1307_read+0, FSR1
	MOVFF       FLOC__DS1307_read+1, FSR1H
	MOVF        R0, 0 
	MOVWF       POSTINC1+0 
;ds1307.h,143 :: 		DS1307_date(myDS, formatComplet);
	MOVF        FARG_DS1307_read_myDS+0, 0 
	MOVWF       FARG_DS1307_date_myDS+0 
	MOVF        FARG_DS1307_read_myDS+1, 0 
	MOVWF       FARG_DS1307_date_myDS+1 
	MOVF        FARG_DS1307_read_formatComplet+0, 0 
	MOVWF       FARG_DS1307_date_formatComplet+0 
	CALL        _DS1307_date+0, 0
;ds1307.h,145 :: 		return myDS->time;
	MOVLW       7
	ADDWF       FARG_DS1307_read_myDS+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      FARG_DS1307_read_myDS+1, 0 
	MOVWF       R1 
;ds1307.h,146 :: 		}
L_end_DS1307_read:
	RETURN      0
; end of _DS1307_read

_DS1307_date:

;ds1307.h,148 :: 		char* DS1307_date(DS1307 *myDS, bool formatComplet){
;ds1307.h,149 :: 		char cont = 0;
	CLRF        DS1307_date_cont_L0+0 
;ds1307.h,153 :: 		numToString(myDs->dayOfWeek, &myDs->time[cont++], 1);
	MOVLW       3
	ADDWF       FARG_DS1307_date_myDS+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_DS1307_date_myDS+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       FARG_numToString_valor+0 
	MOVLW       0
	MOVWF       FARG_numToString_valor+1 
	MOVWF       FARG_numToString_valor+2 
	MOVWF       FARG_numToString_valor+3 
	MOVLW       0
	MOVWF       FARG_numToString_valor+1 
	MOVWF       FARG_numToString_valor+2 
	MOVWF       FARG_numToString_valor+3 
	MOVLW       7
	ADDWF       FARG_DS1307_date_myDS+0, 0 
	MOVWF       FARG_numToString_cadena+0 
	MOVLW       0
	ADDWFC      FARG_DS1307_date_myDS+1, 0 
	MOVWF       FARG_numToString_cadena+1 
	MOVF        DS1307_date_cont_L0+0, 0 
	ADDWF       FARG_numToString_cadena+0, 1 
	MOVLW       0
	ADDWFC      FARG_numToString_cadena+1, 1 
	MOVLW       1
	MOVWF       FARG_numToString_digitos+0 
	CALL        _numToString+0, 0
	INCF        DS1307_date_cont_L0+0, 1 
;ds1307.h,154 :: 		if(formatComplet)
	MOVF        FARG_DS1307_date_formatComplet+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_DS1307_date345
;ds1307.h,155 :: 		myDS->time[cont++] = '-';
	MOVLW       7
	ADDWF       FARG_DS1307_date_myDS+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      FARG_DS1307_date_myDS+1, 0 
	MOVWF       R1 
	MOVF        DS1307_date_cont_L0+0, 0 
	ADDWF       R0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FSR1H 
	MOVLW       45
	MOVWF       POSTINC1+0 
	INCF        DS1307_date_cont_L0+0, 1 
L_DS1307_date345:
;ds1307.h,157 :: 		numToString(myDs->hours, &myDs->time[cont], 2);
	MOVLW       2
	ADDWF       FARG_DS1307_date_myDS+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_DS1307_date_myDS+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       FARG_numToString_valor+0 
	MOVLW       0
	MOVWF       FARG_numToString_valor+1 
	MOVWF       FARG_numToString_valor+2 
	MOVWF       FARG_numToString_valor+3 
	MOVLW       0
	MOVWF       FARG_numToString_valor+1 
	MOVWF       FARG_numToString_valor+2 
	MOVWF       FARG_numToString_valor+3 
	MOVLW       7
	ADDWF       FARG_DS1307_date_myDS+0, 0 
	MOVWF       FARG_numToString_cadena+0 
	MOVLW       0
	ADDWFC      FARG_DS1307_date_myDS+1, 0 
	MOVWF       FARG_numToString_cadena+1 
	MOVF        DS1307_date_cont_L0+0, 0 
	ADDWF       FARG_numToString_cadena+0, 1 
	MOVLW       0
	ADDWFC      FARG_numToString_cadena+1, 1 
	MOVLW       2
	MOVWF       FARG_numToString_digitos+0 
	CALL        _numToString+0, 0
;ds1307.h,158 :: 		cont += 2;
	MOVLW       2
	ADDWF       DS1307_date_cont_L0+0, 1 
;ds1307.h,159 :: 		if(formatComplet)
	MOVF        FARG_DS1307_date_formatComplet+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_DS1307_date346
;ds1307.h,160 :: 		myDS->time[cont++] = ':';
	MOVLW       7
	ADDWF       FARG_DS1307_date_myDS+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      FARG_DS1307_date_myDS+1, 0 
	MOVWF       R1 
	MOVF        DS1307_date_cont_L0+0, 0 
	ADDWF       R0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FSR1H 
	MOVLW       58
	MOVWF       POSTINC1+0 
	INCF        DS1307_date_cont_L0+0, 1 
L_DS1307_date346:
;ds1307.h,162 :: 		numToString(myDs->minutes, &myDs->time[cont], 2);
	MOVLW       1
	ADDWF       FARG_DS1307_date_myDS+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_DS1307_date_myDS+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       FARG_numToString_valor+0 
	MOVLW       0
	MOVWF       FARG_numToString_valor+1 
	MOVWF       FARG_numToString_valor+2 
	MOVWF       FARG_numToString_valor+3 
	MOVLW       0
	MOVWF       FARG_numToString_valor+1 
	MOVWF       FARG_numToString_valor+2 
	MOVWF       FARG_numToString_valor+3 
	MOVLW       7
	ADDWF       FARG_DS1307_date_myDS+0, 0 
	MOVWF       FARG_numToString_cadena+0 
	MOVLW       0
	ADDWFC      FARG_DS1307_date_myDS+1, 0 
	MOVWF       FARG_numToString_cadena+1 
	MOVF        DS1307_date_cont_L0+0, 0 
	ADDWF       FARG_numToString_cadena+0, 1 
	MOVLW       0
	ADDWFC      FARG_numToString_cadena+1, 1 
	MOVLW       2
	MOVWF       FARG_numToString_digitos+0 
	CALL        _numToString+0, 0
;ds1307.h,163 :: 		cont += 2;
	MOVLW       2
	ADDWF       DS1307_date_cont_L0+0, 1 
;ds1307.h,164 :: 		if(formatComplet)
	MOVF        FARG_DS1307_date_formatComplet+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_DS1307_date347
;ds1307.h,165 :: 		myDS->time[cont++] = ':';
	MOVLW       7
	ADDWF       FARG_DS1307_date_myDS+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      FARG_DS1307_date_myDS+1, 0 
	MOVWF       R1 
	MOVF        DS1307_date_cont_L0+0, 0 
	ADDWF       R0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FSR1H 
	MOVLW       58
	MOVWF       POSTINC1+0 
	INCF        DS1307_date_cont_L0+0, 1 
L_DS1307_date347:
;ds1307.h,167 :: 		numToString(myDs->seconds, &myDs->time[cont], 2);
	MOVFF       FARG_DS1307_date_myDS+0, FSR0
	MOVFF       FARG_DS1307_date_myDS+1, FSR0H
	MOVF        POSTINC0+0, 0 
	MOVWF       FARG_numToString_valor+0 
	MOVLW       0
	MOVWF       FARG_numToString_valor+1 
	MOVWF       FARG_numToString_valor+2 
	MOVWF       FARG_numToString_valor+3 
	MOVLW       0
	MOVWF       FARG_numToString_valor+1 
	MOVWF       FARG_numToString_valor+2 
	MOVWF       FARG_numToString_valor+3 
	MOVLW       7
	ADDWF       FARG_DS1307_date_myDS+0, 0 
	MOVWF       FARG_numToString_cadena+0 
	MOVLW       0
	ADDWFC      FARG_DS1307_date_myDS+1, 0 
	MOVWF       FARG_numToString_cadena+1 
	MOVF        DS1307_date_cont_L0+0, 0 
	ADDWF       FARG_numToString_cadena+0, 1 
	MOVLW       0
	ADDWFC      FARG_numToString_cadena+1, 1 
	MOVLW       2
	MOVWF       FARG_numToString_digitos+0 
	CALL        _numToString+0, 0
;ds1307.h,168 :: 		cont += 2;
	MOVLW       2
	ADDWF       DS1307_date_cont_L0+0, 1 
;ds1307.h,169 :: 		if(formatComplet)
	MOVF        FARG_DS1307_date_formatComplet+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_DS1307_date348
;ds1307.h,170 :: 		myDS->time[cont++] = ' ';
	MOVLW       7
	ADDWF       FARG_DS1307_date_myDS+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      FARG_DS1307_date_myDS+1, 0 
	MOVWF       R1 
	MOVF        DS1307_date_cont_L0+0, 0 
	ADDWF       R0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FSR1H 
	MOVLW       32
	MOVWF       POSTINC1+0 
	INCF        DS1307_date_cont_L0+0, 1 
L_DS1307_date348:
;ds1307.h,172 :: 		numToString(myDs->day, &myDs->time[cont], 2);
	MOVLW       4
	ADDWF       FARG_DS1307_date_myDS+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_DS1307_date_myDS+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       FARG_numToString_valor+0 
	MOVLW       0
	MOVWF       FARG_numToString_valor+1 
	MOVWF       FARG_numToString_valor+2 
	MOVWF       FARG_numToString_valor+3 
	MOVLW       0
	MOVWF       FARG_numToString_valor+1 
	MOVWF       FARG_numToString_valor+2 
	MOVWF       FARG_numToString_valor+3 
	MOVLW       7
	ADDWF       FARG_DS1307_date_myDS+0, 0 
	MOVWF       FARG_numToString_cadena+0 
	MOVLW       0
	ADDWFC      FARG_DS1307_date_myDS+1, 0 
	MOVWF       FARG_numToString_cadena+1 
	MOVF        DS1307_date_cont_L0+0, 0 
	ADDWF       FARG_numToString_cadena+0, 1 
	MOVLW       0
	ADDWFC      FARG_numToString_cadena+1, 1 
	MOVLW       2
	MOVWF       FARG_numToString_digitos+0 
	CALL        _numToString+0, 0
;ds1307.h,173 :: 		cont += 2;
	MOVLW       2
	ADDWF       DS1307_date_cont_L0+0, 1 
;ds1307.h,174 :: 		if(formatComplet)
	MOVF        FARG_DS1307_date_formatComplet+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_DS1307_date349
;ds1307.h,175 :: 		myDS->time[cont++] = '/';
	MOVLW       7
	ADDWF       FARG_DS1307_date_myDS+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      FARG_DS1307_date_myDS+1, 0 
	MOVWF       R1 
	MOVF        DS1307_date_cont_L0+0, 0 
	ADDWF       R0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FSR1H 
	MOVLW       47
	MOVWF       POSTINC1+0 
	INCF        DS1307_date_cont_L0+0, 1 
L_DS1307_date349:
;ds1307.h,177 :: 		numToString(myDs->month, &myDs->time[cont], 2);
	MOVLW       5
	ADDWF       FARG_DS1307_date_myDS+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_DS1307_date_myDS+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       FARG_numToString_valor+0 
	MOVLW       0
	MOVWF       FARG_numToString_valor+1 
	MOVWF       FARG_numToString_valor+2 
	MOVWF       FARG_numToString_valor+3 
	MOVLW       0
	MOVWF       FARG_numToString_valor+1 
	MOVWF       FARG_numToString_valor+2 
	MOVWF       FARG_numToString_valor+3 
	MOVLW       7
	ADDWF       FARG_DS1307_date_myDS+0, 0 
	MOVWF       FARG_numToString_cadena+0 
	MOVLW       0
	ADDWFC      FARG_DS1307_date_myDS+1, 0 
	MOVWF       FARG_numToString_cadena+1 
	MOVF        DS1307_date_cont_L0+0, 0 
	ADDWF       FARG_numToString_cadena+0, 1 
	MOVLW       0
	ADDWFC      FARG_numToString_cadena+1, 1 
	MOVLW       2
	MOVWF       FARG_numToString_digitos+0 
	CALL        _numToString+0, 0
;ds1307.h,178 :: 		cont += 2;
	MOVLW       2
	ADDWF       DS1307_date_cont_L0+0, 1 
;ds1307.h,179 :: 		if(formatComplet)
	MOVF        FARG_DS1307_date_formatComplet+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_DS1307_date350
;ds1307.h,180 :: 		myDS->time[cont++] = '/';
	MOVLW       7
	ADDWF       FARG_DS1307_date_myDS+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      FARG_DS1307_date_myDS+1, 0 
	MOVWF       R1 
	MOVF        DS1307_date_cont_L0+0, 0 
	ADDWF       R0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FSR1H 
	MOVLW       47
	MOVWF       POSTINC1+0 
	INCF        DS1307_date_cont_L0+0, 1 
L_DS1307_date350:
;ds1307.h,182 :: 		numToString(myDs->year, &myDs->time[cont], 2);
	MOVLW       6
	ADDWF       FARG_DS1307_date_myDS+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_DS1307_date_myDS+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       FARG_numToString_valor+0 
	MOVLW       0
	MOVWF       FARG_numToString_valor+1 
	MOVWF       FARG_numToString_valor+2 
	MOVWF       FARG_numToString_valor+3 
	MOVLW       0
	MOVWF       FARG_numToString_valor+1 
	MOVWF       FARG_numToString_valor+2 
	MOVWF       FARG_numToString_valor+3 
	MOVLW       7
	ADDWF       FARG_DS1307_date_myDS+0, 0 
	MOVWF       FARG_numToString_cadena+0 
	MOVLW       0
	ADDWFC      FARG_DS1307_date_myDS+1, 0 
	MOVWF       FARG_numToString_cadena+1 
	MOVF        DS1307_date_cont_L0+0, 0 
	ADDWF       FARG_numToString_cadena+0, 1 
	MOVLW       0
	ADDWFC      FARG_numToString_cadena+1, 1 
	MOVLW       2
	MOVWF       FARG_numToString_digitos+0 
	CALL        _numToString+0, 0
;ds1307.h,183 :: 		cont += 2;
	MOVLW       2
	ADDWF       DS1307_date_cont_L0+0, 0 
	MOVWF       R2 
	MOVF        R2, 0 
	MOVWF       DS1307_date_cont_L0+0 
;ds1307.h,184 :: 		myDS->time[cont] = 0;  //Final de cadena
	MOVLW       7
	ADDWF       FARG_DS1307_date_myDS+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      FARG_DS1307_date_myDS+1, 0 
	MOVWF       R1 
	MOVF        R2, 0 
	ADDWF       R0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      R1, 0 
	MOVWF       FSR1H 
	CLRF        POSTINC1+0 
;ds1307.h,186 :: 		return myDS->time;
	MOVLW       7
	ADDWF       FARG_DS1307_date_myDS+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      FARG_DS1307_date_myDS+1, 0 
	MOVWF       R1 
;ds1307.h,187 :: 		}
L_end_DS1307_date:
	RETURN      0
; end of _DS1307_date

_DS1307_getSeconds:

;ds1307.h,189 :: 		long DS1307_getSeconds(char *HHMMSS){
;ds1307.h,190 :: 		char cont = 0;
	CLRF        DS1307_getSeconds_cont_L0+0 
	MOVLW       255
	MOVWF       DS1307_getSeconds_segundos_L0+0 
	MOVLW       255
	MOVWF       DS1307_getSeconds_segundos_L0+1 
	MOVLW       255
	MOVWF       DS1307_getSeconds_segundos_L0+2 
	MOVLW       255
	MOVWF       DS1307_getSeconds_segundos_L0+3 
;ds1307.h,193 :: 		if(string_len(HHMMSS) == 6){
	MOVF        FARG_DS1307_getSeconds_HHMMSS+0, 0 
	MOVWF       FARG_string_len_texto+0 
	MOVF        FARG_DS1307_getSeconds_HHMMSS+1, 0 
	MOVWF       FARG_string_len_texto+1 
	CALL        _string_len+0, 0
	MOVF        R0, 0 
	XORLW       6
	BTFSS       STATUS+0, 2 
	GOTO        L_DS1307_getSeconds351
;ds1307.h,194 :: 		segundos = 0;
	CLRF        DS1307_getSeconds_segundos_L0+0 
	CLRF        DS1307_getSeconds_segundos_L0+1 
	CLRF        DS1307_getSeconds_segundos_L0+2 
	CLRF        DS1307_getSeconds_segundos_L0+3 
;ds1307.h,196 :: 		while(HHMMSS[cont] != 0){
L_DS1307_getSeconds352:
	MOVF        DS1307_getSeconds_cont_L0+0, 0 
	ADDWF       FARG_DS1307_getSeconds_HHMMSS+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_DS1307_getSeconds_HHMMSS+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	XORLW       0
	BTFSC       STATUS+0, 2 
	GOTO        L_DS1307_getSeconds353
;ds1307.h,197 :: 		segundos *= 60;
	MOVF        DS1307_getSeconds_segundos_L0+0, 0 
	MOVWF       R0 
	MOVF        DS1307_getSeconds_segundos_L0+1, 0 
	MOVWF       R1 
	MOVF        DS1307_getSeconds_segundos_L0+2, 0 
	MOVWF       R2 
	MOVF        DS1307_getSeconds_segundos_L0+3, 0 
	MOVWF       R3 
	MOVLW       60
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	MOVWF       R6 
	MOVWF       R7 
	CALL        _Mul_32x32_U+0, 0
	MOVF        R0, 0 
	MOVWF       DS1307_getSeconds_segundos_L0+0 
	MOVF        R1, 0 
	MOVWF       DS1307_getSeconds_segundos_L0+1 
	MOVF        R2, 0 
	MOVWF       DS1307_getSeconds_segundos_L0+2 
	MOVF        R3, 0 
	MOVWF       DS1307_getSeconds_segundos_L0+3 
;ds1307.h,198 :: 		segundos += stringToNumN(&HHMMSS[cont], 2);
	MOVF        DS1307_getSeconds_cont_L0+0, 0 
	ADDWF       FARG_DS1307_getSeconds_HHMMSS+0, 0 
	MOVWF       FARG_stringToNumN_cadena+0 
	MOVLW       0
	ADDWFC      FARG_DS1307_getSeconds_HHMMSS+1, 0 
	MOVWF       FARG_stringToNumN_cadena+1 
	MOVLW       2
	MOVWF       FARG_stringToNumN_size+0 
	CALL        _stringToNumN+0, 0
	MOVF        R0, 0 
	ADDWF       DS1307_getSeconds_segundos_L0+0, 1 
	MOVF        R1, 0 
	ADDWFC      DS1307_getSeconds_segundos_L0+1, 1 
	MOVF        R2, 0 
	ADDWFC      DS1307_getSeconds_segundos_L0+2, 1 
	MOVF        R3, 0 
	ADDWFC      DS1307_getSeconds_segundos_L0+3, 1 
;ds1307.h,199 :: 		cont += 2;
	MOVLW       2
	ADDWF       DS1307_getSeconds_cont_L0+0, 1 
;ds1307.h,200 :: 		}
	GOTO        L_DS1307_getSeconds352
L_DS1307_getSeconds353:
;ds1307.h,201 :: 		}
L_DS1307_getSeconds351:
;ds1307.h,203 :: 		return segundos;
	MOVF        DS1307_getSeconds_segundos_L0+0, 0 
	MOVWF       R0 
	MOVF        DS1307_getSeconds_segundos_L0+1, 0 
	MOVWF       R1 
	MOVF        DS1307_getSeconds_segundos_L0+2, 0 
	MOVWF       R2 
	MOVF        DS1307_getSeconds_segundos_L0+3, 0 
	MOVWF       R3 
;ds1307.h,204 :: 		}
L_end_DS1307_getSeconds:
	RETURN      0
; end of _DS1307_getSeconds

_impresoraTerm_cmd:

;impresora_termica.h,85 :: 		void impresoraTerm_cmd(const char *comando){
;impresora_termica.h,86 :: 		char cont = 0;
	CLRF        impresoraTerm_cmd_cont_L0+0 
;impresora_termica.h,89 :: 		RomToRam(comando,buffer);
	MOVF        FARG_impresoraTerm_cmd_comando+0, 0 
	MOVWF       FARG_RomToRam_origen+0 
	MOVF        FARG_impresoraTerm_cmd_comando+1, 0 
	MOVWF       FARG_RomToRam_origen+1 
	MOVF        FARG_impresoraTerm_cmd_comando+2, 0 
	MOVWF       FARG_RomToRam_origen+2 
	MOVLW       TPV_buffer+0
	MOVWF       FARG_RomToRam_destino+0 
	MOVLW       hi_addr(TPV_buffer+0)
	MOVWF       FARG_RomToRam_destino+1 
	CALL        _RomToRam+0, 0
;impresora_termica.h,90 :: 		while(buffer[cont])
L_impresoraTerm_cmd354:
	MOVLW       TPV_buffer+0
	MOVWF       FSR0 
	MOVLW       hi_addr(TPV_buffer+0)
	MOVWF       FSR0H 
	MOVF        impresoraTerm_cmd_cont_L0+0, 0 
	ADDWF       FSR0, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR0H, 1 
	MOVF        POSTINC0+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_impresoraTerm_cmd355
;impresora_termica.h,91 :: 		usart_write(buffer[cont++]);
	MOVLW       TPV_buffer+0
	MOVWF       FSR0 
	MOVLW       hi_addr(TPV_buffer+0)
	MOVWF       FSR0H 
	MOVF        impresoraTerm_cmd_cont_L0+0, 0 
	ADDWF       FSR0, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR0H, 1 
	MOVF        POSTINC0+0, 0 
	MOVWF       FARG_usart_write_caracter+0 
	CALL        _usart_write+0, 0
	INCF        impresoraTerm_cmd_cont_L0+0, 1 
	GOTO        L_impresoraTerm_cmd354
L_impresoraTerm_cmd355:
;impresora_termica.h,92 :: 		}
L_end_impresoraTerm_cmd:
	RETURN      0
; end of _impresoraTerm_cmd

_impresoraTerm_cmd2:

;impresora_termica.h,94 :: 		void impresoraTerm_cmd2(const char *comando, char valor){
;impresora_termica.h,95 :: 		char cont = 0;
	CLRF        impresoraTerm_cmd2_cont_L0+0 
;impresora_termica.h,97 :: 		RomToRam(comando,buffer);
	MOVF        FARG_impresoraTerm_cmd2_comando+0, 0 
	MOVWF       FARG_RomToRam_origen+0 
	MOVF        FARG_impresoraTerm_cmd2_comando+1, 0 
	MOVWF       FARG_RomToRam_origen+1 
	MOVF        FARG_impresoraTerm_cmd2_comando+2, 0 
	MOVWF       FARG_RomToRam_origen+2 
	MOVLW       TPV_buffer+0
	MOVWF       FARG_RomToRam_destino+0 
	MOVLW       hi_addr(TPV_buffer+0)
	MOVWF       FARG_RomToRam_destino+1 
	CALL        _RomToRam+0, 0
;impresora_termica.h,98 :: 		while(buffer[cont])
L_impresoraTerm_cmd2356:
	MOVLW       TPV_buffer+0
	MOVWF       FSR0 
	MOVLW       hi_addr(TPV_buffer+0)
	MOVWF       FSR0H 
	MOVF        impresoraTerm_cmd2_cont_L0+0, 0 
	ADDWF       FSR0, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR0H, 1 
	MOVF        POSTINC0+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_impresoraTerm_cmd2357
;impresora_termica.h,99 :: 		usart_write(buffer[cont++]);
	MOVLW       TPV_buffer+0
	MOVWF       FSR0 
	MOVLW       hi_addr(TPV_buffer+0)
	MOVWF       FSR0H 
	MOVF        impresoraTerm_cmd2_cont_L0+0, 0 
	ADDWF       FSR0, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR0H, 1 
	MOVF        POSTINC0+0, 0 
	MOVWF       FARG_usart_write_caracter+0 
	CALL        _usart_write+0, 0
	INCF        impresoraTerm_cmd2_cont_L0+0, 1 
	GOTO        L_impresoraTerm_cmd2356
L_impresoraTerm_cmd2357:
;impresora_termica.h,101 :: 		usart_write(valor);
	MOVF        FARG_impresoraTerm_cmd2_valor+0, 0 
	MOVWF       FARG_usart_write_caracter+0 
	CALL        _usart_write+0, 0
;impresora_termica.h,102 :: 		}
L_end_impresoraTerm_cmd2:
	RETURN      0
; end of _impresoraTerm_cmd2

_impresoraTerm_open:

;impresora_termica.h,104 :: 		void impresoraTerm_open(bool typeFont, char interlineado){
;impresora_termica.h,106 :: 		impresoraTerm_cmd(IMPT_INIT);
	MOVLW       _IMPT_INIT+0
	MOVWF       FARG_impresoraTerm_cmd_comando+0 
	MOVLW       hi_addr(_IMPT_INIT+0)
	MOVWF       FARG_impresoraTerm_cmd_comando+1 
	MOVLW       higher_addr(_IMPT_INIT+0)
	MOVWF       FARG_impresoraTerm_cmd_comando+2 
	CALL        _impresoraTerm_cmd+0, 0
;impresora_termica.h,108 :: 		impresoraTerm_cmd2(IMPT_MODO, typeFont);
	MOVLW       _IMPT_MODO+0
	MOVWF       FARG_impresoraTerm_cmd2_comando+0 
	MOVLW       hi_addr(_IMPT_MODO+0)
	MOVWF       FARG_impresoraTerm_cmd2_comando+1 
	MOVLW       higher_addr(_IMPT_MODO+0)
	MOVWF       FARG_impresoraTerm_cmd2_comando+2 
	MOVF        FARG_impresoraTerm_open_typeFont+0, 0 
	MOVWF       FARG_impresoraTerm_cmd2_valor+0 
	CALL        _impresoraTerm_cmd2+0, 0
;impresora_termica.h,110 :: 		impresoraTerm_cmd2(IMPT_ESP_PROG, interlineado); //Espaciado
	MOVLW       _IMPT_ESP_PROG+0
	MOVWF       FARG_impresoraTerm_cmd2_comando+0 
	MOVLW       hi_addr(_IMPT_ESP_PROG+0)
	MOVWF       FARG_impresoraTerm_cmd2_comando+1 
	MOVLW       higher_addr(_IMPT_ESP_PROG+0)
	MOVWF       FARG_impresoraTerm_cmd2_comando+2 
	MOVF        FARG_impresoraTerm_open_interlineado+0, 0 
	MOVWF       FARG_impresoraTerm_cmd2_valor+0 
	CALL        _impresoraTerm_cmd2+0, 0
;impresora_termica.h,112 :: 		impresoraTerm_cmd2(IMPT_JUST, JUST_LEFT);        //Izquierda
	MOVLW       _IMPT_JUST+0
	MOVWF       FARG_impresoraTerm_cmd2_comando+0 
	MOVLW       hi_addr(_IMPT_JUST+0)
	MOVWF       FARG_impresoraTerm_cmd2_comando+1 
	MOVLW       higher_addr(_IMPT_JUST+0)
	MOVWF       FARG_impresoraTerm_cmd2_comando+2 
	CLRF        FARG_impresoraTerm_cmd2_valor+0 
	CALL        _impresoraTerm_cmd2+0, 0
;impresora_termica.h,114 :: 		impresoraTerm_cmd2(IMPT_SIZE_CHAR, 0x33);        //Tamño 3x3 points
	MOVLW       _IMPT_SIZE_CHAR+0
	MOVWF       FARG_impresoraTerm_cmd2_comando+0 
	MOVLW       hi_addr(_IMPT_SIZE_CHAR+0)
	MOVWF       FARG_impresoraTerm_cmd2_comando+1 
	MOVLW       higher_addr(_IMPT_SIZE_CHAR+0)
	MOVWF       FARG_impresoraTerm_cmd2_comando+2 
	MOVLW       51
	MOVWF       FARG_impresoraTerm_cmd2_valor+0 
	CALL        _impresoraTerm_cmd2+0, 0
;impresora_termica.h,115 :: 		}
L_end_impresoraTerm_open:
	RETURN      0
; end of _impresoraTerm_open

_impresoraTerm_formato:

;impresora_termica.h,117 :: 		void impresoraTerm_formato(char size, char just, bool negrita){
;impresora_termica.h,119 :: 		impresoraTerm_cmd2(IMPT_SIZE_CHAR, size);
	MOVLW       _IMPT_SIZE_CHAR+0
	MOVWF       FARG_impresoraTerm_cmd2_comando+0 
	MOVLW       hi_addr(_IMPT_SIZE_CHAR+0)
	MOVWF       FARG_impresoraTerm_cmd2_comando+1 
	MOVLW       higher_addr(_IMPT_SIZE_CHAR+0)
	MOVWF       FARG_impresoraTerm_cmd2_comando+2 
	MOVF        FARG_impresoraTerm_formato_size+0, 0 
	MOVWF       FARG_impresoraTerm_cmd2_valor+0 
	CALL        _impresoraTerm_cmd2+0, 0
;impresora_termica.h,121 :: 		impresoraTerm_cmd2(IMPT_JUST, just);
	MOVLW       _IMPT_JUST+0
	MOVWF       FARG_impresoraTerm_cmd2_comando+0 
	MOVLW       hi_addr(_IMPT_JUST+0)
	MOVWF       FARG_impresoraTerm_cmd2_comando+1 
	MOVLW       higher_addr(_IMPT_JUST+0)
	MOVWF       FARG_impresoraTerm_cmd2_comando+2 
	MOVF        FARG_impresoraTerm_formato_just+0, 0 
	MOVWF       FARG_impresoraTerm_cmd2_valor+0 
	CALL        _impresoraTerm_cmd2+0, 0
;impresora_termica.h,123 :: 		impresoraTerm_cmd2(IMPT_NEGRITA, negrita);
	MOVLW       _IMPT_NEGRITA+0
	MOVWF       FARG_impresoraTerm_cmd2_comando+0 
	MOVLW       hi_addr(_IMPT_NEGRITA+0)
	MOVWF       FARG_impresoraTerm_cmd2_comando+1 
	MOVLW       higher_addr(_IMPT_NEGRITA+0)
	MOVWF       FARG_impresoraTerm_cmd2_comando+2 
	MOVF        FARG_impresoraTerm_formato_negrita+0, 0 
	MOVWF       FARG_impresoraTerm_cmd2_valor+0 
	CALL        _impresoraTerm_cmd2+0, 0
;impresora_termica.h,124 :: 		}
L_end_impresoraTerm_formato:
	RETURN      0
; end of _impresoraTerm_formato

_impresoraTerm_writeLine:

;impresora_termica.h,126 :: 		void impresoraTerm_writeLine(char *texto){
;impresora_termica.h,127 :: 		char cont = 0;
	CLRF        impresoraTerm_writeLine_cont_L0+0 
;impresora_termica.h,130 :: 		while(texto[cont])
L_impresoraTerm_writeLine358:
	MOVF        impresoraTerm_writeLine_cont_L0+0, 0 
	ADDWF       FARG_impresoraTerm_writeLine_texto+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_impresoraTerm_writeLine_texto+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_impresoraTerm_writeLine359
;impresora_termica.h,131 :: 		usart_write(texto[cont++]);
	MOVF        impresoraTerm_writeLine_cont_L0+0, 0 
	ADDWF       FARG_impresoraTerm_writeLine_texto+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_impresoraTerm_writeLine_texto+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       FARG_usart_write_caracter+0 
	CALL        _usart_write+0, 0
	INCF        impresoraTerm_writeLine_cont_L0+0, 1 
	GOTO        L_impresoraTerm_writeLine358
L_impresoraTerm_writeLine359:
;impresora_termica.h,133 :: 		impresoraTerm_cmd(IMPT_IMPRIME);
	MOVLW       _IMPT_IMPRIME+0
	MOVWF       FARG_impresoraTerm_cmd_comando+0 
	MOVLW       hi_addr(_IMPT_IMPRIME+0)
	MOVWF       FARG_impresoraTerm_cmd_comando+1 
	MOVLW       higher_addr(_IMPT_IMPRIME+0)
	MOVWF       FARG_impresoraTerm_cmd_comando+2 
	CALL        _impresoraTerm_cmd+0, 0
;impresora_termica.h,134 :: 		}
L_end_impresoraTerm_writeLine:
	RETURN      0
; end of _impresoraTerm_writeLine

_impresoraTerm_writeTextStatic:

;impresora_termica.h,136 :: 		bool impresoraTerm_writeTextStatic(const char *texto, char rateBytes){
;impresora_termica.h,140 :: 		while(texto[cont] && rateBytes--){
L_impresoraTerm_writeTextStatic360:
	MOVF        impresoraTerm_writeTextStatic_cont_L0+0, 0 
	ADDWF       FARG_impresoraTerm_writeTextStatic_texto+0, 0 
	MOVWF       TBLPTRL 
	MOVF        impresoraTerm_writeTextStatic_cont_L0+1, 0 
	ADDWFC      FARG_impresoraTerm_writeTextStatic_texto+1, 0 
	MOVWF       TBLPTRH 
	MOVLW       0
	ADDWFC      FARG_impresoraTerm_writeTextStatic_texto+2, 0 
	MOVWF       TBLPTRU 
	TBLRD*+
	MOVFF       TABLAT+0, R0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_impresoraTerm_writeTextStatic361
	MOVF        FARG_impresoraTerm_writeTextStatic_rateBytes+0, 0 
	MOVWF       R0 
	DECF        FARG_impresoraTerm_writeTextStatic_rateBytes+0, 1 
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_impresoraTerm_writeTextStatic361
L__impresoraTerm_writeTextStatic990:
;impresora_termica.h,141 :: 		usart_write(texto[cont]);
	MOVF        impresoraTerm_writeTextStatic_cont_L0+0, 0 
	ADDWF       FARG_impresoraTerm_writeTextStatic_texto+0, 0 
	MOVWF       TBLPTRL 
	MOVF        impresoraTerm_writeTextStatic_cont_L0+1, 0 
	ADDWFC      FARG_impresoraTerm_writeTextStatic_texto+1, 0 
	MOVWF       TBLPTRH 
	MOVLW       0
	ADDWFC      FARG_impresoraTerm_writeTextStatic_texto+2, 0 
	MOVWF       TBLPTRU 
	TBLRD*+
	MOVFF       TABLAT+0, FARG_usart_write_caracter+0
	CALL        _usart_write+0, 0
;impresora_termica.h,143 :: 		if(texto[cont] == '\n'){
	MOVF        impresoraTerm_writeTextStatic_cont_L0+0, 0 
	ADDWF       FARG_impresoraTerm_writeTextStatic_texto+0, 0 
	MOVWF       TBLPTRL 
	MOVF        impresoraTerm_writeTextStatic_cont_L0+1, 0 
	ADDWFC      FARG_impresoraTerm_writeTextStatic_texto+1, 0 
	MOVWF       TBLPTRH 
	MOVLW       0
	ADDWFC      FARG_impresoraTerm_writeTextStatic_texto+2, 0 
	MOVWF       TBLPTRU 
	TBLRD*+
	MOVFF       TABLAT+0, R1
	MOVF        R1, 0 
	XORLW       10
	BTFSS       STATUS+0, 2 
	GOTO        L_impresoraTerm_writeTextStatic364
;impresora_termica.h,144 :: 		cont++;
	INFSNZ      impresoraTerm_writeTextStatic_cont_L0+0, 1 
	INCF        impresoraTerm_writeTextStatic_cont_L0+1, 1 
;impresora_termica.h,145 :: 		break;
	GOTO        L_impresoraTerm_writeTextStatic361
;impresora_termica.h,146 :: 		}
L_impresoraTerm_writeTextStatic364:
;impresora_termica.h,147 :: 		cont++;  //Siguiente posicion
	INFSNZ      impresoraTerm_writeTextStatic_cont_L0+0, 1 
	INCF        impresoraTerm_writeTextStatic_cont_L0+1, 1 
;impresora_termica.h,148 :: 		}
	GOTO        L_impresoraTerm_writeTextStatic360
L_impresoraTerm_writeTextStatic361:
;impresora_termica.h,150 :: 		if(!texto[cont]){
	MOVF        impresoraTerm_writeTextStatic_cont_L0+0, 0 
	ADDWF       FARG_impresoraTerm_writeTextStatic_texto+0, 0 
	MOVWF       TBLPTRL 
	MOVF        impresoraTerm_writeTextStatic_cont_L0+1, 0 
	ADDWFC      FARG_impresoraTerm_writeTextStatic_texto+1, 0 
	MOVWF       TBLPTRH 
	MOVLW       0
	ADDWFC      FARG_impresoraTerm_writeTextStatic_texto+2, 0 
	MOVWF       TBLPTRU 
	TBLRD*+
	MOVFF       TABLAT+0, R0
	MOVF        R0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_impresoraTerm_writeTextStatic365
;impresora_termica.h,151 :: 		cont = 0;
	CLRF        impresoraTerm_writeTextStatic_cont_L0+0 
	CLRF        impresoraTerm_writeTextStatic_cont_L0+1 
;impresora_termica.h,152 :: 		return true; //Finalizo de imprimir
	MOVLW       1
	MOVWF       R0 
	GOTO        L_end_impresoraTerm_writeTextStatic
;impresora_termica.h,153 :: 		}
L_impresoraTerm_writeTextStatic365:
;impresora_termica.h,155 :: 		return false;  //No ha terminado de imprimir
	CLRF        R0 
;impresora_termica.h,156 :: 		}
L_end_impresoraTerm_writeTextStatic:
	RETURN      0
; end of _impresoraTerm_writeTextStatic

_impresoraTerm_writeDinamicText:

;impresora_termica.h,158 :: 		void impresoraTerm_writeDinamicText(char *texto, const int *address){
;impresora_termica.h,159 :: 		char ADRR_ERROR[] = "#ERR_ADDR#";  //Optimizar esta variable
	MOVLW       35
	MOVWF       impresoraTerm_writeDinamicText_ADRR_ERROR_L0+0 
	MOVLW       69
	MOVWF       impresoraTerm_writeDinamicText_ADRR_ERROR_L0+1 
	MOVLW       82
	MOVWF       impresoraTerm_writeDinamicText_ADRR_ERROR_L0+2 
	MOVLW       82
	MOVWF       impresoraTerm_writeDinamicText_ADRR_ERROR_L0+3 
	MOVLW       95
	MOVWF       impresoraTerm_writeDinamicText_ADRR_ERROR_L0+4 
	MOVLW       65
	MOVWF       impresoraTerm_writeDinamicText_ADRR_ERROR_L0+5 
	MOVLW       68
	MOVWF       impresoraTerm_writeDinamicText_ADRR_ERROR_L0+6 
	MOVLW       68
	MOVWF       impresoraTerm_writeDinamicText_ADRR_ERROR_L0+7 
	MOVLW       82
	MOVWF       impresoraTerm_writeDinamicText_ADRR_ERROR_L0+8 
	MOVLW       35
	MOVWF       impresoraTerm_writeDinamicText_ADRR_ERROR_L0+9 
	CLRF        impresoraTerm_writeDinamicText_ADRR_ERROR_L0+10 
	CLRF        impresoraTerm_writeDinamicText_cont_L0+0 
;impresora_termica.h,165 :: 		while(texto[cont]){
L_impresoraTerm_writeDinamicText366:
	MOVF        impresoraTerm_writeDinamicText_cont_L0+0, 0 
	ADDWF       FARG_impresoraTerm_writeDinamicText_texto+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_impresoraTerm_writeDinamicText_texto+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_impresoraTerm_writeDinamicText367
;impresora_termica.h,166 :: 		if(texto[cont] == CMD_IMPRESORA){  //ENVIA N CARACTERES DE COMANDOS HACIA LA IMPRESORA
	MOVF        impresoraTerm_writeDinamicText_cont_L0+0, 0 
	ADDWF       FARG_impresoraTerm_writeDinamicText_texto+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_impresoraTerm_writeDinamicText_texto+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	XORLW       2
	BTFSS       STATUS+0, 2 
	GOTO        L_impresoraTerm_writeDinamicText368
;impresora_termica.h,168 :: 		cont++;
	INCF        impresoraTerm_writeDinamicText_cont_L0+0, 1 
;impresora_termica.h,169 :: 		for(cont2 = 0; cont2 < 2 && texto[cont]; cont2++)
	CLRF        impresoraTerm_writeDinamicText_cont2_L0+0 
L_impresoraTerm_writeDinamicText369:
	MOVLW       2
	SUBWF       impresoraTerm_writeDinamicText_cont2_L0+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_impresoraTerm_writeDinamicText370
	MOVF        impresoraTerm_writeDinamicText_cont_L0+0, 0 
	ADDWF       FARG_impresoraTerm_writeDinamicText_texto+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_impresoraTerm_writeDinamicText_texto+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_impresoraTerm_writeDinamicText370
L__impresoraTerm_writeDinamicText995:
;impresora_termica.h,170 :: 		buffer[cont2] = texto[cont++];
	MOVLW       TPV_buffer+0
	MOVWF       FSR1 
	MOVLW       hi_addr(TPV_buffer+0)
	MOVWF       FSR1H 
	MOVF        impresoraTerm_writeDinamicText_cont2_L0+0, 0 
	ADDWF       FSR1, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR1H, 1 
	MOVF        impresoraTerm_writeDinamicText_cont_L0+0, 0 
	ADDWF       FARG_impresoraTerm_writeDinamicText_texto+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_impresoraTerm_writeDinamicText_texto+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       POSTINC1+0 
	INCF        impresoraTerm_writeDinamicText_cont_L0+0, 1 
;impresora_termica.h,169 :: 		for(cont2 = 0; cont2 < 2 && texto[cont]; cont2++)
	INCF        impresoraTerm_writeDinamicText_cont2_L0+0, 1 
;impresora_termica.h,170 :: 		buffer[cont2] = texto[cont++];
	GOTO        L_impresoraTerm_writeDinamicText369
L_impresoraTerm_writeDinamicText370:
;impresora_termica.h,171 :: 		buffer[cont2] = 0; //Fin de cadena
	MOVLW       TPV_buffer+0
	MOVWF       FSR1 
	MOVLW       hi_addr(TPV_buffer+0)
	MOVWF       FSR1H 
	MOVF        impresoraTerm_writeDinamicText_cont2_L0+0, 0 
	ADDWF       FSR1, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR1H, 1 
	CLRF        POSTINC1+0 
;impresora_termica.h,174 :: 		comandos = atoi(buffer);
	MOVLW       TPV_buffer+0
	MOVWF       FARG_atoi_s+0 
	MOVLW       hi_addr(TPV_buffer+0)
	MOVWF       FARG_atoi_s+1 
	CALL        _atoi+0, 0
	MOVF        R0, 0 
	MOVWF       impresoraTerm_writeDinamicText_comandos_L0+0 
;impresora_termica.h,175 :: 		while(comandos--){
L_impresoraTerm_writeDinamicText374:
	MOVF        impresoraTerm_writeDinamicText_comandos_L0+0, 0 
	MOVWF       R0 
	DECF        impresoraTerm_writeDinamicText_comandos_L0+0, 1 
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_impresoraTerm_writeDinamicText375
;impresora_termica.h,177 :: 		for(cont2 = 0; cont2 < 2 && texto[cont]; cont2++)
	CLRF        impresoraTerm_writeDinamicText_cont2_L0+0 
L_impresoraTerm_writeDinamicText376:
	MOVLW       2
	SUBWF       impresoraTerm_writeDinamicText_cont2_L0+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_impresoraTerm_writeDinamicText377
	MOVF        impresoraTerm_writeDinamicText_cont_L0+0, 0 
	ADDWF       FARG_impresoraTerm_writeDinamicText_texto+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_impresoraTerm_writeDinamicText_texto+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_impresoraTerm_writeDinamicText377
L__impresoraTerm_writeDinamicText994:
;impresora_termica.h,178 :: 		buffer[cont2] = texto[cont++];
	MOVLW       TPV_buffer+0
	MOVWF       FSR1 
	MOVLW       hi_addr(TPV_buffer+0)
	MOVWF       FSR1H 
	MOVF        impresoraTerm_writeDinamicText_cont2_L0+0, 0 
	ADDWF       FSR1, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR1H, 1 
	MOVF        impresoraTerm_writeDinamicText_cont_L0+0, 0 
	ADDWF       FARG_impresoraTerm_writeDinamicText_texto+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_impresoraTerm_writeDinamicText_texto+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       POSTINC1+0 
	INCF        impresoraTerm_writeDinamicText_cont_L0+0, 1 
;impresora_termica.h,177 :: 		for(cont2 = 0; cont2 < 2 && texto[cont]; cont2++)
	INCF        impresoraTerm_writeDinamicText_cont2_L0+0, 1 
;impresora_termica.h,178 :: 		buffer[cont2] = texto[cont++];
	GOTO        L_impresoraTerm_writeDinamicText376
L_impresoraTerm_writeDinamicText377:
;impresora_termica.h,179 :: 		buffer[cont2] = 0; //Fin de cadena
	MOVLW       TPV_buffer+0
	MOVWF       FSR1 
	MOVLW       hi_addr(TPV_buffer+0)
	MOVWF       FSR1H 
	MOVF        impresoraTerm_writeDinamicText_cont2_L0+0, 0 
	ADDWF       FSR1, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR1H, 1 
	CLRF        POSTINC1+0 
;impresora_termica.h,180 :: 		cont2 = xtoi(buffer);
	MOVLW       TPV_buffer+0
	MOVWF       FARG_xtoi_s+0 
	MOVLW       hi_addr(TPV_buffer+0)
	MOVWF       FARG_xtoi_s+1 
	CALL        _xtoi+0, 0
	MOVF        R0, 0 
	MOVWF       impresoraTerm_writeDinamicText_cont2_L0+0 
;impresora_termica.h,181 :: 		usart_write(cont2);
	MOVF        R0, 0 
	MOVWF       FARG_usart_write_caracter+0 
	CALL        _usart_write+0, 0
;impresora_termica.h,182 :: 		}
	GOTO        L_impresoraTerm_writeDinamicText374
L_impresoraTerm_writeDinamicText375:
;impresora_termica.h,184 :: 		if(texto[cont] == '\n')
	MOVF        impresoraTerm_writeDinamicText_cont_L0+0, 0 
	ADDWF       FARG_impresoraTerm_writeDinamicText_texto+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_impresoraTerm_writeDinamicText_texto+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	XORLW       10
	BTFSS       STATUS+0, 2 
	GOTO        L_impresoraTerm_writeDinamicText381
;impresora_termica.h,185 :: 		cont++; //Por el final de cadena
	INCF        impresoraTerm_writeDinamicText_cont_L0+0, 1 
L_impresoraTerm_writeDinamicText381:
;impresora_termica.h,186 :: 		}else if(texto[cont] == CMD_CODIGO_BARRAS || texto[cont] == CMD_TEXT_DINAMIC){  //Comando para escribir variables dinamicas
	GOTO        L_impresoraTerm_writeDinamicText382
L_impresoraTerm_writeDinamicText368:
	MOVF        impresoraTerm_writeDinamicText_cont_L0+0, 0 
	ADDWF       FARG_impresoraTerm_writeDinamicText_texto+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_impresoraTerm_writeDinamicText_texto+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	XORLW       3
	BTFSC       STATUS+0, 2 
	GOTO        L__impresoraTerm_writeDinamicText993
	MOVF        impresoraTerm_writeDinamicText_cont_L0+0, 0 
	ADDWF       FARG_impresoraTerm_writeDinamicText_texto+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_impresoraTerm_writeDinamicText_texto+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	XORLW       5
	BTFSC       STATUS+0, 2 
	GOTO        L__impresoraTerm_writeDinamicText993
	GOTO        L_impresoraTerm_writeDinamicText385
L__impresoraTerm_writeDinamicText993:
;impresora_termica.h,188 :: 		comandos = texto[cont];
	MOVF        impresoraTerm_writeDinamicText_cont_L0+0, 0 
	ADDWF       FARG_impresoraTerm_writeDinamicText_texto+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_impresoraTerm_writeDinamicText_texto+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       impresoraTerm_writeDinamicText_comandos_L0+0 
;impresora_termica.h,191 :: 		ticketPointer = ADRR_ERROR;
	MOVLW       impresoraTerm_writeDinamicText_ADRR_ERROR_L0+0
	MOVWF       impresoraTerm_writeDinamicText_ticketPointer_L0+0 
	MOVLW       hi_addr(impresoraTerm_writeDinamicText_ADRR_ERROR_L0+0)
	MOVWF       impresoraTerm_writeDinamicText_ticketPointer_L0+1 
;impresora_termica.h,193 :: 		cont++;
	INCF        impresoraTerm_writeDinamicText_cont_L0+0, 1 
;impresora_termica.h,194 :: 		for(cont2 = 0; cont2 < 4 && texto[cont]; cont2++)
	CLRF        impresoraTerm_writeDinamicText_cont2_L0+0 
L_impresoraTerm_writeDinamicText386:
	MOVLW       4
	SUBWF       impresoraTerm_writeDinamicText_cont2_L0+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_impresoraTerm_writeDinamicText387
	MOVF        impresoraTerm_writeDinamicText_cont_L0+0, 0 
	ADDWF       FARG_impresoraTerm_writeDinamicText_texto+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_impresoraTerm_writeDinamicText_texto+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_impresoraTerm_writeDinamicText387
L__impresoraTerm_writeDinamicText992:
;impresora_termica.h,195 :: 		buffer[cont2] = texto[cont++];
	MOVLW       TPV_buffer+0
	MOVWF       FSR1 
	MOVLW       hi_addr(TPV_buffer+0)
	MOVWF       FSR1H 
	MOVF        impresoraTerm_writeDinamicText_cont2_L0+0, 0 
	ADDWF       FSR1, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR1H, 1 
	MOVF        impresoraTerm_writeDinamicText_cont_L0+0, 0 
	ADDWF       FARG_impresoraTerm_writeDinamicText_texto+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_impresoraTerm_writeDinamicText_texto+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       POSTINC1+0 
	INCF        impresoraTerm_writeDinamicText_cont_L0+0, 1 
;impresora_termica.h,194 :: 		for(cont2 = 0; cont2 < 4 && texto[cont]; cont2++)
	INCF        impresoraTerm_writeDinamicText_cont2_L0+0, 1 
;impresora_termica.h,195 :: 		buffer[cont2] = texto[cont++];
	GOTO        L_impresoraTerm_writeDinamicText386
L_impresoraTerm_writeDinamicText387:
;impresora_termica.h,196 :: 		buffer[cont2] = 0; //Fin de cadena
	MOVLW       TPV_buffer+0
	MOVWF       FSR1 
	MOVLW       hi_addr(TPV_buffer+0)
	MOVWF       FSR1H 
	MOVF        impresoraTerm_writeDinamicText_cont2_L0+0, 0 
	ADDWF       FSR1, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR1H, 1 
	CLRF        POSTINC1+0 
;impresora_termica.h,198 :: 		dir = xtoi(buffer);
	MOVLW       TPV_buffer+0
	MOVWF       FARG_xtoi_s+0 
	MOVLW       hi_addr(TPV_buffer+0)
	MOVWF       FARG_xtoi_s+1 
	CALL        _xtoi+0, 0
	MOVF        R0, 0 
	MOVWF       impresoraTerm_writeDinamicText_dir_L0+0 
	MOVF        R1, 0 
	MOVWF       impresoraTerm_writeDinamicText_dir_L0+1 
;impresora_termica.h,201 :: 		cont2 = 0;
	CLRF        impresoraTerm_writeDinamicText_cont2_L0+0 
;impresora_termica.h,202 :: 		while(address[cont2]){
L_impresoraTerm_writeDinamicText391:
	MOVF        impresoraTerm_writeDinamicText_cont2_L0+0, 0 
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	MOVWF       R2 
	MOVWF       R3 
	RLCF        R0, 1 
	BCF         R0, 0 
	RLCF        R1, 1 
	RLCF        R2, 1 
	RLCF        R3, 1 
	MOVF        FARG_impresoraTerm_writeDinamicText_address+0, 0 
	ADDWF       R0, 0 
	MOVWF       TBLPTRL 
	MOVF        FARG_impresoraTerm_writeDinamicText_address+1, 0 
	ADDWFC      R1, 0 
	MOVWF       TBLPTRH 
	MOVF        FARG_impresoraTerm_writeDinamicText_address+2, 0 
	ADDWFC      R2, 0 
	MOVWF       TBLPTRU 
	TBLRD*+
	MOVFF       TABLAT+0, R0
	TBLRD*+
	MOVFF       TABLAT+0, R1
	MOVF        R0, 0 
	IORWF       R1, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L_impresoraTerm_writeDinamicText392
;impresora_termica.h,203 :: 		if(dir == address[cont2++]){
	MOVF        impresoraTerm_writeDinamicText_cont2_L0+0, 0 
	MOVWF       R5 
	INCF        impresoraTerm_writeDinamicText_cont2_L0+0, 1 
	MOVF        R5, 0 
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	MOVWF       R2 
	MOVWF       R3 
	RLCF        R0, 1 
	BCF         R0, 0 
	RLCF        R1, 1 
	RLCF        R2, 1 
	RLCF        R3, 1 
	MOVF        FARG_impresoraTerm_writeDinamicText_address+0, 0 
	ADDWF       R0, 0 
	MOVWF       TBLPTRL 
	MOVF        FARG_impresoraTerm_writeDinamicText_address+1, 0 
	ADDWFC      R1, 0 
	MOVWF       TBLPTRH 
	MOVF        FARG_impresoraTerm_writeDinamicText_address+2, 0 
	ADDWFC      R2, 0 
	MOVWF       TBLPTRU 
	TBLRD*+
	MOVFF       TABLAT+0, R1
	TBLRD*+
	MOVFF       TABLAT+0, R2
	MOVF        impresoraTerm_writeDinamicText_dir_L0+1, 0 
	XORWF       R2, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__impresoraTerm_writeDinamicText1260
	MOVF        R1, 0 
	XORWF       impresoraTerm_writeDinamicText_dir_L0+0, 0 
L__impresoraTerm_writeDinamicText1260:
	BTFSS       STATUS+0, 2 
	GOTO        L_impresoraTerm_writeDinamicText393
;impresora_termica.h,205 :: 		getByte(ticketPointer, 0) = getByte(dir, 0);
	MOVF        impresoraTerm_writeDinamicText_dir_L0+0, 0 
	MOVWF       impresoraTerm_writeDinamicText_ticketPointer_L0+0 
;impresora_termica.h,206 :: 		getByte(ticketPointer, 1) = getByte(dir, 1);
	MOVF        impresoraTerm_writeDinamicText_dir_L0+1, 0 
	MOVWF       impresoraTerm_writeDinamicText_ticketPointer_L0+1 
;impresora_termica.h,207 :: 		break;
	GOTO        L_impresoraTerm_writeDinamicText392
;impresora_termica.h,208 :: 		}
L_impresoraTerm_writeDinamicText393:
;impresora_termica.h,209 :: 		}
	GOTO        L_impresoraTerm_writeDinamicText391
L_impresoraTerm_writeDinamicText392:
;impresora_termica.h,212 :: 		if(comandos == CMD_CODIGO_BARRAS)
	MOVF        impresoraTerm_writeDinamicText_comandos_L0+0, 0 
	XORLW       3
	BTFSS       STATUS+0, 2 
	GOTO        L_impresoraTerm_writeDinamicText394
;impresora_termica.h,213 :: 		usart_write(strlen(ticketPointer));
	MOVF        impresoraTerm_writeDinamicText_ticketPointer_L0+0, 0 
	MOVWF       FARG_strlen_s+0 
	MOVF        impresoraTerm_writeDinamicText_ticketPointer_L0+1, 0 
	MOVWF       FARG_strlen_s+1 
	CALL        _strlen+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_usart_write_caracter+0 
	CALL        _usart_write+0, 0
L_impresoraTerm_writeDinamicText394:
;impresora_termica.h,216 :: 		cont2 = 0;
	CLRF        impresoraTerm_writeDinamicText_cont2_L0+0 
;impresora_termica.h,217 :: 		while(ticketPointer[cont2])
L_impresoraTerm_writeDinamicText395:
	MOVF        impresoraTerm_writeDinamicText_cont2_L0+0, 0 
	ADDWF       impresoraTerm_writeDinamicText_ticketPointer_L0+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      impresoraTerm_writeDinamicText_ticketPointer_L0+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_impresoraTerm_writeDinamicText396
;impresora_termica.h,218 :: 		usart_write(ticketPointer[cont2++]);
	MOVF        impresoraTerm_writeDinamicText_cont2_L0+0, 0 
	ADDWF       impresoraTerm_writeDinamicText_ticketPointer_L0+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      impresoraTerm_writeDinamicText_ticketPointer_L0+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       FARG_usart_write_caracter+0 
	CALL        _usart_write+0, 0
	INCF        impresoraTerm_writeDinamicText_cont2_L0+0, 1 
	GOTO        L_impresoraTerm_writeDinamicText395
L_impresoraTerm_writeDinamicText396:
;impresora_termica.h,219 :: 		}else if(texto[cont] == CMD_WRITE_BYTE){  //Modo beta
	GOTO        L_impresoraTerm_writeDinamicText397
L_impresoraTerm_writeDinamicText385:
	MOVF        impresoraTerm_writeDinamicText_cont_L0+0, 0 
	ADDWF       FARG_impresoraTerm_writeDinamicText_texto+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_impresoraTerm_writeDinamicText_texto+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	XORLW       4
	BTFSS       STATUS+0, 2 
	GOTO        L_impresoraTerm_writeDinamicText398
;impresora_termica.h,221 :: 		cont++;
	INCF        impresoraTerm_writeDinamicText_cont_L0+0, 1 
;impresora_termica.h,222 :: 		for(cont2 = 0; cont2 < 2 && texto[cont]; cont2++)
	CLRF        impresoraTerm_writeDinamicText_cont2_L0+0 
L_impresoraTerm_writeDinamicText399:
	MOVLW       2
	SUBWF       impresoraTerm_writeDinamicText_cont2_L0+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_impresoraTerm_writeDinamicText400
	MOVF        impresoraTerm_writeDinamicText_cont_L0+0, 0 
	ADDWF       FARG_impresoraTerm_writeDinamicText_texto+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_impresoraTerm_writeDinamicText_texto+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_impresoraTerm_writeDinamicText400
L__impresoraTerm_writeDinamicText991:
;impresora_termica.h,223 :: 		buffer[cont2] = texto[cont++];
	MOVLW       TPV_buffer+0
	MOVWF       FSR1 
	MOVLW       hi_addr(TPV_buffer+0)
	MOVWF       FSR1H 
	MOVF        impresoraTerm_writeDinamicText_cont2_L0+0, 0 
	ADDWF       FSR1, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR1H, 1 
	MOVF        impresoraTerm_writeDinamicText_cont_L0+0, 0 
	ADDWF       FARG_impresoraTerm_writeDinamicText_texto+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_impresoraTerm_writeDinamicText_texto+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       POSTINC1+0 
	INCF        impresoraTerm_writeDinamicText_cont_L0+0, 1 
;impresora_termica.h,222 :: 		for(cont2 = 0; cont2 < 2 && texto[cont]; cont2++)
	INCF        impresoraTerm_writeDinamicText_cont2_L0+0, 1 
;impresora_termica.h,223 :: 		buffer[cont2] = texto[cont++];
	GOTO        L_impresoraTerm_writeDinamicText399
L_impresoraTerm_writeDinamicText400:
;impresora_termica.h,224 :: 		buffer[cont2] = 0; //Fin de cadena
	MOVLW       TPV_buffer+0
	MOVWF       FSR1 
	MOVLW       hi_addr(TPV_buffer+0)
	MOVWF       FSR1H 
	MOVF        impresoraTerm_writeDinamicText_cont2_L0+0, 0 
	ADDWF       FSR1, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR1H, 1 
	CLRF        POSTINC1+0 
;impresora_termica.h,227 :: 		cont2 = xtoi(buffer);
	MOVLW       TPV_buffer+0
	MOVWF       FARG_xtoi_s+0 
	MOVLW       hi_addr(TPV_buffer+0)
	MOVWF       FARG_xtoi_s+1 
	CALL        _xtoi+0, 0
	MOVF        R0, 0 
	MOVWF       impresoraTerm_writeDinamicText_cont2_L0+0 
;impresora_termica.h,228 :: 		usart_write(cont2);
	MOVF        R0, 0 
	MOVWF       FARG_usart_write_caracter+0 
	CALL        _usart_write+0, 0
;impresora_termica.h,231 :: 		if(texto[cont])
	MOVF        impresoraTerm_writeDinamicText_cont_L0+0, 0 
	ADDWF       FARG_impresoraTerm_writeDinamicText_texto+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_impresoraTerm_writeDinamicText_texto+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_impresoraTerm_writeDinamicText404
;impresora_termica.h,232 :: 		cont++; //Por el final de cadena
	INCF        impresoraTerm_writeDinamicText_cont_L0+0, 1 
L_impresoraTerm_writeDinamicText404:
;impresora_termica.h,233 :: 		}else{  //Caracter normal
	GOTO        L_impresoraTerm_writeDinamicText405
L_impresoraTerm_writeDinamicText398:
;impresora_termica.h,235 :: 		usart_write(texto[cont++]);
	MOVF        impresoraTerm_writeDinamicText_cont_L0+0, 0 
	ADDWF       FARG_impresoraTerm_writeDinamicText_texto+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_impresoraTerm_writeDinamicText_texto+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       FARG_usart_write_caracter+0 
	CALL        _usart_write+0, 0
	INCF        impresoraTerm_writeDinamicText_cont_L0+0, 1 
;impresora_termica.h,236 :: 		}
L_impresoraTerm_writeDinamicText405:
L_impresoraTerm_writeDinamicText397:
L_impresoraTerm_writeDinamicText382:
;impresora_termica.h,237 :: 		}
	GOTO        L_impresoraTerm_writeDinamicText366
L_impresoraTerm_writeDinamicText367:
;impresora_termica.h,238 :: 		}
L_end_impresoraTerm_writeDinamicText:
	RETURN      0
; end of _impresoraTerm_writeDinamicText

_impresoraTerm_codBarNum:

;impresora_termica.h,240 :: 		void impresoraTerm_codBarNum(char *codigo, char format, char altura, char ancho){
;impresora_termica.h,241 :: 		impresoraTerm_cmd2(IMPT_COD_BAR_POS, format);  //Mostrar codigo de barras
	MOVLW       _IMPT_COD_BAR_POS+0
	MOVWF       FARG_impresoraTerm_cmd2_comando+0 
	MOVLW       hi_addr(_IMPT_COD_BAR_POS+0)
	MOVWF       FARG_impresoraTerm_cmd2_comando+1 
	MOVLW       higher_addr(_IMPT_COD_BAR_POS+0)
	MOVWF       FARG_impresoraTerm_cmd2_comando+2 
	MOVF        FARG_impresoraTerm_codBarNum_format+0, 0 
	MOVWF       FARG_impresoraTerm_cmd2_valor+0 
	CALL        _impresoraTerm_cmd2+0, 0
;impresora_termica.h,242 :: 		impresoraTerm_cmd2(IMPT_COD_BAR_V, altura);    //Altura del codigo de barras 1-255
	MOVLW       _IMPT_COD_BAR_V+0
	MOVWF       FARG_impresoraTerm_cmd2_comando+0 
	MOVLW       hi_addr(_IMPT_COD_BAR_V+0)
	MOVWF       FARG_impresoraTerm_cmd2_comando+1 
	MOVLW       higher_addr(_IMPT_COD_BAR_V+0)
	MOVWF       FARG_impresoraTerm_cmd2_comando+2 
	MOVF        FARG_impresoraTerm_codBarNum_altura+0, 0 
	MOVWF       FARG_impresoraTerm_cmd2_valor+0 
	CALL        _impresoraTerm_cmd2+0, 0
;impresora_termica.h,243 :: 		impresoraTerm_cmd2(IMPT_COD_BAR_H, ancho);     //Ancho codigo de barras 2-6
	MOVLW       _IMPT_COD_BAR_H+0
	MOVWF       FARG_impresoraTerm_cmd2_comando+0 
	MOVLW       hi_addr(_IMPT_COD_BAR_H+0)
	MOVWF       FARG_impresoraTerm_cmd2_comando+1 
	MOVLW       higher_addr(_IMPT_COD_BAR_H+0)
	MOVWF       FARG_impresoraTerm_cmd2_comando+2 
	MOVF        FARG_impresoraTerm_codBarNum_ancho+0, 0 
	MOVWF       FARG_impresoraTerm_cmd2_valor+0 
	CALL        _impresoraTerm_cmd2+0, 0
;impresora_termica.h,245 :: 		impresoraTerm_cmd2(IMPT_COD_BAR_C, COD_BARRAS_NUMERICO);
	MOVLW       _IMPT_COD_BAR_C+0
	MOVWF       FARG_impresoraTerm_cmd2_comando+0 
	MOVLW       hi_addr(_IMPT_COD_BAR_C+0)
	MOVWF       FARG_impresoraTerm_cmd2_comando+1 
	MOVLW       higher_addr(_IMPT_COD_BAR_C+0)
	MOVWF       FARG_impresoraTerm_cmd2_comando+2 
	MOVLW       69
	MOVWF       FARG_impresoraTerm_cmd2_valor+0 
	CALL        _impresoraTerm_cmd2+0, 0
;impresora_termica.h,246 :: 		usart_write(strlen(codigo));
	MOVF        FARG_impresoraTerm_codBarNum_codigo+0, 0 
	MOVWF       FARG_strlen_s+0 
	MOVF        FARG_impresoraTerm_codBarNum_codigo+1, 0 
	MOVWF       FARG_strlen_s+1 
	CALL        _strlen+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_usart_write_caracter+0 
	CALL        _usart_write+0, 0
;impresora_termica.h,247 :: 		usart_write_text(codigo);
	MOVF        FARG_impresoraTerm_codBarNum_codigo+0, 0 
	MOVWF       FARG_usart_write_text_texto+0 
	MOVF        FARG_impresoraTerm_codBarNum_codigo+1, 0 
	MOVWF       FARG_usart_write_text_texto+1 
	CALL        _usart_write_text+0, 0
;impresora_termica.h,248 :: 		}
L_end_impresoraTerm_codBarNum:
	RETURN      0
; end of _impresoraTerm_codBarNum

_impresoraTerm_corte:

;impresora_termica.h,250 :: 		void impresoraTerm_corte(bool cutPartial, char offset){
;impresora_termica.h,251 :: 		impresoraTerm_cmd2(IMPT_CORTE_POS, offset? CUT_POS_OFFSET: CUT_POS_ACT);
	MOVLW       _IMPT_CORTE_POS+0
	MOVWF       FARG_impresoraTerm_cmd2_comando+0 
	MOVLW       hi_addr(_IMPT_CORTE_POS+0)
	MOVWF       FARG_impresoraTerm_cmd2_comando+1 
	MOVLW       higher_addr(_IMPT_CORTE_POS+0)
	MOVWF       FARG_impresoraTerm_cmd2_comando+2 
	MOVF        FARG_impresoraTerm_corte_offset+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_impresoraTerm_corte406
	MOVLW       66
	MOVWF       ?FLOC___impresoraTerm_corteT1955+0 
	GOTO        L_impresoraTerm_corte407
L_impresoraTerm_corte406:
	MOVLW       49
	MOVWF       ?FLOC___impresoraTerm_corteT1955+0 
L_impresoraTerm_corte407:
	MOVF        ?FLOC___impresoraTerm_corteT1955+0, 0 
	MOVWF       FARG_impresoraTerm_cmd2_valor+0 
	CALL        _impresoraTerm_cmd2+0, 0
;impresora_termica.h,253 :: 		if(offset)
	MOVF        FARG_impresoraTerm_corte_offset+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_impresoraTerm_corte408
;impresora_termica.h,254 :: 		usart_write(offset);
	MOVF        FARG_impresoraTerm_corte_offset+0, 0 
	MOVWF       FARG_usart_write_caracter+0 
	CALL        _usart_write+0, 0
L_impresoraTerm_corte408:
;impresora_termica.h,257 :: 		}
L_end_impresoraTerm_corte:
	RETURN      0
; end of _impresoraTerm_corte

_I2C_soft_init:

;i2c_soft.h,16 :: 		void I2C_soft_init(){
;i2c_soft.h,18 :: 		I2C_SCLD = 1;
	BSF         I2C_SCLD+0, BitPos(I2C_SCLD+0) 
;i2c_soft.h,19 :: 		I2C_SDAD = 1;
	BSF         I2C_SDAD+0, BitPos(I2C_SDAD+0) 
;i2c_soft.h,20 :: 		}
L_end_I2C_soft_init:
	RETURN      0
; end of _I2C_soft_init

_I2C_soft_start:

;i2c_soft.h,22 :: 		void I2C_soft_start(){
;i2c_soft.h,24 :: 		I2C_SDAD = 1;
	BSF         I2C_SDAD+0, BitPos(I2C_SDAD+0) 
;i2c_soft.h,25 :: 		I2C_SCLD = 1;
	BSF         I2C_SCLD+0, BitPos(I2C_SCLD+0) 
;i2c_soft.h,26 :: 		delay_us(2);
	NOP
	NOP
	NOP
	NOP
	NOP
;i2c_soft.h,28 :: 		I2C_SDAD = 0;
	BCF         I2C_SDAD+0, BitPos(I2C_SDAD+0) 
;i2c_soft.h,29 :: 		I2C_SDA = 0;  //Señal en bajo
	BCF         I2C_SDA+0, BitPos(I2C_SDA+0) 
;i2c_soft.h,30 :: 		delay_us(2);
	NOP
	NOP
	NOP
	NOP
	NOP
;i2c_soft.h,32 :: 		I2C_SCLD = 0;
	BCF         I2C_SCLD+0, BitPos(I2C_SCLD+0) 
;i2c_soft.h,33 :: 		I2C_SCL = 0;  //Señal en bajo
	BCF         I2C_SCL+0, BitPos(I2C_SCL+0) 
;i2c_soft.h,34 :: 		}
L_end_I2C_soft_start:
	RETURN      0
; end of _I2C_soft_start

_I2C_soft_stop:

;i2c_soft.h,36 :: 		void I2C_soft_stop(){
;i2c_soft.h,37 :: 		I2C_SDAD = 0;  //Configuro de salida por seguridad
	BCF         I2C_SDAD+0, BitPos(I2C_SDAD+0) 
;i2c_soft.h,38 :: 		I2C_SDA = 0;   //Mando cero por el protocolo
	BCF         I2C_SDA+0, BitPos(I2C_SDA+0) 
;i2c_soft.h,39 :: 		delay_us(2);
	NOP
	NOP
	NOP
	NOP
	NOP
;i2c_soft.h,40 :: 		I2C_SCLD = 1;
	BSF         I2C_SCLD+0, BitPos(I2C_SCLD+0) 
;i2c_soft.h,41 :: 		delay_us(2);
	NOP
	NOP
	NOP
	NOP
	NOP
;i2c_soft.h,42 :: 		I2C_SDAD = 1;
	BSF         I2C_SDAD+0, BitPos(I2C_SDAD+0) 
;i2c_soft.h,43 :: 		}
L_end_I2C_soft_stop:
	RETURN      0
; end of _I2C_soft_stop

_I2C_soft_write:

;i2c_soft.h,45 :: 		bool I2C_soft_write(char dato){
;i2c_soft.h,49 :: 		for(i = 0; i < 8; i++){
	CLRF        R1 
L_I2C_soft_write409:
	MOVLW       8
	SUBWF       R1, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_I2C_soft_write410
;i2c_soft.h,50 :: 		I2C_SDA = dato.B7;  //El valor del bit
	BTFSC       FARG_I2C_soft_write_dato+0, 7 
	GOTO        L__I2C_soft_write1267
	BCF         I2C_SDA+0, BitPos(I2C_SDA+0) 
	GOTO        L__I2C_soft_write1268
L__I2C_soft_write1267:
	BSF         I2C_SDA+0, BitPos(I2C_SDA+0) 
L__I2C_soft_write1268:
;i2c_soft.h,51 :: 		I2C_SCL = 1;        //Activar dato
	BSF         I2C_SCL+0, BitPos(I2C_SCL+0) 
;i2c_soft.h,52 :: 		delay_us(2);
	NOP
	NOP
	NOP
	NOP
	NOP
;i2c_soft.h,53 :: 		dato <<= 1;         //Recorro hacia la izquierda
	RLCF        FARG_I2C_soft_write_dato+0, 1 
	BCF         FARG_I2C_soft_write_dato+0, 0 
;i2c_soft.h,54 :: 		I2C_SCL = 0;
	BCF         I2C_SCL+0, BitPos(I2C_SCL+0) 
;i2c_soft.h,55 :: 		delay_us(2);
	NOP
	NOP
	NOP
	NOP
	NOP
;i2c_soft.h,49 :: 		for(i = 0; i < 8; i++){
	INCF        R1, 1 
;i2c_soft.h,56 :: 		}
	GOTO        L_I2C_soft_write409
L_I2C_soft_write410:
;i2c_soft.h,59 :: 		I2C_SDAD = 1;
	BSF         I2C_SDAD+0, BitPos(I2C_SDAD+0) 
;i2c_soft.h,60 :: 		asm nop;
	NOP
;i2c_soft.h,61 :: 		I2C_SCL = 1;     //Mandar el púlso para recibir el ACK
	BSF         I2C_SCL+0, BitPos(I2C_SCL+0) 
;i2c_soft.h,62 :: 		delay_us(2);
	NOP
	NOP
	NOP
	NOP
	NOP
;i2c_soft.h,63 :: 		i.B0 = I2C_SDA;  //Guardo el valor del ACK
	BTFSC       I2C_SDA+0, BitPos(I2C_SDA+0) 
	GOTO        L__I2C_soft_write1269
	BCF         R1, 0 
	GOTO        L__I2C_soft_write1270
L__I2C_soft_write1269:
	BSF         R1, 0 
L__I2C_soft_write1270:
;i2c_soft.h,64 :: 		I2C_SCL = 0;
	BCF         I2C_SCL+0, BitPos(I2C_SCL+0) 
;i2c_soft.h,65 :: 		I2C_SDAD = 0;    //Configurar como salida el pin
	BCF         I2C_SDAD+0, BitPos(I2C_SDAD+0) 
;i2c_soft.h,67 :: 		return i.B0;
	MOVLW       0
	BTFSC       R1, 0 
	MOVLW       1
	MOVWF       R0 
;i2c_soft.h,68 :: 		}
L_end_I2C_soft_write:
	RETURN      0
; end of _I2C_soft_write

_I2C_soft_read:

;i2c_soft.h,70 :: 		char I2C_soft_read(bool ACK){
;i2c_soft.h,71 :: 		char i, result = 0;
	CLRF        I2C_soft_read_result_L0+0 
;i2c_soft.h,74 :: 		I2C_SDAD = 1;
	BSF         I2C_SDAD+0, BitPos(I2C_SDAD+0) 
;i2c_soft.h,76 :: 		for(i = 0; i < 8; i++){
	CLRF        R1 
L_I2C_soft_read412:
	MOVLW       8
	SUBWF       R1, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_I2C_soft_read413
;i2c_soft.h,77 :: 		result <<= 1;
	RLCF        I2C_soft_read_result_L0+0, 1 
	BCF         I2C_soft_read_result_L0+0, 0 
;i2c_soft.h,78 :: 		I2C_SCL = 1;
	BSF         I2C_SCL+0, BitPos(I2C_SCL+0) 
;i2c_soft.h,79 :: 		delay_us(2);
	NOP
	NOP
	NOP
	NOP
	NOP
;i2c_soft.h,81 :: 		if(I2C_SDA)
	BTFSS       I2C_SDA+0, BitPos(I2C_SDA+0) 
	GOTO        L_I2C_soft_read415
;i2c_soft.h,82 :: 		result |= 0x01;
	BSF         I2C_soft_read_result_L0+0, 0 
L_I2C_soft_read415:
;i2c_soft.h,83 :: 		I2C_SCL = 0;
	BCF         I2C_SCL+0, BitPos(I2C_SCL+0) 
;i2c_soft.h,84 :: 		delay_us(2);
	NOP
	NOP
	NOP
	NOP
	NOP
;i2c_soft.h,76 :: 		for(i = 0; i < 8; i++){
	INCF        R1, 1 
;i2c_soft.h,85 :: 		}
	GOTO        L_I2C_soft_read412
L_I2C_soft_read413:
;i2c_soft.h,88 :: 		I2C_SDAD = 0;
	BCF         I2C_SDAD+0, BitPos(I2C_SDAD+0) 
;i2c_soft.h,89 :: 		I2C_SDA = !ACK.B0;  //Señal negada
	BTFSC       FARG_I2C_soft_read_ACK+0, 0 
	GOTO        L__I2C_soft_read1272
	BSF         I2C_SDA+0, BitPos(I2C_SDA+0) 
	GOTO        L__I2C_soft_read1273
L__I2C_soft_read1272:
	BCF         I2C_SDA+0, BitPos(I2C_SDA+0) 
L__I2C_soft_read1273:
;i2c_soft.h,90 :: 		asm nop;
	NOP
;i2c_soft.h,91 :: 		I2C_SCL = 1;
	BSF         I2C_SCL+0, BitPos(I2C_SCL+0) 
;i2c_soft.h,92 :: 		delay_us(2);
	NOP
	NOP
	NOP
	NOP
	NOP
;i2c_soft.h,93 :: 		I2C_SCL = 0;
	BCF         I2C_SCL+0, BitPos(I2C_SCL+0) 
;i2c_soft.h,95 :: 		return result;
	MOVF        I2C_soft_read_result_L0+0, 0 
	MOVWF       R0 
;i2c_soft.h,96 :: 		}
L_end_I2C_soft_read:
	RETURN      0
; end of _I2C_soft_read

_eeprom_i2c_open:

;eeprom_i2c_soft.h,20 :: 		void eeprom_i2c_open(){
;eeprom_i2c_soft.h,21 :: 		I2C_soft_init();         //Initialize Soft I2C communication}
	CALL        _I2C_soft_init+0, 0
;eeprom_i2c_soft.h,22 :: 		}
L_end_eeprom_i2c_open:
	RETURN      0
; end of _eeprom_i2c_open

_eeprom_i2c_write:

;eeprom_i2c_soft.h,24 :: 		void eeprom_i2c_write(unsigned int address, char *datos, char size){
;eeprom_i2c_soft.h,25 :: 		char cont = 0;
	CLRF        eeprom_i2c_write_cont_L0+0 
;eeprom_i2c_soft.h,27 :: 		while(cont < size){
L_eeprom_i2c_write416:
	MOVF        FARG_eeprom_i2c_write_size+0, 0 
	SUBWF       eeprom_i2c_write_cont_L0+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_eeprom_i2c_write417
;eeprom_i2c_soft.h,28 :: 		I2C_soft_start();                       // Issue start signal
	CALL        _I2C_soft_start+0, 0
;eeprom_i2c_soft.h,30 :: 		I2C_soft_write(EEPROM_ADDRESS_24LC256); //Escritura e multiples bytes
	MOVLW       160
	MOVWF       FARG_I2C_soft_write_dato+0 
	CALL        _I2C_soft_write+0, 0
;eeprom_i2c_soft.h,31 :: 		I2C_soft_write(getByte(address,1));     // Start from address hihg
	MOVF        FARG_eeprom_i2c_write_address+1, 0 
	MOVWF       FARG_I2C_soft_write_dato+0 
	CALL        _I2C_soft_write+0, 0
;eeprom_i2c_soft.h,32 :: 		I2C_soft_write(getByte(address,0));     // Start from address low
	MOVF        FARG_eeprom_i2c_write_address+0, 0 
	MOVWF       FARG_I2C_soft_write_dato+0 
	CALL        _I2C_soft_write+0, 0
;eeprom_i2c_soft.h,34 :: 		for(; cont < size; cont++){
L_eeprom_i2c_write418:
	MOVF        FARG_eeprom_i2c_write_size+0, 0 
	SUBWF       eeprom_i2c_write_cont_L0+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_eeprom_i2c_write419
;eeprom_i2c_soft.h,35 :: 		I2C_soft_write(datos[cont]);           // Byte para ser escrito
	MOVF        eeprom_i2c_write_cont_L0+0, 0 
	ADDWF       FARG_eeprom_i2c_write_datos+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_eeprom_i2c_write_datos+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       FARG_I2C_soft_write_dato+0 
	CALL        _I2C_soft_write+0, 0
;eeprom_i2c_soft.h,36 :: 		if(++address%64 == 0){
	INFSNZ      FARG_eeprom_i2c_write_address+0, 1 
	INCF        FARG_eeprom_i2c_write_address+1, 1 
	MOVLW       63
	ANDWF       FARG_eeprom_i2c_write_address+0, 0 
	MOVWF       R1 
	MOVF        FARG_eeprom_i2c_write_address+1, 0 
	MOVWF       R2 
	MOVLW       0
	ANDWF       R2, 1 
	MOVLW       0
	XORWF       R2, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__eeprom_i2c_write1276
	MOVLW       0
	XORWF       R1, 0 
L__eeprom_i2c_write1276:
	BTFSS       STATUS+0, 2 
	GOTO        L_eeprom_i2c_write421
;eeprom_i2c_soft.h,37 :: 		cont++;
	INCF        eeprom_i2c_write_cont_L0+0, 1 
;eeprom_i2c_soft.h,38 :: 		break;
	GOTO        L_eeprom_i2c_write419
;eeprom_i2c_soft.h,39 :: 		}
L_eeprom_i2c_write421:
;eeprom_i2c_soft.h,34 :: 		for(; cont < size; cont++){
	INCF        eeprom_i2c_write_cont_L0+0, 1 
;eeprom_i2c_soft.h,40 :: 		}
	GOTO        L_eeprom_i2c_write418
L_eeprom_i2c_write419:
;eeprom_i2c_soft.h,41 :: 		I2C_soft_stop();                         // Issue stop signal
	CALL        _I2C_soft_stop+0, 0
;eeprom_i2c_soft.h,43 :: 		while(true){
L_eeprom_i2c_write422:
;eeprom_i2c_soft.h,44 :: 		I2C_soft_start();
	CALL        _I2C_soft_start+0, 0
;eeprom_i2c_soft.h,45 :: 		if(!I2C_soft_write(EEPROM_ADDRESS_24LC256))
	MOVLW       160
	MOVWF       FARG_I2C_soft_write_dato+0 
	CALL        _I2C_soft_write+0, 0
	MOVF        R0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_eeprom_i2c_write424
;eeprom_i2c_soft.h,46 :: 		break;
	GOTO        L_eeprom_i2c_write423
L_eeprom_i2c_write424:
;eeprom_i2c_soft.h,47 :: 		}
	GOTO        L_eeprom_i2c_write422
L_eeprom_i2c_write423:
;eeprom_i2c_soft.h,48 :: 		I2C_soft_stop();      // Issue stop signal
	CALL        _I2C_soft_stop+0, 0
;eeprom_i2c_soft.h,49 :: 		}
	GOTO        L_eeprom_i2c_write416
L_eeprom_i2c_write417:
;eeprom_i2c_soft.h,50 :: 		}
L_end_eeprom_i2c_write:
	RETURN      0
; end of _eeprom_i2c_write

_eeprom_i2c_read:

;eeprom_i2c_soft.h,52 :: 		void eeprom_i2c_read(unsigned int address, char *datos, char size){
;eeprom_i2c_soft.h,55 :: 		I2C_soft_start();                       // Issue start signal
	CALL        _I2C_soft_start+0, 0
;eeprom_i2c_soft.h,57 :: 		I2C_soft_write(EEPROM_ADDRESS_24LC256); //Escritura e multiples bytes
	MOVLW       160
	MOVWF       FARG_I2C_soft_write_dato+0 
	CALL        _I2C_soft_write+0, 0
;eeprom_i2c_soft.h,58 :: 		I2C_soft_write(getByte(address,1));     // Start from address hihg
	MOVF        FARG_eeprom_i2c_read_address+1, 0 
	MOVWF       FARG_I2C_soft_write_dato+0 
	CALL        _I2C_soft_write+0, 0
;eeprom_i2c_soft.h,59 :: 		I2C_soft_write(getByte(address,0));     // Start from address low
	MOVF        FARG_eeprom_i2c_read_address+0, 0 
	MOVWF       FARG_I2C_soft_write_dato+0 
	CALL        _I2C_soft_write+0, 0
;eeprom_i2c_soft.h,60 :: 		I2C_soft_start();                       // Issue repeated start signal
	CALL        _I2C_soft_start+0, 0
;eeprom_i2c_soft.h,61 :: 		I2C_soft_write(EEPROM_ADDRESS_24LC256|0x01);    // Address EEPROM_ADDRESS_24LC256 for reading R/W=1
	MOVLW       161
	MOVWF       FARG_I2C_soft_write_dato+0 
	CALL        _I2C_soft_write+0, 0
;eeprom_i2c_soft.h,63 :: 		for(cont = 0; cont < size-1; cont++)
	CLRF        eeprom_i2c_read_cont_L0+0 
L_eeprom_i2c_read425:
	DECF        FARG_eeprom_i2c_read_size+0, 0 
	MOVWF       R1 
	CLRF        R2 
	MOVLW       0
	SUBWFB      R2, 1 
	MOVLW       128
	MOVWF       R0 
	MOVLW       128
	XORWF       R2, 0 
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__eeprom_i2c_read1278
	MOVF        R1, 0 
	SUBWF       eeprom_i2c_read_cont_L0+0, 0 
L__eeprom_i2c_read1278:
	BTFSC       STATUS+0, 0 
	GOTO        L_eeprom_i2c_read426
;eeprom_i2c_soft.h,64 :: 		datos[cont] = I2C_soft_read(ACK);
	MOVF        eeprom_i2c_read_cont_L0+0, 0 
	ADDWF       FARG_eeprom_i2c_read_datos+0, 0 
	MOVWF       FLOC__eeprom_i2c_read+0 
	MOVLW       0
	ADDWFC      FARG_eeprom_i2c_read_datos+1, 0 
	MOVWF       FLOC__eeprom_i2c_read+1 
	MOVLW       1
	MOVWF       FARG_I2C_soft_read_ACK+0 
	CALL        _I2C_soft_read+0, 0
	MOVFF       FLOC__eeprom_i2c_read+0, FSR1
	MOVFF       FLOC__eeprom_i2c_read+1, FSR1H
	MOVF        R0, 0 
	MOVWF       POSTINC1+0 
;eeprom_i2c_soft.h,63 :: 		for(cont = 0; cont < size-1; cont++)
	INCF        eeprom_i2c_read_cont_L0+0, 1 
;eeprom_i2c_soft.h,64 :: 		datos[cont] = I2C_soft_read(ACK);
	GOTO        L_eeprom_i2c_read425
L_eeprom_i2c_read426:
;eeprom_i2c_soft.h,65 :: 		datos[cont] = I2C_soft_read(NO_ACK);
	MOVF        eeprom_i2c_read_cont_L0+0, 0 
	ADDWF       FARG_eeprom_i2c_read_datos+0, 0 
	MOVWF       FLOC__eeprom_i2c_read+0 
	MOVLW       0
	ADDWFC      FARG_eeprom_i2c_read_datos+1, 0 
	MOVWF       FLOC__eeprom_i2c_read+1 
	CLRF        FARG_I2C_soft_read_ACK+0 
	CALL        _I2C_soft_read+0, 0
	MOVFF       FLOC__eeprom_i2c_read+0, FSR1
	MOVFF       FLOC__eeprom_i2c_read+1, FSR1H
	MOVF        R0, 0 
	MOVWF       POSTINC1+0 
;eeprom_i2c_soft.h,66 :: 		I2C_soft_stop();                                // Issue stop signal
	CALL        _I2C_soft_stop+0, 0
;eeprom_i2c_soft.h,67 :: 		}
L_end_eeprom_i2c_read:
	RETURN      0
; end of _eeprom_i2c_read

_mysql_reset:

;table_eeprom.h,58 :: 		void mysql_reset(){
;table_eeprom.h,59 :: 		myTable.numTables = 0;
	CLRF        TPV_myTable+0 
;table_eeprom.h,60 :: 		myTable.size = 3;   //Tamaño actual ocupado, num tables y tamaño actual
	MOVLW       3
	MOVWF       TPV_myTable+41 
	MOVLW       0
	MOVWF       TPV_myTable+42 
;table_eeprom.h,62 :: 		eeprom_i2c_write(0x0000, &myTable.numTables, 1);
	CLRF        FARG_eeprom_i2c_write_address+0 
	CLRF        FARG_eeprom_i2c_write_address+1 
	MOVLW       TPV_myTable+0
	MOVWF       FARG_eeprom_i2c_write_datos+0 
	MOVLW       hi_addr(TPV_myTable+0)
	MOVWF       FARG_eeprom_i2c_write_datos+1 
	MOVLW       1
	MOVWF       FARG_eeprom_i2c_write_size+0 
	CALL        _eeprom_i2c_write+0, 0
;table_eeprom.h,63 :: 		eeprom_i2c_write(0x0001,(char*)&myTable.size, 2);
	MOVLW       1
	MOVWF       FARG_eeprom_i2c_write_address+0 
	MOVLW       0
	MOVWF       FARG_eeprom_i2c_write_address+1 
	MOVLW       TPV_myTable+41
	MOVWF       FARG_eeprom_i2c_write_datos+0 
	MOVLW       hi_addr(TPV_myTable+41)
	MOVWF       FARG_eeprom_i2c_write_datos+1 
	MOVLW       2
	MOVWF       FARG_eeprom_i2c_write_size+0 
	CALL        _eeprom_i2c_write+0, 0
;table_eeprom.h,64 :: 		}
L_end_mysql_reset:
	RETURN      0
; end of _mysql_reset

_mysql_init:

;table_eeprom.h,66 :: 		void mysql_init(unsigned int memoryMax){
;table_eeprom.h,68 :: 		myTable.col = 0;
	CLRF        TPV_myTable+1 
;table_eeprom.h,69 :: 		myTable.row = 0;
	CLRF        TPV_myTable+2 
	CLRF        TPV_myTable+3 
;table_eeprom.h,70 :: 		myTable.rowAct = 0;
	CLRF        TPV_myTable+4 
	CLRF        TPV_myTable+5 
;table_eeprom.h,71 :: 		myTable.nameAct[0] = 0;          //Inicializar cadena en cero
	CLRF        TPV_myTable+7 
;table_eeprom.h,72 :: 		myTable.nameColAct[0] = 0;
	CLRF        TPV_myTable+23 
;table_eeprom.h,73 :: 		myTable.sizeMax = memoryMax;
	MOVF        FARG_mysql_init_memoryMax+0, 0 
	MOVWF       TPV_myTable+39 
	MOVF        FARG_mysql_init_memoryMax+1, 0 
	MOVWF       TPV_myTable+40 
;table_eeprom.h,75 :: 		eeprom_i2c_open();  //Preguntamos si deseo resetear la memoria
	CALL        _eeprom_i2c_open+0, 0
;table_eeprom.h,76 :: 		eeprom_i2c_read(0x0000,&myTable.numTables, 1);
	CLRF        FARG_eeprom_i2c_read_address+0 
	CLRF        FARG_eeprom_i2c_read_address+1 
	MOVLW       TPV_myTable+0
	MOVWF       FARG_eeprom_i2c_read_datos+0 
	MOVLW       hi_addr(TPV_myTable+0)
	MOVWF       FARG_eeprom_i2c_read_datos+1 
	MOVLW       1
	MOVWF       FARG_eeprom_i2c_read_size+0 
	CALL        _eeprom_i2c_read+0, 0
;table_eeprom.h,77 :: 		eeprom_i2c_read(0x0001,(char*)&myTable.size, 2);
	MOVLW       1
	MOVWF       FARG_eeprom_i2c_read_address+0 
	MOVLW       0
	MOVWF       FARG_eeprom_i2c_read_address+1 
	MOVLW       TPV_myTable+41
	MOVWF       FARG_eeprom_i2c_read_datos+0 
	MOVLW       hi_addr(TPV_myTable+41)
	MOVWF       FARG_eeprom_i2c_read_datos+1 
	MOVLW       2
	MOVWF       FARG_eeprom_i2c_read_size+0 
	CALL        _eeprom_i2c_read+0, 0
;table_eeprom.h,78 :: 		}
L_end_mysql_init:
	RETURN      0
; end of _mysql_init

_mysql_exist:

;table_eeprom.h,80 :: 		bool mysql_exist(char *name){
;table_eeprom.h,81 :: 		myTable.address = 0x0003;  //Direccion 3 para lectura
	MOVLW       3
	MOVWF       TPV_myTable+43 
	MOVLW       0
	MOVWF       TPV_myTable+44 
;table_eeprom.h,82 :: 		myTable.nameColAct[0] = 0; //Resetear mensaje
	CLRF        TPV_myTable+23 
;table_eeprom.h,84 :: 		for(myTable.cont = 0; myTable.cont < myTable.numTables; myTable.cont++){
	CLRF        TPV_myTable+47 
L_mysql_exist428:
	MOVF        TPV_myTable+0, 0 
	SUBWF       TPV_myTable+47, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_mysql_exist429
;table_eeprom.h,86 :: 		eeprom_i2c_read(myTable.address, myTable.nameAct, TABLE_MAX_SIZE_NAME+1);
	MOVF        TPV_myTable+43, 0 
	MOVWF       FARG_eeprom_i2c_read_address+0 
	MOVF        TPV_myTable+44, 0 
	MOVWF       FARG_eeprom_i2c_read_address+1 
	MOVLW       TPV_myTable+7
	MOVWF       FARG_eeprom_i2c_read_datos+0 
	MOVLW       hi_addr(TPV_myTable+7)
	MOVWF       FARG_eeprom_i2c_read_datos+1 
	MOVLW       16
	MOVWF       FARG_eeprom_i2c_read_size+0 
	CALL        _eeprom_i2c_read+0, 0
;table_eeprom.h,88 :: 		if(!strncmp(name, myTable.nameAct, TABLE_MAX_SIZE_NAME+1))
	MOVF        FARG_mysql_exist_name+0, 0 
	MOVWF       FARG_strncmp_s1+0 
	MOVF        FARG_mysql_exist_name+1, 0 
	MOVWF       FARG_strncmp_s1+1 
	MOVLW       TPV_myTable+7
	MOVWF       FARG_strncmp_s2+0 
	MOVLW       hi_addr(TPV_myTable+7)
	MOVWF       FARG_strncmp_s2+1 
	MOVLW       16
	MOVWF       FARG_strncmp_len+0 
	CALL        _strncmp+0, 0
	MOVF        R0, 0 
	IORWF       R1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L_mysql_exist431
;table_eeprom.h,89 :: 		break;
	GOTO        L_mysql_exist429
L_mysql_exist431:
;table_eeprom.h,91 :: 		eeprom_i2c_read(myTable.address+TABLE_MAX_SIZE_NAME+1, (char*)&myTable.address, 2);
	MOVLW       15
	ADDWF       TPV_myTable+43, 0 
	MOVWF       FARG_eeprom_i2c_read_address+0 
	MOVLW       0
	ADDWFC      TPV_myTable+44, 0 
	MOVWF       FARG_eeprom_i2c_read_address+1 
	INFSNZ      FARG_eeprom_i2c_read_address+0, 1 
	INCF        FARG_eeprom_i2c_read_address+1, 1 
	MOVLW       TPV_myTable+43
	MOVWF       FARG_eeprom_i2c_read_datos+0 
	MOVLW       hi_addr(TPV_myTable+43)
	MOVWF       FARG_eeprom_i2c_read_datos+1 
	MOVLW       2
	MOVWF       FARG_eeprom_i2c_read_size+0 
	CALL        _eeprom_i2c_read+0, 0
;table_eeprom.h,84 :: 		for(myTable.cont = 0; myTable.cont < myTable.numTables; myTable.cont++){
	MOVF        TPV_myTable+47, 0 
	ADDLW       1
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       TPV_myTable+47 
;table_eeprom.h,92 :: 		}
	GOTO        L_mysql_exist428
L_mysql_exist429:
;table_eeprom.h,94 :: 		if(myTable.cont < myTable.numTables){
	MOVF        TPV_myTable+0, 0 
	SUBWF       TPV_myTable+47, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_mysql_exist432
;table_eeprom.h,95 :: 		myTable.addressAct = myTable.address;   //Copiar direccion casa de la tabla
	MOVF        TPV_myTable+43, 0 
	MOVWF       TPV_myTable+45 
	MOVF        TPV_myTable+44, 0 
	MOVWF       TPV_myTable+46 
;table_eeprom.h,97 :: 		myTable.addressAct += TABLE_MAX_SIZE_NAME+3;
	MOVLW       18
	ADDWF       TPV_myTable+43, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      TPV_myTable+44, 0 
	MOVWF       R1 
	MOVF        R0, 0 
	MOVWF       TPV_myTable+45 
	MOVF        R1, 0 
	MOVWF       TPV_myTable+46 
;table_eeprom.h,98 :: 		eeprom_i2c_read(myTable.addressAct,(char*)&myTable.rowAct, 2);
	MOVF        R0, 0 
	MOVWF       FARG_eeprom_i2c_read_address+0 
	MOVF        R1, 0 
	MOVWF       FARG_eeprom_i2c_read_address+1 
	MOVLW       TPV_myTable+4
	MOVWF       FARG_eeprom_i2c_read_datos+0 
	MOVLW       hi_addr(TPV_myTable+4)
	MOVWF       FARG_eeprom_i2c_read_datos+1 
	MOVLW       2
	MOVWF       FARG_eeprom_i2c_read_size+0 
	CALL        _eeprom_i2c_read+0, 0
;table_eeprom.h,99 :: 		eeprom_i2c_read(myTable.addressAct+2,(char*)&myTable.row, 2);
	MOVLW       2
	ADDWF       TPV_myTable+45, 0 
	MOVWF       FARG_eeprom_i2c_read_address+0 
	MOVLW       0
	ADDWFC      TPV_myTable+46, 0 
	MOVWF       FARG_eeprom_i2c_read_address+1 
	MOVLW       TPV_myTable+2
	MOVWF       FARG_eeprom_i2c_read_datos+0 
	MOVLW       hi_addr(TPV_myTable+2)
	MOVWF       FARG_eeprom_i2c_read_datos+1 
	MOVLW       2
	MOVWF       FARG_eeprom_i2c_read_size+0 
	CALL        _eeprom_i2c_read+0, 0
;table_eeprom.h,100 :: 		eeprom_i2c_read(myTable.addressAct+4,&myTable.col, 1); //Filas totales de busqueda
	MOVLW       4
	ADDWF       TPV_myTable+45, 0 
	MOVWF       FARG_eeprom_i2c_read_address+0 
	MOVLW       0
	ADDWFC      TPV_myTable+46, 0 
	MOVWF       FARG_eeprom_i2c_read_address+1 
	MOVLW       TPV_myTable+1
	MOVWF       FARG_eeprom_i2c_read_datos+0 
	MOVLW       hi_addr(TPV_myTable+1)
	MOVWF       FARG_eeprom_i2c_read_datos+1 
	MOVLW       1
	MOVWF       FARG_eeprom_i2c_read_size+0 
	CALL        _eeprom_i2c_read+0, 0
;table_eeprom.h,101 :: 		return true;
	MOVLW       1
	MOVWF       R0 
	GOTO        L_end_mysql_exist
;table_eeprom.h,102 :: 		}else{
L_mysql_exist432:
;table_eeprom.h,103 :: 		myTable.nameAct[0] = 0;
	CLRF        TPV_myTable+7 
;table_eeprom.h,104 :: 		return false;
	CLRF        R0 
;table_eeprom.h,106 :: 		}
L_end_mysql_exist:
	RETURN      0
; end of _mysql_exist

_mysql_create_new:

;table_eeprom.h,108 :: 		char mysql_create_new(char *name, char *columnas, int filas){
;table_eeprom.h,109 :: 		unsigned int tam, acum = 0;   //Tamño a ser escrito
	CLRF        mysql_create_new_acum_L0+0 
	CLRF        mysql_create_new_acum_L0+1 
;table_eeprom.h,114 :: 		if(strlen(name) > TABLE_MAX_SIZE_NAME){
	MOVF        FARG_mysql_create_new_name+0, 0 
	MOVWF       FARG_strlen_s+0 
	MOVF        FARG_mysql_create_new_name+1, 0 
	MOVWF       FARG_strlen_s+1 
	CALL        _strlen+0, 0
	MOVLW       128
	MOVWF       R2 
	MOVLW       128
	XORWF       R1, 0 
	SUBWF       R2, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__mysql_create_new1283
	MOVF        R0, 0 
	SUBLW       15
L__mysql_create_new1283:
	BTFSC       STATUS+0, 0 
	GOTO        L_mysql_create_new434
;table_eeprom.h,115 :: 		return TABLE_CREATE_NAME_OUT_RANGE;     //Excede el tamaño del nombre permisible
	MOVLW       1
	MOVWF       R0 
	GOTO        L_end_mysql_create_new
;table_eeprom.h,116 :: 		}
L_mysql_create_new434:
;table_eeprom.h,118 :: 		if(!mysql_exist(name)){
	MOVF        FARG_mysql_create_new_name+0, 0 
	MOVWF       FARG_mysql_exist_name+0 
	MOVF        FARG_mysql_create_new_name+1, 0 
	MOVWF       FARG_mysql_exist_name+1 
	CALL        _mysql_exist+0, 0
	MOVF        R0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_mysql_create_new435
;table_eeprom.h,120 :: 		col = 0;
	CLRF        mysql_create_new_col_L0+0 
;table_eeprom.h,121 :: 		myTable.cont = 0;
	CLRF        TPV_myTable+47 
;table_eeprom.h,122 :: 		tam = TABLE_MAX_SIZE_NAME+1;   //Tamaño por el nombre
	MOVLW       16
	MOVWF       mysql_create_new_tam_L0+0 
	MOVLW       0
	MOVWF       mysql_create_new_tam_L0+1 
;table_eeprom.h,123 :: 		tam += 2;                      //Contiene el tamaño de la tabla
	MOVLW       18
	MOVWF       mysql_create_new_tam_L0+0 
	MOVLW       0
	MOVWF       mysql_create_new_tam_L0+1 
;table_eeprom.h,124 :: 		tam += 2;                      //Contiene la fila actual
	MOVLW       20
	MOVWF       mysql_create_new_tam_L0+0 
	MOVLW       0
	MOVWF       mysql_create_new_tam_L0+1 
;table_eeprom.h,125 :: 		tam += 2;                      //Contiene las filas programadas
	MOVLW       22
	MOVWF       mysql_create_new_tam_L0+0 
	MOVLW       0
	MOVWF       mysql_create_new_tam_L0+1 
;table_eeprom.h,126 :: 		tam += 1;                      //Contiene la columnas programadas
	MOVLW       23
	MOVWF       mysql_create_new_tam_L0+0 
	MOVLW       0
	MOVWF       mysql_create_new_tam_L0+1 
;table_eeprom.h,129 :: 		aux = 0;
	CLRF        mysql_create_new_aux_L0+0 
;table_eeprom.h,130 :: 		while(columnas[myTable.cont]){
L_mysql_create_new436:
	MOVF        TPV_myTable+47, 0 
	ADDWF       FARG_mysql_create_new_columnas+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_mysql_create_new_columnas+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_mysql_create_new437
;table_eeprom.h,131 :: 		aux++;
	INCF        mysql_create_new_aux_L0+0, 1 
;table_eeprom.h,133 :: 		if(columnas[myTable.cont++] == '&'){
	MOVF        TPV_myTable+47, 0 
	MOVWF       R1 
	MOVF        TPV_myTable+47, 0 
	ADDLW       1
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       TPV_myTable+47 
	MOVF        R1, 0 
	ADDWF       FARG_mysql_create_new_columnas+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_mysql_create_new_columnas+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	XORLW       38
	BTFSS       STATUS+0, 2 
	GOTO        L_mysql_create_new438
;table_eeprom.h,135 :: 		if(aux > TABLE_MAX_SIZE_NAME+1){
	MOVLW       128
	XORLW       0
	MOVWF       R0 
	MOVLW       128
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__mysql_create_new1284
	MOVF        mysql_create_new_aux_L0+0, 0 
	SUBLW       16
L__mysql_create_new1284:
	BTFSC       STATUS+0, 0 
	GOTO        L_mysql_create_new439
;table_eeprom.h,136 :: 		return TABLE_CREATE_NAME_COL_OUT_RANGE;  //Excede el tamaño del nombre de la columna
	MOVLW       2
	MOVWF       R0 
	GOTO        L_end_mysql_create_new
;table_eeprom.h,137 :: 		}
L_mysql_create_new439:
;table_eeprom.h,138 :: 		aux = 0;                        //Resetear
	CLRF        mysql_create_new_aux_L0+0 
;table_eeprom.h,139 :: 		tam += TABLE_MAX_SIZE_NAME+1;   //Agregamos el texto de la columna
	MOVLW       16
	ADDWF       mysql_create_new_tam_L0+0, 1 
	MOVLW       0
	ADDWFC      mysql_create_new_tam_L0+1, 1 
;table_eeprom.h,140 :: 		tam += 1;                       //El espacio ocupado por la columna
	INFSNZ      mysql_create_new_tam_L0+0, 1 
	INCF        mysql_create_new_tam_L0+1, 1 
;table_eeprom.h,142 :: 		i = 0;    //Para guardar la cadena numero
	CLRF        mysql_create_new_i_L0+0 
;table_eeprom.h,143 :: 		while(columnas[myTable.cont] != '\n' && columnas[myTable.cont])
L_mysql_create_new440:
	MOVF        TPV_myTable+47, 0 
	ADDWF       FARG_mysql_create_new_columnas+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_mysql_create_new_columnas+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	XORLW       10
	BTFSC       STATUS+0, 2 
	GOTO        L_mysql_create_new441
	MOVF        TPV_myTable+47, 0 
	ADDWF       FARG_mysql_create_new_columnas+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_mysql_create_new_columnas+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_mysql_create_new441
L__mysql_create_new996:
;table_eeprom.h,144 :: 		cad[i++] = columnas[myTable.cont++];
	MOVLW       mysql_create_new_cad_L0+0
	MOVWF       FSR1 
	MOVLW       hi_addr(mysql_create_new_cad_L0+0)
	MOVWF       FSR1H 
	MOVF        mysql_create_new_i_L0+0, 0 
	ADDWF       FSR1, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR1H, 1 
	MOVF        TPV_myTable+47, 0 
	ADDWF       FARG_mysql_create_new_columnas+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_mysql_create_new_columnas+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       POSTINC1+0 
	INCF        mysql_create_new_i_L0+0, 1 
	MOVF        TPV_myTable+47, 0 
	ADDLW       1
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       TPV_myTable+47 
	GOTO        L_mysql_create_new440
L_mysql_create_new441:
;table_eeprom.h,145 :: 		col++;                       //Nueva columna
	INCF        mysql_create_new_col_L0+0, 1 
;table_eeprom.h,146 :: 		cad[i] = 0;                  //Agregar final de cadena
	MOVLW       mysql_create_new_cad_L0+0
	MOVWF       FSR1 
	MOVLW       hi_addr(mysql_create_new_cad_L0+0)
	MOVWF       FSR1H 
	MOVF        mysql_create_new_i_L0+0, 0 
	ADDWF       FSR1, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR1H, 1 
	CLRF        POSTINC1+0 
;table_eeprom.h,147 :: 		tam += filas*atoi(cad);      //Filas*col
	MOVLW       mysql_create_new_cad_L0+0
	MOVWF       FARG_atoi_s+0 
	MOVLW       hi_addr(mysql_create_new_cad_L0+0)
	MOVWF       FARG_atoi_s+1 
	CALL        _atoi+0, 0
	MOVF        FARG_mysql_create_new_filas+0, 0 
	MOVWF       R4 
	MOVF        FARG_mysql_create_new_filas+1, 0 
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	MOVF        R0, 0 
	ADDWF       mysql_create_new_tam_L0+0, 1 
	MOVF        R1, 0 
	ADDWFC      mysql_create_new_tam_L0+1, 1 
;table_eeprom.h,148 :: 		}
L_mysql_create_new438:
;table_eeprom.h,149 :: 		}
	GOTO        L_mysql_create_new436
L_mysql_create_new437:
;table_eeprom.h,152 :: 		if(myTable.size+tam < myTable.sizeMax){
	MOVF        mysql_create_new_tam_L0+0, 0 
	ADDWF       TPV_myTable+41, 0 
	MOVWF       R1 
	MOVF        mysql_create_new_tam_L0+1, 0 
	ADDWFC      TPV_myTable+42, 0 
	MOVWF       R2 
	MOVF        TPV_myTable+40, 0 
	SUBWF       R2, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__mysql_create_new1285
	MOVF        TPV_myTable+39, 0 
	SUBWF       R1, 0 
L__mysql_create_new1285:
	BTFSC       STATUS+0, 0 
	GOTO        L_mysql_create_new444
;table_eeprom.h,153 :: 		aux = 0;
	CLRF        mysql_create_new_aux_L0+0 
;table_eeprom.h,154 :: 		tam += myTable.size;
	MOVF        TPV_myTable+41, 0 
	ADDWF       mysql_create_new_tam_L0+0, 1 
	MOVF        TPV_myTable+42, 0 
	ADDWFC      mysql_create_new_tam_L0+1, 1 
;table_eeprom.h,156 :: 		eeprom_i2c_write(myTable.size, name, strlen(name)+1);
	MOVF        FARG_mysql_create_new_name+0, 0 
	MOVWF       FARG_strlen_s+0 
	MOVF        FARG_mysql_create_new_name+1, 0 
	MOVWF       FARG_strlen_s+1 
	CALL        _strlen+0, 0
	MOVF        R0, 0 
	ADDLW       1
	MOVWF       FARG_eeprom_i2c_write_size+0 
	MOVF        TPV_myTable+41, 0 
	MOVWF       FARG_eeprom_i2c_write_address+0 
	MOVF        TPV_myTable+42, 0 
	MOVWF       FARG_eeprom_i2c_write_address+1 
	MOVF        FARG_mysql_create_new_name+0, 0 
	MOVWF       FARG_eeprom_i2c_write_datos+0 
	MOVF        FARG_mysql_create_new_name+1, 0 
	MOVWF       FARG_eeprom_i2c_write_datos+1 
	CALL        _eeprom_i2c_write+0, 0
;table_eeprom.h,157 :: 		myTable.size += TABLE_MAX_SIZE_NAME+1;  //Sumar cantidad actual
	MOVLW       16
	ADDWF       TPV_myTable+41, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      TPV_myTable+42, 0 
	MOVWF       R1 
	MOVF        R0, 0 
	MOVWF       TPV_myTable+41 
	MOVF        R1, 0 
	MOVWF       TPV_myTable+42 
;table_eeprom.h,159 :: 		eeprom_i2c_write(myTable.size, (char*)&tam, 2);
	MOVF        R0, 0 
	MOVWF       FARG_eeprom_i2c_write_address+0 
	MOVF        R1, 0 
	MOVWF       FARG_eeprom_i2c_write_address+1 
	MOVLW       mysql_create_new_tam_L0+0
	MOVWF       FARG_eeprom_i2c_write_datos+0 
	MOVLW       hi_addr(mysql_create_new_tam_L0+0)
	MOVWF       FARG_eeprom_i2c_write_datos+1 
	MOVLW       2
	MOVWF       FARG_eeprom_i2c_write_size+0 
	CALL        _eeprom_i2c_write+0, 0
;table_eeprom.h,160 :: 		myTable.size += 2;
	MOVLW       2
	ADDWF       TPV_myTable+41, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      TPV_myTable+42, 0 
	MOVWF       R1 
	MOVF        R0, 0 
	MOVWF       TPV_myTable+41 
	MOVF        R1, 0 
	MOVWF       TPV_myTable+42 
;table_eeprom.h,162 :: 		myTable.rowAct = 0;  //Reutilizar para filas actuales
	CLRF        TPV_myTable+4 
	CLRF        TPV_myTable+5 
;table_eeprom.h,163 :: 		eeprom_i2c_write(myTable.size, (char*)&myTable.rowAct, 2);
	MOVF        TPV_myTable+41, 0 
	MOVWF       FARG_eeprom_i2c_write_address+0 
	MOVF        TPV_myTable+42, 0 
	MOVWF       FARG_eeprom_i2c_write_address+1 
	MOVLW       TPV_myTable+4
	MOVWF       FARG_eeprom_i2c_write_datos+0 
	MOVLW       hi_addr(TPV_myTable+4)
	MOVWF       FARG_eeprom_i2c_write_datos+1 
	MOVLW       2
	MOVWF       FARG_eeprom_i2c_write_size+0 
	CALL        _eeprom_i2c_write+0, 0
;table_eeprom.h,164 :: 		myTable.size += 2;
	MOVLW       2
	ADDWF       TPV_myTable+41, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      TPV_myTable+42, 0 
	MOVWF       R1 
	MOVF        R0, 0 
	MOVWF       TPV_myTable+41 
	MOVF        R1, 0 
	MOVWF       TPV_myTable+42 
;table_eeprom.h,166 :: 		eeprom_i2c_write(myTable.size, (char*)&filas, 2);
	MOVF        R0, 0 
	MOVWF       FARG_eeprom_i2c_write_address+0 
	MOVF        R1, 0 
	MOVWF       FARG_eeprom_i2c_write_address+1 
	MOVLW       FARG_mysql_create_new_filas+0
	MOVWF       FARG_eeprom_i2c_write_datos+0 
	MOVLW       hi_addr(FARG_mysql_create_new_filas+0)
	MOVWF       FARG_eeprom_i2c_write_datos+1 
	MOVLW       2
	MOVWF       FARG_eeprom_i2c_write_size+0 
	CALL        _eeprom_i2c_write+0, 0
;table_eeprom.h,167 :: 		myTable.size += 2;
	MOVLW       2
	ADDWF       TPV_myTable+41, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      TPV_myTable+42, 0 
	MOVWF       R1 
	MOVF        R0, 0 
	MOVWF       TPV_myTable+41 
	MOVF        R1, 0 
	MOVWF       TPV_myTable+42 
;table_eeprom.h,169 :: 		eeprom_i2c_write(myTable.size, &col, 1);
	MOVF        R0, 0 
	MOVWF       FARG_eeprom_i2c_write_address+0 
	MOVF        R1, 0 
	MOVWF       FARG_eeprom_i2c_write_address+1 
	MOVLW       mysql_create_new_col_L0+0
	MOVWF       FARG_eeprom_i2c_write_datos+0 
	MOVLW       hi_addr(mysql_create_new_col_L0+0)
	MOVWF       FARG_eeprom_i2c_write_datos+1 
	MOVLW       1
	MOVWF       FARG_eeprom_i2c_write_size+0 
	CALL        _eeprom_i2c_write+0, 0
;table_eeprom.h,170 :: 		myTable.size += 1;
	MOVLW       1
	ADDWF       TPV_myTable+41, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      TPV_myTable+42, 0 
	MOVWF       R1 
	MOVF        R0, 0 
	MOVWF       TPV_myTable+41 
	MOVF        R1, 0 
	MOVWF       TPV_myTable+42 
;table_eeprom.h,172 :: 		myTable.cont = 0;    //Contador actual
	CLRF        TPV_myTable+47 
;table_eeprom.h,173 :: 		tam = myTable.size;  //Reutilizar el dato momentaneamente
	MOVF        TPV_myTable+41, 0 
	MOVWF       mysql_create_new_tam_L0+0 
	MOVF        TPV_myTable+42, 0 
	MOVWF       mysql_create_new_tam_L0+1 
;table_eeprom.h,175 :: 		while(columnas[myTable.cont]){
L_mysql_create_new445:
	MOVF        TPV_myTable+47, 0 
	ADDWF       FARG_mysql_create_new_columnas+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_mysql_create_new_columnas+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_mysql_create_new446
;table_eeprom.h,177 :: 		eeprom_i2c_write(tam++, &columnas[myTable.cont++], 1);
	MOVF        mysql_create_new_tam_L0+0, 0 
	MOVWF       FARG_eeprom_i2c_write_address+0 
	MOVF        mysql_create_new_tam_L0+1, 0 
	MOVWF       FARG_eeprom_i2c_write_address+1 
	MOVF        TPV_myTable+47, 0 
	ADDWF       FARG_mysql_create_new_columnas+0, 0 
	MOVWF       FARG_eeprom_i2c_write_datos+0 
	MOVLW       0
	ADDWFC      FARG_mysql_create_new_columnas+1, 0 
	MOVWF       FARG_eeprom_i2c_write_datos+1 
	MOVLW       1
	MOVWF       FARG_eeprom_i2c_write_size+0 
	CALL        _eeprom_i2c_write+0, 0
	INFSNZ      mysql_create_new_tam_L0+0, 1 
	INCF        mysql_create_new_tam_L0+1, 1 
	MOVF        TPV_myTable+47, 0 
	ADDLW       1
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       TPV_myTable+47 
;table_eeprom.h,179 :: 		if(columnas[myTable.cont] == '&'){
	MOVF        TPV_myTable+47, 0 
	ADDWF       FARG_mysql_create_new_columnas+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_mysql_create_new_columnas+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	XORLW       38
	BTFSS       STATUS+0, 2 
	GOTO        L_mysql_create_new447
;table_eeprom.h,180 :: 		myTable.cont++;
	MOVF        TPV_myTable+47, 0 
	ADDLW       1
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       TPV_myTable+47 
;table_eeprom.h,181 :: 		eeprom_i2c_write(tam++, &aux, 1);        //Final de cadena
	MOVF        mysql_create_new_tam_L0+0, 0 
	MOVWF       FARG_eeprom_i2c_write_address+0 
	MOVF        mysql_create_new_tam_L0+1, 0 
	MOVWF       FARG_eeprom_i2c_write_address+1 
	MOVLW       mysql_create_new_aux_L0+0
	MOVWF       FARG_eeprom_i2c_write_datos+0 
	MOVLW       hi_addr(mysql_create_new_aux_L0+0)
	MOVWF       FARG_eeprom_i2c_write_datos+1 
	MOVLW       1
	MOVWF       FARG_eeprom_i2c_write_size+0 
	CALL        _eeprom_i2c_write+0, 0
	INFSNZ      mysql_create_new_tam_L0+0, 1 
	INCF        mysql_create_new_tam_L0+1, 1 
;table_eeprom.h,182 :: 		myTable.size += TABLE_MAX_SIZE_NAME+1;   //Agregamos el texto de la columna
	MOVLW       16
	ADDWF       TPV_myTable+41, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      TPV_myTable+42, 0 
	MOVWF       R1 
	MOVF        R0, 0 
	MOVWF       TPV_myTable+41 
	MOVF        R1, 0 
	MOVWF       TPV_myTable+42 
;table_eeprom.h,184 :: 		i = 0;    //Para guardar la cadena numero
	CLRF        mysql_create_new_i_L0+0 
;table_eeprom.h,185 :: 		while(columnas[myTable.cont]){
L_mysql_create_new448:
	MOVF        TPV_myTable+47, 0 
	ADDWF       FARG_mysql_create_new_columnas+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_mysql_create_new_columnas+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_mysql_create_new449
;table_eeprom.h,186 :: 		cad[i++] = columnas[myTable.cont++];
	MOVLW       mysql_create_new_cad_L0+0
	MOVWF       FSR1 
	MOVLW       hi_addr(mysql_create_new_cad_L0+0)
	MOVWF       FSR1H 
	MOVF        mysql_create_new_i_L0+0, 0 
	ADDWF       FSR1, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR1H, 1 
	MOVF        TPV_myTable+47, 0 
	ADDWF       FARG_mysql_create_new_columnas+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_mysql_create_new_columnas+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       POSTINC1+0 
	INCF        mysql_create_new_i_L0+0, 1 
	MOVF        TPV_myTable+47, 0 
	ADDLW       1
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       TPV_myTable+47 
;table_eeprom.h,187 :: 		if(columnas[myTable.cont] == '\n'){
	MOVF        TPV_myTable+47, 0 
	ADDWF       FARG_mysql_create_new_columnas+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_mysql_create_new_columnas+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	XORLW       10
	BTFSS       STATUS+0, 2 
	GOTO        L_mysql_create_new450
;table_eeprom.h,188 :: 		myTable.cont++;
	MOVF        TPV_myTable+47, 0 
	ADDLW       1
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       TPV_myTable+47 
;table_eeprom.h,189 :: 		break;
	GOTO        L_mysql_create_new449
;table_eeprom.h,190 :: 		}
L_mysql_create_new450:
;table_eeprom.h,191 :: 		}
	GOTO        L_mysql_create_new448
L_mysql_create_new449:
;table_eeprom.h,192 :: 		cad[i] = 0;                  //Agregar final de cadena
	MOVLW       mysql_create_new_cad_L0+0
	MOVWF       FSR1 
	MOVLW       hi_addr(mysql_create_new_cad_L0+0)
	MOVWF       FSR1H 
	MOVF        mysql_create_new_i_L0+0, 0 
	ADDWF       FSR1, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR1H, 1 
	CLRF        POSTINC1+0 
;table_eeprom.h,193 :: 		col = atoi(cad);
	MOVLW       mysql_create_new_cad_L0+0
	MOVWF       FARG_atoi_s+0 
	MOVLW       hi_addr(mysql_create_new_cad_L0+0)
	MOVWF       FARG_atoi_s+1 
	CALL        _atoi+0, 0
	MOVF        R0, 0 
	MOVWF       mysql_create_new_col_L0+0 
;table_eeprom.h,194 :: 		eeprom_i2c_write(myTable.size, &col, 1); //Agregamos los bytes a usar por col
	MOVF        TPV_myTable+41, 0 
	MOVWF       FARG_eeprom_i2c_write_address+0 
	MOVF        TPV_myTable+42, 0 
	MOVWF       FARG_eeprom_i2c_write_address+1 
	MOVLW       mysql_create_new_col_L0+0
	MOVWF       FARG_eeprom_i2c_write_datos+0 
	MOVLW       hi_addr(mysql_create_new_col_L0+0)
	MOVWF       FARG_eeprom_i2c_write_datos+1 
	MOVLW       1
	MOVWF       FARG_eeprom_i2c_write_size+0 
	CALL        _eeprom_i2c_write+0, 0
;table_eeprom.h,195 :: 		myTable.size += 1;                       //Agregamos el texto de la columna
	MOVLW       1
	ADDWF       TPV_myTable+41, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      TPV_myTable+42, 0 
	MOVWF       R1 
	MOVF        R0, 0 
	MOVWF       TPV_myTable+41 
	MOVF        R1, 0 
	MOVWF       TPV_myTable+42 
;table_eeprom.h,196 :: 		acum += col*filas;
	MOVF        mysql_create_new_col_L0+0, 0 
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	MOVF        FARG_mysql_create_new_filas+0, 0 
	MOVWF       R4 
	MOVF        FARG_mysql_create_new_filas+1, 0 
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	MOVF        R0, 0 
	ADDWF       mysql_create_new_acum_L0+0, 1 
	MOVF        R1, 0 
	ADDWFC      mysql_create_new_acum_L0+1, 1 
;table_eeprom.h,198 :: 		tam = myTable.size;
	MOVF        TPV_myTable+41, 0 
	MOVWF       mysql_create_new_tam_L0+0 
	MOVF        TPV_myTable+42, 0 
	MOVWF       mysql_create_new_tam_L0+1 
;table_eeprom.h,199 :: 		}
L_mysql_create_new447:
;table_eeprom.h,200 :: 		}
	GOTO        L_mysql_create_new445
L_mysql_create_new446:
;table_eeprom.h,201 :: 		myTable.size += acum;  //Respaldamos el contenido total
	MOVF        mysql_create_new_acum_L0+0, 0 
	ADDWF       TPV_myTable+41, 0 
	MOVWF       R0 
	MOVF        mysql_create_new_acum_L0+1, 0 
	ADDWFC      TPV_myTable+42, 0 
	MOVWF       R1 
	MOVF        R0, 0 
	MOVWF       TPV_myTable+41 
	MOVF        R1, 0 
	MOVWF       TPV_myTable+42 
;table_eeprom.h,202 :: 		myTable.numTables++;   //Agregar tabla y tamaño actuales
	MOVF        TPV_myTable+0, 0 
	ADDLW       1
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       TPV_myTable+0 
;table_eeprom.h,203 :: 		eeprom_i2c_write(0x0000, &myTable.numTables, 1);
	CLRF        FARG_eeprom_i2c_write_address+0 
	CLRF        FARG_eeprom_i2c_write_address+1 
	MOVLW       TPV_myTable+0
	MOVWF       FARG_eeprom_i2c_write_datos+0 
	MOVLW       hi_addr(TPV_myTable+0)
	MOVWF       FARG_eeprom_i2c_write_datos+1 
	MOVLW       1
	MOVWF       FARG_eeprom_i2c_write_size+0 
	CALL        _eeprom_i2c_write+0, 0
;table_eeprom.h,204 :: 		eeprom_i2c_write(0x0001,(char*)&myTable.size, 2);
	MOVLW       1
	MOVWF       FARG_eeprom_i2c_write_address+0 
	MOVLW       0
	MOVWF       FARG_eeprom_i2c_write_address+1 
	MOVLW       TPV_myTable+41
	MOVWF       FARG_eeprom_i2c_write_datos+0 
	MOVLW       hi_addr(TPV_myTable+41)
	MOVWF       FARG_eeprom_i2c_write_datos+1 
	MOVLW       2
	MOVWF       FARG_eeprom_i2c_write_size+0 
	CALL        _eeprom_i2c_write+0, 0
;table_eeprom.h,206 :: 		}else{
	GOTO        L_mysql_create_new451
L_mysql_create_new444:
;table_eeprom.h,207 :: 		return TABLE_CREATE_MEMORY_FULL;  //Memoria agotada
	MOVLW       3
	MOVWF       R0 
	GOTO        L_end_mysql_create_new
;table_eeprom.h,208 :: 		}
L_mysql_create_new451:
;table_eeprom.h,209 :: 		}else{
	GOTO        L_mysql_create_new452
L_mysql_create_new435:
;table_eeprom.h,210 :: 		return TABLE_CREATE_REPEAT;    //Ya existe la tabla
	MOVLW       4
	MOVWF       R0 
	GOTO        L_end_mysql_create_new
;table_eeprom.h,211 :: 		}
L_mysql_create_new452:
;table_eeprom.h,213 :: 		return TABLE_CREATE_SUCCESS;      //Tabla creada con exito
	CLRF        R0 
;table_eeprom.h,214 :: 		}
L_end_mysql_create_new:
	RETURN      0
; end of _mysql_create_new

_mysql_read_string:

;table_eeprom.h,216 :: 		char mysql_read_string(char *name, char *column, int fila, char *result){
;table_eeprom.h,217 :: 		char res = _mysql_calculate_address(name, column);
	MOVF        FARG_mysql_read_string_name+0, 0 
	MOVWF       FARG__mysql_calculate_address_name+0 
	MOVF        FARG_mysql_read_string_name+1, 0 
	MOVWF       FARG__mysql_calculate_address_name+1 
	MOVF        FARG_mysql_read_string_column+0, 0 
	MOVWF       FARG__mysql_calculate_address_column+0 
	MOVF        FARG_mysql_read_string_column+1, 0 
	MOVWF       FARG__mysql_calculate_address_column+1 
	CALL        __mysql_calculate_address+0, 0
	MOVF        R0, 0 
	MOVWF       mysql_read_string_res_L0+0 
;table_eeprom.h,220 :: 		if(res)
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_mysql_read_string453
;table_eeprom.h,221 :: 		return res;
	MOVF        mysql_read_string_res_L0+0, 0 
	MOVWF       R0 
	GOTO        L_end_mysql_read_string
L_mysql_read_string453:
;table_eeprom.h,224 :: 		if(fila >= 1 && fila <= myTable.rowAct)
	MOVLW       128
	XORWF       FARG_mysql_read_string_fila+1, 0 
	MOVWF       R0 
	MOVLW       128
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__mysql_read_string1287
	MOVLW       1
	SUBWF       FARG_mysql_read_string_fila+0, 0 
L__mysql_read_string1287:
	BTFSS       STATUS+0, 0 
	GOTO        L_mysql_read_string456
	MOVF        FARG_mysql_read_string_fila+1, 0 
	SUBWF       TPV_myTable+5, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__mysql_read_string1288
	MOVF        FARG_mysql_read_string_fila+0, 0 
	SUBWF       TPV_myTable+4, 0 
L__mysql_read_string1288:
	BTFSS       STATUS+0, 0 
	GOTO        L_mysql_read_string456
L__mysql_read_string997:
;table_eeprom.h,225 :: 		eeprom_i2c_read(myTable.addressAct+(fila-1)*myTable.tamCol, result, myTable.tamCol);
	MOVLW       1
	SUBWF       FARG_mysql_read_string_fila+0, 0 
	MOVWF       R0 
	MOVLW       0
	SUBWFB      FARG_mysql_read_string_fila+1, 0 
	MOVWF       R1 
	MOVF        TPV_myTable+6, 0 
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	MOVF        R0, 0 
	ADDWF       TPV_myTable+45, 0 
	MOVWF       FARG_eeprom_i2c_read_address+0 
	MOVF        R1, 0 
	ADDWFC      TPV_myTable+46, 0 
	MOVWF       FARG_eeprom_i2c_read_address+1 
	MOVF        FARG_mysql_read_string_result+0, 0 
	MOVWF       FARG_eeprom_i2c_read_datos+0 
	MOVF        FARG_mysql_read_string_result+1, 0 
	MOVWF       FARG_eeprom_i2c_read_datos+1 
	MOVF        TPV_myTable+6, 0 
	MOVWF       FARG_eeprom_i2c_read_size+0 
	CALL        _eeprom_i2c_read+0, 0
	GOTO        L_mysql_read_string457
L_mysql_read_string456:
;table_eeprom.h,227 :: 		return TABLE_RW_NO_EXIST_ROW;   //Fila inexistente
	MOVLW       3
	MOVWF       R0 
	GOTO        L_end_mysql_read_string
;table_eeprom.h,228 :: 		}
L_mysql_read_string457:
;table_eeprom.h,230 :: 		return TABLE_RW_SUCCESS;     //Exito en la busqueda
	CLRF        R0 
;table_eeprom.h,231 :: 		}
L_end_mysql_read_string:
	RETURN      0
; end of _mysql_read_string

_mysql_read:

;table_eeprom.h,233 :: 		char mysql_read(char *name, char *column, int fila, long *result){
;table_eeprom.h,234 :: 		char res = _mysql_calculate_address(name, column);
	MOVF        FARG_mysql_read_name+0, 0 
	MOVWF       FARG__mysql_calculate_address_name+0 
	MOVF        FARG_mysql_read_name+1, 0 
	MOVWF       FARG__mysql_calculate_address_name+1 
	MOVF        FARG_mysql_read_column+0, 0 
	MOVWF       FARG__mysql_calculate_address_column+0 
	MOVF        FARG_mysql_read_column+1, 0 
	MOVWF       FARG__mysql_calculate_address_column+1 
	CALL        __mysql_calculate_address+0, 0
	MOVF        R0, 0 
	MOVWF       mysql_read_res_L0+0 
;table_eeprom.h,237 :: 		if(res)
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_mysql_read458
;table_eeprom.h,238 :: 		return res;
	MOVF        mysql_read_res_L0+0, 0 
	MOVWF       R0 
	GOTO        L_end_mysql_read
L_mysql_read458:
;table_eeprom.h,241 :: 		*result = 0;
	MOVFF       FARG_mysql_read_result+0, FSR1
	MOVFF       FARG_mysql_read_result+1, FSR1H
	CLRF        POSTINC1+0 
	CLRF        POSTINC1+0 
	CLRF        POSTINC1+0 
	CLRF        POSTINC1+0 
;table_eeprom.h,244 :: 		if(fila >= 1 && fila <= myTable.rowAct){
	MOVLW       128
	XORWF       FARG_mysql_read_fila+1, 0 
	MOVWF       R0 
	MOVLW       128
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__mysql_read1290
	MOVLW       1
	SUBWF       FARG_mysql_read_fila+0, 0 
L__mysql_read1290:
	BTFSS       STATUS+0, 0 
	GOTO        L_mysql_read461
	MOVF        FARG_mysql_read_fila+1, 0 
	SUBWF       TPV_myTable+5, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__mysql_read1291
	MOVF        FARG_mysql_read_fila+0, 0 
	SUBWF       TPV_myTable+4, 0 
L__mysql_read1291:
	BTFSS       STATUS+0, 0 
	GOTO        L_mysql_read461
L__mysql_read998:
;table_eeprom.h,245 :: 		if(myTable.tamCol <= 4)
	MOVF        TPV_myTable+6, 0 
	SUBLW       4
	BTFSS       STATUS+0, 0 
	GOTO        L_mysql_read462
;table_eeprom.h,246 :: 		eeprom_i2c_read(myTable.addressAct+(fila-1)*myTable.tamCol, (char*)&(*result), myTable.tamCol);
	MOVLW       1
	SUBWF       FARG_mysql_read_fila+0, 0 
	MOVWF       R0 
	MOVLW       0
	SUBWFB      FARG_mysql_read_fila+1, 0 
	MOVWF       R1 
	MOVF        TPV_myTable+6, 0 
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	MOVF        R0, 0 
	ADDWF       TPV_myTable+45, 0 
	MOVWF       FARG_eeprom_i2c_read_address+0 
	MOVF        R1, 0 
	ADDWFC      TPV_myTable+46, 0 
	MOVWF       FARG_eeprom_i2c_read_address+1 
	MOVF        FARG_mysql_read_result+0, 0 
	MOVWF       FARG_eeprom_i2c_read_datos+0 
	MOVF        FARG_mysql_read_result+1, 0 
	MOVWF       FARG_eeprom_i2c_read_datos+1 
	MOVF        TPV_myTable+6, 0 
	MOVWF       FARG_eeprom_i2c_read_size+0 
	CALL        _eeprom_i2c_read+0, 0
	GOTO        L_mysql_read463
L_mysql_read462:
;table_eeprom.h,248 :: 		return TABLE_RW_OUT_RANGE_BYTES;
	MOVLW       6
	MOVWF       R0 
	GOTO        L_end_mysql_read
;table_eeprom.h,249 :: 		}
L_mysql_read463:
;table_eeprom.h,250 :: 		}else{
	GOTO        L_mysql_read464
L_mysql_read461:
;table_eeprom.h,251 :: 		return TABLE_RW_NO_EXIST_ROW;   //Fila inexistente
	MOVLW       3
	MOVWF       R0 
	GOTO        L_end_mysql_read
;table_eeprom.h,252 :: 		}
L_mysql_read464:
;table_eeprom.h,254 :: 		return TABLE_RW_SUCCESS;
	CLRF        R0 
;table_eeprom.h,255 :: 		}
L_end_mysql_read:
	RETURN      0
; end of _mysql_read

_mysql_read_forced:

;table_eeprom.h,257 :: 		char mysql_read_forced(char *name, char *column, int fila, char *result){
;table_eeprom.h,258 :: 		char res = _mysql_calculate_address(name, column);
	MOVF        FARG_mysql_read_forced_name+0, 0 
	MOVWF       FARG__mysql_calculate_address_name+0 
	MOVF        FARG_mysql_read_forced_name+1, 0 
	MOVWF       FARG__mysql_calculate_address_name+1 
	MOVF        FARG_mysql_read_forced_column+0, 0 
	MOVWF       FARG__mysql_calculate_address_column+0 
	MOVF        FARG_mysql_read_forced_column+1, 0 
	MOVWF       FARG__mysql_calculate_address_column+1 
	CALL        __mysql_calculate_address+0, 0
	MOVF        R0, 0 
	MOVWF       mysql_read_forced_res_L0+0 
;table_eeprom.h,261 :: 		if(res)
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_mysql_read_forced465
;table_eeprom.h,262 :: 		return res;
	MOVF        mysql_read_forced_res_L0+0, 0 
	MOVWF       R0 
	GOTO        L_end_mysql_read_forced
L_mysql_read_forced465:
;table_eeprom.h,265 :: 		if(fila >= 1 && fila <= myTable.row)
	MOVLW       128
	XORWF       FARG_mysql_read_forced_fila+1, 0 
	MOVWF       R0 
	MOVLW       128
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__mysql_read_forced1293
	MOVLW       1
	SUBWF       FARG_mysql_read_forced_fila+0, 0 
L__mysql_read_forced1293:
	BTFSS       STATUS+0, 0 
	GOTO        L_mysql_read_forced468
	MOVF        FARG_mysql_read_forced_fila+1, 0 
	SUBWF       TPV_myTable+3, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__mysql_read_forced1294
	MOVF        FARG_mysql_read_forced_fila+0, 0 
	SUBWF       TPV_myTable+2, 0 
L__mysql_read_forced1294:
	BTFSS       STATUS+0, 0 
	GOTO        L_mysql_read_forced468
L__mysql_read_forced999:
;table_eeprom.h,266 :: 		eeprom_i2c_read(myTable.addressAct+(fila-1)*myTable.tamCol, result, myTable.tamCol);
	MOVLW       1
	SUBWF       FARG_mysql_read_forced_fila+0, 0 
	MOVWF       R0 
	MOVLW       0
	SUBWFB      FARG_mysql_read_forced_fila+1, 0 
	MOVWF       R1 
	MOVF        TPV_myTable+6, 0 
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	MOVF        R0, 0 
	ADDWF       TPV_myTable+45, 0 
	MOVWF       FARG_eeprom_i2c_read_address+0 
	MOVF        R1, 0 
	ADDWFC      TPV_myTable+46, 0 
	MOVWF       FARG_eeprom_i2c_read_address+1 
	MOVF        FARG_mysql_read_forced_result+0, 0 
	MOVWF       FARG_eeprom_i2c_read_datos+0 
	MOVF        FARG_mysql_read_forced_result+1, 0 
	MOVWF       FARG_eeprom_i2c_read_datos+1 
	MOVF        TPV_myTable+6, 0 
	MOVWF       FARG_eeprom_i2c_read_size+0 
	CALL        _eeprom_i2c_read+0, 0
	GOTO        L_mysql_read_forced469
L_mysql_read_forced468:
;table_eeprom.h,268 :: 		return TABLE_RW_NO_EXIST_ROW;   //Fila inexistente
	MOVLW       3
	MOVWF       R0 
	GOTO        L_end_mysql_read_forced
L_mysql_read_forced469:
;table_eeprom.h,270 :: 		return TABLE_RW_SUCCESS;     //Exito en la busqueda
	CLRF        R0 
;table_eeprom.h,271 :: 		}
L_end_mysql_read_forced:
	RETURN      0
; end of _mysql_read_forced

_mysql_write_string:

;table_eeprom.h,273 :: 		char mysql_write_string(char *name, char *column, int fila, char *texto, bool endWrite){
;table_eeprom.h,274 :: 		char res = _mysql_calculate_address(name, column);
	MOVF        FARG_mysql_write_string_name+0, 0 
	MOVWF       FARG__mysql_calculate_address_name+0 
	MOVF        FARG_mysql_write_string_name+1, 0 
	MOVWF       FARG__mysql_calculate_address_name+1 
	MOVF        FARG_mysql_write_string_column+0, 0 
	MOVWF       FARG__mysql_calculate_address_column+0 
	MOVF        FARG_mysql_write_string_column+1, 0 
	MOVWF       FARG__mysql_calculate_address_column+1 
	CALL        __mysql_calculate_address+0, 0
	MOVF        R0, 0 
	MOVWF       mysql_write_string_res_L0+0 
;table_eeprom.h,277 :: 		if(res)
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_mysql_write_string470
;table_eeprom.h,278 :: 		return res;
	MOVF        mysql_write_string_res_L0+0, 0 
	MOVWF       R0 
	GOTO        L_end_mysql_write_string
L_mysql_write_string470:
;table_eeprom.h,281 :: 		myTable.cont = strlen(texto)+1;   //Calcular el tamaño de la cadena a escribir
	MOVF        FARG_mysql_write_string_texto+0, 0 
	MOVWF       FARG_strlen_s+0 
	MOVF        FARG_mysql_write_string_texto+1, 0 
	MOVWF       FARG_strlen_s+1 
	CALL        _strlen+0, 0
	MOVF        R0, 0 
	ADDLW       1
	MOVWF       R1 
	MOVF        R1, 0 
	MOVWF       TPV_myTable+47 
;table_eeprom.h,283 :: 		if(myTable.cont > myTable.tamCol){
	MOVF        R1, 0 
	SUBWF       TPV_myTable+6, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_mysql_write_string471
;table_eeprom.h,284 :: 		return TABLE_RW_OUT_RANGE;
	MOVLW       4
	MOVWF       R0 
	GOTO        L_end_mysql_write_string
;table_eeprom.h,285 :: 		}
L_mysql_write_string471:
;table_eeprom.h,287 :: 		if(endWrite){
	MOVF        FARG_mysql_write_string_endWrite+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_mysql_write_string472
;table_eeprom.h,288 :: 		if(myTable.rowAct < myTable.row){
	MOVF        TPV_myTable+3, 0 
	SUBWF       TPV_myTable+5, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__mysql_write_string1296
	MOVF        TPV_myTable+2, 0 
	SUBWF       TPV_myTable+4, 0 
L__mysql_write_string1296:
	BTFSC       STATUS+0, 0 
	GOTO        L_mysql_write_string473
;table_eeprom.h,289 :: 		eeprom_i2c_write(myTable.addressAct+myTable.rowAct*myTable.tamCol, texto, myTable.cont);
	MOVF        TPV_myTable+4, 0 
	MOVWF       R0 
	MOVF        TPV_myTable+5, 0 
	MOVWF       R1 
	MOVF        TPV_myTable+6, 0 
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	MOVF        R0, 0 
	ADDWF       TPV_myTable+45, 0 
	MOVWF       FARG_eeprom_i2c_write_address+0 
	MOVF        R1, 0 
	ADDWFC      TPV_myTable+46, 0 
	MOVWF       FARG_eeprom_i2c_write_address+1 
	MOVF        FARG_mysql_write_string_texto+0, 0 
	MOVWF       FARG_eeprom_i2c_write_datos+0 
	MOVF        FARG_mysql_write_string_texto+1, 0 
	MOVWF       FARG_eeprom_i2c_write_datos+1 
	MOVF        TPV_myTable+47, 0 
	MOVWF       FARG_eeprom_i2c_write_size+0 
	CALL        _eeprom_i2c_write+0, 0
;table_eeprom.h,290 :: 		myTable.rowAct++;
	MOVLW       1
	ADDWF       TPV_myTable+4, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      TPV_myTable+5, 0 
	MOVWF       R1 
	MOVF        R0, 0 
	MOVWF       TPV_myTable+4 
	MOVF        R1, 0 
	MOVWF       TPV_myTable+5 
;table_eeprom.h,291 :: 		eeprom_i2c_write(myTable.address+TABLE_MAX_SIZE_NAME+3, (char*)&myTable.rowAct, 2);
	MOVLW       15
	ADDWF       TPV_myTable+43, 0 
	MOVWF       FARG_eeprom_i2c_write_address+0 
	MOVLW       0
	ADDWFC      TPV_myTable+44, 0 
	MOVWF       FARG_eeprom_i2c_write_address+1 
	MOVLW       3
	ADDWF       FARG_eeprom_i2c_write_address+0, 1 
	MOVLW       0
	ADDWFC      FARG_eeprom_i2c_write_address+1, 1 
	MOVLW       TPV_myTable+4
	MOVWF       FARG_eeprom_i2c_write_datos+0 
	MOVLW       hi_addr(TPV_myTable+4)
	MOVWF       FARG_eeprom_i2c_write_datos+1 
	MOVLW       2
	MOVWF       FARG_eeprom_i2c_write_size+0 
	CALL        _eeprom_i2c_write+0, 0
;table_eeprom.h,292 :: 		}else{
	GOTO        L_mysql_write_string474
L_mysql_write_string473:
;table_eeprom.h,293 :: 		return TABLE_RW_TABLE_FULL;   //Memoria llena de la tabla
	MOVLW       5
	MOVWF       R0 
	GOTO        L_end_mysql_write_string
;table_eeprom.h,294 :: 		}
L_mysql_write_string474:
;table_eeprom.h,295 :: 		}else if(fila >= 1 && fila <= myTable.rowAct)
	GOTO        L_mysql_write_string475
L_mysql_write_string472:
	MOVLW       128
	XORWF       FARG_mysql_write_string_fila+1, 0 
	MOVWF       R0 
	MOVLW       128
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__mysql_write_string1297
	MOVLW       1
	SUBWF       FARG_mysql_write_string_fila+0, 0 
L__mysql_write_string1297:
	BTFSS       STATUS+0, 0 
	GOTO        L_mysql_write_string478
	MOVF        FARG_mysql_write_string_fila+1, 0 
	SUBWF       TPV_myTable+5, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__mysql_write_string1298
	MOVF        FARG_mysql_write_string_fila+0, 0 
	SUBWF       TPV_myTable+4, 0 
L__mysql_write_string1298:
	BTFSS       STATUS+0, 0 
	GOTO        L_mysql_write_string478
L__mysql_write_string1000:
;table_eeprom.h,296 :: 		eeprom_i2c_write(myTable.addressAct+(fila-1)*myTable.tamCol, texto, myTable.cont);
	MOVLW       1
	SUBWF       FARG_mysql_write_string_fila+0, 0 
	MOVWF       R0 
	MOVLW       0
	SUBWFB      FARG_mysql_write_string_fila+1, 0 
	MOVWF       R1 
	MOVF        TPV_myTable+6, 0 
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	MOVF        R0, 0 
	ADDWF       TPV_myTable+45, 0 
	MOVWF       FARG_eeprom_i2c_write_address+0 
	MOVF        R1, 0 
	ADDWFC      TPV_myTable+46, 0 
	MOVWF       FARG_eeprom_i2c_write_address+1 
	MOVF        FARG_mysql_write_string_texto+0, 0 
	MOVWF       FARG_eeprom_i2c_write_datos+0 
	MOVF        FARG_mysql_write_string_texto+1, 0 
	MOVWF       FARG_eeprom_i2c_write_datos+1 
	MOVF        TPV_myTable+47, 0 
	MOVWF       FARG_eeprom_i2c_write_size+0 
	CALL        _eeprom_i2c_write+0, 0
	GOTO        L_mysql_write_string479
L_mysql_write_string478:
;table_eeprom.h,298 :: 		return TABLE_RW_NO_EXIST_ROW;   //Fila inexistente
	MOVLW       3
	MOVWF       R0 
	GOTO        L_end_mysql_write_string
;table_eeprom.h,299 :: 		}
L_mysql_write_string479:
L_mysql_write_string475:
;table_eeprom.h,301 :: 		return TABLE_RW_SUCCESS;     //Exito en grabacion
	CLRF        R0 
;table_eeprom.h,302 :: 		}
L_end_mysql_write_string:
	RETURN      0
; end of _mysql_write_string

_mysql_write:

;table_eeprom.h,304 :: 		char mysql_write(char *name, char *column, int fila, long value, bool endWrite){
;table_eeprom.h,305 :: 		char res = _mysql_calculate_address(name, column);
	MOVF        FARG_mysql_write_name+0, 0 
	MOVWF       FARG__mysql_calculate_address_name+0 
	MOVF        FARG_mysql_write_name+1, 0 
	MOVWF       FARG__mysql_calculate_address_name+1 
	MOVF        FARG_mysql_write_column+0, 0 
	MOVWF       FARG__mysql_calculate_address_column+0 
	MOVF        FARG_mysql_write_column+1, 0 
	MOVWF       FARG__mysql_calculate_address_column+1 
	CALL        __mysql_calculate_address+0, 0
	MOVF        R0, 0 
	MOVWF       mysql_write_res_L0+0 
;table_eeprom.h,308 :: 		if(res)
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_mysql_write480
;table_eeprom.h,309 :: 		return res;
	MOVF        mysql_write_res_L0+0, 0 
	MOVWF       R0 
	GOTO        L_end_mysql_write
L_mysql_write480:
;table_eeprom.h,312 :: 		myTable.cont = myTable.tamCol;
	MOVF        TPV_myTable+6, 0 
	MOVWF       TPV_myTable+47 
;table_eeprom.h,313 :: 		if(myTable.cont > 4){
	MOVF        TPV_myTable+6, 0 
	SUBLW       4
	BTFSC       STATUS+0, 0 
	GOTO        L_mysql_write481
;table_eeprom.h,314 :: 		return TABLE_RW_OUT_RANGE_BYTES;
	MOVLW       6
	MOVWF       R0 
	GOTO        L_end_mysql_write
;table_eeprom.h,315 :: 		}
L_mysql_write481:
;table_eeprom.h,317 :: 		if(endWrite){
	MOVF        FARG_mysql_write_endWrite+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_mysql_write482
;table_eeprom.h,318 :: 		if(myTable.rowAct < myTable.row){
	MOVF        TPV_myTable+3, 0 
	SUBWF       TPV_myTable+5, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__mysql_write1300
	MOVF        TPV_myTable+2, 0 
	SUBWF       TPV_myTable+4, 0 
L__mysql_write1300:
	BTFSC       STATUS+0, 0 
	GOTO        L_mysql_write483
;table_eeprom.h,319 :: 		eeprom_i2c_write(myTable.addressAct+myTable.rowAct*myTable.tamCol, (char*)&value, myTable.cont);
	MOVF        TPV_myTable+4, 0 
	MOVWF       R0 
	MOVF        TPV_myTable+5, 0 
	MOVWF       R1 
	MOVF        TPV_myTable+6, 0 
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	MOVF        R0, 0 
	ADDWF       TPV_myTable+45, 0 
	MOVWF       FARG_eeprom_i2c_write_address+0 
	MOVF        R1, 0 
	ADDWFC      TPV_myTable+46, 0 
	MOVWF       FARG_eeprom_i2c_write_address+1 
	MOVLW       FARG_mysql_write_value+0
	MOVWF       FARG_eeprom_i2c_write_datos+0 
	MOVLW       hi_addr(FARG_mysql_write_value+0)
	MOVWF       FARG_eeprom_i2c_write_datos+1 
	MOVF        TPV_myTable+47, 0 
	MOVWF       FARG_eeprom_i2c_write_size+0 
	CALL        _eeprom_i2c_write+0, 0
;table_eeprom.h,320 :: 		myTable.rowAct++;
	MOVLW       1
	ADDWF       TPV_myTable+4, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      TPV_myTable+5, 0 
	MOVWF       R1 
	MOVF        R0, 0 
	MOVWF       TPV_myTable+4 
	MOVF        R1, 0 
	MOVWF       TPV_myTable+5 
;table_eeprom.h,321 :: 		eeprom_i2c_write(myTable.address+TABLE_MAX_SIZE_NAME+3, (char*)&myTable.rowAct, 2);
	MOVLW       15
	ADDWF       TPV_myTable+43, 0 
	MOVWF       FARG_eeprom_i2c_write_address+0 
	MOVLW       0
	ADDWFC      TPV_myTable+44, 0 
	MOVWF       FARG_eeprom_i2c_write_address+1 
	MOVLW       3
	ADDWF       FARG_eeprom_i2c_write_address+0, 1 
	MOVLW       0
	ADDWFC      FARG_eeprom_i2c_write_address+1, 1 
	MOVLW       TPV_myTable+4
	MOVWF       FARG_eeprom_i2c_write_datos+0 
	MOVLW       hi_addr(TPV_myTable+4)
	MOVWF       FARG_eeprom_i2c_write_datos+1 
	MOVLW       2
	MOVWF       FARG_eeprom_i2c_write_size+0 
	CALL        _eeprom_i2c_write+0, 0
;table_eeprom.h,322 :: 		}else
	GOTO        L_mysql_write484
L_mysql_write483:
;table_eeprom.h,323 :: 		return TABLE_RW_TABLE_FULL;   //Memoria llena de la tabla
	MOVLW       5
	MOVWF       R0 
	GOTO        L_end_mysql_write
L_mysql_write484:
;table_eeprom.h,324 :: 		}else if(fila >= 1 && fila <= myTable.rowAct)
	GOTO        L_mysql_write485
L_mysql_write482:
	MOVLW       128
	XORWF       FARG_mysql_write_fila+1, 0 
	MOVWF       R0 
	MOVLW       128
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__mysql_write1301
	MOVLW       1
	SUBWF       FARG_mysql_write_fila+0, 0 
L__mysql_write1301:
	BTFSS       STATUS+0, 0 
	GOTO        L_mysql_write488
	MOVF        FARG_mysql_write_fila+1, 0 
	SUBWF       TPV_myTable+5, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__mysql_write1302
	MOVF        FARG_mysql_write_fila+0, 0 
	SUBWF       TPV_myTable+4, 0 
L__mysql_write1302:
	BTFSS       STATUS+0, 0 
	GOTO        L_mysql_write488
L__mysql_write1001:
;table_eeprom.h,325 :: 		eeprom_i2c_write(myTable.addressAct+(fila-1)*myTable.tamCol, (char*)&value, myTable.cont);
	MOVLW       1
	SUBWF       FARG_mysql_write_fila+0, 0 
	MOVWF       R0 
	MOVLW       0
	SUBWFB      FARG_mysql_write_fila+1, 0 
	MOVWF       R1 
	MOVF        TPV_myTable+6, 0 
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	MOVF        R0, 0 
	ADDWF       TPV_myTable+45, 0 
	MOVWF       FARG_eeprom_i2c_write_address+0 
	MOVF        R1, 0 
	ADDWFC      TPV_myTable+46, 0 
	MOVWF       FARG_eeprom_i2c_write_address+1 
	MOVLW       FARG_mysql_write_value+0
	MOVWF       FARG_eeprom_i2c_write_datos+0 
	MOVLW       hi_addr(FARG_mysql_write_value+0)
	MOVWF       FARG_eeprom_i2c_write_datos+1 
	MOVF        TPV_myTable+47, 0 
	MOVWF       FARG_eeprom_i2c_write_size+0 
	CALL        _eeprom_i2c_write+0, 0
	GOTO        L_mysql_write489
L_mysql_write488:
;table_eeprom.h,327 :: 		return TABLE_RW_NO_EXIST_ROW;   //Fila inexistente
	MOVLW       3
	MOVWF       R0 
	GOTO        L_end_mysql_write
L_mysql_write489:
L_mysql_write485:
;table_eeprom.h,329 :: 		return TABLE_RW_SUCCESS;     //Exito en grabacion
	CLRF        R0 
;table_eeprom.h,330 :: 		}
L_end_mysql_write:
	RETURN      0
; end of _mysql_write

_mysql_write_forced:

;table_eeprom.h,332 :: 		char mysql_write_forced(char *name, char *column, int fila, char *texto, char bytes){
;table_eeprom.h,333 :: 		char res = _mysql_calculate_address(name, column);
	MOVF        FARG_mysql_write_forced_name+0, 0 
	MOVWF       FARG__mysql_calculate_address_name+0 
	MOVF        FARG_mysql_write_forced_name+1, 0 
	MOVWF       FARG__mysql_calculate_address_name+1 
	MOVF        FARG_mysql_write_forced_column+0, 0 
	MOVWF       FARG__mysql_calculate_address_column+0 
	MOVF        FARG_mysql_write_forced_column+1, 0 
	MOVWF       FARG__mysql_calculate_address_column+1 
	CALL        __mysql_calculate_address+0, 0
	MOVF        R0, 0 
	MOVWF       mysql_write_forced_res_L0+0 
;table_eeprom.h,336 :: 		if(res)
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_mysql_write_forced490
;table_eeprom.h,337 :: 		return res;
	MOVF        mysql_write_forced_res_L0+0, 0 
	MOVWF       R0 
	GOTO        L_end_mysql_write_forced
L_mysql_write_forced490:
;table_eeprom.h,340 :: 		if(bytes > myTable.tamCol)
	MOVF        FARG_mysql_write_forced_bytes+0, 0 
	SUBWF       TPV_myTable+6, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_mysql_write_forced491
;table_eeprom.h,341 :: 		return TABLE_RW_OUT_RANGE;
	MOVLW       4
	MOVWF       R0 
	GOTO        L_end_mysql_write_forced
L_mysql_write_forced491:
;table_eeprom.h,344 :: 		if(fila >= 1 && fila <= myTable.row)
	MOVLW       128
	XORWF       FARG_mysql_write_forced_fila+1, 0 
	MOVWF       R0 
	MOVLW       128
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__mysql_write_forced1304
	MOVLW       1
	SUBWF       FARG_mysql_write_forced_fila+0, 0 
L__mysql_write_forced1304:
	BTFSS       STATUS+0, 0 
	GOTO        L_mysql_write_forced494
	MOVF        FARG_mysql_write_forced_fila+1, 0 
	SUBWF       TPV_myTable+3, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__mysql_write_forced1305
	MOVF        FARG_mysql_write_forced_fila+0, 0 
	SUBWF       TPV_myTable+2, 0 
L__mysql_write_forced1305:
	BTFSS       STATUS+0, 0 
	GOTO        L_mysql_write_forced494
L__mysql_write_forced1002:
;table_eeprom.h,345 :: 		eeprom_i2c_write(myTable.addressAct+(fila-1)*myTable.tamCol, texto, bytes);
	MOVLW       1
	SUBWF       FARG_mysql_write_forced_fila+0, 0 
	MOVWF       R0 
	MOVLW       0
	SUBWFB      FARG_mysql_write_forced_fila+1, 0 
	MOVWF       R1 
	MOVF        TPV_myTable+6, 0 
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	MOVF        R0, 0 
	ADDWF       TPV_myTable+45, 0 
	MOVWF       FARG_eeprom_i2c_write_address+0 
	MOVF        R1, 0 
	ADDWFC      TPV_myTable+46, 0 
	MOVWF       FARG_eeprom_i2c_write_address+1 
	MOVF        FARG_mysql_write_forced_texto+0, 0 
	MOVWF       FARG_eeprom_i2c_write_datos+0 
	MOVF        FARG_mysql_write_forced_texto+1, 0 
	MOVWF       FARG_eeprom_i2c_write_datos+1 
	MOVF        FARG_mysql_write_forced_bytes+0, 0 
	MOVWF       FARG_eeprom_i2c_write_size+0 
	CALL        _eeprom_i2c_write+0, 0
	GOTO        L_mysql_write_forced495
L_mysql_write_forced494:
;table_eeprom.h,347 :: 		return TABLE_RW_NO_EXIST_ROW;   //Fila inexistente
	MOVLW       3
	MOVWF       R0 
	GOTO        L_end_mysql_write_forced
L_mysql_write_forced495:
;table_eeprom.h,349 :: 		return TABLE_RW_SUCCESS;     //Exito en grabacion
	CLRF        R0 
;table_eeprom.h,350 :: 		}
L_end_mysql_write_forced:
	RETURN      0
; end of _mysql_write_forced

_mysql_write_roundTrip:

;table_eeprom.h,352 :: 		char mysql_write_roundTrip(char *name, char *column, char *texto, char bytes){
;table_eeprom.h,353 :: 		char res = _mysql_calculate_address(name, column);
	MOVF        FARG_mysql_write_roundTrip_name+0, 0 
	MOVWF       FARG__mysql_calculate_address_name+0 
	MOVF        FARG_mysql_write_roundTrip_name+1, 0 
	MOVWF       FARG__mysql_calculate_address_name+1 
	MOVF        FARG_mysql_write_roundTrip_column+0, 0 
	MOVWF       FARG__mysql_calculate_address_column+0 
	MOVF        FARG_mysql_write_roundTrip_column+1, 0 
	MOVWF       FARG__mysql_calculate_address_column+1 
	CALL        __mysql_calculate_address+0, 0
	MOVF        R0, 0 
	MOVWF       mysql_write_roundTrip_res_L0+0 
;table_eeprom.h,356 :: 		if(res)
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_mysql_write_roundTrip496
;table_eeprom.h,357 :: 		return res;
	MOVF        mysql_write_roundTrip_res_L0+0, 0 
	MOVWF       R0 
	GOTO        L_end_mysql_write_roundTrip
L_mysql_write_roundTrip496:
;table_eeprom.h,360 :: 		if(bytes > myTable.tamCol)
	MOVF        FARG_mysql_write_roundTrip_bytes+0, 0 
	SUBWF       TPV_myTable+6, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_mysql_write_roundTrip497
;table_eeprom.h,361 :: 		return TABLE_RW_OUT_RANGE;
	MOVLW       4
	MOVWF       R0 
	GOTO        L_end_mysql_write_roundTrip
L_mysql_write_roundTrip497:
;table_eeprom.h,364 :: 		myTable.rowAct = clamp_shift(++myTable.rowAct, 1, myTable.row);
	MOVLW       1
	ADDWF       TPV_myTable+4, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      TPV_myTable+5, 0 
	MOVWF       R1 
	MOVF        R0, 0 
	MOVWF       TPV_myTable+4 
	MOVF        R1, 0 
	MOVWF       TPV_myTable+5 
	MOVF        TPV_myTable+4, 0 
	MOVWF       FARG_clamp_shift_valor+0 
	MOVF        TPV_myTable+5, 0 
	MOVWF       FARG_clamp_shift_valor+1 
	MOVLW       0
	MOVWF       FARG_clamp_shift_valor+2 
	MOVWF       FARG_clamp_shift_valor+3 
	MOVLW       1
	MOVWF       FARG_clamp_shift_min+0 
	MOVLW       0
	MOVWF       FARG_clamp_shift_min+1 
	MOVWF       FARG_clamp_shift_min+2 
	MOVWF       FARG_clamp_shift_min+3 
	MOVF        TPV_myTable+2, 0 
	MOVWF       FARG_clamp_shift_max+0 
	MOVF        TPV_myTable+3, 0 
	MOVWF       FARG_clamp_shift_max+1 
	MOVLW       0
	MOVWF       FARG_clamp_shift_max+2 
	MOVWF       FARG_clamp_shift_max+3 
	CALL        _clamp_shift+0, 0
	MOVF        R0, 0 
	MOVWF       TPV_myTable+4 
	MOVF        R1, 0 
	MOVWF       TPV_myTable+5 
;table_eeprom.h,365 :: 		eeprom_i2c_write(myTable.address+TABLE_MAX_SIZE_NAME+3, (char*)&myTable.rowAct, 2);
	MOVLW       15
	ADDWF       TPV_myTable+43, 0 
	MOVWF       FARG_eeprom_i2c_write_address+0 
	MOVLW       0
	ADDWFC      TPV_myTable+44, 0 
	MOVWF       FARG_eeprom_i2c_write_address+1 
	MOVLW       3
	ADDWF       FARG_eeprom_i2c_write_address+0, 1 
	MOVLW       0
	ADDWFC      FARG_eeprom_i2c_write_address+1, 1 
	MOVLW       TPV_myTable+4
	MOVWF       FARG_eeprom_i2c_write_datos+0 
	MOVLW       hi_addr(TPV_myTable+4)
	MOVWF       FARG_eeprom_i2c_write_datos+1 
	MOVLW       2
	MOVWF       FARG_eeprom_i2c_write_size+0 
	CALL        _eeprom_i2c_write+0, 0
;table_eeprom.h,366 :: 		eeprom_i2c_write(myTable.addressAct+(myTable.rowAct-1)*myTable.tamCol, texto, bytes);
	MOVLW       1
	SUBWF       TPV_myTable+4, 0 
	MOVWF       R0 
	MOVLW       0
	SUBWFB      TPV_myTable+5, 0 
	MOVWF       R1 
	MOVF        TPV_myTable+6, 0 
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	MOVF        R0, 0 
	ADDWF       TPV_myTable+45, 0 
	MOVWF       FARG_eeprom_i2c_write_address+0 
	MOVF        R1, 0 
	ADDWFC      TPV_myTable+46, 0 
	MOVWF       FARG_eeprom_i2c_write_address+1 
	MOVF        FARG_mysql_write_roundTrip_texto+0, 0 
	MOVWF       FARG_eeprom_i2c_write_datos+0 
	MOVF        FARG_mysql_write_roundTrip_texto+1, 0 
	MOVWF       FARG_eeprom_i2c_write_datos+1 
	MOVF        FARG_mysql_write_roundTrip_bytes+0, 0 
	MOVWF       FARG_eeprom_i2c_write_size+0 
	CALL        _eeprom_i2c_write+0, 0
;table_eeprom.h,368 :: 		return TABLE_RW_SUCCESS;     //Exito en grabacion
	CLRF        R0 
;table_eeprom.h,369 :: 		}
L_end_mysql_write_roundTrip:
	RETURN      0
; end of _mysql_write_roundTrip

_mysql_erase:

;table_eeprom.h,371 :: 		bool mysql_erase(char *name){
;table_eeprom.h,373 :: 		if(!mysql_exist(name))
	MOVF        FARG_mysql_erase_name+0, 0 
	MOVWF       FARG_mysql_exist_name+0 
	MOVF        FARG_mysql_erase_name+1, 0 
	MOVWF       FARG_mysql_exist_name+1 
	CALL        _mysql_exist+0, 0
	MOVF        R0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_mysql_erase498
;table_eeprom.h,374 :: 		return false;
	CLRF        R0 
	GOTO        L_end_mysql_erase
L_mysql_erase498:
;table_eeprom.h,377 :: 		myTable.rowAct = 0;
	CLRF        TPV_myTable+4 
	CLRF        TPV_myTable+5 
;table_eeprom.h,378 :: 		eeprom_i2c_write(myTable.address+TABLE_MAX_SIZE_NAME+3, (char*)&myTable.rowAct, 2);
	MOVLW       15
	ADDWF       TPV_myTable+43, 0 
	MOVWF       FARG_eeprom_i2c_write_address+0 
	MOVLW       0
	ADDWFC      TPV_myTable+44, 0 
	MOVWF       FARG_eeprom_i2c_write_address+1 
	MOVLW       3
	ADDWF       FARG_eeprom_i2c_write_address+0, 1 
	MOVLW       0
	ADDWFC      FARG_eeprom_i2c_write_address+1, 1 
	MOVLW       TPV_myTable+4
	MOVWF       FARG_eeprom_i2c_write_datos+0 
	MOVLW       hi_addr(TPV_myTable+4)
	MOVWF       FARG_eeprom_i2c_write_datos+1 
	MOVLW       2
	MOVWF       FARG_eeprom_i2c_write_size+0 
	CALL        _eeprom_i2c_write+0, 0
;table_eeprom.h,379 :: 		return true;
	MOVLW       1
	MOVWF       R0 
;table_eeprom.h,380 :: 		}
L_end_mysql_erase:
	RETURN      0
; end of _mysql_erase

_mysql_search:

;table_eeprom.h,382 :: 		char mysql_search(char *tabla, char *columna, long buscar, int *fila){
;table_eeprom.h,386 :: 		if(mysql_exist(tabla)){
	MOVF        FARG_mysql_search_tabla+0, 0 
	MOVWF       FARG_mysql_exist_name+0 
	MOVF        FARG_mysql_search_tabla+1, 0 
	MOVWF       FARG_mysql_exist_name+1 
	CALL        _mysql_exist+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_mysql_search499
;table_eeprom.h,387 :: 		for(*fila = 1; *fila <= myTable.rowAct; (*fila)++){
	MOVFF       FARG_mysql_search_fila+0, FSR1
	MOVFF       FARG_mysql_search_fila+1, FSR1H
	MOVLW       1
	MOVWF       POSTINC1+0 
	MOVLW       0
	MOVWF       POSTINC1+0 
L_mysql_search500:
	MOVFF       FARG_mysql_search_fila+0, FSR0
	MOVFF       FARG_mysql_search_fila+1, FSR0H
	MOVF        POSTINC0+0, 0 
	MOVWF       R1 
	MOVF        POSTINC0+0, 0 
	MOVWF       R2 
	MOVF        R2, 0 
	SUBWF       TPV_myTable+5, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__mysql_search1309
	MOVF        R1, 0 
	SUBWF       TPV_myTable+4, 0 
L__mysql_search1309:
	BTFSS       STATUS+0, 0 
	GOTO        L_mysql_search501
;table_eeprom.h,389 :: 		if(!mysql_read(tabla, columna, *fila, &busqueda)){
	MOVF        FARG_mysql_search_tabla+0, 0 
	MOVWF       FARG_mysql_read_name+0 
	MOVF        FARG_mysql_search_tabla+1, 0 
	MOVWF       FARG_mysql_read_name+1 
	MOVF        FARG_mysql_search_columna+0, 0 
	MOVWF       FARG_mysql_read_column+0 
	MOVF        FARG_mysql_search_columna+1, 0 
	MOVWF       FARG_mysql_read_column+1 
	MOVFF       FARG_mysql_search_fila+0, FSR0
	MOVFF       FARG_mysql_search_fila+1, FSR0H
	MOVF        POSTINC0+0, 0 
	MOVWF       FARG_mysql_read_fila+0 
	MOVF        POSTINC0+0, 0 
	MOVWF       FARG_mysql_read_fila+1 
	MOVLW       mysql_search_busqueda_L0+0
	MOVWF       FARG_mysql_read_result+0 
	MOVLW       hi_addr(mysql_search_busqueda_L0+0)
	MOVWF       FARG_mysql_read_result+1 
	CALL        _mysql_read+0, 0
	MOVF        R0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_mysql_search503
;table_eeprom.h,390 :: 		if(buscar == busqueda)
	MOVF        FARG_mysql_search_buscar+3, 0 
	XORWF       mysql_search_busqueda_L0+3, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__mysql_search1310
	MOVF        FARG_mysql_search_buscar+2, 0 
	XORWF       mysql_search_busqueda_L0+2, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__mysql_search1310
	MOVF        FARG_mysql_search_buscar+1, 0 
	XORWF       mysql_search_busqueda_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__mysql_search1310
	MOVF        FARG_mysql_search_buscar+0, 0 
	XORWF       mysql_search_busqueda_L0+0, 0 
L__mysql_search1310:
	BTFSS       STATUS+0, 2 
	GOTO        L_mysql_search504
;table_eeprom.h,391 :: 		return TABLE_RW_SUCCESS;
	CLRF        R0 
	GOTO        L_end_mysql_search
L_mysql_search504:
;table_eeprom.h,392 :: 		}
L_mysql_search503:
;table_eeprom.h,387 :: 		for(*fila = 1; *fila <= myTable.rowAct; (*fila)++){
	MOVFF       FARG_mysql_search_fila+0, FSR0
	MOVFF       FARG_mysql_search_fila+1, FSR0H
	MOVF        POSTINC0+0, 0 
	MOVWF       R0 
	MOVF        POSTINC0+0, 0 
	MOVWF       R1 
	INFSNZ      R0, 1 
	INCF        R1, 1 
	MOVFF       FARG_mysql_search_fila+0, FSR1
	MOVFF       FARG_mysql_search_fila+1, FSR1H
	MOVF        R0, 0 
	MOVWF       POSTINC1+0 
	MOVF        R1, 0 
	MOVWF       POSTINC1+0 
;table_eeprom.h,393 :: 		}
	GOTO        L_mysql_search500
L_mysql_search501:
;table_eeprom.h,394 :: 		return TABLE_RW_NO_EXIST_ROW;
	MOVLW       3
	MOVWF       R0 
	GOTO        L_end_mysql_search
;table_eeprom.h,395 :: 		}
L_mysql_search499:
;table_eeprom.h,397 :: 		return TABLE_RW_NO_EXIST_TABLE;
	MOVLW       1
	MOVWF       R0 
;table_eeprom.h,398 :: 		}
L_end_mysql_search:
	RETURN      0
; end of _mysql_search

_mysql_search_forced:

;table_eeprom.h,400 :: 		char mysql_search_forced(char *tabla, char *columna, long buscar, int *fila){
;table_eeprom.h,404 :: 		if(mysql_exist(tabla)){
	MOVF        FARG_mysql_search_forced_tabla+0, 0 
	MOVWF       FARG_mysql_exist_name+0 
	MOVF        FARG_mysql_search_forced_tabla+1, 0 
	MOVWF       FARG_mysql_exist_name+1 
	CALL        _mysql_exist+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_mysql_search_forced505
;table_eeprom.h,405 :: 		for(*fila = 1; *fila <= myTable.row; (*fila)++){
	MOVFF       FARG_mysql_search_forced_fila+0, FSR1
	MOVFF       FARG_mysql_search_forced_fila+1, FSR1H
	MOVLW       1
	MOVWF       POSTINC1+0 
	MOVLW       0
	MOVWF       POSTINC1+0 
L_mysql_search_forced506:
	MOVFF       FARG_mysql_search_forced_fila+0, FSR0
	MOVFF       FARG_mysql_search_forced_fila+1, FSR0H
	MOVF        POSTINC0+0, 0 
	MOVWF       R1 
	MOVF        POSTINC0+0, 0 
	MOVWF       R2 
	MOVF        R2, 0 
	SUBWF       TPV_myTable+3, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__mysql_search_forced1312
	MOVF        R1, 0 
	SUBWF       TPV_myTable+2, 0 
L__mysql_search_forced1312:
	BTFSS       STATUS+0, 0 
	GOTO        L_mysql_search_forced507
;table_eeprom.h,407 :: 		if(!mysql_read(tabla, columna, *fila, &busqueda)){
	MOVF        FARG_mysql_search_forced_tabla+0, 0 
	MOVWF       FARG_mysql_read_name+0 
	MOVF        FARG_mysql_search_forced_tabla+1, 0 
	MOVWF       FARG_mysql_read_name+1 
	MOVF        FARG_mysql_search_forced_columna+0, 0 
	MOVWF       FARG_mysql_read_column+0 
	MOVF        FARG_mysql_search_forced_columna+1, 0 
	MOVWF       FARG_mysql_read_column+1 
	MOVFF       FARG_mysql_search_forced_fila+0, FSR0
	MOVFF       FARG_mysql_search_forced_fila+1, FSR0H
	MOVF        POSTINC0+0, 0 
	MOVWF       FARG_mysql_read_fila+0 
	MOVF        POSTINC0+0, 0 
	MOVWF       FARG_mysql_read_fila+1 
	MOVLW       mysql_search_forced_busqueda_L0+0
	MOVWF       FARG_mysql_read_result+0 
	MOVLW       hi_addr(mysql_search_forced_busqueda_L0+0)
	MOVWF       FARG_mysql_read_result+1 
	CALL        _mysql_read+0, 0
	MOVF        R0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_mysql_search_forced509
;table_eeprom.h,408 :: 		if(buscar == busqueda)
	MOVF        FARG_mysql_search_forced_buscar+3, 0 
	XORWF       mysql_search_forced_busqueda_L0+3, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__mysql_search_forced1313
	MOVF        FARG_mysql_search_forced_buscar+2, 0 
	XORWF       mysql_search_forced_busqueda_L0+2, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__mysql_search_forced1313
	MOVF        FARG_mysql_search_forced_buscar+1, 0 
	XORWF       mysql_search_forced_busqueda_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__mysql_search_forced1313
	MOVF        FARG_mysql_search_forced_buscar+0, 0 
	XORWF       mysql_search_forced_busqueda_L0+0, 0 
L__mysql_search_forced1313:
	BTFSS       STATUS+0, 2 
	GOTO        L_mysql_search_forced510
;table_eeprom.h,409 :: 		return TABLE_RW_SUCCESS;
	CLRF        R0 
	GOTO        L_end_mysql_search_forced
L_mysql_search_forced510:
;table_eeprom.h,410 :: 		}
L_mysql_search_forced509:
;table_eeprom.h,405 :: 		for(*fila = 1; *fila <= myTable.row; (*fila)++){
	MOVFF       FARG_mysql_search_forced_fila+0, FSR0
	MOVFF       FARG_mysql_search_forced_fila+1, FSR0H
	MOVF        POSTINC0+0, 0 
	MOVWF       R0 
	MOVF        POSTINC0+0, 0 
	MOVWF       R1 
	INFSNZ      R0, 1 
	INCF        R1, 1 
	MOVFF       FARG_mysql_search_forced_fila+0, FSR1
	MOVFF       FARG_mysql_search_forced_fila+1, FSR1H
	MOVF        R0, 0 
	MOVWF       POSTINC1+0 
	MOVF        R1, 0 
	MOVWF       POSTINC1+0 
;table_eeprom.h,411 :: 		}
	GOTO        L_mysql_search_forced506
L_mysql_search_forced507:
;table_eeprom.h,412 :: 		return TABLE_RW_NO_EXIST_ROW;
	MOVLW       3
	MOVWF       R0 
	GOTO        L_end_mysql_search_forced
;table_eeprom.h,413 :: 		}
L_mysql_search_forced505:
;table_eeprom.h,415 :: 		return TABLE_RW_NO_EXIST_TABLE;
	MOVLW       1
	MOVWF       R0 
;table_eeprom.h,416 :: 		}
L_end_mysql_search_forced:
	RETURN      0
; end of _mysql_search_forced

_mysql_count:

;table_eeprom.h,418 :: 		int mysql_count(char *tabla, char *columna, long buscar){
;table_eeprom.h,419 :: 		int coincidencias = 0;
	CLRF        mysql_count_coincidencias_L0+0 
	CLRF        mysql_count_coincidencias_L0+1 
;table_eeprom.h,423 :: 		if(mysql_exist(tabla)){
	MOVF        FARG_mysql_count_tabla+0, 0 
	MOVWF       FARG_mysql_exist_name+0 
	MOVF        FARG_mysql_count_tabla+1, 0 
	MOVWF       FARG_mysql_exist_name+1 
	CALL        _mysql_exist+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_mysql_count511
;table_eeprom.h,424 :: 		for(myTable.cont = 1; myTable.cont <= myTable.rowAct; myTable.cont++){
	MOVLW       1
	MOVWF       TPV_myTable+47 
L_mysql_count512:
	MOVLW       0
	SUBWF       TPV_myTable+5, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__mysql_count1315
	MOVF        TPV_myTable+47, 0 
	SUBWF       TPV_myTable+4, 0 
L__mysql_count1315:
	BTFSS       STATUS+0, 0 
	GOTO        L_mysql_count513
;table_eeprom.h,426 :: 		if(!mysql_read(tabla, columna, myTable.cont, &busqueda)){
	MOVF        FARG_mysql_count_tabla+0, 0 
	MOVWF       FARG_mysql_read_name+0 
	MOVF        FARG_mysql_count_tabla+1, 0 
	MOVWF       FARG_mysql_read_name+1 
	MOVF        FARG_mysql_count_columna+0, 0 
	MOVWF       FARG_mysql_read_column+0 
	MOVF        FARG_mysql_count_columna+1, 0 
	MOVWF       FARG_mysql_read_column+1 
	MOVF        TPV_myTable+47, 0 
	MOVWF       FARG_mysql_read_fila+0 
	MOVLW       0
	MOVWF       FARG_mysql_read_fila+1 
	MOVLW       mysql_count_busqueda_L0+0
	MOVWF       FARG_mysql_read_result+0 
	MOVLW       hi_addr(mysql_count_busqueda_L0+0)
	MOVWF       FARG_mysql_read_result+1 
	CALL        _mysql_read+0, 0
	MOVF        R0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_mysql_count515
;table_eeprom.h,427 :: 		if(buscar == busqueda)
	MOVF        FARG_mysql_count_buscar+3, 0 
	XORWF       mysql_count_busqueda_L0+3, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__mysql_count1316
	MOVF        FARG_mysql_count_buscar+2, 0 
	XORWF       mysql_count_busqueda_L0+2, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__mysql_count1316
	MOVF        FARG_mysql_count_buscar+1, 0 
	XORWF       mysql_count_busqueda_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__mysql_count1316
	MOVF        FARG_mysql_count_buscar+0, 0 
	XORWF       mysql_count_busqueda_L0+0, 0 
L__mysql_count1316:
	BTFSS       STATUS+0, 2 
	GOTO        L_mysql_count516
;table_eeprom.h,428 :: 		coincidencias++;
	INFSNZ      mysql_count_coincidencias_L0+0, 1 
	INCF        mysql_count_coincidencias_L0+1, 1 
L_mysql_count516:
;table_eeprom.h,429 :: 		}
L_mysql_count515:
;table_eeprom.h,424 :: 		for(myTable.cont = 1; myTable.cont <= myTable.rowAct; myTable.cont++){
	MOVF        TPV_myTable+47, 0 
	ADDLW       1
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       TPV_myTable+47 
;table_eeprom.h,430 :: 		}
	GOTO        L_mysql_count512
L_mysql_count513:
;table_eeprom.h,431 :: 		}
L_mysql_count511:
;table_eeprom.h,433 :: 		return coincidencias;
	MOVF        mysql_count_coincidencias_L0+0, 0 
	MOVWF       R0 
	MOVF        mysql_count_coincidencias_L0+1, 0 
	MOVWF       R1 
;table_eeprom.h,434 :: 		}
L_end_mysql_count:
	RETURN      0
; end of _mysql_count

_mysql_count_forced:

;table_eeprom.h,436 :: 		int mysql_count_forced(char *tabla, char *columna, long buscar){
;table_eeprom.h,437 :: 		int coincidencias = 0;
	CLRF        mysql_count_forced_coincidencias_L0+0 
	CLRF        mysql_count_forced_coincidencias_L0+1 
	CLRF        mysql_count_forced_busqueda_L0+0 
	CLRF        mysql_count_forced_busqueda_L0+1 
	CLRF        mysql_count_forced_busqueda_L0+2 
	CLRF        mysql_count_forced_busqueda_L0+3 
;table_eeprom.h,441 :: 		if(mysql_exist(tabla)){
	MOVF        FARG_mysql_count_forced_tabla+0, 0 
	MOVWF       FARG_mysql_exist_name+0 
	MOVF        FARG_mysql_count_forced_tabla+1, 0 
	MOVWF       FARG_mysql_exist_name+1 
	CALL        _mysql_exist+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_mysql_count_forced517
;table_eeprom.h,442 :: 		for(myTable.cont = 1; myTable.cont <= myTable.row; myTable.cont++){
	MOVLW       1
	MOVWF       TPV_myTable+47 
L_mysql_count_forced518:
	MOVLW       0
	SUBWF       TPV_myTable+3, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__mysql_count_forced1318
	MOVF        TPV_myTable+47, 0 
	SUBWF       TPV_myTable+2, 0 
L__mysql_count_forced1318:
	BTFSS       STATUS+0, 0 
	GOTO        L_mysql_count_forced519
;table_eeprom.h,444 :: 		if(!mysql_read_forced(tabla, columna, myTable.cont, (char*)&busqueda)){
	MOVF        FARG_mysql_count_forced_tabla+0, 0 
	MOVWF       FARG_mysql_read_forced_name+0 
	MOVF        FARG_mysql_count_forced_tabla+1, 0 
	MOVWF       FARG_mysql_read_forced_name+1 
	MOVF        FARG_mysql_count_forced_columna+0, 0 
	MOVWF       FARG_mysql_read_forced_column+0 
	MOVF        FARG_mysql_count_forced_columna+1, 0 
	MOVWF       FARG_mysql_read_forced_column+1 
	MOVF        TPV_myTable+47, 0 
	MOVWF       FARG_mysql_read_forced_fila+0 
	MOVLW       0
	MOVWF       FARG_mysql_read_forced_fila+1 
	MOVLW       mysql_count_forced_busqueda_L0+0
	MOVWF       FARG_mysql_read_forced_result+0 
	MOVLW       hi_addr(mysql_count_forced_busqueda_L0+0)
	MOVWF       FARG_mysql_read_forced_result+1 
	CALL        _mysql_read_forced+0, 0
	MOVF        R0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_mysql_count_forced521
;table_eeprom.h,445 :: 		if(buscar == busqueda)
	MOVF        FARG_mysql_count_forced_buscar+3, 0 
	XORWF       mysql_count_forced_busqueda_L0+3, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__mysql_count_forced1319
	MOVF        FARG_mysql_count_forced_buscar+2, 0 
	XORWF       mysql_count_forced_busqueda_L0+2, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__mysql_count_forced1319
	MOVF        FARG_mysql_count_forced_buscar+1, 0 
	XORWF       mysql_count_forced_busqueda_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__mysql_count_forced1319
	MOVF        FARG_mysql_count_forced_buscar+0, 0 
	XORWF       mysql_count_forced_busqueda_L0+0, 0 
L__mysql_count_forced1319:
	BTFSS       STATUS+0, 2 
	GOTO        L_mysql_count_forced522
;table_eeprom.h,446 :: 		coincidencias++;
	INFSNZ      mysql_count_forced_coincidencias_L0+0, 1 
	INCF        mysql_count_forced_coincidencias_L0+1, 1 
L_mysql_count_forced522:
;table_eeprom.h,447 :: 		}
L_mysql_count_forced521:
;table_eeprom.h,442 :: 		for(myTable.cont = 1; myTable.cont <= myTable.row; myTable.cont++){
	MOVF        TPV_myTable+47, 0 
	ADDLW       1
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       TPV_myTable+47 
;table_eeprom.h,448 :: 		}
	GOTO        L_mysql_count_forced518
L_mysql_count_forced519:
;table_eeprom.h,449 :: 		}
L_mysql_count_forced517:
;table_eeprom.h,451 :: 		return coincidencias;
	MOVF        mysql_count_forced_coincidencias_L0+0, 0 
	MOVWF       R0 
	MOVF        mysql_count_forced_coincidencias_L0+1, 0 
	MOVWF       R1 
;table_eeprom.h,452 :: 		}
L_end_mysql_count_forced:
	RETURN      0
; end of _mysql_count_forced

__mysql_calculate_address:

;table_eeprom.h,456 :: 		char _mysql_calculate_address(char *name, char *column){
;table_eeprom.h,457 :: 		unsigned int addressAux = 0;
	CLRF        _mysql_calculate_address_addressAux_L0+0 
	CLRF        _mysql_calculate_address_addressAux_L0+1 
;table_eeprom.h,460 :: 		if(strncmp(name, myTable.nameAct, TABLE_MAX_SIZE_NAME+1)){
	MOVF        FARG__mysql_calculate_address_name+0, 0 
	MOVWF       FARG_strncmp_s1+0 
	MOVF        FARG__mysql_calculate_address_name+1, 0 
	MOVWF       FARG_strncmp_s1+1 
	MOVLW       TPV_myTable+7
	MOVWF       FARG_strncmp_s2+0 
	MOVLW       hi_addr(TPV_myTable+7)
	MOVWF       FARG_strncmp_s2+1 
	MOVLW       16
	MOVWF       FARG_strncmp_len+0 
	CALL        _strncmp+0, 0
	MOVF        R0, 0 
	IORWF       R1, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L__mysql_calculate_address523
;table_eeprom.h,461 :: 		if(!mysql_exist(name)){
	MOVF        FARG__mysql_calculate_address_name+0, 0 
	MOVWF       FARG_mysql_exist_name+0 
	MOVF        FARG__mysql_calculate_address_name+1, 0 
	MOVWF       FARG_mysql_exist_name+1 
	CALL        _mysql_exist+0, 0
	MOVF        R0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L__mysql_calculate_address524
;table_eeprom.h,462 :: 		return TABLE_RW_NO_EXIST_TABLE;  //No existe la tabla buscada
	MOVLW       1
	MOVWF       R0 
	GOTO        L_end__mysql_calculate_address
;table_eeprom.h,463 :: 		}
L__mysql_calculate_address524:
;table_eeprom.h,464 :: 		}
L__mysql_calculate_address523:
;table_eeprom.h,466 :: 		if(strncmp(column, myTable.nameColAct, TABLE_MAX_SIZE_NAME+1)){
	MOVF        FARG__mysql_calculate_address_column+0, 0 
	MOVWF       FARG_strncmp_s1+0 
	MOVF        FARG__mysql_calculate_address_column+1, 0 
	MOVWF       FARG_strncmp_s1+1 
	MOVLW       TPV_myTable+23
	MOVWF       FARG_strncmp_s2+0 
	MOVLW       hi_addr(TPV_myTable+23)
	MOVWF       FARG_strncmp_s2+1 
	MOVLW       16
	MOVWF       FARG_strncmp_len+0 
	CALL        _strncmp+0, 0
	MOVF        R0, 0 
	IORWF       R1, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L__mysql_calculate_address525
;table_eeprom.h,467 :: 		myTable.addressAct = myTable.address;   //Copiar direccion casa de la tabla
	MOVF        TPV_myTable+43, 0 
	MOVWF       TPV_myTable+45 
	MOVF        TPV_myTable+44, 0 
	MOVWF       TPV_myTable+46 
;table_eeprom.h,469 :: 		myTable.addressAct += TABLE_MAX_SIZE_NAME+3;
	MOVLW       18
	ADDWF       TPV_myTable+43, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      TPV_myTable+44, 0 
	MOVWF       R1 
	MOVF        R0, 0 
	MOVWF       TPV_myTable+45 
	MOVF        R1, 0 
	MOVWF       TPV_myTable+46 
;table_eeprom.h,470 :: 		eeprom_i2c_read(myTable.addressAct,(char*)&myTable.rowAct, 2);
	MOVF        R0, 0 
	MOVWF       FARG_eeprom_i2c_read_address+0 
	MOVF        R1, 0 
	MOVWF       FARG_eeprom_i2c_read_address+1 
	MOVLW       TPV_myTable+4
	MOVWF       FARG_eeprom_i2c_read_datos+0 
	MOVLW       hi_addr(TPV_myTable+4)
	MOVWF       FARG_eeprom_i2c_read_datos+1 
	MOVLW       2
	MOVWF       FARG_eeprom_i2c_read_size+0 
	CALL        _eeprom_i2c_read+0, 0
;table_eeprom.h,471 :: 		eeprom_i2c_read(myTable.addressAct+2,(char*)&myTable.row, 2);
	MOVLW       2
	ADDWF       TPV_myTable+45, 0 
	MOVWF       FARG_eeprom_i2c_read_address+0 
	MOVLW       0
	ADDWFC      TPV_myTable+46, 0 
	MOVWF       FARG_eeprom_i2c_read_address+1 
	MOVLW       TPV_myTable+2
	MOVWF       FARG_eeprom_i2c_read_datos+0 
	MOVLW       hi_addr(TPV_myTable+2)
	MOVWF       FARG_eeprom_i2c_read_datos+1 
	MOVLW       2
	MOVWF       FARG_eeprom_i2c_read_size+0 
	CALL        _eeprom_i2c_read+0, 0
;table_eeprom.h,472 :: 		eeprom_i2c_read(myTable.addressAct+4,&myTable.col, 1); //Filas totales de busqueda
	MOVLW       4
	ADDWF       TPV_myTable+45, 0 
	MOVWF       FARG_eeprom_i2c_read_address+0 
	MOVLW       0
	ADDWFC      TPV_myTable+46, 0 
	MOVWF       FARG_eeprom_i2c_read_address+1 
	MOVLW       TPV_myTable+1
	MOVWF       FARG_eeprom_i2c_read_datos+0 
	MOVLW       hi_addr(TPV_myTable+1)
	MOVWF       FARG_eeprom_i2c_read_datos+1 
	MOVLW       1
	MOVWF       FARG_eeprom_i2c_read_size+0 
	CALL        _eeprom_i2c_read+0, 0
;table_eeprom.h,474 :: 		myTable.addressAct += (4+1);   //Apuntamos a la primera columna name
	MOVLW       5
	ADDWF       TPV_myTable+45, 0 
	MOVWF       FLOC___mysql_calculate_address+0 
	MOVLW       0
	ADDWFC      TPV_myTable+46, 0 
	MOVWF       FLOC___mysql_calculate_address+1 
	MOVF        FLOC___mysql_calculate_address+0, 0 
	MOVWF       TPV_myTable+45 
	MOVF        FLOC___mysql_calculate_address+1, 0 
	MOVWF       TPV_myTable+46 
;table_eeprom.h,475 :: 		addressAux = myTable.addressAct;
	MOVF        FLOC___mysql_calculate_address+0, 0 
	MOVWF       _mysql_calculate_address_addressAux_L0+0 
	MOVF        FLOC___mysql_calculate_address+1, 0 
	MOVWF       _mysql_calculate_address_addressAux_L0+1 
;table_eeprom.h,476 :: 		addressAux += myTable.col*(TABLE_MAX_SIZE_NAME+1+1); //Apuntar a los datos
	MOVF        TPV_myTable+1, 0 
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	MOVLW       17
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	MOVF        R0, 0 
	ADDWF       FLOC___mysql_calculate_address+0, 0 
	MOVWF       _mysql_calculate_address_addressAux_L0+0 
	MOVF        R1, 0 
	ADDWFC      FLOC___mysql_calculate_address+1, 0 
	MOVWF       _mysql_calculate_address_addressAux_L0+1 
;table_eeprom.h,479 :: 		for(myTable.cont = 0; myTable.cont < myTable.col; myTable.cont++){
	CLRF        TPV_myTable+47 
L__mysql_calculate_address526:
	MOVF        TPV_myTable+1, 0 
	SUBWF       TPV_myTable+47, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L__mysql_calculate_address527
;table_eeprom.h,481 :: 		eeprom_i2c_read(myTable.addressAct, myTable.nameColAct, TABLE_MAX_SIZE_NAME+1);
	MOVF        TPV_myTable+45, 0 
	MOVWF       FARG_eeprom_i2c_read_address+0 
	MOVF        TPV_myTable+46, 0 
	MOVWF       FARG_eeprom_i2c_read_address+1 
	MOVLW       TPV_myTable+23
	MOVWF       FARG_eeprom_i2c_read_datos+0 
	MOVLW       hi_addr(TPV_myTable+23)
	MOVWF       FARG_eeprom_i2c_read_datos+1 
	MOVLW       16
	MOVWF       FARG_eeprom_i2c_read_size+0 
	CALL        _eeprom_i2c_read+0, 0
;table_eeprom.h,483 :: 		myTable.addressAct += TABLE_MAX_SIZE_NAME+1;
	MOVLW       16
	ADDWF       TPV_myTable+45, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      TPV_myTable+46, 0 
	MOVWF       R1 
	MOVF        R0, 0 
	MOVWF       TPV_myTable+45 
	MOVF        R1, 0 
	MOVWF       TPV_myTable+46 
;table_eeprom.h,484 :: 		eeprom_i2c_read(myTable.addressAct, &myTable.tamCol, 1); //1 de esta direccion
	MOVF        R0, 0 
	MOVWF       FARG_eeprom_i2c_read_address+0 
	MOVF        R1, 0 
	MOVWF       FARG_eeprom_i2c_read_address+1 
	MOVLW       TPV_myTable+6
	MOVWF       FARG_eeprom_i2c_read_datos+0 
	MOVLW       hi_addr(TPV_myTable+6)
	MOVWF       FARG_eeprom_i2c_read_datos+1 
	MOVLW       1
	MOVWF       FARG_eeprom_i2c_read_size+0 
	CALL        _eeprom_i2c_read+0, 0
;table_eeprom.h,485 :: 		myTable.addressAct += 1;
	MOVLW       1
	ADDWF       TPV_myTable+45, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      TPV_myTable+46, 0 
	MOVWF       R1 
	MOVF        R0, 0 
	MOVWF       TPV_myTable+45 
	MOVF        R1, 0 
	MOVWF       TPV_myTable+46 
;table_eeprom.h,487 :: 		if(!strncmp(column, myTable.nameColAct, TABLE_MAX_SIZE_NAME+1))
	MOVF        FARG__mysql_calculate_address_column+0, 0 
	MOVWF       FARG_strncmp_s1+0 
	MOVF        FARG__mysql_calculate_address_column+1, 0 
	MOVWF       FARG_strncmp_s1+1 
	MOVLW       TPV_myTable+23
	MOVWF       FARG_strncmp_s2+0 
	MOVLW       hi_addr(TPV_myTable+23)
	MOVWF       FARG_strncmp_s2+1 
	MOVLW       16
	MOVWF       FARG_strncmp_len+0 
	CALL        _strncmp+0, 0
	MOVF        R0, 0 
	IORWF       R1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__mysql_calculate_address529
;table_eeprom.h,488 :: 		break;
	GOTO        L__mysql_calculate_address527
L__mysql_calculate_address529:
;table_eeprom.h,490 :: 		addressAux += myTable.tamCol*myTable.row;   //Acumular las columnas para saber la direccion
	MOVF        TPV_myTable+6, 0 
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	MOVF        TPV_myTable+2, 0 
	MOVWF       R4 
	MOVF        TPV_myTable+3, 0 
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	MOVF        R0, 0 
	ADDWF       _mysql_calculate_address_addressAux_L0+0, 1 
	MOVF        R1, 0 
	ADDWFC      _mysql_calculate_address_addressAux_L0+1, 1 
;table_eeprom.h,479 :: 		for(myTable.cont = 0; myTable.cont < myTable.col; myTable.cont++){
	MOVF        TPV_myTable+47, 0 
	ADDLW       1
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       TPV_myTable+47 
;table_eeprom.h,492 :: 		}
	GOTO        L__mysql_calculate_address526
L__mysql_calculate_address527:
;table_eeprom.h,494 :: 		if(myTable.cont >= myTable.col){
	MOVF        TPV_myTable+1, 0 
	SUBWF       TPV_myTable+47, 0 
	BTFSS       STATUS+0, 0 
	GOTO        L__mysql_calculate_address530
;table_eeprom.h,495 :: 		myTable.nameColAct[0] = 0;
	CLRF        TPV_myTable+23 
;table_eeprom.h,496 :: 		return TABLE_RW_NO_EXIST_NAME_COL;
	MOVLW       2
	MOVWF       R0 
	GOTO        L_end__mysql_calculate_address
;table_eeprom.h,497 :: 		}
L__mysql_calculate_address530:
;table_eeprom.h,498 :: 		myTable.addressAct = addressAux;
	MOVF        _mysql_calculate_address_addressAux_L0+0, 0 
	MOVWF       TPV_myTable+45 
	MOVF        _mysql_calculate_address_addressAux_L0+1, 0 
	MOVWF       TPV_myTable+46 
;table_eeprom.h,499 :: 		}
L__mysql_calculate_address525:
;table_eeprom.h,501 :: 		return TABLE_RW_SUCCESS;
	CLRF        R0 
;table_eeprom.h,502 :: 		}
L_end__mysql_calculate_address:
	RETURN      0
; end of __mysql_calculate_address

_external_int0_open:

;lib_external_int0.h,8 :: 		void external_int0_open(bool enable, bool edgeOnRising){
;lib_external_int0.h,9 :: 		INTCON.INT0IF = 0;                  //LIMPIAR BANDERA
	BCF         INTCON+0, 1 
;lib_external_int0.h,10 :: 		INTCON2.INTEDG0 = edgeOnRising.B0;  //FLANCO DE SUBIDA
	BTFSC       FARG_external_int0_open_edgeOnRising+0, 0 
	GOTO        L__external_int0_open1322
	BCF         INTCON2+0, 6 
	GOTO        L__external_int0_open1323
L__external_int0_open1322:
	BSF         INTCON2+0, 6 
L__external_int0_open1323:
;lib_external_int0.h,11 :: 		INTCON.INT0IE = enable.B0;          //DISPONIBILIDAD
	BTFSC       FARG_external_int0_open_enable+0, 0 
	GOTO        L__external_int0_open1324
	BCF         INTCON+0, 4 
	GOTO        L__external_int0_open1325
L__external_int0_open1324:
	BSF         INTCON+0, 4 
L__external_int0_open1325:
;lib_external_int0.h,12 :: 		}
L_end_external_int0_open:
	RETURN      0
; end of _external_int0_open

_external_int0_enable:

;lib_external_int0.h,14 :: 		void external_int0_enable(bool enable){
;lib_external_int0.h,15 :: 		INTCON.INT0IE = enable.B0;          //DISPONIBILIDAD
	BTFSC       FARG_external_int0_enable_enable+0, 0 
	GOTO        L__external_int0_enable1327
	BCF         INTCON+0, 4 
	GOTO        L__external_int0_enable1328
L__external_int0_enable1327:
	BSF         INTCON+0, 4 
L__external_int0_enable1328:
;lib_external_int0.h,16 :: 		}
L_end_external_int0_enable:
	RETURN      0
; end of _external_int0_enable

_external_int0_edge:

;lib_external_int0.h,18 :: 		void external_int0_edge(bool onRising){
;lib_external_int0.h,19 :: 		INTCON2.INTEDG0 = onRising.B0;      //FLANCO DE SUBIDA
	BTFSC       FARG_external_int0_edge_onRising+0, 0 
	GOTO        L__external_int0_edge1330
	BCF         INTCON2+0, 6 
	GOTO        L__external_int0_edge1331
L__external_int0_edge1330:
	BSF         INTCON2+0, 6 
L__external_int0_edge1331:
;lib_external_int0.h,20 :: 		}
L_end_external_int0_edge:
	RETURN      0
; end of _external_int0_edge

_external_int1_open:

;lib_external_int1.h,8 :: 		void external_int1_open(bool enable, bool edgeOnRising, bool priorityHigh){
;lib_external_int1.h,9 :: 		INTCON3.INT1IF = 0;                //LIMPIAR BANDERA
	BCF         INTCON3+0, 0 
;lib_external_int1.h,10 :: 		INTCON2.INTEDG1 = edgeOnRising.B0; //FLANCO DE SUBIDA
	BTFSC       FARG_external_int1_open_edgeOnRising+0, 0 
	GOTO        L__external_int1_open1333
	BCF         INTCON2+0, 5 
	GOTO        L__external_int1_open1334
L__external_int1_open1333:
	BSF         INTCON2+0, 5 
L__external_int1_open1334:
;lib_external_int1.h,11 :: 		INTCON3.INT1IP = priorityHigh.B0;  //PRIORIDAD DE LA INTERRUPCION
	BTFSC       FARG_external_int1_open_priorityHigh+0, 0 
	GOTO        L__external_int1_open1335
	BCF         INTCON3+0, 6 
	GOTO        L__external_int1_open1336
L__external_int1_open1335:
	BSF         INTCON3+0, 6 
L__external_int1_open1336:
;lib_external_int1.h,12 :: 		INTCON3.INT1IE = enable.B0;        //DISPONIBILIDAD
	BTFSC       FARG_external_int1_open_enable+0, 0 
	GOTO        L__external_int1_open1337
	BCF         INTCON3+0, 3 
	GOTO        L__external_int1_open1338
L__external_int1_open1337:
	BSF         INTCON3+0, 3 
L__external_int1_open1338:
;lib_external_int1.h,13 :: 		}
L_end_external_int1_open:
	RETURN      0
; end of _external_int1_open

_external_int1_enable:

;lib_external_int1.h,15 :: 		void external_int1_enable(bool enable){
;lib_external_int1.h,16 :: 		INTCON3.INT1IE = enable.B0;        //DISPONIBILIDAD
	BTFSC       FARG_external_int1_enable_enable+0, 0 
	GOTO        L__external_int1_enable1340
	BCF         INTCON3+0, 3 
	GOTO        L__external_int1_enable1341
L__external_int1_enable1340:
	BSF         INTCON3+0, 3 
L__external_int1_enable1341:
;lib_external_int1.h,17 :: 		}
L_end_external_int1_enable:
	RETURN      0
; end of _external_int1_enable

_external_int1_edge:

;lib_external_int1.h,19 :: 		void external_int1_edge(bool onRising){
;lib_external_int1.h,20 :: 		INTCON2.INTEDG1 = onRising.B0;     //FLANCO DE SUBIDA
	BTFSC       FARG_external_int1_edge_onRising+0, 0 
	GOTO        L__external_int1_edge1343
	BCF         INTCON2+0, 5 
	GOTO        L__external_int1_edge1344
L__external_int1_edge1343:
	BSF         INTCON2+0, 5 
L__external_int1_edge1344:
;lib_external_int1.h,21 :: 		}
L_end_external_int1_edge:
	RETURN      0
; end of _external_int1_edge

_external_int1_priority:

;lib_external_int1.h,23 :: 		void external_int1_priority(bool high){
;lib_external_int1.h,24 :: 		INTCON3.INT1IP = high.B0;          //PRIORIDAD DE LA INTERRUPCION
	BTFSC       FARG_external_int1_priority_high+0, 0 
	GOTO        L__external_int1_priority1346
	BCF         INTCON3+0, 6 
	GOTO        L__external_int1_priority1347
L__external_int1_priority1346:
	BSF         INTCON3+0, 6 
L__external_int1_priority1347:
;lib_external_int1.h,25 :: 		}
L_end_external_int1_priority:
	RETURN      0
; end of _external_int1_priority

_wiegand26_open:

;wiegand26.h,51 :: 		void wiegand26_open(){
;wiegand26.h,52 :: 		external_int0_open(false, false);        //No disponible, flanco de bajada
	CLRF        FARG_external_int0_open_enable+0 
	CLRF        FARG_external_int0_open_edgeOnRising+0 
	CALL        _external_int0_open+0, 0
;wiegand26.h,53 :: 		external_int1_open(false, false, true);  //No disponible, flanco de bajada
	CLRF        FARG_external_int1_open_enable+0 
	CLRF        FARG_external_int1_open_edgeOnRising+0 
	MOVLW       1
	MOVWF       FARG_external_int1_open_priorityHigh+0 
	CALL        _external_int1_open+0, 0
;wiegand26.h,54 :: 		WIEGAN26_DATA = 0;
	CLRF        TPV_WIEGAN26_DATA+0 
	CLRF        TPV_WIEGAN26_DATA+1 
	CLRF        TPV_WIEGAN26_DATA+2 
	CLRF        TPV_WIEGAN26_DATA+3 
;wiegand26.h,55 :: 		WIEGAN26_CONT = 0;
	CLRF        TPV_WIEGAN26_CONT+0 
;wiegand26.h,56 :: 		WIEGAND_TEMP = 0;
	CLRF        _WIEGAND_TEMP+0 
	CLRF        _WIEGAND_TEMP+1 
;wiegand26.h,58 :: 		timer2_open(5000, true, true, false);
	MOVLW       136
	MOVWF       FARG_timer2_open_time_us+0 
	MOVLW       19
	MOVWF       FARG_timer2_open_time_us+1 
	MOVLW       0
	MOVWF       FARG_timer2_open_time_us+2 
	MOVWF       FARG_timer2_open_time_us+3 
	MOVLW       1
	MOVWF       FARG_timer2_open_powerOn+0 
	MOVLW       1
	MOVWF       FARG_timer2_open_enable+0 
	CLRF        FARG_timer2_open_priorityHigh+0 
	CALL        _timer2_open+0, 0
;wiegand26.h,59 :: 		}
L_end_wiegand26_open:
	RETURN      0
; end of _wiegand26_open

_wiegand26_read_card:

;wiegand26.h,61 :: 		bool wiegand26_read_card(long *id){
;wiegand26.h,65 :: 		if(WIEGAN26_CONT == 26){
	MOVF        TPV_WIEGAN26_CONT+0, 0 
	XORLW       26
	BTFSS       STATUS+0, 2 
	GOTO        L_wiegand26_read_card531
;wiegand26.h,66 :: 		delay_ms(_WIEGAND26_PULSE_TIME_MAX_MS);  //Para asegurar datos de 26 bits
	MOVLW       17
	MOVWF       R12, 0
	MOVLW       58
	MOVWF       R13, 0
L_wiegand26_read_card532:
	DECFSZ      R13, 1, 1
	BRA         L_wiegand26_read_card532
	DECFSZ      R12, 1, 1
	BRA         L_wiegand26_read_card532
	NOP
;wiegand26.h,68 :: 		if(WIEGAN26_CONT != 26)
	MOVF        TPV_WIEGAN26_CONT+0, 0 
	XORLW       26
	BTFSC       STATUS+0, 2 
	GOTO        L_wiegand26_read_card533
;wiegand26.h,69 :: 		return false;
	CLRF        R0 
	GOTO        L_end_wiegand26_read_card
L_wiegand26_read_card533:
;wiegand26.h,71 :: 		WIEGAN26_BUFFER = WIEGAN26_DATA;
	MOVF        TPV_WIEGAN26_DATA+0, 0 
	MOVWF       TPV_WIEGAN26_BUFFER+0 
	MOVF        TPV_WIEGAN26_DATA+1, 0 
	MOVWF       TPV_WIEGAN26_BUFFER+1 
	MOVF        TPV_WIEGAN26_DATA+2, 0 
	MOVWF       TPV_WIEGAN26_BUFFER+2 
	MOVF        TPV_WIEGAN26_DATA+3, 0 
	MOVWF       TPV_WIEGAN26_BUFFER+3 
;wiegand26.h,72 :: 		aux = WIEGAN26_BUFFER;
	MOVF        TPV_WIEGAN26_DATA+0, 0 
	MOVWF       R14 
	MOVF        TPV_WIEGAN26_DATA+1, 0 
	MOVWF       R15 
	MOVF        TPV_WIEGAN26_DATA+2, 0 
	MOVWF       R16 
	MOVF        TPV_WIEGAN26_DATA+3, 0 
	MOVWF       R17 
;wiegand26.h,74 :: 		WIEGAN26_CONT = 0;    //Resetear puntero
	CLRF        TPV_WIEGAN26_CONT+0 
;wiegand26.h,75 :: 		WIEGAN26_DATA = 0;    //Resetear la informacion
	CLRF        TPV_WIEGAN26_DATA+0 
	CLRF        TPV_WIEGAN26_DATA+1 
	CLRF        TPV_WIEGAN26_DATA+2 
	CLRF        TPV_WIEGAN26_DATA+3 
;wiegand26.h,77 :: 		for(paridad = 0, i = 0; i < 13; i++){
	CLRF        R10 
	CLRF        R9 
L_wiegand26_read_card534:
	MOVLW       13
	SUBWF       R9, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_wiegand26_read_card535
;wiegand26.h,78 :: 		paridad += getByte(aux,0).B0;
	CLRF        R0 
	BTFSC       R14, 0 
	INCF        R0, 1 
	MOVF        R0, 0 
	ADDWF       R10, 1 
;wiegand26.h,79 :: 		aux >>= 1;
	RRCF        R17, 1 
	RRCF        R16, 1 
	RRCF        R15, 1 
	RRCF        R14, 1 
	BCF         R17, 7 
	BTFSC       R17, 6 
	BSF         R17, 7 
;wiegand26.h,77 :: 		for(paridad = 0, i = 0; i < 13; i++){
	INCF        R9, 1 
;wiegand26.h,80 :: 		}
	GOTO        L_wiegand26_read_card534
L_wiegand26_read_card535:
;wiegand26.h,82 :: 		if(paridad % 2 != 1)
	MOVLW       1
	ANDWF       R10, 0 
	MOVWF       R1 
	MOVF        R1, 0 
	XORLW       1
	BTFSC       STATUS+0, 2 
	GOTO        L_wiegand26_read_card537
;wiegand26.h,83 :: 		return false;
	CLRF        R0 
	GOTO        L_end_wiegand26_read_card
L_wiegand26_read_card537:
;wiegand26.h,85 :: 		for(paridad = 0, i = 0; i < 13; i++){
	CLRF        R10 
	CLRF        R9 
L_wiegand26_read_card538:
	MOVLW       13
	SUBWF       R9, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_wiegand26_read_card539
;wiegand26.h,86 :: 		paridad += getByte(aux,0).B0;
	CLRF        R0 
	BTFSC       R14, 0 
	INCF        R0, 1 
	MOVF        R0, 0 
	ADDWF       R10, 1 
;wiegand26.h,87 :: 		aux >>= 1;
	RRCF        R17, 1 
	RRCF        R16, 1 
	RRCF        R15, 1 
	RRCF        R14, 1 
	BCF         R17, 7 
	BTFSC       R17, 6 
	BSF         R17, 7 
;wiegand26.h,85 :: 		for(paridad = 0, i = 0; i < 13; i++){
	INCF        R9, 1 
;wiegand26.h,88 :: 		}
	GOTO        L_wiegand26_read_card538
L_wiegand26_read_card539:
;wiegand26.h,90 :: 		if(paridad % 2 != 0)
	MOVLW       1
	ANDWF       R10, 0 
	MOVWF       R1 
	MOVF        R1, 0 
	XORLW       0
	BTFSC       STATUS+0, 2 
	GOTO        L_wiegand26_read_card541
;wiegand26.h,91 :: 		return false;
	CLRF        R0 
	GOTO        L_end_wiegand26_read_card
L_wiegand26_read_card541:
;wiegand26.h,93 :: 		*id = WIEGAN26_BUFFER;
	MOVFF       FARG_wiegand26_read_card_id+0, FSR1
	MOVFF       FARG_wiegand26_read_card_id+1, FSR1H
	MOVF        TPV_WIEGAN26_BUFFER+0, 0 
	MOVWF       POSTINC1+0 
	MOVF        TPV_WIEGAN26_BUFFER+1, 0 
	MOVWF       POSTINC1+0 
	MOVF        TPV_WIEGAN26_BUFFER+2, 0 
	MOVWF       POSTINC1+0 
	MOVF        TPV_WIEGAN26_BUFFER+3, 0 
	MOVWF       POSTINC1+0 
;wiegand26.h,94 :: 		*id >>= 1;              //Se recorre a la derecha, quitar bit paridad imparidad
	MOVFF       FARG_wiegand26_read_card_id+0, FSR0
	MOVFF       FARG_wiegand26_read_card_id+1, FSR0H
	MOVF        POSTINC0+0, 0 
	MOVWF       R5 
	MOVF        POSTINC0+0, 0 
	MOVWF       R6 
	MOVF        POSTINC0+0, 0 
	MOVWF       R7 
	MOVF        POSTINC0+0, 0 
	MOVWF       R8 
	MOVF        R5, 0 
	MOVWF       R0 
	MOVF        R6, 0 
	MOVWF       R1 
	MOVF        R7, 0 
	MOVWF       R2 
	MOVF        R8, 0 
	MOVWF       R3 
	RRCF        R3, 1 
	RRCF        R2, 1 
	RRCF        R1, 1 
	RRCF        R0, 1 
	BCF         R3, 7 
	BTFSC       R3, 6 
	BSF         R3, 7 
	MOVFF       FARG_wiegand26_read_card_id+0, FSR1
	MOVFF       FARG_wiegand26_read_card_id+1, FSR1H
	MOVF        R0, 0 
	MOVWF       POSTINC1+0 
	MOVF        R1, 0 
	MOVWF       POSTINC1+0 
	MOVF        R2, 0 
	MOVWF       POSTINC1+0 
	MOVF        R3, 0 
	MOVWF       POSTINC1+0 
;wiegand26.h,95 :: 		getByte(*id, 3) = 0x00; //Quitamos el bit de paridad par
	MOVLW       3
	ADDWF       FARG_wiegand26_read_card_id+0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      FARG_wiegand26_read_card_id+1, 0 
	MOVWF       FSR1H 
	CLRF        POSTINC1+0 
;wiegand26.h,96 :: 		return true;
	MOVLW       1
	MOVWF       R0 
	GOTO        L_end_wiegand26_read_card
;wiegand26.h,97 :: 		}
L_wiegand26_read_card531:
;wiegand26.h,99 :: 		return false;
	CLRF        R0 
;wiegand26.h,100 :: 		}
L_end_wiegand26_read_card:
	RETURN      0
; end of _wiegand26_read_card

_wiegand26_read_nip:

;wiegand26.h,102 :: 		bool wiegand26_read_nip(int *nip){
;wiegand26.h,105 :: 		if(WIEGAN26_CONT == 32){
	MOVF        TPV_WIEGAN26_CONT+0, 0 
	XORLW       32
	BTFSS       STATUS+0, 2 
	GOTO        L_wiegand26_read_nip542
;wiegand26.h,106 :: 		delay_ms(_WIEGAND26_PULSE_TIME_MAX_MS);  //Para asegurar datos de 26 bits
	MOVLW       17
	MOVWF       R12, 0
	MOVLW       58
	MOVWF       R13, 0
L_wiegand26_read_nip543:
	DECFSZ      R13, 1, 1
	BRA         L_wiegand26_read_nip543
	DECFSZ      R12, 1, 1
	BRA         L_wiegand26_read_nip543
	NOP
;wiegand26.h,108 :: 		if(WIEGAN26_CONT != 32)
	MOVF        TPV_WIEGAN26_CONT+0, 0 
	XORLW       32
	BTFSC       STATUS+0, 2 
	GOTO        L_wiegand26_read_nip544
;wiegand26.h,109 :: 		return false;
	CLRF        R0 
	GOTO        L_end_wiegand26_read_nip
L_wiegand26_read_nip544:
;wiegand26.h,112 :: 		WIEGAN26_BUFFER = WIEGAN26_DATA;
	MOVF        TPV_WIEGAN26_DATA+0, 0 
	MOVWF       TPV_WIEGAN26_BUFFER+0 
	MOVF        TPV_WIEGAN26_DATA+1, 0 
	MOVWF       TPV_WIEGAN26_BUFFER+1 
	MOVF        TPV_WIEGAN26_DATA+2, 0 
	MOVWF       TPV_WIEGAN26_BUFFER+2 
	MOVF        TPV_WIEGAN26_DATA+3, 0 
	MOVWF       TPV_WIEGAN26_BUFFER+3 
;wiegand26.h,114 :: 		WIEGAN26_CONT = 0;    //Resetear puntero
	CLRF        TPV_WIEGAN26_CONT+0 
;wiegand26.h,115 :: 		WIEGAN26_DATA = 0;    //Resetear la informacion
	CLRF        TPV_WIEGAN26_DATA+0 
	CLRF        TPV_WIEGAN26_DATA+1 
	CLRF        TPV_WIEGAN26_DATA+2 
	CLRF        TPV_WIEGAN26_DATA+3 
;wiegand26.h,118 :: 		if(!wiegand26_checkTouch(4))
	MOVLW       4
	MOVWF       FARG_wiegand26_checkTouch_bytes+0 
	CALL        _wiegand26_checkTouch+0, 0
	MOVF        R0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_wiegand26_read_nip545
;wiegand26.h,119 :: 		return false;
	CLRF        R0 
	GOTO        L_end_wiegand26_read_nip
L_wiegand26_read_nip545:
;wiegand26.h,121 :: 		for(i = 0; i < 4; i++){
	CLRF        wiegand26_read_nip_i_L0+0 
L_wiegand26_read_nip546:
	MOVLW       128
	XORWF       wiegand26_read_nip_i_L0+0, 0 
	MOVWF       R0 
	MOVLW       128
	XORLW       4
	SUBWF       R0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_wiegand26_read_nip547
;wiegand26.h,122 :: 		getByte(WIEGAN26_BUFFER,i) &= 0x0F;
	MOVLW       TPV_WIEGAN26_BUFFER+0
	MOVWF       R1 
	MOVLW       hi_addr(TPV_WIEGAN26_BUFFER+0)
	MOVWF       R2 
	MOVF        wiegand26_read_nip_i_L0+0, 0 
	ADDWF       R1, 1 
	MOVLW       0
	BTFSC       wiegand26_read_nip_i_L0+0, 7 
	MOVLW       255
	ADDWFC      R2, 1 
	MOVFF       R1, FSR0
	MOVFF       R2, FSR0H
	MOVLW       15
	ANDWF       POSTINC0+0, 0 
	MOVWF       R0 
	MOVFF       R1, FSR1
	MOVFF       R2, FSR1H
	MOVF        R0, 0 
	MOVWF       POSTINC1+0 
;wiegand26.h,123 :: 		if(getByte(WIEGAN26_BUFFER,i) == 0x0A || getByte(WIEGAN26_BUFFER,i) == 0x0B)
	MOVLW       TPV_WIEGAN26_BUFFER+0
	MOVWF       FSR0 
	MOVLW       hi_addr(TPV_WIEGAN26_BUFFER+0)
	MOVWF       FSR0H 
	MOVF        wiegand26_read_nip_i_L0+0, 0 
	ADDWF       FSR0, 1 
	MOVLW       0
	BTFSC       wiegand26_read_nip_i_L0+0, 7 
	MOVLW       255
	ADDWFC      FSR0H, 1 
	MOVF        POSTINC0+0, 0 
	XORLW       10
	BTFSC       STATUS+0, 2 
	GOTO        L__wiegand26_read_nip1003
	MOVLW       TPV_WIEGAN26_BUFFER+0
	MOVWF       FSR0 
	MOVLW       hi_addr(TPV_WIEGAN26_BUFFER+0)
	MOVWF       FSR0H 
	MOVF        wiegand26_read_nip_i_L0+0, 0 
	ADDWF       FSR0, 1 
	MOVLW       0
	BTFSC       wiegand26_read_nip_i_L0+0, 7 
	MOVLW       255
	ADDWFC      FSR0H, 1 
	MOVF        POSTINC0+0, 0 
	XORLW       11
	BTFSC       STATUS+0, 2 
	GOTO        L__wiegand26_read_nip1003
	GOTO        L_wiegand26_read_nip551
L__wiegand26_read_nip1003:
;wiegand26.h,124 :: 		return false;
	CLRF        R0 
	GOTO        L_end_wiegand26_read_nip
L_wiegand26_read_nip551:
;wiegand26.h,121 :: 		for(i = 0; i < 4; i++){
	INCF        wiegand26_read_nip_i_L0+0, 1 
;wiegand26.h,125 :: 		}
	GOTO        L_wiegand26_read_nip546
L_wiegand26_read_nip547:
;wiegand26.h,127 :: 		*nip = 0;
	MOVFF       FARG_wiegand26_read_nip_nip+0, FSR1
	MOVFF       FARG_wiegand26_read_nip_nip+1, FSR1H
	CLRF        POSTINC1+0 
	CLRF        POSTINC1+0 
;wiegand26.h,128 :: 		for(i = 3; i >= 0; i--){
	MOVLW       3
	MOVWF       wiegand26_read_nip_i_L0+0 
L_wiegand26_read_nip552:
	MOVLW       128
	BTFSC       wiegand26_read_nip_i_L0+0, 7 
	MOVLW       127
	MOVWF       R0 
	MOVLW       128
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__wiegand26_read_nip1351
	MOVLW       0
	SUBWF       wiegand26_read_nip_i_L0+0, 0 
L__wiegand26_read_nip1351:
	BTFSS       STATUS+0, 0 
	GOTO        L_wiegand26_read_nip553
;wiegand26.h,129 :: 		*nip *= 10;
	MOVFF       FARG_wiegand26_read_nip_nip+0, FSR0
	MOVFF       FARG_wiegand26_read_nip_nip+1, FSR0H
	MOVF        POSTINC0+0, 0 
	MOVWF       R0 
	MOVF        POSTINC0+0, 0 
	MOVWF       R1 
	MOVLW       10
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	MOVFF       FARG_wiegand26_read_nip_nip+0, FSR1
	MOVFF       FARG_wiegand26_read_nip_nip+1, FSR1H
	MOVF        R0, 0 
	MOVWF       POSTINC1+0 
	MOVF        R1, 0 
	MOVWF       POSTINC1+0 
;wiegand26.h,130 :: 		*nip += getByte(WIEGAN26_BUFFER,i);
	MOVLW       TPV_WIEGAN26_BUFFER+0
	MOVWF       FSR2 
	MOVLW       hi_addr(TPV_WIEGAN26_BUFFER+0)
	MOVWF       FSR2H 
	MOVF        wiegand26_read_nip_i_L0+0, 0 
	ADDWF       FSR2, 1 
	MOVLW       0
	BTFSC       wiegand26_read_nip_i_L0+0, 7 
	MOVLW       255
	ADDWFC      FSR2H, 1 
	MOVFF       FARG_wiegand26_read_nip_nip+0, FSR0
	MOVFF       FARG_wiegand26_read_nip_nip+1, FSR0H
	MOVF        POSTINC2+0, 0 
	ADDWF       POSTINC0+0, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      POSTINC0+0, 0 
	MOVWF       R1 
	MOVFF       FARG_wiegand26_read_nip_nip+0, FSR1
	MOVFF       FARG_wiegand26_read_nip_nip+1, FSR1H
	MOVF        R0, 0 
	MOVWF       POSTINC1+0 
	MOVF        R1, 0 
	MOVWF       POSTINC1+0 
;wiegand26.h,128 :: 		for(i = 3; i >= 0; i--){
	DECF        wiegand26_read_nip_i_L0+0, 1 
;wiegand26.h,131 :: 		}
	GOTO        L_wiegand26_read_nip552
L_wiegand26_read_nip553:
;wiegand26.h,132 :: 		return true;
	MOVLW       1
	MOVWF       R0 
	GOTO        L_end_wiegand26_read_nip
;wiegand26.h,133 :: 		}
L_wiegand26_read_nip542:
;wiegand26.h,135 :: 		return false;
	CLRF        R0 
;wiegand26.h,136 :: 		}
L_end_wiegand26_read_nip:
	RETURN      0
; end of _wiegand26_read_nip

_wiegand26_enable:

;wiegand26.h,138 :: 		void wiegand26_enable(){
;wiegand26.h,139 :: 		external_int0_enable(true);
	MOVLW       1
	MOVWF       FARG_external_int0_enable_enable+0 
	CALL        _external_int0_enable+0, 0
;wiegand26.h,140 :: 		external_int1_enable(true);
	MOVLW       1
	MOVWF       FARG_external_int1_enable_enable+0 
	CALL        _external_int1_enable+0, 0
;wiegand26.h,141 :: 		}
L_end_wiegand26_enable:
	RETURN      0
; end of _wiegand26_enable

_wiegand26_checkTouch:

;wiegand26.h,143 :: 		bool wiegand26_checkTouch(char bytes){
;wiegand26.h,148 :: 		for(i = 0; i < bytes; i++){
	CLRF        wiegand26_checkTouch_i_L0+0 
L_wiegand26_checkTouch555:
	MOVF        FARG_wiegand26_checkTouch_bytes+0, 0 
	SUBWF       wiegand26_checkTouch_i_L0+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_wiegand26_checkTouch556
;wiegand26.h,149 :: 		nibleL = ~getByte(WIEGAN26_BUFFER,i);
	MOVLW       TPV_WIEGAN26_BUFFER+0
	MOVWF       FSR0 
	MOVLW       hi_addr(TPV_WIEGAN26_BUFFER+0)
	MOVWF       FSR0H 
	MOVF        wiegand26_checkTouch_i_L0+0, 0 
	ADDWF       FSR0, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR0H, 1 
	COMF        POSTINC0+0, 0 
	MOVWF       wiegand26_checkTouch_nibleL_L0+0 
;wiegand26.h,150 :: 		nibleL &= 0x0F;
	MOVLW       15
	ANDWF       wiegand26_checkTouch_nibleL_L0+0, 1 
;wiegand26.h,151 :: 		nibleH = swap(getByte(WIEGAN26_BUFFER,i));
	MOVLW       TPV_WIEGAN26_BUFFER+0
	MOVWF       FSR0 
	MOVLW       hi_addr(TPV_WIEGAN26_BUFFER+0)
	MOVWF       FSR0H 
	MOVF        wiegand26_checkTouch_i_L0+0, 0 
	ADDWF       FSR0, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR0H, 1 
	MOVF        POSTINC0+0, 0 
	MOVWF       FARG_Swap_input+0 
	CALL        _Swap+0, 0
	MOVF        R0, 0 
	MOVWF       wiegand26_checkTouch_nibleH_L0+0 
;wiegand26.h,152 :: 		nibleH &= 0x0F;
	MOVLW       15
	ANDWF       wiegand26_checkTouch_nibleH_L0+0, 1 
;wiegand26.h,154 :: 		if(nibleH != nibleL)
	MOVF        wiegand26_checkTouch_nibleH_L0+0, 0 
	XORWF       wiegand26_checkTouch_nibleL_L0+0, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L_wiegand26_checkTouch558
;wiegand26.h,155 :: 		break;
	GOTO        L_wiegand26_checkTouch556
L_wiegand26_checkTouch558:
;wiegand26.h,148 :: 		for(i = 0; i < bytes; i++){
	INCF        wiegand26_checkTouch_i_L0+0, 1 
;wiegand26.h,156 :: 		}
	GOTO        L_wiegand26_checkTouch555
L_wiegand26_checkTouch556:
;wiegand26.h,159 :: 		if(i == bytes)
	MOVF        wiegand26_checkTouch_i_L0+0, 0 
	XORWF       FARG_wiegand26_checkTouch_bytes+0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L_wiegand26_checkTouch559
;wiegand26.h,160 :: 		return true;
	MOVLW       1
	MOVWF       R0 
	GOTO        L_end_wiegand26_checkTouch
L_wiegand26_checkTouch559:
;wiegand26.h,162 :: 		return false;
	CLRF        R0 
;wiegand26.h,163 :: 		}
L_end_wiegand26_checkTouch:
	RETURN      0
; end of _wiegand26_checkTouch

_int_wiegand26:

;wiegand26.h,165 :: 		void int_wiegand26(){
;wiegand26.h,166 :: 		int_external_int0();
	CALL        _int_external_int0+0, 0
;wiegand26.h,167 :: 		int_external_int1();
	CALL        _int_external_int1+0, 0
;wiegand26.h,168 :: 		}
L_end_int_wiegand26:
	RETURN      0
; end of _int_wiegand26

_int_external_int0:

;wiegand26.h,170 :: 		void int_external_int0(){
;wiegand26.h,171 :: 		if(INTCON.INT0IF && INTCON.INT0IE){
	BTFSS       INTCON+0, 1 
	GOTO        L_int_external_int0563
	BTFSS       INTCON+0, 4 
	GOTO        L_int_external_int0563
L__int_external_int01004:
;wiegand26.h,172 :: 		WIEGAN26_CONT++;
	INCF        TPV_WIEGAN26_CONT+0, 1 
;wiegand26.h,173 :: 		WIEGAN26_DATA <<= 1;
	RLCF        TPV_WIEGAN26_DATA+0, 1 
	BCF         TPV_WIEGAN26_DATA+0, 0 
	RLCF        TPV_WIEGAN26_DATA+1, 1 
	RLCF        TPV_WIEGAN26_DATA+2, 1 
	RLCF        TPV_WIEGAN26_DATA+3, 1 
;wiegand26.h,174 :: 		WIEGAN26_DATA |= 0;
;wiegand26.h,176 :: 		WIEGAND_TEMP = 0;
	CLRF        _WIEGAND_TEMP+0 
	CLRF        _WIEGAND_TEMP+1 
;wiegand26.h,177 :: 		if(WIEGAN26_CONT > WIEGAND_BITS_NIP)
	MOVF        TPV_WIEGAN26_CONT+0, 0 
	SUBLW       32
	BTFSC       STATUS+0, 0 
	GOTO        L_int_external_int0564
;wiegand26.h,178 :: 		WIEGAND_TEMP = WIEGAND_TIME_FRAME_DELTA;
	MOVLW       148
	MOVWF       _WIEGAND_TEMP+0 
	MOVLW       17
	MOVWF       _WIEGAND_TEMP+1 
L_int_external_int0564:
;wiegand26.h,179 :: 		INTCON.INT0IF = 0;
	BCF         INTCON+0, 1 
;wiegand26.h,180 :: 		}
L_int_external_int0563:
;wiegand26.h,181 :: 		}
L_end_int_external_int0:
	RETURN      0
; end of _int_external_int0

_int_external_int1:

;wiegand26.h,183 :: 		void int_external_int1(){
;wiegand26.h,184 :: 		if(INTCON3.INT1IF && INTCON3.INT1IE){
	BTFSS       INTCON3+0, 0 
	GOTO        L_int_external_int1567
	BTFSS       INTCON3+0, 3 
	GOTO        L_int_external_int1567
L__int_external_int11005:
;wiegand26.h,185 :: 		WIEGAN26_CONT++;
	INCF        TPV_WIEGAN26_CONT+0, 1 
;wiegand26.h,186 :: 		WIEGAN26_DATA <<= 1;
	RLCF        TPV_WIEGAN26_DATA+0, 1 
	BCF         TPV_WIEGAN26_DATA+0, 0 
	RLCF        TPV_WIEGAN26_DATA+1, 1 
	RLCF        TPV_WIEGAN26_DATA+2, 1 
	RLCF        TPV_WIEGAN26_DATA+3, 1 
;wiegand26.h,187 :: 		WIEGAN26_DATA |= 1;
	BSF         TPV_WIEGAN26_DATA+0, 0 
;wiegand26.h,189 :: 		WIEGAND_TEMP = 0;
	CLRF        _WIEGAND_TEMP+0 
	CLRF        _WIEGAND_TEMP+1 
;wiegand26.h,190 :: 		if(WIEGAN26_CONT > WIEGAND_BITS_NIP)
	MOVF        TPV_WIEGAN26_CONT+0, 0 
	SUBLW       32
	BTFSC       STATUS+0, 0 
	GOTO        L_int_external_int1568
;wiegand26.h,191 :: 		WIEGAND_TEMP = WIEGAND_TIME_FRAME_DELTA;
	MOVLW       148
	MOVWF       _WIEGAND_TEMP+0 
	MOVLW       17
	MOVWF       _WIEGAND_TEMP+1 
L_int_external_int1568:
;wiegand26.h,192 :: 		INTCON3.INT1IF = 0;
	BCF         INTCON3+0, 0 
;wiegand26.h,193 :: 		}
L_int_external_int1567:
;wiegand26.h,194 :: 		}
L_end_int_external_int1:
	RETURN      0
; end of _int_external_int1

_int_timer2:

;wiegand26.h,196 :: 		void int_timer2(){
;wiegand26.h,197 :: 		if(PIR1.TMR2IF && PIE1.TMR2IE){
	BTFSS       PIR1+0, 1 
	GOTO        L_int_timer2571
	BTFSS       PIE1+0, 1 
	GOTO        L_int_timer2571
L__int_timer21006:
;wiegand26.h,199 :: 		WIEGAND_TEMP += 5;  //Cada 5ms
	MOVLW       5
	ADDWF       _WIEGAND_TEMP+0, 1 
	MOVLW       0
	ADDWFC      _WIEGAND_TEMP+1, 1 
;wiegand26.h,200 :: 		if(WIEGAND_TEMP >= WIEGAND_TIME_FRAME_RESET){
	MOVLW       19
	SUBWF       _WIEGAND_TEMP+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__int_timer21358
	MOVLW       136
	SUBWF       _WIEGAND_TEMP+0, 0 
L__int_timer21358:
	BTFSS       STATUS+0, 0 
	GOTO        L_int_timer2572
;wiegand26.h,201 :: 		WIEGAND_TEMP = 0;
	CLRF        _WIEGAND_TEMP+0 
	CLRF        _WIEGAND_TEMP+1 
;wiegand26.h,203 :: 		if(WIEGAN26_CONT){
	MOVF        TPV_WIEGAN26_CONT+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_int_timer2573
;wiegand26.h,204 :: 		if(!(WIEGAN26_CONT == WIEGAND_BITS_CARD || WIEGAN26_CONT == WIEGAND_BITS_NIP)){
	MOVF        TPV_WIEGAN26_CONT+0, 0 
	XORLW       26
	BTFSC       STATUS+0, 2 
	GOTO        L_int_timer2575
	MOVF        TPV_WIEGAN26_CONT+0, 0 
	XORLW       32
	BTFSC       STATUS+0, 2 
	GOTO        L_int_timer2575
	CLRF        R0 
	GOTO        L_int_timer2574
L_int_timer2575:
	MOVLW       1
	MOVWF       R0 
L_int_timer2574:
	MOVF        R0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_int_timer2576
;wiegand26.h,205 :: 		WIEGAN26_CONT = 0;
	CLRF        TPV_WIEGAN26_CONT+0 
;wiegand26.h,206 :: 		WIEGAN26_DATA = 0;
	CLRF        TPV_WIEGAN26_DATA+0 
	CLRF        TPV_WIEGAN26_DATA+1 
	CLRF        TPV_WIEGAN26_DATA+2 
	CLRF        TPV_WIEGAN26_DATA+3 
;wiegand26.h,207 :: 		}
L_int_timer2576:
;wiegand26.h,208 :: 		}
L_int_timer2573:
;wiegand26.h,209 :: 		}
L_int_timer2572:
;wiegand26.h,211 :: 		PIR1.TMR2IF = 0;   //LIMPÍAR BANDERA
	BCF         PIR1+0, 1 
;wiegand26.h,212 :: 		}
L_int_timer2571:
;wiegand26.h,213 :: 		}
L_end_int_timer2:
	RETURN      0
; end of _int_timer2

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
	GOTO        L_spi_tcp_read577
;spi_tcp.h,33 :: 		reg = SPI1_read(0);   //Comando MII ó MAC
	CLRF        FARG_SPI1_Read_buffer+0 
	CALL        _SPI1_Read+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_spi_tcp_read_reg+0 
L_spi_tcp_read577:
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
L_spi_tcp_read_phy578:
	DECFSZ      R13, 1, 1
	BRA         L_spi_tcp_read_phy578
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
L_spi_tcp_read_phy579:
	MOVLW       10
	MOVWF       FARG_spi_tcp_read_reg+0 
	CLRF        FARG_spi_tcp_read_reg_eth+0 
	CALL        _spi_tcp_read+0, 0
	BTFSS       R0, 0 
	GOTO        L_spi_tcp_read_phy580
	GOTO        L_spi_tcp_read_phy579
L_spi_tcp_read_phy580:
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

_main:

;TPV.c,309 :: 		void main(){
;TPV.c,311 :: 		pic_init();
	CALL        _pic_init+0, 0
;TPV.c,313 :: 		while(true){
L_main581:
;TPV.c,315 :: 		Net_Ethernet_28j60_doPacket();  //Verifica envio y recepcion tcp
	CALL        _Net_Ethernet_28j60_doPacket+0, 0
;TPV.c,316 :: 		can_do_work();                  //Verifica envio y recepcion can
	CALL        _can_do_work+0, 0
;TPV.c,317 :: 		usart_do_read_text();           //Verifica si hay datos en buffer
	CALL        _usart_do_read_text+0, 0
;TPV.c,319 :: 		tpv_temporizadores();           //Incrementa los contadores y verifica conexiones
	CALL        _tpv_temporizadores+0, 0
;TPV.c,320 :: 		tpv_pushBuffer();               //Empuja en el buffer del enc28j60
	CALL        _tpv_pushBuffer+0, 0
;TPV.c,321 :: 		tpv_reconexion();               //Reconecta el modulo si sufrio desconexion
	CALL        _tpv_reconexion+0, 0
;TPV.c,322 :: 		tpv_buffer_tcp();               //Vacia buffer tcp
	CALL        _tpv_buffer_tcp+0, 0
;TPV.c,323 :: 		tpv_buffer_can();               //Vacia buffer can
	CALL        _tpv_buffer_can+0, 0
;TPV.c,324 :: 		}
	GOTO        L_main581
;TPV.c,325 :: 		}
L_end_main:
	GOTO        $+0
; end of _main

_interrupt:

;TPV.c,327 :: 		void interrupt(){
;TPV.c,328 :: 		int_wiegand26();
	CALL        _int_wiegand26+0, 0
;TPV.c,329 :: 		int_usart_rx();
	CALL        _int_usart_rx+0, 0
;TPV.c,330 :: 		}
L_end_interrupt:
L__interrupt1365:
	RETFIE      1
; end of _interrupt

_interrupt_low:
	MOVWF       ___Low_saveWREG+0 
	MOVF        STATUS+0, 0 
	MOVWF       ___Low_saveSTATUS+0 
	MOVF        BSR+0, 0 
	MOVWF       ___Low_saveBSR+0 

;TPV.c,332 :: 		void interrupt_low(){
;TPV.c,333 :: 		int_timer1();
	CALL        _int_timer1+0, 0
;TPV.c,334 :: 		int_timer2();
	CALL        _int_timer2+0, 0
;TPV.c,335 :: 		int_timer3();
	CALL        _int_timer3+0, 0
;TPV.c,336 :: 		int_can();
	CALL        _int_can+0, 0
;TPV.c,337 :: 		}
L_end_interrupt_low:
L__interrupt_low1367:
	MOVF        ___Low_saveBSR+0, 0 
	MOVWF       BSR+0 
	MOVF        ___Low_saveSTATUS+0, 0 
	MOVWF       STATUS+0 
	SWAPF       ___Low_saveWREG+0, 1 
	SWAPF       ___Low_saveWREG+0, 0 
	RETFIE      0
; end of _interrupt_low

_pic_init:

;TPV.c,341 :: 		void pic_init(){
;TPV.c,344 :: 		OSCCON = 0x40;  //Oscilador externo
	MOVLW       64
	MOVWF       OSCCON+0 
;TPV.c,347 :: 		ADCON1 = 0x0F;  //Todos digitales
	MOVLW       15
	MOVWF       ADCON1+0 
;TPV.c,348 :: 		CMCON = 0x07;   //Apagar los comparadores
	MOVLW       7
	MOVWF       CMCON+0 
;TPV.c,351 :: 		SENSOR_COCHED = 1;
	BSF         TRISD+0, 0 
;TPV.c,352 :: 		BOTON_IMPRIMIRD = 1;
	BSF         TRISD+0, 1 
;TPV.c,353 :: 		LED_LINKD = 0;
	BCF         TRISC+0, 2 
;TPV.c,354 :: 		SALIDA_RELE1D = 0;
	BCF         TRISA+0, 5 
;TPV.c,355 :: 		SALIDA_RELE2D = 0;
	BCF         TRISE+0, 0 
;TPV.c,356 :: 		SALIDA_RELE3D = 0;
	BCF         TRISD+0, 2 
;TPV.c,357 :: 		SALIDA_RELE4D = 0;
	BCF         TRISD+0, 3 
;TPV.c,358 :: 		SALIDA_RELE5D = 0;
	BCF         TRISD+0, 7 
;TPV.c,360 :: 		SALIDA_RELE1 = 0;
	BCF         PORTA+0, 5 
;TPV.c,361 :: 		SALIDA_RELE2 = 0;
	BCF         PORTE+0, 0 
;TPV.c,362 :: 		SALIDA_RELE3 = 0;
	BCF         PORTD+0, 2 
;TPV.c,363 :: 		SALIDA_RELE4 = 0;
	BCF         PORTD+0, 3 
;TPV.c,364 :: 		SALIDA_RELE5 = 0;
	BCF         PORTD+0, 7 
;TPV.c,365 :: 		LED_LINK = 0;
	BCF         PORTC+0, 2 
;TPV.c,370 :: 		if(!RCON.POR){
	BTFSC       RCON+0, 1 
	GOTO        L_pic_init583
;TPV.c,371 :: 		RCON.POR = 1;  //Reset bit
	BSF         RCON+0, 1 
;TPV.c,372 :: 		RCON.TO_ = 1;
	BSF         RCON+0, 3 
;TPV.c,373 :: 		RCON.PD = 1;
	BSF         RCON+0, 2 
;TPV.c,374 :: 		}
L_pic_init583:
;TPV.c,377 :: 		timer1_open(200e3, false, true, false);
	MOVLW       64
	MOVWF       FARG_timer1_open_time_us+0 
	MOVLW       13
	MOVWF       FARG_timer1_open_time_us+1 
	MOVLW       3
	MOVWF       FARG_timer1_open_time_us+2 
	MOVLW       0
	MOVWF       FARG_timer1_open_time_us+3 
	CLRF        FARG_timer1_open_powerOn+0 
	MOVLW       1
	MOVWF       FARG_timer1_open_enable+0 
	CLRF        FARG_timer1_open_priorityHigh+0 
	CALL        _timer1_open+0, 0
;TPV.c,378 :: 		timer3_open(200e3, true, true, false);
	MOVLW       64
	MOVWF       FARG_timer3_open_time_us+0 
	MOVLW       13
	MOVWF       FARG_timer3_open_time_us+1 
	MOVLW       3
	MOVWF       FARG_timer3_open_time_us+2 
	MOVLW       0
	MOVWF       FARG_timer3_open_time_us+3 
	MOVLW       1
	MOVWF       FARG_timer3_open_powerOn+0 
	MOVLW       1
	MOVWF       FARG_timer3_open_enable+0 
	CLRF        FARG_timer3_open_priorityHigh+0 
	CALL        _timer3_open+0, 0
;TPV.c,379 :: 		usart_open(baudiosRate);
	MOVLW       128
	MOVWF       FARG_usart_open_baudRate+0 
	MOVLW       37
	MOVWF       FARG_usart_open_baudRate+1 
	MOVLW       0
	MOVWF       FARG_usart_open_baudRate+2 
	MOVLW       0
	MOVWF       FARG_usart_open_baudRate+3 
	CALL        _usart_open+0, 0
;TPV.c,380 :: 		usart_enable_rx(true, true, 0x0D);
	MOVLW       1
	MOVWF       FARG_usart_enable_rx_enable+0 
	MOVLW       1
	MOVWF       FARG_usart_enable_rx_priorityHigh+0 
	MOVLW       13
	MOVWF       FARG_usart_enable_rx_delimitir+0 
	CALL        _usart_enable_rx+0, 0
;TPV.c,382 :: 		DS1307_open();
	CALL        _DS1307_open+0, 0
;TPV.c,383 :: 		lcd_init();
	CALL        _Lcd_Init+0, 0
;TPV.c,384 :: 		lcd_cmd(_LCD_CURSOR_OFF);
	MOVLW       12
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;TPV.c,385 :: 		lcd_cmd(_LCD_CLEAR);
	MOVLW       1
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;TPV.c,386 :: 		mysql_init(32768);
	MOVLW       0
	MOVWF       FARG_mysql_init_memoryMax+0 
	MOVLW       128
	MOVWF       FARG_mysql_init_memoryMax+1 
	CALL        _mysql_init+0, 0
;TPV.c,387 :: 		wiegand26_open();
	CALL        _wiegand26_open+0, 0
;TPV.c,388 :: 		wtd_enable(true);
	MOVLW       1
	MOVWF       FARG_wtd_enable_enable+0 
	CALL        _wtd_enable+0, 0
;TPV.c,389 :: 		can_open(canIp, canMask, canId, 4);
	MOVF        _canIp+0, 0 
	MOVWF       FARG_can_open_ip+0 
	MOVF        _canIp+1, 0 
	MOVWF       FARG_can_open_ip+1 
	MOVF        _canIp+2, 0 
	MOVWF       FARG_can_open_ip+2 
	MOVF        _canIp+3, 0 
	MOVWF       FARG_can_open_ip+3 
	MOVF        _canMask+0, 0 
	MOVWF       FARG_can_open_mask+0 
	MOVF        _canMask+1, 0 
	MOVWF       FARG_can_open_mask+1 
	MOVF        _canMask+2, 0 
	MOVWF       FARG_can_open_mask+2 
	MOVF        _canMask+3, 0 
	MOVWF       FARG_can_open_mask+3 
	CLRF        FARG_can_open_id+0 
	MOVLW       4
	MOVWF       FARG_can_open_speed_us+0 
	CALL        _can_open+0, 0
;TPV.c,390 :: 		wtd_enable(false);
	CLRF        FARG_wtd_enable_enable+0 
	CALL        _wtd_enable+0, 0
;TPV.c,391 :: 		can_interrupt(true, false);
	MOVLW       1
	MOVWF       FARG_can_interrupt_enable+0 
	CLRF        FARG_can_interrupt_hihgPriprity+0 
	CALL        _can_interrupt+0, 0
;TPV.c,392 :: 		SPI1_Init();                                         //Initialize SPI modulo
	CALL        _SPI1_Init+0, 0
;TPV.c,393 :: 		Net_Ethernet_28j60_Init(myMacAddr, myIpAddr, 0x01);  //Full duplex
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
;TPV.c,394 :: 		Net_Ethernet_28j60_confNetwork(ipMask, gwIpAddr, dnsIpAddr);
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
;TPV.c,395 :: 		Net_Ethernet_28j60_stackInitTCP();
	CALL        _Net_Ethernet_28j60_stackInitTCP+0, 0
;TPV.c,398 :: 		wiegand26_enable();
	CALL        _wiegand26_enable+0, 0
;TPV.c,399 :: 		DS1307_Read(&myRTC, true);
	MOVLW       _myRTC+0
	MOVWF       FARG_DS1307_read_myDS+0 
	MOVLW       hi_addr(_myRTC+0)
	MOVWF       FARG_DS1307_read_myDS+1 
	MOVLW       1
	MOVWF       FARG_DS1307_read_formatComplet+0 
	CALL        _DS1307_read+0, 0
;TPV.c,400 :: 		tarjetas.canTemp = MAX_TIME_CHECK_MOD;
	MOVLW       20
	MOVWF       _tarjetas+63 
	MOVLW       0
	MOVWF       _tarjetas+64 
;TPV.c,402 :: 		pilaBufferCAN = mysql_count_forced(tableEventosCAN, eventosEstatus, '1');
	MOVLW       _tableEventosCAN+0
	MOVWF       FARG_mysql_count_forced_tabla+0 
	MOVLW       hi_addr(_tableEventosCAN+0)
	MOVWF       FARG_mysql_count_forced_tabla+1 
	MOVLW       _eventosEstatus+0
	MOVWF       FARG_mysql_count_forced_columna+0 
	MOVLW       hi_addr(_eventosEstatus+0)
	MOVWF       FARG_mysql_count_forced_columna+1 
	MOVLW       49
	MOVWF       FARG_mysql_count_forced_buscar+0 
	MOVLW       0
	MOVWF       FARG_mysql_count_forced_buscar+1 
	MOVWF       FARG_mysql_count_forced_buscar+2 
	MOVWF       FARG_mysql_count_forced_buscar+3 
	CALL        _mysql_count_forced+0, 0
	MOVF        R0, 0 
	MOVWF       _pilaBufferCAN+0 
	MOVF        R1, 0 
	MOVWF       _pilaBufferCAN+1 
;TPV.c,403 :: 		pilaBufferTCP = mysql_count_forced(tableEventosTCP, eventosEstatus, '1');
	MOVLW       _tableEventosTCP+0
	MOVWF       FARG_mysql_count_forced_tabla+0 
	MOVLW       hi_addr(_tableEventosTCP+0)
	MOVWF       FARG_mysql_count_forced_tabla+1 
	MOVLW       _eventosEstatus+0
	MOVWF       FARG_mysql_count_forced_columna+0 
	MOVLW       hi_addr(_eventosEstatus+0)
	MOVWF       FARG_mysql_count_forced_columna+1 
	MOVLW       49
	MOVWF       FARG_mysql_count_forced_buscar+0 
	MOVLW       0
	MOVWF       FARG_mysql_count_forced_buscar+1 
	MOVWF       FARG_mysql_count_forced_buscar+2 
	MOVWF       FARG_mysql_count_forced_buscar+3 
	CALL        _mysql_count_forced+0, 0
	MOVF        R0, 0 
	MOVWF       _pilaBufferTCP+0 
	MOVF        R1, 0 
	MOVWF       _pilaBufferTCP+1 
;TPV.c,404 :: 		usart_write_text("Pila TCP: ");
	MOVLW       ?lstr1_TPV+0
	MOVWF       FARG_usart_write_text_texto+0 
	MOVLW       hi_addr(?lstr1_TPV+0)
	MOVWF       FARG_usart_write_text_texto+1 
	CALL        _usart_write_text+0, 0
;TPV.c,405 :: 		inttostr(pilaBufferTCP, msjConst);
	MOVF        _pilaBufferTCP+0, 0 
	MOVWF       FARG_IntToStr_input+0 
	MOVF        _pilaBufferTCP+1, 0 
	MOVWF       FARG_IntToStr_input+1 
	MOVLW       _msjConst+0
	MOVWF       FARG_IntToStr_output+0 
	MOVLW       hi_addr(_msjConst+0)
	MOVWF       FARG_IntToStr_output+1 
	CALL        _IntToStr+0, 0
;TPV.c,406 :: 		usart_write_line(msjConst);
	MOVLW       _msjConst+0
	MOVWF       FARG_usart_write_line_texto+0 
	MOVLW       hi_addr(_msjConst+0)
	MOVWF       FARG_usart_write_line_texto+1 
	CALL        _usart_write_line+0, 0
;TPV.c,407 :: 		usart_write_text("Pila CAN: ");
	MOVLW       ?lstr2_TPV+0
	MOVWF       FARG_usart_write_text_texto+0 
	MOVLW       hi_addr(?lstr2_TPV+0)
	MOVWF       FARG_usart_write_text_texto+1 
	CALL        _usart_write_text+0, 0
;TPV.c,408 :: 		inttostr(pilaBufferCAN, msjConst);
	MOVF        _pilaBufferCAN+0, 0 
	MOVWF       FARG_IntToStr_input+0 
	MOVF        _pilaBufferCAN+1, 0 
	MOVWF       FARG_IntToStr_input+1 
	MOVLW       _msjConst+0
	MOVWF       FARG_IntToStr_output+0 
	MOVLW       hi_addr(_msjConst+0)
	MOVWF       FARG_IntToStr_output+1 
	CALL        _IntToStr+0, 0
;TPV.c,409 :: 		usart_write_line(msjConst);
	MOVLW       _msjConst+0
	MOVWF       FARG_usart_write_line_texto+0 
	MOVLW       hi_addr(_msjConst+0)
	MOVWF       FARG_usart_write_line_texto+1 
	CALL        _usart_write_line+0, 0
;TPV.c,412 :: 		mysql_read(tableFolio, folioTotal, 1, &folio);
	MOVLW       _tableFolio+0
	MOVWF       FARG_mysql_read_name+0 
	MOVLW       hi_addr(_tableFolio+0)
	MOVWF       FARG_mysql_read_name+1 
	MOVLW       _folioTotal+0
	MOVWF       FARG_mysql_read_column+0 
	MOVLW       hi_addr(_folioTotal+0)
	MOVWF       FARG_mysql_read_column+1 
	MOVLW       1
	MOVWF       FARG_mysql_read_fila+0 
	MOVLW       0
	MOVWF       FARG_mysql_read_fila+1 
	MOVLW       _folio+0
	MOVWF       FARG_mysql_read_result+0 
	MOVLW       hi_addr(_folio+0)
	MOVWF       FARG_mysql_read_result+1 
	CALL        _mysql_read+0, 0
;TPV.c,413 :: 		mysql_read_string(tableCupo, columnaEstado, 1, &cupoLleno);
	MOVLW       _tableCupo+0
	MOVWF       FARG_mysql_read_string_name+0 
	MOVLW       hi_addr(_tableCupo+0)
	MOVWF       FARG_mysql_read_string_name+1 
	MOVLW       _columnaEstado+0
	MOVWF       FARG_mysql_read_string_column+0 
	MOVLW       hi_addr(_columnaEstado+0)
	MOVWF       FARG_mysql_read_string_column+1 
	MOVLW       1
	MOVWF       FARG_mysql_read_string_fila+0 
	MOVLW       0
	MOVWF       FARG_mysql_read_string_fila+1 
	MOVLW       _cupoLleno+0
	MOVWF       FARG_mysql_read_string_result+0 
	MOVLW       hi_addr(_cupoLleno+0)
	MOVWF       FARG_mysql_read_string_result+1 
	CALL        _mysql_read_string+0, 0
;TPV.c,414 :: 		mysql_read_string(tableSyncronia, columnaEstado, 1, &canSynchrony);
	MOVLW       _tableSyncronia+0
	MOVWF       FARG_mysql_read_string_name+0 
	MOVLW       hi_addr(_tableSyncronia+0)
	MOVWF       FARG_mysql_read_string_name+1 
	MOVLW       _columnaEstado+0
	MOVWF       FARG_mysql_read_string_column+0 
	MOVLW       hi_addr(_columnaEstado+0)
	MOVWF       FARG_mysql_read_string_column+1 
	MOVLW       1
	MOVWF       FARG_mysql_read_string_fila+0 
	MOVLW       0
	MOVWF       FARG_mysql_read_string_fila+1 
	MOVLW       _canSynchrony+0
	MOVWF       FARG_mysql_read_string_result+0 
	MOVLW       hi_addr(_canSynchrony+0)
	MOVWF       FARG_mysql_read_string_result+1 
	CALL        _mysql_read_string+0, 0
;TPV.c,417 :: 		tarjetas.synchrony = true;
	MOVLW       1
	MOVWF       _tarjetas+0 
;TPV.c,418 :: 		if(mysql_exist(tableNodos)){
	MOVLW       _tableNodos+0
	MOVWF       FARG_mysql_exist_name+0 
	MOVLW       hi_addr(_tableNodos+0)
	MOVWF       FARG_mysql_exist_name+1 
	CALL        _mysql_exist+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_pic_init584
;TPV.c,419 :: 		tarjetas.modulos = myTable.rowAct;
	MOVF        TPV_myTable+4, 0 
	MOVWF       _tarjetas+1 
;TPV.c,420 :: 		for(cont = 0; cont < tarjetas.modulos; cont++){
	CLRF        pic_init_cont_L0+0 
L_pic_init585:
	MOVF        _tarjetas+1, 0 
	SUBWF       pic_init_cont_L0+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_pic_init586
;TPV.c,421 :: 		tarjetas.canState[cont] = false;    //Conexion supuesta
	MOVLW       _tarjetas+2
	MOVWF       FSR1 
	MOVLW       hi_addr(_tarjetas+2)
	MOVWF       FSR1H 
	MOVF        pic_init_cont_L0+0, 0 
	ADDWF       FSR1, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR1H, 1 
	CLRF        POSTINC1+0 
;TPV.c,422 :: 		tarjetas.canIdReport[cont] = true;  //Supone conexion conectada
	MOVLW       _tarjetas+22
	MOVWF       FSR1 
	MOVLW       hi_addr(_tarjetas+22)
	MOVWF       FSR1H 
	MOVF        pic_init_cont_L0+0, 0 
	ADDWF       FSR1, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR1H, 1 
	MOVLW       1
	MOVWF       POSTINC1+0 
;TPV.c,423 :: 		mysql_read_string(tableNodos, nodosName, cont+1, &tarjetas.canIdMod[cont]);
	MOVLW       _tableNodos+0
	MOVWF       FARG_mysql_read_string_name+0 
	MOVLW       hi_addr(_tableNodos+0)
	MOVWF       FARG_mysql_read_string_name+1 
	MOVLW       _nodosName+0
	MOVWF       FARG_mysql_read_string_column+0 
	MOVLW       hi_addr(_nodosName+0)
	MOVWF       FARG_mysql_read_string_column+1 
	MOVF        pic_init_cont_L0+0, 0 
	ADDLW       1
	MOVWF       FARG_mysql_read_string_fila+0 
	CLRF        FARG_mysql_read_string_fila+1 
	MOVLW       0
	ADDWFC      FARG_mysql_read_string_fila+1, 1 
	MOVLW       _tarjetas+42
	MOVWF       FARG_mysql_read_string_result+0 
	MOVLW       hi_addr(_tarjetas+42)
	MOVWF       FARG_mysql_read_string_result+1 
	MOVF        pic_init_cont_L0+0, 0 
	ADDWF       FARG_mysql_read_string_result+0, 1 
	BTFSC       STATUS+0, 0 
	INCF        FARG_mysql_read_string_result+1, 1 
	CALL        _mysql_read_string+0, 0
;TPV.c,420 :: 		for(cont = 0; cont < tarjetas.modulos; cont++){
	INCF        pic_init_cont_L0+0, 1 
;TPV.c,424 :: 		}
	GOTO        L_pic_init585
L_pic_init586:
;TPV.c,425 :: 		tarjetas.canIdMod[cont] = 0;  //Final de cadena anexado
	MOVLW       _tarjetas+42
	MOVWF       FSR1 
	MOVLW       hi_addr(_tarjetas+42)
	MOVWF       FSR1H 
	MOVF        pic_init_cont_L0+0, 0 
	ADDWF       FSR1, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR1H, 1 
	CLRF        POSTINC1+0 
;TPV.c,426 :: 		}
L_pic_init584:
;TPV.c,427 :: 		numToString(tarjetas.modulos, msjConst, 3);
	MOVF        _tarjetas+1, 0 
	MOVWF       FARG_numToString_valor+0 
	MOVLW       0
	MOVWF       FARG_numToString_valor+1 
	MOVWF       FARG_numToString_valor+2 
	MOVWF       FARG_numToString_valor+3 
	MOVLW       _msjConst+0
	MOVWF       FARG_numToString_cadena+0 
	MOVLW       hi_addr(_msjConst+0)
	MOVWF       FARG_numToString_cadena+1 
	MOVLW       3
	MOVWF       FARG_numToString_digitos+0 
	CALL        _numToString+0, 0
;TPV.c,428 :: 		usart_write_text("Nodos: ");
	MOVLW       ?lstr3_TPV+0
	MOVWF       FARG_usart_write_text_texto+0 
	MOVLW       hi_addr(?lstr3_TPV+0)
	MOVWF       FARG_usart_write_text_texto+1 
	CALL        _usart_write_text+0, 0
;TPV.c,429 :: 		usart_write_line(msjConst);
	MOVLW       _msjConst+0
	MOVWF       FARG_usart_write_line_texto+0 
	MOVLW       hi_addr(_msjConst+0)
	MOVWF       FARG_usart_write_line_texto+1 
	CALL        _usart_write_line+0, 0
;TPV.c,432 :: 		RCON.IPEN = 1;     //ACTIVAR NIVELES DE INTERRUPCION
	BSF         RCON+0, 7 
;TPV.c,433 :: 		INTCON.PEIE = 1;   //ACTIVAR INTERRUPCIONES PERIFERICAS
	BSF         INTCON+0, 6 
;TPV.c,434 :: 		INTCON.GIE = 1;    //ACTIVAR INTERRUPCIONES GLOBALES
	BSF         INTCON+0, 7 
;TPV.c,553 :: 		Net_Ethernet_28j60_connectTCP(ipAddr, portServer, myPort, &sock1);
	MOVLW       _ipAddr+0
	MOVWF       FARG_Net_Ethernet_28j60_connectTCP_remoteIP+0 
	MOVLW       hi_addr(_ipAddr+0)
	MOVWF       FARG_Net_Ethernet_28j60_connectTCP_remoteIP+1 
	MOVF        _portServer+0, 0 
	MOVWF       FARG_Net_Ethernet_28j60_connectTCP_remote_port+0 
	MOVF        _portServer+1, 0 
	MOVWF       FARG_Net_Ethernet_28j60_connectTCP_remote_port+1 
	MOVF        _myPort+0, 0 
	MOVWF       FARG_Net_Ethernet_28j60_connectTCP_my_port+0 
	MOVF        _myPort+1, 0 
	MOVWF       FARG_Net_Ethernet_28j60_connectTCP_my_port+1 
	MOVLW       _sock1+0
	MOVWF       FARG_Net_Ethernet_28j60_connectTCP_used_socket+0 
	MOVLW       hi_addr(_sock1+0)
	MOVWF       FARG_Net_Ethernet_28j60_connectTCP_used_socket+1 
	CALL        _Net_Ethernet_28j60_connectTCP+0, 0
;TPV.c,554 :: 		isConectTCP = spi_tcp_linked();       //Cable conectado
	CALL        _spi_tcp_linked+0, 0
	MOVF        R0, 0 
	MOVWF       _isConectTCP+0 
;TPV.c,555 :: 		isConectServer = sock1->state == 3;
	MOVLW       37
	ADDWF       _sock1+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      _sock1+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	XORLW       3
	MOVLW       1
	BTFSS       STATUS+0, 2 
	MOVLW       0
	MOVWF       _isConectServer+0 
;TPV.c,556 :: 		usart_write_line("Parking");
	MOVLW       ?lstr4_TPV+0
	MOVWF       FARG_usart_write_line_texto+0 
	MOVLW       hi_addr(?lstr4_TPV+0)
	MOVWF       FARG_usart_write_line_texto+1 
	CALL        _usart_write_line+0, 0
;TPV.c,557 :: 		usart_write_line(isConectTCP? "Cable":"Desconectado");
	MOVF        _isConectTCP+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_pic_init588
	MOVLW       ?lstr5_TPV+0
	MOVWF       ?FLOC___pic_initT2516+0 
	MOVLW       hi_addr(?lstr5_TPV+0)
	MOVWF       ?FLOC___pic_initT2516+1 
	GOTO        L_pic_init589
L_pic_init588:
	MOVLW       ?lstr6_TPV+0
	MOVWF       ?FLOC___pic_initT2516+0 
	MOVLW       hi_addr(?lstr6_TPV+0)
	MOVWF       ?FLOC___pic_initT2516+1 
L_pic_init589:
	MOVF        ?FLOC___pic_initT2516+0, 0 
	MOVWF       FARG_usart_write_line_texto+0 
	MOVF        ?FLOC___pic_initT2516+1, 0 
	MOVWF       FARG_usart_write_line_texto+1 
	CALL        _usart_write_line+0, 0
;TPV.c,558 :: 		usart_write_line(isConectServer? "Online":"Offline");
	MOVF        _isConectServer+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_pic_init590
	MOVLW       ?lstr7_TPV+0
	MOVWF       ?FLOC___pic_initT2519+0 
	MOVLW       hi_addr(?lstr7_TPV+0)
	MOVWF       ?FLOC___pic_initT2519+1 
	GOTO        L_pic_init591
L_pic_init590:
	MOVLW       ?lstr8_TPV+0
	MOVWF       ?FLOC___pic_initT2519+0 
	MOVLW       hi_addr(?lstr8_TPV+0)
	MOVWF       ?FLOC___pic_initT2519+1 
L_pic_init591:
	MOVF        ?FLOC___pic_initT2519+0, 0 
	MOVWF       FARG_usart_write_line_texto+0 
	MOVF        ?FLOC___pic_initT2519+1, 0 
	MOVWF       FARG_usart_write_line_texto+1 
	CALL        _usart_write_line+0, 0
;TPV.c,574 :: 		delay_ms(timeAwake);
	MOVLW       4
	MOVWF       R11, 0
	MOVLW       207
	MOVWF       R12, 0
	MOVLW       1
	MOVWF       R13, 0
L_pic_init592:
	DECFSZ      R13, 1, 1
	BRA         L_pic_init592
	DECFSZ      R12, 1, 1
	BRA         L_pic_init592
	DECFSZ      R11, 1, 1
	BRA         L_pic_init592
	NOP
	NOP
;TPV.c,575 :: 		lcd_out(1, 1, "TPV");
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr9_TPV+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr9_TPV+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;TPV.c,576 :: 		string_cpy(bufferEeprom, "INIRST");
	MOVLW       _bufferEeprom+0
	MOVWF       FARG_string_cpy_destino+0 
	MOVLW       hi_addr(_bufferEeprom+0)
	MOVWF       FARG_string_cpy_destino+1 
	MOVLW       ?lstr10_TPV+0
	MOVWF       FARG_string_cpy_origen+0 
	MOVLW       hi_addr(?lstr10_TPV+0)
	MOVWF       FARG_string_cpy_origen+1 
	CALL        _string_cpy+0, 0
;TPV.c,577 :: 		buffer_save_send(true, bufferEeprom, tarjetas.canIdMod);
	MOVLW       1
	MOVWF       FARG_buffer_save_send_tcpORcan+0 
	MOVLW       _bufferEeprom+0
	MOVWF       FARG_buffer_save_send_buffer+0 
	MOVLW       hi_addr(_bufferEeprom+0)
	MOVWF       FARG_buffer_save_send_buffer+1 
	MOVLW       _tarjetas+42
	MOVWF       FARG_buffer_save_send_nodosCAN+0 
	MOVLW       hi_addr(_tarjetas+42)
	MOVWF       FARG_buffer_save_send_nodosCAN+1 
	CALL        _buffer_save_send+0, 0
;TPV.c,578 :: 		}
L_end_pic_init:
	RETURN      0
; end of _pic_init

_tpv_pushBuffer:

;TPV.c,580 :: 		void tpv_pushBuffer(){
;TPV.c,585 :: 		if(isConectServer && isConectTCP && !isEmptyBuffer){
	MOVF        _isConectServer+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_tpv_pushBuffer595
	MOVF        _isConectTCP+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_tpv_pushBuffer595
	MOVF        _isEmptyBuffer+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_tpv_pushBuffer595
L__tpv_pushBuffer1007:
;TPV.c,587 :: 		if(!pushBuffer){
	MOVF        tpv_pushBuffer_pushBuffer_L0+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_tpv_pushBuffer596
;TPV.c,588 :: 		pushBuffer = true;
	MOVLW       1
	MOVWF       tpv_pushBuffer_pushBuffer_L0+0 
;TPV.c,589 :: 		tempPushBuffer = 0;
	CLRF        _tempPushBuffer+0 
	CLRF        _tempPushBuffer+1 
;TPV.c,590 :: 		}
L_tpv_pushBuffer596:
;TPV.c,592 :: 		if(tempPushBuffer >= timePushBuffer){
	MOVLW       0
	SUBWF       _tempPushBuffer+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__tpv_pushBuffer1370
	MOVLW       5
	SUBWF       _tempPushBuffer+0, 0 
L__tpv_pushBuffer1370:
	BTFSS       STATUS+0, 0 
	GOTO        L_tpv_pushBuffer597
;TPV.c,593 :: 		tempPushBuffer = 0;
	CLRF        _tempPushBuffer+0 
	CLRF        _tempPushBuffer+1 
;TPV.c,594 :: 		Net_Ethernet_28j60_startSendTCP(sock1);
	MOVF        _sock1+0, 0 
	MOVWF       FARG_Net_Ethernet_28j60_startSendTCP_socket_28j60+0 
	MOVF        _sock1+1, 0 
	MOVWF       FARG_Net_Ethernet_28j60_startSendTCP_socket_28j60+1 
	CALL        _Net_Ethernet_28j60_startSendTCP+0, 0
;TPV.c,595 :: 		}
L_tpv_pushBuffer597:
;TPV.c,596 :: 		}else{
	GOTO        L_tpv_pushBuffer598
L_tpv_pushBuffer595:
;TPV.c,597 :: 		if(pushBuffer)
	MOVF        tpv_pushBuffer_pushBuffer_L0+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_tpv_pushBuffer599
;TPV.c,598 :: 		pushBuffer = false;
	CLRF        tpv_pushBuffer_pushBuffer_L0+0 
L_tpv_pushBuffer599:
;TPV.c,599 :: 		}
L_tpv_pushBuffer598:
;TPV.c,600 :: 		}
L_end_tpv_pushBuffer:
	RETURN      0
; end of _tpv_pushBuffer

_tpv_reconexion:

;TPV.c,602 :: 		void tpv_reconexion(){
;TPV.c,605 :: 		if(isConectTCP){
	MOVF        _isConectTCP+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_tpv_reconexion600
;TPV.c,606 :: 		if(sock1->state != 3){   //Intenta reconectar TCP
	MOVLW       37
	ADDWF       _sock1+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      _sock1+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	XORLW       3
	BTFSC       STATUS+0, 2 
	GOTO        L_tpv_reconexion601
;TPV.c,608 :: 		if(conected){
	MOVF        tpv_reconexion_conected_L0+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_tpv_reconexion602
;TPV.c,609 :: 		conected = false;
	CLRF        tpv_reconexion_conected_L0+0 
;TPV.c,610 :: 		tempCreateNewPort = 0;
	CLRF        _tempCreateNewPort+0 
	CLRF        _tempCreateNewPort+1 
;TPV.c,611 :: 		tempReconectTCP = 0;
	CLRF        _tempReconectTCP+0 
	CLRF        _tempReconectTCP+1 
;TPV.c,613 :: 		Net_Ethernet_28j60_connectTCP(ipAddr, portServer, myPort, &sock1); //Reconecta
	MOVLW       _ipAddr+0
	MOVWF       FARG_Net_Ethernet_28j60_connectTCP_remoteIP+0 
	MOVLW       hi_addr(_ipAddr+0)
	MOVWF       FARG_Net_Ethernet_28j60_connectTCP_remoteIP+1 
	MOVF        _portServer+0, 0 
	MOVWF       FARG_Net_Ethernet_28j60_connectTCP_remote_port+0 
	MOVF        _portServer+1, 0 
	MOVWF       FARG_Net_Ethernet_28j60_connectTCP_remote_port+1 
	MOVF        _myPort+0, 0 
	MOVWF       FARG_Net_Ethernet_28j60_connectTCP_my_port+0 
	MOVF        _myPort+1, 0 
	MOVWF       FARG_Net_Ethernet_28j60_connectTCP_my_port+1 
	MOVLW       _sock1+0
	MOVWF       FARG_Net_Ethernet_28j60_connectTCP_used_socket+0 
	MOVLW       hi_addr(_sock1+0)
	MOVWF       FARG_Net_Ethernet_28j60_connectTCP_used_socket+1 
	CALL        _Net_Ethernet_28j60_connectTCP+0, 0
;TPV.c,614 :: 		}
L_tpv_reconexion602:
;TPV.c,616 :: 		if(tempCreateNewPort >= timeCreateNewPort){
	MOVLW       0
	SUBWF       _tempCreateNewPort+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__tpv_reconexion1372
	MOVLW       5
	SUBWF       _tempCreateNewPort+0, 0 
L__tpv_reconexion1372:
	BTFSS       STATUS+0, 0 
	GOTO        L_tpv_reconexion603
;TPV.c,617 :: 		tempCreateNewPort = 0;
	CLRF        _tempCreateNewPort+0 
	CLRF        _tempCreateNewPort+1 
;TPV.c,618 :: 		myPort = clamp_shift(++myPort, myPortMin, myPortMax);
	INFSNZ      _myPort+0, 1 
	INCF        _myPort+1, 1 
	MOVF        _myPort+0, 0 
	MOVWF       FARG_clamp_shift_valor+0 
	MOVF        _myPort+1, 0 
	MOVWF       FARG_clamp_shift_valor+1 
	MOVLW       0
	MOVWF       FARG_clamp_shift_valor+2 
	MOVWF       FARG_clamp_shift_valor+3 
	MOVLW       123
	MOVWF       FARG_clamp_shift_min+0 
	MOVLW       0
	MOVWF       FARG_clamp_shift_min+1 
	MOVLW       0
	MOVWF       FARG_clamp_shift_min+2 
	MOVWF       FARG_clamp_shift_min+3 
	MOVLW       127
	MOVWF       FARG_clamp_shift_max+0 
	MOVLW       0
	MOVWF       FARG_clamp_shift_max+1 
	MOVLW       0
	MOVWF       FARG_clamp_shift_max+2 
	MOVWF       FARG_clamp_shift_max+3 
	CALL        _clamp_shift+0, 0
	MOVF        R0, 0 
	MOVWF       _myPort+0 
	MOVF        R1, 0 
	MOVWF       _myPort+1 
;TPV.c,619 :: 		}
L_tpv_reconexion603:
;TPV.c,621 :: 		if(tempReconectTCP >= timeReconectTCP){
	MOVLW       0
	SUBWF       _tempReconectTCP+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__tpv_reconexion1373
	MOVLW       3
	SUBWF       _tempReconectTCP+0, 0 
L__tpv_reconexion1373:
	BTFSS       STATUS+0, 0 
	GOTO        L_tpv_reconexion604
;TPV.c,622 :: 		tempReconectTCP = 0;
	CLRF        _tempReconectTCP+0 
	CLRF        _tempReconectTCP+1 
;TPV.c,624 :: 		Net_Ethernet_28j60_connectTCP(ipAddr, portServer, myPort, &sock1);
	MOVLW       _ipAddr+0
	MOVWF       FARG_Net_Ethernet_28j60_connectTCP_remoteIP+0 
	MOVLW       hi_addr(_ipAddr+0)
	MOVWF       FARG_Net_Ethernet_28j60_connectTCP_remoteIP+1 
	MOVF        _portServer+0, 0 
	MOVWF       FARG_Net_Ethernet_28j60_connectTCP_remote_port+0 
	MOVF        _portServer+1, 0 
	MOVWF       FARG_Net_Ethernet_28j60_connectTCP_remote_port+1 
	MOVF        _myPort+0, 0 
	MOVWF       FARG_Net_Ethernet_28j60_connectTCP_my_port+0 
	MOVF        _myPort+1, 0 
	MOVWF       FARG_Net_Ethernet_28j60_connectTCP_my_port+1 
	MOVLW       _sock1+0
	MOVWF       FARG_Net_Ethernet_28j60_connectTCP_used_socket+0 
	MOVLW       hi_addr(_sock1+0)
	MOVWF       FARG_Net_Ethernet_28j60_connectTCP_used_socket+1 
	CALL        _Net_Ethernet_28j60_connectTCP+0, 0
;TPV.c,625 :: 		}
L_tpv_reconexion604:
;TPV.c,626 :: 		}else{
	GOTO        L_tpv_reconexion605
L_tpv_reconexion601:
;TPV.c,627 :: 		if(!conected)
	MOVF        tpv_reconexion_conected_L0+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_tpv_reconexion606
;TPV.c,628 :: 		conected = true;
	MOVLW       1
	MOVWF       tpv_reconexion_conected_L0+0 
L_tpv_reconexion606:
;TPV.c,629 :: 		}
L_tpv_reconexion605:
;TPV.c,630 :: 		}
L_tpv_reconexion600:
;TPV.c,631 :: 		}
L_end_tpv_reconexion:
	RETURN      0
; end of _tpv_reconexion

_tpv_buffer_tcp:

;TPV.c,633 :: 		void tpv_buffer_tcp(){
;TPV.c,637 :: 		if(flagTMR3){   //Vacia buffer cada xms
	MOVF        _flagTMR3+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_tpv_buffer_tcp607
;TPV.c,638 :: 		if(!pilaBufferTCP)
	MOVF        _pilaBufferTCP+0, 0 
	IORWF       _pilaBufferTCP+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L_tpv_buffer_tcp608
;TPV.c,639 :: 		return;
	GOTO        L_end_tpv_buffer_tcp
L_tpv_buffer_tcp608:
;TPV.c,642 :: 		if(isConectServer && isConectTCP && isEmptyBuffer && !sendDataTCP && modoBufferTCP){
	MOVF        _isConectServer+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_tpv_buffer_tcp611
	MOVF        _isConectTCP+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_tpv_buffer_tcp611
	MOVF        _isEmptyBuffer+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_tpv_buffer_tcp611
	MOVF        _sendDataTCP+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_tpv_buffer_tcp611
	MOVF        _modoBufferTCP+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_tpv_buffer_tcp611
L__tpv_buffer_tcp1008:
;TPV.c,643 :: 		if(!mysql_read_forced(tableEventosTCP, eventosEstatus, pointer, &estatus)){
	MOVLW       _tableEventosTCP+0
	MOVWF       FARG_mysql_read_forced_name+0 
	MOVLW       hi_addr(_tableEventosTCP+0)
	MOVWF       FARG_mysql_read_forced_name+1 
	MOVLW       _eventosEstatus+0
	MOVWF       FARG_mysql_read_forced_column+0 
	MOVLW       hi_addr(_eventosEstatus+0)
	MOVWF       FARG_mysql_read_forced_column+1 
	MOVF        TPV_pointer+0, 0 
	MOVWF       FARG_mysql_read_forced_fila+0 
	MOVF        TPV_pointer+1, 0 
	MOVWF       FARG_mysql_read_forced_fila+1 
	MOVLW       tpv_buffer_tcp_estatus_L0+0
	MOVWF       FARG_mysql_read_forced_result+0 
	MOVLW       hi_addr(tpv_buffer_tcp_estatus_L0+0)
	MOVWF       FARG_mysql_read_forced_result+1 
	CALL        _mysql_read_forced+0, 0
	MOVF        R0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_tpv_buffer_tcp612
;TPV.c,644 :: 		usart_write_line("Buscando Eventos TCP...");
	MOVLW       ?lstr11_TPV+0
	MOVWF       FARG_usart_write_line_texto+0 
	MOVLW       hi_addr(?lstr11_TPV+0)
	MOVWF       FARG_usart_write_line_texto+1 
	CALL        _usart_write_line+0, 0
;TPV.c,646 :: 		if(estatus == '1'){
	MOVF        tpv_buffer_tcp_estatus_L0+0, 0 
	XORLW       49
	BTFSS       STATUS+0, 2 
	GOTO        L_tpv_buffer_tcp613
;TPV.c,647 :: 		string_cpyc(bufferEeprom, TCP_CAN_TPV);
	MOVLW       _bufferEeprom+0
	MOVWF       FARG_string_cpyc_destino+0 
	MOVLW       hi_addr(_bufferEeprom+0)
	MOVWF       FARG_string_cpyc_destino+1 
	MOVLW       _TCP_CAN_TPV+0
	MOVWF       FARG_string_cpyc_origen+0 
	MOVLW       hi_addr(_TCP_CAN_TPV+0)
	MOVWF       FARG_string_cpyc_origen+1 
	MOVLW       higher_addr(_TCP_CAN_TPV+0)
	MOVWF       FARG_string_cpyc_origen+2 
	CALL        _string_cpyc+0, 0
;TPV.c,648 :: 		mysql_read_forced(tableEventosTCP, eventosRegistro, pointer, &bufferEeprom[string_len(bufferEeprom)]);
	MOVLW       _bufferEeprom+0
	MOVWF       FARG_string_len_texto+0 
	MOVLW       hi_addr(_bufferEeprom+0)
	MOVWF       FARG_string_len_texto+1 
	CALL        _string_len+0, 0
	MOVLW       _bufferEeprom+0
	MOVWF       FARG_mysql_read_forced_result+0 
	MOVLW       hi_addr(_bufferEeprom+0)
	MOVWF       FARG_mysql_read_forced_result+1 
	MOVF        R0, 0 
	ADDWF       FARG_mysql_read_forced_result+0, 1 
	BTFSC       STATUS+0, 0 
	INCF        FARG_mysql_read_forced_result+1, 1 
	MOVLW       _tableEventosTCP+0
	MOVWF       FARG_mysql_read_forced_name+0 
	MOVLW       hi_addr(_tableEventosTCP+0)
	MOVWF       FARG_mysql_read_forced_name+1 
	MOVLW       _eventosRegistro+0
	MOVWF       FARG_mysql_read_forced_column+0 
	MOVLW       hi_addr(_eventosRegistro+0)
	MOVWF       FARG_mysql_read_forced_column+1 
	MOVF        TPV_pointer+0, 0 
	MOVWF       FARG_mysql_read_forced_fila+0 
	MOVF        TPV_pointer+1, 0 
	MOVWF       FARG_mysql_read_forced_fila+1 
	CALL        _mysql_read_forced+0, 0
;TPV.c,649 :: 		punteroTCP = bufferEeprom;
	MOVLW       _bufferEeprom+0
	MOVWF       _punteroTCP+0 
	MOVLW       hi_addr(_bufferEeprom+0)
	MOVWF       _punteroTCP+1 
;TPV.c,650 :: 		sendDataTCP = true;
	MOVLW       1
	MOVWF       _sendDataTCP+0 
;TPV.c,651 :: 		Net_Ethernet_28j60_UserTCP(sock1);
	MOVF        _sock1+0, 0 
	MOVWF       FARG_Net_Ethernet_28j60_UserTCP_socket+0 
	MOVF        _sock1+1, 0 
	MOVWF       FARG_Net_Ethernet_28j60_UserTCP_socket+1 
	CALL        _Net_Ethernet_28j60_UserTCP+0, 0
;TPV.c,652 :: 		Net_Ethernet_28j60_startSendTCP(sock1);
	MOVF        _sock1+0, 0 
	MOVWF       FARG_Net_Ethernet_28j60_startSendTCP_socket_28j60+0 
	MOVF        _sock1+1, 0 
	MOVWF       FARG_Net_Ethernet_28j60_startSendTCP_socket_28j60+1 
	CALL        _Net_Ethernet_28j60_startSendTCP+0, 0
;TPV.c,654 :: 		modoBufferTCP = false;
	CLRF        _modoBufferTCP+0 
;TPV.c,655 :: 		tempRepeatTCP = 0;
	CLRF        _tempRepeatTCP+0 
;TPV.c,656 :: 		return;
	GOTO        L_end_tpv_buffer_tcp
;TPV.c,657 :: 		}
L_tpv_buffer_tcp613:
;TPV.c,658 :: 		}
L_tpv_buffer_tcp612:
;TPV.c,659 :: 		pointer = clamp_shift(++pointer, 1, myTable.row);
	INFSNZ      TPV_pointer+0, 1 
	INCF        TPV_pointer+1, 1 
	MOVF        TPV_pointer+0, 0 
	MOVWF       FARG_clamp_shift_valor+0 
	MOVF        TPV_pointer+1, 0 
	MOVWF       FARG_clamp_shift_valor+1 
	MOVLW       0
	MOVWF       FARG_clamp_shift_valor+2 
	MOVWF       FARG_clamp_shift_valor+3 
	MOVLW       1
	MOVWF       FARG_clamp_shift_min+0 
	MOVLW       0
	MOVWF       FARG_clamp_shift_min+1 
	MOVWF       FARG_clamp_shift_min+2 
	MOVWF       FARG_clamp_shift_min+3 
	MOVF        TPV_myTable+2, 0 
	MOVWF       FARG_clamp_shift_max+0 
	MOVF        TPV_myTable+3, 0 
	MOVWF       FARG_clamp_shift_max+1 
	MOVLW       0
	MOVWF       FARG_clamp_shift_max+2 
	MOVWF       FARG_clamp_shift_max+3 
	CALL        _clamp_shift+0, 0
	MOVF        R0, 0 
	MOVWF       TPV_pointer+0 
	MOVF        R1, 0 
	MOVWF       TPV_pointer+1 
;TPV.c,660 :: 		}
L_tpv_buffer_tcp611:
;TPV.c,661 :: 		}
L_tpv_buffer_tcp607:
;TPV.c,662 :: 		}
L_end_tpv_buffer_tcp:
	RETURN      0
; end of _tpv_buffer_tcp

_tpv_buffer_can:

;TPV.c,664 :: 		void tpv_buffer_can(){
;TPV.c,668 :: 		if(flagTMR3){
	MOVF        _flagTMR3+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_tpv_buffer_can614
;TPV.c,669 :: 		flagTMR3 = false;
	CLRF        _flagTMR3+0 
;TPV.c,671 :: 		if(pilaBufferCAN == 0 || !can.conected)
	MOVLW       0
	XORWF       _pilaBufferCAN+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__tpv_buffer_can1376
	MOVLW       0
	XORWF       _pilaBufferCAN+0, 0 
L__tpv_buffer_can1376:
	BTFSC       STATUS+0, 2 
	GOTO        L__tpv_buffer_can1011
	MOVF        _can+13, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L__tpv_buffer_can1011
	GOTO        L_tpv_buffer_can617
L__tpv_buffer_can1011:
;TPV.c,672 :: 		return;
	GOTO        L_end_tpv_buffer_can
L_tpv_buffer_can617:
;TPV.c,675 :: 		if(!can.rxBusy && !can.txQueu && !modeBufferToNodo){
	MOVF        _can+106, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_tpv_buffer_can620
	MOVF        _can+33, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_tpv_buffer_can620
	MOVF        _modeBufferToNodo+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_tpv_buffer_can620
L__tpv_buffer_can1010:
;TPV.c,676 :: 		if(!mysql_read_forced(tableEventosCAN, eventosEstatus, pointerBufferCAN, &estatus)){
	MOVLW       _tableEventosCAN+0
	MOVWF       FARG_mysql_read_forced_name+0 
	MOVLW       hi_addr(_tableEventosCAN+0)
	MOVWF       FARG_mysql_read_forced_name+1 
	MOVLW       _eventosEstatus+0
	MOVWF       FARG_mysql_read_forced_column+0 
	MOVLW       hi_addr(_eventosEstatus+0)
	MOVWF       FARG_mysql_read_forced_column+1 
	MOVF        _pointerBufferCAN+0, 0 
	MOVWF       FARG_mysql_read_forced_fila+0 
	MOVF        _pointerBufferCAN+1, 0 
	MOVWF       FARG_mysql_read_forced_fila+1 
	MOVLW       tpv_buffer_can_estatus_L0+0
	MOVWF       FARG_mysql_read_forced_result+0 
	MOVLW       hi_addr(tpv_buffer_can_estatus_L0+0)
	MOVWF       FARG_mysql_read_forced_result+1 
	CALL        _mysql_read_forced+0, 0
	MOVF        R0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_tpv_buffer_can621
;TPV.c,677 :: 		usart_write_line("Buscando Eventos CAN...");
	MOVLW       ?lstr12_TPV+0
	MOVWF       FARG_usart_write_line_texto+0 
	MOVLW       hi_addr(?lstr12_TPV+0)
	MOVWF       FARG_usart_write_line_texto+1 
	CALL        _usart_write_line+0, 0
;TPV.c,678 :: 		if(estatus == '1'){
	MOVF        tpv_buffer_can_estatus_L0+0, 0 
	XORLW       49
	BTFSS       STATUS+0, 2 
	GOTO        L_tpv_buffer_can622
;TPV.c,680 :: 		mysql_read_forced(tableEventosCAN, eventosModulos, pointerBufferCAN, bufferEeprom);
	MOVLW       _tableEventosCAN+0
	MOVWF       FARG_mysql_read_forced_name+0 
	MOVLW       hi_addr(_tableEventosCAN+0)
	MOVWF       FARG_mysql_read_forced_name+1 
	MOVLW       _eventosModulos+0
	MOVWF       FARG_mysql_read_forced_column+0 
	MOVLW       hi_addr(_eventosModulos+0)
	MOVWF       FARG_mysql_read_forced_column+1 
	MOVF        _pointerBufferCAN+0, 0 
	MOVWF       FARG_mysql_read_forced_fila+0 
	MOVF        _pointerBufferCAN+1, 0 
	MOVWF       FARG_mysql_read_forced_fila+1 
	MOVLW       _bufferEeprom+0
	MOVWF       FARG_mysql_read_forced_result+0 
	MOVLW       hi_addr(_bufferEeprom+0)
	MOVWF       FARG_mysql_read_forced_result+1 
	CALL        _mysql_read_forced+0, 0
;TPV.c,681 :: 		tam = string_len(bufferEeprom);
	MOVLW       _bufferEeprom+0
	MOVWF       FARG_string_len_texto+0 
	MOVLW       hi_addr(_bufferEeprom+0)
	MOVWF       FARG_string_len_texto+1 
	CALL        _string_len+0, 0
	MOVF        R0, 0 
	MOVWF       tpv_buffer_can_tam_L0+0 
;TPV.c,682 :: 		if(tam != 0){
	MOVF        R0, 0 
	XORLW       0
	BTFSC       STATUS+0, 2 
	GOTO        L_tpv_buffer_can623
;TPV.c,684 :: 		nodo = bufferEeprom[--tam];
	DECF        tpv_buffer_can_tam_L0+0, 1 
	MOVLW       _bufferEeprom+0
	MOVWF       FSR0 
	MOVLW       hi_addr(_bufferEeprom+0)
	MOVWF       FSR0H 
	MOVF        tpv_buffer_can_tam_L0+0, 0 
	ADDWF       FSR0, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR0H, 1 
	MOVF        POSTINC0+0, 0 
	MOVWF       tpv_buffer_can_nodo_L0+0 
;TPV.c,687 :: 		for(cont = 0; cont < tarjetas.modulos; cont++){
	CLRF        tpv_buffer_can_cont_L0+0 
L_tpv_buffer_can624:
	MOVF        _tarjetas+1, 0 
	SUBWF       tpv_buffer_can_cont_L0+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_tpv_buffer_can625
;TPV.c,688 :: 		if(nodo == tarjetas.canIdMod[cont] && !tarjetas.canState[cont]){
	MOVLW       _tarjetas+42
	MOVWF       FSR2 
	MOVLW       hi_addr(_tarjetas+42)
	MOVWF       FSR2H 
	MOVF        tpv_buffer_can_cont_L0+0, 0 
	ADDWF       FSR2, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR2H, 1 
	MOVF        tpv_buffer_can_nodo_L0+0, 0 
	XORWF       POSTINC2+0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L_tpv_buffer_can629
	MOVLW       _tarjetas+2
	MOVWF       FSR0 
	MOVLW       hi_addr(_tarjetas+2)
	MOVWF       FSR0H 
	MOVF        tpv_buffer_can_cont_L0+0, 0 
	ADDWF       FSR0, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR0H, 1 
	MOVF        POSTINC0+0, 0 
	MOVWF       R0 
	MOVF        R0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_tpv_buffer_can629
L__tpv_buffer_can1009:
;TPV.c,689 :: 		bufferEeprom[tam] = 0; //Desapilo y guardo
	MOVLW       _bufferEeprom+0
	MOVWF       FSR1 
	MOVLW       hi_addr(_bufferEeprom+0)
	MOVWF       FSR1H 
	MOVF        tpv_buffer_can_tam_L0+0, 0 
	ADDWF       FSR1, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR1H, 1 
	CLRF        POSTINC1+0 
;TPV.c,690 :: 		mysql_write_forced(tableEventosCAN, eventosModulos, pointerBufferCAN, bufferEeprom, string_len(bufferEeprom)+1);
	MOVLW       _bufferEeprom+0
	MOVWF       FARG_string_len_texto+0 
	MOVLW       hi_addr(_bufferEeprom+0)
	MOVWF       FARG_string_len_texto+1 
	CALL        _string_len+0, 0
	MOVF        R0, 0 
	ADDLW       1
	MOVWF       FARG_mysql_write_forced_bytes+0 
	MOVLW       _tableEventosCAN+0
	MOVWF       FARG_mysql_write_forced_name+0 
	MOVLW       hi_addr(_tableEventosCAN+0)
	MOVWF       FARG_mysql_write_forced_name+1 
	MOVLW       _eventosModulos+0
	MOVWF       FARG_mysql_write_forced_column+0 
	MOVLW       hi_addr(_eventosModulos+0)
	MOVWF       FARG_mysql_write_forced_column+1 
	MOVF        _pointerBufferCAN+0, 0 
	MOVWF       FARG_mysql_write_forced_fila+0 
	MOVF        _pointerBufferCAN+1, 0 
	MOVWF       FARG_mysql_write_forced_fila+1 
	MOVLW       _bufferEeprom+0
	MOVWF       FARG_mysql_write_forced_texto+0 
	MOVLW       hi_addr(_bufferEeprom+0)
	MOVWF       FARG_mysql_write_forced_texto+1 
	CALL        _mysql_write_forced+0, 0
;TPV.c,691 :: 		usart_write_text("NODO DEAD: ");
	MOVLW       ?lstr13_TPV+0
	MOVWF       FARG_usart_write_text_texto+0 
	MOVLW       hi_addr(?lstr13_TPV+0)
	MOVWF       FARG_usart_write_text_texto+1 
	CALL        _usart_write_text+0, 0
;TPV.c,692 :: 		numToString(nodo, msjConst, 2);
	MOVF        tpv_buffer_can_nodo_L0+0, 0 
	MOVWF       FARG_numToString_valor+0 
	MOVLW       0
	MOVWF       FARG_numToString_valor+1 
	MOVWF       FARG_numToString_valor+2 
	MOVWF       FARG_numToString_valor+3 
	MOVLW       _msjConst+0
	MOVWF       FARG_numToString_cadena+0 
	MOVLW       hi_addr(_msjConst+0)
	MOVWF       FARG_numToString_cadena+1 
	MOVLW       2
	MOVWF       FARG_numToString_digitos+0 
	CALL        _numToString+0, 0
;TPV.c,693 :: 		usart_write_line(msjConst);
	MOVLW       _msjConst+0
	MOVWF       FARG_usart_write_line_texto+0 
	MOVLW       hi_addr(_msjConst+0)
	MOVWF       FARG_usart_write_line_texto+1 
	CALL        _usart_write_line+0, 0
;TPV.c,694 :: 		return;  //No enviar nodo
	GOTO        L_end_tpv_buffer_can
;TPV.c,695 :: 		}
L_tpv_buffer_can629:
;TPV.c,687 :: 		for(cont = 0; cont < tarjetas.modulos; cont++){
	INCF        tpv_buffer_can_cont_L0+0, 1 
;TPV.c,696 :: 		}
	GOTO        L_tpv_buffer_can624
L_tpv_buffer_can625:
;TPV.c,698 :: 		usart_write_text("Enviar a nodo: ");
	MOVLW       ?lstr14_TPV+0
	MOVWF       FARG_usart_write_text_texto+0 
	MOVLW       hi_addr(?lstr14_TPV+0)
	MOVWF       FARG_usart_write_text_texto+1 
	CALL        _usart_write_text+0, 0
;TPV.c,699 :: 		numTostring(nodo, msjConst, 2);
	MOVF        tpv_buffer_can_nodo_L0+0, 0 
	MOVWF       FARG_numToString_valor+0 
	MOVLW       0
	MOVWF       FARG_numToString_valor+1 
	MOVWF       FARG_numToString_valor+2 
	MOVWF       FARG_numToString_valor+3 
	MOVLW       _msjConst+0
	MOVWF       FARG_numToString_cadena+0 
	MOVLW       hi_addr(_msjConst+0)
	MOVWF       FARG_numToString_cadena+1 
	MOVLW       2
	MOVWF       FARG_numToString_digitos+0 
	CALL        _numToString+0, 0
;TPV.c,700 :: 		usart_write_line(msjConst);
	MOVLW       _msjConst+0
	MOVWF       FARG_usart_write_line_texto+0 
	MOVLW       hi_addr(_msjConst+0)
	MOVWF       FARG_usart_write_line_texto+1 
	CALL        _usart_write_line+0, 0
;TPV.c,703 :: 		mysql_read_forced(tableEventosCAN, eventosRegistro, pointerBufferCAN, bufferEeprom);
	MOVLW       _tableEventosCAN+0
	MOVWF       FARG_mysql_read_forced_name+0 
	MOVLW       hi_addr(_tableEventosCAN+0)
	MOVWF       FARG_mysql_read_forced_name+1 
	MOVLW       _eventosRegistro+0
	MOVWF       FARG_mysql_read_forced_column+0 
	MOVLW       hi_addr(_eventosRegistro+0)
	MOVWF       FARG_mysql_read_forced_column+1 
	MOVF        _pointerBufferCAN+0, 0 
	MOVWF       FARG_mysql_read_forced_fila+0 
	MOVF        _pointerBufferCAN+1, 0 
	MOVWF       FARG_mysql_read_forced_fila+1 
	MOVLW       _bufferEeprom+0
	MOVWF       FARG_mysql_read_forced_result+0 
	MOVLW       hi_addr(_bufferEeprom+0)
	MOVWF       FARG_mysql_read_forced_result+1 
	CALL        _mysql_read_forced+0, 0
;TPV.c,704 :: 		if(can_write_text(can.ip+nodo, bufferEeprom, 0));
	MOVF        tpv_buffer_can_nodo_L0+0, 0 
	ADDWF       _can+0, 0 
	MOVWF       FARG_can_write_text_ipAddress+0 
	MOVLW       0
	ADDWFC      _can+1, 0 
	MOVWF       FARG_can_write_text_ipAddress+1 
	MOVLW       0
	ADDWFC      _can+2, 0 
	MOVWF       FARG_can_write_text_ipAddress+2 
	MOVLW       0
	ADDWFC      _can+3, 0 
	MOVWF       FARG_can_write_text_ipAddress+3 
	MOVLW       _bufferEeprom+0
	MOVWF       FARG_can_write_text_texto+0 
	MOVLW       hi_addr(_bufferEeprom+0)
	MOVWF       FARG_can_write_text_texto+1 
	CLRF        FARG_can_write_text_priority+0 
	CALL        _can_write_text+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_tpv_buffer_can630
L_tpv_buffer_can630:
;TPV.c,705 :: 		modeBufferToNodo = true;
	MOVLW       1
	MOVWF       _modeBufferToNodo+0 
;TPV.c,706 :: 		return;  //No apuntar hacia adelante
	GOTO        L_end_tpv_buffer_can
;TPV.c,707 :: 		}else{
L_tpv_buffer_can623:
;TPV.c,709 :: 		estatus = '0';
	MOVLW       48
	MOVWF       tpv_buffer_can_estatus_L0+0 
;TPV.c,710 :: 		mysql_write_forced(tableEventosCAN, eventosEstatus, pointerBufferCAN, &estatus, 1);
	MOVLW       _tableEventosCAN+0
	MOVWF       FARG_mysql_write_forced_name+0 
	MOVLW       hi_addr(_tableEventosCAN+0)
	MOVWF       FARG_mysql_write_forced_name+1 
	MOVLW       _eventosEstatus+0
	MOVWF       FARG_mysql_write_forced_column+0 
	MOVLW       hi_addr(_eventosEstatus+0)
	MOVWF       FARG_mysql_write_forced_column+1 
	MOVF        _pointerBufferCAN+0, 0 
	MOVWF       FARG_mysql_write_forced_fila+0 
	MOVF        _pointerBufferCAN+1, 0 
	MOVWF       FARG_mysql_write_forced_fila+1 
	MOVLW       tpv_buffer_can_estatus_L0+0
	MOVWF       FARG_mysql_write_forced_texto+0 
	MOVLW       hi_addr(tpv_buffer_can_estatus_L0+0)
	MOVWF       FARG_mysql_write_forced_texto+1 
	MOVLW       1
	MOVWF       FARG_mysql_write_forced_bytes+0 
	CALL        _mysql_write_forced+0, 0
;TPV.c,711 :: 		pilaBufferCAN--;
	MOVLW       1
	SUBWF       _pilaBufferCAN+0, 1 
	MOVLW       0
	SUBWFB      _pilaBufferCAN+1, 1 
;TPV.c,712 :: 		usart_write_text("CAN restan: ");
	MOVLW       ?lstr15_TPV+0
	MOVWF       FARG_usart_write_text_texto+0 
	MOVLW       hi_addr(?lstr15_TPV+0)
	MOVWF       FARG_usart_write_text_texto+1 
	CALL        _usart_write_text+0, 0
;TPV.c,713 :: 		inttostr(pilaBufferCAN, msjConst);
	MOVF        _pilaBufferCAN+0, 0 
	MOVWF       FARG_IntToStr_input+0 
	MOVF        _pilaBufferCAN+1, 0 
	MOVWF       FARG_IntToStr_input+1 
	MOVLW       _msjConst+0
	MOVWF       FARG_IntToStr_output+0 
	MOVLW       hi_addr(_msjConst+0)
	MOVWF       FARG_IntToStr_output+1 
	CALL        _IntToStr+0, 0
;TPV.c,714 :: 		usart_write_line(msjConst);
	MOVLW       _msjConst+0
	MOVWF       FARG_usart_write_line_texto+0 
	MOVLW       hi_addr(_msjConst+0)
	MOVWF       FARG_usart_write_line_texto+1 
	CALL        _usart_write_line+0, 0
;TPV.c,716 :: 		}
L_tpv_buffer_can622:
;TPV.c,717 :: 		}
L_tpv_buffer_can621:
;TPV.c,718 :: 		pointerBufferCAN = clamp_shift(++pointerBufferCAN, 1, myTable.row);
	INFSNZ      _pointerBufferCAN+0, 1 
	INCF        _pointerBufferCAN+1, 1 
	MOVF        _pointerBufferCAN+0, 0 
	MOVWF       FARG_clamp_shift_valor+0 
	MOVF        _pointerBufferCAN+1, 0 
	MOVWF       FARG_clamp_shift_valor+1 
	MOVLW       0
	BTFSC       _pointerBufferCAN+1, 7 
	MOVLW       255
	MOVWF       FARG_clamp_shift_valor+2 
	MOVWF       FARG_clamp_shift_valor+3 
	MOVLW       1
	MOVWF       FARG_clamp_shift_min+0 
	MOVLW       0
	MOVWF       FARG_clamp_shift_min+1 
	MOVWF       FARG_clamp_shift_min+2 
	MOVWF       FARG_clamp_shift_min+3 
	MOVF        TPV_myTable+2, 0 
	MOVWF       FARG_clamp_shift_max+0 
	MOVF        TPV_myTable+3, 0 
	MOVWF       FARG_clamp_shift_max+1 
	MOVLW       0
	MOVWF       FARG_clamp_shift_max+2 
	MOVWF       FARG_clamp_shift_max+3 
	CALL        _clamp_shift+0, 0
	MOVF        R0, 0 
	MOVWF       _pointerBufferCAN+0 
	MOVF        R1, 0 
	MOVWF       _pointerBufferCAN+1 
;TPV.c,719 :: 		}
L_tpv_buffer_can620:
;TPV.c,720 :: 		}
L_tpv_buffer_can614:
;TPV.c,721 :: 		}
L_end_tpv_buffer_can:
	RETURN      0
; end of _tpv_buffer_can

_tpv_temporizadores:

;TPV.c,723 :: 		void tpv_temporizadores(){
;TPV.c,733 :: 		if(flagSecondTMR3){
	MOVF        _flagSecondTMR3+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_tpv_temporizadores632
;TPV.c,734 :: 		flagSecondTMR3 = 0;
	CLRF        _flagSecondTMR3+0 
;TPV.c,735 :: 		tempPushBuffer++;
	INFSNZ      _tempPushBuffer+0, 1 
	INCF        _tempPushBuffer+1, 1 
;TPV.c,736 :: 		tempCreateNewPort++;
	INFSNZ      _tempCreateNewPort+0, 1 
	INCF        _tempCreateNewPort+1, 1 
;TPV.c,737 :: 		tempReconectTCP++;
	INFSNZ      _tempReconectTCP+0, 1 
	INCF        _tempReconectTCP+1, 1 
;TPV.c,738 :: 		tarjetas.canTemp++;
	MOVLW       1
	ADDWF       _tarjetas+63, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      _tarjetas+64, 0 
	MOVWF       R1 
	MOVF        R0, 0 
	MOVWF       _tarjetas+63 
	MOVF        R1, 0 
	MOVWF       _tarjetas+64 
;TPV.c,739 :: 		tempHeartBeatTcp++;
	INFSNZ      _tempHeartBeatTcp+0, 1 
	INCF        _tempHeartBeatTcp+1, 1 
;TPV.c,742 :: 		isEmptyBuffer = Net_Ethernet_28j60_bufferEmptyTCP(sock1);
	MOVF        _sock1+0, 0 
	MOVWF       FARG_Net_Ethernet_28j60_bufferEmptyTCP_socket_28j60+0 
	MOVF        _sock1+1, 0 
	MOVWF       FARG_Net_Ethernet_28j60_bufferEmptyTCP_socket_28j60+1 
	CALL        _Net_Ethernet_28j60_bufferEmptyTCP+0, 0
	MOVF        R0, 0 
	MOVWF       _isEmptyBuffer+0 
;TPV.c,745 :: 		if(isConectTCP != spi_tcp_linked()){
	CALL        _spi_tcp_linked+0, 0
	MOVF        _isConectTCP+0, 0 
	XORWF       R0, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L_tpv_temporizadores633
;TPV.c,746 :: 		isConectTCP = spi_tcp_linked();
	CALL        _spi_tcp_linked+0, 0
	MOVF        R0, 0 
	MOVWF       _isConectTCP+0 
;TPV.c,748 :: 		if(isConectTCP)
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_tpv_temporizadores634
;TPV.c,749 :: 		usart_write_text("CONEXION POR CABLE \r\n");
	MOVLW       ?lstr16_TPV+0
	MOVWF       FARG_usart_write_text_texto+0 
	MOVLW       hi_addr(?lstr16_TPV+0)
	MOVWF       FARG_usart_write_text_texto+1 
	CALL        _usart_write_text+0, 0
	GOTO        L_tpv_temporizadores635
L_tpv_temporizadores634:
;TPV.c,751 :: 		usart_write_text("DESCONEXION POR CABLE \r\n");
	MOVLW       ?lstr17_TPV+0
	MOVWF       FARG_usart_write_text_texto+0 
	MOVLW       hi_addr(?lstr17_TPV+0)
	MOVWF       FARG_usart_write_text_texto+1 
	CALL        _usart_write_text+0, 0
;TPV.c,752 :: 		asm reset;      //No es mejor la forma buscar otra
	RESET
;TPV.c,759 :: 		}
L_tpv_temporizadores635:
;TPV.c,760 :: 		}
L_tpv_temporizadores633:
;TPV.c,762 :: 		if(isConectServer != (sock1->state == 3)){
	MOVLW       37
	ADDWF       _sock1+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      _sock1+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	XORLW       3
	MOVLW       1
	BTFSS       STATUS+0, 2 
	MOVLW       0
	MOVWF       R1 
	MOVF        _isConectServer+0, 0 
	XORWF       R1, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L_tpv_temporizadores636
;TPV.c,763 :: 		isConectServer = sock1->state == 3;
	MOVLW       37
	ADDWF       _sock1+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      _sock1+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	XORLW       3
	MOVLW       1
	BTFSS       STATUS+0, 2 
	MOVLW       0
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       _isConectServer+0 
;TPV.c,765 :: 		if(isConectServer){
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_tpv_temporizadores637
;TPV.c,766 :: 		usart_write_text("ONLINE \r\n");
	MOVLW       ?lstr18_TPV+0
	MOVWF       FARG_usart_write_text_texto+0 
	MOVLW       hi_addr(?lstr18_TPV+0)
	MOVWF       FARG_usart_write_text_texto+1 
	CALL        _usart_write_text+0, 0
;TPV.c,767 :: 		tempHeartBeatTcp = 0;
	CLRF        _tempHeartBeatTcp+0 
	CLRF        _tempHeartBeatTcp+1 
;TPV.c,768 :: 		heartBeatTCP = false;
	CLRF        _heartBeatTCP+0 
;TPV.c,769 :: 		}else
	GOTO        L_tpv_temporizadores638
L_tpv_temporizadores637:
;TPV.c,770 :: 		usart_write_text("OFFLINE \r\n");
	MOVLW       ?lstr19_TPV+0
	MOVWF       FARG_usart_write_text_texto+0 
	MOVLW       hi_addr(?lstr19_TPV+0)
	MOVWF       FARG_usart_write_text_texto+1 
	CALL        _usart_write_text+0, 0
L_tpv_temporizadores638:
;TPV.c,771 :: 		}
L_tpv_temporizadores636:
;TPV.c,773 :: 		if(isConectTCP && isConectServer && can.conected){
	MOVF        _isConectTCP+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_tpv_temporizadores641
	MOVF        _isConectServer+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_tpv_temporizadores641
	MOVF        _can+13, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_tpv_temporizadores641
L__tpv_temporizadores1013:
;TPV.c,774 :: 		LED_LINK ^= 1;
	BTG         PORTC+0, 2 
;TPV.c,775 :: 		}
L_tpv_temporizadores641:
;TPV.c,777 :: 		if(isConectedCan != can.conected){
	MOVF        tpv_temporizadores_isConectedCan_L0+0, 0 
	XORWF       _can+13, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L_tpv_temporizadores642
;TPV.c,778 :: 		usart_write_text("Conexion CAN: ");
	MOVLW       ?lstr20_TPV+0
	MOVWF       FARG_usart_write_text_texto+0 
	MOVLW       hi_addr(?lstr20_TPV+0)
	MOVWF       FARG_usart_write_text_texto+1 
	CALL        _usart_write_text+0, 0
;TPV.c,779 :: 		usart_write_line(can.conected? "Conectado":"Desconectado");
	MOVF        _can+13, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_tpv_temporizadores643
	MOVLW       ?lstr21_TPV+0
	MOVWF       ?FLOC___tpv_temporizadoresT2657+0 
	MOVLW       hi_addr(?lstr21_TPV+0)
	MOVWF       ?FLOC___tpv_temporizadoresT2657+1 
	GOTO        L_tpv_temporizadores644
L_tpv_temporizadores643:
	MOVLW       ?lstr22_TPV+0
	MOVWF       ?FLOC___tpv_temporizadoresT2657+0 
	MOVLW       hi_addr(?lstr22_TPV+0)
	MOVWF       ?FLOC___tpv_temporizadoresT2657+1 
L_tpv_temporizadores644:
	MOVF        ?FLOC___tpv_temporizadoresT2657+0, 0 
	MOVWF       FARG_usart_write_line_texto+0 
	MOVF        ?FLOC___tpv_temporizadoresT2657+1, 0 
	MOVWF       FARG_usart_write_line_texto+1 
	CALL        _usart_write_line+0, 0
;TPV.c,780 :: 		isConectedCan = can.conected;
	MOVF        _can+13, 0 
	MOVWF       tpv_temporizadores_isConectedCan_L0+0 
;TPV.c,782 :: 		string_cpyc(bufferEeprom, CAN_REPORT);
	MOVLW       _bufferEeprom+0
	MOVWF       FARG_string_cpyc_destino+0 
	MOVLW       hi_addr(_bufferEeprom+0)
	MOVWF       FARG_string_cpyc_destino+1 
	MOVLW       tpv_temporizadores_CAN_REPORT_L0+0
	MOVWF       FARG_string_cpyc_origen+0 
	MOVLW       hi_addr(tpv_temporizadores_CAN_REPORT_L0+0)
	MOVWF       FARG_string_cpyc_origen+1 
	MOVLW       higher_addr(tpv_temporizadores_CAN_REPORT_L0+0)
	MOVWF       FARG_string_cpyc_origen+2 
	CALL        _string_cpyc+0, 0
;TPV.c,783 :: 		string_addc(bufferEeprom, TCP_CAN_MOD);
	MOVLW       _bufferEeprom+0
	MOVWF       FARG_string_addc_destino+0 
	MOVLW       hi_addr(_bufferEeprom+0)
	MOVWF       FARG_string_addc_destino+1 
	MOVLW       _TCP_CAN_MOD+0
	MOVWF       FARG_string_addc_addEnd+0 
	MOVLW       hi_addr(_TCP_CAN_MOD+0)
	MOVWF       FARG_string_addc_addEnd+1 
	MOVLW       higher_addr(_TCP_CAN_MOD+0)
	MOVWF       FARG_string_addc_addEnd+2 
	CALL        _string_addc+0, 0
;TPV.c,784 :: 		numToHex(can.id, msjConst, 1);
	MOVF        _can+12, 0 
	MOVWF       FARG_numToHex_valor+0 
	MOVLW       0
	MOVWF       FARG_numToHex_valor+1 
	MOVWF       FARG_numToHex_valor+2 
	MOVWF       FARG_numToHex_valor+3 
	MOVLW       _msjConst+0
	MOVWF       FARG_numToHex_cadena+0 
	MOVLW       hi_addr(_msjConst+0)
	MOVWF       FARG_numToHex_cadena+1 
	MOVLW       1
	MOVWF       FARG_numToHex_bytes+0 
	CALL        _numToHex+0, 0
;TPV.c,785 :: 		string_add(bufferEeprom, msjConst);
	MOVLW       _bufferEeprom+0
	MOVWF       FARG_string_add_destino+0 
	MOVLW       hi_addr(_bufferEeprom+0)
	MOVWF       FARG_string_add_destino+1 
	MOVLW       _msjConst+0
	MOVWF       FARG_string_add_addEnd+0 
	MOVLW       hi_addr(_msjConst+0)
	MOVWF       FARG_string_add_addEnd+1 
	CALL        _string_add+0, 0
;TPV.c,786 :: 		string_addc(bufferEeprom, can.conected?CAN_ONLINE:CAN_OFFLINE);
	MOVLW       _bufferEeprom+0
	MOVWF       FARG_string_addc_destino+0 
	MOVLW       hi_addr(_bufferEeprom+0)
	MOVWF       FARG_string_addc_destino+1 
	MOVF        _can+13, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_tpv_temporizadores645
	MOVLW       tpv_temporizadores_CAN_ONLINE_L0+0
	MOVWF       ?FLOC___tpv_temporizadoresT2668+0 
	MOVLW       hi_addr(tpv_temporizadores_CAN_ONLINE_L0+0)
	MOVWF       ?FLOC___tpv_temporizadoresT2668+1 
	MOVLW       higher_addr(tpv_temporizadores_CAN_ONLINE_L0+0)
	MOVWF       ?FLOC___tpv_temporizadoresT2668+2 
	GOTO        L_tpv_temporizadores646
L_tpv_temporizadores645:
	MOVLW       tpv_temporizadores_CAN_OFFLINE_L0+0
	MOVWF       ?FLOC___tpv_temporizadoresT2668+0 
	MOVLW       hi_addr(tpv_temporizadores_CAN_OFFLINE_L0+0)
	MOVWF       ?FLOC___tpv_temporizadoresT2668+1 
	MOVLW       higher_addr(tpv_temporizadores_CAN_OFFLINE_L0+0)
	MOVWF       ?FLOC___tpv_temporizadoresT2668+2 
L_tpv_temporizadores646:
	MOVF        ?FLOC___tpv_temporizadoresT2668+0, 0 
	MOVWF       FARG_string_addc_addEnd+0 
	MOVF        ?FLOC___tpv_temporizadoresT2668+1, 0 
	MOVWF       FARG_string_addc_addEnd+1 
	MOVF        ?FLOC___tpv_temporizadoresT2668+2, 0 
	MOVWF       FARG_string_addc_addEnd+2 
	CALL        _string_addc+0, 0
;TPV.c,787 :: 		buffer_save_send(true, bufferEeprom, tarjetas.canIdMod);
	MOVLW       1
	MOVWF       FARG_buffer_save_send_tcpORcan+0 
	MOVLW       _bufferEeprom+0
	MOVWF       FARG_buffer_save_send_buffer+0 
	MOVLW       hi_addr(_bufferEeprom+0)
	MOVWF       FARG_buffer_save_send_buffer+1 
	MOVLW       _tarjetas+42
	MOVWF       FARG_buffer_save_send_nodosCAN+0 
	MOVLW       hi_addr(_tarjetas+42)
	MOVWF       FARG_buffer_save_send_nodosCAN+1 
	CALL        _buffer_save_send+0, 0
;TPV.c,788 :: 		}
L_tpv_temporizadores642:
;TPV.c,791 :: 		if(tarjetas.canTemp >= MAX_TIME_CHECK_MOD){
	MOVLW       128
	XORWF       _tarjetas+64, 0 
	MOVWF       R0 
	MOVLW       128
	XORLW       0
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__tpv_temporizadores1378
	MOVLW       20
	SUBWF       _tarjetas+63, 0 
L__tpv_temporizadores1378:
	BTFSS       STATUS+0, 0 
	GOTO        L_tpv_temporizadores647
;TPV.c,792 :: 		tarjetas.canTemp = 0;
	CLRF        _tarjetas+63 
	CLRF        _tarjetas+64 
;TPV.c,794 :: 		for(cont = 0; cont < tarjetas.modulos; cont++){
	CLRF        tpv_temporizadores_cont_L0+0 
L_tpv_temporizadores648:
	MOVF        _tarjetas+1, 0 
	SUBWF       tpv_temporizadores_cont_L0+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_tpv_temporizadores649
;TPV.c,795 :: 		if(tarjetas.canState[cont] != tarjetas.canIdReport[cont]){
	MOVLW       _tarjetas+2
	MOVWF       FSR0 
	MOVLW       hi_addr(_tarjetas+2)
	MOVWF       FSR0H 
	MOVF        tpv_temporizadores_cont_L0+0, 0 
	ADDWF       FSR0, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR0H, 1 
	MOVLW       _tarjetas+22
	MOVWF       FSR2 
	MOVLW       hi_addr(_tarjetas+22)
	MOVWF       FSR2H 
	MOVF        tpv_temporizadores_cont_L0+0, 0 
	ADDWF       FSR2, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR2H, 1 
	MOVF        POSTINC0+0, 0 
	XORWF       POSTINC2+0, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L_tpv_temporizadores651
;TPV.c,797 :: 		string_cpyc(bufferEeprom, CAN_REPORT);
	MOVLW       _bufferEeprom+0
	MOVWF       FARG_string_cpyc_destino+0 
	MOVLW       hi_addr(_bufferEeprom+0)
	MOVWF       FARG_string_cpyc_destino+1 
	MOVLW       tpv_temporizadores_CAN_REPORT_L0+0
	MOVWF       FARG_string_cpyc_origen+0 
	MOVLW       hi_addr(tpv_temporizadores_CAN_REPORT_L0+0)
	MOVWF       FARG_string_cpyc_origen+1 
	MOVLW       higher_addr(tpv_temporizadores_CAN_REPORT_L0+0)
	MOVWF       FARG_string_cpyc_origen+2 
	CALL        _string_cpyc+0, 0
;TPV.c,798 :: 		string_addc(bufferEeprom, TCP_CAN_MOD);
	MOVLW       _bufferEeprom+0
	MOVWF       FARG_string_addc_destino+0 
	MOVLW       hi_addr(_bufferEeprom+0)
	MOVWF       FARG_string_addc_destino+1 
	MOVLW       _TCP_CAN_MOD+0
	MOVWF       FARG_string_addc_addEnd+0 
	MOVLW       hi_addr(_TCP_CAN_MOD+0)
	MOVWF       FARG_string_addc_addEnd+1 
	MOVLW       higher_addr(_TCP_CAN_MOD+0)
	MOVWF       FARG_string_addc_addEnd+2 
	CALL        _string_addc+0, 0
;TPV.c,799 :: 		numToHex(tarjetas.canIdMod[cont], msjConst, 1);
	MOVLW       _tarjetas+42
	MOVWF       FSR0 
	MOVLW       hi_addr(_tarjetas+42)
	MOVWF       FSR0H 
	MOVF        tpv_temporizadores_cont_L0+0, 0 
	ADDWF       FSR0, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR0H, 1 
	MOVF        POSTINC0+0, 0 
	MOVWF       FARG_numToHex_valor+0 
	MOVLW       0
	MOVWF       FARG_numToHex_valor+1 
	MOVWF       FARG_numToHex_valor+2 
	MOVWF       FARG_numToHex_valor+3 
	MOVLW       0
	MOVWF       FARG_numToHex_valor+1 
	MOVWF       FARG_numToHex_valor+2 
	MOVWF       FARG_numToHex_valor+3 
	MOVLW       _msjConst+0
	MOVWF       FARG_numToHex_cadena+0 
	MOVLW       hi_addr(_msjConst+0)
	MOVWF       FARG_numToHex_cadena+1 
	MOVLW       1
	MOVWF       FARG_numToHex_bytes+0 
	CALL        _numToHex+0, 0
;TPV.c,800 :: 		string_add(bufferEeprom, msjConst);
	MOVLW       _bufferEeprom+0
	MOVWF       FARG_string_add_destino+0 
	MOVLW       hi_addr(_bufferEeprom+0)
	MOVWF       FARG_string_add_destino+1 
	MOVLW       _msjConst+0
	MOVWF       FARG_string_add_addEnd+0 
	MOVLW       hi_addr(_msjConst+0)
	MOVWF       FARG_string_add_addEnd+1 
	CALL        _string_add+0, 0
;TPV.c,801 :: 		string_addc(bufferEeprom, tarjetas.canIdReport[cont]?CAN_ONLINE:CAN_OFFLINE);
	MOVLW       _bufferEeprom+0
	MOVWF       FARG_string_addc_destino+0 
	MOVLW       hi_addr(_bufferEeprom+0)
	MOVWF       FARG_string_addc_destino+1 
	MOVLW       _tarjetas+22
	MOVWF       FSR0 
	MOVLW       hi_addr(_tarjetas+22)
	MOVWF       FSR0H 
	MOVF        tpv_temporizadores_cont_L0+0, 0 
	ADDWF       FSR0, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR0H, 1 
	MOVF        POSTINC0+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_tpv_temporizadores652
	MOVLW       tpv_temporizadores_CAN_ONLINE_L0+0
	MOVWF       ?FLOC___tpv_temporizadoresT2701+0 
	MOVLW       hi_addr(tpv_temporizadores_CAN_ONLINE_L0+0)
	MOVWF       ?FLOC___tpv_temporizadoresT2701+1 
	MOVLW       higher_addr(tpv_temporizadores_CAN_ONLINE_L0+0)
	MOVWF       ?FLOC___tpv_temporizadoresT2701+2 
	GOTO        L_tpv_temporizadores653
L_tpv_temporizadores652:
	MOVLW       tpv_temporizadores_CAN_OFFLINE_L0+0
	MOVWF       ?FLOC___tpv_temporizadoresT2701+0 
	MOVLW       hi_addr(tpv_temporizadores_CAN_OFFLINE_L0+0)
	MOVWF       ?FLOC___tpv_temporizadoresT2701+1 
	MOVLW       higher_addr(tpv_temporizadores_CAN_OFFLINE_L0+0)
	MOVWF       ?FLOC___tpv_temporizadoresT2701+2 
L_tpv_temporizadores653:
	MOVF        ?FLOC___tpv_temporizadoresT2701+0, 0 
	MOVWF       FARG_string_addc_addEnd+0 
	MOVF        ?FLOC___tpv_temporizadoresT2701+1, 0 
	MOVWF       FARG_string_addc_addEnd+1 
	MOVF        ?FLOC___tpv_temporizadoresT2701+2, 0 
	MOVWF       FARG_string_addc_addEnd+2 
	CALL        _string_addc+0, 0
;TPV.c,802 :: 		buffer_save_send(true, bufferEeprom, tarjetas.canIdMod);
	MOVLW       1
	MOVWF       FARG_buffer_save_send_tcpORcan+0 
	MOVLW       _bufferEeprom+0
	MOVWF       FARG_buffer_save_send_buffer+0 
	MOVLW       hi_addr(_bufferEeprom+0)
	MOVWF       FARG_buffer_save_send_buffer+1 
	MOVLW       _tarjetas+42
	MOVWF       FARG_buffer_save_send_nodosCAN+0 
	MOVLW       hi_addr(_tarjetas+42)
	MOVWF       FARG_buffer_save_send_nodosCAN+1 
	CALL        _buffer_save_send+0, 0
;TPV.c,803 :: 		tarjetas.canState[cont] = tarjetas.canIdReport[cont];
	MOVLW       _tarjetas+2
	MOVWF       FSR1 
	MOVLW       hi_addr(_tarjetas+2)
	MOVWF       FSR1H 
	MOVF        tpv_temporizadores_cont_L0+0, 0 
	ADDWF       FSR1, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR1H, 1 
	MOVLW       _tarjetas+22
	MOVWF       FSR0 
	MOVLW       hi_addr(_tarjetas+22)
	MOVWF       FSR0H 
	MOVF        tpv_temporizadores_cont_L0+0, 0 
	ADDWF       FSR0, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR0H, 1 
	MOVF        POSTINC0+0, 0 
	MOVWF       POSTINC1+0 
;TPV.c,805 :: 		if(tarjetas.synchrony){
	MOVF        _tarjetas+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_tpv_temporizadores654
;TPV.c,806 :: 		tarjetas.synchrony = false;
	CLRF        _tarjetas+0 
;TPV.c,807 :: 		string_cpyc(bufferEeprom, CAN_CMD_PASSBACK_OFFLINE);
	MOVLW       _bufferEeprom+0
	MOVWF       FARG_string_cpyc_destino+0 
	MOVLW       hi_addr(_bufferEeprom+0)
	MOVWF       FARG_string_cpyc_destino+1 
	MOVLW       tpv_temporizadores_CAN_CMD_PASSBACK_OFFLINE_L0+0
	MOVWF       FARG_string_cpyc_origen+0 
	MOVLW       hi_addr(tpv_temporizadores_CAN_CMD_PASSBACK_OFFLINE_L0+0)
	MOVWF       FARG_string_cpyc_origen+1 
	MOVLW       higher_addr(tpv_temporizadores_CAN_CMD_PASSBACK_OFFLINE_L0+0)
	MOVWF       FARG_string_cpyc_origen+2 
	CALL        _string_cpyc+0, 0
;TPV.c,808 :: 		buffer_save_send(false, bufferEeprom, tarjetas.canIdMod);
	CLRF        FARG_buffer_save_send_tcpORcan+0 
	MOVLW       _bufferEeprom+0
	MOVWF       FARG_buffer_save_send_buffer+0 
	MOVLW       hi_addr(_bufferEeprom+0)
	MOVWF       FARG_buffer_save_send_buffer+1 
	MOVLW       _tarjetas+42
	MOVWF       FARG_buffer_save_send_nodosCAN+0 
	MOVLW       hi_addr(_tarjetas+42)
	MOVWF       FARG_buffer_save_send_nodosCAN+1 
	CALL        _buffer_save_send+0, 0
;TPV.c,809 :: 		usart_write_line(bufferEeprom);
	MOVLW       _bufferEeprom+0
	MOVWF       FARG_usart_write_line_texto+0 
	MOVLW       hi_addr(_bufferEeprom+0)
	MOVWF       FARG_usart_write_line_texto+1 
	CALL        _usart_write_line+0, 0
;TPV.c,810 :: 		}
L_tpv_temporizadores654:
;TPV.c,811 :: 		}
L_tpv_temporizadores651:
;TPV.c,812 :: 		tarjetas.canIdReport[cont] = false; //Esperar nueva respuesta
	MOVLW       _tarjetas+22
	MOVWF       FSR1 
	MOVLW       hi_addr(_tarjetas+22)
	MOVWF       FSR1H 
	MOVF        tpv_temporizadores_cont_L0+0, 0 
	ADDWF       FSR1, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR1H, 1 
	CLRF        POSTINC1+0 
;TPV.c,794 :: 		for(cont = 0; cont < tarjetas.modulos; cont++){
	INCF        tpv_temporizadores_cont_L0+0, 1 
;TPV.c,813 :: 		}
	GOTO        L_tpv_temporizadores648
L_tpv_temporizadores649:
;TPV.c,815 :: 		for(cont = 0; cont < tarjetas.modulos; cont++){
	CLRF        tpv_temporizadores_cont_L0+0 
L_tpv_temporizadores655:
	MOVF        _tarjetas+1, 0 
	SUBWF       tpv_temporizadores_cont_L0+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_tpv_temporizadores656
;TPV.c,816 :: 		if(!tarjetas.canState[cont])
	MOVLW       _tarjetas+2
	MOVWF       FSR0 
	MOVLW       hi_addr(_tarjetas+2)
	MOVWF       FSR0H 
	MOVF        tpv_temporizadores_cont_L0+0, 0 
	ADDWF       FSR0, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR0H, 1 
	MOVF        POSTINC0+0, 0 
	MOVWF       R0 
	MOVF        R0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_tpv_temporizadores658
;TPV.c,817 :: 		break;
	GOTO        L_tpv_temporizadores656
L_tpv_temporizadores658:
;TPV.c,815 :: 		for(cont = 0; cont < tarjetas.modulos; cont++){
	INCF        tpv_temporizadores_cont_L0+0, 1 
;TPV.c,818 :: 		}
	GOTO        L_tpv_temporizadores655
L_tpv_temporizadores656:
;TPV.c,820 :: 		if(cont == tarjetas.modulos){
	MOVF        tpv_temporizadores_cont_L0+0, 0 
	XORWF       _tarjetas+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L_tpv_temporizadores659
;TPV.c,821 :: 		if(!tarjetas.synchrony){
	MOVF        _tarjetas+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_tpv_temporizadores660
;TPV.c,822 :: 		tarjetas.synchrony = true;
	MOVLW       1
	MOVWF       _tarjetas+0 
;TPV.c,823 :: 		string_cpyc(bufferEeprom, CAN_CMD_PASSBACK_ONLINE);
	MOVLW       _bufferEeprom+0
	MOVWF       FARG_string_cpyc_destino+0 
	MOVLW       hi_addr(_bufferEeprom+0)
	MOVWF       FARG_string_cpyc_destino+1 
	MOVLW       tpv_temporizadores_CAN_CMD_PASSBACK_ONLINE_L0+0
	MOVWF       FARG_string_cpyc_origen+0 
	MOVLW       hi_addr(tpv_temporizadores_CAN_CMD_PASSBACK_ONLINE_L0+0)
	MOVWF       FARG_string_cpyc_origen+1 
	MOVLW       higher_addr(tpv_temporizadores_CAN_CMD_PASSBACK_ONLINE_L0+0)
	MOVWF       FARG_string_cpyc_origen+2 
	CALL        _string_cpyc+0, 0
;TPV.c,824 :: 		usart_write_line(bufferEeprom);
	MOVLW       _bufferEeprom+0
	MOVWF       FARG_usart_write_line_texto+0 
	MOVLW       hi_addr(_bufferEeprom+0)
	MOVWF       FARG_usart_write_line_texto+1 
	CALL        _usart_write_line+0, 0
;TPV.c,825 :: 		buffer_save_send(false, bufferEeprom, tarjetas.canIdMod);
	CLRF        FARG_buffer_save_send_tcpORcan+0 
	MOVLW       _bufferEeprom+0
	MOVWF       FARG_buffer_save_send_buffer+0 
	MOVLW       hi_addr(_bufferEeprom+0)
	MOVWF       FARG_buffer_save_send_buffer+1 
	MOVLW       _tarjetas+42
	MOVWF       FARG_buffer_save_send_nodosCAN+0 
	MOVLW       hi_addr(_tarjetas+42)
	MOVWF       FARG_buffer_save_send_nodosCAN+1 
	CALL        _buffer_save_send+0, 0
;TPV.c,826 :: 		}
L_tpv_temporizadores660:
;TPV.c,827 :: 		}
L_tpv_temporizadores659:
;TPV.c,828 :: 		}
L_tpv_temporizadores647:
;TPV.c,830 :: 		if(!modoBufferTCP){
	MOVF        _modoBufferTCP+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_tpv_temporizadores661
;TPV.c,832 :: 		if(++tempRepeatTCP >= 5){
	INCF        _tempRepeatTCP+0, 1 
	MOVLW       5
	SUBWF       _tempRepeatTCP+0, 0 
	BTFSS       STATUS+0, 0 
	GOTO        L_tpv_temporizadores662
;TPV.c,833 :: 		tempRepeatTCP = 0;  //Reiniciar
	CLRF        _tempRepeatTCP+0 
;TPV.c,834 :: 		if(isEmptyBuffer)
	MOVF        _isEmptyBuffer+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_tpv_temporizadores663
;TPV.c,835 :: 		modoBufferTCP = true;
	MOVLW       1
	MOVWF       _modoBufferTCP+0 
L_tpv_temporizadores663:
;TPV.c,836 :: 		}
L_tpv_temporizadores662:
;TPV.c,837 :: 		}
L_tpv_temporizadores661:
;TPV.c,840 :: 		if(tempHeartBeatTcp >= timeHeartBeatTcp){
	MOVLW       128
	XORWF       _tempHeartBeatTcp+1, 0 
	MOVWF       R0 
	MOVLW       128
	XORLW       0
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__tpv_temporizadores1379
	MOVLW       30
	SUBWF       _tempHeartBeatTcp+0, 0 
L__tpv_temporizadores1379:
	BTFSS       STATUS+0, 0 
	GOTO        L_tpv_temporizadores664
;TPV.c,841 :: 		tempHeartBeatTcp = 0;
	CLRF        _tempHeartBeatTcp+0 
	CLRF        _tempHeartBeatTcp+1 
;TPV.c,844 :: 		if(!heartBeatTCP && isConectServer){
	MOVF        _heartBeatTCP+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_tpv_temporizadores667
	MOVF        _isConectServer+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_tpv_temporizadores667
L__tpv_temporizadores1012:
;TPV.c,845 :: 		usart_write_line("Offline heartBeat TCP");
	MOVLW       ?lstr23_TPV+0
	MOVWF       FARG_usart_write_line_texto+0 
	MOVLW       hi_addr(?lstr23_TPV+0)
	MOVWF       FARG_usart_write_line_texto+1 
	CALL        _usart_write_line+0, 0
;TPV.c,847 :: 		string_cpy(bufferEeprom, "ERRHRB");  //ERROR DE HEARBEAT
	MOVLW       _bufferEeprom+0
	MOVWF       FARG_string_cpy_destino+0 
	MOVLW       hi_addr(_bufferEeprom+0)
	MOVWF       FARG_string_cpy_destino+1 
	MOVLW       ?lstr24_TPV+0
	MOVWF       FARG_string_cpy_origen+0 
	MOVLW       hi_addr(?lstr24_TPV+0)
	MOVWF       FARG_string_cpy_origen+1 
	CALL        _string_cpy+0, 0
;TPV.c,848 :: 		buffer_save_send(true, bufferEeprom, tarjetas.canIdMod);
	MOVLW       1
	MOVWF       FARG_buffer_save_send_tcpORcan+0 
	MOVLW       _bufferEeprom+0
	MOVWF       FARG_buffer_save_send_buffer+0 
	MOVLW       hi_addr(_bufferEeprom+0)
	MOVWF       FARG_buffer_save_send_buffer+1 
	MOVLW       _tarjetas+42
	MOVWF       FARG_buffer_save_send_nodosCAN+0 
	MOVLW       hi_addr(_tarjetas+42)
	MOVWF       FARG_buffer_save_send_nodosCAN+1 
	CALL        _buffer_save_send+0, 0
;TPV.c,849 :: 		asm reset;
	RESET
;TPV.c,853 :: 		}
L_tpv_temporizadores667:
;TPV.c,855 :: 		heartBeatTCP = false;
	CLRF        _heartBeatTCP+0 
;TPV.c,856 :: 		}
L_tpv_temporizadores664:
;TPV.c,859 :: 		}
L_tpv_temporizadores632:
;TPV.c,860 :: 		}
L_end_tpv_temporizadores:
	RETURN      0
; end of _tpv_temporizadores

_Net_Ethernet_28j60_UserTCP:

;TPV.c,864 :: 		void Net_Ethernet_28j60_UserTCP(SOCKET_28j60_Dsc *socket){
;TPV.c,887 :: 		if(!sendDataTCP.B0){
	BTFSC       _sendDataTCP+0, 0 
	GOTO        L_Net_Ethernet_28j60_UserTCP668
;TPV.c,889 :: 		if(!socket->dataLength)
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
	GOTO        L_Net_Ethernet_28j60_UserTCP669
;TPV.c,890 :: 		return;
	GOTO        L_end_Net_Ethernet_28j60_UserTCP
L_Net_Ethernet_28j60_UserTCP669:
;TPV.c,893 :: 		if(socket->remotePort == portServer && socket->destPort == myPort){  //Modo servidor
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
	GOTO        L__Net_Ethernet_28j60_UserTCP1381
	MOVF        _portServer+0, 0 
	XORWF       R1, 0 
L__Net_Ethernet_28j60_UserTCP1381:
	BTFSS       STATUS+0, 2 
	GOTO        L_Net_Ethernet_28j60_UserTCP672
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
	GOTO        L__Net_Ethernet_28j60_UserTCP1382
	MOVF        _myPort+0, 0 
	XORWF       R1, 0 
L__Net_Ethernet_28j60_UserTCP1382:
	BTFSS       STATUS+0, 2 
	GOTO        L_Net_Ethernet_28j60_UserTCP672
L__Net_Ethernet_28j60_UserTCP1021:
;TPV.c,894 :: 		respuesta[0] = 0;
	CLRF        Net_Ethernet_28j60_UserTCP_respuesta_L0+0 
;TPV.c,896 :: 		for(cont = 0; cont < socket->dataLength && cont < sizeof(getRequest)-1; cont++){
	CLRF        Net_Ethernet_28j60_UserTCP_cont_L0+0 
	CLRF        Net_Ethernet_28j60_UserTCP_cont_L0+1 
L_Net_Ethernet_28j60_UserTCP673:
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
	GOTO        L__Net_Ethernet_28j60_UserTCP1383
	MOVF        R1, 0 
	SUBWF       Net_Ethernet_28j60_UserTCP_cont_L0+0, 0 
L__Net_Ethernet_28j60_UserTCP1383:
	BTFSC       STATUS+0, 0 
	GOTO        L_Net_Ethernet_28j60_UserTCP674
	MOVLW       0
	SUBWF       Net_Ethernet_28j60_UserTCP_cont_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__Net_Ethernet_28j60_UserTCP1384
	MOVLW       63
	SUBWF       Net_Ethernet_28j60_UserTCP_cont_L0+0, 0 
L__Net_Ethernet_28j60_UserTCP1384:
	BTFSC       STATUS+0, 0 
	GOTO        L_Net_Ethernet_28j60_UserTCP674
L__Net_Ethernet_28j60_UserTCP1020:
;TPV.c,897 :: 		getRequest[contRequest] = Net_Ethernet_28j60_getByte();
	MOVLW       _getRequest+0
	ADDWF       Net_Ethernet_28j60_UserTCP_contRequest_L0+0, 0 
	MOVWF       FLOC__Net_Ethernet_28j60_UserTCP+0 
	MOVLW       hi_addr(_getRequest+0)
	ADDWFC      Net_Ethernet_28j60_UserTCP_contRequest_L0+1, 0 
	MOVWF       FLOC__Net_Ethernet_28j60_UserTCP+1 
	CALL        _Net_Ethernet_28j60_getByte+0, 0
	MOVFF       FLOC__Net_Ethernet_28j60_UserTCP+0, FSR1
	MOVFF       FLOC__Net_Ethernet_28j60_UserTCP+1, FSR1H
	MOVF        R0, 0 
	MOVWF       POSTINC1+0 
;TPV.c,899 :: 		if(getRequest[contRequest] == '<'){
	MOVLW       _getRequest+0
	ADDWF       Net_Ethernet_28j60_UserTCP_contRequest_L0+0, 0 
	MOVWF       FSR0 
	MOVLW       hi_addr(_getRequest+0)
	ADDWFC      Net_Ethernet_28j60_UserTCP_contRequest_L0+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	XORLW       60
	BTFSS       STATUS+0, 2 
	GOTO        L_Net_Ethernet_28j60_UserTCP678
;TPV.c,900 :: 		contRequest = 0;
	CLRF        Net_Ethernet_28j60_UserTCP_contRequest_L0+0 
	CLRF        Net_Ethernet_28j60_UserTCP_contRequest_L0+1 
;TPV.c,901 :: 		overflow = false;
	CLRF        Net_Ethernet_28j60_UserTCP_overflow_L0+0 
;TPV.c,902 :: 		}else if(getRequest[contRequest] == '>')
	GOTO        L_Net_Ethernet_28j60_UserTCP679
L_Net_Ethernet_28j60_UserTCP678:
	MOVLW       _getRequest+0
	ADDWF       Net_Ethernet_28j60_UserTCP_contRequest_L0+0, 0 
	MOVWF       FSR0 
	MOVLW       hi_addr(_getRequest+0)
	ADDWFC      Net_Ethernet_28j60_UserTCP_contRequest_L0+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	XORLW       62
	BTFSS       STATUS+0, 2 
	GOTO        L_Net_Ethernet_28j60_UserTCP680
;TPV.c,903 :: 		break;
	GOTO        L_Net_Ethernet_28j60_UserTCP674
L_Net_Ethernet_28j60_UserTCP680:
;TPV.c,904 :: 		else if(getRequest[contRequest] == '!'){
	MOVLW       _getRequest+0
	ADDWF       Net_Ethernet_28j60_UserTCP_contRequest_L0+0, 0 
	MOVWF       FSR0 
	MOVLW       hi_addr(_getRequest+0)
	ADDWFC      Net_Ethernet_28j60_UserTCP_contRequest_L0+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	XORLW       33
	BTFSS       STATUS+0, 2 
	GOTO        L_Net_Ethernet_28j60_UserTCP682
;TPV.c,905 :: 		heartBeatTCP = true;
	MOVLW       1
	MOVWF       _heartBeatTCP+0 
;TPV.c,906 :: 		continue;
	GOTO        L_Net_Ethernet_28j60_UserTCP675
;TPV.c,907 :: 		}else{
L_Net_Ethernet_28j60_UserTCP682:
;TPV.c,908 :: 		if(contRequest == sizeof(getRequest)-1)
	MOVF        Net_Ethernet_28j60_UserTCP_contRequest_L0+1, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L__Net_Ethernet_28j60_UserTCP1385
	MOVLW       63
	XORWF       Net_Ethernet_28j60_UserTCP_contRequest_L0+0, 0 
L__Net_Ethernet_28j60_UserTCP1385:
	BTFSS       STATUS+0, 2 
	GOTO        L_Net_Ethernet_28j60_UserTCP684
;TPV.c,909 :: 		overflow = true;
	MOVLW       1
	MOVWF       Net_Ethernet_28j60_UserTCP_overflow_L0+0 
L_Net_Ethernet_28j60_UserTCP684:
;TPV.c,910 :: 		contRequest = clamp_shift(++contRequest, 0, sizeof(getRequest)-1);
	INFSNZ      Net_Ethernet_28j60_UserTCP_contRequest_L0+0, 1 
	INCF        Net_Ethernet_28j60_UserTCP_contRequest_L0+1, 1 
	MOVF        Net_Ethernet_28j60_UserTCP_contRequest_L0+0, 0 
	MOVWF       FARG_clamp_shift_valor+0 
	MOVF        Net_Ethernet_28j60_UserTCP_contRequest_L0+1, 0 
	MOVWF       FARG_clamp_shift_valor+1 
	MOVLW       0
	MOVWF       FARG_clamp_shift_valor+2 
	MOVWF       FARG_clamp_shift_valor+3 
	CLRF        FARG_clamp_shift_min+0 
	CLRF        FARG_clamp_shift_min+1 
	CLRF        FARG_clamp_shift_min+2 
	CLRF        FARG_clamp_shift_min+3 
	MOVLW       63
	MOVWF       FARG_clamp_shift_max+0 
	MOVLW       0
	MOVWF       FARG_clamp_shift_max+1 
	MOVLW       0
	MOVWF       FARG_clamp_shift_max+2 
	MOVWF       FARG_clamp_shift_max+3 
	CALL        _clamp_shift+0, 0
	MOVF        R0, 0 
	MOVWF       Net_Ethernet_28j60_UserTCP_contRequest_L0+0 
	MOVF        R1, 0 
	MOVWF       Net_Ethernet_28j60_UserTCP_contRequest_L0+1 
;TPV.c,911 :: 		}
L_Net_Ethernet_28j60_UserTCP679:
;TPV.c,912 :: 		}
L_Net_Ethernet_28j60_UserTCP675:
;TPV.c,896 :: 		for(cont = 0; cont < socket->dataLength && cont < sizeof(getRequest)-1; cont++){
	INFSNZ      Net_Ethernet_28j60_UserTCP_cont_L0+0, 1 
	INCF        Net_Ethernet_28j60_UserTCP_cont_L0+1, 1 
;TPV.c,912 :: 		}
	GOTO        L_Net_Ethernet_28j60_UserTCP673
L_Net_Ethernet_28j60_UserTCP674:
;TPV.c,913 :: 		if(getRequest[contRequest] != '>')
	MOVLW       _getRequest+0
	ADDWF       Net_Ethernet_28j60_UserTCP_contRequest_L0+0, 0 
	MOVWF       FSR0 
	MOVLW       hi_addr(_getRequest+0)
	ADDWFC      Net_Ethernet_28j60_UserTCP_contRequest_L0+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	XORLW       62
	BTFSC       STATUS+0, 2 
	GOTO        L_Net_Ethernet_28j60_UserTCP685
;TPV.c,914 :: 		return;
	GOTO        L_end_Net_Ethernet_28j60_UserTCP
L_Net_Ethernet_28j60_UserTCP685:
;TPV.c,916 :: 		getRequest[contRequest] = 0;
	MOVLW       _getRequest+0
	ADDWF       Net_Ethernet_28j60_UserTCP_contRequest_L0+0, 0 
	MOVWF       FSR1 
	MOVLW       hi_addr(_getRequest+0)
	ADDWFC      Net_Ethernet_28j60_UserTCP_contRequest_L0+1, 0 
	MOVWF       FSR1H 
	CLRF        POSTINC1+0 
;TPV.c,919 :: 		if(overflow){
	MOVF        Net_Ethernet_28j60_UserTCP_overflow_L0+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_Net_Ethernet_28j60_UserTCP686
;TPV.c,920 :: 		overflow = false;
	CLRF        Net_Ethernet_28j60_UserTCP_overflow_L0+0 
;TPV.c,921 :: 		string_cpyc(respuesta, TCP_MESSAGE_OVERFLOW);
	MOVLW       Net_Ethernet_28j60_UserTCP_respuesta_L0+0
	MOVWF       FARG_string_cpyc_destino+0 
	MOVLW       hi_addr(Net_Ethernet_28j60_UserTCP_respuesta_L0+0)
	MOVWF       FARG_string_cpyc_destino+1 
	MOVLW       _TCP_MESSAGE_OVERFLOW+0
	MOVWF       FARG_string_cpyc_origen+0 
	MOVLW       hi_addr(_TCP_MESSAGE_OVERFLOW+0)
	MOVWF       FARG_string_cpyc_origen+1 
	MOVLW       higher_addr(_TCP_MESSAGE_OVERFLOW+0)
	MOVWF       FARG_string_cpyc_origen+2 
	CALL        _string_cpyc+0, 0
;TPV.c,922 :: 		numToHex(sizeof(getRequest), msjConst, 1);
	MOVLW       64
	MOVWF       FARG_numToHex_valor+0 
	MOVLW       0
	MOVWF       FARG_numToHex_valor+1 
	MOVWF       FARG_numToHex_valor+2 
	MOVWF       FARG_numToHex_valor+3 
	MOVLW       _msjConst+0
	MOVWF       FARG_numToHex_cadena+0 
	MOVLW       hi_addr(_msjConst+0)
	MOVWF       FARG_numToHex_cadena+1 
	MOVLW       1
	MOVWF       FARG_numToHex_bytes+0 
	CALL        _numToHex+0, 0
;TPV.c,923 :: 		string_add(respuesta, msjConst);
	MOVLW       Net_Ethernet_28j60_UserTCP_respuesta_L0+0
	MOVWF       FARG_string_add_destino+0 
	MOVLW       hi_addr(Net_Ethernet_28j60_UserTCP_respuesta_L0+0)
	MOVWF       FARG_string_add_destino+1 
	MOVLW       _msjConst+0
	MOVWF       FARG_string_add_addEnd+0 
	MOVLW       hi_addr(_msjConst+0)
	MOVWF       FARG_string_add_addEnd+1 
	CALL        _string_add+0, 0
;TPV.c,924 :: 		getRequest[0] = 0;
	CLRF        _getRequest+0 
;TPV.c,925 :: 		}
L_Net_Ethernet_28j60_UserTCP686:
;TPV.c,928 :: 		bytetostr(contRequest, msjConst);
	MOVF        Net_Ethernet_28j60_UserTCP_contRequest_L0+0, 0 
	MOVWF       FARG_ByteToStr_input+0 
	MOVLW       _msjConst+0
	MOVWF       FARG_ByteToStr_output+0 
	MOVLW       hi_addr(_msjConst+0)
	MOVWF       FARG_ByteToStr_output+1 
	CALL        _ByteToStr+0, 0
;TPV.c,929 :: 		usart_write_text("Bytes: ");
	MOVLW       ?lstr25_TPV+0
	MOVWF       FARG_usart_write_text_texto+0 
	MOVLW       hi_addr(?lstr25_TPV+0)
	MOVWF       FARG_usart_write_text_texto+1 
	CALL        _usart_write_text+0, 0
;TPV.c,930 :: 		usart_write_text(msjConst);
	MOVLW       _msjConst+0
	MOVWF       FARG_usart_write_text_texto+0 
	MOVLW       hi_addr(_msjConst+0)
	MOVWF       FARG_usart_write_text_texto+1 
	CALL        _usart_write_text+0, 0
;TPV.c,932 :: 		usart_write_text(" ,Mensaje: ");
	MOVLW       ?lstr26_TPV+0
	MOVWF       FARG_usart_write_text_texto+0 
	MOVLW       hi_addr(?lstr26_TPV+0)
	MOVWF       FARG_usart_write_text_texto+1 
	CALL        _usart_write_text+0, 0
;TPV.c,933 :: 		usart_write_line(getRequest);
	MOVLW       _getRequest+0
	MOVWF       FARG_usart_write_line_texto+0 
	MOVLW       hi_addr(_getRequest+0)
	MOVWF       FARG_usart_write_line_texto+1 
	CALL        _usart_write_line+0, 0
;TPV.c,936 :: 		sizeTotal = 0;  //Siempre inivializar en ceros
	CLRF        Net_Ethernet_28j60_UserTCP_sizeTotal_L0+0 
;TPV.c,939 :: 		responderACK = false;
	CLRF        Net_Ethernet_28j60_UserTCP_responderACK_L0+0 
;TPV.c,940 :: 		sizeKey = sizeof(TCP_CAN_TPV)-1;
	MOVLW       3
	MOVWF       Net_Ethernet_28j60_UserTCP_sizeKey_L0+0 
;TPV.c,941 :: 		if(string_cmpnc(TCP_CAN_TPV, &getRequest[sizeTotal], sizeKey)){
	MOVLW       _TCP_CAN_TPV+0
	MOVWF       FARG_string_cmpnc_text1+0 
	MOVLW       hi_addr(_TCP_CAN_TPV+0)
	MOVWF       FARG_string_cmpnc_text1+1 
	MOVLW       higher_addr(_TCP_CAN_TPV+0)
	MOVWF       FARG_string_cmpnc_text1+2 
	MOVLW       _getRequest+0
	MOVWF       FARG_string_cmpnc_text2+0 
	MOVLW       hi_addr(_getRequest+0)
	MOVWF       FARG_string_cmpnc_text2+1 
	MOVF        Net_Ethernet_28j60_UserTCP_sizeTotal_L0+0, 0 
	ADDWF       FARG_string_cmpnc_text2+0, 1 
	BTFSC       STATUS+0, 0 
	INCF        FARG_string_cmpnc_text2+1, 1 
	MOVLW       3
	MOVWF       FARG_string_cmpnc_bytes+0 
	CALL        _string_cmpnc+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_Net_Ethernet_28j60_UserTCP687
;TPV.c,943 :: 		string_cpy(getRequest, &getRequest[sizeKey]);
	MOVLW       _getRequest+0
	MOVWF       FARG_string_cpy_destino+0 
	MOVLW       hi_addr(_getRequest+0)
	MOVWF       FARG_string_cpy_destino+1 
	MOVLW       _getRequest+0
	MOVWF       FARG_string_cpy_origen+0 
	MOVLW       hi_addr(_getRequest+0)
	MOVWF       FARG_string_cpy_origen+1 
	MOVF        Net_Ethernet_28j60_UserTCP_sizeKey_L0+0, 0 
	ADDWF       FARG_string_cpy_origen+0, 1 
	BTFSC       STATUS+0, 0 
	INCF        FARG_string_cpy_origen+1, 1 
	CALL        _string_cpy+0, 0
;TPV.c,944 :: 		responderACK = true;
	MOVLW       1
	MOVWF       Net_Ethernet_28j60_UserTCP_responderACK_L0+0 
;TPV.c,945 :: 		}
L_Net_Ethernet_28j60_UserTCP687:
;TPV.c,948 :: 		sizeKey = sizeof(TCP_CAN_PENSIONADO)-1;
	MOVLW       3
	MOVWF       Net_Ethernet_28j60_UserTCP_sizeKey_L0+0 
;TPV.c,950 :: 		if(string_cmpnc(TCP_CAN_PENSIONADO, &getRequest[sizeTotal], sizeKey)){
	MOVLW       _TCP_CAN_PENSIONADO+0
	MOVWF       FARG_string_cmpnc_text1+0 
	MOVLW       hi_addr(_TCP_CAN_PENSIONADO+0)
	MOVWF       FARG_string_cmpnc_text1+1 
	MOVLW       higher_addr(_TCP_CAN_PENSIONADO+0)
	MOVWF       FARG_string_cmpnc_text1+2 
	MOVLW       _getRequest+0
	MOVWF       FARG_string_cmpnc_text2+0 
	MOVLW       hi_addr(_getRequest+0)
	MOVWF       FARG_string_cmpnc_text2+1 
	MOVF        Net_Ethernet_28j60_UserTCP_sizeTotal_L0+0, 0 
	ADDWF       FARG_string_cmpnc_text2+0, 1 
	BTFSC       STATUS+0, 0 
	INCF        FARG_string_cmpnc_text2+1, 1 
	MOVLW       3
	MOVWF       FARG_string_cmpnc_bytes+0 
	CALL        _string_cmpnc+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_Net_Ethernet_28j60_UserTCP688
;TPV.c,952 :: 		sizeTotal += sizeKey;
	MOVF        Net_Ethernet_28j60_UserTCP_sizeKey_L0+0, 0 
	ADDWF       Net_Ethernet_28j60_UserTCP_sizeTotal_L0+0, 0 
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       Net_Ethernet_28j60_UserTCP_sizeTotal_L0+0 
;TPV.c,953 :: 		sizeKey = 6;  //3 Bytes en hexadecimal
	MOVLW       6
	MOVWF       Net_Ethernet_28j60_UserTCP_sizeKey_L0+0 
;TPV.c,954 :: 		string_cpyn(msjConst, &getRequest[sizeTotal], sizeKey);
	MOVLW       _msjConst+0
	MOVWF       FARG_string_cpyn_destino+0 
	MOVLW       hi_addr(_msjConst+0)
	MOVWF       FARG_string_cpyn_destino+1 
	MOVLW       _getRequest+0
	MOVWF       FARG_string_cpyn_origen+0 
	MOVLW       hi_addr(_getRequest+0)
	MOVWF       FARG_string_cpyn_origen+1 
	MOVF        R0, 0 
	ADDWF       FARG_string_cpyn_origen+0, 1 
	BTFSC       STATUS+0, 0 
	INCF        FARG_string_cpyn_origen+1, 1 
	MOVLW       6
	MOVWF       FARG_string_cpyn_size+0 
	CALL        _string_cpyn+0, 0
;TPV.c,955 :: 		idConsulta = hexToNum(msjConst);
	MOVLW       _msjConst+0
	MOVWF       FARG_hexToNum_hex+0 
	MOVLW       hi_addr(_msjConst+0)
	MOVWF       FARG_hexToNum_hex+1 
	CALL        _hexToNum+0, 0
	MOVF        R0, 0 
	MOVWF       Net_Ethernet_28j60_UserTCP_idConsulta_L0+0 
	MOVF        R1, 0 
	MOVWF       Net_Ethernet_28j60_UserTCP_idConsulta_L0+1 
	MOVF        R2, 0 
	MOVWF       Net_Ethernet_28j60_UserTCP_idConsulta_L0+2 
	MOVF        R3, 0 
	MOVWF       Net_Ethernet_28j60_UserTCP_idConsulta_L0+3 
;TPV.c,958 :: 		result = !mysql_search(tablePensionados, pensionadosID, idConsulta, &fila);
	MOVLW       _tablePensionados+0
	MOVWF       FARG_mysql_search_tabla+0 
	MOVLW       hi_addr(_tablePensionados+0)
	MOVWF       FARG_mysql_search_tabla+1 
	MOVLW       _pensionadosID+0
	MOVWF       FARG_mysql_search_columna+0 
	MOVLW       hi_addr(_pensionadosID+0)
	MOVWF       FARG_mysql_search_columna+1 
	MOVF        R0, 0 
	MOVWF       FARG_mysql_search_buscar+0 
	MOVF        R1, 0 
	MOVWF       FARG_mysql_search_buscar+1 
	MOVF        R2, 0 
	MOVWF       FARG_mysql_search_buscar+2 
	MOVF        R3, 0 
	MOVWF       FARG_mysql_search_buscar+3 
	MOVLW       Net_Ethernet_28j60_UserTCP_fila_L0+0
	MOVWF       FARG_mysql_search_fila+0 
	MOVLW       hi_addr(Net_Ethernet_28j60_UserTCP_fila_L0+0)
	MOVWF       FARG_mysql_search_fila+1 
	CALL        _mysql_search+0, 0
	MOVF        R0, 1 
	MOVLW       1
	BTFSS       STATUS+0, 2 
	MOVLW       0
	MOVWF       Net_Ethernet_28j60_UserTCP_result_L0+0 
;TPV.c,960 :: 		sizeTotal += sizeKey;
	MOVF        Net_Ethernet_28j60_UserTCP_sizeKey_L0+0, 0 
	ADDWF       Net_Ethernet_28j60_UserTCP_sizeTotal_L0+0, 0 
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       Net_Ethernet_28j60_UserTCP_sizeTotal_L0+0 
;TPV.c,961 :: 		sizeKey = sizeof(TCP_CAN_REGISTRAR)-1;
	MOVLW       3
	MOVWF       Net_Ethernet_28j60_UserTCP_sizeKey_L0+0 
;TPV.c,963 :: 		string_cpyn(respuesta, getRequest, sizeTotal+sizeKey);
	MOVLW       Net_Ethernet_28j60_UserTCP_respuesta_L0+0
	MOVWF       FARG_string_cpyn_destino+0 
	MOVLW       hi_addr(Net_Ethernet_28j60_UserTCP_respuesta_L0+0)
	MOVWF       FARG_string_cpyn_destino+1 
	MOVLW       _getRequest+0
	MOVWF       FARG_string_cpyn_origen+0 
	MOVLW       hi_addr(_getRequest+0)
	MOVWF       FARG_string_cpyn_origen+1 
	MOVLW       3
	ADDWF       R0, 0 
	MOVWF       FARG_string_cpyn_size+0 
	CALL        _string_cpyn+0, 0
;TPV.c,965 :: 		string_cpyn(bufferEeprom, getRequest, sizeTotal+sizeKey);
	MOVLW       _bufferEeprom+0
	MOVWF       FARG_string_cpyn_destino+0 
	MOVLW       hi_addr(_bufferEeprom+0)
	MOVWF       FARG_string_cpyn_destino+1 
	MOVLW       _getRequest+0
	MOVWF       FARG_string_cpyn_origen+0 
	MOVLW       hi_addr(_getRequest+0)
	MOVWF       FARG_string_cpyn_origen+1 
	MOVF        Net_Ethernet_28j60_UserTCP_sizeKey_L0+0, 0 
	ADDWF       Net_Ethernet_28j60_UserTCP_sizeTotal_L0+0, 0 
	MOVWF       FARG_string_cpyn_size+0 
	CALL        _string_cpyn+0, 0
;TPV.c,968 :: 		if(string_cmpnc(TCP_CAN_REGISTRAR, &getRequest[sizeTotal], sizeKey)){
	MOVLW       _TCP_CAN_REGISTRAR+0
	MOVWF       FARG_string_cmpnc_text1+0 
	MOVLW       hi_addr(_TCP_CAN_REGISTRAR+0)
	MOVWF       FARG_string_cmpnc_text1+1 
	MOVLW       higher_addr(_TCP_CAN_REGISTRAR+0)
	MOVWF       FARG_string_cmpnc_text1+2 
	MOVLW       _getRequest+0
	MOVWF       FARG_string_cmpnc_text2+0 
	MOVLW       hi_addr(_getRequest+0)
	MOVWF       FARG_string_cmpnc_text2+1 
	MOVF        Net_Ethernet_28j60_UserTCP_sizeTotal_L0+0, 0 
	ADDWF       FARG_string_cmpnc_text2+0, 1 
	BTFSC       STATUS+0, 0 
	INCF        FARG_string_cmpnc_text2+1, 1 
	MOVF        Net_Ethernet_28j60_UserTCP_sizeKey_L0+0, 0 
	MOVWF       FARG_string_cmpnc_bytes+0 
	CALL        _string_cmpnc+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_Net_Ethernet_28j60_UserTCP689
;TPV.c,970 :: 		sizeTotal += sizeKey;
	MOVF        Net_Ethernet_28j60_UserTCP_sizeKey_L0+0, 0 
	ADDWF       Net_Ethernet_28j60_UserTCP_sizeTotal_L0+0, 1 
;TPV.c,971 :: 		estatus = !mysql_search(tablePrepago, prepagoID, idConsulta, &filaAux);
	MOVLW       _tablePrepago+0
	MOVWF       FARG_mysql_search_tabla+0 
	MOVLW       hi_addr(_tablePrepago+0)
	MOVWF       FARG_mysql_search_tabla+1 
	MOVLW       _prepagoId+0
	MOVWF       FARG_mysql_search_columna+0 
	MOVLW       hi_addr(_prepagoId+0)
	MOVWF       FARG_mysql_search_columna+1 
	MOVF        Net_Ethernet_28j60_UserTCP_idConsulta_L0+0, 0 
	MOVWF       FARG_mysql_search_buscar+0 
	MOVF        Net_Ethernet_28j60_UserTCP_idConsulta_L0+1, 0 
	MOVWF       FARG_mysql_search_buscar+1 
	MOVF        Net_Ethernet_28j60_UserTCP_idConsulta_L0+2, 0 
	MOVWF       FARG_mysql_search_buscar+2 
	MOVF        Net_Ethernet_28j60_UserTCP_idConsulta_L0+3, 0 
	MOVWF       FARG_mysql_search_buscar+3 
	MOVLW       Net_Ethernet_28j60_UserTCP_filaAux_L0+0
	MOVWF       FARG_mysql_search_fila+0 
	MOVLW       hi_addr(Net_Ethernet_28j60_UserTCP_filaAux_L0+0)
	MOVWF       FARG_mysql_search_fila+1 
	CALL        _mysql_search+0, 0
	MOVF        R0, 1 
	MOVLW       1
	BTFSS       STATUS+0, 2 
	MOVLW       0
	MOVWF       Net_Ethernet_28j60_UserTCP_estatus_L0+0 
;TPV.c,972 :: 		estatus |= !mysql_search(tableSoporte, soporteID, idConsulta, &filaAux);
	MOVLW       _tableSoporte+0
	MOVWF       FARG_mysql_search_tabla+0 
	MOVLW       hi_addr(_tableSoporte+0)
	MOVWF       FARG_mysql_search_tabla+1 
	MOVLW       _soporteID+0
	MOVWF       FARG_mysql_search_columna+0 
	MOVLW       hi_addr(_soporteID+0)
	MOVWF       FARG_mysql_search_columna+1 
	MOVF        Net_Ethernet_28j60_UserTCP_idConsulta_L0+0, 0 
	MOVWF       FARG_mysql_search_buscar+0 
	MOVF        Net_Ethernet_28j60_UserTCP_idConsulta_L0+1, 0 
	MOVWF       FARG_mysql_search_buscar+1 
	MOVF        Net_Ethernet_28j60_UserTCP_idConsulta_L0+2, 0 
	MOVWF       FARG_mysql_search_buscar+2 
	MOVF        Net_Ethernet_28j60_UserTCP_idConsulta_L0+3, 0 
	MOVWF       FARG_mysql_search_buscar+3 
	MOVLW       Net_Ethernet_28j60_UserTCP_filaAux_L0+0
	MOVWF       FARG_mysql_search_fila+0 
	MOVLW       hi_addr(Net_Ethernet_28j60_UserTCP_filaAux_L0+0)
	MOVWF       FARG_mysql_search_fila+1 
	CALL        _mysql_search+0, 0
	MOVF        R0, 1 
	MOVLW       1
	BTFSS       STATUS+0, 2 
	MOVLW       0
	MOVWF       R1 
	MOVF        R1, 0 
	IORWF       Net_Ethernet_28j60_UserTCP_estatus_L0+0, 1 
;TPV.c,974 :: 		if(result || estatus){
	MOVF        Net_Ethernet_28j60_UserTCP_result_L0+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L__Net_Ethernet_28j60_UserTCP1019
	MOVF        Net_Ethernet_28j60_UserTCP_estatus_L0+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L__Net_Ethernet_28j60_UserTCP1019
	GOTO        L_Net_Ethernet_28j60_UserTCP692
L__Net_Ethernet_28j60_UserTCP1019:
;TPV.c,975 :: 		string_addc(respuesta, result?TCP_TBL_DUPLICADO:TCP_TBL_REG_PREVIO);
	MOVLW       Net_Ethernet_28j60_UserTCP_respuesta_L0+0
	MOVWF       FARG_string_addc_destino+0 
	MOVLW       hi_addr(Net_Ethernet_28j60_UserTCP_respuesta_L0+0)
	MOVWF       FARG_string_addc_destino+1 
	MOVF        Net_Ethernet_28j60_UserTCP_result_L0+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_Net_Ethernet_28j60_UserTCP693
	MOVLW       _TCP_TBL_DUPLICADO+0
	MOVWF       ?FLOC___Net_Ethernet_28j60_UserTCPT2866+0 
	MOVLW       hi_addr(_TCP_TBL_DUPLICADO+0)
	MOVWF       ?FLOC___Net_Ethernet_28j60_UserTCPT2866+1 
	MOVLW       higher_addr(_TCP_TBL_DUPLICADO+0)
	MOVWF       ?FLOC___Net_Ethernet_28j60_UserTCPT2866+2 
	GOTO        L_Net_Ethernet_28j60_UserTCP694
L_Net_Ethernet_28j60_UserTCP693:
	MOVLW       _TCP_TBL_REG_PREVIO+0
	MOVWF       ?FLOC___Net_Ethernet_28j60_UserTCPT2866+0 
	MOVLW       hi_addr(_TCP_TBL_REG_PREVIO+0)
	MOVWF       ?FLOC___Net_Ethernet_28j60_UserTCPT2866+1 
	MOVLW       higher_addr(_TCP_TBL_REG_PREVIO+0)
	MOVWF       ?FLOC___Net_Ethernet_28j60_UserTCPT2866+2 
L_Net_Ethernet_28j60_UserTCP694:
	MOVF        ?FLOC___Net_Ethernet_28j60_UserTCPT2866+0, 0 
	MOVWF       FARG_string_addc_addEnd+0 
	MOVF        ?FLOC___Net_Ethernet_28j60_UserTCPT2866+1, 0 
	MOVWF       FARG_string_addc_addEnd+1 
	MOVF        ?FLOC___Net_Ethernet_28j60_UserTCPT2866+2, 0 
	MOVWF       FARG_string_addc_addEnd+2 
	CALL        _string_addc+0, 0
;TPV.c,976 :: 		bufferEeprom[0] = 0; //FORZAR FINAL DE CADENA
	CLRF        _bufferEeprom+0 
;TPV.c,977 :: 		}else{
	GOTO        L_Net_Ethernet_28j60_UserTCP695
L_Net_Ethernet_28j60_UserTCP692:
;TPV.c,979 :: 		result = !mysql_write(tablePensionados, pensionadosID, -1, idConsulta, true);
	MOVLW       _tablePensionados+0
	MOVWF       FARG_mysql_write_name+0 
	MOVLW       hi_addr(_tablePensionados+0)
	MOVWF       FARG_mysql_write_name+1 
	MOVLW       _pensionadosID+0
	MOVWF       FARG_mysql_write_column+0 
	MOVLW       hi_addr(_pensionadosID+0)
	MOVWF       FARG_mysql_write_column+1 
	MOVLW       255
	MOVWF       FARG_mysql_write_fila+0 
	MOVLW       255
	MOVWF       FARG_mysql_write_fila+1 
	MOVF        Net_Ethernet_28j60_UserTCP_idConsulta_L0+0, 0 
	MOVWF       FARG_mysql_write_value+0 
	MOVF        Net_Ethernet_28j60_UserTCP_idConsulta_L0+1, 0 
	MOVWF       FARG_mysql_write_value+1 
	MOVF        Net_Ethernet_28j60_UserTCP_idConsulta_L0+2, 0 
	MOVWF       FARG_mysql_write_value+2 
	MOVF        Net_Ethernet_28j60_UserTCP_idConsulta_L0+3, 0 
	MOVWF       FARG_mysql_write_value+3 
	MOVLW       1
	MOVWF       FARG_mysql_write_endWrite+0 
	CALL        _mysql_write+0, 0
	MOVF        R0, 1 
	MOVLW       1
	BTFSS       STATUS+0, 2 
	MOVLW       0
	MOVWF       R1 
	MOVF        R1, 0 
	MOVWF       Net_Ethernet_28j60_UserTCP_result_L0+0 
;TPV.c,981 :: 		if(result){
	MOVF        R1, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_Net_Ethernet_28j60_UserTCP696
;TPV.c,982 :: 		mysql_write(tablePensionados,pensionadosVigencia, myTable.rowAct, getRequest[sizeTotal], false);
	MOVLW       _tablePensionados+0
	MOVWF       FARG_mysql_write_name+0 
	MOVLW       hi_addr(_tablePensionados+0)
	MOVWF       FARG_mysql_write_name+1 
	MOVLW       _pensionadosVigencia+0
	MOVWF       FARG_mysql_write_column+0 
	MOVLW       hi_addr(_pensionadosVigencia+0)
	MOVWF       FARG_mysql_write_column+1 
	MOVF        TPV_myTable+4, 0 
	MOVWF       FARG_mysql_write_fila+0 
	MOVF        TPV_myTable+5, 0 
	MOVWF       FARG_mysql_write_fila+1 
	MOVLW       _getRequest+0
	MOVWF       FSR0 
	MOVLW       hi_addr(_getRequest+0)
	MOVWF       FSR0H 
	MOVF        Net_Ethernet_28j60_UserTCP_sizeTotal_L0+0, 0 
	ADDWF       FSR0, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR0H, 1 
	MOVF        POSTINC0+0, 0 
	MOVWF       FARG_mysql_write_value+0 
	MOVLW       0
	MOVWF       FARG_mysql_write_value+1 
	MOVWF       FARG_mysql_write_value+2 
	MOVWF       FARG_mysql_write_value+3 
	MOVLW       0
	MOVWF       FARG_mysql_write_value+1 
	MOVWF       FARG_mysql_write_value+2 
	MOVWF       FARG_mysql_write_value+3 
	CLRF        FARG_mysql_write_endWrite+0 
	CALL        _mysql_write+0, 0
;TPV.c,983 :: 		mysql_write(tablePensionados,pensionadosEstatus, myTable.rowAct, getRequest[sizeTotal+1], false);
	MOVLW       _tablePensionados+0
	MOVWF       FARG_mysql_write_name+0 
	MOVLW       hi_addr(_tablePensionados+0)
	MOVWF       FARG_mysql_write_name+1 
	MOVLW       _pensionadosEstatus+0
	MOVWF       FARG_mysql_write_column+0 
	MOVLW       hi_addr(_pensionadosEstatus+0)
	MOVWF       FARG_mysql_write_column+1 
	MOVF        TPV_myTable+4, 0 
	MOVWF       FARG_mysql_write_fila+0 
	MOVF        TPV_myTable+5, 0 
	MOVWF       FARG_mysql_write_fila+1 
	MOVF        Net_Ethernet_28j60_UserTCP_sizeTotal_L0+0, 0 
	ADDLW       1
	MOVWF       R0 
	CLRF        R1 
	MOVLW       0
	ADDWFC      R1, 1 
	MOVLW       _getRequest+0
	ADDWF       R0, 0 
	MOVWF       FSR0 
	MOVLW       hi_addr(_getRequest+0)
	ADDWFC      R1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       FARG_mysql_write_value+0 
	MOVLW       0
	MOVWF       FARG_mysql_write_value+1 
	MOVWF       FARG_mysql_write_value+2 
	MOVWF       FARG_mysql_write_value+3 
	MOVLW       0
	MOVWF       FARG_mysql_write_value+1 
	MOVWF       FARG_mysql_write_value+2 
	MOVWF       FARG_mysql_write_value+3 
	CLRF        FARG_mysql_write_endWrite+0 
	CALL        _mysql_write+0, 0
;TPV.c,984 :: 		string_addc(respuesta, TCP_TBL_REGISTRADO);
	MOVLW       Net_Ethernet_28j60_UserTCP_respuesta_L0+0
	MOVWF       FARG_string_addc_destino+0 
	MOVLW       hi_addr(Net_Ethernet_28j60_UserTCP_respuesta_L0+0)
	MOVWF       FARG_string_addc_destino+1 
	MOVLW       _TCP_TBL_REGISTRADO+0
	MOVWF       FARG_string_addc_addEnd+0 
	MOVLW       hi_addr(_TCP_TBL_REGISTRADO+0)
	MOVWF       FARG_string_addc_addEnd+1 
	MOVLW       higher_addr(_TCP_TBL_REGISTRADO+0)
	MOVWF       FARG_string_addc_addEnd+2 
	CALL        _string_addc+0, 0
;TPV.c,985 :: 		}else{
	GOTO        L_Net_Ethernet_28j60_UserTCP697
L_Net_Ethernet_28j60_UserTCP696:
;TPV.c,986 :: 		string_addc(respuesta, TCP_TBL_LLENA);
	MOVLW       Net_Ethernet_28j60_UserTCP_respuesta_L0+0
	MOVWF       FARG_string_addc_destino+0 
	MOVLW       hi_addr(Net_Ethernet_28j60_UserTCP_respuesta_L0+0)
	MOVWF       FARG_string_addc_destino+1 
	MOVLW       _TCP_TBL_LLENA+0
	MOVWF       FARG_string_addc_addEnd+0 
	MOVLW       hi_addr(_TCP_TBL_LLENA+0)
	MOVWF       FARG_string_addc_addEnd+1 
	MOVLW       higher_addr(_TCP_TBL_LLENA+0)
	MOVWF       FARG_string_addc_addEnd+2 
	CALL        _string_addc+0, 0
;TPV.c,987 :: 		bufferEeprom[0] = 0; //FORZAR FINAL DE CADENA
	CLRF        _bufferEeprom+0 
;TPV.c,988 :: 		}
L_Net_Ethernet_28j60_UserTCP697:
;TPV.c,989 :: 		}
L_Net_Ethernet_28j60_UserTCP695:
;TPV.c,990 :: 		}else if(string_cmpnc(TCP_CAN_ACTUALIZAR, &getRequest[sizeTotal], sizeKey)){
	GOTO        L_Net_Ethernet_28j60_UserTCP698
L_Net_Ethernet_28j60_UserTCP689:
	MOVLW       _TCP_CAN_ACTUALIZAR+0
	MOVWF       FARG_string_cmpnc_text1+0 
	MOVLW       hi_addr(_TCP_CAN_ACTUALIZAR+0)
	MOVWF       FARG_string_cmpnc_text1+1 
	MOVLW       higher_addr(_TCP_CAN_ACTUALIZAR+0)
	MOVWF       FARG_string_cmpnc_text1+2 
	MOVLW       _getRequest+0
	MOVWF       FARG_string_cmpnc_text2+0 
	MOVLW       hi_addr(_getRequest+0)
	MOVWF       FARG_string_cmpnc_text2+1 
	MOVF        Net_Ethernet_28j60_UserTCP_sizeTotal_L0+0, 0 
	ADDWF       FARG_string_cmpnc_text2+0, 1 
	BTFSC       STATUS+0, 0 
	INCF        FARG_string_cmpnc_text2+1, 1 
	MOVF        Net_Ethernet_28j60_UserTCP_sizeKey_L0+0, 0 
	MOVWF       FARG_string_cmpnc_bytes+0 
	CALL        _string_cmpnc+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_Net_Ethernet_28j60_UserTCP699
;TPV.c,992 :: 		sizeTotal += sizeKey;
	MOVF        Net_Ethernet_28j60_UserTCP_sizeKey_L0+0, 0 
	ADDWF       Net_Ethernet_28j60_UserTCP_sizeTotal_L0+0, 1 
;TPV.c,993 :: 		if(result){
	MOVF        Net_Ethernet_28j60_UserTCP_result_L0+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_Net_Ethernet_28j60_UserTCP700
;TPV.c,995 :: 		string_cpyn(msjConst, &getRequest[sizeTotal], 6);
	MOVLW       _msjConst+0
	MOVWF       FARG_string_cpyn_destino+0 
	MOVLW       hi_addr(_msjConst+0)
	MOVWF       FARG_string_cpyn_destino+1 
	MOVLW       _getRequest+0
	MOVWF       FARG_string_cpyn_origen+0 
	MOVLW       hi_addr(_getRequest+0)
	MOVWF       FARG_string_cpyn_origen+1 
	MOVF        Net_Ethernet_28j60_UserTCP_sizeTotal_L0+0, 0 
	ADDWF       FARG_string_cpyn_origen+0, 1 
	BTFSC       STATUS+0, 0 
	INCF        FARG_string_cpyn_origen+1, 1 
	MOVLW       6
	MOVWF       FARG_string_cpyn_size+0 
	CALL        _string_cpyn+0, 0
;TPV.c,996 :: 		idNuevo = hexToNum(msjConst);
	MOVLW       _msjConst+0
	MOVWF       FARG_hexToNum_hex+0 
	MOVLW       hi_addr(_msjConst+0)
	MOVWF       FARG_hexToNum_hex+1 
	CALL        _hexToNum+0, 0
	MOVF        R0, 0 
	MOVWF       Net_Ethernet_28j60_UserTCP_idNuevo_L0+0 
	MOVF        R1, 0 
	MOVWF       Net_Ethernet_28j60_UserTCP_idNuevo_L0+1 
	MOVF        R2, 0 
	MOVWF       Net_Ethernet_28j60_UserTCP_idNuevo_L0+2 
	MOVF        R3, 0 
	MOVWF       Net_Ethernet_28j60_UserTCP_idNuevo_L0+3 
;TPV.c,997 :: 		if(idNuevo != idConsulta)
	MOVF        R3, 0 
	XORWF       Net_Ethernet_28j60_UserTCP_idConsulta_L0+3, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__Net_Ethernet_28j60_UserTCP1386
	MOVF        R2, 0 
	XORWF       Net_Ethernet_28j60_UserTCP_idConsulta_L0+2, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__Net_Ethernet_28j60_UserTCP1386
	MOVF        R1, 0 
	XORWF       Net_Ethernet_28j60_UserTCP_idConsulta_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__Net_Ethernet_28j60_UserTCP1386
	MOVF        R0, 0 
	XORWF       Net_Ethernet_28j60_UserTCP_idConsulta_L0+0, 0 
L__Net_Ethernet_28j60_UserTCP1386:
	BTFSC       STATUS+0, 2 
	GOTO        L_Net_Ethernet_28j60_UserTCP701
;TPV.c,998 :: 		result = !mysql_write(tablePensionados, pensionadosID, fila, idNuevo, false);
	MOVLW       _tablePensionados+0
	MOVWF       FARG_mysql_write_name+0 
	MOVLW       hi_addr(_tablePensionados+0)
	MOVWF       FARG_mysql_write_name+1 
	MOVLW       _pensionadosID+0
	MOVWF       FARG_mysql_write_column+0 
	MOVLW       hi_addr(_pensionadosID+0)
	MOVWF       FARG_mysql_write_column+1 
	MOVF        Net_Ethernet_28j60_UserTCP_fila_L0+0, 0 
	MOVWF       FARG_mysql_write_fila+0 
	MOVF        Net_Ethernet_28j60_UserTCP_fila_L0+1, 0 
	MOVWF       FARG_mysql_write_fila+1 
	MOVF        Net_Ethernet_28j60_UserTCP_idNuevo_L0+0, 0 
	MOVWF       FARG_mysql_write_value+0 
	MOVF        Net_Ethernet_28j60_UserTCP_idNuevo_L0+1, 0 
	MOVWF       FARG_mysql_write_value+1 
	MOVF        Net_Ethernet_28j60_UserTCP_idNuevo_L0+2, 0 
	MOVWF       FARG_mysql_write_value+2 
	MOVF        Net_Ethernet_28j60_UserTCP_idNuevo_L0+3, 0 
	MOVWF       FARG_mysql_write_value+3 
	CLRF        FARG_mysql_write_endWrite+0 
	CALL        _mysql_write+0, 0
	MOVF        R0, 1 
	MOVLW       1
	BTFSS       STATUS+0, 2 
	MOVLW       0
	MOVWF       Net_Ethernet_28j60_UserTCP_result_L0+0 
L_Net_Ethernet_28j60_UserTCP701:
;TPV.c,999 :: 		result = !mysql_write(tablePensionados, pensionadosVigencia, fila, getRequest[sizeTotal+6], false);
	MOVLW       _tablePensionados+0
	MOVWF       FARG_mysql_write_name+0 
	MOVLW       hi_addr(_tablePensionados+0)
	MOVWF       FARG_mysql_write_name+1 
	MOVLW       _pensionadosVigencia+0
	MOVWF       FARG_mysql_write_column+0 
	MOVLW       hi_addr(_pensionadosVigencia+0)
	MOVWF       FARG_mysql_write_column+1 
	MOVF        Net_Ethernet_28j60_UserTCP_fila_L0+0, 0 
	MOVWF       FARG_mysql_write_fila+0 
	MOVF        Net_Ethernet_28j60_UserTCP_fila_L0+1, 0 
	MOVWF       FARG_mysql_write_fila+1 
	MOVLW       6
	ADDWF       Net_Ethernet_28j60_UserTCP_sizeTotal_L0+0, 0 
	MOVWF       R0 
	CLRF        R1 
	MOVLW       0
	ADDWFC      R1, 1 
	MOVLW       _getRequest+0
	ADDWF       R0, 0 
	MOVWF       FSR0 
	MOVLW       hi_addr(_getRequest+0)
	ADDWFC      R1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       FARG_mysql_write_value+0 
	MOVLW       0
	MOVWF       FARG_mysql_write_value+1 
	MOVWF       FARG_mysql_write_value+2 
	MOVWF       FARG_mysql_write_value+3 
	MOVLW       0
	MOVWF       FARG_mysql_write_value+1 
	MOVWF       FARG_mysql_write_value+2 
	MOVWF       FARG_mysql_write_value+3 
	CLRF        FARG_mysql_write_endWrite+0 
	CALL        _mysql_write+0, 0
	MOVF        R0, 1 
	MOVLW       1
	BTFSS       STATUS+0, 2 
	MOVLW       0
	MOVWF       Net_Ethernet_28j60_UserTCP_result_L0+0 
;TPV.c,1000 :: 		result = !mysql_write(tablePensionados, pensionadosEstatus, fila, getRequest[sizeTotal+7], false);
	MOVLW       _tablePensionados+0
	MOVWF       FARG_mysql_write_name+0 
	MOVLW       hi_addr(_tablePensionados+0)
	MOVWF       FARG_mysql_write_name+1 
	MOVLW       _pensionadosEstatus+0
	MOVWF       FARG_mysql_write_column+0 
	MOVLW       hi_addr(_pensionadosEstatus+0)
	MOVWF       FARG_mysql_write_column+1 
	MOVF        Net_Ethernet_28j60_UserTCP_fila_L0+0, 0 
	MOVWF       FARG_mysql_write_fila+0 
	MOVF        Net_Ethernet_28j60_UserTCP_fila_L0+1, 0 
	MOVWF       FARG_mysql_write_fila+1 
	MOVLW       7
	ADDWF       Net_Ethernet_28j60_UserTCP_sizeTotal_L0+0, 0 
	MOVWF       R0 
	CLRF        R1 
	MOVLW       0
	ADDWFC      R1, 1 
	MOVLW       _getRequest+0
	ADDWF       R0, 0 
	MOVWF       FSR0 
	MOVLW       hi_addr(_getRequest+0)
	ADDWFC      R1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       FARG_mysql_write_value+0 
	MOVLW       0
	MOVWF       FARG_mysql_write_value+1 
	MOVWF       FARG_mysql_write_value+2 
	MOVWF       FARG_mysql_write_value+3 
	MOVLW       0
	MOVWF       FARG_mysql_write_value+1 
	MOVWF       FARG_mysql_write_value+2 
	MOVWF       FARG_mysql_write_value+3 
	CLRF        FARG_mysql_write_endWrite+0 
	CALL        _mysql_write+0, 0
	MOVF        R0, 1 
	MOVLW       1
	BTFSS       STATUS+0, 2 
	MOVLW       0
	MOVWF       R1 
	MOVF        R1, 0 
	MOVWF       Net_Ethernet_28j60_UserTCP_result_L0+0 
;TPV.c,1002 :: 		string_addc(respuesta, result?TCP_TBL_MODIFICADO:TCP_TBL_ERROR);
	MOVLW       Net_Ethernet_28j60_UserTCP_respuesta_L0+0
	MOVWF       FARG_string_addc_destino+0 
	MOVLW       hi_addr(Net_Ethernet_28j60_UserTCP_respuesta_L0+0)
	MOVWF       FARG_string_addc_destino+1 
	MOVF        R1, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_Net_Ethernet_28j60_UserTCP702
	MOVLW       _TCP_TBL_MODIFICADO+0
	MOVWF       ?FLOC___Net_Ethernet_28j60_UserTCPT2924+0 
	MOVLW       hi_addr(_TCP_TBL_MODIFICADO+0)
	MOVWF       ?FLOC___Net_Ethernet_28j60_UserTCPT2924+1 
	MOVLW       higher_addr(_TCP_TBL_MODIFICADO+0)
	MOVWF       ?FLOC___Net_Ethernet_28j60_UserTCPT2924+2 
	GOTO        L_Net_Ethernet_28j60_UserTCP703
L_Net_Ethernet_28j60_UserTCP702:
	MOVLW       _TCP_TBL_ERROR+0
	MOVWF       ?FLOC___Net_Ethernet_28j60_UserTCPT2924+0 
	MOVLW       hi_addr(_TCP_TBL_ERROR+0)
	MOVWF       ?FLOC___Net_Ethernet_28j60_UserTCPT2924+1 
	MOVLW       higher_addr(_TCP_TBL_ERROR+0)
	MOVWF       ?FLOC___Net_Ethernet_28j60_UserTCPT2924+2 
L_Net_Ethernet_28j60_UserTCP703:
	MOVF        ?FLOC___Net_Ethernet_28j60_UserTCPT2924+0, 0 
	MOVWF       FARG_string_addc_addEnd+0 
	MOVF        ?FLOC___Net_Ethernet_28j60_UserTCPT2924+1, 0 
	MOVWF       FARG_string_addc_addEnd+1 
	MOVF        ?FLOC___Net_Ethernet_28j60_UserTCPT2924+2, 0 
	MOVWF       FARG_string_addc_addEnd+2 
	CALL        _string_addc+0, 0
;TPV.c,1003 :: 		if(!result)
	MOVF        Net_Ethernet_28j60_UserTCP_result_L0+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_Net_Ethernet_28j60_UserTCP704
;TPV.c,1004 :: 		bufferEeprom[0] = 0; //FORZAR FINAL DE CADENA
	CLRF        _bufferEeprom+0 
L_Net_Ethernet_28j60_UserTCP704:
;TPV.c,1005 :: 		}else{
	GOTO        L_Net_Ethernet_28j60_UserTCP705
L_Net_Ethernet_28j60_UserTCP700:
;TPV.c,1006 :: 		string_addc(respuesta, TCP_TBL_NO_FOUND);
	MOVLW       Net_Ethernet_28j60_UserTCP_respuesta_L0+0
	MOVWF       FARG_string_addc_destino+0 
	MOVLW       hi_addr(Net_Ethernet_28j60_UserTCP_respuesta_L0+0)
	MOVWF       FARG_string_addc_destino+1 
	MOVLW       _TCP_TBL_NO_FOUND+0
	MOVWF       FARG_string_addc_addEnd+0 
	MOVLW       hi_addr(_TCP_TBL_NO_FOUND+0)
	MOVWF       FARG_string_addc_addEnd+1 
	MOVLW       higher_addr(_TCP_TBL_NO_FOUND+0)
	MOVWF       FARG_string_addc_addEnd+2 
	CALL        _string_addc+0, 0
;TPV.c,1007 :: 		bufferEeprom[0] = 0; //FORZAR FINAL DE CADENA
	CLRF        _bufferEeprom+0 
;TPV.c,1008 :: 		}
L_Net_Ethernet_28j60_UserTCP705:
;TPV.c,1009 :: 		}else if(string_cmpnc(TCP_CAN_CONSULTAR, &getRequest[sizeTotal], sizeKey)){
	GOTO        L_Net_Ethernet_28j60_UserTCP706
L_Net_Ethernet_28j60_UserTCP699:
	MOVLW       _TCP_CAN_CONSULTAR+0
	MOVWF       FARG_string_cmpnc_text1+0 
	MOVLW       hi_addr(_TCP_CAN_CONSULTAR+0)
	MOVWF       FARG_string_cmpnc_text1+1 
	MOVLW       higher_addr(_TCP_CAN_CONSULTAR+0)
	MOVWF       FARG_string_cmpnc_text1+2 
	MOVLW       _getRequest+0
	MOVWF       FARG_string_cmpnc_text2+0 
	MOVLW       hi_addr(_getRequest+0)
	MOVWF       FARG_string_cmpnc_text2+1 
	MOVF        Net_Ethernet_28j60_UserTCP_sizeTotal_L0+0, 0 
	ADDWF       FARG_string_cmpnc_text2+0, 1 
	BTFSC       STATUS+0, 0 
	INCF        FARG_string_cmpnc_text2+1, 1 
	MOVF        Net_Ethernet_28j60_UserTCP_sizeKey_L0+0, 0 
	MOVWF       FARG_string_cmpnc_bytes+0 
	CALL        _string_cmpnc+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_Net_Ethernet_28j60_UserTCP707
;TPV.c,1011 :: 		sizeTotal += sizeKey;
	MOVF        Net_Ethernet_28j60_UserTCP_sizeKey_L0+0, 0 
	ADDWF       Net_Ethernet_28j60_UserTCP_sizeTotal_L0+0, 1 
;TPV.c,1012 :: 		if(result){
	MOVF        Net_Ethernet_28j60_UserTCP_result_L0+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_Net_Ethernet_28j60_UserTCP708
;TPV.c,1013 :: 		mysql_read_string(tablePensionados, pensionadosVigencia, fila, &result);
	MOVLW       _tablePensionados+0
	MOVWF       FARG_mysql_read_string_name+0 
	MOVLW       hi_addr(_tablePensionados+0)
	MOVWF       FARG_mysql_read_string_name+1 
	MOVLW       _pensionadosVigencia+0
	MOVWF       FARG_mysql_read_string_column+0 
	MOVLW       hi_addr(_pensionadosVigencia+0)
	MOVWF       FARG_mysql_read_string_column+1 
	MOVF        Net_Ethernet_28j60_UserTCP_fila_L0+0, 0 
	MOVWF       FARG_mysql_read_string_fila+0 
	MOVF        Net_Ethernet_28j60_UserTCP_fila_L0+1, 0 
	MOVWF       FARG_mysql_read_string_fila+1 
	MOVLW       Net_Ethernet_28j60_UserTCP_result_L0+0
	MOVWF       FARG_mysql_read_string_result+0 
	MOVLW       hi_addr(Net_Ethernet_28j60_UserTCP_result_L0+0)
	MOVWF       FARG_mysql_read_string_result+1 
	CALL        _mysql_read_string+0, 0
;TPV.c,1014 :: 		string_push(respuesta, result);
	MOVLW       Net_Ethernet_28j60_UserTCP_respuesta_L0+0
	MOVWF       FARG_string_push_texto+0 
	MOVLW       hi_addr(Net_Ethernet_28j60_UserTCP_respuesta_L0+0)
	MOVWF       FARG_string_push_texto+1 
	MOVF        Net_Ethernet_28j60_UserTCP_result_L0+0, 0 
	MOVWF       FARG_string_push_caracter+0 
	CALL        _string_push+0, 0
;TPV.c,1015 :: 		mysql_read_string(tablePensionados, pensionadosEstatus, fila, &result);
	MOVLW       _tablePensionados+0
	MOVWF       FARG_mysql_read_string_name+0 
	MOVLW       hi_addr(_tablePensionados+0)
	MOVWF       FARG_mysql_read_string_name+1 
	MOVLW       _pensionadosEstatus+0
	MOVWF       FARG_mysql_read_string_column+0 
	MOVLW       hi_addr(_pensionadosEstatus+0)
	MOVWF       FARG_mysql_read_string_column+1 
	MOVF        Net_Ethernet_28j60_UserTCP_fila_L0+0, 0 
	MOVWF       FARG_mysql_read_string_fila+0 
	MOVF        Net_Ethernet_28j60_UserTCP_fila_L0+1, 0 
	MOVWF       FARG_mysql_read_string_fila+1 
	MOVLW       Net_Ethernet_28j60_UserTCP_result_L0+0
	MOVWF       FARG_mysql_read_string_result+0 
	MOVLW       hi_addr(Net_Ethernet_28j60_UserTCP_result_L0+0)
	MOVWF       FARG_mysql_read_string_result+1 
	CALL        _mysql_read_string+0, 0
;TPV.c,1016 :: 		string_push(respuesta, result);
	MOVLW       Net_Ethernet_28j60_UserTCP_respuesta_L0+0
	MOVWF       FARG_string_push_texto+0 
	MOVLW       hi_addr(Net_Ethernet_28j60_UserTCP_respuesta_L0+0)
	MOVWF       FARG_string_push_texto+1 
	MOVF        Net_Ethernet_28j60_UserTCP_result_L0+0, 0 
	MOVWF       FARG_string_push_caracter+0 
	CALL        _string_push+0, 0
;TPV.c,1017 :: 		string_addc(respuesta, TCP_CAN_MODULE);
	MOVLW       Net_Ethernet_28j60_UserTCP_respuesta_L0+0
	MOVWF       FARG_string_addc_destino+0 
	MOVLW       hi_addr(Net_Ethernet_28j60_UserTCP_respuesta_L0+0)
	MOVWF       FARG_string_addc_destino+1 
	MOVLW       _TCP_CAN_MODULE+0
	MOVWF       FARG_string_addc_addEnd+0 
	MOVLW       hi_addr(_TCP_CAN_MODULE+0)
	MOVWF       FARG_string_addc_addEnd+1 
	MOVLW       higher_addr(_TCP_CAN_MODULE+0)
	MOVWF       FARG_string_addc_addEnd+2 
	CALL        _string_addc+0, 0
;TPV.c,1018 :: 		numToHex(can.id, msjConst, 1);
	MOVF        _can+12, 0 
	MOVWF       FARG_numToHex_valor+0 
	MOVLW       0
	MOVWF       FARG_numToHex_valor+1 
	MOVWF       FARG_numToHex_valor+2 
	MOVWF       FARG_numToHex_valor+3 
	MOVLW       _msjConst+0
	MOVWF       FARG_numToHex_cadena+0 
	MOVLW       hi_addr(_msjConst+0)
	MOVWF       FARG_numToHex_cadena+1 
	MOVLW       1
	MOVWF       FARG_numToHex_bytes+0 
	CALL        _numToHex+0, 0
;TPV.c,1019 :: 		string_add(respuesta, msjConst);
	MOVLW       Net_Ethernet_28j60_UserTCP_respuesta_L0+0
	MOVWF       FARG_string_add_destino+0 
	MOVLW       hi_addr(Net_Ethernet_28j60_UserTCP_respuesta_L0+0)
	MOVWF       FARG_string_add_destino+1 
	MOVLW       _msjConst+0
	MOVWF       FARG_string_add_addEnd+0 
	MOVLW       hi_addr(_msjConst+0)
	MOVWF       FARG_string_add_addEnd+1 
	CALL        _string_add+0, 0
;TPV.c,1020 :: 		}else{
	GOTO        L_Net_Ethernet_28j60_UserTCP709
L_Net_Ethernet_28j60_UserTCP708:
;TPV.c,1021 :: 		string_addc(respuesta, TCP_TBL_NO_FOUND);
	MOVLW       Net_Ethernet_28j60_UserTCP_respuesta_L0+0
	MOVWF       FARG_string_addc_destino+0 
	MOVLW       hi_addr(Net_Ethernet_28j60_UserTCP_respuesta_L0+0)
	MOVWF       FARG_string_addc_destino+1 
	MOVLW       _TCP_TBL_NO_FOUND+0
	MOVWF       FARG_string_addc_addEnd+0 
	MOVLW       hi_addr(_TCP_TBL_NO_FOUND+0)
	MOVWF       FARG_string_addc_addEnd+1 
	MOVLW       higher_addr(_TCP_TBL_NO_FOUND+0)
	MOVWF       FARG_string_addc_addEnd+2 
	CALL        _string_addc+0, 0
;TPV.c,1022 :: 		bufferEeprom[0] = 0; //FORZAR FINAL DE CADENA
	CLRF        _bufferEeprom+0 
;TPV.c,1023 :: 		}
L_Net_Ethernet_28j60_UserTCP709:
;TPV.c,1024 :: 		}else if(string_cmpnc(TCP_CAN_VIGENCIA, &getRequest[sizeTotal], sizeKey)){
	GOTO        L_Net_Ethernet_28j60_UserTCP710
L_Net_Ethernet_28j60_UserTCP707:
	MOVLW       _TCP_CAN_VIGENCIA+0
	MOVWF       FARG_string_cmpnc_text1+0 
	MOVLW       hi_addr(_TCP_CAN_VIGENCIA+0)
	MOVWF       FARG_string_cmpnc_text1+1 
	MOVLW       higher_addr(_TCP_CAN_VIGENCIA+0)
	MOVWF       FARG_string_cmpnc_text1+2 
	MOVLW       _getRequest+0
	MOVWF       FARG_string_cmpnc_text2+0 
	MOVLW       hi_addr(_getRequest+0)
	MOVWF       FARG_string_cmpnc_text2+1 
	MOVF        Net_Ethernet_28j60_UserTCP_sizeTotal_L0+0, 0 
	ADDWF       FARG_string_cmpnc_text2+0, 1 
	BTFSC       STATUS+0, 0 
	INCF        FARG_string_cmpnc_text2+1, 1 
	MOVF        Net_Ethernet_28j60_UserTCP_sizeKey_L0+0, 0 
	MOVWF       FARG_string_cmpnc_bytes+0 
	CALL        _string_cmpnc+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_Net_Ethernet_28j60_UserTCP711
;TPV.c,1026 :: 		sizeTotal += sizeKey;
	MOVF        Net_Ethernet_28j60_UserTCP_sizeKey_L0+0, 0 
	ADDWF       Net_Ethernet_28j60_UserTCP_sizeTotal_L0+0, 1 
;TPV.c,1027 :: 		if(result){
	MOVF        Net_Ethernet_28j60_UserTCP_result_L0+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_Net_Ethernet_28j60_UserTCP712
;TPV.c,1028 :: 		result = !mysql_write(tablePensionados, pensionadosVigencia, fila, getRequest[sizeTotal], false);
	MOVLW       _tablePensionados+0
	MOVWF       FARG_mysql_write_name+0 
	MOVLW       hi_addr(_tablePensionados+0)
	MOVWF       FARG_mysql_write_name+1 
	MOVLW       _pensionadosVigencia+0
	MOVWF       FARG_mysql_write_column+0 
	MOVLW       hi_addr(_pensionadosVigencia+0)
	MOVWF       FARG_mysql_write_column+1 
	MOVF        Net_Ethernet_28j60_UserTCP_fila_L0+0, 0 
	MOVWF       FARG_mysql_write_fila+0 
	MOVF        Net_Ethernet_28j60_UserTCP_fila_L0+1, 0 
	MOVWF       FARG_mysql_write_fila+1 
	MOVLW       _getRequest+0
	MOVWF       FSR0 
	MOVLW       hi_addr(_getRequest+0)
	MOVWF       FSR0H 
	MOVF        Net_Ethernet_28j60_UserTCP_sizeTotal_L0+0, 0 
	ADDWF       FSR0, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR0H, 1 
	MOVF        POSTINC0+0, 0 
	MOVWF       FARG_mysql_write_value+0 
	MOVLW       0
	MOVWF       FARG_mysql_write_value+1 
	MOVWF       FARG_mysql_write_value+2 
	MOVWF       FARG_mysql_write_value+3 
	MOVLW       0
	MOVWF       FARG_mysql_write_value+1 
	MOVWF       FARG_mysql_write_value+2 
	MOVWF       FARG_mysql_write_value+3 
	CLRF        FARG_mysql_write_endWrite+0 
	CALL        _mysql_write+0, 0
	MOVF        R0, 1 
	MOVLW       1
	BTFSS       STATUS+0, 2 
	MOVLW       0
	MOVWF       R1 
	MOVF        R1, 0 
	MOVWF       Net_Ethernet_28j60_UserTCP_result_L0+0 
;TPV.c,1030 :: 		string_addc(respuesta, result?TCP_TBL_MODIFICADO:TCP_TBL_ERROR);
	MOVLW       Net_Ethernet_28j60_UserTCP_respuesta_L0+0
	MOVWF       FARG_string_addc_destino+0 
	MOVLW       hi_addr(Net_Ethernet_28j60_UserTCP_respuesta_L0+0)
	MOVWF       FARG_string_addc_destino+1 
	MOVF        R1, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_Net_Ethernet_28j60_UserTCP713
	MOVLW       _TCP_TBL_MODIFICADO+0
	MOVWF       ?FLOC___Net_Ethernet_28j60_UserTCPT2968+0 
	MOVLW       hi_addr(_TCP_TBL_MODIFICADO+0)
	MOVWF       ?FLOC___Net_Ethernet_28j60_UserTCPT2968+1 
	MOVLW       higher_addr(_TCP_TBL_MODIFICADO+0)
	MOVWF       ?FLOC___Net_Ethernet_28j60_UserTCPT2968+2 
	GOTO        L_Net_Ethernet_28j60_UserTCP714
L_Net_Ethernet_28j60_UserTCP713:
	MOVLW       _TCP_TBL_ERROR+0
	MOVWF       ?FLOC___Net_Ethernet_28j60_UserTCPT2968+0 
	MOVLW       hi_addr(_TCP_TBL_ERROR+0)
	MOVWF       ?FLOC___Net_Ethernet_28j60_UserTCPT2968+1 
	MOVLW       higher_addr(_TCP_TBL_ERROR+0)
	MOVWF       ?FLOC___Net_Ethernet_28j60_UserTCPT2968+2 
L_Net_Ethernet_28j60_UserTCP714:
	MOVF        ?FLOC___Net_Ethernet_28j60_UserTCPT2968+0, 0 
	MOVWF       FARG_string_addc_addEnd+0 
	MOVF        ?FLOC___Net_Ethernet_28j60_UserTCPT2968+1, 0 
	MOVWF       FARG_string_addc_addEnd+1 
	MOVF        ?FLOC___Net_Ethernet_28j60_UserTCPT2968+2, 0 
	MOVWF       FARG_string_addc_addEnd+2 
	CALL        _string_addc+0, 0
;TPV.c,1031 :: 		if(!result)
	MOVF        Net_Ethernet_28j60_UserTCP_result_L0+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_Net_Ethernet_28j60_UserTCP715
;TPV.c,1032 :: 		bufferEeprom[0] = 0; //FORZAR FINAL DE CADENA
	CLRF        _bufferEeprom+0 
L_Net_Ethernet_28j60_UserTCP715:
;TPV.c,1033 :: 		}else{
	GOTO        L_Net_Ethernet_28j60_UserTCP716
L_Net_Ethernet_28j60_UserTCP712:
;TPV.c,1034 :: 		string_addc(respuesta,TCP_TBL_NO_FOUND);
	MOVLW       Net_Ethernet_28j60_UserTCP_respuesta_L0+0
	MOVWF       FARG_string_addc_destino+0 
	MOVLW       hi_addr(Net_Ethernet_28j60_UserTCP_respuesta_L0+0)
	MOVWF       FARG_string_addc_destino+1 
	MOVLW       _TCP_TBL_NO_FOUND+0
	MOVWF       FARG_string_addc_addEnd+0 
	MOVLW       hi_addr(_TCP_TBL_NO_FOUND+0)
	MOVWF       FARG_string_addc_addEnd+1 
	MOVLW       higher_addr(_TCP_TBL_NO_FOUND+0)
	MOVWF       FARG_string_addc_addEnd+2 
	CALL        _string_addc+0, 0
;TPV.c,1035 :: 		bufferEeprom[0] = 0; //FORZAR FINAL DE CADENA
	CLRF        _bufferEeprom+0 
;TPV.c,1036 :: 		}
L_Net_Ethernet_28j60_UserTCP716:
;TPV.c,1037 :: 		}else if(string_cmpnc(TCP_CAN_PASSBACK, &getRequest[sizeTotal], sizeKey)){
	GOTO        L_Net_Ethernet_28j60_UserTCP717
L_Net_Ethernet_28j60_UserTCP711:
	MOVLW       _TCP_CAN_PASSBACK+0
	MOVWF       FARG_string_cmpnc_text1+0 
	MOVLW       hi_addr(_TCP_CAN_PASSBACK+0)
	MOVWF       FARG_string_cmpnc_text1+1 
	MOVLW       higher_addr(_TCP_CAN_PASSBACK+0)
	MOVWF       FARG_string_cmpnc_text1+2 
	MOVLW       _getRequest+0
	MOVWF       FARG_string_cmpnc_text2+0 
	MOVLW       hi_addr(_getRequest+0)
	MOVWF       FARG_string_cmpnc_text2+1 
	MOVF        Net_Ethernet_28j60_UserTCP_sizeTotal_L0+0, 0 
	ADDWF       FARG_string_cmpnc_text2+0, 1 
	BTFSC       STATUS+0, 0 
	INCF        FARG_string_cmpnc_text2+1, 1 
	MOVF        Net_Ethernet_28j60_UserTCP_sizeKey_L0+0, 0 
	MOVWF       FARG_string_cmpnc_bytes+0 
	CALL        _string_cmpnc+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_Net_Ethernet_28j60_UserTCP718
;TPV.c,1039 :: 		sizeTotal += sizeKey;
	MOVF        Net_Ethernet_28j60_UserTCP_sizeKey_L0+0, 0 
	ADDWF       Net_Ethernet_28j60_UserTCP_sizeTotal_L0+0, 1 
;TPV.c,1040 :: 		if(result){
	MOVF        Net_Ethernet_28j60_UserTCP_result_L0+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_Net_Ethernet_28j60_UserTCP719
;TPV.c,1041 :: 		result = !mysql_write(tablePensionados, pensionadosEstatus, fila, getRequest[sizeTotal], false);
	MOVLW       _tablePensionados+0
	MOVWF       FARG_mysql_write_name+0 
	MOVLW       hi_addr(_tablePensionados+0)
	MOVWF       FARG_mysql_write_name+1 
	MOVLW       _pensionadosEstatus+0
	MOVWF       FARG_mysql_write_column+0 
	MOVLW       hi_addr(_pensionadosEstatus+0)
	MOVWF       FARG_mysql_write_column+1 
	MOVF        Net_Ethernet_28j60_UserTCP_fila_L0+0, 0 
	MOVWF       FARG_mysql_write_fila+0 
	MOVF        Net_Ethernet_28j60_UserTCP_fila_L0+1, 0 
	MOVWF       FARG_mysql_write_fila+1 
	MOVLW       _getRequest+0
	MOVWF       FSR0 
	MOVLW       hi_addr(_getRequest+0)
	MOVWF       FSR0H 
	MOVF        Net_Ethernet_28j60_UserTCP_sizeTotal_L0+0, 0 
	ADDWF       FSR0, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR0H, 1 
	MOVF        POSTINC0+0, 0 
	MOVWF       FARG_mysql_write_value+0 
	MOVLW       0
	MOVWF       FARG_mysql_write_value+1 
	MOVWF       FARG_mysql_write_value+2 
	MOVWF       FARG_mysql_write_value+3 
	MOVLW       0
	MOVWF       FARG_mysql_write_value+1 
	MOVWF       FARG_mysql_write_value+2 
	MOVWF       FARG_mysql_write_value+3 
	CLRF        FARG_mysql_write_endWrite+0 
	CALL        _mysql_write+0, 0
	MOVF        R0, 1 
	MOVLW       1
	BTFSS       STATUS+0, 2 
	MOVLW       0
	MOVWF       R1 
	MOVF        R1, 0 
	MOVWF       Net_Ethernet_28j60_UserTCP_result_L0+0 
;TPV.c,1043 :: 		string_addc(respuesta, result?TCP_TBL_MODIFICADO:TCP_TBL_ERROR);
	MOVLW       Net_Ethernet_28j60_UserTCP_respuesta_L0+0
	MOVWF       FARG_string_addc_destino+0 
	MOVLW       hi_addr(Net_Ethernet_28j60_UserTCP_respuesta_L0+0)
	MOVWF       FARG_string_addc_destino+1 
	MOVF        R1, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_Net_Ethernet_28j60_UserTCP720
	MOVLW       _TCP_TBL_MODIFICADO+0
	MOVWF       ?FLOC___Net_Ethernet_28j60_UserTCPT2990+0 
	MOVLW       hi_addr(_TCP_TBL_MODIFICADO+0)
	MOVWF       ?FLOC___Net_Ethernet_28j60_UserTCPT2990+1 
	MOVLW       higher_addr(_TCP_TBL_MODIFICADO+0)
	MOVWF       ?FLOC___Net_Ethernet_28j60_UserTCPT2990+2 
	GOTO        L_Net_Ethernet_28j60_UserTCP721
L_Net_Ethernet_28j60_UserTCP720:
	MOVLW       _TCP_TBL_ERROR+0
	MOVWF       ?FLOC___Net_Ethernet_28j60_UserTCPT2990+0 
	MOVLW       hi_addr(_TCP_TBL_ERROR+0)
	MOVWF       ?FLOC___Net_Ethernet_28j60_UserTCPT2990+1 
	MOVLW       higher_addr(_TCP_TBL_ERROR+0)
	MOVWF       ?FLOC___Net_Ethernet_28j60_UserTCPT2990+2 
L_Net_Ethernet_28j60_UserTCP721:
	MOVF        ?FLOC___Net_Ethernet_28j60_UserTCPT2990+0, 0 
	MOVWF       FARG_string_addc_addEnd+0 
	MOVF        ?FLOC___Net_Ethernet_28j60_UserTCPT2990+1, 0 
	MOVWF       FARG_string_addc_addEnd+1 
	MOVF        ?FLOC___Net_Ethernet_28j60_UserTCPT2990+2, 0 
	MOVWF       FARG_string_addc_addEnd+2 
	CALL        _string_addc+0, 0
;TPV.c,1044 :: 		if(!result)
	MOVF        Net_Ethernet_28j60_UserTCP_result_L0+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_Net_Ethernet_28j60_UserTCP722
;TPV.c,1045 :: 		bufferEeprom[0] = 0; //FORZAR FINAL DE CADENA
	CLRF        _bufferEeprom+0 
L_Net_Ethernet_28j60_UserTCP722:
;TPV.c,1046 :: 		}else{
	GOTO        L_Net_Ethernet_28j60_UserTCP723
L_Net_Ethernet_28j60_UserTCP719:
;TPV.c,1047 :: 		string_addc(respuesta,TCP_TBL_NO_FOUND);
	MOVLW       Net_Ethernet_28j60_UserTCP_respuesta_L0+0
	MOVWF       FARG_string_addc_destino+0 
	MOVLW       hi_addr(Net_Ethernet_28j60_UserTCP_respuesta_L0+0)
	MOVWF       FARG_string_addc_destino+1 
	MOVLW       _TCP_TBL_NO_FOUND+0
	MOVWF       FARG_string_addc_addEnd+0 
	MOVLW       hi_addr(_TCP_TBL_NO_FOUND+0)
	MOVWF       FARG_string_addc_addEnd+1 
	MOVLW       higher_addr(_TCP_TBL_NO_FOUND+0)
	MOVWF       FARG_string_addc_addEnd+2 
	CALL        _string_addc+0, 0
;TPV.c,1048 :: 		bufferEeprom[0] = 0; //FORZAR FINAL DE CADENA
	CLRF        _bufferEeprom+0 
;TPV.c,1049 :: 		}
L_Net_Ethernet_28j60_UserTCP723:
;TPV.c,1050 :: 		}else{
	GOTO        L_Net_Ethernet_28j60_UserTCP724
L_Net_Ethernet_28j60_UserTCP718:
;TPV.c,1051 :: 		bufferEeprom[0] = 0; //FORZAR FINAL DE CADENA
	CLRF        _bufferEeprom+0 
;TPV.c,1052 :: 		}
L_Net_Ethernet_28j60_UserTCP724:
L_Net_Ethernet_28j60_UserTCP717:
L_Net_Ethernet_28j60_UserTCP710:
L_Net_Ethernet_28j60_UserTCP706:
L_Net_Ethernet_28j60_UserTCP698:
;TPV.c,1054 :: 		if(string_len(bufferEeprom) != 0){
	MOVLW       _bufferEeprom+0
	MOVWF       FARG_string_len_texto+0 
	MOVLW       hi_addr(_bufferEeprom+0)
	MOVWF       FARG_string_len_texto+1 
	CALL        _string_len+0, 0
	MOVF        R0, 0 
	XORLW       0
	BTFSC       STATUS+0, 2 
	GOTO        L_Net_Ethernet_28j60_UserTCP725
;TPV.c,1055 :: 		numToString(fila, msjConst, 4);
	MOVF        Net_Ethernet_28j60_UserTCP_fila_L0+0, 0 
	MOVWF       FARG_numToString_valor+0 
	MOVF        Net_Ethernet_28j60_UserTCP_fila_L0+1, 0 
	MOVWF       FARG_numToString_valor+1 
	MOVLW       0
	BTFSC       Net_Ethernet_28j60_UserTCP_fila_L0+1, 7 
	MOVLW       255
	MOVWF       FARG_numToString_valor+2 
	MOVWF       FARG_numToString_valor+3 
	MOVLW       _msjConst+0
	MOVWF       FARG_numToString_cadena+0 
	MOVLW       hi_addr(_msjConst+0)
	MOVWF       FARG_numToString_cadena+1 
	MOVLW       4
	MOVWF       FARG_numToString_digitos+0 
	CALL        _numToString+0, 0
;TPV.c,1056 :: 		string_add(bufferEeprom, msjConst);
	MOVLW       _bufferEeprom+0
	MOVWF       FARG_string_add_destino+0 
	MOVLW       hi_addr(_bufferEeprom+0)
	MOVWF       FARG_string_add_destino+1 
	MOVLW       _msjConst+0
	MOVWF       FARG_string_add_addEnd+0 
	MOVLW       hi_addr(_msjConst+0)
	MOVWF       FARG_string_add_addEnd+1 
	CALL        _string_add+0, 0
;TPV.c,1057 :: 		string_add(bufferEeprom, &getRequest[sizeTotal]);
	MOVLW       _bufferEeprom+0
	MOVWF       FARG_string_add_destino+0 
	MOVLW       hi_addr(_bufferEeprom+0)
	MOVWF       FARG_string_add_destino+1 
	MOVLW       _getRequest+0
	MOVWF       FARG_string_add_addEnd+0 
	MOVLW       hi_addr(_getRequest+0)
	MOVWF       FARG_string_add_addEnd+1 
	MOVF        Net_Ethernet_28j60_UserTCP_sizeTotal_L0+0, 0 
	ADDWF       FARG_string_add_addEnd+0, 1 
	BTFSC       STATUS+0, 0 
	INCF        FARG_string_add_addEnd+1, 1 
	CALL        _string_add+0, 0
;TPV.c,1058 :: 		buffer_save_send(false, bufferEeprom, tarjetas.canIdMod);
	CLRF        FARG_buffer_save_send_tcpORcan+0 
	MOVLW       _bufferEeprom+0
	MOVWF       FARG_buffer_save_send_buffer+0 
	MOVLW       hi_addr(_bufferEeprom+0)
	MOVWF       FARG_buffer_save_send_buffer+1 
	MOVLW       _tarjetas+42
	MOVWF       FARG_buffer_save_send_nodosCAN+0 
	MOVLW       hi_addr(_tarjetas+42)
	MOVWF       FARG_buffer_save_send_nodosCAN+1 
	CALL        _buffer_save_send+0, 0
;TPV.c,1059 :: 		usart_write_text("Se guarda: ");
	MOVLW       ?lstr27_TPV+0
	MOVWF       FARG_usart_write_text_texto+0 
	MOVLW       hi_addr(?lstr27_TPV+0)
	MOVWF       FARG_usart_write_text_texto+1 
	CALL        _usart_write_text+0, 0
;TPV.c,1060 :: 		usart_write_line(bufferEeprom);
	MOVLW       _bufferEeprom+0
	MOVWF       FARG_usart_write_line_texto+0 
	MOVLW       hi_addr(_bufferEeprom+0)
	MOVWF       FARG_usart_write_line_texto+1 
	CALL        _usart_write_line+0, 0
;TPV.c,1061 :: 		}else{
	GOTO        L_Net_Ethernet_28j60_UserTCP726
L_Net_Ethernet_28j60_UserTCP725:
;TPV.c,1062 :: 		usart_write_line("No se genera evento CAN");
	MOVLW       ?lstr28_TPV+0
	MOVWF       FARG_usart_write_line_texto+0 
	MOVLW       hi_addr(?lstr28_TPV+0)
	MOVWF       FARG_usart_write_line_texto+1 
	CALL        _usart_write_line+0, 0
;TPV.c,1063 :: 		}
L_Net_Ethernet_28j60_UserTCP726:
;TPV.c,1064 :: 		}else if(string_cmpnc(TCP_CAN_RTC, &getRequest[sizeTotal], sizeKey)){
	GOTO        L_Net_Ethernet_28j60_UserTCP727
L_Net_Ethernet_28j60_UserTCP688:
	MOVLW       _TCP_CAN_RTC+0
	MOVWF       FARG_string_cmpnc_text1+0 
	MOVLW       hi_addr(_TCP_CAN_RTC+0)
	MOVWF       FARG_string_cmpnc_text1+1 
	MOVLW       higher_addr(_TCP_CAN_RTC+0)
	MOVWF       FARG_string_cmpnc_text1+2 
	MOVLW       _getRequest+0
	MOVWF       FARG_string_cmpnc_text2+0 
	MOVLW       hi_addr(_getRequest+0)
	MOVWF       FARG_string_cmpnc_text2+1 
	MOVF        Net_Ethernet_28j60_UserTCP_sizeTotal_L0+0, 0 
	ADDWF       FARG_string_cmpnc_text2+0, 1 
	BTFSC       STATUS+0, 0 
	INCF        FARG_string_cmpnc_text2+1, 1 
	MOVF        Net_Ethernet_28j60_UserTCP_sizeKey_L0+0, 0 
	MOVWF       FARG_string_cmpnc_bytes+0 
	CALL        _string_cmpnc+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_Net_Ethernet_28j60_UserTCP728
;TPV.c,1066 :: 		sizeTotal += sizeKey;
	MOVF        Net_Ethernet_28j60_UserTCP_sizeKey_L0+0, 0 
	ADDWF       Net_Ethernet_28j60_UserTCP_sizeTotal_L0+0, 0 
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       Net_Ethernet_28j60_UserTCP_sizeTotal_L0+0 
;TPV.c,1067 :: 		sizeKey = sizeof(TCP_TABLE_SET)-1;
	MOVLW       3
	MOVWF       Net_Ethernet_28j60_UserTCP_sizeKey_L0+0 
;TPV.c,1068 :: 		string_cpyn(respuesta, getRequest, sizeTotal+sizeKey);
	MOVLW       Net_Ethernet_28j60_UserTCP_respuesta_L0+0
	MOVWF       FARG_string_cpyn_destino+0 
	MOVLW       hi_addr(Net_Ethernet_28j60_UserTCP_respuesta_L0+0)
	MOVWF       FARG_string_cpyn_destino+1 
	MOVLW       _getRequest+0
	MOVWF       FARG_string_cpyn_origen+0 
	MOVLW       hi_addr(_getRequest+0)
	MOVWF       FARG_string_cpyn_origen+1 
	MOVLW       3
	ADDWF       R0, 0 
	MOVWF       FARG_string_cpyn_size+0 
	CALL        _string_cpyn+0, 0
;TPV.c,1071 :: 		if(string_cmpnc(TCP_TABLE_SET, &getRequest[sizeTotal], sizeKey)){
	MOVLW       _TCP_TABLE_SET+0
	MOVWF       FARG_string_cmpnc_text1+0 
	MOVLW       hi_addr(_TCP_TABLE_SET+0)
	MOVWF       FARG_string_cmpnc_text1+1 
	MOVLW       higher_addr(_TCP_TABLE_SET+0)
	MOVWF       FARG_string_cmpnc_text1+2 
	MOVLW       _getRequest+0
	MOVWF       FARG_string_cmpnc_text2+0 
	MOVLW       hi_addr(_getRequest+0)
	MOVWF       FARG_string_cmpnc_text2+1 
	MOVF        Net_Ethernet_28j60_UserTCP_sizeTotal_L0+0, 0 
	ADDWF       FARG_string_cmpnc_text2+0, 1 
	BTFSC       STATUS+0, 0 
	INCF        FARG_string_cmpnc_text2+1, 1 
	MOVF        Net_Ethernet_28j60_UserTCP_sizeKey_L0+0, 0 
	MOVWF       FARG_string_cmpnc_bytes+0 
	CALL        _string_cmpnc+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_Net_Ethernet_28j60_UserTCP729
;TPV.c,1072 :: 		sizeTotal += sizeKey;
	MOVF        Net_Ethernet_28j60_UserTCP_sizeKey_L0+0, 0 
	ADDWF       Net_Ethernet_28j60_UserTCP_sizeTotal_L0+0, 0 
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       Net_Ethernet_28j60_UserTCP_sizeTotal_L0+0 
;TPV.c,1074 :: 		DS1307_write_string(&myRTC, &getRequest[sizeTotal]);
	MOVLW       _myRTC+0
	MOVWF       FARG_DS1307_write_string_myDS+0 
	MOVLW       hi_addr(_myRTC+0)
	MOVWF       FARG_DS1307_write_string_myDS+1 
	MOVLW       _getRequest+0
	MOVWF       FARG_DS1307_write_string_date+0 
	MOVLW       hi_addr(_getRequest+0)
	MOVWF       FARG_DS1307_write_string_date+1 
	MOVF        R0, 0 
	ADDWF       FARG_DS1307_write_string_date+0, 1 
	BTFSC       STATUS+0, 0 
	INCF        FARG_DS1307_write_string_date+1, 1 
	CALL        _DS1307_write_string+0, 0
;TPV.c,1075 :: 		string_addc(respuesta, TCP_TBL_MODIFICADO);
	MOVLW       Net_Ethernet_28j60_UserTCP_respuesta_L0+0
	MOVWF       FARG_string_addc_destino+0 
	MOVLW       hi_addr(Net_Ethernet_28j60_UserTCP_respuesta_L0+0)
	MOVWF       FARG_string_addc_destino+1 
	MOVLW       _TCP_TBL_MODIFICADO+0
	MOVWF       FARG_string_addc_addEnd+0 
	MOVLW       hi_addr(_TCP_TBL_MODIFICADO+0)
	MOVWF       FARG_string_addc_addEnd+1 
	MOVLW       higher_addr(_TCP_TBL_MODIFICADO+0)
	MOVWF       FARG_string_addc_addEnd+2 
	CALL        _string_addc+0, 0
;TPV.c,1077 :: 		buffer_save_send(false, getRequest, tarjetas.canIdMod);
	CLRF        FARG_buffer_save_send_tcpORcan+0 
	MOVLW       _getRequest+0
	MOVWF       FARG_buffer_save_send_buffer+0 
	MOVLW       hi_addr(_getRequest+0)
	MOVWF       FARG_buffer_save_send_buffer+1 
	MOVLW       _tarjetas+42
	MOVWF       FARG_buffer_save_send_nodosCAN+0 
	MOVLW       hi_addr(_tarjetas+42)
	MOVWF       FARG_buffer_save_send_nodosCAN+1 
	CALL        _buffer_save_send+0, 0
;TPV.c,1078 :: 		usart_write_text("Se guarda: ");
	MOVLW       ?lstr29_TPV+0
	MOVWF       FARG_usart_write_text_texto+0 
	MOVLW       hi_addr(?lstr29_TPV+0)
	MOVWF       FARG_usart_write_text_texto+1 
	CALL        _usart_write_text+0, 0
;TPV.c,1079 :: 		usart_write_line(bufferEeprom);
	MOVLW       _bufferEeprom+0
	MOVWF       FARG_usart_write_line_texto+0 
	MOVLW       hi_addr(_bufferEeprom+0)
	MOVWF       FARG_usart_write_line_texto+1 
	CALL        _usart_write_line+0, 0
;TPV.c,1080 :: 		}else if(string_cmpnc(TCP_TABLE_GET, &getRequest[sizeTotal], sizeKey)){
	GOTO        L_Net_Ethernet_28j60_UserTCP730
L_Net_Ethernet_28j60_UserTCP729:
	MOVLW       _TCP_TABLE_GET+0
	MOVWF       FARG_string_cmpnc_text1+0 
	MOVLW       hi_addr(_TCP_TABLE_GET+0)
	MOVWF       FARG_string_cmpnc_text1+1 
	MOVLW       higher_addr(_TCP_TABLE_GET+0)
	MOVWF       FARG_string_cmpnc_text1+2 
	MOVLW       _getRequest+0
	MOVWF       FARG_string_cmpnc_text2+0 
	MOVLW       hi_addr(_getRequest+0)
	MOVWF       FARG_string_cmpnc_text2+1 
	MOVF        Net_Ethernet_28j60_UserTCP_sizeTotal_L0+0, 0 
	ADDWF       FARG_string_cmpnc_text2+0, 1 
	BTFSC       STATUS+0, 0 
	INCF        FARG_string_cmpnc_text2+1, 1 
	MOVF        Net_Ethernet_28j60_UserTCP_sizeKey_L0+0, 0 
	MOVWF       FARG_string_cmpnc_bytes+0 
	CALL        _string_cmpnc+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_Net_Ethernet_28j60_UserTCP731
;TPV.c,1081 :: 		sizeTotal += sizeKey;
	MOVF        Net_Ethernet_28j60_UserTCP_sizeKey_L0+0, 0 
	ADDWF       Net_Ethernet_28j60_UserTCP_sizeTotal_L0+0, 1 
;TPV.c,1083 :: 		DS1307_read(&myRTC, true);
	MOVLW       _myRTC+0
	MOVWF       FARG_DS1307_read_myDS+0 
	MOVLW       hi_addr(_myRTC+0)
	MOVWF       FARG_DS1307_read_myDS+1 
	MOVLW       1
	MOVWF       FARG_DS1307_read_formatComplet+0 
	CALL        _DS1307_read+0, 0
;TPV.c,1084 :: 		string_add(respuesta, myRTC.time);
	MOVLW       Net_Ethernet_28j60_UserTCP_respuesta_L0+0
	MOVWF       FARG_string_add_destino+0 
	MOVLW       hi_addr(Net_Ethernet_28j60_UserTCP_respuesta_L0+0)
	MOVWF       FARG_string_add_destino+1 
	MOVLW       _myRTC+7
	MOVWF       FARG_string_add_addEnd+0 
	MOVLW       hi_addr(_myRTC+7)
	MOVWF       FARG_string_add_addEnd+1 
	CALL        _string_add+0, 0
;TPV.c,1085 :: 		string_addc(respuesta, TCP_CAN_MODULE);
	MOVLW       Net_Ethernet_28j60_UserTCP_respuesta_L0+0
	MOVWF       FARG_string_addc_destino+0 
	MOVLW       hi_addr(Net_Ethernet_28j60_UserTCP_respuesta_L0+0)
	MOVWF       FARG_string_addc_destino+1 
	MOVLW       _TCP_CAN_MODULE+0
	MOVWF       FARG_string_addc_addEnd+0 
	MOVLW       hi_addr(_TCP_CAN_MODULE+0)
	MOVWF       FARG_string_addc_addEnd+1 
	MOVLW       higher_addr(_TCP_CAN_MODULE+0)
	MOVWF       FARG_string_addc_addEnd+2 
	CALL        _string_addc+0, 0
;TPV.c,1086 :: 		numToHex(can.id, msjConst, 1);
	MOVF        _can+12, 0 
	MOVWF       FARG_numToHex_valor+0 
	MOVLW       0
	MOVWF       FARG_numToHex_valor+1 
	MOVWF       FARG_numToHex_valor+2 
	MOVWF       FARG_numToHex_valor+3 
	MOVLW       _msjConst+0
	MOVWF       FARG_numToHex_cadena+0 
	MOVLW       hi_addr(_msjConst+0)
	MOVWF       FARG_numToHex_cadena+1 
	MOVLW       1
	MOVWF       FARG_numToHex_bytes+0 
	CALL        _numToHex+0, 0
;TPV.c,1087 :: 		string_add(respuesta, msjConst);
	MOVLW       Net_Ethernet_28j60_UserTCP_respuesta_L0+0
	MOVWF       FARG_string_add_destino+0 
	MOVLW       hi_addr(Net_Ethernet_28j60_UserTCP_respuesta_L0+0)
	MOVWF       FARG_string_add_destino+1 
	MOVLW       _msjConst+0
	MOVWF       FARG_string_add_addEnd+0 
	MOVLW       hi_addr(_msjConst+0)
	MOVWF       FARG_string_add_addEnd+1 
	CALL        _string_add+0, 0
;TPV.c,1089 :: 		buffer_save_send(false, getRequest, tarjetas.canIdMod);
	CLRF        FARG_buffer_save_send_tcpORcan+0 
	MOVLW       _getRequest+0
	MOVWF       FARG_buffer_save_send_buffer+0 
	MOVLW       hi_addr(_getRequest+0)
	MOVWF       FARG_buffer_save_send_buffer+1 
	MOVLW       _tarjetas+42
	MOVWF       FARG_buffer_save_send_nodosCAN+0 
	MOVLW       hi_addr(_tarjetas+42)
	MOVWF       FARG_buffer_save_send_nodosCAN+1 
	CALL        _buffer_save_send+0, 0
;TPV.c,1090 :: 		}
L_Net_Ethernet_28j60_UserTCP731:
L_Net_Ethernet_28j60_UserTCP730:
;TPV.c,1091 :: 		}else if(string_cmpnc(TCP_CAN_FOL, &getRequest[sizeTotal], sizeKey)){
	GOTO        L_Net_Ethernet_28j60_UserTCP732
L_Net_Ethernet_28j60_UserTCP728:
	MOVLW       _TCP_CAN_FOL+0
	MOVWF       FARG_string_cmpnc_text1+0 
	MOVLW       hi_addr(_TCP_CAN_FOL+0)
	MOVWF       FARG_string_cmpnc_text1+1 
	MOVLW       higher_addr(_TCP_CAN_FOL+0)
	MOVWF       FARG_string_cmpnc_text1+2 
	MOVLW       _getRequest+0
	MOVWF       FARG_string_cmpnc_text2+0 
	MOVLW       hi_addr(_getRequest+0)
	MOVWF       FARG_string_cmpnc_text2+1 
	MOVF        Net_Ethernet_28j60_UserTCP_sizeTotal_L0+0, 0 
	ADDWF       FARG_string_cmpnc_text2+0, 1 
	BTFSC       STATUS+0, 0 
	INCF        FARG_string_cmpnc_text2+1, 1 
	MOVF        Net_Ethernet_28j60_UserTCP_sizeKey_L0+0, 0 
	MOVWF       FARG_string_cmpnc_bytes+0 
	CALL        _string_cmpnc+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_Net_Ethernet_28j60_UserTCP733
;TPV.c,1092 :: 		string_cpyc(respuesta, TCP_CAN_FOL);
	MOVLW       Net_Ethernet_28j60_UserTCP_respuesta_L0+0
	MOVWF       FARG_string_cpyc_destino+0 
	MOVLW       hi_addr(Net_Ethernet_28j60_UserTCP_respuesta_L0+0)
	MOVWF       FARG_string_cpyc_destino+1 
	MOVLW       _TCP_CAN_FOL+0
	MOVWF       FARG_string_cpyc_origen+0 
	MOVLW       hi_addr(_TCP_CAN_FOL+0)
	MOVWF       FARG_string_cpyc_origen+1 
	MOVLW       higher_addr(_TCP_CAN_FOL+0)
	MOVWF       FARG_string_cpyc_origen+2 
	CALL        _string_cpyc+0, 0
;TPV.c,1094 :: 		sizeTotal += sizeKey;
	MOVF        Net_Ethernet_28j60_UserTCP_sizeKey_L0+0, 0 
	ADDWF       Net_Ethernet_28j60_UserTCP_sizeTotal_L0+0, 0 
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       Net_Ethernet_28j60_UserTCP_sizeTotal_L0+0 
;TPV.c,1095 :: 		sizeKey = sizeof(TCP_TABLE_SET)-1;
	MOVLW       3
	MOVWF       Net_Ethernet_28j60_UserTCP_sizeKey_L0+0 
;TPV.c,1097 :: 		if(string_cmpnc(TCP_TABLE_SET, &getRequest[sizeTotal], sizeKey)){
	MOVLW       _TCP_TABLE_SET+0
	MOVWF       FARG_string_cmpnc_text1+0 
	MOVLW       hi_addr(_TCP_TABLE_SET+0)
	MOVWF       FARG_string_cmpnc_text1+1 
	MOVLW       higher_addr(_TCP_TABLE_SET+0)
	MOVWF       FARG_string_cmpnc_text1+2 
	MOVLW       _getRequest+0
	MOVWF       FARG_string_cmpnc_text2+0 
	MOVLW       hi_addr(_getRequest+0)
	MOVWF       FARG_string_cmpnc_text2+1 
	MOVF        R0, 0 
	ADDWF       FARG_string_cmpnc_text2+0, 1 
	BTFSC       STATUS+0, 0 
	INCF        FARG_string_cmpnc_text2+1, 1 
	MOVLW       3
	MOVWF       FARG_string_cmpnc_bytes+0 
	CALL        _string_cmpnc+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_Net_Ethernet_28j60_UserTCP734
;TPV.c,1098 :: 		sizeTotal += sizeKey;
	MOVF        Net_Ethernet_28j60_UserTCP_sizeKey_L0+0, 0 
	ADDWF       Net_Ethernet_28j60_UserTCP_sizeTotal_L0+0, 0 
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       Net_Ethernet_28j60_UserTCP_sizeTotal_L0+0 
;TPV.c,1100 :: 		folio = hexToNum(&getRequest[sizeTotal]);
	MOVLW       _getRequest+0
	MOVWF       FARG_hexToNum_hex+0 
	MOVLW       hi_addr(_getRequest+0)
	MOVWF       FARG_hexToNum_hex+1 
	MOVF        R0, 0 
	ADDWF       FARG_hexToNum_hex+0, 1 
	BTFSC       STATUS+0, 0 
	INCF        FARG_hexToNum_hex+1, 1 
	CALL        _hexToNum+0, 0
	MOVF        R0, 0 
	MOVWF       _folio+0 
	MOVF        R1, 0 
	MOVWF       _folio+1 
	MOVF        R2, 0 
	MOVWF       _folio+2 
	MOVF        R3, 0 
	MOVWF       _folio+3 
;TPV.c,1101 :: 		result = !mysql_write(tableFolio, folioTotal, 1, folio, false);
	MOVLW       _tableFolio+0
	MOVWF       FARG_mysql_write_name+0 
	MOVLW       hi_addr(_tableFolio+0)
	MOVWF       FARG_mysql_write_name+1 
	MOVLW       _folioTotal+0
	MOVWF       FARG_mysql_write_column+0 
	MOVLW       hi_addr(_folioTotal+0)
	MOVWF       FARG_mysql_write_column+1 
	MOVLW       1
	MOVWF       FARG_mysql_write_fila+0 
	MOVLW       0
	MOVWF       FARG_mysql_write_fila+1 
	MOVF        R0, 0 
	MOVWF       FARG_mysql_write_value+0 
	MOVF        R1, 0 
	MOVWF       FARG_mysql_write_value+1 
	MOVF        R2, 0 
	MOVWF       FARG_mysql_write_value+2 
	MOVF        R3, 0 
	MOVWF       FARG_mysql_write_value+3 
	CLRF        FARG_mysql_write_endWrite+0 
	CALL        _mysql_write+0, 0
	MOVF        R0, 1 
	MOVLW       1
	BTFSS       STATUS+0, 2 
	MOVLW       0
	MOVWF       R1 
	MOVF        R1, 0 
	MOVWF       Net_Ethernet_28j60_UserTCP_result_L0+0 
;TPV.c,1102 :: 		string_addc(respuesta,result?TCP_TBL_MODIFICADO:TCP_TBL_ERROR);
	MOVLW       Net_Ethernet_28j60_UserTCP_respuesta_L0+0
	MOVWF       FARG_string_addc_destino+0 
	MOVLW       hi_addr(Net_Ethernet_28j60_UserTCP_respuesta_L0+0)
	MOVWF       FARG_string_addc_destino+1 
	MOVF        R1, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_Net_Ethernet_28j60_UserTCP735
	MOVLW       _TCP_TBL_MODIFICADO+0
	MOVWF       ?FLOC___Net_Ethernet_28j60_UserTCPT3078+0 
	MOVLW       hi_addr(_TCP_TBL_MODIFICADO+0)
	MOVWF       ?FLOC___Net_Ethernet_28j60_UserTCPT3078+1 
	MOVLW       higher_addr(_TCP_TBL_MODIFICADO+0)
	MOVWF       ?FLOC___Net_Ethernet_28j60_UserTCPT3078+2 
	GOTO        L_Net_Ethernet_28j60_UserTCP736
L_Net_Ethernet_28j60_UserTCP735:
	MOVLW       _TCP_TBL_ERROR+0
	MOVWF       ?FLOC___Net_Ethernet_28j60_UserTCPT3078+0 
	MOVLW       hi_addr(_TCP_TBL_ERROR+0)
	MOVWF       ?FLOC___Net_Ethernet_28j60_UserTCPT3078+1 
	MOVLW       higher_addr(_TCP_TBL_ERROR+0)
	MOVWF       ?FLOC___Net_Ethernet_28j60_UserTCPT3078+2 
L_Net_Ethernet_28j60_UserTCP736:
	MOVF        ?FLOC___Net_Ethernet_28j60_UserTCPT3078+0, 0 
	MOVWF       FARG_string_addc_addEnd+0 
	MOVF        ?FLOC___Net_Ethernet_28j60_UserTCPT3078+1, 0 
	MOVWF       FARG_string_addc_addEnd+1 
	MOVF        ?FLOC___Net_Ethernet_28j60_UserTCPT3078+2, 0 
	MOVWF       FARG_string_addc_addEnd+2 
	CALL        _string_addc+0, 0
;TPV.c,1103 :: 		}else if(string_cmpnc(TCP_TABLE_GET, &getRequest[sizeTotal], sizeKey)){
	GOTO        L_Net_Ethernet_28j60_UserTCP737
L_Net_Ethernet_28j60_UserTCP734:
	MOVLW       _TCP_TABLE_GET+0
	MOVWF       FARG_string_cmpnc_text1+0 
	MOVLW       hi_addr(_TCP_TABLE_GET+0)
	MOVWF       FARG_string_cmpnc_text1+1 
	MOVLW       higher_addr(_TCP_TABLE_GET+0)
	MOVWF       FARG_string_cmpnc_text1+2 
	MOVLW       _getRequest+0
	MOVWF       FARG_string_cmpnc_text2+0 
	MOVLW       hi_addr(_getRequest+0)
	MOVWF       FARG_string_cmpnc_text2+1 
	MOVF        Net_Ethernet_28j60_UserTCP_sizeTotal_L0+0, 0 
	ADDWF       FARG_string_cmpnc_text2+0, 1 
	BTFSC       STATUS+0, 0 
	INCF        FARG_string_cmpnc_text2+1, 1 
	MOVF        Net_Ethernet_28j60_UserTCP_sizeKey_L0+0, 0 
	MOVWF       FARG_string_cmpnc_bytes+0 
	CALL        _string_cmpnc+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_Net_Ethernet_28j60_UserTCP738
;TPV.c,1104 :: 		sizeTotal += sizeKey;
	MOVF        Net_Ethernet_28j60_UserTCP_sizeKey_L0+0, 0 
	ADDWF       Net_Ethernet_28j60_UserTCP_sizeTotal_L0+0, 1 
;TPV.c,1106 :: 		result = !mysql_read(tableFolio, folioTotal, 1, &folio);
	MOVLW       _tableFolio+0
	MOVWF       FARG_mysql_read_name+0 
	MOVLW       hi_addr(_tableFolio+0)
	MOVWF       FARG_mysql_read_name+1 
	MOVLW       _folioTotal+0
	MOVWF       FARG_mysql_read_column+0 
	MOVLW       hi_addr(_folioTotal+0)
	MOVWF       FARG_mysql_read_column+1 
	MOVLW       1
	MOVWF       FARG_mysql_read_fila+0 
	MOVLW       0
	MOVWF       FARG_mysql_read_fila+1 
	MOVLW       _folio+0
	MOVWF       FARG_mysql_read_result+0 
	MOVLW       hi_addr(_folio+0)
	MOVWF       FARG_mysql_read_result+1 
	CALL        _mysql_read+0, 0
	MOVF        R0, 1 
	MOVLW       1
	BTFSS       STATUS+0, 2 
	MOVLW       0
	MOVWF       Net_Ethernet_28j60_UserTCP_result_L0+0 
;TPV.c,1107 :: 		numToHex(folio, msjConst, 4);
	MOVF        _folio+0, 0 
	MOVWF       FARG_numToHex_valor+0 
	MOVF        _folio+1, 0 
	MOVWF       FARG_numToHex_valor+1 
	MOVF        _folio+2, 0 
	MOVWF       FARG_numToHex_valor+2 
	MOVF        _folio+3, 0 
	MOVWF       FARG_numToHex_valor+3 
	MOVLW       _msjConst+0
	MOVWF       FARG_numToHex_cadena+0 
	MOVLW       hi_addr(_msjConst+0)
	MOVWF       FARG_numToHex_cadena+1 
	MOVLW       4
	MOVWF       FARG_numToHex_bytes+0 
	CALL        _numToHex+0, 0
;TPV.c,1108 :: 		if(result){
	MOVF        Net_Ethernet_28j60_UserTCP_result_L0+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_Net_Ethernet_28j60_UserTCP739
;TPV.c,1109 :: 		string_add(respuesta, msjConst);
	MOVLW       Net_Ethernet_28j60_UserTCP_respuesta_L0+0
	MOVWF       FARG_string_add_destino+0 
	MOVLW       hi_addr(Net_Ethernet_28j60_UserTCP_respuesta_L0+0)
	MOVWF       FARG_string_add_destino+1 
	MOVLW       _msjConst+0
	MOVWF       FARG_string_add_addEnd+0 
	MOVLW       hi_addr(_msjConst+0)
	MOVWF       FARG_string_add_addEnd+1 
	CALL        _string_add+0, 0
;TPV.c,1110 :: 		string_addc(respuesta, TCP_CAN_MODULE);
	MOVLW       Net_Ethernet_28j60_UserTCP_respuesta_L0+0
	MOVWF       FARG_string_addc_destino+0 
	MOVLW       hi_addr(Net_Ethernet_28j60_UserTCP_respuesta_L0+0)
	MOVWF       FARG_string_addc_destino+1 
	MOVLW       _TCP_CAN_MODULE+0
	MOVWF       FARG_string_addc_addEnd+0 
	MOVLW       hi_addr(_TCP_CAN_MODULE+0)
	MOVWF       FARG_string_addc_addEnd+1 
	MOVLW       higher_addr(_TCP_CAN_MODULE+0)
	MOVWF       FARG_string_addc_addEnd+2 
	CALL        _string_addc+0, 0
;TPV.c,1111 :: 		numToHex(can.id, msjConst, 1);
	MOVF        _can+12, 0 
	MOVWF       FARG_numToHex_valor+0 
	MOVLW       0
	MOVWF       FARG_numToHex_valor+1 
	MOVWF       FARG_numToHex_valor+2 
	MOVWF       FARG_numToHex_valor+3 
	MOVLW       _msjConst+0
	MOVWF       FARG_numToHex_cadena+0 
	MOVLW       hi_addr(_msjConst+0)
	MOVWF       FARG_numToHex_cadena+1 
	MOVLW       1
	MOVWF       FARG_numToHex_bytes+0 
	CALL        _numToHex+0, 0
;TPV.c,1112 :: 		string_add(respuesta, msjConst);
	MOVLW       Net_Ethernet_28j60_UserTCP_respuesta_L0+0
	MOVWF       FARG_string_add_destino+0 
	MOVLW       hi_addr(Net_Ethernet_28j60_UserTCP_respuesta_L0+0)
	MOVWF       FARG_string_add_destino+1 
	MOVLW       _msjConst+0
	MOVWF       FARG_string_add_addEnd+0 
	MOVLW       hi_addr(_msjConst+0)
	MOVWF       FARG_string_add_addEnd+1 
	CALL        _string_add+0, 0
;TPV.c,1113 :: 		}else
	GOTO        L_Net_Ethernet_28j60_UserTCP740
L_Net_Ethernet_28j60_UserTCP739:
;TPV.c,1114 :: 		string_addc(respuesta, TCP_TBL_ERROR);
	MOVLW       Net_Ethernet_28j60_UserTCP_respuesta_L0+0
	MOVWF       FARG_string_addc_destino+0 
	MOVLW       hi_addr(Net_Ethernet_28j60_UserTCP_respuesta_L0+0)
	MOVWF       FARG_string_addc_destino+1 
	MOVLW       _TCP_TBL_ERROR+0
	MOVWF       FARG_string_addc_addEnd+0 
	MOVLW       hi_addr(_TCP_TBL_ERROR+0)
	MOVWF       FARG_string_addc_addEnd+1 
	MOVLW       higher_addr(_TCP_TBL_ERROR+0)
	MOVWF       FARG_string_addc_addEnd+2 
	CALL        _string_addc+0, 0
L_Net_Ethernet_28j60_UserTCP740:
;TPV.c,1115 :: 		}
L_Net_Ethernet_28j60_UserTCP738:
L_Net_Ethernet_28j60_UserTCP737:
;TPV.c,1116 :: 		}else if(string_cmpnc(TCP_CAN_TICKET, &getRequest[sizeTotal], sizeKey)){
	GOTO        L_Net_Ethernet_28j60_UserTCP741
L_Net_Ethernet_28j60_UserTCP733:
	MOVLW       _TCP_CAN_TICKET+0
	MOVWF       FARG_string_cmpnc_text1+0 
	MOVLW       hi_addr(_TCP_CAN_TICKET+0)
	MOVWF       FARG_string_cmpnc_text1+1 
	MOVLW       higher_addr(_TCP_CAN_TICKET+0)
	MOVWF       FARG_string_cmpnc_text1+2 
	MOVLW       _getRequest+0
	MOVWF       FARG_string_cmpnc_text2+0 
	MOVLW       hi_addr(_getRequest+0)
	MOVWF       FARG_string_cmpnc_text2+1 
	MOVF        Net_Ethernet_28j60_UserTCP_sizeTotal_L0+0, 0 
	ADDWF       FARG_string_cmpnc_text2+0, 1 
	BTFSC       STATUS+0, 0 
	INCF        FARG_string_cmpnc_text2+1, 1 
	MOVF        Net_Ethernet_28j60_UserTCP_sizeKey_L0+0, 0 
	MOVWF       FARG_string_cmpnc_bytes+0 
	CALL        _string_cmpnc+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_Net_Ethernet_28j60_UserTCP742
;TPV.c,1117 :: 		string_cpyc(respuesta, TCP_CAN_TICKET);
	MOVLW       Net_Ethernet_28j60_UserTCP_respuesta_L0+0
	MOVWF       FARG_string_cpyc_destino+0 
	MOVLW       hi_addr(Net_Ethernet_28j60_UserTCP_respuesta_L0+0)
	MOVWF       FARG_string_cpyc_destino+1 
	MOVLW       _TCP_CAN_TICKET+0
	MOVWF       FARG_string_cpyc_origen+0 
	MOVLW       hi_addr(_TCP_CAN_TICKET+0)
	MOVWF       FARG_string_cpyc_origen+1 
	MOVLW       higher_addr(_TCP_CAN_TICKET+0)
	MOVWF       FARG_string_cpyc_origen+2 
	CALL        _string_cpyc+0, 0
;TPV.c,1119 :: 		sizeTotal += sizeKey;
	MOVF        Net_Ethernet_28j60_UserTCP_sizeKey_L0+0, 0 
	ADDWF       Net_Ethernet_28j60_UserTCP_sizeTotal_L0+0, 1 
;TPV.c,1120 :: 		sizeKey = sizeof(TCP_CAN_TICKET)-1;
	MOVLW       3
	MOVWF       Net_Ethernet_28j60_UserTCP_sizeKey_L0+0 
;TPV.c,1122 :: 		string_cpyc(respuesta, TCP_TABLE);
	MOVLW       Net_Ethernet_28j60_UserTCP_respuesta_L0+0
	MOVWF       FARG_string_cpyc_destino+0 
	MOVLW       hi_addr(Net_Ethernet_28j60_UserTCP_respuesta_L0+0)
	MOVWF       FARG_string_cpyc_destino+1 
	MOVLW       _TCP_TABLE+0
	MOVWF       FARG_string_cpyc_origen+0 
	MOVLW       hi_addr(_TCP_TABLE+0)
	MOVWF       FARG_string_cpyc_origen+1 
	MOVLW       higher_addr(_TCP_TABLE+0)
	MOVWF       FARG_string_cpyc_origen+2 
	CALL        _string_cpyc+0, 0
;TPV.c,1123 :: 		string_addc(respuesta, TCP_CAN_TICKET);
	MOVLW       Net_Ethernet_28j60_UserTCP_respuesta_L0+0
	MOVWF       FARG_string_addc_destino+0 
	MOVLW       hi_addr(Net_Ethernet_28j60_UserTCP_respuesta_L0+0)
	MOVWF       FARG_string_addc_destino+1 
	MOVLW       _TCP_CAN_TICKET+0
	MOVWF       FARG_string_addc_addEnd+0 
	MOVLW       hi_addr(_TCP_CAN_TICKET+0)
	MOVWF       FARG_string_addc_addEnd+1 
	MOVLW       higher_addr(_TCP_CAN_TICKET+0)
	MOVWF       FARG_string_addc_addEnd+2 
	CALL        _string_addc+0, 0
;TPV.c,1125 :: 		if(string_cmpnc(TCP_CAN_TPV, &getRequest[sizeTotal], sizeKey)){
	MOVLW       _TCP_CAN_TPV+0
	MOVWF       FARG_string_cmpnc_text1+0 
	MOVLW       hi_addr(_TCP_CAN_TPV+0)
	MOVWF       FARG_string_cmpnc_text1+1 
	MOVLW       higher_addr(_TCP_CAN_TPV+0)
	MOVWF       FARG_string_cmpnc_text1+2 
	MOVLW       _getRequest+0
	MOVWF       FARG_string_cmpnc_text2+0 
	MOVLW       hi_addr(_getRequest+0)
	MOVWF       FARG_string_cmpnc_text2+1 
	MOVF        Net_Ethernet_28j60_UserTCP_sizeTotal_L0+0, 0 
	ADDWF       FARG_string_cmpnc_text2+0, 1 
	BTFSC       STATUS+0, 0 
	INCF        FARG_string_cmpnc_text2+1, 1 
	MOVF        Net_Ethernet_28j60_UserTCP_sizeKey_L0+0, 0 
	MOVWF       FARG_string_cmpnc_bytes+0 
	CALL        _string_cmpnc+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_Net_Ethernet_28j60_UserTCP743
;TPV.c,1126 :: 		sizeTotal += sizeKey;
	MOVF        Net_Ethernet_28j60_UserTCP_sizeKey_L0+0, 0 
	ADDWF       Net_Ethernet_28j60_UserTCP_sizeTotal_L0+0, 1 
;TPV.c,1127 :: 		sizeKey = sizeof(TCP_TABLE_ERASE)-1;
	MOVLW       3
	MOVWF       Net_Ethernet_28j60_UserTCP_sizeKey_L0+0 
;TPV.c,1129 :: 		string_addc(respuesta, TCP_CAN_TPV);
	MOVLW       Net_Ethernet_28j60_UserTCP_respuesta_L0+0
	MOVWF       FARG_string_addc_destino+0 
	MOVLW       hi_addr(Net_Ethernet_28j60_UserTCP_respuesta_L0+0)
	MOVWF       FARG_string_addc_destino+1 
	MOVLW       _TCP_CAN_TPV+0
	MOVWF       FARG_string_addc_addEnd+0 
	MOVLW       hi_addr(_TCP_CAN_TPV+0)
	MOVWF       FARG_string_addc_addEnd+1 
	MOVLW       higher_addr(_TCP_CAN_TPV+0)
	MOVWF       FARG_string_addc_addEnd+2 
	CALL        _string_addc+0, 0
;TPV.c,1130 :: 		if(string_cmpnc(TCP_TABLE_ERASE, &getRequest[sizeTotal], sizeKey)){
	MOVLW       _TCP_TABLE_ERASE+0
	MOVWF       FARG_string_cmpnc_text1+0 
	MOVLW       hi_addr(_TCP_TABLE_ERASE+0)
	MOVWF       FARG_string_cmpnc_text1+1 
	MOVLW       higher_addr(_TCP_TABLE_ERASE+0)
	MOVWF       FARG_string_cmpnc_text1+2 
	MOVLW       _getRequest+0
	MOVWF       FARG_string_cmpnc_text2+0 
	MOVLW       hi_addr(_getRequest+0)
	MOVWF       FARG_string_cmpnc_text2+1 
	MOVF        Net_Ethernet_28j60_UserTCP_sizeTotal_L0+0, 0 
	ADDWF       FARG_string_cmpnc_text2+0, 1 
	BTFSC       STATUS+0, 0 
	INCF        FARG_string_cmpnc_text2+1, 1 
	MOVF        Net_Ethernet_28j60_UserTCP_sizeKey_L0+0, 0 
	MOVWF       FARG_string_cmpnc_bytes+0 
	CALL        _string_cmpnc+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_Net_Ethernet_28j60_UserTCP744
;TPV.c,1132 :: 		mysql_erase(tableTicketTPV);
	MOVLW       _tableTicketTPV+0
	MOVWF       FARG_mysql_erase_name+0 
	MOVLW       hi_addr(_tableTicketTPV+0)
	MOVWF       FARG_mysql_erase_name+1 
	CALL        _mysql_erase+0, 0
;TPV.c,1133 :: 		}else if(string_cmpnc(TCP_CAN_ANEXAR, &getRequest[sizeTotal], sizeKey)){
	GOTO        L_Net_Ethernet_28j60_UserTCP745
L_Net_Ethernet_28j60_UserTCP744:
	MOVLW       _TCP_CAN_ANEXAR+0
	MOVWF       FARG_string_cmpnc_text1+0 
	MOVLW       hi_addr(_TCP_CAN_ANEXAR+0)
	MOVWF       FARG_string_cmpnc_text1+1 
	MOVLW       higher_addr(_TCP_CAN_ANEXAR+0)
	MOVWF       FARG_string_cmpnc_text1+2 
	MOVLW       _getRequest+0
	MOVWF       FARG_string_cmpnc_text2+0 
	MOVLW       hi_addr(_getRequest+0)
	MOVWF       FARG_string_cmpnc_text2+1 
	MOVF        Net_Ethernet_28j60_UserTCP_sizeTotal_L0+0, 0 
	ADDWF       FARG_string_cmpnc_text2+0, 1 
	BTFSC       STATUS+0, 0 
	INCF        FARG_string_cmpnc_text2+1, 1 
	MOVF        Net_Ethernet_28j60_UserTCP_sizeKey_L0+0, 0 
	MOVWF       FARG_string_cmpnc_bytes+0 
	CALL        _string_cmpnc+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_Net_Ethernet_28j60_UserTCP746
;TPV.c,1134 :: 		sizeTotal += sizeKey;
	MOVF        Net_Ethernet_28j60_UserTCP_sizeKey_L0+0, 0 
	ADDWF       Net_Ethernet_28j60_UserTCP_sizeTotal_L0+0, 0 
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       Net_Ethernet_28j60_UserTCP_sizeTotal_L0+0 
;TPV.c,1135 :: 		sizeKey = sizeTotal + string_len(&getRequest[sizeTotal]);
	MOVLW       _getRequest+0
	MOVWF       FARG_string_len_texto+0 
	MOVLW       hi_addr(_getRequest+0)
	MOVWF       FARG_string_len_texto+1 
	MOVF        R0, 0 
	ADDWF       FARG_string_len_texto+0, 1 
	BTFSC       STATUS+0, 0 
	INCF        FARG_string_len_texto+1, 1 
	CALL        _string_len+0, 0
	MOVF        R0, 0 
	ADDWF       Net_Ethernet_28j60_UserTCP_sizeTotal_L0+0, 0 
	MOVWF       Net_Ethernet_28j60_UserTCP_sizeKey_L0+0 
;TPV.c,1137 :: 		for(cont = sizeTotal; cont < sizeKey; cont++)
	MOVF        Net_Ethernet_28j60_UserTCP_sizeTotal_L0+0, 0 
	MOVWF       Net_Ethernet_28j60_UserTCP_cont_L0+0 
	MOVLW       0
	MOVWF       Net_Ethernet_28j60_UserTCP_cont_L0+1 
L_Net_Ethernet_28j60_UserTCP747:
	MOVLW       0
	SUBWF       Net_Ethernet_28j60_UserTCP_cont_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__Net_Ethernet_28j60_UserTCP1387
	MOVF        Net_Ethernet_28j60_UserTCP_sizeKey_L0+0, 0 
	SUBWF       Net_Ethernet_28j60_UserTCP_cont_L0+0, 0 
L__Net_Ethernet_28j60_UserTCP1387:
	BTFSC       STATUS+0, 0 
	GOTO        L_Net_Ethernet_28j60_UserTCP748
;TPV.c,1138 :: 		mysql_write(tableTicketTPV, ticketTicket, -1, getRequest[cont], true);
	MOVLW       _tableTicketTPV+0
	MOVWF       FARG_mysql_write_name+0 
	MOVLW       hi_addr(_tableTicketTPV+0)
	MOVWF       FARG_mysql_write_name+1 
	MOVLW       _ticketTicket+0
	MOVWF       FARG_mysql_write_column+0 
	MOVLW       hi_addr(_ticketTicket+0)
	MOVWF       FARG_mysql_write_column+1 
	MOVLW       255
	MOVWF       FARG_mysql_write_fila+0 
	MOVLW       255
	MOVWF       FARG_mysql_write_fila+1 
	MOVLW       _getRequest+0
	ADDWF       Net_Ethernet_28j60_UserTCP_cont_L0+0, 0 
	MOVWF       FSR0 
	MOVLW       hi_addr(_getRequest+0)
	ADDWFC      Net_Ethernet_28j60_UserTCP_cont_L0+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       FARG_mysql_write_value+0 
	MOVLW       0
	MOVWF       FARG_mysql_write_value+1 
	MOVWF       FARG_mysql_write_value+2 
	MOVWF       FARG_mysql_write_value+3 
	MOVLW       0
	MOVWF       FARG_mysql_write_value+1 
	MOVWF       FARG_mysql_write_value+2 
	MOVWF       FARG_mysql_write_value+3 
	MOVLW       1
	MOVWF       FARG_mysql_write_endWrite+0 
	CALL        _mysql_write+0, 0
;TPV.c,1137 :: 		for(cont = sizeTotal; cont < sizeKey; cont++)
	INFSNZ      Net_Ethernet_28j60_UserTCP_cont_L0+0, 1 
	INCF        Net_Ethernet_28j60_UserTCP_cont_L0+1, 1 
;TPV.c,1138 :: 		mysql_write(tableTicketTPV, ticketTicket, -1, getRequest[cont], true);
	GOTO        L_Net_Ethernet_28j60_UserTCP747
L_Net_Ethernet_28j60_UserTCP748:
;TPV.c,1139 :: 		}else if(string_cmpnc(TCP_CAN_FINALIZAR, &getRequest[sizeTotal], sizeKey)){
	GOTO        L_Net_Ethernet_28j60_UserTCP750
L_Net_Ethernet_28j60_UserTCP746:
	MOVLW       _TCP_CAN_FINALIZAR+0
	MOVWF       FARG_string_cmpnc_text1+0 
	MOVLW       hi_addr(_TCP_CAN_FINALIZAR+0)
	MOVWF       FARG_string_cmpnc_text1+1 
	MOVLW       higher_addr(_TCP_CAN_FINALIZAR+0)
	MOVWF       FARG_string_cmpnc_text1+2 
	MOVLW       _getRequest+0
	MOVWF       FARG_string_cmpnc_text2+0 
	MOVLW       hi_addr(_getRequest+0)
	MOVWF       FARG_string_cmpnc_text2+1 
	MOVF        Net_Ethernet_28j60_UserTCP_sizeTotal_L0+0, 0 
	ADDWF       FARG_string_cmpnc_text2+0, 1 
	BTFSC       STATUS+0, 0 
	INCF        FARG_string_cmpnc_text2+1, 1 
	MOVF        Net_Ethernet_28j60_UserTCP_sizeKey_L0+0, 0 
	MOVWF       FARG_string_cmpnc_bytes+0 
	CALL        _string_cmpnc+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_Net_Ethernet_28j60_UserTCP751
;TPV.c,1141 :: 		mysql_write(tableTicketTPV, ticketTicket, -1, 0, true);
	MOVLW       _tableTicketTPV+0
	MOVWF       FARG_mysql_write_name+0 
	MOVLW       hi_addr(_tableTicketTPV+0)
	MOVWF       FARG_mysql_write_name+1 
	MOVLW       _ticketTicket+0
	MOVWF       FARG_mysql_write_column+0 
	MOVLW       hi_addr(_ticketTicket+0)
	MOVWF       FARG_mysql_write_column+1 
	MOVLW       255
	MOVWF       FARG_mysql_write_fila+0 
	MOVLW       255
	MOVWF       FARG_mysql_write_fila+1 
	CLRF        FARG_mysql_write_value+0 
	CLRF        FARG_mysql_write_value+1 
	CLRF        FARG_mysql_write_value+2 
	CLRF        FARG_mysql_write_value+3 
	MOVLW       1
	MOVWF       FARG_mysql_write_endWrite+0 
	CALL        _mysql_write+0, 0
;TPV.c,1142 :: 		}else if(string_cmpnc(TCP_CAN_IMPRIMIR, &getRequest[sizeTotal], sizeKey)){
	GOTO        L_Net_Ethernet_28j60_UserTCP752
L_Net_Ethernet_28j60_UserTCP751:
	MOVLW       _TCP_CAN_IMPRIMIR+0
	MOVWF       FARG_string_cmpnc_text1+0 
	MOVLW       hi_addr(_TCP_CAN_IMPRIMIR+0)
	MOVWF       FARG_string_cmpnc_text1+1 
	MOVLW       higher_addr(_TCP_CAN_IMPRIMIR+0)
	MOVWF       FARG_string_cmpnc_text1+2 
	MOVLW       _getRequest+0
	MOVWF       FARG_string_cmpnc_text2+0 
	MOVLW       hi_addr(_getRequest+0)
	MOVWF       FARG_string_cmpnc_text2+1 
	MOVF        Net_Ethernet_28j60_UserTCP_sizeTotal_L0+0, 0 
	ADDWF       FARG_string_cmpnc_text2+0, 1 
	BTFSC       STATUS+0, 0 
	INCF        FARG_string_cmpnc_text2+1, 1 
	MOVF        Net_Ethernet_28j60_UserTCP_sizeKey_L0+0, 0 
	MOVWF       FARG_string_cmpnc_bytes+0 
	CALL        _string_cmpnc+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_Net_Ethernet_28j60_UserTCP753
;TPV.c,1143 :: 		if(mysql_read_string(tableTicketTPV, ticketTicket, 1, &result)){
	MOVLW       _tableTicketTPV+0
	MOVWF       FARG_mysql_read_string_name+0 
	MOVLW       hi_addr(_tableTicketTPV+0)
	MOVWF       FARG_mysql_read_string_name+1 
	MOVLW       _ticketTicket+0
	MOVWF       FARG_mysql_read_string_column+0 
	MOVLW       hi_addr(_ticketTicket+0)
	MOVWF       FARG_mysql_read_string_column+1 
	MOVLW       1
	MOVWF       FARG_mysql_read_string_fila+0 
	MOVLW       0
	MOVWF       FARG_mysql_read_string_fila+1 
	MOVLW       Net_Ethernet_28j60_UserTCP_result_L0+0
	MOVWF       FARG_mysql_read_string_result+0 
	MOVLW       hi_addr(Net_Ethernet_28j60_UserTCP_result_L0+0)
	MOVWF       FARG_mysql_read_string_result+1 
	CALL        _mysql_read_string+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_Net_Ethernet_28j60_UserTCP754
;TPV.c,1144 :: 		usart_write_line("Emulando boleto");
	MOVLW       ?lstr30_TPV+0
	MOVWF       FARG_usart_write_line_texto+0 
	MOVLW       hi_addr(?lstr30_TPV+0)
	MOVWF       FARG_usart_write_line_texto+1 
	CALL        _usart_write_line+0, 0
;TPV.c,1145 :: 		for(cont = 1; cont <= myTable.rowAct; cont++){
	MOVLW       1
	MOVWF       Net_Ethernet_28j60_UserTCP_cont_L0+0 
	MOVLW       0
	MOVWF       Net_Ethernet_28j60_UserTCP_cont_L0+1 
L_Net_Ethernet_28j60_UserTCP755:
	MOVF        Net_Ethernet_28j60_UserTCP_cont_L0+1, 0 
	SUBWF       TPV_myTable+5, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__Net_Ethernet_28j60_UserTCP1388
	MOVF        Net_Ethernet_28j60_UserTCP_cont_L0+0, 0 
	SUBWF       TPV_myTable+4, 0 
L__Net_Ethernet_28j60_UserTCP1388:
	BTFSS       STATUS+0, 0 
	GOTO        L_Net_Ethernet_28j60_UserTCP756
;TPV.c,1146 :: 		mysql_read_string(tableTicketTPV, ticketTicket, cont, &result);
	MOVLW       _tableTicketTPV+0
	MOVWF       FARG_mysql_read_string_name+0 
	MOVLW       hi_addr(_tableTicketTPV+0)
	MOVWF       FARG_mysql_read_string_name+1 
	MOVLW       _ticketTicket+0
	MOVWF       FARG_mysql_read_string_column+0 
	MOVLW       hi_addr(_ticketTicket+0)
	MOVWF       FARG_mysql_read_string_column+1 
	MOVF        Net_Ethernet_28j60_UserTCP_cont_L0+0, 0 
	MOVWF       FARG_mysql_read_string_fila+0 
	MOVF        Net_Ethernet_28j60_UserTCP_cont_L0+1, 0 
	MOVWF       FARG_mysql_read_string_fila+1 
	MOVLW       Net_Ethernet_28j60_UserTCP_result_L0+0
	MOVWF       FARG_mysql_read_string_result+0 
	MOVLW       hi_addr(Net_Ethernet_28j60_UserTCP_result_L0+0)
	MOVWF       FARG_mysql_read_string_result+1 
	CALL        _mysql_read_string+0, 0
;TPV.c,1147 :: 		usart_write(result);
	MOVF        Net_Ethernet_28j60_UserTCP_result_L0+0, 0 
	MOVWF       FARG_usart_write_caracter+0 
	CALL        _usart_write+0, 0
;TPV.c,1145 :: 		for(cont = 1; cont <= myTable.rowAct; cont++){
	INFSNZ      Net_Ethernet_28j60_UserTCP_cont_L0+0, 1 
	INCF        Net_Ethernet_28j60_UserTCP_cont_L0+1, 1 
;TPV.c,1148 :: 		}
	GOTO        L_Net_Ethernet_28j60_UserTCP755
L_Net_Ethernet_28j60_UserTCP756:
;TPV.c,1149 :: 		}
L_Net_Ethernet_28j60_UserTCP754:
;TPV.c,1150 :: 		}
L_Net_Ethernet_28j60_UserTCP753:
L_Net_Ethernet_28j60_UserTCP752:
L_Net_Ethernet_28j60_UserTCP750:
L_Net_Ethernet_28j60_UserTCP745:
;TPV.c,1152 :: 		numToString(myTable.rowAct, msjConst, 4);
	MOVF        TPV_myTable+4, 0 
	MOVWF       FARG_numToString_valor+0 
	MOVF        TPV_myTable+5, 0 
	MOVWF       FARG_numToString_valor+1 
	MOVLW       0
	MOVWF       FARG_numToString_valor+2 
	MOVWF       FARG_numToString_valor+3 
	MOVLW       _msjConst+0
	MOVWF       FARG_numToString_cadena+0 
	MOVLW       hi_addr(_msjConst+0)
	MOVWF       FARG_numToString_cadena+1 
	MOVLW       4
	MOVWF       FARG_numToString_digitos+0 
	CALL        _numToString+0, 0
;TPV.c,1153 :: 		string_add(respuesta, msjConst);
	MOVLW       Net_Ethernet_28j60_UserTCP_respuesta_L0+0
	MOVWF       FARG_string_add_destino+0 
	MOVLW       hi_addr(Net_Ethernet_28j60_UserTCP_respuesta_L0+0)
	MOVWF       FARG_string_add_destino+1 
	MOVLW       _msjConst+0
	MOVWF       FARG_string_add_addEnd+0 
	MOVLW       hi_addr(_msjConst+0)
	MOVWF       FARG_string_add_addEnd+1 
	CALL        _string_add+0, 0
;TPV.c,1154 :: 		}else if(string_cmpnc(TCP_CAN_EXP, &getRequest[sizeTotal], sizeKey)){
	GOTO        L_Net_Ethernet_28j60_UserTCP758
L_Net_Ethernet_28j60_UserTCP743:
	MOVLW       _TCP_CAN_EXP+0
	MOVWF       FARG_string_cmpnc_text1+0 
	MOVLW       hi_addr(_TCP_CAN_EXP+0)
	MOVWF       FARG_string_cmpnc_text1+1 
	MOVLW       higher_addr(_TCP_CAN_EXP+0)
	MOVWF       FARG_string_cmpnc_text1+2 
	MOVLW       _getRequest+0
	MOVWF       FARG_string_cmpnc_text2+0 
	MOVLW       hi_addr(_getRequest+0)
	MOVWF       FARG_string_cmpnc_text2+1 
	MOVF        Net_Ethernet_28j60_UserTCP_sizeTotal_L0+0, 0 
	ADDWF       FARG_string_cmpnc_text2+0, 1 
	BTFSC       STATUS+0, 0 
	INCF        FARG_string_cmpnc_text2+1, 1 
	MOVF        Net_Ethernet_28j60_UserTCP_sizeKey_L0+0, 0 
	MOVWF       FARG_string_cmpnc_bytes+0 
	CALL        _string_cmpnc+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_Net_Ethernet_28j60_UserTCP759
;TPV.c,1155 :: 		sizeTotal += sizeKey;
	MOVF        Net_Ethernet_28j60_UserTCP_sizeKey_L0+0, 0 
	ADDWF       Net_Ethernet_28j60_UserTCP_sizeTotal_L0+0, 1 
;TPV.c,1156 :: 		sizeKey = sizeof(TCP_TABLE_ERASE)-1;
	MOVLW       3
	MOVWF       Net_Ethernet_28j60_UserTCP_sizeKey_L0+0 
;TPV.c,1158 :: 		string_addc(respuesta, TCP_CAN_EXP);
	MOVLW       Net_Ethernet_28j60_UserTCP_respuesta_L0+0
	MOVWF       FARG_string_addc_destino+0 
	MOVLW       hi_addr(Net_Ethernet_28j60_UserTCP_respuesta_L0+0)
	MOVWF       FARG_string_addc_destino+1 
	MOVLW       _TCP_CAN_EXP+0
	MOVWF       FARG_string_addc_addEnd+0 
	MOVLW       hi_addr(_TCP_CAN_EXP+0)
	MOVWF       FARG_string_addc_addEnd+1 
	MOVLW       higher_addr(_TCP_CAN_EXP+0)
	MOVWF       FARG_string_addc_addEnd+2 
	CALL        _string_addc+0, 0
;TPV.c,1159 :: 		if(string_cmpnc(TCP_TABLE_ERASE, &getRequest[sizeTotal], sizeKey)){
	MOVLW       _TCP_TABLE_ERASE+0
	MOVWF       FARG_string_cmpnc_text1+0 
	MOVLW       hi_addr(_TCP_TABLE_ERASE+0)
	MOVWF       FARG_string_cmpnc_text1+1 
	MOVLW       higher_addr(_TCP_TABLE_ERASE+0)
	MOVWF       FARG_string_cmpnc_text1+2 
	MOVLW       _getRequest+0
	MOVWF       FARG_string_cmpnc_text2+0 
	MOVLW       hi_addr(_getRequest+0)
	MOVWF       FARG_string_cmpnc_text2+1 
	MOVF        Net_Ethernet_28j60_UserTCP_sizeTotal_L0+0, 0 
	ADDWF       FARG_string_cmpnc_text2+0, 1 
	BTFSC       STATUS+0, 0 
	INCF        FARG_string_cmpnc_text2+1, 1 
	MOVF        Net_Ethernet_28j60_UserTCP_sizeKey_L0+0, 0 
	MOVWF       FARG_string_cmpnc_bytes+0 
	CALL        _string_cmpnc+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_Net_Ethernet_28j60_UserTCP760
;TPV.c,1161 :: 		mysql_erase(tableTicketEXP);
	MOVLW       _tableTicketEXP+0
	MOVWF       FARG_mysql_erase_name+0 
	MOVLW       hi_addr(_tableTicketEXP+0)
	MOVWF       FARG_mysql_erase_name+1 
	CALL        _mysql_erase+0, 0
;TPV.c,1162 :: 		}else if(string_cmpnc(TCP_CAN_ANEXAR, &getRequest[sizeTotal], sizeKey)){
	GOTO        L_Net_Ethernet_28j60_UserTCP761
L_Net_Ethernet_28j60_UserTCP760:
	MOVLW       _TCP_CAN_ANEXAR+0
	MOVWF       FARG_string_cmpnc_text1+0 
	MOVLW       hi_addr(_TCP_CAN_ANEXAR+0)
	MOVWF       FARG_string_cmpnc_text1+1 
	MOVLW       higher_addr(_TCP_CAN_ANEXAR+0)
	MOVWF       FARG_string_cmpnc_text1+2 
	MOVLW       _getRequest+0
	MOVWF       FARG_string_cmpnc_text2+0 
	MOVLW       hi_addr(_getRequest+0)
	MOVWF       FARG_string_cmpnc_text2+1 
	MOVF        Net_Ethernet_28j60_UserTCP_sizeTotal_L0+0, 0 
	ADDWF       FARG_string_cmpnc_text2+0, 1 
	BTFSC       STATUS+0, 0 
	INCF        FARG_string_cmpnc_text2+1, 1 
	MOVF        Net_Ethernet_28j60_UserTCP_sizeKey_L0+0, 0 
	MOVWF       FARG_string_cmpnc_bytes+0 
	CALL        _string_cmpnc+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_Net_Ethernet_28j60_UserTCP762
;TPV.c,1163 :: 		sizeTotal += sizeKey;
	MOVF        Net_Ethernet_28j60_UserTCP_sizeKey_L0+0, 0 
	ADDWF       Net_Ethernet_28j60_UserTCP_sizeTotal_L0+0, 0 
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       Net_Ethernet_28j60_UserTCP_sizeTotal_L0+0 
;TPV.c,1164 :: 		sizeKey = sizeTotal + string_len(&getRequest[sizeTotal]);
	MOVLW       _getRequest+0
	MOVWF       FARG_string_len_texto+0 
	MOVLW       hi_addr(_getRequest+0)
	MOVWF       FARG_string_len_texto+1 
	MOVF        R0, 0 
	ADDWF       FARG_string_len_texto+0, 1 
	BTFSC       STATUS+0, 0 
	INCF        FARG_string_len_texto+1, 1 
	CALL        _string_len+0, 0
	MOVF        R0, 0 
	ADDWF       Net_Ethernet_28j60_UserTCP_sizeTotal_L0+0, 0 
	MOVWF       Net_Ethernet_28j60_UserTCP_sizeKey_L0+0 
;TPV.c,1166 :: 		for(cont = sizeTotal; cont < sizeKey; cont++)
	MOVF        Net_Ethernet_28j60_UserTCP_sizeTotal_L0+0, 0 
	MOVWF       Net_Ethernet_28j60_UserTCP_cont_L0+0 
	MOVLW       0
	MOVWF       Net_Ethernet_28j60_UserTCP_cont_L0+1 
L_Net_Ethernet_28j60_UserTCP763:
	MOVLW       0
	SUBWF       Net_Ethernet_28j60_UserTCP_cont_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__Net_Ethernet_28j60_UserTCP1389
	MOVF        Net_Ethernet_28j60_UserTCP_sizeKey_L0+0, 0 
	SUBWF       Net_Ethernet_28j60_UserTCP_cont_L0+0, 0 
L__Net_Ethernet_28j60_UserTCP1389:
	BTFSC       STATUS+0, 0 
	GOTO        L_Net_Ethernet_28j60_UserTCP764
;TPV.c,1167 :: 		mysql_write(tableTicketEXP, ticketTicket, -1, getRequest[cont], true);
	MOVLW       _tableTicketEXP+0
	MOVWF       FARG_mysql_write_name+0 
	MOVLW       hi_addr(_tableTicketEXP+0)
	MOVWF       FARG_mysql_write_name+1 
	MOVLW       _ticketTicket+0
	MOVWF       FARG_mysql_write_column+0 
	MOVLW       hi_addr(_ticketTicket+0)
	MOVWF       FARG_mysql_write_column+1 
	MOVLW       255
	MOVWF       FARG_mysql_write_fila+0 
	MOVLW       255
	MOVWF       FARG_mysql_write_fila+1 
	MOVLW       _getRequest+0
	ADDWF       Net_Ethernet_28j60_UserTCP_cont_L0+0, 0 
	MOVWF       FSR0 
	MOVLW       hi_addr(_getRequest+0)
	ADDWFC      Net_Ethernet_28j60_UserTCP_cont_L0+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       FARG_mysql_write_value+0 
	MOVLW       0
	MOVWF       FARG_mysql_write_value+1 
	MOVWF       FARG_mysql_write_value+2 
	MOVWF       FARG_mysql_write_value+3 
	MOVLW       0
	MOVWF       FARG_mysql_write_value+1 
	MOVWF       FARG_mysql_write_value+2 
	MOVWF       FARG_mysql_write_value+3 
	MOVLW       1
	MOVWF       FARG_mysql_write_endWrite+0 
	CALL        _mysql_write+0, 0
;TPV.c,1166 :: 		for(cont = sizeTotal; cont < sizeKey; cont++)
	INFSNZ      Net_Ethernet_28j60_UserTCP_cont_L0+0, 1 
	INCF        Net_Ethernet_28j60_UserTCP_cont_L0+1, 1 
;TPV.c,1167 :: 		mysql_write(tableTicketEXP, ticketTicket, -1, getRequest[cont], true);
	GOTO        L_Net_Ethernet_28j60_UserTCP763
L_Net_Ethernet_28j60_UserTCP764:
;TPV.c,1168 :: 		}else if(string_cmpnc(TCP_CAN_FINALIZAR, &getRequest[sizeTotal], sizeKey)){
	GOTO        L_Net_Ethernet_28j60_UserTCP766
L_Net_Ethernet_28j60_UserTCP762:
	MOVLW       _TCP_CAN_FINALIZAR+0
	MOVWF       FARG_string_cmpnc_text1+0 
	MOVLW       hi_addr(_TCP_CAN_FINALIZAR+0)
	MOVWF       FARG_string_cmpnc_text1+1 
	MOVLW       higher_addr(_TCP_CAN_FINALIZAR+0)
	MOVWF       FARG_string_cmpnc_text1+2 
	MOVLW       _getRequest+0
	MOVWF       FARG_string_cmpnc_text2+0 
	MOVLW       hi_addr(_getRequest+0)
	MOVWF       FARG_string_cmpnc_text2+1 
	MOVF        Net_Ethernet_28j60_UserTCP_sizeTotal_L0+0, 0 
	ADDWF       FARG_string_cmpnc_text2+0, 1 
	BTFSC       STATUS+0, 0 
	INCF        FARG_string_cmpnc_text2+1, 1 
	MOVF        Net_Ethernet_28j60_UserTCP_sizeKey_L0+0, 0 
	MOVWF       FARG_string_cmpnc_bytes+0 
	CALL        _string_cmpnc+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_Net_Ethernet_28j60_UserTCP767
;TPV.c,1170 :: 		mysql_write(tableTicketEXP, ticketTicket, -1, 0, true);
	MOVLW       _tableTicketEXP+0
	MOVWF       FARG_mysql_write_name+0 
	MOVLW       hi_addr(_tableTicketEXP+0)
	MOVWF       FARG_mysql_write_name+1 
	MOVLW       _ticketTicket+0
	MOVWF       FARG_mysql_write_column+0 
	MOVLW       hi_addr(_ticketTicket+0)
	MOVWF       FARG_mysql_write_column+1 
	MOVLW       255
	MOVWF       FARG_mysql_write_fila+0 
	MOVLW       255
	MOVWF       FARG_mysql_write_fila+1 
	CLRF        FARG_mysql_write_value+0 
	CLRF        FARG_mysql_write_value+1 
	CLRF        FARG_mysql_write_value+2 
	CLRF        FARG_mysql_write_value+3 
	MOVLW       1
	MOVWF       FARG_mysql_write_endWrite+0 
	CALL        _mysql_write+0, 0
;TPV.c,1171 :: 		}else if(string_cmpnc(TCP_CAN_IMPRIMIR, &getRequest[sizeTotal], sizeKey)){
	GOTO        L_Net_Ethernet_28j60_UserTCP768
L_Net_Ethernet_28j60_UserTCP767:
	MOVLW       _TCP_CAN_IMPRIMIR+0
	MOVWF       FARG_string_cmpnc_text1+0 
	MOVLW       hi_addr(_TCP_CAN_IMPRIMIR+0)
	MOVWF       FARG_string_cmpnc_text1+1 
	MOVLW       higher_addr(_TCP_CAN_IMPRIMIR+0)
	MOVWF       FARG_string_cmpnc_text1+2 
	MOVLW       _getRequest+0
	MOVWF       FARG_string_cmpnc_text2+0 
	MOVLW       hi_addr(_getRequest+0)
	MOVWF       FARG_string_cmpnc_text2+1 
	MOVF        Net_Ethernet_28j60_UserTCP_sizeTotal_L0+0, 0 
	ADDWF       FARG_string_cmpnc_text2+0, 1 
	BTFSC       STATUS+0, 0 
	INCF        FARG_string_cmpnc_text2+1, 1 
	MOVF        Net_Ethernet_28j60_UserTCP_sizeKey_L0+0, 0 
	MOVWF       FARG_string_cmpnc_bytes+0 
	CALL        _string_cmpnc+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_Net_Ethernet_28j60_UserTCP769
;TPV.c,1172 :: 		if(mysql_read_string(tableTicketEXP, ticketTicket, 1, &result)){
	MOVLW       _tableTicketEXP+0
	MOVWF       FARG_mysql_read_string_name+0 
	MOVLW       hi_addr(_tableTicketEXP+0)
	MOVWF       FARG_mysql_read_string_name+1 
	MOVLW       _ticketTicket+0
	MOVWF       FARG_mysql_read_string_column+0 
	MOVLW       hi_addr(_ticketTicket+0)
	MOVWF       FARG_mysql_read_string_column+1 
	MOVLW       1
	MOVWF       FARG_mysql_read_string_fila+0 
	MOVLW       0
	MOVWF       FARG_mysql_read_string_fila+1 
	MOVLW       Net_Ethernet_28j60_UserTCP_result_L0+0
	MOVWF       FARG_mysql_read_string_result+0 
	MOVLW       hi_addr(Net_Ethernet_28j60_UserTCP_result_L0+0)
	MOVWF       FARG_mysql_read_string_result+1 
	CALL        _mysql_read_string+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_Net_Ethernet_28j60_UserTCP770
;TPV.c,1173 :: 		usart_write_line("Emulando boleto");
	MOVLW       ?lstr31_TPV+0
	MOVWF       FARG_usart_write_line_texto+0 
	MOVLW       hi_addr(?lstr31_TPV+0)
	MOVWF       FARG_usart_write_line_texto+1 
	CALL        _usart_write_line+0, 0
;TPV.c,1174 :: 		for(cont = 1; cont <= myTable.rowAct; cont++){
	MOVLW       1
	MOVWF       Net_Ethernet_28j60_UserTCP_cont_L0+0 
	MOVLW       0
	MOVWF       Net_Ethernet_28j60_UserTCP_cont_L0+1 
L_Net_Ethernet_28j60_UserTCP771:
	MOVF        Net_Ethernet_28j60_UserTCP_cont_L0+1, 0 
	SUBWF       TPV_myTable+5, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__Net_Ethernet_28j60_UserTCP1390
	MOVF        Net_Ethernet_28j60_UserTCP_cont_L0+0, 0 
	SUBWF       TPV_myTable+4, 0 
L__Net_Ethernet_28j60_UserTCP1390:
	BTFSS       STATUS+0, 0 
	GOTO        L_Net_Ethernet_28j60_UserTCP772
;TPV.c,1175 :: 		mysql_read_string(tableTicketEXP, ticketTicket, cont, &result);
	MOVLW       _tableTicketEXP+0
	MOVWF       FARG_mysql_read_string_name+0 
	MOVLW       hi_addr(_tableTicketEXP+0)
	MOVWF       FARG_mysql_read_string_name+1 
	MOVLW       _ticketTicket+0
	MOVWF       FARG_mysql_read_string_column+0 
	MOVLW       hi_addr(_ticketTicket+0)
	MOVWF       FARG_mysql_read_string_column+1 
	MOVF        Net_Ethernet_28j60_UserTCP_cont_L0+0, 0 
	MOVWF       FARG_mysql_read_string_fila+0 
	MOVF        Net_Ethernet_28j60_UserTCP_cont_L0+1, 0 
	MOVWF       FARG_mysql_read_string_fila+1 
	MOVLW       Net_Ethernet_28j60_UserTCP_result_L0+0
	MOVWF       FARG_mysql_read_string_result+0 
	MOVLW       hi_addr(Net_Ethernet_28j60_UserTCP_result_L0+0)
	MOVWF       FARG_mysql_read_string_result+1 
	CALL        _mysql_read_string+0, 0
;TPV.c,1176 :: 		usart_write(result);
	MOVF        Net_Ethernet_28j60_UserTCP_result_L0+0, 0 
	MOVWF       FARG_usart_write_caracter+0 
	CALL        _usart_write+0, 0
;TPV.c,1174 :: 		for(cont = 1; cont <= myTable.rowAct; cont++){
	INFSNZ      Net_Ethernet_28j60_UserTCP_cont_L0+0, 1 
	INCF        Net_Ethernet_28j60_UserTCP_cont_L0+1, 1 
;TPV.c,1177 :: 		}
	GOTO        L_Net_Ethernet_28j60_UserTCP771
L_Net_Ethernet_28j60_UserTCP772:
;TPV.c,1178 :: 		usart_write_line("");
	MOVLW       ?lstr32_TPV+0
	MOVWF       FARG_usart_write_line_texto+0 
	MOVLW       hi_addr(?lstr32_TPV+0)
	MOVWF       FARG_usart_write_line_texto+1 
	CALL        _usart_write_line+0, 0
;TPV.c,1179 :: 		}
L_Net_Ethernet_28j60_UserTCP770:
;TPV.c,1180 :: 		}
L_Net_Ethernet_28j60_UserTCP769:
L_Net_Ethernet_28j60_UserTCP768:
L_Net_Ethernet_28j60_UserTCP766:
L_Net_Ethernet_28j60_UserTCP761:
;TPV.c,1182 :: 		numToString(myTable.rowAct, msjConst, 4);
	MOVF        TPV_myTable+4, 0 
	MOVWF       FARG_numToString_valor+0 
	MOVF        TPV_myTable+5, 0 
	MOVWF       FARG_numToString_valor+1 
	MOVLW       0
	MOVWF       FARG_numToString_valor+2 
	MOVWF       FARG_numToString_valor+3 
	MOVLW       _msjConst+0
	MOVWF       FARG_numToString_cadena+0 
	MOVLW       hi_addr(_msjConst+0)
	MOVWF       FARG_numToString_cadena+1 
	MOVLW       4
	MOVWF       FARG_numToString_digitos+0 
	CALL        _numToString+0, 0
;TPV.c,1183 :: 		string_add(respuesta, msjConst);
	MOVLW       Net_Ethernet_28j60_UserTCP_respuesta_L0+0
	MOVWF       FARG_string_add_destino+0 
	MOVLW       hi_addr(Net_Ethernet_28j60_UserTCP_respuesta_L0+0)
	MOVWF       FARG_string_add_destino+1 
	MOVLW       _msjConst+0
	MOVWF       FARG_string_add_addEnd+0 
	MOVLW       hi_addr(_msjConst+0)
	MOVWF       FARG_string_add_addEnd+1 
	CALL        _string_add+0, 0
;TPV.c,1184 :: 		}
L_Net_Ethernet_28j60_UserTCP759:
L_Net_Ethernet_28j60_UserTCP758:
;TPV.c,1185 :: 		}else if(string_cmpnc(TCP_CAN_PREPAGO, &getRequest[sizeTotal], sizeKey)){
	GOTO        L_Net_Ethernet_28j60_UserTCP774
L_Net_Ethernet_28j60_UserTCP742:
	MOVLW       _TCP_CAN_PREPAGO+0
	MOVWF       FARG_string_cmpnc_text1+0 
	MOVLW       hi_addr(_TCP_CAN_PREPAGO+0)
	MOVWF       FARG_string_cmpnc_text1+1 
	MOVLW       higher_addr(_TCP_CAN_PREPAGO+0)
	MOVWF       FARG_string_cmpnc_text1+2 
	MOVLW       _getRequest+0
	MOVWF       FARG_string_cmpnc_text2+0 
	MOVLW       hi_addr(_getRequest+0)
	MOVWF       FARG_string_cmpnc_text2+1 
	MOVF        Net_Ethernet_28j60_UserTCP_sizeTotal_L0+0, 0 
	ADDWF       FARG_string_cmpnc_text2+0, 1 
	BTFSC       STATUS+0, 0 
	INCF        FARG_string_cmpnc_text2+1, 1 
	MOVF        Net_Ethernet_28j60_UserTCP_sizeKey_L0+0, 0 
	MOVWF       FARG_string_cmpnc_bytes+0 
	CALL        _string_cmpnc+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_Net_Ethernet_28j60_UserTCP775
;TPV.c,1187 :: 		sizeTotal += sizeKey;
	MOVF        Net_Ethernet_28j60_UserTCP_sizeKey_L0+0, 0 
	ADDWF       Net_Ethernet_28j60_UserTCP_sizeTotal_L0+0, 0 
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       Net_Ethernet_28j60_UserTCP_sizeTotal_L0+0 
;TPV.c,1188 :: 		sizeKey = 6;  //3 Bytes en hexadecimal
	MOVLW       6
	MOVWF       Net_Ethernet_28j60_UserTCP_sizeKey_L0+0 
;TPV.c,1189 :: 		string_cpyn(msjConst, &getRequest[sizeTotal], sizeKey);
	MOVLW       _msjConst+0
	MOVWF       FARG_string_cpyn_destino+0 
	MOVLW       hi_addr(_msjConst+0)
	MOVWF       FARG_string_cpyn_destino+1 
	MOVLW       _getRequest+0
	MOVWF       FARG_string_cpyn_origen+0 
	MOVLW       hi_addr(_getRequest+0)
	MOVWF       FARG_string_cpyn_origen+1 
	MOVF        R0, 0 
	ADDWF       FARG_string_cpyn_origen+0, 1 
	BTFSC       STATUS+0, 0 
	INCF        FARG_string_cpyn_origen+1, 1 
	MOVLW       6
	MOVWF       FARG_string_cpyn_size+0 
	CALL        _string_cpyn+0, 0
;TPV.c,1190 :: 		idConsulta = hexToNum(msjConst);
	MOVLW       _msjConst+0
	MOVWF       FARG_hexToNum_hex+0 
	MOVLW       hi_addr(_msjConst+0)
	MOVWF       FARG_hexToNum_hex+1 
	CALL        _hexToNum+0, 0
	MOVF        R0, 0 
	MOVWF       Net_Ethernet_28j60_UserTCP_idConsulta_L0+0 
	MOVF        R1, 0 
	MOVWF       Net_Ethernet_28j60_UserTCP_idConsulta_L0+1 
	MOVF        R2, 0 
	MOVWF       Net_Ethernet_28j60_UserTCP_idConsulta_L0+2 
	MOVF        R3, 0 
	MOVWF       Net_Ethernet_28j60_UserTCP_idConsulta_L0+3 
;TPV.c,1192 :: 		result = !mysql_search(tablePrepago, prepagoID, idConsulta, &fila);
	MOVLW       _tablePrepago+0
	MOVWF       FARG_mysql_search_tabla+0 
	MOVLW       hi_addr(_tablePrepago+0)
	MOVWF       FARG_mysql_search_tabla+1 
	MOVLW       _prepagoId+0
	MOVWF       FARG_mysql_search_columna+0 
	MOVLW       hi_addr(_prepagoId+0)
	MOVWF       FARG_mysql_search_columna+1 
	MOVF        R0, 0 
	MOVWF       FARG_mysql_search_buscar+0 
	MOVF        R1, 0 
	MOVWF       FARG_mysql_search_buscar+1 
	MOVF        R2, 0 
	MOVWF       FARG_mysql_search_buscar+2 
	MOVF        R3, 0 
	MOVWF       FARG_mysql_search_buscar+3 
	MOVLW       Net_Ethernet_28j60_UserTCP_fila_L0+0
	MOVWF       FARG_mysql_search_fila+0 
	MOVLW       hi_addr(Net_Ethernet_28j60_UserTCP_fila_L0+0)
	MOVWF       FARG_mysql_search_fila+1 
	CALL        _mysql_search+0, 0
	MOVF        R0, 1 
	MOVLW       1
	BTFSS       STATUS+0, 2 
	MOVLW       0
	MOVWF       Net_Ethernet_28j60_UserTCP_result_L0+0 
;TPV.c,1194 :: 		sizeTotal += sizeKey;
	MOVF        Net_Ethernet_28j60_UserTCP_sizeKey_L0+0, 0 
	ADDWF       Net_Ethernet_28j60_UserTCP_sizeTotal_L0+0, 0 
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       Net_Ethernet_28j60_UserTCP_sizeTotal_L0+0 
;TPV.c,1195 :: 		sizeKey = sizeof(TCP_CAN_REGISTRAR)-1;
	MOVLW       3
	MOVWF       Net_Ethernet_28j60_UserTCP_sizeKey_L0+0 
;TPV.c,1197 :: 		string_cpyn(respuesta, getRequest, sizeTotal+sizeKey);
	MOVLW       Net_Ethernet_28j60_UserTCP_respuesta_L0+0
	MOVWF       FARG_string_cpyn_destino+0 
	MOVLW       hi_addr(Net_Ethernet_28j60_UserTCP_respuesta_L0+0)
	MOVWF       FARG_string_cpyn_destino+1 
	MOVLW       _getRequest+0
	MOVWF       FARG_string_cpyn_origen+0 
	MOVLW       hi_addr(_getRequest+0)
	MOVWF       FARG_string_cpyn_origen+1 
	MOVLW       3
	ADDWF       R0, 0 
	MOVWF       FARG_string_cpyn_size+0 
	CALL        _string_cpyn+0, 0
;TPV.c,1199 :: 		string_cpyn(bufferEeprom, getRequest, sizeTotal+sizeKey);
	MOVLW       _bufferEeprom+0
	MOVWF       FARG_string_cpyn_destino+0 
	MOVLW       hi_addr(_bufferEeprom+0)
	MOVWF       FARG_string_cpyn_destino+1 
	MOVLW       _getRequest+0
	MOVWF       FARG_string_cpyn_origen+0 
	MOVLW       hi_addr(_getRequest+0)
	MOVWF       FARG_string_cpyn_origen+1 
	MOVF        Net_Ethernet_28j60_UserTCP_sizeKey_L0+0, 0 
	ADDWF       Net_Ethernet_28j60_UserTCP_sizeTotal_L0+0, 0 
	MOVWF       FARG_string_cpyn_size+0 
	CALL        _string_cpyn+0, 0
;TPV.c,1201 :: 		if(string_cmpnc(TCP_CAN_REGISTRAR, &getRequest[sizeTotal], sizeKey)){
	MOVLW       _TCP_CAN_REGISTRAR+0
	MOVWF       FARG_string_cmpnc_text1+0 
	MOVLW       hi_addr(_TCP_CAN_REGISTRAR+0)
	MOVWF       FARG_string_cmpnc_text1+1 
	MOVLW       higher_addr(_TCP_CAN_REGISTRAR+0)
	MOVWF       FARG_string_cmpnc_text1+2 
	MOVLW       _getRequest+0
	MOVWF       FARG_string_cmpnc_text2+0 
	MOVLW       hi_addr(_getRequest+0)
	MOVWF       FARG_string_cmpnc_text2+1 
	MOVF        Net_Ethernet_28j60_UserTCP_sizeTotal_L0+0, 0 
	ADDWF       FARG_string_cmpnc_text2+0, 1 
	BTFSC       STATUS+0, 0 
	INCF        FARG_string_cmpnc_text2+1, 1 
	MOVF        Net_Ethernet_28j60_UserTCP_sizeKey_L0+0, 0 
	MOVWF       FARG_string_cmpnc_bytes+0 
	CALL        _string_cmpnc+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_Net_Ethernet_28j60_UserTCP776
;TPV.c,1203 :: 		sizeTotal += sizeKey;
	MOVF        Net_Ethernet_28j60_UserTCP_sizeKey_L0+0, 0 
	ADDWF       Net_Ethernet_28j60_UserTCP_sizeTotal_L0+0, 1 
;TPV.c,1205 :: 		estatus = !mysql_search(tablePensionados, pensionadosID, idConsulta, &filaAux);
	MOVLW       _tablePensionados+0
	MOVWF       FARG_mysql_search_tabla+0 
	MOVLW       hi_addr(_tablePensionados+0)
	MOVWF       FARG_mysql_search_tabla+1 
	MOVLW       _pensionadosID+0
	MOVWF       FARG_mysql_search_columna+0 
	MOVLW       hi_addr(_pensionadosID+0)
	MOVWF       FARG_mysql_search_columna+1 
	MOVF        Net_Ethernet_28j60_UserTCP_idConsulta_L0+0, 0 
	MOVWF       FARG_mysql_search_buscar+0 
	MOVF        Net_Ethernet_28j60_UserTCP_idConsulta_L0+1, 0 
	MOVWF       FARG_mysql_search_buscar+1 
	MOVF        Net_Ethernet_28j60_UserTCP_idConsulta_L0+2, 0 
	MOVWF       FARG_mysql_search_buscar+2 
	MOVF        Net_Ethernet_28j60_UserTCP_idConsulta_L0+3, 0 
	MOVWF       FARG_mysql_search_buscar+3 
	MOVLW       Net_Ethernet_28j60_UserTCP_filaAux_L0+0
	MOVWF       FARG_mysql_search_fila+0 
	MOVLW       hi_addr(Net_Ethernet_28j60_UserTCP_filaAux_L0+0)
	MOVWF       FARG_mysql_search_fila+1 
	CALL        _mysql_search+0, 0
	MOVF        R0, 1 
	MOVLW       1
	BTFSS       STATUS+0, 2 
	MOVLW       0
	MOVWF       Net_Ethernet_28j60_UserTCP_estatus_L0+0 
;TPV.c,1206 :: 		estatus |= !mysql_search(tableSoporte, soporteID, idConsulta, &filaAux);
	MOVLW       _tableSoporte+0
	MOVWF       FARG_mysql_search_tabla+0 
	MOVLW       hi_addr(_tableSoporte+0)
	MOVWF       FARG_mysql_search_tabla+1 
	MOVLW       _soporteID+0
	MOVWF       FARG_mysql_search_columna+0 
	MOVLW       hi_addr(_soporteID+0)
	MOVWF       FARG_mysql_search_columna+1 
	MOVF        Net_Ethernet_28j60_UserTCP_idConsulta_L0+0, 0 
	MOVWF       FARG_mysql_search_buscar+0 
	MOVF        Net_Ethernet_28j60_UserTCP_idConsulta_L0+1, 0 
	MOVWF       FARG_mysql_search_buscar+1 
	MOVF        Net_Ethernet_28j60_UserTCP_idConsulta_L0+2, 0 
	MOVWF       FARG_mysql_search_buscar+2 
	MOVF        Net_Ethernet_28j60_UserTCP_idConsulta_L0+3, 0 
	MOVWF       FARG_mysql_search_buscar+3 
	MOVLW       Net_Ethernet_28j60_UserTCP_filaAux_L0+0
	MOVWF       FARG_mysql_search_fila+0 
	MOVLW       hi_addr(Net_Ethernet_28j60_UserTCP_filaAux_L0+0)
	MOVWF       FARG_mysql_search_fila+1 
	CALL        _mysql_search+0, 0
	MOVF        R0, 1 
	MOVLW       1
	BTFSS       STATUS+0, 2 
	MOVLW       0
	MOVWF       R1 
	MOVF        R1, 0 
	IORWF       Net_Ethernet_28j60_UserTCP_estatus_L0+0, 1 
;TPV.c,1208 :: 		if(result || estatus){
	MOVF        Net_Ethernet_28j60_UserTCP_result_L0+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L__Net_Ethernet_28j60_UserTCP1018
	MOVF        Net_Ethernet_28j60_UserTCP_estatus_L0+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L__Net_Ethernet_28j60_UserTCP1018
	GOTO        L_Net_Ethernet_28j60_UserTCP779
L__Net_Ethernet_28j60_UserTCP1018:
;TPV.c,1209 :: 		string_addc(respuesta, result?TCP_TBL_DUPLICADO:TCP_TBL_REG_PREVIO);
	MOVLW       Net_Ethernet_28j60_UserTCP_respuesta_L0+0
	MOVWF       FARG_string_addc_destino+0 
	MOVLW       hi_addr(Net_Ethernet_28j60_UserTCP_respuesta_L0+0)
	MOVWF       FARG_string_addc_destino+1 
	MOVF        Net_Ethernet_28j60_UserTCP_result_L0+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_Net_Ethernet_28j60_UserTCP780
	MOVLW       _TCP_TBL_DUPLICADO+0
	MOVWF       ?FLOC___Net_Ethernet_28j60_UserTCPT3268+0 
	MOVLW       hi_addr(_TCP_TBL_DUPLICADO+0)
	MOVWF       ?FLOC___Net_Ethernet_28j60_UserTCPT3268+1 
	MOVLW       higher_addr(_TCP_TBL_DUPLICADO+0)
	MOVWF       ?FLOC___Net_Ethernet_28j60_UserTCPT3268+2 
	GOTO        L_Net_Ethernet_28j60_UserTCP781
L_Net_Ethernet_28j60_UserTCP780:
	MOVLW       _TCP_TBL_REG_PREVIO+0
	MOVWF       ?FLOC___Net_Ethernet_28j60_UserTCPT3268+0 
	MOVLW       hi_addr(_TCP_TBL_REG_PREVIO+0)
	MOVWF       ?FLOC___Net_Ethernet_28j60_UserTCPT3268+1 
	MOVLW       higher_addr(_TCP_TBL_REG_PREVIO+0)
	MOVWF       ?FLOC___Net_Ethernet_28j60_UserTCPT3268+2 
L_Net_Ethernet_28j60_UserTCP781:
	MOVF        ?FLOC___Net_Ethernet_28j60_UserTCPT3268+0, 0 
	MOVWF       FARG_string_addc_addEnd+0 
	MOVF        ?FLOC___Net_Ethernet_28j60_UserTCPT3268+1, 0 
	MOVWF       FARG_string_addc_addEnd+1 
	MOVF        ?FLOC___Net_Ethernet_28j60_UserTCPT3268+2, 0 
	MOVWF       FARG_string_addc_addEnd+2 
	CALL        _string_addc+0, 0
;TPV.c,1210 :: 		bufferEeprom[0] = 0; //FORZAR FINAL DE CADENA
	CLRF        _bufferEeprom+0 
;TPV.c,1211 :: 		}else{
	GOTO        L_Net_Ethernet_28j60_UserTCP782
L_Net_Ethernet_28j60_UserTCP779:
;TPV.c,1213 :: 		result = !mysql_write(tablePrepago, prepagoID, -1, idConsulta, true);
	MOVLW       _tablePrepago+0
	MOVWF       FARG_mysql_write_name+0 
	MOVLW       hi_addr(_tablePrepago+0)
	MOVWF       FARG_mysql_write_name+1 
	MOVLW       _prepagoId+0
	MOVWF       FARG_mysql_write_column+0 
	MOVLW       hi_addr(_prepagoId+0)
	MOVWF       FARG_mysql_write_column+1 
	MOVLW       255
	MOVWF       FARG_mysql_write_fila+0 
	MOVLW       255
	MOVWF       FARG_mysql_write_fila+1 
	MOVF        Net_Ethernet_28j60_UserTCP_idConsulta_L0+0, 0 
	MOVWF       FARG_mysql_write_value+0 
	MOVF        Net_Ethernet_28j60_UserTCP_idConsulta_L0+1, 0 
	MOVWF       FARG_mysql_write_value+1 
	MOVF        Net_Ethernet_28j60_UserTCP_idConsulta_L0+2, 0 
	MOVWF       FARG_mysql_write_value+2 
	MOVF        Net_Ethernet_28j60_UserTCP_idConsulta_L0+3, 0 
	MOVWF       FARG_mysql_write_value+3 
	MOVLW       1
	MOVWF       FARG_mysql_write_endWrite+0 
	CALL        _mysql_write+0, 0
	MOVF        R0, 1 
	MOVLW       1
	BTFSS       STATUS+0, 2 
	MOVLW       0
	MOVWF       R1 
	MOVF        R1, 0 
	MOVWF       Net_Ethernet_28j60_UserTCP_result_L0+0 
;TPV.c,1215 :: 		if(result){
	MOVF        R1, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_Net_Ethernet_28j60_UserTCP783
;TPV.c,1216 :: 		string_cpyn(msjConst, &getRequest[sizeTotal], 8);
	MOVLW       _msjConst+0
	MOVWF       FARG_string_cpyn_destino+0 
	MOVLW       hi_addr(_msjConst+0)
	MOVWF       FARG_string_cpyn_destino+1 
	MOVLW       _getRequest+0
	MOVWF       FARG_string_cpyn_origen+0 
	MOVLW       hi_addr(_getRequest+0)
	MOVWF       FARG_string_cpyn_origen+1 
	MOVF        Net_Ethernet_28j60_UserTCP_sizeTotal_L0+0, 0 
	ADDWF       FARG_string_cpyn_origen+0, 1 
	BTFSC       STATUS+0, 0 
	INCF        FARG_string_cpyn_origen+1, 1 
	MOVLW       8
	MOVWF       FARG_string_cpyn_size+0 
	CALL        _string_cpyn+0, 0
;TPV.c,1217 :: 		nip = hexToNum(msjConst);
	MOVLW       _msjConst+0
	MOVWF       FARG_hexToNum_hex+0 
	MOVLW       hi_addr(_msjConst+0)
	MOVWF       FARG_hexToNum_hex+1 
	CALL        _hexToNum+0, 0
	MOVF        R0, 0 
	MOVWF       Net_Ethernet_28j60_UserTCP_nip_L0+0 
	MOVF        R1, 0 
	MOVWF       Net_Ethernet_28j60_UserTCP_nip_L0+1 
	MOVF        R2, 0 
	MOVWF       Net_Ethernet_28j60_UserTCP_nip_L0+2 
	MOVF        R3, 0 
	MOVWF       Net_Ethernet_28j60_UserTCP_nip_L0+3 
;TPV.c,1218 :: 		string_cpyn(msjConst, &getRequest[sizeTotal+8], 8);
	MOVLW       _msjConst+0
	MOVWF       FARG_string_cpyn_destino+0 
	MOVLW       hi_addr(_msjConst+0)
	MOVWF       FARG_string_cpyn_destino+1 
	MOVLW       8
	ADDWF       Net_Ethernet_28j60_UserTCP_sizeTotal_L0+0, 0 
	MOVWF       R0 
	CLRF        R1 
	MOVLW       0
	ADDWFC      R1, 1 
	MOVLW       _getRequest+0
	ADDWF       R0, 0 
	MOVWF       FARG_string_cpyn_origen+0 
	MOVLW       hi_addr(_getRequest+0)
	ADDWFC      R1, 0 
	MOVWF       FARG_string_cpyn_origen+1 
	MOVLW       8
	MOVWF       FARG_string_cpyn_size+0 
	CALL        _string_cpyn+0, 0
;TPV.c,1219 :: 		saldo = hexToNum(msjConst);
	MOVLW       _msjConst+0
	MOVWF       FARG_hexToNum_hex+0 
	MOVLW       hi_addr(_msjConst+0)
	MOVWF       FARG_hexToNum_hex+1 
	CALL        _hexToNum+0, 0
	MOVF        R0, 0 
	MOVWF       Net_Ethernet_28j60_UserTCP_saldo_L0+0 
	MOVF        R1, 0 
	MOVWF       Net_Ethernet_28j60_UserTCP_saldo_L0+1 
	MOVF        R2, 0 
	MOVWF       Net_Ethernet_28j60_UserTCP_saldo_L0+2 
	MOVF        R3, 0 
	MOVWF       Net_Ethernet_28j60_UserTCP_saldo_L0+3 
;TPV.c,1220 :: 		estatus =  getRequest[sizeTotal+16];
	MOVLW       16
	ADDWF       Net_Ethernet_28j60_UserTCP_sizeTotal_L0+0, 0 
	MOVWF       R0 
	CLRF        R1 
	MOVLW       0
	ADDWFC      R1, 1 
	MOVLW       _getRequest+0
	ADDWF       R0, 0 
	MOVWF       FSR0 
	MOVLW       hi_addr(_getRequest+0)
	ADDWFC      R1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       Net_Ethernet_28j60_UserTCP_estatus_L0+0 
;TPV.c,1222 :: 		mysql_write(tablePrepago,prepagoNIP, myTable.rowAct, nip, false);
	MOVLW       _tablePrepago+0
	MOVWF       FARG_mysql_write_name+0 
	MOVLW       hi_addr(_tablePrepago+0)
	MOVWF       FARG_mysql_write_name+1 
	MOVLW       _prepagoNip+0
	MOVWF       FARG_mysql_write_column+0 
	MOVLW       hi_addr(_prepagoNip+0)
	MOVWF       FARG_mysql_write_column+1 
	MOVF        TPV_myTable+4, 0 
	MOVWF       FARG_mysql_write_fila+0 
	MOVF        TPV_myTable+5, 0 
	MOVWF       FARG_mysql_write_fila+1 
	MOVF        Net_Ethernet_28j60_UserTCP_nip_L0+0, 0 
	MOVWF       FARG_mysql_write_value+0 
	MOVF        Net_Ethernet_28j60_UserTCP_nip_L0+1, 0 
	MOVWF       FARG_mysql_write_value+1 
	MOVF        Net_Ethernet_28j60_UserTCP_nip_L0+2, 0 
	MOVWF       FARG_mysql_write_value+2 
	MOVF        Net_Ethernet_28j60_UserTCP_nip_L0+3, 0 
	MOVWF       FARG_mysql_write_value+3 
	CLRF        FARG_mysql_write_endWrite+0 
	CALL        _mysql_write+0, 0
;TPV.c,1223 :: 		mysql_write(tablePrepago,prepagoSaldo, myTable.rowAct, saldo, false);
	MOVLW       _tablePrepago+0
	MOVWF       FARG_mysql_write_name+0 
	MOVLW       hi_addr(_tablePrepago+0)
	MOVWF       FARG_mysql_write_name+1 
	MOVLW       _prepagoSaldo+0
	MOVWF       FARG_mysql_write_column+0 
	MOVLW       hi_addr(_prepagoSaldo+0)
	MOVWF       FARG_mysql_write_column+1 
	MOVF        TPV_myTable+4, 0 
	MOVWF       FARG_mysql_write_fila+0 
	MOVF        TPV_myTable+5, 0 
	MOVWF       FARG_mysql_write_fila+1 
	MOVF        Net_Ethernet_28j60_UserTCP_saldo_L0+0, 0 
	MOVWF       FARG_mysql_write_value+0 
	MOVF        Net_Ethernet_28j60_UserTCP_saldo_L0+1, 0 
	MOVWF       FARG_mysql_write_value+1 
	MOVF        Net_Ethernet_28j60_UserTCP_saldo_L0+2, 0 
	MOVWF       FARG_mysql_write_value+2 
	MOVF        Net_Ethernet_28j60_UserTCP_saldo_L0+3, 0 
	MOVWF       FARG_mysql_write_value+3 
	CLRF        FARG_mysql_write_endWrite+0 
	CALL        _mysql_write+0, 0
;TPV.c,1224 :: 		mysql_write(tablePrepago,prepagoEstatus, myTable.rowAct, estatus, false);
	MOVLW       _tablePrepago+0
	MOVWF       FARG_mysql_write_name+0 
	MOVLW       hi_addr(_tablePrepago+0)
	MOVWF       FARG_mysql_write_name+1 
	MOVLW       _prepagoEstatus+0
	MOVWF       FARG_mysql_write_column+0 
	MOVLW       hi_addr(_prepagoEstatus+0)
	MOVWF       FARG_mysql_write_column+1 
	MOVF        TPV_myTable+4, 0 
	MOVWF       FARG_mysql_write_fila+0 
	MOVF        TPV_myTable+5, 0 
	MOVWF       FARG_mysql_write_fila+1 
	MOVF        Net_Ethernet_28j60_UserTCP_estatus_L0+0, 0 
	MOVWF       FARG_mysql_write_value+0 
	MOVLW       0
	MOVWF       FARG_mysql_write_value+1 
	MOVWF       FARG_mysql_write_value+2 
	MOVWF       FARG_mysql_write_value+3 
	CLRF        FARG_mysql_write_endWrite+0 
	CALL        _mysql_write+0, 0
;TPV.c,1225 :: 		string_addc(respuesta, TCP_TBL_REGISTRADO);
	MOVLW       Net_Ethernet_28j60_UserTCP_respuesta_L0+0
	MOVWF       FARG_string_addc_destino+0 
	MOVLW       hi_addr(Net_Ethernet_28j60_UserTCP_respuesta_L0+0)
	MOVWF       FARG_string_addc_destino+1 
	MOVLW       _TCP_TBL_REGISTRADO+0
	MOVWF       FARG_string_addc_addEnd+0 
	MOVLW       hi_addr(_TCP_TBL_REGISTRADO+0)
	MOVWF       FARG_string_addc_addEnd+1 
	MOVLW       higher_addr(_TCP_TBL_REGISTRADO+0)
	MOVWF       FARG_string_addc_addEnd+2 
	CALL        _string_addc+0, 0
;TPV.c,1226 :: 		}else{
	GOTO        L_Net_Ethernet_28j60_UserTCP784
L_Net_Ethernet_28j60_UserTCP783:
;TPV.c,1227 :: 		string_addc(respuesta, TCP_TBL_LLENA);
	MOVLW       Net_Ethernet_28j60_UserTCP_respuesta_L0+0
	MOVWF       FARG_string_addc_destino+0 
	MOVLW       hi_addr(Net_Ethernet_28j60_UserTCP_respuesta_L0+0)
	MOVWF       FARG_string_addc_destino+1 
	MOVLW       _TCP_TBL_LLENA+0
	MOVWF       FARG_string_addc_addEnd+0 
	MOVLW       hi_addr(_TCP_TBL_LLENA+0)
	MOVWF       FARG_string_addc_addEnd+1 
	MOVLW       higher_addr(_TCP_TBL_LLENA+0)
	MOVWF       FARG_string_addc_addEnd+2 
	CALL        _string_addc+0, 0
;TPV.c,1228 :: 		bufferEeprom[0] = 0; //FORZAR FINAL DE CADENA
	CLRF        _bufferEeprom+0 
;TPV.c,1229 :: 		}
L_Net_Ethernet_28j60_UserTCP784:
;TPV.c,1230 :: 		}
L_Net_Ethernet_28j60_UserTCP782:
;TPV.c,1231 :: 		}else if(string_cmpnc(TCP_CAN_ACTUALIZAR, &getRequest[sizeTotal], sizeKey)){
	GOTO        L_Net_Ethernet_28j60_UserTCP785
L_Net_Ethernet_28j60_UserTCP776:
	MOVLW       _TCP_CAN_ACTUALIZAR+0
	MOVWF       FARG_string_cmpnc_text1+0 
	MOVLW       hi_addr(_TCP_CAN_ACTUALIZAR+0)
	MOVWF       FARG_string_cmpnc_text1+1 
	MOVLW       higher_addr(_TCP_CAN_ACTUALIZAR+0)
	MOVWF       FARG_string_cmpnc_text1+2 
	MOVLW       _getRequest+0
	MOVWF       FARG_string_cmpnc_text2+0 
	MOVLW       hi_addr(_getRequest+0)
	MOVWF       FARG_string_cmpnc_text2+1 
	MOVF        Net_Ethernet_28j60_UserTCP_sizeTotal_L0+0, 0 
	ADDWF       FARG_string_cmpnc_text2+0, 1 
	BTFSC       STATUS+0, 0 
	INCF        FARG_string_cmpnc_text2+1, 1 
	MOVF        Net_Ethernet_28j60_UserTCP_sizeKey_L0+0, 0 
	MOVWF       FARG_string_cmpnc_bytes+0 
	CALL        _string_cmpnc+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_Net_Ethernet_28j60_UserTCP786
;TPV.c,1233 :: 		sizeTotal += sizeKey;
	MOVF        Net_Ethernet_28j60_UserTCP_sizeKey_L0+0, 0 
	ADDWF       Net_Ethernet_28j60_UserTCP_sizeTotal_L0+0, 1 
;TPV.c,1234 :: 		if(result){
	MOVF        Net_Ethernet_28j60_UserTCP_result_L0+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_Net_Ethernet_28j60_UserTCP787
;TPV.c,1236 :: 		string_cpyn(msjConst, &getRequest[sizeTotal], 6);
	MOVLW       _msjConst+0
	MOVWF       FARG_string_cpyn_destino+0 
	MOVLW       hi_addr(_msjConst+0)
	MOVWF       FARG_string_cpyn_destino+1 
	MOVLW       _getRequest+0
	MOVWF       FARG_string_cpyn_origen+0 
	MOVLW       hi_addr(_getRequest+0)
	MOVWF       FARG_string_cpyn_origen+1 
	MOVF        Net_Ethernet_28j60_UserTCP_sizeTotal_L0+0, 0 
	ADDWF       FARG_string_cpyn_origen+0, 1 
	BTFSC       STATUS+0, 0 
	INCF        FARG_string_cpyn_origen+1, 1 
	MOVLW       6
	MOVWF       FARG_string_cpyn_size+0 
	CALL        _string_cpyn+0, 0
;TPV.c,1237 :: 		idNuevo = hexToNum(msjConst);
	MOVLW       _msjConst+0
	MOVWF       FARG_hexToNum_hex+0 
	MOVLW       hi_addr(_msjConst+0)
	MOVWF       FARG_hexToNum_hex+1 
	CALL        _hexToNum+0, 0
	MOVF        R0, 0 
	MOVWF       Net_Ethernet_28j60_UserTCP_idNuevo_L0+0 
	MOVF        R1, 0 
	MOVWF       Net_Ethernet_28j60_UserTCP_idNuevo_L0+1 
	MOVF        R2, 0 
	MOVWF       Net_Ethernet_28j60_UserTCP_idNuevo_L0+2 
	MOVF        R3, 0 
	MOVWF       Net_Ethernet_28j60_UserTCP_idNuevo_L0+3 
;TPV.c,1238 :: 		string_cpyn(msjConst, &getRequest[sizeTotal+6], 8);
	MOVLW       _msjConst+0
	MOVWF       FARG_string_cpyn_destino+0 
	MOVLW       hi_addr(_msjConst+0)
	MOVWF       FARG_string_cpyn_destino+1 
	MOVLW       6
	ADDWF       Net_Ethernet_28j60_UserTCP_sizeTotal_L0+0, 0 
	MOVWF       R0 
	CLRF        R1 
	MOVLW       0
	ADDWFC      R1, 1 
	MOVLW       _getRequest+0
	ADDWF       R0, 0 
	MOVWF       FARG_string_cpyn_origen+0 
	MOVLW       hi_addr(_getRequest+0)
	ADDWFC      R1, 0 
	MOVWF       FARG_string_cpyn_origen+1 
	MOVLW       8
	MOVWF       FARG_string_cpyn_size+0 
	CALL        _string_cpyn+0, 0
;TPV.c,1239 :: 		nip = hexToNum(msjConst);
	MOVLW       _msjConst+0
	MOVWF       FARG_hexToNum_hex+0 
	MOVLW       hi_addr(_msjConst+0)
	MOVWF       FARG_hexToNum_hex+1 
	CALL        _hexToNum+0, 0
	MOVF        R0, 0 
	MOVWF       Net_Ethernet_28j60_UserTCP_nip_L0+0 
	MOVF        R1, 0 
	MOVWF       Net_Ethernet_28j60_UserTCP_nip_L0+1 
	MOVF        R2, 0 
	MOVWF       Net_Ethernet_28j60_UserTCP_nip_L0+2 
	MOVF        R3, 0 
	MOVWF       Net_Ethernet_28j60_UserTCP_nip_L0+3 
;TPV.c,1240 :: 		string_cpyn(msjConst, &getRequest[sizeTotal+14], 8);
	MOVLW       _msjConst+0
	MOVWF       FARG_string_cpyn_destino+0 
	MOVLW       hi_addr(_msjConst+0)
	MOVWF       FARG_string_cpyn_destino+1 
	MOVLW       14
	ADDWF       Net_Ethernet_28j60_UserTCP_sizeTotal_L0+0, 0 
	MOVWF       R0 
	CLRF        R1 
	MOVLW       0
	ADDWFC      R1, 1 
	MOVLW       _getRequest+0
	ADDWF       R0, 0 
	MOVWF       FARG_string_cpyn_origen+0 
	MOVLW       hi_addr(_getRequest+0)
	ADDWFC      R1, 0 
	MOVWF       FARG_string_cpyn_origen+1 
	MOVLW       8
	MOVWF       FARG_string_cpyn_size+0 
	CALL        _string_cpyn+0, 0
;TPV.c,1241 :: 		saldo = hexToNum(msjConst);
	MOVLW       _msjConst+0
	MOVWF       FARG_hexToNum_hex+0 
	MOVLW       hi_addr(_msjConst+0)
	MOVWF       FARG_hexToNum_hex+1 
	CALL        _hexToNum+0, 0
	MOVF        R0, 0 
	MOVWF       Net_Ethernet_28j60_UserTCP_saldo_L0+0 
	MOVF        R1, 0 
	MOVWF       Net_Ethernet_28j60_UserTCP_saldo_L0+1 
	MOVF        R2, 0 
	MOVWF       Net_Ethernet_28j60_UserTCP_saldo_L0+2 
	MOVF        R3, 0 
	MOVWF       Net_Ethernet_28j60_UserTCP_saldo_L0+3 
;TPV.c,1242 :: 		estatus =  getRequest[sizeTotal+22];
	MOVLW       22
	ADDWF       Net_Ethernet_28j60_UserTCP_sizeTotal_L0+0, 0 
	MOVWF       R0 
	CLRF        R1 
	MOVLW       0
	ADDWFC      R1, 1 
	MOVLW       _getRequest+0
	ADDWF       R0, 0 
	MOVWF       FSR0 
	MOVLW       hi_addr(_getRequest+0)
	ADDWFC      R1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       Net_Ethernet_28j60_UserTCP_estatus_L0+0 
;TPV.c,1244 :: 		if(idNuevo != idConsulta)
	MOVF        Net_Ethernet_28j60_UserTCP_idNuevo_L0+3, 0 
	XORWF       Net_Ethernet_28j60_UserTCP_idConsulta_L0+3, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__Net_Ethernet_28j60_UserTCP1391
	MOVF        Net_Ethernet_28j60_UserTCP_idNuevo_L0+2, 0 
	XORWF       Net_Ethernet_28j60_UserTCP_idConsulta_L0+2, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__Net_Ethernet_28j60_UserTCP1391
	MOVF        Net_Ethernet_28j60_UserTCP_idNuevo_L0+1, 0 
	XORWF       Net_Ethernet_28j60_UserTCP_idConsulta_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__Net_Ethernet_28j60_UserTCP1391
	MOVF        Net_Ethernet_28j60_UserTCP_idNuevo_L0+0, 0 
	XORWF       Net_Ethernet_28j60_UserTCP_idConsulta_L0+0, 0 
L__Net_Ethernet_28j60_UserTCP1391:
	BTFSC       STATUS+0, 2 
	GOTO        L_Net_Ethernet_28j60_UserTCP788
;TPV.c,1245 :: 		result = !mysql_write(tablePrepago, prepagoID, fila, idNuevo, false);
	MOVLW       _tablePrepago+0
	MOVWF       FARG_mysql_write_name+0 
	MOVLW       hi_addr(_tablePrepago+0)
	MOVWF       FARG_mysql_write_name+1 
	MOVLW       _prepagoId+0
	MOVWF       FARG_mysql_write_column+0 
	MOVLW       hi_addr(_prepagoId+0)
	MOVWF       FARG_mysql_write_column+1 
	MOVF        Net_Ethernet_28j60_UserTCP_fila_L0+0, 0 
	MOVWF       FARG_mysql_write_fila+0 
	MOVF        Net_Ethernet_28j60_UserTCP_fila_L0+1, 0 
	MOVWF       FARG_mysql_write_fila+1 
	MOVF        Net_Ethernet_28j60_UserTCP_idNuevo_L0+0, 0 
	MOVWF       FARG_mysql_write_value+0 
	MOVF        Net_Ethernet_28j60_UserTCP_idNuevo_L0+1, 0 
	MOVWF       FARG_mysql_write_value+1 
	MOVF        Net_Ethernet_28j60_UserTCP_idNuevo_L0+2, 0 
	MOVWF       FARG_mysql_write_value+2 
	MOVF        Net_Ethernet_28j60_UserTCP_idNuevo_L0+3, 0 
	MOVWF       FARG_mysql_write_value+3 
	CLRF        FARG_mysql_write_endWrite+0 
	CALL        _mysql_write+0, 0
	MOVF        R0, 1 
	MOVLW       1
	BTFSS       STATUS+0, 2 
	MOVLW       0
	MOVWF       Net_Ethernet_28j60_UserTCP_result_L0+0 
L_Net_Ethernet_28j60_UserTCP788:
;TPV.c,1246 :: 		result = !mysql_write(tablePrepago,prepagoNIP, fila, nip, false);
	MOVLW       _tablePrepago+0
	MOVWF       FARG_mysql_write_name+0 
	MOVLW       hi_addr(_tablePrepago+0)
	MOVWF       FARG_mysql_write_name+1 
	MOVLW       _prepagoNip+0
	MOVWF       FARG_mysql_write_column+0 
	MOVLW       hi_addr(_prepagoNip+0)
	MOVWF       FARG_mysql_write_column+1 
	MOVF        Net_Ethernet_28j60_UserTCP_fila_L0+0, 0 
	MOVWF       FARG_mysql_write_fila+0 
	MOVF        Net_Ethernet_28j60_UserTCP_fila_L0+1, 0 
	MOVWF       FARG_mysql_write_fila+1 
	MOVF        Net_Ethernet_28j60_UserTCP_nip_L0+0, 0 
	MOVWF       FARG_mysql_write_value+0 
	MOVF        Net_Ethernet_28j60_UserTCP_nip_L0+1, 0 
	MOVWF       FARG_mysql_write_value+1 
	MOVF        Net_Ethernet_28j60_UserTCP_nip_L0+2, 0 
	MOVWF       FARG_mysql_write_value+2 
	MOVF        Net_Ethernet_28j60_UserTCP_nip_L0+3, 0 
	MOVWF       FARG_mysql_write_value+3 
	CLRF        FARG_mysql_write_endWrite+0 
	CALL        _mysql_write+0, 0
	MOVF        R0, 1 
	MOVLW       1
	BTFSS       STATUS+0, 2 
	MOVLW       0
	MOVWF       Net_Ethernet_28j60_UserTCP_result_L0+0 
;TPV.c,1247 :: 		result = !mysql_write(tablePrepago,prepagoSaldo, fila, saldo, false);
	MOVLW       _tablePrepago+0
	MOVWF       FARG_mysql_write_name+0 
	MOVLW       hi_addr(_tablePrepago+0)
	MOVWF       FARG_mysql_write_name+1 
	MOVLW       _prepagoSaldo+0
	MOVWF       FARG_mysql_write_column+0 
	MOVLW       hi_addr(_prepagoSaldo+0)
	MOVWF       FARG_mysql_write_column+1 
	MOVF        Net_Ethernet_28j60_UserTCP_fila_L0+0, 0 
	MOVWF       FARG_mysql_write_fila+0 
	MOVF        Net_Ethernet_28j60_UserTCP_fila_L0+1, 0 
	MOVWF       FARG_mysql_write_fila+1 
	MOVF        Net_Ethernet_28j60_UserTCP_saldo_L0+0, 0 
	MOVWF       FARG_mysql_write_value+0 
	MOVF        Net_Ethernet_28j60_UserTCP_saldo_L0+1, 0 
	MOVWF       FARG_mysql_write_value+1 
	MOVF        Net_Ethernet_28j60_UserTCP_saldo_L0+2, 0 
	MOVWF       FARG_mysql_write_value+2 
	MOVF        Net_Ethernet_28j60_UserTCP_saldo_L0+3, 0 
	MOVWF       FARG_mysql_write_value+3 
	CLRF        FARG_mysql_write_endWrite+0 
	CALL        _mysql_write+0, 0
	MOVF        R0, 1 
	MOVLW       1
	BTFSS       STATUS+0, 2 
	MOVLW       0
	MOVWF       Net_Ethernet_28j60_UserTCP_result_L0+0 
;TPV.c,1248 :: 		result = !mysql_write(tablePrepago,prepagoEstatus, fila, estatus, false);
	MOVLW       _tablePrepago+0
	MOVWF       FARG_mysql_write_name+0 
	MOVLW       hi_addr(_tablePrepago+0)
	MOVWF       FARG_mysql_write_name+1 
	MOVLW       _prepagoEstatus+0
	MOVWF       FARG_mysql_write_column+0 
	MOVLW       hi_addr(_prepagoEstatus+0)
	MOVWF       FARG_mysql_write_column+1 
	MOVF        Net_Ethernet_28j60_UserTCP_fila_L0+0, 0 
	MOVWF       FARG_mysql_write_fila+0 
	MOVF        Net_Ethernet_28j60_UserTCP_fila_L0+1, 0 
	MOVWF       FARG_mysql_write_fila+1 
	MOVF        Net_Ethernet_28j60_UserTCP_estatus_L0+0, 0 
	MOVWF       FARG_mysql_write_value+0 
	MOVLW       0
	MOVWF       FARG_mysql_write_value+1 
	MOVWF       FARG_mysql_write_value+2 
	MOVWF       FARG_mysql_write_value+3 
	CLRF        FARG_mysql_write_endWrite+0 
	CALL        _mysql_write+0, 0
	MOVF        R0, 1 
	MOVLW       1
	BTFSS       STATUS+0, 2 
	MOVLW       0
	MOVWF       R1 
	MOVF        R1, 0 
	MOVWF       Net_Ethernet_28j60_UserTCP_result_L0+0 
;TPV.c,1250 :: 		string_addc(respuesta, result?TCP_TBL_MODIFICADO:TCP_TBL_ERROR);
	MOVLW       Net_Ethernet_28j60_UserTCP_respuesta_L0+0
	MOVWF       FARG_string_addc_destino+0 
	MOVLW       hi_addr(Net_Ethernet_28j60_UserTCP_respuesta_L0+0)
	MOVWF       FARG_string_addc_destino+1 
	MOVF        R1, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_Net_Ethernet_28j60_UserTCP789
	MOVLW       _TCP_TBL_MODIFICADO+0
	MOVWF       ?FLOC___Net_Ethernet_28j60_UserTCPT3349+0 
	MOVLW       hi_addr(_TCP_TBL_MODIFICADO+0)
	MOVWF       ?FLOC___Net_Ethernet_28j60_UserTCPT3349+1 
	MOVLW       higher_addr(_TCP_TBL_MODIFICADO+0)
	MOVWF       ?FLOC___Net_Ethernet_28j60_UserTCPT3349+2 
	GOTO        L_Net_Ethernet_28j60_UserTCP790
L_Net_Ethernet_28j60_UserTCP789:
	MOVLW       _TCP_TBL_ERROR+0
	MOVWF       ?FLOC___Net_Ethernet_28j60_UserTCPT3349+0 
	MOVLW       hi_addr(_TCP_TBL_ERROR+0)
	MOVWF       ?FLOC___Net_Ethernet_28j60_UserTCPT3349+1 
	MOVLW       higher_addr(_TCP_TBL_ERROR+0)
	MOVWF       ?FLOC___Net_Ethernet_28j60_UserTCPT3349+2 
L_Net_Ethernet_28j60_UserTCP790:
	MOVF        ?FLOC___Net_Ethernet_28j60_UserTCPT3349+0, 0 
	MOVWF       FARG_string_addc_addEnd+0 
	MOVF        ?FLOC___Net_Ethernet_28j60_UserTCPT3349+1, 0 
	MOVWF       FARG_string_addc_addEnd+1 
	MOVF        ?FLOC___Net_Ethernet_28j60_UserTCPT3349+2, 0 
	MOVWF       FARG_string_addc_addEnd+2 
	CALL        _string_addc+0, 0
;TPV.c,1251 :: 		if(!result)
	MOVF        Net_Ethernet_28j60_UserTCP_result_L0+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_Net_Ethernet_28j60_UserTCP791
;TPV.c,1252 :: 		bufferEeprom[0] = 0; //FORZAR FINAL DE CADENA
	CLRF        _bufferEeprom+0 
L_Net_Ethernet_28j60_UserTCP791:
;TPV.c,1253 :: 		}else{
	GOTO        L_Net_Ethernet_28j60_UserTCP792
L_Net_Ethernet_28j60_UserTCP787:
;TPV.c,1254 :: 		string_addc(respuesta, TCP_TBL_NO_FOUND);
	MOVLW       Net_Ethernet_28j60_UserTCP_respuesta_L0+0
	MOVWF       FARG_string_addc_destino+0 
	MOVLW       hi_addr(Net_Ethernet_28j60_UserTCP_respuesta_L0+0)
	MOVWF       FARG_string_addc_destino+1 
	MOVLW       _TCP_TBL_NO_FOUND+0
	MOVWF       FARG_string_addc_addEnd+0 
	MOVLW       hi_addr(_TCP_TBL_NO_FOUND+0)
	MOVWF       FARG_string_addc_addEnd+1 
	MOVLW       higher_addr(_TCP_TBL_NO_FOUND+0)
	MOVWF       FARG_string_addc_addEnd+2 
	CALL        _string_addc+0, 0
;TPV.c,1255 :: 		bufferEeprom[0] = 0; //FORZAR FINAL DE CADENA
	CLRF        _bufferEeprom+0 
;TPV.c,1256 :: 		}
L_Net_Ethernet_28j60_UserTCP792:
;TPV.c,1257 :: 		}else if(string_cmpnc(TCP_CAN_CONSULTAR, &getRequest[sizeTotal], sizeKey)){
	GOTO        L_Net_Ethernet_28j60_UserTCP793
L_Net_Ethernet_28j60_UserTCP786:
	MOVLW       _TCP_CAN_CONSULTAR+0
	MOVWF       FARG_string_cmpnc_text1+0 
	MOVLW       hi_addr(_TCP_CAN_CONSULTAR+0)
	MOVWF       FARG_string_cmpnc_text1+1 
	MOVLW       higher_addr(_TCP_CAN_CONSULTAR+0)
	MOVWF       FARG_string_cmpnc_text1+2 
	MOVLW       _getRequest+0
	MOVWF       FARG_string_cmpnc_text2+0 
	MOVLW       hi_addr(_getRequest+0)
	MOVWF       FARG_string_cmpnc_text2+1 
	MOVF        Net_Ethernet_28j60_UserTCP_sizeTotal_L0+0, 0 
	ADDWF       FARG_string_cmpnc_text2+0, 1 
	BTFSC       STATUS+0, 0 
	INCF        FARG_string_cmpnc_text2+1, 1 
	MOVF        Net_Ethernet_28j60_UserTCP_sizeKey_L0+0, 0 
	MOVWF       FARG_string_cmpnc_bytes+0 
	CALL        _string_cmpnc+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_Net_Ethernet_28j60_UserTCP794
;TPV.c,1259 :: 		sizeTotal += sizeKey;
	MOVF        Net_Ethernet_28j60_UserTCP_sizeKey_L0+0, 0 
	ADDWF       Net_Ethernet_28j60_UserTCP_sizeTotal_L0+0, 1 
;TPV.c,1260 :: 		if(result){
	MOVF        Net_Ethernet_28j60_UserTCP_result_L0+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_Net_Ethernet_28j60_UserTCP795
;TPV.c,1261 :: 		mysql_read(tablePrepago, prepagoNIP, fila, &nip);
	MOVLW       _tablePrepago+0
	MOVWF       FARG_mysql_read_name+0 
	MOVLW       hi_addr(_tablePrepago+0)
	MOVWF       FARG_mysql_read_name+1 
	MOVLW       _prepagoNip+0
	MOVWF       FARG_mysql_read_column+0 
	MOVLW       hi_addr(_prepagoNip+0)
	MOVWF       FARG_mysql_read_column+1 
	MOVF        Net_Ethernet_28j60_UserTCP_fila_L0+0, 0 
	MOVWF       FARG_mysql_read_fila+0 
	MOVF        Net_Ethernet_28j60_UserTCP_fila_L0+1, 0 
	MOVWF       FARG_mysql_read_fila+1 
	MOVLW       Net_Ethernet_28j60_UserTCP_nip_L0+0
	MOVWF       FARG_mysql_read_result+0 
	MOVLW       hi_addr(Net_Ethernet_28j60_UserTCP_nip_L0+0)
	MOVWF       FARG_mysql_read_result+1 
	CALL        _mysql_read+0, 0
;TPV.c,1262 :: 		numToHex(nip, msjConst, 4);
	MOVF        Net_Ethernet_28j60_UserTCP_nip_L0+0, 0 
	MOVWF       FARG_numToHex_valor+0 
	MOVF        Net_Ethernet_28j60_UserTCP_nip_L0+1, 0 
	MOVWF       FARG_numToHex_valor+1 
	MOVF        Net_Ethernet_28j60_UserTCP_nip_L0+2, 0 
	MOVWF       FARG_numToHex_valor+2 
	MOVF        Net_Ethernet_28j60_UserTCP_nip_L0+3, 0 
	MOVWF       FARG_numToHex_valor+3 
	MOVLW       _msjConst+0
	MOVWF       FARG_numToHex_cadena+0 
	MOVLW       hi_addr(_msjConst+0)
	MOVWF       FARG_numToHex_cadena+1 
	MOVLW       4
	MOVWF       FARG_numToHex_bytes+0 
	CALL        _numToHex+0, 0
;TPV.c,1263 :: 		string_add(respuesta, msjConst);
	MOVLW       Net_Ethernet_28j60_UserTCP_respuesta_L0+0
	MOVWF       FARG_string_add_destino+0 
	MOVLW       hi_addr(Net_Ethernet_28j60_UserTCP_respuesta_L0+0)
	MOVWF       FARG_string_add_destino+1 
	MOVLW       _msjConst+0
	MOVWF       FARG_string_add_addEnd+0 
	MOVLW       hi_addr(_msjConst+0)
	MOVWF       FARG_string_add_addEnd+1 
	CALL        _string_add+0, 0
;TPV.c,1264 :: 		mysql_read(tablePrepago, prepagoSaldo, fila, &saldo);
	MOVLW       _tablePrepago+0
	MOVWF       FARG_mysql_read_name+0 
	MOVLW       hi_addr(_tablePrepago+0)
	MOVWF       FARG_mysql_read_name+1 
	MOVLW       _prepagoSaldo+0
	MOVWF       FARG_mysql_read_column+0 
	MOVLW       hi_addr(_prepagoSaldo+0)
	MOVWF       FARG_mysql_read_column+1 
	MOVF        Net_Ethernet_28j60_UserTCP_fila_L0+0, 0 
	MOVWF       FARG_mysql_read_fila+0 
	MOVF        Net_Ethernet_28j60_UserTCP_fila_L0+1, 0 
	MOVWF       FARG_mysql_read_fila+1 
	MOVLW       Net_Ethernet_28j60_UserTCP_saldo_L0+0
	MOVWF       FARG_mysql_read_result+0 
	MOVLW       hi_addr(Net_Ethernet_28j60_UserTCP_saldo_L0+0)
	MOVWF       FARG_mysql_read_result+1 
	CALL        _mysql_read+0, 0
;TPV.c,1265 :: 		numToHex(saldo, msjConst, 4);
	MOVF        Net_Ethernet_28j60_UserTCP_saldo_L0+0, 0 
	MOVWF       FARG_numToHex_valor+0 
	MOVF        Net_Ethernet_28j60_UserTCP_saldo_L0+1, 0 
	MOVWF       FARG_numToHex_valor+1 
	MOVF        Net_Ethernet_28j60_UserTCP_saldo_L0+2, 0 
	MOVWF       FARG_numToHex_valor+2 
	MOVF        Net_Ethernet_28j60_UserTCP_saldo_L0+3, 0 
	MOVWF       FARG_numToHex_valor+3 
	MOVLW       _msjConst+0
	MOVWF       FARG_numToHex_cadena+0 
	MOVLW       hi_addr(_msjConst+0)
	MOVWF       FARG_numToHex_cadena+1 
	MOVLW       4
	MOVWF       FARG_numToHex_bytes+0 
	CALL        _numToHex+0, 0
;TPV.c,1266 :: 		string_add(respuesta, msjConst);
	MOVLW       Net_Ethernet_28j60_UserTCP_respuesta_L0+0
	MOVWF       FARG_string_add_destino+0 
	MOVLW       hi_addr(Net_Ethernet_28j60_UserTCP_respuesta_L0+0)
	MOVWF       FARG_string_add_destino+1 
	MOVLW       _msjConst+0
	MOVWF       FARG_string_add_addEnd+0 
	MOVLW       hi_addr(_msjConst+0)
	MOVWF       FARG_string_add_addEnd+1 
	CALL        _string_add+0, 0
;TPV.c,1267 :: 		mysql_read_string(tablePrepago, prepagoEstatus, fila, &estatus);
	MOVLW       _tablePrepago+0
	MOVWF       FARG_mysql_read_string_name+0 
	MOVLW       hi_addr(_tablePrepago+0)
	MOVWF       FARG_mysql_read_string_name+1 
	MOVLW       _prepagoEstatus+0
	MOVWF       FARG_mysql_read_string_column+0 
	MOVLW       hi_addr(_prepagoEstatus+0)
	MOVWF       FARG_mysql_read_string_column+1 
	MOVF        Net_Ethernet_28j60_UserTCP_fila_L0+0, 0 
	MOVWF       FARG_mysql_read_string_fila+0 
	MOVF        Net_Ethernet_28j60_UserTCP_fila_L0+1, 0 
	MOVWF       FARG_mysql_read_string_fila+1 
	MOVLW       Net_Ethernet_28j60_UserTCP_estatus_L0+0
	MOVWF       FARG_mysql_read_string_result+0 
	MOVLW       hi_addr(Net_Ethernet_28j60_UserTCP_estatus_L0+0)
	MOVWF       FARG_mysql_read_string_result+1 
	CALL        _mysql_read_string+0, 0
;TPV.c,1268 :: 		string_push(respuesta, estatus);
	MOVLW       Net_Ethernet_28j60_UserTCP_respuesta_L0+0
	MOVWF       FARG_string_push_texto+0 
	MOVLW       hi_addr(Net_Ethernet_28j60_UserTCP_respuesta_L0+0)
	MOVWF       FARG_string_push_texto+1 
	MOVF        Net_Ethernet_28j60_UserTCP_estatus_L0+0, 0 
	MOVWF       FARG_string_push_caracter+0 
	CALL        _string_push+0, 0
;TPV.c,1269 :: 		string_addc(respuesta, TCP_CAN_MODULE);
	MOVLW       Net_Ethernet_28j60_UserTCP_respuesta_L0+0
	MOVWF       FARG_string_addc_destino+0 
	MOVLW       hi_addr(Net_Ethernet_28j60_UserTCP_respuesta_L0+0)
	MOVWF       FARG_string_addc_destino+1 
	MOVLW       _TCP_CAN_MODULE+0
	MOVWF       FARG_string_addc_addEnd+0 
	MOVLW       hi_addr(_TCP_CAN_MODULE+0)
	MOVWF       FARG_string_addc_addEnd+1 
	MOVLW       higher_addr(_TCP_CAN_MODULE+0)
	MOVWF       FARG_string_addc_addEnd+2 
	CALL        _string_addc+0, 0
;TPV.c,1270 :: 		numToHex(can.id, msjConst, 1);
	MOVF        _can+12, 0 
	MOVWF       FARG_numToHex_valor+0 
	MOVLW       0
	MOVWF       FARG_numToHex_valor+1 
	MOVWF       FARG_numToHex_valor+2 
	MOVWF       FARG_numToHex_valor+3 
	MOVLW       _msjConst+0
	MOVWF       FARG_numToHex_cadena+0 
	MOVLW       hi_addr(_msjConst+0)
	MOVWF       FARG_numToHex_cadena+1 
	MOVLW       1
	MOVWF       FARG_numToHex_bytes+0 
	CALL        _numToHex+0, 0
;TPV.c,1271 :: 		string_add(respuesta, msjConst);
	MOVLW       Net_Ethernet_28j60_UserTCP_respuesta_L0+0
	MOVWF       FARG_string_add_destino+0 
	MOVLW       hi_addr(Net_Ethernet_28j60_UserTCP_respuesta_L0+0)
	MOVWF       FARG_string_add_destino+1 
	MOVLW       _msjConst+0
	MOVWF       FARG_string_add_addEnd+0 
	MOVLW       hi_addr(_msjConst+0)
	MOVWF       FARG_string_add_addEnd+1 
	CALL        _string_add+0, 0
;TPV.c,1272 :: 		}else{
	GOTO        L_Net_Ethernet_28j60_UserTCP796
L_Net_Ethernet_28j60_UserTCP795:
;TPV.c,1273 :: 		string_addc(respuesta, TCP_TBL_NO_FOUND);
	MOVLW       Net_Ethernet_28j60_UserTCP_respuesta_L0+0
	MOVWF       FARG_string_addc_destino+0 
	MOVLW       hi_addr(Net_Ethernet_28j60_UserTCP_respuesta_L0+0)
	MOVWF       FARG_string_addc_destino+1 
	MOVLW       _TCP_TBL_NO_FOUND+0
	MOVWF       FARG_string_addc_addEnd+0 
	MOVLW       hi_addr(_TCP_TBL_NO_FOUND+0)
	MOVWF       FARG_string_addc_addEnd+1 
	MOVLW       higher_addr(_TCP_TBL_NO_FOUND+0)
	MOVWF       FARG_string_addc_addEnd+2 
	CALL        _string_addc+0, 0
;TPV.c,1274 :: 		bufferEeprom[0] = 0; //FORZAR FINAL DE CADENA
	CLRF        _bufferEeprom+0 
;TPV.c,1275 :: 		}
L_Net_Ethernet_28j60_UserTCP796:
;TPV.c,1276 :: 		}else if(string_cmpnc(TCP_CAN_NIP, &getRequest[sizeTotal], sizeKey)){
	GOTO        L_Net_Ethernet_28j60_UserTCP797
L_Net_Ethernet_28j60_UserTCP794:
	MOVLW       _TCP_CAN_NIP+0
	MOVWF       FARG_string_cmpnc_text1+0 
	MOVLW       hi_addr(_TCP_CAN_NIP+0)
	MOVWF       FARG_string_cmpnc_text1+1 
	MOVLW       higher_addr(_TCP_CAN_NIP+0)
	MOVWF       FARG_string_cmpnc_text1+2 
	MOVLW       _getRequest+0
	MOVWF       FARG_string_cmpnc_text2+0 
	MOVLW       hi_addr(_getRequest+0)
	MOVWF       FARG_string_cmpnc_text2+1 
	MOVF        Net_Ethernet_28j60_UserTCP_sizeTotal_L0+0, 0 
	ADDWF       FARG_string_cmpnc_text2+0, 1 
	BTFSC       STATUS+0, 0 
	INCF        FARG_string_cmpnc_text2+1, 1 
	MOVF        Net_Ethernet_28j60_UserTCP_sizeKey_L0+0, 0 
	MOVWF       FARG_string_cmpnc_bytes+0 
	CALL        _string_cmpnc+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_Net_Ethernet_28j60_UserTCP798
;TPV.c,1278 :: 		sizeTotal += sizeKey;
	MOVF        Net_Ethernet_28j60_UserTCP_sizeKey_L0+0, 0 
	ADDWF       Net_Ethernet_28j60_UserTCP_sizeTotal_L0+0, 1 
;TPV.c,1279 :: 		if(result){
	MOVF        Net_Ethernet_28j60_UserTCP_result_L0+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_Net_Ethernet_28j60_UserTCP799
;TPV.c,1280 :: 		string_cpyn(msjConst, &getRequest[sizeTotal], 8);
	MOVLW       _msjConst+0
	MOVWF       FARG_string_cpyn_destino+0 
	MOVLW       hi_addr(_msjConst+0)
	MOVWF       FARG_string_cpyn_destino+1 
	MOVLW       _getRequest+0
	MOVWF       FARG_string_cpyn_origen+0 
	MOVLW       hi_addr(_getRequest+0)
	MOVWF       FARG_string_cpyn_origen+1 
	MOVF        Net_Ethernet_28j60_UserTCP_sizeTotal_L0+0, 0 
	ADDWF       FARG_string_cpyn_origen+0, 1 
	BTFSC       STATUS+0, 0 
	INCF        FARG_string_cpyn_origen+1, 1 
	MOVLW       8
	MOVWF       FARG_string_cpyn_size+0 
	CALL        _string_cpyn+0, 0
;TPV.c,1281 :: 		nip = hexToNum(msjConst);
	MOVLW       _msjConst+0
	MOVWF       FARG_hexToNum_hex+0 
	MOVLW       hi_addr(_msjConst+0)
	MOVWF       FARG_hexToNum_hex+1 
	CALL        _hexToNum+0, 0
	MOVF        R0, 0 
	MOVWF       Net_Ethernet_28j60_UserTCP_nip_L0+0 
	MOVF        R1, 0 
	MOVWF       Net_Ethernet_28j60_UserTCP_nip_L0+1 
	MOVF        R2, 0 
	MOVWF       Net_Ethernet_28j60_UserTCP_nip_L0+2 
	MOVF        R3, 0 
	MOVWF       Net_Ethernet_28j60_UserTCP_nip_L0+3 
;TPV.c,1282 :: 		result = !mysql_write(tablePrepago, prepagoNIP, fila, nip, false);
	MOVLW       _tablePrepago+0
	MOVWF       FARG_mysql_write_name+0 
	MOVLW       hi_addr(_tablePrepago+0)
	MOVWF       FARG_mysql_write_name+1 
	MOVLW       _prepagoNip+0
	MOVWF       FARG_mysql_write_column+0 
	MOVLW       hi_addr(_prepagoNip+0)
	MOVWF       FARG_mysql_write_column+1 
	MOVF        Net_Ethernet_28j60_UserTCP_fila_L0+0, 0 
	MOVWF       FARG_mysql_write_fila+0 
	MOVF        Net_Ethernet_28j60_UserTCP_fila_L0+1, 0 
	MOVWF       FARG_mysql_write_fila+1 
	MOVF        R0, 0 
	MOVWF       FARG_mysql_write_value+0 
	MOVF        R1, 0 
	MOVWF       FARG_mysql_write_value+1 
	MOVF        R2, 0 
	MOVWF       FARG_mysql_write_value+2 
	MOVF        R3, 0 
	MOVWF       FARG_mysql_write_value+3 
	CLRF        FARG_mysql_write_endWrite+0 
	CALL        _mysql_write+0, 0
	MOVF        R0, 1 
	MOVLW       1
	BTFSS       STATUS+0, 2 
	MOVLW       0
	MOVWF       R1 
	MOVF        R1, 0 
	MOVWF       Net_Ethernet_28j60_UserTCP_result_L0+0 
;TPV.c,1284 :: 		string_addc(respuesta, result?TCP_TBL_MODIFICADO:TCP_TBL_ERROR);
	MOVLW       Net_Ethernet_28j60_UserTCP_respuesta_L0+0
	MOVWF       FARG_string_addc_destino+0 
	MOVLW       hi_addr(Net_Ethernet_28j60_UserTCP_respuesta_L0+0)
	MOVWF       FARG_string_addc_destino+1 
	MOVF        R1, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_Net_Ethernet_28j60_UserTCP800
	MOVLW       _TCP_TBL_MODIFICADO+0
	MOVWF       ?FLOC___Net_Ethernet_28j60_UserTCPT3403+0 
	MOVLW       hi_addr(_TCP_TBL_MODIFICADO+0)
	MOVWF       ?FLOC___Net_Ethernet_28j60_UserTCPT3403+1 
	MOVLW       higher_addr(_TCP_TBL_MODIFICADO+0)
	MOVWF       ?FLOC___Net_Ethernet_28j60_UserTCPT3403+2 
	GOTO        L_Net_Ethernet_28j60_UserTCP801
L_Net_Ethernet_28j60_UserTCP800:
	MOVLW       _TCP_TBL_ERROR+0
	MOVWF       ?FLOC___Net_Ethernet_28j60_UserTCPT3403+0 
	MOVLW       hi_addr(_TCP_TBL_ERROR+0)
	MOVWF       ?FLOC___Net_Ethernet_28j60_UserTCPT3403+1 
	MOVLW       higher_addr(_TCP_TBL_ERROR+0)
	MOVWF       ?FLOC___Net_Ethernet_28j60_UserTCPT3403+2 
L_Net_Ethernet_28j60_UserTCP801:
	MOVF        ?FLOC___Net_Ethernet_28j60_UserTCPT3403+0, 0 
	MOVWF       FARG_string_addc_addEnd+0 
	MOVF        ?FLOC___Net_Ethernet_28j60_UserTCPT3403+1, 0 
	MOVWF       FARG_string_addc_addEnd+1 
	MOVF        ?FLOC___Net_Ethernet_28j60_UserTCPT3403+2, 0 
	MOVWF       FARG_string_addc_addEnd+2 
	CALL        _string_addc+0, 0
;TPV.c,1285 :: 		if(!result)
	MOVF        Net_Ethernet_28j60_UserTCP_result_L0+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_Net_Ethernet_28j60_UserTCP802
;TPV.c,1286 :: 		bufferEeprom[0] = 0; //FORZAR FINAL DE CADENA
	CLRF        _bufferEeprom+0 
L_Net_Ethernet_28j60_UserTCP802:
;TPV.c,1287 :: 		}else{
	GOTO        L_Net_Ethernet_28j60_UserTCP803
L_Net_Ethernet_28j60_UserTCP799:
;TPV.c,1288 :: 		string_addc(respuesta,TCP_TBL_NO_FOUND);
	MOVLW       Net_Ethernet_28j60_UserTCP_respuesta_L0+0
	MOVWF       FARG_string_addc_destino+0 
	MOVLW       hi_addr(Net_Ethernet_28j60_UserTCP_respuesta_L0+0)
	MOVWF       FARG_string_addc_destino+1 
	MOVLW       _TCP_TBL_NO_FOUND+0
	MOVWF       FARG_string_addc_addEnd+0 
	MOVLW       hi_addr(_TCP_TBL_NO_FOUND+0)
	MOVWF       FARG_string_addc_addEnd+1 
	MOVLW       higher_addr(_TCP_TBL_NO_FOUND+0)
	MOVWF       FARG_string_addc_addEnd+2 
	CALL        _string_addc+0, 0
;TPV.c,1289 :: 		bufferEeprom[0] = 0; //FORZAR FINAL DE CADENA
	CLRF        _bufferEeprom+0 
;TPV.c,1290 :: 		}
L_Net_Ethernet_28j60_UserTCP803:
;TPV.c,1291 :: 		}else if(string_cmpnc(TCP_CAN_SALDO, &getRequest[sizeTotal], sizeKey)){
	GOTO        L_Net_Ethernet_28j60_UserTCP804
L_Net_Ethernet_28j60_UserTCP798:
	MOVLW       _TCP_CAN_SALDO+0
	MOVWF       FARG_string_cmpnc_text1+0 
	MOVLW       hi_addr(_TCP_CAN_SALDO+0)
	MOVWF       FARG_string_cmpnc_text1+1 
	MOVLW       higher_addr(_TCP_CAN_SALDO+0)
	MOVWF       FARG_string_cmpnc_text1+2 
	MOVLW       _getRequest+0
	MOVWF       FARG_string_cmpnc_text2+0 
	MOVLW       hi_addr(_getRequest+0)
	MOVWF       FARG_string_cmpnc_text2+1 
	MOVF        Net_Ethernet_28j60_UserTCP_sizeTotal_L0+0, 0 
	ADDWF       FARG_string_cmpnc_text2+0, 1 
	BTFSC       STATUS+0, 0 
	INCF        FARG_string_cmpnc_text2+1, 1 
	MOVF        Net_Ethernet_28j60_UserTCP_sizeKey_L0+0, 0 
	MOVWF       FARG_string_cmpnc_bytes+0 
	CALL        _string_cmpnc+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_Net_Ethernet_28j60_UserTCP805
;TPV.c,1293 :: 		sizeTotal += sizeKey;
	MOVF        Net_Ethernet_28j60_UserTCP_sizeKey_L0+0, 0 
	ADDWF       Net_Ethernet_28j60_UserTCP_sizeTotal_L0+0, 1 
;TPV.c,1294 :: 		if(result){
	MOVF        Net_Ethernet_28j60_UserTCP_result_L0+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_Net_Ethernet_28j60_UserTCP806
;TPV.c,1295 :: 		string_cpyn(msjConst, &getRequest[sizeTotal], 8);
	MOVLW       _msjConst+0
	MOVWF       FARG_string_cpyn_destino+0 
	MOVLW       hi_addr(_msjConst+0)
	MOVWF       FARG_string_cpyn_destino+1 
	MOVLW       _getRequest+0
	MOVWF       FARG_string_cpyn_origen+0 
	MOVLW       hi_addr(_getRequest+0)
	MOVWF       FARG_string_cpyn_origen+1 
	MOVF        Net_Ethernet_28j60_UserTCP_sizeTotal_L0+0, 0 
	ADDWF       FARG_string_cpyn_origen+0, 1 
	BTFSC       STATUS+0, 0 
	INCF        FARG_string_cpyn_origen+1, 1 
	MOVLW       8
	MOVWF       FARG_string_cpyn_size+0 
	CALL        _string_cpyn+0, 0
;TPV.c,1296 :: 		saldo = hexToNum(msjConst);
	MOVLW       _msjConst+0
	MOVWF       FARG_hexToNum_hex+0 
	MOVLW       hi_addr(_msjConst+0)
	MOVWF       FARG_hexToNum_hex+1 
	CALL        _hexToNum+0, 0
	MOVF        R0, 0 
	MOVWF       Net_Ethernet_28j60_UserTCP_saldo_L0+0 
	MOVF        R1, 0 
	MOVWF       Net_Ethernet_28j60_UserTCP_saldo_L0+1 
	MOVF        R2, 0 
	MOVWF       Net_Ethernet_28j60_UserTCP_saldo_L0+2 
	MOVF        R3, 0 
	MOVWF       Net_Ethernet_28j60_UserTCP_saldo_L0+3 
;TPV.c,1297 :: 		result = !mysql_write(tablePrepago, prepagoSaldo, fila, saldo, false);
	MOVLW       _tablePrepago+0
	MOVWF       FARG_mysql_write_name+0 
	MOVLW       hi_addr(_tablePrepago+0)
	MOVWF       FARG_mysql_write_name+1 
	MOVLW       _prepagoSaldo+0
	MOVWF       FARG_mysql_write_column+0 
	MOVLW       hi_addr(_prepagoSaldo+0)
	MOVWF       FARG_mysql_write_column+1 
	MOVF        Net_Ethernet_28j60_UserTCP_fila_L0+0, 0 
	MOVWF       FARG_mysql_write_fila+0 
	MOVF        Net_Ethernet_28j60_UserTCP_fila_L0+1, 0 
	MOVWF       FARG_mysql_write_fila+1 
	MOVF        R0, 0 
	MOVWF       FARG_mysql_write_value+0 
	MOVF        R1, 0 
	MOVWF       FARG_mysql_write_value+1 
	MOVF        R2, 0 
	MOVWF       FARG_mysql_write_value+2 
	MOVF        R3, 0 
	MOVWF       FARG_mysql_write_value+3 
	CLRF        FARG_mysql_write_endWrite+0 
	CALL        _mysql_write+0, 0
	MOVF        R0, 1 
	MOVLW       1
	BTFSS       STATUS+0, 2 
	MOVLW       0
	MOVWF       R1 
	MOVF        R1, 0 
	MOVWF       Net_Ethernet_28j60_UserTCP_result_L0+0 
;TPV.c,1299 :: 		string_addc(respuesta, result?TCP_TBL_MODIFICADO:TCP_TBL_ERROR);
	MOVLW       Net_Ethernet_28j60_UserTCP_respuesta_L0+0
	MOVWF       FARG_string_addc_destino+0 
	MOVLW       hi_addr(Net_Ethernet_28j60_UserTCP_respuesta_L0+0)
	MOVWF       FARG_string_addc_destino+1 
	MOVF        R1, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_Net_Ethernet_28j60_UserTCP807
	MOVLW       _TCP_TBL_MODIFICADO+0
	MOVWF       ?FLOC___Net_Ethernet_28j60_UserTCPT3427+0 
	MOVLW       hi_addr(_TCP_TBL_MODIFICADO+0)
	MOVWF       ?FLOC___Net_Ethernet_28j60_UserTCPT3427+1 
	MOVLW       higher_addr(_TCP_TBL_MODIFICADO+0)
	MOVWF       ?FLOC___Net_Ethernet_28j60_UserTCPT3427+2 
	GOTO        L_Net_Ethernet_28j60_UserTCP808
L_Net_Ethernet_28j60_UserTCP807:
	MOVLW       _TCP_TBL_ERROR+0
	MOVWF       ?FLOC___Net_Ethernet_28j60_UserTCPT3427+0 
	MOVLW       hi_addr(_TCP_TBL_ERROR+0)
	MOVWF       ?FLOC___Net_Ethernet_28j60_UserTCPT3427+1 
	MOVLW       higher_addr(_TCP_TBL_ERROR+0)
	MOVWF       ?FLOC___Net_Ethernet_28j60_UserTCPT3427+2 
L_Net_Ethernet_28j60_UserTCP808:
	MOVF        ?FLOC___Net_Ethernet_28j60_UserTCPT3427+0, 0 
	MOVWF       FARG_string_addc_addEnd+0 
	MOVF        ?FLOC___Net_Ethernet_28j60_UserTCPT3427+1, 0 
	MOVWF       FARG_string_addc_addEnd+1 
	MOVF        ?FLOC___Net_Ethernet_28j60_UserTCPT3427+2, 0 
	MOVWF       FARG_string_addc_addEnd+2 
	CALL        _string_addc+0, 0
;TPV.c,1300 :: 		if(!result)
	MOVF        Net_Ethernet_28j60_UserTCP_result_L0+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_Net_Ethernet_28j60_UserTCP809
;TPV.c,1301 :: 		bufferEeprom[0] = 0; //FORZAR FINAL DE CADENA
	CLRF        _bufferEeprom+0 
L_Net_Ethernet_28j60_UserTCP809:
;TPV.c,1302 :: 		}else{
	GOTO        L_Net_Ethernet_28j60_UserTCP810
L_Net_Ethernet_28j60_UserTCP806:
;TPV.c,1303 :: 		string_addc(respuesta,TCP_TBL_NO_FOUND);
	MOVLW       Net_Ethernet_28j60_UserTCP_respuesta_L0+0
	MOVWF       FARG_string_addc_destino+0 
	MOVLW       hi_addr(Net_Ethernet_28j60_UserTCP_respuesta_L0+0)
	MOVWF       FARG_string_addc_destino+1 
	MOVLW       _TCP_TBL_NO_FOUND+0
	MOVWF       FARG_string_addc_addEnd+0 
	MOVLW       hi_addr(_TCP_TBL_NO_FOUND+0)
	MOVWF       FARG_string_addc_addEnd+1 
	MOVLW       higher_addr(_TCP_TBL_NO_FOUND+0)
	MOVWF       FARG_string_addc_addEnd+2 
	CALL        _string_addc+0, 0
;TPV.c,1304 :: 		bufferEeprom[0] = 0; //FORZAR FINAL DE CADENA
	CLRF        _bufferEeprom+0 
;TPV.c,1305 :: 		}
L_Net_Ethernet_28j60_UserTCP810:
;TPV.c,1306 :: 		}else if(string_cmpnc(TCP_CAN_PASSBACK, &getRequest[sizeTotal], sizeKey)){
	GOTO        L_Net_Ethernet_28j60_UserTCP811
L_Net_Ethernet_28j60_UserTCP805:
	MOVLW       _TCP_CAN_PASSBACK+0
	MOVWF       FARG_string_cmpnc_text1+0 
	MOVLW       hi_addr(_TCP_CAN_PASSBACK+0)
	MOVWF       FARG_string_cmpnc_text1+1 
	MOVLW       higher_addr(_TCP_CAN_PASSBACK+0)
	MOVWF       FARG_string_cmpnc_text1+2 
	MOVLW       _getRequest+0
	MOVWF       FARG_string_cmpnc_text2+0 
	MOVLW       hi_addr(_getRequest+0)
	MOVWF       FARG_string_cmpnc_text2+1 
	MOVF        Net_Ethernet_28j60_UserTCP_sizeTotal_L0+0, 0 
	ADDWF       FARG_string_cmpnc_text2+0, 1 
	BTFSC       STATUS+0, 0 
	INCF        FARG_string_cmpnc_text2+1, 1 
	MOVF        Net_Ethernet_28j60_UserTCP_sizeKey_L0+0, 0 
	MOVWF       FARG_string_cmpnc_bytes+0 
	CALL        _string_cmpnc+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_Net_Ethernet_28j60_UserTCP812
;TPV.c,1308 :: 		sizeTotal += sizeKey;
	MOVF        Net_Ethernet_28j60_UserTCP_sizeKey_L0+0, 0 
	ADDWF       Net_Ethernet_28j60_UserTCP_sizeTotal_L0+0, 1 
;TPV.c,1309 :: 		if(result){
	MOVF        Net_Ethernet_28j60_UserTCP_result_L0+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_Net_Ethernet_28j60_UserTCP813
;TPV.c,1310 :: 		estatus = getRequest[sizeTotal];
	MOVLW       _getRequest+0
	MOVWF       FSR0 
	MOVLW       hi_addr(_getRequest+0)
	MOVWF       FSR0H 
	MOVF        Net_Ethernet_28j60_UserTCP_sizeTotal_L0+0, 0 
	ADDWF       FSR0, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR0H, 1 
	MOVF        POSTINC0+0, 0 
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       Net_Ethernet_28j60_UserTCP_estatus_L0+0 
;TPV.c,1311 :: 		result = !mysql_write(tablePrepago, prepagoEstatus, fila, estatus, false);
	MOVLW       _tablePrepago+0
	MOVWF       FARG_mysql_write_name+0 
	MOVLW       hi_addr(_tablePrepago+0)
	MOVWF       FARG_mysql_write_name+1 
	MOVLW       _prepagoEstatus+0
	MOVWF       FARG_mysql_write_column+0 
	MOVLW       hi_addr(_prepagoEstatus+0)
	MOVWF       FARG_mysql_write_column+1 
	MOVF        Net_Ethernet_28j60_UserTCP_fila_L0+0, 0 
	MOVWF       FARG_mysql_write_fila+0 
	MOVF        Net_Ethernet_28j60_UserTCP_fila_L0+1, 0 
	MOVWF       FARG_mysql_write_fila+1 
	MOVF        R0, 0 
	MOVWF       FARG_mysql_write_value+0 
	MOVLW       0
	MOVWF       FARG_mysql_write_value+1 
	MOVWF       FARG_mysql_write_value+2 
	MOVWF       FARG_mysql_write_value+3 
	CLRF        FARG_mysql_write_endWrite+0 
	CALL        _mysql_write+0, 0
	MOVF        R0, 1 
	MOVLW       1
	BTFSS       STATUS+0, 2 
	MOVLW       0
	MOVWF       R1 
	MOVF        R1, 0 
	MOVWF       Net_Ethernet_28j60_UserTCP_result_L0+0 
;TPV.c,1313 :: 		string_addc(respuesta, result?TCP_TBL_MODIFICADO:TCP_TBL_ERROR);
	MOVLW       Net_Ethernet_28j60_UserTCP_respuesta_L0+0
	MOVWF       FARG_string_addc_destino+0 
	MOVLW       hi_addr(Net_Ethernet_28j60_UserTCP_respuesta_L0+0)
	MOVWF       FARG_string_addc_destino+1 
	MOVF        R1, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_Net_Ethernet_28j60_UserTCP814
	MOVLW       _TCP_TBL_MODIFICADO+0
	MOVWF       ?FLOC___Net_Ethernet_28j60_UserTCPT3449+0 
	MOVLW       hi_addr(_TCP_TBL_MODIFICADO+0)
	MOVWF       ?FLOC___Net_Ethernet_28j60_UserTCPT3449+1 
	MOVLW       higher_addr(_TCP_TBL_MODIFICADO+0)
	MOVWF       ?FLOC___Net_Ethernet_28j60_UserTCPT3449+2 
	GOTO        L_Net_Ethernet_28j60_UserTCP815
L_Net_Ethernet_28j60_UserTCP814:
	MOVLW       _TCP_TBL_ERROR+0
	MOVWF       ?FLOC___Net_Ethernet_28j60_UserTCPT3449+0 
	MOVLW       hi_addr(_TCP_TBL_ERROR+0)
	MOVWF       ?FLOC___Net_Ethernet_28j60_UserTCPT3449+1 
	MOVLW       higher_addr(_TCP_TBL_ERROR+0)
	MOVWF       ?FLOC___Net_Ethernet_28j60_UserTCPT3449+2 
L_Net_Ethernet_28j60_UserTCP815:
	MOVF        ?FLOC___Net_Ethernet_28j60_UserTCPT3449+0, 0 
	MOVWF       FARG_string_addc_addEnd+0 
	MOVF        ?FLOC___Net_Ethernet_28j60_UserTCPT3449+1, 0 
	MOVWF       FARG_string_addc_addEnd+1 
	MOVF        ?FLOC___Net_Ethernet_28j60_UserTCPT3449+2, 0 
	MOVWF       FARG_string_addc_addEnd+2 
	CALL        _string_addc+0, 0
;TPV.c,1314 :: 		if(!result)
	MOVF        Net_Ethernet_28j60_UserTCP_result_L0+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_Net_Ethernet_28j60_UserTCP816
;TPV.c,1315 :: 		bufferEeprom[0] = 0; //FORZAR FINAL DE CADENA
	CLRF        _bufferEeprom+0 
L_Net_Ethernet_28j60_UserTCP816:
;TPV.c,1316 :: 		}else{
	GOTO        L_Net_Ethernet_28j60_UserTCP817
L_Net_Ethernet_28j60_UserTCP813:
;TPV.c,1317 :: 		string_addc(respuesta,TCP_TBL_NO_FOUND);
	MOVLW       Net_Ethernet_28j60_UserTCP_respuesta_L0+0
	MOVWF       FARG_string_addc_destino+0 
	MOVLW       hi_addr(Net_Ethernet_28j60_UserTCP_respuesta_L0+0)
	MOVWF       FARG_string_addc_destino+1 
	MOVLW       _TCP_TBL_NO_FOUND+0
	MOVWF       FARG_string_addc_addEnd+0 
	MOVLW       hi_addr(_TCP_TBL_NO_FOUND+0)
	MOVWF       FARG_string_addc_addEnd+1 
	MOVLW       higher_addr(_TCP_TBL_NO_FOUND+0)
	MOVWF       FARG_string_addc_addEnd+2 
	CALL        _string_addc+0, 0
;TPV.c,1318 :: 		bufferEeprom[0] = 0; //FORZAR FINAL DE CADENA
	CLRF        _bufferEeprom+0 
;TPV.c,1319 :: 		}
L_Net_Ethernet_28j60_UserTCP817:
;TPV.c,1320 :: 		}else{
	GOTO        L_Net_Ethernet_28j60_UserTCP818
L_Net_Ethernet_28j60_UserTCP812:
;TPV.c,1321 :: 		bufferEeprom[0] = 0; //FORZAR FINAL DE CADENA
	CLRF        _bufferEeprom+0 
;TPV.c,1322 :: 		}
L_Net_Ethernet_28j60_UserTCP818:
L_Net_Ethernet_28j60_UserTCP811:
L_Net_Ethernet_28j60_UserTCP804:
L_Net_Ethernet_28j60_UserTCP797:
L_Net_Ethernet_28j60_UserTCP793:
L_Net_Ethernet_28j60_UserTCP785:
;TPV.c,1324 :: 		if(string_len(bufferEeprom) != 0){
	MOVLW       _bufferEeprom+0
	MOVWF       FARG_string_len_texto+0 
	MOVLW       hi_addr(_bufferEeprom+0)
	MOVWF       FARG_string_len_texto+1 
	CALL        _string_len+0, 0
	MOVF        R0, 0 
	XORLW       0
	BTFSC       STATUS+0, 2 
	GOTO        L_Net_Ethernet_28j60_UserTCP819
;TPV.c,1325 :: 		numToString(fila, msjConst, 4);
	MOVF        Net_Ethernet_28j60_UserTCP_fila_L0+0, 0 
	MOVWF       FARG_numToString_valor+0 
	MOVF        Net_Ethernet_28j60_UserTCP_fila_L0+1, 0 
	MOVWF       FARG_numToString_valor+1 
	MOVLW       0
	BTFSC       Net_Ethernet_28j60_UserTCP_fila_L0+1, 7 
	MOVLW       255
	MOVWF       FARG_numToString_valor+2 
	MOVWF       FARG_numToString_valor+3 
	MOVLW       _msjConst+0
	MOVWF       FARG_numToString_cadena+0 
	MOVLW       hi_addr(_msjConst+0)
	MOVWF       FARG_numToString_cadena+1 
	MOVLW       4
	MOVWF       FARG_numToString_digitos+0 
	CALL        _numToString+0, 0
;TPV.c,1326 :: 		string_add(bufferEeprom, msjConst);
	MOVLW       _bufferEeprom+0
	MOVWF       FARG_string_add_destino+0 
	MOVLW       hi_addr(_bufferEeprom+0)
	MOVWF       FARG_string_add_destino+1 
	MOVLW       _msjConst+0
	MOVWF       FARG_string_add_addEnd+0 
	MOVLW       hi_addr(_msjConst+0)
	MOVWF       FARG_string_add_addEnd+1 
	CALL        _string_add+0, 0
;TPV.c,1327 :: 		string_add(bufferEeprom, &getRequest[sizeTotal]);
	MOVLW       _bufferEeprom+0
	MOVWF       FARG_string_add_destino+0 
	MOVLW       hi_addr(_bufferEeprom+0)
	MOVWF       FARG_string_add_destino+1 
	MOVLW       _getRequest+0
	MOVWF       FARG_string_add_addEnd+0 
	MOVLW       hi_addr(_getRequest+0)
	MOVWF       FARG_string_add_addEnd+1 
	MOVF        Net_Ethernet_28j60_UserTCP_sizeTotal_L0+0, 0 
	ADDWF       FARG_string_add_addEnd+0, 1 
	BTFSC       STATUS+0, 0 
	INCF        FARG_string_add_addEnd+1, 1 
	CALL        _string_add+0, 0
;TPV.c,1328 :: 		buffer_save_send(false, bufferEeprom, tarjetas.canIdMod);
	CLRF        FARG_buffer_save_send_tcpORcan+0 
	MOVLW       _bufferEeprom+0
	MOVWF       FARG_buffer_save_send_buffer+0 
	MOVLW       hi_addr(_bufferEeprom+0)
	MOVWF       FARG_buffer_save_send_buffer+1 
	MOVLW       _tarjetas+42
	MOVWF       FARG_buffer_save_send_nodosCAN+0 
	MOVLW       hi_addr(_tarjetas+42)
	MOVWF       FARG_buffer_save_send_nodosCAN+1 
	CALL        _buffer_save_send+0, 0
;TPV.c,1329 :: 		usart_write_text("Se guarda: ");
	MOVLW       ?lstr33_TPV+0
	MOVWF       FARG_usart_write_text_texto+0 
	MOVLW       hi_addr(?lstr33_TPV+0)
	MOVWF       FARG_usart_write_text_texto+1 
	CALL        _usart_write_text+0, 0
;TPV.c,1330 :: 		usart_write_line(bufferEeprom);
	MOVLW       _bufferEeprom+0
	MOVWF       FARG_usart_write_line_texto+0 
	MOVLW       hi_addr(_bufferEeprom+0)
	MOVWF       FARG_usart_write_line_texto+1 
	CALL        _usart_write_line+0, 0
;TPV.c,1331 :: 		}else{
	GOTO        L_Net_Ethernet_28j60_UserTCP820
L_Net_Ethernet_28j60_UserTCP819:
;TPV.c,1332 :: 		usart_write_line("No se genera evento CAN");
	MOVLW       ?lstr34_TPV+0
	MOVWF       FARG_usart_write_line_texto+0 
	MOVLW       hi_addr(?lstr34_TPV+0)
	MOVWF       FARG_usart_write_line_texto+1 
	CALL        _usart_write_line+0, 0
;TPV.c,1333 :: 		}
L_Net_Ethernet_28j60_UserTCP820:
;TPV.c,1334 :: 		}else if(string_cmpnc(TCP_CAN_SOPORTE, &getRequest[sizeTotal], sizeKey)){
	GOTO        L_Net_Ethernet_28j60_UserTCP821
L_Net_Ethernet_28j60_UserTCP775:
	MOVLW       _TCP_CAN_SOPORTE+0
	MOVWF       FARG_string_cmpnc_text1+0 
	MOVLW       hi_addr(_TCP_CAN_SOPORTE+0)
	MOVWF       FARG_string_cmpnc_text1+1 
	MOVLW       higher_addr(_TCP_CAN_SOPORTE+0)
	MOVWF       FARG_string_cmpnc_text1+2 
	MOVLW       _getRequest+0
	MOVWF       FARG_string_cmpnc_text2+0 
	MOVLW       hi_addr(_getRequest+0)
	MOVWF       FARG_string_cmpnc_text2+1 
	MOVF        Net_Ethernet_28j60_UserTCP_sizeTotal_L0+0, 0 
	ADDWF       FARG_string_cmpnc_text2+0, 1 
	BTFSC       STATUS+0, 0 
	INCF        FARG_string_cmpnc_text2+1, 1 
	MOVF        Net_Ethernet_28j60_UserTCP_sizeKey_L0+0, 0 
	MOVWF       FARG_string_cmpnc_bytes+0 
	CALL        _string_cmpnc+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_Net_Ethernet_28j60_UserTCP822
;TPV.c,1336 :: 		sizeTotal += sizeKey;
	MOVF        Net_Ethernet_28j60_UserTCP_sizeKey_L0+0, 0 
	ADDWF       Net_Ethernet_28j60_UserTCP_sizeTotal_L0+0, 0 
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       Net_Ethernet_28j60_UserTCP_sizeTotal_L0+0 
;TPV.c,1337 :: 		sizeKey = 6;  //3 Bytes en hexadecimal
	MOVLW       6
	MOVWF       Net_Ethernet_28j60_UserTCP_sizeKey_L0+0 
;TPV.c,1338 :: 		string_cpyn(msjConst, &getRequest[sizeTotal], sizeKey);
	MOVLW       _msjConst+0
	MOVWF       FARG_string_cpyn_destino+0 
	MOVLW       hi_addr(_msjConst+0)
	MOVWF       FARG_string_cpyn_destino+1 
	MOVLW       _getRequest+0
	MOVWF       FARG_string_cpyn_origen+0 
	MOVLW       hi_addr(_getRequest+0)
	MOVWF       FARG_string_cpyn_origen+1 
	MOVF        R0, 0 
	ADDWF       FARG_string_cpyn_origen+0, 1 
	BTFSC       STATUS+0, 0 
	INCF        FARG_string_cpyn_origen+1, 1 
	MOVLW       6
	MOVWF       FARG_string_cpyn_size+0 
	CALL        _string_cpyn+0, 0
;TPV.c,1339 :: 		idConsulta = hexToNum(msjConst);
	MOVLW       _msjConst+0
	MOVWF       FARG_hexToNum_hex+0 
	MOVLW       hi_addr(_msjConst+0)
	MOVWF       FARG_hexToNum_hex+1 
	CALL        _hexToNum+0, 0
	MOVF        R0, 0 
	MOVWF       Net_Ethernet_28j60_UserTCP_idConsulta_L0+0 
	MOVF        R1, 0 
	MOVWF       Net_Ethernet_28j60_UserTCP_idConsulta_L0+1 
	MOVF        R2, 0 
	MOVWF       Net_Ethernet_28j60_UserTCP_idConsulta_L0+2 
	MOVF        R3, 0 
	MOVWF       Net_Ethernet_28j60_UserTCP_idConsulta_L0+3 
;TPV.c,1341 :: 		result = !mysql_search(tableSoporte, soporteID, idConsulta, &fila);
	MOVLW       _tableSoporte+0
	MOVWF       FARG_mysql_search_tabla+0 
	MOVLW       hi_addr(_tableSoporte+0)
	MOVWF       FARG_mysql_search_tabla+1 
	MOVLW       _soporteID+0
	MOVWF       FARG_mysql_search_columna+0 
	MOVLW       hi_addr(_soporteID+0)
	MOVWF       FARG_mysql_search_columna+1 
	MOVF        R0, 0 
	MOVWF       FARG_mysql_search_buscar+0 
	MOVF        R1, 0 
	MOVWF       FARG_mysql_search_buscar+1 
	MOVF        R2, 0 
	MOVWF       FARG_mysql_search_buscar+2 
	MOVF        R3, 0 
	MOVWF       FARG_mysql_search_buscar+3 
	MOVLW       Net_Ethernet_28j60_UserTCP_fila_L0+0
	MOVWF       FARG_mysql_search_fila+0 
	MOVLW       hi_addr(Net_Ethernet_28j60_UserTCP_fila_L0+0)
	MOVWF       FARG_mysql_search_fila+1 
	CALL        _mysql_search+0, 0
	MOVF        R0, 1 
	MOVLW       1
	BTFSS       STATUS+0, 2 
	MOVLW       0
	MOVWF       Net_Ethernet_28j60_UserTCP_result_L0+0 
;TPV.c,1343 :: 		sizeTotal += sizeKey;
	MOVF        Net_Ethernet_28j60_UserTCP_sizeKey_L0+0, 0 
	ADDWF       Net_Ethernet_28j60_UserTCP_sizeTotal_L0+0, 0 
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       Net_Ethernet_28j60_UserTCP_sizeTotal_L0+0 
;TPV.c,1344 :: 		sizeKey = sizeof(TCP_CAN_REGISTRAR)-1;
	MOVLW       3
	MOVWF       Net_Ethernet_28j60_UserTCP_sizeKey_L0+0 
;TPV.c,1346 :: 		string_cpyn(respuesta, getRequest, sizeTotal+sizeKey);
	MOVLW       Net_Ethernet_28j60_UserTCP_respuesta_L0+0
	MOVWF       FARG_string_cpyn_destino+0 
	MOVLW       hi_addr(Net_Ethernet_28j60_UserTCP_respuesta_L0+0)
	MOVWF       FARG_string_cpyn_destino+1 
	MOVLW       _getRequest+0
	MOVWF       FARG_string_cpyn_origen+0 
	MOVLW       hi_addr(_getRequest+0)
	MOVWF       FARG_string_cpyn_origen+1 
	MOVLW       3
	ADDWF       R0, 0 
	MOVWF       FARG_string_cpyn_size+0 
	CALL        _string_cpyn+0, 0
;TPV.c,1348 :: 		string_cpyn(bufferEeprom, getRequest, sizeTotal+sizeKey);
	MOVLW       _bufferEeprom+0
	MOVWF       FARG_string_cpyn_destino+0 
	MOVLW       hi_addr(_bufferEeprom+0)
	MOVWF       FARG_string_cpyn_destino+1 
	MOVLW       _getRequest+0
	MOVWF       FARG_string_cpyn_origen+0 
	MOVLW       hi_addr(_getRequest+0)
	MOVWF       FARG_string_cpyn_origen+1 
	MOVF        Net_Ethernet_28j60_UserTCP_sizeKey_L0+0, 0 
	ADDWF       Net_Ethernet_28j60_UserTCP_sizeTotal_L0+0, 0 
	MOVWF       FARG_string_cpyn_size+0 
	CALL        _string_cpyn+0, 0
;TPV.c,1351 :: 		if(string_cmpnc(TCP_CAN_REGISTRAR, &getRequest[sizeTotal], sizeKey)){
	MOVLW       _TCP_CAN_REGISTRAR+0
	MOVWF       FARG_string_cmpnc_text1+0 
	MOVLW       hi_addr(_TCP_CAN_REGISTRAR+0)
	MOVWF       FARG_string_cmpnc_text1+1 
	MOVLW       higher_addr(_TCP_CAN_REGISTRAR+0)
	MOVWF       FARG_string_cmpnc_text1+2 
	MOVLW       _getRequest+0
	MOVWF       FARG_string_cmpnc_text2+0 
	MOVLW       hi_addr(_getRequest+0)
	MOVWF       FARG_string_cmpnc_text2+1 
	MOVF        Net_Ethernet_28j60_UserTCP_sizeTotal_L0+0, 0 
	ADDWF       FARG_string_cmpnc_text2+0, 1 
	BTFSC       STATUS+0, 0 
	INCF        FARG_string_cmpnc_text2+1, 1 
	MOVF        Net_Ethernet_28j60_UserTCP_sizeKey_L0+0, 0 
	MOVWF       FARG_string_cmpnc_bytes+0 
	CALL        _string_cmpnc+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_Net_Ethernet_28j60_UserTCP823
;TPV.c,1353 :: 		sizeTotal += sizeKey;
	MOVF        Net_Ethernet_28j60_UserTCP_sizeKey_L0+0, 0 
	ADDWF       Net_Ethernet_28j60_UserTCP_sizeTotal_L0+0, 1 
;TPV.c,1354 :: 		estatus = !mysql_search(tablePrepago, prepagoID, idConsulta, &filaAux);
	MOVLW       _tablePrepago+0
	MOVWF       FARG_mysql_search_tabla+0 
	MOVLW       hi_addr(_tablePrepago+0)
	MOVWF       FARG_mysql_search_tabla+1 
	MOVLW       _prepagoId+0
	MOVWF       FARG_mysql_search_columna+0 
	MOVLW       hi_addr(_prepagoId+0)
	MOVWF       FARG_mysql_search_columna+1 
	MOVF        Net_Ethernet_28j60_UserTCP_idConsulta_L0+0, 0 
	MOVWF       FARG_mysql_search_buscar+0 
	MOVF        Net_Ethernet_28j60_UserTCP_idConsulta_L0+1, 0 
	MOVWF       FARG_mysql_search_buscar+1 
	MOVF        Net_Ethernet_28j60_UserTCP_idConsulta_L0+2, 0 
	MOVWF       FARG_mysql_search_buscar+2 
	MOVF        Net_Ethernet_28j60_UserTCP_idConsulta_L0+3, 0 
	MOVWF       FARG_mysql_search_buscar+3 
	MOVLW       Net_Ethernet_28j60_UserTCP_filaAux_L0+0
	MOVWF       FARG_mysql_search_fila+0 
	MOVLW       hi_addr(Net_Ethernet_28j60_UserTCP_filaAux_L0+0)
	MOVWF       FARG_mysql_search_fila+1 
	CALL        _mysql_search+0, 0
	MOVF        R0, 1 
	MOVLW       1
	BTFSS       STATUS+0, 2 
	MOVLW       0
	MOVWF       Net_Ethernet_28j60_UserTCP_estatus_L0+0 
;TPV.c,1355 :: 		estatus |= !mysql_search(tablePensionados, pensionadosID, idConsulta, &filaAux);
	MOVLW       _tablePensionados+0
	MOVWF       FARG_mysql_search_tabla+0 
	MOVLW       hi_addr(_tablePensionados+0)
	MOVWF       FARG_mysql_search_tabla+1 
	MOVLW       _pensionadosID+0
	MOVWF       FARG_mysql_search_columna+0 
	MOVLW       hi_addr(_pensionadosID+0)
	MOVWF       FARG_mysql_search_columna+1 
	MOVF        Net_Ethernet_28j60_UserTCP_idConsulta_L0+0, 0 
	MOVWF       FARG_mysql_search_buscar+0 
	MOVF        Net_Ethernet_28j60_UserTCP_idConsulta_L0+1, 0 
	MOVWF       FARG_mysql_search_buscar+1 
	MOVF        Net_Ethernet_28j60_UserTCP_idConsulta_L0+2, 0 
	MOVWF       FARG_mysql_search_buscar+2 
	MOVF        Net_Ethernet_28j60_UserTCP_idConsulta_L0+3, 0 
	MOVWF       FARG_mysql_search_buscar+3 
	MOVLW       Net_Ethernet_28j60_UserTCP_filaAux_L0+0
	MOVWF       FARG_mysql_search_fila+0 
	MOVLW       hi_addr(Net_Ethernet_28j60_UserTCP_filaAux_L0+0)
	MOVWF       FARG_mysql_search_fila+1 
	CALL        _mysql_search+0, 0
	MOVF        R0, 1 
	MOVLW       1
	BTFSS       STATUS+0, 2 
	MOVLW       0
	MOVWF       R1 
	MOVF        R1, 0 
	IORWF       Net_Ethernet_28j60_UserTCP_estatus_L0+0, 1 
;TPV.c,1357 :: 		if(result || estatus){
	MOVF        Net_Ethernet_28j60_UserTCP_result_L0+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L__Net_Ethernet_28j60_UserTCP1017
	MOVF        Net_Ethernet_28j60_UserTCP_estatus_L0+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L__Net_Ethernet_28j60_UserTCP1017
	GOTO        L_Net_Ethernet_28j60_UserTCP826
L__Net_Ethernet_28j60_UserTCP1017:
;TPV.c,1358 :: 		string_addc(respuesta, result?TCP_TBL_DUPLICADO:TCP_TBL_REG_PREVIO);
	MOVLW       Net_Ethernet_28j60_UserTCP_respuesta_L0+0
	MOVWF       FARG_string_addc_destino+0 
	MOVLW       hi_addr(Net_Ethernet_28j60_UserTCP_respuesta_L0+0)
	MOVWF       FARG_string_addc_destino+1 
	MOVF        Net_Ethernet_28j60_UserTCP_result_L0+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_Net_Ethernet_28j60_UserTCP827
	MOVLW       _TCP_TBL_DUPLICADO+0
	MOVWF       ?FLOC___Net_Ethernet_28j60_UserTCPT3513+0 
	MOVLW       hi_addr(_TCP_TBL_DUPLICADO+0)
	MOVWF       ?FLOC___Net_Ethernet_28j60_UserTCPT3513+1 
	MOVLW       higher_addr(_TCP_TBL_DUPLICADO+0)
	MOVWF       ?FLOC___Net_Ethernet_28j60_UserTCPT3513+2 
	GOTO        L_Net_Ethernet_28j60_UserTCP828
L_Net_Ethernet_28j60_UserTCP827:
	MOVLW       _TCP_TBL_REG_PREVIO+0
	MOVWF       ?FLOC___Net_Ethernet_28j60_UserTCPT3513+0 
	MOVLW       hi_addr(_TCP_TBL_REG_PREVIO+0)
	MOVWF       ?FLOC___Net_Ethernet_28j60_UserTCPT3513+1 
	MOVLW       higher_addr(_TCP_TBL_REG_PREVIO+0)
	MOVWF       ?FLOC___Net_Ethernet_28j60_UserTCPT3513+2 
L_Net_Ethernet_28j60_UserTCP828:
	MOVF        ?FLOC___Net_Ethernet_28j60_UserTCPT3513+0, 0 
	MOVWF       FARG_string_addc_addEnd+0 
	MOVF        ?FLOC___Net_Ethernet_28j60_UserTCPT3513+1, 0 
	MOVWF       FARG_string_addc_addEnd+1 
	MOVF        ?FLOC___Net_Ethernet_28j60_UserTCPT3513+2, 0 
	MOVWF       FARG_string_addc_addEnd+2 
	CALL        _string_addc+0, 0
;TPV.c,1359 :: 		bufferEeprom[0] = 0; //FORZAR FINAL DE CADENA
	CLRF        _bufferEeprom+0 
;TPV.c,1360 :: 		}else{
	GOTO        L_Net_Ethernet_28j60_UserTCP829
L_Net_Ethernet_28j60_UserTCP826:
;TPV.c,1362 :: 		result = !mysql_write(tableSoporte, soporteID, -1, idConsulta, true);
	MOVLW       _tableSoporte+0
	MOVWF       FARG_mysql_write_name+0 
	MOVLW       hi_addr(_tableSoporte+0)
	MOVWF       FARG_mysql_write_name+1 
	MOVLW       _soporteID+0
	MOVWF       FARG_mysql_write_column+0 
	MOVLW       hi_addr(_soporteID+0)
	MOVWF       FARG_mysql_write_column+1 
	MOVLW       255
	MOVWF       FARG_mysql_write_fila+0 
	MOVLW       255
	MOVWF       FARG_mysql_write_fila+1 
	MOVF        Net_Ethernet_28j60_UserTCP_idConsulta_L0+0, 0 
	MOVWF       FARG_mysql_write_value+0 
	MOVF        Net_Ethernet_28j60_UserTCP_idConsulta_L0+1, 0 
	MOVWF       FARG_mysql_write_value+1 
	MOVF        Net_Ethernet_28j60_UserTCP_idConsulta_L0+2, 0 
	MOVWF       FARG_mysql_write_value+2 
	MOVF        Net_Ethernet_28j60_UserTCP_idConsulta_L0+3, 0 
	MOVWF       FARG_mysql_write_value+3 
	MOVLW       1
	MOVWF       FARG_mysql_write_endWrite+0 
	CALL        _mysql_write+0, 0
	MOVF        R0, 1 
	MOVLW       1
	BTFSS       STATUS+0, 2 
	MOVLW       0
	MOVWF       R1 
	MOVF        R1, 0 
	MOVWF       Net_Ethernet_28j60_UserTCP_result_L0+0 
;TPV.c,1364 :: 		if(result){
	MOVF        R1, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_Net_Ethernet_28j60_UserTCP830
;TPV.c,1365 :: 		string_addc(respuesta, TCP_TBL_REGISTRADO);
	MOVLW       Net_Ethernet_28j60_UserTCP_respuesta_L0+0
	MOVWF       FARG_string_addc_destino+0 
	MOVLW       hi_addr(Net_Ethernet_28j60_UserTCP_respuesta_L0+0)
	MOVWF       FARG_string_addc_destino+1 
	MOVLW       _TCP_TBL_REGISTRADO+0
	MOVWF       FARG_string_addc_addEnd+0 
	MOVLW       hi_addr(_TCP_TBL_REGISTRADO+0)
	MOVWF       FARG_string_addc_addEnd+1 
	MOVLW       higher_addr(_TCP_TBL_REGISTRADO+0)
	MOVWF       FARG_string_addc_addEnd+2 
	CALL        _string_addc+0, 0
;TPV.c,1366 :: 		}else{
	GOTO        L_Net_Ethernet_28j60_UserTCP831
L_Net_Ethernet_28j60_UserTCP830:
;TPV.c,1367 :: 		string_addc(respuesta, TCP_TBL_LLENA);
	MOVLW       Net_Ethernet_28j60_UserTCP_respuesta_L0+0
	MOVWF       FARG_string_addc_destino+0 
	MOVLW       hi_addr(Net_Ethernet_28j60_UserTCP_respuesta_L0+0)
	MOVWF       FARG_string_addc_destino+1 
	MOVLW       _TCP_TBL_LLENA+0
	MOVWF       FARG_string_addc_addEnd+0 
	MOVLW       hi_addr(_TCP_TBL_LLENA+0)
	MOVWF       FARG_string_addc_addEnd+1 
	MOVLW       higher_addr(_TCP_TBL_LLENA+0)
	MOVWF       FARG_string_addc_addEnd+2 
	CALL        _string_addc+0, 0
;TPV.c,1368 :: 		bufferEeprom[0] = 0; //FORZAR FINAL DE CADENA
	CLRF        _bufferEeprom+0 
;TPV.c,1369 :: 		}
L_Net_Ethernet_28j60_UserTCP831:
;TPV.c,1370 :: 		}
L_Net_Ethernet_28j60_UserTCP829:
;TPV.c,1371 :: 		}else if(string_cmpnc(TCP_CAN_CONSULTAR, &getRequest[sizeTotal], sizeKey)){
	GOTO        L_Net_Ethernet_28j60_UserTCP832
L_Net_Ethernet_28j60_UserTCP823:
	MOVLW       _TCP_CAN_CONSULTAR+0
	MOVWF       FARG_string_cmpnc_text1+0 
	MOVLW       hi_addr(_TCP_CAN_CONSULTAR+0)
	MOVWF       FARG_string_cmpnc_text1+1 
	MOVLW       higher_addr(_TCP_CAN_CONSULTAR+0)
	MOVWF       FARG_string_cmpnc_text1+2 
	MOVLW       _getRequest+0
	MOVWF       FARG_string_cmpnc_text2+0 
	MOVLW       hi_addr(_getRequest+0)
	MOVWF       FARG_string_cmpnc_text2+1 
	MOVF        Net_Ethernet_28j60_UserTCP_sizeTotal_L0+0, 0 
	ADDWF       FARG_string_cmpnc_text2+0, 1 
	BTFSC       STATUS+0, 0 
	INCF        FARG_string_cmpnc_text2+1, 1 
	MOVF        Net_Ethernet_28j60_UserTCP_sizeKey_L0+0, 0 
	MOVWF       FARG_string_cmpnc_bytes+0 
	CALL        _string_cmpnc+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_Net_Ethernet_28j60_UserTCP833
;TPV.c,1373 :: 		sizeTotal += sizeKey;
	MOVF        Net_Ethernet_28j60_UserTCP_sizeKey_L0+0, 0 
	ADDWF       Net_Ethernet_28j60_UserTCP_sizeTotal_L0+0, 1 
;TPV.c,1374 :: 		if(result){
	MOVF        Net_Ethernet_28j60_UserTCP_result_L0+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_Net_Ethernet_28j60_UserTCP834
;TPV.c,1375 :: 		string_addc(respuesta, TCP_CAN_MODULE);
	MOVLW       Net_Ethernet_28j60_UserTCP_respuesta_L0+0
	MOVWF       FARG_string_addc_destino+0 
	MOVLW       hi_addr(Net_Ethernet_28j60_UserTCP_respuesta_L0+0)
	MOVWF       FARG_string_addc_destino+1 
	MOVLW       _TCP_CAN_MODULE+0
	MOVWF       FARG_string_addc_addEnd+0 
	MOVLW       hi_addr(_TCP_CAN_MODULE+0)
	MOVWF       FARG_string_addc_addEnd+1 
	MOVLW       higher_addr(_TCP_CAN_MODULE+0)
	MOVWF       FARG_string_addc_addEnd+2 
	CALL        _string_addc+0, 0
;TPV.c,1376 :: 		numToHex(can.id, msjConst, 1);
	MOVF        _can+12, 0 
	MOVWF       FARG_numToHex_valor+0 
	MOVLW       0
	MOVWF       FARG_numToHex_valor+1 
	MOVWF       FARG_numToHex_valor+2 
	MOVWF       FARG_numToHex_valor+3 
	MOVLW       _msjConst+0
	MOVWF       FARG_numToHex_cadena+0 
	MOVLW       hi_addr(_msjConst+0)
	MOVWF       FARG_numToHex_cadena+1 
	MOVLW       1
	MOVWF       FARG_numToHex_bytes+0 
	CALL        _numToHex+0, 0
;TPV.c,1377 :: 		string_add(respuesta, msjConst);
	MOVLW       Net_Ethernet_28j60_UserTCP_respuesta_L0+0
	MOVWF       FARG_string_add_destino+0 
	MOVLW       hi_addr(Net_Ethernet_28j60_UserTCP_respuesta_L0+0)
	MOVWF       FARG_string_add_destino+1 
	MOVLW       _msjConst+0
	MOVWF       FARG_string_add_addEnd+0 
	MOVLW       hi_addr(_msjConst+0)
	MOVWF       FARG_string_add_addEnd+1 
	CALL        _string_add+0, 0
;TPV.c,1378 :: 		}else{
	GOTO        L_Net_Ethernet_28j60_UserTCP835
L_Net_Ethernet_28j60_UserTCP834:
;TPV.c,1379 :: 		string_addc(respuesta, TCP_TBL_NO_FOUND);
	MOVLW       Net_Ethernet_28j60_UserTCP_respuesta_L0+0
	MOVWF       FARG_string_addc_destino+0 
	MOVLW       hi_addr(Net_Ethernet_28j60_UserTCP_respuesta_L0+0)
	MOVWF       FARG_string_addc_destino+1 
	MOVLW       _TCP_TBL_NO_FOUND+0
	MOVWF       FARG_string_addc_addEnd+0 
	MOVLW       hi_addr(_TCP_TBL_NO_FOUND+0)
	MOVWF       FARG_string_addc_addEnd+1 
	MOVLW       higher_addr(_TCP_TBL_NO_FOUND+0)
	MOVWF       FARG_string_addc_addEnd+2 
	CALL        _string_addc+0, 0
;TPV.c,1380 :: 		bufferEeprom[0] = 0; //FORZAR FINAL DE CADENA
	CLRF        _bufferEeprom+0 
;TPV.c,1381 :: 		}
L_Net_Ethernet_28j60_UserTCP835:
;TPV.c,1382 :: 		}else{
	GOTO        L_Net_Ethernet_28j60_UserTCP836
L_Net_Ethernet_28j60_UserTCP833:
;TPV.c,1383 :: 		bufferEeprom[0] = 0; //FORZAR FINAL DE CADENA
	CLRF        _bufferEeprom+0 
;TPV.c,1384 :: 		}
L_Net_Ethernet_28j60_UserTCP836:
L_Net_Ethernet_28j60_UserTCP832:
;TPV.c,1387 :: 		if(string_len(bufferEeprom) != 0){
	MOVLW       _bufferEeprom+0
	MOVWF       FARG_string_len_texto+0 
	MOVLW       hi_addr(_bufferEeprom+0)
	MOVWF       FARG_string_len_texto+1 
	CALL        _string_len+0, 0
	MOVF        R0, 0 
	XORLW       0
	BTFSC       STATUS+0, 2 
	GOTO        L_Net_Ethernet_28j60_UserTCP837
;TPV.c,1388 :: 		numToString(fila, msjConst, 4);
	MOVF        Net_Ethernet_28j60_UserTCP_fila_L0+0, 0 
	MOVWF       FARG_numToString_valor+0 
	MOVF        Net_Ethernet_28j60_UserTCP_fila_L0+1, 0 
	MOVWF       FARG_numToString_valor+1 
	MOVLW       0
	BTFSC       Net_Ethernet_28j60_UserTCP_fila_L0+1, 7 
	MOVLW       255
	MOVWF       FARG_numToString_valor+2 
	MOVWF       FARG_numToString_valor+3 
	MOVLW       _msjConst+0
	MOVWF       FARG_numToString_cadena+0 
	MOVLW       hi_addr(_msjConst+0)
	MOVWF       FARG_numToString_cadena+1 
	MOVLW       4
	MOVWF       FARG_numToString_digitos+0 
	CALL        _numToString+0, 0
;TPV.c,1389 :: 		string_add(bufferEeprom, msjConst);
	MOVLW       _bufferEeprom+0
	MOVWF       FARG_string_add_destino+0 
	MOVLW       hi_addr(_bufferEeprom+0)
	MOVWF       FARG_string_add_destino+1 
	MOVLW       _msjConst+0
	MOVWF       FARG_string_add_addEnd+0 
	MOVLW       hi_addr(_msjConst+0)
	MOVWF       FARG_string_add_addEnd+1 
	CALL        _string_add+0, 0
;TPV.c,1390 :: 		string_add(bufferEeprom, &getRequest[sizeTotal]);
	MOVLW       _bufferEeprom+0
	MOVWF       FARG_string_add_destino+0 
	MOVLW       hi_addr(_bufferEeprom+0)
	MOVWF       FARG_string_add_destino+1 
	MOVLW       _getRequest+0
	MOVWF       FARG_string_add_addEnd+0 
	MOVLW       hi_addr(_getRequest+0)
	MOVWF       FARG_string_add_addEnd+1 
	MOVF        Net_Ethernet_28j60_UserTCP_sizeTotal_L0+0, 0 
	ADDWF       FARG_string_add_addEnd+0, 1 
	BTFSC       STATUS+0, 0 
	INCF        FARG_string_add_addEnd+1, 1 
	CALL        _string_add+0, 0
;TPV.c,1391 :: 		buffer_save_send(false, bufferEeprom, tarjetas.canIdMod);
	CLRF        FARG_buffer_save_send_tcpORcan+0 
	MOVLW       _bufferEeprom+0
	MOVWF       FARG_buffer_save_send_buffer+0 
	MOVLW       hi_addr(_bufferEeprom+0)
	MOVWF       FARG_buffer_save_send_buffer+1 
	MOVLW       _tarjetas+42
	MOVWF       FARG_buffer_save_send_nodosCAN+0 
	MOVLW       hi_addr(_tarjetas+42)
	MOVWF       FARG_buffer_save_send_nodosCAN+1 
	CALL        _buffer_save_send+0, 0
;TPV.c,1392 :: 		usart_write_text("Se guarda: ");
	MOVLW       ?lstr35_TPV+0
	MOVWF       FARG_usart_write_text_texto+0 
	MOVLW       hi_addr(?lstr35_TPV+0)
	MOVWF       FARG_usart_write_text_texto+1 
	CALL        _usart_write_text+0, 0
;TPV.c,1393 :: 		usart_write_line(bufferEeprom);
	MOVLW       _bufferEeprom+0
	MOVWF       FARG_usart_write_line_texto+0 
	MOVLW       hi_addr(_bufferEeprom+0)
	MOVWF       FARG_usart_write_line_texto+1 
	CALL        _usart_write_line+0, 0
;TPV.c,1394 :: 		}else{
	GOTO        L_Net_Ethernet_28j60_UserTCP838
L_Net_Ethernet_28j60_UserTCP837:
;TPV.c,1395 :: 		usart_write_line("No se genera evento CAN");
	MOVLW       ?lstr36_TPV+0
	MOVWF       FARG_usart_write_line_texto+0 
	MOVLW       hi_addr(?lstr36_TPV+0)
	MOVWF       FARG_usart_write_line_texto+1 
	CALL        _usart_write_line+0, 0
;TPV.c,1396 :: 		}
L_Net_Ethernet_28j60_UserTCP838:
;TPV.c,1397 :: 		}else if(string_cmpnc(TCP_TABLE, &getRequest[sizeTotal], sizeKey)){
	GOTO        L_Net_Ethernet_28j60_UserTCP839
L_Net_Ethernet_28j60_UserTCP822:
	MOVLW       _TCP_TABLE+0
	MOVWF       FARG_string_cmpnc_text1+0 
	MOVLW       hi_addr(_TCP_TABLE+0)
	MOVWF       FARG_string_cmpnc_text1+1 
	MOVLW       higher_addr(_TCP_TABLE+0)
	MOVWF       FARG_string_cmpnc_text1+2 
	MOVLW       _getRequest+0
	MOVWF       FARG_string_cmpnc_text2+0 
	MOVLW       hi_addr(_getRequest+0)
	MOVWF       FARG_string_cmpnc_text2+1 
	MOVF        Net_Ethernet_28j60_UserTCP_sizeTotal_L0+0, 0 
	ADDWF       FARG_string_cmpnc_text2+0, 1 
	BTFSC       STATUS+0, 0 
	INCF        FARG_string_cmpnc_text2+1, 1 
	MOVF        Net_Ethernet_28j60_UserTCP_sizeKey_L0+0, 0 
	MOVWF       FARG_string_cmpnc_bytes+0 
	CALL        _string_cmpnc+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_Net_Ethernet_28j60_UserTCP840
;TPV.c,1398 :: 		sizeTotal += sizeKey;
	MOVF        Net_Ethernet_28j60_UserTCP_sizeKey_L0+0, 0 
	ADDWF       Net_Ethernet_28j60_UserTCP_sizeTotal_L0+0, 0 
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       Net_Ethernet_28j60_UserTCP_sizeTotal_L0+0 
;TPV.c,1399 :: 		sizeKey = sizeof(TCP_TABLE_ERASE)-1;  //FORMATO ALL/T00/EXX
	MOVLW       3
	MOVWF       Net_Ethernet_28j60_UserTCP_sizeKey_L0+0 
;TPV.c,1401 :: 		string_cpyn(respuesta, getRequest, sizeTotal);
	MOVLW       Net_Ethernet_28j60_UserTCP_respuesta_L0+0
	MOVWF       FARG_string_cpyn_destino+0 
	MOVLW       hi_addr(Net_Ethernet_28j60_UserTCP_respuesta_L0+0)
	MOVWF       FARG_string_cpyn_destino+1 
	MOVLW       _getRequest+0
	MOVWF       FARG_string_cpyn_origen+0 
	MOVLW       hi_addr(_getRequest+0)
	MOVWF       FARG_string_cpyn_origen+1 
	MOVF        R0, 0 
	MOVWF       FARG_string_cpyn_size+0 
	CALL        _string_cpyn+0, 0
;TPV.c,1403 :: 		string_cpyn(bufferEeprom, getRequest, sizeTotal);
	MOVLW       _bufferEeprom+0
	MOVWF       FARG_string_cpyn_destino+0 
	MOVLW       hi_addr(_bufferEeprom+0)
	MOVWF       FARG_string_cpyn_destino+1 
	MOVLW       _getRequest+0
	MOVWF       FARG_string_cpyn_origen+0 
	MOVLW       hi_addr(_getRequest+0)
	MOVWF       FARG_string_cpyn_origen+1 
	MOVF        Net_Ethernet_28j60_UserTCP_sizeTotal_L0+0, 0 
	MOVWF       FARG_string_cpyn_size+0 
	CALL        _string_cpyn+0, 0
;TPV.c,1404 :: 		string_add(bufferEeprom, &getRequest[sizeTotal+sizeKey]);
	MOVLW       _bufferEeprom+0
	MOVWF       FARG_string_add_destino+0 
	MOVLW       hi_addr(_bufferEeprom+0)
	MOVWF       FARG_string_add_destino+1 
	MOVF        Net_Ethernet_28j60_UserTCP_sizeKey_L0+0, 0 
	ADDWF       Net_Ethernet_28j60_UserTCP_sizeTotal_L0+0, 0 
	MOVWF       R0 
	CLRF        R1 
	MOVLW       0
	ADDWFC      R1, 1 
	MOVLW       _getRequest+0
	ADDWF       R0, 0 
	MOVWF       FARG_string_add_addEnd+0 
	MOVLW       hi_addr(_getRequest+0)
	ADDWFC      R1, 0 
	MOVWF       FARG_string_add_addEnd+1 
	CALL        _string_add+0, 0
;TPV.c,1406 :: 		cmdOwn = true;
	MOVLW       1
	MOVWF       Net_Ethernet_28j60_UserTCP_cmdOwn_L0+0 
;TPV.c,1407 :: 		if(string_cmpnc(TCP_CAN_MODULE_ALL, &getRequest[sizeTotal], sizeKey)){
	MOVLW       _TCP_CAN_MODULE_ALL+0
	MOVWF       FARG_string_cmpnc_text1+0 
	MOVLW       hi_addr(_TCP_CAN_MODULE_ALL+0)
	MOVWF       FARG_string_cmpnc_text1+1 
	MOVLW       higher_addr(_TCP_CAN_MODULE_ALL+0)
	MOVWF       FARG_string_cmpnc_text1+2 
	MOVLW       _getRequest+0
	MOVWF       FARG_string_cmpnc_text2+0 
	MOVLW       hi_addr(_getRequest+0)
	MOVWF       FARG_string_cmpnc_text2+1 
	MOVF        Net_Ethernet_28j60_UserTCP_sizeTotal_L0+0, 0 
	ADDWF       FARG_string_cmpnc_text2+0, 1 
	BTFSC       STATUS+0, 0 
	INCF        FARG_string_cmpnc_text2+1, 1 
	MOVF        Net_Ethernet_28j60_UserTCP_sizeKey_L0+0, 0 
	MOVWF       FARG_string_cmpnc_bytes+0 
	CALL        _string_cmpnc+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_Net_Ethernet_28j60_UserTCP841
;TPV.c,1408 :: 		buffer_save_send(false, bufferEeprom, tarjetas.canIdMod);
	CLRF        FARG_buffer_save_send_tcpORcan+0 
	MOVLW       _bufferEeprom+0
	MOVWF       FARG_buffer_save_send_buffer+0 
	MOVLW       hi_addr(_bufferEeprom+0)
	MOVWF       FARG_buffer_save_send_buffer+1 
	MOVLW       _tarjetas+42
	MOVWF       FARG_buffer_save_send_nodosCAN+0 
	MOVLW       hi_addr(_tarjetas+42)
	MOVWF       FARG_buffer_save_send_nodosCAN+1 
	CALL        _buffer_save_send+0, 0
;TPV.c,1409 :: 		}else{ //PREGUNTAR QUE OTRO NODO DEBO ENVIAR
	GOTO        L_Net_Ethernet_28j60_UserTCP842
L_Net_Ethernet_28j60_UserTCP841:
;TPV.c,1410 :: 		if(getRequest[sizeTotal] != TCP_CAN_MODULE[0]){
	MOVLW       _getRequest+0
	MOVWF       FSR0 
	MOVLW       hi_addr(_getRequest+0)
	MOVWF       FSR0H 
	MOVF        Net_Ethernet_28j60_UserTCP_sizeTotal_L0+0, 0 
	ADDWF       FSR0, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR0H, 1 
	MOVF        POSTINC0+0, 0 
	XORLW       84
	BTFSC       STATUS+0, 2 
	GOTO        L_Net_Ethernet_28j60_UserTCP843
;TPV.c,1411 :: 		cmdOwn = false;
	CLRF        Net_Ethernet_28j60_UserTCP_cmdOwn_L0+0 
;TPV.c,1413 :: 		string_cpyn(msjConst, &getRequest[sizeTotal+1], 2);
	MOVLW       _msjConst+0
	MOVWF       FARG_string_cpyn_destino+0 
	MOVLW       hi_addr(_msjConst+0)
	MOVWF       FARG_string_cpyn_destino+1 
	MOVF        Net_Ethernet_28j60_UserTCP_sizeTotal_L0+0, 0 
	ADDLW       1
	MOVWF       R0 
	CLRF        R1 
	MOVLW       0
	ADDWFC      R1, 1 
	MOVLW       _getRequest+0
	ADDWF       R0, 0 
	MOVWF       FARG_string_cpyn_origen+0 
	MOVLW       hi_addr(_getRequest+0)
	ADDWFC      R1, 0 
	MOVWF       FARG_string_cpyn_origen+1 
	MOVLW       2
	MOVWF       FARG_string_cpyn_size+0 
	CALL        _string_cpyn+0, 0
;TPV.c,1414 :: 		nodo = hexToNum(msjConst);
	MOVLW       _msjConst+0
	MOVWF       FARG_hexToNum_hex+0 
	MOVLW       hi_addr(_msjConst+0)
	MOVWF       FARG_hexToNum_hex+1 
	CALL        _hexToNum+0, 0
	MOVF        R0, 0 
	MOVWF       Net_Ethernet_28j60_UserTCP_nodo_L0+0 
;TPV.c,1415 :: 		for(result = 0; result < tarjetas.modulos; result++){
	CLRF        Net_Ethernet_28j60_UserTCP_result_L0+0 
L_Net_Ethernet_28j60_UserTCP844:
	MOVF        _tarjetas+1, 0 
	SUBWF       Net_Ethernet_28j60_UserTCP_result_L0+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_Net_Ethernet_28j60_UserTCP845
;TPV.c,1416 :: 		if(nodo == tarjetas.canIdMod[result]){
	MOVLW       _tarjetas+42
	MOVWF       FSR2 
	MOVLW       hi_addr(_tarjetas+42)
	MOVWF       FSR2H 
	MOVF        Net_Ethernet_28j60_UserTCP_result_L0+0, 0 
	ADDWF       FSR2, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR2H, 1 
	MOVF        Net_Ethernet_28j60_UserTCP_nodo_L0+0, 0 
	XORWF       POSTINC2+0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L_Net_Ethernet_28j60_UserTCP847
;TPV.c,1418 :: 		msjConst[0] = nodo;
	MOVF        Net_Ethernet_28j60_UserTCP_nodo_L0+0, 0 
	MOVWF       _msjConst+0 
;TPV.c,1419 :: 		msjConst[1] = 0;  //Fin de cadena anexado
	CLRF        _msjConst+1 
;TPV.c,1420 :: 		buffer_save_send(false, bufferEeprom, msjConst);
	CLRF        FARG_buffer_save_send_tcpORcan+0 
	MOVLW       _bufferEeprom+0
	MOVWF       FARG_buffer_save_send_buffer+0 
	MOVLW       hi_addr(_bufferEeprom+0)
	MOVWF       FARG_buffer_save_send_buffer+1 
	MOVLW       _msjConst+0
	MOVWF       FARG_buffer_save_send_nodosCAN+0 
	MOVLW       hi_addr(_msjConst+0)
	MOVWF       FARG_buffer_save_send_nodosCAN+1 
	CALL        _buffer_save_send+0, 0
;TPV.c,1421 :: 		break;//No enviar respuesta con TPV si no con el modulo
	GOTO        L_Net_Ethernet_28j60_UserTCP845
;TPV.c,1422 :: 		}
L_Net_Ethernet_28j60_UserTCP847:
;TPV.c,1415 :: 		for(result = 0; result < tarjetas.modulos; result++){
	INCF        Net_Ethernet_28j60_UserTCP_result_L0+0, 1 
;TPV.c,1423 :: 		}
	GOTO        L_Net_Ethernet_28j60_UserTCP844
L_Net_Ethernet_28j60_UserTCP845:
;TPV.c,1425 :: 		if(result == tarjetas.modulos)
	MOVF        Net_Ethernet_28j60_UserTCP_result_L0+0, 0 
	XORWF       _tarjetas+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L_Net_Ethernet_28j60_UserTCP848
;TPV.c,1426 :: 		string_addc(respuesta, TCP_TBL_ERROR);
	MOVLW       Net_Ethernet_28j60_UserTCP_respuesta_L0+0
	MOVWF       FARG_string_addc_destino+0 
	MOVLW       hi_addr(Net_Ethernet_28j60_UserTCP_respuesta_L0+0)
	MOVWF       FARG_string_addc_destino+1 
	MOVLW       _TCP_TBL_ERROR+0
	MOVWF       FARG_string_addc_addEnd+0 
	MOVLW       hi_addr(_TCP_TBL_ERROR+0)
	MOVWF       FARG_string_addc_addEnd+1 
	MOVLW       higher_addr(_TCP_TBL_ERROR+0)
	MOVWF       FARG_string_addc_addEnd+2 
	CALL        _string_addc+0, 0
	GOTO        L_Net_Ethernet_28j60_UserTCP849
L_Net_Ethernet_28j60_UserTCP848:
;TPV.c,1428 :: 		string_addc(respuesta, TCP_TBL_OK);
	MOVLW       Net_Ethernet_28j60_UserTCP_respuesta_L0+0
	MOVWF       FARG_string_addc_destino+0 
	MOVLW       hi_addr(Net_Ethernet_28j60_UserTCP_respuesta_L0+0)
	MOVWF       FARG_string_addc_destino+1 
	MOVLW       _TCP_TBL_OK+0
	MOVWF       FARG_string_addc_addEnd+0 
	MOVLW       hi_addr(_TCP_TBL_OK+0)
	MOVWF       FARG_string_addc_addEnd+1 
	MOVLW       higher_addr(_TCP_TBL_OK+0)
	MOVWF       FARG_string_addc_addEnd+2 
	CALL        _string_addc+0, 0
L_Net_Ethernet_28j60_UserTCP849:
;TPV.c,1429 :: 		}
L_Net_Ethernet_28j60_UserTCP843:
;TPV.c,1430 :: 		}
L_Net_Ethernet_28j60_UserTCP842:
;TPV.c,1433 :: 		sizeTotal += sizeKey;
	MOVF        Net_Ethernet_28j60_UserTCP_sizeKey_L0+0, 0 
	ADDWF       Net_Ethernet_28j60_UserTCP_sizeTotal_L0+0, 0 
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       Net_Ethernet_28j60_UserTCP_sizeTotal_L0+0 
;TPV.c,1434 :: 		sizeKey = sizeof(TCP_TABLE_ERASE)-1;
	MOVLW       3
	MOVWF       Net_Ethernet_28j60_UserTCP_sizeKey_L0+0 
;TPV.c,1437 :: 		if(string_cmpnc(TCP_TABLE_ERASE, &getRequest[sizeTotal], sizeKey) && cmdOwn){
	MOVLW       _TCP_TABLE_ERASE+0
	MOVWF       FARG_string_cmpnc_text1+0 
	MOVLW       hi_addr(_TCP_TABLE_ERASE+0)
	MOVWF       FARG_string_cmpnc_text1+1 
	MOVLW       higher_addr(_TCP_TABLE_ERASE+0)
	MOVWF       FARG_string_cmpnc_text1+2 
	MOVLW       _getRequest+0
	MOVWF       FARG_string_cmpnc_text2+0 
	MOVLW       hi_addr(_getRequest+0)
	MOVWF       FARG_string_cmpnc_text2+1 
	MOVF        R0, 0 
	ADDWF       FARG_string_cmpnc_text2+0, 1 
	BTFSC       STATUS+0, 0 
	INCF        FARG_string_cmpnc_text2+1, 1 
	MOVLW       3
	MOVWF       FARG_string_cmpnc_bytes+0 
	CALL        _string_cmpnc+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_Net_Ethernet_28j60_UserTCP852
	MOVF        Net_Ethernet_28j60_UserTCP_cmdOwn_L0+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_Net_Ethernet_28j60_UserTCP852
L__Net_Ethernet_28j60_UserTCP1016:
;TPV.c,1439 :: 		sizeTotal += sizeKey;
	MOVF        Net_Ethernet_28j60_UserTCP_sizeKey_L0+0, 0 
	ADDWF       Net_Ethernet_28j60_UserTCP_sizeTotal_L0+0, 0 
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       Net_Ethernet_28j60_UserTCP_sizeTotal_L0+0 
;TPV.c,1441 :: 		if(mysql_erase(&getRequest[sizeTotal])){
	MOVLW       _getRequest+0
	MOVWF       FARG_mysql_erase_name+0 
	MOVLW       hi_addr(_getRequest+0)
	MOVWF       FARG_mysql_erase_name+1 
	MOVF        R0, 0 
	ADDWF       FARG_mysql_erase_name+0, 1 
	BTFSC       STATUS+0, 0 
	INCF        FARG_mysql_erase_name+1, 1 
	CALL        _mysql_erase+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_Net_Ethernet_28j60_UserTCP853
;TPV.c,1443 :: 		string_addc(respuesta, TCP_TABLE_ERASE);
	MOVLW       Net_Ethernet_28j60_UserTCP_respuesta_L0+0
	MOVWF       FARG_string_addc_destino+0 
	MOVLW       hi_addr(Net_Ethernet_28j60_UserTCP_respuesta_L0+0)
	MOVWF       FARG_string_addc_destino+1 
	MOVLW       _TCP_TABLE_ERASE+0
	MOVWF       FARG_string_addc_addEnd+0 
	MOVLW       hi_addr(_TCP_TABLE_ERASE+0)
	MOVWF       FARG_string_addc_addEnd+1 
	MOVLW       higher_addr(_TCP_TABLE_ERASE+0)
	MOVWF       FARG_string_addc_addEnd+2 
	CALL        _string_addc+0, 0
;TPV.c,1444 :: 		string_cpyn(msjConst, &getRequest[sizeTotal], 3);
	MOVLW       _msjConst+0
	MOVWF       FARG_string_cpyn_destino+0 
	MOVLW       hi_addr(_msjConst+0)
	MOVWF       FARG_string_cpyn_destino+1 
	MOVLW       _getRequest+0
	MOVWF       FARG_string_cpyn_origen+0 
	MOVLW       hi_addr(_getRequest+0)
	MOVWF       FARG_string_cpyn_origen+1 
	MOVF        Net_Ethernet_28j60_UserTCP_sizeTotal_L0+0, 0 
	ADDWF       FARG_string_cpyn_origen+0, 1 
	BTFSC       STATUS+0, 0 
	INCF        FARG_string_cpyn_origen+1, 1 
	MOVLW       3
	MOVWF       FARG_string_cpyn_size+0 
	CALL        _string_cpyn+0, 0
;TPV.c,1445 :: 		string_toUpper(msjConst);
	MOVLW       _msjConst+0
	MOVWF       FARG_string_toUpper_cadena+0 
	MOVLW       hi_addr(_msjConst+0)
	MOVWF       FARG_string_toUpper_cadena+1 
	CALL        _string_toUpper+0, 0
;TPV.c,1446 :: 		string_add(respuesta, msjConst);
	MOVLW       Net_Ethernet_28j60_UserTCP_respuesta_L0+0
	MOVWF       FARG_string_add_destino+0 
	MOVLW       hi_addr(Net_Ethernet_28j60_UserTCP_respuesta_L0+0)
	MOVWF       FARG_string_add_destino+1 
	MOVLW       _msjConst+0
	MOVWF       FARG_string_add_addEnd+0 
	MOVLW       hi_addr(_msjConst+0)
	MOVWF       FARG_string_add_addEnd+1 
	CALL        _string_add+0, 0
;TPV.c,1447 :: 		}else{
	GOTO        L_Net_Ethernet_28j60_UserTCP854
L_Net_Ethernet_28j60_UserTCP853:
;TPV.c,1448 :: 		string_addc(respuesta, TCP_TABLE_ERASE);
	MOVLW       Net_Ethernet_28j60_UserTCP_respuesta_L0+0
	MOVWF       FARG_string_addc_destino+0 
	MOVLW       hi_addr(Net_Ethernet_28j60_UserTCP_respuesta_L0+0)
	MOVWF       FARG_string_addc_destino+1 
	MOVLW       _TCP_TABLE_ERASE+0
	MOVWF       FARG_string_addc_addEnd+0 
	MOVLW       hi_addr(_TCP_TABLE_ERASE+0)
	MOVWF       FARG_string_addc_addEnd+1 
	MOVLW       higher_addr(_TCP_TABLE_ERASE+0)
	MOVWF       FARG_string_addc_addEnd+2 
	CALL        _string_addc+0, 0
;TPV.c,1449 :: 		string_addc(respuesta, TCP_TBL_NO_FOUND);
	MOVLW       Net_Ethernet_28j60_UserTCP_respuesta_L0+0
	MOVWF       FARG_string_addc_destino+0 
	MOVLW       hi_addr(Net_Ethernet_28j60_UserTCP_respuesta_L0+0)
	MOVWF       FARG_string_addc_destino+1 
	MOVLW       _TCP_TBL_NO_FOUND+0
	MOVWF       FARG_string_addc_addEnd+0 
	MOVLW       hi_addr(_TCP_TBL_NO_FOUND+0)
	MOVWF       FARG_string_addc_addEnd+1 
	MOVLW       higher_addr(_TCP_TBL_NO_FOUND+0)
	MOVWF       FARG_string_addc_addEnd+2 
	CALL        _string_addc+0, 0
;TPV.c,1450 :: 		bufferEeprom[0] = 0;
	CLRF        _bufferEeprom+0 
;TPV.c,1451 :: 		}
L_Net_Ethernet_28j60_UserTCP854:
;TPV.c,1453 :: 		string_cpyc(msjConst, TCP_CAN_MODULE);
	MOVLW       _msjConst+0
	MOVWF       FARG_string_cpyc_destino+0 
	MOVLW       hi_addr(_msjConst+0)
	MOVWF       FARG_string_cpyc_destino+1 
	MOVLW       _TCP_CAN_MODULE+0
	MOVWF       FARG_string_cpyc_origen+0 
	MOVLW       hi_addr(_TCP_CAN_MODULE+0)
	MOVWF       FARG_string_cpyc_origen+1 
	MOVLW       higher_addr(_TCP_CAN_MODULE+0)
	MOVWF       FARG_string_cpyc_origen+2 
	CALL        _string_cpyc+0, 0
;TPV.c,1454 :: 		numToHex(can.id, &msjConst[1], 1);
	MOVF        _can+12, 0 
	MOVWF       FARG_numToHex_valor+0 
	MOVLW       0
	MOVWF       FARG_numToHex_valor+1 
	MOVWF       FARG_numToHex_valor+2 
	MOVWF       FARG_numToHex_valor+3 
	MOVLW       _msjConst+1
	MOVWF       FARG_numToHex_cadena+0 
	MOVLW       hi_addr(_msjConst+1)
	MOVWF       FARG_numToHex_cadena+1 
	MOVLW       1
	MOVWF       FARG_numToHex_bytes+0 
	CALL        _numToHex+0, 0
;TPV.c,1455 :: 		string_add(respuesta, msjConst);
	MOVLW       Net_Ethernet_28j60_UserTCP_respuesta_L0+0
	MOVWF       FARG_string_add_destino+0 
	MOVLW       hi_addr(Net_Ethernet_28j60_UserTCP_respuesta_L0+0)
	MOVWF       FARG_string_add_destino+1 
	MOVLW       _msjConst+0
	MOVWF       FARG_string_add_addEnd+0 
	MOVLW       hi_addr(_msjConst+0)
	MOVWF       FARG_string_add_addEnd+1 
	CALL        _string_add+0, 0
;TPV.c,1456 :: 		}else if(string_cmpnc(TCP_TABLE_INFO, &getRequest[sizeTotal], sizeKey) && cmdOwn){
	GOTO        L_Net_Ethernet_28j60_UserTCP855
L_Net_Ethernet_28j60_UserTCP852:
	MOVLW       _TCP_TABLE_INFO+0
	MOVWF       FARG_string_cmpnc_text1+0 
	MOVLW       hi_addr(_TCP_TABLE_INFO+0)
	MOVWF       FARG_string_cmpnc_text1+1 
	MOVLW       higher_addr(_TCP_TABLE_INFO+0)
	MOVWF       FARG_string_cmpnc_text1+2 
	MOVLW       _getRequest+0
	MOVWF       FARG_string_cmpnc_text2+0 
	MOVLW       hi_addr(_getRequest+0)
	MOVWF       FARG_string_cmpnc_text2+1 
	MOVF        Net_Ethernet_28j60_UserTCP_sizeTotal_L0+0, 0 
	ADDWF       FARG_string_cmpnc_text2+0, 1 
	BTFSC       STATUS+0, 0 
	INCF        FARG_string_cmpnc_text2+1, 1 
	MOVF        Net_Ethernet_28j60_UserTCP_sizeKey_L0+0, 0 
	MOVWF       FARG_string_cmpnc_bytes+0 
	CALL        _string_cmpnc+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_Net_Ethernet_28j60_UserTCP858
	MOVF        Net_Ethernet_28j60_UserTCP_cmdOwn_L0+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_Net_Ethernet_28j60_UserTCP858
L__Net_Ethernet_28j60_UserTCP1015:
;TPV.c,1458 :: 		sizeTotal += sizeKey;
	MOVF        Net_Ethernet_28j60_UserTCP_sizeKey_L0+0, 0 
	ADDWF       Net_Ethernet_28j60_UserTCP_sizeTotal_L0+0, 0 
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       Net_Ethernet_28j60_UserTCP_sizeTotal_L0+0 
;TPV.c,1459 :: 		if(mysql_exist(&getRequest[sizeTotal])){
	MOVLW       _getRequest+0
	MOVWF       FARG_mysql_exist_name+0 
	MOVLW       hi_addr(_getRequest+0)
	MOVWF       FARG_mysql_exist_name+1 
	MOVF        R0, 0 
	ADDWF       FARG_mysql_exist_name+0, 1 
	BTFSC       STATUS+0, 0 
	INCF        FARG_mysql_exist_name+1, 1 
	CALL        _mysql_exist+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_Net_Ethernet_28j60_UserTCP859
;TPV.c,1460 :: 		string_addc(respuesta, TCP_TABLE_INFO);
	MOVLW       Net_Ethernet_28j60_UserTCP_respuesta_L0+0
	MOVWF       FARG_string_addc_destino+0 
	MOVLW       hi_addr(Net_Ethernet_28j60_UserTCP_respuesta_L0+0)
	MOVWF       FARG_string_addc_destino+1 
	MOVLW       _TCP_TABLE_INFO+0
	MOVWF       FARG_string_addc_addEnd+0 
	MOVLW       hi_addr(_TCP_TABLE_INFO+0)
	MOVWF       FARG_string_addc_addEnd+1 
	MOVLW       higher_addr(_TCP_TABLE_INFO+0)
	MOVWF       FARG_string_addc_addEnd+2 
	CALL        _string_addc+0, 0
;TPV.c,1462 :: 		string_cpyn(msjConst, &getRequest[sizeTotal], 3);
	MOVLW       _msjConst+0
	MOVWF       FARG_string_cpyn_destino+0 
	MOVLW       hi_addr(_msjConst+0)
	MOVWF       FARG_string_cpyn_destino+1 
	MOVLW       _getRequest+0
	MOVWF       FARG_string_cpyn_origen+0 
	MOVLW       hi_addr(_getRequest+0)
	MOVWF       FARG_string_cpyn_origen+1 
	MOVF        Net_Ethernet_28j60_UserTCP_sizeTotal_L0+0, 0 
	ADDWF       FARG_string_cpyn_origen+0, 1 
	BTFSC       STATUS+0, 0 
	INCF        FARG_string_cpyn_origen+1, 1 
	MOVLW       3
	MOVWF       FARG_string_cpyn_size+0 
	CALL        _string_cpyn+0, 0
;TPV.c,1463 :: 		string_toUpper(msjConst);
	MOVLW       _msjConst+0
	MOVWF       FARG_string_toUpper_cadena+0 
	MOVLW       hi_addr(_msjConst+0)
	MOVWF       FARG_string_toUpper_cadena+1 
	CALL        _string_toUpper+0, 0
;TPV.c,1464 :: 		string_add(respuesta, msjConst);
	MOVLW       Net_Ethernet_28j60_UserTCP_respuesta_L0+0
	MOVWF       FARG_string_add_destino+0 
	MOVLW       hi_addr(Net_Ethernet_28j60_UserTCP_respuesta_L0+0)
	MOVWF       FARG_string_add_destino+1 
	MOVLW       _msjConst+0
	MOVWF       FARG_string_add_addEnd+0 
	MOVLW       hi_addr(_msjConst+0)
	MOVWF       FARG_string_add_addEnd+1 
	CALL        _string_add+0, 0
;TPV.c,1466 :: 		string_addc(respuesta, FILAS_ACTUALES);
	MOVLW       Net_Ethernet_28j60_UserTCP_respuesta_L0+0
	MOVWF       FARG_string_addc_destino+0 
	MOVLW       hi_addr(Net_Ethernet_28j60_UserTCP_respuesta_L0+0)
	MOVWF       FARG_string_addc_destino+1 
	MOVLW       Net_Ethernet_28j60_UserTCP_FILAS_ACTUALES_L0+0
	MOVWF       FARG_string_addc_addEnd+0 
	MOVLW       hi_addr(Net_Ethernet_28j60_UserTCP_FILAS_ACTUALES_L0+0)
	MOVWF       FARG_string_addc_addEnd+1 
	MOVLW       higher_addr(Net_Ethernet_28j60_UserTCP_FILAS_ACTUALES_L0+0)
	MOVWF       FARG_string_addc_addEnd+2 
	CALL        _string_addc+0, 0
;TPV.c,1467 :: 		numToString(myTable.rowAct, msjConst, 4);
	MOVF        TPV_myTable+4, 0 
	MOVWF       FARG_numToString_valor+0 
	MOVF        TPV_myTable+5, 0 
	MOVWF       FARG_numToString_valor+1 
	MOVLW       0
	MOVWF       FARG_numToString_valor+2 
	MOVWF       FARG_numToString_valor+3 
	MOVLW       _msjConst+0
	MOVWF       FARG_numToString_cadena+0 
	MOVLW       hi_addr(_msjConst+0)
	MOVWF       FARG_numToString_cadena+1 
	MOVLW       4
	MOVWF       FARG_numToString_digitos+0 
	CALL        _numToString+0, 0
;TPV.c,1468 :: 		string_add(respuesta, msjConst);
	MOVLW       Net_Ethernet_28j60_UserTCP_respuesta_L0+0
	MOVWF       FARG_string_add_destino+0 
	MOVLW       hi_addr(Net_Ethernet_28j60_UserTCP_respuesta_L0+0)
	MOVWF       FARG_string_add_destino+1 
	MOVLW       _msjConst+0
	MOVWF       FARG_string_add_addEnd+0 
	MOVLW       hi_addr(_msjConst+0)
	MOVWF       FARG_string_add_addEnd+1 
	CALL        _string_add+0, 0
;TPV.c,1470 :: 		string_addc(respuesta, FILAS_PROG);
	MOVLW       Net_Ethernet_28j60_UserTCP_respuesta_L0+0
	MOVWF       FARG_string_addc_destino+0 
	MOVLW       hi_addr(Net_Ethernet_28j60_UserTCP_respuesta_L0+0)
	MOVWF       FARG_string_addc_destino+1 
	MOVLW       Net_Ethernet_28j60_UserTCP_FILAS_PROG_L0+0
	MOVWF       FARG_string_addc_addEnd+0 
	MOVLW       hi_addr(Net_Ethernet_28j60_UserTCP_FILAS_PROG_L0+0)
	MOVWF       FARG_string_addc_addEnd+1 
	MOVLW       higher_addr(Net_Ethernet_28j60_UserTCP_FILAS_PROG_L0+0)
	MOVWF       FARG_string_addc_addEnd+2 
	CALL        _string_addc+0, 0
;TPV.c,1471 :: 		numToString(myTable.row, msjConst, 4);
	MOVF        TPV_myTable+2, 0 
	MOVWF       FARG_numToString_valor+0 
	MOVF        TPV_myTable+3, 0 
	MOVWF       FARG_numToString_valor+1 
	MOVLW       0
	MOVWF       FARG_numToString_valor+2 
	MOVWF       FARG_numToString_valor+3 
	MOVLW       _msjConst+0
	MOVWF       FARG_numToString_cadena+0 
	MOVLW       hi_addr(_msjConst+0)
	MOVWF       FARG_numToString_cadena+1 
	MOVLW       4
	MOVWF       FARG_numToString_digitos+0 
	CALL        _numToString+0, 0
;TPV.c,1472 :: 		string_add(respuesta, msjConst);
	MOVLW       Net_Ethernet_28j60_UserTCP_respuesta_L0+0
	MOVWF       FARG_string_add_destino+0 
	MOVLW       hi_addr(Net_Ethernet_28j60_UserTCP_respuesta_L0+0)
	MOVWF       FARG_string_add_destino+1 
	MOVLW       _msjConst+0
	MOVWF       FARG_string_add_addEnd+0 
	MOVLW       hi_addr(_msjConst+0)
	MOVWF       FARG_string_add_addEnd+1 
	CALL        _string_add+0, 0
;TPV.c,1473 :: 		}else{
	GOTO        L_Net_Ethernet_28j60_UserTCP860
L_Net_Ethernet_28j60_UserTCP859:
;TPV.c,1474 :: 		string_addc(respuesta, TCP_TABLE_INFO);
	MOVLW       Net_Ethernet_28j60_UserTCP_respuesta_L0+0
	MOVWF       FARG_string_addc_destino+0 
	MOVLW       hi_addr(Net_Ethernet_28j60_UserTCP_respuesta_L0+0)
	MOVWF       FARG_string_addc_destino+1 
	MOVLW       _TCP_TABLE_INFO+0
	MOVWF       FARG_string_addc_addEnd+0 
	MOVLW       hi_addr(_TCP_TABLE_INFO+0)
	MOVWF       FARG_string_addc_addEnd+1 
	MOVLW       higher_addr(_TCP_TABLE_INFO+0)
	MOVWF       FARG_string_addc_addEnd+2 
	CALL        _string_addc+0, 0
;TPV.c,1475 :: 		string_addc(respuesta, TCP_TBL_NO_FOUND);
	MOVLW       Net_Ethernet_28j60_UserTCP_respuesta_L0+0
	MOVWF       FARG_string_addc_destino+0 
	MOVLW       hi_addr(Net_Ethernet_28j60_UserTCP_respuesta_L0+0)
	MOVWF       FARG_string_addc_destino+1 
	MOVLW       _TCP_TBL_NO_FOUND+0
	MOVWF       FARG_string_addc_addEnd+0 
	MOVLW       hi_addr(_TCP_TBL_NO_FOUND+0)
	MOVWF       FARG_string_addc_addEnd+1 
	MOVLW       higher_addr(_TCP_TBL_NO_FOUND+0)
	MOVWF       FARG_string_addc_addEnd+2 
	CALL        _string_addc+0, 0
;TPV.c,1476 :: 		bufferEeprom[0] = 0;
	CLRF        _bufferEeprom+0 
;TPV.c,1477 :: 		}
L_Net_Ethernet_28j60_UserTCP860:
;TPV.c,1479 :: 		string_cpyc(msjConst, TCP_CAN_MODULE);
	MOVLW       _msjConst+0
	MOVWF       FARG_string_cpyc_destino+0 
	MOVLW       hi_addr(_msjConst+0)
	MOVWF       FARG_string_cpyc_destino+1 
	MOVLW       _TCP_CAN_MODULE+0
	MOVWF       FARG_string_cpyc_origen+0 
	MOVLW       hi_addr(_TCP_CAN_MODULE+0)
	MOVWF       FARG_string_cpyc_origen+1 
	MOVLW       higher_addr(_TCP_CAN_MODULE+0)
	MOVWF       FARG_string_cpyc_origen+2 
	CALL        _string_cpyc+0, 0
;TPV.c,1480 :: 		numToHex(can.id, &msjConst[1], 1);
	MOVF        _can+12, 0 
	MOVWF       FARG_numToHex_valor+0 
	MOVLW       0
	MOVWF       FARG_numToHex_valor+1 
	MOVWF       FARG_numToHex_valor+2 
	MOVWF       FARG_numToHex_valor+3 
	MOVLW       _msjConst+1
	MOVWF       FARG_numToHex_cadena+0 
	MOVLW       hi_addr(_msjConst+1)
	MOVWF       FARG_numToHex_cadena+1 
	MOVLW       1
	MOVWF       FARG_numToHex_bytes+0 
	CALL        _numToHex+0, 0
;TPV.c,1481 :: 		string_add(respuesta, msjConst);
	MOVLW       Net_Ethernet_28j60_UserTCP_respuesta_L0+0
	MOVWF       FARG_string_add_destino+0 
	MOVLW       hi_addr(Net_Ethernet_28j60_UserTCP_respuesta_L0+0)
	MOVWF       FARG_string_add_destino+1 
	MOVLW       _msjConst+0
	MOVWF       FARG_string_add_addEnd+0 
	MOVLW       hi_addr(_msjConst+0)
	MOVWF       FARG_string_add_addEnd+1 
	CALL        _string_add+0, 0
;TPV.c,1482 :: 		}
L_Net_Ethernet_28j60_UserTCP858:
L_Net_Ethernet_28j60_UserTCP855:
;TPV.c,1483 :: 		}else if(string_cmpnc(TCP_CAN_CMD, &getRequest[sizeTotal], sizeKey)){
	GOTO        L_Net_Ethernet_28j60_UserTCP861
L_Net_Ethernet_28j60_UserTCP840:
	MOVLW       _TCP_CAN_CMD+0
	MOVWF       FARG_string_cmpnc_text1+0 
	MOVLW       hi_addr(_TCP_CAN_CMD+0)
	MOVWF       FARG_string_cmpnc_text1+1 
	MOVLW       higher_addr(_TCP_CAN_CMD+0)
	MOVWF       FARG_string_cmpnc_text1+2 
	MOVLW       _getRequest+0
	MOVWF       FARG_string_cmpnc_text2+0 
	MOVLW       hi_addr(_getRequest+0)
	MOVWF       FARG_string_cmpnc_text2+1 
	MOVF        Net_Ethernet_28j60_UserTCP_sizeTotal_L0+0, 0 
	ADDWF       FARG_string_cmpnc_text2+0, 1 
	BTFSC       STATUS+0, 0 
	INCF        FARG_string_cmpnc_text2+1, 1 
	MOVF        Net_Ethernet_28j60_UserTCP_sizeKey_L0+0, 0 
	MOVWF       FARG_string_cmpnc_bytes+0 
	CALL        _string_cmpnc+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_Net_Ethernet_28j60_UserTCP862
;TPV.c,1484 :: 		sizeTotal += sizeKey;
	MOVF        Net_Ethernet_28j60_UserTCP_sizeKey_L0+0, 0 
	ADDWF       Net_Ethernet_28j60_UserTCP_sizeTotal_L0+0, 0 
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       Net_Ethernet_28j60_UserTCP_sizeTotal_L0+0 
;TPV.c,1485 :: 		sizeKey = sizeof(TCP_CAN_MODULE_ALL)-1;
	MOVLW       3
	MOVWF       Net_Ethernet_28j60_UserTCP_sizeKey_L0+0 
;TPV.c,1487 :: 		string_cpyn(respuesta, getRequest, sizeTotal);
	MOVLW       Net_Ethernet_28j60_UserTCP_respuesta_L0+0
	MOVWF       FARG_string_cpyn_destino+0 
	MOVLW       hi_addr(Net_Ethernet_28j60_UserTCP_respuesta_L0+0)
	MOVWF       FARG_string_cpyn_destino+1 
	MOVLW       _getRequest+0
	MOVWF       FARG_string_cpyn_origen+0 
	MOVLW       hi_addr(_getRequest+0)
	MOVWF       FARG_string_cpyn_origen+1 
	MOVF        R0, 0 
	MOVWF       FARG_string_cpyn_size+0 
	CALL        _string_cpyn+0, 0
;TPV.c,1489 :: 		string_cpyn(bufferEeprom, getRequest, sizeTotal);
	MOVLW       _bufferEeprom+0
	MOVWF       FARG_string_cpyn_destino+0 
	MOVLW       hi_addr(_bufferEeprom+0)
	MOVWF       FARG_string_cpyn_destino+1 
	MOVLW       _getRequest+0
	MOVWF       FARG_string_cpyn_origen+0 
	MOVLW       hi_addr(_getRequest+0)
	MOVWF       FARG_string_cpyn_origen+1 
	MOVF        Net_Ethernet_28j60_UserTCP_sizeTotal_L0+0, 0 
	MOVWF       FARG_string_cpyn_size+0 
	CALL        _string_cpyn+0, 0
;TPV.c,1490 :: 		string_add(bufferEeprom, &getRequest[sizeTotal+sizeKey]);
	MOVLW       _bufferEeprom+0
	MOVWF       FARG_string_add_destino+0 
	MOVLW       hi_addr(_bufferEeprom+0)
	MOVWF       FARG_string_add_destino+1 
	MOVF        Net_Ethernet_28j60_UserTCP_sizeKey_L0+0, 0 
	ADDWF       Net_Ethernet_28j60_UserTCP_sizeTotal_L0+0, 0 
	MOVWF       R0 
	CLRF        R1 
	MOVLW       0
	ADDWFC      R1, 1 
	MOVLW       _getRequest+0
	ADDWF       R0, 0 
	MOVWF       FARG_string_add_addEnd+0 
	MOVLW       hi_addr(_getRequest+0)
	ADDWFC      R1, 0 
	MOVWF       FARG_string_add_addEnd+1 
	CALL        _string_add+0, 0
;TPV.c,1492 :: 		cmdOwn = true;
	MOVLW       1
	MOVWF       Net_Ethernet_28j60_UserTCP_cmdOwn_L0+0 
;TPV.c,1493 :: 		if(string_cmpnc(TCP_CAN_MODULE_ALL, &getRequest[sizeTotal], sizeKey)){
	MOVLW       _TCP_CAN_MODULE_ALL+0
	MOVWF       FARG_string_cmpnc_text1+0 
	MOVLW       hi_addr(_TCP_CAN_MODULE_ALL+0)
	MOVWF       FARG_string_cmpnc_text1+1 
	MOVLW       higher_addr(_TCP_CAN_MODULE_ALL+0)
	MOVWF       FARG_string_cmpnc_text1+2 
	MOVLW       _getRequest+0
	MOVWF       FARG_string_cmpnc_text2+0 
	MOVLW       hi_addr(_getRequest+0)
	MOVWF       FARG_string_cmpnc_text2+1 
	MOVF        Net_Ethernet_28j60_UserTCP_sizeTotal_L0+0, 0 
	ADDWF       FARG_string_cmpnc_text2+0, 1 
	BTFSC       STATUS+0, 0 
	INCF        FARG_string_cmpnc_text2+1, 1 
	MOVF        Net_Ethernet_28j60_UserTCP_sizeKey_L0+0, 0 
	MOVWF       FARG_string_cmpnc_bytes+0 
	CALL        _string_cmpnc+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_Net_Ethernet_28j60_UserTCP863
;TPV.c,1494 :: 		buffer_save_send(false, bufferEeprom, tarjetas.canIdMod);
	CLRF        FARG_buffer_save_send_tcpORcan+0 
	MOVLW       _bufferEeprom+0
	MOVWF       FARG_buffer_save_send_buffer+0 
	MOVLW       hi_addr(_bufferEeprom+0)
	MOVWF       FARG_buffer_save_send_buffer+1 
	MOVLW       _tarjetas+42
	MOVWF       FARG_buffer_save_send_nodosCAN+0 
	MOVLW       hi_addr(_tarjetas+42)
	MOVWF       FARG_buffer_save_send_nodosCAN+1 
	CALL        _buffer_save_send+0, 0
;TPV.c,1495 :: 		}else{ //PREGUNTAR QUE OTRO NODO DEBO ENVIAR
	GOTO        L_Net_Ethernet_28j60_UserTCP864
L_Net_Ethernet_28j60_UserTCP863:
;TPV.c,1496 :: 		if(getRequest[sizeTotal] != TCP_CAN_MODULE[0]){
	MOVLW       _getRequest+0
	MOVWF       FSR0 
	MOVLW       hi_addr(_getRequest+0)
	MOVWF       FSR0H 
	MOVF        Net_Ethernet_28j60_UserTCP_sizeTotal_L0+0, 0 
	ADDWF       FSR0, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR0H, 1 
	MOVF        POSTINC0+0, 0 
	XORLW       84
	BTFSC       STATUS+0, 2 
	GOTO        L_Net_Ethernet_28j60_UserTCP865
;TPV.c,1497 :: 		cmdOwn = false;
	CLRF        Net_Ethernet_28j60_UserTCP_cmdOwn_L0+0 
;TPV.c,1499 :: 		string_cpyn(msjConst, &getRequest[sizeTotal+1], 2);
	MOVLW       _msjConst+0
	MOVWF       FARG_string_cpyn_destino+0 
	MOVLW       hi_addr(_msjConst+0)
	MOVWF       FARG_string_cpyn_destino+1 
	MOVF        Net_Ethernet_28j60_UserTCP_sizeTotal_L0+0, 0 
	ADDLW       1
	MOVWF       R0 
	CLRF        R1 
	MOVLW       0
	ADDWFC      R1, 1 
	MOVLW       _getRequest+0
	ADDWF       R0, 0 
	MOVWF       FARG_string_cpyn_origen+0 
	MOVLW       hi_addr(_getRequest+0)
	ADDWFC      R1, 0 
	MOVWF       FARG_string_cpyn_origen+1 
	MOVLW       2
	MOVWF       FARG_string_cpyn_size+0 
	CALL        _string_cpyn+0, 0
;TPV.c,1500 :: 		nodo = hexToNum(msjConst);
	MOVLW       _msjConst+0
	MOVWF       FARG_hexToNum_hex+0 
	MOVLW       hi_addr(_msjConst+0)
	MOVWF       FARG_hexToNum_hex+1 
	CALL        _hexToNum+0, 0
	MOVF        R0, 0 
	MOVWF       Net_Ethernet_28j60_UserTCP_nodo_L0+0 
;TPV.c,1501 :: 		for(result = 0; result < tarjetas.modulos; result++){
	CLRF        Net_Ethernet_28j60_UserTCP_result_L0+0 
L_Net_Ethernet_28j60_UserTCP866:
	MOVF        _tarjetas+1, 0 
	SUBWF       Net_Ethernet_28j60_UserTCP_result_L0+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_Net_Ethernet_28j60_UserTCP867
;TPV.c,1502 :: 		if(nodo == tarjetas.canIdMod[result]){
	MOVLW       _tarjetas+42
	MOVWF       FSR2 
	MOVLW       hi_addr(_tarjetas+42)
	MOVWF       FSR2H 
	MOVF        Net_Ethernet_28j60_UserTCP_result_L0+0, 0 
	ADDWF       FSR2, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR2H, 1 
	MOVF        Net_Ethernet_28j60_UserTCP_nodo_L0+0, 0 
	XORWF       POSTINC2+0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L_Net_Ethernet_28j60_UserTCP869
;TPV.c,1504 :: 		msjConst[0] = nodo;
	MOVF        Net_Ethernet_28j60_UserTCP_nodo_L0+0, 0 
	MOVWF       _msjConst+0 
;TPV.c,1505 :: 		msjConst[1] = 0;  //Fin de cadena anexado
	CLRF        _msjConst+1 
;TPV.c,1506 :: 		buffer_save_send(false, bufferEeprom, msjConst);
	CLRF        FARG_buffer_save_send_tcpORcan+0 
	MOVLW       _bufferEeprom+0
	MOVWF       FARG_buffer_save_send_buffer+0 
	MOVLW       hi_addr(_bufferEeprom+0)
	MOVWF       FARG_buffer_save_send_buffer+1 
	MOVLW       _msjConst+0
	MOVWF       FARG_buffer_save_send_nodosCAN+0 
	MOVLW       hi_addr(_msjConst+0)
	MOVWF       FARG_buffer_save_send_nodosCAN+1 
	CALL        _buffer_save_send+0, 0
;TPV.c,1507 :: 		break;//No enviar respuesta con TPV si no con el modulo
	GOTO        L_Net_Ethernet_28j60_UserTCP867
;TPV.c,1508 :: 		}
L_Net_Ethernet_28j60_UserTCP869:
;TPV.c,1501 :: 		for(result = 0; result < tarjetas.modulos; result++){
	INCF        Net_Ethernet_28j60_UserTCP_result_L0+0, 1 
;TPV.c,1509 :: 		}
	GOTO        L_Net_Ethernet_28j60_UserTCP866
L_Net_Ethernet_28j60_UserTCP867:
;TPV.c,1511 :: 		if(result == tarjetas.modulos)
	MOVF        Net_Ethernet_28j60_UserTCP_result_L0+0, 0 
	XORWF       _tarjetas+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L_Net_Ethernet_28j60_UserTCP870
;TPV.c,1512 :: 		string_addc(respuesta, TCP_TBL_ERROR);
	MOVLW       Net_Ethernet_28j60_UserTCP_respuesta_L0+0
	MOVWF       FARG_string_addc_destino+0 
	MOVLW       hi_addr(Net_Ethernet_28j60_UserTCP_respuesta_L0+0)
	MOVWF       FARG_string_addc_destino+1 
	MOVLW       _TCP_TBL_ERROR+0
	MOVWF       FARG_string_addc_addEnd+0 
	MOVLW       hi_addr(_TCP_TBL_ERROR+0)
	MOVWF       FARG_string_addc_addEnd+1 
	MOVLW       higher_addr(_TCP_TBL_ERROR+0)
	MOVWF       FARG_string_addc_addEnd+2 
	CALL        _string_addc+0, 0
	GOTO        L_Net_Ethernet_28j60_UserTCP871
L_Net_Ethernet_28j60_UserTCP870:
;TPV.c,1514 :: 		string_addc(respuesta, TCP_TBL_OK);
	MOVLW       Net_Ethernet_28j60_UserTCP_respuesta_L0+0
	MOVWF       FARG_string_addc_destino+0 
	MOVLW       hi_addr(Net_Ethernet_28j60_UserTCP_respuesta_L0+0)
	MOVWF       FARG_string_addc_destino+1 
	MOVLW       _TCP_TBL_OK+0
	MOVWF       FARG_string_addc_addEnd+0 
	MOVLW       hi_addr(_TCP_TBL_OK+0)
	MOVWF       FARG_string_addc_addEnd+1 
	MOVLW       higher_addr(_TCP_TBL_OK+0)
	MOVWF       FARG_string_addc_addEnd+2 
	CALL        _string_addc+0, 0
;TPV.c,1515 :: 		}
L_Net_Ethernet_28j60_UserTCP871:
;TPV.c,1516 :: 		}
L_Net_Ethernet_28j60_UserTCP865:
;TPV.c,1517 :: 		}
L_Net_Ethernet_28j60_UserTCP864:
;TPV.c,1519 :: 		sizeTotal += sizeKey;
	MOVF        Net_Ethernet_28j60_UserTCP_sizeKey_L0+0, 0 
	ADDWF       Net_Ethernet_28j60_UserTCP_sizeTotal_L0+0, 1 
;TPV.c,1520 :: 		sizeKey = sizeof(TCP_TABLE_ERASE)-1;
	MOVLW       3
	MOVWF       Net_Ethernet_28j60_UserTCP_sizeKey_L0+0 
;TPV.c,1522 :: 		}else if(string_cmpnc(TCP_SQL, &getRequest[sizeTotal], sizeKey)){
	GOTO        L_Net_Ethernet_28j60_UserTCP872
L_Net_Ethernet_28j60_UserTCP862:
	MOVLW       _TCP_SQL+0
	MOVWF       FARG_string_cmpnc_text1+0 
	MOVLW       hi_addr(_TCP_SQL+0)
	MOVWF       FARG_string_cmpnc_text1+1 
	MOVLW       higher_addr(_TCP_SQL+0)
	MOVWF       FARG_string_cmpnc_text1+2 
	MOVLW       _getRequest+0
	MOVWF       FARG_string_cmpnc_text2+0 
	MOVLW       hi_addr(_getRequest+0)
	MOVWF       FARG_string_cmpnc_text2+1 
	MOVF        Net_Ethernet_28j60_UserTCP_sizeTotal_L0+0, 0 
	ADDWF       FARG_string_cmpnc_text2+0, 1 
	BTFSC       STATUS+0, 0 
	INCF        FARG_string_cmpnc_text2+1, 1 
	MOVF        Net_Ethernet_28j60_UserTCP_sizeKey_L0+0, 0 
	MOVWF       FARG_string_cmpnc_bytes+0 
	CALL        _string_cmpnc+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_Net_Ethernet_28j60_UserTCP873
;TPV.c,1523 :: 		sizeTotal += sizeKey;
	MOVF        Net_Ethernet_28j60_UserTCP_sizeKey_L0+0, 0 
	ADDWF       Net_Ethernet_28j60_UserTCP_sizeTotal_L0+0, 0 
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       Net_Ethernet_28j60_UserTCP_sizeTotal_L0+0 
;TPV.c,1524 :: 		sizeKey = sizeof(TCP_SQL_WRITE)-1;
	MOVLW       3
	MOVWF       Net_Ethernet_28j60_UserTCP_sizeKey_L0+0 
;TPV.c,1526 :: 		if(string_cmpnc(TCP_SQL_WRITE, &getRequest[sizeTotal], sizeKey)){
	MOVLW       _TCP_SQL_WRITE+0
	MOVWF       FARG_string_cmpnc_text1+0 
	MOVLW       hi_addr(_TCP_SQL_WRITE+0)
	MOVWF       FARG_string_cmpnc_text1+1 
	MOVLW       higher_addr(_TCP_SQL_WRITE+0)
	MOVWF       FARG_string_cmpnc_text1+2 
	MOVLW       _getRequest+0
	MOVWF       FARG_string_cmpnc_text2+0 
	MOVLW       hi_addr(_getRequest+0)
	MOVWF       FARG_string_cmpnc_text2+1 
	MOVF        R0, 0 
	ADDWF       FARG_string_cmpnc_text2+0, 1 
	BTFSC       STATUS+0, 0 
	INCF        FARG_string_cmpnc_text2+1, 1 
	MOVLW       3
	MOVWF       FARG_string_cmpnc_bytes+0 
	CALL        _string_cmpnc+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_Net_Ethernet_28j60_UserTCP874
;TPV.c,1527 :: 		sizeTotal += sizeKey;
	MOVF        Net_Ethernet_28j60_UserTCP_sizeKey_L0+0, 0 
	ADDWF       Net_Ethernet_28j60_UserTCP_sizeTotal_L0+0, 0 
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       Net_Ethernet_28j60_UserTCP_sizeTotal_L0+0 
;TPV.c,1530 :: 		if(getRequest[sizeTotal] == '1'){
	MOVLW       _getRequest+0
	MOVWF       FSR0 
	MOVLW       hi_addr(_getRequest+0)
	MOVWF       FSR0H 
	MOVF        R0, 0 
	ADDWF       FSR0, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR0H, 1 
	MOVF        POSTINC0+0, 0 
	XORLW       49
	BTFSS       STATUS+0, 2 
	GOTO        L_Net_Ethernet_28j60_UserTCP875
;TPV.c,1531 :: 		if(!modoBufferTCP){
	MOVF        _modoBufferTCP+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_Net_Ethernet_28j60_UserTCP876
;TPV.c,1532 :: 		modoBufferTCP = true; //Permite el siguiente envio
	MOVLW       1
	MOVWF       _modoBufferTCP+0 
;TPV.c,1533 :: 		mysql_write_forced(tableEventosTCP, eventosEstatus, pointer, "0", 1);
	MOVLW       _tableEventosTCP+0
	MOVWF       FARG_mysql_write_forced_name+0 
	MOVLW       hi_addr(_tableEventosTCP+0)
	MOVWF       FARG_mysql_write_forced_name+1 
	MOVLW       _eventosEstatus+0
	MOVWF       FARG_mysql_write_forced_column+0 
	MOVLW       hi_addr(_eventosEstatus+0)
	MOVWF       FARG_mysql_write_forced_column+1 
	MOVF        TPV_pointer+0, 0 
	MOVWF       FARG_mysql_write_forced_fila+0 
	MOVF        TPV_pointer+1, 0 
	MOVWF       FARG_mysql_write_forced_fila+1 
	MOVLW       ?lstr37_TPV+0
	MOVWF       FARG_mysql_write_forced_texto+0 
	MOVLW       hi_addr(?lstr37_TPV+0)
	MOVWF       FARG_mysql_write_forced_texto+1 
	MOVLW       1
	MOVWF       FARG_mysql_write_forced_bytes+0 
	CALL        _mysql_write_forced+0, 0
;TPV.c,1534 :: 		pilaBufferTCP = clamp(--pilaBufferTCP, 0, 65535);
	MOVLW       1
	SUBWF       _pilaBufferTCP+0, 1 
	MOVLW       0
	SUBWFB      _pilaBufferTCP+1, 1 
	MOVF        _pilaBufferTCP+0, 0 
	MOVWF       FARG_clamp_valor+0 
	MOVF        _pilaBufferTCP+1, 0 
	MOVWF       FARG_clamp_valor+1 
	MOVLW       0
	BTFSC       _pilaBufferTCP+1, 7 
	MOVLW       255
	MOVWF       FARG_clamp_valor+2 
	MOVWF       FARG_clamp_valor+3 
	CLRF        FARG_clamp_min+0 
	CLRF        FARG_clamp_min+1 
	CLRF        FARG_clamp_min+2 
	CLRF        FARG_clamp_min+3 
	MOVLW       255
	MOVWF       FARG_clamp_max+0 
	MOVLW       255
	MOVWF       FARG_clamp_max+1 
	MOVLW       0
	MOVWF       FARG_clamp_max+2 
	MOVWF       FARG_clamp_max+3 
	CALL        _clamp+0, 0
	MOVF        R0, 0 
	MOVWF       _pilaBufferTCP+0 
	MOVF        R1, 0 
	MOVWF       _pilaBufferTCP+1 
;TPV.c,1535 :: 		inttostr(pilaBufferTCP, msjConst);
	MOVF        R0, 0 
	MOVWF       FARG_IntToStr_input+0 
	MOVF        R1, 0 
	MOVWF       FARG_IntToStr_input+1 
	MOVLW       _msjConst+0
	MOVWF       FARG_IntToStr_output+0 
	MOVLW       hi_addr(_msjConst+0)
	MOVWF       FARG_IntToStr_output+1 
	CALL        _IntToStr+0, 0
;TPV.c,1536 :: 		usart_write_text("Restan: ");
	MOVLW       ?lstr38_TPV+0
	MOVWF       FARG_usart_write_text_texto+0 
	MOVLW       hi_addr(?lstr38_TPV+0)
	MOVWF       FARG_usart_write_text_texto+1 
	CALL        _usart_write_text+0, 0
;TPV.c,1537 :: 		usart_write_line(msjConst);
	MOVLW       _msjConst+0
	MOVWF       FARG_usart_write_line_texto+0 
	MOVLW       hi_addr(_msjConst+0)
	MOVWF       FARG_usart_write_line_texto+1 
	CALL        _usart_write_line+0, 0
;TPV.c,1538 :: 		}else{
	GOTO        L_Net_Ethernet_28j60_UserTCP877
L_Net_Ethernet_28j60_UserTCP876:
;TPV.c,1539 :: 		usart_write_line("No proceso");
	MOVLW       ?lstr39_TPV+0
	MOVWF       FARG_usart_write_line_texto+0 
	MOVLW       hi_addr(?lstr39_TPV+0)
	MOVWF       FARG_usart_write_line_texto+1 
	CALL        _usart_write_line+0, 0
;TPV.c,1540 :: 		}
L_Net_Ethernet_28j60_UserTCP877:
;TPV.c,1541 :: 		}
L_Net_Ethernet_28j60_UserTCP875:
;TPV.c,1542 :: 		}
L_Net_Ethernet_28j60_UserTCP874:
;TPV.c,1543 :: 		}else if(string_cmpnc(TCP_CAN_NODOS, &getRequest[sizeTotal], sizeKey)){
	GOTO        L_Net_Ethernet_28j60_UserTCP878
L_Net_Ethernet_28j60_UserTCP873:
	MOVLW       _TCP_CAN_NODOS+0
	MOVWF       FARG_string_cmpnc_text1+0 
	MOVLW       hi_addr(_TCP_CAN_NODOS+0)
	MOVWF       FARG_string_cmpnc_text1+1 
	MOVLW       higher_addr(_TCP_CAN_NODOS+0)
	MOVWF       FARG_string_cmpnc_text1+2 
	MOVLW       _getRequest+0
	MOVWF       FARG_string_cmpnc_text2+0 
	MOVLW       hi_addr(_getRequest+0)
	MOVWF       FARG_string_cmpnc_text2+1 
	MOVF        Net_Ethernet_28j60_UserTCP_sizeTotal_L0+0, 0 
	ADDWF       FARG_string_cmpnc_text2+0, 1 
	BTFSC       STATUS+0, 0 
	INCF        FARG_string_cmpnc_text2+1, 1 
	MOVF        Net_Ethernet_28j60_UserTCP_sizeKey_L0+0, 0 
	MOVWF       FARG_string_cmpnc_bytes+0 
	CALL        _string_cmpnc+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_Net_Ethernet_28j60_UserTCP879
;TPV.c,1544 :: 		sizeTotal += sizeKey;
	MOVF        Net_Ethernet_28j60_UserTCP_sizeKey_L0+0, 0 
	ADDWF       Net_Ethernet_28j60_UserTCP_sizeTotal_L0+0, 1 
;TPV.c,1545 :: 		sizeKey = sizeof(TCP_CAN_REGISTRAR)-1;
	MOVLW       3
	MOVWF       Net_Ethernet_28j60_UserTCP_sizeKey_L0+0 
;TPV.c,1547 :: 		string_cpyc(respuesta, TCP_CAN_NODOS);
	MOVLW       Net_Ethernet_28j60_UserTCP_respuesta_L0+0
	MOVWF       FARG_string_cpyc_destino+0 
	MOVLW       hi_addr(Net_Ethernet_28j60_UserTCP_respuesta_L0+0)
	MOVWF       FARG_string_cpyc_destino+1 
	MOVLW       _TCP_CAN_NODOS+0
	MOVWF       FARG_string_cpyc_origen+0 
	MOVLW       hi_addr(_TCP_CAN_NODOS+0)
	MOVWF       FARG_string_cpyc_origen+1 
	MOVLW       higher_addr(_TCP_CAN_NODOS+0)
	MOVWF       FARG_string_cpyc_origen+2 
	CALL        _string_cpyc+0, 0
;TPV.c,1549 :: 		if(string_cmpnc(TCP_CAN_REGISTRAR, &getRequest[sizeTotal], sizeKey)){
	MOVLW       _TCP_CAN_REGISTRAR+0
	MOVWF       FARG_string_cmpnc_text1+0 
	MOVLW       hi_addr(_TCP_CAN_REGISTRAR+0)
	MOVWF       FARG_string_cmpnc_text1+1 
	MOVLW       higher_addr(_TCP_CAN_REGISTRAR+0)
	MOVWF       FARG_string_cmpnc_text1+2 
	MOVLW       _getRequest+0
	MOVWF       FARG_string_cmpnc_text2+0 
	MOVLW       hi_addr(_getRequest+0)
	MOVWF       FARG_string_cmpnc_text2+1 
	MOVF        Net_Ethernet_28j60_UserTCP_sizeTotal_L0+0, 0 
	ADDWF       FARG_string_cmpnc_text2+0, 1 
	BTFSC       STATUS+0, 0 
	INCF        FARG_string_cmpnc_text2+1, 1 
	MOVF        Net_Ethernet_28j60_UserTCP_sizeKey_L0+0, 0 
	MOVWF       FARG_string_cmpnc_bytes+0 
	CALL        _string_cmpnc+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_Net_Ethernet_28j60_UserTCP880
;TPV.c,1550 :: 		string_addc(respuesta, TCP_CAN_REGISTRAR);
	MOVLW       Net_Ethernet_28j60_UserTCP_respuesta_L0+0
	MOVWF       FARG_string_addc_destino+0 
	MOVLW       hi_addr(Net_Ethernet_28j60_UserTCP_respuesta_L0+0)
	MOVWF       FARG_string_addc_destino+1 
	MOVLW       _TCP_CAN_REGISTRAR+0
	MOVWF       FARG_string_addc_addEnd+0 
	MOVLW       hi_addr(_TCP_CAN_REGISTRAR+0)
	MOVWF       FARG_string_addc_addEnd+1 
	MOVLW       higher_addr(_TCP_CAN_REGISTRAR+0)
	MOVWF       FARG_string_addc_addEnd+2 
	CALL        _string_addc+0, 0
;TPV.c,1551 :: 		sizeTotal +=sizeKey;
	MOVF        Net_Ethernet_28j60_UserTCP_sizeKey_L0+0, 0 
	ADDWF       Net_Ethernet_28j60_UserTCP_sizeTotal_L0+0, 0 
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       Net_Ethernet_28j60_UserTCP_sizeTotal_L0+0 
;TPV.c,1553 :: 		string_cpyn(msjConst, &getRequest[sizeTotal], 2);
	MOVLW       _msjConst+0
	MOVWF       FARG_string_cpyn_destino+0 
	MOVLW       hi_addr(_msjConst+0)
	MOVWF       FARG_string_cpyn_destino+1 
	MOVLW       _getRequest+0
	MOVWF       FARG_string_cpyn_origen+0 
	MOVLW       hi_addr(_getRequest+0)
	MOVWF       FARG_string_cpyn_origen+1 
	MOVF        R0, 0 
	ADDWF       FARG_string_cpyn_origen+0, 1 
	BTFSC       STATUS+0, 0 
	INCF        FARG_string_cpyn_origen+1, 1 
	MOVLW       2
	MOVWF       FARG_string_cpyn_size+0 
	CALL        _string_cpyn+0, 0
;TPV.c,1554 :: 		idConsulta = clamp(hexToNum(msjConst), 1, MAX_MODULES);
	MOVLW       _msjConst+0
	MOVWF       FARG_hexToNum_hex+0 
	MOVLW       hi_addr(_msjConst+0)
	MOVWF       FARG_hexToNum_hex+1 
	CALL        _hexToNum+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_clamp_valor+0 
	MOVF        R1, 0 
	MOVWF       FARG_clamp_valor+1 
	MOVF        R2, 0 
	MOVWF       FARG_clamp_valor+2 
	MOVF        R3, 0 
	MOVWF       FARG_clamp_valor+3 
	MOVLW       1
	MOVWF       FARG_clamp_min+0 
	MOVLW       0
	MOVWF       FARG_clamp_min+1 
	MOVWF       FARG_clamp_min+2 
	MOVWF       FARG_clamp_min+3 
	MOVLW       20
	MOVWF       FARG_clamp_max+0 
	MOVLW       0
	MOVWF       FARG_clamp_max+1 
	MOVWF       FARG_clamp_max+2 
	MOVWF       FARG_clamp_max+3 
	CALL        _clamp+0, 0
	MOVF        R0, 0 
	MOVWF       Net_Ethernet_28j60_UserTCP_idConsulta_L0+0 
	MOVF        R1, 0 
	MOVWF       Net_Ethernet_28j60_UserTCP_idConsulta_L0+1 
	MOVF        R2, 0 
	MOVWF       Net_Ethernet_28j60_UserTCP_idConsulta_L0+2 
	MOVF        R3, 0 
	MOVWF       Net_Ethernet_28j60_UserTCP_idConsulta_L0+3 
;TPV.c,1556 :: 		if(!mysql_search(tableNodos, nodosName, idConsulta, &fila)){
	MOVLW       _tableNodos+0
	MOVWF       FARG_mysql_search_tabla+0 
	MOVLW       hi_addr(_tableNodos+0)
	MOVWF       FARG_mysql_search_tabla+1 
	MOVLW       _nodosName+0
	MOVWF       FARG_mysql_search_columna+0 
	MOVLW       hi_addr(_nodosName+0)
	MOVWF       FARG_mysql_search_columna+1 
	MOVF        R0, 0 
	MOVWF       FARG_mysql_search_buscar+0 
	MOVF        R1, 0 
	MOVWF       FARG_mysql_search_buscar+1 
	MOVF        R2, 0 
	MOVWF       FARG_mysql_search_buscar+2 
	MOVF        R3, 0 
	MOVWF       FARG_mysql_search_buscar+3 
	MOVLW       Net_Ethernet_28j60_UserTCP_fila_L0+0
	MOVWF       FARG_mysql_search_fila+0 
	MOVLW       hi_addr(Net_Ethernet_28j60_UserTCP_fila_L0+0)
	MOVWF       FARG_mysql_search_fila+1 
	CALL        _mysql_search+0, 0
	MOVF        R0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_Net_Ethernet_28j60_UserTCP881
;TPV.c,1557 :: 		string_addc(respuesta, TCP_TBL_DUPLICADO);
	MOVLW       Net_Ethernet_28j60_UserTCP_respuesta_L0+0
	MOVWF       FARG_string_addc_destino+0 
	MOVLW       hi_addr(Net_Ethernet_28j60_UserTCP_respuesta_L0+0)
	MOVWF       FARG_string_addc_destino+1 
	MOVLW       _TCP_TBL_DUPLICADO+0
	MOVWF       FARG_string_addc_addEnd+0 
	MOVLW       hi_addr(_TCP_TBL_DUPLICADO+0)
	MOVWF       FARG_string_addc_addEnd+1 
	MOVLW       higher_addr(_TCP_TBL_DUPLICADO+0)
	MOVWF       FARG_string_addc_addEnd+2 
	CALL        _string_addc+0, 0
;TPV.c,1558 :: 		}else{
	GOTO        L_Net_Ethernet_28j60_UserTCP882
L_Net_Ethernet_28j60_UserTCP881:
;TPV.c,1559 :: 		result = !mysql_write(tableNodos, nodosName, -1, idConsulta, true);
	MOVLW       _tableNodos+0
	MOVWF       FARG_mysql_write_name+0 
	MOVLW       hi_addr(_tableNodos+0)
	MOVWF       FARG_mysql_write_name+1 
	MOVLW       _nodosName+0
	MOVWF       FARG_mysql_write_column+0 
	MOVLW       hi_addr(_nodosName+0)
	MOVWF       FARG_mysql_write_column+1 
	MOVLW       255
	MOVWF       FARG_mysql_write_fila+0 
	MOVLW       255
	MOVWF       FARG_mysql_write_fila+1 
	MOVF        Net_Ethernet_28j60_UserTCP_idConsulta_L0+0, 0 
	MOVWF       FARG_mysql_write_value+0 
	MOVF        Net_Ethernet_28j60_UserTCP_idConsulta_L0+1, 0 
	MOVWF       FARG_mysql_write_value+1 
	MOVF        Net_Ethernet_28j60_UserTCP_idConsulta_L0+2, 0 
	MOVWF       FARG_mysql_write_value+2 
	MOVF        Net_Ethernet_28j60_UserTCP_idConsulta_L0+3, 0 
	MOVWF       FARG_mysql_write_value+3 
	MOVLW       1
	MOVWF       FARG_mysql_write_endWrite+0 
	CALL        _mysql_write+0, 0
	MOVF        R0, 1 
	MOVLW       1
	BTFSS       STATUS+0, 2 
	MOVLW       0
	MOVWF       R1 
	MOVF        R1, 0 
	MOVWF       Net_Ethernet_28j60_UserTCP_result_L0+0 
;TPV.c,1561 :: 		if(result)
	MOVF        R1, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_Net_Ethernet_28j60_UserTCP883
;TPV.c,1562 :: 		string_addc(respuesta, TCP_TBL_REGISTRADO);
	MOVLW       Net_Ethernet_28j60_UserTCP_respuesta_L0+0
	MOVWF       FARG_string_addc_destino+0 
	MOVLW       hi_addr(Net_Ethernet_28j60_UserTCP_respuesta_L0+0)
	MOVWF       FARG_string_addc_destino+1 
	MOVLW       _TCP_TBL_REGISTRADO+0
	MOVWF       FARG_string_addc_addEnd+0 
	MOVLW       hi_addr(_TCP_TBL_REGISTRADO+0)
	MOVWF       FARG_string_addc_addEnd+1 
	MOVLW       higher_addr(_TCP_TBL_REGISTRADO+0)
	MOVWF       FARG_string_addc_addEnd+2 
	CALL        _string_addc+0, 0
	GOTO        L_Net_Ethernet_28j60_UserTCP884
L_Net_Ethernet_28j60_UserTCP883:
;TPV.c,1564 :: 		string_addc(respuesta, TCP_TBL_LLENA);
	MOVLW       Net_Ethernet_28j60_UserTCP_respuesta_L0+0
	MOVWF       FARG_string_addc_destino+0 
	MOVLW       hi_addr(Net_Ethernet_28j60_UserTCP_respuesta_L0+0)
	MOVWF       FARG_string_addc_destino+1 
	MOVLW       _TCP_TBL_LLENA+0
	MOVWF       FARG_string_addc_addEnd+0 
	MOVLW       hi_addr(_TCP_TBL_LLENA+0)
	MOVWF       FARG_string_addc_addEnd+1 
	MOVLW       higher_addr(_TCP_TBL_LLENA+0)
	MOVWF       FARG_string_addc_addEnd+2 
	CALL        _string_addc+0, 0
L_Net_Ethernet_28j60_UserTCP884:
;TPV.c,1565 :: 		}
L_Net_Ethernet_28j60_UserTCP882:
;TPV.c,1566 :: 		}else if(string_cmpnc(TCP_CAN_CONSULTAR, &getRequest[sizeTotal], sizeKey)){
	GOTO        L_Net_Ethernet_28j60_UserTCP885
L_Net_Ethernet_28j60_UserTCP880:
	MOVLW       _TCP_CAN_CONSULTAR+0
	MOVWF       FARG_string_cmpnc_text1+0 
	MOVLW       hi_addr(_TCP_CAN_CONSULTAR+0)
	MOVWF       FARG_string_cmpnc_text1+1 
	MOVLW       higher_addr(_TCP_CAN_CONSULTAR+0)
	MOVWF       FARG_string_cmpnc_text1+2 
	MOVLW       _getRequest+0
	MOVWF       FARG_string_cmpnc_text2+0 
	MOVLW       hi_addr(_getRequest+0)
	MOVWF       FARG_string_cmpnc_text2+1 
	MOVF        Net_Ethernet_28j60_UserTCP_sizeTotal_L0+0, 0 
	ADDWF       FARG_string_cmpnc_text2+0, 1 
	BTFSC       STATUS+0, 0 
	INCF        FARG_string_cmpnc_text2+1, 1 
	MOVF        Net_Ethernet_28j60_UserTCP_sizeKey_L0+0, 0 
	MOVWF       FARG_string_cmpnc_bytes+0 
	CALL        _string_cmpnc+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_Net_Ethernet_28j60_UserTCP886
;TPV.c,1567 :: 		string_addc(respuesta, TCP_CAN_CONSULTAR);
	MOVLW       Net_Ethernet_28j60_UserTCP_respuesta_L0+0
	MOVWF       FARG_string_addc_destino+0 
	MOVLW       hi_addr(Net_Ethernet_28j60_UserTCP_respuesta_L0+0)
	MOVWF       FARG_string_addc_destino+1 
	MOVLW       _TCP_CAN_CONSULTAR+0
	MOVWF       FARG_string_addc_addEnd+0 
	MOVLW       hi_addr(_TCP_CAN_CONSULTAR+0)
	MOVWF       FARG_string_addc_addEnd+1 
	MOVLW       higher_addr(_TCP_CAN_CONSULTAR+0)
	MOVWF       FARG_string_addc_addEnd+2 
	CALL        _string_addc+0, 0
;TPV.c,1569 :: 		sizeTotal +=sizeKey;
	MOVF        Net_Ethernet_28j60_UserTCP_sizeKey_L0+0, 0 
	ADDWF       Net_Ethernet_28j60_UserTCP_sizeTotal_L0+0, 1 
;TPV.c,1571 :: 		if(mysql_exist(tableNodos)){
	MOVLW       _tableNodos+0
	MOVWF       FARG_mysql_exist_name+0 
	MOVLW       hi_addr(_tableNodos+0)
	MOVWF       FARG_mysql_exist_name+1 
	CALL        _mysql_exist+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_Net_Ethernet_28j60_UserTCP887
;TPV.c,1572 :: 		for(cont = 1; cont <= myTable.rowAct && cont <= MAX_MODULES; cont++){
	MOVLW       1
	MOVWF       Net_Ethernet_28j60_UserTCP_cont_L0+0 
	MOVLW       0
	MOVWF       Net_Ethernet_28j60_UserTCP_cont_L0+1 
L_Net_Ethernet_28j60_UserTCP888:
	MOVF        Net_Ethernet_28j60_UserTCP_cont_L0+1, 0 
	SUBWF       TPV_myTable+5, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__Net_Ethernet_28j60_UserTCP1392
	MOVF        Net_Ethernet_28j60_UserTCP_cont_L0+0, 0 
	SUBWF       TPV_myTable+4, 0 
L__Net_Ethernet_28j60_UserTCP1392:
	BTFSS       STATUS+0, 0 
	GOTO        L_Net_Ethernet_28j60_UserTCP889
	MOVLW       0
	MOVWF       R0 
	MOVF        Net_Ethernet_28j60_UserTCP_cont_L0+1, 0 
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__Net_Ethernet_28j60_UserTCP1393
	MOVF        Net_Ethernet_28j60_UserTCP_cont_L0+0, 0 
	SUBLW       20
L__Net_Ethernet_28j60_UserTCP1393:
	BTFSS       STATUS+0, 0 
	GOTO        L_Net_Ethernet_28j60_UserTCP889
L__Net_Ethernet_28j60_UserTCP1014:
;TPV.c,1573 :: 		mysql_read(tableNodos, nodosName, cont, &idConsulta);
	MOVLW       _tableNodos+0
	MOVWF       FARG_mysql_read_name+0 
	MOVLW       hi_addr(_tableNodos+0)
	MOVWF       FARG_mysql_read_name+1 
	MOVLW       _nodosName+0
	MOVWF       FARG_mysql_read_column+0 
	MOVLW       hi_addr(_nodosName+0)
	MOVWF       FARG_mysql_read_column+1 
	MOVF        Net_Ethernet_28j60_UserTCP_cont_L0+0, 0 
	MOVWF       FARG_mysql_read_fila+0 
	MOVF        Net_Ethernet_28j60_UserTCP_cont_L0+1, 0 
	MOVWF       FARG_mysql_read_fila+1 
	MOVLW       Net_Ethernet_28j60_UserTCP_idConsulta_L0+0
	MOVWF       FARG_mysql_read_result+0 
	MOVLW       hi_addr(Net_Ethernet_28j60_UserTCP_idConsulta_L0+0)
	MOVWF       FARG_mysql_read_result+1 
	CALL        _mysql_read+0, 0
;TPV.c,1574 :: 		numToHex(idConsulta, msjConst, 1);
	MOVF        Net_Ethernet_28j60_UserTCP_idConsulta_L0+0, 0 
	MOVWF       FARG_numToHex_valor+0 
	MOVF        Net_Ethernet_28j60_UserTCP_idConsulta_L0+1, 0 
	MOVWF       FARG_numToHex_valor+1 
	MOVF        Net_Ethernet_28j60_UserTCP_idConsulta_L0+2, 0 
	MOVWF       FARG_numToHex_valor+2 
	MOVF        Net_Ethernet_28j60_UserTCP_idConsulta_L0+3, 0 
	MOVWF       FARG_numToHex_valor+3 
	MOVLW       _msjConst+0
	MOVWF       FARG_numToHex_cadena+0 
	MOVLW       hi_addr(_msjConst+0)
	MOVWF       FARG_numToHex_cadena+1 
	MOVLW       1
	MOVWF       FARG_numToHex_bytes+0 
	CALL        _numToHex+0, 0
;TPV.c,1575 :: 		string_add(respuesta, msjConst);
	MOVLW       Net_Ethernet_28j60_UserTCP_respuesta_L0+0
	MOVWF       FARG_string_add_destino+0 
	MOVLW       hi_addr(Net_Ethernet_28j60_UserTCP_respuesta_L0+0)
	MOVWF       FARG_string_add_destino+1 
	MOVLW       _msjConst+0
	MOVWF       FARG_string_add_addEnd+0 
	MOVLW       hi_addr(_msjConst+0)
	MOVWF       FARG_string_add_addEnd+1 
	CALL        _string_add+0, 0
;TPV.c,1572 :: 		for(cont = 1; cont <= myTable.rowAct && cont <= MAX_MODULES; cont++){
	INFSNZ      Net_Ethernet_28j60_UserTCP_cont_L0+0, 1 
	INCF        Net_Ethernet_28j60_UserTCP_cont_L0+1, 1 
;TPV.c,1576 :: 		}
	GOTO        L_Net_Ethernet_28j60_UserTCP888
L_Net_Ethernet_28j60_UserTCP889:
;TPV.c,1577 :: 		}else{
	GOTO        L_Net_Ethernet_28j60_UserTCP893
L_Net_Ethernet_28j60_UserTCP887:
;TPV.c,1578 :: 		string_addc(respuesta, TCP_TBL_NO_FOUND);
	MOVLW       Net_Ethernet_28j60_UserTCP_respuesta_L0+0
	MOVWF       FARG_string_addc_destino+0 
	MOVLW       hi_addr(Net_Ethernet_28j60_UserTCP_respuesta_L0+0)
	MOVWF       FARG_string_addc_destino+1 
	MOVLW       _TCP_TBL_NO_FOUND+0
	MOVWF       FARG_string_addc_addEnd+0 
	MOVLW       hi_addr(_TCP_TBL_NO_FOUND+0)
	MOVWF       FARG_string_addc_addEnd+1 
	MOVLW       higher_addr(_TCP_TBL_NO_FOUND+0)
	MOVWF       FARG_string_addc_addEnd+2 
	CALL        _string_addc+0, 0
;TPV.c,1579 :: 		}
L_Net_Ethernet_28j60_UserTCP893:
;TPV.c,1580 :: 		}
L_Net_Ethernet_28j60_UserTCP886:
L_Net_Ethernet_28j60_UserTCP885:
;TPV.c,1582 :: 		string_addc(respuesta, TCP_CAN_MODULE);
	MOVLW       Net_Ethernet_28j60_UserTCP_respuesta_L0+0
	MOVWF       FARG_string_addc_destino+0 
	MOVLW       hi_addr(Net_Ethernet_28j60_UserTCP_respuesta_L0+0)
	MOVWF       FARG_string_addc_destino+1 
	MOVLW       _TCP_CAN_MODULE+0
	MOVWF       FARG_string_addc_addEnd+0 
	MOVLW       hi_addr(_TCP_CAN_MODULE+0)
	MOVWF       FARG_string_addc_addEnd+1 
	MOVLW       higher_addr(_TCP_CAN_MODULE+0)
	MOVWF       FARG_string_addc_addEnd+2 
	CALL        _string_addc+0, 0
;TPV.c,1583 :: 		numToHex(can.id, msjConst, 1);
	MOVF        _can+12, 0 
	MOVWF       FARG_numToHex_valor+0 
	MOVLW       0
	MOVWF       FARG_numToHex_valor+1 
	MOVWF       FARG_numToHex_valor+2 
	MOVWF       FARG_numToHex_valor+3 
	MOVLW       _msjConst+0
	MOVWF       FARG_numToHex_cadena+0 
	MOVLW       hi_addr(_msjConst+0)
	MOVWF       FARG_numToHex_cadena+1 
	MOVLW       1
	MOVWF       FARG_numToHex_bytes+0 
	CALL        _numToHex+0, 0
;TPV.c,1584 :: 		string_add(respuesta, msjConst);
	MOVLW       Net_Ethernet_28j60_UserTCP_respuesta_L0+0
	MOVWF       FARG_string_add_destino+0 
	MOVLW       hi_addr(Net_Ethernet_28j60_UserTCP_respuesta_L0+0)
	MOVWF       FARG_string_add_destino+1 
	MOVLW       _msjConst+0
	MOVWF       FARG_string_add_addEnd+0 
	MOVLW       hi_addr(_msjConst+0)
	MOVWF       FARG_string_add_addEnd+1 
	CALL        _string_add+0, 0
;TPV.c,1585 :: 		}else if(string_cmpnc(TCP_CAN_RESET, &getRequest[sizeTotal], sizeKey)){
	GOTO        L_Net_Ethernet_28j60_UserTCP894
L_Net_Ethernet_28j60_UserTCP879:
	MOVLW       _TCP_CAN_RESET+0
	MOVWF       FARG_string_cmpnc_text1+0 
	MOVLW       hi_addr(_TCP_CAN_RESET+0)
	MOVWF       FARG_string_cmpnc_text1+1 
	MOVLW       higher_addr(_TCP_CAN_RESET+0)
	MOVWF       FARG_string_cmpnc_text1+2 
	MOVLW       _getRequest+0
	MOVWF       FARG_string_cmpnc_text2+0 
	MOVLW       hi_addr(_getRequest+0)
	MOVWF       FARG_string_cmpnc_text2+1 
	MOVF        Net_Ethernet_28j60_UserTCP_sizeTotal_L0+0, 0 
	ADDWF       FARG_string_cmpnc_text2+0, 1 
	BTFSC       STATUS+0, 0 
	INCF        FARG_string_cmpnc_text2+1, 1 
	MOVF        Net_Ethernet_28j60_UserTCP_sizeKey_L0+0, 0 
	MOVWF       FARG_string_cmpnc_bytes+0 
	CALL        _string_cmpnc+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_Net_Ethernet_28j60_UserTCP895
;TPV.c,1586 :: 		asm reset;
	RESET
;TPV.c,1587 :: 		}
L_Net_Ethernet_28j60_UserTCP895:
L_Net_Ethernet_28j60_UserTCP894:
L_Net_Ethernet_28j60_UserTCP878:
L_Net_Ethernet_28j60_UserTCP872:
L_Net_Ethernet_28j60_UserTCP861:
L_Net_Ethernet_28j60_UserTCP839:
L_Net_Ethernet_28j60_UserTCP821:
L_Net_Ethernet_28j60_UserTCP774:
L_Net_Ethernet_28j60_UserTCP741:
L_Net_Ethernet_28j60_UserTCP732:
L_Net_Ethernet_28j60_UserTCP727:
;TPV.c,1590 :: 		if(responderACK){
	MOVF        Net_Ethernet_28j60_UserTCP_responderACK_L0+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_Net_Ethernet_28j60_UserTCP896
;TPV.c,1591 :: 		responderACK = false;
	CLRF        Net_Ethernet_28j60_UserTCP_responderACK_L0+0 
;TPV.c,1592 :: 		cont = 0;
	CLRF        Net_Ethernet_28j60_UserTCP_cont_L0+0 
	CLRF        Net_Ethernet_28j60_UserTCP_cont_L0+1 
;TPV.c,1593 :: 		while(msjSQLACK[cont])
L_Net_Ethernet_28j60_UserTCP897:
	MOVLW       Net_Ethernet_28j60_UserTCP_msjSQLACK_L0+0
	ADDWF       Net_Ethernet_28j60_UserTCP_cont_L0+0, 0 
	MOVWF       TBLPTRL 
	MOVLW       hi_addr(Net_Ethernet_28j60_UserTCP_msjSQLACK_L0+0)
	ADDWFC      Net_Ethernet_28j60_UserTCP_cont_L0+1, 0 
	MOVWF       TBLPTRH 
	MOVLW       higher_addr(Net_Ethernet_28j60_UserTCP_msjSQLACK_L0+0)
	MOVWF       TBLPTRU 
	MOVLW       0
	ADDWFC      TBLPTRU, 1 
	TBLRD*+
	MOVFF       TABLAT+0, R0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_Net_Ethernet_28j60_UserTCP898
;TPV.c,1594 :: 		Net_Ethernet_28j60_putByteTCP(msjSQLACK[cont++],socket_28j60);
	MOVLW       Net_Ethernet_28j60_UserTCP_msjSQLACK_L0+0
	ADDWF       Net_Ethernet_28j60_UserTCP_cont_L0+0, 0 
	MOVWF       TBLPTRL 
	MOVLW       hi_addr(Net_Ethernet_28j60_UserTCP_msjSQLACK_L0+0)
	ADDWFC      Net_Ethernet_28j60_UserTCP_cont_L0+1, 0 
	MOVWF       TBLPTRH 
	MOVLW       higher_addr(Net_Ethernet_28j60_UserTCP_msjSQLACK_L0+0)
	MOVWF       TBLPTRU 
	MOVLW       0
	ADDWFC      TBLPTRU, 1 
	TBLRD*+
	MOVFF       TABLAT+0, FARG_Net_Ethernet_28j60_putByteTCP_ch+0
	MOVLW       _socket_28j60+0
	MOVWF       FARG_Net_Ethernet_28j60_putByteTCP_socket_28j60+0 
	MOVLW       hi_addr(_socket_28j60+0)
	MOVWF       FARG_Net_Ethernet_28j60_putByteTCP_socket_28j60+1 
	CALL        _Net_Ethernet_28j60_putByteTCP+0, 0
	INFSNZ      Net_Ethernet_28j60_UserTCP_cont_L0+0, 1 
	INCF        Net_Ethernet_28j60_UserTCP_cont_L0+1, 1 
	GOTO        L_Net_Ethernet_28j60_UserTCP897
L_Net_Ethernet_28j60_UserTCP898:
;TPV.c,1595 :: 		}
L_Net_Ethernet_28j60_UserTCP896:
;TPV.c,1598 :: 		Net_Ethernet_28j60_putByteTCP('<',socket_28j60);
	MOVLW       60
	MOVWF       FARG_Net_Ethernet_28j60_putByteTCP_ch+0 
	MOVLW       _socket_28j60+0
	MOVWF       FARG_Net_Ethernet_28j60_putByteTCP_socket_28j60+0 
	MOVLW       hi_addr(_socket_28j60+0)
	MOVWF       FARG_Net_Ethernet_28j60_putByteTCP_socket_28j60+1 
	CALL        _Net_Ethernet_28j60_putByteTCP+0, 0
;TPV.c,1599 :: 		cont = 0;
	CLRF        Net_Ethernet_28j60_UserTCP_cont_L0+0 
	CLRF        Net_Ethernet_28j60_UserTCP_cont_L0+1 
;TPV.c,1600 :: 		while(respuesta[cont])
L_Net_Ethernet_28j60_UserTCP899:
	MOVLW       Net_Ethernet_28j60_UserTCP_respuesta_L0+0
	ADDWF       Net_Ethernet_28j60_UserTCP_cont_L0+0, 0 
	MOVWF       FSR0 
	MOVLW       hi_addr(Net_Ethernet_28j60_UserTCP_respuesta_L0+0)
	ADDWFC      Net_Ethernet_28j60_UserTCP_cont_L0+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_Net_Ethernet_28j60_UserTCP900
;TPV.c,1601 :: 		Net_Ethernet_28j60_putByteTCP(respuesta[cont++],socket_28j60);
	MOVLW       Net_Ethernet_28j60_UserTCP_respuesta_L0+0
	ADDWF       Net_Ethernet_28j60_UserTCP_cont_L0+0, 0 
	MOVWF       FSR0 
	MOVLW       hi_addr(Net_Ethernet_28j60_UserTCP_respuesta_L0+0)
	ADDWFC      Net_Ethernet_28j60_UserTCP_cont_L0+1, 0 
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
	GOTO        L_Net_Ethernet_28j60_UserTCP899
L_Net_Ethernet_28j60_UserTCP900:
;TPV.c,1602 :: 		Net_Ethernet_28j60_putByteTCP('>',socket_28j60);
	MOVLW       62
	MOVWF       FARG_Net_Ethernet_28j60_putByteTCP_ch+0 
	MOVLW       _socket_28j60+0
	MOVWF       FARG_Net_Ethernet_28j60_putByteTCP_socket_28j60+0 
	MOVLW       hi_addr(_socket_28j60+0)
	MOVWF       FARG_Net_Ethernet_28j60_putByteTCP_socket_28j60+1 
	CALL        _Net_Ethernet_28j60_putByteTCP+0, 0
;TPV.c,1603 :: 		}//PROCESA EL PUERTO DESTINO
L_Net_Ethernet_28j60_UserTCP672:
;TPV.c,1604 :: 		}else{ //Se transmite datos hacia la app
	GOTO        L_Net_Ethernet_28j60_UserTCP901
L_Net_Ethernet_28j60_UserTCP668:
;TPV.c,1605 :: 		cont = 0;
	CLRF        Net_Ethernet_28j60_UserTCP_cont_L0+0 
	CLRF        Net_Ethernet_28j60_UserTCP_cont_L0+1 
;TPV.c,1606 :: 		Net_Ethernet_28j60_putByteTCP('<',socket_28j60);
	MOVLW       60
	MOVWF       FARG_Net_Ethernet_28j60_putByteTCP_ch+0 
	MOVLW       _socket_28j60+0
	MOVWF       FARG_Net_Ethernet_28j60_putByteTCP_socket_28j60+0 
	MOVLW       hi_addr(_socket_28j60+0)
	MOVWF       FARG_Net_Ethernet_28j60_putByteTCP_socket_28j60+1 
	CALL        _Net_Ethernet_28j60_putByteTCP+0, 0
;TPV.c,1607 :: 		while(punteroTCP[cont])
L_Net_Ethernet_28j60_UserTCP902:
	MOVF        Net_Ethernet_28j60_UserTCP_cont_L0+0, 0 
	ADDWF       _punteroTCP+0, 0 
	MOVWF       FSR0 
	MOVF        Net_Ethernet_28j60_UserTCP_cont_L0+1, 0 
	ADDWFC      _punteroTCP+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_Net_Ethernet_28j60_UserTCP903
;TPV.c,1608 :: 		Net_Ethernet_28j60_putByteTCP(punteroTCP[cont++],socket_28j60);
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
	GOTO        L_Net_Ethernet_28j60_UserTCP902
L_Net_Ethernet_28j60_UserTCP903:
;TPV.c,1609 :: 		Net_Ethernet_28j60_putByteTCP('>',socket_28j60);
	MOVLW       62
	MOVWF       FARG_Net_Ethernet_28j60_putByteTCP_ch+0 
	MOVLW       _socket_28j60+0
	MOVWF       FARG_Net_Ethernet_28j60_putByteTCP_socket_28j60+0 
	MOVLW       hi_addr(_socket_28j60+0)
	MOVWF       FARG_Net_Ethernet_28j60_putByteTCP_socket_28j60+1 
	CALL        _Net_Ethernet_28j60_putByteTCP+0, 0
;TPV.c,1610 :: 		sendDataTCP.B0 = false;  //Resetear bandera
	BCF         _sendDataTCP+0, 0 
;TPV.c,1611 :: 		}
L_Net_Ethernet_28j60_UserTCP901:
;TPV.c,1613 :: 		}
L_end_Net_Ethernet_28j60_UserTCP:
	RETURN      0
; end of _Net_Ethernet_28j60_UserTCP

_Net_Ethernet_28j60_UserUDP:

;TPV.c,1615 :: 		unsigned int Net_Ethernet_28j60_UserUDP(SOCKET_28j60_Dsc *socket){
;TPV.c,1616 :: 		return 0;
	CLRF        R0 
	CLRF        R1 
;TPV.c,1617 :: 		}
L_end_Net_Ethernet_28j60_UserUDP:
	RETURN      0
; end of _Net_Ethernet_28j60_UserUDP

_usart_user_read_text:

;TPV.c,1619 :: 		void usart_user_read_text(){
;TPV.c,1620 :: 		if(!usart.rx_overflow){
	MOVF        _usart+34, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_usart_user_read_text904
;TPV.c,1621 :: 		usart_write_text("Se recibio: ");
	MOVLW       ?lstr40_TPV+0
	MOVWF       FARG_usart_write_text_texto+0 
	MOVLW       hi_addr(?lstr40_TPV+0)
	MOVWF       FARG_usart_write_text_texto+1 
	CALL        _usart_write_text+0, 0
;TPV.c,1622 :: 		usart_write_text(usart.message);
	MOVLW       _usart+0
	MOVWF       FARG_usart_write_text_texto+0 
	MOVLW       hi_addr(_usart+0)
	MOVWF       FARG_usart_write_text_texto+1 
	CALL        _usart_write_text+0, 0
;TPV.c,1623 :: 		usart_write_text("\r\n");
	MOVLW       ?lstr41_TPV+0
	MOVWF       FARG_usart_write_text_texto+0 
	MOVLW       hi_addr(?lstr41_TPV+0)
	MOVWF       FARG_usart_write_text_texto+1 
	CALL        _usart_write_text+0, 0
;TPV.c,1625 :: 		}else{
	GOTO        L_usart_user_read_text905
L_usart_user_read_text904:
;TPV.c,1626 :: 		usart.rx_overflow = 0;
	CLRF        _usart+34 
;TPV.c,1627 :: 		usart_write_text("Dato dañado overflow\r\n");
	MOVLW       ?lstr42_TPV+0
	MOVWF       FARG_usart_write_text_texto+0 
	MOVLW       hi_addr(?lstr42_TPV+0)
	MOVWF       FARG_usart_write_text_texto+1 
	CALL        _usart_write_text+0, 0
;TPV.c,1628 :: 		}
L_usart_user_read_text905:
;TPV.c,1629 :: 		}
L_end_usart_user_read_text:
	RETURN      0
; end of _usart_user_read_text

_can_user_read_message:

;TPV.c,1631 :: 		void can_user_read_message(){
;TPV.c,1639 :: 		usart_write_text("Se recibio data por can: ");
	MOVLW       ?lstr43_TPV+0
	MOVWF       FARG_usart_write_text_texto+0 
	MOVLW       hi_addr(?lstr43_TPV+0)
	MOVWF       FARG_usart_write_text_texto+1 
	CALL        _usart_write_text+0, 0
;TPV.c,1640 :: 		usart_write_line(can.rxBuffer);
	MOVLW       _can+107
	MOVWF       FARG_usart_write_line_texto+0 
	MOVLW       hi_addr(_can+107)
	MOVWF       FARG_usart_write_line_texto+1 
	CALL        _usart_write_line+0, 0
;TPV.c,1643 :: 		sizeTotal = 0;
	CLRF        can_user_read_message_sizeTotal_L0+0 
;TPV.c,1644 :: 		sizeKey = sizeof(TCP_CAN_TPV)-1;
	MOVLW       3
	MOVWF       can_user_read_message_sizeKey_L0+0 
;TPV.c,1645 :: 		if(string_cmpnc(TCP_CAN_TPV, &can.rxBuffer[sizeTotal], sizeKey)){
	MOVLW       _TCP_CAN_TPV+0
	MOVWF       FARG_string_cmpnc_text1+0 
	MOVLW       hi_addr(_TCP_CAN_TPV+0)
	MOVWF       FARG_string_cmpnc_text1+1 
	MOVLW       higher_addr(_TCP_CAN_TPV+0)
	MOVWF       FARG_string_cmpnc_text1+2 
	MOVLW       _can+107
	MOVWF       FARG_string_cmpnc_text2+0 
	MOVLW       hi_addr(_can+107)
	MOVWF       FARG_string_cmpnc_text2+1 
	MOVF        can_user_read_message_sizeTotal_L0+0, 0 
	ADDWF       FARG_string_cmpnc_text2+0, 1 
	BTFSC       STATUS+0, 0 
	INCF        FARG_string_cmpnc_text2+1, 1 
	MOVLW       3
	MOVWF       FARG_string_cmpnc_bytes+0 
	CALL        _string_cmpnc+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_can_user_read_message906
;TPV.c,1646 :: 		sizeTotal += sizeKey;
	MOVF        can_user_read_message_sizeKey_L0+0, 0 
	ADDWF       can_user_read_message_sizeTotal_L0+0, 1 
;TPV.c,1647 :: 		usart_write_line("Evento TPV a ser guardado");
	MOVLW       ?lstr44_TPV+0
	MOVWF       FARG_usart_write_line_texto+0 
	MOVLW       hi_addr(?lstr44_TPV+0)
	MOVWF       FARG_usart_write_line_texto+1 
	CALL        _usart_write_line+0, 0
;TPV.c,1648 :: 		buffer_save_send(true, &can.rxBuffer[sizeTotal], tarjetas.canIdMod);
	MOVLW       1
	MOVWF       FARG_buffer_save_send_tcpORcan+0 
	MOVLW       _can+107
	MOVWF       FARG_buffer_save_send_buffer+0 
	MOVLW       hi_addr(_can+107)
	MOVWF       FARG_buffer_save_send_buffer+1 
	MOVF        can_user_read_message_sizeTotal_L0+0, 0 
	ADDWF       FARG_buffer_save_send_buffer+0, 1 
	BTFSC       STATUS+0, 0 
	INCF        FARG_buffer_save_send_buffer+1, 1 
	MOVLW       _tarjetas+42
	MOVWF       FARG_buffer_save_send_nodosCAN+0 
	MOVLW       hi_addr(_tarjetas+42)
	MOVWF       FARG_buffer_save_send_nodosCAN+1 
	CALL        _buffer_save_send+0, 0
;TPV.c,1649 :: 		}else if(string_cmpnc(TCP_CAN_PENSIONADO, &can.rxBuffer[sizeTotal], sizeKey)){
	GOTO        L_can_user_read_message907
L_can_user_read_message906:
	MOVLW       _TCP_CAN_PENSIONADO+0
	MOVWF       FARG_string_cmpnc_text1+0 
	MOVLW       hi_addr(_TCP_CAN_PENSIONADO+0)
	MOVWF       FARG_string_cmpnc_text1+1 
	MOVLW       higher_addr(_TCP_CAN_PENSIONADO+0)
	MOVWF       FARG_string_cmpnc_text1+2 
	MOVLW       _can+107
	MOVWF       FARG_string_cmpnc_text2+0 
	MOVLW       hi_addr(_can+107)
	MOVWF       FARG_string_cmpnc_text2+1 
	MOVF        can_user_read_message_sizeTotal_L0+0, 0 
	ADDWF       FARG_string_cmpnc_text2+0, 1 
	BTFSC       STATUS+0, 0 
	INCF        FARG_string_cmpnc_text2+1, 1 
	MOVF        can_user_read_message_sizeKey_L0+0, 0 
	MOVWF       FARG_string_cmpnc_bytes+0 
	CALL        _string_cmpnc+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_can_user_read_message908
;TPV.c,1651 :: 		sizeTotal += sizeKey;
	MOVF        can_user_read_message_sizeKey_L0+0, 0 
	ADDWF       can_user_read_message_sizeTotal_L0+0, 0 
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       can_user_read_message_sizeTotal_L0+0 
;TPV.c,1652 :: 		sizeKey = 6;
	MOVLW       6
	MOVWF       can_user_read_message_sizeKey_L0+0 
;TPV.c,1653 :: 		string_cpyn(msjConst, &can.rxBuffer[sizeTotal], sizeKey);
	MOVLW       _msjConst+0
	MOVWF       FARG_string_cpyn_destino+0 
	MOVLW       hi_addr(_msjConst+0)
	MOVWF       FARG_string_cpyn_destino+1 
	MOVLW       _can+107
	MOVWF       FARG_string_cpyn_origen+0 
	MOVLW       hi_addr(_can+107)
	MOVWF       FARG_string_cpyn_origen+1 
	MOVF        R0, 0 
	ADDWF       FARG_string_cpyn_origen+0, 1 
	BTFSC       STATUS+0, 0 
	INCF        FARG_string_cpyn_origen+1, 1 
	MOVLW       6
	MOVWF       FARG_string_cpyn_size+0 
	CALL        _string_cpyn+0, 0
;TPV.c,1654 :: 		idConsulta = hexToNum(msjConst);
	MOVLW       _msjConst+0
	MOVWF       FARG_hexToNum_hex+0 
	MOVLW       hi_addr(_msjConst+0)
	MOVWF       FARG_hexToNum_hex+1 
	CALL        _hexToNum+0, 0
	MOVF        R0, 0 
	MOVWF       can_user_read_message_idConsulta_L0+0 
	MOVF        R1, 0 
	MOVWF       can_user_read_message_idConsulta_L0+1 
	MOVF        R2, 0 
	MOVWF       can_user_read_message_idConsulta_L0+2 
	MOVF        R3, 0 
	MOVWF       can_user_read_message_idConsulta_L0+3 
;TPV.c,1656 :: 		sizeTotal += sizeKey;
	MOVF        can_user_read_message_sizeKey_L0+0, 0 
	ADDWF       can_user_read_message_sizeTotal_L0+0, 0 
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       can_user_read_message_sizeTotal_L0+0 
;TPV.c,1657 :: 		sizeKey = sizeof(TCP_CAN_PASSBACK)-1;
	MOVLW       3
	MOVWF       can_user_read_message_sizeKey_L0+0 
;TPV.c,1658 :: 		if(string_cmpnc(TCP_CAN_PASSBACK, &can.rxBuffer[sizeTotal], sizeKey)){
	MOVLW       _TCP_CAN_PASSBACK+0
	MOVWF       FARG_string_cmpnc_text1+0 
	MOVLW       hi_addr(_TCP_CAN_PASSBACK+0)
	MOVWF       FARG_string_cmpnc_text1+1 
	MOVLW       higher_addr(_TCP_CAN_PASSBACK+0)
	MOVWF       FARG_string_cmpnc_text1+2 
	MOVLW       _can+107
	MOVWF       FARG_string_cmpnc_text2+0 
	MOVLW       hi_addr(_can+107)
	MOVWF       FARG_string_cmpnc_text2+1 
	MOVF        R0, 0 
	ADDWF       FARG_string_cmpnc_text2+0, 1 
	BTFSC       STATUS+0, 0 
	INCF        FARG_string_cmpnc_text2+1, 1 
	MOVLW       3
	MOVWF       FARG_string_cmpnc_bytes+0 
	CALL        _string_cmpnc+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_can_user_read_message909
;TPV.c,1660 :: 		sizeTotal += sizeKey;
	MOVF        can_user_read_message_sizeKey_L0+0, 0 
	ADDWF       can_user_read_message_sizeTotal_L0+0, 0 
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       can_user_read_message_sizeTotal_L0+0 
;TPV.c,1661 :: 		sizeKey = 4;
	MOVLW       4
	MOVWF       can_user_read_message_sizeKey_L0+0 
;TPV.c,1662 :: 		string_cpyn(msjConst, &can.rxBuffer[sizeTotal], sizeKey);
	MOVLW       _msjConst+0
	MOVWF       FARG_string_cpyn_destino+0 
	MOVLW       hi_addr(_msjConst+0)
	MOVWF       FARG_string_cpyn_destino+1 
	MOVLW       _can+107
	MOVWF       FARG_string_cpyn_origen+0 
	MOVLW       hi_addr(_can+107)
	MOVWF       FARG_string_cpyn_origen+1 
	MOVF        R0, 0 
	ADDWF       FARG_string_cpyn_origen+0, 1 
	BTFSC       STATUS+0, 0 
	INCF        FARG_string_cpyn_origen+1, 1 
	MOVLW       4
	MOVWF       FARG_string_cpyn_size+0 
	CALL        _string_cpyn+0, 0
;TPV.c,1663 :: 		fila = stringToNum(msjConst);
	MOVLW       _msjConst+0
	MOVWF       FARG_stringToNum_cadena+0 
	MOVLW       hi_addr(_msjConst+0)
	MOVWF       FARG_stringToNum_cadena+1 
	CALL        _stringToNum+0, 0
	MOVF        R0, 0 
	MOVWF       can_user_read_message_fila_L0+0 
	MOVF        R1, 0 
	MOVWF       can_user_read_message_fila_L0+1 
;TPV.c,1665 :: 		sizeTotal += sizeKey;
	MOVF        can_user_read_message_sizeKey_L0+0, 0 
	ADDWF       can_user_read_message_sizeTotal_L0+0, 0 
	MOVWF       R4 
	MOVF        R4, 0 
	MOVWF       can_user_read_message_sizeTotal_L0+0 
;TPV.c,1666 :: 		sizeKey = 1;
	MOVLW       1
	MOVWF       can_user_read_message_sizeKey_L0+0 
;TPV.c,1667 :: 		estatus = can.rxBuffer[sizeTotal];
	MOVLW       _can+107
	MOVWF       FSR0 
	MOVLW       hi_addr(_can+107)
	MOVWF       FSR0H 
	MOVF        R4, 0 
	ADDWF       FSR0, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR0H, 1 
	MOVF        POSTINC0+0, 0 
	MOVWF       can_user_read_message_estatus_L0+0 
;TPV.c,1669 :: 		if(!mysql_read(tablePensionados, pensionadosID, fila, &id)){
	MOVLW       _tablePensionados+0
	MOVWF       FARG_mysql_read_name+0 
	MOVLW       hi_addr(_tablePensionados+0)
	MOVWF       FARG_mysql_read_name+1 
	MOVLW       _pensionadosID+0
	MOVWF       FARG_mysql_read_column+0 
	MOVLW       hi_addr(_pensionadosID+0)
	MOVWF       FARG_mysql_read_column+1 
	MOVF        R0, 0 
	MOVWF       FARG_mysql_read_fila+0 
	MOVF        R1, 0 
	MOVWF       FARG_mysql_read_fila+1 
	MOVLW       can_user_read_message_id_L0+0
	MOVWF       FARG_mysql_read_result+0 
	MOVLW       hi_addr(can_user_read_message_id_L0+0)
	MOVWF       FARG_mysql_read_result+1 
	CALL        _mysql_read+0, 0
	MOVF        R0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_can_user_read_message910
;TPV.c,1670 :: 		if(id == idConsulta){
	MOVF        can_user_read_message_id_L0+3, 0 
	XORWF       can_user_read_message_idConsulta_L0+3, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__can_user_read_message1397
	MOVF        can_user_read_message_id_L0+2, 0 
	XORWF       can_user_read_message_idConsulta_L0+2, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__can_user_read_message1397
	MOVF        can_user_read_message_id_L0+1, 0 
	XORWF       can_user_read_message_idConsulta_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__can_user_read_message1397
	MOVF        can_user_read_message_id_L0+0, 0 
	XORWF       can_user_read_message_idConsulta_L0+0, 0 
L__can_user_read_message1397:
	BTFSS       STATUS+0, 2 
	GOTO        L_can_user_read_message911
;TPV.c,1671 :: 		mysql_write(tablePensionados, pensionadosEstatus, fila, estatus, false);
	MOVLW       _tablePensionados+0
	MOVWF       FARG_mysql_write_name+0 
	MOVLW       hi_addr(_tablePensionados+0)
	MOVWF       FARG_mysql_write_name+1 
	MOVLW       _pensionadosEstatus+0
	MOVWF       FARG_mysql_write_column+0 
	MOVLW       hi_addr(_pensionadosEstatus+0)
	MOVWF       FARG_mysql_write_column+1 
	MOVF        can_user_read_message_fila_L0+0, 0 
	MOVWF       FARG_mysql_write_fila+0 
	MOVF        can_user_read_message_fila_L0+1, 0 
	MOVWF       FARG_mysql_write_fila+1 
	MOVF        can_user_read_message_estatus_L0+0, 0 
	MOVWF       FARG_mysql_write_value+0 
	MOVLW       0
	MOVWF       FARG_mysql_write_value+1 
	MOVWF       FARG_mysql_write_value+2 
	MOVWF       FARG_mysql_write_value+3 
	CLRF        FARG_mysql_write_endWrite+0 
	CALL        _mysql_write+0, 0
;TPV.c,1672 :: 		buffer_save_send(false, can.rxBuffer, tarjetas.canIdMod);
	CLRF        FARG_buffer_save_send_tcpORcan+0 
	MOVLW       _can+107
	MOVWF       FARG_buffer_save_send_buffer+0 
	MOVLW       hi_addr(_can+107)
	MOVWF       FARG_buffer_save_send_buffer+1 
	MOVLW       _tarjetas+42
	MOVWF       FARG_buffer_save_send_nodosCAN+0 
	MOVLW       hi_addr(_tarjetas+42)
	MOVWF       FARG_buffer_save_send_nodosCAN+1 
	CALL        _buffer_save_send+0, 0
;TPV.c,1673 :: 		}
L_can_user_read_message911:
;TPV.c,1674 :: 		}
L_can_user_read_message910:
;TPV.c,1675 :: 		}
L_can_user_read_message909:
;TPV.c,1676 :: 		}else if(string_cmpnc(TCP_CAN_PREPAGO, &can.rxBuffer[sizeTotal], sizeKey)){
	GOTO        L_can_user_read_message912
L_can_user_read_message908:
	MOVLW       _TCP_CAN_PREPAGO+0
	MOVWF       FARG_string_cmpnc_text1+0 
	MOVLW       hi_addr(_TCP_CAN_PREPAGO+0)
	MOVWF       FARG_string_cmpnc_text1+1 
	MOVLW       higher_addr(_TCP_CAN_PREPAGO+0)
	MOVWF       FARG_string_cmpnc_text1+2 
	MOVLW       _can+107
	MOVWF       FARG_string_cmpnc_text2+0 
	MOVLW       hi_addr(_can+107)
	MOVWF       FARG_string_cmpnc_text2+1 
	MOVF        can_user_read_message_sizeTotal_L0+0, 0 
	ADDWF       FARG_string_cmpnc_text2+0, 1 
	BTFSC       STATUS+0, 0 
	INCF        FARG_string_cmpnc_text2+1, 1 
	MOVF        can_user_read_message_sizeKey_L0+0, 0 
	MOVWF       FARG_string_cmpnc_bytes+0 
	CALL        _string_cmpnc+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_can_user_read_message913
;TPV.c,1678 :: 		sizeTotal += sizeKey;
	MOVF        can_user_read_message_sizeKey_L0+0, 0 
	ADDWF       can_user_read_message_sizeTotal_L0+0, 0 
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       can_user_read_message_sizeTotal_L0+0 
;TPV.c,1679 :: 		sizeKey = 6;
	MOVLW       6
	MOVWF       can_user_read_message_sizeKey_L0+0 
;TPV.c,1680 :: 		string_cpyn(msjConst, &can.rxBuffer[sizeTotal], sizeKey);
	MOVLW       _msjConst+0
	MOVWF       FARG_string_cpyn_destino+0 
	MOVLW       hi_addr(_msjConst+0)
	MOVWF       FARG_string_cpyn_destino+1 
	MOVLW       _can+107
	MOVWF       FARG_string_cpyn_origen+0 
	MOVLW       hi_addr(_can+107)
	MOVWF       FARG_string_cpyn_origen+1 
	MOVF        R0, 0 
	ADDWF       FARG_string_cpyn_origen+0, 1 
	BTFSC       STATUS+0, 0 
	INCF        FARG_string_cpyn_origen+1, 1 
	MOVLW       6
	MOVWF       FARG_string_cpyn_size+0 
	CALL        _string_cpyn+0, 0
;TPV.c,1681 :: 		idConsulta = hexToNum(msjConst);
	MOVLW       _msjConst+0
	MOVWF       FARG_hexToNum_hex+0 
	MOVLW       hi_addr(_msjConst+0)
	MOVWF       FARG_hexToNum_hex+1 
	CALL        _hexToNum+0, 0
	MOVF        R0, 0 
	MOVWF       can_user_read_message_idConsulta_L0+0 
	MOVF        R1, 0 
	MOVWF       can_user_read_message_idConsulta_L0+1 
	MOVF        R2, 0 
	MOVWF       can_user_read_message_idConsulta_L0+2 
	MOVF        R3, 0 
	MOVWF       can_user_read_message_idConsulta_L0+3 
;TPV.c,1683 :: 		sizeTotal += sizeKey;
	MOVF        can_user_read_message_sizeKey_L0+0, 0 
	ADDWF       can_user_read_message_sizeTotal_L0+0, 0 
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       can_user_read_message_sizeTotal_L0+0 
;TPV.c,1684 :: 		sizeKey = sizeof(CAN_SPECIAL_DATE)-1;
	MOVLW       3
	MOVWF       can_user_read_message_sizeKey_L0+0 
;TPV.c,1686 :: 		if(string_cmpnc(CAN_SPECIAL_DATE, &can.rxBuffer[sizeTotal], sizeKey)){
	MOVLW       _CAN_SPECIAL_DATE+0
	MOVWF       FARG_string_cmpnc_text1+0 
	MOVLW       hi_addr(_CAN_SPECIAL_DATE+0)
	MOVWF       FARG_string_cmpnc_text1+1 
	MOVLW       higher_addr(_CAN_SPECIAL_DATE+0)
	MOVWF       FARG_string_cmpnc_text1+2 
	MOVLW       _can+107
	MOVWF       FARG_string_cmpnc_text2+0 
	MOVLW       hi_addr(_can+107)
	MOVWF       FARG_string_cmpnc_text2+1 
	MOVF        R0, 0 
	ADDWF       FARG_string_cmpnc_text2+0, 1 
	BTFSC       STATUS+0, 0 
	INCF        FARG_string_cmpnc_text2+1, 1 
	MOVLW       3
	MOVWF       FARG_string_cmpnc_bytes+0 
	CALL        _string_cmpnc+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_can_user_read_message914
;TPV.c,1688 :: 		sizeTotal += sizeKey;
	MOVF        can_user_read_message_sizeKey_L0+0, 0 
	ADDWF       can_user_read_message_sizeTotal_L0+0, 0 
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       can_user_read_message_sizeTotal_L0+0 
;TPV.c,1689 :: 		sizeKey = 4;
	MOVLW       4
	MOVWF       can_user_read_message_sizeKey_L0+0 
;TPV.c,1690 :: 		string_cpyn(msjConst, &can.rxBuffer[sizeTotal], sizeKey);
	MOVLW       _msjConst+0
	MOVWF       FARG_string_cpyn_destino+0 
	MOVLW       hi_addr(_msjConst+0)
	MOVWF       FARG_string_cpyn_destino+1 
	MOVLW       _can+107
	MOVWF       FARG_string_cpyn_origen+0 
	MOVLW       hi_addr(_can+107)
	MOVWF       FARG_string_cpyn_origen+1 
	MOVF        R0, 0 
	ADDWF       FARG_string_cpyn_origen+0, 1 
	BTFSC       STATUS+0, 0 
	INCF        FARG_string_cpyn_origen+1, 1 
	MOVLW       4
	MOVWF       FARG_string_cpyn_size+0 
	CALL        _string_cpyn+0, 0
;TPV.c,1691 :: 		fila = stringToNum(msjConst);
	MOVLW       _msjConst+0
	MOVWF       FARG_stringToNum_cadena+0 
	MOVLW       hi_addr(_msjConst+0)
	MOVWF       FARG_stringToNum_cadena+1 
	CALL        _stringToNum+0, 0
	MOVF        R0, 0 
	MOVWF       can_user_read_message_fila_L0+0 
	MOVF        R1, 0 
	MOVWF       can_user_read_message_fila_L0+1 
;TPV.c,1693 :: 		sizeTotal += sizeKey;
	MOVF        can_user_read_message_sizeKey_L0+0, 0 
	ADDWF       can_user_read_message_sizeTotal_L0+0, 0 
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       can_user_read_message_sizeTotal_L0+0 
;TPV.c,1694 :: 		sizeKey = 1;
	MOVLW       1
	MOVWF       can_user_read_message_sizeKey_L0+0 
;TPV.c,1695 :: 		estatus = can.rxBuffer[sizeTotal];
	MOVLW       _can+107
	MOVWF       FSR0 
	MOVLW       hi_addr(_can+107)
	MOVWF       FSR0H 
	MOVF        R0, 0 
	ADDWF       FSR0, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR0H, 1 
	MOVF        POSTINC0+0, 0 
	MOVWF       can_user_read_message_estatus_L0+0 
;TPV.c,1697 :: 		sizeTotal += sizeKey;
	INCF        R0, 1 
	MOVF        R0, 0 
	MOVWF       can_user_read_message_sizeTotal_L0+0 
;TPV.c,1698 :: 		sizeKey = 12;
	MOVLW       12
	MOVWF       can_user_read_message_sizeKey_L0+0 
;TPV.c,1699 :: 		string_cpyn(msjConst, &can.rxBuffer[sizeTotal], sizeKey);
	MOVLW       _msjConst+0
	MOVWF       FARG_string_cpyn_destino+0 
	MOVLW       hi_addr(_msjConst+0)
	MOVWF       FARG_string_cpyn_destino+1 
	MOVLW       _can+107
	MOVWF       FARG_string_cpyn_origen+0 
	MOVLW       hi_addr(_can+107)
	MOVWF       FARG_string_cpyn_origen+1 
	MOVF        R0, 0 
	ADDWF       FARG_string_cpyn_origen+0, 1 
	BTFSC       STATUS+0, 0 
	INCF        FARG_string_cpyn_origen+1, 1 
	MOVLW       12
	MOVWF       FARG_string_cpyn_size+0 
	CALL        _string_cpyn+0, 0
;TPV.c,1701 :: 		if(!mysql_read(tablePrepago, prepagoID, fila, &id)){
	MOVLW       _tablePrepago+0
	MOVWF       FARG_mysql_read_name+0 
	MOVLW       hi_addr(_tablePrepago+0)
	MOVWF       FARG_mysql_read_name+1 
	MOVLW       _prepagoId+0
	MOVWF       FARG_mysql_read_column+0 
	MOVLW       hi_addr(_prepagoId+0)
	MOVWF       FARG_mysql_read_column+1 
	MOVF        can_user_read_message_fila_L0+0, 0 
	MOVWF       FARG_mysql_read_fila+0 
	MOVF        can_user_read_message_fila_L0+1, 0 
	MOVWF       FARG_mysql_read_fila+1 
	MOVLW       can_user_read_message_id_L0+0
	MOVWF       FARG_mysql_read_result+0 
	MOVLW       hi_addr(can_user_read_message_id_L0+0)
	MOVWF       FARG_mysql_read_result+1 
	CALL        _mysql_read+0, 0
	MOVF        R0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_can_user_read_message915
;TPV.c,1702 :: 		if(id == idConsulta){
	MOVF        can_user_read_message_id_L0+3, 0 
	XORWF       can_user_read_message_idConsulta_L0+3, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__can_user_read_message1398
	MOVF        can_user_read_message_id_L0+2, 0 
	XORWF       can_user_read_message_idConsulta_L0+2, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__can_user_read_message1398
	MOVF        can_user_read_message_id_L0+1, 0 
	XORWF       can_user_read_message_idConsulta_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__can_user_read_message1398
	MOVF        can_user_read_message_id_L0+0, 0 
	XORWF       can_user_read_message_idConsulta_L0+0, 0 
L__can_user_read_message1398:
	BTFSS       STATUS+0, 2 
	GOTO        L_can_user_read_message916
;TPV.c,1704 :: 		usart_write_line("Modificado PAS+DATE");
	MOVLW       ?lstr45_TPV+0
	MOVWF       FARG_usart_write_line_texto+0 
	MOVLW       hi_addr(?lstr45_TPV+0)
	MOVWF       FARG_usart_write_line_texto+1 
	CALL        _usart_write_line+0, 0
;TPV.c,1705 :: 		mysql_write(tablePrepago, prepagoEstatus, fila, estatus, false);
	MOVLW       _tablePrepago+0
	MOVWF       FARG_mysql_write_name+0 
	MOVLW       hi_addr(_tablePrepago+0)
	MOVWF       FARG_mysql_write_name+1 
	MOVLW       _prepagoEstatus+0
	MOVWF       FARG_mysql_write_column+0 
	MOVLW       hi_addr(_prepagoEstatus+0)
	MOVWF       FARG_mysql_write_column+1 
	MOVF        can_user_read_message_fila_L0+0, 0 
	MOVWF       FARG_mysql_write_fila+0 
	MOVF        can_user_read_message_fila_L0+1, 0 
	MOVWF       FARG_mysql_write_fila+1 
	MOVF        can_user_read_message_estatus_L0+0, 0 
	MOVWF       FARG_mysql_write_value+0 
	MOVLW       0
	MOVWF       FARG_mysql_write_value+1 
	MOVWF       FARG_mysql_write_value+2 
	MOVWF       FARG_mysql_write_value+3 
	CLRF        FARG_mysql_write_endWrite+0 
	CALL        _mysql_write+0, 0
;TPV.c,1706 :: 		mysql_write_string(tablePrepago, prepagoDate, fila, msjConst, false);
	MOVLW       _tablePrepago+0
	MOVWF       FARG_mysql_write_string_name+0 
	MOVLW       hi_addr(_tablePrepago+0)
	MOVWF       FARG_mysql_write_string_name+1 
	MOVLW       _prepagoDate+0
	MOVWF       FARG_mysql_write_string_column+0 
	MOVLW       hi_addr(_prepagoDate+0)
	MOVWF       FARG_mysql_write_string_column+1 
	MOVF        can_user_read_message_fila_L0+0, 0 
	MOVWF       FARG_mysql_write_string_fila+0 
	MOVF        can_user_read_message_fila_L0+1, 0 
	MOVWF       FARG_mysql_write_string_fila+1 
	MOVLW       _msjConst+0
	MOVWF       FARG_mysql_write_string_texto+0 
	MOVLW       hi_addr(_msjConst+0)
	MOVWF       FARG_mysql_write_string_texto+1 
	CLRF        FARG_mysql_write_string_endWrite+0 
	CALL        _mysql_write_string+0, 0
;TPV.c,1707 :: 		buffer_save_send(false, can.rxBuffer, tarjetas.canIdMod);
	CLRF        FARG_buffer_save_send_tcpORcan+0 
	MOVLW       _can+107
	MOVWF       FARG_buffer_save_send_buffer+0 
	MOVLW       hi_addr(_can+107)
	MOVWF       FARG_buffer_save_send_buffer+1 
	MOVLW       _tarjetas+42
	MOVWF       FARG_buffer_save_send_nodosCAN+0 
	MOVLW       hi_addr(_tarjetas+42)
	MOVWF       FARG_buffer_save_send_nodosCAN+1 
	CALL        _buffer_save_send+0, 0
;TPV.c,1708 :: 		}
L_can_user_read_message916:
;TPV.c,1709 :: 		}
L_can_user_read_message915:
;TPV.c,1710 :: 		}else if(string_cmpnc(CAN_SPECIAL_SALDO, &can.rxBuffer[sizeTotal], sizeKey)){
	GOTO        L_can_user_read_message917
L_can_user_read_message914:
	MOVLW       _CAN_SPECIAL_SALDO+0
	MOVWF       FARG_string_cmpnc_text1+0 
	MOVLW       hi_addr(_CAN_SPECIAL_SALDO+0)
	MOVWF       FARG_string_cmpnc_text1+1 
	MOVLW       higher_addr(_CAN_SPECIAL_SALDO+0)
	MOVWF       FARG_string_cmpnc_text1+2 
	MOVLW       _can+107
	MOVWF       FARG_string_cmpnc_text2+0 
	MOVLW       hi_addr(_can+107)
	MOVWF       FARG_string_cmpnc_text2+1 
	MOVF        can_user_read_message_sizeTotal_L0+0, 0 
	ADDWF       FARG_string_cmpnc_text2+0, 1 
	BTFSC       STATUS+0, 0 
	INCF        FARG_string_cmpnc_text2+1, 1 
	MOVF        can_user_read_message_sizeKey_L0+0, 0 
	MOVWF       FARG_string_cmpnc_bytes+0 
	CALL        _string_cmpnc+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_can_user_read_message918
;TPV.c,1712 :: 		sizeTotal += sizeKey;
	MOVF        can_user_read_message_sizeKey_L0+0, 0 
	ADDWF       can_user_read_message_sizeTotal_L0+0, 0 
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       can_user_read_message_sizeTotal_L0+0 
;TPV.c,1713 :: 		sizeKey = 4;
	MOVLW       4
	MOVWF       can_user_read_message_sizeKey_L0+0 
;TPV.c,1714 :: 		string_cpyn(msjConst, &can.rxBuffer[sizeTotal], sizeKey);
	MOVLW       _msjConst+0
	MOVWF       FARG_string_cpyn_destino+0 
	MOVLW       hi_addr(_msjConst+0)
	MOVWF       FARG_string_cpyn_destino+1 
	MOVLW       _can+107
	MOVWF       FARG_string_cpyn_origen+0 
	MOVLW       hi_addr(_can+107)
	MOVWF       FARG_string_cpyn_origen+1 
	MOVF        R0, 0 
	ADDWF       FARG_string_cpyn_origen+0, 1 
	BTFSC       STATUS+0, 0 
	INCF        FARG_string_cpyn_origen+1, 1 
	MOVLW       4
	MOVWF       FARG_string_cpyn_size+0 
	CALL        _string_cpyn+0, 0
;TPV.c,1715 :: 		fila = stringToNum(msjConst);
	MOVLW       _msjConst+0
	MOVWF       FARG_stringToNum_cadena+0 
	MOVLW       hi_addr(_msjConst+0)
	MOVWF       FARG_stringToNum_cadena+1 
	CALL        _stringToNum+0, 0
	MOVF        R0, 0 
	MOVWF       can_user_read_message_fila_L0+0 
	MOVF        R1, 0 
	MOVWF       can_user_read_message_fila_L0+1 
;TPV.c,1717 :: 		sizeTotal += sizeKey;
	MOVF        can_user_read_message_sizeKey_L0+0, 0 
	ADDWF       can_user_read_message_sizeTotal_L0+0, 0 
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       can_user_read_message_sizeTotal_L0+0 
;TPV.c,1718 :: 		sizeKey = 1;
	MOVLW       1
	MOVWF       can_user_read_message_sizeKey_L0+0 
;TPV.c,1719 :: 		estatus = can.rxBuffer[sizeTotal];
	MOVLW       _can+107
	MOVWF       FSR0 
	MOVLW       hi_addr(_can+107)
	MOVWF       FSR0H 
	MOVF        R0, 0 
	ADDWF       FSR0, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR0H, 1 
	MOVF        POSTINC0+0, 0 
	MOVWF       can_user_read_message_estatus_L0+0 
;TPV.c,1721 :: 		sizeTotal += sizeKey;
	INCF        R0, 1 
	MOVF        R0, 0 
	MOVWF       can_user_read_message_sizeTotal_L0+0 
;TPV.c,1722 :: 		sizeKey = 8;
	MOVLW       8
	MOVWF       can_user_read_message_sizeKey_L0+0 
;TPV.c,1723 :: 		string_cpyn(msjConst, &can.rxBuffer[sizeTotal], sizeKey);
	MOVLW       _msjConst+0
	MOVWF       FARG_string_cpyn_destino+0 
	MOVLW       hi_addr(_msjConst+0)
	MOVWF       FARG_string_cpyn_destino+1 
	MOVLW       _can+107
	MOVWF       FARG_string_cpyn_origen+0 
	MOVLW       hi_addr(_can+107)
	MOVWF       FARG_string_cpyn_origen+1 
	MOVF        R0, 0 
	ADDWF       FARG_string_cpyn_origen+0, 1 
	BTFSC       STATUS+0, 0 
	INCF        FARG_string_cpyn_origen+1, 1 
	MOVLW       8
	MOVWF       FARG_string_cpyn_size+0 
	CALL        _string_cpyn+0, 0
;TPV.c,1724 :: 		saldo = hexToNum(msjConst);
	MOVLW       _msjConst+0
	MOVWF       FARG_hexToNum_hex+0 
	MOVLW       hi_addr(_msjConst+0)
	MOVWF       FARG_hexToNum_hex+1 
	CALL        _hexToNum+0, 0
	MOVF        R0, 0 
	MOVWF       can_user_read_message_saldo_L0+0 
	MOVF        R1, 0 
	MOVWF       can_user_read_message_saldo_L0+1 
	MOVF        R2, 0 
	MOVWF       can_user_read_message_saldo_L0+2 
	MOVF        R3, 0 
	MOVWF       can_user_read_message_saldo_L0+3 
;TPV.c,1726 :: 		if(!mysql_read(tablePrepago, prepagoID, fila, &id)){
	MOVLW       _tablePrepago+0
	MOVWF       FARG_mysql_read_name+0 
	MOVLW       hi_addr(_tablePrepago+0)
	MOVWF       FARG_mysql_read_name+1 
	MOVLW       _prepagoId+0
	MOVWF       FARG_mysql_read_column+0 
	MOVLW       hi_addr(_prepagoId+0)
	MOVWF       FARG_mysql_read_column+1 
	MOVF        can_user_read_message_fila_L0+0, 0 
	MOVWF       FARG_mysql_read_fila+0 
	MOVF        can_user_read_message_fila_L0+1, 0 
	MOVWF       FARG_mysql_read_fila+1 
	MOVLW       can_user_read_message_id_L0+0
	MOVWF       FARG_mysql_read_result+0 
	MOVLW       hi_addr(can_user_read_message_id_L0+0)
	MOVWF       FARG_mysql_read_result+1 
	CALL        _mysql_read+0, 0
	MOVF        R0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_can_user_read_message919
;TPV.c,1727 :: 		if(id == idConsulta){
	MOVF        can_user_read_message_id_L0+3, 0 
	XORWF       can_user_read_message_idConsulta_L0+3, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__can_user_read_message1399
	MOVF        can_user_read_message_id_L0+2, 0 
	XORWF       can_user_read_message_idConsulta_L0+2, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__can_user_read_message1399
	MOVF        can_user_read_message_id_L0+1, 0 
	XORWF       can_user_read_message_idConsulta_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__can_user_read_message1399
	MOVF        can_user_read_message_id_L0+0, 0 
	XORWF       can_user_read_message_idConsulta_L0+0, 0 
L__can_user_read_message1399:
	BTFSS       STATUS+0, 2 
	GOTO        L_can_user_read_message920
;TPV.c,1729 :: 		usart_write_line("Modificado PAS+SALDO");
	MOVLW       ?lstr46_TPV+0
	MOVWF       FARG_usart_write_line_texto+0 
	MOVLW       hi_addr(?lstr46_TPV+0)
	MOVWF       FARG_usart_write_line_texto+1 
	CALL        _usart_write_line+0, 0
;TPV.c,1730 :: 		mysql_write(tablePrepago, prepagoEstatus, fila, estatus, false);
	MOVLW       _tablePrepago+0
	MOVWF       FARG_mysql_write_name+0 
	MOVLW       hi_addr(_tablePrepago+0)
	MOVWF       FARG_mysql_write_name+1 
	MOVLW       _prepagoEstatus+0
	MOVWF       FARG_mysql_write_column+0 
	MOVLW       hi_addr(_prepagoEstatus+0)
	MOVWF       FARG_mysql_write_column+1 
	MOVF        can_user_read_message_fila_L0+0, 0 
	MOVWF       FARG_mysql_write_fila+0 
	MOVF        can_user_read_message_fila_L0+1, 0 
	MOVWF       FARG_mysql_write_fila+1 
	MOVF        can_user_read_message_estatus_L0+0, 0 
	MOVWF       FARG_mysql_write_value+0 
	MOVLW       0
	MOVWF       FARG_mysql_write_value+1 
	MOVWF       FARG_mysql_write_value+2 
	MOVWF       FARG_mysql_write_value+3 
	CLRF        FARG_mysql_write_endWrite+0 
	CALL        _mysql_write+0, 0
;TPV.c,1731 :: 		mysql_write(tablePrepago, prepagoSaldo, fila, saldo, false);
	MOVLW       _tablePrepago+0
	MOVWF       FARG_mysql_write_name+0 
	MOVLW       hi_addr(_tablePrepago+0)
	MOVWF       FARG_mysql_write_name+1 
	MOVLW       _prepagoSaldo+0
	MOVWF       FARG_mysql_write_column+0 
	MOVLW       hi_addr(_prepagoSaldo+0)
	MOVWF       FARG_mysql_write_column+1 
	MOVF        can_user_read_message_fila_L0+0, 0 
	MOVWF       FARG_mysql_write_fila+0 
	MOVF        can_user_read_message_fila_L0+1, 0 
	MOVWF       FARG_mysql_write_fila+1 
	MOVF        can_user_read_message_saldo_L0+0, 0 
	MOVWF       FARG_mysql_write_value+0 
	MOVF        can_user_read_message_saldo_L0+1, 0 
	MOVWF       FARG_mysql_write_value+1 
	MOVF        can_user_read_message_saldo_L0+2, 0 
	MOVWF       FARG_mysql_write_value+2 
	MOVF        can_user_read_message_saldo_L0+3, 0 
	MOVWF       FARG_mysql_write_value+3 
	CLRF        FARG_mysql_write_endWrite+0 
	CALL        _mysql_write+0, 0
;TPV.c,1732 :: 		buffer_save_send(false, can.rxBuffer, tarjetas.canIdMod);
	CLRF        FARG_buffer_save_send_tcpORcan+0 
	MOVLW       _can+107
	MOVWF       FARG_buffer_save_send_buffer+0 
	MOVLW       hi_addr(_can+107)
	MOVWF       FARG_buffer_save_send_buffer+1 
	MOVLW       _tarjetas+42
	MOVWF       FARG_buffer_save_send_nodosCAN+0 
	MOVLW       hi_addr(_tarjetas+42)
	MOVWF       FARG_buffer_save_send_nodosCAN+1 
	CALL        _buffer_save_send+0, 0
;TPV.c,1733 :: 		}
L_can_user_read_message920:
;TPV.c,1734 :: 		}
L_can_user_read_message919:
;TPV.c,1735 :: 		}else if(string_cmpnc(TCP_CAN_PASSBACK, &can.rxBuffer[sizeTotal], sizeKey)){
	GOTO        L_can_user_read_message921
L_can_user_read_message918:
	MOVLW       _TCP_CAN_PASSBACK+0
	MOVWF       FARG_string_cmpnc_text1+0 
	MOVLW       hi_addr(_TCP_CAN_PASSBACK+0)
	MOVWF       FARG_string_cmpnc_text1+1 
	MOVLW       higher_addr(_TCP_CAN_PASSBACK+0)
	MOVWF       FARG_string_cmpnc_text1+2 
	MOVLW       _can+107
	MOVWF       FARG_string_cmpnc_text2+0 
	MOVLW       hi_addr(_can+107)
	MOVWF       FARG_string_cmpnc_text2+1 
	MOVF        can_user_read_message_sizeTotal_L0+0, 0 
	ADDWF       FARG_string_cmpnc_text2+0, 1 
	BTFSC       STATUS+0, 0 
	INCF        FARG_string_cmpnc_text2+1, 1 
	MOVF        can_user_read_message_sizeKey_L0+0, 0 
	MOVWF       FARG_string_cmpnc_bytes+0 
	CALL        _string_cmpnc+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_can_user_read_message922
;TPV.c,1737 :: 		sizeTotal += sizeKey;
	MOVF        can_user_read_message_sizeKey_L0+0, 0 
	ADDWF       can_user_read_message_sizeTotal_L0+0, 0 
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       can_user_read_message_sizeTotal_L0+0 
;TPV.c,1738 :: 		sizeKey = 4;
	MOVLW       4
	MOVWF       can_user_read_message_sizeKey_L0+0 
;TPV.c,1739 :: 		string_cpyn(msjConst, &can.rxBuffer[sizeTotal], sizeKey);
	MOVLW       _msjConst+0
	MOVWF       FARG_string_cpyn_destino+0 
	MOVLW       hi_addr(_msjConst+0)
	MOVWF       FARG_string_cpyn_destino+1 
	MOVLW       _can+107
	MOVWF       FARG_string_cpyn_origen+0 
	MOVLW       hi_addr(_can+107)
	MOVWF       FARG_string_cpyn_origen+1 
	MOVF        R0, 0 
	ADDWF       FARG_string_cpyn_origen+0, 1 
	BTFSC       STATUS+0, 0 
	INCF        FARG_string_cpyn_origen+1, 1 
	MOVLW       4
	MOVWF       FARG_string_cpyn_size+0 
	CALL        _string_cpyn+0, 0
;TPV.c,1740 :: 		fila = stringToNum(msjConst);
	MOVLW       _msjConst+0
	MOVWF       FARG_stringToNum_cadena+0 
	MOVLW       hi_addr(_msjConst+0)
	MOVWF       FARG_stringToNum_cadena+1 
	CALL        _stringToNum+0, 0
	MOVF        R0, 0 
	MOVWF       can_user_read_message_fila_L0+0 
	MOVF        R1, 0 
	MOVWF       can_user_read_message_fila_L0+1 
;TPV.c,1742 :: 		sizeTotal += sizeKey;
	MOVF        can_user_read_message_sizeKey_L0+0, 0 
	ADDWF       can_user_read_message_sizeTotal_L0+0, 0 
	MOVWF       R4 
	MOVF        R4, 0 
	MOVWF       can_user_read_message_sizeTotal_L0+0 
;TPV.c,1743 :: 		sizeKey = 1;
	MOVLW       1
	MOVWF       can_user_read_message_sizeKey_L0+0 
;TPV.c,1744 :: 		estatus = can.rxBuffer[sizeTotal];
	MOVLW       _can+107
	MOVWF       FSR0 
	MOVLW       hi_addr(_can+107)
	MOVWF       FSR0H 
	MOVF        R4, 0 
	ADDWF       FSR0, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR0H, 1 
	MOVF        POSTINC0+0, 0 
	MOVWF       can_user_read_message_estatus_L0+0 
;TPV.c,1747 :: 		if(!mysql_read(tablePrepago, prepagoID, fila, &id)){
	MOVLW       _tablePrepago+0
	MOVWF       FARG_mysql_read_name+0 
	MOVLW       hi_addr(_tablePrepago+0)
	MOVWF       FARG_mysql_read_name+1 
	MOVLW       _prepagoId+0
	MOVWF       FARG_mysql_read_column+0 
	MOVLW       hi_addr(_prepagoId+0)
	MOVWF       FARG_mysql_read_column+1 
	MOVF        R0, 0 
	MOVWF       FARG_mysql_read_fila+0 
	MOVF        R1, 0 
	MOVWF       FARG_mysql_read_fila+1 
	MOVLW       can_user_read_message_id_L0+0
	MOVWF       FARG_mysql_read_result+0 
	MOVLW       hi_addr(can_user_read_message_id_L0+0)
	MOVWF       FARG_mysql_read_result+1 
	CALL        _mysql_read+0, 0
	MOVF        R0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_can_user_read_message923
;TPV.c,1748 :: 		if(id == idConsulta){
	MOVF        can_user_read_message_id_L0+3, 0 
	XORWF       can_user_read_message_idConsulta_L0+3, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__can_user_read_message1400
	MOVF        can_user_read_message_id_L0+2, 0 
	XORWF       can_user_read_message_idConsulta_L0+2, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__can_user_read_message1400
	MOVF        can_user_read_message_id_L0+1, 0 
	XORWF       can_user_read_message_idConsulta_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__can_user_read_message1400
	MOVF        can_user_read_message_id_L0+0, 0 
	XORWF       can_user_read_message_idConsulta_L0+0, 0 
L__can_user_read_message1400:
	BTFSS       STATUS+0, 2 
	GOTO        L_can_user_read_message924
;TPV.c,1750 :: 		usart_write_line("Modificado PAS");
	MOVLW       ?lstr47_TPV+0
	MOVWF       FARG_usart_write_line_texto+0 
	MOVLW       hi_addr(?lstr47_TPV+0)
	MOVWF       FARG_usart_write_line_texto+1 
	CALL        _usart_write_line+0, 0
;TPV.c,1751 :: 		mysql_write(tablePrepago, prepagoEstatus, fila, estatus, false);
	MOVLW       _tablePrepago+0
	MOVWF       FARG_mysql_write_name+0 
	MOVLW       hi_addr(_tablePrepago+0)
	MOVWF       FARG_mysql_write_name+1 
	MOVLW       _prepagoEstatus+0
	MOVWF       FARG_mysql_write_column+0 
	MOVLW       hi_addr(_prepagoEstatus+0)
	MOVWF       FARG_mysql_write_column+1 
	MOVF        can_user_read_message_fila_L0+0, 0 
	MOVWF       FARG_mysql_write_fila+0 
	MOVF        can_user_read_message_fila_L0+1, 0 
	MOVWF       FARG_mysql_write_fila+1 
	MOVF        can_user_read_message_estatus_L0+0, 0 
	MOVWF       FARG_mysql_write_value+0 
	MOVLW       0
	MOVWF       FARG_mysql_write_value+1 
	MOVWF       FARG_mysql_write_value+2 
	MOVWF       FARG_mysql_write_value+3 
	CLRF        FARG_mysql_write_endWrite+0 
	CALL        _mysql_write+0, 0
;TPV.c,1752 :: 		buffer_save_send(false, can.rxBuffer, tarjetas.canIdMod);
	CLRF        FARG_buffer_save_send_tcpORcan+0 
	MOVLW       _can+107
	MOVWF       FARG_buffer_save_send_buffer+0 
	MOVLW       hi_addr(_can+107)
	MOVWF       FARG_buffer_save_send_buffer+1 
	MOVLW       _tarjetas+42
	MOVWF       FARG_buffer_save_send_nodosCAN+0 
	MOVLW       hi_addr(_tarjetas+42)
	MOVWF       FARG_buffer_save_send_nodosCAN+1 
	CALL        _buffer_save_send+0, 0
;TPV.c,1753 :: 		}
L_can_user_read_message924:
;TPV.c,1754 :: 		}
L_can_user_read_message923:
;TPV.c,1755 :: 		}
L_can_user_read_message922:
L_can_user_read_message921:
L_can_user_read_message917:
;TPV.c,1756 :: 		}
L_can_user_read_message913:
L_can_user_read_message912:
L_can_user_read_message907:
;TPV.c,1757 :: 		}
L_end_can_user_read_message:
	RETURN      0
; end of _can_user_read_message

_can_user_write_message:

;TPV.c,1759 :: 		void can_user_write_message(){
;TPV.c,1761 :: 		if(can.tx_status == CAN_RW_ENVIADO){
	MOVF        _can+34, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_can_user_write_message925
;TPV.c,1762 :: 		if(modeBufferToNodo){
	MOVF        _modeBufferToNodo+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_can_user_write_message926
;TPV.c,1763 :: 		usart_write_line("Envio entregado del nodo");
	MOVLW       ?lstr48_TPV+0
	MOVWF       FARG_usart_write_line_texto+0 
	MOVLW       hi_addr(?lstr48_TPV+0)
	MOVWF       FARG_usart_write_line_texto+1 
	CALL        _usart_write_line+0, 0
;TPV.c,1764 :: 		modeBufferToNodo = false;
	CLRF        _modeBufferToNodo+0 
;TPV.c,1766 :: 		mysql_read_forced(tableEventosCAN, eventosModulos, pointerBufferCAN, bufferEeprom);
	MOVLW       _tableEventosCAN+0
	MOVWF       FARG_mysql_read_forced_name+0 
	MOVLW       hi_addr(_tableEventosCAN+0)
	MOVWF       FARG_mysql_read_forced_name+1 
	MOVLW       _eventosModulos+0
	MOVWF       FARG_mysql_read_forced_column+0 
	MOVLW       hi_addr(_eventosModulos+0)
	MOVWF       FARG_mysql_read_forced_column+1 
	MOVF        _pointerBufferCAN+0, 0 
	MOVWF       FARG_mysql_read_forced_fila+0 
	MOVF        _pointerBufferCAN+1, 0 
	MOVWF       FARG_mysql_read_forced_fila+1 
	MOVLW       _bufferEeprom+0
	MOVWF       FARG_mysql_read_forced_result+0 
	MOVLW       hi_addr(_bufferEeprom+0)
	MOVWF       FARG_mysql_read_forced_result+1 
	CALL        _mysql_read_forced+0, 0
;TPV.c,1767 :: 		tam = string_len(bufferEeprom);
	MOVLW       _bufferEeprom+0
	MOVWF       FARG_string_len_texto+0 
	MOVLW       hi_addr(_bufferEeprom+0)
	MOVWF       FARG_string_len_texto+1 
	CALL        _string_len+0, 0
	MOVF        R0, 0 
	MOVWF       can_user_write_message_tam_L0+0 
;TPV.c,1769 :: 		if(tam != 0){
	MOVF        R0, 0 
	XORLW       0
	BTFSC       STATUS+0, 2 
	GOTO        L_can_user_write_message927
;TPV.c,1770 :: 		bufferEeprom[--tam] = 0;
	DECF        can_user_write_message_tam_L0+0, 1 
	MOVLW       _bufferEeprom+0
	MOVWF       FSR1 
	MOVLW       hi_addr(_bufferEeprom+0)
	MOVWF       FSR1H 
	MOVF        can_user_write_message_tam_L0+0, 0 
	ADDWF       FSR1, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR1H, 1 
	CLRF        POSTINC1+0 
;TPV.c,1771 :: 		mysql_write_forced(tableEventosCAN, eventosModulos, pointerBufferCAN, bufferEeprom, string_len(bufferEeprom)+1);
	MOVLW       _bufferEeprom+0
	MOVWF       FARG_string_len_texto+0 
	MOVLW       hi_addr(_bufferEeprom+0)
	MOVWF       FARG_string_len_texto+1 
	CALL        _string_len+0, 0
	MOVF        R0, 0 
	ADDLW       1
	MOVWF       FARG_mysql_write_forced_bytes+0 
	MOVLW       _tableEventosCAN+0
	MOVWF       FARG_mysql_write_forced_name+0 
	MOVLW       hi_addr(_tableEventosCAN+0)
	MOVWF       FARG_mysql_write_forced_name+1 
	MOVLW       _eventosModulos+0
	MOVWF       FARG_mysql_write_forced_column+0 
	MOVLW       hi_addr(_eventosModulos+0)
	MOVWF       FARG_mysql_write_forced_column+1 
	MOVF        _pointerBufferCAN+0, 0 
	MOVWF       FARG_mysql_write_forced_fila+0 
	MOVF        _pointerBufferCAN+1, 0 
	MOVWF       FARG_mysql_write_forced_fila+1 
	MOVLW       _bufferEeprom+0
	MOVWF       FARG_mysql_write_forced_texto+0 
	MOVLW       hi_addr(_bufferEeprom+0)
	MOVWF       FARG_mysql_write_forced_texto+1 
	CALL        _mysql_write_forced+0, 0
;TPV.c,1774 :: 		if(tam == 0){
	MOVF        can_user_write_message_tam_L0+0, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_can_user_write_message928
;TPV.c,1775 :: 		usart_write_text("Linea completa: ");
	MOVLW       ?lstr49_TPV+0
	MOVWF       FARG_usart_write_text_texto+0 
	MOVLW       hi_addr(?lstr49_TPV+0)
	MOVWF       FARG_usart_write_text_texto+1 
	CALL        _usart_write_text+0, 0
;TPV.c,1776 :: 		usart_write_line(can.txBuffer);
	MOVLW       _can+41
	MOVWF       FARG_usart_write_line_texto+0 
	MOVLW       hi_addr(_can+41)
	MOVWF       FARG_usart_write_line_texto+1 
	CALL        _usart_write_line+0, 0
;TPV.c,1777 :: 		}
L_can_user_write_message928:
;TPV.c,1778 :: 		}
L_can_user_write_message927:
;TPV.c,1779 :: 		}
L_can_user_write_message926:
;TPV.c,1780 :: 		}else if(can.tx_status == CAN_RW_CORRUPT){
	GOTO        L_can_user_write_message929
L_can_user_write_message925:
	MOVF        _can+34, 0 
	XORLW       3
	BTFSS       STATUS+0, 2 
	GOTO        L_can_user_write_message930
;TPV.c,1782 :: 		if(!modeBufferToNodo){
	MOVF        _modeBufferToNodo+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_can_user_write_message931
;TPV.c,1783 :: 		buffer_save_send(true, can.txBuffer, tarjetas.canIdMod);
	MOVLW       1
	MOVWF       FARG_buffer_save_send_tcpORcan+0 
	MOVLW       _can+41
	MOVWF       FARG_buffer_save_send_buffer+0 
	MOVLW       hi_addr(_can+41)
	MOVWF       FARG_buffer_save_send_buffer+1 
	MOVLW       _tarjetas+42
	MOVWF       FARG_buffer_save_send_nodosCAN+0 
	MOVLW       hi_addr(_tarjetas+42)
	MOVWF       FARG_buffer_save_send_nodosCAN+1 
	CALL        _buffer_save_send+0, 0
;TPV.c,1784 :: 		}else{
	GOTO        L_can_user_write_message932
L_can_user_write_message931:
;TPV.c,1786 :: 		modeBufferToNodo = false;
	CLRF        _modeBufferToNodo+0 
;TPV.c,1787 :: 		usart_write_line("No se pudo enviar al nodo");
	MOVLW       ?lstr50_TPV+0
	MOVWF       FARG_usart_write_line_texto+0 
	MOVLW       hi_addr(?lstr50_TPV+0)
	MOVWF       FARG_usart_write_line_texto+1 
	CALL        _usart_write_line+0, 0
;TPV.c,1788 :: 		}
L_can_user_write_message932:
;TPV.c,1789 :: 		}
L_can_user_write_message930:
L_can_user_write_message929:
;TPV.c,1790 :: 		}
L_end_can_user_write_message:
	RETURN      0
; end of _can_user_write_message

_can_user_guardHeartBeat:

;TPV.c,1792 :: 		void can_user_guardHeartBeat(char idNodo){
;TPV.c,1793 :: 		char cont = 0;
	CLRF        can_user_guardHeartBeat_cont_L0+0 
;TPV.c,1796 :: 		for(cont = 0; cont < tarjetas.modulos; cont++){
	CLRF        can_user_guardHeartBeat_cont_L0+0 
L_can_user_guardHeartBeat933:
	MOVF        _tarjetas+1, 0 
	SUBWF       can_user_guardHeartBeat_cont_L0+0, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_can_user_guardHeartBeat934
;TPV.c,1797 :: 		if(idNodo == tarjetas.canIdMod[cont]){
	MOVLW       _tarjetas+42
	MOVWF       FSR2 
	MOVLW       hi_addr(_tarjetas+42)
	MOVWF       FSR2H 
	MOVF        can_user_guardHeartBeat_cont_L0+0, 0 
	ADDWF       FSR2, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR2H, 1 
	MOVF        FARG_can_user_guardHeartBeat_idNodo+0, 0 
	XORWF       POSTINC2+0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L_can_user_guardHeartBeat936
;TPV.c,1798 :: 		tarjetas.canIdReport[cont] = true;
	MOVLW       _tarjetas+22
	MOVWF       FSR1 
	MOVLW       hi_addr(_tarjetas+22)
	MOVWF       FSR1H 
	MOVF        can_user_guardHeartBeat_cont_L0+0, 0 
	ADDWF       FSR1, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR1H, 1 
	MOVLW       1
	MOVWF       POSTINC1+0 
;TPV.c,1800 :: 		if(tarjetas.canState[cont] != tarjetas.canIdReport[cont]){
	MOVLW       _tarjetas+2
	MOVWF       FSR0 
	MOVLW       hi_addr(_tarjetas+2)
	MOVWF       FSR0H 
	MOVF        can_user_guardHeartBeat_cont_L0+0, 0 
	ADDWF       FSR0, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR0H, 1 
	MOVLW       _tarjetas+22
	MOVWF       FSR2 
	MOVLW       hi_addr(_tarjetas+22)
	MOVWF       FSR2H 
	MOVF        can_user_guardHeartBeat_cont_L0+0, 0 
	ADDWF       FSR2, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR2H, 1 
	MOVF        POSTINC0+0, 0 
	XORWF       POSTINC2+0, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L_can_user_guardHeartBeat937
;TPV.c,1803 :: 		}
L_can_user_guardHeartBeat937:
;TPV.c,1804 :: 		break;
	GOTO        L_can_user_guardHeartBeat934
;TPV.c,1805 :: 		}
L_can_user_guardHeartBeat936:
;TPV.c,1796 :: 		for(cont = 0; cont < tarjetas.modulos; cont++){
	INCF        can_user_guardHeartBeat_cont_L0+0, 1 
;TPV.c,1806 :: 		}
	GOTO        L_can_user_guardHeartBeat933
L_can_user_guardHeartBeat934:
;TPV.c,1807 :: 		}
L_end_can_user_guardHeartBeat:
	RETURN      0
; end of _can_user_guardHeartBeat

_buffer_save_send:

;TPV.c,1809 :: 		void buffer_save_send(bool tcpORcan, char *buffer, char *nodosCAN){
;TPV.c,1812 :: 		if(tcpORcan){
	MOVF        FARG_buffer_save_send_tcpORcan+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_buffer_save_send938
;TPV.c,1814 :: 		if(!isConectServer)
	MOVF        _isConectServer+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_buffer_save_send939
;TPV.c,1815 :: 		string_addc(buffer, ",");
	MOVF        FARG_buffer_save_send_buffer+0, 0 
	MOVWF       FARG_string_addc_destino+0 
	MOVF        FARG_buffer_save_send_buffer+1, 0 
	MOVWF       FARG_string_addc_destino+1 
	MOVLW       ?lstr_51_TPV+0
	MOVWF       FARG_string_addc_addEnd+0 
	MOVLW       hi_addr(?lstr_51_TPV+0)
	MOVWF       FARG_string_addc_addEnd+1 
	MOVLW       higher_addr(?lstr_51_TPV+0)
	MOVWF       FARG_string_addc_addEnd+2 
	CALL        _string_addc+0, 0
L_buffer_save_send939:
;TPV.c,1816 :: 		mysql_write_roundTrip(tableEventosTCP, eventosRegistro, buffer, strlen(buffer)+1);
	MOVF        FARG_buffer_save_send_buffer+0, 0 
	MOVWF       FARG_strlen_s+0 
	MOVF        FARG_buffer_save_send_buffer+1, 0 
	MOVWF       FARG_strlen_s+1 
	CALL        _strlen+0, 0
	MOVF        R0, 0 
	ADDLW       1
	MOVWF       FARG_mysql_write_roundTrip_bytes+0 
	MOVLW       _tableEventosTCP+0
	MOVWF       FARG_mysql_write_roundTrip_name+0 
	MOVLW       hi_addr(_tableEventosTCP+0)
	MOVWF       FARG_mysql_write_roundTrip_name+1 
	MOVLW       _eventosRegistro+0
	MOVWF       FARG_mysql_write_roundTrip_column+0 
	MOVLW       hi_addr(_eventosRegistro+0)
	MOVWF       FARG_mysql_write_roundTrip_column+1 
	MOVF        FARG_buffer_save_send_buffer+0, 0 
	MOVWF       FARG_mysql_write_roundTrip_texto+0 
	MOVF        FARG_buffer_save_send_buffer+1, 0 
	MOVWF       FARG_mysql_write_roundTrip_texto+1 
	CALL        _mysql_write_roundTrip+0, 0
;TPV.c,1817 :: 		mysql_read_forced(tableEventosTCP, eventosEstatus, myTable.rowAct, &estatus);
	MOVLW       _tableEventosTCP+0
	MOVWF       FARG_mysql_read_forced_name+0 
	MOVLW       hi_addr(_tableEventosTCP+0)
	MOVWF       FARG_mysql_read_forced_name+1 
	MOVLW       _eventosEstatus+0
	MOVWF       FARG_mysql_read_forced_column+0 
	MOVLW       hi_addr(_eventosEstatus+0)
	MOVWF       FARG_mysql_read_forced_column+1 
	MOVF        TPV_myTable+4, 0 
	MOVWF       FARG_mysql_read_forced_fila+0 
	MOVF        TPV_myTable+5, 0 
	MOVWF       FARG_mysql_read_forced_fila+1 
	MOVLW       buffer_save_send_estatus_L0+0
	MOVWF       FARG_mysql_read_forced_result+0 
	MOVLW       hi_addr(buffer_save_send_estatus_L0+0)
	MOVWF       FARG_mysql_read_forced_result+1 
	CALL        _mysql_read_forced+0, 0
;TPV.c,1819 :: 		if(estatus != '1')
	MOVF        buffer_save_send_estatus_L0+0, 0 
	XORLW       49
	BTFSC       STATUS+0, 2 
	GOTO        L_buffer_save_send940
;TPV.c,1820 :: 		pilaBufferTCP++;
	INFSNZ      _pilaBufferTCP+0, 1 
	INCF        _pilaBufferTCP+1, 1 
L_buffer_save_send940:
;TPV.c,1822 :: 		mysql_write_forced(tableEventosTCP, eventosEstatus, myTable.rowAct, "1", 1);
	MOVLW       _tableEventosTCP+0
	MOVWF       FARG_mysql_write_forced_name+0 
	MOVLW       hi_addr(_tableEventosTCP+0)
	MOVWF       FARG_mysql_write_forced_name+1 
	MOVLW       _eventosEstatus+0
	MOVWF       FARG_mysql_write_forced_column+0 
	MOVLW       hi_addr(_eventosEstatus+0)
	MOVWF       FARG_mysql_write_forced_column+1 
	MOVF        TPV_myTable+4, 0 
	MOVWF       FARG_mysql_write_forced_fila+0 
	MOVF        TPV_myTable+5, 0 
	MOVWF       FARG_mysql_write_forced_fila+1 
	MOVLW       ?lstr52_TPV+0
	MOVWF       FARG_mysql_write_forced_texto+0 
	MOVLW       hi_addr(?lstr52_TPV+0)
	MOVWF       FARG_mysql_write_forced_texto+1 
	MOVLW       1
	MOVWF       FARG_mysql_write_forced_bytes+0 
	CALL        _mysql_write_forced+0, 0
;TPV.c,1824 :: 		usart_write_text("FR: ");
	MOVLW       ?lstr53_TPV+0
	MOVWF       FARG_usart_write_text_texto+0 
	MOVLW       hi_addr(?lstr53_TPV+0)
	MOVWF       FARG_usart_write_text_texto+1 
	CALL        _usart_write_text+0, 0
;TPV.c,1825 :: 		inttostr(myTable.rowAct, msjConst);
	MOVF        TPV_myTable+4, 0 
	MOVWF       FARG_IntToStr_input+0 
	MOVF        TPV_myTable+5, 0 
	MOVWF       FARG_IntToStr_input+1 
	MOVLW       _msjConst+0
	MOVWF       FARG_IntToStr_output+0 
	MOVLW       hi_addr(_msjConst+0)
	MOVWF       FARG_IntToStr_output+1 
	CALL        _IntToStr+0, 0
;TPV.c,1826 :: 		usart_write_text(msjConst);
	MOVLW       _msjConst+0
	MOVWF       FARG_usart_write_text_texto+0 
	MOVLW       hi_addr(_msjConst+0)
	MOVWF       FARG_usart_write_text_texto+1 
	CALL        _usart_write_text+0, 0
;TPV.c,1827 :: 		usart_write_text(", FT: ");
	MOVLW       ?lstr54_TPV+0
	MOVWF       FARG_usart_write_text_texto+0 
	MOVLW       hi_addr(?lstr54_TPV+0)
	MOVWF       FARG_usart_write_text_texto+1 
	CALL        _usart_write_text+0, 0
;TPV.c,1828 :: 		inttostr(pilaBufferTCP, msjConst);
	MOVF        _pilaBufferTCP+0, 0 
	MOVWF       FARG_IntToStr_input+0 
	MOVF        _pilaBufferTCP+1, 0 
	MOVWF       FARG_IntToStr_input+1 
	MOVLW       _msjConst+0
	MOVWF       FARG_IntToStr_output+0 
	MOVLW       hi_addr(_msjConst+0)
	MOVWF       FARG_IntToStr_output+1 
	CALL        _IntToStr+0, 0
;TPV.c,1829 :: 		usart_write_text(msjConst);
	MOVLW       _msjConst+0
	MOVWF       FARG_usart_write_text_texto+0 
	MOVLW       hi_addr(_msjConst+0)
	MOVWF       FARG_usart_write_text_texto+1 
	CALL        _usart_write_text+0, 0
;TPV.c,1830 :: 		usart_write_line(", Registrado TCP");
	MOVLW       ?lstr55_TPV+0
	MOVWF       FARG_usart_write_line_texto+0 
	MOVLW       hi_addr(?lstr55_TPV+0)
	MOVWF       FARG_usart_write_line_texto+1 
	CALL        _usart_write_line+0, 0
;TPV.c,1831 :: 		}else{
	GOTO        L_buffer_save_send941
L_buffer_save_send938:
;TPV.c,1833 :: 		mysql_write_roundTrip(tableEventosCAN, eventosRegistro, buffer, string_len(buffer)+1);
	MOVF        FARG_buffer_save_send_buffer+0, 0 
	MOVWF       FARG_string_len_texto+0 
	MOVF        FARG_buffer_save_send_buffer+1, 0 
	MOVWF       FARG_string_len_texto+1 
	CALL        _string_len+0, 0
	MOVF        R0, 0 
	ADDLW       1
	MOVWF       FARG_mysql_write_roundTrip_bytes+0 
	MOVLW       _tableEventosCAN+0
	MOVWF       FARG_mysql_write_roundTrip_name+0 
	MOVLW       hi_addr(_tableEventosCAN+0)
	MOVWF       FARG_mysql_write_roundTrip_name+1 
	MOVLW       _eventosRegistro+0
	MOVWF       FARG_mysql_write_roundTrip_column+0 
	MOVLW       hi_addr(_eventosRegistro+0)
	MOVWF       FARG_mysql_write_roundTrip_column+1 
	MOVF        FARG_buffer_save_send_buffer+0, 0 
	MOVWF       FARG_mysql_write_roundTrip_texto+0 
	MOVF        FARG_buffer_save_send_buffer+1, 0 
	MOVWF       FARG_mysql_write_roundTrip_texto+1 
	CALL        _mysql_write_roundTrip+0, 0
;TPV.c,1834 :: 		mysql_read_forced(tableEventosCAN, eventosEstatus, myTable.rowAct, &estatus);
	MOVLW       _tableEventosCAN+0
	MOVWF       FARG_mysql_read_forced_name+0 
	MOVLW       hi_addr(_tableEventosCAN+0)
	MOVWF       FARG_mysql_read_forced_name+1 
	MOVLW       _eventosEstatus+0
	MOVWF       FARG_mysql_read_forced_column+0 
	MOVLW       hi_addr(_eventosEstatus+0)
	MOVWF       FARG_mysql_read_forced_column+1 
	MOVF        TPV_myTable+4, 0 
	MOVWF       FARG_mysql_read_forced_fila+0 
	MOVF        TPV_myTable+5, 0 
	MOVWF       FARG_mysql_read_forced_fila+1 
	MOVLW       buffer_save_send_estatus_L0+0
	MOVWF       FARG_mysql_read_forced_result+0 
	MOVLW       hi_addr(buffer_save_send_estatus_L0+0)
	MOVWF       FARG_mysql_read_forced_result+1 
	CALL        _mysql_read_forced+0, 0
;TPV.c,1836 :: 		if(estatus != '1')
	MOVF        buffer_save_send_estatus_L0+0, 0 
	XORLW       49
	BTFSC       STATUS+0, 2 
	GOTO        L_buffer_save_send942
;TPV.c,1837 :: 		pilaBufferCAN++;
	INFSNZ      _pilaBufferCAN+0, 1 
	INCF        _pilaBufferCAN+1, 1 
L_buffer_save_send942:
;TPV.c,1838 :: 		mysql_write_forced(tableEventosCAN, eventosEstatus, myTable.rowAct, "1", 1);
	MOVLW       _tableEventosCAN+0
	MOVWF       FARG_mysql_write_forced_name+0 
	MOVLW       hi_addr(_tableEventosCAN+0)
	MOVWF       FARG_mysql_write_forced_name+1 
	MOVLW       _eventosEstatus+0
	MOVWF       FARG_mysql_write_forced_column+0 
	MOVLW       hi_addr(_eventosEstatus+0)
	MOVWF       FARG_mysql_write_forced_column+1 
	MOVF        TPV_myTable+4, 0 
	MOVWF       FARG_mysql_write_forced_fila+0 
	MOVF        TPV_myTable+5, 0 
	MOVWF       FARG_mysql_write_forced_fila+1 
	MOVLW       ?lstr56_TPV+0
	MOVWF       FARG_mysql_write_forced_texto+0 
	MOVLW       hi_addr(?lstr56_TPV+0)
	MOVWF       FARG_mysql_write_forced_texto+1 
	MOVLW       1
	MOVWF       FARG_mysql_write_forced_bytes+0 
	CALL        _mysql_write_forced+0, 0
;TPV.c,1841 :: 		mysql_write_forced(tableEventosCAN, eventosModulos, myTable.rowAct, nodosCAN, string_len(nodosCAN)+1);
	MOVF        FARG_buffer_save_send_nodosCAN+0, 0 
	MOVWF       FARG_string_len_texto+0 
	MOVF        FARG_buffer_save_send_nodosCAN+1, 0 
	MOVWF       FARG_string_len_texto+1 
	CALL        _string_len+0, 0
	MOVF        R0, 0 
	ADDLW       1
	MOVWF       FARG_mysql_write_forced_bytes+0 
	MOVLW       _tableEventosCAN+0
	MOVWF       FARG_mysql_write_forced_name+0 
	MOVLW       hi_addr(_tableEventosCAN+0)
	MOVWF       FARG_mysql_write_forced_name+1 
	MOVLW       _eventosModulos+0
	MOVWF       FARG_mysql_write_forced_column+0 
	MOVLW       hi_addr(_eventosModulos+0)
	MOVWF       FARG_mysql_write_forced_column+1 
	MOVF        TPV_myTable+4, 0 
	MOVWF       FARG_mysql_write_forced_fila+0 
	MOVF        TPV_myTable+5, 0 
	MOVWF       FARG_mysql_write_forced_fila+1 
	MOVF        FARG_buffer_save_send_nodosCAN+0, 0 
	MOVWF       FARG_mysql_write_forced_texto+0 
	MOVF        FARG_buffer_save_send_nodosCAN+1, 0 
	MOVWF       FARG_mysql_write_forced_texto+1 
	CALL        _mysql_write_forced+0, 0
;TPV.c,1842 :: 		}
L_buffer_save_send941:
;TPV.c,1843 :: 		}
L_end_buffer_save_send:
	RETURN      0
; end of _buffer_save_send

_lcd_clean_row:

;TPV.c,1845 :: 		void lcd_clean_row(char fila){
;TPV.c,1846 :: 		char i = 20;
	MOVLW       20
	MOVWF       lcd_clean_row_i_L0+0 
;TPV.c,1848 :: 		while(i)
L_lcd_clean_row943:
	MOVF        lcd_clean_row_i_L0+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_lcd_clean_row944
;TPV.c,1849 :: 		lcd_chr(fila, i--, ' ');
	MOVF        FARG_lcd_clean_row_fila+0, 0 
	MOVWF       FARG_Lcd_Chr_row+0 
	MOVF        lcd_clean_row_i_L0+0, 0 
	MOVWF       FARG_Lcd_Chr_column+0 
	MOVLW       32
	MOVWF       FARG_Lcd_Chr_out_char+0 
	CALL        _Lcd_Chr+0, 0
	DECF        lcd_clean_row_i_L0+0, 1 
	GOTO        L_lcd_clean_row943
L_lcd_clean_row944:
;TPV.c,1850 :: 		}
L_end_lcd_clean_row:
	RETURN      0
; end of _lcd_clean_row

_int_timer1:

;TPV.c,1854 :: 		void int_timer1(){
;TPV.c,1857 :: 		if(PIR1.TMR1IF && PIE1.TMR1IE){
	BTFSS       PIR1+0, 0 
	GOTO        L_int_timer1947
	BTFSS       PIE1+0, 0 
	GOTO        L_int_timer1947
L__int_timer11022:
;TPV.c,1859 :: 		if(++temp >= 5){
	INCF        int_timer1_temp_L0+0, 1 
	MOVLW       5
	SUBWF       int_timer1_temp_L0+0, 0 
	BTFSS       STATUS+0, 0 
	GOTO        L_int_timer1948
;TPV.c,1860 :: 		temp = 0;
	CLRF        int_timer1_temp_L0+0 
;TPV.c,1861 :: 		SALIDA_RELE1 = 0;  //APAGAR RELE DESPUES DE UN SEGUNDO
	BCF         PORTA+0, 5 
;TPV.c,1862 :: 		PIE1.TMR1IE = 0;  //DESACTIVAR EL TIMER1
	BCF         PIE1+0, 0 
;TPV.c,1863 :: 		}
L_int_timer1948:
;TPV.c,1866 :: 		TMR1H = getByte(sampler1,1);
	MOVF        _sampler1+1, 0 
	MOVWF       TMR1H+0 
;TPV.c,1867 :: 		TMR1L = getByte(sampler1,0);
	MOVF        _sampler1+0, 0 
	MOVWF       TMR1L+0 
;TPV.c,1868 :: 		PIR1.TMR1IF = 0;   //LIMPIAR BANDERA
	BCF         PIR1+0, 0 
;TPV.c,1869 :: 		}
L_int_timer1947:
;TPV.c,1870 :: 		}
L_end_int_timer1:
	RETURN      0
; end of _int_timer1

_int_timer3:

;TPV.c,1872 :: 		void int_timer3(){
;TPV.c,1875 :: 		if(PIR2.TMR3IF && PIE2.TMR3IE){
	BTFSS       PIR2+0, 1 
	GOTO        L_int_timer3951
	BTFSS       PIE2+0, 1 
	GOTO        L_int_timer3951
L__int_timer31023:
;TPV.c,1876 :: 		can.temp += 200;     //Can protocol
	MOVLW       200
	ADDWF       _can+173, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      _can+174, 0 
	MOVWF       R1 
	MOVF        R0, 0 
	MOVWF       _can+173 
	MOVF        R1, 0 
	MOVWF       _can+174 
;TPV.c,1877 :: 		flagTMR3.B0 = true;  //CADA XMS
	BSF         _flagTMR3+0, 0 
;TPV.c,1879 :: 		if(++temp >= 5){
	INCF        int_timer3_temp_L0+0, 1 
	MOVLW       5
	SUBWF       int_timer3_temp_L0+0, 0 
	BTFSS       STATUS+0, 0 
	GOTO        L_int_timer3952
;TPV.c,1880 :: 		temp = 0;
	CLRF        int_timer3_temp_L0+0 
;TPV.c,1881 :: 		flagSecondTMR3.B0 = true;
	BSF         _flagSecondTMR3+0, 0 
;TPV.c,1882 :: 		Net_Ethernet_28j60_UserTimerSec++;    //Para el protocolo tcp
	MOVLW       1
	ADDWF       _Net_Ethernet_28j60_UserTimerSec+0, 1 
	MOVLW       0
	ADDWFC      _Net_Ethernet_28j60_UserTimerSec+1, 1 
	ADDWFC      _Net_Ethernet_28j60_UserTimerSec+2, 1 
	ADDWFC      _Net_Ethernet_28j60_UserTimerSec+3, 1 
;TPV.c,1883 :: 		}
L_int_timer3952:
;TPV.c,1885 :: 		TMR3H = getByte(sampler3,1);
	MOVF        _sampler3+1, 0 
	MOVWF       TMR3H+0 
;TPV.c,1886 :: 		TMR3L = getByte(sampler3,0);
	MOVF        _sampler3+0, 0 
	MOVWF       TMR3L+0 
;TPV.c,1887 :: 		PIR2.TMR3IF = 0;   //LIMPÍAR BANDERA
	BCF         PIR2+0, 1 
;TPV.c,1888 :: 		}
L_int_timer3951:
;TPV.c,1889 :: 		}
L_end_int_timer3:
	RETURN      0
; end of _int_timer3
