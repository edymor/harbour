
/*
TITULO     : Agenda de Telefone
DATA       : 13/02/25
PROGRAMA   : AGENDR04.PRG
COMENTARIO : RELATORIO (Por Celular)
*/
 
#include "AGEND.CH"
#include "AGENDMOU.CH"
**
**BI [INI] R04.B01
**BI [FIM] R04.B01
**
***
*** Inicio do bloco de substitui‡„o R042.B
MENSAGEM( "Aguarde abertura de arquivos" )
SELE 1
IF !USEREDE( "AGENDA", .F., 10 )
   BEEP()
   MENSAGEM( "O arquivo AGENDA n„o est  dispon¡vel", 3 )
   RETURN
ELSE
   SET INDEX TO AGEND001,AGEND002,AGEND003,AGEND004
ENDIF
*** Final do bloco de substitui‡„o R042.B
***
MENSAGEM( "Tecle <ESC> para retornar" )
COR( "MENU" )
@ LIN_MENU, 00
@ LIN_MENU, 01 SAY "Relat¢rio ³ Por Celular"
SELE AGENDA  
SET ORDER TO 1
**
**BI [INI] R04.B02
**BI [FIM] R04.B02
**
GOTO TOP
**
**BI [INI] R04.B05
**BI [FIM] R04.B05
**
NUM_RELATORIO := 1
//
// -> Tipo do relatorio
relatorio:TIPO := COLUNAR
//
// -> Define cabecalhos do relatorio
relatorio:ADDTITULO( "Agenda Telefone" )
relatorio:ADDTITULO( "MS Sistemas           Relatorio por Celular" )
//
// -> Define reducao de caracter
//
// -> Define margem do papel
relatorio:LIN_SUPERIOR := 1
relatorio:LIN_INFERIOR := 61
relatorio:COL_INICIAL := 0
//
// -> Define os campos ou expressoes a serem impressos
relatorio:ADD( "Celular", AGENDA->CELULAR, 1, "@R (#99#) #99.9999" )
relatorio:ADD( "Cod", AGENDA->SEQ_CODIGO, 17, "9999999999" )
relatorio:ADD( "Nome", AGENDA->NOME, 28, "@!" )
//
// -> Executa impressao do objeto relatorio
**
**BI [INI] R04.B07
**BI [FIM] R04.B07
**
relatorio:RODA()
**
**BI [INI] R04.B08
**BI [FIM] R04.B08
**
MOUSE( DESLIGA )
RESTSCREEN( LIN_MENU + 1, 00, 23, 79, TELA_PRI )
MOUSE( LIGA )
**
**BI [INI] R04.B09
**BI [FIM] R04.B09
**
 
/* Final do programa AGENDR04.PRG */