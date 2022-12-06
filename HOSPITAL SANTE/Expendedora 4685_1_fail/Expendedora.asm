
_bcdToDec:

;miscelaneos.h,17 :: 		char bcdToDec(char dato){
;miscelaneos.h,18 :: 		dato = 10*(swap(dato)&0x0F) + (dato&0x0F);
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
;miscelaneos.h,20 :: 		return dato;
;miscelaneos.h,21 :: 		}
L_end_bcdToDec:
	RETURN      0
; end of _bcdToDec

_decToBcd:

;miscelaneos.h,23 :: 		char decToBcd(char dato){
;miscelaneos.h,24 :: 		dato = swap(dato/10) + (dato%10);
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
;miscelaneos.h,26 :: 		return dato;
;miscelaneos.h,27 :: 		}
L_end_decToBcd:
	RETURN      0
; end of _decToBcd

_RomToRam:

;miscelaneos.h,29 :: 		char* RomToRam(const char *origen, char *destino){
;miscelaneos.h,30 :: 		unsigned int cont = 0;
	CLRF        RomToRam_cont_L0+0 
	CLRF        RomToRam_cont_L0+1 
;miscelaneos.h,32 :: 		while(destino[cont] = origen[cont++]);
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
;miscelaneos.h,34 :: 		return destino;
	MOVF        FARG_RomToRam_destino+0, 0 
	MOVWF       R0 
	MOVF        FARG_RomToRam_destino+1, 0 
	MOVWF       R1 
;miscelaneos.h,35 :: 		}
L_end_RomToRam:
	RETURN      0
; end of _RomToRam

_clamp:

;miscelaneos.h,37 :: 		long clamp(long valor, long min, long max){
;miscelaneos.h,38 :: 		if(valor > max)
	MOVLW       128
	XORWF       FARG_clamp_max+3, 0 
	MOVWF       R0 
	MOVLW       128
	XORWF       FARG_clamp_valor+3, 0 
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__clamp990
	MOVF        FARG_clamp_valor+2, 0 
	SUBWF       FARG_clamp_max+2, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__clamp990
	MOVF        FARG_clamp_valor+1, 0 
	SUBWF       FARG_clamp_max+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__clamp990
	MOVF        FARG_clamp_valor+0, 0 
	SUBWF       FARG_clamp_max+0, 0 
L__clamp990:
	BTFSC       STATUS+0, 0 
	GOTO        L_clamp2
;miscelaneos.h,39 :: 		valor = max;
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
;miscelaneos.h,40 :: 		else if(valor < min)
	MOVLW       128
	XORWF       FARG_clamp_valor+3, 0 
	MOVWF       R0 
	MOVLW       128
	XORWF       FARG_clamp_min+3, 0 
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__clamp991
	MOVF        FARG_clamp_min+2, 0 
	SUBWF       FARG_clamp_valor+2, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__clamp991
	MOVF        FARG_clamp_min+1, 0 
	SUBWF       FARG_clamp_valor+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__clamp991
	MOVF        FARG_clamp_min+0, 0 
	SUBWF       FARG_clamp_valor+0, 0 
L__clamp991:
	BTFSC       STATUS+0, 0 
	GOTO        L_clamp4
;miscelaneos.h,41 :: 		valor = min;
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
;miscelaneos.h,43 :: 		return valor;
	MOVF        FARG_clamp_valor+0, 0 
	MOVWF       R0 
	MOVF        FARG_clamp_valor+1, 0 
	MOVWF       R1 
	MOVF        FARG_clamp_valor+2, 0 
	MOVWF       R2 
	MOVF        FARG_clamp_valor+3, 0 
	MOVWF       R3 
;miscelaneos.h,44 :: 		}
L_end_clamp:
	RETURN      0
; end of _clamp

_clamp_shift:

;miscelaneos.h,46 :: 		long clamp_shift(long valor, long min, long max){
;miscelaneos.h,47 :: 		if(valor > max)
	MOVLW       128
	XORWF       FARG_clamp_shift_max+3, 0 
	MOVWF       R0 
	MOVLW       128
	XORWF       FARG_clamp_shift_valor+3, 0 
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__clamp_shift993
	MOVF        FARG_clamp_shift_valor+2, 0 
	SUBWF       FARG_clamp_shift_max+2, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__clamp_shift993
	MOVF        FARG_clamp_shift_valor+1, 0 
	SUBWF       FARG_clamp_shift_max+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__clamp_shift993
	MOVF        FARG_clamp_shift_valor+0, 0 
	SUBWF       FARG_clamp_shift_max+0, 0 
L__clamp_shift993:
	BTFSC       STATUS+0, 0 
	GOTO        L_clamp_shift5
;miscelaneos.h,48 :: 		valor = min;
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
;miscelaneos.h,49 :: 		else if(valor < min)
	MOVLW       128
	XORWF       FARG_clamp_shift_valor+3, 0 
	MOVWF       R0 
	MOVLW       128
	XORWF       FARG_clamp_shift_min+3, 0 
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__clamp_shift994
	MOVF        FARG_clamp_shift_min+2, 0 
	SUBWF       FARG_clamp_shift_valor+2, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__clamp_shift994
	MOVF        FARG_clamp_shift_min+1, 0 
	SUBWF       FARG_clamp_shift_valor+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__clamp_shift994
	MOVF        FARG_clamp_shift_min+0, 0 
	SUBWF       FARG_clamp_shift_valor+0, 0 
L__clamp_shift994:
	BTFSC       STATUS+0, 0 
	GOTO        L_clamp_shift7
;miscelaneos.h,50 :: 		valor = max;
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
;miscelaneos.h,52 :: 		return valor;
	MOVF        FARG_clamp_shift_valor+0, 0 
	MOVWF       R0 
	MOVF        FARG_clamp_shift_valor+1, 0 
	MOVWF       R1 
	MOVF        FARG_clamp_shift_valor+2, 0 
	MOVWF       R2 
	MOVF        FARG_clamp_shift_valor+3, 0 
	MOVWF       R3 
;miscelaneos.h,53 :: 		}
L_end_clamp_shift:
	RETURN      0
; end of _clamp_shift

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
L__string_cpyn906:
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
	GOTO        L__string_cmp907
	MOVF        string_cmp_cont_L0+0, 0 
	ADDWF       FARG_string_cmp_text2+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_string_cmp_text2+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	XORLW       0
	BTFSC       STATUS+0, 2 
	GOTO        L__string_cmp907
	GOTO        L_string_cmp38
L__string_cmp907:
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
	GOTO        L__string_cmpc908
	MOVF        string_cmpc_cont_L0+0, 0 
	ADDWF       FARG_string_cmpc_text2+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_string_cmpc_text2+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	XORLW       0
	BTFSC       STATUS+0, 2 
	GOTO        L__string_cmpc908
	GOTO        L_string_cmpc46
L__string_cmpc908:
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
	GOTO        L__string_isNumeric909
	MOVF        string_isNumeric_cont_L0+0, 0 
	ADDWF       FARG_string_isNumeric_cadena+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_string_isNumeric_cadena+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	SUBLW       57
	BTFSS       STATUS+0, 0 
	GOTO        L__string_isNumeric909
	GOTO        L_string_isNumeric60
L__string_isNumeric909:
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
L__stringToNumN910:
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
L__hexToNum914:
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
L__hexToNum913:
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
L__hexToNum912:
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
L__hexToNum911:
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
L__string_toUpper915:
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
	GOTO        L__timer1_open1015
	MOVLW       1
	SUBWF       FARG_timer1_open_time_us+2, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__timer1_open1015
	MOVLW       0
	SUBWF       FARG_timer1_open_time_us+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__timer1_open1015
	MOVLW       0
	SUBWF       FARG_timer1_open_time_us+0, 0 
L__timer1_open1015:
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
	GOTO        L__timer1_open1016
	BTFSS       STATUS+0, 0 
	GOTO        L__timer1_open1016
	MOVLW       1
	ADDWF       FARG_timer1_open_time_us+0, 1 
	MOVLW       0
	ADDWFC      FARG_timer1_open_time_us+1, 1 
	ADDWFC      FARG_timer1_open_time_us+2, 1 
	ADDWFC      FARG_timer1_open_time_us+3, 1 
L__timer1_open1016:
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
	GOTO        L__timer1_open1017
	BCF         T1CON+0, 4 
	GOTO        L__timer1_open1018
L__timer1_open1017:
	BSF         T1CON+0, 4 
L__timer1_open1018:
;lib_timer1.h,29 :: 		T1CON.T1CKPS1 = i.B1;   //PRESCALER
	BTFSC       timer1_open_i_L0+0, 1 
	GOTO        L__timer1_open1019
	BCF         T1CON+0, 5 
	GOTO        L__timer1_open1020
L__timer1_open1019:
	BSF         T1CON+0, 5 
L__timer1_open1020:
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
	GOTO        L__timer1_open1021
	BCF         PIE1+0, 0 
	GOTO        L__timer1_open1022
L__timer1_open1021:
	BSF         PIE1+0, 0 
L__timer1_open1022:
;lib_timer1.h,41 :: 		IPR1.TMR1IP = priorityHigh; //TIPO DE PRIORIDAD
	BTFSC       FARG_timer1_open_priorityHigh+0, 0 
	GOTO        L__timer1_open1023
	BCF         IPR1+0, 0 
	GOTO        L__timer1_open1024
L__timer1_open1023:
	BSF         IPR1+0, 0 
L__timer1_open1024:
;lib_timer1.h,42 :: 		T1CON.TMR1ON = powerOn;     //ENCENDER TIMER
	BTFSC       FARG_timer1_open_powerOn+0, 0 
	GOTO        L__timer1_open1025
	BCF         T1CON+0, 0 
	GOTO        L__timer1_open1026
L__timer1_open1025:
	BSF         T1CON+0, 0 
L__timer1_open1026:
;lib_timer1.h,43 :: 		}
L_end_timer1_open:
	RETURN      0
; end of _timer1_open

_timer1_enable:

;lib_timer1.h,45 :: 		void timer1_enable(bool enable){
;lib_timer1.h,46 :: 		PIE1.TMR1IE = enable;
	BTFSC       FARG_timer1_enable_enable+0, 0 
	GOTO        L__timer1_enable1028
	BCF         PIE1+0, 0 
	GOTO        L__timer1_enable1029
L__timer1_enable1028:
	BSF         PIE1+0, 0 
L__timer1_enable1029:
;lib_timer1.h,47 :: 		}
L_end_timer1_enable:
	RETURN      0
; end of _timer1_enable

_timer1_power:

;lib_timer1.h,49 :: 		void timer1_power(bool on){
;lib_timer1.h,50 :: 		T1CON.TMR1ON = on; //ENCENDER TIMER
	BTFSC       FARG_timer1_power_on+0, 0 
	GOTO        L__timer1_power1031
	BCF         T1CON+0, 0 
	GOTO        L__timer1_power1032
L__timer1_power1031:
	BSF         T1CON+0, 0 
L__timer1_power1032:
;lib_timer1.h,51 :: 		}
L_end_timer1_power:
	RETURN      0
; end of _timer1_power

_timer1_priority:

;lib_timer1.h,53 :: 		void timer1_priority(bool hihg){
;lib_timer1.h,54 :: 		IPR1.TMR1IP = hihg; //TIPO DE PRIORIDAD
	BTFSC       FARG_timer1_priority_hihg+0, 0 
	GOTO        L__timer1_priority1034
	BCF         IPR1+0, 0 
	GOTO        L__timer1_priority1035
L__timer1_priority1034:
	BSF         IPR1+0, 0 
L__timer1_priority1035:
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
	GOTO        L__timer2_open1038
	MOVF        R2, 0 
	SUBLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L__timer2_open1038
	MOVF        R1, 0 
	SUBLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L__timer2_open1038
	MOVF        R0, 0 
	SUBLW       255
L__timer2_open1038:
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
	GOTO        L__timer2_open1039
	BCF         T2CON+0, 0 
	GOTO        L__timer2_open1040
L__timer2_open1039:
	BSF         T2CON+0, 0 
L__timer2_open1040:
;lib_timer2.h,33 :: 		T2CON.T2CKPS1 = auxPre.B1;  //Prescaler
	BTFSC       timer2_open_auxPre_L0+0, 1 
	GOTO        L__timer2_open1041
	BCF         T2CON+0, 1 
	GOTO        L__timer2_open1042
L__timer2_open1041:
	BSF         T2CON+0, 1 
L__timer2_open1042:
;lib_timer2.h,34 :: 		post--;
	DECF        timer2_open_post_L0+0, 1 
;lib_timer2.h,35 :: 		T2CON.T2OUTPS0 = post.B0;   //Postcaler
	BTFSC       timer2_open_post_L0+0, 0 
	GOTO        L__timer2_open1043
	BCF         T2CON+0, 3 
	GOTO        L__timer2_open1044
L__timer2_open1043:
	BSF         T2CON+0, 3 
L__timer2_open1044:
;lib_timer2.h,36 :: 		T2CON.T2OUTPS1 = post.B1;   //Postcaler
	BTFSC       timer2_open_post_L0+0, 1 
	GOTO        L__timer2_open1045
	BCF         T2CON+0, 4 
	GOTO        L__timer2_open1046
L__timer2_open1045:
	BSF         T2CON+0, 4 
L__timer2_open1046:
;lib_timer2.h,37 :: 		T2CON.T2OUTPS2 = post.B2;   //Postcaler
	BTFSC       timer2_open_post_L0+0, 2 
	GOTO        L__timer2_open1047
	BCF         T2CON+0, 5 
	GOTO        L__timer2_open1048
L__timer2_open1047:
	BSF         T2CON+0, 5 
L__timer2_open1048:
;lib_timer2.h,38 :: 		T2CON.T2OUTPS3 = post.B3;   //Postcaler
	BTFSC       timer2_open_post_L0+0, 3 
	GOTO        L__timer2_open1049
	BCF         T2CON+0, 6 
	GOTO        L__timer2_open1050
L__timer2_open1049:
	BSF         T2CON+0, 6 
L__timer2_open1050:
;lib_timer2.h,41 :: 		TMR2 = 0;
	CLRF        TMR2+0 
;lib_timer2.h,44 :: 		PIR1.TMR2IF = 0;            //LIMPIAR BANDERA
	BCF         PIR1+0, 1 
;lib_timer2.h,45 :: 		PIE1.TMR2IE = enable;       //ACTIVAR O DESACTIVAR TIMER
	BTFSC       FARG_timer2_open_enable+0, 0 
	GOTO        L__timer2_open1051
	BCF         PIE1+0, 1 
	GOTO        L__timer2_open1052
L__timer2_open1051:
	BSF         PIE1+0, 1 
L__timer2_open1052:
;lib_timer2.h,46 :: 		IPR1.TMR2IP = priorityHigh; //TIPO DE PRIORIDAD
	BTFSC       FARG_timer2_open_priorityHigh+0, 0 
	GOTO        L__timer2_open1053
	BCF         IPR1+0, 1 
	GOTO        L__timer2_open1054
L__timer2_open1053:
	BSF         IPR1+0, 1 
L__timer2_open1054:
;lib_timer2.h,47 :: 		T2CON.TMR2ON = powerOn;     //ENCENDER TIMER
	BTFSC       FARG_timer2_open_powerOn+0, 0 
	GOTO        L__timer2_open1055
	BCF         T2CON+0, 2 
	GOTO        L__timer2_open1056
L__timer2_open1055:
	BSF         T2CON+0, 2 
L__timer2_open1056:
;lib_timer2.h,48 :: 		}
L_end_timer2_open:
	RETURN      0
; end of _timer2_open

_timer2_enable:

;lib_timer2.h,50 :: 		void timer2_enable(bool enable){
;lib_timer2.h,51 :: 		PIE1.TMR2IE = enable;       //ACTIVAR O DESACTIVAR TIMER
	BTFSC       FARG_timer2_enable_enable+0, 0 
	GOTO        L__timer2_enable1058
	BCF         PIE1+0, 1 
	GOTO        L__timer2_enable1059
L__timer2_enable1058:
	BSF         PIE1+0, 1 
L__timer2_enable1059:
;lib_timer2.h,52 :: 		}
L_end_timer2_enable:
	RETURN      0
; end of _timer2_enable

_timer2_power:

;lib_timer2.h,54 :: 		void timer2_power(bool on){
;lib_timer2.h,55 :: 		T2CON.TMR2ON = on;     //ENCENDER TIMER
	BTFSC       FARG_timer2_power_on+0, 0 
	GOTO        L__timer2_power1061
	BCF         T2CON+0, 2 
	GOTO        L__timer2_power1062
L__timer2_power1061:
	BSF         T2CON+0, 2 
L__timer2_power1062:
;lib_timer2.h,56 :: 		}
L_end_timer2_power:
	RETURN      0
; end of _timer2_power

_timer2_priority:

;lib_timer2.h,58 :: 		void timer2_priority(bool hihg){
;lib_timer2.h,59 :: 		IPR1.TMR2IP = hihg; //TIPO DE PRIORIDAD
	BTFSC       FARG_timer2_priority_hihg+0, 0 
	GOTO        L__timer2_priority1064
	BCF         IPR1+0, 1 
	GOTO        L__timer2_priority1065
L__timer2_priority1064:
	BSF         IPR1+0, 1 
L__timer2_priority1065:
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
	GOTO        L__timer3_open1067
	MOVLW       1
	SUBWF       FARG_timer3_open_time_us+2, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__timer3_open1067
	MOVLW       0
	SUBWF       FARG_timer3_open_time_us+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__timer3_open1067
	MOVLW       0
	SUBWF       FARG_timer3_open_time_us+0, 0 
L__timer3_open1067:
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
	GOTO        L__timer3_open1068
	BTFSS       STATUS+0, 0 
	GOTO        L__timer3_open1068
	MOVLW       1
	ADDWF       FARG_timer3_open_time_us+0, 1 
	MOVLW       0
	ADDWFC      FARG_timer3_open_time_us+1, 1 
	ADDWFC      FARG_timer3_open_time_us+2, 1 
	ADDWFC      FARG_timer3_open_time_us+3, 1 
L__timer3_open1068:
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
	GOTO        L__timer3_open1069
	BCF         T3CON+0, 4 
	GOTO        L__timer3_open1070
L__timer3_open1069:
	BSF         T3CON+0, 4 
L__timer3_open1070:
;lib_timer3.h,31 :: 		T3CON.T3CKPS1 = i.B1;   //PRESCALER
	BTFSC       timer3_open_i_L0+0, 1 
	GOTO        L__timer3_open1071
	BCF         T3CON+0, 5 
	GOTO        L__timer3_open1072
L__timer3_open1071:
	BSF         T3CON+0, 5 
L__timer3_open1072:
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
	GOTO        L__timer3_open1073
	BCF         PIE2+0, 1 
	GOTO        L__timer3_open1074
L__timer3_open1073:
	BSF         PIE2+0, 1 
L__timer3_open1074:
;lib_timer3.h,42 :: 		IPR2.TMR3IP = priorityHigh; //TIPO DE PRIORIDAD
	BTFSC       FARG_timer3_open_priorityHigh+0, 0 
	GOTO        L__timer3_open1075
	BCF         IPR2+0, 1 
	GOTO        L__timer3_open1076
L__timer3_open1075:
	BSF         IPR2+0, 1 
L__timer3_open1076:
;lib_timer3.h,43 :: 		T3CON.TMR3ON = powerOn;     //ENCENDER TIMER
	BTFSC       FARG_timer3_open_powerOn+0, 0 
	GOTO        L__timer3_open1077
	BCF         T3CON+0, 0 
	GOTO        L__timer3_open1078
L__timer3_open1077:
	BSF         T3CON+0, 0 
L__timer3_open1078:
;lib_timer3.h,44 :: 		}
L_end_timer3_open:
	RETURN      0
; end of _timer3_open

_timer3_enable:

;lib_timer3.h,46 :: 		void timer3_enable(bool enable){
;lib_timer3.h,47 :: 		PIE3.TMR3IE = enable;
	BTFSC       FARG_timer3_enable_enable+0, 0 
	GOTO        L__timer3_enable1080
	BCF         PIE3+0, 1 
	GOTO        L__timer3_enable1081
L__timer3_enable1080:
	BSF         PIE3+0, 1 
L__timer3_enable1081:
;lib_timer3.h,48 :: 		}
L_end_timer3_enable:
	RETURN      0
; end of _timer3_enable

_timer3_power:

;lib_timer3.h,50 :: 		void timer3_power(bool on){
;lib_timer3.h,51 :: 		T3CON.TMR3ON = on; //ENCENDER TIMER
	BTFSC       FARG_timer3_power_on+0, 0 
	GOTO        L__timer3_power1083
	BCF         T3CON+0, 0 
	GOTO        L__timer3_power1084
L__timer3_power1083:
	BSF         T3CON+0, 0 
L__timer3_power1084:
;lib_timer3.h,52 :: 		}
L_end_timer3_power:
	RETURN      0
; end of _timer3_power

_timer3_priority:

;lib_timer3.h,54 :: 		void timer3_priority(bool hihg){
;lib_timer3.h,55 :: 		IPR2.TMR3IP = hihg; //TIPO DE PRIORIDAD
	BTFSC       FARG_timer3_priority_hihg+0, 0 
	GOTO        L__timer3_priority1086
	BCF         IPR2+0, 1 
	GOTO        L__timer3_priority1087
L__timer3_priority1086:
	BSF         IPR2+0, 1 
L__timer3_priority1087:
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
	GOTO        L__usart_enable_rx1094
	BCF         IPR1+0, 5 
	GOTO        L__usart_enable_rx1095
L__usart_enable_rx1094:
	BSF         IPR1+0, 5 
L__usart_enable_rx1095:
;lib_usart.h,131 :: 		PIR1.RCIF = 0;
	BCF         PIR1+0, 5 
;lib_usart.h,132 :: 		PIE1.RCIE = enable;
	BTFSC       FARG_usart_enable_rx_enable+0, 0 
	GOTO        L__usart_enable_rx1096
	BCF         PIE1+0, 5 
	GOTO        L__usart_enable_rx1097
L__usart_enable_rx1096:
	BSF         PIE1+0, 5 
L__usart_enable_rx1097:
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
	GOTO        L__usart_enable_tx1099
	BCF         IPR1+0, 4 
	GOTO        L__usart_enable_tx1100
L__usart_enable_tx1099:
	BSF         IPR1+0, 4 
L__usart_enable_tx1100:
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
L__usart_write_text_int916:
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
L__int_usart_rx917:
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
	GOTO        L__int_usart_rx1104
	BCF         _usart+34, 0 
	GOTO        L__int_usart_rx1105
L__int_usart_rx1104:
	BSF         _usart+34, 0 
L__int_usart_rx1105:
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
L__int_usart_tx918:
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
L__can_write_text919:
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
	GOTO        L__can_do_write_message1109
	MOVLW       184
	SUBWF       _can+173, 0 
L__can_do_write_message1109:
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
	MOVWF       ?FLOC___can_do_write_messageT670+0 
	GOTO        L_can_do_write_message162
L_can_do_write_message161:
	MOVLW       2
	MOVWF       ?FLOC___can_do_write_messageT670+0 
L_can_do_write_message162:
	MOVF        ?FLOC___can_do_write_messageT670+0, 0 
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
L__can_do_write_message920:
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
	GOTO        L__can_do_write_message1110
	MOVF        can_do_write_message_id_L0+2, 0 
	XORWF       _can+6, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__can_do_write_message1110
	MOVF        can_do_write_message_id_L0+1, 0 
	XORWF       _can+5, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__can_do_write_message1110
	MOVF        can_do_write_message_id_L0+0, 0 
	XORWF       _can+4, 0 
L__can_do_write_message1110:
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
	MOVWF       ?FLOC___can_do_write_messageT701+0 
	GOTO        L_can_do_write_message175
L_can_do_write_message174:
	MOVLW       1
	MOVWF       ?FLOC___can_do_write_messageT701+0 
L_can_do_write_message175:
	MOVF        ?FLOC___can_do_write_messageT701+0, 0 
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
	GOTO        L__can_do_read_message1112
	MOVLW       184
	SUBWF       _can+173, 0 
L__can_do_read_message1112:
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
	GOTO        L__can_do_read_message1113
	MOVF        can_do_read_message_id_L0+2, 0 
	XORWF       _can+6, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__can_do_read_message1113
	MOVF        can_do_read_message_id_L0+1, 0 
	XORWF       _can+5, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__can_do_read_message1113
	MOVF        can_do_read_message_id_L0+0, 0 
	XORWF       _can+4, 0 
L__can_do_read_message1113:
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
	GOTO        L__can_do_read_message1114
	MOVLW       63
	SUBWF       can_do_read_message_len_L0+0, 0 
L__can_do_read_message1114:
	BTFSC       STATUS+0, 0 
	GOTO        L_can_do_read_message198
L__can_do_read_message921:
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
	GOTO        L__can_set_baud1117
	MOVLW       0
	XORWF       R0, 0 
L__can_set_baud1117:
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
L__can_set_baud922:
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
	GOTO        L__can_set_baud1118
	BCF         BRGCON2+0, 3 
	GOTO        L__can_set_baud1119
L__can_set_baud1118:
	BSF         BRGCON2+0, 3 
L__can_set_baud1119:
;lib_can.h,432 :: 		BRGCON2.SEG1PH1 = pre.B1;
	BTFSC       can_set_baud_pre_L0+0, 1 
	GOTO        L__can_set_baud1120
	BCF         BRGCON2+0, 4 
	GOTO        L__can_set_baud1121
L__can_set_baud1120:
	BSF         BRGCON2+0, 4 
L__can_set_baud1121:
;lib_can.h,433 :: 		BRGCON2.SEG1PH2 = pre.B2;
	BTFSC       can_set_baud_pre_L0+0, 2 
	GOTO        L__can_set_baud1122
	BCF         BRGCON2+0, 5 
	GOTO        L__can_set_baud1123
L__can_set_baud1122:
	BSF         BRGCON2+0, 5 
L__can_set_baud1123:
;lib_can.h,435 :: 		BRGCON3.WAKDIS = !CAN_WAKE_UP_IN_ACTIVITY;
	BCF         BRGCON3+0, 7 
;lib_can.h,436 :: 		BRGCON3.WAKFIL = CAN_LINE_FILTER_ON;
	BCF         BRGCON3+0, 6 
;lib_can.h,437 :: 		BRGCON3.SEG2PH0 = pre.B0;
	BTFSC       can_set_baud_pre_L0+0, 0 
	GOTO        L__can_set_baud1124
	BCF         BRGCON3+0, 0 
	GOTO        L__can_set_baud1125
L__can_set_baud1124:
	BSF         BRGCON3+0, 0 
L__can_set_baud1125:
;lib_can.h,438 :: 		BRGCON3.SEG2PH1 = pre.B1;
	BTFSC       can_set_baud_pre_L0+0, 1 
	GOTO        L__can_set_baud1126
	BCF         BRGCON3+0, 1 
	GOTO        L__can_set_baud1127
L__can_set_baud1126:
	BSF         BRGCON3+0, 1 
L__can_set_baud1127:
;lib_can.h,439 :: 		BRGCON3.SEG2PH2 = pre.B2;
	BTFSC       can_set_baud_pre_L0+0, 2 
	GOTO        L__can_set_baud1128
	BCF         BRGCON3+0, 2 
	GOTO        L__can_set_baud1129
L__can_set_baud1128:
	BSF         BRGCON3+0, 2 
L__can_set_baud1129:
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
	GOTO        L__can_set_baud1130
	BCF         BRGCON2+0, 0 
	GOTO        L__can_set_baud1131
L__can_set_baud1130:
	BSF         BRGCON2+0, 0 
L__can_set_baud1131:
;lib_can.h,444 :: 		BRGCON2.PRSEG1 = pre.B1;
	BTFSC       can_set_baud_pre_L0+0, 1 
	GOTO        L__can_set_baud1132
	BCF         BRGCON2+0, 1 
	GOTO        L__can_set_baud1133
L__can_set_baud1132:
	BSF         BRGCON2+0, 1 
L__can_set_baud1133:
;lib_can.h,445 :: 		BRGCON2.PRSEG2 = pre.B2;
	BTFSC       can_set_baud_pre_L0+0, 2 
	GOTO        L__can_set_baud1134
	BCF         BRGCON2+0, 2 
	GOTO        L__can_set_baud1135
L__can_set_baud1134:
	BSF         BRGCON2+0, 2 
L__can_set_baud1135:
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
	CLRF        ?FLOC___can_readT862+0 
	GOTO        L_can_read218
L_can_read217:
	MOVLW       16
	MOVWF       ?FLOC___can_readT862+0 
L_can_read218:
	MOVF        ?FLOC___can_readT862+0, 0 
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
	MOVWF       ?FLOC___can_readT875+0 
	GOTO        L_can_read224
L_can_read223:
	MOVLW       16
	MOVWF       ?FLOC___can_readT875+0 
L_can_read224:
	MOVF        ?FLOC___can_readT875+0, 0 
	MOVWF       can_read_ref_L0+0 
;lib_can.h,475 :: 		ref |= can.mode == CAN_MODE_ENHANCED_LEGACY? 0x01:0x00;
	MOVF        _can+14, 0 
	XORLW       1
	BTFSS       STATUS+0, 2 
	GOTO        L_can_read225
	MOVLW       1
	MOVWF       ?FLOC___can_readT877+0 
	GOTO        L_can_read226
L_can_read225:
	CLRF        ?FLOC___can_readT877+0 
L_can_read226:
	MOVF        ?FLOC___can_readT877+0, 0 
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
	MOVWF       ?FLOC___can_readT885+0 
	GOTO        L_can_read229
L_can_read228:
	MOVLW       255
	MOVWF       ?FLOC___can_readT885+0 
L_can_read229:
	MOVF        ?FLOC___can_readT885+0, 0 
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
L__can_read929:
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
L__can_read928:
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
L__can_read927:
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
L__can_read926:
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
L__can_read925:
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
L__can_read924:
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
L__can_read923:
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
	GOTO        L__can_read1137
	MOVLW       RXB0CON+0
	XORWF       can_read_bufferBX_L0+0, 0 
L__can_read1137:
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
	GOTO        L__can_read1138
	MOVLW       RXB1CON+0
	XORWF       can_read_bufferBX_L0+0, 0 
L__can_read1138:
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
	MOVWF       ?FLOC___can_writeT1004+0 
	GOTO        L_can_write274
L_can_write273:
	MOVLW       3
	MOVWF       ?FLOC___can_writeT1004+0 
L_can_write274:
	MOVF        ?FLOC___can_writeT1004+0, 0 
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
	MOVWF       ?FLOC___can_writeT1012+0 
	GOTO        L_can_write278
L_can_write277:
	MOVLW       4
	MOVWF       ?FLOC___can_writeT1012+0 
L_can_write278:
	MOVF        ?FLOC___can_writeT1012+0, 0 
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
	MOVWF       ?FLOC___can_writeT1020+0 
	GOTO        L_can_write282
L_can_write281:
	MOVLW       5
	MOVWF       ?FLOC___can_writeT1020+0 
L_can_write282:
	MOVF        ?FLOC___can_writeT1020+0, 0 
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
L__can_write936:
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
L__can_write935:
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
L__can_write934:
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
L__can_write933:
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
L__can_write932:
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
L__can_write931:
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
	GOTO        L__can_write1140
	BCF         POSTINC1+0, 0 
	GOTO        L__can_write1141
L__can_write1140:
	BSF         POSTINC1+0, 0 
L__can_write1141:
;lib_can.h,669 :: 		(*transmisor).B1 = priority.B1;  //BIT TXPRI1
	MOVFF       can_write_transmisor_L0+0, FSR1
	MOVFF       can_write_transmisor_L0+1, FSR1H
	BTFSC       FARG_can_write_priority+0, 1 
	GOTO        L__can_write1142
	BCF         POSTINC1+0, 1 
	GOTO        L__can_write1143
L__can_write1142:
	BSF         POSTINC1+0, 1 
L__can_write1143:
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
	GOTO        L__can_write1144
	BCF         POSTINC1+0, 6 
	GOTO        L__can_write1145
L__can_write1144:
	BSF         POSTINC1+0, 6 
L__can_write1145:
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
L__can_write930:
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
	GOTO        L__can_set_operation1147
	BCF         CANCON+0, 5 
	GOTO        L__can_set_operation1148
L__can_set_operation1147:
	BSF         CANCON+0, 5 
L__can_set_operation1148:
;lib_can.h,695 :: 		CANCON.REQOP1 = CAN_OPERATION.B1;
	BTFSC       FARG_can_set_operation_CAN_OPERATION+0, 1 
	GOTO        L__can_set_operation1149
	BCF         CANCON+0, 6 
	GOTO        L__can_set_operation1150
L__can_set_operation1149:
	BSF         CANCON+0, 6 
L__can_set_operation1150:
;lib_can.h,696 :: 		CANCON.REQOP2 = CAN_OPERATION.B2;
	BTFSC       FARG_can_set_operation_CAN_OPERATION+0, 2 
	GOTO        L__can_set_operation1151
	BCF         CANCON+0, 7 
	GOTO        L__can_set_operation1152
L__can_set_operation1151:
	BSF         CANCON+0, 7 
L__can_set_operation1152:
;lib_can.h,698 :: 		while(CANSTAT.OPMODE0 != CANCON.REQOP0 ||
L_can_set_operation318:
;lib_can.h,699 :: 		CANSTAT.OPMODE1 != CANCON.REQOP1 ||
	BTFSC       CANSTAT+0, 5 
	GOTO        L__can_set_operation1153
	BTFSS       CANCON+0, 5 
	GOTO        L__can_set_operation1154
	GOTO        L__can_set_operation937
L__can_set_operation1153:
	BTFSS       CANCON+0, 5 
	GOTO        L__can_set_operation937
L__can_set_operation1154:
	BTFSC       CANSTAT+0, 6 
	GOTO        L__can_set_operation1155
	BTFSS       CANCON+0, 6 
	GOTO        L__can_set_operation1156
	GOTO        L__can_set_operation937
L__can_set_operation1155:
	BTFSS       CANCON+0, 6 
	GOTO        L__can_set_operation937
L__can_set_operation1156:
;lib_can.h,700 :: 		CANSTAT.OPMODE2 != CANCON.REQOP2);
	BTFSC       CANSTAT+0, 7 
	GOTO        L__can_set_operation1157
	BTFSS       CANCON+0, 7 
	GOTO        L__can_set_operation1158
	GOTO        L__can_set_operation937
L__can_set_operation1157:
	BTFSS       CANCON+0, 7 
	GOTO        L__can_set_operation937
L__can_set_operation1158:
	GOTO        L_can_set_operation319
L__can_set_operation937:
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
	GOTO        L__can_set_mode1160
	BCF         can_set_mode_modeAct_L0+0, 0 
	GOTO        L__can_set_mode1161
L__can_set_mode1160:
	BSF         can_set_mode_modeAct_L0+0, 0 
L__can_set_mode1161:
;lib_can.h,707 :: 		modeAct.B1 = CANSTAT.OPMODE1;
	BTFSC       CANSTAT+0, 6 
	GOTO        L__can_set_mode1162
	BCF         can_set_mode_modeAct_L0+0, 1 
	GOTO        L__can_set_mode1163
L__can_set_mode1162:
	BSF         can_set_mode_modeAct_L0+0, 1 
L__can_set_mode1163:
;lib_can.h,708 :: 		modeAct.B2 = CANSTAT.OPMODE2;
	BTFSC       CANSTAT+0, 7 
	GOTO        L__can_set_mode1164
	BCF         can_set_mode_modeAct_L0+0, 2 
	GOTO        L__can_set_mode1165
L__can_set_mode1164:
	BSF         can_set_mode_modeAct_L0+0, 2 
L__can_set_mode1165:
;lib_can.h,710 :: 		can_set_operation(CAN_OPERATION_CONFIG);  //Se debe poner se en modo config
	MOVLW       4
	MOVWF       FARG_can_set_operation_CAN_OPERATION+0 
	CALL        _can_set_operation+0, 0
;lib_can.h,711 :: 		ECANCON.MDSEL0 = CAN_MODE.B0;
	BTFSC       FARG_can_set_mode_CAN_MODE+0, 0 
	GOTO        L__can_set_mode1166
	BCF         ECANCON+0, 6 
	GOTO        L__can_set_mode1167
L__can_set_mode1166:
	BSF         ECANCON+0, 6 
L__can_set_mode1167:
;lib_can.h,712 :: 		ECANCON.MDSEL1 = CAN_MODE.B1;
	BTFSC       FARG_can_set_mode_CAN_MODE+0, 1 
	GOTO        L__can_set_mode1168
	BCF         ECANCON+0, 7 
	GOTO        L__can_set_mode1169
L__can_set_mode1168:
	BSF         ECANCON+0, 7 
L__can_set_mode1169:
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
L__can_set_id1171:
	BZ          L__can_set_id1172
	RLCF        FARG_can_set_id_value+0, 1 
	BCF         FARG_can_set_id_value+0, 0 
	RLCF        FARG_can_set_id_value+1, 1 
	RLCF        FARG_can_set_id_value+2, 1 
	RLCF        FARG_can_set_id_value+3, 1 
	ADDLW       255
	GOTO        L__can_set_id1171
L__can_set_id1172:
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
	GOTO        L__can_get_id1174
	BCF         can_get_id_value_L0+2, 2 
	GOTO        L__can_get_id1175
L__can_get_id1174:
	BSF         can_get_id_value_L0+2, 2 
L__can_get_id1175:
;lib_can.h,747 :: 		getByte(value,2).B3 = address[-2].B6;  //SIDL, BITS 19
	MOVFF       R1, FSR0
	MOVFF       R2, FSR0H
	MOVF        POSTINC0+0, 0 
	MOVWF       R0 
	BTFSC       R0, 6 
	GOTO        L__can_get_id1176
	BCF         can_get_id_value_L0+2, 3 
	GOTO        L__can_get_id1177
L__can_get_id1176:
	BSF         can_get_id_value_L0+2, 3 
L__can_get_id1177:
;lib_can.h,748 :: 		getByte(value,2).B4 = address[-2].B7;  //SIDL, BITS 20
	MOVFF       R1, FSR0
	MOVFF       R2, FSR0H
	MOVF        POSTINC0+0, 0 
	MOVWF       R0 
	BTFSC       R0, 7 
	GOTO        L__can_get_id1178
	BCF         can_get_id_value_L0+2, 4 
	GOTO        L__can_get_id1179
L__can_get_id1178:
	BSF         can_get_id_value_L0+2, 4 
L__can_get_id1179:
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
	GOTO        L__can_get_id1180
	BCF         can_get_id_value_L0+2, 5 
	GOTO        L__can_get_id1181
L__can_get_id1180:
	BSF         can_get_id_value_L0+2, 5 
L__can_get_id1181:
;lib_can.h,750 :: 		getByte(value,2).B6 = address[-3].B1;
	MOVFF       R1, FSR0
	MOVFF       R2, FSR0H
	MOVF        POSTINC0+0, 0 
	MOVWF       R0 
	BTFSC       R0, 1 
	GOTO        L__can_get_id1182
	BCF         can_get_id_value_L0+2, 6 
	GOTO        L__can_get_id1183
L__can_get_id1182:
	BSF         can_get_id_value_L0+2, 6 
L__can_get_id1183:
;lib_can.h,751 :: 		getByte(value,2).B7 = address[-3].B2;
	MOVFF       R1, FSR0
	MOVFF       R2, FSR0H
	MOVF        POSTINC0+0, 0 
	MOVWF       R0 
	BTFSC       R0, 2 
	GOTO        L__can_get_id1184
	BCF         can_get_id_value_L0+2, 7 
	GOTO        L__can_get_id1185
L__can_get_id1184:
	BSF         can_get_id_value_L0+2, 7 
L__can_get_id1185:
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
	GOTO        L__can_abort1187
	BCF         CANCON+0, 4 
	GOTO        L__can_abort1188
L__can_abort1187:
	BSF         CANCON+0, 4 
L__can_abort1188:
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
	GOTO        L__can_interrupt1190
	BCF         IPR3+0, 2 
	GOTO        L__can_interrupt1191
L__can_interrupt1190:
	BSF         IPR3+0, 2 
L__can_interrupt1191:
;lib_can.h,779 :: 		IPR3.TXB1IP = hihgPriprity;
	BTFSC       FARG_can_interrupt_hihgPriprity+0, 0 
	GOTO        L__can_interrupt1192
	BCF         IPR3+0, 3 
	GOTO        L__can_interrupt1193
L__can_interrupt1192:
	BSF         IPR3+0, 3 
L__can_interrupt1193:
;lib_can.h,780 :: 		IPR3.TXBnIP = hihgPriprity;
	BTFSC       FARG_can_interrupt_hihgPriprity+0, 0 
	GOTO        L__can_interrupt1194
	BCF         IPR3+0, 4 
	GOTO        L__can_interrupt1195
L__can_interrupt1194:
	BSF         IPR3+0, 4 
L__can_interrupt1195:
;lib_can.h,783 :: 		PIE3.TXB0IE = enable;
	BTFSC       FARG_can_interrupt_enable+0, 0 
	GOTO        L__can_interrupt1196
	BCF         PIE3+0, 2 
	GOTO        L__can_interrupt1197
L__can_interrupt1196:
	BSF         PIE3+0, 2 
L__can_interrupt1197:
;lib_can.h,784 :: 		PIE3.TXB1IE = enable;
	BTFSC       FARG_can_interrupt_enable+0, 0 
	GOTO        L__can_interrupt1198
	BCF         PIE3+0, 3 
	GOTO        L__can_interrupt1199
L__can_interrupt1198:
	BSF         PIE3+0, 3 
L__can_interrupt1199:
;lib_can.h,785 :: 		PIE3.TXBnIE = enable;
	BTFSC       FARG_can_interrupt_enable+0, 0 
	GOTO        L__can_interrupt1200
	BCF         PIE3+0, 4 
	GOTO        L__can_interrupt1201
L__can_interrupt1200:
	BSF         PIE3+0, 4 
L__can_interrupt1201:
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
	GOTO        L__can_desonexion938
	BTFSC       TXB1CON+0, 4 
	GOTO        L__can_desonexion938
	BTFSC       TXB2CON+0, 4 
	GOTO        L__can_desonexion938
	GOTO        L_can_desonexion329
L__can_desonexion938:
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
L__int_can941:
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
L__int_can940:
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
L__int_can939:
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
	GOTO        L__DS1307_write_string942
	MOVF        FARG_DS1307_write_string_date+0, 0 
	MOVWF       FARG_string_isNumeric_cadena+0 
	MOVF        FARG_DS1307_write_string_date+1, 0 
	MOVWF       FARG_string_isNumeric_cadena+1 
	CALL        _string_isNumeric+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L__DS1307_write_string942
	GOTO        L_DS1307_write_string344
L__DS1307_write_string942:
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

;impresora_termica.h,86 :: 		void impresoraTerm_cmd(const char *comando){
;impresora_termica.h,87 :: 		char cont = 0;
	CLRF        impresoraTerm_cmd_cont_L0+0 
;impresora_termica.h,90 :: 		RomToRam(comando,buffer);
	MOVF        FARG_impresoraTerm_cmd_comando+0, 0 
	MOVWF       FARG_RomToRam_origen+0 
	MOVF        FARG_impresoraTerm_cmd_comando+1, 0 
	MOVWF       FARG_RomToRam_origen+1 
	MOVF        FARG_impresoraTerm_cmd_comando+2, 0 
	MOVWF       FARG_RomToRam_origen+2 
	MOVLW       Expendedora_buffer+0
	MOVWF       FARG_RomToRam_destino+0 
	MOVLW       hi_addr(Expendedora_buffer+0)
	MOVWF       FARG_RomToRam_destino+1 
	CALL        _RomToRam+0, 0
;impresora_termica.h,91 :: 		while(buffer[cont])
L_impresoraTerm_cmd354:
	MOVLW       Expendedora_buffer+0
	MOVWF       FSR0 
	MOVLW       hi_addr(Expendedora_buffer+0)
	MOVWF       FSR0H 
	MOVF        impresoraTerm_cmd_cont_L0+0, 0 
	ADDWF       FSR0, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR0H, 1 
	MOVF        POSTINC0+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_impresoraTerm_cmd355
;impresora_termica.h,92 :: 		usart_write(buffer[cont++]);
	MOVLW       Expendedora_buffer+0
	MOVWF       FSR0 
	MOVLW       hi_addr(Expendedora_buffer+0)
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
;impresora_termica.h,93 :: 		}
L_end_impresoraTerm_cmd:
	RETURN      0
; end of _impresoraTerm_cmd

_impresoraTerm_cmd2:

;impresora_termica.h,95 :: 		void impresoraTerm_cmd2(const char *comando, char valor){
;impresora_termica.h,96 :: 		char cont = 0;
	CLRF        impresoraTerm_cmd2_cont_L0+0 
;impresora_termica.h,98 :: 		RomToRam(comando,buffer);
	MOVF        FARG_impresoraTerm_cmd2_comando+0, 0 
	MOVWF       FARG_RomToRam_origen+0 
	MOVF        FARG_impresoraTerm_cmd2_comando+1, 0 
	MOVWF       FARG_RomToRam_origen+1 
	MOVF        FARG_impresoraTerm_cmd2_comando+2, 0 
	MOVWF       FARG_RomToRam_origen+2 
	MOVLW       Expendedora_buffer+0
	MOVWF       FARG_RomToRam_destino+0 
	MOVLW       hi_addr(Expendedora_buffer+0)
	MOVWF       FARG_RomToRam_destino+1 
	CALL        _RomToRam+0, 0
;impresora_termica.h,99 :: 		while(buffer[cont])
L_impresoraTerm_cmd2356:
	MOVLW       Expendedora_buffer+0
	MOVWF       FSR0 
	MOVLW       hi_addr(Expendedora_buffer+0)
	MOVWF       FSR0H 
	MOVF        impresoraTerm_cmd2_cont_L0+0, 0 
	ADDWF       FSR0, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR0H, 1 
	MOVF        POSTINC0+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_impresoraTerm_cmd2357
;impresora_termica.h,100 :: 		usart_write(buffer[cont++]);
	MOVLW       Expendedora_buffer+0
	MOVWF       FSR0 
	MOVLW       hi_addr(Expendedora_buffer+0)
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
;impresora_termica.h,102 :: 		usart_write(valor);
	MOVF        FARG_impresoraTerm_cmd2_valor+0, 0 
	MOVWF       FARG_usart_write_caracter+0 
	CALL        _usart_write+0, 0
;impresora_termica.h,103 :: 		}
L_end_impresoraTerm_cmd2:
	RETURN      0
; end of _impresoraTerm_cmd2

_impresoraTerm_open:

;impresora_termica.h,105 :: 		void impresoraTerm_open(bool typeFont, char interlineado){
;impresora_termica.h,107 :: 		impresoraTerm_cmd(IMPT_INIT);
	MOVLW       _IMPT_INIT+0
	MOVWF       FARG_impresoraTerm_cmd_comando+0 
	MOVLW       hi_addr(_IMPT_INIT+0)
	MOVWF       FARG_impresoraTerm_cmd_comando+1 
	MOVLW       higher_addr(_IMPT_INIT+0)
	MOVWF       FARG_impresoraTerm_cmd_comando+2 
	CALL        _impresoraTerm_cmd+0, 0
;impresora_termica.h,109 :: 		impresoraTerm_cmd2(IMPT_MODO, typeFont);
	MOVLW       _IMPT_MODO+0
	MOVWF       FARG_impresoraTerm_cmd2_comando+0 
	MOVLW       hi_addr(_IMPT_MODO+0)
	MOVWF       FARG_impresoraTerm_cmd2_comando+1 
	MOVLW       higher_addr(_IMPT_MODO+0)
	MOVWF       FARG_impresoraTerm_cmd2_comando+2 
	MOVF        FARG_impresoraTerm_open_typeFont+0, 0 
	MOVWF       FARG_impresoraTerm_cmd2_valor+0 
	CALL        _impresoraTerm_cmd2+0, 0
;impresora_termica.h,111 :: 		impresoraTerm_cmd2(IMPT_ESP_PROG, interlineado); //Espaciado
	MOVLW       _IMPT_ESP_PROG+0
	MOVWF       FARG_impresoraTerm_cmd2_comando+0 
	MOVLW       hi_addr(_IMPT_ESP_PROG+0)
	MOVWF       FARG_impresoraTerm_cmd2_comando+1 
	MOVLW       higher_addr(_IMPT_ESP_PROG+0)
	MOVWF       FARG_impresoraTerm_cmd2_comando+2 
	MOVF        FARG_impresoraTerm_open_interlineado+0, 0 
	MOVWF       FARG_impresoraTerm_cmd2_valor+0 
	CALL        _impresoraTerm_cmd2+0, 0
;impresora_termica.h,113 :: 		impresoraTerm_cmd2(IMPT_JUST, JUST_LEFT);        //Izquierda
	MOVLW       _IMPT_JUST+0
	MOVWF       FARG_impresoraTerm_cmd2_comando+0 
	MOVLW       hi_addr(_IMPT_JUST+0)
	MOVWF       FARG_impresoraTerm_cmd2_comando+1 
	MOVLW       higher_addr(_IMPT_JUST+0)
	MOVWF       FARG_impresoraTerm_cmd2_comando+2 
	CLRF        FARG_impresoraTerm_cmd2_valor+0 
	CALL        _impresoraTerm_cmd2+0, 0
;impresora_termica.h,115 :: 		impresoraTerm_cmd2(IMPT_SIZE_CHAR, 0x33);        //Tamño 3x3 points
	MOVLW       _IMPT_SIZE_CHAR+0
	MOVWF       FARG_impresoraTerm_cmd2_comando+0 
	MOVLW       hi_addr(_IMPT_SIZE_CHAR+0)
	MOVWF       FARG_impresoraTerm_cmd2_comando+1 
	MOVLW       higher_addr(_IMPT_SIZE_CHAR+0)
	MOVWF       FARG_impresoraTerm_cmd2_comando+2 
	MOVLW       51
	MOVWF       FARG_impresoraTerm_cmd2_valor+0 
	CALL        _impresoraTerm_cmd2+0, 0
;impresora_termica.h,116 :: 		}
L_end_impresoraTerm_open:
	RETURN      0
; end of _impresoraTerm_open

_impresoraTerm_formato:

;impresora_termica.h,118 :: 		void impresoraTerm_formato(char size, char just, bool negrita){
;impresora_termica.h,120 :: 		impresoraTerm_cmd2(IMPT_SIZE_CHAR, size);
	MOVLW       _IMPT_SIZE_CHAR+0
	MOVWF       FARG_impresoraTerm_cmd2_comando+0 
	MOVLW       hi_addr(_IMPT_SIZE_CHAR+0)
	MOVWF       FARG_impresoraTerm_cmd2_comando+1 
	MOVLW       higher_addr(_IMPT_SIZE_CHAR+0)
	MOVWF       FARG_impresoraTerm_cmd2_comando+2 
	MOVF        FARG_impresoraTerm_formato_size+0, 0 
	MOVWF       FARG_impresoraTerm_cmd2_valor+0 
	CALL        _impresoraTerm_cmd2+0, 0
;impresora_termica.h,122 :: 		impresoraTerm_cmd2(IMPT_JUST, just);
	MOVLW       _IMPT_JUST+0
	MOVWF       FARG_impresoraTerm_cmd2_comando+0 
	MOVLW       hi_addr(_IMPT_JUST+0)
	MOVWF       FARG_impresoraTerm_cmd2_comando+1 
	MOVLW       higher_addr(_IMPT_JUST+0)
	MOVWF       FARG_impresoraTerm_cmd2_comando+2 
	MOVF        FARG_impresoraTerm_formato_just+0, 0 
	MOVWF       FARG_impresoraTerm_cmd2_valor+0 
	CALL        _impresoraTerm_cmd2+0, 0
;impresora_termica.h,124 :: 		impresoraTerm_cmd2(IMPT_NEGRITA, negrita);
	MOVLW       _IMPT_NEGRITA+0
	MOVWF       FARG_impresoraTerm_cmd2_comando+0 
	MOVLW       hi_addr(_IMPT_NEGRITA+0)
	MOVWF       FARG_impresoraTerm_cmd2_comando+1 
	MOVLW       higher_addr(_IMPT_NEGRITA+0)
	MOVWF       FARG_impresoraTerm_cmd2_comando+2 
	MOVF        FARG_impresoraTerm_formato_negrita+0, 0 
	MOVWF       FARG_impresoraTerm_cmd2_valor+0 
	CALL        _impresoraTerm_cmd2+0, 0
;impresora_termica.h,125 :: 		}
L_end_impresoraTerm_formato:
	RETURN      0
; end of _impresoraTerm_formato

_impresoraTerm_writeLine:

;impresora_termica.h,127 :: 		void impresoraTerm_writeLine(char *texto){
;impresora_termica.h,128 :: 		char cont = 0;
	CLRF        impresoraTerm_writeLine_cont_L0+0 
;impresora_termica.h,131 :: 		while(texto[cont])
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
;impresora_termica.h,132 :: 		usart_write(texto[cont++]);
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
;impresora_termica.h,134 :: 		impresoraTerm_cmd(IMPT_IMPRIME);
	MOVLW       _IMPT_IMPRIME+0
	MOVWF       FARG_impresoraTerm_cmd_comando+0 
	MOVLW       hi_addr(_IMPT_IMPRIME+0)
	MOVWF       FARG_impresoraTerm_cmd_comando+1 
	MOVLW       higher_addr(_IMPT_IMPRIME+0)
	MOVWF       FARG_impresoraTerm_cmd_comando+2 
	CALL        _impresoraTerm_cmd+0, 0
;impresora_termica.h,135 :: 		}
L_end_impresoraTerm_writeLine:
	RETURN      0
; end of _impresoraTerm_writeLine

_impresoraTerm_writeTextStatic:

;impresora_termica.h,137 :: 		bool impresoraTerm_writeTextStatic(const char *texto, char rateBytes){
;impresora_termica.h,141 :: 		while(texto[cont] && rateBytes--){
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
L__impresoraTerm_writeTextStatic943:
;impresora_termica.h,142 :: 		usart_write(texto[cont]);
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
;impresora_termica.h,144 :: 		if(texto[cont] == '\n'){
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
;impresora_termica.h,145 :: 		cont++;
	INFSNZ      impresoraTerm_writeTextStatic_cont_L0+0, 1 
	INCF        impresoraTerm_writeTextStatic_cont_L0+1, 1 
;impresora_termica.h,146 :: 		break;
	GOTO        L_impresoraTerm_writeTextStatic361
;impresora_termica.h,147 :: 		}
L_impresoraTerm_writeTextStatic364:
;impresora_termica.h,148 :: 		cont++;  //Siguiente posicion
	INFSNZ      impresoraTerm_writeTextStatic_cont_L0+0, 1 
	INCF        impresoraTerm_writeTextStatic_cont_L0+1, 1 
;impresora_termica.h,149 :: 		}
	GOTO        L_impresoraTerm_writeTextStatic360
L_impresoraTerm_writeTextStatic361:
;impresora_termica.h,151 :: 		if(!texto[cont]){
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
;impresora_termica.h,152 :: 		cont = 0;
	CLRF        impresoraTerm_writeTextStatic_cont_L0+0 
	CLRF        impresoraTerm_writeTextStatic_cont_L0+1 
;impresora_termica.h,153 :: 		return true; //Finalizo de imprimir
	MOVLW       1
	MOVWF       R0 
	GOTO        L_end_impresoraTerm_writeTextStatic
;impresora_termica.h,154 :: 		}
L_impresoraTerm_writeTextStatic365:
;impresora_termica.h,156 :: 		return false;  //No ha terminado de imprimir
	CLRF        R0 
;impresora_termica.h,157 :: 		}
L_end_impresoraTerm_writeTextStatic:
	RETURN      0
; end of _impresoraTerm_writeTextStatic

_impresoraTerm_writeDinamicText:

;impresora_termica.h,159 :: 		void impresoraTerm_writeDinamicText(char *texto, const int *address){
;impresora_termica.h,160 :: 		char ADRR_ERROR[] = "#ERR_ADDR#";  //Optimizar esta variable
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
;impresora_termica.h,166 :: 		while(texto[cont]){
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
;impresora_termica.h,167 :: 		if(texto[cont] == CMD_IMPRESORA){  //ENVIA N CARACTERES DE COMANDOS HACIA LA IMPRESORA
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
;impresora_termica.h,169 :: 		cont++;
	INCF        impresoraTerm_writeDinamicText_cont_L0+0, 1 
;impresora_termica.h,170 :: 		for(cont2 = 0; cont2 < 2 && texto[cont]; cont2++)
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
L__impresoraTerm_writeDinamicText948:
;impresora_termica.h,171 :: 		buffer[cont2] = texto[cont++];
	MOVLW       Expendedora_buffer+0
	MOVWF       FSR1 
	MOVLW       hi_addr(Expendedora_buffer+0)
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
;impresora_termica.h,170 :: 		for(cont2 = 0; cont2 < 2 && texto[cont]; cont2++)
	INCF        impresoraTerm_writeDinamicText_cont2_L0+0, 1 
;impresora_termica.h,171 :: 		buffer[cont2] = texto[cont++];
	GOTO        L_impresoraTerm_writeDinamicText369
L_impresoraTerm_writeDinamicText370:
;impresora_termica.h,172 :: 		buffer[cont2] = 0; //Fin de cadena
	MOVLW       Expendedora_buffer+0
	MOVWF       FSR1 
	MOVLW       hi_addr(Expendedora_buffer+0)
	MOVWF       FSR1H 
	MOVF        impresoraTerm_writeDinamicText_cont2_L0+0, 0 
	ADDWF       FSR1, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR1H, 1 
	CLRF        POSTINC1+0 
;impresora_termica.h,175 :: 		comandos = atoi(buffer);
	MOVLW       Expendedora_buffer+0
	MOVWF       FARG_atoi_s+0 
	MOVLW       hi_addr(Expendedora_buffer+0)
	MOVWF       FARG_atoi_s+1 
	CALL        _atoi+0, 0
	MOVF        R0, 0 
	MOVWF       impresoraTerm_writeDinamicText_comandos_L0+0 
;impresora_termica.h,176 :: 		while(comandos--){
L_impresoraTerm_writeDinamicText374:
	MOVF        impresoraTerm_writeDinamicText_comandos_L0+0, 0 
	MOVWF       R0 
	DECF        impresoraTerm_writeDinamicText_comandos_L0+0, 1 
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_impresoraTerm_writeDinamicText375
;impresora_termica.h,178 :: 		for(cont2 = 0; cont2 < 2 && texto[cont]; cont2++)
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
L__impresoraTerm_writeDinamicText947:
;impresora_termica.h,179 :: 		buffer[cont2] = texto[cont++];
	MOVLW       Expendedora_buffer+0
	MOVWF       FSR1 
	MOVLW       hi_addr(Expendedora_buffer+0)
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
;impresora_termica.h,178 :: 		for(cont2 = 0; cont2 < 2 && texto[cont]; cont2++)
	INCF        impresoraTerm_writeDinamicText_cont2_L0+0, 1 
;impresora_termica.h,179 :: 		buffer[cont2] = texto[cont++];
	GOTO        L_impresoraTerm_writeDinamicText376
L_impresoraTerm_writeDinamicText377:
;impresora_termica.h,180 :: 		buffer[cont2] = 0; //Fin de cadena
	MOVLW       Expendedora_buffer+0
	MOVWF       FSR1 
	MOVLW       hi_addr(Expendedora_buffer+0)
	MOVWF       FSR1H 
	MOVF        impresoraTerm_writeDinamicText_cont2_L0+0, 0 
	ADDWF       FSR1, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR1H, 1 
	CLRF        POSTINC1+0 
;impresora_termica.h,181 :: 		cont2 = xtoi(buffer);
	MOVLW       Expendedora_buffer+0
	MOVWF       FARG_xtoi_s+0 
	MOVLW       hi_addr(Expendedora_buffer+0)
	MOVWF       FARG_xtoi_s+1 
	CALL        _xtoi+0, 0
	MOVF        R0, 0 
	MOVWF       impresoraTerm_writeDinamicText_cont2_L0+0 
;impresora_termica.h,182 :: 		usart_write(cont2);
	MOVF        R0, 0 
	MOVWF       FARG_usart_write_caracter+0 
	CALL        _usart_write+0, 0
;impresora_termica.h,183 :: 		}
	GOTO        L_impresoraTerm_writeDinamicText374
L_impresoraTerm_writeDinamicText375:
;impresora_termica.h,185 :: 		if(texto[cont] == '\n')
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
;impresora_termica.h,186 :: 		cont++; //Por el final de cadena
	INCF        impresoraTerm_writeDinamicText_cont_L0+0, 1 
L_impresoraTerm_writeDinamicText381:
;impresora_termica.h,187 :: 		}else if(texto[cont] == CMD_CODIGO_BARRAS || texto[cont] == CMD_TEXT_DINAMIC){  //Comando para escribir variables dinamicas
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
	GOTO        L__impresoraTerm_writeDinamicText946
	MOVF        impresoraTerm_writeDinamicText_cont_L0+0, 0 
	ADDWF       FARG_impresoraTerm_writeDinamicText_texto+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_impresoraTerm_writeDinamicText_texto+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	XORLW       5
	BTFSC       STATUS+0, 2 
	GOTO        L__impresoraTerm_writeDinamicText946
	GOTO        L_impresoraTerm_writeDinamicText385
L__impresoraTerm_writeDinamicText946:
;impresora_termica.h,189 :: 		comandos = texto[cont];
	MOVF        impresoraTerm_writeDinamicText_cont_L0+0, 0 
	ADDWF       FARG_impresoraTerm_writeDinamicText_texto+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_impresoraTerm_writeDinamicText_texto+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       impresoraTerm_writeDinamicText_comandos_L0+0 
;impresora_termica.h,192 :: 		ticketPointer = ADRR_ERROR;
	MOVLW       impresoraTerm_writeDinamicText_ADRR_ERROR_L0+0
	MOVWF       impresoraTerm_writeDinamicText_ticketPointer_L0+0 
	MOVLW       hi_addr(impresoraTerm_writeDinamicText_ADRR_ERROR_L0+0)
	MOVWF       impresoraTerm_writeDinamicText_ticketPointer_L0+1 
;impresora_termica.h,194 :: 		cont++;
	INCF        impresoraTerm_writeDinamicText_cont_L0+0, 1 
;impresora_termica.h,195 :: 		for(cont2 = 0; cont2 < 4 && texto[cont]; cont2++)
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
L__impresoraTerm_writeDinamicText945:
;impresora_termica.h,196 :: 		buffer[cont2] = texto[cont++];
	MOVLW       Expendedora_buffer+0
	MOVWF       FSR1 
	MOVLW       hi_addr(Expendedora_buffer+0)
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
;impresora_termica.h,195 :: 		for(cont2 = 0; cont2 < 4 && texto[cont]; cont2++)
	INCF        impresoraTerm_writeDinamicText_cont2_L0+0, 1 
;impresora_termica.h,196 :: 		buffer[cont2] = texto[cont++];
	GOTO        L_impresoraTerm_writeDinamicText386
L_impresoraTerm_writeDinamicText387:
;impresora_termica.h,197 :: 		buffer[cont2] = 0; //Fin de cadena
	MOVLW       Expendedora_buffer+0
	MOVWF       FSR1 
	MOVLW       hi_addr(Expendedora_buffer+0)
	MOVWF       FSR1H 
	MOVF        impresoraTerm_writeDinamicText_cont2_L0+0, 0 
	ADDWF       FSR1, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR1H, 1 
	CLRF        POSTINC1+0 
;impresora_termica.h,199 :: 		dir = xtoi(buffer);
	MOVLW       Expendedora_buffer+0
	MOVWF       FARG_xtoi_s+0 
	MOVLW       hi_addr(Expendedora_buffer+0)
	MOVWF       FARG_xtoi_s+1 
	CALL        _xtoi+0, 0
	MOVF        R0, 0 
	MOVWF       impresoraTerm_writeDinamicText_dir_L0+0 
	MOVF        R1, 0 
	MOVWF       impresoraTerm_writeDinamicText_dir_L0+1 
;impresora_termica.h,202 :: 		cont2 = 0;
	CLRF        impresoraTerm_writeDinamicText_cont2_L0+0 
;impresora_termica.h,203 :: 		while(address[cont2]){
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
;impresora_termica.h,204 :: 		if(dir == address[cont2++]){
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
	GOTO        L__impresoraTerm_writeDinamicText1218
	MOVF        R1, 0 
	XORWF       impresoraTerm_writeDinamicText_dir_L0+0, 0 
L__impresoraTerm_writeDinamicText1218:
	BTFSS       STATUS+0, 2 
	GOTO        L_impresoraTerm_writeDinamicText393
;impresora_termica.h,206 :: 		getByte(ticketPointer, 0) = getByte(dir, 0);
	MOVF        impresoraTerm_writeDinamicText_dir_L0+0, 0 
	MOVWF       impresoraTerm_writeDinamicText_ticketPointer_L0+0 
;impresora_termica.h,207 :: 		getByte(ticketPointer, 1) = getByte(dir, 1);
	MOVF        impresoraTerm_writeDinamicText_dir_L0+1, 0 
	MOVWF       impresoraTerm_writeDinamicText_ticketPointer_L0+1 
;impresora_termica.h,208 :: 		break;
	GOTO        L_impresoraTerm_writeDinamicText392
;impresora_termica.h,209 :: 		}
L_impresoraTerm_writeDinamicText393:
;impresora_termica.h,210 :: 		}
	GOTO        L_impresoraTerm_writeDinamicText391
L_impresoraTerm_writeDinamicText392:
;impresora_termica.h,213 :: 		if(comandos == CMD_CODIGO_BARRAS)
	MOVF        impresoraTerm_writeDinamicText_comandos_L0+0, 0 
	XORLW       3
	BTFSS       STATUS+0, 2 
	GOTO        L_impresoraTerm_writeDinamicText394
;impresora_termica.h,214 :: 		usart_write(strlen(ticketPointer));
	MOVF        impresoraTerm_writeDinamicText_ticketPointer_L0+0, 0 
	MOVWF       FARG_strlen_s+0 
	MOVF        impresoraTerm_writeDinamicText_ticketPointer_L0+1, 0 
	MOVWF       FARG_strlen_s+1 
	CALL        _strlen+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_usart_write_caracter+0 
	CALL        _usart_write+0, 0
L_impresoraTerm_writeDinamicText394:
;impresora_termica.h,217 :: 		cont2 = 0;
	CLRF        impresoraTerm_writeDinamicText_cont2_L0+0 
;impresora_termica.h,218 :: 		while(ticketPointer[cont2])
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
;impresora_termica.h,219 :: 		usart_write(ticketPointer[cont2++]);
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
;impresora_termica.h,220 :: 		}else if(texto[cont] == CMD_WRITE_BYTE){  //Modo beta
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
;impresora_termica.h,222 :: 		cont++;
	INCF        impresoraTerm_writeDinamicText_cont_L0+0, 1 
;impresora_termica.h,223 :: 		for(cont2 = 0; cont2 < 2 && texto[cont]; cont2++)
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
L__impresoraTerm_writeDinamicText944:
;impresora_termica.h,224 :: 		buffer[cont2] = texto[cont++];
	MOVLW       Expendedora_buffer+0
	MOVWF       FSR1 
	MOVLW       hi_addr(Expendedora_buffer+0)
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
;impresora_termica.h,223 :: 		for(cont2 = 0; cont2 < 2 && texto[cont]; cont2++)
	INCF        impresoraTerm_writeDinamicText_cont2_L0+0, 1 
;impresora_termica.h,224 :: 		buffer[cont2] = texto[cont++];
	GOTO        L_impresoraTerm_writeDinamicText399
L_impresoraTerm_writeDinamicText400:
;impresora_termica.h,225 :: 		buffer[cont2] = 0; //Fin de cadena
	MOVLW       Expendedora_buffer+0
	MOVWF       FSR1 
	MOVLW       hi_addr(Expendedora_buffer+0)
	MOVWF       FSR1H 
	MOVF        impresoraTerm_writeDinamicText_cont2_L0+0, 0 
	ADDWF       FSR1, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR1H, 1 
	CLRF        POSTINC1+0 
;impresora_termica.h,228 :: 		cont2 = xtoi(buffer);
	MOVLW       Expendedora_buffer+0
	MOVWF       FARG_xtoi_s+0 
	MOVLW       hi_addr(Expendedora_buffer+0)
	MOVWF       FARG_xtoi_s+1 
	CALL        _xtoi+0, 0
	MOVF        R0, 0 
	MOVWF       impresoraTerm_writeDinamicText_cont2_L0+0 
;impresora_termica.h,229 :: 		usart_write(cont2);
	MOVF        R0, 0 
	MOVWF       FARG_usart_write_caracter+0 
	CALL        _usart_write+0, 0
;impresora_termica.h,232 :: 		if(texto[cont])
	MOVF        impresoraTerm_writeDinamicText_cont_L0+0, 0 
	ADDWF       FARG_impresoraTerm_writeDinamicText_texto+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_impresoraTerm_writeDinamicText_texto+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_impresoraTerm_writeDinamicText404
;impresora_termica.h,233 :: 		cont++; //Por el final de cadena
	INCF        impresoraTerm_writeDinamicText_cont_L0+0, 1 
L_impresoraTerm_writeDinamicText404:
;impresora_termica.h,234 :: 		}else{  //Caracter normal
	GOTO        L_impresoraTerm_writeDinamicText405
L_impresoraTerm_writeDinamicText398:
;impresora_termica.h,236 :: 		usart_write(texto[cont++]);
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
;impresora_termica.h,237 :: 		}
L_impresoraTerm_writeDinamicText405:
L_impresoraTerm_writeDinamicText397:
L_impresoraTerm_writeDinamicText382:
;impresora_termica.h,238 :: 		}
	GOTO        L_impresoraTerm_writeDinamicText366
L_impresoraTerm_writeDinamicText367:
;impresora_termica.h,239 :: 		}
L_end_impresoraTerm_writeDinamicText:
	RETURN      0
; end of _impresoraTerm_writeDinamicText

_impresoraTerm_codBarNum:

;impresora_termica.h,241 :: 		void impresoraTerm_codBarNum(char *codigo, char format, char altura, char ancho){
;impresora_termica.h,242 :: 		impresoraTerm_cmd2(IMPT_COD_BAR_POS, format);  //Mostrar codigo de barras
	MOVLW       _IMPT_COD_BAR_POS+0
	MOVWF       FARG_impresoraTerm_cmd2_comando+0 
	MOVLW       hi_addr(_IMPT_COD_BAR_POS+0)
	MOVWF       FARG_impresoraTerm_cmd2_comando+1 
	MOVLW       higher_addr(_IMPT_COD_BAR_POS+0)
	MOVWF       FARG_impresoraTerm_cmd2_comando+2 
	MOVF        FARG_impresoraTerm_codBarNum_format+0, 0 
	MOVWF       FARG_impresoraTerm_cmd2_valor+0 
	CALL        _impresoraTerm_cmd2+0, 0
;impresora_termica.h,243 :: 		impresoraTerm_cmd2(IMPT_COD_BAR_V, altura);    //Altura del codigo de barras 1-255
	MOVLW       _IMPT_COD_BAR_V+0
	MOVWF       FARG_impresoraTerm_cmd2_comando+0 
	MOVLW       hi_addr(_IMPT_COD_BAR_V+0)
	MOVWF       FARG_impresoraTerm_cmd2_comando+1 
	MOVLW       higher_addr(_IMPT_COD_BAR_V+0)
	MOVWF       FARG_impresoraTerm_cmd2_comando+2 
	MOVF        FARG_impresoraTerm_codBarNum_altura+0, 0 
	MOVWF       FARG_impresoraTerm_cmd2_valor+0 
	CALL        _impresoraTerm_cmd2+0, 0
;impresora_termica.h,244 :: 		impresoraTerm_cmd2(IMPT_COD_BAR_H, ancho);     //Ancho codigo de barras 2-6
	MOVLW       _IMPT_COD_BAR_H+0
	MOVWF       FARG_impresoraTerm_cmd2_comando+0 
	MOVLW       hi_addr(_IMPT_COD_BAR_H+0)
	MOVWF       FARG_impresoraTerm_cmd2_comando+1 
	MOVLW       higher_addr(_IMPT_COD_BAR_H+0)
	MOVWF       FARG_impresoraTerm_cmd2_comando+2 
	MOVF        FARG_impresoraTerm_codBarNum_ancho+0, 0 
	MOVWF       FARG_impresoraTerm_cmd2_valor+0 
	CALL        _impresoraTerm_cmd2+0, 0
;impresora_termica.h,246 :: 		impresoraTerm_cmd2(IMPT_COD_BAR_C, COD_BARRAS_NUMERICO);
	MOVLW       _IMPT_COD_BAR_C+0
	MOVWF       FARG_impresoraTerm_cmd2_comando+0 
	MOVLW       hi_addr(_IMPT_COD_BAR_C+0)
	MOVWF       FARG_impresoraTerm_cmd2_comando+1 
	MOVLW       higher_addr(_IMPT_COD_BAR_C+0)
	MOVWF       FARG_impresoraTerm_cmd2_comando+2 
	MOVLW       69
	MOVWF       FARG_impresoraTerm_cmd2_valor+0 
	CALL        _impresoraTerm_cmd2+0, 0
;impresora_termica.h,247 :: 		usart_write(strlen(codigo));
	MOVF        FARG_impresoraTerm_codBarNum_codigo+0, 0 
	MOVWF       FARG_strlen_s+0 
	MOVF        FARG_impresoraTerm_codBarNum_codigo+1, 0 
	MOVWF       FARG_strlen_s+1 
	CALL        _strlen+0, 0
	MOVF        R0, 0 
	MOVWF       FARG_usart_write_caracter+0 
	CALL        _usart_write+0, 0
;impresora_termica.h,248 :: 		usart_write_text(codigo);
	MOVF        FARG_impresoraTerm_codBarNum_codigo+0, 0 
	MOVWF       FARG_usart_write_text_texto+0 
	MOVF        FARG_impresoraTerm_codBarNum_codigo+1, 0 
	MOVWF       FARG_usart_write_text_texto+1 
	CALL        _usart_write_text+0, 0
;impresora_termica.h,249 :: 		}
L_end_impresoraTerm_codBarNum:
	RETURN      0
; end of _impresoraTerm_codBarNum

_impresoraTerm_corte:

;impresora_termica.h,251 :: 		void impresoraTerm_corte(bool cutPartial, char offset){
;impresora_termica.h,252 :: 		impresoraTerm_cmd2(IMPT_CORTE_POS, offset? CUT_POS_OFFSET: CUT_POS_ACT);
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
	MOVWF       ?FLOC___impresoraTerm_corteT1946+0 
	GOTO        L_impresoraTerm_corte407
L_impresoraTerm_corte406:
	MOVLW       49
	MOVWF       ?FLOC___impresoraTerm_corteT1946+0 
L_impresoraTerm_corte407:
	MOVF        ?FLOC___impresoraTerm_corteT1946+0, 0 
	MOVWF       FARG_impresoraTerm_cmd2_valor+0 
	CALL        _impresoraTerm_cmd2+0, 0
;impresora_termica.h,254 :: 		if(offset)
	MOVF        FARG_impresoraTerm_corte_offset+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_impresoraTerm_corte408
;impresora_termica.h,255 :: 		usart_write(offset);
	MOVF        FARG_impresoraTerm_corte_offset+0, 0 
	MOVWF       FARG_usart_write_caracter+0 
	CALL        _usart_write+0, 0
L_impresoraTerm_corte408:
;impresora_termica.h,258 :: 		}
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
	GOTO        L__I2C_soft_write1225
	BCF         I2C_SDA+0, BitPos(I2C_SDA+0) 
	GOTO        L__I2C_soft_write1226
L__I2C_soft_write1225:
	BSF         I2C_SDA+0, BitPos(I2C_SDA+0) 
L__I2C_soft_write1226:
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
	GOTO        L__I2C_soft_write1227
	BCF         R1, 0 
	GOTO        L__I2C_soft_write1228
L__I2C_soft_write1227:
	BSF         R1, 0 
L__I2C_soft_write1228:
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
	GOTO        L__I2C_soft_read1230
	BSF         I2C_SDA+0, BitPos(I2C_SDA+0) 
	GOTO        L__I2C_soft_read1231
L__I2C_soft_read1230:
	BCF         I2C_SDA+0, BitPos(I2C_SDA+0) 
L__I2C_soft_read1231:
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
	GOTO        L__eeprom_i2c_write1234
	MOVLW       0
	XORWF       R1, 0 
L__eeprom_i2c_write1234:
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
;eeprom_i2c_soft.h,57 :: 		I2C_soft_write(EEPROM_ADDRESS_24LC256); // Escritura e multiples bytes
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
	GOTO        L__eeprom_i2c_read1236
	MOVF        R1, 0 
	SUBWF       eeprom_i2c_read_cont_L0+0, 0 
L__eeprom_i2c_read1236:
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

;table_eeprom.h,59 :: 		void mysql_reset(){
;table_eeprom.h,60 :: 		myTable.numTables = 0;
	CLRF        Expendedora_myTable+0 
;table_eeprom.h,61 :: 		myTable.size = 3;   //Tamaño actual ocupado, num tables y tamaño actual
	MOVLW       3
	MOVWF       Expendedora_myTable+41 
	MOVLW       0
	MOVWF       Expendedora_myTable+42 
;table_eeprom.h,63 :: 		eeprom_i2c_write(0x0000, &myTable.numTables, 1);
	CLRF        FARG_eeprom_i2c_write_address+0 
	CLRF        FARG_eeprom_i2c_write_address+1 
	MOVLW       Expendedora_myTable+0
	MOVWF       FARG_eeprom_i2c_write_datos+0 
	MOVLW       hi_addr(Expendedora_myTable+0)
	MOVWF       FARG_eeprom_i2c_write_datos+1 
	MOVLW       1
	MOVWF       FARG_eeprom_i2c_write_size+0 
	CALL        _eeprom_i2c_write+0, 0
;table_eeprom.h,64 :: 		eeprom_i2c_write(0x0001,(char*)&myTable.size, 2);
	MOVLW       1
	MOVWF       FARG_eeprom_i2c_write_address+0 
	MOVLW       0
	MOVWF       FARG_eeprom_i2c_write_address+1 
	MOVLW       Expendedora_myTable+41
	MOVWF       FARG_eeprom_i2c_write_datos+0 
	MOVLW       hi_addr(Expendedora_myTable+41)
	MOVWF       FARG_eeprom_i2c_write_datos+1 
	MOVLW       2
	MOVWF       FARG_eeprom_i2c_write_size+0 
	CALL        _eeprom_i2c_write+0, 0
;table_eeprom.h,65 :: 		}
L_end_mysql_reset:
	RETURN      0
; end of _mysql_reset

_mysql_init:

;table_eeprom.h,67 :: 		void mysql_init(unsigned int memoryMax){
;table_eeprom.h,69 :: 		myTable.col = 0;
	CLRF        Expendedora_myTable+1 
;table_eeprom.h,70 :: 		myTable.row = 0;
	CLRF        Expendedora_myTable+2 
	CLRF        Expendedora_myTable+3 
;table_eeprom.h,71 :: 		myTable.rowAct = 0;
	CLRF        Expendedora_myTable+4 
	CLRF        Expendedora_myTable+5 
;table_eeprom.h,72 :: 		myTable.nameAct[0] = 0;          //Inicializar cadena en cero
	CLRF        Expendedora_myTable+7 
;table_eeprom.h,73 :: 		myTable.nameColAct[0] = 0;
	CLRF        Expendedora_myTable+23 
;table_eeprom.h,74 :: 		myTable.sizeMax = memoryMax;
	MOVF        FARG_mysql_init_memoryMax+0, 0 
	MOVWF       Expendedora_myTable+39 
	MOVF        FARG_mysql_init_memoryMax+1, 0 
	MOVWF       Expendedora_myTable+40 
;table_eeprom.h,76 :: 		eeprom_i2c_open();  //Preguntamos si deseo resetear la memoria
	CALL        _eeprom_i2c_open+0, 0
;table_eeprom.h,77 :: 		eeprom_i2c_read(0x0000,&myTable.numTables, 1);
	CLRF        FARG_eeprom_i2c_read_address+0 
	CLRF        FARG_eeprom_i2c_read_address+1 
	MOVLW       Expendedora_myTable+0
	MOVWF       FARG_eeprom_i2c_read_datos+0 
	MOVLW       hi_addr(Expendedora_myTable+0)
	MOVWF       FARG_eeprom_i2c_read_datos+1 
	MOVLW       1
	MOVWF       FARG_eeprom_i2c_read_size+0 
	CALL        _eeprom_i2c_read+0, 0
;table_eeprom.h,78 :: 		eeprom_i2c_read(0x0001,(char*)&myTable.size, 2);
	MOVLW       1
	MOVWF       FARG_eeprom_i2c_read_address+0 
	MOVLW       0
	MOVWF       FARG_eeprom_i2c_read_address+1 
	MOVLW       Expendedora_myTable+41
	MOVWF       FARG_eeprom_i2c_read_datos+0 
	MOVLW       hi_addr(Expendedora_myTable+41)
	MOVWF       FARG_eeprom_i2c_read_datos+1 
	MOVLW       2
	MOVWF       FARG_eeprom_i2c_read_size+0 
	CALL        _eeprom_i2c_read+0, 0
;table_eeprom.h,79 :: 		}
L_end_mysql_init:
	RETURN      0
; end of _mysql_init

_mysql_exist:

;table_eeprom.h,81 :: 		bool mysql_exist(char *name){
;table_eeprom.h,82 :: 		myTable.address = 0x0003;  //Direccion 3 para lectura
	MOVLW       3
	MOVWF       Expendedora_myTable+43 
	MOVLW       0
	MOVWF       Expendedora_myTable+44 
;table_eeprom.h,83 :: 		myTable.nameColAct[0] = 0; //Resetear mensaje
	CLRF        Expendedora_myTable+23 
;table_eeprom.h,85 :: 		for(myTable.cont = 0; myTable.cont < myTable.numTables; myTable.cont++){
	CLRF        Expendedora_myTable+47 
L_mysql_exist428:
	MOVF        Expendedora_myTable+0, 0 
	SUBWF       Expendedora_myTable+47, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_mysql_exist429
;table_eeprom.h,87 :: 		eeprom_i2c_read(myTable.address, myTable.nameAct, TABLE_MAX_SIZE_NAME+1);
	MOVF        Expendedora_myTable+43, 0 
	MOVWF       FARG_eeprom_i2c_read_address+0 
	MOVF        Expendedora_myTable+44, 0 
	MOVWF       FARG_eeprom_i2c_read_address+1 
	MOVLW       Expendedora_myTable+7
	MOVWF       FARG_eeprom_i2c_read_datos+0 
	MOVLW       hi_addr(Expendedora_myTable+7)
	MOVWF       FARG_eeprom_i2c_read_datos+1 
	MOVLW       16
	MOVWF       FARG_eeprom_i2c_read_size+0 
	CALL        _eeprom_i2c_read+0, 0
;table_eeprom.h,89 :: 		if(!strncmp(name, myTable.nameAct, TABLE_MAX_SIZE_NAME+1))
	MOVF        FARG_mysql_exist_name+0, 0 
	MOVWF       FARG_strncmp_s1+0 
	MOVF        FARG_mysql_exist_name+1, 0 
	MOVWF       FARG_strncmp_s1+1 
	MOVLW       Expendedora_myTable+7
	MOVWF       FARG_strncmp_s2+0 
	MOVLW       hi_addr(Expendedora_myTable+7)
	MOVWF       FARG_strncmp_s2+1 
	MOVLW       16
	MOVWF       FARG_strncmp_len+0 
	CALL        _strncmp+0, 0
	MOVF        R0, 0 
	IORWF       R1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L_mysql_exist431
;table_eeprom.h,90 :: 		break;
	GOTO        L_mysql_exist429
L_mysql_exist431:
;table_eeprom.h,92 :: 		eeprom_i2c_read(myTable.address+TABLE_MAX_SIZE_NAME+1, (char*)&myTable.address, 2);
	MOVLW       15
	ADDWF       Expendedora_myTable+43, 0 
	MOVWF       FARG_eeprom_i2c_read_address+0 
	MOVLW       0
	ADDWFC      Expendedora_myTable+44, 0 
	MOVWF       FARG_eeprom_i2c_read_address+1 
	INFSNZ      FARG_eeprom_i2c_read_address+0, 1 
	INCF        FARG_eeprom_i2c_read_address+1, 1 
	MOVLW       Expendedora_myTable+43
	MOVWF       FARG_eeprom_i2c_read_datos+0 
	MOVLW       hi_addr(Expendedora_myTable+43)
	MOVWF       FARG_eeprom_i2c_read_datos+1 
	MOVLW       2
	MOVWF       FARG_eeprom_i2c_read_size+0 
	CALL        _eeprom_i2c_read+0, 0
;table_eeprom.h,85 :: 		for(myTable.cont = 0; myTable.cont < myTable.numTables; myTable.cont++){
	MOVF        Expendedora_myTable+47, 0 
	ADDLW       1
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       Expendedora_myTable+47 
;table_eeprom.h,93 :: 		}
	GOTO        L_mysql_exist428
L_mysql_exist429:
;table_eeprom.h,95 :: 		if(myTable.cont < myTable.numTables){
	MOVF        Expendedora_myTable+0, 0 
	SUBWF       Expendedora_myTable+47, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_mysql_exist432
;table_eeprom.h,96 :: 		myTable.addressAct = myTable.address;   //Copiar direccion casa de la tabla
	MOVF        Expendedora_myTable+43, 0 
	MOVWF       Expendedora_myTable+45 
	MOVF        Expendedora_myTable+44, 0 
	MOVWF       Expendedora_myTable+46 
;table_eeprom.h,98 :: 		myTable.addressAct += TABLE_MAX_SIZE_NAME+3;
	MOVLW       18
	ADDWF       Expendedora_myTable+43, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      Expendedora_myTable+44, 0 
	MOVWF       R1 
	MOVF        R0, 0 
	MOVWF       Expendedora_myTable+45 
	MOVF        R1, 0 
	MOVWF       Expendedora_myTable+46 
;table_eeprom.h,99 :: 		eeprom_i2c_read(myTable.addressAct,(char*)&myTable.rowAct, 2);
	MOVF        R0, 0 
	MOVWF       FARG_eeprom_i2c_read_address+0 
	MOVF        R1, 0 
	MOVWF       FARG_eeprom_i2c_read_address+1 
	MOVLW       Expendedora_myTable+4
	MOVWF       FARG_eeprom_i2c_read_datos+0 
	MOVLW       hi_addr(Expendedora_myTable+4)
	MOVWF       FARG_eeprom_i2c_read_datos+1 
	MOVLW       2
	MOVWF       FARG_eeprom_i2c_read_size+0 
	CALL        _eeprom_i2c_read+0, 0
;table_eeprom.h,100 :: 		eeprom_i2c_read(myTable.addressAct+2,(char*)&myTable.row, 2);
	MOVLW       2
	ADDWF       Expendedora_myTable+45, 0 
	MOVWF       FARG_eeprom_i2c_read_address+0 
	MOVLW       0
	ADDWFC      Expendedora_myTable+46, 0 
	MOVWF       FARG_eeprom_i2c_read_address+1 
	MOVLW       Expendedora_myTable+2
	MOVWF       FARG_eeprom_i2c_read_datos+0 
	MOVLW       hi_addr(Expendedora_myTable+2)
	MOVWF       FARG_eeprom_i2c_read_datos+1 
	MOVLW       2
	MOVWF       FARG_eeprom_i2c_read_size+0 
	CALL        _eeprom_i2c_read+0, 0
;table_eeprom.h,101 :: 		eeprom_i2c_read(myTable.addressAct+4,&myTable.col, 1); //Filas totales de busqueda
	MOVLW       4
	ADDWF       Expendedora_myTable+45, 0 
	MOVWF       FARG_eeprom_i2c_read_address+0 
	MOVLW       0
	ADDWFC      Expendedora_myTable+46, 0 
	MOVWF       FARG_eeprom_i2c_read_address+1 
	MOVLW       Expendedora_myTable+1
	MOVWF       FARG_eeprom_i2c_read_datos+0 
	MOVLW       hi_addr(Expendedora_myTable+1)
	MOVWF       FARG_eeprom_i2c_read_datos+1 
	MOVLW       1
	MOVWF       FARG_eeprom_i2c_read_size+0 
	CALL        _eeprom_i2c_read+0, 0
;table_eeprom.h,102 :: 		return true;
	MOVLW       1
	MOVWF       R0 
	GOTO        L_end_mysql_exist
;table_eeprom.h,103 :: 		}else{
L_mysql_exist432:
;table_eeprom.h,104 :: 		myTable.nameAct[0] = 0;
	CLRF        Expendedora_myTable+7 
;table_eeprom.h,105 :: 		return false;
	CLRF        R0 
;table_eeprom.h,107 :: 		}
L_end_mysql_exist:
	RETURN      0
; end of _mysql_exist

_mysql_create_new:

;table_eeprom.h,109 :: 		char mysql_create_new(char *name, char *columnas, int filas){
;table_eeprom.h,110 :: 		unsigned int tam, acum = 0;   //Tamño a ser escrito
	CLRF        mysql_create_new_acum_L0+0 
	CLRF        mysql_create_new_acum_L0+1 
;table_eeprom.h,115 :: 		if(strlen(name) > TABLE_MAX_SIZE_NAME){
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
	GOTO        L__mysql_create_new1241
	MOVF        R0, 0 
	SUBLW       15
L__mysql_create_new1241:
	BTFSC       STATUS+0, 0 
	GOTO        L_mysql_create_new434
;table_eeprom.h,116 :: 		return TABLE_CREATE_NAME_OUT_RANGE;     //Excede el tamaño del nombre permisible
	MOVLW       1
	MOVWF       R0 
	GOTO        L_end_mysql_create_new
;table_eeprom.h,117 :: 		}
L_mysql_create_new434:
;table_eeprom.h,120 :: 		if(!mysql_exist(name)){
	MOVF        FARG_mysql_create_new_name+0, 0 
	MOVWF       FARG_mysql_exist_name+0 
	MOVF        FARG_mysql_create_new_name+1, 0 
	MOVWF       FARG_mysql_exist_name+1 
	CALL        _mysql_exist+0, 0
	MOVF        R0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_mysql_create_new435
;table_eeprom.h,122 :: 		col = 0;
	CLRF        mysql_create_new_col_L0+0 
;table_eeprom.h,123 :: 		myTable.cont = 0;
	CLRF        Expendedora_myTable+47 
;table_eeprom.h,124 :: 		tam = TABLE_MAX_SIZE_NAME+1;   //Tamaño por el nombre
	MOVLW       16
	MOVWF       mysql_create_new_tam_L0+0 
	MOVLW       0
	MOVWF       mysql_create_new_tam_L0+1 
;table_eeprom.h,125 :: 		tam += 2;                      //Contiene el tamaño de la tabla
	MOVLW       18
	MOVWF       mysql_create_new_tam_L0+0 
	MOVLW       0
	MOVWF       mysql_create_new_tam_L0+1 
;table_eeprom.h,126 :: 		tam += 2;                      //Contiene la fila actual
	MOVLW       20
	MOVWF       mysql_create_new_tam_L0+0 
	MOVLW       0
	MOVWF       mysql_create_new_tam_L0+1 
;table_eeprom.h,127 :: 		tam += 2;                      //Contiene las filas programadas
	MOVLW       22
	MOVWF       mysql_create_new_tam_L0+0 
	MOVLW       0
	MOVWF       mysql_create_new_tam_L0+1 
;table_eeprom.h,128 :: 		tam += 1;                      //Contiene la columnas programadas
	MOVLW       23
	MOVWF       mysql_create_new_tam_L0+0 
	MOVLW       0
	MOVWF       mysql_create_new_tam_L0+1 
;table_eeprom.h,131 :: 		aux = 0;
	CLRF        mysql_create_new_aux_L0+0 
;table_eeprom.h,132 :: 		while(columnas[myTable.cont]){
L_mysql_create_new436:
	MOVF        Expendedora_myTable+47, 0 
	ADDWF       FARG_mysql_create_new_columnas+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_mysql_create_new_columnas+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_mysql_create_new437
;table_eeprom.h,133 :: 		aux++;
	INCF        mysql_create_new_aux_L0+0, 1 
;table_eeprom.h,135 :: 		if(columnas[myTable.cont++] == '&'){
	MOVF        Expendedora_myTable+47, 0 
	MOVWF       R1 
	MOVF        Expendedora_myTable+47, 0 
	ADDLW       1
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       Expendedora_myTable+47 
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
;table_eeprom.h,137 :: 		if(aux > TABLE_MAX_SIZE_NAME+1){
	MOVLW       128
	XORLW       0
	MOVWF       R0 
	MOVLW       128
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__mysql_create_new1242
	MOVF        mysql_create_new_aux_L0+0, 0 
	SUBLW       16
L__mysql_create_new1242:
	BTFSC       STATUS+0, 0 
	GOTO        L_mysql_create_new439
;table_eeprom.h,138 :: 		return TABLE_CREATE_NAME_COL_OUT_RANGE;  //Excede el tamaño del nombre de la columna
	MOVLW       2
	MOVWF       R0 
	GOTO        L_end_mysql_create_new
;table_eeprom.h,139 :: 		}
L_mysql_create_new439:
;table_eeprom.h,140 :: 		aux = 0;                        //Resetear
	CLRF        mysql_create_new_aux_L0+0 
;table_eeprom.h,141 :: 		tam += TABLE_MAX_SIZE_NAME+1;   //Agregamos el texto de la columna
	MOVLW       16
	ADDWF       mysql_create_new_tam_L0+0, 1 
	MOVLW       0
	ADDWFC      mysql_create_new_tam_L0+1, 1 
;table_eeprom.h,142 :: 		tam += 1;                       //El espacio ocupado por la columna
	INFSNZ      mysql_create_new_tam_L0+0, 1 
	INCF        mysql_create_new_tam_L0+1, 1 
;table_eeprom.h,144 :: 		i = 0;    //Para guardar la cadena numero
	CLRF        mysql_create_new_i_L0+0 
;table_eeprom.h,145 :: 		while(columnas[myTable.cont] != '\n' && columnas[myTable.cont])
L_mysql_create_new440:
	MOVF        Expendedora_myTable+47, 0 
	ADDWF       FARG_mysql_create_new_columnas+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_mysql_create_new_columnas+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	XORLW       10
	BTFSC       STATUS+0, 2 
	GOTO        L_mysql_create_new441
	MOVF        Expendedora_myTable+47, 0 
	ADDWF       FARG_mysql_create_new_columnas+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_mysql_create_new_columnas+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_mysql_create_new441
L__mysql_create_new949:
;table_eeprom.h,146 :: 		cad[i++] = columnas[myTable.cont++];
	MOVLW       mysql_create_new_cad_L0+0
	MOVWF       FSR1 
	MOVLW       hi_addr(mysql_create_new_cad_L0+0)
	MOVWF       FSR1H 
	MOVF        mysql_create_new_i_L0+0, 0 
	ADDWF       FSR1, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR1H, 1 
	MOVF        Expendedora_myTable+47, 0 
	ADDWF       FARG_mysql_create_new_columnas+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_mysql_create_new_columnas+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       POSTINC1+0 
	INCF        mysql_create_new_i_L0+0, 1 
	MOVF        Expendedora_myTable+47, 0 
	ADDLW       1
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       Expendedora_myTable+47 
	GOTO        L_mysql_create_new440
L_mysql_create_new441:
;table_eeprom.h,147 :: 		col++;                       //Nueva columna
	INCF        mysql_create_new_col_L0+0, 1 
;table_eeprom.h,148 :: 		cad[i] = 0;                  //Agregar final de cadena
	MOVLW       mysql_create_new_cad_L0+0
	MOVWF       FSR1 
	MOVLW       hi_addr(mysql_create_new_cad_L0+0)
	MOVWF       FSR1H 
	MOVF        mysql_create_new_i_L0+0, 0 
	ADDWF       FSR1, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR1H, 1 
	CLRF        POSTINC1+0 
;table_eeprom.h,149 :: 		tam += filas*atoi(cad);      //Filas*col
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
;table_eeprom.h,150 :: 		}
L_mysql_create_new438:
;table_eeprom.h,151 :: 		}
	GOTO        L_mysql_create_new436
L_mysql_create_new437:
;table_eeprom.h,154 :: 		if(myTable.size+tam < myTable.sizeMax){
	MOVF        mysql_create_new_tam_L0+0, 0 
	ADDWF       Expendedora_myTable+41, 0 
	MOVWF       R1 
	MOVF        mysql_create_new_tam_L0+1, 0 
	ADDWFC      Expendedora_myTable+42, 0 
	MOVWF       R2 
	MOVF        Expendedora_myTable+40, 0 
	SUBWF       R2, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__mysql_create_new1243
	MOVF        Expendedora_myTable+39, 0 
	SUBWF       R1, 0 
L__mysql_create_new1243:
	BTFSC       STATUS+0, 0 
	GOTO        L_mysql_create_new444
;table_eeprom.h,155 :: 		aux = 0;
	CLRF        mysql_create_new_aux_L0+0 
;table_eeprom.h,156 :: 		tam += myTable.size;
	MOVF        Expendedora_myTable+41, 0 
	ADDWF       mysql_create_new_tam_L0+0, 1 
	MOVF        Expendedora_myTable+42, 0 
	ADDWFC      mysql_create_new_tam_L0+1, 1 
;table_eeprom.h,158 :: 		eeprom_i2c_write(myTable.size, name, strlen(name)+1);
	MOVF        FARG_mysql_create_new_name+0, 0 
	MOVWF       FARG_strlen_s+0 
	MOVF        FARG_mysql_create_new_name+1, 0 
	MOVWF       FARG_strlen_s+1 
	CALL        _strlen+0, 0
	MOVF        R0, 0 
	ADDLW       1
	MOVWF       FARG_eeprom_i2c_write_size+0 
	MOVF        Expendedora_myTable+41, 0 
	MOVWF       FARG_eeprom_i2c_write_address+0 
	MOVF        Expendedora_myTable+42, 0 
	MOVWF       FARG_eeprom_i2c_write_address+1 
	MOVF        FARG_mysql_create_new_name+0, 0 
	MOVWF       FARG_eeprom_i2c_write_datos+0 
	MOVF        FARG_mysql_create_new_name+1, 0 
	MOVWF       FARG_eeprom_i2c_write_datos+1 
	CALL        _eeprom_i2c_write+0, 0
;table_eeprom.h,159 :: 		myTable.size += TABLE_MAX_SIZE_NAME+1;  //Sumar cantidad actual
	MOVLW       16
	ADDWF       Expendedora_myTable+41, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      Expendedora_myTable+42, 0 
	MOVWF       R1 
	MOVF        R0, 0 
	MOVWF       Expendedora_myTable+41 
	MOVF        R1, 0 
	MOVWF       Expendedora_myTable+42 
;table_eeprom.h,161 :: 		eeprom_i2c_write(myTable.size, (char*)&tam, 2);
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
;table_eeprom.h,162 :: 		myTable.size += 2;
	MOVLW       2
	ADDWF       Expendedora_myTable+41, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      Expendedora_myTable+42, 0 
	MOVWF       R1 
	MOVF        R0, 0 
	MOVWF       Expendedora_myTable+41 
	MOVF        R1, 0 
	MOVWF       Expendedora_myTable+42 
;table_eeprom.h,164 :: 		myTable.rowAct = 0;  //Reutilizar para filas actuales
	CLRF        Expendedora_myTable+4 
	CLRF        Expendedora_myTable+5 
;table_eeprom.h,165 :: 		eeprom_i2c_write(myTable.size, (char*)&myTable.rowAct, 2);
	MOVF        Expendedora_myTable+41, 0 
	MOVWF       FARG_eeprom_i2c_write_address+0 
	MOVF        Expendedora_myTable+42, 0 
	MOVWF       FARG_eeprom_i2c_write_address+1 
	MOVLW       Expendedora_myTable+4
	MOVWF       FARG_eeprom_i2c_write_datos+0 
	MOVLW       hi_addr(Expendedora_myTable+4)
	MOVWF       FARG_eeprom_i2c_write_datos+1 
	MOVLW       2
	MOVWF       FARG_eeprom_i2c_write_size+0 
	CALL        _eeprom_i2c_write+0, 0
;table_eeprom.h,166 :: 		myTable.size += 2;
	MOVLW       2
	ADDWF       Expendedora_myTable+41, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      Expendedora_myTable+42, 0 
	MOVWF       R1 
	MOVF        R0, 0 
	MOVWF       Expendedora_myTable+41 
	MOVF        R1, 0 
	MOVWF       Expendedora_myTable+42 
;table_eeprom.h,168 :: 		eeprom_i2c_write(myTable.size, (char*)&filas, 2);
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
;table_eeprom.h,169 :: 		myTable.size += 2;
	MOVLW       2
	ADDWF       Expendedora_myTable+41, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      Expendedora_myTable+42, 0 
	MOVWF       R1 
	MOVF        R0, 0 
	MOVWF       Expendedora_myTable+41 
	MOVF        R1, 0 
	MOVWF       Expendedora_myTable+42 
;table_eeprom.h,171 :: 		eeprom_i2c_write(myTable.size, &col, 1);
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
;table_eeprom.h,172 :: 		myTable.size += 1;
	MOVLW       1
	ADDWF       Expendedora_myTable+41, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      Expendedora_myTable+42, 0 
	MOVWF       R1 
	MOVF        R0, 0 
	MOVWF       Expendedora_myTable+41 
	MOVF        R1, 0 
	MOVWF       Expendedora_myTable+42 
;table_eeprom.h,174 :: 		myTable.cont = 0;    //Contador actual
	CLRF        Expendedora_myTable+47 
;table_eeprom.h,175 :: 		tam = myTable.size;  //Reutilizar el dato momentaneamente
	MOVF        Expendedora_myTable+41, 0 
	MOVWF       mysql_create_new_tam_L0+0 
	MOVF        Expendedora_myTable+42, 0 
	MOVWF       mysql_create_new_tam_L0+1 
;table_eeprom.h,177 :: 		while(columnas[myTable.cont]){
L_mysql_create_new445:
	MOVF        Expendedora_myTable+47, 0 
	ADDWF       FARG_mysql_create_new_columnas+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_mysql_create_new_columnas+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_mysql_create_new446
;table_eeprom.h,179 :: 		eeprom_i2c_write(tam++, &columnas[myTable.cont++], 1);
	MOVF        mysql_create_new_tam_L0+0, 0 
	MOVWF       FARG_eeprom_i2c_write_address+0 
	MOVF        mysql_create_new_tam_L0+1, 0 
	MOVWF       FARG_eeprom_i2c_write_address+1 
	MOVF        Expendedora_myTable+47, 0 
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
	MOVF        Expendedora_myTable+47, 0 
	ADDLW       1
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       Expendedora_myTable+47 
;table_eeprom.h,181 :: 		if(columnas[myTable.cont] == '&'){
	MOVF        Expendedora_myTable+47, 0 
	ADDWF       FARG_mysql_create_new_columnas+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_mysql_create_new_columnas+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	XORLW       38
	BTFSS       STATUS+0, 2 
	GOTO        L_mysql_create_new447
;table_eeprom.h,182 :: 		myTable.cont++;
	MOVF        Expendedora_myTable+47, 0 
	ADDLW       1
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       Expendedora_myTable+47 
;table_eeprom.h,183 :: 		eeprom_i2c_write(tam++, &aux, 1);        //Final de cadena
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
;table_eeprom.h,184 :: 		myTable.size += TABLE_MAX_SIZE_NAME+1;   //Agregamos el texto de la columna
	MOVLW       16
	ADDWF       Expendedora_myTable+41, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      Expendedora_myTable+42, 0 
	MOVWF       R1 
	MOVF        R0, 0 
	MOVWF       Expendedora_myTable+41 
	MOVF        R1, 0 
	MOVWF       Expendedora_myTable+42 
;table_eeprom.h,186 :: 		i = 0;    //Para guardar la cadena numero
	CLRF        mysql_create_new_i_L0+0 
;table_eeprom.h,187 :: 		while(columnas[myTable.cont]){
L_mysql_create_new448:
	MOVF        Expendedora_myTable+47, 0 
	ADDWF       FARG_mysql_create_new_columnas+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_mysql_create_new_columnas+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_mysql_create_new449
;table_eeprom.h,188 :: 		cad[i++] = columnas[myTable.cont++];
	MOVLW       mysql_create_new_cad_L0+0
	MOVWF       FSR1 
	MOVLW       hi_addr(mysql_create_new_cad_L0+0)
	MOVWF       FSR1H 
	MOVF        mysql_create_new_i_L0+0, 0 
	ADDWF       FSR1, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR1H, 1 
	MOVF        Expendedora_myTable+47, 0 
	ADDWF       FARG_mysql_create_new_columnas+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_mysql_create_new_columnas+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	MOVWF       POSTINC1+0 
	INCF        mysql_create_new_i_L0+0, 1 
	MOVF        Expendedora_myTable+47, 0 
	ADDLW       1
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       Expendedora_myTable+47 
;table_eeprom.h,189 :: 		if(columnas[myTable.cont] == '\n'){
	MOVF        Expendedora_myTable+47, 0 
	ADDWF       FARG_mysql_create_new_columnas+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_mysql_create_new_columnas+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	XORLW       10
	BTFSS       STATUS+0, 2 
	GOTO        L_mysql_create_new450
;table_eeprom.h,190 :: 		myTable.cont++;
	MOVF        Expendedora_myTable+47, 0 
	ADDLW       1
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       Expendedora_myTable+47 
;table_eeprom.h,191 :: 		break;
	GOTO        L_mysql_create_new449
;table_eeprom.h,192 :: 		}
L_mysql_create_new450:
;table_eeprom.h,193 :: 		}
	GOTO        L_mysql_create_new448
L_mysql_create_new449:
;table_eeprom.h,194 :: 		cad[i] = 0;                  //Agregar final de cadena
	MOVLW       mysql_create_new_cad_L0+0
	MOVWF       FSR1 
	MOVLW       hi_addr(mysql_create_new_cad_L0+0)
	MOVWF       FSR1H 
	MOVF        mysql_create_new_i_L0+0, 0 
	ADDWF       FSR1, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR1H, 1 
	CLRF        POSTINC1+0 
;table_eeprom.h,195 :: 		col = atoi(cad);
	MOVLW       mysql_create_new_cad_L0+0
	MOVWF       FARG_atoi_s+0 
	MOVLW       hi_addr(mysql_create_new_cad_L0+0)
	MOVWF       FARG_atoi_s+1 
	CALL        _atoi+0, 0
	MOVF        R0, 0 
	MOVWF       mysql_create_new_col_L0+0 
;table_eeprom.h,196 :: 		eeprom_i2c_write(myTable.size, &col, 1); //Agregamos los bytes a usar por col
	MOVF        Expendedora_myTable+41, 0 
	MOVWF       FARG_eeprom_i2c_write_address+0 
	MOVF        Expendedora_myTable+42, 0 
	MOVWF       FARG_eeprom_i2c_write_address+1 
	MOVLW       mysql_create_new_col_L0+0
	MOVWF       FARG_eeprom_i2c_write_datos+0 
	MOVLW       hi_addr(mysql_create_new_col_L0+0)
	MOVWF       FARG_eeprom_i2c_write_datos+1 
	MOVLW       1
	MOVWF       FARG_eeprom_i2c_write_size+0 
	CALL        _eeprom_i2c_write+0, 0
;table_eeprom.h,197 :: 		myTable.size += 1;                       //Agregamos el texto de la columna
	MOVLW       1
	ADDWF       Expendedora_myTable+41, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      Expendedora_myTable+42, 0 
	MOVWF       R1 
	MOVF        R0, 0 
	MOVWF       Expendedora_myTable+41 
	MOVF        R1, 0 
	MOVWF       Expendedora_myTable+42 
;table_eeprom.h,198 :: 		acum += col*filas;
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
;table_eeprom.h,200 :: 		tam = myTable.size;
	MOVF        Expendedora_myTable+41, 0 
	MOVWF       mysql_create_new_tam_L0+0 
	MOVF        Expendedora_myTable+42, 0 
	MOVWF       mysql_create_new_tam_L0+1 
;table_eeprom.h,201 :: 		}
L_mysql_create_new447:
;table_eeprom.h,202 :: 		}
	GOTO        L_mysql_create_new445
L_mysql_create_new446:
;table_eeprom.h,203 :: 		myTable.size += acum;  //Respaldamos el contenido total
	MOVF        mysql_create_new_acum_L0+0, 0 
	ADDWF       Expendedora_myTable+41, 0 
	MOVWF       R0 
	MOVF        mysql_create_new_acum_L0+1, 0 
	ADDWFC      Expendedora_myTable+42, 0 
	MOVWF       R1 
	MOVF        R0, 0 
	MOVWF       Expendedora_myTable+41 
	MOVF        R1, 0 
	MOVWF       Expendedora_myTable+42 
;table_eeprom.h,204 :: 		myTable.numTables++;   //Agregar tabla y tamaño actuales
	MOVF        Expendedora_myTable+0, 0 
	ADDLW       1
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       Expendedora_myTable+0 
;table_eeprom.h,205 :: 		eeprom_i2c_write(0x0000, &myTable.numTables, 1);
	CLRF        FARG_eeprom_i2c_write_address+0 
	CLRF        FARG_eeprom_i2c_write_address+1 
	MOVLW       Expendedora_myTable+0
	MOVWF       FARG_eeprom_i2c_write_datos+0 
	MOVLW       hi_addr(Expendedora_myTable+0)
	MOVWF       FARG_eeprom_i2c_write_datos+1 
	MOVLW       1
	MOVWF       FARG_eeprom_i2c_write_size+0 
	CALL        _eeprom_i2c_write+0, 0
;table_eeprom.h,206 :: 		eeprom_i2c_write(0x0001,(char*)&myTable.size, 2);
	MOVLW       1
	MOVWF       FARG_eeprom_i2c_write_address+0 
	MOVLW       0
	MOVWF       FARG_eeprom_i2c_write_address+1 
	MOVLW       Expendedora_myTable+41
	MOVWF       FARG_eeprom_i2c_write_datos+0 
	MOVLW       hi_addr(Expendedora_myTable+41)
	MOVWF       FARG_eeprom_i2c_write_datos+1 
	MOVLW       2
	MOVWF       FARG_eeprom_i2c_write_size+0 
	CALL        _eeprom_i2c_write+0, 0
;table_eeprom.h,208 :: 		}else{
	GOTO        L_mysql_create_new451
L_mysql_create_new444:
;table_eeprom.h,209 :: 		return TABLE_CREATE_MEMORY_FULL;  //Memoria agotada
	MOVLW       3
	MOVWF       R0 
	GOTO        L_end_mysql_create_new
;table_eeprom.h,210 :: 		}
L_mysql_create_new451:
;table_eeprom.h,211 :: 		}else{
	GOTO        L_mysql_create_new452
L_mysql_create_new435:
;table_eeprom.h,212 :: 		return TABLE_CREATE_REPEAT;    //Ya existe la tabla
	MOVLW       4
	MOVWF       R0 
	GOTO        L_end_mysql_create_new
;table_eeprom.h,213 :: 		}
L_mysql_create_new452:
;table_eeprom.h,215 :: 		return TABLE_CREATE_SUCCESS;      //Tabla creada con exito
	CLRF        R0 
;table_eeprom.h,216 :: 		}
L_end_mysql_create_new:
	RETURN      0
; end of _mysql_create_new

_mysql_read_string:

;table_eeprom.h,218 :: 		char mysql_read_string(char *name, char *column, int fila, char *result){
;table_eeprom.h,219 :: 		char res = _mysql_calculate_address(name, column);
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
;table_eeprom.h,222 :: 		if(res)
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_mysql_read_string453
;table_eeprom.h,223 :: 		return res;
	MOVF        mysql_read_string_res_L0+0, 0 
	MOVWF       R0 
	GOTO        L_end_mysql_read_string
L_mysql_read_string453:
;table_eeprom.h,226 :: 		if(fila >= 1 && fila <= myTable.rowAct)
	MOVLW       128
	XORWF       FARG_mysql_read_string_fila+1, 0 
	MOVWF       R0 
	MOVLW       128
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__mysql_read_string1245
	MOVLW       1
	SUBWF       FARG_mysql_read_string_fila+0, 0 
L__mysql_read_string1245:
	BTFSS       STATUS+0, 0 
	GOTO        L_mysql_read_string456
	MOVF        FARG_mysql_read_string_fila+1, 0 
	SUBWF       Expendedora_myTable+5, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__mysql_read_string1246
	MOVF        FARG_mysql_read_string_fila+0, 0 
	SUBWF       Expendedora_myTable+4, 0 
L__mysql_read_string1246:
	BTFSS       STATUS+0, 0 
	GOTO        L_mysql_read_string456
L__mysql_read_string950:
;table_eeprom.h,227 :: 		eeprom_i2c_read(myTable.addressAct+(fila-1)*myTable.tamCol, result, myTable.tamCol);
	MOVLW       1
	SUBWF       FARG_mysql_read_string_fila+0, 0 
	MOVWF       R0 
	MOVLW       0
	SUBWFB      FARG_mysql_read_string_fila+1, 0 
	MOVWF       R1 
	MOVF        Expendedora_myTable+6, 0 
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	MOVF        R0, 0 
	ADDWF       Expendedora_myTable+45, 0 
	MOVWF       FARG_eeprom_i2c_read_address+0 
	MOVF        R1, 0 
	ADDWFC      Expendedora_myTable+46, 0 
	MOVWF       FARG_eeprom_i2c_read_address+1 
	MOVF        FARG_mysql_read_string_result+0, 0 
	MOVWF       FARG_eeprom_i2c_read_datos+0 
	MOVF        FARG_mysql_read_string_result+1, 0 
	MOVWF       FARG_eeprom_i2c_read_datos+1 
	MOVF        Expendedora_myTable+6, 0 
	MOVWF       FARG_eeprom_i2c_read_size+0 
	CALL        _eeprom_i2c_read+0, 0
	GOTO        L_mysql_read_string457
L_mysql_read_string456:
;table_eeprom.h,229 :: 		return TABLE_RW_NO_EXIST_ROW;   //Fila inexistente
	MOVLW       3
	MOVWF       R0 
	GOTO        L_end_mysql_read_string
;table_eeprom.h,230 :: 		}
L_mysql_read_string457:
;table_eeprom.h,232 :: 		return TABLE_RW_SUCCESS;     //Exito en la busqueda
	CLRF        R0 
;table_eeprom.h,233 :: 		}
L_end_mysql_read_string:
	RETURN      0
; end of _mysql_read_string

_mysql_read:

;table_eeprom.h,235 :: 		char mysql_read(char *name, char *column, int fila, long *result){
;table_eeprom.h,236 :: 		char res = _mysql_calculate_address(name, column);
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
;table_eeprom.h,239 :: 		if(res)
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_mysql_read458
;table_eeprom.h,240 :: 		return res;
	MOVF        mysql_read_res_L0+0, 0 
	MOVWF       R0 
	GOTO        L_end_mysql_read
L_mysql_read458:
;table_eeprom.h,243 :: 		*result = 0;
	MOVFF       FARG_mysql_read_result+0, FSR1
	MOVFF       FARG_mysql_read_result+1, FSR1H
	CLRF        POSTINC1+0 
	CLRF        POSTINC1+0 
	CLRF        POSTINC1+0 
	CLRF        POSTINC1+0 
;table_eeprom.h,246 :: 		if(fila >= 1 && fila <= myTable.rowAct){
	MOVLW       128
	XORWF       FARG_mysql_read_fila+1, 0 
	MOVWF       R0 
	MOVLW       128
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__mysql_read1248
	MOVLW       1
	SUBWF       FARG_mysql_read_fila+0, 0 
L__mysql_read1248:
	BTFSS       STATUS+0, 0 
	GOTO        L_mysql_read461
	MOVF        FARG_mysql_read_fila+1, 0 
	SUBWF       Expendedora_myTable+5, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__mysql_read1249
	MOVF        FARG_mysql_read_fila+0, 0 
	SUBWF       Expendedora_myTable+4, 0 
L__mysql_read1249:
	BTFSS       STATUS+0, 0 
	GOTO        L_mysql_read461
L__mysql_read951:
;table_eeprom.h,247 :: 		if(myTable.tamCol <= 4)
	MOVF        Expendedora_myTable+6, 0 
	SUBLW       4
	BTFSS       STATUS+0, 0 
	GOTO        L_mysql_read462
;table_eeprom.h,248 :: 		eeprom_i2c_read(myTable.addressAct+(fila-1)*myTable.tamCol, (char*)&(*result), myTable.tamCol);
	MOVLW       1
	SUBWF       FARG_mysql_read_fila+0, 0 
	MOVWF       R0 
	MOVLW       0
	SUBWFB      FARG_mysql_read_fila+1, 0 
	MOVWF       R1 
	MOVF        Expendedora_myTable+6, 0 
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	MOVF        R0, 0 
	ADDWF       Expendedora_myTable+45, 0 
	MOVWF       FARG_eeprom_i2c_read_address+0 
	MOVF        R1, 0 
	ADDWFC      Expendedora_myTable+46, 0 
	MOVWF       FARG_eeprom_i2c_read_address+1 
	MOVF        FARG_mysql_read_result+0, 0 
	MOVWF       FARG_eeprom_i2c_read_datos+0 
	MOVF        FARG_mysql_read_result+1, 0 
	MOVWF       FARG_eeprom_i2c_read_datos+1 
	MOVF        Expendedora_myTable+6, 0 
	MOVWF       FARG_eeprom_i2c_read_size+0 
	CALL        _eeprom_i2c_read+0, 0
	GOTO        L_mysql_read463
L_mysql_read462:
;table_eeprom.h,250 :: 		return TABLE_RW_OUT_RANGE_BYTES;
	MOVLW       6
	MOVWF       R0 
	GOTO        L_end_mysql_read
;table_eeprom.h,251 :: 		}
L_mysql_read463:
;table_eeprom.h,252 :: 		}else{
	GOTO        L_mysql_read464
L_mysql_read461:
;table_eeprom.h,253 :: 		return TABLE_RW_NO_EXIST_ROW;   //Fila inexistente
	MOVLW       3
	MOVWF       R0 
	GOTO        L_end_mysql_read
;table_eeprom.h,254 :: 		}
L_mysql_read464:
;table_eeprom.h,256 :: 		return TABLE_RW_SUCCESS;
	CLRF        R0 
;table_eeprom.h,257 :: 		}
L_end_mysql_read:
	RETURN      0
; end of _mysql_read

_mysql_read_forced:

;table_eeprom.h,259 :: 		char mysql_read_forced(char *name, char *column, int fila, char *result){
;table_eeprom.h,260 :: 		char res = _mysql_calculate_address(name, column);
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
;table_eeprom.h,263 :: 		if(res)
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_mysql_read_forced465
;table_eeprom.h,264 :: 		return res;
	MOVF        mysql_read_forced_res_L0+0, 0 
	MOVWF       R0 
	GOTO        L_end_mysql_read_forced
L_mysql_read_forced465:
;table_eeprom.h,267 :: 		if(fila >= 1 && fila <= myTable.row)
	MOVLW       128
	XORWF       FARG_mysql_read_forced_fila+1, 0 
	MOVWF       R0 
	MOVLW       128
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__mysql_read_forced1251
	MOVLW       1
	SUBWF       FARG_mysql_read_forced_fila+0, 0 
L__mysql_read_forced1251:
	BTFSS       STATUS+0, 0 
	GOTO        L_mysql_read_forced468
	MOVF        FARG_mysql_read_forced_fila+1, 0 
	SUBWF       Expendedora_myTable+3, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__mysql_read_forced1252
	MOVF        FARG_mysql_read_forced_fila+0, 0 
	SUBWF       Expendedora_myTable+2, 0 
L__mysql_read_forced1252:
	BTFSS       STATUS+0, 0 
	GOTO        L_mysql_read_forced468
L__mysql_read_forced952:
;table_eeprom.h,268 :: 		eeprom_i2c_read(myTable.addressAct+(fila-1)*myTable.tamCol, result, myTable.tamCol);
	MOVLW       1
	SUBWF       FARG_mysql_read_forced_fila+0, 0 
	MOVWF       R0 
	MOVLW       0
	SUBWFB      FARG_mysql_read_forced_fila+1, 0 
	MOVWF       R1 
	MOVF        Expendedora_myTable+6, 0 
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	MOVF        R0, 0 
	ADDWF       Expendedora_myTable+45, 0 
	MOVWF       FARG_eeprom_i2c_read_address+0 
	MOVF        R1, 0 
	ADDWFC      Expendedora_myTable+46, 0 
	MOVWF       FARG_eeprom_i2c_read_address+1 
	MOVF        FARG_mysql_read_forced_result+0, 0 
	MOVWF       FARG_eeprom_i2c_read_datos+0 
	MOVF        FARG_mysql_read_forced_result+1, 0 
	MOVWF       FARG_eeprom_i2c_read_datos+1 
	MOVF        Expendedora_myTable+6, 0 
	MOVWF       FARG_eeprom_i2c_read_size+0 
	CALL        _eeprom_i2c_read+0, 0
	GOTO        L_mysql_read_forced469
L_mysql_read_forced468:
;table_eeprom.h,270 :: 		return TABLE_RW_NO_EXIST_ROW;   //Fila inexistente
	MOVLW       3
	MOVWF       R0 
	GOTO        L_end_mysql_read_forced
L_mysql_read_forced469:
;table_eeprom.h,272 :: 		return TABLE_RW_SUCCESS;     //Exito en la busqueda
	CLRF        R0 
;table_eeprom.h,273 :: 		}
L_end_mysql_read_forced:
	RETURN      0
; end of _mysql_read_forced

_mysql_write_string:

;table_eeprom.h,275 :: 		char mysql_write_string(char *name, char *column, int fila, char *texto, bool endWrite){
;table_eeprom.h,276 :: 		char res = _mysql_calculate_address(name, column);
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
;table_eeprom.h,279 :: 		if(res)
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_mysql_write_string470
;table_eeprom.h,280 :: 		return res;
	MOVF        mysql_write_string_res_L0+0, 0 
	MOVWF       R0 
	GOTO        L_end_mysql_write_string
L_mysql_write_string470:
;table_eeprom.h,283 :: 		myTable.cont = strlen(texto)+1;   //Calcular el tamaño de la cadena a escribir
	MOVF        FARG_mysql_write_string_texto+0, 0 
	MOVWF       FARG_strlen_s+0 
	MOVF        FARG_mysql_write_string_texto+1, 0 
	MOVWF       FARG_strlen_s+1 
	CALL        _strlen+0, 0
	MOVF        R0, 0 
	ADDLW       1
	MOVWF       R1 
	MOVF        R1, 0 
	MOVWF       Expendedora_myTable+47 
;table_eeprom.h,285 :: 		if(myTable.cont > myTable.tamCol){
	MOVF        R1, 0 
	SUBWF       Expendedora_myTable+6, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_mysql_write_string471
;table_eeprom.h,286 :: 		return TABLE_RW_OUT_RANGE;
	MOVLW       4
	MOVWF       R0 
	GOTO        L_end_mysql_write_string
;table_eeprom.h,287 :: 		}
L_mysql_write_string471:
;table_eeprom.h,289 :: 		if(endWrite){
	MOVF        FARG_mysql_write_string_endWrite+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_mysql_write_string472
;table_eeprom.h,290 :: 		if(myTable.rowAct < myTable.row){
	MOVF        Expendedora_myTable+3, 0 
	SUBWF       Expendedora_myTable+5, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__mysql_write_string1254
	MOVF        Expendedora_myTable+2, 0 
	SUBWF       Expendedora_myTable+4, 0 
L__mysql_write_string1254:
	BTFSC       STATUS+0, 0 
	GOTO        L_mysql_write_string473
;table_eeprom.h,291 :: 		eeprom_i2c_write(myTable.addressAct+myTable.rowAct*myTable.tamCol, texto, myTable.cont);
	MOVF        Expendedora_myTable+4, 0 
	MOVWF       R0 
	MOVF        Expendedora_myTable+5, 0 
	MOVWF       R1 
	MOVF        Expendedora_myTable+6, 0 
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	MOVF        R0, 0 
	ADDWF       Expendedora_myTable+45, 0 
	MOVWF       FARG_eeprom_i2c_write_address+0 
	MOVF        R1, 0 
	ADDWFC      Expendedora_myTable+46, 0 
	MOVWF       FARG_eeprom_i2c_write_address+1 
	MOVF        FARG_mysql_write_string_texto+0, 0 
	MOVWF       FARG_eeprom_i2c_write_datos+0 
	MOVF        FARG_mysql_write_string_texto+1, 0 
	MOVWF       FARG_eeprom_i2c_write_datos+1 
	MOVF        Expendedora_myTable+47, 0 
	MOVWF       FARG_eeprom_i2c_write_size+0 
	CALL        _eeprom_i2c_write+0, 0
;table_eeprom.h,292 :: 		myTable.rowAct++;
	MOVLW       1
	ADDWF       Expendedora_myTable+4, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      Expendedora_myTable+5, 0 
	MOVWF       R1 
	MOVF        R0, 0 
	MOVWF       Expendedora_myTable+4 
	MOVF        R1, 0 
	MOVWF       Expendedora_myTable+5 
;table_eeprom.h,293 :: 		eeprom_i2c_write(myTable.address+TABLE_MAX_SIZE_NAME+3, (char*)&myTable.rowAct, 2);
	MOVLW       15
	ADDWF       Expendedora_myTable+43, 0 
	MOVWF       FARG_eeprom_i2c_write_address+0 
	MOVLW       0
	ADDWFC      Expendedora_myTable+44, 0 
	MOVWF       FARG_eeprom_i2c_write_address+1 
	MOVLW       3
	ADDWF       FARG_eeprom_i2c_write_address+0, 1 
	MOVLW       0
	ADDWFC      FARG_eeprom_i2c_write_address+1, 1 
	MOVLW       Expendedora_myTable+4
	MOVWF       FARG_eeprom_i2c_write_datos+0 
	MOVLW       hi_addr(Expendedora_myTable+4)
	MOVWF       FARG_eeprom_i2c_write_datos+1 
	MOVLW       2
	MOVWF       FARG_eeprom_i2c_write_size+0 
	CALL        _eeprom_i2c_write+0, 0
;table_eeprom.h,294 :: 		}else{
	GOTO        L_mysql_write_string474
L_mysql_write_string473:
;table_eeprom.h,295 :: 		return TABLE_RW_TABLE_FULL;   //Memoria llena de la tabla
	MOVLW       5
	MOVWF       R0 
	GOTO        L_end_mysql_write_string
;table_eeprom.h,296 :: 		}
L_mysql_write_string474:
;table_eeprom.h,297 :: 		}else if(fila >= 1 && fila <= myTable.rowAct)
	GOTO        L_mysql_write_string475
L_mysql_write_string472:
	MOVLW       128
	XORWF       FARG_mysql_write_string_fila+1, 0 
	MOVWF       R0 
	MOVLW       128
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__mysql_write_string1255
	MOVLW       1
	SUBWF       FARG_mysql_write_string_fila+0, 0 
L__mysql_write_string1255:
	BTFSS       STATUS+0, 0 
	GOTO        L_mysql_write_string478
	MOVF        FARG_mysql_write_string_fila+1, 0 
	SUBWF       Expendedora_myTable+5, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__mysql_write_string1256
	MOVF        FARG_mysql_write_string_fila+0, 0 
	SUBWF       Expendedora_myTable+4, 0 
L__mysql_write_string1256:
	BTFSS       STATUS+0, 0 
	GOTO        L_mysql_write_string478
L__mysql_write_string953:
;table_eeprom.h,298 :: 		eeprom_i2c_write(myTable.addressAct+(fila-1)*myTable.tamCol, texto, myTable.cont);
	MOVLW       1
	SUBWF       FARG_mysql_write_string_fila+0, 0 
	MOVWF       R0 
	MOVLW       0
	SUBWFB      FARG_mysql_write_string_fila+1, 0 
	MOVWF       R1 
	MOVF        Expendedora_myTable+6, 0 
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	MOVF        R0, 0 
	ADDWF       Expendedora_myTable+45, 0 
	MOVWF       FARG_eeprom_i2c_write_address+0 
	MOVF        R1, 0 
	ADDWFC      Expendedora_myTable+46, 0 
	MOVWF       FARG_eeprom_i2c_write_address+1 
	MOVF        FARG_mysql_write_string_texto+0, 0 
	MOVWF       FARG_eeprom_i2c_write_datos+0 
	MOVF        FARG_mysql_write_string_texto+1, 0 
	MOVWF       FARG_eeprom_i2c_write_datos+1 
	MOVF        Expendedora_myTable+47, 0 
	MOVWF       FARG_eeprom_i2c_write_size+0 
	CALL        _eeprom_i2c_write+0, 0
	GOTO        L_mysql_write_string479
L_mysql_write_string478:
;table_eeprom.h,300 :: 		return TABLE_RW_NO_EXIST_ROW;   //Fila inexistente
	MOVLW       3
	MOVWF       R0 
	GOTO        L_end_mysql_write_string
;table_eeprom.h,301 :: 		}
L_mysql_write_string479:
L_mysql_write_string475:
;table_eeprom.h,303 :: 		return TABLE_RW_SUCCESS;     //Exito en grabacion
	CLRF        R0 
;table_eeprom.h,304 :: 		}
L_end_mysql_write_string:
	RETURN      0
; end of _mysql_write_string

_mysql_write:

;table_eeprom.h,306 :: 		char mysql_write(char *name, char *column, int fila, long value, bool endWrite){
;table_eeprom.h,307 :: 		char res = _mysql_calculate_address(name, column);
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
;table_eeprom.h,310 :: 		if(res)
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_mysql_write480
;table_eeprom.h,311 :: 		return res;
	MOVF        mysql_write_res_L0+0, 0 
	MOVWF       R0 
	GOTO        L_end_mysql_write
L_mysql_write480:
;table_eeprom.h,314 :: 		myTable.cont = myTable.tamCol;
	MOVF        Expendedora_myTable+6, 0 
	MOVWF       Expendedora_myTable+47 
;table_eeprom.h,315 :: 		if(myTable.cont > 4){
	MOVF        Expendedora_myTable+6, 0 
	SUBLW       4
	BTFSC       STATUS+0, 0 
	GOTO        L_mysql_write481
;table_eeprom.h,316 :: 		return TABLE_RW_OUT_RANGE_BYTES;
	MOVLW       6
	MOVWF       R0 
	GOTO        L_end_mysql_write
;table_eeprom.h,317 :: 		}
L_mysql_write481:
;table_eeprom.h,319 :: 		if(endWrite){
	MOVF        FARG_mysql_write_endWrite+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_mysql_write482
;table_eeprom.h,320 :: 		if(myTable.rowAct < myTable.row){
	MOVF        Expendedora_myTable+3, 0 
	SUBWF       Expendedora_myTable+5, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__mysql_write1258
	MOVF        Expendedora_myTable+2, 0 
	SUBWF       Expendedora_myTable+4, 0 
L__mysql_write1258:
	BTFSC       STATUS+0, 0 
	GOTO        L_mysql_write483
;table_eeprom.h,321 :: 		eeprom_i2c_write(myTable.addressAct+myTable.rowAct*myTable.tamCol, (char*)&value, myTable.cont);
	MOVF        Expendedora_myTable+4, 0 
	MOVWF       R0 
	MOVF        Expendedora_myTable+5, 0 
	MOVWF       R1 
	MOVF        Expendedora_myTable+6, 0 
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	MOVF        R0, 0 
	ADDWF       Expendedora_myTable+45, 0 
	MOVWF       FARG_eeprom_i2c_write_address+0 
	MOVF        R1, 0 
	ADDWFC      Expendedora_myTable+46, 0 
	MOVWF       FARG_eeprom_i2c_write_address+1 
	MOVLW       FARG_mysql_write_value+0
	MOVWF       FARG_eeprom_i2c_write_datos+0 
	MOVLW       hi_addr(FARG_mysql_write_value+0)
	MOVWF       FARG_eeprom_i2c_write_datos+1 
	MOVF        Expendedora_myTable+47, 0 
	MOVWF       FARG_eeprom_i2c_write_size+0 
	CALL        _eeprom_i2c_write+0, 0
;table_eeprom.h,322 :: 		myTable.rowAct++;
	MOVLW       1
	ADDWF       Expendedora_myTable+4, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      Expendedora_myTable+5, 0 
	MOVWF       R1 
	MOVF        R0, 0 
	MOVWF       Expendedora_myTable+4 
	MOVF        R1, 0 
	MOVWF       Expendedora_myTable+5 
;table_eeprom.h,323 :: 		eeprom_i2c_write(myTable.address+TABLE_MAX_SIZE_NAME+3, (char*)&myTable.rowAct, 2);
	MOVLW       15
	ADDWF       Expendedora_myTable+43, 0 
	MOVWF       FARG_eeprom_i2c_write_address+0 
	MOVLW       0
	ADDWFC      Expendedora_myTable+44, 0 
	MOVWF       FARG_eeprom_i2c_write_address+1 
	MOVLW       3
	ADDWF       FARG_eeprom_i2c_write_address+0, 1 
	MOVLW       0
	ADDWFC      FARG_eeprom_i2c_write_address+1, 1 
	MOVLW       Expendedora_myTable+4
	MOVWF       FARG_eeprom_i2c_write_datos+0 
	MOVLW       hi_addr(Expendedora_myTable+4)
	MOVWF       FARG_eeprom_i2c_write_datos+1 
	MOVLW       2
	MOVWF       FARG_eeprom_i2c_write_size+0 
	CALL        _eeprom_i2c_write+0, 0
;table_eeprom.h,324 :: 		}else
	GOTO        L_mysql_write484
L_mysql_write483:
;table_eeprom.h,325 :: 		return TABLE_RW_TABLE_FULL;   //Memoria llena de la tabla
	MOVLW       5
	MOVWF       R0 
	GOTO        L_end_mysql_write
L_mysql_write484:
;table_eeprom.h,326 :: 		}else if(fila >= 1 && fila <= myTable.rowAct)
	GOTO        L_mysql_write485
L_mysql_write482:
	MOVLW       128
	XORWF       FARG_mysql_write_fila+1, 0 
	MOVWF       R0 
	MOVLW       128
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__mysql_write1259
	MOVLW       1
	SUBWF       FARG_mysql_write_fila+0, 0 
L__mysql_write1259:
	BTFSS       STATUS+0, 0 
	GOTO        L_mysql_write488
	MOVF        FARG_mysql_write_fila+1, 0 
	SUBWF       Expendedora_myTable+5, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__mysql_write1260
	MOVF        FARG_mysql_write_fila+0, 0 
	SUBWF       Expendedora_myTable+4, 0 
L__mysql_write1260:
	BTFSS       STATUS+0, 0 
	GOTO        L_mysql_write488
L__mysql_write954:
;table_eeprom.h,327 :: 		eeprom_i2c_write(myTable.addressAct+(fila-1)*myTable.tamCol, (char*)&value, myTable.cont);
	MOVLW       1
	SUBWF       FARG_mysql_write_fila+0, 0 
	MOVWF       R0 
	MOVLW       0
	SUBWFB      FARG_mysql_write_fila+1, 0 
	MOVWF       R1 
	MOVF        Expendedora_myTable+6, 0 
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	MOVF        R0, 0 
	ADDWF       Expendedora_myTable+45, 0 
	MOVWF       FARG_eeprom_i2c_write_address+0 
	MOVF        R1, 0 
	ADDWFC      Expendedora_myTable+46, 0 
	MOVWF       FARG_eeprom_i2c_write_address+1 
	MOVLW       FARG_mysql_write_value+0
	MOVWF       FARG_eeprom_i2c_write_datos+0 
	MOVLW       hi_addr(FARG_mysql_write_value+0)
	MOVWF       FARG_eeprom_i2c_write_datos+1 
	MOVF        Expendedora_myTable+47, 0 
	MOVWF       FARG_eeprom_i2c_write_size+0 
	CALL        _eeprom_i2c_write+0, 0
	GOTO        L_mysql_write489
L_mysql_write488:
;table_eeprom.h,329 :: 		return TABLE_RW_NO_EXIST_ROW;   //Fila inexistente
	MOVLW       3
	MOVWF       R0 
	GOTO        L_end_mysql_write
L_mysql_write489:
L_mysql_write485:
;table_eeprom.h,331 :: 		return TABLE_RW_SUCCESS;     //Exito en grabacion
	CLRF        R0 
;table_eeprom.h,332 :: 		}
L_end_mysql_write:
	RETURN      0
; end of _mysql_write

_mysql_write_forced:

;table_eeprom.h,334 :: 		char mysql_write_forced(char *name, char *column, int fila, char *texto, char bytes){
;table_eeprom.h,335 :: 		char res = _mysql_calculate_address(name, column);
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
;table_eeprom.h,338 :: 		if(res)
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_mysql_write_forced490
;table_eeprom.h,339 :: 		return res;
	MOVF        mysql_write_forced_res_L0+0, 0 
	MOVWF       R0 
	GOTO        L_end_mysql_write_forced
L_mysql_write_forced490:
;table_eeprom.h,342 :: 		if(bytes > myTable.tamCol)
	MOVF        FARG_mysql_write_forced_bytes+0, 0 
	SUBWF       Expendedora_myTable+6, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_mysql_write_forced491
;table_eeprom.h,343 :: 		return TABLE_RW_OUT_RANGE;
	MOVLW       4
	MOVWF       R0 
	GOTO        L_end_mysql_write_forced
L_mysql_write_forced491:
;table_eeprom.h,346 :: 		if(fila >= 1 && fila <= myTable.row)
	MOVLW       128
	XORWF       FARG_mysql_write_forced_fila+1, 0 
	MOVWF       R0 
	MOVLW       128
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__mysql_write_forced1262
	MOVLW       1
	SUBWF       FARG_mysql_write_forced_fila+0, 0 
L__mysql_write_forced1262:
	BTFSS       STATUS+0, 0 
	GOTO        L_mysql_write_forced494
	MOVF        FARG_mysql_write_forced_fila+1, 0 
	SUBWF       Expendedora_myTable+3, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__mysql_write_forced1263
	MOVF        FARG_mysql_write_forced_fila+0, 0 
	SUBWF       Expendedora_myTable+2, 0 
L__mysql_write_forced1263:
	BTFSS       STATUS+0, 0 
	GOTO        L_mysql_write_forced494
L__mysql_write_forced955:
;table_eeprom.h,347 :: 		eeprom_i2c_write(myTable.addressAct+(fila-1)*myTable.tamCol, texto, bytes);
	MOVLW       1
	SUBWF       FARG_mysql_write_forced_fila+0, 0 
	MOVWF       R0 
	MOVLW       0
	SUBWFB      FARG_mysql_write_forced_fila+1, 0 
	MOVWF       R1 
	MOVF        Expendedora_myTable+6, 0 
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	MOVF        R0, 0 
	ADDWF       Expendedora_myTable+45, 0 
	MOVWF       FARG_eeprom_i2c_write_address+0 
	MOVF        R1, 0 
	ADDWFC      Expendedora_myTable+46, 0 
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
;table_eeprom.h,349 :: 		return TABLE_RW_NO_EXIST_ROW;   //Fila inexistente
	MOVLW       3
	MOVWF       R0 
	GOTO        L_end_mysql_write_forced
L_mysql_write_forced495:
;table_eeprom.h,351 :: 		return TABLE_RW_SUCCESS;     //Exito en grabacion
	CLRF        R0 
;table_eeprom.h,352 :: 		}
L_end_mysql_write_forced:
	RETURN      0
; end of _mysql_write_forced

_mysql_write_roundTrip:

;table_eeprom.h,354 :: 		char mysql_write_roundTrip(char *name, char *column, char *texto, char bytes){
;table_eeprom.h,355 :: 		char res = _mysql_calculate_address(name, column);
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
;table_eeprom.h,358 :: 		if(res)
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_mysql_write_roundTrip496
;table_eeprom.h,359 :: 		return res;
	MOVF        mysql_write_roundTrip_res_L0+0, 0 
	MOVWF       R0 
	GOTO        L_end_mysql_write_roundTrip
L_mysql_write_roundTrip496:
;table_eeprom.h,362 :: 		if(bytes > myTable.tamCol)
	MOVF        FARG_mysql_write_roundTrip_bytes+0, 0 
	SUBWF       Expendedora_myTable+6, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L_mysql_write_roundTrip497
;table_eeprom.h,363 :: 		return TABLE_RW_OUT_RANGE;
	MOVLW       4
	MOVWF       R0 
	GOTO        L_end_mysql_write_roundTrip
L_mysql_write_roundTrip497:
;table_eeprom.h,366 :: 		myTable.rowAct = clamp_shift(++myTable.rowAct, 1, myTable.row);
	MOVLW       1
	ADDWF       Expendedora_myTable+4, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      Expendedora_myTable+5, 0 
	MOVWF       R1 
	MOVF        R0, 0 
	MOVWF       Expendedora_myTable+4 
	MOVF        R1, 0 
	MOVWF       Expendedora_myTable+5 
	MOVF        Expendedora_myTable+4, 0 
	MOVWF       FARG_clamp_shift_valor+0 
	MOVF        Expendedora_myTable+5, 0 
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
	MOVF        Expendedora_myTable+2, 0 
	MOVWF       FARG_clamp_shift_max+0 
	MOVF        Expendedora_myTable+3, 0 
	MOVWF       FARG_clamp_shift_max+1 
	MOVLW       0
	MOVWF       FARG_clamp_shift_max+2 
	MOVWF       FARG_clamp_shift_max+3 
	CALL        _clamp_shift+0, 0
	MOVF        R0, 0 
	MOVWF       Expendedora_myTable+4 
	MOVF        R1, 0 
	MOVWF       Expendedora_myTable+5 
;table_eeprom.h,367 :: 		eeprom_i2c_write(myTable.address+TABLE_MAX_SIZE_NAME+3, (char*)&myTable.rowAct, 2);
	MOVLW       15
	ADDWF       Expendedora_myTable+43, 0 
	MOVWF       FARG_eeprom_i2c_write_address+0 
	MOVLW       0
	ADDWFC      Expendedora_myTable+44, 0 
	MOVWF       FARG_eeprom_i2c_write_address+1 
	MOVLW       3
	ADDWF       FARG_eeprom_i2c_write_address+0, 1 
	MOVLW       0
	ADDWFC      FARG_eeprom_i2c_write_address+1, 1 
	MOVLW       Expendedora_myTable+4
	MOVWF       FARG_eeprom_i2c_write_datos+0 
	MOVLW       hi_addr(Expendedora_myTable+4)
	MOVWF       FARG_eeprom_i2c_write_datos+1 
	MOVLW       2
	MOVWF       FARG_eeprom_i2c_write_size+0 
	CALL        _eeprom_i2c_write+0, 0
;table_eeprom.h,368 :: 		eeprom_i2c_write(myTable.addressAct+(myTable.rowAct-1)*myTable.tamCol, texto, bytes);
	MOVLW       1
	SUBWF       Expendedora_myTable+4, 0 
	MOVWF       R0 
	MOVLW       0
	SUBWFB      Expendedora_myTable+5, 0 
	MOVWF       R1 
	MOVF        Expendedora_myTable+6, 0 
	MOVWF       R4 
	MOVLW       0
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	MOVF        R0, 0 
	ADDWF       Expendedora_myTable+45, 0 
	MOVWF       FARG_eeprom_i2c_write_address+0 
	MOVF        R1, 0 
	ADDWFC      Expendedora_myTable+46, 0 
	MOVWF       FARG_eeprom_i2c_write_address+1 
	MOVF        FARG_mysql_write_roundTrip_texto+0, 0 
	MOVWF       FARG_eeprom_i2c_write_datos+0 
	MOVF        FARG_mysql_write_roundTrip_texto+1, 0 
	MOVWF       FARG_eeprom_i2c_write_datos+1 
	MOVF        FARG_mysql_write_roundTrip_bytes+0, 0 
	MOVWF       FARG_eeprom_i2c_write_size+0 
	CALL        _eeprom_i2c_write+0, 0
;table_eeprom.h,370 :: 		return TABLE_RW_SUCCESS;     //Exito en grabacion
	CLRF        R0 
;table_eeprom.h,371 :: 		}
L_end_mysql_write_roundTrip:
	RETURN      0
; end of _mysql_write_roundTrip

_mysql_erase:

;table_eeprom.h,373 :: 		bool mysql_erase(char *name){
;table_eeprom.h,375 :: 		if(!mysql_exist(name))
	MOVF        FARG_mysql_erase_name+0, 0 
	MOVWF       FARG_mysql_exist_name+0 
	MOVF        FARG_mysql_erase_name+1, 0 
	MOVWF       FARG_mysql_exist_name+1 
	CALL        _mysql_exist+0, 0
	MOVF        R0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_mysql_erase498
;table_eeprom.h,376 :: 		return false;
	CLRF        R0 
	GOTO        L_end_mysql_erase
L_mysql_erase498:
;table_eeprom.h,379 :: 		myTable.rowAct = 0;
	CLRF        Expendedora_myTable+4 
	CLRF        Expendedora_myTable+5 
;table_eeprom.h,380 :: 		eeprom_i2c_write(myTable.address+TABLE_MAX_SIZE_NAME+3, (char*)&myTable.rowAct, 2);
	MOVLW       15
	ADDWF       Expendedora_myTable+43, 0 
	MOVWF       FARG_eeprom_i2c_write_address+0 
	MOVLW       0
	ADDWFC      Expendedora_myTable+44, 0 
	MOVWF       FARG_eeprom_i2c_write_address+1 
	MOVLW       3
	ADDWF       FARG_eeprom_i2c_write_address+0, 1 
	MOVLW       0
	ADDWFC      FARG_eeprom_i2c_write_address+1, 1 
	MOVLW       Expendedora_myTable+4
	MOVWF       FARG_eeprom_i2c_write_datos+0 
	MOVLW       hi_addr(Expendedora_myTable+4)
	MOVWF       FARG_eeprom_i2c_write_datos+1 
	MOVLW       2
	MOVWF       FARG_eeprom_i2c_write_size+0 
	CALL        _eeprom_i2c_write+0, 0
;table_eeprom.h,381 :: 		return true;
	MOVLW       1
	MOVWF       R0 
;table_eeprom.h,382 :: 		}
L_end_mysql_erase:
	RETURN      0
; end of _mysql_erase

_mysql_search:

;table_eeprom.h,384 :: 		char mysql_search(char *tabla, char *columna, long buscar, int *fila){
;table_eeprom.h,388 :: 		if(mysql_exist(tabla)){
	MOVF        FARG_mysql_search_tabla+0, 0 
	MOVWF       FARG_mysql_exist_name+0 
	MOVF        FARG_mysql_search_tabla+1, 0 
	MOVWF       FARG_mysql_exist_name+1 
	CALL        _mysql_exist+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_mysql_search499
;table_eeprom.h,389 :: 		for(*fila = 1; *fila <= myTable.rowAct; (*fila)++){
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
	SUBWF       Expendedora_myTable+5, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__mysql_search1267
	MOVF        R1, 0 
	SUBWF       Expendedora_myTable+4, 0 
L__mysql_search1267:
	BTFSS       STATUS+0, 0 
	GOTO        L_mysql_search501
;table_eeprom.h,391 :: 		if(!mysql_read(tabla, columna, *fila, &busqueda)){
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
;table_eeprom.h,392 :: 		if(buscar == busqueda)
	MOVF        FARG_mysql_search_buscar+3, 0 
	XORWF       mysql_search_busqueda_L0+3, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__mysql_search1268
	MOVF        FARG_mysql_search_buscar+2, 0 
	XORWF       mysql_search_busqueda_L0+2, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__mysql_search1268
	MOVF        FARG_mysql_search_buscar+1, 0 
	XORWF       mysql_search_busqueda_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__mysql_search1268
	MOVF        FARG_mysql_search_buscar+0, 0 
	XORWF       mysql_search_busqueda_L0+0, 0 
L__mysql_search1268:
	BTFSS       STATUS+0, 2 
	GOTO        L_mysql_search504
;table_eeprom.h,393 :: 		return TABLE_RW_SUCCESS;
	CLRF        R0 
	GOTO        L_end_mysql_search
L_mysql_search504:
;table_eeprom.h,394 :: 		}
L_mysql_search503:
;table_eeprom.h,389 :: 		for(*fila = 1; *fila <= myTable.rowAct; (*fila)++){
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
;table_eeprom.h,395 :: 		}
	GOTO        L_mysql_search500
L_mysql_search501:
;table_eeprom.h,396 :: 		return TABLE_RW_NO_EXIST_ROW;
	MOVLW       3
	MOVWF       R0 
	GOTO        L_end_mysql_search
;table_eeprom.h,397 :: 		}
L_mysql_search499:
;table_eeprom.h,399 :: 		return TABLE_RW_NO_EXIST_TABLE;
	MOVLW       1
	MOVWF       R0 
;table_eeprom.h,400 :: 		}
L_end_mysql_search:
	RETURN      0
; end of _mysql_search

_mysql_search_forced:

;table_eeprom.h,402 :: 		char mysql_search_forced(char *tabla, char *columna, long buscar, int *fila){
;table_eeprom.h,406 :: 		if(mysql_exist(tabla)){
	MOVF        FARG_mysql_search_forced_tabla+0, 0 
	MOVWF       FARG_mysql_exist_name+0 
	MOVF        FARG_mysql_search_forced_tabla+1, 0 
	MOVWF       FARG_mysql_exist_name+1 
	CALL        _mysql_exist+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_mysql_search_forced505
;table_eeprom.h,407 :: 		for(*fila = 1; *fila <= myTable.row; (*fila)++){
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
	SUBWF       Expendedora_myTable+3, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__mysql_search_forced1270
	MOVF        R1, 0 
	SUBWF       Expendedora_myTable+2, 0 
L__mysql_search_forced1270:
	BTFSS       STATUS+0, 0 
	GOTO        L_mysql_search_forced507
;table_eeprom.h,409 :: 		if(!mysql_read(tabla, columna, *fila, &busqueda)){
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
;table_eeprom.h,410 :: 		if(buscar == busqueda)
	MOVF        FARG_mysql_search_forced_buscar+3, 0 
	XORWF       mysql_search_forced_busqueda_L0+3, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__mysql_search_forced1271
	MOVF        FARG_mysql_search_forced_buscar+2, 0 
	XORWF       mysql_search_forced_busqueda_L0+2, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__mysql_search_forced1271
	MOVF        FARG_mysql_search_forced_buscar+1, 0 
	XORWF       mysql_search_forced_busqueda_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__mysql_search_forced1271
	MOVF        FARG_mysql_search_forced_buscar+0, 0 
	XORWF       mysql_search_forced_busqueda_L0+0, 0 
L__mysql_search_forced1271:
	BTFSS       STATUS+0, 2 
	GOTO        L_mysql_search_forced510
;table_eeprom.h,411 :: 		return TABLE_RW_SUCCESS;
	CLRF        R0 
	GOTO        L_end_mysql_search_forced
L_mysql_search_forced510:
;table_eeprom.h,412 :: 		}
L_mysql_search_forced509:
;table_eeprom.h,407 :: 		for(*fila = 1; *fila <= myTable.row; (*fila)++){
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
;table_eeprom.h,413 :: 		}
	GOTO        L_mysql_search_forced506
L_mysql_search_forced507:
;table_eeprom.h,414 :: 		return TABLE_RW_NO_EXIST_ROW;
	MOVLW       3
	MOVWF       R0 
	GOTO        L_end_mysql_search_forced
;table_eeprom.h,415 :: 		}
L_mysql_search_forced505:
;table_eeprom.h,417 :: 		return TABLE_RW_NO_EXIST_TABLE;
	MOVLW       1
	MOVWF       R0 
;table_eeprom.h,418 :: 		}
L_end_mysql_search_forced:
	RETURN      0
; end of _mysql_search_forced

_mysql_count:

;table_eeprom.h,420 :: 		int mysql_count(char *tabla, char *columna, long buscar){
;table_eeprom.h,421 :: 		int coincidencias = 0;
	CLRF        mysql_count_coincidencias_L0+0 
	CLRF        mysql_count_coincidencias_L0+1 
;table_eeprom.h,425 :: 		if(mysql_exist(tabla)){
	MOVF        FARG_mysql_count_tabla+0, 0 
	MOVWF       FARG_mysql_exist_name+0 
	MOVF        FARG_mysql_count_tabla+1, 0 
	MOVWF       FARG_mysql_exist_name+1 
	CALL        _mysql_exist+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_mysql_count511
;table_eeprom.h,426 :: 		for(myTable.cont = 1; myTable.cont <= myTable.rowAct; myTable.cont++){
	MOVLW       1
	MOVWF       Expendedora_myTable+47 
L_mysql_count512:
	MOVLW       0
	SUBWF       Expendedora_myTable+5, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__mysql_count1273
	MOVF        Expendedora_myTable+47, 0 
	SUBWF       Expendedora_myTable+4, 0 
L__mysql_count1273:
	BTFSS       STATUS+0, 0 
	GOTO        L_mysql_count513
;table_eeprom.h,428 :: 		if(!mysql_read(tabla, columna, myTable.cont, &busqueda)){
	MOVF        FARG_mysql_count_tabla+0, 0 
	MOVWF       FARG_mysql_read_name+0 
	MOVF        FARG_mysql_count_tabla+1, 0 
	MOVWF       FARG_mysql_read_name+1 
	MOVF        FARG_mysql_count_columna+0, 0 
	MOVWF       FARG_mysql_read_column+0 
	MOVF        FARG_mysql_count_columna+1, 0 
	MOVWF       FARG_mysql_read_column+1 
	MOVF        Expendedora_myTable+47, 0 
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
;table_eeprom.h,429 :: 		if(buscar == busqueda)
	MOVF        FARG_mysql_count_buscar+3, 0 
	XORWF       mysql_count_busqueda_L0+3, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__mysql_count1274
	MOVF        FARG_mysql_count_buscar+2, 0 
	XORWF       mysql_count_busqueda_L0+2, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__mysql_count1274
	MOVF        FARG_mysql_count_buscar+1, 0 
	XORWF       mysql_count_busqueda_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__mysql_count1274
	MOVF        FARG_mysql_count_buscar+0, 0 
	XORWF       mysql_count_busqueda_L0+0, 0 
L__mysql_count1274:
	BTFSS       STATUS+0, 2 
	GOTO        L_mysql_count516
;table_eeprom.h,430 :: 		coincidencias++;
	INFSNZ      mysql_count_coincidencias_L0+0, 1 
	INCF        mysql_count_coincidencias_L0+1, 1 
L_mysql_count516:
;table_eeprom.h,431 :: 		}
L_mysql_count515:
;table_eeprom.h,426 :: 		for(myTable.cont = 1; myTable.cont <= myTable.rowAct; myTable.cont++){
	MOVF        Expendedora_myTable+47, 0 
	ADDLW       1
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       Expendedora_myTable+47 
;table_eeprom.h,432 :: 		}
	GOTO        L_mysql_count512
L_mysql_count513:
;table_eeprom.h,433 :: 		}
L_mysql_count511:
;table_eeprom.h,435 :: 		return coincidencias;
	MOVF        mysql_count_coincidencias_L0+0, 0 
	MOVWF       R0 
	MOVF        mysql_count_coincidencias_L0+1, 0 
	MOVWF       R1 
;table_eeprom.h,436 :: 		}
L_end_mysql_count:
	RETURN      0
; end of _mysql_count

_mysql_count_forced:

;table_eeprom.h,438 :: 		int mysql_count_forced(char *tabla, char *columna, long buscar){
;table_eeprom.h,439 :: 		int coincidencias = 0;
	CLRF        mysql_count_forced_coincidencias_L0+0 
	CLRF        mysql_count_forced_coincidencias_L0+1 
	CLRF        mysql_count_forced_busqueda_L0+0 
	CLRF        mysql_count_forced_busqueda_L0+1 
	CLRF        mysql_count_forced_busqueda_L0+2 
	CLRF        mysql_count_forced_busqueda_L0+3 
;table_eeprom.h,443 :: 		if(mysql_exist(tabla)){
	MOVF        FARG_mysql_count_forced_tabla+0, 0 
	MOVWF       FARG_mysql_exist_name+0 
	MOVF        FARG_mysql_count_forced_tabla+1, 0 
	MOVWF       FARG_mysql_exist_name+1 
	CALL        _mysql_exist+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_mysql_count_forced517
;table_eeprom.h,444 :: 		for(myTable.cont = 1; myTable.cont <= myTable.row; myTable.cont++){
	MOVLW       1
	MOVWF       Expendedora_myTable+47 
L_mysql_count_forced518:
	MOVLW       0
	SUBWF       Expendedora_myTable+3, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__mysql_count_forced1276
	MOVF        Expendedora_myTable+47, 0 
	SUBWF       Expendedora_myTable+2, 0 
L__mysql_count_forced1276:
	BTFSS       STATUS+0, 0 
	GOTO        L_mysql_count_forced519
;table_eeprom.h,446 :: 		if(!mysql_read_forced(tabla, columna, myTable.cont, (char*)&busqueda)){
	MOVF        FARG_mysql_count_forced_tabla+0, 0 
	MOVWF       FARG_mysql_read_forced_name+0 
	MOVF        FARG_mysql_count_forced_tabla+1, 0 
	MOVWF       FARG_mysql_read_forced_name+1 
	MOVF        FARG_mysql_count_forced_columna+0, 0 
	MOVWF       FARG_mysql_read_forced_column+0 
	MOVF        FARG_mysql_count_forced_columna+1, 0 
	MOVWF       FARG_mysql_read_forced_column+1 
	MOVF        Expendedora_myTable+47, 0 
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
;table_eeprom.h,447 :: 		if(buscar == busqueda)
	MOVF        FARG_mysql_count_forced_buscar+3, 0 
	XORWF       mysql_count_forced_busqueda_L0+3, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__mysql_count_forced1277
	MOVF        FARG_mysql_count_forced_buscar+2, 0 
	XORWF       mysql_count_forced_busqueda_L0+2, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__mysql_count_forced1277
	MOVF        FARG_mysql_count_forced_buscar+1, 0 
	XORWF       mysql_count_forced_busqueda_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__mysql_count_forced1277
	MOVF        FARG_mysql_count_forced_buscar+0, 0 
	XORWF       mysql_count_forced_busqueda_L0+0, 0 
L__mysql_count_forced1277:
	BTFSS       STATUS+0, 2 
	GOTO        L_mysql_count_forced522
;table_eeprom.h,448 :: 		coincidencias++;
	INFSNZ      mysql_count_forced_coincidencias_L0+0, 1 
	INCF        mysql_count_forced_coincidencias_L0+1, 1 
L_mysql_count_forced522:
;table_eeprom.h,449 :: 		}
L_mysql_count_forced521:
;table_eeprom.h,444 :: 		for(myTable.cont = 1; myTable.cont <= myTable.row; myTable.cont++){
	MOVF        Expendedora_myTable+47, 0 
	ADDLW       1
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       Expendedora_myTable+47 
;table_eeprom.h,450 :: 		}
	GOTO        L_mysql_count_forced518
L_mysql_count_forced519:
;table_eeprom.h,451 :: 		}
L_mysql_count_forced517:
;table_eeprom.h,453 :: 		return coincidencias;
	MOVF        mysql_count_forced_coincidencias_L0+0, 0 
	MOVWF       R0 
	MOVF        mysql_count_forced_coincidencias_L0+1, 0 
	MOVWF       R1 
;table_eeprom.h,454 :: 		}
L_end_mysql_count_forced:
	RETURN      0
; end of _mysql_count_forced

__mysql_calculate_address:

;table_eeprom.h,458 :: 		char _mysql_calculate_address(char *name, char *column){
;table_eeprom.h,459 :: 		unsigned int addressAux = 0;
	CLRF        _mysql_calculate_address_addressAux_L0+0 
	CLRF        _mysql_calculate_address_addressAux_L0+1 
;table_eeprom.h,462 :: 		if(strncmp(name, myTable.nameAct, TABLE_MAX_SIZE_NAME+1)){
	MOVF        FARG__mysql_calculate_address_name+0, 0 
	MOVWF       FARG_strncmp_s1+0 
	MOVF        FARG__mysql_calculate_address_name+1, 0 
	MOVWF       FARG_strncmp_s1+1 
	MOVLW       Expendedora_myTable+7
	MOVWF       FARG_strncmp_s2+0 
	MOVLW       hi_addr(Expendedora_myTable+7)
	MOVWF       FARG_strncmp_s2+1 
	MOVLW       16
	MOVWF       FARG_strncmp_len+0 
	CALL        _strncmp+0, 0
	MOVF        R0, 0 
	IORWF       R1, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L__mysql_calculate_address523
;table_eeprom.h,463 :: 		if(!mysql_exist(name)){
	MOVF        FARG__mysql_calculate_address_name+0, 0 
	MOVWF       FARG_mysql_exist_name+0 
	MOVF        FARG__mysql_calculate_address_name+1, 0 
	MOVWF       FARG_mysql_exist_name+1 
	CALL        _mysql_exist+0, 0
	MOVF        R0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L__mysql_calculate_address524
;table_eeprom.h,464 :: 		return TABLE_RW_NO_EXIST_TABLE;  //No existe la tabla buscada
	MOVLW       1
	MOVWF       R0 
	GOTO        L_end__mysql_calculate_address
;table_eeprom.h,465 :: 		}
L__mysql_calculate_address524:
;table_eeprom.h,466 :: 		}
L__mysql_calculate_address523:
;table_eeprom.h,468 :: 		if(strncmp(column, myTable.nameColAct, TABLE_MAX_SIZE_NAME+1)){
	MOVF        FARG__mysql_calculate_address_column+0, 0 
	MOVWF       FARG_strncmp_s1+0 
	MOVF        FARG__mysql_calculate_address_column+1, 0 
	MOVWF       FARG_strncmp_s1+1 
	MOVLW       Expendedora_myTable+23
	MOVWF       FARG_strncmp_s2+0 
	MOVLW       hi_addr(Expendedora_myTable+23)
	MOVWF       FARG_strncmp_s2+1 
	MOVLW       16
	MOVWF       FARG_strncmp_len+0 
	CALL        _strncmp+0, 0
	MOVF        R0, 0 
	IORWF       R1, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L__mysql_calculate_address525
;table_eeprom.h,469 :: 		myTable.addressAct = myTable.address;   //Copiar direccion casa de la tabla
	MOVF        Expendedora_myTable+43, 0 
	MOVWF       Expendedora_myTable+45 
	MOVF        Expendedora_myTable+44, 0 
	MOVWF       Expendedora_myTable+46 
;table_eeprom.h,471 :: 		myTable.addressAct += TABLE_MAX_SIZE_NAME+3;
	MOVLW       18
	ADDWF       Expendedora_myTable+43, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      Expendedora_myTable+44, 0 
	MOVWF       R1 
	MOVF        R0, 0 
	MOVWF       Expendedora_myTable+45 
	MOVF        R1, 0 
	MOVWF       Expendedora_myTable+46 
;table_eeprom.h,472 :: 		eeprom_i2c_read(myTable.addressAct,(char*)&myTable.rowAct, 2);
	MOVF        R0, 0 
	MOVWF       FARG_eeprom_i2c_read_address+0 
	MOVF        R1, 0 
	MOVWF       FARG_eeprom_i2c_read_address+1 
	MOVLW       Expendedora_myTable+4
	MOVWF       FARG_eeprom_i2c_read_datos+0 
	MOVLW       hi_addr(Expendedora_myTable+4)
	MOVWF       FARG_eeprom_i2c_read_datos+1 
	MOVLW       2
	MOVWF       FARG_eeprom_i2c_read_size+0 
	CALL        _eeprom_i2c_read+0, 0
;table_eeprom.h,473 :: 		eeprom_i2c_read(myTable.addressAct+2,(char*)&myTable.row, 2);
	MOVLW       2
	ADDWF       Expendedora_myTable+45, 0 
	MOVWF       FARG_eeprom_i2c_read_address+0 
	MOVLW       0
	ADDWFC      Expendedora_myTable+46, 0 
	MOVWF       FARG_eeprom_i2c_read_address+1 
	MOVLW       Expendedora_myTable+2
	MOVWF       FARG_eeprom_i2c_read_datos+0 
	MOVLW       hi_addr(Expendedora_myTable+2)
	MOVWF       FARG_eeprom_i2c_read_datos+1 
	MOVLW       2
	MOVWF       FARG_eeprom_i2c_read_size+0 
	CALL        _eeprom_i2c_read+0, 0
;table_eeprom.h,474 :: 		eeprom_i2c_read(myTable.addressAct+4,&myTable.col, 1); //Filas totales de busqueda
	MOVLW       4
	ADDWF       Expendedora_myTable+45, 0 
	MOVWF       FARG_eeprom_i2c_read_address+0 
	MOVLW       0
	ADDWFC      Expendedora_myTable+46, 0 
	MOVWF       FARG_eeprom_i2c_read_address+1 
	MOVLW       Expendedora_myTable+1
	MOVWF       FARG_eeprom_i2c_read_datos+0 
	MOVLW       hi_addr(Expendedora_myTable+1)
	MOVWF       FARG_eeprom_i2c_read_datos+1 
	MOVLW       1
	MOVWF       FARG_eeprom_i2c_read_size+0 
	CALL        _eeprom_i2c_read+0, 0
;table_eeprom.h,476 :: 		myTable.addressAct += (4+1);   //Apuntamos a la primera columna name
	MOVLW       5
	ADDWF       Expendedora_myTable+45, 0 
	MOVWF       FLOC___mysql_calculate_address+0 
	MOVLW       0
	ADDWFC      Expendedora_myTable+46, 0 
	MOVWF       FLOC___mysql_calculate_address+1 
	MOVF        FLOC___mysql_calculate_address+0, 0 
	MOVWF       Expendedora_myTable+45 
	MOVF        FLOC___mysql_calculate_address+1, 0 
	MOVWF       Expendedora_myTable+46 
;table_eeprom.h,477 :: 		addressAux = myTable.addressAct;
	MOVF        FLOC___mysql_calculate_address+0, 0 
	MOVWF       _mysql_calculate_address_addressAux_L0+0 
	MOVF        FLOC___mysql_calculate_address+1, 0 
	MOVWF       _mysql_calculate_address_addressAux_L0+1 
;table_eeprom.h,478 :: 		addressAux += myTable.col*(TABLE_MAX_SIZE_NAME+1+1); //Apuntar a los datos
	MOVF        Expendedora_myTable+1, 0 
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
;table_eeprom.h,481 :: 		for(myTable.cont = 0; myTable.cont < myTable.col; myTable.cont++){
	CLRF        Expendedora_myTable+47 
L__mysql_calculate_address526:
	MOVF        Expendedora_myTable+1, 0 
	SUBWF       Expendedora_myTable+47, 0 
	BTFSC       STATUS+0, 0 
	GOTO        L__mysql_calculate_address527
;table_eeprom.h,483 :: 		eeprom_i2c_read(myTable.addressAct, myTable.nameColAct, TABLE_MAX_SIZE_NAME+1);
	MOVF        Expendedora_myTable+45, 0 
	MOVWF       FARG_eeprom_i2c_read_address+0 
	MOVF        Expendedora_myTable+46, 0 
	MOVWF       FARG_eeprom_i2c_read_address+1 
	MOVLW       Expendedora_myTable+23
	MOVWF       FARG_eeprom_i2c_read_datos+0 
	MOVLW       hi_addr(Expendedora_myTable+23)
	MOVWF       FARG_eeprom_i2c_read_datos+1 
	MOVLW       16
	MOVWF       FARG_eeprom_i2c_read_size+0 
	CALL        _eeprom_i2c_read+0, 0
;table_eeprom.h,485 :: 		myTable.addressAct += TABLE_MAX_SIZE_NAME+1;
	MOVLW       16
	ADDWF       Expendedora_myTable+45, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      Expendedora_myTable+46, 0 
	MOVWF       R1 
	MOVF        R0, 0 
	MOVWF       Expendedora_myTable+45 
	MOVF        R1, 0 
	MOVWF       Expendedora_myTable+46 
;table_eeprom.h,486 :: 		eeprom_i2c_read(myTable.addressAct, &myTable.tamCol, 1); //1 de esta direccion
	MOVF        R0, 0 
	MOVWF       FARG_eeprom_i2c_read_address+0 
	MOVF        R1, 0 
	MOVWF       FARG_eeprom_i2c_read_address+1 
	MOVLW       Expendedora_myTable+6
	MOVWF       FARG_eeprom_i2c_read_datos+0 
	MOVLW       hi_addr(Expendedora_myTable+6)
	MOVWF       FARG_eeprom_i2c_read_datos+1 
	MOVLW       1
	MOVWF       FARG_eeprom_i2c_read_size+0 
	CALL        _eeprom_i2c_read+0, 0
;table_eeprom.h,487 :: 		myTable.addressAct += 1;
	MOVLW       1
	ADDWF       Expendedora_myTable+45, 0 
	MOVWF       R0 
	MOVLW       0
	ADDWFC      Expendedora_myTable+46, 0 
	MOVWF       R1 
	MOVF        R0, 0 
	MOVWF       Expendedora_myTable+45 
	MOVF        R1, 0 
	MOVWF       Expendedora_myTable+46 
;table_eeprom.h,489 :: 		if(!strncmp(column, myTable.nameColAct, TABLE_MAX_SIZE_NAME+1))
	MOVF        FARG__mysql_calculate_address_column+0, 0 
	MOVWF       FARG_strncmp_s1+0 
	MOVF        FARG__mysql_calculate_address_column+1, 0 
	MOVWF       FARG_strncmp_s1+1 
	MOVLW       Expendedora_myTable+23
	MOVWF       FARG_strncmp_s2+0 
	MOVLW       hi_addr(Expendedora_myTable+23)
	MOVWF       FARG_strncmp_s2+1 
	MOVLW       16
	MOVWF       FARG_strncmp_len+0 
	CALL        _strncmp+0, 0
	MOVF        R0, 0 
	IORWF       R1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__mysql_calculate_address529
;table_eeprom.h,490 :: 		break;
	GOTO        L__mysql_calculate_address527
L__mysql_calculate_address529:
;table_eeprom.h,492 :: 		addressAux += myTable.tamCol*myTable.row;   //Acumular las columnas para saber la direccion
	MOVF        Expendedora_myTable+6, 0 
	MOVWF       R0 
	MOVLW       0
	MOVWF       R1 
	MOVF        Expendedora_myTable+2, 0 
	MOVWF       R4 
	MOVF        Expendedora_myTable+3, 0 
	MOVWF       R5 
	CALL        _Mul_16X16_U+0, 0
	MOVF        R0, 0 
	ADDWF       _mysql_calculate_address_addressAux_L0+0, 1 
	MOVF        R1, 0 
	ADDWFC      _mysql_calculate_address_addressAux_L0+1, 1 
;table_eeprom.h,481 :: 		for(myTable.cont = 0; myTable.cont < myTable.col; myTable.cont++){
	MOVF        Expendedora_myTable+47, 0 
	ADDLW       1
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       Expendedora_myTable+47 
;table_eeprom.h,494 :: 		}
	GOTO        L__mysql_calculate_address526
L__mysql_calculate_address527:
;table_eeprom.h,496 :: 		if(myTable.cont >= myTable.col){
	MOVF        Expendedora_myTable+1, 0 
	SUBWF       Expendedora_myTable+47, 0 
	BTFSS       STATUS+0, 0 
	GOTO        L__mysql_calculate_address530
;table_eeprom.h,497 :: 		myTable.nameColAct[0] = 0;
	CLRF        Expendedora_myTable+23 
;table_eeprom.h,498 :: 		return TABLE_RW_NO_EXIST_NAME_COL;
	MOVLW       2
	MOVWF       R0 
	GOTO        L_end__mysql_calculate_address
;table_eeprom.h,499 :: 		}
L__mysql_calculate_address530:
;table_eeprom.h,500 :: 		myTable.addressAct = addressAux;
	MOVF        _mysql_calculate_address_addressAux_L0+0, 0 
	MOVWF       Expendedora_myTable+45 
	MOVF        _mysql_calculate_address_addressAux_L0+1, 0 
	MOVWF       Expendedora_myTable+46 
;table_eeprom.h,501 :: 		}
L__mysql_calculate_address525:
;table_eeprom.h,503 :: 		return TABLE_RW_SUCCESS;
	CLRF        R0 
;table_eeprom.h,504 :: 		}
L_end__mysql_calculate_address:
	RETURN      0
; end of __mysql_calculate_address

_external_int0_open:

;lib_external_int0.h,8 :: 		void external_int0_open(bool enable, bool edgeOnRising){
;lib_external_int0.h,9 :: 		INTCON.INT0IF = 0;                  //LIMPIAR BANDERA
	BCF         INTCON+0, 1 
;lib_external_int0.h,10 :: 		INTCON2.INTEDG0 = edgeOnRising.B0;  //FLANCO DE SUBIDA
	BTFSC       FARG_external_int0_open_edgeOnRising+0, 0 
	GOTO        L__external_int0_open1280
	BCF         INTCON2+0, 6 
	GOTO        L__external_int0_open1281
L__external_int0_open1280:
	BSF         INTCON2+0, 6 
L__external_int0_open1281:
;lib_external_int0.h,11 :: 		INTCON.INT0IE = enable.B0;          //DISPONIBILIDAD
	BTFSC       FARG_external_int0_open_enable+0, 0 
	GOTO        L__external_int0_open1282
	BCF         INTCON+0, 4 
	GOTO        L__external_int0_open1283
L__external_int0_open1282:
	BSF         INTCON+0, 4 
L__external_int0_open1283:
;lib_external_int0.h,12 :: 		}
L_end_external_int0_open:
	RETURN      0
; end of _external_int0_open

_external_int0_enable:

;lib_external_int0.h,14 :: 		void external_int0_enable(bool enable){
;lib_external_int0.h,15 :: 		INTCON.INT0IE = enable.B0;          //DISPONIBILIDAD
	BTFSC       FARG_external_int0_enable_enable+0, 0 
	GOTO        L__external_int0_enable1285
	BCF         INTCON+0, 4 
	GOTO        L__external_int0_enable1286
L__external_int0_enable1285:
	BSF         INTCON+0, 4 
L__external_int0_enable1286:
;lib_external_int0.h,16 :: 		}
L_end_external_int0_enable:
	RETURN      0
; end of _external_int0_enable

_external_int0_edge:

;lib_external_int0.h,18 :: 		void external_int0_edge(bool onRising){
;lib_external_int0.h,19 :: 		INTCON2.INTEDG0 = onRising.B0;      //FLANCO DE SUBIDA
	BTFSC       FARG_external_int0_edge_onRising+0, 0 
	GOTO        L__external_int0_edge1288
	BCF         INTCON2+0, 6 
	GOTO        L__external_int0_edge1289
L__external_int0_edge1288:
	BSF         INTCON2+0, 6 
L__external_int0_edge1289:
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
	GOTO        L__external_int1_open1291
	BCF         INTCON2+0, 5 
	GOTO        L__external_int1_open1292
L__external_int1_open1291:
	BSF         INTCON2+0, 5 
L__external_int1_open1292:
;lib_external_int1.h,11 :: 		INTCON3.INT1IP = priorityHigh.B0;  //PRIORIDAD DE LA INTERRUPCION
	BTFSC       FARG_external_int1_open_priorityHigh+0, 0 
	GOTO        L__external_int1_open1293
	BCF         INTCON3+0, 6 
	GOTO        L__external_int1_open1294
L__external_int1_open1293:
	BSF         INTCON3+0, 6 
L__external_int1_open1294:
;lib_external_int1.h,12 :: 		INTCON3.INT1IE = enable.B0;        //DISPONIBILIDAD
	BTFSC       FARG_external_int1_open_enable+0, 0 
	GOTO        L__external_int1_open1295
	BCF         INTCON3+0, 3 
	GOTO        L__external_int1_open1296
L__external_int1_open1295:
	BSF         INTCON3+0, 3 
L__external_int1_open1296:
;lib_external_int1.h,13 :: 		}
L_end_external_int1_open:
	RETURN      0
; end of _external_int1_open

_external_int1_enable:

;lib_external_int1.h,15 :: 		void external_int1_enable(bool enable){
;lib_external_int1.h,16 :: 		INTCON3.INT1IE = enable.B0;        //DISPONIBILIDAD
	BTFSC       FARG_external_int1_enable_enable+0, 0 
	GOTO        L__external_int1_enable1298
	BCF         INTCON3+0, 3 
	GOTO        L__external_int1_enable1299
L__external_int1_enable1298:
	BSF         INTCON3+0, 3 
L__external_int1_enable1299:
;lib_external_int1.h,17 :: 		}
L_end_external_int1_enable:
	RETURN      0
; end of _external_int1_enable

_external_int1_edge:

;lib_external_int1.h,19 :: 		void external_int1_edge(bool onRising){
;lib_external_int1.h,20 :: 		INTCON2.INTEDG1 = onRising.B0;     //FLANCO DE SUBIDA
	BTFSC       FARG_external_int1_edge_onRising+0, 0 
	GOTO        L__external_int1_edge1301
	BCF         INTCON2+0, 5 
	GOTO        L__external_int1_edge1302
L__external_int1_edge1301:
	BSF         INTCON2+0, 5 
L__external_int1_edge1302:
;lib_external_int1.h,21 :: 		}
L_end_external_int1_edge:
	RETURN      0
; end of _external_int1_edge

_external_int1_priority:

;lib_external_int1.h,23 :: 		void external_int1_priority(bool high){
;lib_external_int1.h,24 :: 		INTCON3.INT1IP = high.B0;          //PRIORIDAD DE LA INTERRUPCION
	BTFSC       FARG_external_int1_priority_high+0, 0 
	GOTO        L__external_int1_priority1304
	BCF         INTCON3+0, 6 
	GOTO        L__external_int1_priority1305
L__external_int1_priority1304:
	BSF         INTCON3+0, 6 
L__external_int1_priority1305:
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
	CLRF        Expendedora_WIEGAN26_DATA+0 
	CLRF        Expendedora_WIEGAN26_DATA+1 
	CLRF        Expendedora_WIEGAN26_DATA+2 
	CLRF        Expendedora_WIEGAN26_DATA+3 
;wiegand26.h,55 :: 		WIEGAN26_CONT = 0;
	CLRF        Expendedora_WIEGAN26_CONT+0 
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
	MOVF        Expendedora_WIEGAN26_CONT+0, 0 
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
	MOVF        Expendedora_WIEGAN26_CONT+0, 0 
	XORLW       26
	BTFSC       STATUS+0, 2 
	GOTO        L_wiegand26_read_card533
;wiegand26.h,69 :: 		return false;
	CLRF        R0 
	GOTO        L_end_wiegand26_read_card
L_wiegand26_read_card533:
;wiegand26.h,71 :: 		WIEGAN26_BUFFER = WIEGAN26_DATA;
	MOVF        Expendedora_WIEGAN26_DATA+0, 0 
	MOVWF       Expendedora_WIEGAN26_BUFFER+0 
	MOVF        Expendedora_WIEGAN26_DATA+1, 0 
	MOVWF       Expendedora_WIEGAN26_BUFFER+1 
	MOVF        Expendedora_WIEGAN26_DATA+2, 0 
	MOVWF       Expendedora_WIEGAN26_BUFFER+2 
	MOVF        Expendedora_WIEGAN26_DATA+3, 0 
	MOVWF       Expendedora_WIEGAN26_BUFFER+3 
;wiegand26.h,72 :: 		aux = WIEGAN26_BUFFER;
	MOVF        Expendedora_WIEGAN26_DATA+0, 0 
	MOVWF       R14 
	MOVF        Expendedora_WIEGAN26_DATA+1, 0 
	MOVWF       R15 
	MOVF        Expendedora_WIEGAN26_DATA+2, 0 
	MOVWF       R16 
	MOVF        Expendedora_WIEGAN26_DATA+3, 0 
	MOVWF       R17 
;wiegand26.h,74 :: 		WIEGAN26_CONT = 0;    //Resetear puntero
	CLRF        Expendedora_WIEGAN26_CONT+0 
;wiegand26.h,75 :: 		WIEGAN26_DATA = 0;    //Resetear la informacion
	CLRF        Expendedora_WIEGAN26_DATA+0 
	CLRF        Expendedora_WIEGAN26_DATA+1 
	CLRF        Expendedora_WIEGAN26_DATA+2 
	CLRF        Expendedora_WIEGAN26_DATA+3 
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
	MOVF        Expendedora_WIEGAN26_BUFFER+0, 0 
	MOVWF       POSTINC1+0 
	MOVF        Expendedora_WIEGAN26_BUFFER+1, 0 
	MOVWF       POSTINC1+0 
	MOVF        Expendedora_WIEGAN26_BUFFER+2, 0 
	MOVWF       POSTINC1+0 
	MOVF        Expendedora_WIEGAN26_BUFFER+3, 0 
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
	MOVF        Expendedora_WIEGAN26_CONT+0, 0 
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
	MOVF        Expendedora_WIEGAN26_CONT+0, 0 
	XORLW       32
	BTFSC       STATUS+0, 2 
	GOTO        L_wiegand26_read_nip544
;wiegand26.h,109 :: 		return false;
	CLRF        R0 
	GOTO        L_end_wiegand26_read_nip
L_wiegand26_read_nip544:
;wiegand26.h,112 :: 		WIEGAN26_BUFFER = WIEGAN26_DATA;
	MOVF        Expendedora_WIEGAN26_DATA+0, 0 
	MOVWF       Expendedora_WIEGAN26_BUFFER+0 
	MOVF        Expendedora_WIEGAN26_DATA+1, 0 
	MOVWF       Expendedora_WIEGAN26_BUFFER+1 
	MOVF        Expendedora_WIEGAN26_DATA+2, 0 
	MOVWF       Expendedora_WIEGAN26_BUFFER+2 
	MOVF        Expendedora_WIEGAN26_DATA+3, 0 
	MOVWF       Expendedora_WIEGAN26_BUFFER+3 
;wiegand26.h,114 :: 		WIEGAN26_CONT = 0;    //Resetear puntero
	CLRF        Expendedora_WIEGAN26_CONT+0 
;wiegand26.h,115 :: 		WIEGAN26_DATA = 0;    //Resetear la informacion
	CLRF        Expendedora_WIEGAN26_DATA+0 
	CLRF        Expendedora_WIEGAN26_DATA+1 
	CLRF        Expendedora_WIEGAN26_DATA+2 
	CLRF        Expendedora_WIEGAN26_DATA+3 
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
	MOVLW       Expendedora_WIEGAN26_BUFFER+0
	MOVWF       R1 
	MOVLW       hi_addr(Expendedora_WIEGAN26_BUFFER+0)
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
	MOVLW       Expendedora_WIEGAN26_BUFFER+0
	MOVWF       FSR0 
	MOVLW       hi_addr(Expendedora_WIEGAN26_BUFFER+0)
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
	GOTO        L__wiegand26_read_nip956
	MOVLW       Expendedora_WIEGAN26_BUFFER+0
	MOVWF       FSR0 
	MOVLW       hi_addr(Expendedora_WIEGAN26_BUFFER+0)
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
	GOTO        L__wiegand26_read_nip956
	GOTO        L_wiegand26_read_nip551
L__wiegand26_read_nip956:
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
	GOTO        L__wiegand26_read_nip1309
	MOVLW       0
	SUBWF       wiegand26_read_nip_i_L0+0, 0 
L__wiegand26_read_nip1309:
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
	MOVLW       Expendedora_WIEGAN26_BUFFER+0
	MOVWF       FSR2 
	MOVLW       hi_addr(Expendedora_WIEGAN26_BUFFER+0)
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
	MOVLW       Expendedora_WIEGAN26_BUFFER+0
	MOVWF       FSR0 
	MOVLW       hi_addr(Expendedora_WIEGAN26_BUFFER+0)
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
	MOVLW       Expendedora_WIEGAN26_BUFFER+0
	MOVWF       FSR0 
	MOVLW       hi_addr(Expendedora_WIEGAN26_BUFFER+0)
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
L__int_external_int0957:
;wiegand26.h,172 :: 		WIEGAN26_CONT++;
	INCF        Expendedora_WIEGAN26_CONT+0, 1 
;wiegand26.h,173 :: 		WIEGAN26_DATA <<= 1;
	RLCF        Expendedora_WIEGAN26_DATA+0, 1 
	BCF         Expendedora_WIEGAN26_DATA+0, 0 
	RLCF        Expendedora_WIEGAN26_DATA+1, 1 
	RLCF        Expendedora_WIEGAN26_DATA+2, 1 
	RLCF        Expendedora_WIEGAN26_DATA+3, 1 
;wiegand26.h,174 :: 		WIEGAN26_DATA |= 0;
;wiegand26.h,176 :: 		WIEGAND_TEMP = 0;
	CLRF        _WIEGAND_TEMP+0 
	CLRF        _WIEGAND_TEMP+1 
;wiegand26.h,177 :: 		if(WIEGAN26_CONT > WIEGAND_BITS_NIP)
	MOVF        Expendedora_WIEGAN26_CONT+0, 0 
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
L__int_external_int1958:
;wiegand26.h,185 :: 		WIEGAN26_CONT++;
	INCF        Expendedora_WIEGAN26_CONT+0, 1 
;wiegand26.h,186 :: 		WIEGAN26_DATA <<= 1;
	RLCF        Expendedora_WIEGAN26_DATA+0, 1 
	BCF         Expendedora_WIEGAN26_DATA+0, 0 
	RLCF        Expendedora_WIEGAN26_DATA+1, 1 
	RLCF        Expendedora_WIEGAN26_DATA+2, 1 
	RLCF        Expendedora_WIEGAN26_DATA+3, 1 
;wiegand26.h,187 :: 		WIEGAN26_DATA |= 1;
	BSF         Expendedora_WIEGAN26_DATA+0, 0 
;wiegand26.h,189 :: 		WIEGAND_TEMP = 0;
	CLRF        _WIEGAND_TEMP+0 
	CLRF        _WIEGAND_TEMP+1 
;wiegand26.h,190 :: 		if(WIEGAN26_CONT > WIEGAND_BITS_NIP)
	MOVF        Expendedora_WIEGAN26_CONT+0, 0 
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
L__int_timer2959:
;wiegand26.h,199 :: 		WIEGAND_TEMP += 5;  //Cada 5ms
	MOVLW       5
	ADDWF       _WIEGAND_TEMP+0, 1 
	MOVLW       0
	ADDWFC      _WIEGAND_TEMP+1, 1 
;wiegand26.h,200 :: 		if(WIEGAND_TEMP >= WIEGAND_TIME_FRAME_RESET){
	MOVLW       19
	SUBWF       _WIEGAND_TEMP+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__int_timer21316
	MOVLW       136
	SUBWF       _WIEGAND_TEMP+0, 0 
L__int_timer21316:
	BTFSS       STATUS+0, 0 
	GOTO        L_int_timer2572
;wiegand26.h,201 :: 		WIEGAND_TEMP = 0;
	CLRF        _WIEGAND_TEMP+0 
	CLRF        _WIEGAND_TEMP+1 
;wiegand26.h,203 :: 		if(WIEGAN26_CONT){
	MOVF        Expendedora_WIEGAN26_CONT+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_int_timer2573
;wiegand26.h,204 :: 		if(!(WIEGAN26_CONT == WIEGAND_BITS_CARD || WIEGAN26_CONT == WIEGAND_BITS_NIP)){
	MOVF        Expendedora_WIEGAN26_CONT+0, 0 
	XORLW       26
	BTFSC       STATUS+0, 2 
	GOTO        L_int_timer2575
	MOVF        Expendedora_WIEGAN26_CONT+0, 0 
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
	CLRF        Expendedora_WIEGAN26_CONT+0 
;wiegand26.h,206 :: 		WIEGAN26_DATA = 0;
	CLRF        Expendedora_WIEGAN26_DATA+0 
	CLRF        Expendedora_WIEGAN26_DATA+1 
	CLRF        Expendedora_WIEGAN26_DATA+2 
	CLRF        Expendedora_WIEGAN26_DATA+3 
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

_encrypt_basic:

;_lib_cryptography.h,5 :: 		void encrypt_basic(char *cadena){
;_lib_cryptography.h,6 :: 		char cont = 0;
	CLRF        encrypt_basic_cont_L0+0 
;_lib_cryptography.h,8 :: 		while(cadena[cont]){
L_encrypt_basic577:
	MOVF        encrypt_basic_cont_L0+0, 0 
	ADDWF       FARG_encrypt_basic_cadena+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_encrypt_basic_cadena+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_encrypt_basic578
;_lib_cryptography.h,9 :: 		if(cadena[cont] == '0')
	MOVF        encrypt_basic_cont_L0+0, 0 
	ADDWF       FARG_encrypt_basic_cadena+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_encrypt_basic_cadena+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	XORLW       48
	BTFSS       STATUS+0, 2 
	GOTO        L_encrypt_basic579
;_lib_cryptography.h,10 :: 		cadena[cont] = '2';
	MOVF        encrypt_basic_cont_L0+0, 0 
	ADDWF       FARG_encrypt_basic_cadena+0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      FARG_encrypt_basic_cadena+1, 0 
	MOVWF       FSR1H 
	MOVLW       50
	MOVWF       POSTINC1+0 
	GOTO        L_encrypt_basic580
L_encrypt_basic579:
;_lib_cryptography.h,11 :: 		else if(cadena[cont] == '1')
	MOVF        encrypt_basic_cont_L0+0, 0 
	ADDWF       FARG_encrypt_basic_cadena+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_encrypt_basic_cadena+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	XORLW       49
	BTFSS       STATUS+0, 2 
	GOTO        L_encrypt_basic581
;_lib_cryptography.h,12 :: 		cadena[cont] = '0';
	MOVF        encrypt_basic_cont_L0+0, 0 
	ADDWF       FARG_encrypt_basic_cadena+0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      FARG_encrypt_basic_cadena+1, 0 
	MOVWF       FSR1H 
	MOVLW       48
	MOVWF       POSTINC1+0 
	GOTO        L_encrypt_basic582
L_encrypt_basic581:
;_lib_cryptography.h,13 :: 		else if(cadena[cont] == '2')
	MOVF        encrypt_basic_cont_L0+0, 0 
	ADDWF       FARG_encrypt_basic_cadena+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_encrypt_basic_cadena+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	XORLW       50
	BTFSS       STATUS+0, 2 
	GOTO        L_encrypt_basic583
;_lib_cryptography.h,14 :: 		cadena[cont] = '8';
	MOVF        encrypt_basic_cont_L0+0, 0 
	ADDWF       FARG_encrypt_basic_cadena+0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      FARG_encrypt_basic_cadena+1, 0 
	MOVWF       FSR1H 
	MOVLW       56
	MOVWF       POSTINC1+0 
	GOTO        L_encrypt_basic584
L_encrypt_basic583:
;_lib_cryptography.h,15 :: 		else if(cadena[cont] == '3')
	MOVF        encrypt_basic_cont_L0+0, 0 
	ADDWF       FARG_encrypt_basic_cadena+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_encrypt_basic_cadena+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	XORLW       51
	BTFSS       STATUS+0, 2 
	GOTO        L_encrypt_basic585
;_lib_cryptography.h,16 :: 		cadena[cont] = '9';
	MOVF        encrypt_basic_cont_L0+0, 0 
	ADDWF       FARG_encrypt_basic_cadena+0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      FARG_encrypt_basic_cadena+1, 0 
	MOVWF       FSR1H 
	MOVLW       57
	MOVWF       POSTINC1+0 
	GOTO        L_encrypt_basic586
L_encrypt_basic585:
;_lib_cryptography.h,17 :: 		else if(cadena[cont] == '4')
	MOVF        encrypt_basic_cont_L0+0, 0 
	ADDWF       FARG_encrypt_basic_cadena+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_encrypt_basic_cadena+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	XORLW       52
	BTFSS       STATUS+0, 2 
	GOTO        L_encrypt_basic587
;_lib_cryptography.h,18 :: 		cadena[cont] = '7';
	MOVF        encrypt_basic_cont_L0+0, 0 
	ADDWF       FARG_encrypt_basic_cadena+0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      FARG_encrypt_basic_cadena+1, 0 
	MOVWF       FSR1H 
	MOVLW       55
	MOVWF       POSTINC1+0 
	GOTO        L_encrypt_basic588
L_encrypt_basic587:
;_lib_cryptography.h,19 :: 		else if(cadena[cont] == '5')
	MOVF        encrypt_basic_cont_L0+0, 0 
	ADDWF       FARG_encrypt_basic_cadena+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_encrypt_basic_cadena+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	XORLW       53
	BTFSS       STATUS+0, 2 
	GOTO        L_encrypt_basic589
;_lib_cryptography.h,20 :: 		cadena[cont] = '6';
	MOVF        encrypt_basic_cont_L0+0, 0 
	ADDWF       FARG_encrypt_basic_cadena+0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      FARG_encrypt_basic_cadena+1, 0 
	MOVWF       FSR1H 
	MOVLW       54
	MOVWF       POSTINC1+0 
	GOTO        L_encrypt_basic590
L_encrypt_basic589:
;_lib_cryptography.h,21 :: 		else if(cadena[cont] == '6')
	MOVF        encrypt_basic_cont_L0+0, 0 
	ADDWF       FARG_encrypt_basic_cadena+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_encrypt_basic_cadena+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	XORLW       54
	BTFSS       STATUS+0, 2 
	GOTO        L_encrypt_basic591
;_lib_cryptography.h,22 :: 		cadena[cont] = '4';
	MOVF        encrypt_basic_cont_L0+0, 0 
	ADDWF       FARG_encrypt_basic_cadena+0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      FARG_encrypt_basic_cadena+1, 0 
	MOVWF       FSR1H 
	MOVLW       52
	MOVWF       POSTINC1+0 
	GOTO        L_encrypt_basic592
L_encrypt_basic591:
;_lib_cryptography.h,23 :: 		else if(cadena[cont] == '7')
	MOVF        encrypt_basic_cont_L0+0, 0 
	ADDWF       FARG_encrypt_basic_cadena+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_encrypt_basic_cadena+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	XORLW       55
	BTFSS       STATUS+0, 2 
	GOTO        L_encrypt_basic593
;_lib_cryptography.h,24 :: 		cadena[cont] = '5';
	MOVF        encrypt_basic_cont_L0+0, 0 
	ADDWF       FARG_encrypt_basic_cadena+0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      FARG_encrypt_basic_cadena+1, 0 
	MOVWF       FSR1H 
	MOVLW       53
	MOVWF       POSTINC1+0 
	GOTO        L_encrypt_basic594
L_encrypt_basic593:
;_lib_cryptography.h,25 :: 		else if(cadena[cont] == '8')
	MOVF        encrypt_basic_cont_L0+0, 0 
	ADDWF       FARG_encrypt_basic_cadena+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_encrypt_basic_cadena+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	XORLW       56
	BTFSS       STATUS+0, 2 
	GOTO        L_encrypt_basic595
;_lib_cryptography.h,26 :: 		cadena[cont] = '3';
	MOVF        encrypt_basic_cont_L0+0, 0 
	ADDWF       FARG_encrypt_basic_cadena+0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      FARG_encrypt_basic_cadena+1, 0 
	MOVWF       FSR1H 
	MOVLW       51
	MOVWF       POSTINC1+0 
	GOTO        L_encrypt_basic596
L_encrypt_basic595:
;_lib_cryptography.h,27 :: 		else if(cadena[cont] == '9')
	MOVF        encrypt_basic_cont_L0+0, 0 
	ADDWF       FARG_encrypt_basic_cadena+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_encrypt_basic_cadena+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	XORLW       57
	BTFSS       STATUS+0, 2 
	GOTO        L_encrypt_basic597
;_lib_cryptography.h,28 :: 		cadena[cont] = '1';
	MOVF        encrypt_basic_cont_L0+0, 0 
	ADDWF       FARG_encrypt_basic_cadena+0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      FARG_encrypt_basic_cadena+1, 0 
	MOVWF       FSR1H 
	MOVLW       49
	MOVWF       POSTINC1+0 
L_encrypt_basic597:
L_encrypt_basic596:
L_encrypt_basic594:
L_encrypt_basic592:
L_encrypt_basic590:
L_encrypt_basic588:
L_encrypt_basic586:
L_encrypt_basic584:
L_encrypt_basic582:
L_encrypt_basic580:
;_lib_cryptography.h,29 :: 		cont++;
	INCF        encrypt_basic_cont_L0+0, 1 
;_lib_cryptography.h,30 :: 		}
	GOTO        L_encrypt_basic577
L_encrypt_basic578:
;_lib_cryptography.h,31 :: 		}
L_end_encrypt_basic:
	RETURN      0
; end of _encrypt_basic

_decrypt_basic:

;_lib_cryptography.h,33 :: 		void decrypt_basic(char *cadena){
;_lib_cryptography.h,34 :: 		char cont = 0;
	CLRF        decrypt_basic_cont_L0+0 
;_lib_cryptography.h,36 :: 		while(cadena[cont]){
L_decrypt_basic598:
	MOVF        decrypt_basic_cont_L0+0, 0 
	ADDWF       FARG_decrypt_basic_cadena+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_decrypt_basic_cadena+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_decrypt_basic599
;_lib_cryptography.h,37 :: 		if(cadena[cont] == '0')
	MOVF        decrypt_basic_cont_L0+0, 0 
	ADDWF       FARG_decrypt_basic_cadena+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_decrypt_basic_cadena+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	XORLW       48
	BTFSS       STATUS+0, 2 
	GOTO        L_decrypt_basic600
;_lib_cryptography.h,38 :: 		cadena[cont] = '1';
	MOVF        decrypt_basic_cont_L0+0, 0 
	ADDWF       FARG_decrypt_basic_cadena+0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      FARG_decrypt_basic_cadena+1, 0 
	MOVWF       FSR1H 
	MOVLW       49
	MOVWF       POSTINC1+0 
	GOTO        L_decrypt_basic601
L_decrypt_basic600:
;_lib_cryptography.h,39 :: 		else if(cadena[cont] == '1')
	MOVF        decrypt_basic_cont_L0+0, 0 
	ADDWF       FARG_decrypt_basic_cadena+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_decrypt_basic_cadena+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	XORLW       49
	BTFSS       STATUS+0, 2 
	GOTO        L_decrypt_basic602
;_lib_cryptography.h,40 :: 		cadena[cont] = '9';
	MOVF        decrypt_basic_cont_L0+0, 0 
	ADDWF       FARG_decrypt_basic_cadena+0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      FARG_decrypt_basic_cadena+1, 0 
	MOVWF       FSR1H 
	MOVLW       57
	MOVWF       POSTINC1+0 
	GOTO        L_decrypt_basic603
L_decrypt_basic602:
;_lib_cryptography.h,41 :: 		else if(cadena[cont] == '2')
	MOVF        decrypt_basic_cont_L0+0, 0 
	ADDWF       FARG_decrypt_basic_cadena+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_decrypt_basic_cadena+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	XORLW       50
	BTFSS       STATUS+0, 2 
	GOTO        L_decrypt_basic604
;_lib_cryptography.h,42 :: 		cadena[cont] = '0';
	MOVF        decrypt_basic_cont_L0+0, 0 
	ADDWF       FARG_decrypt_basic_cadena+0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      FARG_decrypt_basic_cadena+1, 0 
	MOVWF       FSR1H 
	MOVLW       48
	MOVWF       POSTINC1+0 
	GOTO        L_decrypt_basic605
L_decrypt_basic604:
;_lib_cryptography.h,43 :: 		else if(cadena[cont] == '3')
	MOVF        decrypt_basic_cont_L0+0, 0 
	ADDWF       FARG_decrypt_basic_cadena+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_decrypt_basic_cadena+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	XORLW       51
	BTFSS       STATUS+0, 2 
	GOTO        L_decrypt_basic606
;_lib_cryptography.h,44 :: 		cadena[cont] = '8';
	MOVF        decrypt_basic_cont_L0+0, 0 
	ADDWF       FARG_decrypt_basic_cadena+0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      FARG_decrypt_basic_cadena+1, 0 
	MOVWF       FSR1H 
	MOVLW       56
	MOVWF       POSTINC1+0 
	GOTO        L_decrypt_basic607
L_decrypt_basic606:
;_lib_cryptography.h,45 :: 		else if(cadena[cont] == '4')
	MOVF        decrypt_basic_cont_L0+0, 0 
	ADDWF       FARG_decrypt_basic_cadena+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_decrypt_basic_cadena+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	XORLW       52
	BTFSS       STATUS+0, 2 
	GOTO        L_decrypt_basic608
;_lib_cryptography.h,46 :: 		cadena[cont] = '6';
	MOVF        decrypt_basic_cont_L0+0, 0 
	ADDWF       FARG_decrypt_basic_cadena+0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      FARG_decrypt_basic_cadena+1, 0 
	MOVWF       FSR1H 
	MOVLW       54
	MOVWF       POSTINC1+0 
	GOTO        L_decrypt_basic609
L_decrypt_basic608:
;_lib_cryptography.h,47 :: 		else if(cadena[cont] == '5')
	MOVF        decrypt_basic_cont_L0+0, 0 
	ADDWF       FARG_decrypt_basic_cadena+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_decrypt_basic_cadena+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	XORLW       53
	BTFSS       STATUS+0, 2 
	GOTO        L_decrypt_basic610
;_lib_cryptography.h,48 :: 		cadena[cont] = '7';
	MOVF        decrypt_basic_cont_L0+0, 0 
	ADDWF       FARG_decrypt_basic_cadena+0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      FARG_decrypt_basic_cadena+1, 0 
	MOVWF       FSR1H 
	MOVLW       55
	MOVWF       POSTINC1+0 
	GOTO        L_decrypt_basic611
L_decrypt_basic610:
;_lib_cryptography.h,49 :: 		else if(cadena[cont] == '6')
	MOVF        decrypt_basic_cont_L0+0, 0 
	ADDWF       FARG_decrypt_basic_cadena+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_decrypt_basic_cadena+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	XORLW       54
	BTFSS       STATUS+0, 2 
	GOTO        L_decrypt_basic612
;_lib_cryptography.h,50 :: 		cadena[cont] = '5';
	MOVF        decrypt_basic_cont_L0+0, 0 
	ADDWF       FARG_decrypt_basic_cadena+0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      FARG_decrypt_basic_cadena+1, 0 
	MOVWF       FSR1H 
	MOVLW       53
	MOVWF       POSTINC1+0 
	GOTO        L_decrypt_basic613
L_decrypt_basic612:
;_lib_cryptography.h,51 :: 		else if(cadena[cont] == '7')
	MOVF        decrypt_basic_cont_L0+0, 0 
	ADDWF       FARG_decrypt_basic_cadena+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_decrypt_basic_cadena+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	XORLW       55
	BTFSS       STATUS+0, 2 
	GOTO        L_decrypt_basic614
;_lib_cryptography.h,52 :: 		cadena[cont] = '4';
	MOVF        decrypt_basic_cont_L0+0, 0 
	ADDWF       FARG_decrypt_basic_cadena+0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      FARG_decrypt_basic_cadena+1, 0 
	MOVWF       FSR1H 
	MOVLW       52
	MOVWF       POSTINC1+0 
	GOTO        L_decrypt_basic615
L_decrypt_basic614:
;_lib_cryptography.h,53 :: 		else if(cadena[cont] == '8')
	MOVF        decrypt_basic_cont_L0+0, 0 
	ADDWF       FARG_decrypt_basic_cadena+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_decrypt_basic_cadena+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	XORLW       56
	BTFSS       STATUS+0, 2 
	GOTO        L_decrypt_basic616
;_lib_cryptography.h,54 :: 		cadena[cont] = '2';
	MOVF        decrypt_basic_cont_L0+0, 0 
	ADDWF       FARG_decrypt_basic_cadena+0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      FARG_decrypt_basic_cadena+1, 0 
	MOVWF       FSR1H 
	MOVLW       50
	MOVWF       POSTINC1+0 
	GOTO        L_decrypt_basic617
L_decrypt_basic616:
;_lib_cryptography.h,55 :: 		else if(cadena[cont] == '9')
	MOVF        decrypt_basic_cont_L0+0, 0 
	ADDWF       FARG_decrypt_basic_cadena+0, 0 
	MOVWF       FSR0 
	MOVLW       0
	ADDWFC      FARG_decrypt_basic_cadena+1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	XORLW       57
	BTFSS       STATUS+0, 2 
	GOTO        L_decrypt_basic618
;_lib_cryptography.h,56 :: 		cadena[cont] = '3';
	MOVF        decrypt_basic_cont_L0+0, 0 
	ADDWF       FARG_decrypt_basic_cadena+0, 0 
	MOVWF       FSR1 
	MOVLW       0
	ADDWFC      FARG_decrypt_basic_cadena+1, 0 
	MOVWF       FSR1H 
	MOVLW       51
	MOVWF       POSTINC1+0 
L_decrypt_basic618:
L_decrypt_basic617:
L_decrypt_basic615:
L_decrypt_basic613:
L_decrypt_basic611:
L_decrypt_basic609:
L_decrypt_basic607:
L_decrypt_basic605:
L_decrypt_basic603:
L_decrypt_basic601:
;_lib_cryptography.h,57 :: 		cont++;
	INCF        decrypt_basic_cont_L0+0, 1 
;_lib_cryptography.h,58 :: 		}
	GOTO        L_decrypt_basic598
L_decrypt_basic599:
;_lib_cryptography.h,59 :: 		}
L_end_decrypt_basic:
	RETURN      0
; end of _decrypt_basic

_main:

;Expendedora.c,250 :: 		void main(){
;Expendedora.c,252 :: 		pic_init();
	CALL        _pic_init+0, 0
;Expendedora.c,254 :: 		while(true){
L_main619:
;Expendedora.c,255 :: 		can_do_work();                  //Tareas can open
	CALL        _can_do_work+0, 0
;Expendedora.c,256 :: 		expendedora_checkTarjeta();     //Verifica la tarjeta del pensionado
	CALL        _expendedora_checkTarjeta+0, 0
;Expendedora.c,257 :: 		expendedora_imprimir();         //Imprime ticket
	CALL        _expendedora_imprimir+0, 0
;Expendedora.c,258 :: 		expendedora_bufferEventos();
	CALL        _expendedora_bufferEventos+0, 0
;Expendedora.c,259 :: 		expendedora_temporizadores();
	CALL        _expendedora_temporizadores+0, 0
;Expendedora.c,260 :: 		expendedora_barrera();
	CALL        _expendedora_barrera+0, 0
;Expendedora.c,261 :: 		}
	GOTO        L_main619
;Expendedora.c,262 :: 		}
L_end_main:
	GOTO        $+0
; end of _main

_interrupt:

;Expendedora.c,264 :: 		void interrupt(){
;Expendedora.c,265 :: 		int_wiegand26();
	CALL        _int_wiegand26+0, 0
;Expendedora.c,267 :: 		}
L_end_interrupt:
L__interrupt1321:
	RETFIE      1
; end of _interrupt

_interrupt_low:
	MOVWF       ___Low_saveWREG+0 
	MOVF        STATUS+0, 0 
	MOVWF       ___Low_saveSTATUS+0 
	MOVF        BSR+0, 0 
	MOVWF       ___Low_saveBSR+0 

;Expendedora.c,269 :: 		void interrupt_low(){
;Expendedora.c,270 :: 		int_timer1();
	CALL        _int_timer1+0, 0
;Expendedora.c,271 :: 		int_timer2();
	CALL        _int_timer2+0, 0
;Expendedora.c,272 :: 		int_timer3();
	CALL        _int_timer3+0, 0
;Expendedora.c,274 :: 		int_can();
	CALL        _int_can+0, 0
;Expendedora.c,275 :: 		}
L_end_interrupt_low:
L__interrupt_low1323:
	MOVF        ___Low_saveBSR+0, 0 
	MOVWF       BSR+0 
	MOVF        ___Low_saveSTATUS+0, 0 
	MOVWF       STATUS+0 
	SWAPF       ___Low_saveWREG+0, 1 
	SWAPF       ___Low_saveWREG+0, 0 
	RETFIE      0
; end of _interrupt_low

_pic_init:

;Expendedora.c,279 :: 		void pic_init(){
;Expendedora.c,281 :: 		OSCCON = 0x40;  //Oscilador externo
	MOVLW       64
	MOVWF       OSCCON+0 
;Expendedora.c,284 :: 		ADCON1 = 0x0F;  //Todos digitales
	MOVLW       15
	MOVWF       ADCON1+0 
;Expendedora.c,285 :: 		CMCON = 0x07;   //Apagar los comparadores
	MOVLW       7
	MOVWF       CMCON+0 
;Expendedora.c,288 :: 		SENSOR_COCHED = 1;
	BSF         TRISD+0, 0 
;Expendedora.c,289 :: 		BOTON_IMPRIMIRD = 1;
	BSF         TRISD+0, 1 
;Expendedora.c,290 :: 		BOTON_ENTRADA1D = 1;
	BSF         TRISD+0, 4 
;Expendedora.c,291 :: 		LED_LINKD = 0;
	BCF         TRISC+0, 2 
;Expendedora.c,292 :: 		SALIDA_RELE1D = 0;
	BCF         TRISA+0, 5 
;Expendedora.c,293 :: 		SALIDA_RELE2D = 0;
	BCF         TRISE+0, 0 
;Expendedora.c,294 :: 		SALIDA_RELE3D = 0;
	BCF         TRISD+0, 2 
;Expendedora.c,295 :: 		SALIDA_RELE4D = 0;
	BCF         TRISD+0, 3 
;Expendedora.c,296 :: 		SALIDA_RELE5D = 0;
	BCF         TRISD+0, 7 
;Expendedora.c,298 :: 		SALIDA_RELE1 = 0;
	BCF         PORTA+0, 5 
;Expendedora.c,299 :: 		SALIDA_RELE2 = 0;
	BCF         PORTE+0, 0 
;Expendedora.c,300 :: 		SALIDA_RELE3 = 0;
	BCF         PORTD+0, 2 
;Expendedora.c,301 :: 		SALIDA_RELE4 = 0;
	BCF         PORTD+0, 3 
;Expendedora.c,302 :: 		SALIDA_RELE5 = 0;
	BCF         PORTD+0, 7 
;Expendedora.c,303 :: 		LED_LINK = 0;
	BCF         PORTC+0, 2 
;Expendedora.c,306 :: 		canId = eeprom_read(0);
	CLRF        FARG_EEPROM_Read_address+0 
	CLRF        FARG_EEPROM_Read_address+1 
	CALL        _EEPROM_Read+0, 0
	MOVF        R0, 0 
	MOVWF       _canId+0 
;Expendedora.c,309 :: 		timer1_open(200e3, true, false, false);
	MOVLW       64
	MOVWF       FARG_timer1_open_time_us+0 
	MOVLW       13
	MOVWF       FARG_timer1_open_time_us+1 
	MOVLW       3
	MOVWF       FARG_timer1_open_time_us+2 
	MOVLW       0
	MOVWF       FARG_timer1_open_time_us+3 
	MOVLW       1
	MOVWF       FARG_timer1_open_powerOn+0 
	CLRF        FARG_timer1_open_enable+0 
	CLRF        FARG_timer1_open_priorityHigh+0 
	CALL        _timer1_open+0, 0
;Expendedora.c,310 :: 		timer3_open(200e3, true, true, false);
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
;Expendedora.c,311 :: 		usart_open(baudiosRate);
	MOVLW       0
	MOVWF       FARG_usart_open_baudRate+0 
	MOVLW       150
	MOVWF       FARG_usart_open_baudRate+1 
	MOVLW       0
	MOVWF       FARG_usart_open_baudRate+2 
	MOVLW       0
	MOVWF       FARG_usart_open_baudRate+3 
	CALL        _usart_open+0, 0
;Expendedora.c,315 :: 		DS1307_open();
	CALL        _DS1307_open+0, 0
;Expendedora.c,316 :: 		lcd_init();
	CALL        _Lcd_Init+0, 0
;Expendedora.c,317 :: 		lcd_cmd(_LCD_CURSOR_OFF);
	MOVLW       12
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;Expendedora.c,318 :: 		lcd_cmd(_LCD_CLEAR);
	MOVLW       1
	MOVWF       FARG_Lcd_Cmd_out_char+0 
	CALL        _Lcd_Cmd+0, 0
;Expendedora.c,319 :: 		mysql_init(32768);
	MOVLW       0
	MOVWF       FARG_mysql_init_memoryMax+0 
	MOVLW       128
	MOVWF       FARG_mysql_init_memoryMax+1 
	CALL        _mysql_init+0, 0
;Expendedora.c,320 :: 		wiegand26_open();
	CALL        _wiegand26_open+0, 0
;Expendedora.c,321 :: 		can_open(canIp, canMask, canId, 4);
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
	MOVF        _canId+0, 0 
	MOVWF       FARG_can_open_id+0 
	MOVLW       4
	MOVWF       FARG_can_open_speed_us+0 
	CALL        _can_open+0, 0
;Expendedora.c,322 :: 		can_interrupt(true, false);
	MOVLW       1
	MOVWF       FARG_can_interrupt_enable+0 
	CLRF        FARG_can_interrupt_hihgPriprity+0 
	CALL        _can_interrupt+0, 0
;Expendedora.c,325 :: 		lcd_clean_row(1);
	MOVLW       1
	MOVWF       FARG_lcd_clean_row_fila+0 
	CALL        _lcd_clean_row+0, 0
;Expendedora.c,326 :: 		lcd_out(1, 1, "Inicializando...");
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr1_Expendedora+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr1_Expendedora+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;Expendedora.c,330 :: 		wiegand26_enable();
	CALL        _wiegand26_enable+0, 0
;Expendedora.c,331 :: 		DS1307_Read(&myRTC, true);
	MOVLW       _myRTC+0
	MOVWF       FARG_DS1307_read_myDS+0 
	MOVLW       hi_addr(_myRTC+0)
	MOVWF       FARG_DS1307_read_myDS+1 
	MOVLW       1
	MOVWF       FARG_DS1307_read_formatComplet+0 
	CALL        _DS1307_read+0, 0
;Expendedora.c,333 :: 		pilaBufferCAN = mysql_count_forced(tableEventosCAN, eventosEstatus, '1');
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
;Expendedora.c,340 :: 		mysql_read(tableFolio, folioTotal, 1, &folio);
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
;Expendedora.c,341 :: 		mysql_read_string(tableCupo, columnaEstado, 1, &cupoLleno);
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
;Expendedora.c,342 :: 		mysql_read_string(tableSyncronia, columnaEstado, 1, &canSynchrony);
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
;Expendedora.c,345 :: 		RCON.IPEN = 1;     //ACTIVAR NIVELES DE INTERRUPCION
	BSF         RCON+0, 7 
;Expendedora.c,346 :: 		INTCON.PEIE = 1;   //ACTIVAR INTERRUPCIONES PERIFERICAS
	BSF         INTCON+0, 6 
;Expendedora.c,347 :: 		INTCON.GIE = 1;    //ACTIVAR INTERRUPCIONES GLOBALES
	BSF         INTCON+0, 7 
;Expendedora.c,459 :: 		delay_ms(timeAwake);
	MOVLW       4
	MOVWF       R11, 0
	MOVLW       207
	MOVWF       R12, 0
	MOVLW       1
	MOVWF       R13, 0
L_pic_init621:
	DECFSZ      R13, 1, 1
	BRA         L_pic_init621
	DECFSZ      R12, 1, 1
	BRA         L_pic_init621
	DECFSZ      R11, 1, 1
	BRA         L_pic_init621
	NOP
	NOP
;Expendedora.c,463 :: 		lcd_clean_row(1);
	MOVLW       1
	MOVWF       FARG_lcd_clean_row_fila+0 
	CALL        _lcd_clean_row+0, 0
;Expendedora.c,465 :: 		lcd_out(1, 5, "Expendedora");
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       5
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr2_Expendedora+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr2_Expendedora+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;Expendedora.c,466 :: 		}
L_end_pic_init:
	RETURN      0
; end of _pic_init

_expendedora_barrera:

;Expendedora.c,468 :: 		void expendedora_barrera(){
;Expendedora.c,473 :: 		if(BOTON_ENTRADA1 && !sensor.B0){
	BTFSS       PORTD+0, 4 
	GOTO        L_expendedora_barrera624
	BTFSC       expendedora_barrera_sensor_L0+0, 0 
	GOTO        L_expendedora_barrera624
L__expendedora_barrera961:
;Expendedora.c,474 :: 		sensor.B0 = true;
	BSF         expendedora_barrera_sensor_L0+0, 0 
;Expendedora.c,476 :: 		string_cpyc(bufferEeprom, CAN_TPV);
	MOVLW       _bufferEeprom+0
	MOVWF       FARG_string_cpyc_destino+0 
	MOVLW       hi_addr(_bufferEeprom+0)
	MOVWF       FARG_string_cpyc_destino+1 
	MOVLW       _CAN_TPV+0
	MOVWF       FARG_string_cpyc_origen+0 
	MOVLW       hi_addr(_CAN_TPV+0)
	MOVWF       FARG_string_cpyc_origen+1 
	MOVLW       higher_addr(_CAN_TPV+0)
	MOVWF       FARG_string_cpyc_origen+2 
	CALL        _string_cpyc+0, 0
;Expendedora.c,477 :: 		string_addc(bufferEeprom, CAN_BAR);         //BAR
	MOVLW       _bufferEeprom+0
	MOVWF       FARG_string_addc_destino+0 
	MOVLW       hi_addr(_bufferEeprom+0)
	MOVWF       FARG_string_addc_destino+1 
	MOVLW       expendedora_barrera_CAN_BAR_L0+0
	MOVWF       FARG_string_addc_addEnd+0 
	MOVLW       hi_addr(expendedora_barrera_CAN_BAR_L0+0)
	MOVWF       FARG_string_addc_addEnd+1 
	MOVLW       higher_addr(expendedora_barrera_CAN_BAR_L0+0)
	MOVWF       FARG_string_addc_addEnd+2 
	CALL        _string_addc+0, 0
;Expendedora.c,478 :: 		string_addc(bufferEeprom, BARRERA_ABIERTA);
	MOVLW       _bufferEeprom+0
	MOVWF       FARG_string_addc_destino+0 
	MOVLW       hi_addr(_bufferEeprom+0)
	MOVWF       FARG_string_addc_destino+1 
	MOVLW       expendedora_barrera_BARRERA_ABIERTA_L0+0
	MOVWF       FARG_string_addc_addEnd+0 
	MOVLW       hi_addr(expendedora_barrera_BARRERA_ABIERTA_L0+0)
	MOVWF       FARG_string_addc_addEnd+1 
	MOVLW       higher_addr(expendedora_barrera_BARRERA_ABIERTA_L0+0)
	MOVWF       FARG_string_addc_addEnd+2 
	CALL        _string_addc+0, 0
;Expendedora.c,479 :: 		DS1307_read(&myRTC, false);
	MOVLW       _myRTC+0
	MOVWF       FARG_DS1307_read_myDS+0 
	MOVLW       hi_addr(_myRTC+0)
	MOVWF       FARG_DS1307_read_myDS+1 
	CLRF        FARG_DS1307_read_formatComplet+0 
	CALL        _DS1307_read+0, 0
;Expendedora.c,480 :: 		string_add(bufferEeprom, &myRTC.time[1]);
	MOVLW       _bufferEeprom+0
	MOVWF       FARG_string_add_destino+0 
	MOVLW       hi_addr(_bufferEeprom+0)
	MOVWF       FARG_string_add_destino+1 
	MOVLW       _myRTC+8
	MOVWF       FARG_string_add_addEnd+0 
	MOVLW       hi_addr(_myRTC+8)
	MOVWF       FARG_string_add_addEnd+1 
	CALL        _string_add+0, 0
;Expendedora.c,482 :: 		string_addc(bufferEeprom, CAN_MODULE);
	MOVLW       _bufferEeprom+0
	MOVWF       FARG_string_addc_destino+0 
	MOVLW       hi_addr(_bufferEeprom+0)
	MOVWF       FARG_string_addc_destino+1 
	MOVLW       _CAN_MODULE+0
	MOVWF       FARG_string_addc_addEnd+0 
	MOVLW       hi_addr(_CAN_MODULE+0)
	MOVWF       FARG_string_addc_addEnd+1 
	MOVLW       higher_addr(_CAN_MODULE+0)
	MOVWF       FARG_string_addc_addEnd+2 
	CALL        _string_addc+0, 0
;Expendedora.c,483 :: 		numToHex(canId, msjConst, 1);
	MOVF        _canId+0, 0 
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
;Expendedora.c,484 :: 		string_add(bufferEeprom, msjConst);
	MOVLW       _bufferEeprom+0
	MOVWF       FARG_string_add_destino+0 
	MOVLW       hi_addr(_bufferEeprom+0)
	MOVWF       FARG_string_add_destino+1 
	MOVLW       _msjConst+0
	MOVWF       FARG_string_add_addEnd+0 
	MOVLW       hi_addr(_msjConst+0)
	MOVWF       FARG_string_add_addEnd+1 
	CALL        _string_add+0, 0
;Expendedora.c,485 :: 		buffer_save_send(false, bufferEeprom);
	CLRF        FARG_buffer_save_send_guardar+0 
	MOVLW       _bufferEeprom+0
	MOVWF       FARG_buffer_save_send_buffer+0 
	MOVLW       hi_addr(_bufferEeprom+0)
	MOVWF       FARG_buffer_save_send_buffer+1 
	CALL        _buffer_save_send+0, 0
;Expendedora.c,489 :: 		delay_ms(50);
	MOVLW       163
	MOVWF       R12, 0
	MOVLW       85
	MOVWF       R13, 0
L_expendedora_barrera625:
	DECFSZ      R13, 1, 1
	BRA         L_expendedora_barrera625
	DECFSZ      R12, 1, 1
	BRA         L_expendedora_barrera625
;Expendedora.c,490 :: 		}else if(!BOTON_ENTRADA1 && sensor){
	GOTO        L_expendedora_barrera626
L_expendedora_barrera624:
	BTFSC       PORTD+0, 4 
	GOTO        L_expendedora_barrera629
	MOVF        expendedora_barrera_sensor_L0+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_expendedora_barrera629
L__expendedora_barrera960:
;Expendedora.c,491 :: 		sensor.B0 = false;
	BCF         expendedora_barrera_sensor_L0+0, 0 
;Expendedora.c,492 :: 		delay_ms(50);
	MOVLW       163
	MOVWF       R12, 0
	MOVLW       85
	MOVWF       R13, 0
L_expendedora_barrera630:
	DECFSZ      R13, 1, 1
	BRA         L_expendedora_barrera630
	DECFSZ      R12, 1, 1
	BRA         L_expendedora_barrera630
;Expendedora.c,493 :: 		}
L_expendedora_barrera629:
L_expendedora_barrera626:
;Expendedora.c,494 :: 		}
L_end_expendedora_barrera:
	RETURN      0
; end of _expendedora_barrera

_expendedora_temporizadores:

;Expendedora.c,496 :: 		void expendedora_temporizadores(){
;Expendedora.c,499 :: 		if(flagSecondTMR3){
	MOVF        _flagSecondTMR3+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_expendedora_temporizadores631
;Expendedora.c,500 :: 		flagSecondTMR3 = false;
	CLRF        _flagSecondTMR3+0 
;Expendedora.c,501 :: 		can_heartbeat();              //Envia heartbeat
	CALL        _can_heartbeat+0, 0
;Expendedora.c,502 :: 		tempSensor++;
	INCF        _tempSensor+0, 1 
;Expendedora.c,505 :: 		if(isCanConect != can.conected){
	MOVF        expendedora_temporizadores_isCanConect_L0+0, 0 
	XORWF       _can+13, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L_expendedora_temporizadores632
;Expendedora.c,510 :: 		isCanConect = can.conected;
	MOVF        _can+13, 0 
	MOVWF       expendedora_temporizadores_isCanConect_L0+0 
;Expendedora.c,511 :: 		}
L_expendedora_temporizadores632:
;Expendedora.c,513 :: 		DS1307_Read(&myRTC,true);
	MOVLW       _myRTC+0
	MOVWF       FARG_DS1307_read_myDS+0 
	MOVLW       hi_addr(_myRTC+0)
	MOVWF       FARG_DS1307_read_myDS+1 
	MOVLW       1
	MOVWF       FARG_DS1307_read_formatComplet+0 
	CALL        _DS1307_read+0, 0
;Expendedora.c,514 :: 		string_cpyn(msjConst, &myRTC.time[2], 8);
	MOVLW       _msjConst+0
	MOVWF       FARG_string_cpyn_destino+0 
	MOVLW       hi_addr(_msjConst+0)
	MOVWF       FARG_string_cpyn_destino+1 
	MOVLW       _myRTC+9
	MOVWF       FARG_string_cpyn_origen+0 
	MOVLW       hi_addr(_myRTC+9)
	MOVWF       FARG_string_cpyn_origen+1 
	MOVLW       8
	MOVWF       FARG_string_cpyn_size+0 
	CALL        _string_cpyn+0, 0
;Expendedora.c,515 :: 		lcd_out(4, 2, msjConst);
	MOVLW       4
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       2
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       _msjConst+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(_msjConst+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;Expendedora.c,516 :: 		string_cpyn(msjConst, &myRTC.time[11], 8);
	MOVLW       _msjConst+0
	MOVWF       FARG_string_cpyn_destino+0 
	MOVLW       hi_addr(_msjConst+0)
	MOVWF       FARG_string_cpyn_destino+1 
	MOVLW       _myRTC+18
	MOVWF       FARG_string_cpyn_origen+0 
	MOVLW       hi_addr(_myRTC+18)
	MOVWF       FARG_string_cpyn_origen+1 
	MOVLW       8
	MOVWF       FARG_string_cpyn_size+0 
	CALL        _string_cpyn+0, 0
;Expendedora.c,517 :: 		lcd_out(4, 12, msjConst);
	MOVLW       4
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       12
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       _msjConst+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(_msjConst+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;Expendedora.c,519 :: 		if(limpiarLCD){
	MOVF        _limpiarLCD+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_expendedora_temporizadores633
;Expendedora.c,520 :: 		if(++tempLCD >= 5){
	INCF        _tempLCD+0, 1 
	MOVLW       5
	SUBWF       _tempLCD+0, 0 
	BTFSS       STATUS+0, 0 
	GOTO        L_expendedora_temporizadores634
;Expendedora.c,521 :: 		limpiarLCD = false;
	CLRF        _limpiarLCD+0 
;Expendedora.c,522 :: 		tempLCD = 0;
	CLRF        _tempLCD+0 
;Expendedora.c,523 :: 		lcd_clean_row(1);
	MOVLW       1
	MOVWF       FARG_lcd_clean_row_fila+0 
	CALL        _lcd_clean_row+0, 0
;Expendedora.c,524 :: 		lcd_clean_row(2);
	MOVLW       2
	MOVWF       FARG_lcd_clean_row_fila+0 
	CALL        _lcd_clean_row+0, 0
;Expendedora.c,525 :: 		lcd_clean_row(3);
	MOVLW       3
	MOVWF       FARG_lcd_clean_row_fila+0 
	CALL        _lcd_clean_row+0, 0
;Expendedora.c,526 :: 		lcd_clean_row(4);
	MOVLW       4
	MOVWF       FARG_lcd_clean_row_fila+0 
	CALL        _lcd_clean_row+0, 0
;Expendedora.c,527 :: 		lcd_out(1, 5, "Expendedora");
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       5
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr3_Expendedora+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr3_Expendedora+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;Expendedora.c,529 :: 		if(BOTON_ENTRADA1)
	BTFSS       PORTD+0, 4 
	GOTO        L_expendedora_temporizadores635
;Expendedora.c,530 :: 		lcd_chr(1,18,'B');
	MOVLW       1
	MOVWF       FARG_Lcd_Chr_row+0 
	MOVLW       18
	MOVWF       FARG_Lcd_Chr_column+0 
	MOVLW       66
	MOVWF       FARG_Lcd_Chr_out_char+0 
	CALL        _Lcd_Chr+0, 0
L_expendedora_temporizadores635:
;Expendedora.c,531 :: 		if(SENSOR_COCHE)
	BTFSS       PORTD+0, 0 
	GOTO        L_expendedora_temporizadores636
;Expendedora.c,532 :: 		lcd_chr(1,20,'C');
	MOVLW       1
	MOVWF       FARG_Lcd_Chr_row+0 
	MOVLW       20
	MOVWF       FARG_Lcd_Chr_column+0 
	MOVLW       67
	MOVWF       FARG_Lcd_Chr_out_char+0 
	CALL        _Lcd_Chr+0, 0
L_expendedora_temporizadores636:
;Expendedora.c,533 :: 		}
L_expendedora_temporizadores634:
;Expendedora.c,534 :: 		}
L_expendedora_temporizadores633:
;Expendedora.c,535 :: 		}
L_expendedora_temporizadores631:
;Expendedora.c,536 :: 		}
L_end_expendedora_temporizadores:
	RETURN      0
; end of _expendedora_temporizadores

_expendedora_checkTarjeta:

;Expendedora.c,538 :: 		void expendedora_checkTarjeta(){
;Expendedora.c,567 :: 		if(wiegand26_read_card(&id)){
	MOVLW       expendedora_checkTarjeta_id_L0+0
	MOVWF       FARG_wiegand26_read_card_id+0 
	MOVLW       hi_addr(expendedora_checkTarjeta_id_L0+0)
	MOVWF       FARG_wiegand26_read_card_id+1 
	CALL        _wiegand26_read_card+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_expendedora_checkTarjeta637
;Expendedora.c,568 :: 		limpiarLCD = true;
	MOVLW       1
	MOVWF       _limpiarLCD+0 
;Expendedora.c,569 :: 		tempLCD = 0;
	CLRF        _tempLCD+0 
;Expendedora.c,570 :: 		if(!buscarID && !buscarNIP)
	MOVF        expendedora_checkTarjeta_buscarID_L0+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_expendedora_checkTarjeta640
	MOVF        expendedora_checkTarjeta_buscarNIP_L0+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_expendedora_checkTarjeta640
L__expendedora_checkTarjeta978:
;Expendedora.c,571 :: 		buscarID = true;
	MOVLW       1
	MOVWF       expendedora_checkTarjeta_buscarID_L0+0 
L_expendedora_checkTarjeta640:
;Expendedora.c,572 :: 		lcd_clean_row(1);
	MOVLW       1
	MOVWF       FARG_lcd_clean_row_fila+0 
	CALL        _lcd_clean_row+0, 0
;Expendedora.c,573 :: 		lcd_out(1, 1, "CARD: ");
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr4_Expendedora+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr4_Expendedora+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;Expendedora.c,574 :: 		longtostr(id, msjConst);
	MOVF        expendedora_checkTarjeta_id_L0+0, 0 
	MOVWF       FARG_LongToStr_input+0 
	MOVF        expendedora_checkTarjeta_id_L0+1, 0 
	MOVWF       FARG_LongToStr_input+1 
	MOVF        expendedora_checkTarjeta_id_L0+2, 0 
	MOVWF       FARG_LongToStr_input+2 
	MOVF        expendedora_checkTarjeta_id_L0+3, 0 
	MOVWF       FARG_LongToStr_input+3 
	MOVLW       _msjConst+0
	MOVWF       FARG_LongToStr_output+0 
	MOVLW       hi_addr(_msjConst+0)
	MOVWF       FARG_LongToStr_output+1 
	CALL        _LongToStr+0, 0
;Expendedora.c,575 :: 		lcd_out(1, sizeof("CARD: "), msjConst);
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       6
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       _msjConst+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(_msjConst+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;Expendedora.c,581 :: 		}else if(wiegand26_read_nip(&nip)){
	GOTO        L_expendedora_checkTarjeta641
L_expendedora_checkTarjeta637:
	MOVLW       expendedora_checkTarjeta_nip_L0+0
	MOVWF       FARG_wiegand26_read_nip_nip+0 
	MOVLW       hi_addr(expendedora_checkTarjeta_nip_L0+0)
	MOVWF       FARG_wiegand26_read_nip_nip+1 
	CALL        _wiegand26_read_nip+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_expendedora_checkTarjeta642
;Expendedora.c,582 :: 		limpiarLCD = true;
	MOVLW       1
	MOVWF       _limpiarLCD+0 
;Expendedora.c,583 :: 		tempLCD = 0;
	CLRF        _tempLCD+0 
;Expendedora.c,584 :: 		if(!buscarID && !buscarNIP)
	MOVF        expendedora_checkTarjeta_buscarID_L0+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_expendedora_checkTarjeta645
	MOVF        expendedora_checkTarjeta_buscarNIP_L0+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_expendedora_checkTarjeta645
L__expendedora_checkTarjeta977:
;Expendedora.c,585 :: 		buscarNIP = true;
	MOVLW       1
	MOVWF       expendedora_checkTarjeta_buscarNIP_L0+0 
L_expendedora_checkTarjeta645:
;Expendedora.c,586 :: 		lcd_clean_row(1);
	MOVLW       1
	MOVWF       FARG_lcd_clean_row_fila+0 
	CALL        _lcd_clean_row+0, 0
;Expendedora.c,587 :: 		lcd_out(1, 1, " NIP: ");
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr5_Expendedora+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr5_Expendedora+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;Expendedora.c,588 :: 		numToString(nip, msjConst, 4);
	MOVF        expendedora_checkTarjeta_nip_L0+0, 0 
	MOVWF       FARG_numToString_valor+0 
	MOVF        expendedora_checkTarjeta_nip_L0+1, 0 
	MOVWF       FARG_numToString_valor+1 
	MOVLW       0
	BTFSC       expendedora_checkTarjeta_nip_L0+1, 7 
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
;Expendedora.c,590 :: 		lcd_out(1, sizeof(" NIP: "), msjConst);
	MOVLW       1
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       6
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       _msjConst+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(_msjConst+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;Expendedora.c,596 :: 		}
L_expendedora_checkTarjeta642:
L_expendedora_checkTarjeta641:
;Expendedora.c,599 :: 		if(buscarID){
	MOVF        expendedora_checkTarjeta_buscarID_L0+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_expendedora_checkTarjeta646
;Expendedora.c,600 :: 		if(!mysql_search(tableSoporte, soporteID, id, &fila)){
	MOVLW       _tableSoporte+0
	MOVWF       FARG_mysql_search_tabla+0 
	MOVLW       hi_addr(_tableSoporte+0)
	MOVWF       FARG_mysql_search_tabla+1 
	MOVLW       _soporteID+0
	MOVWF       FARG_mysql_search_columna+0 
	MOVLW       hi_addr(_soporteID+0)
	MOVWF       FARG_mysql_search_columna+1 
	MOVF        expendedora_checkTarjeta_id_L0+0, 0 
	MOVWF       FARG_mysql_search_buscar+0 
	MOVF        expendedora_checkTarjeta_id_L0+1, 0 
	MOVWF       FARG_mysql_search_buscar+1 
	MOVF        expendedora_checkTarjeta_id_L0+2, 0 
	MOVWF       FARG_mysql_search_buscar+2 
	MOVF        expendedora_checkTarjeta_id_L0+3, 0 
	MOVWF       FARG_mysql_search_buscar+3 
	MOVLW       expendedora_checkTarjeta_fila_L0+0
	MOVWF       FARG_mysql_search_fila+0 
	MOVLW       hi_addr(expendedora_checkTarjeta_fila_L0+0)
	MOVWF       FARG_mysql_search_fila+1 
	CALL        _mysql_search+0, 0
	MOVF        R0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_expendedora_checkTarjeta647
;Expendedora.c,609 :: 		lcd_clean_row(3);
	MOVLW       3
	MOVWF       FARG_lcd_clean_row_fila+0 
	CALL        _lcd_clean_row+0, 0
;Expendedora.c,610 :: 		lcd_out(3,1,"Tarjeta bloqueada");
	MOVLW       3
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr6_Expendedora+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr6_Expendedora+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;Expendedora.c,611 :: 		buscarID = false;
	CLRF        expendedora_checkTarjeta_buscarID_L0+0 
;Expendedora.c,626 :: 		}
L_expendedora_checkTarjeta647:
;Expendedora.c,627 :: 		}
L_expendedora_checkTarjeta646:
;Expendedora.c,630 :: 		if(!SENSOR_COCHE){
	BTFSC       PORTD+0, 0 
	GOTO        L_expendedora_checkTarjeta648
;Expendedora.c,631 :: 		if(buscarNIP || buscarID){
	MOVF        expendedora_checkTarjeta_buscarNIP_L0+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L__expendedora_checkTarjeta976
	MOVF        expendedora_checkTarjeta_buscarID_L0+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L__expendedora_checkTarjeta976
	GOTO        L_expendedora_checkTarjeta651
L__expendedora_checkTarjeta976:
;Expendedora.c,632 :: 		buscarNIP = false;
	CLRF        expendedora_checkTarjeta_buscarNIP_L0+0 
;Expendedora.c,633 :: 		buscarID = false;
	CLRF        expendedora_checkTarjeta_buscarID_L0+0 
;Expendedora.c,634 :: 		lcd_clean_row(3);
	MOVLW       3
	MOVWF       FARG_lcd_clean_row_fila+0 
	CALL        _lcd_clean_row+0, 0
;Expendedora.c,635 :: 		lcd_out(3,1,"No se detecta auto");
	MOVLW       3
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr7_Expendedora+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr7_Expendedora+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;Expendedora.c,636 :: 		}
L_expendedora_checkTarjeta651:
;Expendedora.c,637 :: 		}
L_expendedora_checkTarjeta648:
;Expendedora.c,640 :: 		if(buscarID){
	MOVF        expendedora_checkTarjeta_buscarID_L0+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_expendedora_checkTarjeta652
;Expendedora.c,641 :: 		buscarID = false;
	CLRF        expendedora_checkTarjeta_buscarID_L0+0 
;Expendedora.c,643 :: 		DS1307_read(&myRTC, false);
	MOVLW       _myRTC+0
	MOVWF       FARG_DS1307_read_myDS+0 
	MOVLW       hi_addr(_myRTC+0)
	MOVWF       FARG_DS1307_read_myDS+1 
	CLRF        FARG_DS1307_read_formatComplet+0 
	CALL        _DS1307_read+0, 0
;Expendedora.c,645 :: 		string_cpyc(canCommand, CAN_TPV);
	MOVLW       _canCommand+0
	MOVWF       FARG_string_cpyc_destino+0 
	MOVLW       hi_addr(_canCommand+0)
	MOVWF       FARG_string_cpyc_destino+1 
	MOVLW       _CAN_TPV+0
	MOVWF       FARG_string_cpyc_origen+0 
	MOVLW       hi_addr(_CAN_TPV+0)
	MOVWF       FARG_string_cpyc_origen+1 
	MOVLW       higher_addr(_CAN_TPV+0)
	MOVWF       FARG_string_cpyc_origen+2 
	CALL        _string_cpyc+0, 0
;Expendedora.c,646 :: 		string_addc(canCommand, CAN_IDX);       //IDX
	MOVLW       _canCommand+0
	MOVWF       FARG_string_addc_destino+0 
	MOVLW       hi_addr(_canCommand+0)
	MOVWF       FARG_string_addc_destino+1 
	MOVLW       _CAN_IDX+0
	MOVWF       FARG_string_addc_addEnd+0 
	MOVLW       hi_addr(_CAN_IDX+0)
	MOVWF       FARG_string_addc_addEnd+1 
	MOVLW       higher_addr(_CAN_IDX+0)
	MOVWF       FARG_string_addc_addEnd+2 
	CALL        _string_addc+0, 0
;Expendedora.c,647 :: 		numToHex(id, msjConst, 3);
	MOVF        expendedora_checkTarjeta_id_L0+0, 0 
	MOVWF       FARG_numToHex_valor+0 
	MOVF        expendedora_checkTarjeta_id_L0+1, 0 
	MOVWF       FARG_numToHex_valor+1 
	MOVF        expendedora_checkTarjeta_id_L0+2, 0 
	MOVWF       FARG_numToHex_valor+2 
	MOVF        expendedora_checkTarjeta_id_L0+3, 0 
	MOVWF       FARG_numToHex_valor+3 
	MOVLW       _msjConst+0
	MOVWF       FARG_numToHex_cadena+0 
	MOVLW       hi_addr(_msjConst+0)
	MOVWF       FARG_numToHex_cadena+1 
	MOVLW       3
	MOVWF       FARG_numToHex_bytes+0 
	CALL        _numToHex+0, 0
;Expendedora.c,648 :: 		string_add(canCommand, msjConst);       //IDX + RFID(HEX)
	MOVLW       _canCommand+0
	MOVWF       FARG_string_add_destino+0 
	MOVLW       hi_addr(_canCommand+0)
	MOVWF       FARG_string_add_destino+1 
	MOVLW       _msjConst+0
	MOVWF       FARG_string_add_addEnd+0 
	MOVLW       hi_addr(_msjConst+0)
	MOVWF       FARG_string_add_addEnd+1 
	CALL        _string_add+0, 0
;Expendedora.c,649 :: 		string_add(canCommand, &myRTC.time[1]); //IDX + ID(HEX) + DATE
	MOVLW       _canCommand+0
	MOVWF       FARG_string_add_destino+0 
	MOVLW       hi_addr(_canCommand+0)
	MOVWF       FARG_string_add_destino+1 
	MOVLW       _myRTC+8
	MOVWF       FARG_string_add_addEnd+0 
	MOVLW       hi_addr(_myRTC+8)
	MOVWF       FARG_string_add_addEnd+1 
	CALL        _string_add+0, 0
;Expendedora.c,651 :: 		string_cpyc(acceso, ACCESO_DENEGADO);   //Sin Acceso, Sin vigencia, no passback, desconocida id
	MOVLW       expendedora_checkTarjeta_acceso_L0+0
	MOVWF       FARG_string_cpyc_destino+0 
	MOVLW       hi_addr(expendedora_checkTarjeta_acceso_L0+0)
	MOVWF       FARG_string_cpyc_destino+1 
	MOVLW       expendedora_checkTarjeta_ACCESO_DENEGADO_L0+0
	MOVWF       FARG_string_cpyc_origen+0 
	MOVLW       hi_addr(expendedora_checkTarjeta_ACCESO_DENEGADO_L0+0)
	MOVWF       FARG_string_cpyc_origen+1 
	MOVLW       higher_addr(expendedora_checkTarjeta_ACCESO_DENEGADO_L0+0)
	MOVWF       FARG_string_cpyc_origen+2 
	CALL        _string_cpyc+0, 0
;Expendedora.c,654 :: 		if(!mysql_search(tablePensionados, pensionadosID, id, &fila)){
	MOVLW       _tablePensionados+0
	MOVWF       FARG_mysql_search_tabla+0 
	MOVLW       hi_addr(_tablePensionados+0)
	MOVWF       FARG_mysql_search_tabla+1 
	MOVLW       _pensionadosID+0
	MOVWF       FARG_mysql_search_columna+0 
	MOVLW       hi_addr(_pensionadosID+0)
	MOVWF       FARG_mysql_search_columna+1 
	MOVF        expendedora_checkTarjeta_id_L0+0, 0 
	MOVWF       FARG_mysql_search_buscar+0 
	MOVF        expendedora_checkTarjeta_id_L0+1, 0 
	MOVWF       FARG_mysql_search_buscar+1 
	MOVF        expendedora_checkTarjeta_id_L0+2, 0 
	MOVWF       FARG_mysql_search_buscar+2 
	MOVF        expendedora_checkTarjeta_id_L0+3, 0 
	MOVWF       FARG_mysql_search_buscar+3 
	MOVLW       expendedora_checkTarjeta_fila_L0+0
	MOVWF       FARG_mysql_search_fila+0 
	MOVLW       hi_addr(expendedora_checkTarjeta_fila_L0+0)
	MOVWF       FARG_mysql_search_fila+1 
	CALL        _mysql_search+0, 0
	MOVF        R0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_expendedora_checkTarjeta653
;Expendedora.c,656 :: 		canCommand[3] = CAN_PENSIONADO[0];
	MOVLW       80
	MOVWF       _canCommand+3 
;Expendedora.c,657 :: 		canCommand[4] = CAN_PENSIONADO[1];
	MOVLW       69
	MOVWF       _canCommand+4 
;Expendedora.c,658 :: 		canCommand[5] = CAN_PENSIONADO[2];
	MOVLW       78
	MOVWF       _canCommand+5 
;Expendedora.c,660 :: 		mysql_read_string(tablePensionados, pensionadosVigencia, fila, &vigencia);
	MOVLW       _tablePensionados+0
	MOVWF       FARG_mysql_read_string_name+0 
	MOVLW       hi_addr(_tablePensionados+0)
	MOVWF       FARG_mysql_read_string_name+1 
	MOVLW       _pensionadosVigencia+0
	MOVWF       FARG_mysql_read_string_column+0 
	MOVLW       hi_addr(_pensionadosVigencia+0)
	MOVWF       FARG_mysql_read_string_column+1 
	MOVF        expendedora_checkTarjeta_fila_L0+0, 0 
	MOVWF       FARG_mysql_read_string_fila+0 
	MOVF        expendedora_checkTarjeta_fila_L0+1, 0 
	MOVWF       FARG_mysql_read_string_fila+1 
	MOVLW       expendedora_checkTarjeta_vigencia_L0+0
	MOVWF       FARG_mysql_read_string_result+0 
	MOVLW       hi_addr(expendedora_checkTarjeta_vigencia_L0+0)
	MOVWF       FARG_mysql_read_string_result+1 
	CALL        _mysql_read_string+0, 0
;Expendedora.c,661 :: 		mysql_read_string(tablePensionados, pensionadosEstatus, fila, &estatus);
	MOVLW       _tablePensionados+0
	MOVWF       FARG_mysql_read_string_name+0 
	MOVLW       hi_addr(_tablePensionados+0)
	MOVWF       FARG_mysql_read_string_name+1 
	MOVLW       _pensionadosEstatus+0
	MOVWF       FARG_mysql_read_string_column+0 
	MOVLW       hi_addr(_pensionadosEstatus+0)
	MOVWF       FARG_mysql_read_string_column+1 
	MOVF        expendedora_checkTarjeta_fila_L0+0, 0 
	MOVWF       FARG_mysql_read_string_fila+0 
	MOVF        expendedora_checkTarjeta_fila_L0+1, 0 
	MOVWF       FARG_mysql_read_string_fila+1 
	MOVLW       expendedora_checkTarjeta_estatus_L0+0
	MOVWF       FARG_mysql_read_string_result+0 
	MOVLW       hi_addr(expendedora_checkTarjeta_estatus_L0+0)
	MOVWF       FARG_mysql_read_string_result+1 
	CALL        _mysql_read_string+0, 0
;Expendedora.c,668 :: 		if(vigencia == VIGENTE && (estatus == ESTATUS_PAS || estatus == ESTATUS_BREAK || !canSynchrony || !can.conected)){
	MOVF        expendedora_checkTarjeta_vigencia_L0+0, 0 
	XORLW       86
	BTFSS       STATUS+0, 2 
	GOTO        L_expendedora_checkTarjeta658
	MOVF        expendedora_checkTarjeta_estatus_L0+0, 0 
	XORLW       79
	BTFSC       STATUS+0, 2 
	GOTO        L__expendedora_checkTarjeta975
	MOVF        expendedora_checkTarjeta_estatus_L0+0, 0 
	XORLW       45
	BTFSC       STATUS+0, 2 
	GOTO        L__expendedora_checkTarjeta975
	MOVF        _canSynchrony+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L__expendedora_checkTarjeta975
	MOVF        _can+13, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L__expendedora_checkTarjeta975
	GOTO        L_expendedora_checkTarjeta658
L__expendedora_checkTarjeta975:
L__expendedora_checkTarjeta974:
;Expendedora.c,670 :: 		abrirBarrera = true;
	MOVLW       1
	MOVWF       _abrirBarrera+0 
;Expendedora.c,671 :: 		SALIDA_RELE1 = 1;
	BSF         PORTA+0, 5 
;Expendedora.c,672 :: 		SALIDA_RELE2 = 1;
	BSF         PORTE+0, 0 
;Expendedora.c,673 :: 		timer1_reset();
	CALL        _timer1_reset+0, 0
;Expendedora.c,674 :: 		timer1_enable(true);
	MOVLW       1
	MOVWF       FARG_timer1_enable_enable+0 
	CALL        _timer1_enable+0, 0
;Expendedora.c,675 :: 		acceso[0] = TPV_ACCESO;     //Acceso
	MOVLW       65
	MOVWF       expendedora_checkTarjeta_acceso_L0+0 
;Expendedora.c,677 :: 		if(!can.conected || !canSynchrony || estatus == ESTATUS_BREAK)
	MOVF        _can+13, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L__expendedora_checkTarjeta973
	MOVF        _canSynchrony+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L__expendedora_checkTarjeta973
	MOVF        expendedora_checkTarjeta_estatus_L0+0, 0 
	XORLW       45
	BTFSC       STATUS+0, 2 
	GOTO        L__expendedora_checkTarjeta973
	GOTO        L_expendedora_checkTarjeta661
L__expendedora_checkTarjeta973:
;Expendedora.c,678 :: 		acceso[2] = ESTATUS_BREAK;   //Estado del passback roto
	MOVLW       45
	MOVWF       expendedora_checkTarjeta_acceso_L0+2 
L_expendedora_checkTarjeta661:
;Expendedora.c,680 :: 		estatus = (!can.conected || !canSynchrony)? ESTATUS_BREAK:ESTATUS_MOD;
	MOVF        _can+13, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L__expendedora_checkTarjeta972
	MOVF        _canSynchrony+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L__expendedora_checkTarjeta972
	GOTO        L_expendedora_checkTarjeta664
L__expendedora_checkTarjeta972:
	MOVLW       45
	MOVWF       ?FLOC___expendedora_checkTarjetaT2652+0 
	GOTO        L_expendedora_checkTarjeta665
L_expendedora_checkTarjeta664:
	MOVLW       73
	MOVWF       ?FLOC___expendedora_checkTarjetaT2652+0 
L_expendedora_checkTarjeta665:
	MOVF        ?FLOC___expendedora_checkTarjetaT2652+0, 0 
	MOVWF       expendedora_checkTarjeta_estatus_L0+0 
;Expendedora.c,681 :: 		mysql_write(tablePensionados, pensionadosEstatus, fila, estatus, false);
	MOVLW       _tablePensionados+0
	MOVWF       FARG_mysql_write_name+0 
	MOVLW       hi_addr(_tablePensionados+0)
	MOVWF       FARG_mysql_write_name+1 
	MOVLW       _pensionadosEstatus+0
	MOVWF       FARG_mysql_write_column+0 
	MOVLW       hi_addr(_pensionadosEstatus+0)
	MOVWF       FARG_mysql_write_column+1 
	MOVF        expendedora_checkTarjeta_fila_L0+0, 0 
	MOVWF       FARG_mysql_write_fila+0 
	MOVF        expendedora_checkTarjeta_fila_L0+1, 0 
	MOVWF       FARG_mysql_write_fila+1 
	MOVF        ?FLOC___expendedora_checkTarjetaT2652+0, 0 
	MOVWF       FARG_mysql_write_value+0 
	MOVLW       0
	MOVWF       FARG_mysql_write_value+1 
	MOVWF       FARG_mysql_write_value+2 
	MOVWF       FARG_mysql_write_value+3 
	CLRF        FARG_mysql_write_endWrite+0 
	CALL        _mysql_write+0, 0
;Expendedora.c,682 :: 		lcd_clean_row(2);
	MOVLW       2
	MOVWF       FARG_lcd_clean_row_fila+0 
	CALL        _lcd_clean_row+0, 0
;Expendedora.c,683 :: 		lcd_out(2, 1, "Acceso aceptado");
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr8_Expendedora+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr8_Expendedora+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;Expendedora.c,689 :: 		}else{
	GOTO        L_expendedora_checkTarjeta666
L_expendedora_checkTarjeta658:
;Expendedora.c,690 :: 		if(vigencia == ESTATUS_NOT){
	MOVF        expendedora_checkTarjeta_vigencia_L0+0, 0 
	XORLW       78
	BTFSS       STATUS+0, 2 
	GOTO        L_expendedora_checkTarjeta667
;Expendedora.c,691 :: 		acceso[1] = TPV_NO_VIGENCIA;    //Vigencia
	MOVLW       86
	MOVWF       expendedora_checkTarjeta_acceso_L0+1 
;Expendedora.c,692 :: 		lcd_clean_row(2);
	MOVLW       2
	MOVWF       FARG_lcd_clean_row_fila+0 
	CALL        _lcd_clean_row+0, 0
;Expendedora.c,693 :: 		lcd_out(2, 1, "Vigencia terminada");
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr9_Expendedora+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr9_Expendedora+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;Expendedora.c,697 :: 		}else if(estatus == ESTATUS_MOD){
	GOTO        L_expendedora_checkTarjeta668
L_expendedora_checkTarjeta667:
	MOVF        expendedora_checkTarjeta_estatus_L0+0, 0 
	XORLW       73
	BTFSS       STATUS+0, 2 
	GOTO        L_expendedora_checkTarjeta669
;Expendedora.c,698 :: 		acceso[2] = TPV_PASSBACK;   //Estado del passback
	MOVLW       80
	MOVWF       expendedora_checkTarjeta_acceso_L0+2 
;Expendedora.c,699 :: 		lcd_clean_row(2);
	MOVLW       2
	MOVWF       FARG_lcd_clean_row_fila+0 
	CALL        _lcd_clean_row+0, 0
;Expendedora.c,700 :: 		lcd_out(2,1,"Passback activo");
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr10_Expendedora+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr10_Expendedora+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;Expendedora.c,704 :: 		}
L_expendedora_checkTarjeta669:
L_expendedora_checkTarjeta668:
;Expendedora.c,705 :: 		}
L_expendedora_checkTarjeta666:
;Expendedora.c,707 :: 		string_add(canCommand, acceso);
	MOVLW       _canCommand+0
	MOVWF       FARG_string_add_destino+0 
	MOVLW       hi_addr(_canCommand+0)
	MOVWF       FARG_string_add_destino+1 
	MOVLW       expendedora_checkTarjeta_acceso_L0+0
	MOVWF       FARG_string_add_addEnd+0 
	MOVLW       hi_addr(expendedora_checkTarjeta_acceso_L0+0)
	MOVWF       FARG_string_add_addEnd+1 
	CALL        _string_add+0, 0
;Expendedora.c,709 :: 		string_cpyc(bufferEeprom, CAN_PENSIONADO);
	MOVLW       _bufferEeprom+0
	MOVWF       FARG_string_cpyc_destino+0 
	MOVLW       hi_addr(_bufferEeprom+0)
	MOVWF       FARG_string_cpyc_destino+1 
	MOVLW       _CAN_PENSIONADO+0
	MOVWF       FARG_string_cpyc_origen+0 
	MOVLW       hi_addr(_CAN_PENSIONADO+0)
	MOVWF       FARG_string_cpyc_origen+1 
	MOVLW       higher_addr(_CAN_PENSIONADO+0)
	MOVWF       FARG_string_cpyc_origen+2 
	CALL        _string_cpyc+0, 0
;Expendedora.c,710 :: 		numTohex(id, msjConst, 3);
	MOVF        expendedora_checkTarjeta_id_L0+0, 0 
	MOVWF       FARG_numToHex_valor+0 
	MOVF        expendedora_checkTarjeta_id_L0+1, 0 
	MOVWF       FARG_numToHex_valor+1 
	MOVF        expendedora_checkTarjeta_id_L0+2, 0 
	MOVWF       FARG_numToHex_valor+2 
	MOVF        expendedora_checkTarjeta_id_L0+3, 0 
	MOVWF       FARG_numToHex_valor+3 
	MOVLW       _msjConst+0
	MOVWF       FARG_numToHex_cadena+0 
	MOVLW       hi_addr(_msjConst+0)
	MOVWF       FARG_numToHex_cadena+1 
	MOVLW       3
	MOVWF       FARG_numToHex_bytes+0 
	CALL        _numToHex+0, 0
;Expendedora.c,711 :: 		string_add(bufferEeprom, msjConst);
	MOVLW       _bufferEeprom+0
	MOVWF       FARG_string_add_destino+0 
	MOVLW       hi_addr(_bufferEeprom+0)
	MOVWF       FARG_string_add_destino+1 
	MOVLW       _msjConst+0
	MOVWF       FARG_string_add_addEnd+0 
	MOVLW       hi_addr(_msjConst+0)
	MOVWF       FARG_string_add_addEnd+1 
	CALL        _string_add+0, 0
;Expendedora.c,712 :: 		string_addc(bufferEeprom, CAN_PASSBACK);   //CODIGO DE ACCION
	MOVLW       _bufferEeprom+0
	MOVWF       FARG_string_addc_destino+0 
	MOVLW       hi_addr(_bufferEeprom+0)
	MOVWF       FARG_string_addc_destino+1 
	MOVLW       _CAN_PASSBACK+0
	MOVWF       FARG_string_addc_addEnd+0 
	MOVLW       hi_addr(_CAN_PASSBACK+0)
	MOVWF       FARG_string_addc_addEnd+1 
	MOVLW       higher_addr(_CAN_PASSBACK+0)
	MOVWF       FARG_string_addc_addEnd+2 
	CALL        _string_addc+0, 0
;Expendedora.c,713 :: 		numToString(fila, msjConst, 4);
	MOVF        expendedora_checkTarjeta_fila_L0+0, 0 
	MOVWF       FARG_numToString_valor+0 
	MOVF        expendedora_checkTarjeta_fila_L0+1, 0 
	MOVWF       FARG_numToString_valor+1 
	MOVLW       0
	BTFSC       expendedora_checkTarjeta_fila_L0+1, 7 
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
;Expendedora.c,714 :: 		string_add(bufferEeprom, msjConst);
	MOVLW       _bufferEeprom+0
	MOVWF       FARG_string_add_destino+0 
	MOVLW       hi_addr(_bufferEeprom+0)
	MOVWF       FARG_string_add_destino+1 
	MOVLW       _msjConst+0
	MOVWF       FARG_string_add_addEnd+0 
	MOVLW       hi_addr(_msjConst+0)
	MOVWF       FARG_string_add_addEnd+1 
	CALL        _string_add+0, 0
;Expendedora.c,716 :: 		msjConst[0] = estatus;
	MOVF        expendedora_checkTarjeta_estatus_L0+0, 0 
	MOVWF       _msjConst+0 
;Expendedora.c,717 :: 		msjConst[1] = 0;
	CLRF        _msjConst+1 
;Expendedora.c,718 :: 		string_add(bufferEeprom, msjConst);
	MOVLW       _bufferEeprom+0
	MOVWF       FARG_string_add_destino+0 
	MOVLW       hi_addr(_bufferEeprom+0)
	MOVWF       FARG_string_add_destino+1 
	MOVLW       _msjConst+0
	MOVWF       FARG_string_add_addEnd+0 
	MOVLW       hi_addr(_msjConst+0)
	MOVWF       FARG_string_add_addEnd+1 
	CALL        _string_add+0, 0
;Expendedora.c,720 :: 		buffer_save_send(true, bufferEeprom);
	MOVLW       1
	MOVWF       FARG_buffer_save_send_guardar+0 
	MOVLW       _bufferEeprom+0
	MOVWF       FARG_buffer_save_send_buffer+0 
	MOVLW       hi_addr(_bufferEeprom+0)
	MOVWF       FARG_buffer_save_send_buffer+1 
	CALL        _buffer_save_send+0, 0
;Expendedora.c,721 :: 		}else if(!mysql_search(tablePrepago, pensionadosID, id, &fila)){
	GOTO        L_expendedora_checkTarjeta670
L_expendedora_checkTarjeta653:
	MOVLW       _tablePrepago+0
	MOVWF       FARG_mysql_search_tabla+0 
	MOVLW       hi_addr(_tablePrepago+0)
	MOVWF       FARG_mysql_search_tabla+1 
	MOVLW       _pensionadosID+0
	MOVWF       FARG_mysql_search_columna+0 
	MOVLW       hi_addr(_pensionadosID+0)
	MOVWF       FARG_mysql_search_columna+1 
	MOVF        expendedora_checkTarjeta_id_L0+0, 0 
	MOVWF       FARG_mysql_search_buscar+0 
	MOVF        expendedora_checkTarjeta_id_L0+1, 0 
	MOVWF       FARG_mysql_search_buscar+1 
	MOVF        expendedora_checkTarjeta_id_L0+2, 0 
	MOVWF       FARG_mysql_search_buscar+2 
	MOVF        expendedora_checkTarjeta_id_L0+3, 0 
	MOVWF       FARG_mysql_search_buscar+3 
	MOVLW       expendedora_checkTarjeta_fila_L0+0
	MOVWF       FARG_mysql_search_fila+0 
	MOVLW       hi_addr(expendedora_checkTarjeta_fila_L0+0)
	MOVWF       FARG_mysql_search_fila+1 
	CALL        _mysql_search+0, 0
	MOVF        R0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_expendedora_checkTarjeta671
;Expendedora.c,723 :: 		canCommand[3] = CAN_PREPAGO[0];
	MOVLW       80
	MOVWF       _canCommand+3 
;Expendedora.c,724 :: 		canCommand[4] = CAN_PREPAGO[1];
	MOVLW       82
	MOVWF       _canCommand+4 
;Expendedora.c,725 :: 		canCommand[5] = CAN_PREPAGO[2];
	MOVLW       69
	MOVWF       _canCommand+5 
;Expendedora.c,728 :: 		mysql_read_string(tablePrepago, prepagoEstatus, fila, &estatus);
	MOVLW       _tablePrepago+0
	MOVWF       FARG_mysql_read_string_name+0 
	MOVLW       hi_addr(_tablePrepago+0)
	MOVWF       FARG_mysql_read_string_name+1 
	MOVLW       _prepagoEstatus+0
	MOVWF       FARG_mysql_read_string_column+0 
	MOVLW       hi_addr(_prepagoEstatus+0)
	MOVWF       FARG_mysql_read_string_column+1 
	MOVF        expendedora_checkTarjeta_fila_L0+0, 0 
	MOVWF       FARG_mysql_read_string_fila+0 
	MOVF        expendedora_checkTarjeta_fila_L0+1, 0 
	MOVWF       FARG_mysql_read_string_fila+1 
	MOVLW       expendedora_checkTarjeta_estatus_L0+0
	MOVWF       FARG_mysql_read_string_result+0 
	MOVLW       hi_addr(expendedora_checkTarjeta_estatus_L0+0)
	MOVWF       FARG_mysql_read_string_result+1 
	CALL        _mysql_read_string+0, 0
;Expendedora.c,729 :: 		mysql_read(tablePrepago, prepagoSaldo, fila, &saldo);
	MOVLW       _tablePrepago+0
	MOVWF       FARG_mysql_read_name+0 
	MOVLW       hi_addr(_tablePrepago+0)
	MOVWF       FARG_mysql_read_name+1 
	MOVLW       _prepagoSaldo+0
	MOVWF       FARG_mysql_read_column+0 
	MOVLW       hi_addr(_prepagoSaldo+0)
	MOVWF       FARG_mysql_read_column+1 
	MOVF        expendedora_checkTarjeta_fila_L0+0, 0 
	MOVWF       FARG_mysql_read_fila+0 
	MOVF        expendedora_checkTarjeta_fila_L0+1, 0 
	MOVWF       FARG_mysql_read_fila+1 
	MOVLW       expendedora_checkTarjeta_saldo_L0+0
	MOVWF       FARG_mysql_read_result+0 
	MOVLW       hi_addr(expendedora_checkTarjeta_saldo_L0+0)
	MOVWF       FARG_mysql_read_result+1 
	CALL        _mysql_read+0, 0
;Expendedora.c,730 :: 		if(saldo >= 3600 && (estatus == ESTATUS_PAS || estatus == ESTATUS_BREAK || !canSynchrony || !can.conected)){
	MOVLW       128
	XORWF       expendedora_checkTarjeta_saldo_L0+3, 0 
	MOVWF       R0 
	MOVLW       128
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__expendedora_checkTarjeta1328
	MOVLW       0
	SUBWF       expendedora_checkTarjeta_saldo_L0+2, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__expendedora_checkTarjeta1328
	MOVLW       14
	SUBWF       expendedora_checkTarjeta_saldo_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__expendedora_checkTarjeta1328
	MOVLW       16
	SUBWF       expendedora_checkTarjeta_saldo_L0+0, 0 
L__expendedora_checkTarjeta1328:
	BTFSS       STATUS+0, 0 
	GOTO        L_expendedora_checkTarjeta676
	MOVF        expendedora_checkTarjeta_estatus_L0+0, 0 
	XORLW       79
	BTFSC       STATUS+0, 2 
	GOTO        L__expendedora_checkTarjeta971
	MOVF        expendedora_checkTarjeta_estatus_L0+0, 0 
	XORLW       45
	BTFSC       STATUS+0, 2 
	GOTO        L__expendedora_checkTarjeta971
	MOVF        _canSynchrony+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L__expendedora_checkTarjeta971
	MOVF        _can+13, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L__expendedora_checkTarjeta971
	GOTO        L_expendedora_checkTarjeta676
L__expendedora_checkTarjeta971:
L__expendedora_checkTarjeta970:
;Expendedora.c,732 :: 		abrirBarrera = true;
	MOVLW       1
	MOVWF       _abrirBarrera+0 
;Expendedora.c,733 :: 		SALIDA_RELE1 = 1;
	BSF         PORTA+0, 5 
;Expendedora.c,734 :: 		SALIDA_RELE2 = 1;
	BSF         PORTE+0, 0 
;Expendedora.c,735 :: 		timer1_reset();
	CALL        _timer1_reset+0, 0
;Expendedora.c,736 :: 		timer1_enable(true);
	MOVLW       1
	MOVWF       FARG_timer1_enable_enable+0 
	CALL        _timer1_enable+0, 0
;Expendedora.c,737 :: 		acceso[0] = TPV_ACCESO;     //Acceso
	MOVLW       65
	MOVWF       expendedora_checkTarjeta_acceso_L0+0 
;Expendedora.c,739 :: 		if(!can.conected || !canSynchrony || estatus == ESTATUS_BREAK)
	MOVF        _can+13, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L__expendedora_checkTarjeta969
	MOVF        _canSynchrony+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L__expendedora_checkTarjeta969
	MOVF        expendedora_checkTarjeta_estatus_L0+0, 0 
	XORLW       45
	BTFSC       STATUS+0, 2 
	GOTO        L__expendedora_checkTarjeta969
	GOTO        L_expendedora_checkTarjeta679
L__expendedora_checkTarjeta969:
;Expendedora.c,740 :: 		acceso[2] = ESTATUS_BREAK;   //Estado del passback roto
	MOVLW       45
	MOVWF       expendedora_checkTarjeta_acceso_L0+2 
L_expendedora_checkTarjeta679:
;Expendedora.c,742 :: 		estatus = (!can.conected || !canSynchrony)? ESTATUS_BREAK:ESTATUS_MOD;
	MOVF        _can+13, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L__expendedora_checkTarjeta968
	MOVF        _canSynchrony+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L__expendedora_checkTarjeta968
	GOTO        L_expendedora_checkTarjeta682
L__expendedora_checkTarjeta968:
	MOVLW       45
	MOVWF       ?FLOC___expendedora_checkTarjetaT2711+0 
	GOTO        L_expendedora_checkTarjeta683
L_expendedora_checkTarjeta682:
	MOVLW       73
	MOVWF       ?FLOC___expendedora_checkTarjetaT2711+0 
L_expendedora_checkTarjeta683:
	MOVF        ?FLOC___expendedora_checkTarjetaT2711+0, 0 
	MOVWF       expendedora_checkTarjeta_estatus_L0+0 
;Expendedora.c,743 :: 		mysql_write(tablePrepago, prepagoEstatus, fila, estatus, false);
	MOVLW       _tablePrepago+0
	MOVWF       FARG_mysql_write_name+0 
	MOVLW       hi_addr(_tablePrepago+0)
	MOVWF       FARG_mysql_write_name+1 
	MOVLW       _prepagoEstatus+0
	MOVWF       FARG_mysql_write_column+0 
	MOVLW       hi_addr(_prepagoEstatus+0)
	MOVWF       FARG_mysql_write_column+1 
	MOVF        expendedora_checkTarjeta_fila_L0+0, 0 
	MOVWF       FARG_mysql_write_fila+0 
	MOVF        expendedora_checkTarjeta_fila_L0+1, 0 
	MOVWF       FARG_mysql_write_fila+1 
	MOVF        ?FLOC___expendedora_checkTarjetaT2711+0, 0 
	MOVWF       FARG_mysql_write_value+0 
	MOVLW       0
	MOVWF       FARG_mysql_write_value+1 
	MOVWF       FARG_mysql_write_value+2 
	MOVWF       FARG_mysql_write_value+3 
	CLRF        FARG_mysql_write_endWrite+0 
	CALL        _mysql_write+0, 0
;Expendedora.c,744 :: 		lcd_clean_row(2);
	MOVLW       2
	MOVWF       FARG_lcd_clean_row_fila+0 
	CALL        _lcd_clean_row+0, 0
;Expendedora.c,745 :: 		lcd_out(2,1,"Acceso aceptado");
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr11_Expendedora+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr11_Expendedora+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;Expendedora.c,751 :: 		}else{
	GOTO        L_expendedora_checkTarjeta684
L_expendedora_checkTarjeta676:
;Expendedora.c,752 :: 		if(saldo < 3600){
	MOVLW       128
	XORWF       expendedora_checkTarjeta_saldo_L0+3, 0 
	MOVWF       R0 
	MOVLW       128
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__expendedora_checkTarjeta1329
	MOVLW       0
	SUBWF       expendedora_checkTarjeta_saldo_L0+2, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__expendedora_checkTarjeta1329
	MOVLW       14
	SUBWF       expendedora_checkTarjeta_saldo_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__expendedora_checkTarjeta1329
	MOVLW       16
	SUBWF       expendedora_checkTarjeta_saldo_L0+0, 0 
L__expendedora_checkTarjeta1329:
	BTFSC       STATUS+0, 0 
	GOTO        L_expendedora_checkTarjeta685
;Expendedora.c,753 :: 		acceso[1] = TPV_SIN_SALDO;  //Sin saldo
	MOVLW       83
	MOVWF       expendedora_checkTarjeta_acceso_L0+1 
;Expendedora.c,754 :: 		lcd_clean_row(2);
	MOVLW       2
	MOVWF       FARG_lcd_clean_row_fila+0 
	CALL        _lcd_clean_row+0, 0
;Expendedora.c,755 :: 		lcd_out(2,1,"Saldo terminado");
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr12_Expendedora+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr12_Expendedora+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;Expendedora.c,759 :: 		}else if(estatus == ESTATUS_MOD){
	GOTO        L_expendedora_checkTarjeta686
L_expendedora_checkTarjeta685:
	MOVF        expendedora_checkTarjeta_estatus_L0+0, 0 
	XORLW       73
	BTFSS       STATUS+0, 2 
	GOTO        L_expendedora_checkTarjeta687
;Expendedora.c,760 :: 		acceso[2] = TPV_PASSBACK;   //Estado del passback
	MOVLW       80
	MOVWF       expendedora_checkTarjeta_acceso_L0+2 
;Expendedora.c,761 :: 		lcd_clean_row(2);
	MOVLW       2
	MOVWF       FARG_lcd_clean_row_fila+0 
	CALL        _lcd_clean_row+0, 0
;Expendedora.c,762 :: 		lcd_out(2,1,"Passback activo");
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr13_Expendedora+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr13_Expendedora+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;Expendedora.c,766 :: 		}
L_expendedora_checkTarjeta687:
L_expendedora_checkTarjeta686:
;Expendedora.c,767 :: 		}
L_expendedora_checkTarjeta684:
;Expendedora.c,769 :: 		string_add(canCommand, acceso);
	MOVLW       _canCommand+0
	MOVWF       FARG_string_add_destino+0 
	MOVLW       hi_addr(_canCommand+0)
	MOVWF       FARG_string_add_destino+1 
	MOVLW       expendedora_checkTarjeta_acceso_L0+0
	MOVWF       FARG_string_add_addEnd+0 
	MOVLW       hi_addr(expendedora_checkTarjeta_acceso_L0+0)
	MOVWF       FARG_string_add_addEnd+1 
	CALL        _string_add+0, 0
;Expendedora.c,771 :: 		string_cpyc(bufferEeprom, CAN_PREPAGO);
	MOVLW       _bufferEeprom+0
	MOVWF       FARG_string_cpyc_destino+0 
	MOVLW       hi_addr(_bufferEeprom+0)
	MOVWF       FARG_string_cpyc_destino+1 
	MOVLW       _CAN_PREPAGO+0
	MOVWF       FARG_string_cpyc_origen+0 
	MOVLW       hi_addr(_CAN_PREPAGO+0)
	MOVWF       FARG_string_cpyc_origen+1 
	MOVLW       higher_addr(_CAN_PREPAGO+0)
	MOVWF       FARG_string_cpyc_origen+2 
	CALL        _string_cpyc+0, 0
;Expendedora.c,772 :: 		numTohex(id, msjConst, 3);
	MOVF        expendedora_checkTarjeta_id_L0+0, 0 
	MOVWF       FARG_numToHex_valor+0 
	MOVF        expendedora_checkTarjeta_id_L0+1, 0 
	MOVWF       FARG_numToHex_valor+1 
	MOVF        expendedora_checkTarjeta_id_L0+2, 0 
	MOVWF       FARG_numToHex_valor+2 
	MOVF        expendedora_checkTarjeta_id_L0+3, 0 
	MOVWF       FARG_numToHex_valor+3 
	MOVLW       _msjConst+0
	MOVWF       FARG_numToHex_cadena+0 
	MOVLW       hi_addr(_msjConst+0)
	MOVWF       FARG_numToHex_cadena+1 
	MOVLW       3
	MOVWF       FARG_numToHex_bytes+0 
	CALL        _numToHex+0, 0
;Expendedora.c,773 :: 		string_add(bufferEeprom, msjConst);
	MOVLW       _bufferEeprom+0
	MOVWF       FARG_string_add_destino+0 
	MOVLW       hi_addr(_bufferEeprom+0)
	MOVWF       FARG_string_add_destino+1 
	MOVLW       _msjConst+0
	MOVWF       FARG_string_add_addEnd+0 
	MOVLW       hi_addr(_msjConst+0)
	MOVWF       FARG_string_add_addEnd+1 
	CALL        _string_add+0, 0
;Expendedora.c,774 :: 		if(acceso[0] == TPV_ACCESO)
	MOVF        expendedora_checkTarjeta_acceso_L0+0, 0 
	XORLW       65
	BTFSS       STATUS+0, 2 
	GOTO        L_expendedora_checkTarjeta688
;Expendedora.c,775 :: 		string_addc(bufferEeprom, CAN_SPECIAL_DATE);   //CODIGO DE ACCION
	MOVLW       _bufferEeprom+0
	MOVWF       FARG_string_addc_destino+0 
	MOVLW       hi_addr(_bufferEeprom+0)
	MOVWF       FARG_string_addc_destino+1 
	MOVLW       _CAN_SPECIAL_DATE+0
	MOVWF       FARG_string_addc_addEnd+0 
	MOVLW       hi_addr(_CAN_SPECIAL_DATE+0)
	MOVWF       FARG_string_addc_addEnd+1 
	MOVLW       higher_addr(_CAN_SPECIAL_DATE+0)
	MOVWF       FARG_string_addc_addEnd+2 
	CALL        _string_addc+0, 0
	GOTO        L_expendedora_checkTarjeta689
L_expendedora_checkTarjeta688:
;Expendedora.c,777 :: 		string_addc(bufferEeprom, CAN_PASSBACK);
	MOVLW       _bufferEeprom+0
	MOVWF       FARG_string_addc_destino+0 
	MOVLW       hi_addr(_bufferEeprom+0)
	MOVWF       FARG_string_addc_destino+1 
	MOVLW       _CAN_PASSBACK+0
	MOVWF       FARG_string_addc_addEnd+0 
	MOVLW       hi_addr(_CAN_PASSBACK+0)
	MOVWF       FARG_string_addc_addEnd+1 
	MOVLW       higher_addr(_CAN_PASSBACK+0)
	MOVWF       FARG_string_addc_addEnd+2 
	CALL        _string_addc+0, 0
L_expendedora_checkTarjeta689:
;Expendedora.c,778 :: 		numToString(fila, msjConst, 4);
	MOVF        expendedora_checkTarjeta_fila_L0+0, 0 
	MOVWF       FARG_numToString_valor+0 
	MOVF        expendedora_checkTarjeta_fila_L0+1, 0 
	MOVWF       FARG_numToString_valor+1 
	MOVLW       0
	BTFSC       expendedora_checkTarjeta_fila_L0+1, 7 
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
;Expendedora.c,779 :: 		string_add(bufferEeprom, msjConst);
	MOVLW       _bufferEeprom+0
	MOVWF       FARG_string_add_destino+0 
	MOVLW       hi_addr(_bufferEeprom+0)
	MOVWF       FARG_string_add_destino+1 
	MOVLW       _msjConst+0
	MOVWF       FARG_string_add_addEnd+0 
	MOVLW       hi_addr(_msjConst+0)
	MOVWF       FARG_string_add_addEnd+1 
	CALL        _string_add+0, 0
;Expendedora.c,781 :: 		msjConst[0] = estatus;
	MOVF        expendedora_checkTarjeta_estatus_L0+0, 0 
	MOVWF       _msjConst+0 
;Expendedora.c,782 :: 		msjConst[1] = 0;
	CLRF        _msjConst+1 
;Expendedora.c,783 :: 		string_add(bufferEeprom, msjConst);
	MOVLW       _bufferEeprom+0
	MOVWF       FARG_string_add_destino+0 
	MOVLW       hi_addr(_bufferEeprom+0)
	MOVWF       FARG_string_add_destino+1 
	MOVLW       _msjConst+0
	MOVWF       FARG_string_add_addEnd+0 
	MOVLW       hi_addr(_msjConst+0)
	MOVWF       FARG_string_add_addEnd+1 
	CALL        _string_add+0, 0
;Expendedora.c,785 :: 		DS1307_read(&myRTC, false);
	MOVLW       _myRTC+0
	MOVWF       FARG_DS1307_read_myDS+0 
	MOVLW       hi_addr(_myRTC+0)
	MOVWF       FARG_DS1307_read_myDS+1 
	CLRF        FARG_DS1307_read_formatComplet+0 
	CALL        _DS1307_read+0, 0
;Expendedora.c,786 :: 		string_add(bufferEeprom, &myRTC.time[1]);
	MOVLW       _bufferEeprom+0
	MOVWF       FARG_string_add_destino+0 
	MOVLW       hi_addr(_bufferEeprom+0)
	MOVWF       FARG_string_add_destino+1 
	MOVLW       _myRTC+8
	MOVWF       FARG_string_add_addEnd+0 
	MOVLW       hi_addr(_myRTC+8)
	MOVWF       FARG_string_add_addEnd+1 
	CALL        _string_add+0, 0
;Expendedora.c,788 :: 		buffer_save_send(true, bufferEeprom);
	MOVLW       1
	MOVWF       FARG_buffer_save_send_guardar+0 
	MOVLW       _bufferEeprom+0
	MOVWF       FARG_buffer_save_send_buffer+0 
	MOVLW       hi_addr(_bufferEeprom+0)
	MOVWF       FARG_buffer_save_send_buffer+1 
	CALL        _buffer_save_send+0, 0
;Expendedora.c,789 :: 		}else{
	GOTO        L_expendedora_checkTarjeta690
L_expendedora_checkTarjeta671:
;Expendedora.c,790 :: 		lcd_clean_row(2);
	MOVLW       2
	MOVWF       FARG_lcd_clean_row_fila+0 
	CALL        _lcd_clean_row+0, 0
;Expendedora.c,791 :: 		lcd_out(2,1,"Tarjeta desconocida");
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr14_Expendedora+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr14_Expendedora+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;Expendedora.c,796 :: 		acceso[3] = TPV_DESCONOCIDO;      //Tarjeta desconocida
	MOVLW       68
	MOVWF       expendedora_checkTarjeta_acceso_L0+3 
;Expendedora.c,797 :: 		string_add(canCommand, acceso);
	MOVLW       _canCommand+0
	MOVWF       FARG_string_add_destino+0 
	MOVLW       hi_addr(_canCommand+0)
	MOVWF       FARG_string_add_destino+1 
	MOVLW       expendedora_checkTarjeta_acceso_L0+0
	MOVWF       FARG_string_add_addEnd+0 
	MOVLW       hi_addr(expendedora_checkTarjeta_acceso_L0+0)
	MOVWF       FARG_string_add_addEnd+1 
	CALL        _string_add+0, 0
;Expendedora.c,798 :: 		}
L_expendedora_checkTarjeta690:
L_expendedora_checkTarjeta670:
;Expendedora.c,800 :: 		string_addc(canCommand, CAN_MODULE);
	MOVLW       _canCommand+0
	MOVWF       FARG_string_addc_destino+0 
	MOVLW       hi_addr(_canCommand+0)
	MOVWF       FARG_string_addc_destino+1 
	MOVLW       _CAN_MODULE+0
	MOVWF       FARG_string_addc_addEnd+0 
	MOVLW       hi_addr(_CAN_MODULE+0)
	MOVWF       FARG_string_addc_addEnd+1 
	MOVLW       higher_addr(_CAN_MODULE+0)
	MOVWF       FARG_string_addc_addEnd+2 
	CALL        _string_addc+0, 0
;Expendedora.c,801 :: 		numToHex(canId, msjConst, 1);
	MOVF        _canId+0, 0 
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
;Expendedora.c,802 :: 		string_add(canCommand, msjConst);
	MOVLW       _canCommand+0
	MOVWF       FARG_string_add_destino+0 
	MOVLW       hi_addr(_canCommand+0)
	MOVWF       FARG_string_add_destino+1 
	MOVLW       _msjConst+0
	MOVWF       FARG_string_add_addEnd+0 
	MOVLW       hi_addr(_msjConst+0)
	MOVWF       FARG_string_add_addEnd+1 
	CALL        _string_add+0, 0
;Expendedora.c,803 :: 		buffer_save_send(false, canCommand);
	CLRF        FARG_buffer_save_send_guardar+0 
	MOVLW       _canCommand+0
	MOVWF       FARG_buffer_save_send_buffer+0 
	MOVLW       hi_addr(_canCommand+0)
	MOVWF       FARG_buffer_save_send_buffer+1 
	CALL        _buffer_save_send+0, 0
;Expendedora.c,804 :: 		}else if(buscarNIP){
	GOTO        L_expendedora_checkTarjeta691
L_expendedora_checkTarjeta652:
	MOVF        expendedora_checkTarjeta_buscarNIP_L0+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_expendedora_checkTarjeta692
;Expendedora.c,805 :: 		buscarNIP = false;
	CLRF        expendedora_checkTarjeta_buscarNIP_L0+0 
;Expendedora.c,807 :: 		DS1307_read(&myRTC, false);
	MOVLW       _myRTC+0
	MOVWF       FARG_DS1307_read_myDS+0 
	MOVLW       hi_addr(_myRTC+0)
	MOVWF       FARG_DS1307_read_myDS+1 
	CLRF        FARG_DS1307_read_formatComplet+0 
	CALL        _DS1307_read+0, 0
;Expendedora.c,809 :: 		string_cpyc(canCommand, CAN_TPV);
	MOVLW       _canCommand+0
	MOVWF       FARG_string_cpyc_destino+0 
	MOVLW       hi_addr(_canCommand+0)
	MOVWF       FARG_string_cpyc_destino+1 
	MOVLW       _CAN_TPV+0
	MOVWF       FARG_string_cpyc_origen+0 
	MOVLW       hi_addr(_CAN_TPV+0)
	MOVWF       FARG_string_cpyc_origen+1 
	MOVLW       higher_addr(_CAN_TPV+0)
	MOVWF       FARG_string_cpyc_origen+2 
	CALL        _string_cpyc+0, 0
;Expendedora.c,810 :: 		string_addc(canCommand, CAN_NIP);       //NIP
	MOVLW       _canCommand+0
	MOVWF       FARG_string_addc_destino+0 
	MOVLW       hi_addr(_canCommand+0)
	MOVWF       FARG_string_addc_destino+1 
	MOVLW       _CAN_NIP+0
	MOVWF       FARG_string_addc_addEnd+0 
	MOVLW       hi_addr(_CAN_NIP+0)
	MOVWF       FARG_string_addc_addEnd+1 
	MOVLW       higher_addr(_CAN_NIP+0)
	MOVWF       FARG_string_addc_addEnd+2 
	CALL        _string_addc+0, 0
;Expendedora.c,811 :: 		numToString(nip, msjConst, 4);
	MOVF        expendedora_checkTarjeta_nip_L0+0, 0 
	MOVWF       FARG_numToString_valor+0 
	MOVF        expendedora_checkTarjeta_nip_L0+1, 0 
	MOVWF       FARG_numToString_valor+1 
	MOVLW       0
	BTFSC       expendedora_checkTarjeta_nip_L0+1, 7 
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
;Expendedora.c,812 :: 		string_add(canCommand, msjConst);       //NIP + NIP(DEC)
	MOVLW       _canCommand+0
	MOVWF       FARG_string_add_destino+0 
	MOVLW       hi_addr(_canCommand+0)
	MOVWF       FARG_string_add_destino+1 
	MOVLW       _msjConst+0
	MOVWF       FARG_string_add_addEnd+0 
	MOVLW       hi_addr(_msjConst+0)
	MOVWF       FARG_string_add_addEnd+1 
	CALL        _string_add+0, 0
;Expendedora.c,813 :: 		string_add(canCommand, &myRTC.time[1]); //NIP + NIP(DEC) + DATE
	MOVLW       _canCommand+0
	MOVWF       FARG_string_add_destino+0 
	MOVLW       hi_addr(_canCommand+0)
	MOVWF       FARG_string_add_destino+1 
	MOVLW       _myRTC+8
	MOVWF       FARG_string_add_addEnd+0 
	MOVLW       hi_addr(_myRTC+8)
	MOVWF       FARG_string_add_addEnd+1 
	CALL        _string_add+0, 0
;Expendedora.c,815 :: 		string_cpyc(acceso, ACCESO_DENEGADO);   //sin acceso, sin Saldo, sin passback, desconocida nip
	MOVLW       expendedora_checkTarjeta_acceso_L0+0
	MOVWF       FARG_string_cpyc_destino+0 
	MOVLW       hi_addr(expendedora_checkTarjeta_acceso_L0+0)
	MOVWF       FARG_string_cpyc_destino+1 
	MOVLW       expendedora_checkTarjeta_ACCESO_DENEGADO_L0+0
	MOVWF       FARG_string_cpyc_origen+0 
	MOVLW       hi_addr(expendedora_checkTarjeta_ACCESO_DENEGADO_L0+0)
	MOVWF       FARG_string_cpyc_origen+1 
	MOVLW       higher_addr(expendedora_checkTarjeta_ACCESO_DENEGADO_L0+0)
	MOVWF       FARG_string_cpyc_origen+2 
	CALL        _string_cpyc+0, 0
;Expendedora.c,818 :: 		if(!mysql_search(tablePrepago, prepagoNip, nip, &fila)){
	MOVLW       _tablePrepago+0
	MOVWF       FARG_mysql_search_tabla+0 
	MOVLW       hi_addr(_tablePrepago+0)
	MOVWF       FARG_mysql_search_tabla+1 
	MOVLW       _prepagoNip+0
	MOVWF       FARG_mysql_search_columna+0 
	MOVLW       hi_addr(_prepagoNip+0)
	MOVWF       FARG_mysql_search_columna+1 
	MOVF        expendedora_checkTarjeta_nip_L0+0, 0 
	MOVWF       FARG_mysql_search_buscar+0 
	MOVF        expendedora_checkTarjeta_nip_L0+1, 0 
	MOVWF       FARG_mysql_search_buscar+1 
	MOVLW       0
	BTFSC       expendedora_checkTarjeta_nip_L0+1, 7 
	MOVLW       255
	MOVWF       FARG_mysql_search_buscar+2 
	MOVWF       FARG_mysql_search_buscar+3 
	MOVLW       expendedora_checkTarjeta_fila_L0+0
	MOVWF       FARG_mysql_search_fila+0 
	MOVLW       hi_addr(expendedora_checkTarjeta_fila_L0+0)
	MOVWF       FARG_mysql_search_fila+1 
	CALL        _mysql_search+0, 0
	MOVF        R0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_expendedora_checkTarjeta693
;Expendedora.c,820 :: 		mysql_read_string(tablePrepago, prepagoEstatus, fila, &estatus);
	MOVLW       _tablePrepago+0
	MOVWF       FARG_mysql_read_string_name+0 
	MOVLW       hi_addr(_tablePrepago+0)
	MOVWF       FARG_mysql_read_string_name+1 
	MOVLW       _prepagoEstatus+0
	MOVWF       FARG_mysql_read_string_column+0 
	MOVLW       hi_addr(_prepagoEstatus+0)
	MOVWF       FARG_mysql_read_string_column+1 
	MOVF        expendedora_checkTarjeta_fila_L0+0, 0 
	MOVWF       FARG_mysql_read_string_fila+0 
	MOVF        expendedora_checkTarjeta_fila_L0+1, 0 
	MOVWF       FARG_mysql_read_string_fila+1 
	MOVLW       expendedora_checkTarjeta_estatus_L0+0
	MOVWF       FARG_mysql_read_string_result+0 
	MOVLW       hi_addr(expendedora_checkTarjeta_estatus_L0+0)
	MOVWF       FARG_mysql_read_string_result+1 
	CALL        _mysql_read_string+0, 0
;Expendedora.c,821 :: 		mysql_read(tablePrepago, prepagoSaldo, fila, &saldo);
	MOVLW       _tablePrepago+0
	MOVWF       FARG_mysql_read_name+0 
	MOVLW       hi_addr(_tablePrepago+0)
	MOVWF       FARG_mysql_read_name+1 
	MOVLW       _prepagoSaldo+0
	MOVWF       FARG_mysql_read_column+0 
	MOVLW       hi_addr(_prepagoSaldo+0)
	MOVWF       FARG_mysql_read_column+1 
	MOVF        expendedora_checkTarjeta_fila_L0+0, 0 
	MOVWF       FARG_mysql_read_fila+0 
	MOVF        expendedora_checkTarjeta_fila_L0+1, 0 
	MOVWF       FARG_mysql_read_fila+1 
	MOVLW       expendedora_checkTarjeta_saldo_L0+0
	MOVWF       FARG_mysql_read_result+0 
	MOVLW       hi_addr(expendedora_checkTarjeta_saldo_L0+0)
	MOVWF       FARG_mysql_read_result+1 
	CALL        _mysql_read+0, 0
;Expendedora.c,822 :: 		mysql_read(tablePrepago, prepagoID, fila, &id);
	MOVLW       _tablePrepago+0
	MOVWF       FARG_mysql_read_name+0 
	MOVLW       hi_addr(_tablePrepago+0)
	MOVWF       FARG_mysql_read_name+1 
	MOVLW       _prepagoId+0
	MOVWF       FARG_mysql_read_column+0 
	MOVLW       hi_addr(_prepagoId+0)
	MOVWF       FARG_mysql_read_column+1 
	MOVF        expendedora_checkTarjeta_fila_L0+0, 0 
	MOVWF       FARG_mysql_read_fila+0 
	MOVF        expendedora_checkTarjeta_fila_L0+1, 0 
	MOVWF       FARG_mysql_read_fila+1 
	MOVLW       expendedora_checkTarjeta_id_L0+0
	MOVWF       FARG_mysql_read_result+0 
	MOVLW       hi_addr(expendedora_checkTarjeta_id_L0+0)
	MOVWF       FARG_mysql_read_result+1 
	CALL        _mysql_read+0, 0
;Expendedora.c,824 :: 		if(saldo >= 3600 && (estatus == ESTATUS_PAS || estatus == ESTATUS_BREAK || !canSynchrony || !can.conected)){
	MOVLW       128
	XORWF       expendedora_checkTarjeta_saldo_L0+3, 0 
	MOVWF       R0 
	MOVLW       128
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__expendedora_checkTarjeta1330
	MOVLW       0
	SUBWF       expendedora_checkTarjeta_saldo_L0+2, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__expendedora_checkTarjeta1330
	MOVLW       14
	SUBWF       expendedora_checkTarjeta_saldo_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__expendedora_checkTarjeta1330
	MOVLW       16
	SUBWF       expendedora_checkTarjeta_saldo_L0+0, 0 
L__expendedora_checkTarjeta1330:
	BTFSS       STATUS+0, 0 
	GOTO        L_expendedora_checkTarjeta698
	MOVF        expendedora_checkTarjeta_estatus_L0+0, 0 
	XORLW       79
	BTFSC       STATUS+0, 2 
	GOTO        L__expendedora_checkTarjeta967
	MOVF        expendedora_checkTarjeta_estatus_L0+0, 0 
	XORLW       45
	BTFSC       STATUS+0, 2 
	GOTO        L__expendedora_checkTarjeta967
	MOVF        _canSynchrony+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L__expendedora_checkTarjeta967
	MOVF        _can+13, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L__expendedora_checkTarjeta967
	GOTO        L_expendedora_checkTarjeta698
L__expendedora_checkTarjeta967:
L__expendedora_checkTarjeta966:
;Expendedora.c,826 :: 		abrirBarrera = true;
	MOVLW       1
	MOVWF       _abrirBarrera+0 
;Expendedora.c,827 :: 		SALIDA_RELE1 = 1;
	BSF         PORTA+0, 5 
;Expendedora.c,828 :: 		SALIDA_RELE2 = 1;
	BSF         PORTE+0, 0 
;Expendedora.c,829 :: 		timer1_reset();
	CALL        _timer1_reset+0, 0
;Expendedora.c,830 :: 		timer1_enable(true);
	MOVLW       1
	MOVWF       FARG_timer1_enable_enable+0 
	CALL        _timer1_enable+0, 0
;Expendedora.c,832 :: 		acceso[0] = TPV_ACCESO;    //Acceso
	MOVLW       65
	MOVWF       expendedora_checkTarjeta_acceso_L0+0 
;Expendedora.c,834 :: 		if(!can.conected || !canSynchrony || estatus == ESTATUS_BREAK)
	MOVF        _can+13, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L__expendedora_checkTarjeta965
	MOVF        _canSynchrony+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L__expendedora_checkTarjeta965
	MOVF        expendedora_checkTarjeta_estatus_L0+0, 0 
	XORLW       45
	BTFSC       STATUS+0, 2 
	GOTO        L__expendedora_checkTarjeta965
	GOTO        L_expendedora_checkTarjeta701
L__expendedora_checkTarjeta965:
;Expendedora.c,835 :: 		acceso[2] = ESTATUS_BREAK;   //Estado del passback roto
	MOVLW       45
	MOVWF       expendedora_checkTarjeta_acceso_L0+2 
L_expendedora_checkTarjeta701:
;Expendedora.c,837 :: 		estatus = (!can.conected || !canSynchrony)? ESTATUS_BREAK:ESTATUS_MOD;
	MOVF        _can+13, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L__expendedora_checkTarjeta964
	MOVF        _canSynchrony+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L__expendedora_checkTarjeta964
	GOTO        L_expendedora_checkTarjeta704
L__expendedora_checkTarjeta964:
	MOVLW       45
	MOVWF       ?FLOC___expendedora_checkTarjetaT2798+0 
	GOTO        L_expendedora_checkTarjeta705
L_expendedora_checkTarjeta704:
	MOVLW       73
	MOVWF       ?FLOC___expendedora_checkTarjetaT2798+0 
L_expendedora_checkTarjeta705:
	MOVF        ?FLOC___expendedora_checkTarjetaT2798+0, 0 
	MOVWF       expendedora_checkTarjeta_estatus_L0+0 
;Expendedora.c,838 :: 		mysql_write(tablePrepago, prepagoEstatus, fila, estatus, false);
	MOVLW       _tablePrepago+0
	MOVWF       FARG_mysql_write_name+0 
	MOVLW       hi_addr(_tablePrepago+0)
	MOVWF       FARG_mysql_write_name+1 
	MOVLW       _prepagoEstatus+0
	MOVWF       FARG_mysql_write_column+0 
	MOVLW       hi_addr(_prepagoEstatus+0)
	MOVWF       FARG_mysql_write_column+1 
	MOVF        expendedora_checkTarjeta_fila_L0+0, 0 
	MOVWF       FARG_mysql_write_fila+0 
	MOVF        expendedora_checkTarjeta_fila_L0+1, 0 
	MOVWF       FARG_mysql_write_fila+1 
	MOVF        ?FLOC___expendedora_checkTarjetaT2798+0, 0 
	MOVWF       FARG_mysql_write_value+0 
	MOVLW       0
	MOVWF       FARG_mysql_write_value+1 
	MOVWF       FARG_mysql_write_value+2 
	MOVWF       FARG_mysql_write_value+3 
	CLRF        FARG_mysql_write_endWrite+0 
	CALL        _mysql_write+0, 0
;Expendedora.c,839 :: 		lcd_clean_row(2);
	MOVLW       2
	MOVWF       FARG_lcd_clean_row_fila+0 
	CALL        _lcd_clean_row+0, 0
;Expendedora.c,840 :: 		lcd_out(2,1,"Acceso aceptado");
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr15_Expendedora+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr15_Expendedora+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;Expendedora.c,846 :: 		}else{
	GOTO        L_expendedora_checkTarjeta706
L_expendedora_checkTarjeta698:
;Expendedora.c,847 :: 		if(saldo < 3600){
	MOVLW       128
	XORWF       expendedora_checkTarjeta_saldo_L0+3, 0 
	MOVWF       R0 
	MOVLW       128
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__expendedora_checkTarjeta1331
	MOVLW       0
	SUBWF       expendedora_checkTarjeta_saldo_L0+2, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__expendedora_checkTarjeta1331
	MOVLW       14
	SUBWF       expendedora_checkTarjeta_saldo_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__expendedora_checkTarjeta1331
	MOVLW       16
	SUBWF       expendedora_checkTarjeta_saldo_L0+0, 0 
L__expendedora_checkTarjeta1331:
	BTFSC       STATUS+0, 0 
	GOTO        L_expendedora_checkTarjeta707
;Expendedora.c,848 :: 		acceso[1] = TPV_SIN_SALDO;  //Sin saldo
	MOVLW       83
	MOVWF       expendedora_checkTarjeta_acceso_L0+1 
;Expendedora.c,849 :: 		lcd_clean_row(2);
	MOVLW       2
	MOVWF       FARG_lcd_clean_row_fila+0 
	CALL        _lcd_clean_row+0, 0
;Expendedora.c,850 :: 		lcd_out(2,1,"Saldo agotado");
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr16_Expendedora+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr16_Expendedora+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;Expendedora.c,854 :: 		}else if(estatus == ESTATUS_MOD){
	GOTO        L_expendedora_checkTarjeta708
L_expendedora_checkTarjeta707:
	MOVF        expendedora_checkTarjeta_estatus_L0+0, 0 
	XORLW       73
	BTFSS       STATUS+0, 2 
	GOTO        L_expendedora_checkTarjeta709
;Expendedora.c,855 :: 		acceso[2] = TPV_PASSBACK;   //Estado del passback
	MOVLW       80
	MOVWF       expendedora_checkTarjeta_acceso_L0+2 
;Expendedora.c,856 :: 		lcd_clean_row(2);
	MOVLW       2
	MOVWF       FARG_lcd_clean_row_fila+0 
	CALL        _lcd_clean_row+0, 0
;Expendedora.c,857 :: 		lcd_out(2,1,"Passback activo");
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr17_Expendedora+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr17_Expendedora+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;Expendedora.c,861 :: 		}
L_expendedora_checkTarjeta709:
L_expendedora_checkTarjeta708:
;Expendedora.c,862 :: 		}
L_expendedora_checkTarjeta706:
;Expendedora.c,864 :: 		string_add(canCommand, acceso);
	MOVLW       _canCommand+0
	MOVWF       FARG_string_add_destino+0 
	MOVLW       hi_addr(_canCommand+0)
	MOVWF       FARG_string_add_destino+1 
	MOVLW       expendedora_checkTarjeta_acceso_L0+0
	MOVWF       FARG_string_add_addEnd+0 
	MOVLW       hi_addr(expendedora_checkTarjeta_acceso_L0+0)
	MOVWF       FARG_string_add_addEnd+1 
	CALL        _string_add+0, 0
;Expendedora.c,866 :: 		string_cpyc(bufferEeprom, CAN_PREPAGO);
	MOVLW       _bufferEeprom+0
	MOVWF       FARG_string_cpyc_destino+0 
	MOVLW       hi_addr(_bufferEeprom+0)
	MOVWF       FARG_string_cpyc_destino+1 
	MOVLW       _CAN_PREPAGO+0
	MOVWF       FARG_string_cpyc_origen+0 
	MOVLW       hi_addr(_CAN_PREPAGO+0)
	MOVWF       FARG_string_cpyc_origen+1 
	MOVLW       higher_addr(_CAN_PREPAGO+0)
	MOVWF       FARG_string_cpyc_origen+2 
	CALL        _string_cpyc+0, 0
;Expendedora.c,867 :: 		numTohex(id, msjConst, 3);
	MOVF        expendedora_checkTarjeta_id_L0+0, 0 
	MOVWF       FARG_numToHex_valor+0 
	MOVF        expendedora_checkTarjeta_id_L0+1, 0 
	MOVWF       FARG_numToHex_valor+1 
	MOVF        expendedora_checkTarjeta_id_L0+2, 0 
	MOVWF       FARG_numToHex_valor+2 
	MOVF        expendedora_checkTarjeta_id_L0+3, 0 
	MOVWF       FARG_numToHex_valor+3 
	MOVLW       _msjConst+0
	MOVWF       FARG_numToHex_cadena+0 
	MOVLW       hi_addr(_msjConst+0)
	MOVWF       FARG_numToHex_cadena+1 
	MOVLW       3
	MOVWF       FARG_numToHex_bytes+0 
	CALL        _numToHex+0, 0
;Expendedora.c,868 :: 		string_add(bufferEeprom, msjConst);
	MOVLW       _bufferEeprom+0
	MOVWF       FARG_string_add_destino+0 
	MOVLW       hi_addr(_bufferEeprom+0)
	MOVWF       FARG_string_add_destino+1 
	MOVLW       _msjConst+0
	MOVWF       FARG_string_add_addEnd+0 
	MOVLW       hi_addr(_msjConst+0)
	MOVWF       FARG_string_add_addEnd+1 
	CALL        _string_add+0, 0
;Expendedora.c,869 :: 		if(acceso[0] == TPV_ACCESO)
	MOVF        expendedora_checkTarjeta_acceso_L0+0, 0 
	XORLW       65
	BTFSS       STATUS+0, 2 
	GOTO        L_expendedora_checkTarjeta710
;Expendedora.c,870 :: 		string_addc(bufferEeprom, CAN_SPECIAL_DATE);   //CODIGO DE ACCION
	MOVLW       _bufferEeprom+0
	MOVWF       FARG_string_addc_destino+0 
	MOVLW       hi_addr(_bufferEeprom+0)
	MOVWF       FARG_string_addc_destino+1 
	MOVLW       _CAN_SPECIAL_DATE+0
	MOVWF       FARG_string_addc_addEnd+0 
	MOVLW       hi_addr(_CAN_SPECIAL_DATE+0)
	MOVWF       FARG_string_addc_addEnd+1 
	MOVLW       higher_addr(_CAN_SPECIAL_DATE+0)
	MOVWF       FARG_string_addc_addEnd+2 
	CALL        _string_addc+0, 0
	GOTO        L_expendedora_checkTarjeta711
L_expendedora_checkTarjeta710:
;Expendedora.c,872 :: 		string_addc(bufferEeprom, CAN_PASSBACK);
	MOVLW       _bufferEeprom+0
	MOVWF       FARG_string_addc_destino+0 
	MOVLW       hi_addr(_bufferEeprom+0)
	MOVWF       FARG_string_addc_destino+1 
	MOVLW       _CAN_PASSBACK+0
	MOVWF       FARG_string_addc_addEnd+0 
	MOVLW       hi_addr(_CAN_PASSBACK+0)
	MOVWF       FARG_string_addc_addEnd+1 
	MOVLW       higher_addr(_CAN_PASSBACK+0)
	MOVWF       FARG_string_addc_addEnd+2 
	CALL        _string_addc+0, 0
L_expendedora_checkTarjeta711:
;Expendedora.c,873 :: 		numToString(fila, msjConst, 4);
	MOVF        expendedora_checkTarjeta_fila_L0+0, 0 
	MOVWF       FARG_numToString_valor+0 
	MOVF        expendedora_checkTarjeta_fila_L0+1, 0 
	MOVWF       FARG_numToString_valor+1 
	MOVLW       0
	BTFSC       expendedora_checkTarjeta_fila_L0+1, 7 
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
;Expendedora.c,874 :: 		string_add(bufferEeprom, msjConst);
	MOVLW       _bufferEeprom+0
	MOVWF       FARG_string_add_destino+0 
	MOVLW       hi_addr(_bufferEeprom+0)
	MOVWF       FARG_string_add_destino+1 
	MOVLW       _msjConst+0
	MOVWF       FARG_string_add_addEnd+0 
	MOVLW       hi_addr(_msjConst+0)
	MOVWF       FARG_string_add_addEnd+1 
	CALL        _string_add+0, 0
;Expendedora.c,876 :: 		string_push(bufferEeprom, estatus);
	MOVLW       _bufferEeprom+0
	MOVWF       FARG_string_push_texto+0 
	MOVLW       hi_addr(_bufferEeprom+0)
	MOVWF       FARG_string_push_texto+1 
	MOVF        expendedora_checkTarjeta_estatus_L0+0, 0 
	MOVWF       FARG_string_push_caracter+0 
	CALL        _string_push+0, 0
;Expendedora.c,878 :: 		DS1307_read(&myRTC, false);
	MOVLW       _myRTC+0
	MOVWF       FARG_DS1307_read_myDS+0 
	MOVLW       hi_addr(_myRTC+0)
	MOVWF       FARG_DS1307_read_myDS+1 
	CLRF        FARG_DS1307_read_formatComplet+0 
	CALL        _DS1307_read+0, 0
;Expendedora.c,879 :: 		string_add(bufferEeprom, &myRTC.time[1]);
	MOVLW       _bufferEeprom+0
	MOVWF       FARG_string_add_destino+0 
	MOVLW       hi_addr(_bufferEeprom+0)
	MOVWF       FARG_string_add_destino+1 
	MOVLW       _myRTC+8
	MOVWF       FARG_string_add_addEnd+0 
	MOVLW       hi_addr(_myRTC+8)
	MOVWF       FARG_string_add_addEnd+1 
	CALL        _string_add+0, 0
;Expendedora.c,881 :: 		buffer_save_send(true, bufferEeprom);
	MOVLW       1
	MOVWF       FARG_buffer_save_send_guardar+0 
	MOVLW       _bufferEeprom+0
	MOVWF       FARG_buffer_save_send_buffer+0 
	MOVLW       hi_addr(_bufferEeprom+0)
	MOVWF       FARG_buffer_save_send_buffer+1 
	CALL        _buffer_save_send+0, 0
;Expendedora.c,882 :: 		}else if(!mysql_search_forced(tableKeyOutNip, keyOutNip, nip, &fila)){
	GOTO        L_expendedora_checkTarjeta712
L_expendedora_checkTarjeta693:
	MOVLW       _tableKeyOutNip+0
	MOVWF       FARG_mysql_search_forced_tabla+0 
	MOVLW       hi_addr(_tableKeyOutNip+0)
	MOVWF       FARG_mysql_search_forced_tabla+1 
	MOVLW       _keyOutNip+0
	MOVWF       FARG_mysql_search_forced_columna+0 
	MOVLW       hi_addr(_keyOutNip+0)
	MOVWF       FARG_mysql_search_forced_columna+1 
	MOVF        expendedora_checkTarjeta_nip_L0+0, 0 
	MOVWF       FARG_mysql_search_forced_buscar+0 
	MOVF        expendedora_checkTarjeta_nip_L0+1, 0 
	MOVWF       FARG_mysql_search_forced_buscar+1 
	MOVLW       0
	BTFSC       expendedora_checkTarjeta_nip_L0+1, 7 
	MOVLW       255
	MOVWF       FARG_mysql_search_forced_buscar+2 
	MOVWF       FARG_mysql_search_forced_buscar+3 
	MOVLW       expendedora_checkTarjeta_fila_L0+0
	MOVWF       FARG_mysql_search_forced_fila+0 
	MOVLW       hi_addr(expendedora_checkTarjeta_fila_L0+0)
	MOVWF       FARG_mysql_search_forced_fila+1 
	CALL        _mysql_search_forced+0, 0
	MOVF        R0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_expendedora_checkTarjeta713
;Expendedora.c,884 :: 		canCommand[3] = CAN_KEY[0];
	MOVLW       75
	MOVWF       _canCommand+3 
;Expendedora.c,885 :: 		canCommand[4] = CAN_KEY[1];
	MOVLW       69
	MOVWF       _canCommand+4 
;Expendedora.c,886 :: 		canCommand[5] = CAN_KEY[2];
	MOVLW       89
	MOVWF       _canCommand+5 
;Expendedora.c,887 :: 		mysql_read_forced(tableKeyOutNip, keyOutEstatus, fila, &estatus);
	MOVLW       _tableKeyOutNip+0
	MOVWF       FARG_mysql_read_forced_name+0 
	MOVLW       hi_addr(_tableKeyOutNip+0)
	MOVWF       FARG_mysql_read_forced_name+1 
	MOVLW       _keyOutEstatus+0
	MOVWF       FARG_mysql_read_forced_column+0 
	MOVLW       hi_addr(_keyOutEstatus+0)
	MOVWF       FARG_mysql_read_forced_column+1 
	MOVF        expendedora_checkTarjeta_fila_L0+0, 0 
	MOVWF       FARG_mysql_read_forced_fila+0 
	MOVF        expendedora_checkTarjeta_fila_L0+1, 0 
	MOVWF       FARG_mysql_read_forced_fila+1 
	MOVLW       expendedora_checkTarjeta_estatus_L0+0
	MOVWF       FARG_mysql_read_forced_result+0 
	MOVLW       hi_addr(expendedora_checkTarjeta_estatus_L0+0)
	MOVWF       FARG_mysql_read_forced_result+1 
	CALL        _mysql_read_forced+0, 0
;Expendedora.c,888 :: 		mysql_read_forced(tableKeyOutNip, keyOutDate, fila, fecha);
	MOVLW       _tableKeyOutNip+0
	MOVWF       FARG_mysql_read_forced_name+0 
	MOVLW       hi_addr(_tableKeyOutNip+0)
	MOVWF       FARG_mysql_read_forced_name+1 
	MOVLW       _keyOutDate+0
	MOVWF       FARG_mysql_read_forced_column+0 
	MOVLW       hi_addr(_keyOutDate+0)
	MOVWF       FARG_mysql_read_forced_column+1 
	MOVF        expendedora_checkTarjeta_fila_L0+0, 0 
	MOVWF       FARG_mysql_read_forced_fila+0 
	MOVF        expendedora_checkTarjeta_fila_L0+1, 0 
	MOVWF       FARG_mysql_read_forced_fila+1 
	MOVLW       expendedora_checkTarjeta_fecha_L0+0
	MOVWF       FARG_mysql_read_forced_result+0 
	MOVLW       hi_addr(expendedora_checkTarjeta_fecha_L0+0)
	MOVWF       FARG_mysql_read_forced_result+1 
	CALL        _mysql_read_forced+0, 0
;Expendedora.c,889 :: 		fecha[12] = 0; //Agregar final de cadena, proteccion
	CLRF        expendedora_checkTarjeta_fecha_L0+12 
;Expendedora.c,890 :: 		DS1307_read(&myRTC, false);
	MOVLW       _myRTC+0
	MOVWF       FARG_DS1307_read_myDS+0 
	MOVLW       hi_addr(_myRTC+0)
	MOVWF       FARG_DS1307_read_myDS+1 
	CLRF        FARG_DS1307_read_formatComplet+0 
	CALL        _DS1307_read+0, 0
;Expendedora.c,899 :: 		string_cpyn(msjConst, &myRTC.time[1], 6);
	MOVLW       _msjConst+0
	MOVWF       FARG_string_cpyn_destino+0 
	MOVLW       hi_addr(_msjConst+0)
	MOVWF       FARG_string_cpyn_destino+1 
	MOVLW       _myRTC+8
	MOVWF       FARG_string_cpyn_origen+0 
	MOVLW       hi_addr(_myRTC+8)
	MOVWF       FARG_string_cpyn_origen+1 
	MOVLW       6
	MOVWF       FARG_string_cpyn_size+0 
	CALL        _string_cpyn+0, 0
;Expendedora.c,900 :: 		seconds = DS1307_getSeconds(msjConst);
	MOVLW       _msjConst+0
	MOVWF       FARG_DS1307_getSeconds_HHMMSS+0 
	MOVLW       hi_addr(_msjConst+0)
	MOVWF       FARG_DS1307_getSeconds_HHMMSS+1 
	CALL        _DS1307_getSeconds+0, 0
	MOVF        R0, 0 
	MOVWF       expendedora_checkTarjeta_seconds_L0+0 
	MOVF        R1, 0 
	MOVWF       expendedora_checkTarjeta_seconds_L0+1 
	MOVF        R2, 0 
	MOVWF       expendedora_checkTarjeta_seconds_L0+2 
	MOVF        R3, 0 
	MOVWF       expendedora_checkTarjeta_seconds_L0+3 
;Expendedora.c,901 :: 		string_cpyn(msjConst, fecha, 6);
	MOVLW       _msjConst+0
	MOVWF       FARG_string_cpyn_destino+0 
	MOVLW       hi_addr(_msjConst+0)
	MOVWF       FARG_string_cpyn_destino+1 
	MOVLW       expendedora_checkTarjeta_fecha_L0+0
	MOVWF       FARG_string_cpyn_origen+0 
	MOVLW       hi_addr(expendedora_checkTarjeta_fecha_L0+0)
	MOVWF       FARG_string_cpyn_origen+1 
	MOVLW       6
	MOVWF       FARG_string_cpyn_size+0 
	CALL        _string_cpyn+0, 0
;Expendedora.c,902 :: 		seconds -= DS1307_getSeconds(msjConst);
	MOVLW       _msjConst+0
	MOVWF       FARG_DS1307_getSeconds_HHMMSS+0 
	MOVLW       hi_addr(_msjConst+0)
	MOVWF       FARG_DS1307_getSeconds_HHMMSS+1 
	CALL        _DS1307_getSeconds+0, 0
	MOVF        expendedora_checkTarjeta_seconds_L0+0, 0 
	MOVWF       R4 
	MOVF        expendedora_checkTarjeta_seconds_L0+1, 0 
	MOVWF       R5 
	MOVF        expendedora_checkTarjeta_seconds_L0+2, 0 
	MOVWF       R6 
	MOVF        expendedora_checkTarjeta_seconds_L0+3, 0 
	MOVWF       R7 
	MOVF        R0, 0 
	SUBWF       R4, 1 
	MOVF        R1, 0 
	SUBWFB      R5, 1 
	MOVF        R2, 0 
	SUBWFB      R6, 1 
	MOVF        R3, 0 
	SUBWFB      R7, 1 
	MOVF        R4, 0 
	MOVWF       expendedora_checkTarjeta_seconds_L0+0 
	MOVF        R5, 0 
	MOVWF       expendedora_checkTarjeta_seconds_L0+1 
	MOVF        R6, 0 
	MOVWF       expendedora_checkTarjeta_seconds_L0+2 
	MOVF        R7, 0 
	MOVWF       expendedora_checkTarjeta_seconds_L0+3 
;Expendedora.c,903 :: 		seconds = clamp(seconds, 0, TOLERANCIA_OUT); //Saturar en este rango
	MOVF        R4, 0 
	MOVWF       FARG_clamp_valor+0 
	MOVF        R5, 0 
	MOVWF       FARG_clamp_valor+1 
	MOVF        R6, 0 
	MOVWF       FARG_clamp_valor+2 
	MOVF        R7, 0 
	MOVWF       FARG_clamp_valor+3 
	CLRF        FARG_clamp_min+0 
	CLRF        FARG_clamp_min+1 
	CLRF        FARG_clamp_min+2 
	CLRF        FARG_clamp_min+3 
	MOVLW       142
	MOVWF       FARG_clamp_max+0 
	MOVLW       3
	MOVWF       FARG_clamp_max+1 
	MOVLW       0
	MOVWF       FARG_clamp_max+2 
	MOVWF       FARG_clamp_max+3 
	CALL        _clamp+0, 0
	MOVF        R0, 0 
	MOVWF       expendedora_checkTarjeta_seconds_L0+0 
	MOVF        R1, 0 
	MOVWF       expendedora_checkTarjeta_seconds_L0+1 
	MOVF        R2, 0 
	MOVWF       expendedora_checkTarjeta_seconds_L0+2 
	MOVF        R3, 0 
	MOVWF       expendedora_checkTarjeta_seconds_L0+3 
;Expendedora.c,906 :: 		string_cpy(msjConst, &myRTC.time[1]);
	MOVLW       _msjConst+0
	MOVWF       FARG_string_cpy_destino+0 
	MOVLW       hi_addr(_msjConst+0)
	MOVWF       FARG_string_cpy_destino+1 
	MOVLW       _myRTC+8
	MOVWF       FARG_string_cpy_origen+0 
	MOVLW       hi_addr(_myRTC+8)
	MOVWF       FARG_string_cpy_origen+1 
	CALL        _string_cpy+0, 0
;Expendedora.c,907 :: 		isOtherToday = !string_cmpn(&msjConst[6], &fecha[6], 2);
	MOVLW       _msjConst+6
	MOVWF       FARG_string_cmpn_text1+0 
	MOVLW       hi_addr(_msjConst+6)
	MOVWF       FARG_string_cmpn_text1+1 
	MOVLW       expendedora_checkTarjeta_fecha_L0+6
	MOVWF       FARG_string_cmpn_text2+0 
	MOVLW       hi_addr(expendedora_checkTarjeta_fecha_L0+6)
	MOVWF       FARG_string_cmpn_text2+1 
	MOVLW       2
	MOVWF       FARG_string_cmpn_bytes+0 
	CALL        _string_cmpn+0, 0
	MOVF        R0, 1 
	MOVLW       1
	BTFSS       STATUS+0, 2 
	MOVLW       0
	MOVWF       expendedora_checkTarjeta_isOtherToday_L0+0 
;Expendedora.c,908 :: 		isOtherToday |= !string_cmpn(&msjConst[8], &fecha[8], 2);
	MOVLW       _msjConst+8
	MOVWF       FARG_string_cmpn_text1+0 
	MOVLW       hi_addr(_msjConst+8)
	MOVWF       FARG_string_cmpn_text1+1 
	MOVLW       expendedora_checkTarjeta_fecha_L0+8
	MOVWF       FARG_string_cmpn_text2+0 
	MOVLW       hi_addr(expendedora_checkTarjeta_fecha_L0+8)
	MOVWF       FARG_string_cmpn_text2+1 
	MOVLW       2
	MOVWF       FARG_string_cmpn_bytes+0 
	CALL        _string_cmpn+0, 0
	MOVF        R0, 1 
	MOVLW       1
	BTFSS       STATUS+0, 2 
	MOVLW       0
	MOVWF       R1 
	MOVF        R1, 0 
	IORWF       expendedora_checkTarjeta_isOtherToday_L0+0, 1 
;Expendedora.c,909 :: 		isOtherToday |= !string_cmpn(&msjConst[10], &fecha[10], 2);
	MOVLW       _msjConst+10
	MOVWF       FARG_string_cmpn_text1+0 
	MOVLW       hi_addr(_msjConst+10)
	MOVWF       FARG_string_cmpn_text1+1 
	MOVLW       expendedora_checkTarjeta_fecha_L0+10
	MOVWF       FARG_string_cmpn_text2+0 
	MOVLW       hi_addr(expendedora_checkTarjeta_fecha_L0+10)
	MOVWF       FARG_string_cmpn_text2+1 
	MOVLW       2
	MOVWF       FARG_string_cmpn_bytes+0 
	CALL        _string_cmpn+0, 0
	MOVF        R0, 1 
	MOVLW       1
	BTFSS       STATUS+0, 2 
	MOVLW       0
	MOVWF       R1 
	MOVF        R1, 0 
	IORWF       expendedora_checkTarjeta_isOtherToday_L0+0, 1 
;Expendedora.c,912 :: 		if(estatus == '1' && seconds < TOLERANCIA_OUT && !isOtherToday){
	MOVF        expendedora_checkTarjeta_estatus_L0+0, 0 
	XORLW       49
	BTFSS       STATUS+0, 2 
	GOTO        L_expendedora_checkTarjeta716
	MOVLW       128
	XORWF       expendedora_checkTarjeta_seconds_L0+3, 0 
	MOVWF       R0 
	MOVLW       128
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__expendedora_checkTarjeta1332
	MOVLW       0
	SUBWF       expendedora_checkTarjeta_seconds_L0+2, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__expendedora_checkTarjeta1332
	MOVLW       3
	SUBWF       expendedora_checkTarjeta_seconds_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__expendedora_checkTarjeta1332
	MOVLW       142
	SUBWF       expendedora_checkTarjeta_seconds_L0+0, 0 
L__expendedora_checkTarjeta1332:
	BTFSC       STATUS+0, 0 
	GOTO        L_expendedora_checkTarjeta716
	MOVF        expendedora_checkTarjeta_isOtherToday_L0+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_expendedora_checkTarjeta716
L__expendedora_checkTarjeta963:
;Expendedora.c,914 :: 		abrirBarrera = true;
	MOVLW       1
	MOVWF       _abrirBarrera+0 
;Expendedora.c,915 :: 		SALIDA_RELE1 = 1;
	BSF         PORTA+0, 5 
;Expendedora.c,916 :: 		SALIDA_RELE2 = 1;
	BSF         PORTE+0, 0 
;Expendedora.c,917 :: 		timer1_reset();
	CALL        _timer1_reset+0, 0
;Expendedora.c,918 :: 		timer1_enable(true);
	MOVLW       1
	MOVWF       FARG_timer1_enable_enable+0 
	CALL        _timer1_enable+0, 0
;Expendedora.c,920 :: 		acceso[0] = TPV_ACCESO;    //Acceso
	MOVLW       65
	MOVWF       expendedora_checkTarjeta_acceso_L0+0 
;Expendedora.c,924 :: 		mysql_write_forced(tableKeyOutNip, keyOutEstatus, fila, "0", 1);
	MOVLW       _tableKeyOutNip+0
	MOVWF       FARG_mysql_write_forced_name+0 
	MOVLW       hi_addr(_tableKeyOutNip+0)
	MOVWF       FARG_mysql_write_forced_name+1 
	MOVLW       _keyOutEstatus+0
	MOVWF       FARG_mysql_write_forced_column+0 
	MOVLW       hi_addr(_keyOutEstatus+0)
	MOVWF       FARG_mysql_write_forced_column+1 
	MOVF        expendedora_checkTarjeta_fila_L0+0, 0 
	MOVWF       FARG_mysql_write_forced_fila+0 
	MOVF        expendedora_checkTarjeta_fila_L0+1, 0 
	MOVWF       FARG_mysql_write_forced_fila+1 
	MOVLW       ?lstr18_Expendedora+0
	MOVWF       FARG_mysql_write_forced_texto+0 
	MOVLW       hi_addr(?lstr18_Expendedora+0)
	MOVWF       FARG_mysql_write_forced_texto+1 
	MOVLW       1
	MOVWF       FARG_mysql_write_forced_bytes+0 
	CALL        _mysql_write_forced+0, 0
;Expendedora.c,925 :: 		lcd_clean_row(2);
	MOVLW       2
	MOVWF       FARG_lcd_clean_row_fila+0 
	CALL        _lcd_clean_row+0, 0
;Expendedora.c,926 :: 		lcd_out(2,1,"NIP aceptado");
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr19_Expendedora+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr19_Expendedora+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;Expendedora.c,932 :: 		}else if(estatus == '0'){
	GOTO        L_expendedora_checkTarjeta717
L_expendedora_checkTarjeta716:
	MOVF        expendedora_checkTarjeta_estatus_L0+0, 0 
	XORLW       48
	BTFSS       STATUS+0, 2 
	GOTO        L_expendedora_checkTarjeta718
;Expendedora.c,933 :: 		acceso[2] = TPV_PASSBACK;   //Llave ya utilizada
	MOVLW       80
	MOVWF       expendedora_checkTarjeta_acceso_L0+2 
;Expendedora.c,934 :: 		lcd_clean_row(2);
	MOVLW       2
	MOVWF       FARG_lcd_clean_row_fila+0 
	CALL        _lcd_clean_row+0, 0
;Expendedora.c,935 :: 		lcd_out(2,1,"NIP desconocido*");
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr20_Expendedora+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr20_Expendedora+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;Expendedora.c,941 :: 		}else if(isOtherToday || seconds >= TOLERANCIA_OUT){
	GOTO        L_expendedora_checkTarjeta719
L_expendedora_checkTarjeta718:
	MOVF        expendedora_checkTarjeta_isOtherToday_L0+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L__expendedora_checkTarjeta962
	MOVLW       128
	XORWF       expendedora_checkTarjeta_seconds_L0+3, 0 
	MOVWF       R0 
	MOVLW       128
	SUBWF       R0, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__expendedora_checkTarjeta1333
	MOVLW       0
	SUBWF       expendedora_checkTarjeta_seconds_L0+2, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__expendedora_checkTarjeta1333
	MOVLW       3
	SUBWF       expendedora_checkTarjeta_seconds_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__expendedora_checkTarjeta1333
	MOVLW       142
	SUBWF       expendedora_checkTarjeta_seconds_L0+0, 0 
L__expendedora_checkTarjeta1333:
	BTFSC       STATUS+0, 0 
	GOTO        L__expendedora_checkTarjeta962
	GOTO        L_expendedora_checkTarjeta722
L__expendedora_checkTarjeta962:
;Expendedora.c,942 :: 		acceso[1] = TPV_OUT_TIME;  //FECHA EN FUERA DE RANGO
	MOVLW       84
	MOVWF       expendedora_checkTarjeta_acceso_L0+1 
;Expendedora.c,943 :: 		lcd_clean_row(2);
	MOVLW       2
	MOVWF       FARG_lcd_clean_row_fila+0 
	CALL        _lcd_clean_row+0, 0
;Expendedora.c,944 :: 		lcd_out(2,1,"NIP invalido*");
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr21_Expendedora+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr21_Expendedora+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;Expendedora.c,948 :: 		}
L_expendedora_checkTarjeta722:
L_expendedora_checkTarjeta719:
L_expendedora_checkTarjeta717:
;Expendedora.c,950 :: 		string_add(canCommand, acceso);
	MOVLW       _canCommand+0
	MOVWF       FARG_string_add_destino+0 
	MOVLW       hi_addr(_canCommand+0)
	MOVWF       FARG_string_add_destino+1 
	MOVLW       expendedora_checkTarjeta_acceso_L0+0
	MOVWF       FARG_string_add_addEnd+0 
	MOVLW       hi_addr(expendedora_checkTarjeta_acceso_L0+0)
	MOVWF       FARG_string_add_addEnd+1 
	CALL        _string_add+0, 0
;Expendedora.c,951 :: 		}else{
	GOTO        L_expendedora_checkTarjeta723
L_expendedora_checkTarjeta713:
;Expendedora.c,952 :: 		lcd_clean_row(2);
	MOVLW       2
	MOVWF       FARG_lcd_clean_row_fila+0 
	CALL        _lcd_clean_row+0, 0
;Expendedora.c,953 :: 		lcd_out(2,1,"Nip descnocido");
	MOVLW       2
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr22_Expendedora+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr22_Expendedora+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;Expendedora.c,957 :: 		acceso[3] = TPV_DESCONOCIDO;
	MOVLW       68
	MOVWF       expendedora_checkTarjeta_acceso_L0+3 
;Expendedora.c,958 :: 		string_add(canCommand,acceso);
	MOVLW       _canCommand+0
	MOVWF       FARG_string_add_destino+0 
	MOVLW       hi_addr(_canCommand+0)
	MOVWF       FARG_string_add_destino+1 
	MOVLW       expendedora_checkTarjeta_acceso_L0+0
	MOVWF       FARG_string_add_addEnd+0 
	MOVLW       hi_addr(expendedora_checkTarjeta_acceso_L0+0)
	MOVWF       FARG_string_add_addEnd+1 
	CALL        _string_add+0, 0
;Expendedora.c,959 :: 		}
L_expendedora_checkTarjeta723:
L_expendedora_checkTarjeta712:
;Expendedora.c,961 :: 		string_addc(canCommand, CAN_MODULE);
	MOVLW       _canCommand+0
	MOVWF       FARG_string_addc_destino+0 
	MOVLW       hi_addr(_canCommand+0)
	MOVWF       FARG_string_addc_destino+1 
	MOVLW       _CAN_MODULE+0
	MOVWF       FARG_string_addc_addEnd+0 
	MOVLW       hi_addr(_CAN_MODULE+0)
	MOVWF       FARG_string_addc_addEnd+1 
	MOVLW       higher_addr(_CAN_MODULE+0)
	MOVWF       FARG_string_addc_addEnd+2 
	CALL        _string_addc+0, 0
;Expendedora.c,962 :: 		numToHex(canId, msjConst, 1);
	MOVF        _canId+0, 0 
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
;Expendedora.c,963 :: 		string_add(canCommand, msjConst);
	MOVLW       _canCommand+0
	MOVWF       FARG_string_add_destino+0 
	MOVLW       hi_addr(_canCommand+0)
	MOVWF       FARG_string_add_destino+1 
	MOVLW       _msjConst+0
	MOVWF       FARG_string_add_addEnd+0 
	MOVLW       hi_addr(_msjConst+0)
	MOVWF       FARG_string_add_addEnd+1 
	CALL        _string_add+0, 0
;Expendedora.c,964 :: 		buffer_save_send(false, canCommand);
	CLRF        FARG_buffer_save_send_guardar+0 
	MOVLW       _canCommand+0
	MOVWF       FARG_buffer_save_send_buffer+0 
	MOVLW       hi_addr(_canCommand+0)
	MOVWF       FARG_buffer_save_send_buffer+1 
	CALL        _buffer_save_send+0, 0
;Expendedora.c,965 :: 		}
L_expendedora_checkTarjeta692:
L_expendedora_checkTarjeta691:
;Expendedora.c,966 :: 		}
L_end_expendedora_checkTarjeta:
	RETURN      0
; end of _expendedora_checkTarjeta

_expendedora_imprimir:

;Expendedora.c,968 :: 		void expendedora_imprimir(){
;Expendedora.c,975 :: 		if(SENSOR_COCHE && !btnCoche){
	BTFSS       PORTD+0, 0 
	GOTO        L_expendedora_imprimir726
	MOVF        expendedora_imprimir_btnCoche_L0+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_expendedora_imprimir726
L__expendedora_imprimir981:
;Expendedora.c,976 :: 		btnCoche = true;
	MOVLW       1
	MOVWF       expendedora_imprimir_btnCoche_L0+0 
;Expendedora.c,977 :: 		lcd_chr(1,20,'C');
	MOVLW       1
	MOVWF       FARG_Lcd_Chr_row+0 
	MOVLW       20
	MOVWF       FARG_Lcd_Chr_column+0 
	MOVLW       67
	MOVWF       FARG_Lcd_Chr_out_char+0 
	CALL        _Lcd_Chr+0, 0
;Expendedora.c,979 :: 		string_cpyc(bufferEeprom, CAN_TPV);
	MOVLW       _bufferEeprom+0
	MOVWF       FARG_string_cpyc_destino+0 
	MOVLW       hi_addr(_bufferEeprom+0)
	MOVWF       FARG_string_cpyc_destino+1 
	MOVLW       _CAN_TPV+0
	MOVWF       FARG_string_cpyc_origen+0 
	MOVLW       hi_addr(_CAN_TPV+0)
	MOVWF       FARG_string_cpyc_origen+1 
	MOVLW       higher_addr(_CAN_TPV+0)
	MOVWF       FARG_string_cpyc_origen+2 
	CALL        _string_cpyc+0, 0
;Expendedora.c,980 :: 		string_addc(bufferEeprom, CAN_COCHE_IN);
	MOVLW       _bufferEeprom+0
	MOVWF       FARG_string_addc_destino+0 
	MOVLW       hi_addr(_bufferEeprom+0)
	MOVWF       FARG_string_addc_destino+1 
	MOVLW       _CAN_COCHE_IN+0
	MOVWF       FARG_string_addc_addEnd+0 
	MOVLW       hi_addr(_CAN_COCHE_IN+0)
	MOVWF       FARG_string_addc_addEnd+1 
	MOVLW       higher_addr(_CAN_COCHE_IN+0)
	MOVWF       FARG_string_addc_addEnd+2 
	CALL        _string_addc+0, 0
;Expendedora.c,981 :: 		DS1307_read(&myRTC, false);
	MOVLW       _myRTC+0
	MOVWF       FARG_DS1307_read_myDS+0 
	MOVLW       hi_addr(_myRTC+0)
	MOVWF       FARG_DS1307_read_myDS+1 
	CLRF        FARG_DS1307_read_formatComplet+0 
	CALL        _DS1307_read+0, 0
;Expendedora.c,982 :: 		string_add(bufferEeprom, &myRTC.time[1]);
	MOVLW       _bufferEeprom+0
	MOVWF       FARG_string_add_destino+0 
	MOVLW       hi_addr(_bufferEeprom+0)
	MOVWF       FARG_string_add_destino+1 
	MOVLW       _myRTC+8
	MOVWF       FARG_string_add_addEnd+0 
	MOVLW       hi_addr(_myRTC+8)
	MOVWF       FARG_string_add_addEnd+1 
	CALL        _string_add+0, 0
;Expendedora.c,984 :: 		string_addc(bufferEeprom, CAN_MODULE);
	MOVLW       _bufferEeprom+0
	MOVWF       FARG_string_addc_destino+0 
	MOVLW       hi_addr(_bufferEeprom+0)
	MOVWF       FARG_string_addc_destino+1 
	MOVLW       _CAN_MODULE+0
	MOVWF       FARG_string_addc_addEnd+0 
	MOVLW       hi_addr(_CAN_MODULE+0)
	MOVWF       FARG_string_addc_addEnd+1 
	MOVLW       higher_addr(_CAN_MODULE+0)
	MOVWF       FARG_string_addc_addEnd+2 
	CALL        _string_addc+0, 0
;Expendedora.c,985 :: 		numToHex(canId, msjConst, 1);
	MOVF        _canId+0, 0 
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
;Expendedora.c,986 :: 		string_add(bufferEeprom, msjConst);
	MOVLW       _bufferEeprom+0
	MOVWF       FARG_string_add_destino+0 
	MOVLW       hi_addr(_bufferEeprom+0)
	MOVWF       FARG_string_add_destino+1 
	MOVLW       _msjConst+0
	MOVWF       FARG_string_add_addEnd+0 
	MOVLW       hi_addr(_msjConst+0)
	MOVWF       FARG_string_add_addEnd+1 
	CALL        _string_add+0, 0
;Expendedora.c,987 :: 		buffer_save_send(false, bufferEeprom);
	CLRF        FARG_buffer_save_send_guardar+0 
	MOVLW       _bufferEeprom+0
	MOVWF       FARG_buffer_save_send_buffer+0 
	MOVLW       hi_addr(_bufferEeprom+0)
	MOVWF       FARG_buffer_save_send_buffer+1 
	CALL        _buffer_save_send+0, 0
;Expendedora.c,991 :: 		}else if(!SENSOR_COCHE && btnCoche){
	GOTO        L_expendedora_imprimir727
L_expendedora_imprimir726:
	BTFSC       PORTD+0, 0 
	GOTO        L_expendedora_imprimir730
	MOVF        expendedora_imprimir_btnCoche_L0+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_expendedora_imprimir730
L__expendedora_imprimir980:
;Expendedora.c,992 :: 		btnCoche = false;
	CLRF        expendedora_imprimir_btnCoche_L0+0 
;Expendedora.c,993 :: 		lcd_chr(1,20,' ');
	MOVLW       1
	MOVWF       FARG_Lcd_Chr_row+0 
	MOVLW       20
	MOVWF       FARG_Lcd_Chr_column+0 
	MOVLW       32
	MOVWF       FARG_Lcd_Chr_out_char+0 
	CALL        _Lcd_Chr+0, 0
;Expendedora.c,995 :: 		string_cpyc(bufferEeprom, CAN_TPV);
	MOVLW       _bufferEeprom+0
	MOVWF       FARG_string_cpyc_destino+0 
	MOVLW       hi_addr(_bufferEeprom+0)
	MOVWF       FARG_string_cpyc_destino+1 
	MOVLW       _CAN_TPV+0
	MOVWF       FARG_string_cpyc_origen+0 
	MOVLW       hi_addr(_CAN_TPV+0)
	MOVWF       FARG_string_cpyc_origen+1 
	MOVLW       higher_addr(_CAN_TPV+0)
	MOVWF       FARG_string_cpyc_origen+2 
	CALL        _string_cpyc+0, 0
;Expendedora.c,996 :: 		string_addc(bufferEeprom, CAN_COCHE_OUT);
	MOVLW       _bufferEeprom+0
	MOVWF       FARG_string_addc_destino+0 
	MOVLW       hi_addr(_bufferEeprom+0)
	MOVWF       FARG_string_addc_destino+1 
	MOVLW       _CAN_COCHE_OUT+0
	MOVWF       FARG_string_addc_addEnd+0 
	MOVLW       hi_addr(_CAN_COCHE_OUT+0)
	MOVWF       FARG_string_addc_addEnd+1 
	MOVLW       higher_addr(_CAN_COCHE_OUT+0)
	MOVWF       FARG_string_addc_addEnd+2 
	CALL        _string_addc+0, 0
;Expendedora.c,997 :: 		DS1307_read(&myRTC, false);
	MOVLW       _myRTC+0
	MOVWF       FARG_DS1307_read_myDS+0 
	MOVLW       hi_addr(_myRTC+0)
	MOVWF       FARG_DS1307_read_myDS+1 
	CLRF        FARG_DS1307_read_formatComplet+0 
	CALL        _DS1307_read+0, 0
;Expendedora.c,998 :: 		string_add(bufferEeprom, &myRTC.time[1]);
	MOVLW       _bufferEeprom+0
	MOVWF       FARG_string_add_destino+0 
	MOVLW       hi_addr(_bufferEeprom+0)
	MOVWF       FARG_string_add_destino+1 
	MOVLW       _myRTC+8
	MOVWF       FARG_string_add_addEnd+0 
	MOVLW       hi_addr(_myRTC+8)
	MOVWF       FARG_string_add_addEnd+1 
	CALL        _string_add+0, 0
;Expendedora.c,1000 :: 		string_addc(bufferEeprom, CAN_MODULE);
	MOVLW       _bufferEeprom+0
	MOVWF       FARG_string_addc_destino+0 
	MOVLW       hi_addr(_bufferEeprom+0)
	MOVWF       FARG_string_addc_destino+1 
	MOVLW       _CAN_MODULE+0
	MOVWF       FARG_string_addc_addEnd+0 
	MOVLW       hi_addr(_CAN_MODULE+0)
	MOVWF       FARG_string_addc_addEnd+1 
	MOVLW       higher_addr(_CAN_MODULE+0)
	MOVWF       FARG_string_addc_addEnd+2 
	CALL        _string_addc+0, 0
;Expendedora.c,1001 :: 		numToHex(canId, msjConst, 1);
	MOVF        _canId+0, 0 
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
;Expendedora.c,1002 :: 		string_add(bufferEeprom, msjConst);
	MOVLW       _bufferEeprom+0
	MOVWF       FARG_string_add_destino+0 
	MOVLW       hi_addr(_bufferEeprom+0)
	MOVWF       FARG_string_add_destino+1 
	MOVLW       _msjConst+0
	MOVWF       FARG_string_add_addEnd+0 
	MOVLW       hi_addr(_msjConst+0)
	MOVWF       FARG_string_add_addEnd+1 
	CALL        _string_add+0, 0
;Expendedora.c,1003 :: 		buffer_save_send(false, bufferEeprom);
	CLRF        FARG_buffer_save_send_guardar+0 
	MOVLW       _bufferEeprom+0
	MOVWF       FARG_buffer_save_send_buffer+0 
	MOVLW       hi_addr(_bufferEeprom+0)
	MOVWF       FARG_buffer_save_send_buffer+1 
	CALL        _buffer_save_send+0, 0
;Expendedora.c,1007 :: 		}
L_expendedora_imprimir730:
L_expendedora_imprimir727:
;Expendedora.c,1010 :: 		if(BOTON_IMPRIMIR){
	BTFSS       PORTD+0, 1 
	GOTO        L_expendedora_imprimir731
;Expendedora.c,1011 :: 		if(!imprimir && SENSOR_COCHE){
	MOVF        expendedora_imprimir_imprimir_L0+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_expendedora_imprimir734
	BTFSS       PORTD+0, 0 
	GOTO        L_expendedora_imprimir734
L__expendedora_imprimir979:
;Expendedora.c,1012 :: 		limpiarLCD = true;
	MOVLW       1
	MOVWF       _limpiarLCD+0 
;Expendedora.c,1013 :: 		tempLCD = 0;
	CLRF        _tempLCD+0 
;Expendedora.c,1015 :: 		if(cupoLleno){
	MOVF        _cupoLleno+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_expendedora_imprimir735
;Expendedora.c,1016 :: 		lcd_clean_row(1);
	MOVLW       1
	MOVWF       FARG_lcd_clean_row_fila+0 
	CALL        _lcd_clean_row+0, 0
;Expendedora.c,1017 :: 		lcd_out(3,1,"Cupo lleno");
	MOVLW       3
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr23_Expendedora+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr23_Expendedora+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;Expendedora.c,1021 :: 		return;
	GOTO        L_end_expendedora_imprimir
;Expendedora.c,1022 :: 		}
L_expendedora_imprimir735:
;Expendedora.c,1024 :: 		imprimir = 0x03;      //Imprimiendo y esperar señal en bajo
	MOVLW       3
	MOVWF       expendedora_imprimir_imprimir_L0+0 
;Expendedora.c,1025 :: 		lcd_clean_row(3);
	MOVLW       3
	MOVWF       FARG_lcd_clean_row_fila+0 
	CALL        _lcd_clean_row+0, 0
;Expendedora.c,1026 :: 		lcd_out(3,1,"Imprimendo...");
	MOVLW       3
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr24_Expendedora+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr24_Expendedora+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;Expendedora.c,1031 :: 		folio = clamp_shift(++folio, 1, 9999999); //FORMATO DE 7 DIGITOS
	MOVLW       1
	ADDWF       _folio+0, 1 
	MOVLW       0
	ADDWFC      _folio+1, 1 
	ADDWFC      _folio+2, 1 
	ADDWFC      _folio+3, 1 
	MOVF        _folio+0, 0 
	MOVWF       FARG_clamp_shift_valor+0 
	MOVF        _folio+1, 0 
	MOVWF       FARG_clamp_shift_valor+1 
	MOVF        _folio+2, 0 
	MOVWF       FARG_clamp_shift_valor+2 
	MOVF        _folio+3, 0 
	MOVWF       FARG_clamp_shift_valor+3 
	MOVLW       1
	MOVWF       FARG_clamp_shift_min+0 
	MOVLW       0
	MOVWF       FARG_clamp_shift_min+1 
	MOVWF       FARG_clamp_shift_min+2 
	MOVWF       FARG_clamp_shift_min+3 
	MOVLW       127
	MOVWF       FARG_clamp_shift_max+0 
	MOVLW       150
	MOVWF       FARG_clamp_shift_max+1 
	MOVLW       152
	MOVWF       FARG_clamp_shift_max+2 
	MOVLW       0
	MOVWF       FARG_clamp_shift_max+3 
	CALL        _clamp_shift+0, 0
	MOVF        R0, 0 
	MOVWF       _folio+0 
	MOVF        R1, 0 
	MOVWF       _folio+1 
	MOVF        R2, 0 
	MOVWF       _folio+2 
	MOVF        R3, 0 
	MOVWF       _folio+3 
;Expendedora.c,1032 :: 		numToString(folio, ticketFolio, 7);
	MOVF        R0, 0 
	MOVWF       FARG_numToString_valor+0 
	MOVF        R1, 0 
	MOVWF       FARG_numToString_valor+1 
	MOVF        R2, 0 
	MOVWF       FARG_numToString_valor+2 
	MOVF        R3, 0 
	MOVWF       FARG_numToString_valor+3 
	MOVLW       _ticketFolio+0
	MOVWF       FARG_numToString_cadena+0 
	MOVLW       hi_addr(_ticketFolio+0)
	MOVWF       FARG_numToString_cadena+1 
	MOVLW       7
	MOVWF       FARG_numToString_digitos+0 
	CALL        _numToString+0, 0
;Expendedora.c,1033 :: 		DS1307_read(&myRTC, true);                //Obtiene la hora actual
	MOVLW       _myRTC+0
	MOVWF       FARG_DS1307_read_myDS+0 
	MOVLW       hi_addr(_myRTC+0)
	MOVWF       FARG_DS1307_read_myDS+1 
	MOVLW       1
	MOVWF       FARG_DS1307_read_formatComplet+0 
	CALL        _DS1307_read+0, 0
;Expendedora.c,1034 :: 		string_cpy(ticketTime, &myRTC.time[2]);
	MOVLW       _ticketTime+0
	MOVWF       FARG_string_cpy_destino+0 
	MOVLW       hi_addr(_ticketTime+0)
	MOVWF       FARG_string_cpy_destino+1 
	MOVLW       _myRTC+9
	MOVWF       FARG_string_cpy_origen+0 
	MOVLW       hi_addr(_myRTC+9)
	MOVWF       FARG_string_cpy_origen+1 
	CALL        _string_cpy+0, 0
;Expendedora.c,1036 :: 		DS1307_read(&myRTC, false);                //Obtiene la hora actual
	MOVLW       _myRTC+0
	MOVWF       FARG_DS1307_read_myDS+0 
	MOVLW       hi_addr(_myRTC+0)
	MOVWF       FARG_DS1307_read_myDS+1 
	CLRF        FARG_DS1307_read_formatComplet+0 
	CALL        _DS1307_read+0, 0
;Expendedora.c,1037 :: 		string_cpy(ticketCodigo, &myRTC.time[1]);  //B:13, W-HH:MM:SS DD/MT/YY
	MOVLW       _ticketCodigo+0
	MOVWF       FARG_string_cpy_destino+0 
	MOVLW       hi_addr(_ticketCodigo+0)
	MOVWF       FARG_string_cpy_destino+1 
	MOVLW       _myRTC+8
	MOVWF       FARG_string_cpy_origen+0 
	MOVLW       hi_addr(_myRTC+8)
	MOVWF       FARG_string_cpy_origen+1 
	CALL        _string_cpy+0, 0
;Expendedora.c,1038 :: 		string_cpy(tiempoEvento, &myRTC.time[1]);
	MOVLW       expendedora_imprimir_tiempoEvento_L0+0
	MOVWF       FARG_string_cpy_destino+0 
	MOVLW       hi_addr(expendedora_imprimir_tiempoEvento_L0+0)
	MOVWF       FARG_string_cpy_destino+1 
	MOVLW       _myRTC+8
	MOVWF       FARG_string_cpy_origen+0 
	MOVLW       hi_addr(_myRTC+8)
	MOVWF       FARG_string_cpy_origen+1 
	CALL        _string_cpy+0, 0
;Expendedora.c,1040 :: 		string_pop(ticketCodigo);
	MOVLW       _ticketCodigo+0
	MOVWF       FARG_string_pop_texto+0 
	MOVLW       hi_addr(_ticketCodigo+0)
	MOVWF       FARG_string_pop_texto+1 
	CALL        _string_pop+0, 0
;Expendedora.c,1041 :: 		string_pop(ticketCodigo);
	MOVLW       _ticketCodigo+0
	MOVWF       FARG_string_pop_texto+0 
	MOVLW       hi_addr(_ticketCodigo+0)
	MOVWF       FARG_string_pop_texto+1 
	CALL        _string_pop+0, 0
;Expendedora.c,1042 :: 		numToString(myRTC.year, msjConst, 3);
	MOVF        _myRTC+6, 0 
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
;Expendedora.c,1043 :: 		string_add(ticketCodigo, msjConst);
	MOVLW       _ticketCodigo+0
	MOVWF       FARG_string_add_destino+0 
	MOVLW       hi_addr(_ticketCodigo+0)
	MOVWF       FARG_string_add_destino+1 
	MOVLW       _msjConst+0
	MOVWF       FARG_string_add_addEnd+0 
	MOVLW       hi_addr(_msjConst+0)
	MOVWF       FARG_string_add_addEnd+1 
	CALL        _string_add+0, 0
;Expendedora.c,1044 :: 		string_push(ticketCodigo, '1');
	MOVLW       _ticketCodigo+0
	MOVWF       FARG_string_push_texto+0 
	MOVLW       hi_addr(_ticketCodigo+0)
	MOVWF       FARG_string_push_texto+1 
	MOVLW       49
	MOVWF       FARG_string_push_caracter+0 
	CALL        _string_push+0, 0
;Expendedora.c,1045 :: 		string_add(ticketCodigo, ticketFolio);     //B:7
	MOVLW       _ticketCodigo+0
	MOVWF       FARG_string_add_destino+0 
	MOVLW       hi_addr(_ticketCodigo+0)
	MOVWF       FARG_string_add_destino+1 
	MOVLW       _ticketFolio+0
	MOVWF       FARG_string_add_addEnd+0 
	MOVLW       hi_addr(_ticketFolio+0)
	MOVWF       FARG_string_add_addEnd+1 
	CALL        _string_add+0, 0
;Expendedora.c,1046 :: 		string_addc(ticketCodigo, convenio);
	MOVLW       _ticketCodigo+0
	MOVWF       FARG_string_addc_destino+0 
	MOVLW       hi_addr(_ticketCodigo+0)
	MOVWF       FARG_string_addc_destino+1 
	MOVLW       expendedora_imprimir_convenio_L0+0
	MOVWF       FARG_string_addc_addEnd+0 
	MOVLW       hi_addr(expendedora_imprimir_convenio_L0+0)
	MOVWF       FARG_string_addc_addEnd+1 
	MOVLW       higher_addr(expendedora_imprimir_convenio_L0+0)
	MOVWF       FARG_string_addc_addEnd+2 
	CALL        _string_addc+0, 0
;Expendedora.c,1051 :: 		encrypt_basic(ticketCodigo);
	MOVLW       _ticketCodigo+0
	MOVWF       FARG_encrypt_basic_cadena+0 
	MOVLW       hi_addr(_ticketCodigo+0)
	MOVWF       FARG_encrypt_basic_cadena+1 
	CALL        _encrypt_basic+0, 0
;Expendedora.c,1054 :: 		mysql_write(tableFolio, folioTotal, 1, folio, false);
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
	MOVF        _folio+0, 0 
	MOVWF       FARG_mysql_write_value+0 
	MOVF        _folio+1, 0 
	MOVWF       FARG_mysql_write_value+1 
	MOVF        _folio+2, 0 
	MOVWF       FARG_mysql_write_value+2 
	MOVF        _folio+3, 0 
	MOVWF       FARG_mysql_write_value+3 
	CLRF        FARG_mysql_write_endWrite+0 
	CALL        _mysql_write+0, 0
;Expendedora.c,1059 :: 		}
L_expendedora_imprimir734:
;Expendedora.c,1060 :: 		}
L_expendedora_imprimir731:
;Expendedora.c,1063 :: 		if(imprimir){
	MOVF        expendedora_imprimir_imprimir_L0+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_expendedora_imprimir736
;Expendedora.c,1065 :: 		if(imprimir.B0){
	BTFSS       expendedora_imprimir_imprimir_L0+0, 0 
	GOTO        L_expendedora_imprimir737
;Expendedora.c,1066 :: 		if(expendedora_ticket()){
	CALL        _expendedora_ticket+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_expendedora_imprimir738
;Expendedora.c,1067 :: 		imprimir.B0 = false;
	BCF         expendedora_imprimir_imprimir_L0+0, 0 
;Expendedora.c,1068 :: 		lcd_clean_row(3);
	MOVLW       3
	MOVWF       FARG_lcd_clean_row_fila+0 
	CALL        _lcd_clean_row+0, 0
;Expendedora.c,1069 :: 		lcd_out(3, 4, "Tome su boleto");
	MOVLW       3
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       4
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr25_Expendedora+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr25_Expendedora+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;Expendedora.c,1074 :: 		abrirBarrera = true;
	MOVLW       1
	MOVWF       _abrirBarrera+0 
;Expendedora.c,1075 :: 		SALIDA_RELE1 = 1;
	BSF         PORTA+0, 5 
;Expendedora.c,1076 :: 		SALIDA_RELE2 = 1;
	BSF         PORTE+0, 0 
;Expendedora.c,1077 :: 		timer1_reset();
	CALL        _timer1_reset+0, 0
;Expendedora.c,1078 :: 		timer1_enable(true);
	MOVLW       1
	MOVWF       FARG_timer1_enable_enable+0 
	CALL        _timer1_enable+0, 0
;Expendedora.c,1080 :: 		string_cpyc(canCommand, CAN_TPV);      //TPV
	MOVLW       _canCommand+0
	MOVWF       FARG_string_cpyc_destino+0 
	MOVLW       hi_addr(_canCommand+0)
	MOVWF       FARG_string_cpyc_destino+1 
	MOVLW       _CAN_TPV+0
	MOVWF       FARG_string_cpyc_origen+0 
	MOVLW       hi_addr(_CAN_TPV+0)
	MOVWF       FARG_string_cpyc_origen+1 
	MOVLW       higher_addr(_CAN_TPV+0)
	MOVWF       FARG_string_cpyc_origen+2 
	CALL        _string_cpyc+0, 0
;Expendedora.c,1081 :: 		string_addc(canCommand, CAN_FOL);      //FOL
	MOVLW       _canCommand+0
	MOVWF       FARG_string_addc_destino+0 
	MOVLW       hi_addr(_canCommand+0)
	MOVWF       FARG_string_addc_destino+1 
	MOVLW       _CAN_FOL+0
	MOVWF       FARG_string_addc_addEnd+0 
	MOVLW       hi_addr(_CAN_FOL+0)
	MOVWF       FARG_string_addc_addEnd+1 
	MOVLW       higher_addr(_CAN_FOL+0)
	MOVWF       FARG_string_addc_addEnd+2 
	CALL        _string_addc+0, 0
;Expendedora.c,1082 :: 		numToHex(folio, ticketFolio, 4);
	MOVF        _folio+0, 0 
	MOVWF       FARG_numToHex_valor+0 
	MOVF        _folio+1, 0 
	MOVWF       FARG_numToHex_valor+1 
	MOVF        _folio+2, 0 
	MOVWF       FARG_numToHex_valor+2 
	MOVF        _folio+3, 0 
	MOVWF       FARG_numToHex_valor+3 
	MOVLW       _ticketFolio+0
	MOVWF       FARG_numToHex_cadena+0 
	MOVLW       hi_addr(_ticketFolio+0)
	MOVWF       FARG_numToHex_cadena+1 
	MOVLW       4
	MOVWF       FARG_numToHex_bytes+0 
	CALL        _numToHex+0, 0
;Expendedora.c,1083 :: 		string_add(canCommand, ticketFolio);   //FOL + FOL(HEX)
	MOVLW       _canCommand+0
	MOVWF       FARG_string_add_destino+0 
	MOVLW       hi_addr(_canCommand+0)
	MOVWF       FARG_string_add_destino+1 
	MOVLW       _ticketFolio+0
	MOVWF       FARG_string_add_addEnd+0 
	MOVLW       hi_addr(_ticketFolio+0)
	MOVWF       FARG_string_add_addEnd+1 
	CALL        _string_add+0, 0
;Expendedora.c,1086 :: 		string_add(canCommand, tiempoEvento);
	MOVLW       _canCommand+0
	MOVWF       FARG_string_add_destino+0 
	MOVLW       hi_addr(_canCommand+0)
	MOVWF       FARG_string_add_destino+1 
	MOVLW       expendedora_imprimir_tiempoEvento_L0+0
	MOVWF       FARG_string_add_addEnd+0 
	MOVLW       hi_addr(expendedora_imprimir_tiempoEvento_L0+0)
	MOVWF       FARG_string_add_addEnd+1 
	CALL        _string_add+0, 0
;Expendedora.c,1087 :: 		string_addc(canCommand, CAN_MODULE);   //FOL + FOL(HEX) + DATE + E
	MOVLW       _canCommand+0
	MOVWF       FARG_string_addc_destino+0 
	MOVLW       hi_addr(_canCommand+0)
	MOVWF       FARG_string_addc_destino+1 
	MOVLW       _CAN_MODULE+0
	MOVWF       FARG_string_addc_addEnd+0 
	MOVLW       hi_addr(_CAN_MODULE+0)
	MOVWF       FARG_string_addc_addEnd+1 
	MOVLW       higher_addr(_CAN_MODULE+0)
	MOVWF       FARG_string_addc_addEnd+2 
	CALL        _string_addc+0, 0
;Expendedora.c,1088 :: 		numToHex(canId, msjConst, 1);          //CONVIERTE EL NODO EN NUM
	MOVF        _canId+0, 0 
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
;Expendedora.c,1089 :: 		string_add(canCommand, msjConst);      //FOL + FOL(HEX) + DATE + E + ID(HEX)
	MOVLW       _canCommand+0
	MOVWF       FARG_string_add_destino+0 
	MOVLW       hi_addr(_canCommand+0)
	MOVWF       FARG_string_add_destino+1 
	MOVLW       _msjConst+0
	MOVWF       FARG_string_add_addEnd+0 
	MOVLW       hi_addr(_msjConst+0)
	MOVWF       FARG_string_add_addEnd+1 
	CALL        _string_add+0, 0
;Expendedora.c,1091 :: 		buffer_save_send(false, canCommand);
	CLRF        FARG_buffer_save_send_guardar+0 
	MOVLW       _canCommand+0
	MOVWF       FARG_buffer_save_send_buffer+0 
	MOVLW       hi_addr(_canCommand+0)
	MOVWF       FARG_buffer_save_send_buffer+1 
	CALL        _buffer_save_send+0, 0
;Expendedora.c,1092 :: 		}
L_expendedora_imprimir738:
;Expendedora.c,1093 :: 		}
L_expendedora_imprimir737:
;Expendedora.c,1095 :: 		if(imprimir.B1){
	BTFSS       expendedora_imprimir_imprimir_L0+0, 1 
	GOTO        L_expendedora_imprimir739
;Expendedora.c,1096 :: 		if(!SENSOR_COCHE){
	BTFSC       PORTD+0, 0 
	GOTO        L_expendedora_imprimir740
;Expendedora.c,1097 :: 		imprimir.B1 = false;
	BCF         expendedora_imprimir_imprimir_L0+0, 1 
;Expendedora.c,1098 :: 		delay_ms(50);        //Posible delay por los sensores
	MOVLW       163
	MOVWF       R12, 0
	MOVLW       85
	MOVWF       R13, 0
L_expendedora_imprimir741:
	DECFSZ      R13, 1, 1
	BRA         L_expendedora_imprimir741
	DECFSZ      R12, 1, 1
	BRA         L_expendedora_imprimir741
;Expendedora.c,1099 :: 		}
L_expendedora_imprimir740:
;Expendedora.c,1100 :: 		}
L_expendedora_imprimir739:
;Expendedora.c,1101 :: 		}
L_expendedora_imprimir736:
;Expendedora.c,1102 :: 		}
L_end_expendedora_imprimir:
	RETURN      0
; end of _expendedora_imprimir

_expendedora_ticket:

;Expendedora.c,1104 :: 		bool expendedora_ticket(){
;Expendedora.c,1107 :: 		char cont = 0;
	CLRF        expendedora_ticket_cont_L0+0 
;Expendedora.c,1110 :: 		cont = 0;
	CLRF        expendedora_ticket_cont_L0+0 
;Expendedora.c,1124 :: 		while(ticket[puntero] != 0){
L_expendedora_ticket742:
	MOVLW       _ticket+0
	ADDWF       expendedora_ticket_puntero_L0+0, 0 
	MOVWF       TBLPTRL 
	MOVLW       hi_addr(_ticket+0)
	ADDWFC      expendedora_ticket_puntero_L0+1, 0 
	MOVWF       TBLPTRH 
	MOVLW       higher_addr(_ticket+0)
	MOVWF       TBLPTRU 
	MOVLW       0
	ADDWFC      TBLPTRU, 1 
	TBLRD*+
	MOVFF       TABLAT+0, R1
	MOVF        R1, 0 
	XORLW       0
	BTFSC       STATUS+0, 2 
	GOTO        L_expendedora_ticket743
;Expendedora.c,1125 :: 		buffer[cont++] = ticket[puntero++];
	MOVLW       expendedora_ticket_buffer_L0+0
	MOVWF       FSR1 
	MOVLW       hi_addr(expendedora_ticket_buffer_L0+0)
	MOVWF       FSR1H 
	MOVF        expendedora_ticket_cont_L0+0, 0 
	ADDWF       FSR1, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR1H, 1 
	MOVLW       _ticket+0
	ADDWF       expendedora_ticket_puntero_L0+0, 0 
	MOVWF       TBLPTRL 
	MOVLW       hi_addr(_ticket+0)
	ADDWFC      expendedora_ticket_puntero_L0+1, 0 
	MOVWF       TBLPTRH 
	MOVLW       higher_addr(_ticket+0)
	MOVWF       TBLPTRU 
	MOVLW       0
	ADDWFC      TBLPTRU, 1 
	TBLRD*+
	MOVFF       TABLAT+0, R0
	MOVF        R0, 0 
	MOVWF       POSTINC1+0 
	INCF        expendedora_ticket_cont_L0+0, 1 
	INFSNZ      expendedora_ticket_puntero_L0+0, 1 
	INCF        expendedora_ticket_puntero_L0+1, 1 
;Expendedora.c,1127 :: 		if(buffer[cont-1] == '\n')
	DECF        expendedora_ticket_cont_L0+0, 0 
	MOVWF       R0 
	CLRF        R1 
	MOVLW       0
	SUBWFB      R1, 1 
	MOVLW       expendedora_ticket_buffer_L0+0
	ADDWF       R0, 0 
	MOVWF       FSR0 
	MOVLW       hi_addr(expendedora_ticket_buffer_L0+0)
	ADDWFC      R1, 0 
	MOVWF       FSR0H 
	MOVF        POSTINC0+0, 0 
	XORLW       10
	BTFSS       STATUS+0, 2 
	GOTO        L_expendedora_ticket744
;Expendedora.c,1128 :: 		break;
	GOTO        L_expendedora_ticket743
L_expendedora_ticket744:
;Expendedora.c,1129 :: 		}
	GOTO        L_expendedora_ticket742
L_expendedora_ticket743:
;Expendedora.c,1131 :: 		buffer[cont] = 0;
	MOVLW       expendedora_ticket_buffer_L0+0
	MOVWF       FSR1 
	MOVLW       hi_addr(expendedora_ticket_buffer_L0+0)
	MOVWF       FSR1H 
	MOVF        expendedora_ticket_cont_L0+0, 0 
	ADDWF       FSR1, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR1H, 1 
	CLRF        POSTINC1+0 
;Expendedora.c,1133 :: 		impresoraTerm_writeDinamicText(buffer, ticketAddr);
	MOVLW       expendedora_ticket_buffer_L0+0
	MOVWF       FARG_impresoraTerm_writeDinamicText_texto+0 
	MOVLW       hi_addr(expendedora_ticket_buffer_L0+0)
	MOVWF       FARG_impresoraTerm_writeDinamicText_texto+1 
	MOVLW       _ticketAddr+0
	MOVWF       FARG_impresoraTerm_writeDinamicText_address+0 
	MOVLW       hi_addr(_ticketAddr+0)
	MOVWF       FARG_impresoraTerm_writeDinamicText_address+1 
	MOVLW       higher_addr(_ticketAddr+0)
	MOVWF       FARG_impresoraTerm_writeDinamicText_address+2 
	CALL        _impresoraTerm_writeDinamicText+0, 0
;Expendedora.c,1136 :: 		if(ticket[puntero] == 0/*puntero == myTable.rowAct-1 || puntero == myTable.rowAct*/){
	MOVLW       _ticket+0
	ADDWF       expendedora_ticket_puntero_L0+0, 0 
	MOVWF       TBLPTRL 
	MOVLW       hi_addr(_ticket+0)
	ADDWFC      expendedora_ticket_puntero_L0+1, 0 
	MOVWF       TBLPTRH 
	MOVLW       higher_addr(_ticket+0)
	MOVWF       TBLPTRU 
	MOVLW       0
	ADDWFC      TBLPTRU, 1 
	TBLRD*+
	MOVFF       TABLAT+0, R1
	MOVF        R1, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_expendedora_ticket745
;Expendedora.c,1137 :: 		puntero = 0;
	CLRF        expendedora_ticket_puntero_L0+0 
	CLRF        expendedora_ticket_puntero_L0+1 
;Expendedora.c,1138 :: 		return true;
	MOVLW       1
	MOVWF       R0 
	GOTO        L_end_expendedora_ticket
;Expendedora.c,1139 :: 		}
L_expendedora_ticket745:
;Expendedora.c,1141 :: 		return false;
	CLRF        R0 
;Expendedora.c,1142 :: 		}
L_end_expendedora_ticket:
	RETURN      0
; end of _expendedora_ticket

_expendedora_bufferEventos:

;Expendedora.c,1144 :: 		void expendedora_bufferEventos(){
;Expendedora.c,1149 :: 		if(!pilaBufferCAN || !can.conected)
	MOVF        _pilaBufferCAN+0, 0 
	IORWF       _pilaBufferCAN+1, 0 
	BTFSC       STATUS+0, 2 
	GOTO        L__expendedora_bufferEventos983
	MOVF        _can+13, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L__expendedora_bufferEventos983
	GOTO        L_expendedora_bufferEventos748
L__expendedora_bufferEventos983:
;Expendedora.c,1150 :: 		return;
	GOTO        L_end_expendedora_bufferEventos
L_expendedora_bufferEventos748:
;Expendedora.c,1153 :: 		if(!can.txQueu && !can.rxBusy && !modeBufferEventos){
	MOVF        _can+33, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_expendedora_bufferEventos751
	MOVF        _can+106, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_expendedora_bufferEventos751
	MOVF        _modeBufferEventos+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_expendedora_bufferEventos751
L__expendedora_bufferEventos982:
;Expendedora.c,1155 :: 		if(!mysql_read_forced(tableEventosCAN, eventosEstatus, pilaBufferPointer, &estatus)){
	MOVLW       _tableEventosCAN+0
	MOVWF       FARG_mysql_read_forced_name+0 
	MOVLW       hi_addr(_tableEventosCAN+0)
	MOVWF       FARG_mysql_read_forced_name+1 
	MOVLW       _eventosEstatus+0
	MOVWF       FARG_mysql_read_forced_column+0 
	MOVLW       hi_addr(_eventosEstatus+0)
	MOVWF       FARG_mysql_read_forced_column+1 
	MOVF        _pilaBufferPointer+0, 0 
	MOVWF       FARG_mysql_read_forced_fila+0 
	MOVF        _pilaBufferPointer+1, 0 
	MOVWF       FARG_mysql_read_forced_fila+1 
	MOVLW       expendedora_bufferEventos_estatus_L0+0
	MOVWF       FARG_mysql_read_forced_result+0 
	MOVLW       hi_addr(expendedora_bufferEventos_estatus_L0+0)
	MOVWF       FARG_mysql_read_forced_result+1 
	CALL        _mysql_read_forced+0, 0
	MOVF        R0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_expendedora_bufferEventos752
;Expendedora.c,1165 :: 		if(estatus == '1'){  //Data no enviada
	MOVF        expendedora_bufferEventos_estatus_L0+0, 0 
	XORLW       49
	BTFSS       STATUS+0, 2 
	GOTO        L_expendedora_bufferEventos753
;Expendedora.c,1166 :: 		mysql_read_string(tableEventosCAN, eventosRegistro, pilaBufferPointer, bufferEeprom);
	MOVLW       _tableEventosCAN+0
	MOVWF       FARG_mysql_read_string_name+0 
	MOVLW       hi_addr(_tableEventosCAN+0)
	MOVWF       FARG_mysql_read_string_name+1 
	MOVLW       _eventosRegistro+0
	MOVWF       FARG_mysql_read_string_column+0 
	MOVLW       hi_addr(_eventosRegistro+0)
	MOVWF       FARG_mysql_read_string_column+1 
	MOVF        _pilaBufferPointer+0, 0 
	MOVWF       FARG_mysql_read_string_fila+0 
	MOVF        _pilaBufferPointer+1, 0 
	MOVWF       FARG_mysql_read_string_fila+1 
	MOVLW       _bufferEeprom+0
	MOVWF       FARG_mysql_read_string_result+0 
	MOVLW       hi_addr(_bufferEeprom+0)
	MOVWF       FARG_mysql_read_string_result+1 
	CALL        _mysql_read_string+0, 0
;Expendedora.c,1168 :: 		if(can_write_text(can.ip+canIdTPV, bufferEeprom, 0)){
	MOVF        _can+0, 0 
	MOVWF       FARG_can_write_text_ipAddress+0 
	MOVF        _can+1, 0 
	MOVWF       FARG_can_write_text_ipAddress+1 
	MOVF        _can+2, 0 
	MOVWF       FARG_can_write_text_ipAddress+2 
	MOVF        _can+3, 0 
	MOVWF       FARG_can_write_text_ipAddress+3 
	MOVLW       _bufferEeprom+0
	MOVWF       FARG_can_write_text_texto+0 
	MOVLW       hi_addr(_bufferEeprom+0)
	MOVWF       FARG_can_write_text_texto+1 
	CLRF        FARG_can_write_text_priority+0 
	CALL        _can_write_text+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_expendedora_bufferEventos754
;Expendedora.c,1169 :: 		modeBufferEventos = true;
	MOVLW       1
	MOVWF       _modeBufferEventos+0 
;Expendedora.c,1170 :: 		}
L_expendedora_bufferEventos754:
;Expendedora.c,1179 :: 		return;
	GOTO        L_end_expendedora_bufferEventos
;Expendedora.c,1180 :: 		}
L_expendedora_bufferEventos753:
;Expendedora.c,1181 :: 		}
L_expendedora_bufferEventos752:
;Expendedora.c,1183 :: 		pilaBufferPointer = clamp_shift(++pilaBufferPointer, 1, myTable.row);
	INFSNZ      _pilaBufferPointer+0, 1 
	INCF        _pilaBufferPointer+1, 1 
	MOVF        _pilaBufferPointer+0, 0 
	MOVWF       FARG_clamp_shift_valor+0 
	MOVF        _pilaBufferPointer+1, 0 
	MOVWF       FARG_clamp_shift_valor+1 
	MOVLW       0
	BTFSC       _pilaBufferPointer+1, 7 
	MOVLW       255
	MOVWF       FARG_clamp_shift_valor+2 
	MOVWF       FARG_clamp_shift_valor+3 
	MOVLW       1
	MOVWF       FARG_clamp_shift_min+0 
	MOVLW       0
	MOVWF       FARG_clamp_shift_min+1 
	MOVWF       FARG_clamp_shift_min+2 
	MOVWF       FARG_clamp_shift_min+3 
	MOVF        Expendedora_myTable+2, 0 
	MOVWF       FARG_clamp_shift_max+0 
	MOVF        Expendedora_myTable+3, 0 
	MOVWF       FARG_clamp_shift_max+1 
	MOVLW       0
	MOVWF       FARG_clamp_shift_max+2 
	MOVWF       FARG_clamp_shift_max+3 
	CALL        _clamp_shift+0, 0
	MOVF        R0, 0 
	MOVWF       _pilaBufferPointer+0 
	MOVF        R1, 0 
	MOVWF       _pilaBufferPointer+1 
;Expendedora.c,1184 :: 		}
L_expendedora_bufferEventos751:
;Expendedora.c,1185 :: 		}
L_end_expendedora_bufferEventos:
	RETURN      0
; end of _expendedora_bufferEventos

_lcd_clean_row:

;Expendedora.c,1189 :: 		void lcd_clean_row(char fila){
;Expendedora.c,1190 :: 		char i = 20;
	MOVLW       20
	MOVWF       lcd_clean_row_i_L0+0 
;Expendedora.c,1192 :: 		while(i)
L_lcd_clean_row755:
	MOVF        lcd_clean_row_i_L0+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_lcd_clean_row756
;Expendedora.c,1193 :: 		lcd_chr(fila, i--, ' ');
	MOVF        FARG_lcd_clean_row_fila+0, 0 
	MOVWF       FARG_Lcd_Chr_row+0 
	MOVF        lcd_clean_row_i_L0+0, 0 
	MOVWF       FARG_Lcd_Chr_column+0 
	MOVLW       32
	MOVWF       FARG_Lcd_Chr_out_char+0 
	CALL        _Lcd_Chr+0, 0
	DECF        lcd_clean_row_i_L0+0, 1 
	GOTO        L_lcd_clean_row755
L_lcd_clean_row756:
;Expendedora.c,1194 :: 		}
L_end_lcd_clean_row:
	RETURN      0
; end of _lcd_clean_row

_can_user_read_message:

;Expendedora.c,1196 :: 		void can_user_read_message(){
;Expendedora.c,1211 :: 		limpiarLCD = true;
	MOVLW       1
	MOVWF       _limpiarLCD+0 
;Expendedora.c,1212 :: 		tempLCD = 0;
	CLRF        _tempLCD+0 
;Expendedora.c,1213 :: 		lcd_clean_row(3);
	MOVLW       3
	MOVWF       FARG_lcd_clean_row_fila+0 
	CALL        _lcd_clean_row+0, 0
;Expendedora.c,1214 :: 		lcd_out(3,17,"MSG");
	MOVLW       3
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       17
	MOVWF       FARG_Lcd_Out_column+0 
	MOVLW       ?lstr26_Expendedora+0
	MOVWF       FARG_Lcd_Out_text+0 
	MOVLW       hi_addr(?lstr26_Expendedora+0)
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;Expendedora.c,1217 :: 		sizeTotal = 0;
	CLRF        can_user_read_message_sizeTotal_L0+0 
;Expendedora.c,1218 :: 		sizeKey = sizeof(CAN_PENSIONADO)-1;  //PENSIONADO: PEN+ID(HEX)+CMD+FILA+MENSAJE
	MOVLW       3
	MOVWF       can_user_read_message_sizeKey_L0+0 
;Expendedora.c,1219 :: 		if(string_cmpnc(CAN_PENSIONADO, &can.rxBuffer[sizeTotal], sizeKey)){
	MOVLW       _CAN_PENSIONADO+0
	MOVWF       FARG_string_cmpnc_text1+0 
	MOVLW       hi_addr(_CAN_PENSIONADO+0)
	MOVWF       FARG_string_cmpnc_text1+1 
	MOVLW       higher_addr(_CAN_PENSIONADO+0)
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
	GOTO        L_can_user_read_message757
;Expendedora.c,1221 :: 		sizeTotal += sizeKey;
	MOVF        can_user_read_message_sizeKey_L0+0, 0 
	ADDWF       can_user_read_message_sizeTotal_L0+0, 0 
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       can_user_read_message_sizeTotal_L0+0 
;Expendedora.c,1222 :: 		sizeKey = 6;  //3 Bytes en hexadecimal
	MOVLW       6
	MOVWF       can_user_read_message_sizeKey_L0+0 
;Expendedora.c,1223 :: 		string_cpyn(msjConst, &can.rxBuffer[sizeTotal], sizeKey);
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
;Expendedora.c,1224 :: 		idConsulta = hexToNum(msjConst);
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
;Expendedora.c,1226 :: 		sizeTotal += sizeKey;
	MOVF        can_user_read_message_sizeKey_L0+0, 0 
	ADDWF       can_user_read_message_sizeTotal_L0+0, 0 
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       can_user_read_message_sizeTotal_L0+0 
;Expendedora.c,1227 :: 		sizeKey = sizeof(CAN_REGISTRAR)-1;  //COMANDO 3BYTES
	MOVLW       3
	MOVWF       can_user_read_message_sizeKey_L0+0 
;Expendedora.c,1229 :: 		string_cpyn(msjConst, &can.rxBuffer[sizeTotal+sizeKey], 4); //4 numeros fila
	MOVLW       _msjConst+0
	MOVWF       FARG_string_cpyn_destino+0 
	MOVLW       hi_addr(_msjConst+0)
	MOVWF       FARG_string_cpyn_destino+1 
	MOVLW       3
	ADDWF       R0, 1 
	CLRF        R1 
	MOVLW       0
	ADDWFC      R1, 1 
	MOVLW       _can+107
	ADDWF       R0, 0 
	MOVWF       FARG_string_cpyn_origen+0 
	MOVLW       hi_addr(_can+107)
	ADDWFC      R1, 0 
	MOVWF       FARG_string_cpyn_origen+1 
	MOVLW       4
	MOVWF       FARG_string_cpyn_size+0 
	CALL        _string_cpyn+0, 0
;Expendedora.c,1230 :: 		fila = stringToNum(msjConst);
	MOVLW       _msjConst+0
	MOVWF       FARG_stringToNum_cadena+0 
	MOVLW       hi_addr(_msjConst+0)
	MOVWF       FARG_stringToNum_cadena+1 
	CALL        _stringToNum+0, 0
	MOVF        R0, 0 
	MOVWF       can_user_read_message_fila_L0+0 
	MOVF        R1, 0 
	MOVWF       can_user_read_message_fila_L0+1 
;Expendedora.c,1232 :: 		if(string_cmpnc(CAN_REGISTRAR, &can.rxBuffer[sizeTotal], sizeKey)){
	MOVLW       _CAN_REGISTRAR+0
	MOVWF       FARG_string_cmpnc_text1+0 
	MOVLW       hi_addr(_CAN_REGISTRAR+0)
	MOVWF       FARG_string_cmpnc_text1+1 
	MOVLW       higher_addr(_CAN_REGISTRAR+0)
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
	GOTO        L_can_user_read_message758
;Expendedora.c,1234 :: 		sizeTotal += sizeKey;
	MOVF        can_user_read_message_sizeKey_L0+0, 0 
	ADDWF       can_user_read_message_sizeTotal_L0+0, 0 
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       can_user_read_message_sizeTotal_L0+0 
;Expendedora.c,1235 :: 		sizeKey = 4;  //4 POR LA FILA
	MOVLW       4
	MOVWF       can_user_read_message_sizeKey_L0+0 
;Expendedora.c,1237 :: 		idNew = idConsulta;
	MOVF        can_user_read_message_idConsulta_L0+0, 0 
	MOVWF       can_user_read_message_idNew_L0+0 
	MOVF        can_user_read_message_idConsulta_L0+1, 0 
	MOVWF       can_user_read_message_idNew_L0+1 
	MOVF        can_user_read_message_idConsulta_L0+2, 0 
	MOVWF       can_user_read_message_idNew_L0+2 
	MOVF        can_user_read_message_idConsulta_L0+3, 0 
	MOVWF       can_user_read_message_idNew_L0+3 
;Expendedora.c,1239 :: 		sizeTotal += sizeKey;
	MOVLW       4
	ADDWF       R0, 1 
	MOVF        R0, 0 
	MOVWF       can_user_read_message_sizeTotal_L0+0 
;Expendedora.c,1240 :: 		sizeKey = 1;  //1 Byte
	MOVLW       1
	MOVWF       can_user_read_message_sizeKey_L0+0 
;Expendedora.c,1241 :: 		vigencia = can.rxBuffer[sizeTotal];
	MOVLW       _can+107
	MOVWF       FSR0 
	MOVLW       hi_addr(_can+107)
	MOVWF       FSR0H 
	MOVF        R0, 0 
	ADDWF       FSR0, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR0H, 1 
	MOVF        POSTINC0+0, 0 
	MOVWF       can_user_read_message_vigencia_L0+0 
;Expendedora.c,1243 :: 		sizeTotal += sizeKey;
	INCF        R0, 1 
	MOVF        R0, 0 
	MOVWF       can_user_read_message_sizeTotal_L0+0 
;Expendedora.c,1244 :: 		sizeKey = 1;  //1 Byte
	MOVLW       1
	MOVWF       can_user_read_message_sizeKey_L0+0 
;Expendedora.c,1245 :: 		estatus = can.rxBuffer[sizeTotal];
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
;Expendedora.c,1247 :: 		if(mysql_read(tablePensionados, pensionadosID, fila, &id) == TABLE_RW_NO_EXIST_ROW){
	MOVLW       _tablePensionados+0
	MOVWF       FARG_mysql_read_name+0 
	MOVLW       hi_addr(_tablePensionados+0)
	MOVWF       FARG_mysql_read_name+1 
	MOVLW       _pensionadosID+0
	MOVWF       FARG_mysql_read_column+0 
	MOVLW       hi_addr(_pensionadosID+0)
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
	MOVF        R0, 0 
	XORLW       3
	BTFSS       STATUS+0, 2 
	GOTO        L_can_user_read_message759
;Expendedora.c,1248 :: 		if(fila == myTable.rowAct+1){
	MOVLW       1
	ADDWF       Expendedora_myTable+4, 0 
	MOVWF       R1 
	MOVLW       0
	ADDWFC      Expendedora_myTable+5, 0 
	MOVWF       R2 
	MOVF        can_user_read_message_fila_L0+1, 0 
	XORWF       R2, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__can_user_read_message1339
	MOVF        R1, 0 
	XORWF       can_user_read_message_fila_L0+0, 0 
L__can_user_read_message1339:
	BTFSS       STATUS+0, 2 
	GOTO        L_can_user_read_message760
;Expendedora.c,1249 :: 		if(!mysql_write(tablePensionados, pensionadosID, -1, idNew, true)){
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
	MOVF        can_user_read_message_idNew_L0+0, 0 
	MOVWF       FARG_mysql_write_value+0 
	MOVF        can_user_read_message_idNew_L0+1, 0 
	MOVWF       FARG_mysql_write_value+1 
	MOVF        can_user_read_message_idNew_L0+2, 0 
	MOVWF       FARG_mysql_write_value+2 
	MOVF        can_user_read_message_idNew_L0+3, 0 
	MOVWF       FARG_mysql_write_value+3 
	MOVLW       1
	MOVWF       FARG_mysql_write_endWrite+0 
	CALL        _mysql_write+0, 0
	MOVF        R0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_can_user_read_message761
;Expendedora.c,1253 :: 		mysql_write(tablePensionados, pensionadosID, fila, idNew, false);
	MOVLW       _tablePensionados+0
	MOVWF       FARG_mysql_write_name+0 
	MOVLW       hi_addr(_tablePensionados+0)
	MOVWF       FARG_mysql_write_name+1 
	MOVLW       _pensionadosID+0
	MOVWF       FARG_mysql_write_column+0 
	MOVLW       hi_addr(_pensionadosID+0)
	MOVWF       FARG_mysql_write_column+1 
	MOVF        can_user_read_message_fila_L0+0, 0 
	MOVWF       FARG_mysql_write_fila+0 
	MOVF        can_user_read_message_fila_L0+1, 0 
	MOVWF       FARG_mysql_write_fila+1 
	MOVF        can_user_read_message_idNew_L0+0, 0 
	MOVWF       FARG_mysql_write_value+0 
	MOVF        can_user_read_message_idNew_L0+1, 0 
	MOVWF       FARG_mysql_write_value+1 
	MOVF        can_user_read_message_idNew_L0+2, 0 
	MOVWF       FARG_mysql_write_value+2 
	MOVF        can_user_read_message_idNew_L0+3, 0 
	MOVWF       FARG_mysql_write_value+3 
	CLRF        FARG_mysql_write_endWrite+0 
	CALL        _mysql_write+0, 0
;Expendedora.c,1254 :: 		mysql_write(tablePensionados, pensionadosVigencia, fila, vigencia, false);
	MOVLW       _tablePensionados+0
	MOVWF       FARG_mysql_write_name+0 
	MOVLW       hi_addr(_tablePensionados+0)
	MOVWF       FARG_mysql_write_name+1 
	MOVLW       _pensionadosVigencia+0
	MOVWF       FARG_mysql_write_column+0 
	MOVLW       hi_addr(_pensionadosVigencia+0)
	MOVWF       FARG_mysql_write_column+1 
	MOVF        can_user_read_message_fila_L0+0, 0 
	MOVWF       FARG_mysql_write_fila+0 
	MOVF        can_user_read_message_fila_L0+1, 0 
	MOVWF       FARG_mysql_write_fila+1 
	MOVF        can_user_read_message_vigencia_L0+0, 0 
	MOVWF       FARG_mysql_write_value+0 
	MOVLW       0
	MOVWF       FARG_mysql_write_value+1 
	MOVWF       FARG_mysql_write_value+2 
	MOVWF       FARG_mysql_write_value+3 
	CLRF        FARG_mysql_write_endWrite+0 
	CALL        _mysql_write+0, 0
;Expendedora.c,1255 :: 		mysql_write(tablePensionados, pensionadosEstatus, fila, estatus, false);
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
;Expendedora.c,1256 :: 		}
L_can_user_read_message761:
;Expendedora.c,1257 :: 		}
L_can_user_read_message760:
;Expendedora.c,1258 :: 		}
L_can_user_read_message759:
;Expendedora.c,1259 :: 		}else if(string_cmpnc(CAN_ACTUALIZAR, &can.rxBuffer[sizeTotal], sizeKey)){
	GOTO        L_can_user_read_message762
L_can_user_read_message758:
	MOVLW       _CAN_ACTUALIZAR+0
	MOVWF       FARG_string_cmpnc_text1+0 
	MOVLW       hi_addr(_CAN_ACTUALIZAR+0)
	MOVWF       FARG_string_cmpnc_text1+1 
	MOVLW       higher_addr(_CAN_ACTUALIZAR+0)
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
	GOTO        L_can_user_read_message763
;Expendedora.c,1261 :: 		sizeTotal += sizeKey;
	MOVF        can_user_read_message_sizeKey_L0+0, 0 
	ADDWF       can_user_read_message_sizeTotal_L0+0, 0 
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       can_user_read_message_sizeTotal_L0+0 
;Expendedora.c,1262 :: 		sizeKey = 4;  //4 POR LA FILA
	MOVLW       4
	MOVWF       can_user_read_message_sizeKey_L0+0 
;Expendedora.c,1264 :: 		sizeTotal += sizeKey;
	MOVLW       4
	ADDWF       R0, 1 
	MOVF        R0, 0 
	MOVWF       can_user_read_message_sizeTotal_L0+0 
;Expendedora.c,1265 :: 		sizeKey = 6;  //3 Bytes en hexadecimal
	MOVLW       6
	MOVWF       can_user_read_message_sizeKey_L0+0 
;Expendedora.c,1266 :: 		string_cpyn(msjConst, &can.rxBuffer[sizeTotal], sizeKey);
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
;Expendedora.c,1267 :: 		idNew = hexToNum(msjConst);
	MOVLW       _msjConst+0
	MOVWF       FARG_hexToNum_hex+0 
	MOVLW       hi_addr(_msjConst+0)
	MOVWF       FARG_hexToNum_hex+1 
	CALL        _hexToNum+0, 0
	MOVF        R0, 0 
	MOVWF       can_user_read_message_idNew_L0+0 
	MOVF        R1, 0 
	MOVWF       can_user_read_message_idNew_L0+1 
	MOVF        R2, 0 
	MOVWF       can_user_read_message_idNew_L0+2 
	MOVF        R3, 0 
	MOVWF       can_user_read_message_idNew_L0+3 
;Expendedora.c,1269 :: 		sizeTotal += sizeKey;
	MOVF        can_user_read_message_sizeKey_L0+0, 0 
	ADDWF       can_user_read_message_sizeTotal_L0+0, 0 
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       can_user_read_message_sizeTotal_L0+0 
;Expendedora.c,1270 :: 		sizeKey = 1;  //1 Byte
	MOVLW       1
	MOVWF       can_user_read_message_sizeKey_L0+0 
;Expendedora.c,1271 :: 		vigencia = can.rxBuffer[sizeTotal];
	MOVLW       _can+107
	MOVWF       FSR0 
	MOVLW       hi_addr(_can+107)
	MOVWF       FSR0H 
	MOVF        R0, 0 
	ADDWF       FSR0, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR0H, 1 
	MOVF        POSTINC0+0, 0 
	MOVWF       can_user_read_message_vigencia_L0+0 
;Expendedora.c,1273 :: 		sizeTotal += sizeKey;
	INCF        R0, 1 
	MOVF        R0, 0 
	MOVWF       can_user_read_message_sizeTotal_L0+0 
;Expendedora.c,1274 :: 		sizeKey = 1;  //1 Byte
	MOVLW       1
	MOVWF       can_user_read_message_sizeKey_L0+0 
;Expendedora.c,1275 :: 		estatus = can.rxBuffer[sizeTotal];
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
;Expendedora.c,1278 :: 		if(!mysql_read(tablePensionados,pensionadosID, fila, &id)){
	MOVLW       _tablePensionados+0
	MOVWF       FARG_mysql_read_name+0 
	MOVLW       hi_addr(_tablePensionados+0)
	MOVWF       FARG_mysql_read_name+1 
	MOVLW       _pensionadosID+0
	MOVWF       FARG_mysql_read_column+0 
	MOVLW       hi_addr(_pensionadosID+0)
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
	GOTO        L_can_user_read_message764
;Expendedora.c,1279 :: 		if(id == idConsulta){
	MOVF        can_user_read_message_id_L0+3, 0 
	XORWF       can_user_read_message_idConsulta_L0+3, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__can_user_read_message1340
	MOVF        can_user_read_message_id_L0+2, 0 
	XORWF       can_user_read_message_idConsulta_L0+2, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__can_user_read_message1340
	MOVF        can_user_read_message_id_L0+1, 0 
	XORWF       can_user_read_message_idConsulta_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__can_user_read_message1340
	MOVF        can_user_read_message_id_L0+0, 0 
	XORWF       can_user_read_message_idConsulta_L0+0, 0 
L__can_user_read_message1340:
	BTFSS       STATUS+0, 2 
	GOTO        L_can_user_read_message765
;Expendedora.c,1283 :: 		mysql_write(tablePensionados, pensionadosID, fila, idNew, false);
	MOVLW       _tablePensionados+0
	MOVWF       FARG_mysql_write_name+0 
	MOVLW       hi_addr(_tablePensionados+0)
	MOVWF       FARG_mysql_write_name+1 
	MOVLW       _pensionadosID+0
	MOVWF       FARG_mysql_write_column+0 
	MOVLW       hi_addr(_pensionadosID+0)
	MOVWF       FARG_mysql_write_column+1 
	MOVF        can_user_read_message_fila_L0+0, 0 
	MOVWF       FARG_mysql_write_fila+0 
	MOVF        can_user_read_message_fila_L0+1, 0 
	MOVWF       FARG_mysql_write_fila+1 
	MOVF        can_user_read_message_idNew_L0+0, 0 
	MOVWF       FARG_mysql_write_value+0 
	MOVF        can_user_read_message_idNew_L0+1, 0 
	MOVWF       FARG_mysql_write_value+1 
	MOVF        can_user_read_message_idNew_L0+2, 0 
	MOVWF       FARG_mysql_write_value+2 
	MOVF        can_user_read_message_idNew_L0+3, 0 
	MOVWF       FARG_mysql_write_value+3 
	CLRF        FARG_mysql_write_endWrite+0 
	CALL        _mysql_write+0, 0
;Expendedora.c,1284 :: 		mysql_write(tablePensionados, pensionadosVigencia, fila, vigencia, false);
	MOVLW       _tablePensionados+0
	MOVWF       FARG_mysql_write_name+0 
	MOVLW       hi_addr(_tablePensionados+0)
	MOVWF       FARG_mysql_write_name+1 
	MOVLW       _pensionadosVigencia+0
	MOVWF       FARG_mysql_write_column+0 
	MOVLW       hi_addr(_pensionadosVigencia+0)
	MOVWF       FARG_mysql_write_column+1 
	MOVF        can_user_read_message_fila_L0+0, 0 
	MOVWF       FARG_mysql_write_fila+0 
	MOVF        can_user_read_message_fila_L0+1, 0 
	MOVWF       FARG_mysql_write_fila+1 
	MOVF        can_user_read_message_vigencia_L0+0, 0 
	MOVWF       FARG_mysql_write_value+0 
	MOVLW       0
	MOVWF       FARG_mysql_write_value+1 
	MOVWF       FARG_mysql_write_value+2 
	MOVWF       FARG_mysql_write_value+3 
	CLRF        FARG_mysql_write_endWrite+0 
	CALL        _mysql_write+0, 0
;Expendedora.c,1285 :: 		mysql_write(tablePensionados, pensionadosEstatus, fila, estatus, false);
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
;Expendedora.c,1286 :: 		}
L_can_user_read_message765:
;Expendedora.c,1287 :: 		}
L_can_user_read_message764:
;Expendedora.c,1288 :: 		}else if(string_cmpnc(CAN_VIGENCIA, &can.rxBuffer[sizeTotal], sizeKey)){
	GOTO        L_can_user_read_message766
L_can_user_read_message763:
	MOVLW       _CAN_VIGENCIA+0
	MOVWF       FARG_string_cmpnc_text1+0 
	MOVLW       hi_addr(_CAN_VIGENCIA+0)
	MOVWF       FARG_string_cmpnc_text1+1 
	MOVLW       higher_addr(_CAN_VIGENCIA+0)
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
	GOTO        L_can_user_read_message767
;Expendedora.c,1290 :: 		sizeTotal += sizeKey;
	MOVF        can_user_read_message_sizeKey_L0+0, 0 
	ADDWF       can_user_read_message_sizeTotal_L0+0, 0 
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       can_user_read_message_sizeTotal_L0+0 
;Expendedora.c,1291 :: 		sizeKey = 4;  //4 POR LA FILA
	MOVLW       4
	MOVWF       can_user_read_message_sizeKey_L0+0 
;Expendedora.c,1293 :: 		sizeTotal += sizeKey;
	MOVLW       4
	ADDWF       R0, 1 
	MOVF        R0, 0 
	MOVWF       can_user_read_message_sizeTotal_L0+0 
;Expendedora.c,1294 :: 		sizeKey = 1;  //1 Byte
	MOVLW       1
	MOVWF       can_user_read_message_sizeKey_L0+0 
;Expendedora.c,1295 :: 		vigencia = can.rxBuffer[sizeTotal];
	MOVLW       _can+107
	MOVWF       FSR0 
	MOVLW       hi_addr(_can+107)
	MOVWF       FSR0H 
	MOVF        R0, 0 
	ADDWF       FSR0, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR0H, 1 
	MOVF        POSTINC0+0, 0 
	MOVWF       can_user_read_message_vigencia_L0+0 
;Expendedora.c,1297 :: 		if(!mysql_read(tablePensionados,pensionadosID, fila, &id)){
	MOVLW       _tablePensionados+0
	MOVWF       FARG_mysql_read_name+0 
	MOVLW       hi_addr(_tablePensionados+0)
	MOVWF       FARG_mysql_read_name+1 
	MOVLW       _pensionadosID+0
	MOVWF       FARG_mysql_read_column+0 
	MOVLW       hi_addr(_pensionadosID+0)
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
	GOTO        L_can_user_read_message768
;Expendedora.c,1298 :: 		if(id == idConsulta){
	MOVF        can_user_read_message_id_L0+3, 0 
	XORWF       can_user_read_message_idConsulta_L0+3, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__can_user_read_message1341
	MOVF        can_user_read_message_id_L0+2, 0 
	XORWF       can_user_read_message_idConsulta_L0+2, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__can_user_read_message1341
	MOVF        can_user_read_message_id_L0+1, 0 
	XORWF       can_user_read_message_idConsulta_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__can_user_read_message1341
	MOVF        can_user_read_message_id_L0+0, 0 
	XORWF       can_user_read_message_idConsulta_L0+0, 0 
L__can_user_read_message1341:
	BTFSS       STATUS+0, 2 
	GOTO        L_can_user_read_message769
;Expendedora.c,1302 :: 		mysql_write(tablePensionados, pensionadosVigencia, fila, vigencia, false);
	MOVLW       _tablePensionados+0
	MOVWF       FARG_mysql_write_name+0 
	MOVLW       hi_addr(_tablePensionados+0)
	MOVWF       FARG_mysql_write_name+1 
	MOVLW       _pensionadosVigencia+0
	MOVWF       FARG_mysql_write_column+0 
	MOVLW       hi_addr(_pensionadosVigencia+0)
	MOVWF       FARG_mysql_write_column+1 
	MOVF        can_user_read_message_fila_L0+0, 0 
	MOVWF       FARG_mysql_write_fila+0 
	MOVF        can_user_read_message_fila_L0+1, 0 
	MOVWF       FARG_mysql_write_fila+1 
	MOVF        can_user_read_message_vigencia_L0+0, 0 
	MOVWF       FARG_mysql_write_value+0 
	MOVLW       0
	MOVWF       FARG_mysql_write_value+1 
	MOVWF       FARG_mysql_write_value+2 
	MOVWF       FARG_mysql_write_value+3 
	CLRF        FARG_mysql_write_endWrite+0 
	CALL        _mysql_write+0, 0
;Expendedora.c,1303 :: 		}
L_can_user_read_message769:
;Expendedora.c,1304 :: 		}
L_can_user_read_message768:
;Expendedora.c,1305 :: 		}else if(string_cmpnc(CAN_PASSBACK, &can.rxBuffer[sizeTotal], sizeKey)){
	GOTO        L_can_user_read_message770
L_can_user_read_message767:
	MOVLW       _CAN_PASSBACK+0
	MOVWF       FARG_string_cmpnc_text1+0 
	MOVLW       hi_addr(_CAN_PASSBACK+0)
	MOVWF       FARG_string_cmpnc_text1+1 
	MOVLW       higher_addr(_CAN_PASSBACK+0)
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
	GOTO        L_can_user_read_message771
;Expendedora.c,1307 :: 		sizeTotal += sizeKey;
	MOVF        can_user_read_message_sizeKey_L0+0, 0 
	ADDWF       can_user_read_message_sizeTotal_L0+0, 0 
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       can_user_read_message_sizeTotal_L0+0 
;Expendedora.c,1308 :: 		sizeKey = 4;  //4 POR LA FILA
	MOVLW       4
	MOVWF       can_user_read_message_sizeKey_L0+0 
;Expendedora.c,1310 :: 		sizeTotal += sizeKey;
	MOVLW       4
	ADDWF       R0, 1 
	MOVF        R0, 0 
	MOVWF       can_user_read_message_sizeTotal_L0+0 
;Expendedora.c,1311 :: 		sizeKey = 1;
	MOVLW       1
	MOVWF       can_user_read_message_sizeKey_L0+0 
;Expendedora.c,1312 :: 		estatus = can.rxBuffer[sizeTotal];
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
;Expendedora.c,1314 :: 		if(!mysql_read(tablePensionados, pensionadosID, fila, &id)){
	MOVLW       _tablePensionados+0
	MOVWF       FARG_mysql_read_name+0 
	MOVLW       hi_addr(_tablePensionados+0)
	MOVWF       FARG_mysql_read_name+1 
	MOVLW       _pensionadosID+0
	MOVWF       FARG_mysql_read_column+0 
	MOVLW       hi_addr(_pensionadosID+0)
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
	GOTO        L_can_user_read_message772
;Expendedora.c,1315 :: 		if(id == idConsulta){
	MOVF        can_user_read_message_id_L0+3, 0 
	XORWF       can_user_read_message_idConsulta_L0+3, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__can_user_read_message1342
	MOVF        can_user_read_message_id_L0+2, 0 
	XORWF       can_user_read_message_idConsulta_L0+2, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__can_user_read_message1342
	MOVF        can_user_read_message_id_L0+1, 0 
	XORWF       can_user_read_message_idConsulta_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__can_user_read_message1342
	MOVF        can_user_read_message_id_L0+0, 0 
	XORWF       can_user_read_message_idConsulta_L0+0, 0 
L__can_user_read_message1342:
	BTFSS       STATUS+0, 2 
	GOTO        L_can_user_read_message773
;Expendedora.c,1319 :: 		mysql_write(tablePensionados, pensionadosEstatus, fila, estatus, false);
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
;Expendedora.c,1320 :: 		}
L_can_user_read_message773:
;Expendedora.c,1321 :: 		}
L_can_user_read_message772:
;Expendedora.c,1322 :: 		}else if(string_cmpnc(CAN_CONSULTAR, &can.rxBuffer[sizeTotal], sizeKey)){
	GOTO        L_can_user_read_message774
L_can_user_read_message771:
	MOVLW       _CAN_CONSULTAR+0
	MOVWF       FARG_string_cmpnc_text1+0 
	MOVLW       hi_addr(_CAN_CONSULTAR+0)
	MOVWF       FARG_string_cmpnc_text1+1 
	MOVLW       higher_addr(_CAN_CONSULTAR+0)
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
	GOTO        L_can_user_read_message775
;Expendedora.c,1324 :: 		sizeTotal += sizeKey;
	MOVF        can_user_read_message_sizeKey_L0+0, 0 
	ADDWF       can_user_read_message_sizeTotal_L0+0, 1 
;Expendedora.c,1325 :: 		sizeKey = 4;  //4 POR LA FILA
	MOVLW       4
	MOVWF       can_user_read_message_sizeKey_L0+0 
;Expendedora.c,1327 :: 		string_cpyc(bufferEeprom, CAN_TPV);
	MOVLW       _bufferEeprom+0
	MOVWF       FARG_string_cpyc_destino+0 
	MOVLW       hi_addr(_bufferEeprom+0)
	MOVWF       FARG_string_cpyc_destino+1 
	MOVLW       _CAN_TPV+0
	MOVWF       FARG_string_cpyc_origen+0 
	MOVLW       hi_addr(_CAN_TPV+0)
	MOVWF       FARG_string_cpyc_origen+1 
	MOVLW       higher_addr(_CAN_TPV+0)
	MOVWF       FARG_string_cpyc_origen+2 
	CALL        _string_cpyc+0, 0
;Expendedora.c,1328 :: 		string_cpyn(&bufferEeprom[sizeof(CAN_TPV)-1], can.rxBuffer, sizeTotal);
	MOVLW       _bufferEeprom+3
	MOVWF       FARG_string_cpyn_destino+0 
	MOVLW       hi_addr(_bufferEeprom+3)
	MOVWF       FARG_string_cpyn_destino+1 
	MOVLW       _can+107
	MOVWF       FARG_string_cpyn_origen+0 
	MOVLW       hi_addr(_can+107)
	MOVWF       FARG_string_cpyn_origen+1 
	MOVF        can_user_read_message_sizeTotal_L0+0, 0 
	MOVWF       FARG_string_cpyn_size+0 
	CALL        _string_cpyn+0, 0
;Expendedora.c,1329 :: 		if(!mysql_read(tablePensionados, pensionadosID, fila, &id)){
	MOVLW       _tablePensionados+0
	MOVWF       FARG_mysql_read_name+0 
	MOVLW       hi_addr(_tablePensionados+0)
	MOVWF       FARG_mysql_read_name+1 
	MOVLW       _pensionadosID+0
	MOVWF       FARG_mysql_read_column+0 
	MOVLW       hi_addr(_pensionadosID+0)
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
	GOTO        L_can_user_read_message776
;Expendedora.c,1330 :: 		if(idConsulta == id){
	MOVF        can_user_read_message_idConsulta_L0+3, 0 
	XORWF       can_user_read_message_id_L0+3, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__can_user_read_message1343
	MOVF        can_user_read_message_idConsulta_L0+2, 0 
	XORWF       can_user_read_message_id_L0+2, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__can_user_read_message1343
	MOVF        can_user_read_message_idConsulta_L0+1, 0 
	XORWF       can_user_read_message_id_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__can_user_read_message1343
	MOVF        can_user_read_message_idConsulta_L0+0, 0 
	XORWF       can_user_read_message_id_L0+0, 0 
L__can_user_read_message1343:
	BTFSS       STATUS+0, 2 
	GOTO        L_can_user_read_message777
;Expendedora.c,1334 :: 		mysql_read_string(tablePensionados, pensionadosVigencia, fila, &vigencia);
	MOVLW       _tablePensionados+0
	MOVWF       FARG_mysql_read_string_name+0 
	MOVLW       hi_addr(_tablePensionados+0)
	MOVWF       FARG_mysql_read_string_name+1 
	MOVLW       _pensionadosVigencia+0
	MOVWF       FARG_mysql_read_string_column+0 
	MOVLW       hi_addr(_pensionadosVigencia+0)
	MOVWF       FARG_mysql_read_string_column+1 
	MOVF        can_user_read_message_fila_L0+0, 0 
	MOVWF       FARG_mysql_read_string_fila+0 
	MOVF        can_user_read_message_fila_L0+1, 0 
	MOVWF       FARG_mysql_read_string_fila+1 
	MOVLW       can_user_read_message_vigencia_L0+0
	MOVWF       FARG_mysql_read_string_result+0 
	MOVLW       hi_addr(can_user_read_message_vigencia_L0+0)
	MOVWF       FARG_mysql_read_string_result+1 
	CALL        _mysql_read_string+0, 0
;Expendedora.c,1335 :: 		mysql_read_string(tablePensionados, pensionadosEstatus, fila, &estatus);
	MOVLW       _tablePensionados+0
	MOVWF       FARG_mysql_read_string_name+0 
	MOVLW       hi_addr(_tablePensionados+0)
	MOVWF       FARG_mysql_read_string_name+1 
	MOVLW       _pensionadosEstatus+0
	MOVWF       FARG_mysql_read_string_column+0 
	MOVLW       hi_addr(_pensionadosEstatus+0)
	MOVWF       FARG_mysql_read_string_column+1 
	MOVF        can_user_read_message_fila_L0+0, 0 
	MOVWF       FARG_mysql_read_string_fila+0 
	MOVF        can_user_read_message_fila_L0+1, 0 
	MOVWF       FARG_mysql_read_string_fila+1 
	MOVLW       can_user_read_message_estatus_L0+0
	MOVWF       FARG_mysql_read_string_result+0 
	MOVLW       hi_addr(can_user_read_message_estatus_L0+0)
	MOVWF       FARG_mysql_read_string_result+1 
	CALL        _mysql_read_string+0, 0
;Expendedora.c,1337 :: 		string_push(bufferEeprom, vigencia);
	MOVLW       _bufferEeprom+0
	MOVWF       FARG_string_push_texto+0 
	MOVLW       hi_addr(_bufferEeprom+0)
	MOVWF       FARG_string_push_texto+1 
	MOVF        can_user_read_message_vigencia_L0+0, 0 
	MOVWF       FARG_string_push_caracter+0 
	CALL        _string_push+0, 0
;Expendedora.c,1338 :: 		string_push(bufferEeprom, estatus);
	MOVLW       _bufferEeprom+0
	MOVWF       FARG_string_push_texto+0 
	MOVLW       hi_addr(_bufferEeprom+0)
	MOVWF       FARG_string_push_texto+1 
	MOVF        can_user_read_message_estatus_L0+0, 0 
	MOVWF       FARG_string_push_caracter+0 
	CALL        _string_push+0, 0
;Expendedora.c,1339 :: 		string_addc(bufferEeprom, CAN_MODULE);
	MOVLW       _bufferEeprom+0
	MOVWF       FARG_string_addc_destino+0 
	MOVLW       hi_addr(_bufferEeprom+0)
	MOVWF       FARG_string_addc_destino+1 
	MOVLW       _CAN_MODULE+0
	MOVWF       FARG_string_addc_addEnd+0 
	MOVLW       hi_addr(_CAN_MODULE+0)
	MOVWF       FARG_string_addc_addEnd+1 
	MOVLW       higher_addr(_CAN_MODULE+0)
	MOVWF       FARG_string_addc_addEnd+2 
	CALL        _string_addc+0, 0
;Expendedora.c,1340 :: 		numToHex(can.id, msjConst, 1);
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
;Expendedora.c,1341 :: 		string_add(bufferEeprom, msjConst);
	MOVLW       _bufferEeprom+0
	MOVWF       FARG_string_add_destino+0 
	MOVLW       hi_addr(_bufferEeprom+0)
	MOVWF       FARG_string_add_destino+1 
	MOVLW       _msjConst+0
	MOVWF       FARG_string_add_addEnd+0 
	MOVLW       hi_addr(_msjConst+0)
	MOVWF       FARG_string_add_addEnd+1 
	CALL        _string_add+0, 0
;Expendedora.c,1342 :: 		}else{
	GOTO        L_can_user_read_message778
L_can_user_read_message777:
;Expendedora.c,1343 :: 		string_addc(bufferEeprom, CAN_TABLE_NO_FOUND);
	MOVLW       _bufferEeprom+0
	MOVWF       FARG_string_addc_destino+0 
	MOVLW       hi_addr(_bufferEeprom+0)
	MOVWF       FARG_string_addc_destino+1 
	MOVLW       _CAN_TABLE_NO_FOUND+0
	MOVWF       FARG_string_addc_addEnd+0 
	MOVLW       hi_addr(_CAN_TABLE_NO_FOUND+0)
	MOVWF       FARG_string_addc_addEnd+1 
	MOVLW       higher_addr(_CAN_TABLE_NO_FOUND+0)
	MOVWF       FARG_string_addc_addEnd+2 
	CALL        _string_addc+0, 0
;Expendedora.c,1344 :: 		}
L_can_user_read_message778:
;Expendedora.c,1345 :: 		}else{
	GOTO        L_can_user_read_message779
L_can_user_read_message776:
;Expendedora.c,1346 :: 		string_addc(bufferEeprom, CAN_TABLE_ERROR);
	MOVLW       _bufferEeprom+0
	MOVWF       FARG_string_addc_destino+0 
	MOVLW       hi_addr(_bufferEeprom+0)
	MOVWF       FARG_string_addc_destino+1 
	MOVLW       _CAN_TABLE_ERROR+0
	MOVWF       FARG_string_addc_addEnd+0 
	MOVLW       hi_addr(_CAN_TABLE_ERROR+0)
	MOVWF       FARG_string_addc_addEnd+1 
	MOVLW       higher_addr(_CAN_TABLE_ERROR+0)
	MOVWF       FARG_string_addc_addEnd+2 
	CALL        _string_addc+0, 0
;Expendedora.c,1347 :: 		}
L_can_user_read_message779:
;Expendedora.c,1349 :: 		buffer_save_send(true, bufferEeprom);
	MOVLW       1
	MOVWF       FARG_buffer_save_send_guardar+0 
	MOVLW       _bufferEeprom+0
	MOVWF       FARG_buffer_save_send_buffer+0 
	MOVLW       hi_addr(_bufferEeprom+0)
	MOVWF       FARG_buffer_save_send_buffer+1 
	CALL        _buffer_save_send+0, 0
;Expendedora.c,1350 :: 		}
L_can_user_read_message775:
L_can_user_read_message774:
L_can_user_read_message770:
L_can_user_read_message766:
L_can_user_read_message762:
;Expendedora.c,1351 :: 		}else if(string_cmpnc(CAN_RTC, &can.rxBuffer[sizeTotal], sizeKey)){
	GOTO        L_can_user_read_message780
L_can_user_read_message757:
	MOVLW       _CAN_RTC+0
	MOVWF       FARG_string_cmpnc_text1+0 
	MOVLW       hi_addr(_CAN_RTC+0)
	MOVWF       FARG_string_cmpnc_text1+1 
	MOVLW       higher_addr(_CAN_RTC+0)
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
	GOTO        L_can_user_read_message781
;Expendedora.c,1352 :: 		sizeTotal += sizeKey;
	MOVF        can_user_read_message_sizeKey_L0+0, 0 
	ADDWF       can_user_read_message_sizeTotal_L0+0, 0 
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       can_user_read_message_sizeTotal_L0+0 
;Expendedora.c,1353 :: 		sizeKey = sizeof(CAN_TABLE_SET)-1;
	MOVLW       3
	MOVWF       can_user_read_message_sizeKey_L0+0 
;Expendedora.c,1355 :: 		if(string_cmpnc(CAN_TABLE_SET, &can.rxBuffer[sizeTotal], sizeKey)){
	MOVLW       _CAN_TABLE_SET+0
	MOVWF       FARG_string_cmpnc_text1+0 
	MOVLW       hi_addr(_CAN_TABLE_SET+0)
	MOVWF       FARG_string_cmpnc_text1+1 
	MOVLW       higher_addr(_CAN_TABLE_SET+0)
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
	GOTO        L_can_user_read_message782
;Expendedora.c,1356 :: 		sizeTotal += sizeKey;
	MOVF        can_user_read_message_sizeKey_L0+0, 0 
	ADDWF       can_user_read_message_sizeTotal_L0+0, 0 
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       can_user_read_message_sizeTotal_L0+0 
;Expendedora.c,1357 :: 		DS1307_write_string(&myRTC,&can.rxBuffer[sizeTotal]);
	MOVLW       _myRTC+0
	MOVWF       FARG_DS1307_write_string_myDS+0 
	MOVLW       hi_addr(_myRTC+0)
	MOVWF       FARG_DS1307_write_string_myDS+1 
	MOVLW       _can+107
	MOVWF       FARG_DS1307_write_string_date+0 
	MOVLW       hi_addr(_can+107)
	MOVWF       FARG_DS1307_write_string_date+1 
	MOVF        R0, 0 
	ADDWF       FARG_DS1307_write_string_date+0, 1 
	BTFSC       STATUS+0, 0 
	INCF        FARG_DS1307_write_string_date+1, 1 
	CALL        _DS1307_write_string+0, 0
;Expendedora.c,1363 :: 		}else if(string_cmpnc(CAN_TABLE_GET, &can.rxBuffer[sizeTotal], sizeKey)){
	GOTO        L_can_user_read_message783
L_can_user_read_message782:
	MOVLW       _CAN_TABLE_GET+0
	MOVWF       FARG_string_cmpnc_text1+0 
	MOVLW       hi_addr(_CAN_TABLE_GET+0)
	MOVWF       FARG_string_cmpnc_text1+1 
	MOVLW       higher_addr(_CAN_TABLE_GET+0)
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
	GOTO        L_can_user_read_message784
;Expendedora.c,1364 :: 		sizeTotal += sizeKey;
	MOVF        can_user_read_message_sizeKey_L0+0, 0 
	ADDWF       can_user_read_message_sizeTotal_L0+0, 1 
;Expendedora.c,1365 :: 		DS1307_read(&myRTC,true);
	MOVLW       _myRTC+0
	MOVWF       FARG_DS1307_read_myDS+0 
	MOVLW       hi_addr(_myRTC+0)
	MOVWF       FARG_DS1307_read_myDS+1 
	MOVLW       1
	MOVWF       FARG_DS1307_read_formatComplet+0 
	CALL        _DS1307_read+0, 0
;Expendedora.c,1366 :: 		string_cpyc(bufferEeprom, CAN_TPV);
	MOVLW       _bufferEeprom+0
	MOVWF       FARG_string_cpyc_destino+0 
	MOVLW       hi_addr(_bufferEeprom+0)
	MOVWF       FARG_string_cpyc_destino+1 
	MOVLW       _CAN_TPV+0
	MOVWF       FARG_string_cpyc_origen+0 
	MOVLW       hi_addr(_CAN_TPV+0)
	MOVWF       FARG_string_cpyc_origen+1 
	MOVLW       higher_addr(_CAN_TPV+0)
	MOVWF       FARG_string_cpyc_origen+2 
	CALL        _string_cpyc+0, 0
;Expendedora.c,1367 :: 		string_addc(bufferEeprom, CAN_RTC);
	MOVLW       _bufferEeprom+0
	MOVWF       FARG_string_addc_destino+0 
	MOVLW       hi_addr(_bufferEeprom+0)
	MOVWF       FARG_string_addc_destino+1 
	MOVLW       _CAN_RTC+0
	MOVWF       FARG_string_addc_addEnd+0 
	MOVLW       hi_addr(_CAN_RTC+0)
	MOVWF       FARG_string_addc_addEnd+1 
	MOVLW       higher_addr(_CAN_RTC+0)
	MOVWF       FARG_string_addc_addEnd+2 
	CALL        _string_addc+0, 0
;Expendedora.c,1368 :: 		string_addc(bufferEeprom, CAN_TABLE_GET);
	MOVLW       _bufferEeprom+0
	MOVWF       FARG_string_addc_destino+0 
	MOVLW       hi_addr(_bufferEeprom+0)
	MOVWF       FARG_string_addc_destino+1 
	MOVLW       _CAN_TABLE_GET+0
	MOVWF       FARG_string_addc_addEnd+0 
	MOVLW       hi_addr(_CAN_TABLE_GET+0)
	MOVWF       FARG_string_addc_addEnd+1 
	MOVLW       higher_addr(_CAN_TABLE_GET+0)
	MOVWF       FARG_string_addc_addEnd+2 
	CALL        _string_addc+0, 0
;Expendedora.c,1369 :: 		string_add(bufferEeprom, myRTC.time);
	MOVLW       _bufferEeprom+0
	MOVWF       FARG_string_add_destino+0 
	MOVLW       hi_addr(_bufferEeprom+0)
	MOVWF       FARG_string_add_destino+1 
	MOVLW       _myRTC+7
	MOVWF       FARG_string_add_addEnd+0 
	MOVLW       hi_addr(_myRTC+7)
	MOVWF       FARG_string_add_addEnd+1 
	CALL        _string_add+0, 0
;Expendedora.c,1370 :: 		string_addc(bufferEeprom, CAN_MODULE);
	MOVLW       _bufferEeprom+0
	MOVWF       FARG_string_addc_destino+0 
	MOVLW       hi_addr(_bufferEeprom+0)
	MOVWF       FARG_string_addc_destino+1 
	MOVLW       _CAN_MODULE+0
	MOVWF       FARG_string_addc_addEnd+0 
	MOVLW       hi_addr(_CAN_MODULE+0)
	MOVWF       FARG_string_addc_addEnd+1 
	MOVLW       higher_addr(_CAN_MODULE+0)
	MOVWF       FARG_string_addc_addEnd+2 
	CALL        _string_addc+0, 0
;Expendedora.c,1371 :: 		numToHex(can.id, msjConst, 1);
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
;Expendedora.c,1372 :: 		string_add(bufferEeprom, msjConst);
	MOVLW       _bufferEeprom+0
	MOVWF       FARG_string_add_destino+0 
	MOVLW       hi_addr(_bufferEeprom+0)
	MOVWF       FARG_string_add_destino+1 
	MOVLW       _msjConst+0
	MOVWF       FARG_string_add_addEnd+0 
	MOVLW       hi_addr(_msjConst+0)
	MOVWF       FARG_string_add_addEnd+1 
	CALL        _string_add+0, 0
;Expendedora.c,1373 :: 		buffer_save_send(true, bufferEeprom);
	MOVLW       1
	MOVWF       FARG_buffer_save_send_guardar+0 
	MOVLW       _bufferEeprom+0
	MOVWF       FARG_buffer_save_send_buffer+0 
	MOVLW       hi_addr(_bufferEeprom+0)
	MOVWF       FARG_buffer_save_send_buffer+1 
	CALL        _buffer_save_send+0, 0
;Expendedora.c,1377 :: 		}
L_can_user_read_message784:
L_can_user_read_message783:
;Expendedora.c,1378 :: 		}else if(string_cmpnc(CAN_PREPAGO, &can.rxBuffer[sizeTotal], sizeKey)){
	GOTO        L_can_user_read_message785
L_can_user_read_message781:
	MOVLW       _CAN_PREPAGO+0
	MOVWF       FARG_string_cmpnc_text1+0 
	MOVLW       hi_addr(_CAN_PREPAGO+0)
	MOVWF       FARG_string_cmpnc_text1+1 
	MOVLW       higher_addr(_CAN_PREPAGO+0)
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
	GOTO        L_can_user_read_message786
;Expendedora.c,1380 :: 		sizeTotal += sizeKey;
	MOVF        can_user_read_message_sizeKey_L0+0, 0 
	ADDWF       can_user_read_message_sizeTotal_L0+0, 0 
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       can_user_read_message_sizeTotal_L0+0 
;Expendedora.c,1381 :: 		sizeKey = 6;  //3 Bytes en hexadecimal
	MOVLW       6
	MOVWF       can_user_read_message_sizeKey_L0+0 
;Expendedora.c,1382 :: 		string_cpyn(msjConst, &can.rxBuffer[sizeTotal], sizeKey);
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
;Expendedora.c,1383 :: 		idConsulta = hexToNum(msjConst);
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
;Expendedora.c,1385 :: 		sizeTotal += sizeKey;
	MOVF        can_user_read_message_sizeKey_L0+0, 0 
	ADDWF       can_user_read_message_sizeTotal_L0+0, 0 
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       can_user_read_message_sizeTotal_L0+0 
;Expendedora.c,1386 :: 		sizeKey = sizeof(CAN_REGISTRAR)-1;  //COMANDO 3BYTES
	MOVLW       3
	MOVWF       can_user_read_message_sizeKey_L0+0 
;Expendedora.c,1388 :: 		string_cpyn(msjConst, &can.rxBuffer[sizeTotal+sizeKey], 4); //4 numeros fila
	MOVLW       _msjConst+0
	MOVWF       FARG_string_cpyn_destino+0 
	MOVLW       hi_addr(_msjConst+0)
	MOVWF       FARG_string_cpyn_destino+1 
	MOVLW       3
	ADDWF       R0, 1 
	CLRF        R1 
	MOVLW       0
	ADDWFC      R1, 1 
	MOVLW       _can+107
	ADDWF       R0, 0 
	MOVWF       FARG_string_cpyn_origen+0 
	MOVLW       hi_addr(_can+107)
	ADDWFC      R1, 0 
	MOVWF       FARG_string_cpyn_origen+1 
	MOVLW       4
	MOVWF       FARG_string_cpyn_size+0 
	CALL        _string_cpyn+0, 0
;Expendedora.c,1389 :: 		fila = stringToNum(msjConst);
	MOVLW       _msjConst+0
	MOVWF       FARG_stringToNum_cadena+0 
	MOVLW       hi_addr(_msjConst+0)
	MOVWF       FARG_stringToNum_cadena+1 
	CALL        _stringToNum+0, 0
	MOVF        R0, 0 
	MOVWF       can_user_read_message_fila_L0+0 
	MOVF        R1, 0 
	MOVWF       can_user_read_message_fila_L0+1 
;Expendedora.c,1392 :: 		if(string_cmpnc(CAN_REGISTRAR, &can.rxBuffer[sizeTotal], sizeKey)){
	MOVLW       _CAN_REGISTRAR+0
	MOVWF       FARG_string_cmpnc_text1+0 
	MOVLW       hi_addr(_CAN_REGISTRAR+0)
	MOVWF       FARG_string_cmpnc_text1+1 
	MOVLW       higher_addr(_CAN_REGISTRAR+0)
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
	GOTO        L_can_user_read_message787
;Expendedora.c,1394 :: 		sizeTotal += sizeKey;
	MOVF        can_user_read_message_sizeKey_L0+0, 0 
	ADDWF       can_user_read_message_sizeTotal_L0+0, 0 
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       can_user_read_message_sizeTotal_L0+0 
;Expendedora.c,1395 :: 		sizeKey = 4;  //4 POR LA FILA
	MOVLW       4
	MOVWF       can_user_read_message_sizeKey_L0+0 
;Expendedora.c,1397 :: 		idNew = idConsulta;
	MOVF        can_user_read_message_idConsulta_L0+0, 0 
	MOVWF       can_user_read_message_idNew_L0+0 
	MOVF        can_user_read_message_idConsulta_L0+1, 0 
	MOVWF       can_user_read_message_idNew_L0+1 
	MOVF        can_user_read_message_idConsulta_L0+2, 0 
	MOVWF       can_user_read_message_idNew_L0+2 
	MOVF        can_user_read_message_idConsulta_L0+3, 0 
	MOVWF       can_user_read_message_idNew_L0+3 
;Expendedora.c,1399 :: 		sizeTotal += sizeKey;
	MOVLW       4
	ADDWF       R0, 1 
	MOVF        R0, 0 
	MOVWF       can_user_read_message_sizeTotal_L0+0 
;Expendedora.c,1400 :: 		sizeKey = 8;  //8 Byte
	MOVLW       8
	MOVWF       can_user_read_message_sizeKey_L0+0 
;Expendedora.c,1401 :: 		string_cpyn(msjConst, &can.rxBuffer[sizeTotal], sizeKey);
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
;Expendedora.c,1402 :: 		nip = hexToNum(msjConst);
	MOVLW       _msjConst+0
	MOVWF       FARG_hexToNum_hex+0 
	MOVLW       hi_addr(_msjConst+0)
	MOVWF       FARG_hexToNum_hex+1 
	CALL        _hexToNum+0, 0
	MOVF        R0, 0 
	MOVWF       can_user_read_message_nip_L0+0 
	MOVF        R1, 0 
	MOVWF       can_user_read_message_nip_L0+1 
	MOVF        R2, 0 
	MOVWF       can_user_read_message_nip_L0+2 
	MOVF        R3, 0 
	MOVWF       can_user_read_message_nip_L0+3 
;Expendedora.c,1404 :: 		sizeTotal += sizeKey;
	MOVF        can_user_read_message_sizeKey_L0+0, 0 
	ADDWF       can_user_read_message_sizeTotal_L0+0, 0 
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       can_user_read_message_sizeTotal_L0+0 
;Expendedora.c,1405 :: 		sizeKey = 8;  //8 Byte
	MOVLW       8
	MOVWF       can_user_read_message_sizeKey_L0+0 
;Expendedora.c,1406 :: 		string_cpyn(msjConst, &can.rxBuffer[sizeTotal], sizeKey);
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
;Expendedora.c,1407 :: 		saldo = hexToNum(msjConst);
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
;Expendedora.c,1409 :: 		sizeTotal += sizeKey;
	MOVF        can_user_read_message_sizeKey_L0+0, 0 
	ADDWF       can_user_read_message_sizeTotal_L0+0, 0 
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       can_user_read_message_sizeTotal_L0+0 
;Expendedora.c,1410 :: 		sizeKey = 1;  //1 Byte
	MOVLW       1
	MOVWF       can_user_read_message_sizeKey_L0+0 
;Expendedora.c,1411 :: 		estatus = can.rxBuffer[sizeTotal];
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
;Expendedora.c,1413 :: 		if(mysql_read(tablePrepago, prepagoID, fila, &id) == TABLE_RW_NO_EXIST_ROW){
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
	MOVF        R0, 0 
	XORLW       3
	BTFSS       STATUS+0, 2 
	GOTO        L_can_user_read_message788
;Expendedora.c,1414 :: 		if(fila == myTable.rowAct+1){
	MOVLW       1
	ADDWF       Expendedora_myTable+4, 0 
	MOVWF       R1 
	MOVLW       0
	ADDWFC      Expendedora_myTable+5, 0 
	MOVWF       R2 
	MOVF        can_user_read_message_fila_L0+1, 0 
	XORWF       R2, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__can_user_read_message1344
	MOVF        R1, 0 
	XORWF       can_user_read_message_fila_L0+0, 0 
L__can_user_read_message1344:
	BTFSS       STATUS+0, 2 
	GOTO        L_can_user_read_message789
;Expendedora.c,1415 :: 		if(!mysql_write(tablePrepago, prepagoID, -1, idNew, true)){
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
	MOVF        can_user_read_message_idNew_L0+0, 0 
	MOVWF       FARG_mysql_write_value+0 
	MOVF        can_user_read_message_idNew_L0+1, 0 
	MOVWF       FARG_mysql_write_value+1 
	MOVF        can_user_read_message_idNew_L0+2, 0 
	MOVWF       FARG_mysql_write_value+2 
	MOVF        can_user_read_message_idNew_L0+3, 0 
	MOVWF       FARG_mysql_write_value+3 
	MOVLW       1
	MOVWF       FARG_mysql_write_endWrite+0 
	CALL        _mysql_write+0, 0
	MOVF        R0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_can_user_read_message790
;Expendedora.c,1417 :: 		mysql_write(tablePrepago, prepagoNip, fila, nip, false);
	MOVLW       _tablePrepago+0
	MOVWF       FARG_mysql_write_name+0 
	MOVLW       hi_addr(_tablePrepago+0)
	MOVWF       FARG_mysql_write_name+1 
	MOVLW       _prepagoNip+0
	MOVWF       FARG_mysql_write_column+0 
	MOVLW       hi_addr(_prepagoNip+0)
	MOVWF       FARG_mysql_write_column+1 
	MOVF        can_user_read_message_fila_L0+0, 0 
	MOVWF       FARG_mysql_write_fila+0 
	MOVF        can_user_read_message_fila_L0+1, 0 
	MOVWF       FARG_mysql_write_fila+1 
	MOVF        can_user_read_message_nip_L0+0, 0 
	MOVWF       FARG_mysql_write_value+0 
	MOVF        can_user_read_message_nip_L0+1, 0 
	MOVWF       FARG_mysql_write_value+1 
	MOVF        can_user_read_message_nip_L0+2, 0 
	MOVWF       FARG_mysql_write_value+2 
	MOVF        can_user_read_message_nip_L0+3, 0 
	MOVWF       FARG_mysql_write_value+3 
	CLRF        FARG_mysql_write_endWrite+0 
	CALL        _mysql_write+0, 0
;Expendedora.c,1418 :: 		mysql_write(tablePrepago, prepagoSaldo, fila, saldo, false);
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
;Expendedora.c,1419 :: 		mysql_write(tablePrepago, prepagoEstatus, fila, estatus, false);
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
;Expendedora.c,1420 :: 		mysql_write_string(tablePrepago, prepagoDate, fila, "", false);
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
	MOVLW       ?lstr27_Expendedora+0
	MOVWF       FARG_mysql_write_string_texto+0 
	MOVLW       hi_addr(?lstr27_Expendedora+0)
	MOVWF       FARG_mysql_write_string_texto+1 
	CLRF        FARG_mysql_write_string_endWrite+0 
	CALL        _mysql_write_string+0, 0
;Expendedora.c,1424 :: 		}
L_can_user_read_message790:
;Expendedora.c,1425 :: 		}
L_can_user_read_message789:
;Expendedora.c,1426 :: 		}
L_can_user_read_message788:
;Expendedora.c,1427 :: 		}else if(string_cmpnc(CAN_ACTUALIZAR, &can.rxBuffer[sizeTotal], sizeKey)){
	GOTO        L_can_user_read_message791
L_can_user_read_message787:
	MOVLW       _CAN_ACTUALIZAR+0
	MOVWF       FARG_string_cmpnc_text1+0 
	MOVLW       hi_addr(_CAN_ACTUALIZAR+0)
	MOVWF       FARG_string_cmpnc_text1+1 
	MOVLW       higher_addr(_CAN_ACTUALIZAR+0)
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
	GOTO        L_can_user_read_message792
;Expendedora.c,1429 :: 		sizeTotal += sizeKey;
	MOVF        can_user_read_message_sizeKey_L0+0, 0 
	ADDWF       can_user_read_message_sizeTotal_L0+0, 0 
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       can_user_read_message_sizeTotal_L0+0 
;Expendedora.c,1430 :: 		sizeKey = 4;  //4 POR LA FILA
	MOVLW       4
	MOVWF       can_user_read_message_sizeKey_L0+0 
;Expendedora.c,1432 :: 		sizeTotal += sizeKey;
	MOVLW       4
	ADDWF       R0, 1 
	MOVF        R0, 0 
	MOVWF       can_user_read_message_sizeTotal_L0+0 
;Expendedora.c,1433 :: 		sizeKey = 6;  //3 Bytes en hexadecimal
	MOVLW       6
	MOVWF       can_user_read_message_sizeKey_L0+0 
;Expendedora.c,1434 :: 		string_cpyn(msjConst, &can.rxBuffer[sizeTotal], sizeKey);
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
;Expendedora.c,1435 :: 		idNew = hexToNum(msjConst);
	MOVLW       _msjConst+0
	MOVWF       FARG_hexToNum_hex+0 
	MOVLW       hi_addr(_msjConst+0)
	MOVWF       FARG_hexToNum_hex+1 
	CALL        _hexToNum+0, 0
	MOVF        R0, 0 
	MOVWF       can_user_read_message_idNew_L0+0 
	MOVF        R1, 0 
	MOVWF       can_user_read_message_idNew_L0+1 
	MOVF        R2, 0 
	MOVWF       can_user_read_message_idNew_L0+2 
	MOVF        R3, 0 
	MOVWF       can_user_read_message_idNew_L0+3 
;Expendedora.c,1437 :: 		sizeTotal += sizeKey;
	MOVF        can_user_read_message_sizeKey_L0+0, 0 
	ADDWF       can_user_read_message_sizeTotal_L0+0, 0 
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       can_user_read_message_sizeTotal_L0+0 
;Expendedora.c,1438 :: 		sizeKey = 8;  //8 Byte
	MOVLW       8
	MOVWF       can_user_read_message_sizeKey_L0+0 
;Expendedora.c,1439 :: 		string_cpyn(msjConst, &can.rxBuffer[sizeTotal], sizeKey);
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
;Expendedora.c,1440 :: 		nip = hexToNum(msjConst);
	MOVLW       _msjConst+0
	MOVWF       FARG_hexToNum_hex+0 
	MOVLW       hi_addr(_msjConst+0)
	MOVWF       FARG_hexToNum_hex+1 
	CALL        _hexToNum+0, 0
	MOVF        R0, 0 
	MOVWF       can_user_read_message_nip_L0+0 
	MOVF        R1, 0 
	MOVWF       can_user_read_message_nip_L0+1 
	MOVF        R2, 0 
	MOVWF       can_user_read_message_nip_L0+2 
	MOVF        R3, 0 
	MOVWF       can_user_read_message_nip_L0+3 
;Expendedora.c,1442 :: 		sizeTotal += sizeKey;
	MOVF        can_user_read_message_sizeKey_L0+0, 0 
	ADDWF       can_user_read_message_sizeTotal_L0+0, 0 
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       can_user_read_message_sizeTotal_L0+0 
;Expendedora.c,1443 :: 		sizeKey = 8;  //8 Byte
	MOVLW       8
	MOVWF       can_user_read_message_sizeKey_L0+0 
;Expendedora.c,1444 :: 		string_cpyn(msjConst, &can.rxBuffer[sizeTotal], sizeKey);
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
;Expendedora.c,1445 :: 		saldo = hexToNum(msjConst);
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
;Expendedora.c,1447 :: 		sizeTotal += sizeKey;
	MOVF        can_user_read_message_sizeKey_L0+0, 0 
	ADDWF       can_user_read_message_sizeTotal_L0+0, 0 
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       can_user_read_message_sizeTotal_L0+0 
;Expendedora.c,1448 :: 		sizeKey = 1;  //1 Byte
	MOVLW       1
	MOVWF       can_user_read_message_sizeKey_L0+0 
;Expendedora.c,1449 :: 		estatus = can.rxBuffer[sizeTotal];
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
;Expendedora.c,1452 :: 		if(!mysql_read(tablePrepago, prepagoID, fila, &id)){
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
	GOTO        L_can_user_read_message793
;Expendedora.c,1453 :: 		if(id == idConsulta){
	MOVF        can_user_read_message_id_L0+3, 0 
	XORWF       can_user_read_message_idConsulta_L0+3, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__can_user_read_message1345
	MOVF        can_user_read_message_id_L0+2, 0 
	XORWF       can_user_read_message_idConsulta_L0+2, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__can_user_read_message1345
	MOVF        can_user_read_message_id_L0+1, 0 
	XORWF       can_user_read_message_idConsulta_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__can_user_read_message1345
	MOVF        can_user_read_message_id_L0+0, 0 
	XORWF       can_user_read_message_idConsulta_L0+0, 0 
L__can_user_read_message1345:
	BTFSS       STATUS+0, 2 
	GOTO        L_can_user_read_message794
;Expendedora.c,1454 :: 		mysql_write(tablePrepago, prepagoID, fila, idNew, false);
	MOVLW       _tablePrepago+0
	MOVWF       FARG_mysql_write_name+0 
	MOVLW       hi_addr(_tablePrepago+0)
	MOVWF       FARG_mysql_write_name+1 
	MOVLW       _prepagoId+0
	MOVWF       FARG_mysql_write_column+0 
	MOVLW       hi_addr(_prepagoId+0)
	MOVWF       FARG_mysql_write_column+1 
	MOVF        can_user_read_message_fila_L0+0, 0 
	MOVWF       FARG_mysql_write_fila+0 
	MOVF        can_user_read_message_fila_L0+1, 0 
	MOVWF       FARG_mysql_write_fila+1 
	MOVF        can_user_read_message_idNew_L0+0, 0 
	MOVWF       FARG_mysql_write_value+0 
	MOVF        can_user_read_message_idNew_L0+1, 0 
	MOVWF       FARG_mysql_write_value+1 
	MOVF        can_user_read_message_idNew_L0+2, 0 
	MOVWF       FARG_mysql_write_value+2 
	MOVF        can_user_read_message_idNew_L0+3, 0 
	MOVWF       FARG_mysql_write_value+3 
	CLRF        FARG_mysql_write_endWrite+0 
	CALL        _mysql_write+0, 0
;Expendedora.c,1455 :: 		mysql_write(tablePrepago, prepagoNip, fila, nip, false);
	MOVLW       _tablePrepago+0
	MOVWF       FARG_mysql_write_name+0 
	MOVLW       hi_addr(_tablePrepago+0)
	MOVWF       FARG_mysql_write_name+1 
	MOVLW       _prepagoNip+0
	MOVWF       FARG_mysql_write_column+0 
	MOVLW       hi_addr(_prepagoNip+0)
	MOVWF       FARG_mysql_write_column+1 
	MOVF        can_user_read_message_fila_L0+0, 0 
	MOVWF       FARG_mysql_write_fila+0 
	MOVF        can_user_read_message_fila_L0+1, 0 
	MOVWF       FARG_mysql_write_fila+1 
	MOVF        can_user_read_message_nip_L0+0, 0 
	MOVWF       FARG_mysql_write_value+0 
	MOVF        can_user_read_message_nip_L0+1, 0 
	MOVWF       FARG_mysql_write_value+1 
	MOVF        can_user_read_message_nip_L0+2, 0 
	MOVWF       FARG_mysql_write_value+2 
	MOVF        can_user_read_message_nip_L0+3, 0 
	MOVWF       FARG_mysql_write_value+3 
	CLRF        FARG_mysql_write_endWrite+0 
	CALL        _mysql_write+0, 0
;Expendedora.c,1456 :: 		mysql_write(tablePrepago, prepagoSaldo, fila, saldo, false);
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
;Expendedora.c,1457 :: 		mysql_write(tablePrepago, prepagoEstatus, fila, estatus, false);
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
;Expendedora.c,1461 :: 		}
L_can_user_read_message794:
;Expendedora.c,1462 :: 		}
L_can_user_read_message793:
;Expendedora.c,1463 :: 		}else if(string_cmpnc(CAN_CONSULTAR, &can.rxBuffer[sizeTotal], sizeKey)){
	GOTO        L_can_user_read_message795
L_can_user_read_message792:
	MOVLW       _CAN_CONSULTAR+0
	MOVWF       FARG_string_cmpnc_text1+0 
	MOVLW       hi_addr(_CAN_CONSULTAR+0)
	MOVWF       FARG_string_cmpnc_text1+1 
	MOVLW       higher_addr(_CAN_CONSULTAR+0)
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
	GOTO        L_can_user_read_message796
;Expendedora.c,1465 :: 		sizeTotal += sizeKey;
	MOVF        can_user_read_message_sizeKey_L0+0, 0 
	ADDWF       can_user_read_message_sizeTotal_L0+0, 1 
;Expendedora.c,1466 :: 		sizeKey = 4;  //4 POR LA FILA
	MOVLW       4
	MOVWF       can_user_read_message_sizeKey_L0+0 
;Expendedora.c,1468 :: 		string_cpyc(bufferEeprom, CAN_TPV);
	MOVLW       _bufferEeprom+0
	MOVWF       FARG_string_cpyc_destino+0 
	MOVLW       hi_addr(_bufferEeprom+0)
	MOVWF       FARG_string_cpyc_destino+1 
	MOVLW       _CAN_TPV+0
	MOVWF       FARG_string_cpyc_origen+0 
	MOVLW       hi_addr(_CAN_TPV+0)
	MOVWF       FARG_string_cpyc_origen+1 
	MOVLW       higher_addr(_CAN_TPV+0)
	MOVWF       FARG_string_cpyc_origen+2 
	CALL        _string_cpyc+0, 0
;Expendedora.c,1469 :: 		string_cpyn(&bufferEeprom[sizeof(CAN_TPV)-1], can.rxBuffer, sizeTotal);
	MOVLW       _bufferEeprom+3
	MOVWF       FARG_string_cpyn_destino+0 
	MOVLW       hi_addr(_bufferEeprom+3)
	MOVWF       FARG_string_cpyn_destino+1 
	MOVLW       _can+107
	MOVWF       FARG_string_cpyn_origen+0 
	MOVLW       hi_addr(_can+107)
	MOVWF       FARG_string_cpyn_origen+1 
	MOVF        can_user_read_message_sizeTotal_L0+0, 0 
	MOVWF       FARG_string_cpyn_size+0 
	CALL        _string_cpyn+0, 0
;Expendedora.c,1470 :: 		if(!mysql_read(tablePrepago, prepagoID, fila, &id)){
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
	GOTO        L_can_user_read_message797
;Expendedora.c,1471 :: 		if(idConsulta == id){
	MOVF        can_user_read_message_idConsulta_L0+3, 0 
	XORWF       can_user_read_message_id_L0+3, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__can_user_read_message1346
	MOVF        can_user_read_message_idConsulta_L0+2, 0 
	XORWF       can_user_read_message_id_L0+2, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__can_user_read_message1346
	MOVF        can_user_read_message_idConsulta_L0+1, 0 
	XORWF       can_user_read_message_id_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__can_user_read_message1346
	MOVF        can_user_read_message_idConsulta_L0+0, 0 
	XORWF       can_user_read_message_id_L0+0, 0 
L__can_user_read_message1346:
	BTFSS       STATUS+0, 2 
	GOTO        L_can_user_read_message798
;Expendedora.c,1472 :: 		mysql_read(tablePrepago, prepagoNip, fila, &nip);
	MOVLW       _tablePrepago+0
	MOVWF       FARG_mysql_read_name+0 
	MOVLW       hi_addr(_tablePrepago+0)
	MOVWF       FARG_mysql_read_name+1 
	MOVLW       _prepagoNip+0
	MOVWF       FARG_mysql_read_column+0 
	MOVLW       hi_addr(_prepagoNip+0)
	MOVWF       FARG_mysql_read_column+1 
	MOVF        can_user_read_message_fila_L0+0, 0 
	MOVWF       FARG_mysql_read_fila+0 
	MOVF        can_user_read_message_fila_L0+1, 0 
	MOVWF       FARG_mysql_read_fila+1 
	MOVLW       can_user_read_message_nip_L0+0
	MOVWF       FARG_mysql_read_result+0 
	MOVLW       hi_addr(can_user_read_message_nip_L0+0)
	MOVWF       FARG_mysql_read_result+1 
	CALL        _mysql_read+0, 0
;Expendedora.c,1473 :: 		mysql_read(tablePrepago, prepagoSaldo, fila, &saldo);
	MOVLW       _tablePrepago+0
	MOVWF       FARG_mysql_read_name+0 
	MOVLW       hi_addr(_tablePrepago+0)
	MOVWF       FARG_mysql_read_name+1 
	MOVLW       _prepagoSaldo+0
	MOVWF       FARG_mysql_read_column+0 
	MOVLW       hi_addr(_prepagoSaldo+0)
	MOVWF       FARG_mysql_read_column+1 
	MOVF        can_user_read_message_fila_L0+0, 0 
	MOVWF       FARG_mysql_read_fila+0 
	MOVF        can_user_read_message_fila_L0+1, 0 
	MOVWF       FARG_mysql_read_fila+1 
	MOVLW       can_user_read_message_saldo_L0+0
	MOVWF       FARG_mysql_read_result+0 
	MOVLW       hi_addr(can_user_read_message_saldo_L0+0)
	MOVWF       FARG_mysql_read_result+1 
	CALL        _mysql_read+0, 0
;Expendedora.c,1474 :: 		mysql_read_string(tablePrepago, prepagoEstatus, fila, &estatus);
	MOVLW       _tablePrepago+0
	MOVWF       FARG_mysql_read_string_name+0 
	MOVLW       hi_addr(_tablePrepago+0)
	MOVWF       FARG_mysql_read_string_name+1 
	MOVLW       _prepagoEstatus+0
	MOVWF       FARG_mysql_read_string_column+0 
	MOVLW       hi_addr(_prepagoEstatus+0)
	MOVWF       FARG_mysql_read_string_column+1 
	MOVF        can_user_read_message_fila_L0+0, 0 
	MOVWF       FARG_mysql_read_string_fila+0 
	MOVF        can_user_read_message_fila_L0+1, 0 
	MOVWF       FARG_mysql_read_string_fila+1 
	MOVLW       can_user_read_message_estatus_L0+0
	MOVWF       FARG_mysql_read_string_result+0 
	MOVLW       hi_addr(can_user_read_message_estatus_L0+0)
	MOVWF       FARG_mysql_read_string_result+1 
	CALL        _mysql_read_string+0, 0
;Expendedora.c,1476 :: 		numToHex(nip, msjConst, 4);
	MOVF        can_user_read_message_nip_L0+0, 0 
	MOVWF       FARG_numToHex_valor+0 
	MOVF        can_user_read_message_nip_L0+1, 0 
	MOVWF       FARG_numToHex_valor+1 
	MOVF        can_user_read_message_nip_L0+2, 0 
	MOVWF       FARG_numToHex_valor+2 
	MOVF        can_user_read_message_nip_L0+3, 0 
	MOVWF       FARG_numToHex_valor+3 
	MOVLW       _msjConst+0
	MOVWF       FARG_numToHex_cadena+0 
	MOVLW       hi_addr(_msjConst+0)
	MOVWF       FARG_numToHex_cadena+1 
	MOVLW       4
	MOVWF       FARG_numToHex_bytes+0 
	CALL        _numToHex+0, 0
;Expendedora.c,1477 :: 		string_add(bufferEeprom, msjConst);
	MOVLW       _bufferEeprom+0
	MOVWF       FARG_string_add_destino+0 
	MOVLW       hi_addr(_bufferEeprom+0)
	MOVWF       FARG_string_add_destino+1 
	MOVLW       _msjConst+0
	MOVWF       FARG_string_add_addEnd+0 
	MOVLW       hi_addr(_msjConst+0)
	MOVWF       FARG_string_add_addEnd+1 
	CALL        _string_add+0, 0
;Expendedora.c,1478 :: 		numToHex(saldo, msjConst, 4);
	MOVF        can_user_read_message_saldo_L0+0, 0 
	MOVWF       FARG_numToHex_valor+0 
	MOVF        can_user_read_message_saldo_L0+1, 0 
	MOVWF       FARG_numToHex_valor+1 
	MOVF        can_user_read_message_saldo_L0+2, 0 
	MOVWF       FARG_numToHex_valor+2 
	MOVF        can_user_read_message_saldo_L0+3, 0 
	MOVWF       FARG_numToHex_valor+3 
	MOVLW       _msjConst+0
	MOVWF       FARG_numToHex_cadena+0 
	MOVLW       hi_addr(_msjConst+0)
	MOVWF       FARG_numToHex_cadena+1 
	MOVLW       4
	MOVWF       FARG_numToHex_bytes+0 
	CALL        _numToHex+0, 0
;Expendedora.c,1479 :: 		string_add(bufferEeprom, msjConst);
	MOVLW       _bufferEeprom+0
	MOVWF       FARG_string_add_destino+0 
	MOVLW       hi_addr(_bufferEeprom+0)
	MOVWF       FARG_string_add_destino+1 
	MOVLW       _msjConst+0
	MOVWF       FARG_string_add_addEnd+0 
	MOVLW       hi_addr(_msjConst+0)
	MOVWF       FARG_string_add_addEnd+1 
	CALL        _string_add+0, 0
;Expendedora.c,1480 :: 		string_push(bufferEeprom, estatus);
	MOVLW       _bufferEeprom+0
	MOVWF       FARG_string_push_texto+0 
	MOVLW       hi_addr(_bufferEeprom+0)
	MOVWF       FARG_string_push_texto+1 
	MOVF        can_user_read_message_estatus_L0+0, 0 
	MOVWF       FARG_string_push_caracter+0 
	CALL        _string_push+0, 0
;Expendedora.c,1481 :: 		string_addc(bufferEeprom, CAN_MODULE);
	MOVLW       _bufferEeprom+0
	MOVWF       FARG_string_addc_destino+0 
	MOVLW       hi_addr(_bufferEeprom+0)
	MOVWF       FARG_string_addc_destino+1 
	MOVLW       _CAN_MODULE+0
	MOVWF       FARG_string_addc_addEnd+0 
	MOVLW       hi_addr(_CAN_MODULE+0)
	MOVWF       FARG_string_addc_addEnd+1 
	MOVLW       higher_addr(_CAN_MODULE+0)
	MOVWF       FARG_string_addc_addEnd+2 
	CALL        _string_addc+0, 0
;Expendedora.c,1482 :: 		numToHex(can.id, msjConst, 1);
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
;Expendedora.c,1483 :: 		string_add(bufferEeprom, msjConst);
	MOVLW       _bufferEeprom+0
	MOVWF       FARG_string_add_destino+0 
	MOVLW       hi_addr(_bufferEeprom+0)
	MOVWF       FARG_string_add_destino+1 
	MOVLW       _msjConst+0
	MOVWF       FARG_string_add_addEnd+0 
	MOVLW       hi_addr(_msjConst+0)
	MOVWF       FARG_string_add_addEnd+1 
	CALL        _string_add+0, 0
;Expendedora.c,1487 :: 		}else{
	GOTO        L_can_user_read_message799
L_can_user_read_message798:
;Expendedora.c,1488 :: 		string_addc(bufferEeprom, CAN_TABLE_NO_FOUND);
	MOVLW       _bufferEeprom+0
	MOVWF       FARG_string_addc_destino+0 
	MOVLW       hi_addr(_bufferEeprom+0)
	MOVWF       FARG_string_addc_destino+1 
	MOVLW       _CAN_TABLE_NO_FOUND+0
	MOVWF       FARG_string_addc_addEnd+0 
	MOVLW       hi_addr(_CAN_TABLE_NO_FOUND+0)
	MOVWF       FARG_string_addc_addEnd+1 
	MOVLW       higher_addr(_CAN_TABLE_NO_FOUND+0)
	MOVWF       FARG_string_addc_addEnd+2 
	CALL        _string_addc+0, 0
;Expendedora.c,1489 :: 		}
L_can_user_read_message799:
;Expendedora.c,1490 :: 		}
L_can_user_read_message797:
;Expendedora.c,1492 :: 		buffer_save_send(true, bufferEeprom);
	MOVLW       1
	MOVWF       FARG_buffer_save_send_guardar+0 
	MOVLW       _bufferEeprom+0
	MOVWF       FARG_buffer_save_send_buffer+0 
	MOVLW       hi_addr(_bufferEeprom+0)
	MOVWF       FARG_buffer_save_send_buffer+1 
	CALL        _buffer_save_send+0, 0
;Expendedora.c,1493 :: 		}else if(string_cmpnc(CAN_NIP, &can.rxBuffer[sizeTotal], sizeKey)){
	GOTO        L_can_user_read_message800
L_can_user_read_message796:
	MOVLW       _CAN_NIP+0
	MOVWF       FARG_string_cmpnc_text1+0 
	MOVLW       hi_addr(_CAN_NIP+0)
	MOVWF       FARG_string_cmpnc_text1+1 
	MOVLW       higher_addr(_CAN_NIP+0)
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
	GOTO        L_can_user_read_message801
;Expendedora.c,1495 :: 		sizeTotal += sizeKey;
	MOVF        can_user_read_message_sizeKey_L0+0, 0 
	ADDWF       can_user_read_message_sizeTotal_L0+0, 0 
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       can_user_read_message_sizeTotal_L0+0 
;Expendedora.c,1496 :: 		sizeKey = 4;  //4 POR LA FILA
	MOVLW       4
	MOVWF       can_user_read_message_sizeKey_L0+0 
;Expendedora.c,1498 :: 		sizeTotal += sizeKey;
	MOVLW       4
	ADDWF       R0, 1 
	MOVF        R0, 0 
	MOVWF       can_user_read_message_sizeTotal_L0+0 
;Expendedora.c,1499 :: 		sizeKey = 8;  //8 Byte
	MOVLW       8
	MOVWF       can_user_read_message_sizeKey_L0+0 
;Expendedora.c,1500 :: 		string_cpyn(msjConst, &can.rxBuffer[sizeTotal], sizeKey);
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
;Expendedora.c,1501 :: 		nip = hexToNum(msjConst);
	MOVLW       _msjConst+0
	MOVWF       FARG_hexToNum_hex+0 
	MOVLW       hi_addr(_msjConst+0)
	MOVWF       FARG_hexToNum_hex+1 
	CALL        _hexToNum+0, 0
	MOVF        R0, 0 
	MOVWF       can_user_read_message_nip_L0+0 
	MOVF        R1, 0 
	MOVWF       can_user_read_message_nip_L0+1 
	MOVF        R2, 0 
	MOVWF       can_user_read_message_nip_L0+2 
	MOVF        R3, 0 
	MOVWF       can_user_read_message_nip_L0+3 
;Expendedora.c,1503 :: 		if(!mysql_read(tablePrepago, prepagoID, fila, &id)){
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
	GOTO        L_can_user_read_message802
;Expendedora.c,1504 :: 		if(id == idConsulta){
	MOVF        can_user_read_message_id_L0+3, 0 
	XORWF       can_user_read_message_idConsulta_L0+3, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__can_user_read_message1347
	MOVF        can_user_read_message_id_L0+2, 0 
	XORWF       can_user_read_message_idConsulta_L0+2, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__can_user_read_message1347
	MOVF        can_user_read_message_id_L0+1, 0 
	XORWF       can_user_read_message_idConsulta_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__can_user_read_message1347
	MOVF        can_user_read_message_id_L0+0, 0 
	XORWF       can_user_read_message_idConsulta_L0+0, 0 
L__can_user_read_message1347:
	BTFSS       STATUS+0, 2 
	GOTO        L_can_user_read_message803
;Expendedora.c,1505 :: 		mysql_write(tablePrepago, prepagoNip, fila, nip, false);
	MOVLW       _tablePrepago+0
	MOVWF       FARG_mysql_write_name+0 
	MOVLW       hi_addr(_tablePrepago+0)
	MOVWF       FARG_mysql_write_name+1 
	MOVLW       _prepagoNip+0
	MOVWF       FARG_mysql_write_column+0 
	MOVLW       hi_addr(_prepagoNip+0)
	MOVWF       FARG_mysql_write_column+1 
	MOVF        can_user_read_message_fila_L0+0, 0 
	MOVWF       FARG_mysql_write_fila+0 
	MOVF        can_user_read_message_fila_L0+1, 0 
	MOVWF       FARG_mysql_write_fila+1 
	MOVF        can_user_read_message_nip_L0+0, 0 
	MOVWF       FARG_mysql_write_value+0 
	MOVF        can_user_read_message_nip_L0+1, 0 
	MOVWF       FARG_mysql_write_value+1 
	MOVF        can_user_read_message_nip_L0+2, 0 
	MOVWF       FARG_mysql_write_value+2 
	MOVF        can_user_read_message_nip_L0+3, 0 
	MOVWF       FARG_mysql_write_value+3 
	CLRF        FARG_mysql_write_endWrite+0 
	CALL        _mysql_write+0, 0
;Expendedora.c,1509 :: 		}
L_can_user_read_message803:
;Expendedora.c,1510 :: 		}
L_can_user_read_message802:
;Expendedora.c,1511 :: 		}else if(string_cmpnc(CAN_SALDO, &can.rxBuffer[sizeTotal], sizeKey)){
	GOTO        L_can_user_read_message804
L_can_user_read_message801:
	MOVLW       _CAN_SALDO+0
	MOVWF       FARG_string_cmpnc_text1+0 
	MOVLW       hi_addr(_CAN_SALDO+0)
	MOVWF       FARG_string_cmpnc_text1+1 
	MOVLW       higher_addr(_CAN_SALDO+0)
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
	GOTO        L_can_user_read_message805
;Expendedora.c,1513 :: 		sizeTotal += sizeKey;
	MOVF        can_user_read_message_sizeKey_L0+0, 0 
	ADDWF       can_user_read_message_sizeTotal_L0+0, 0 
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       can_user_read_message_sizeTotal_L0+0 
;Expendedora.c,1514 :: 		sizeKey = 4;  //4 POR LA FILA
	MOVLW       4
	MOVWF       can_user_read_message_sizeKey_L0+0 
;Expendedora.c,1516 :: 		sizeTotal += sizeKey;
	MOVLW       4
	ADDWF       R0, 1 
	MOVF        R0, 0 
	MOVWF       can_user_read_message_sizeTotal_L0+0 
;Expendedora.c,1517 :: 		sizeKey = 8;  //8 Byte
	MOVLW       8
	MOVWF       can_user_read_message_sizeKey_L0+0 
;Expendedora.c,1518 :: 		string_cpyn(msjConst, &can.rxBuffer[sizeTotal], sizeKey);
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
;Expendedora.c,1519 :: 		saldo = hexToNum(msjConst);
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
;Expendedora.c,1521 :: 		if(!mysql_read(tablePrepago, prepagoID, fila, &id)){
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
	GOTO        L_can_user_read_message806
;Expendedora.c,1522 :: 		if(id == idConsulta){
	MOVF        can_user_read_message_id_L0+3, 0 
	XORWF       can_user_read_message_idConsulta_L0+3, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__can_user_read_message1348
	MOVF        can_user_read_message_id_L0+2, 0 
	XORWF       can_user_read_message_idConsulta_L0+2, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__can_user_read_message1348
	MOVF        can_user_read_message_id_L0+1, 0 
	XORWF       can_user_read_message_idConsulta_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__can_user_read_message1348
	MOVF        can_user_read_message_id_L0+0, 0 
	XORWF       can_user_read_message_idConsulta_L0+0, 0 
L__can_user_read_message1348:
	BTFSS       STATUS+0, 2 
	GOTO        L_can_user_read_message807
;Expendedora.c,1523 :: 		mysql_write(tablePrepago, prepagoSaldo, fila, saldo, false);
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
;Expendedora.c,1527 :: 		}
L_can_user_read_message807:
;Expendedora.c,1528 :: 		}
L_can_user_read_message806:
;Expendedora.c,1529 :: 		}else if(string_cmpnc(CAN_PASSBACK, &can.rxBuffer[sizeTotal], sizeKey)){
	GOTO        L_can_user_read_message808
L_can_user_read_message805:
	MOVLW       _CAN_PASSBACK+0
	MOVWF       FARG_string_cmpnc_text1+0 
	MOVLW       hi_addr(_CAN_PASSBACK+0)
	MOVWF       FARG_string_cmpnc_text1+1 
	MOVLW       higher_addr(_CAN_PASSBACK+0)
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
	GOTO        L_can_user_read_message809
;Expendedora.c,1531 :: 		sizeTotal += sizeKey;
	MOVF        can_user_read_message_sizeKey_L0+0, 0 
	ADDWF       can_user_read_message_sizeTotal_L0+0, 0 
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       can_user_read_message_sizeTotal_L0+0 
;Expendedora.c,1532 :: 		sizeKey = 4;  //4 POR LA FILA
	MOVLW       4
	MOVWF       can_user_read_message_sizeKey_L0+0 
;Expendedora.c,1534 :: 		sizeTotal += sizeKey;
	MOVLW       4
	ADDWF       R0, 1 
	MOVF        R0, 0 
	MOVWF       can_user_read_message_sizeTotal_L0+0 
;Expendedora.c,1535 :: 		sizeKey = 1;
	MOVLW       1
	MOVWF       can_user_read_message_sizeKey_L0+0 
;Expendedora.c,1536 :: 		estatus = can.rxBuffer[sizeTotal];
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
;Expendedora.c,1538 :: 		if(!mysql_read(tablePrepago, prepagoID, fila, &id)){
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
	GOTO        L_can_user_read_message810
;Expendedora.c,1539 :: 		if(id == idConsulta){
	MOVF        can_user_read_message_id_L0+3, 0 
	XORWF       can_user_read_message_idConsulta_L0+3, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__can_user_read_message1349
	MOVF        can_user_read_message_id_L0+2, 0 
	XORWF       can_user_read_message_idConsulta_L0+2, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__can_user_read_message1349
	MOVF        can_user_read_message_id_L0+1, 0 
	XORWF       can_user_read_message_idConsulta_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__can_user_read_message1349
	MOVF        can_user_read_message_id_L0+0, 0 
	XORWF       can_user_read_message_idConsulta_L0+0, 0 
L__can_user_read_message1349:
	BTFSS       STATUS+0, 2 
	GOTO        L_can_user_read_message811
;Expendedora.c,1540 :: 		mysql_write(tablePrepago, prepagoEstatus, fila, estatus, false);
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
;Expendedora.c,1544 :: 		}
L_can_user_read_message811:
;Expendedora.c,1545 :: 		}
L_can_user_read_message810:
;Expendedora.c,1546 :: 		}else if(string_cmpnc(CAN_SPECIAL_DATE, &can.rxBuffer[sizeTotal], sizeKey)){
	GOTO        L_can_user_read_message812
L_can_user_read_message809:
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
	MOVF        can_user_read_message_sizeTotal_L0+0, 0 
	ADDWF       FARG_string_cmpnc_text2+0, 1 
	BTFSC       STATUS+0, 0 
	INCF        FARG_string_cmpnc_text2+1, 1 
	MOVF        can_user_read_message_sizeKey_L0+0, 0 
	MOVWF       FARG_string_cmpnc_bytes+0 
	CALL        _string_cmpnc+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_can_user_read_message813
;Expendedora.c,1548 :: 		sizeTotal += sizeKey;
	MOVF        can_user_read_message_sizeKey_L0+0, 0 
	ADDWF       can_user_read_message_sizeTotal_L0+0, 0 
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       can_user_read_message_sizeTotal_L0+0 
;Expendedora.c,1549 :: 		sizeKey = 4;  //4 POR LA FILA
	MOVLW       4
	MOVWF       can_user_read_message_sizeKey_L0+0 
;Expendedora.c,1551 :: 		sizeTotal += sizeKey;
	MOVLW       4
	ADDWF       R0, 1 
	MOVF        R0, 0 
	MOVWF       can_user_read_message_sizeTotal_L0+0 
;Expendedora.c,1552 :: 		sizeKey = 1;
	MOVLW       1
	MOVWF       can_user_read_message_sizeKey_L0+0 
;Expendedora.c,1553 :: 		estatus = can.rxBuffer[sizeTotal];
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
;Expendedora.c,1555 :: 		sizeTotal += sizeKey;
	INCF        R0, 1 
	MOVF        R0, 0 
	MOVWF       can_user_read_message_sizeTotal_L0+0 
;Expendedora.c,1556 :: 		sizeKey = 12;
	MOVLW       12
	MOVWF       can_user_read_message_sizeKey_L0+0 
;Expendedora.c,1557 :: 		string_cpyn(msjConst, &can.rxBuffer[sizeTotal], sizeKey);
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
;Expendedora.c,1559 :: 		if(!mysql_read(tablePrepago, prepagoID, fila, &id)){
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
	GOTO        L_can_user_read_message814
;Expendedora.c,1560 :: 		if(id == idConsulta){
	MOVF        can_user_read_message_id_L0+3, 0 
	XORWF       can_user_read_message_idConsulta_L0+3, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__can_user_read_message1350
	MOVF        can_user_read_message_id_L0+2, 0 
	XORWF       can_user_read_message_idConsulta_L0+2, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__can_user_read_message1350
	MOVF        can_user_read_message_id_L0+1, 0 
	XORWF       can_user_read_message_idConsulta_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__can_user_read_message1350
	MOVF        can_user_read_message_id_L0+0, 0 
	XORWF       can_user_read_message_idConsulta_L0+0, 0 
L__can_user_read_message1350:
	BTFSS       STATUS+0, 2 
	GOTO        L_can_user_read_message815
;Expendedora.c,1561 :: 		mysql_write(tablePrepago, prepagoEstatus, fila, estatus, false);
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
;Expendedora.c,1562 :: 		mysql_write_string(tablePrepago, prepagoDate, fila, msjConst, false);
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
;Expendedora.c,1566 :: 		}
L_can_user_read_message815:
;Expendedora.c,1567 :: 		}
L_can_user_read_message814:
;Expendedora.c,1568 :: 		}else if(string_cmpnc(CAN_SPECIAL_SALDO, &can.rxBuffer[sizeTotal], sizeKey)){
	GOTO        L_can_user_read_message816
L_can_user_read_message813:
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
	GOTO        L_can_user_read_message817
;Expendedora.c,1570 :: 		sizeTotal += sizeKey;
	MOVF        can_user_read_message_sizeKey_L0+0, 0 
	ADDWF       can_user_read_message_sizeTotal_L0+0, 0 
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       can_user_read_message_sizeTotal_L0+0 
;Expendedora.c,1571 :: 		sizeKey = 4;  //4 POR LA FILA
	MOVLW       4
	MOVWF       can_user_read_message_sizeKey_L0+0 
;Expendedora.c,1573 :: 		sizeTotal += sizeKey;
	MOVLW       4
	ADDWF       R0, 1 
	MOVF        R0, 0 
	MOVWF       can_user_read_message_sizeTotal_L0+0 
;Expendedora.c,1574 :: 		sizeKey = 1;
	MOVLW       1
	MOVWF       can_user_read_message_sizeKey_L0+0 
;Expendedora.c,1575 :: 		estatus = can.rxBuffer[sizeTotal];
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
;Expendedora.c,1577 :: 		sizeTotal += sizeKey;
	INCF        R0, 1 
	MOVF        R0, 0 
	MOVWF       can_user_read_message_sizeTotal_L0+0 
;Expendedora.c,1578 :: 		sizeKey = 8;
	MOVLW       8
	MOVWF       can_user_read_message_sizeKey_L0+0 
;Expendedora.c,1579 :: 		string_cpyn(msjConst, &can.rxBuffer[sizeTotal], sizeKey);
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
;Expendedora.c,1580 :: 		saldo = hexToNum(msjConst);
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
;Expendedora.c,1582 :: 		if(!mysql_read(tablePrepago, prepagoID, fila, &id)){
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
	GOTO        L_can_user_read_message818
;Expendedora.c,1583 :: 		if(id == idConsulta){
	MOVF        can_user_read_message_id_L0+3, 0 
	XORWF       can_user_read_message_idConsulta_L0+3, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__can_user_read_message1351
	MOVF        can_user_read_message_id_L0+2, 0 
	XORWF       can_user_read_message_idConsulta_L0+2, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__can_user_read_message1351
	MOVF        can_user_read_message_id_L0+1, 0 
	XORWF       can_user_read_message_idConsulta_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__can_user_read_message1351
	MOVF        can_user_read_message_id_L0+0, 0 
	XORWF       can_user_read_message_idConsulta_L0+0, 0 
L__can_user_read_message1351:
	BTFSS       STATUS+0, 2 
	GOTO        L_can_user_read_message819
;Expendedora.c,1584 :: 		mysql_write(tablePrepago, prepagoEstatus, fila, estatus, false);
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
;Expendedora.c,1585 :: 		mysql_write(tablePrepago, prepagoSaldo, fila, saldo, false);
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
;Expendedora.c,1589 :: 		}
L_can_user_read_message819:
;Expendedora.c,1590 :: 		}
L_can_user_read_message818:
;Expendedora.c,1591 :: 		}else{
	GOTO        L_can_user_read_message820
L_can_user_read_message817:
;Expendedora.c,1592 :: 		string_addc(bufferEeprom, CAN_TABLE_ERROR);
	MOVLW       _bufferEeprom+0
	MOVWF       FARG_string_addc_destino+0 
	MOVLW       hi_addr(_bufferEeprom+0)
	MOVWF       FARG_string_addc_destino+1 
	MOVLW       _CAN_TABLE_ERROR+0
	MOVWF       FARG_string_addc_addEnd+0 
	MOVLW       hi_addr(_CAN_TABLE_ERROR+0)
	MOVWF       FARG_string_addc_addEnd+1 
	MOVLW       higher_addr(_CAN_TABLE_ERROR+0)
	MOVWF       FARG_string_addc_addEnd+2 
	CALL        _string_addc+0, 0
;Expendedora.c,1593 :: 		}
L_can_user_read_message820:
L_can_user_read_message816:
L_can_user_read_message812:
L_can_user_read_message808:
L_can_user_read_message804:
L_can_user_read_message800:
L_can_user_read_message795:
L_can_user_read_message791:
;Expendedora.c,1594 :: 		}else if(string_cmpnc(CAN_SOPORTE, &can.rxBuffer[sizeTotal], sizeKey)){
	GOTO        L_can_user_read_message821
L_can_user_read_message786:
	MOVLW       _CAN_SOPORTE+0
	MOVWF       FARG_string_cmpnc_text1+0 
	MOVLW       hi_addr(_CAN_SOPORTE+0)
	MOVWF       FARG_string_cmpnc_text1+1 
	MOVLW       higher_addr(_CAN_SOPORTE+0)
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
	GOTO        L_can_user_read_message822
;Expendedora.c,1596 :: 		sizeTotal += sizeKey;
	MOVF        can_user_read_message_sizeKey_L0+0, 0 
	ADDWF       can_user_read_message_sizeTotal_L0+0, 0 
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       can_user_read_message_sizeTotal_L0+0 
;Expendedora.c,1597 :: 		sizeKey = 6;  //3 Bytes en hexadecimal
	MOVLW       6
	MOVWF       can_user_read_message_sizeKey_L0+0 
;Expendedora.c,1598 :: 		string_cpyn(msjConst, &can.rxBuffer[sizeTotal], sizeKey);
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
;Expendedora.c,1599 :: 		idConsulta = hexToNum(msjConst);
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
;Expendedora.c,1601 :: 		sizeTotal += sizeKey;
	MOVF        can_user_read_message_sizeKey_L0+0, 0 
	ADDWF       can_user_read_message_sizeTotal_L0+0, 0 
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       can_user_read_message_sizeTotal_L0+0 
;Expendedora.c,1602 :: 		sizeKey = sizeof(CAN_REGISTRAR)-1;  //COMANDO 3BYTES
	MOVLW       3
	MOVWF       can_user_read_message_sizeKey_L0+0 
;Expendedora.c,1604 :: 		string_cpyn(msjConst, &can.rxBuffer[sizeTotal+sizeKey], 4); //4 numeros fila
	MOVLW       _msjConst+0
	MOVWF       FARG_string_cpyn_destino+0 
	MOVLW       hi_addr(_msjConst+0)
	MOVWF       FARG_string_cpyn_destino+1 
	MOVLW       3
	ADDWF       R0, 1 
	CLRF        R1 
	MOVLW       0
	ADDWFC      R1, 1 
	MOVLW       _can+107
	ADDWF       R0, 0 
	MOVWF       FARG_string_cpyn_origen+0 
	MOVLW       hi_addr(_can+107)
	ADDWFC      R1, 0 
	MOVWF       FARG_string_cpyn_origen+1 
	MOVLW       4
	MOVWF       FARG_string_cpyn_size+0 
	CALL        _string_cpyn+0, 0
;Expendedora.c,1605 :: 		fila = stringToNum(msjConst);
	MOVLW       _msjConst+0
	MOVWF       FARG_stringToNum_cadena+0 
	MOVLW       hi_addr(_msjConst+0)
	MOVWF       FARG_stringToNum_cadena+1 
	CALL        _stringToNum+0, 0
	MOVF        R0, 0 
	MOVWF       can_user_read_message_fila_L0+0 
	MOVF        R1, 0 
	MOVWF       can_user_read_message_fila_L0+1 
;Expendedora.c,1607 :: 		if(string_cmpnc(CAN_REGISTRAR, &can.rxBuffer[sizeTotal], sizeKey)){
	MOVLW       _CAN_REGISTRAR+0
	MOVWF       FARG_string_cmpnc_text1+0 
	MOVLW       hi_addr(_CAN_REGISTRAR+0)
	MOVWF       FARG_string_cmpnc_text1+1 
	MOVLW       higher_addr(_CAN_REGISTRAR+0)
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
	GOTO        L_can_user_read_message823
;Expendedora.c,1609 :: 		sizeTotal += sizeKey;
	MOVF        can_user_read_message_sizeKey_L0+0, 0 
	ADDWF       can_user_read_message_sizeTotal_L0+0, 1 
;Expendedora.c,1610 :: 		sizeKey = 4;  //4 POR LA FILA
	MOVLW       4
	MOVWF       can_user_read_message_sizeKey_L0+0 
;Expendedora.c,1612 :: 		idNew = idConsulta;
	MOVF        can_user_read_message_idConsulta_L0+0, 0 
	MOVWF       can_user_read_message_idNew_L0+0 
	MOVF        can_user_read_message_idConsulta_L0+1, 0 
	MOVWF       can_user_read_message_idNew_L0+1 
	MOVF        can_user_read_message_idConsulta_L0+2, 0 
	MOVWF       can_user_read_message_idNew_L0+2 
	MOVF        can_user_read_message_idConsulta_L0+3, 0 
	MOVWF       can_user_read_message_idNew_L0+3 
;Expendedora.c,1614 :: 		if(mysql_read(tableSoporte, soporteID, fila, &id) == TABLE_RW_NO_EXIST_ROW){
	MOVLW       _tableSoporte+0
	MOVWF       FARG_mysql_read_name+0 
	MOVLW       hi_addr(_tableSoporte+0)
	MOVWF       FARG_mysql_read_name+1 
	MOVLW       _soporteID+0
	MOVWF       FARG_mysql_read_column+0 
	MOVLW       hi_addr(_soporteID+0)
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
	MOVF        R0, 0 
	XORLW       3
	BTFSS       STATUS+0, 2 
	GOTO        L_can_user_read_message824
;Expendedora.c,1615 :: 		if(fila == myTable.rowAct+1){
	MOVLW       1
	ADDWF       Expendedora_myTable+4, 0 
	MOVWF       R1 
	MOVLW       0
	ADDWFC      Expendedora_myTable+5, 0 
	MOVWF       R2 
	MOVF        can_user_read_message_fila_L0+1, 0 
	XORWF       R2, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__can_user_read_message1352
	MOVF        R1, 0 
	XORWF       can_user_read_message_fila_L0+0, 0 
L__can_user_read_message1352:
	BTFSS       STATUS+0, 2 
	GOTO        L_can_user_read_message825
;Expendedora.c,1616 :: 		if(!mysql_write(tableSoporte, soporteID, -1, idNew, true)){
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
	MOVF        can_user_read_message_idNew_L0+0, 0 
	MOVWF       FARG_mysql_write_value+0 
	MOVF        can_user_read_message_idNew_L0+1, 0 
	MOVWF       FARG_mysql_write_value+1 
	MOVF        can_user_read_message_idNew_L0+2, 0 
	MOVWF       FARG_mysql_write_value+2 
	MOVF        can_user_read_message_idNew_L0+3, 0 
	MOVWF       FARG_mysql_write_value+3 
	MOVLW       1
	MOVWF       FARG_mysql_write_endWrite+0 
	CALL        _mysql_write+0, 0
	MOVF        R0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_can_user_read_message826
;Expendedora.c,1620 :: 		mysql_write(tableSoporte, soporteID, fila, idNew, false);
	MOVLW       _tableSoporte+0
	MOVWF       FARG_mysql_write_name+0 
	MOVLW       hi_addr(_tableSoporte+0)
	MOVWF       FARG_mysql_write_name+1 
	MOVLW       _soporteID+0
	MOVWF       FARG_mysql_write_column+0 
	MOVLW       hi_addr(_soporteID+0)
	MOVWF       FARG_mysql_write_column+1 
	MOVF        can_user_read_message_fila_L0+0, 0 
	MOVWF       FARG_mysql_write_fila+0 
	MOVF        can_user_read_message_fila_L0+1, 0 
	MOVWF       FARG_mysql_write_fila+1 
	MOVF        can_user_read_message_idNew_L0+0, 0 
	MOVWF       FARG_mysql_write_value+0 
	MOVF        can_user_read_message_idNew_L0+1, 0 
	MOVWF       FARG_mysql_write_value+1 
	MOVF        can_user_read_message_idNew_L0+2, 0 
	MOVWF       FARG_mysql_write_value+2 
	MOVF        can_user_read_message_idNew_L0+3, 0 
	MOVWF       FARG_mysql_write_value+3 
	CLRF        FARG_mysql_write_endWrite+0 
	CALL        _mysql_write+0, 0
;Expendedora.c,1621 :: 		}
L_can_user_read_message826:
;Expendedora.c,1622 :: 		}
L_can_user_read_message825:
;Expendedora.c,1623 :: 		}
L_can_user_read_message824:
;Expendedora.c,1624 :: 		}else if(string_cmpnc(CAN_CONSULTAR, &can.rxBuffer[sizeTotal], sizeKey)){
	GOTO        L_can_user_read_message827
L_can_user_read_message823:
	MOVLW       _CAN_CONSULTAR+0
	MOVWF       FARG_string_cmpnc_text1+0 
	MOVLW       hi_addr(_CAN_CONSULTAR+0)
	MOVWF       FARG_string_cmpnc_text1+1 
	MOVLW       higher_addr(_CAN_CONSULTAR+0)
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
	GOTO        L_can_user_read_message828
;Expendedora.c,1626 :: 		sizeTotal += sizeKey;
	MOVF        can_user_read_message_sizeKey_L0+0, 0 
	ADDWF       can_user_read_message_sizeTotal_L0+0, 1 
;Expendedora.c,1627 :: 		sizeKey = 4;  //4 POR LA FILA
	MOVLW       4
	MOVWF       can_user_read_message_sizeKey_L0+0 
;Expendedora.c,1629 :: 		string_cpyc(bufferEeprom, CAN_TPV);
	MOVLW       _bufferEeprom+0
	MOVWF       FARG_string_cpyc_destino+0 
	MOVLW       hi_addr(_bufferEeprom+0)
	MOVWF       FARG_string_cpyc_destino+1 
	MOVLW       _CAN_TPV+0
	MOVWF       FARG_string_cpyc_origen+0 
	MOVLW       hi_addr(_CAN_TPV+0)
	MOVWF       FARG_string_cpyc_origen+1 
	MOVLW       higher_addr(_CAN_TPV+0)
	MOVWF       FARG_string_cpyc_origen+2 
	CALL        _string_cpyc+0, 0
;Expendedora.c,1630 :: 		string_cpyn(&bufferEeprom[sizeof(CAN_TPV)-1], can.rxBuffer, sizeTotal);
	MOVLW       _bufferEeprom+3
	MOVWF       FARG_string_cpyn_destino+0 
	MOVLW       hi_addr(_bufferEeprom+3)
	MOVWF       FARG_string_cpyn_destino+1 
	MOVLW       _can+107
	MOVWF       FARG_string_cpyn_origen+0 
	MOVLW       hi_addr(_can+107)
	MOVWF       FARG_string_cpyn_origen+1 
	MOVF        can_user_read_message_sizeTotal_L0+0, 0 
	MOVWF       FARG_string_cpyn_size+0 
	CALL        _string_cpyn+0, 0
;Expendedora.c,1631 :: 		if(!mysql_read(tableSoporte, soporteID, fila, &id)){
	MOVLW       _tableSoporte+0
	MOVWF       FARG_mysql_read_name+0 
	MOVLW       hi_addr(_tableSoporte+0)
	MOVWF       FARG_mysql_read_name+1 
	MOVLW       _soporteID+0
	MOVWF       FARG_mysql_read_column+0 
	MOVLW       hi_addr(_soporteID+0)
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
	GOTO        L_can_user_read_message829
;Expendedora.c,1632 :: 		if(idConsulta == id){
	MOVF        can_user_read_message_idConsulta_L0+3, 0 
	XORWF       can_user_read_message_id_L0+3, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__can_user_read_message1353
	MOVF        can_user_read_message_idConsulta_L0+2, 0 
	XORWF       can_user_read_message_id_L0+2, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__can_user_read_message1353
	MOVF        can_user_read_message_idConsulta_L0+1, 0 
	XORWF       can_user_read_message_id_L0+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__can_user_read_message1353
	MOVF        can_user_read_message_idConsulta_L0+0, 0 
	XORWF       can_user_read_message_id_L0+0, 0 
L__can_user_read_message1353:
	BTFSS       STATUS+0, 2 
	GOTO        L_can_user_read_message830
;Expendedora.c,1637 :: 		string_addc(bufferEeprom, CAN_MODULE);
	MOVLW       _bufferEeprom+0
	MOVWF       FARG_string_addc_destino+0 
	MOVLW       hi_addr(_bufferEeprom+0)
	MOVWF       FARG_string_addc_destino+1 
	MOVLW       _CAN_MODULE+0
	MOVWF       FARG_string_addc_addEnd+0 
	MOVLW       hi_addr(_CAN_MODULE+0)
	MOVWF       FARG_string_addc_addEnd+1 
	MOVLW       higher_addr(_CAN_MODULE+0)
	MOVWF       FARG_string_addc_addEnd+2 
	CALL        _string_addc+0, 0
;Expendedora.c,1638 :: 		numToHex(can.id, msjConst, 1);
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
;Expendedora.c,1639 :: 		string_add(bufferEeprom, msjConst);
	MOVLW       _bufferEeprom+0
	MOVWF       FARG_string_add_destino+0 
	MOVLW       hi_addr(_bufferEeprom+0)
	MOVWF       FARG_string_add_destino+1 
	MOVLW       _msjConst+0
	MOVWF       FARG_string_add_addEnd+0 
	MOVLW       hi_addr(_msjConst+0)
	MOVWF       FARG_string_add_addEnd+1 
	CALL        _string_add+0, 0
;Expendedora.c,1640 :: 		}else{
	GOTO        L_can_user_read_message831
L_can_user_read_message830:
;Expendedora.c,1641 :: 		string_addc(bufferEeprom, CAN_TABLE_NO_FOUND);
	MOVLW       _bufferEeprom+0
	MOVWF       FARG_string_addc_destino+0 
	MOVLW       hi_addr(_bufferEeprom+0)
	MOVWF       FARG_string_addc_destino+1 
	MOVLW       _CAN_TABLE_NO_FOUND+0
	MOVWF       FARG_string_addc_addEnd+0 
	MOVLW       hi_addr(_CAN_TABLE_NO_FOUND+0)
	MOVWF       FARG_string_addc_addEnd+1 
	MOVLW       higher_addr(_CAN_TABLE_NO_FOUND+0)
	MOVWF       FARG_string_addc_addEnd+2 
	CALL        _string_addc+0, 0
;Expendedora.c,1642 :: 		}
L_can_user_read_message831:
;Expendedora.c,1643 :: 		}else{
	GOTO        L_can_user_read_message832
L_can_user_read_message829:
;Expendedora.c,1644 :: 		string_addc(bufferEeprom, CAN_TABLE_ERROR);
	MOVLW       _bufferEeprom+0
	MOVWF       FARG_string_addc_destino+0 
	MOVLW       hi_addr(_bufferEeprom+0)
	MOVWF       FARG_string_addc_destino+1 
	MOVLW       _CAN_TABLE_ERROR+0
	MOVWF       FARG_string_addc_addEnd+0 
	MOVLW       hi_addr(_CAN_TABLE_ERROR+0)
	MOVWF       FARG_string_addc_addEnd+1 
	MOVLW       higher_addr(_CAN_TABLE_ERROR+0)
	MOVWF       FARG_string_addc_addEnd+2 
	CALL        _string_addc+0, 0
;Expendedora.c,1645 :: 		}
L_can_user_read_message832:
;Expendedora.c,1647 :: 		buffer_save_send(true, bufferEeprom);
	MOVLW       1
	MOVWF       FARG_buffer_save_send_guardar+0 
	MOVLW       _bufferEeprom+0
	MOVWF       FARG_buffer_save_send_buffer+0 
	MOVLW       hi_addr(_bufferEeprom+0)
	MOVWF       FARG_buffer_save_send_buffer+1 
	CALL        _buffer_save_send+0, 0
;Expendedora.c,1648 :: 		}
L_can_user_read_message828:
L_can_user_read_message827:
;Expendedora.c,1649 :: 		}else if(string_cmpnc(CAN_TABLE, &can.rxBuffer[sizeTotal], sizeKey)){
	GOTO        L_can_user_read_message833
L_can_user_read_message822:
	MOVLW       _CAN_TABLE+0
	MOVWF       FARG_string_cmpnc_text1+0 
	MOVLW       hi_addr(_CAN_TABLE+0)
	MOVWF       FARG_string_cmpnc_text1+1 
	MOVLW       higher_addr(_CAN_TABLE+0)
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
	GOTO        L_can_user_read_message834
;Expendedora.c,1650 :: 		sizeTotal += sizeKey;
	MOVF        can_user_read_message_sizeKey_L0+0, 0 
	ADDWF       can_user_read_message_sizeTotal_L0+0, 1 
;Expendedora.c,1651 :: 		sizeKey = sizeof(CAN_TABLE_ERASE)-1;  //FORMATO ALL/T00/EXX
	MOVLW       3
	MOVWF       can_user_read_message_sizeKey_L0+0 
;Expendedora.c,1654 :: 		string_cpyc(bufferEeprom, CAN_TPV);
	MOVLW       _bufferEeprom+0
	MOVWF       FARG_string_cpyc_destino+0 
	MOVLW       hi_addr(_bufferEeprom+0)
	MOVWF       FARG_string_cpyc_destino+1 
	MOVLW       _CAN_TPV+0
	MOVWF       FARG_string_cpyc_origen+0 
	MOVLW       hi_addr(_CAN_TPV+0)
	MOVWF       FARG_string_cpyc_origen+1 
	MOVLW       higher_addr(_CAN_TPV+0)
	MOVWF       FARG_string_cpyc_origen+2 
	CALL        _string_cpyc+0, 0
;Expendedora.c,1655 :: 		string_addc(bufferEeprom, CAN_TABLE);
	MOVLW       _bufferEeprom+0
	MOVWF       FARG_string_addc_destino+0 
	MOVLW       hi_addr(_bufferEeprom+0)
	MOVWF       FARG_string_addc_destino+1 
	MOVLW       _CAN_TABLE+0
	MOVWF       FARG_string_addc_addEnd+0 
	MOVLW       hi_addr(_CAN_TABLE+0)
	MOVWF       FARG_string_addc_addEnd+1 
	MOVLW       higher_addr(_CAN_TABLE+0)
	MOVWF       FARG_string_addc_addEnd+2 
	CALL        _string_addc+0, 0
;Expendedora.c,1658 :: 		if(string_cmpnc(CAN_TABLE_ERASE, &can.rxBuffer[sizeTotal], sizeKey)){
	MOVLW       _CAN_TABLE_ERASE+0
	MOVWF       FARG_string_cmpnc_text1+0 
	MOVLW       hi_addr(_CAN_TABLE_ERASE+0)
	MOVWF       FARG_string_cmpnc_text1+1 
	MOVLW       higher_addr(_CAN_TABLE_ERASE+0)
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
	GOTO        L_can_user_read_message835
;Expendedora.c,1659 :: 		sizeTotal += sizeKey;
	MOVF        can_user_read_message_sizeKey_L0+0, 0 
	ADDWF       can_user_read_message_sizeTotal_L0+0, 0 
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       can_user_read_message_sizeTotal_L0+0 
;Expendedora.c,1660 :: 		if(mysql_erase(&can.rxBuffer[sizeTotal])){
	MOVLW       _can+107
	MOVWF       FARG_mysql_erase_name+0 
	MOVLW       hi_addr(_can+107)
	MOVWF       FARG_mysql_erase_name+1 
	MOVF        R0, 0 
	ADDWF       FARG_mysql_erase_name+0, 1 
	BTFSC       STATUS+0, 0 
	INCF        FARG_mysql_erase_name+1, 1 
	CALL        _mysql_erase+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_can_user_read_message836
;Expendedora.c,1661 :: 		string_addc(bufferEeprom, CAN_TABLE_ERASE);
	MOVLW       _bufferEeprom+0
	MOVWF       FARG_string_addc_destino+0 
	MOVLW       hi_addr(_bufferEeprom+0)
	MOVWF       FARG_string_addc_destino+1 
	MOVLW       _CAN_TABLE_ERASE+0
	MOVWF       FARG_string_addc_addEnd+0 
	MOVLW       hi_addr(_CAN_TABLE_ERASE+0)
	MOVWF       FARG_string_addc_addEnd+1 
	MOVLW       higher_addr(_CAN_TABLE_ERASE+0)
	MOVWF       FARG_string_addc_addEnd+2 
	CALL        _string_addc+0, 0
;Expendedora.c,1663 :: 		string_cpyn(msjConst, &can.rxBuffer[sizeTotal], 3);
	MOVLW       _msjConst+0
	MOVWF       FARG_string_cpyn_destino+0 
	MOVLW       hi_addr(_msjConst+0)
	MOVWF       FARG_string_cpyn_destino+1 
	MOVLW       _can+107
	MOVWF       FARG_string_cpyn_origen+0 
	MOVLW       hi_addr(_can+107)
	MOVWF       FARG_string_cpyn_origen+1 
	MOVF        can_user_read_message_sizeTotal_L0+0, 0 
	ADDWF       FARG_string_cpyn_origen+0, 1 
	BTFSC       STATUS+0, 0 
	INCF        FARG_string_cpyn_origen+1, 1 
	MOVLW       3
	MOVWF       FARG_string_cpyn_size+0 
	CALL        _string_cpyn+0, 0
;Expendedora.c,1664 :: 		string_toUpper(msjConst);
	MOVLW       _msjConst+0
	MOVWF       FARG_string_toUpper_cadena+0 
	MOVLW       hi_addr(_msjConst+0)
	MOVWF       FARG_string_toUpper_cadena+1 
	CALL        _string_toUpper+0, 0
;Expendedora.c,1665 :: 		string_add(bufferEeprom, msjConst);
	MOVLW       _bufferEeprom+0
	MOVWF       FARG_string_add_destino+0 
	MOVLW       hi_addr(_bufferEeprom+0)
	MOVWF       FARG_string_add_destino+1 
	MOVLW       _msjConst+0
	MOVWF       FARG_string_add_addEnd+0 
	MOVLW       hi_addr(_msjConst+0)
	MOVWF       FARG_string_add_addEnd+1 
	CALL        _string_add+0, 0
;Expendedora.c,1666 :: 		}else{
	GOTO        L_can_user_read_message837
L_can_user_read_message836:
;Expendedora.c,1667 :: 		string_addc(bufferEeprom, CAN_TABLE_NO_FOUND);
	MOVLW       _bufferEeprom+0
	MOVWF       FARG_string_addc_destino+0 
	MOVLW       hi_addr(_bufferEeprom+0)
	MOVWF       FARG_string_addc_destino+1 
	MOVLW       _CAN_TABLE_NO_FOUND+0
	MOVWF       FARG_string_addc_addEnd+0 
	MOVLW       hi_addr(_CAN_TABLE_NO_FOUND+0)
	MOVWF       FARG_string_addc_addEnd+1 
	MOVLW       higher_addr(_CAN_TABLE_NO_FOUND+0)
	MOVWF       FARG_string_addc_addEnd+2 
	CALL        _string_addc+0, 0
;Expendedora.c,1668 :: 		}
L_can_user_read_message837:
;Expendedora.c,1673 :: 		}else if(string_cmpnc(CAN_TABLE_INFO, &can.rxBuffer[sizeTotal], sizeKey)){
	GOTO        L_can_user_read_message838
L_can_user_read_message835:
	MOVLW       _CAN_TABLE_INFO+0
	MOVWF       FARG_string_cmpnc_text1+0 
	MOVLW       hi_addr(_CAN_TABLE_INFO+0)
	MOVWF       FARG_string_cmpnc_text1+1 
	MOVLW       higher_addr(_CAN_TABLE_INFO+0)
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
	GOTO        L_can_user_read_message839
;Expendedora.c,1675 :: 		sizeTotal += sizeKey;
	MOVF        can_user_read_message_sizeKey_L0+0, 0 
	ADDWF       can_user_read_message_sizeTotal_L0+0, 0 
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       can_user_read_message_sizeTotal_L0+0 
;Expendedora.c,1677 :: 		if(mysql_exist(&can.rxBuffer[sizeTotal])){
	MOVLW       _can+107
	MOVWF       FARG_mysql_exist_name+0 
	MOVLW       hi_addr(_can+107)
	MOVWF       FARG_mysql_exist_name+1 
	MOVF        R0, 0 
	ADDWF       FARG_mysql_exist_name+0, 1 
	BTFSC       STATUS+0, 0 
	INCF        FARG_mysql_exist_name+1, 1 
	CALL        _mysql_exist+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_can_user_read_message840
;Expendedora.c,1678 :: 		string_addc(bufferEeprom, CAN_TABLE_INFO);
	MOVLW       _bufferEeprom+0
	MOVWF       FARG_string_addc_destino+0 
	MOVLW       hi_addr(_bufferEeprom+0)
	MOVWF       FARG_string_addc_destino+1 
	MOVLW       _CAN_TABLE_INFO+0
	MOVWF       FARG_string_addc_addEnd+0 
	MOVLW       hi_addr(_CAN_TABLE_INFO+0)
	MOVWF       FARG_string_addc_addEnd+1 
	MOVLW       higher_addr(_CAN_TABLE_INFO+0)
	MOVWF       FARG_string_addc_addEnd+2 
	CALL        _string_addc+0, 0
;Expendedora.c,1680 :: 		string_cpyn(msjConst, &can.rxBuffer[sizeTotal], 3);
	MOVLW       _msjConst+0
	MOVWF       FARG_string_cpyn_destino+0 
	MOVLW       hi_addr(_msjConst+0)
	MOVWF       FARG_string_cpyn_destino+1 
	MOVLW       _can+107
	MOVWF       FARG_string_cpyn_origen+0 
	MOVLW       hi_addr(_can+107)
	MOVWF       FARG_string_cpyn_origen+1 
	MOVF        can_user_read_message_sizeTotal_L0+0, 0 
	ADDWF       FARG_string_cpyn_origen+0, 1 
	BTFSC       STATUS+0, 0 
	INCF        FARG_string_cpyn_origen+1, 1 
	MOVLW       3
	MOVWF       FARG_string_cpyn_size+0 
	CALL        _string_cpyn+0, 0
;Expendedora.c,1681 :: 		string_toUpper(msjConst);
	MOVLW       _msjConst+0
	MOVWF       FARG_string_toUpper_cadena+0 
	MOVLW       hi_addr(_msjConst+0)
	MOVWF       FARG_string_toUpper_cadena+1 
	CALL        _string_toUpper+0, 0
;Expendedora.c,1682 :: 		string_add(bufferEeprom, msjConst);
	MOVLW       _bufferEeprom+0
	MOVWF       FARG_string_add_destino+0 
	MOVLW       hi_addr(_bufferEeprom+0)
	MOVWF       FARG_string_add_destino+1 
	MOVLW       _msjConst+0
	MOVWF       FARG_string_add_addEnd+0 
	MOVLW       hi_addr(_msjConst+0)
	MOVWF       FARG_string_add_addEnd+1 
	CALL        _string_add+0, 0
;Expendedora.c,1684 :: 		string_addc(bufferEeprom, FILAS_ACTUALES);
	MOVLW       _bufferEeprom+0
	MOVWF       FARG_string_addc_destino+0 
	MOVLW       hi_addr(_bufferEeprom+0)
	MOVWF       FARG_string_addc_destino+1 
	MOVLW       can_user_read_message_FILAS_ACTUALES_L0+0
	MOVWF       FARG_string_addc_addEnd+0 
	MOVLW       hi_addr(can_user_read_message_FILAS_ACTUALES_L0+0)
	MOVWF       FARG_string_addc_addEnd+1 
	MOVLW       higher_addr(can_user_read_message_FILAS_ACTUALES_L0+0)
	MOVWF       FARG_string_addc_addEnd+2 
	CALL        _string_addc+0, 0
;Expendedora.c,1685 :: 		numToString(myTable.rowAct, msjConst, 4);
	MOVF        Expendedora_myTable+4, 0 
	MOVWF       FARG_numToString_valor+0 
	MOVF        Expendedora_myTable+5, 0 
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
;Expendedora.c,1686 :: 		string_add(bufferEeprom, msjConst);
	MOVLW       _bufferEeprom+0
	MOVWF       FARG_string_add_destino+0 
	MOVLW       hi_addr(_bufferEeprom+0)
	MOVWF       FARG_string_add_destino+1 
	MOVLW       _msjConst+0
	MOVWF       FARG_string_add_addEnd+0 
	MOVLW       hi_addr(_msjConst+0)
	MOVWF       FARG_string_add_addEnd+1 
	CALL        _string_add+0, 0
;Expendedora.c,1688 :: 		string_addc(bufferEeprom, FILAS_PROG);
	MOVLW       _bufferEeprom+0
	MOVWF       FARG_string_addc_destino+0 
	MOVLW       hi_addr(_bufferEeprom+0)
	MOVWF       FARG_string_addc_destino+1 
	MOVLW       can_user_read_message_FILAS_PROG_L0+0
	MOVWF       FARG_string_addc_addEnd+0 
	MOVLW       hi_addr(can_user_read_message_FILAS_PROG_L0+0)
	MOVWF       FARG_string_addc_addEnd+1 
	MOVLW       higher_addr(can_user_read_message_FILAS_PROG_L0+0)
	MOVWF       FARG_string_addc_addEnd+2 
	CALL        _string_addc+0, 0
;Expendedora.c,1689 :: 		numToString(myTable.row, msjConst, 4);
	MOVF        Expendedora_myTable+2, 0 
	MOVWF       FARG_numToString_valor+0 
	MOVF        Expendedora_myTable+3, 0 
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
;Expendedora.c,1690 :: 		string_add(bufferEeprom, msjConst);
	MOVLW       _bufferEeprom+0
	MOVWF       FARG_string_add_destino+0 
	MOVLW       hi_addr(_bufferEeprom+0)
	MOVWF       FARG_string_add_destino+1 
	MOVLW       _msjConst+0
	MOVWF       FARG_string_add_addEnd+0 
	MOVLW       hi_addr(_msjConst+0)
	MOVWF       FARG_string_add_addEnd+1 
	CALL        _string_add+0, 0
;Expendedora.c,1695 :: 		}else{
	GOTO        L_can_user_read_message841
L_can_user_read_message840:
;Expendedora.c,1696 :: 		string_addc(bufferEeprom, CAN_TABLE_NO_FOUND);
	MOVLW       _bufferEeprom+0
	MOVWF       FARG_string_addc_destino+0 
	MOVLW       hi_addr(_bufferEeprom+0)
	MOVWF       FARG_string_addc_destino+1 
	MOVLW       _CAN_TABLE_NO_FOUND+0
	MOVWF       FARG_string_addc_addEnd+0 
	MOVLW       hi_addr(_CAN_TABLE_NO_FOUND+0)
	MOVWF       FARG_string_addc_addEnd+1 
	MOVLW       higher_addr(_CAN_TABLE_NO_FOUND+0)
	MOVWF       FARG_string_addc_addEnd+2 
	CALL        _string_addc+0, 0
;Expendedora.c,1697 :: 		}
L_can_user_read_message841:
;Expendedora.c,1698 :: 		}else if(string_cmpnc(CAN_PASSBACK, &can.rxBuffer[sizeTotal], sizeKey)){
	GOTO        L_can_user_read_message842
L_can_user_read_message839:
	MOVLW       _CAN_PASSBACK+0
	MOVWF       FARG_string_cmpnc_text1+0 
	MOVLW       hi_addr(_CAN_PASSBACK+0)
	MOVWF       FARG_string_cmpnc_text1+1 
	MOVLW       higher_addr(_CAN_PASSBACK+0)
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
	GOTO        L_can_user_read_message843
;Expendedora.c,1700 :: 		sizeTotal += sizeKey;
	MOVF        can_user_read_message_sizeKey_L0+0, 0 
	ADDWF       can_user_read_message_sizeTotal_L0+0, 0 
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       can_user_read_message_sizeTotal_L0+0 
;Expendedora.c,1703 :: 		if(mysql_exist(&can.rxBuffer[sizeTotal])){
	MOVLW       _can+107
	MOVWF       FARG_mysql_exist_name+0 
	MOVLW       hi_addr(_can+107)
	MOVWF       FARG_mysql_exist_name+1 
	MOVF        R0, 0 
	ADDWF       FARG_mysql_exist_name+0, 1 
	BTFSC       STATUS+0, 0 
	INCF        FARG_mysql_exist_name+1, 1 
	CALL        _mysql_exist+0, 0
	MOVF        R0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_can_user_read_message844
;Expendedora.c,1704 :: 		string_addc(bufferEeprom, CAN_PASSBACK);
	MOVLW       _bufferEeprom+0
	MOVWF       FARG_string_addc_destino+0 
	MOVLW       hi_addr(_bufferEeprom+0)
	MOVWF       FARG_string_addc_destino+1 
	MOVLW       _CAN_PASSBACK+0
	MOVWF       FARG_string_addc_addEnd+0 
	MOVLW       hi_addr(_CAN_PASSBACK+0)
	MOVWF       FARG_string_addc_addEnd+1 
	MOVLW       higher_addr(_CAN_PASSBACK+0)
	MOVWF       FARG_string_addc_addEnd+2 
	CALL        _string_addc+0, 0
;Expendedora.c,1706 :: 		string_cpyn(msjConst, &can.rxBuffer[sizeTotal], 3);
	MOVLW       _msjConst+0
	MOVWF       FARG_string_cpyn_destino+0 
	MOVLW       hi_addr(_msjConst+0)
	MOVWF       FARG_string_cpyn_destino+1 
	MOVLW       _can+107
	MOVWF       FARG_string_cpyn_origen+0 
	MOVLW       hi_addr(_can+107)
	MOVWF       FARG_string_cpyn_origen+1 
	MOVF        can_user_read_message_sizeTotal_L0+0, 0 
	ADDWF       FARG_string_cpyn_origen+0, 1 
	BTFSC       STATUS+0, 0 
	INCF        FARG_string_cpyn_origen+1, 1 
	MOVLW       3
	MOVWF       FARG_string_cpyn_size+0 
	CALL        _string_cpyn+0, 0
;Expendedora.c,1707 :: 		string_toUpper(msjConst);
	MOVLW       _msjConst+0
	MOVWF       FARG_string_toUpper_cadena+0 
	MOVLW       hi_addr(_msjConst+0)
	MOVWF       FARG_string_toUpper_cadena+1 
	CALL        _string_toUpper+0, 0
;Expendedora.c,1708 :: 		string_add(bufferEeprom, msjConst);
	MOVLW       _bufferEeprom+0
	MOVWF       FARG_string_add_destino+0 
	MOVLW       hi_addr(_bufferEeprom+0)
	MOVWF       FARG_string_add_destino+1 
	MOVLW       _msjConst+0
	MOVWF       FARG_string_add_addEnd+0 
	MOVLW       hi_addr(_msjConst+0)
	MOVWF       FARG_string_add_addEnd+1 
	CALL        _string_add+0, 0
;Expendedora.c,1711 :: 		for(fila = 1; fila <= myTable.rowAct; fila++)
	MOVLW       1
	MOVWF       can_user_read_message_fila_L0+0 
	MOVLW       0
	MOVWF       can_user_read_message_fila_L0+1 
L_can_user_read_message845:
	MOVF        can_user_read_message_fila_L0+1, 0 
	SUBWF       Expendedora_myTable+5, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__can_user_read_message1354
	MOVF        can_user_read_message_fila_L0+0, 0 
	SUBWF       Expendedora_myTable+4, 0 
L__can_user_read_message1354:
	BTFSS       STATUS+0, 0 
	GOTO        L_can_user_read_message846
;Expendedora.c,1712 :: 		mysql_write(&can.rxBuffer[sizeTotal], pensionadosEstatus, fila, '-', false);
	MOVLW       _can+107
	MOVWF       FARG_mysql_write_name+0 
	MOVLW       hi_addr(_can+107)
	MOVWF       FARG_mysql_write_name+1 
	MOVF        can_user_read_message_sizeTotal_L0+0, 0 
	ADDWF       FARG_mysql_write_name+0, 1 
	BTFSC       STATUS+0, 0 
	INCF        FARG_mysql_write_name+1, 1 
	MOVLW       _pensionadosEstatus+0
	MOVWF       FARG_mysql_write_column+0 
	MOVLW       hi_addr(_pensionadosEstatus+0)
	MOVWF       FARG_mysql_write_column+1 
	MOVF        can_user_read_message_fila_L0+0, 0 
	MOVWF       FARG_mysql_write_fila+0 
	MOVF        can_user_read_message_fila_L0+1, 0 
	MOVWF       FARG_mysql_write_fila+1 
	MOVLW       45
	MOVWF       FARG_mysql_write_value+0 
	MOVLW       0
	MOVWF       FARG_mysql_write_value+1 
	MOVWF       FARG_mysql_write_value+2 
	MOVWF       FARG_mysql_write_value+3 
	CLRF        FARG_mysql_write_endWrite+0 
	CALL        _mysql_write+0, 0
;Expendedora.c,1711 :: 		for(fila = 1; fila <= myTable.rowAct; fila++)
	INFSNZ      can_user_read_message_fila_L0+0, 1 
	INCF        can_user_read_message_fila_L0+1, 1 
;Expendedora.c,1712 :: 		mysql_write(&can.rxBuffer[sizeTotal], pensionadosEstatus, fila, '-', false);
	GOTO        L_can_user_read_message845
L_can_user_read_message846:
;Expendedora.c,1715 :: 		if(!mysql_write(&can.rxBuffer[sizeTotal], pensionadosEstatus, 1, '-', false))
	MOVLW       _can+107
	MOVWF       FARG_mysql_write_name+0 
	MOVLW       hi_addr(_can+107)
	MOVWF       FARG_mysql_write_name+1 
	MOVF        can_user_read_message_sizeTotal_L0+0, 0 
	ADDWF       FARG_mysql_write_name+0, 1 
	BTFSC       STATUS+0, 0 
	INCF        FARG_mysql_write_name+1, 1 
	MOVLW       _pensionadosEstatus+0
	MOVWF       FARG_mysql_write_column+0 
	MOVLW       hi_addr(_pensionadosEstatus+0)
	MOVWF       FARG_mysql_write_column+1 
	MOVLW       1
	MOVWF       FARG_mysql_write_fila+0 
	MOVLW       0
	MOVWF       FARG_mysql_write_fila+1 
	MOVLW       45
	MOVWF       FARG_mysql_write_value+0 
	MOVLW       0
	MOVWF       FARG_mysql_write_value+1 
	MOVWF       FARG_mysql_write_value+2 
	MOVWF       FARG_mysql_write_value+3 
	CLRF        FARG_mysql_write_endWrite+0 
	CALL        _mysql_write+0, 0
	MOVF        R0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_can_user_read_message848
;Expendedora.c,1716 :: 		string_addc(bufferEeprom, CAN_TABLE_MODIFICADO);
	MOVLW       _bufferEeprom+0
	MOVWF       FARG_string_addc_destino+0 
	MOVLW       hi_addr(_bufferEeprom+0)
	MOVWF       FARG_string_addc_destino+1 
	MOVLW       _CAN_TABLE_MODIFICADO+0
	MOVWF       FARG_string_addc_addEnd+0 
	MOVLW       hi_addr(_CAN_TABLE_MODIFICADO+0)
	MOVWF       FARG_string_addc_addEnd+1 
	MOVLW       higher_addr(_CAN_TABLE_MODIFICADO+0)
	MOVWF       FARG_string_addc_addEnd+2 
	CALL        _string_addc+0, 0
	GOTO        L_can_user_read_message849
L_can_user_read_message848:
;Expendedora.c,1718 :: 		string_addc(bufferEeprom,CAN_TABLE_ERROR);
	MOVLW       _bufferEeprom+0
	MOVWF       FARG_string_addc_destino+0 
	MOVLW       hi_addr(_bufferEeprom+0)
	MOVWF       FARG_string_addc_destino+1 
	MOVLW       _CAN_TABLE_ERROR+0
	MOVWF       FARG_string_addc_addEnd+0 
	MOVLW       hi_addr(_CAN_TABLE_ERROR+0)
	MOVWF       FARG_string_addc_addEnd+1 
	MOVLW       higher_addr(_CAN_TABLE_ERROR+0)
	MOVWF       FARG_string_addc_addEnd+2 
	CALL        _string_addc+0, 0
L_can_user_read_message849:
;Expendedora.c,1719 :: 		}else{
	GOTO        L_can_user_read_message850
L_can_user_read_message844:
;Expendedora.c,1720 :: 		string_addc(bufferEeprom, CAN_TABLE_NO_FOUND);
	MOVLW       _bufferEeprom+0
	MOVWF       FARG_string_addc_destino+0 
	MOVLW       hi_addr(_bufferEeprom+0)
	MOVWF       FARG_string_addc_destino+1 
	MOVLW       _CAN_TABLE_NO_FOUND+0
	MOVWF       FARG_string_addc_addEnd+0 
	MOVLW       hi_addr(_CAN_TABLE_NO_FOUND+0)
	MOVWF       FARG_string_addc_addEnd+1 
	MOVLW       higher_addr(_CAN_TABLE_NO_FOUND+0)
	MOVWF       FARG_string_addc_addEnd+2 
	CALL        _string_addc+0, 0
;Expendedora.c,1721 :: 		}
L_can_user_read_message850:
;Expendedora.c,1722 :: 		}
L_can_user_read_message843:
L_can_user_read_message842:
L_can_user_read_message838:
;Expendedora.c,1724 :: 		string_cpyc(msjConst, CAN_MODULE);
	MOVLW       _msjConst+0
	MOVWF       FARG_string_cpyc_destino+0 
	MOVLW       hi_addr(_msjConst+0)
	MOVWF       FARG_string_cpyc_destino+1 
	MOVLW       _CAN_MODULE+0
	MOVWF       FARG_string_cpyc_origen+0 
	MOVLW       hi_addr(_CAN_MODULE+0)
	MOVWF       FARG_string_cpyc_origen+1 
	MOVLW       higher_addr(_CAN_MODULE+0)
	MOVWF       FARG_string_cpyc_origen+2 
	CALL        _string_cpyc+0, 0
;Expendedora.c,1725 :: 		numToHex(can.id, &msjConst[1], 1);
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
;Expendedora.c,1726 :: 		string_add(bufferEeprom, msjConst);
	MOVLW       _bufferEeprom+0
	MOVWF       FARG_string_add_destino+0 
	MOVLW       hi_addr(_bufferEeprom+0)
	MOVWF       FARG_string_add_destino+1 
	MOVLW       _msjConst+0
	MOVWF       FARG_string_add_addEnd+0 
	MOVLW       hi_addr(_msjConst+0)
	MOVWF       FARG_string_add_addEnd+1 
	CALL        _string_add+0, 0
;Expendedora.c,1728 :: 		buffer_save_send(true, bufferEeprom);
	MOVLW       1
	MOVWF       FARG_buffer_save_send_guardar+0 
	MOVLW       _bufferEeprom+0
	MOVWF       FARG_buffer_save_send_buffer+0 
	MOVLW       hi_addr(_bufferEeprom+0)
	MOVWF       FARG_buffer_save_send_buffer+1 
	CALL        _buffer_save_send+0, 0
;Expendedora.c,1729 :: 		}else if(string_cmpnc(CAN_TABLE_RW, &can.rxBuffer[sizeTotal], sizeKey)){
	GOTO        L_can_user_read_message851
L_can_user_read_message834:
	MOVLW       _CAN_TABLE_RW+0
	MOVWF       FARG_string_cmpnc_text1+0 
	MOVLW       hi_addr(_CAN_TABLE_RW+0)
	MOVWF       FARG_string_cmpnc_text1+1 
	MOVLW       higher_addr(_CAN_TABLE_RW+0)
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
	GOTO        L_can_user_read_message852
;Expendedora.c,1731 :: 		sizeTotal += sizeKey;
	MOVF        can_user_read_message_sizeKey_L0+0, 0 
	ADDWF       can_user_read_message_sizeTotal_L0+0, 0 
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       can_user_read_message_sizeTotal_L0+0 
;Expendedora.c,1732 :: 		sizeKey = 4;
	MOVLW       4
	MOVWF       can_user_read_message_sizeKey_L0+0 
;Expendedora.c,1733 :: 		string_cpyn(msjConst, &can.rxBuffer[sizeTotal], sizeKey);
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
;Expendedora.c,1734 :: 		fila = stringToNum(msjConst);
	MOVLW       _msjConst+0
	MOVWF       FARG_stringToNum_cadena+0 
	MOVLW       hi_addr(_msjConst+0)
	MOVWF       FARG_stringToNum_cadena+1 
	CALL        _stringToNum+0, 0
	MOVF        R0, 0 
	MOVWF       can_user_read_message_fila_L0+0 
	MOVF        R1, 0 
	MOVWF       can_user_read_message_fila_L0+1 
;Expendedora.c,1736 :: 		sizeTotal += sizeKey;
	MOVF        can_user_read_message_sizeKey_L0+0, 0 
	ADDWF       can_user_read_message_sizeTotal_L0+0, 1 
;Expendedora.c,1737 :: 		sizeKey = sizeof(CAN_PENSIONADO)-1;
	MOVLW       3
	MOVWF       can_user_read_message_sizeKey_L0+0 
;Expendedora.c,1739 :: 		string_cpyc(bufferEeprom, CAN_TBL);
	MOVLW       _bufferEeprom+0
	MOVWF       FARG_string_cpyc_destino+0 
	MOVLW       hi_addr(_bufferEeprom+0)
	MOVWF       FARG_string_cpyc_destino+1 
	MOVLW       _CAN_TBL+0
	MOVWF       FARG_string_cpyc_origen+0 
	MOVLW       hi_addr(_CAN_TBL+0)
	MOVWF       FARG_string_cpyc_origen+1 
	MOVLW       higher_addr(_CAN_TBL+0)
	MOVWF       FARG_string_cpyc_origen+2 
	CALL        _string_cpyc+0, 0
;Expendedora.c,1740 :: 		string_addc(bufferEeprom, CAN_MODULE);
	MOVLW       _bufferEeprom+0
	MOVWF       FARG_string_addc_destino+0 
	MOVLW       hi_addr(_bufferEeprom+0)
	MOVWF       FARG_string_addc_destino+1 
	MOVLW       _CAN_MODULE+0
	MOVWF       FARG_string_addc_addEnd+0 
	MOVLW       hi_addr(_CAN_MODULE+0)
	MOVWF       FARG_string_addc_addEnd+1 
	MOVLW       higher_addr(_CAN_MODULE+0)
	MOVWF       FARG_string_addc_addEnd+2 
	CALL        _string_addc+0, 0
;Expendedora.c,1741 :: 		numToHex(can.id, msjConst, 1);
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
;Expendedora.c,1742 :: 		string_add(bufferEeprom, msjConst);
	MOVLW       _bufferEeprom+0
	MOVWF       FARG_string_add_destino+0 
	MOVLW       hi_addr(_bufferEeprom+0)
	MOVWF       FARG_string_add_destino+1 
	MOVLW       _msjConst+0
	MOVWF       FARG_string_add_addEnd+0 
	MOVLW       hi_addr(_msjConst+0)
	MOVWF       FARG_string_add_addEnd+1 
	CALL        _string_add+0, 0
;Expendedora.c,1745 :: 		if(string_cmpnc(CAN_PENSIONADO, &can.rxBuffer[sizeTotal], sizeKey)){
	MOVLW       _CAN_PENSIONADO+0
	MOVWF       FARG_string_cmpnc_text1+0 
	MOVLW       hi_addr(_CAN_PENSIONADO+0)
	MOVWF       FARG_string_cmpnc_text1+1 
	MOVLW       higher_addr(_CAN_PENSIONADO+0)
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
	GOTO        L_can_user_read_message853
;Expendedora.c,1747 :: 		string_addc(bufferEeprom, CAN_PENSIONADO);
	MOVLW       _bufferEeprom+0
	MOVWF       FARG_string_addc_destino+0 
	MOVLW       hi_addr(_bufferEeprom+0)
	MOVWF       FARG_string_addc_destino+1 
	MOVLW       _CAN_PENSIONADO+0
	MOVWF       FARG_string_addc_addEnd+0 
	MOVLW       hi_addr(_CAN_PENSIONADO+0)
	MOVWF       FARG_string_addc_addEnd+1 
	MOVLW       higher_addr(_CAN_PENSIONADO+0)
	MOVWF       FARG_string_addc_addEnd+2 
	CALL        _string_addc+0, 0
;Expendedora.c,1748 :: 		sizeTotal += sizeKey;
	MOVF        can_user_read_message_sizeKey_L0+0, 0 
	ADDWF       can_user_read_message_sizeTotal_L0+0, 0 
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       can_user_read_message_sizeTotal_L0+0 
;Expendedora.c,1749 :: 		sizeKey = sizeof(CAN_TABLE_READ)-1;
	MOVLW       3
	MOVWF       can_user_read_message_sizeKey_L0+0 
;Expendedora.c,1751 :: 		if(string_cmpnc(CAN_TABLE_READ, &can.rxBuffer[sizeTotal], sizeKey)){
	MOVLW       _CAN_TABLE_READ+0
	MOVWF       FARG_string_cmpnc_text1+0 
	MOVLW       hi_addr(_CAN_TABLE_READ+0)
	MOVWF       FARG_string_cmpnc_text1+1 
	MOVLW       higher_addr(_CAN_TABLE_READ+0)
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
	GOTO        L_can_user_read_message854
;Expendedora.c,1752 :: 		if(!mysql_read(tablePensionados, pensionadosID, fila, &id)){
	MOVLW       _tablePensionados+0
	MOVWF       FARG_mysql_read_name+0 
	MOVLW       hi_addr(_tablePensionados+0)
	MOVWF       FARG_mysql_read_name+1 
	MOVLW       _pensionadosID+0
	MOVWF       FARG_mysql_read_column+0 
	MOVLW       hi_addr(_pensionadosID+0)
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
	GOTO        L_can_user_read_message855
;Expendedora.c,1754 :: 		mysql_read_string(tablePensionados, pensionadosVigencia, fila, &vigencia);
	MOVLW       _tablePensionados+0
	MOVWF       FARG_mysql_read_string_name+0 
	MOVLW       hi_addr(_tablePensionados+0)
	MOVWF       FARG_mysql_read_string_name+1 
	MOVLW       _pensionadosVigencia+0
	MOVWF       FARG_mysql_read_string_column+0 
	MOVLW       hi_addr(_pensionadosVigencia+0)
	MOVWF       FARG_mysql_read_string_column+1 
	MOVF        can_user_read_message_fila_L0+0, 0 
	MOVWF       FARG_mysql_read_string_fila+0 
	MOVF        can_user_read_message_fila_L0+1, 0 
	MOVWF       FARG_mysql_read_string_fila+1 
	MOVLW       can_user_read_message_vigencia_L0+0
	MOVWF       FARG_mysql_read_string_result+0 
	MOVLW       hi_addr(can_user_read_message_vigencia_L0+0)
	MOVWF       FARG_mysql_read_string_result+1 
	CALL        _mysql_read_string+0, 0
;Expendedora.c,1755 :: 		mysql_read_string(tablePensionados, pensionadosEstatus, fila, &estatus);
	MOVLW       _tablePensionados+0
	MOVWF       FARG_mysql_read_string_name+0 
	MOVLW       hi_addr(_tablePensionados+0)
	MOVWF       FARG_mysql_read_string_name+1 
	MOVLW       _pensionadosEstatus+0
	MOVWF       FARG_mysql_read_string_column+0 
	MOVLW       hi_addr(_pensionadosEstatus+0)
	MOVWF       FARG_mysql_read_string_column+1 
	MOVF        can_user_read_message_fila_L0+0, 0 
	MOVWF       FARG_mysql_read_string_fila+0 
	MOVF        can_user_read_message_fila_L0+1, 0 
	MOVWF       FARG_mysql_read_string_fila+1 
	MOVLW       can_user_read_message_estatus_L0+0
	MOVWF       FARG_mysql_read_string_result+0 
	MOVLW       hi_addr(can_user_read_message_estatus_L0+0)
	MOVWF       FARG_mysql_read_string_result+1 
	CALL        _mysql_read_string+0, 0
;Expendedora.c,1757 :: 		numToHex(id, msjConst, 3);
	MOVF        can_user_read_message_id_L0+0, 0 
	MOVWF       FARG_numToHex_valor+0 
	MOVF        can_user_read_message_id_L0+1, 0 
	MOVWF       FARG_numToHex_valor+1 
	MOVF        can_user_read_message_id_L0+2, 0 
	MOVWF       FARG_numToHex_valor+2 
	MOVF        can_user_read_message_id_L0+3, 0 
	MOVWF       FARG_numToHex_valor+3 
	MOVLW       _msjConst+0
	MOVWF       FARG_numToHex_cadena+0 
	MOVLW       hi_addr(_msjConst+0)
	MOVWF       FARG_numToHex_cadena+1 
	MOVLW       3
	MOVWF       FARG_numToHex_bytes+0 
	CALL        _numToHex+0, 0
;Expendedora.c,1758 :: 		string_add(bufferEeprom, msjConst);
	MOVLW       _bufferEeprom+0
	MOVWF       FARG_string_add_destino+0 
	MOVLW       hi_addr(_bufferEeprom+0)
	MOVWF       FARG_string_add_destino+1 
	MOVLW       _msjConst+0
	MOVWF       FARG_string_add_addEnd+0 
	MOVLW       hi_addr(_msjConst+0)
	MOVWF       FARG_string_add_addEnd+1 
	CALL        _string_add+0, 0
;Expendedora.c,1759 :: 		string_push(bufferEeprom, vigencia);
	MOVLW       _bufferEeprom+0
	MOVWF       FARG_string_push_texto+0 
	MOVLW       hi_addr(_bufferEeprom+0)
	MOVWF       FARG_string_push_texto+1 
	MOVF        can_user_read_message_vigencia_L0+0, 0 
	MOVWF       FARG_string_push_caracter+0 
	CALL        _string_push+0, 0
;Expendedora.c,1760 :: 		string_push(bufferEeprom, estatus);
	MOVLW       _bufferEeprom+0
	MOVWF       FARG_string_push_texto+0 
	MOVLW       hi_addr(_bufferEeprom+0)
	MOVWF       FARG_string_push_texto+1 
	MOVF        can_user_read_message_estatus_L0+0, 0 
	MOVWF       FARG_string_push_caracter+0 
	CALL        _string_push+0, 0
;Expendedora.c,1761 :: 		}else{
	GOTO        L_can_user_read_message856
L_can_user_read_message855:
;Expendedora.c,1762 :: 		string_addc(bufferEeprom, CAN_TABLE_ERROR);
	MOVLW       _bufferEeprom+0
	MOVWF       FARG_string_addc_destino+0 
	MOVLW       hi_addr(_bufferEeprom+0)
	MOVWF       FARG_string_addc_destino+1 
	MOVLW       _CAN_TABLE_ERROR+0
	MOVWF       FARG_string_addc_addEnd+0 
	MOVLW       hi_addr(_CAN_TABLE_ERROR+0)
	MOVWF       FARG_string_addc_addEnd+1 
	MOVLW       higher_addr(_CAN_TABLE_ERROR+0)
	MOVWF       FARG_string_addc_addEnd+2 
	CALL        _string_addc+0, 0
;Expendedora.c,1763 :: 		}
L_can_user_read_message856:
;Expendedora.c,1764 :: 		}else if(string_cmpnc(CAN_TABLE_WRITE, &can.rxBuffer[sizeTotal], sizeKey)){
	GOTO        L_can_user_read_message857
L_can_user_read_message854:
	MOVLW       _CAN_TABLE_WRITE+0
	MOVWF       FARG_string_cmpnc_text1+0 
	MOVLW       hi_addr(_CAN_TABLE_WRITE+0)
	MOVWF       FARG_string_cmpnc_text1+1 
	MOVLW       higher_addr(_CAN_TABLE_WRITE+0)
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
	GOTO        L_can_user_read_message858
;Expendedora.c,1765 :: 		sizeTotal += sizeKey;
	MOVF        can_user_read_message_sizeKey_L0+0, 0 
	ADDWF       can_user_read_message_sizeTotal_L0+0, 0 
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       can_user_read_message_sizeTotal_L0+0 
;Expendedora.c,1766 :: 		sizeKey = 6;  //3 Bytes en hexadecimal
	MOVLW       6
	MOVWF       can_user_read_message_sizeKey_L0+0 
;Expendedora.c,1767 :: 		string_cpyn(msjConst, &can.rxBuffer[sizeTotal], sizeKey);
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
;Expendedora.c,1768 :: 		idNew = hexToNum(msjConst);
	MOVLW       _msjConst+0
	MOVWF       FARG_hexToNum_hex+0 
	MOVLW       hi_addr(_msjConst+0)
	MOVWF       FARG_hexToNum_hex+1 
	CALL        _hexToNum+0, 0
	MOVF        R0, 0 
	MOVWF       can_user_read_message_idNew_L0+0 
	MOVF        R1, 0 
	MOVWF       can_user_read_message_idNew_L0+1 
	MOVF        R2, 0 
	MOVWF       can_user_read_message_idNew_L0+2 
	MOVF        R3, 0 
	MOVWF       can_user_read_message_idNew_L0+3 
;Expendedora.c,1770 :: 		sizeTotal += sizeKey;
	MOVF        can_user_read_message_sizeKey_L0+0, 0 
	ADDWF       can_user_read_message_sizeTotal_L0+0, 0 
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       can_user_read_message_sizeTotal_L0+0 
;Expendedora.c,1771 :: 		sizeKey = 1;  //1 Byte
	MOVLW       1
	MOVWF       can_user_read_message_sizeKey_L0+0 
;Expendedora.c,1772 :: 		vigencia = can.rxBuffer[sizeTotal];
	MOVLW       _can+107
	MOVWF       FSR0 
	MOVLW       hi_addr(_can+107)
	MOVWF       FSR0H 
	MOVF        R0, 0 
	ADDWF       FSR0, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR0H, 1 
	MOVF        POSTINC0+0, 0 
	MOVWF       can_user_read_message_vigencia_L0+0 
;Expendedora.c,1774 :: 		sizeTotal += sizeKey;
	INCF        R0, 1 
	MOVF        R0, 0 
	MOVWF       can_user_read_message_sizeTotal_L0+0 
;Expendedora.c,1775 :: 		sizeKey = 1;  //1 Byte
	MOVLW       1
	MOVWF       can_user_read_message_sizeKey_L0+0 
;Expendedora.c,1776 :: 		estatus = can.rxBuffer[sizeTotal];
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
;Expendedora.c,1778 :: 		if(!mysql_write(tablePensionados, pensionadosID, fila, id, false)){
	MOVLW       _tablePensionados+0
	MOVWF       FARG_mysql_write_name+0 
	MOVLW       hi_addr(_tablePensionados+0)
	MOVWF       FARG_mysql_write_name+1 
	MOVLW       _pensionadosID+0
	MOVWF       FARG_mysql_write_column+0 
	MOVLW       hi_addr(_pensionadosID+0)
	MOVWF       FARG_mysql_write_column+1 
	MOVF        can_user_read_message_fila_L0+0, 0 
	MOVWF       FARG_mysql_write_fila+0 
	MOVF        can_user_read_message_fila_L0+1, 0 
	MOVWF       FARG_mysql_write_fila+1 
	MOVF        can_user_read_message_id_L0+0, 0 
	MOVWF       FARG_mysql_write_value+0 
	MOVF        can_user_read_message_id_L0+1, 0 
	MOVWF       FARG_mysql_write_value+1 
	MOVF        can_user_read_message_id_L0+2, 0 
	MOVWF       FARG_mysql_write_value+2 
	MOVF        can_user_read_message_id_L0+3, 0 
	MOVWF       FARG_mysql_write_value+3 
	CLRF        FARG_mysql_write_endWrite+0 
	CALL        _mysql_write+0, 0
	MOVF        R0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_can_user_read_message859
;Expendedora.c,1780 :: 		mysql_write(tablePensionados, pensionadosVigencia, fila, vigencia, false);
	MOVLW       _tablePensionados+0
	MOVWF       FARG_mysql_write_name+0 
	MOVLW       hi_addr(_tablePensionados+0)
	MOVWF       FARG_mysql_write_name+1 
	MOVLW       _pensionadosVigencia+0
	MOVWF       FARG_mysql_write_column+0 
	MOVLW       hi_addr(_pensionadosVigencia+0)
	MOVWF       FARG_mysql_write_column+1 
	MOVF        can_user_read_message_fila_L0+0, 0 
	MOVWF       FARG_mysql_write_fila+0 
	MOVF        can_user_read_message_fila_L0+1, 0 
	MOVWF       FARG_mysql_write_fila+1 
	MOVF        can_user_read_message_vigencia_L0+0, 0 
	MOVWF       FARG_mysql_write_value+0 
	MOVLW       0
	MOVWF       FARG_mysql_write_value+1 
	MOVWF       FARG_mysql_write_value+2 
	MOVWF       FARG_mysql_write_value+3 
	CLRF        FARG_mysql_write_endWrite+0 
	CALL        _mysql_write+0, 0
;Expendedora.c,1781 :: 		mysql_write(tablePensionados, pensionadosEstatus, fila, estatus, false);
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
;Expendedora.c,1783 :: 		string_addc(bufferEeprom, CAN_TABLE_MODIFICADO);
	MOVLW       _bufferEeprom+0
	MOVWF       FARG_string_addc_destino+0 
	MOVLW       hi_addr(_bufferEeprom+0)
	MOVWF       FARG_string_addc_destino+1 
	MOVLW       _CAN_TABLE_MODIFICADO+0
	MOVWF       FARG_string_addc_addEnd+0 
	MOVLW       hi_addr(_CAN_TABLE_MODIFICADO+0)
	MOVWF       FARG_string_addc_addEnd+1 
	MOVLW       higher_addr(_CAN_TABLE_MODIFICADO+0)
	MOVWF       FARG_string_addc_addEnd+2 
	CALL        _string_addc+0, 0
;Expendedora.c,1784 :: 		}else{
	GOTO        L_can_user_read_message860
L_can_user_read_message859:
;Expendedora.c,1785 :: 		string_addc(bufferEeprom, CAN_TABLE_ERROR);
	MOVLW       _bufferEeprom+0
	MOVWF       FARG_string_addc_destino+0 
	MOVLW       hi_addr(_bufferEeprom+0)
	MOVWF       FARG_string_addc_destino+1 
	MOVLW       _CAN_TABLE_ERROR+0
	MOVWF       FARG_string_addc_addEnd+0 
	MOVLW       hi_addr(_CAN_TABLE_ERROR+0)
	MOVWF       FARG_string_addc_addEnd+1 
	MOVLW       higher_addr(_CAN_TABLE_ERROR+0)
	MOVWF       FARG_string_addc_addEnd+2 
	CALL        _string_addc+0, 0
;Expendedora.c,1786 :: 		}
L_can_user_read_message860:
;Expendedora.c,1787 :: 		}
L_can_user_read_message858:
L_can_user_read_message857:
;Expendedora.c,1788 :: 		}
L_can_user_read_message853:
;Expendedora.c,1789 :: 		}else if(string_cmpnc(CAN_CMD, &can.rxBuffer[sizeTotal], sizeKey)){
	GOTO        L_can_user_read_message861
L_can_user_read_message852:
	MOVLW       _CAN_CMD+0
	MOVWF       FARG_string_cmpnc_text1+0 
	MOVLW       hi_addr(_CAN_CMD+0)
	MOVWF       FARG_string_cmpnc_text1+1 
	MOVLW       higher_addr(_CAN_CMD+0)
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
	GOTO        L_can_user_read_message862
;Expendedora.c,1790 :: 		sizeTotal += sizeKey;
	MOVF        can_user_read_message_sizeKey_L0+0, 0 
	ADDWF       can_user_read_message_sizeTotal_L0+0, 0 
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       can_user_read_message_sizeTotal_L0+0 
;Expendedora.c,1791 :: 		sizeKey = sizeof(CAN_PASSBACK)-1;
	MOVLW       3
	MOVWF       can_user_read_message_sizeKey_L0+0 
;Expendedora.c,1793 :: 		if(string_cmpnc(CAN_PASSBACK, &can.rxBuffer[sizeTotal], sizeKey)){
	MOVLW       _CAN_PASSBACK+0
	MOVWF       FARG_string_cmpnc_text1+0 
	MOVLW       hi_addr(_CAN_PASSBACK+0)
	MOVWF       FARG_string_cmpnc_text1+1 
	MOVLW       higher_addr(_CAN_PASSBACK+0)
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
	GOTO        L_can_user_read_message863
;Expendedora.c,1794 :: 		sizeTotal += sizeKey;
	MOVF        can_user_read_message_sizeKey_L0+0, 0 
	ADDWF       can_user_read_message_sizeTotal_L0+0, 0 
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       can_user_read_message_sizeTotal_L0+0 
;Expendedora.c,1796 :: 		if(can.rxBuffer[sizeTotal] == '1')
	MOVLW       _can+107
	MOVWF       FSR0 
	MOVLW       hi_addr(_can+107)
	MOVWF       FSR0H 
	MOVF        R0, 0 
	ADDWF       FSR0, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR0H, 1 
	MOVF        POSTINC0+0, 0 
	XORLW       49
	BTFSS       STATUS+0, 2 
	GOTO        L_can_user_read_message864
;Expendedora.c,1797 :: 		canSynchrony = true;
	MOVLW       1
	MOVWF       _canSynchrony+0 
	GOTO        L_can_user_read_message865
L_can_user_read_message864:
;Expendedora.c,1799 :: 		canSynchrony = false;
	CLRF        _canSynchrony+0 
L_can_user_read_message865:
;Expendedora.c,1800 :: 		mysql_write(tableSyncronia, columnaEstado, 1, canSynchrony, false);
	MOVLW       _tableSyncronia+0
	MOVWF       FARG_mysql_write_name+0 
	MOVLW       hi_addr(_tableSyncronia+0)
	MOVWF       FARG_mysql_write_name+1 
	MOVLW       _columnaEstado+0
	MOVWF       FARG_mysql_write_column+0 
	MOVLW       hi_addr(_columnaEstado+0)
	MOVWF       FARG_mysql_write_column+1 
	MOVLW       1
	MOVWF       FARG_mysql_write_fila+0 
	MOVLW       0
	MOVWF       FARG_mysql_write_fila+1 
	MOVF        _canSynchrony+0, 0 
	MOVWF       FARG_mysql_write_value+0 
	MOVLW       0
	MOVWF       FARG_mysql_write_value+1 
	MOVWF       FARG_mysql_write_value+2 
	MOVWF       FARG_mysql_write_value+3 
	CLRF        FARG_mysql_write_endWrite+0 
	CALL        _mysql_write+0, 0
;Expendedora.c,1803 :: 		lcd_clean_row(3);
	MOVLW       3
	MOVWF       FARG_lcd_clean_row_fila+0 
	CALL        _lcd_clean_row+0, 0
;Expendedora.c,1804 :: 		lcd_out(3,1,canSynchrony? "Sincronizado":"Desincronizado");
	MOVLW       3
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVF        _canSynchrony+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_can_user_read_message866
	MOVLW       ?lstr28_Expendedora+0
	MOVWF       ?FLOC___can_user_read_messageT3770+0 
	MOVLW       hi_addr(?lstr28_Expendedora+0)
	MOVWF       ?FLOC___can_user_read_messageT3770+1 
	GOTO        L_can_user_read_message867
L_can_user_read_message866:
	MOVLW       ?lstr29_Expendedora+0
	MOVWF       ?FLOC___can_user_read_messageT3770+0 
	MOVLW       hi_addr(?lstr29_Expendedora+0)
	MOVWF       ?FLOC___can_user_read_messageT3770+1 
L_can_user_read_message867:
	MOVF        ?FLOC___can_user_read_messageT3770+0, 0 
	MOVWF       FARG_Lcd_Out_text+0 
	MOVF        ?FLOC___can_user_read_messageT3770+1, 0 
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;Expendedora.c,1806 :: 		string_cpyc(bufferEeprom, CAN_TPV);        //SYN
	MOVLW       _bufferEeprom+0
	MOVWF       FARG_string_cpyc_destino+0 
	MOVLW       hi_addr(_bufferEeprom+0)
	MOVWF       FARG_string_cpyc_destino+1 
	MOVLW       _CAN_TPV+0
	MOVWF       FARG_string_cpyc_origen+0 
	MOVLW       hi_addr(_CAN_TPV+0)
	MOVWF       FARG_string_cpyc_origen+1 
	MOVLW       higher_addr(_CAN_TPV+0)
	MOVWF       FARG_string_cpyc_origen+2 
	CALL        _string_cpyc+0, 0
;Expendedora.c,1807 :: 		string_addc(bufferEeprom, CAN_CMD);
	MOVLW       _bufferEeprom+0
	MOVWF       FARG_string_addc_destino+0 
	MOVLW       hi_addr(_bufferEeprom+0)
	MOVWF       FARG_string_addc_destino+1 
	MOVLW       _CAN_CMD+0
	MOVWF       FARG_string_addc_addEnd+0 
	MOVLW       hi_addr(_CAN_CMD+0)
	MOVWF       FARG_string_addc_addEnd+1 
	MOVLW       higher_addr(_CAN_CMD+0)
	MOVWF       FARG_string_addc_addEnd+2 
	CALL        _string_addc+0, 0
;Expendedora.c,1808 :: 		string_addc(bufferEeprom, CAN_PASSBACK);
	MOVLW       _bufferEeprom+0
	MOVWF       FARG_string_addc_destino+0 
	MOVLW       hi_addr(_bufferEeprom+0)
	MOVWF       FARG_string_addc_destino+1 
	MOVLW       _CAN_PASSBACK+0
	MOVWF       FARG_string_addc_addEnd+0 
	MOVLW       hi_addr(_CAN_PASSBACK+0)
	MOVWF       FARG_string_addc_addEnd+1 
	MOVLW       higher_addr(_CAN_PASSBACK+0)
	MOVWF       FARG_string_addc_addEnd+2 
	CALL        _string_addc+0, 0
;Expendedora.c,1809 :: 		string_push(buffereeprom, canSynchrony+'0');
	MOVLW       _bufferEeprom+0
	MOVWF       FARG_string_push_texto+0 
	MOVLW       hi_addr(_bufferEeprom+0)
	MOVWF       FARG_string_push_texto+1 
	MOVLW       48
	ADDWF       _canSynchrony+0, 0 
	MOVWF       FARG_string_push_caracter+0 
	CALL        _string_push+0, 0
;Expendedora.c,1811 :: 		string_cpyc(msjConst, CAN_MODULE);
	MOVLW       _msjConst+0
	MOVWF       FARG_string_cpyc_destino+0 
	MOVLW       hi_addr(_msjConst+0)
	MOVWF       FARG_string_cpyc_destino+1 
	MOVLW       _CAN_MODULE+0
	MOVWF       FARG_string_cpyc_origen+0 
	MOVLW       hi_addr(_CAN_MODULE+0)
	MOVWF       FARG_string_cpyc_origen+1 
	MOVLW       higher_addr(_CAN_MODULE+0)
	MOVWF       FARG_string_cpyc_origen+2 
	CALL        _string_cpyc+0, 0
;Expendedora.c,1812 :: 		numToHex(can.id, &msjConst[1], 1);
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
;Expendedora.c,1813 :: 		string_add(bufferEeprom, msjConst);
	MOVLW       _bufferEeprom+0
	MOVWF       FARG_string_add_destino+0 
	MOVLW       hi_addr(_bufferEeprom+0)
	MOVWF       FARG_string_add_destino+1 
	MOVLW       _msjConst+0
	MOVWF       FARG_string_add_addEnd+0 
	MOVLW       hi_addr(_msjConst+0)
	MOVWF       FARG_string_add_addEnd+1 
	CALL        _string_add+0, 0
;Expendedora.c,1815 :: 		buffer_save_send(true, bufferEeprom);
	MOVLW       1
	MOVWF       FARG_buffer_save_send_guardar+0 
	MOVLW       _bufferEeprom+0
	MOVWF       FARG_buffer_save_send_buffer+0 
	MOVLW       hi_addr(_bufferEeprom+0)
	MOVWF       FARG_buffer_save_send_buffer+1 
	CALL        _buffer_save_send+0, 0
;Expendedora.c,1820 :: 		}else if(string_cmpnc(CAN_CUPO, &can.rxBuffer[sizeTotal], sizeKey)){
	GOTO        L_can_user_read_message868
L_can_user_read_message863:
	MOVLW       _CAN_CUPO+0
	MOVWF       FARG_string_cmpnc_text1+0 
	MOVLW       hi_addr(_CAN_CUPO+0)
	MOVWF       FARG_string_cmpnc_text1+1 
	MOVLW       higher_addr(_CAN_CUPO+0)
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
	GOTO        L_can_user_read_message869
;Expendedora.c,1821 :: 		sizeTotal += sizeKey;
	MOVF        can_user_read_message_sizeKey_L0+0, 0 
	ADDWF       can_user_read_message_sizeTotal_L0+0, 0 
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       can_user_read_message_sizeTotal_L0+0 
;Expendedora.c,1823 :: 		if(can.rxBuffer[sizeTotal] == '1')
	MOVLW       _can+107
	MOVWF       FSR0 
	MOVLW       hi_addr(_can+107)
	MOVWF       FSR0H 
	MOVF        R0, 0 
	ADDWF       FSR0, 1 
	BTFSC       STATUS+0, 0 
	INCF        FSR0H, 1 
	MOVF        POSTINC0+0, 0 
	XORLW       49
	BTFSS       STATUS+0, 2 
	GOTO        L_can_user_read_message870
;Expendedora.c,1824 :: 		cupoLleno = true;
	MOVLW       1
	MOVWF       _cupoLleno+0 
	GOTO        L_can_user_read_message871
L_can_user_read_message870:
;Expendedora.c,1826 :: 		cupoLleno = false;
	CLRF        _cupoLleno+0 
L_can_user_read_message871:
;Expendedora.c,1827 :: 		mysql_write(tableCupo, columnaEstado, 1, cupoLleno, false);
	MOVLW       _tableCupo+0
	MOVWF       FARG_mysql_write_name+0 
	MOVLW       hi_addr(_tableCupo+0)
	MOVWF       FARG_mysql_write_name+1 
	MOVLW       _columnaEstado+0
	MOVWF       FARG_mysql_write_column+0 
	MOVLW       hi_addr(_columnaEstado+0)
	MOVWF       FARG_mysql_write_column+1 
	MOVLW       1
	MOVWF       FARG_mysql_write_fila+0 
	MOVLW       0
	MOVWF       FARG_mysql_write_fila+1 
	MOVF        _cupoLleno+0, 0 
	MOVWF       FARG_mysql_write_value+0 
	MOVLW       0
	MOVWF       FARG_mysql_write_value+1 
	MOVWF       FARG_mysql_write_value+2 
	MOVWF       FARG_mysql_write_value+3 
	CLRF        FARG_mysql_write_endWrite+0 
	CALL        _mysql_write+0, 0
;Expendedora.c,1829 :: 		lcd_clean_row(3);
	MOVLW       3
	MOVWF       FARG_lcd_clean_row_fila+0 
	CALL        _lcd_clean_row+0, 0
;Expendedora.c,1830 :: 		lcd_out(3,1,cupoLleno? "Cupo lleno":"Cupo disponible");
	MOVLW       3
	MOVWF       FARG_Lcd_Out_row+0 
	MOVLW       1
	MOVWF       FARG_Lcd_Out_column+0 
	MOVF        _cupoLleno+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_can_user_read_message872
	MOVLW       ?lstr30_Expendedora+0
	MOVWF       ?FLOC___can_user_read_messageT3801+0 
	MOVLW       hi_addr(?lstr30_Expendedora+0)
	MOVWF       ?FLOC___can_user_read_messageT3801+1 
	GOTO        L_can_user_read_message873
L_can_user_read_message872:
	MOVLW       ?lstr31_Expendedora+0
	MOVWF       ?FLOC___can_user_read_messageT3801+0 
	MOVLW       hi_addr(?lstr31_Expendedora+0)
	MOVWF       ?FLOC___can_user_read_messageT3801+1 
L_can_user_read_message873:
	MOVF        ?FLOC___can_user_read_messageT3801+0, 0 
	MOVWF       FARG_Lcd_Out_text+0 
	MOVF        ?FLOC___can_user_read_messageT3801+1, 0 
	MOVWF       FARG_Lcd_Out_text+1 
	CALL        _Lcd_Out+0, 0
;Expendedora.c,1832 :: 		string_cpyc(bufferEeprom, CAN_TPV);        //SYN
	MOVLW       _bufferEeprom+0
	MOVWF       FARG_string_cpyc_destino+0 
	MOVLW       hi_addr(_bufferEeprom+0)
	MOVWF       FARG_string_cpyc_destino+1 
	MOVLW       _CAN_TPV+0
	MOVWF       FARG_string_cpyc_origen+0 
	MOVLW       hi_addr(_CAN_TPV+0)
	MOVWF       FARG_string_cpyc_origen+1 
	MOVLW       higher_addr(_CAN_TPV+0)
	MOVWF       FARG_string_cpyc_origen+2 
	CALL        _string_cpyc+0, 0
;Expendedora.c,1833 :: 		string_addc(bufferEeprom, CAN_CMD);
	MOVLW       _bufferEeprom+0
	MOVWF       FARG_string_addc_destino+0 
	MOVLW       hi_addr(_bufferEeprom+0)
	MOVWF       FARG_string_addc_destino+1 
	MOVLW       _CAN_CMD+0
	MOVWF       FARG_string_addc_addEnd+0 
	MOVLW       hi_addr(_CAN_CMD+0)
	MOVWF       FARG_string_addc_addEnd+1 
	MOVLW       higher_addr(_CAN_CMD+0)
	MOVWF       FARG_string_addc_addEnd+2 
	CALL        _string_addc+0, 0
;Expendedora.c,1834 :: 		string_addc(bufferEeprom, CAN_CUPO);
	MOVLW       _bufferEeprom+0
	MOVWF       FARG_string_addc_destino+0 
	MOVLW       hi_addr(_bufferEeprom+0)
	MOVWF       FARG_string_addc_destino+1 
	MOVLW       _CAN_CUPO+0
	MOVWF       FARG_string_addc_addEnd+0 
	MOVLW       hi_addr(_CAN_CUPO+0)
	MOVWF       FARG_string_addc_addEnd+1 
	MOVLW       higher_addr(_CAN_CUPO+0)
	MOVWF       FARG_string_addc_addEnd+2 
	CALL        _string_addc+0, 0
;Expendedora.c,1835 :: 		string_push(buffereeprom, cupoLleno+'0');
	MOVLW       _bufferEeprom+0
	MOVWF       FARG_string_push_texto+0 
	MOVLW       hi_addr(_bufferEeprom+0)
	MOVWF       FARG_string_push_texto+1 
	MOVLW       48
	ADDWF       _cupoLleno+0, 0 
	MOVWF       FARG_string_push_caracter+0 
	CALL        _string_push+0, 0
;Expendedora.c,1837 :: 		string_cpyc(msjConst, CAN_MODULE);
	MOVLW       _msjConst+0
	MOVWF       FARG_string_cpyc_destino+0 
	MOVLW       hi_addr(_msjConst+0)
	MOVWF       FARG_string_cpyc_destino+1 
	MOVLW       _CAN_MODULE+0
	MOVWF       FARG_string_cpyc_origen+0 
	MOVLW       hi_addr(_CAN_MODULE+0)
	MOVWF       FARG_string_cpyc_origen+1 
	MOVLW       higher_addr(_CAN_MODULE+0)
	MOVWF       FARG_string_cpyc_origen+2 
	CALL        _string_cpyc+0, 0
;Expendedora.c,1838 :: 		numToHex(can.id, &msjConst[1], 1);
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
;Expendedora.c,1839 :: 		string_add(bufferEeprom, msjConst);
	MOVLW       _bufferEeprom+0
	MOVWF       FARG_string_add_destino+0 
	MOVLW       hi_addr(_bufferEeprom+0)
	MOVWF       FARG_string_add_destino+1 
	MOVLW       _msjConst+0
	MOVWF       FARG_string_add_addEnd+0 
	MOVLW       hi_addr(_msjConst+0)
	MOVWF       FARG_string_add_addEnd+1 
	CALL        _string_add+0, 0
;Expendedora.c,1841 :: 		buffer_save_send(true, bufferEeprom);
	MOVLW       1
	MOVWF       FARG_buffer_save_send_guardar+0 
	MOVLW       _bufferEeprom+0
	MOVWF       FARG_buffer_save_send_buffer+0 
	MOVLW       hi_addr(_bufferEeprom+0)
	MOVWF       FARG_buffer_save_send_buffer+1 
	CALL        _buffer_save_send+0, 0
;Expendedora.c,1846 :: 		}else if(string_cmpnc(CAN_ABRIR, &can.rxBuffer[sizeTotal], sizeKey)){
	GOTO        L_can_user_read_message874
L_can_user_read_message869:
	MOVLW       _CAN_ABRIR+0
	MOVWF       FARG_string_cmpnc_text1+0 
	MOVLW       hi_addr(_CAN_ABRIR+0)
	MOVWF       FARG_string_cmpnc_text1+1 
	MOVLW       higher_addr(_CAN_ABRIR+0)
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
	GOTO        L_can_user_read_message875
;Expendedora.c,1848 :: 		abrirBarrera = true;
	MOVLW       1
	MOVWF       _abrirBarrera+0 
;Expendedora.c,1849 :: 		SALIDA_RELE1 = 1;
	BSF         PORTA+0, 5 
;Expendedora.c,1850 :: 		SALIDA_RELE2 = 1;
	BSF         PORTE+0, 0 
;Expendedora.c,1851 :: 		timer1_reset();
	CALL        _timer1_reset+0, 0
;Expendedora.c,1852 :: 		timer1_enable(true);
	MOVLW       1
	MOVWF       FARG_timer1_enable_enable+0 
	CALL        _timer1_enable+0, 0
;Expendedora.c,1854 :: 		string_cpyc(bufferEeprom, CAN_TPV);        //SYN
	MOVLW       _bufferEeprom+0
	MOVWF       FARG_string_cpyc_destino+0 
	MOVLW       hi_addr(_bufferEeprom+0)
	MOVWF       FARG_string_cpyc_destino+1 
	MOVLW       _CAN_TPV+0
	MOVWF       FARG_string_cpyc_origen+0 
	MOVLW       hi_addr(_CAN_TPV+0)
	MOVWF       FARG_string_cpyc_origen+1 
	MOVLW       higher_addr(_CAN_TPV+0)
	MOVWF       FARG_string_cpyc_origen+2 
	CALL        _string_cpyc+0, 0
;Expendedora.c,1855 :: 		string_addc(bufferEeprom, CAN_CMD);
	MOVLW       _bufferEeprom+0
	MOVWF       FARG_string_addc_destino+0 
	MOVLW       hi_addr(_bufferEeprom+0)
	MOVWF       FARG_string_addc_destino+1 
	MOVLW       _CAN_CMD+0
	MOVWF       FARG_string_addc_addEnd+0 
	MOVLW       hi_addr(_CAN_CMD+0)
	MOVWF       FARG_string_addc_addEnd+1 
	MOVLW       higher_addr(_CAN_CMD+0)
	MOVWF       FARG_string_addc_addEnd+2 
	CALL        _string_addc+0, 0
;Expendedora.c,1856 :: 		string_addc(bufferEeprom, CAN_ABRIR);
	MOVLW       _bufferEeprom+0
	MOVWF       FARG_string_addc_destino+0 
	MOVLW       hi_addr(_bufferEeprom+0)
	MOVWF       FARG_string_addc_destino+1 
	MOVLW       _CAN_ABRIR+0
	MOVWF       FARG_string_addc_addEnd+0 
	MOVLW       hi_addr(_CAN_ABRIR+0)
	MOVWF       FARG_string_addc_addEnd+1 
	MOVLW       higher_addr(_CAN_ABRIR+0)
	MOVWF       FARG_string_addc_addEnd+2 
	CALL        _string_addc+0, 0
;Expendedora.c,1857 :: 		string_push(buffereeprom, '1');            //Abrio la barrera
	MOVLW       _bufferEeprom+0
	MOVWF       FARG_string_push_texto+0 
	MOVLW       hi_addr(_bufferEeprom+0)
	MOVWF       FARG_string_push_texto+1 
	MOVLW       49
	MOVWF       FARG_string_push_caracter+0 
	CALL        _string_push+0, 0
;Expendedora.c,1859 :: 		string_cpyc(msjConst, CAN_MODULE);
	MOVLW       _msjConst+0
	MOVWF       FARG_string_cpyc_destino+0 
	MOVLW       hi_addr(_msjConst+0)
	MOVWF       FARG_string_cpyc_destino+1 
	MOVLW       _CAN_MODULE+0
	MOVWF       FARG_string_cpyc_origen+0 
	MOVLW       hi_addr(_CAN_MODULE+0)
	MOVWF       FARG_string_cpyc_origen+1 
	MOVLW       higher_addr(_CAN_MODULE+0)
	MOVWF       FARG_string_cpyc_origen+2 
	CALL        _string_cpyc+0, 0
;Expendedora.c,1860 :: 		numToHex(can.id, &msjConst[1], 1);
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
;Expendedora.c,1861 :: 		string_add(bufferEeprom, msjConst);
	MOVLW       _bufferEeprom+0
	MOVWF       FARG_string_add_destino+0 
	MOVLW       hi_addr(_bufferEeprom+0)
	MOVWF       FARG_string_add_destino+1 
	MOVLW       _msjConst+0
	MOVWF       FARG_string_add_addEnd+0 
	MOVLW       hi_addr(_msjConst+0)
	MOVWF       FARG_string_add_addEnd+1 
	CALL        _string_add+0, 0
;Expendedora.c,1863 :: 		buffer_save_send(true, bufferEeprom);
	MOVLW       1
	MOVWF       FARG_buffer_save_send_guardar+0 
	MOVLW       _bufferEeprom+0
	MOVWF       FARG_buffer_save_send_buffer+0 
	MOVLW       hi_addr(_bufferEeprom+0)
	MOVWF       FARG_buffer_save_send_buffer+1 
	CALL        _buffer_save_send+0, 0
;Expendedora.c,1867 :: 		}else if(string_cmpnc(CAN_KEY, &can.rxBuffer[sizeTotal], sizeKey)){
	GOTO        L_can_user_read_message876
L_can_user_read_message875:
	MOVLW       _CAN_KEY+0
	MOVWF       FARG_string_cmpnc_text1+0 
	MOVLW       hi_addr(_CAN_KEY+0)
	MOVWF       FARG_string_cmpnc_text1+1 
	MOVLW       higher_addr(_CAN_KEY+0)
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
	GOTO        L_can_user_read_message877
;Expendedora.c,1868 :: 		sizeTotal += sizeKey;
	MOVF        can_user_read_message_sizeKey_L0+0, 0 
	ADDWF       can_user_read_message_sizeTotal_L0+0, 0 
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       can_user_read_message_sizeTotal_L0+0 
;Expendedora.c,1869 :: 		sizeKey = sizeof(CAN_NIP)-1;
	MOVLW       3
	MOVWF       can_user_read_message_sizeKey_L0+0 
;Expendedora.c,1871 :: 		if(string_cmpnc(CAN_NIP, &can.rxBuffer[sizeTotal], sizeKey)){
	MOVLW       _CAN_NIP+0
	MOVWF       FARG_string_cmpnc_text1+0 
	MOVLW       hi_addr(_CAN_NIP+0)
	MOVWF       FARG_string_cmpnc_text1+1 
	MOVLW       higher_addr(_CAN_NIP+0)
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
	GOTO        L_can_user_read_message878
;Expendedora.c,1872 :: 		sizeTotal += sizeKey;
	MOVF        can_user_read_message_sizeKey_L0+0, 0 
	ADDWF       can_user_read_message_sizeTotal_L0+0, 0 
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       can_user_read_message_sizeTotal_L0+0 
;Expendedora.c,1873 :: 		string_cpyn(msjConst, &can.rxBuffer[sizeTotal], 8);
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
;Expendedora.c,1874 :: 		nip = hexToNum(msjConst);
	MOVLW       _msjConst+0
	MOVWF       FARG_hexToNum_hex+0 
	MOVLW       hi_addr(_msjConst+0)
	MOVWF       FARG_hexToNum_hex+1 
	CALL        _hexToNum+0, 0
	MOVF        R0, 0 
	MOVWF       can_user_read_message_nip_L0+0 
	MOVF        R1, 0 
	MOVWF       can_user_read_message_nip_L0+1 
	MOVF        R2, 0 
	MOVWF       can_user_read_message_nip_L0+2 
	MOVF        R3, 0 
	MOVWF       can_user_read_message_nip_L0+3 
;Expendedora.c,1876 :: 		string_cpyn(msjConst, &can.rxBuffer[sizeTotal+8], 12);
	MOVLW       _msjConst+0
	MOVWF       FARG_string_cpyn_destino+0 
	MOVLW       hi_addr(_msjConst+0)
	MOVWF       FARG_string_cpyn_destino+1 
	MOVLW       8
	ADDWF       can_user_read_message_sizeTotal_L0+0, 0 
	MOVWF       R0 
	CLRF        R1 
	MOVLW       0
	ADDWFC      R1, 1 
	MOVLW       _can+107
	ADDWF       R0, 0 
	MOVWF       FARG_string_cpyn_origen+0 
	MOVLW       hi_addr(_can+107)
	ADDWFC      R1, 0 
	MOVWF       FARG_string_cpyn_origen+1 
	MOVLW       12
	MOVWF       FARG_string_cpyn_size+0 
	CALL        _string_cpyn+0, 0
;Expendedora.c,1878 :: 		if(!mysql_search_forced(tableKeyOutNip, keyOutNip, nip, &fila)){
	MOVLW       _tableKeyOutNip+0
	MOVWF       FARG_mysql_search_forced_tabla+0 
	MOVLW       hi_addr(_tableKeyOutNip+0)
	MOVWF       FARG_mysql_search_forced_tabla+1 
	MOVLW       _keyOutNip+0
	MOVWF       FARG_mysql_search_forced_columna+0 
	MOVLW       hi_addr(_keyOutNip+0)
	MOVWF       FARG_mysql_search_forced_columna+1 
	MOVF        can_user_read_message_nip_L0+0, 0 
	MOVWF       FARG_mysql_search_forced_buscar+0 
	MOVF        can_user_read_message_nip_L0+1, 0 
	MOVWF       FARG_mysql_search_forced_buscar+1 
	MOVF        can_user_read_message_nip_L0+2, 0 
	MOVWF       FARG_mysql_search_forced_buscar+2 
	MOVF        can_user_read_message_nip_L0+3, 0 
	MOVWF       FARG_mysql_search_forced_buscar+3 
	MOVLW       can_user_read_message_fila_L0+0
	MOVWF       FARG_mysql_search_forced_fila+0 
	MOVLW       hi_addr(can_user_read_message_fila_L0+0)
	MOVWF       FARG_mysql_search_forced_fila+1 
	CALL        _mysql_search_forced+0, 0
	MOVF        R0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_can_user_read_message879
;Expendedora.c,1879 :: 		estatus = '0';
	MOVLW       48
	MOVWF       can_user_read_message_estatus_L0+0 
;Expendedora.c,1880 :: 		mysql_write_forced(tableKeyOutNip, keyOutEstatus, fila, &estatus, sizeof(estatus));
	MOVLW       _tableKeyOutNip+0
	MOVWF       FARG_mysql_write_forced_name+0 
	MOVLW       hi_addr(_tableKeyOutNip+0)
	MOVWF       FARG_mysql_write_forced_name+1 
	MOVLW       _keyOutEstatus+0
	MOVWF       FARG_mysql_write_forced_column+0 
	MOVLW       hi_addr(_keyOutEstatus+0)
	MOVWF       FARG_mysql_write_forced_column+1 
	MOVF        can_user_read_message_fila_L0+0, 0 
	MOVWF       FARG_mysql_write_forced_fila+0 
	MOVF        can_user_read_message_fila_L0+1, 0 
	MOVWF       FARG_mysql_write_forced_fila+1 
	MOVLW       can_user_read_message_estatus_L0+0
	MOVWF       FARG_mysql_write_forced_texto+0 
	MOVLW       hi_addr(can_user_read_message_estatus_L0+0)
	MOVWF       FARG_mysql_write_forced_texto+1 
	MOVLW       1
	MOVWF       FARG_mysql_write_forced_bytes+0 
	CALL        _mysql_write_forced+0, 0
;Expendedora.c,1881 :: 		auxNip = -1;  //Nip invalido
	MOVLW       255
	MOVWF       can_user_read_message_auxNip_L0+0 
	MOVLW       255
	MOVWF       can_user_read_message_auxNip_L0+1 
	MOVWF       can_user_read_message_auxNip_L0+2 
	MOVWF       can_user_read_message_auxNip_L0+3 
;Expendedora.c,1882 :: 		mysql_write_forced(tableKeyOutNip, keyOutNip, fila, (char*)&auxNip, sizeof(auxNip));
	MOVLW       _tableKeyOutNip+0
	MOVWF       FARG_mysql_write_forced_name+0 
	MOVLW       hi_addr(_tableKeyOutNip+0)
	MOVWF       FARG_mysql_write_forced_name+1 
	MOVLW       _keyOutNip+0
	MOVWF       FARG_mysql_write_forced_column+0 
	MOVLW       hi_addr(_keyOutNip+0)
	MOVWF       FARG_mysql_write_forced_column+1 
	MOVF        can_user_read_message_fila_L0+0, 0 
	MOVWF       FARG_mysql_write_forced_fila+0 
	MOVF        can_user_read_message_fila_L0+1, 0 
	MOVWF       FARG_mysql_write_forced_fila+1 
	MOVLW       can_user_read_message_auxNip_L0+0
	MOVWF       FARG_mysql_write_forced_texto+0 
	MOVLW       hi_addr(can_user_read_message_auxNip_L0+0)
	MOVWF       FARG_mysql_write_forced_texto+1 
	MOVLW       4
	MOVWF       FARG_mysql_write_forced_bytes+0 
	CALL        _mysql_write_forced+0, 0
;Expendedora.c,1883 :: 		}
L_can_user_read_message879:
;Expendedora.c,1885 :: 		mysql_write_roundTrip(tableKeyOutNip, keyOutEstatus, "1", 1);
	MOVLW       _tableKeyOutNip+0
	MOVWF       FARG_mysql_write_roundTrip_name+0 
	MOVLW       hi_addr(_tableKeyOutNip+0)
	MOVWF       FARG_mysql_write_roundTrip_name+1 
	MOVLW       _keyOutEstatus+0
	MOVWF       FARG_mysql_write_roundTrip_column+0 
	MOVLW       hi_addr(_keyOutEstatus+0)
	MOVWF       FARG_mysql_write_roundTrip_column+1 
	MOVLW       ?lstr32_Expendedora+0
	MOVWF       FARG_mysql_write_roundTrip_texto+0 
	MOVLW       hi_addr(?lstr32_Expendedora+0)
	MOVWF       FARG_mysql_write_roundTrip_texto+1 
	MOVLW       1
	MOVWF       FARG_mysql_write_roundTrip_bytes+0 
	CALL        _mysql_write_roundTrip+0, 0
;Expendedora.c,1886 :: 		mysql_write_forced(tableKeyOutNip, keyOutNip, myTable.rowAct, (char*)&nip, sizeof(nip));
	MOVLW       _tableKeyOutNip+0
	MOVWF       FARG_mysql_write_forced_name+0 
	MOVLW       hi_addr(_tableKeyOutNip+0)
	MOVWF       FARG_mysql_write_forced_name+1 
	MOVLW       _keyOutNip+0
	MOVWF       FARG_mysql_write_forced_column+0 
	MOVLW       hi_addr(_keyOutNip+0)
	MOVWF       FARG_mysql_write_forced_column+1 
	MOVF        Expendedora_myTable+4, 0 
	MOVWF       FARG_mysql_write_forced_fila+0 
	MOVF        Expendedora_myTable+5, 0 
	MOVWF       FARG_mysql_write_forced_fila+1 
	MOVLW       can_user_read_message_nip_L0+0
	MOVWF       FARG_mysql_write_forced_texto+0 
	MOVLW       hi_addr(can_user_read_message_nip_L0+0)
	MOVWF       FARG_mysql_write_forced_texto+1 
	MOVLW       4
	MOVWF       FARG_mysql_write_forced_bytes+0 
	CALL        _mysql_write_forced+0, 0
;Expendedora.c,1887 :: 		mysql_write_forced(tableKeyOutNip, keyOutDate, myTable.rowAct, msjConst, string_len(msjConst)+1);
	MOVLW       _msjConst+0
	MOVWF       FARG_string_len_texto+0 
	MOVLW       hi_addr(_msjConst+0)
	MOVWF       FARG_string_len_texto+1 
	CALL        _string_len+0, 0
	MOVF        R0, 0 
	ADDLW       1
	MOVWF       FARG_mysql_write_forced_bytes+0 
	MOVLW       _tableKeyOutNip+0
	MOVWF       FARG_mysql_write_forced_name+0 
	MOVLW       hi_addr(_tableKeyOutNip+0)
	MOVWF       FARG_mysql_write_forced_name+1 
	MOVLW       _keyOutDate+0
	MOVWF       FARG_mysql_write_forced_column+0 
	MOVLW       hi_addr(_keyOutDate+0)
	MOVWF       FARG_mysql_write_forced_column+1 
	MOVF        Expendedora_myTable+4, 0 
	MOVWF       FARG_mysql_write_forced_fila+0 
	MOVF        Expendedora_myTable+5, 0 
	MOVWF       FARG_mysql_write_forced_fila+1 
	MOVLW       _msjConst+0
	MOVWF       FARG_mysql_write_forced_texto+0 
	MOVLW       hi_addr(_msjConst+0)
	MOVWF       FARG_mysql_write_forced_texto+1 
	CALL        _mysql_write_forced+0, 0
;Expendedora.c,1890 :: 		string_cpyc(bufferEeprom, CAN_TPV);
	MOVLW       _bufferEeprom+0
	MOVWF       FARG_string_cpyc_destino+0 
	MOVLW       hi_addr(_bufferEeprom+0)
	MOVWF       FARG_string_cpyc_destino+1 
	MOVLW       _CAN_TPV+0
	MOVWF       FARG_string_cpyc_origen+0 
	MOVLW       hi_addr(_CAN_TPV+0)
	MOVWF       FARG_string_cpyc_origen+1 
	MOVLW       higher_addr(_CAN_TPV+0)
	MOVWF       FARG_string_cpyc_origen+2 
	CALL        _string_cpyc+0, 0
;Expendedora.c,1891 :: 		string_addc(bufferEeprom, CAN_OUT);
	MOVLW       _bufferEeprom+0
	MOVWF       FARG_string_addc_destino+0 
	MOVLW       hi_addr(_bufferEeprom+0)
	MOVWF       FARG_string_addc_destino+1 
	MOVLW       _CAN_OUT+0
	MOVWF       FARG_string_addc_addEnd+0 
	MOVLW       hi_addr(_CAN_OUT+0)
	MOVWF       FARG_string_addc_addEnd+1 
	MOVLW       higher_addr(_CAN_OUT+0)
	MOVWF       FARG_string_addc_addEnd+2 
	CALL        _string_addc+0, 0
;Expendedora.c,1892 :: 		string_addc(bufferEeprom, CAN_KEY);
	MOVLW       _bufferEeprom+0
	MOVWF       FARG_string_addc_destino+0 
	MOVLW       hi_addr(_bufferEeprom+0)
	MOVWF       FARG_string_addc_destino+1 
	MOVLW       _CAN_KEY+0
	MOVWF       FARG_string_addc_addEnd+0 
	MOVLW       hi_addr(_CAN_KEY+0)
	MOVWF       FARG_string_addc_addEnd+1 
	MOVLW       higher_addr(_CAN_KEY+0)
	MOVWF       FARG_string_addc_addEnd+2 
	CALL        _string_addc+0, 0
;Expendedora.c,1893 :: 		string_addc(bufferEeprom, CAN_NIP);
	MOVLW       _bufferEeprom+0
	MOVWF       FARG_string_addc_destino+0 
	MOVLW       hi_addr(_bufferEeprom+0)
	MOVWF       FARG_string_addc_destino+1 
	MOVLW       _CAN_NIP+0
	MOVWF       FARG_string_addc_addEnd+0 
	MOVLW       hi_addr(_CAN_NIP+0)
	MOVWF       FARG_string_addc_addEnd+1 
	MOVLW       higher_addr(_CAN_NIP+0)
	MOVWF       FARG_string_addc_addEnd+2 
	CALL        _string_addc+0, 0
;Expendedora.c,1894 :: 		numToHex(nip, msjConst, 4);
	MOVF        can_user_read_message_nip_L0+0, 0 
	MOVWF       FARG_numToHex_valor+0 
	MOVF        can_user_read_message_nip_L0+1, 0 
	MOVWF       FARG_numToHex_valor+1 
	MOVF        can_user_read_message_nip_L0+2, 0 
	MOVWF       FARG_numToHex_valor+2 
	MOVF        can_user_read_message_nip_L0+3, 0 
	MOVWF       FARG_numToHex_valor+3 
	MOVLW       _msjConst+0
	MOVWF       FARG_numToHex_cadena+0 
	MOVLW       hi_addr(_msjConst+0)
	MOVWF       FARG_numToHex_cadena+1 
	MOVLW       4
	MOVWF       FARG_numToHex_bytes+0 
	CALL        _numToHex+0, 0
;Expendedora.c,1895 :: 		string_add(bufferEeprom, msjConst);
	MOVLW       _bufferEeprom+0
	MOVWF       FARG_string_add_destino+0 
	MOVLW       hi_addr(_bufferEeprom+0)
	MOVWF       FARG_string_add_destino+1 
	MOVLW       _msjConst+0
	MOVWF       FARG_string_add_addEnd+0 
	MOVLW       hi_addr(_msjConst+0)
	MOVWF       FARG_string_add_addEnd+1 
	CALL        _string_add+0, 0
;Expendedora.c,1896 :: 		string_addc(bufferEeprom, CAN_REGISTRAR);
	MOVLW       _bufferEeprom+0
	MOVWF       FARG_string_addc_destino+0 
	MOVLW       hi_addr(_bufferEeprom+0)
	MOVWF       FARG_string_addc_destino+1 
	MOVLW       _CAN_REGISTRAR+0
	MOVWF       FARG_string_addc_addEnd+0 
	MOVLW       hi_addr(_CAN_REGISTRAR+0)
	MOVWF       FARG_string_addc_addEnd+1 
	MOVLW       higher_addr(_CAN_REGISTRAR+0)
	MOVWF       FARG_string_addc_addEnd+2 
	CALL        _string_addc+0, 0
;Expendedora.c,1898 :: 		string_addc(bufferEeprom, CAN_MODULE);
	MOVLW       _bufferEeprom+0
	MOVWF       FARG_string_addc_destino+0 
	MOVLW       hi_addr(_bufferEeprom+0)
	MOVWF       FARG_string_addc_destino+1 
	MOVLW       _CAN_MODULE+0
	MOVWF       FARG_string_addc_addEnd+0 
	MOVLW       hi_addr(_CAN_MODULE+0)
	MOVWF       FARG_string_addc_addEnd+1 
	MOVLW       higher_addr(_CAN_MODULE+0)
	MOVWF       FARG_string_addc_addEnd+2 
	CALL        _string_addc+0, 0
;Expendedora.c,1899 :: 		numToHex(canId, msjConst, 1);
	MOVF        _canId+0, 0 
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
;Expendedora.c,1900 :: 		string_add(bufferEeprom, msjConst);
	MOVLW       _bufferEeprom+0
	MOVWF       FARG_string_add_destino+0 
	MOVLW       hi_addr(_bufferEeprom+0)
	MOVWF       FARG_string_add_destino+1 
	MOVLW       _msjConst+0
	MOVWF       FARG_string_add_addEnd+0 
	MOVLW       hi_addr(_msjConst+0)
	MOVWF       FARG_string_add_addEnd+1 
	CALL        _string_add+0, 0
;Expendedora.c,1902 :: 		buffer_save_send(true, bufferEeprom);
	MOVLW       1
	MOVWF       FARG_buffer_save_send_guardar+0 
	MOVLW       _bufferEeprom+0
	MOVWF       FARG_buffer_save_send_buffer+0 
	MOVLW       hi_addr(_bufferEeprom+0)
	MOVWF       FARG_buffer_save_send_buffer+1 
	CALL        _buffer_save_send+0, 0
;Expendedora.c,1907 :: 		}
L_can_user_read_message878:
;Expendedora.c,1908 :: 		}else if(string_cmpnc(CAN_FOL, &can.rxBuffer[sizeTotal], sizeKey)){
	GOTO        L_can_user_read_message880
L_can_user_read_message877:
	MOVLW       _CAN_FOL+0
	MOVWF       FARG_string_cmpnc_text1+0 
	MOVLW       hi_addr(_CAN_FOL+0)
	MOVWF       FARG_string_cmpnc_text1+1 
	MOVLW       higher_addr(_CAN_FOL+0)
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
	GOTO        L_can_user_read_message881
;Expendedora.c,1909 :: 		sizeTotal += sizeKey;
	MOVF        can_user_read_message_sizeKey_L0+0, 0 
	ADDWF       can_user_read_message_sizeTotal_L0+0, 0 
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       can_user_read_message_sizeTotal_L0+0 
;Expendedora.c,1910 :: 		sizeKey = sizeof(CAN_TABLE_GET)-1;
	MOVLW       3
	MOVWF       can_user_read_message_sizeKey_L0+0 
;Expendedora.c,1912 :: 		if(string_cmpnc(CAN_TABLE_GET, &can.rxBuffer[sizeTotal], sizeKey)){
	MOVLW       _CAN_TABLE_GET+0
	MOVWF       FARG_string_cmpnc_text1+0 
	MOVLW       hi_addr(_CAN_TABLE_GET+0)
	MOVWF       FARG_string_cmpnc_text1+1 
	MOVLW       higher_addr(_CAN_TABLE_GET+0)
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
	GOTO        L_can_user_read_message882
;Expendedora.c,1913 :: 		sizeTotal += sizeKey;
	MOVF        can_user_read_message_sizeKey_L0+0, 0 
	ADDWF       can_user_read_message_sizeTotal_L0+0, 1 
;Expendedora.c,1914 :: 		string_cpyc(bufferEeprom, CAN_TPV);
	MOVLW       _bufferEeprom+0
	MOVWF       FARG_string_cpyc_destino+0 
	MOVLW       hi_addr(_bufferEeprom+0)
	MOVWF       FARG_string_cpyc_destino+1 
	MOVLW       _CAN_TPV+0
	MOVWF       FARG_string_cpyc_origen+0 
	MOVLW       hi_addr(_CAN_TPV+0)
	MOVWF       FARG_string_cpyc_origen+1 
	MOVLW       higher_addr(_CAN_TPV+0)
	MOVWF       FARG_string_cpyc_origen+2 
	CALL        _string_cpyc+0, 0
;Expendedora.c,1915 :: 		string_addc(bufferEeprom, CAN_FOL);
	MOVLW       _bufferEeprom+0
	MOVWF       FARG_string_addc_destino+0 
	MOVLW       hi_addr(_bufferEeprom+0)
	MOVWF       FARG_string_addc_destino+1 
	MOVLW       _CAN_FOL+0
	MOVWF       FARG_string_addc_addEnd+0 
	MOVLW       hi_addr(_CAN_FOL+0)
	MOVWF       FARG_string_addc_addEnd+1 
	MOVLW       higher_addr(_CAN_FOL+0)
	MOVWF       FARG_string_addc_addEnd+2 
	CALL        _string_addc+0, 0
;Expendedora.c,1916 :: 		string_addc(bufferEeprom, CAN_TABLE_GET);
	MOVLW       _bufferEeprom+0
	MOVWF       FARG_string_addc_destino+0 
	MOVLW       hi_addr(_bufferEeprom+0)
	MOVWF       FARG_string_addc_destino+1 
	MOVLW       _CAN_TABLE_GET+0
	MOVWF       FARG_string_addc_addEnd+0 
	MOVLW       hi_addr(_CAN_TABLE_GET+0)
	MOVWF       FARG_string_addc_addEnd+1 
	MOVLW       higher_addr(_CAN_TABLE_GET+0)
	MOVWF       FARG_string_addc_addEnd+2 
	CALL        _string_addc+0, 0
;Expendedora.c,1918 :: 		mysql_read(tableFolio, folioTotal, 1, &folio);
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
;Expendedora.c,1919 :: 		numToHex(folio, msjConst, 4);
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
;Expendedora.c,1920 :: 		string_add(bufferEeprom, msjConst);
	MOVLW       _bufferEeprom+0
	MOVWF       FARG_string_add_destino+0 
	MOVLW       hi_addr(_bufferEeprom+0)
	MOVWF       FARG_string_add_destino+1 
	MOVLW       _msjConst+0
	MOVWF       FARG_string_add_addEnd+0 
	MOVLW       hi_addr(_msjConst+0)
	MOVWF       FARG_string_add_addEnd+1 
	CALL        _string_add+0, 0
;Expendedora.c,1921 :: 		string_addc(bufferEeprom, CAN_MODULE);
	MOVLW       _bufferEeprom+0
	MOVWF       FARG_string_addc_destino+0 
	MOVLW       hi_addr(_bufferEeprom+0)
	MOVWF       FARG_string_addc_destino+1 
	MOVLW       _CAN_MODULE+0
	MOVWF       FARG_string_addc_addEnd+0 
	MOVLW       hi_addr(_CAN_MODULE+0)
	MOVWF       FARG_string_addc_addEnd+1 
	MOVLW       higher_addr(_CAN_MODULE+0)
	MOVWF       FARG_string_addc_addEnd+2 
	CALL        _string_addc+0, 0
;Expendedora.c,1922 :: 		numToHex(can.id, msjConst, 1);
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
;Expendedora.c,1923 :: 		string_add(bufferEeprom, msjConst);
	MOVLW       _bufferEeprom+0
	MOVWF       FARG_string_add_destino+0 
	MOVLW       hi_addr(_bufferEeprom+0)
	MOVWF       FARG_string_add_destino+1 
	MOVLW       _msjConst+0
	MOVWF       FARG_string_add_addEnd+0 
	MOVLW       hi_addr(_msjConst+0)
	MOVWF       FARG_string_add_addEnd+1 
	CALL        _string_add+0, 0
;Expendedora.c,1924 :: 		buffer_save_send(true, bufferEeprom);
	MOVLW       1
	MOVWF       FARG_buffer_save_send_guardar+0 
	MOVLW       _bufferEeprom+0
	MOVWF       FARG_buffer_save_send_buffer+0 
	MOVLW       hi_addr(_bufferEeprom+0)
	MOVWF       FARG_buffer_save_send_buffer+1 
	CALL        _buffer_save_send+0, 0
;Expendedora.c,1928 :: 		}else if(string_cmpnc(CAN_TABLE_SET, &can.rxBuffer[sizeTotal], sizeKey)){
	GOTO        L_can_user_read_message883
L_can_user_read_message882:
	MOVLW       _CAN_TABLE_SET+0
	MOVWF       FARG_string_cmpnc_text1+0 
	MOVLW       hi_addr(_CAN_TABLE_SET+0)
	MOVWF       FARG_string_cmpnc_text1+1 
	MOVLW       higher_addr(_CAN_TABLE_SET+0)
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
	GOTO        L_can_user_read_message884
;Expendedora.c,1929 :: 		sizeTotal += sizeKey;
	MOVF        can_user_read_message_sizeKey_L0+0, 0 
	ADDWF       can_user_read_message_sizeTotal_L0+0, 0 
	MOVWF       R0 
	MOVF        R0, 0 
	MOVWF       can_user_read_message_sizeTotal_L0+0 
;Expendedora.c,1930 :: 		string_cpyn(msjConst, &can.rxBuffer[sizeTotal], 8);
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
;Expendedora.c,1931 :: 		folio = hexToNum(msjConst);
	MOVLW       _msjConst+0
	MOVWF       FARG_hexToNum_hex+0 
	MOVLW       hi_addr(_msjConst+0)
	MOVWF       FARG_hexToNum_hex+1 
	CALL        _hexToNum+0, 0
	MOVF        R0, 0 
	MOVWF       _folio+0 
	MOVF        R1, 0 
	MOVWF       _folio+1 
	MOVF        R2, 0 
	MOVWF       _folio+2 
	MOVF        R3, 0 
	MOVWF       _folio+3 
;Expendedora.c,1932 :: 		mysql_write(tableFolio, folioTotal, 1, folio, false);
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
;Expendedora.c,1937 :: 		}
L_can_user_read_message884:
L_can_user_read_message883:
;Expendedora.c,1938 :: 		}
L_can_user_read_message881:
L_can_user_read_message880:
L_can_user_read_message876:
L_can_user_read_message874:
L_can_user_read_message868:
;Expendedora.c,1939 :: 		}
L_can_user_read_message862:
L_can_user_read_message861:
L_can_user_read_message851:
L_can_user_read_message833:
L_can_user_read_message821:
L_can_user_read_message785:
L_can_user_read_message780:
;Expendedora.c,1940 :: 		}
L_end_can_user_read_message:
	RETURN      0
; end of _can_user_read_message

_can_user_write_message:

;Expendedora.c,1942 :: 		void can_user_write_message(){
;Expendedora.c,1943 :: 		if(can.tx_status == CAN_RW_ENVIADO){
	MOVF        _can+34, 0 
	XORLW       0
	BTFSS       STATUS+0, 2 
	GOTO        L_can_user_write_message885
;Expendedora.c,1944 :: 		if(modeBufferEventos){
	MOVF        _modeBufferEventos+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_can_user_write_message886
;Expendedora.c,1945 :: 		modeBufferEventos = false;
	CLRF        _modeBufferEventos+0 
;Expendedora.c,1946 :: 		pilaBufferCAN--;
	MOVLW       1
	SUBWF       _pilaBufferCAN+0, 1 
	MOVLW       0
	SUBWFB      _pilaBufferCAN+1, 1 
;Expendedora.c,1947 :: 		mysql_write_forced(tableEventosCAN, eventosEstatus, pilaBufferPointer, "0", 1);
	MOVLW       _tableEventosCAN+0
	MOVWF       FARG_mysql_write_forced_name+0 
	MOVLW       hi_addr(_tableEventosCAN+0)
	MOVWF       FARG_mysql_write_forced_name+1 
	MOVLW       _eventosEstatus+0
	MOVWF       FARG_mysql_write_forced_column+0 
	MOVLW       hi_addr(_eventosEstatus+0)
	MOVWF       FARG_mysql_write_forced_column+1 
	MOVF        _pilaBufferPointer+0, 0 
	MOVWF       FARG_mysql_write_forced_fila+0 
	MOVF        _pilaBufferPointer+1, 0 
	MOVWF       FARG_mysql_write_forced_fila+1 
	MOVLW       ?lstr33_Expendedora+0
	MOVWF       FARG_mysql_write_forced_texto+0 
	MOVLW       hi_addr(?lstr33_Expendedora+0)
	MOVWF       FARG_mysql_write_forced_texto+1 
	MOVLW       1
	MOVWF       FARG_mysql_write_forced_bytes+0 
	CALL        _mysql_write_forced+0, 0
;Expendedora.c,1952 :: 		}
L_can_user_write_message886:
;Expendedora.c,1953 :: 		}else if(can.tx_status == CAN_RW_CORRUPT){
	GOTO        L_can_user_write_message887
L_can_user_write_message885:
	MOVF        _can+34, 0 
	XORLW       3
	BTFSS       STATUS+0, 2 
	GOTO        L_can_user_write_message888
;Expendedora.c,1955 :: 		if(!modeBufferEventos){
	MOVF        _modeBufferEventos+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_can_user_write_message889
;Expendedora.c,1956 :: 		buffer_save_send(true, can.txBuffer);
	MOVLW       1
	MOVWF       FARG_buffer_save_send_guardar+0 
	MOVLW       _can+41
	MOVWF       FARG_buffer_save_send_buffer+0 
	MOVLW       hi_addr(_can+41)
	MOVWF       FARG_buffer_save_send_buffer+1 
	CALL        _buffer_save_send+0, 0
;Expendedora.c,1960 :: 		}else{
	GOTO        L_can_user_write_message890
L_can_user_write_message889:
;Expendedora.c,1962 :: 		modeBufferEventos = false;
	CLRF        _modeBufferEventos+0 
;Expendedora.c,1966 :: 		}
L_can_user_write_message890:
;Expendedora.c,1967 :: 		}
L_can_user_write_message888:
L_can_user_write_message887:
;Expendedora.c,1968 :: 		}
L_end_can_user_write_message:
	RETURN      0
; end of _can_user_write_message

_can_user_guardHeartBeat:

;Expendedora.c,1970 :: 		void can_user_guardHeartBeat(char idNodo){
;Expendedora.c,1972 :: 		}
L_end_can_user_guardHeartBeat:
	RETURN      0
; end of _can_user_guardHeartBeat

_can_heartbeat:

;Expendedora.c,1974 :: 		void can_heartbeat(){
;Expendedora.c,1978 :: 		if(++temp_heartbeat >= TIME_HEARTBEAT){
	INFSNZ      _temp_heartbeat+0, 1 
	INCF        _temp_heartbeat+1, 1 
	MOVLW       0
	SUBWF       _temp_heartbeat+1, 0 
	BTFSS       STATUS+0, 2 
	GOTO        L__can_heartbeat1358
	MOVLW       5
	SUBWF       _temp_heartbeat+0, 0 
L__can_heartbeat1358:
	BTFSS       STATUS+0, 0 
	GOTO        L_can_heartbeat891
;Expendedora.c,1979 :: 		temp_heartbeat = 0;
	CLRF        _temp_heartbeat+0 
	CLRF        _temp_heartbeat+1 
;Expendedora.c,1980 :: 		cmdHeartBeat[0] = can.id;
	MOVF        _can+12, 0 
	MOVWF       can_heartbeat_cmdHeartBeat_L0+0 
;Expendedora.c,1981 :: 		cmdHeartBeat[1] = CAN_PROTOCOL_HEARTBEAT;
	MOVLW       255
	MOVWF       can_heartbeat_cmdHeartBeat_L0+1 
;Expendedora.c,1982 :: 		can_write(can.ip+canIdTPV, cmdHeartBeat, sizeof(cmdHeartBeat), 3, false);
	MOVF        _can+0, 0 
	MOVWF       FARG_can_write_id+0 
	MOVF        _can+1, 0 
	MOVWF       FARG_can_write_id+1 
	MOVF        _can+2, 0 
	MOVWF       FARG_can_write_id+2 
	MOVF        _can+3, 0 
	MOVWF       FARG_can_write_id+3 
	MOVLW       can_heartbeat_cmdHeartBeat_L0+0
	MOVWF       FARG_can_write_datos+0 
	MOVLW       hi_addr(can_heartbeat_cmdHeartBeat_L0+0)
	MOVWF       FARG_can_write_datos+1 
	MOVLW       2
	MOVWF       FARG_can_write_size+0 
	MOVLW       3
	MOVWF       FARG_can_write_priority+0 
	CLRF        FARG_can_write_rtr+0 
	CALL        _can_write+0, 0
;Expendedora.c,1983 :: 		}
L_can_heartbeat891:
;Expendedora.c,1984 :: 		}
L_end_can_heartbeat:
	RETURN      0
; end of _can_heartbeat

_buffer_save_send:

;Expendedora.c,1986 :: 		void buffer_save_send(bool guardar, char *buffer){
;Expendedora.c,1989 :: 		if(!guardar){
	MOVF        FARG_buffer_save_send_guardar+0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_buffer_save_send892
;Expendedora.c,1990 :: 		if(!can_write_text(can.ip+canIdTPV, buffer, 0))
	MOVF        _can+0, 0 
	MOVWF       FARG_can_write_text_ipAddress+0 
	MOVF        _can+1, 0 
	MOVWF       FARG_can_write_text_ipAddress+1 
	MOVF        _can+2, 0 
	MOVWF       FARG_can_write_text_ipAddress+2 
	MOVF        _can+3, 0 
	MOVWF       FARG_can_write_text_ipAddress+3 
	MOVF        FARG_buffer_save_send_buffer+0, 0 
	MOVWF       FARG_can_write_text_texto+0 
	MOVF        FARG_buffer_save_send_buffer+1, 0 
	MOVWF       FARG_can_write_text_texto+1 
	CLRF        FARG_can_write_text_priority+0 
	CALL        _can_write_text+0, 0
	MOVF        R0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_buffer_save_send893
;Expendedora.c,1991 :: 		guardar = true;
	MOVLW       1
	MOVWF       FARG_buffer_save_send_guardar+0 
L_buffer_save_send893:
;Expendedora.c,1992 :: 		}
L_buffer_save_send892:
;Expendedora.c,1994 :: 		if(guardar){
	MOVF        FARG_buffer_save_send_guardar+0, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_buffer_save_send894
;Expendedora.c,1995 :: 		if(!mysql_write_roundTrip(tableEventosCAN, eventosRegistro, buffer, strlen(buffer)+1)){
	MOVF        FARG_buffer_save_send_buffer+0, 0 
	MOVWF       FARG_strlen_s+0 
	MOVF        FARG_buffer_save_send_buffer+1, 0 
	MOVWF       FARG_strlen_s+1 
	CALL        _strlen+0, 0
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
	MOVF        R0, 1 
	BTFSS       STATUS+0, 2 
	GOTO        L_buffer_save_send895
;Expendedora.c,1996 :: 		mysql_read_forced(tableEventosCAN, eventosEstatus, myTable.rowAct, &result);
	MOVLW       _tableEventosCAN+0
	MOVWF       FARG_mysql_read_forced_name+0 
	MOVLW       hi_addr(_tableEventosCAN+0)
	MOVWF       FARG_mysql_read_forced_name+1 
	MOVLW       _eventosEstatus+0
	MOVWF       FARG_mysql_read_forced_column+0 
	MOVLW       hi_addr(_eventosEstatus+0)
	MOVWF       FARG_mysql_read_forced_column+1 
	MOVF        Expendedora_myTable+4, 0 
	MOVWF       FARG_mysql_read_forced_fila+0 
	MOVF        Expendedora_myTable+5, 0 
	MOVWF       FARG_mysql_read_forced_fila+1 
	MOVLW       buffer_save_send_result_L0+0
	MOVWF       FARG_mysql_read_forced_result+0 
	MOVLW       hi_addr(buffer_save_send_result_L0+0)
	MOVWF       FARG_mysql_read_forced_result+1 
	CALL        _mysql_read_forced+0, 0
;Expendedora.c,1998 :: 		if(result != '1')
	MOVF        buffer_save_send_result_L0+0, 0 
	XORLW       49
	BTFSC       STATUS+0, 2 
	GOTO        L_buffer_save_send896
;Expendedora.c,1999 :: 		pilaBufferCAN++;
	INFSNZ      _pilaBufferCAN+0, 1 
	INCF        _pilaBufferCAN+1, 1 
L_buffer_save_send896:
;Expendedora.c,2000 :: 		mysql_write_forced(tableEventosCAN, eventosEstatus, myTable.rowAct, "1", 1);
	MOVLW       _tableEventosCAN+0
	MOVWF       FARG_mysql_write_forced_name+0 
	MOVLW       hi_addr(_tableEventosCAN+0)
	MOVWF       FARG_mysql_write_forced_name+1 
	MOVLW       _eventosEstatus+0
	MOVWF       FARG_mysql_write_forced_column+0 
	MOVLW       hi_addr(_eventosEstatus+0)
	MOVWF       FARG_mysql_write_forced_column+1 
	MOVF        Expendedora_myTable+4, 0 
	MOVWF       FARG_mysql_write_forced_fila+0 
	MOVF        Expendedora_myTable+5, 0 
	MOVWF       FARG_mysql_write_forced_fila+1 
	MOVLW       ?lstr34_Expendedora+0
	MOVWF       FARG_mysql_write_forced_texto+0 
	MOVLW       hi_addr(?lstr34_Expendedora+0)
	MOVWF       FARG_mysql_write_forced_texto+1 
	MOVLW       1
	MOVWF       FARG_mysql_write_forced_bytes+0 
	CALL        _mysql_write_forced+0, 0
;Expendedora.c,2010 :: 		}
L_buffer_save_send895:
;Expendedora.c,2011 :: 		}
L_buffer_save_send894:
;Expendedora.c,2012 :: 		}
L_end_buffer_save_send:
	RETURN      0
; end of _buffer_save_send

_int_timer1:

;Expendedora.c,2016 :: 		void int_timer1(){
;Expendedora.c,2019 :: 		if(PIR1.TMR1IF && PIE1.TMR1IE){
	BTFSS       PIR1+0, 0 
	GOTO        L_int_timer1899
	BTFSS       PIE1+0, 0 
	GOTO        L_int_timer1899
L__int_timer1984:
;Expendedora.c,2021 :: 		if(++temp >= 5){
	INCF        int_timer1_temp_L0+0, 1 
	MOVLW       5
	SUBWF       int_timer1_temp_L0+0, 0 
	BTFSS       STATUS+0, 0 
	GOTO        L_int_timer1900
;Expendedora.c,2022 :: 		temp = 0;
	CLRF        int_timer1_temp_L0+0 
;Expendedora.c,2023 :: 		SALIDA_RELE1 = 0; //APAGAR RELE DESPUES DE UN SEGUNDO
	BCF         PORTA+0, 5 
;Expendedora.c,2024 :: 		SALIDA_RELE2 = 0;
	BCF         PORTE+0, 0 
;Expendedora.c,2025 :: 		PIE1.TMR1IE = 0;  //DESACTIVAR EL TIMER1
	BCF         PIE1+0, 0 
;Expendedora.c,2026 :: 		}
L_int_timer1900:
;Expendedora.c,2029 :: 		TMR1H = getByte(sampler1,1);
	MOVF        _sampler1+1, 0 
	MOVWF       TMR1H+0 
;Expendedora.c,2030 :: 		TMR1L = getByte(sampler1,0);
	MOVF        _sampler1+0, 0 
	MOVWF       TMR1L+0 
;Expendedora.c,2031 :: 		PIR1.TMR1IF = 0;   //LIMPÍAR BANDERA
	BCF         PIR1+0, 0 
;Expendedora.c,2032 :: 		}
L_int_timer1899:
;Expendedora.c,2033 :: 		}
L_end_int_timer1:
	RETURN      0
; end of _int_timer1

_int_timer3:

;Expendedora.c,2035 :: 		void int_timer3(){
;Expendedora.c,2038 :: 		if(PIR2.TMR3IF && PIE2.TMR3IE){
	BTFSS       PIR2+0, 1 
	GOTO        L_int_timer3903
	BTFSS       PIE2+0, 1 
	GOTO        L_int_timer3903
L__int_timer3985:
;Expendedora.c,2039 :: 		can.temp += 200;     //Can protocol
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
;Expendedora.c,2040 :: 		flagTMR3.B0 = true;
	BSF         _flagTMR3+0, 0 
;Expendedora.c,2043 :: 		if(++temp >= 5){
	INCF        int_timer3_temp_L0+0, 1 
	MOVLW       5
	SUBWF       int_timer3_temp_L0+0, 0 
	BTFSS       STATUS+0, 0 
	GOTO        L_int_timer3904
;Expendedora.c,2044 :: 		if(can.conected)
	MOVF        _can+13, 1 
	BTFSC       STATUS+0, 2 
	GOTO        L_int_timer3905
;Expendedora.c,2045 :: 		LED_LINK ^= 1;
	BTG         PORTC+0, 2 
L_int_timer3905:
;Expendedora.c,2046 :: 		temp = 0;
	CLRF        int_timer3_temp_L0+0 
;Expendedora.c,2047 :: 		flagSecondTMR3.B0 = true;
	BSF         _flagSecondTMR3+0, 0 
;Expendedora.c,2048 :: 		}
L_int_timer3904:
;Expendedora.c,2050 :: 		TMR3H = getByte(sampler3,1);
	MOVF        _sampler3+1, 0 
	MOVWF       TMR3H+0 
;Expendedora.c,2051 :: 		TMR3L = getByte(sampler3,0);
	MOVF        _sampler3+0, 0 
	MOVWF       TMR3L+0 
;Expendedora.c,2052 :: 		PIR2.TMR3IF = 0;   //LIMPÍAR BANDERA
	BCF         PIR2+0, 1 
;Expendedora.c,2053 :: 		}
L_int_timer3903:
;Expendedora.c,2054 :: 		}
L_end_int_timer3:
	RETURN      0
; end of _int_timer3
