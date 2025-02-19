
/*
TITULO     : Agenda de Telefone
DATA       : 13/02/25
PROGRAMA   : AGENDR02.PRG
COMENTARIO : RELATORIO (Por Cpf)
*/
 
#include "AGEND.CH"
#include "AGENDMOU.CH"
**
**BI [INI] R02.B01
**BI [FIM] R02.B01
**
***
*** Inicio do bloco de substitui‡„o R022.B
MENSAGEM( "Aguarde abertura de arquivos" )
SELE 1
IF !USEREDE( "AGENDA", .F., 10 )
   BEEP()
   MENSAGEM( "O arquivo AGENDA n„o est  dispon¡vel", 3 )
   RETURN
ELSE
   SET INDEX TO AGEND001,AGEND002,AGEND003,AGEND004
ENDIF
*** Final do bloco de substitui‡„o R022.B
***
MENSAGEM( "Tecle <ESC> para retornar" )
COR( "MENU" )
@ LIN_MENU, 00
@ LIN_MENU, 01 SAY "Relat¢rio ³ Por Cpf"
SELE AGENDA  
SET ORDER TO 2
**
**BI [INI] R02.B02
**BI [FIM] R02.B02
**
GOTO TOP
**
**BI [INI] R02.B05
**BI [FIM] R02.B05
**
NUM_RELATORIO := 1
//
// -> Tipo do relatorio
relatorio:TIPO := COLUNAR
//
// -> Define cabecalhos do relatorio
relatorio:ADDTITULO( "Agenda Telefone" )
relatorio:ADDTITULO( "MS Sistemas         Relatorio por Cpf" )
//
// -> Define reducao de caracter
//
// -> Define margem do papel
relatorio:LIN_SUPERIOR := 1
relatorio:LIN_INFERIOR := 61
relatorio:COL_INICIAL := 0
//
// -> Define os campos ou expressoes a serem impressos
relatorio:ADD( "Cpf", AGENDA->CPF, 1, "@R 999.999.999-99" )
relatorio:ADD( "Cod", AGENDA->SEQ_CODIGO, 16, "9999999999" )
relatorio:ADD( "Nome", AGENDA->NOME, 27, "@!" )
relatorio:ADD( "Celular", AGENDA->CELULAR, 68, "@R (#99#) #99.9999" )
//
// -> Executa impressao do objeto relatorio
**
**BI [INI] R02.B07
**BI [FIM] R02.B07
**
relatorio:RODA()
**
**BI [INI] R02.B08
**BI [FIM] R02.B08
**
MOUSE( DESLIGA )
RESTSCREEN( LIN_MENU + 1, 00, 23, 79, TELA_PRI )
MOUSE( LIGA )
**
**BI [INI] R02.B09
**BI [FIM] R02.B09
**
 
/* Final do programa AGENDR02.PRG */