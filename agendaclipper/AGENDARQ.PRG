
/*
TITULO     : Agenda de Telefone
DATA       : 13/02/25
PROGRAMA   : AGENDARQ.PRG
COMENTARIO : CRIACAO DE ARQUIVOS
*/
 
#include "AGEND.CH"
#include "AGENDMOU.CH"

FUNCTION CRIARQ
//
// -> Funcao que cria banco de dados (arquivos "DBF")
LOCAL ESTRU_DBF
**
**BI [INI] ARQ.B01
**BI [FIM] ARQ.B01
**
IF !FILE( "AGENDA.DBF" )
   ESTRU_DBF := {}
   AADD( ESTRU_DBF, { "SEQ_CODIGO", "C", 10, 0 } )
   AADD( ESTRU_DBF, { "NOME", "C", 40, 0 } )
   AADD( ESTRU_DBF, { "CPF", "C", 11, 0 } )
   AADD( ESTRU_DBF, { "CELULAR", "C", 11, 0 } )
   AADD( ESTRU_DBF, { "NOMECONTAT", "C", 20, 0 } )
   AADD( ESTRU_DBF, { "CELULAR1", "C", 11, 0 } )
   AADD( ESTRU_DBF, { "OBSERVACAO", "M", 10, 0 } )
   DBCREATE( "AGENDA", ESTRU_DBF )
ENDIF
IF !FILE( "AGEND.RED" )
   ESTRU_DBF := {}
   AADD( ESTRU_DBF, { "DADOS", "C", 100, 0 } )
   DBCREATE( "AGEND.RED", ESTRU_DBF )
ENDIF
**
**BI [INI] ARQ.B02
**BI [FIM] ARQ.B02
**
 
/* Final do programa AGENDARQ.PRG */