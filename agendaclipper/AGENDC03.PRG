
/*
TITULO     : Agenda de Telefone
DATA       : 13/02/25
PROGRAMA   : AGENDC03.PRG
COMENTARIO : MANUTENCAO (Consulta por Nome)
*/
 
#include "AGEND.CH"
#include "AGENDMOU.CH"
SET DELETED OFF
M->MOSTRA_RESULTADO := .T.
**
**BI [INI] C03.B01
**BI [FIM] C03.B01
**
MENSAGEM( "Aguarde abertura de arquivos" )
SELE 1
IF !USEREDE( "AGENDA", .F., 10 )
   BEEP()
   MENSAGEM( "O arquivo AGENDA n„o est  dispon¡vel", 3 )
   RETURN
ELSE
   SET INDEX TO AGEND001, AGEND002, AGEND003, AGEND004
ENDIF
SELE AGENDA  
**
**BI [INI] C03.B02
**BI [FIM] C03.B02
**
SET ORDER TO 4
PRIVATE ME_MO, SEQ_CODIGO, NOME, CPF, CELULAR, NOMECONTAT, CELULAR1, OBSERVACAO
COR( "MENU" )
@ LIN_MENU, 00
@ LIN_MENU,01 SAY "Manuten‡„o ³ Consulta por Nome"
JANELA( 03, 02, 21, 77, "Consulta por Nome" )
L_CON := L_SOM; C_CON := C_SOM
//
// -> Monta janela do TBROWSE
COR( "MENU" )
@ 05, 04 CLEAR TO 19, 75
@ 05, 04 SAY SUBS( TB_JANELA, 1, 1 ) +;
             REPL( SUBS( TB_JANELA, 2, 1 ), 70 ) + SUBS( TB_JANELA, 3, 1 )
@ 06, 04 SAY SUBS( TB_JANELA, 12, 1 )
@ 06, 75 SAY SUBS( TB_JANELA, 4, 1 )
@ 07, 04 SAY SUBS( TB_JANELA, 11, 1 )
@ 07, 75 SAY SUBS( TB_JANELA, 5, 1 )
FOR CONTAR = 8 TO 18
   @ CONTAR, 04 SAY SUBS( TB_JANELA, 10, 1 )
   @ CONTAR, 75 SAY SUBS( TB_JANELA, 6, 1 )
NEXT
@ 19, 04 SAY SUBS( TB_JANELA, 9, 1 ) +;
             REPL( SUBS( TB_JANELA, 8, 1 ), 70 ) + SUBS( TB_JANELA, 7, 1 )
//
// -> Define as rotinas a serem usadas pelo TBROWSE
ROTI_NAS := { { | X | CARREG01( X ) },;
              { | X | CARGET01( X ) },;
              { || SALVAR01() } }
GRA_VAR := {}
//
// -> Define as colunas para o TBROWSE
OB_COLUN := {}
AADD( OB_COLUN, TBCOLUMNNEW( "Nome", { || TRAN( AGENDA->NOME, "@!" ) } ) )
AADD( OB_COLUN, TBCOLUMNNEW( "Codigo", { || TRAN( AGENDA->SEQ_CODIGO, "9999999999" ) } ) )
AADD( OB_COLUN, TBCOLUMNNEW( "Celular", { || TRAN( AGENDA->CELULAR, "@R (#99#) #99.9999" ) } ) )
//
// -> Mostra a tela BROWSE e sai retornando o controle ao programa
BRO_WSE( .T. )
M->SEQ_CODIGO := SPACE( 10 )
ED_JAN := {}
AADD( ED_JAN, { "Nome", M->SEQ_CODIGO, "@!", 10,;
      { | DADOS | M->SEQ_CODIGO := DADOS } } )
**
**BI [INI] C03.B03
**BI [FIM] C03.B03
**
WHILE .T.
   **
   **BI [INI] C03.B04
   **BI [FIM] C03.B04
   **
   IF EDIT_JAN( ED_JAN ) = .F.
      EXIT
   ENDIF
   SEEK TRIM( M->SEQ_CODIGO )
   IF EOF()
      BEEP()
      MENSAGEM( "Dados n„o encontrados", 3 )
      LOOP
   ENDIF
   MENSAGEM( "Posicione sobre o registro desejado e tecle <ENTER>" )
   //
   // -> Edita tela BROWSE
   BRO_WSE()
ENDDO
SET DELETED ON
MOUSE( DESLIGA )
RESTSCREEN( LIN_MENU + 1, 00, MAXROW() - 1, MAXCOL(), TELA_PRI )
MOUSE( LIGA )
SET DELETED ON
**
**BI [INI] C03.B05
**BI [FIM] C03.B05
**
 
/* Final do programa AGENDC03.PRG */