
/*
TITULO     : Agenda de Telefone
DATA       : 13/02/25
PROGRAMA   : AGENDINC.PRG
COMENTARIO : MENU DE CADASTROS
*/
 
#include "AGEND.CH"
#include "AGENDMOU.CH"
**
**BI [INI] INC.B01
**BI [FIM] INC.B01
**
MENSAGEM( "Tecle <ESC> para sair" )
menu:ADD( "Agenda", AGENDI01() )
menu:RODA()
CLOSE DATABASES
**
**BI [INI] INC.B02
**BI [FIM] INC.B02
**
 
/* Final do programa AGENDINC.PRG */