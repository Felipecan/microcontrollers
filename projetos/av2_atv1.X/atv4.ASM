;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*              MODIFICA��ES PARA USO COM 12F675                   *
;*                FEITAS PELO PROF. MARDSON                        *
;*                    FEVEREIRO DE 2014                            *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                       NOME DO PROJETO                           *
;*                           CLIENTE                               *
;*         DESENVOLVIDO PELA MOSAICO ENGENHARIA E CONSULTORIA      *
;*   VERS�O: 1.0                           DATA: 17/06/03          *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     DESCRI��O DO ARQUIVO                        *
;*-----------------------------------------------------------------*
;*   MODELO PARA O PIC 12F675                                      *
;*                                                                 *
;*                                                                 *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     ARQUIVOS DE DEFINI��ES                      *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
#INCLUDE <p12f675.inc>	;ARQUIVO PADR�O MICROCHIP PARA 12F675

	__CONFIG _BODEN_OFF & _CP_OFF & _PWRTE_ON & _WDT_OFF & _MCLRE_ON & _INTRC_OSC_NOCLKOUT

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                    PAGINA��O DE MEM�RIA                         *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;DEFINI��O DE COMANDOS DE USU�RIO PARA ALTERA��O DA P�GINA DE MEM�RIA
#DEFINE	BANK0	BCF STATUS,RP0	;SETA BANK 0 DE MEM�RIA
#DEFINE	BANK1	BSF STATUS,RP0	;SETA BANK 1 DE MAM�RIA

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                         VARI�VEIS                               *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINI��O DOS NOMES E ENDERE�OS DE TODAS AS VARI�VEIS UTILIZADAS 
; PELO SISTEMA

	CBLOCK	0x20	;ENDERE�O INICIAL DA MEM�RIA DE
					;USU�RIO
		W_TEMP		;REGISTRADORES TEMPOR�RIOS PARA USO
		STATUS_TEMP	;JUNTO �S INTERRUP��ES
		DADO		;ARMAZENA O DADO PARA A EEPROM

		;NOVAS VARI�VEIS
		LIM_READ    ;CONTROLA QUANDO DE ELEMENTOS DA MEM�RIA DEVE SER LIDO OU ESCRITO.
		SWAP_ORD    ;AUXILA NA TROCAR DOS VALORES DE LUGAR NA ORDEN��O.
		TEMP	    ;TEMPOR�RIA, AUXILIAR...
		TEMP_ADDR   ;VARI�VEL QUE AUXILIA NA ORDENA��O SEGURANDO O ENDRE�O DO QUE TIVER O MENOR VALOR (TRABALHA EM CONJUNTO COM TEMP, NA ORDENA��O)
		ORD_ADDR    ;VAR�AVEL QUE QUARDA QUAL ENDERE�O DO PONTEIRO VAI SER TROCADO AO FIM DE CADA LOOP.
		CRTL_LIM_READ; VAR�AVEL QUE CONTROLA A QUANTIDADE DE ELEMENTOS A CADA LOOP DEVER� SER LIDA

	ENDC			;FIM DO BLOCO DE MEM�RIA
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                        FLAGS INTERNOS                           *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINI��O DE TODOS OS FLAGS UTILIZADOS PELO SISTEMA

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                         CONSTANTES                              *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINI��O DE TODAS AS CONSTANTES UTILIZADAS PELO SISTEMA
; INICIALIZA��O DA EEPROM, DE ACORDO COM A DESCRI��O NO ARQUIVO "Def_Rega_Formigas.inc"

