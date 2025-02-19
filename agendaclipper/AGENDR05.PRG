
/*
TITULO     : Agenda de Telefone
DATA       : 13/02/25
PROGRAMA   : AGENDR05.PRG
COMENTARIO : RELATORIO (Por Contato)
*/
 
#include "AGEND.CH"
#include "AGENDMOU.CH"
**
**BI [INI] R05.B01
**BI [FIM] R05.B01
**
***
*** Inicio do bloco de substitui‡„o R052.B
MENSAGEM( "Aguarde abertura de arquivos" )
SELE 1
IF !USEREDE( "AGENDA", .F., 10 )
   BEEP()
   MENSAGEM( "O arquivo AGENDA n„o est  dispon¡vel", 3 )
   RETURN
ELSE
   SET INDEX TO AGEND001,AGEND002,AGEND003,AGEND004
ENDIF
*** Final do bloco de substitui‡„o R052.B
***
MENSAGEM( "Tecle <ESC> para retornar" )
COR( "MENU" )
@ LIN_MENU, 00
@ LIN_MENU, 01 SAY "Relat¢rio ³ Por Contato"
SELE AGENDA  
SET ORDER TO 3
**
**BI [INI] R05.B02
**BI [FIM] R05.B02
**
GOTO TOP
**
**BI [INI] R05.B05
**BI [FIM] R05.B05
**
NUM_RELATORIO := 1
//
// -> Tipo do relatorio
relatorio:TIPO := COLUNAR
//
// -> Define cabecalhos do relatorio
relatorio:ADDTITULO( "Agenda Telefone" )
relatorio:ADDTITULO( "MS Sistemas            Relatorio por Contato" )
//
// -> Define reducao de caracter
//
// -> Define margem do papel
relatorio:LIN_SUPERIOR := 1
relatorio:LIN_INFERIOR := 61
relatorio:COL_INICIAL := 0
//
// -> Define os campos ou expressoes a serem impressos
relatorio:ADD( "Fone", AGENDA->CELULAR1, 1, "@R (#99#) #99.9999" )
relatorio:ADD( "Cod", AGENDA->SEQ_CODIGO, 17, "9999999999" )
relatorio:ADD( "Nome Contato", AGENDA->NOMECONTAT, 28, "@!" )
relatorio:ADD( "Nome", AGENDA->NOME, 49, "@!" )
//
// -> Executa impressao do objeto relatorio
**
**BI [INI] R05.B07
**BI [FIM] R05.B07
**
relatorio:RODA()
**
**BI [INI] R05.B08
**BI [FIM] R05.B08
**
MOUSE( DESLIGA )
RESTSCREEN( LIN_MENU + 1, 00, 23, 79, TELA_PRI )
MOUSE( LIGA )
**
**BI [INI] R05.B09
**BI [FIM] R05.B09
**
 
/* Final do programa AGENDR05.PRG */