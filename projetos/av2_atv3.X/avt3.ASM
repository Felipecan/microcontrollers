;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*              MODIFICA��ES PARA USO COM 12F675                   *
;*                FEITAS PELO PROF. MARDSON                        *
;*                    FEVEREIRO DE 2016                            *
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

		;NOVAS VARI�VEIS
		TEMP
		GPIO_TEMP

	ENDC			;FIM DO BLOCO DE MEM�RIA
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                        FLAGS INTERNOS                           *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINI��O DE TODOS OS FLAGS UTILIZADOS PELO SISTEMA

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                         CONSTANTES                              *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
; DEFINI��O DE TODAS AS CONSTANTES UTILIZADAS PELO SISTEMA

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

SUBROTINA1

	;CORPO DA ROTINA

	RETURN

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     INICIO DO PROGRAMA                          *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
	
INICIO
	BANK1				;ALTERA PARA O BANCO 1
	MOVLW	B'00000010'	;CONFIGURA TODAS AS PORTAS DO GPIO (PINOS)
	MOVWF	TRISIO		;COMO SA�DAS
	MOVLW	B'00000010'
	MOVWF	ANSEL 		;DEFINE PORTAS COMO Digital I/O MENOS A GP1
	MOVLW	B'00000100'
	MOVWF	OPTION_REG	;DEFINE OP��ES DE OPERA��O
	MOVLW	B'00000000'
	MOVWF	INTCON		;DEFINE OP��ES DE INTERRUP��ES
	;MOVLW	B'10100111'
	;MOVWF	VRCON
	BANK0				;RETORNA PARA O BANCO
	MOVLW	B'00000100'
	MOVWF	CMCON		;DEFINE O MODO DE OPERA��O DO COMPARADOR ANAL�GICO
	

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     INICIALIZA��O DAS VARI�VEIS                 *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                     ROTINA PRINCIPAL                            *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
MAIN
	; PRIMEIRAMENTE, DEVE-SE USAR UM DIVISOR DE TENSAO QUE IRA MAPIAR DE 0-5V PARA 0-3.59V.
	; ASSIM O PROGRAMA DEVERA FUNCIONAR DE MANEIRA CORRETA.	
	
	BANK1
	MOVLW	B'10001100'
	MOVWF	VRCON			; VAI SETAR O VRCON PARA 4.5V = ~3.233V (EM 0-3.59) [3.125Vref]
	BANK0	
	MOVLW	.9			; VALOR QUE VAI COLOCADO NO DISPLAY, CASO A TENS�O SEJA MAIOR QUE 4.5V
	BTFSS	CMCON,6			; SE DER ZERO, ENT�O VIN > VRCON(Vref)
	GOTO	DISPLAY
	
	;CASO O VALOR DE TENS�O SEJA MENOS QUE 4.5V, VERIFICA SE ELE � MAIOR QUE 4V
	BANK1
	MOVLW	B'10001010'		
	MOVWF	VRCON			; VAI SETAR O VRCON PARA 4V = ~2.874V (EM 0-3.59) [2.812Vref]		
	BANK0	
	MOVLW	.8			; VALOR QUE VAI COLOCADO NO DISPLAY, CASO A TENS�O SEJA MAIOR QUE 4V E MENOR QUE 4.5V
	BTFSS	CMCON,6			; SE DER ZERO, ENT�O VIN > VRCON(Vref)
	GOTO	DISPLAY
	
	;CASO O VALOR DE TENS�O SEJA MENOS QUE 4V, VERIFICA SE ELE � MAIOR QUE 3.5
	BANK1
	MOVLW	B'10001000'		
	MOVWF	VRCON			; VAI SETAR O VRCON PARA 3.5V = ~2.515V (EM 0-3.59) [2.5Vref]		
	BANK0	
	MOVLW	.7			; VALOR QUE VAI COLOCADO NO DISPLAY, CASO A TENS�O SEJA MAIOR QUE 3.5V E MENOR QUE 4V
	BTFSS	CMCON,6			; SE DER ZERO, ENT�O VIN > VRCON(Vref)
	GOTO	DISPLAY
	
	;CASO O VALOR DE TENS�O SEJA MENOS QUE 3.5V, VERIFICA SE ELE � MAIOR QUE 3V
	BANK1
	MOVLW	B'10101010'		
	MOVWF	VRCON			; VAI SETAR O VRCON PARA 3V = ~2.155V (EM 0-3.59) [2.083Vref]		
	BANK0	
	MOVLW	.6			; VALOR QUE VAI COLOCADO NO DISPLAY, CASO A TENS�O SEJA MAIOR QUE 3V E MENOR QUE 3.5V
	BTFSS	CMCON,6			; SE DER ZERO, ENT�O VIN > VRCON(Vref)
	GOTO	DISPLAY
	
	;CASO O VALOR DE TENS�O SEJA MENOS QUE 3V, VERIFICA SE ELE � MAIOR QUE 2.5V
	BANK1
	MOVLW	B'10000011'		
	MOVWF	VRCON			; VAI SETAR O VRCON PARA 2.5V = ~1.796V (EM 0-3.59) [1.718Vref]		
	BANK0	
	MOVLW	.5			; VALOR QUE VAI COLOCADO NO DISPLAY, CASO A TENS�O SEJA MAIOR QUE 2.5V E MENOR QUE 3V
	BTFSS	CMCON,6			; SE DER ZERO, ENT�O VIN > VRCON(Vref)
	GOTO	DISPLAY
	
	;CASO O VALOR DE TENS�O SEJA MENOS QUE 2.5V, VERIFICA SE ELE � MAIOR QUE 2V
	BANK1
	MOVLW	B'10000001'		
	MOVWF	VRCON			; VAI SETAR O VRCON PARA 2V = ~1.437V (EM 0-3.59) [1.406Vref]		
	BANK0	
	MOVLW	.4			; VALOR QUE VAI COLOCADO NO DISPLAY, CASO A TENS�O SEJA MAIOR QUE 2V E MENOR QUE 2.5V
	BTFSS	CMCON,6			; SE DER ZERO, ENT�O VIN > VRCON(Vref)
	GOTO	DISPLAY
	
	;CASO O VALOR DE TENS�O SEJA MENOS QUE 2V, VERIFICA SE ELE � MAIOR QUE 1.5V
	BANK1
	MOVLW	B'10100101'		
	MOVWF	VRCON			; VAI SETAR O VRCON PARA 1.5V = ~1.077V (EM 0-3.59) [1.041Vref]		
	BANK0	
	MOVLW	.3			; VALOR QUE VAI COLOCADO NO DISPLAY, CASO A TENS�O SEJA MAIOR QUE 1.5V E MENOR QUE 2V
	BTFSS	CMCON,6			; SE DER ZERO, ENT�O VIN > VRCON(Vref)
	GOTO	DISPLAY
	
	;CASO O VALOR DE TENS�O SEJA MENOS QUE 1.5V, VERIFICA SE ELE � MAIOR QUE 1V
	BANK1
	MOVLW	B'10100011'		
	MOVWF	VRCON			; VAI SETAR O VRCON PARA 1V = ~0.718V (EM 0-3.59) [0.625Vref]		
	BANK0	
	MOVLW	.2			; VALOR QUE VAI COLOCADO NO DISPLAY, CASO A TENS�O SEJA MAIOR QUE 1V E MENOR QUE 1.5V
	BTFSS	CMCON,6			; SE DER ZERO, ENT�O VIN > VRCON(Vref)
	GOTO	DISPLAY
	
	;CASO O VALOR DE TENS�O SEJA MENOS QUE 1V, VERIFICA SE ELE � MAIOR QUE 0.5V
	BANK1
	MOVLW	B'10100001'		
	MOVWF	VRCON			; VAI SETAR O VRCON PARA 0.5V = ~0.359 (EM 0-3.59) [0.208Vref]		
	BANK0	
	MOVLW	.1			; VALOR QUE VAI COLOCADO NO DISPLAY, CASO A TENS�O SEJA MAIOR QUE 0.5V E MENOR QUE 1V
	BTFSS	CMCON,6			; SE DER ZERO, ENT�O VIN > VRCON(Vref)
	GOTO	DISPLAY
	
	;CASO O VALOR DE TENS�O SEJA MENOS QUE 0.5
	
	MOVLW	.0			; VALOR QUE VAI COLOCADO NO DISPLAY, CASO A TENS�O SEJA MAIOR QUE 1V E MENOR QUE 1.5V	
	GOTO	DISPLAY
	
	
	