;A PARTIR DO ENDERE�O ZERO DA EEPROM, DADOS EM ORDEM ALEAT�RIA
	ORG 0x2100
	DE	0X89,0X1E,0X39,0X9F,0XC2,0X0C,0XAB,0X33,0X63,0XD3,0X95,0X7B,0X38,0XD6,0X1E,0X48
	DE	0XDB,0XD8,0X86,0XFD,0XA5,0XFC,0X0C,0XBE,0X68,0X9B,0XD9,0X10,0XD8,0XEC,0X90,0X91
	DE	0XAA,0XBB,0XCC,0XDD,0XEE,0XF1,0XC9,0X77

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                           ENTRADAS                              *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINI��O DE TODOS OS PINOS QUE SER�O UTILIZADOS COMO ENTRADA
; RECOMENDAMOS TAMB�M COMENTAR O SIGNIFICADO DE SEUS ESTADOS (0 E 1)

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                           SA�DAS                                *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINI��O DE TODOS OS PINOS QUE SER�O UTILIZADOS COMO SA�DA
; RECOMENDAMOS TAMB�M COMENTAR O SIGNIFICADO DE SEUS ESTADOS (0 E 1)

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                       VETOR DE RESET                            *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

	ORG	0x00			;ENDERE�O INICIAL DE PROCESSAMENTO
	GOTO	INICIO
	
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                    IN�CIO DA INTERRUP��O                        *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; ENDERE�O DE DESVIO DAS INTERRUP��ES. A PRIMEIRA TAREFA � SALVAR OS
; VALORES DE "W" E "STATUS" PARA RECUPERA��O FUTURA

	ORG	0x04			;ENDERE�O INICIAL DA INTERRUP��O
	MOVWF	W_TEMP		;COPIA W PARA W_TEMP
	SWAPF	STATUS,W
	MOVWF	STATUS_TEMP	;COPIA STATUS PARA STATUS_TEMP

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                    ROTINA DE INTERRUP��O                        *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; AQUI SER� ESCRITA AS ROTINAS DE RECONHECIMENTO E TRATAMENTO DAS
; INTERRUP��ES

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                 ROTINA DE SA�DA DA INTERRUP��O                  *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; OS VALORES DE "W" E "STATUS" DEVEM SER RECUPERADOS ANTES DE 
; RETORNAR DA INTERRUP��O

SAI_INT
	SWAPF	STATUS_TEMP,W
	MOVWF	STATUS		;MOVE STATUS_TEMP PARA STATUS
	SWAPF	W_TEMP,F
	SWAPF	W_TEMP,W	;MOVE W_TEMP PARA W
	RETFIE

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*	            	 ROTINAS E SUBROTINAS                      *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; CADA ROTINA OU SUBROTINA DEVE POSSUIR A DESCRI��O DE FUNCIONAMENTO
; E UM NOME COERENTE �S SUAS FUN��ES.
LE_EEPROM
;LER DADO DA EEPROM, CUJO ENDERE�O � INDICADO EM W
;DADO LIDO RETORNA EM W
	ANDLW	.127		;LIMITA ENDERE�O MAX. 127
	BANK1				;ACESSO VIA BANK 1
	MOVWF	EEADR		;INDICA O END. DE LEITURA
	BSF		EECON1,RD	;INICIA O PROCESSO DE LEITURA
	MOVF	EEDATA,W	;COLOCA DADO LIDO EM W
	BANK0				;POSICIONA PARA BANK 0
	RETURN

GRAVA_EEPROM
;ESCREVE DADO (DADO) NA EEPROM, CUJO ENDERE�O � INDICADO EM W
	ANDLW	.127		;LIMITA ENDERE�O MAX. 127
	BANK1				;ACESSO VIA BANK 1
	MOVWF	EEADR
	MOVF	DADO,W
	MOVWF	EEDATA
	BSF		EECON1,WREN ;HABILITA ESCRITA
	BCF		INTCON,GIE	;DESLIGA INTERRUP��ES
	MOVLW	B'01010101'	;DESBLOQUEIA ESCRITA
	MOVWF	EECON2		;
	MOVLW	B'10101010'	;DESBLOQUEIA ESCRITA
	MOVWF	EECON2		;
	BSF		EECON1,WR ;INICIA A ESCRITA
AGUARDA
	BTFSC	EECON1,WR ;TERMINOU?
	GOTO	AGUARDA
	BSF		INTCON,GIE ;HABILITA INTERRUP��ES
	BANK0				;POSICIONA PARA BANK 0
	RETURN

SUBROTINA1

	;CORPO DA ROTINA

	RETURN

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     INICIO DO PROGRAMA                          *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
	
INICIO
	BANK1				;ALTERA PARA O BANCO 1
	MOVLW	B'00000000' ;CONFIGURA TODAS AS PORTAS DO GPIO (PINOS)
	MOVWF	TRISIO		;COMO SA�DAS
	CLRF	ANSEL 		;DEFINE PORTAS COMO Digital I/O
	MOVLW	B'00000000'
	MOVWF	OPTION_REG	;DEFINE OP��ES DE OPERA��O
	MOVLW	B'00000000'
	MOVWF	INTCON		;DEFINE OP��ES DE INTERRUP��ES
	BANK0				;RETORNA PARA O BANCO
	MOVLW	B'00000111'
	MOVWF	CMCON		;DEFINE O MODO DE OPERA��O DO COMPARADOR ANAL�GICO

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     INICIALIZA��O DAS VARI�VEIS                 *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
	CLRF	GPIO
	;COMO DEVEMOS SEMPRE LER 40 ELEMENTOS DA MEM�RIA, A VARI�VEL � INCIALIZADA COM VALOR DE 40
	MOVLW	D'40'
	MOVWF	LIM_READ
	MOVWF	CRTL_LIM_READ

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     ROTINA PRINCIPAL                            *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
MAIN

	;CORPO DA ROTINA PRINCIPAL
		
	; ***  INCIO DE LEITURA DOS DADOS DA EEPROM ***
	MOVLW	0x30	;MOVE O VALOR 0x30 PARA O W, E ASSIM SET O FSR PARA O ENDER�O
	MOVWF	FSR	;FSR APONTA PARA O ENDER�O 0x30
	MOVLW	0x00	;MOVE O VALOR 0, PARA O TEMP, QUE IRA TRABALHAR O ENDERE�O NA MEM�RIA EEPROM, NO QUAL INICIA DO ZERO.
	MOVWF	TEMP	;NO MOMENTO, A VARI�VEL IRA TRABALHAR NA MANIPULA��O DO ENDRE�O NA MEM�RIA EEPROM
	
NEXT	CALL	LE_EEPROM
	MOVWF	INDF	;MOVE DA EEPROM PRA O ENDERE�O DA RAM EM QUEST�O
	INCF	FSR	;ATUALIZA O PONTEIRO PARA O PR�XIMO ENDERE�O
	INCF	TEMP	;ATUALIZA O PR�XIMO ENDERE�O PRA EEPROM TAMB�M.
	MOVFW	TEMP	;JOGA O VALOR PRA WORK, ASSIM A FUN��O LE_EEPROM VAI SABER DE ONDE ENDERE�O LER
	DECFSZ	LIM_READ,F  ;CONTROLA QUANDO DEVE SER LIDO, QUANDO CHEGAR AO ZERO DEVE  SAIR.
	GOTO	NEXT
	
	
	; *** INCIO DAS ROTINAS PARA ORDENA��O ***
	; *** INCIALIZA��ES PARA O PRIMEIRO LOOP ***
	BSF	GPIO,GP5    ;GP5 = 1
	MOVLW	0x30	    
	MOVWF	ORD_ADDR    ;SALVA O ENDRE�O DE QUAL VALOR VAI SER TROCADO AO FIM DE CADA LOOP, INCIALMENTE ESSE VALOR � O PRIMEIRO.
	MOVWF	FSR	    ;FSR -> 0x30
	MOVWF	TEMP_ADDR   ;ARMAZENA O ENDERE�O DO PRIMERO ENDERE�O, SERA A PRIMEIRA REFERENCIA. AUXILIANDO NAS TROCAS E COMPARA��O
	MOVFW	INDF
	MOVWF	TEMP	    ;ARMAZENA O VALOR DO PRIMEIRO ENDERA�O DE REFERNECIA EM  TEMP
	MOVLW	D'39'	    ;VALOR A SER ARMAZENADO NO LIMITE DE LEITURA E NO CONTROLE. AQUI � UM A MENOS, PORQUE O ALGORITMO J� INICIA DO SEGUNDO.
	MOVWF	LIM_READ    ;LIM_READ = 30d
	MOVWF	CRTL_LIM_READ
	
	
	;*** INICIO DA ORDENA��O DE FATO ***