DISPLAY
	MOVWF	TEMP			; VAI SALVAR O VALOR QUE DEVE SER JOGADO NO DISPLAY EM TEMP
	
	MOVFW	GPIO			
	MOVWF	GPIO_TEMP		; ARMAZENA O ESTADO DO GPIO, PARA MANIPULA-LO SEM ALTERAR O GPIO DURANTE O PROCEDIMENTO
				
	BTFSS	TEMP,0			; TESTA O BIT 0 DO TEMP
	BCF	GPIO_TEMP,0		; SE O TESTE FOR 0, ENT�O LIMPA O BIT, SE O TESTE FOR 1, PULA PRA PR�XIMA INSTRU��O PARA SETAR O BIT
	BTFSC	TEMP,0			; CASO O TESTE ANTERIOR FOR ZERO, ESSE TESTE IRA PULAR A INSTRU��O SEGUINTE. AGORA SE O TESTE FOR UM, ENT�O SETA O BIT 0
	BSF	GPIO_TEMP,0
	
	BTFSS	TEMP,1			; ESTA O BIT 1 DO TEMP
	BCF	GPIO_TEMP,2		; SE O TESTE FOR 0, ENT�O LIMPA O BIT, SE O TESTE FOR 1, PULA PRA PR�XIMA INSTRU��O PARA SETAR O BIT
	BTFSC	TEMP,1			; CASO O TESTE ANTERIOR FOR ZERO, ESSE TESTE IRA PULAR A INSTRU��O SEGUINTE. AGORA SE O TESTE FOR UM, ENT�O SETA O BIT 2
	BSF	GPIO_TEMP,2
	
	BTFSS	TEMP,2			; ESTA O BIT 2 DO TEMP
	BCF	GPIO_TEMP,4		; SE O TESTE FOR 0, ENT�O LIMPA O BIT, SE O TESTE FOR 1, PULA PRA PR�XIMA INSTRU��O PARA SETAR O BIT
	BTFSC	TEMP,2			; CASO O TESTE ANTERIOR FOR ZERO, ESSE TESTE IRA PULAR A INSTRU��O SEGUINTE. AGORA SE O TESTE FOR UM, ENT�O SETA O BIT 4
	BSF	GPIO_TEMP,4
	
	BTFSS	TEMP,3			; ESTA O BIT 3 DO TEMP
	BCF	GPIO_TEMP,5		; SE O TESTE FOR 0, ENT�O LIMPA O BIT, SE O TESTE FOR 1, PULA PRA PR�XIMA INSTRU��O PARA SETAR O BIT
	BTFSC	TEMP,3			; CASO O TESTE ANTERIOR FOR ZERO, ESSE TESTE IRA PULAR A INSTRU��O SEGUINTE. AGORA SE O TESTE FOR UM, ENT�O SETA O BIT 5
	BSF	GPIO_TEMP,5
	
	MOVFW	GPIO_TEMP		; JOGA O VALOR DE VOLTA AO GPIO.
	MOVWF	GPIO
	
	GOTO	MAIN
	
	

	GOTO MAIN
	
	

;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
;*                       FIM DO PROGRAMA                           *
;* * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *

	END