ORDENAR	INCF	FSR	    ;NOS COMANDO ACIMA, ARMAZEMOS O VALOR DO PRIMERO EM VARI�VEIS, ENT�O AQUI INCREMENTAMOS UMA, PRA PODER COMPARAR OS VALORES E SEGUIR ADIANTE
	MOVFW	TEMP	    ;MOVE-SE O VALOR DE TEMP PARA WORK, W = TEMP
	SUBWF	INDF,W	    ;SUBTRAI PARA SABER O MENOR; INDF - W(TEMP) = W
	BTFSS	STATUS,C    ;CASO O BIT DE CARRY, O BIT C, FOR IGUAL A ZERO, ENT�O ACHOU ALGO MENOR QUE O QUE T� EM TEMP E VAI ATUALIZ�-LO 
	GOTO	ACHOU_MENOR ;CHAMA ROTINA PARA ATUALIAR O TEMP E O TEMP_ADDR PARA O MENOR VALOR NO LOOP ATUAL
	DECFSZ	LIM_READ,F  ;CONTA QUANTOS ELEMENTOS FORAM VERIFICADOS, ELE SUBTRAI A CADA ELEMENTO, AO ZERAR, TERMINAR O LOOP PARA O VALOR EM QUEST�O
	GOTO	ORDENAR	    ;CASO N�O TENHA ENCONTRADO NADA MENOR E N�O TENHA TERMINADO DE ORDENADAR NO MOMENTO, VOLTA AO LOOP
	GOTO	TROCAR	    ;SE CHEGOU AO FINAL DAS COMPARA��ES, VAI PARAR ROTINA DE ATUALZAR A LISTA DE ORDENA��O

ACHOU_MENOR	MOVFW	FSR	    ;MOVE O VALOR ATUAL, QUE CORRESPONDE AO DO MENOR VALOR, PARA O W
		MOVWF	TEMP_ADDR   ;ATUALIZA O TEMP_ADDR
		MOVFW	INDF	    ;MOVE O VALOR APONTADO POR FSR
		MOVWF	TEMP	    ;ATUALIZA TEMP
		DECFSZ	LIM_READ,F  ;CONTA QUANTOS ELEMENTOS FORAM VERIFICADOS, ELE SUBTRAI A CADA ELEMENTO, AO ZERAR, TERMINAR O LOOP PARA O VALOR EM QUEST�O
		GOTO	ORDENAR	    ;VOLTA AO LOOP DE ORDENA��O
	
TROCAR	MOVFW	ORD_ADDR    ;MOVE O PARA W, O ENDERE�O QUE VAI SER TROCADO 
	MOVWF	FSR	    ;ATUALIZA FSR PARA O ENDRE�O
	MOVFW	INDF	    ;MOVER� O VALOR PARA UMA VARI�VEL DE AJUDA
	MOVWF	SWAP_ORD    ;ARMAZENA O VALOR PARA SER COLOCADO EM OUTRO LUGAR MAIS A FRENTE, ESPECIFICAMENTE, NO ENDERE�O DE TEMPO.
	MOVFW	TEMP	    ;ATUALIZANDO O NOVO VALOR DO ENDERE�O ORD_ADDR PARA O MENOR ARMAZENADO EM TEMP
	MOVWF	INDF	    ;ATUAZIZA O VALOR NOVO PARA O ENDRE�O QUE IRA SER SALVO
	
	MOVFW	TEMP_ADDR   ;VAI AO ENDER�O ONDE A VARI�VEL DO ENDERE�O ORD_ADDR VAI SER SALVA AGORA.
	MOVWF	FSR	    ;ATUALIZA O ENDERE�O.
	MOVFW	SWAP_ORD    ;MOVE O SWAP_ORD
	MOVWF	INDF	    ;SALVA-O EM SUA NOVA POSI��O, POIS ELE � MAIOR QUE O QUE ESTAVA EM TEMP.
	
	
	INCF	ORD_ADDR    ;INCREMENTA UM PARA O ORD_ADDR PARA NOVA REFERENCIA, POIS ELE SER� O PR�XIMO QUE PODER� MUDAR DE LUGAR.
	MOVFW	ORD_ADDR    ;SALVA-O NO FSR E TEMP_ADDR QUE V�O SER AS PR�XIMAS REFERENCIAS NA ORDENA��O
	MOVWF	TEMP_ADDR
	MOVWF	FSR	
	MOVFW	INDF	    ;MOVE O NOVO VALOR DE REFERENCIA PARA W E ASSIM SALVAR NAS VARI�VEIS AUXIALERS.
	MOVWF	TEMP
	DECF	CRTL_LIM_READ    ;DIMINUI NO CONTROLE DE ELEMENTOS
	BTFSC	STATUS,Z	 ;SE A OPERA��O ACIMA FOR ZERO, ENT�O ACABARAM OS ELEMENTOS E � O FIM DA ORDENA��O.
	GOTO	PSEUDO_FIM
	MOVFW	CRTL_LIM_READ	 ;CASO N�O SEJA O FIM, ATUALIZA O CONTADOR DE ELEMENTOS E VOLTA PRA ORDENAR O RESTANTE DOS VALORES.
	MOVWF	LIM_READ
	GOTO	ORDENAR
	
PSEUDO_FIM
	BCF	GPIO,GP5
	
	; *** ESCREVENDO NA EEPROM ***
	MOVLW	D'40'	;REDEFINE O LIMITE DE LEITURA, QUE TAMB�M PODE SER ENTENDIDO COMO ESCRITA
	MOVWF	LIM_READ
	MOVLW	0x30	;CONFIGURA O ENDRE�O DE ONDE DEVE COME�AR A LER NA MEM�RIA RAM
	MOVWF	FSR	;SETA O FSR PARA O ENDERE�O EM QUEST�O
	MOVFW	INDF	;J� PUXA O DADO DO PRIMEIRO ENDERE�O PARA A VARI�VEL DADO
	MOVWF	DADO
	MOVLW	0x00	;AJUSTA O ENDERA�O ONDE SERA ESCREITO NA EEPROM E O DEIXA EM W PARA A FUN��O DE ESCRITA LER DAQUI.
	MOVWF	TEMP

GRAVANDO_EEPROM
	CALL	GRAVA_EEPROM	;CHAMA A FUN��O DE ESCRITA PARA ESCREVER O PRIMEIRO DADO
	INCF	FSR		;ATUALIZA O FSR PARA O PR�XIMO ENDRE�O
	MOVFW	INDF		;PUXA NOVAMENTE O PR�XIMO DADO PARA SALVAR NA VARI�EL DADO.
	CLRF	DADO
	MOVWF	DADO
	INCF	TEMP		;ATUALIZA O TEMP PARA O NOVO ENDERE�O ONDE DEVER� SER SALVO NA PR�XIMA CHAMADA DO GRAVA_EEPROM
	MOVFW	TEMP		;MOVE-O PARA W, PARA ENT�O A FUN��O FUNCIONAR CORRETAMENTE
	DECFSZ	LIM_READ,F	;TESTE SE J� FORAM LIDOS TODOS.
	GOTO	GRAVANDO_EEPROM
	
	
	

	
FIM
	GOTO	FIM

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                       FIM DO PROGRAMA                           *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

	END
