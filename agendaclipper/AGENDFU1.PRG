
/*
TITULO     : Agenda de Telefone
DATA       : 13/02/25
PROGRAMA   : AGENDFU1.PRG
COMENTARIO : FUNCOES - PARTE 1
*/

#include "AGEND.CH"
#include "AGENDMOU.CH"
**
**BI [INI] FUN.B01
**BI [FIM] FUN.B01
**

FUNCTION MENU( OBJETO_MENU )
//
// -> Funcao que monta menu
LOCAL COL_MENU, CONTAR, LIN_INICIA, LAR_GURA, AL_TURA, NAO_EDITA := {},;
      ES_COLHA, DESTAQUE_MENU := {}, POS_DESTAQUE, OPCOES_MENU, ROTINAS_MENU
TIPO_MENU := OBJETO_MENU[ _TIPO_MENU ]
OPCOES_MENU := OBJETO_MENU[ _OPCOES_MENU ]
ROTINAS_MENU := OBJETO_MENU[ _CHAMADA_MENU ]
FOR CONTAR := 1 TO LEN( OPCOES_MENU )
   AADD( DESTAQUE_MENU, OPCOES_MENU[ CONTAR ] )
   IF SUBS( DESTAQUE_MENU[ CONTAR ], 1, 1 ) = ">"
      DESTAQUE_MENU[ CONTAR ] := SUBS( DESTAQUE_MENU[ CONTAR ], 2 )
   ENDIF
   IF ( POS_DESTAQUE := AT( "~", OPCOES_MENU[ CONTAR ] ) ) != 0
      OPCOES_MENU[ CONTAR ] := STUFF( OPCOES_MENU[ CONTAR ], POS_DESTAQUE,;
                                      1, "" )
   ENDIF
NEXT
IF TIPO_MENU = NIL; TIPO_MENU := MENU_PRINCIPAL; ENDIF
COL_MENU := MENU_POS[ MENU_P ]
LIN_INICIA := LIN_MENU + 1
//
// -> Para edicao de sub-menu
IF TIPO_MENU = SUB_MENU
   COL_MENU += 10
   IF LEN( OPCOES_MENU ) > 13 .OR. POS_ULT_MENU > 13
      LIN_INICIA := LIN_MENU + 2
   ELSE
      LIN_INICIA := LIN_MENU + POS_ULT_MENU + 2
   ENDIF
ENDIF
//
// -> Verfica a largura maxima do menu
LAR_GURA := 0
AL_TURA := LEN( OPCOES_MENU )
FOR CONTAR = 1 TO AL_TURA
   AADD( NAO_EDITA, .T. )
   OPCOES_MENU[ CONTAR ] := " " + TRIM( OPCOES_MENU[ CONTAR ] ) + " "
   IF LEN( OPCOES_MENU[ CONTAR ] ) > LAR_GURA
      LAR_GURA = LEN( OPCOES_MENU[ CONTAR ] )
      IF SUBS( OPCOES_MENU[ CONTAR ], 2, 1 ) = ">"
         LAR_GURA++
      ENDIF
   ENDIF
NEXT
//
// -> Verfica se a largura esta abaixo da largura minima
IF LAR_GURA < 18; LAR_GURA := 18; ENDIF
//
// -> Prepara os separadores de menu e simbolos de sub-menu
FOR CONTAR = 1 TO AL_TURA
   IF OPCOES_MENU[ CONTAR ] = " - "
      NAO_EDITA[ CONTAR ] := .F.
      OPCOES_MENU[ CONTAR ] := REPL( "Ä", LAR_GURA )
   ELSEIF SUBS( OPCOES_MENU[ CONTAR ], 2, 1 ) = ">"
      OPCOES_MENU[ CONTAR ] := " " + PADR( SUBS( OPCOES_MENU[ CONTAR ], 3 ), ;
                               LAR_GURA - 3 ) + CHR( 16 ) + " "
   ELSE
      OPCOES_MENU[ CONTAR ] := PADR( OPCOES_MENU[ CONTAR ], LAR_GURA )
      IF TIPO_MENU = 1
         PRO_CURA := CHR( POS_ULT_MENU ) + CHR( CONTAR ) + CHR( 0 )
      ELSE
         PRO_CURA := CHR( CONTAR ) + CHR( 0 ) + CHR( 0 )
      ENDIF
      IF ASCAN( ACESSO_MENUS[ MENU_P ], PRO_CURA ) != 0
         OPCOES_MENU[ CONTAR ] := CHR( 254 ) + SUBS( OPCOES_MENU[ CONTAR ], 2 )
      ENDIF
   ENDIF
NEXT
//
// -> Verrifica se a altura ultrapassa a altura maxima
AL_TURA += 2
IF AL_TURA > 15; AL_TURA := 15; ENDIF
//
// -> Verfica se a largura do menu ultrapassa a tela e faz ajuste
IF COL_MENU + LAR_GURA + 3 > 79
   IF TIPO_MENU = MENU_PRINCIPAL
      COL_MENU -= ( ( LAR_GURA + 2 ) - LEN( MENU_PRI[ MENU_P ] ) )
   ELSE
      COL_MENU -= ( ( COL_MENU + LAR_GURA + 3 ) - 79 )
   ENDIF
ENDIF
SOMBRA( LIN_INICIA, COL_MENU, AL_TURA + LIN_INICIA - 1,;
        COL_MENU + LAR_GURA + 3)
COR( "MENU" )
@ LIN_INICIA, COL_MENU CLEAR TO AL_TURA + LIN_INICIA - 1, COL_MENU + LAR_GURA + 3
@ LIN_INICIA, COL_MENU + 1 TO AL_TURA + LIN_INICIA - 1,COL_MENU + LAR_GURA + 2
IF AL_TURA < 15
   FOR CONTAR = 1 TO AL_TURA - 2
      IF SUBS( OPCOES_MENU[ CONTAR ], 1, 1 ) = "Ä"
         @ CONTAR + LIN_INICIA, COL_MENU + 1 SAY "Ã"
         @ CONTAR + LIN_INICIA, COL_MENU + LAR_GURA + 2 SAY "´"
      ENDIF
   NEXT
ENDIF
//
// -> Imprime setas para cima e para baixo indicando que o menu ultrapassa
//    o tamanho da janela
IF LEN( OPCOES_MENU ) > AL_TURA - 2
   @ LIN_INICIA + 1, COL_MENU + LAR_GURA + 3 SAY CHR( 24 )
   @ LIN_INICIA + AL_TURA - 2, COL_MENU + LAR_GURA + 3 SAY CHR( 25 )
ENDIF
//
// -> Faz a edicao efetiva do menu
ES_COLHA := MIROMENU( LIN_INICIA + 1, COL_MENU + 2,;
            LIN_INICIA + AL_TURA - 2, COL_MENU + LAR_GURA + 1,;
            OPCOES_MENU, DESTAQUE_MENU )
//
// -> Verifica se a tecla ESC foi pressicionada e se a edicao e' referente
//    a um menu principal para entao ativar a janela de saida
IF ES_COLHA = 0 .AND. TIPO_MENU = MENU_PRINCIPAL .AND. BUFFER = CHR( T_ENTER )
   //
   // -> Ativa a janela de saida
   BUFFER := "S" + CHR( T_ENTER )
ENDIF
IF ES_COLHA > 0 .AND. ES_COLHA < 999
   //
   // -> Verfica se sera ativado um sub-menu
   IF !( TIPO_MENU = MENU_PRINCIPAL .AND. SUBS( OPCOES_MENU[ ES_COLHA ],;
         LEN( OPCOES_MENU[ ES_COLHA ] ) - 1, 1 ) = CHR( 16 ) )
      MOUSE( DESLIGA )
      RESTSCREEN( LIN_MENU + 1, 00, 23, 79, TELA_PRI )
      MOUSE( LIGA )
   ELSE
      SOMBRA( L_SOM, C_SOM, .T. )
      IF LEN( OPCOES_MENU ) <= AL_TURA
         COR( "DESTAQUE DO MENU" )
         @ LIN_MENU + ES_COLHA + 1, COL() SAY OPCOES_MENU[ ES_COLHA ]
      ENDIF
   ENDIF
   IF TIPO_MENU = MENU_PRINCIPAL
      POS_ULT_MENU := ES_COLHA
   ENDIF
ELSE
   MOUSE( DESLIGA )
   RESTSCREEN( LIN_MENU + 1, 00, 23, 79, TELA_PRI )
   MOUSE( LIGA )
ENDIF
menu:LIMPA()
IF TIPO_MENU = SUB_MENU .AND. ES_COLHA = 999
   ES_COLHA := 0
ENDIF
IF ES_COLHA > 0 .AND. ES_COLHA < 999
   EVAL( ROTINAS_MENU[ ES_COLHA ] )
ENDIF
RETURN IIF( ES_COLHA = -1, 0, ES_COLHA )

FUNCTION MIROMENU( LIN_SUP, COL_ESQ, LIN_INF, COL_DIR, DADOS_MENU, DESTAQUE_MENU )
LOCAL CONTAR, ULT_CURSOR := SETCURSOR(), TECLA := 0, OP_CAO := 1,;
      OBJ_MENU := TBROWSENEW( LIN_SUP, COL_ESQ, LIN_INF, COL_DIR ),;
      ULT_OPCAO := 1, ULT_LINHA := LIN_SUP, POS_DESTAQUE, CONTADOR,;
      BO_TAO := 0, LIN := 0, COL := 0, DADO_CUR, LE_TRA
//
// -> Define os dados principais do BROWSE
OBJ_MENU:ADDCOLUMN( TBCOLUMNNEW( , { || DADOS_MENU[ OP_CAO ] } ) )
OBJ_MENU:GOTOPBLOCK := { || OP_CAO := 1 }
OBJ_MENU:GOBOTTOMBLOCK := { || OP_CAO := LEN( DADOS_MENU ) }
OBJ_MENU:SKIPBLOCK := { | SALTO | SKIPMENU( SALTO, LEN( DADOS_MENU ), @OP_CAO ) }
CURSOR( DESLIGA )
WHILE .T.
   MOUSE( DESLIGA )
   IF ( POS_DESTAQUE := AT( "~", DESTAQUE_MENU[ ULT_OPCAO ] ) ) != 0
      @ ULT_LINHA, COL_ESQ + POS_DESTAQUE SAY SUBS( DESTAQUE_MENU[ ULT_OPCAO ],;
                   POS_DESTAQUE + 1, 1 ) COLOR CONTECOR[ 7 ]
   ENDIF
   //
   // -> Estabiliza o BROWSE
   WHILE ( !OBJ_MENU:STABILIZE() )
      IF ( POS_DESTAQUE := AT( "~", DESTAQUE_MENU[ OP_CAO ] ) ) != 0
            @ ROW(), COL_ESQ + POS_DESTAQUE SAY SUBS( DESTAQUE_MENU[ OP_CAO ],;
                               POS_DESTAQUE + 1, 1 ) COLOR CONTECOR[ 7 ]
      ENDIF
    ENDDO
   MOUSE( LIGA )
   //
   // -> Verifica se a opcao corrente e' editavel ou nao para saltar
   //    as nao editaveis
   IF SUBS( DADOS_MENU[ OP_CAO ], 1, 1 ) = "Ä"
      IF TECLA = T_CIMA .OR. TECLA = T_HOME .OR. TECLA = T_PGUP
         IF OP_CAO = 1
            OBJ_MENU:GOBOTTOM()
         ELSE
            OBJ_MENU:UP()
         ENDIF
      ELSE
         IF OP_CAO = LEN( DADOS_MENU )
            OBJ_MENU:GOTOP()
         ELSE
            OBJ_MENU:DOWN()
         ENDIF
      ENDIF
      LOOP
   ENDIF
   ULT_LINHA := LIN_SUP + OBJ_MENU:ROWPOS - 1
   ULT_OPCAO := OP_CAO
   //
   // -> Verifica se o BROWSE esta estavel
   IF OBJ_MENU:STABLE
      //
      // -> Verfica se foi pressionado uma tecla
      WHILE( TECLA := INKEY() ) == 0
         IF TECLA = 0
            //
            // -> Lˆ buffer do mouse
            MOUSE( @BO_TAO, @LIN, @COL )
         ENDIF
         //
         // -> Verifica se os botoes do mouse foram pressionados para ativar
         //    a acao equivalente a posicao do cursor do mouse
         IF BO_TAO = M_ESQUERDO .OR. BO_TAO = M_OS_DOIS
            DADO_CUR := SUBS( SAVESCREEN( LIN, COL, LIN, COL ), 1, 1 )
            IF DADO_CUR = CHR( 254 ) .OR. BO_TAO = M_OS_DOIS
               TECLA := T_ESC
            ELSEIF LIN = 24 .AND. ( COL >= 71 .AND. COL <= 78 )
               TECLA := T_F1
            ELSEIF ( LIN = LIN_SUP - 1 .AND. ( COL >= COL_ESQ .AND.;
                     COL <= COL_DIR ) ) .OR. DADO_CUR = CHR( 24 )
               TECLA := T_CIMA
            ELSEIF ( LIN = LIN_INF + 1 .AND. ( COL >= COL_ESQ .AND.;
                     COL <= COL_DIR ) ) .OR. DADO_CUR = CHR( 25 )
               TECLA := T_BAIXO
            ELSEIF ( COL >= COL_ESQ .AND. COL <= COL_DIR ) .AND.;
                   ( LIN >= LIN_SUP .AND. LIN <= LIN_INF )
               OBJ_MENU:ROWPOS := ( LIN - LIN_SUP ) + 1
               OBJ_MENU:REFRESHALL()
               MOUSE( DESLIGA )
               WHILE ( !OBJ_MENU:STABILIZE() )
                  IF ( POS_DESTAQUE := AT( "~", DESTAQUE_MENU[ OP_CAO ] ) ) != 0
                     @ ROW(), COL_ESQ + POS_DESTAQUE SAY SUBS(;
                              DESTAQUE_MENU[ OP_CAO ], POS_DESTAQUE + 1, 1 );
                              COLOR CONTECOR[ 7 ]
                  ENDIF
               ENDDO
               MOUSE( LIGA )
               TECLA := T_ENTER
            ELSEIF LIN = LIN_MENU
               FOR CONTAR = 1 TO LEN( MENU_PRI )
                  IF COL >= MENU_POS[ CONTAR ] + 1 .AND.;
                     COL <= LEN( MENU_PRI[ CONTAR ] ) + MENU_POS[ CONTAR ]
                     MENU_P := CONTAR
                     OP_CAO := -1
                     EXIT
                  ENDIF
               NEXT
            ELSE
               BEEP_MOUSE()
               LOOP
            ENDIF
            EXIT
         ELSEIF BO_TAO = M_DIREITO
            TECLA := T_ENTER
            EXIT
         ENDIF
      ENDDO
      IF OP_CAO = -1
         EXIT
      ENDIF
   ENDIF
   //
   // -> Verifica se foi pressionamento uma tecla marcada com o caracter " ~ "
   IF SENHAS_MENU = .F.
      FOR CONTADOR := 1 TO LEN( DESTAQUE_MENU )
         IF ( POS_DESTAQUE := AT( "~", DESTAQUE_MENU[ CONTADOR ] ) ) != 0
            LE_TRA := SUBS( DESTAQUE_MENU[ CONTADOR ], POS_DESTAQUE + 1, 1 )
            IF UPPER( LE_TRA ) = UPPER( CHR( TECLA ) )
               ULT_OPCAO := CONTADOR
               CONTADOR = ( CONTADOR - OP_CAO )
               IF CONTADOR < 0
                  CONTADOR *= ( -1 )
                  TECLA = T_CIMA
               ELSE
                  TECLA = T_BAIXO
               ENDIF
               FOR CONTAR := 1 TO CONTADOR
                  IF TECLA = T_CIMA
                     OBJ_MENU:UP()
                  ELSE
                     OBJ_MENU:DOWN()
                  ENDIF
               NEXT
               MOUSE( DESLIGA )
               OBJ_MENU:REFRESHALL()
               WHILE ( !OBJ_MENU:STABILIZE() )
                  IF ( POS_DESTAQUE := AT( "~", DESTAQUE_MENU[ OP_CAO ] ) ) != 0
                     @ ROW(), COL_ESQ + POS_DESTAQUE SAY SUBS(;
                              DESTAQUE_MENU[ OP_CAO ], POS_DESTAQUE + 1, 1 );
                              COLOR CONTECOR[ 7 ]
                  ENDIF
                  IF OP_CAO = ULT_OPCAO
                     OBJ_MENU:ROWPOS := ( ROW() - LIN_SUP ) + 1
                  ENDIF
               ENDDO
               MOUSE( LIGA )
               TECLA := T_ENTER
               EXIT
            ENDIF
         ENDIF
      NEXT
   ENDIF
   //
   // -> Verifica a tecla pressionada e executa a acao indicada
   IF TECLA = T_ESC
      OP_CAO := 0
      EXIT
   ELSEIF TECLA = T_F10 .AND. SENHAS_MENU = .T.
      M->NOM_ARQ := "AGEND.SNH"
      IF USEREDE( M->NOM_ARQ, .F., 10 )
         IF ALTERA_NIVEL = .T.
            GOTO REG_SENHA
            IF !REGLOCK( 20 )
               BEEP()
               MENSAGEM( "Troca de n¡vel mal sucedida", 3 )
               LOOP
            ENDIF
         ELSE
            IF !ADIREG( 0 )
               BEEP()
               MENSAGEM( "Credenciamento mal sucedido", 3 )
               MENSAGEM( "Tecle <ESC> para sair" )
               USE
               LOOP
            ENDIF
         ENDIF
      ELSE
         BEEP()
         MENSAGEM( "Credenciamento mal sucedido", 3 )
         MENSAGEM( "Tecle <ESC> para sair" )
         LOOP
      ENDIF
      IF ALTERA_NIVEL != .T.
         REPLACE CODSENHA WITH M->CODSENHA
         REPLACE USUARIO WITH M->USUARIO
      ENDIF
      M->ACESSO_INC := ""
      M->ACESSO_CON := ""
      M->ACESSO_ALT := ""
      M->ACESSO_EXC := ""
      M->ACESSO_REL := ""
      M->ACESSO_UTI := ""
      FOR CONTADOR := 1 TO LEN( ACESSO_MENUS ) - 1
         FOR CONTAR := 1 TO LEN( ACESSO_MENUS[ CONTADOR ] )
            IF ACESSO_MENUS[ CONTADOR ][ CONTAR ] != CHR( 0 ) + CHR( 0 ) +;
                                                     CHR( 0 )
               IF CONTADOR = 1
                  M->ACESSO_INC += ACESSO_MENUS[ CONTADOR ][ CONTAR ]
               ELSEIF CONTADOR = 2
                  M->ACESSO_CON += ACESSO_MENUS[ CONTADOR ][ CONTAR ]
               ELSEIF CONTADOR = 3
                  M->ACESSO_ALT += ACESSO_MENUS[ CONTADOR ][ CONTAR ]
               ELSEIF CONTADOR = 4
                  M->ACESSO_EXC += ACESSO_MENUS[ CONTADOR ][ CONTAR ]
               ELSEIF CONTADOR = 5
                  M->ACESSO_REL += ACESSO_MENUS[ CONTADOR ][ CONTAR ]
               ELSEIF CONTADOR = 6
                  M->ACESSO_UTI += ACESSO_MENUS[ CONTADOR ][ CONTAR ]
               ENDIF
            ENDIF
         NEXT
      NEXT
      REPLACE ACESSO_INC WITH M->ACESSO_INC
      REPLACE ACESSO_CON WITH M->ACESSO_CON
      REPLACE ACESSO_ALT WITH M->ACESSO_ALT
      REPLACE ACESSO_EXC WITH M->ACESSO_EXC
      REPLACE ACESSO_REL WITH M->ACESSO_REL
      REPLACE ACESSO_UTI WITH M->ACESSO_UTI
      IF ALTERA_NIVEL = .T.
         UNLOCK
         ALTERA_NIVEL := .F.
      ENDIF
      USE
      SENHAS_MENU = .F.
      ACESSO_MENUS := ULT_ACESSO
      FUNDO()
      TELA_PRI := SAVESCREEN( LIN_MENU+1, 00, 23, 79 )
      TONE( 400, 1 ); TONE( 350, 2 ); TONE( 300, 1 ); TONE( 250, 2 )
      ULTIMO_MENU := " "
      OP_CAO := 999
      EXIT
   ELSEIF TECLA = T_ENTER
      IF SENHAS_MENU = .T.
         IF MENU_P = LEN( MENU_PRI )
            LOOP
         ENDIF
         IF SUBS( DADOS_MENU[ OP_CAO ], LEN( DADOS_MENU[ OP_CAO ] ) - 1, 1 ) =;
            CHR( 16 )
            EXIT
         ENDIF
         IF TIPO_MENU = 1
            PRO_CURA := CHR( POS_ULT_MENU ) + CHR( OP_CAO ) + CHR( 0 )
         ELSE
            PRO_CURA := CHR( OP_CAO ) + CHR( 0 ) + CHR( 0 )
         ENDIF
         POSI_CAO := ASCAN( ACESSO_MENUS[ MENU_P ], PRO_CURA )
         IF POSI_CAO = 0
            AADD( ACESSO_MENUS[ MENU_P ], PRO_CURA )
            DADOS_MENU[ OP_CAO ] := CHR( 254 ) + SUBS( DADOS_MENU[ OP_CAO ], 2 )
         ELSE
            ACESSO_MENUS[ MENU_P ][ POSI_CAO ] := CHR( 0 ) + CHR( 0 ) + CHR( 0 )
            DADOS_MENU[ OP_CAO ] := " " + SUBS( DADOS_MENU[ OP_CAO ], 2 )
         ENDIF
         IF OP_CAO < LEN( DADOS_MENU )
            OBJ_MENU:DOWN()
         ENDIF
         OBJ_MENU:REFRESHALL()
      ELSE
         IF SUBS( DADOS_MENU[ OP_CAO ], 1, 1 ) = CHR( 254 )
            BEEP()
            MENSAGEM( "Acesso n„o permitido", 3 )
            MENSAGEM( "Tecle <ESC> para sair" )
         ELSE
            EXIT
         ENDIF
      ENDIF
   ELSEIF TECLA == T_F1
      HELP( "MENU" )
   ELSEIF TECLA == T_F3
      CALEN()
   ELSEIF TECLA == T_F4
      CALCU()
   ELSEIF TECLA == T_F5
      SHELLDOS()
   ELSEIF TECLA == T_F6
      SET_CONF()
   ELSEIF TECLA == T_F7
      HELP_TEC()
   ELSEIF TECLA = T_DIREITA
      BUFFER := CHR( T_DIREITA ) + CHR( T_ENTER )
      OP_CAO := 0
      EXIT
   ELSEIF TECLA = T_ESQUERDA
      BUFFER := CHR( T_ESQUERDA ) + CHR( T_ENTER )
      OP_CAO := 0
      EXIT
   ELSEIF TECLA = T_CIMA
      IF OP_CAO = 1
         OBJ_MENU:GOBOTTOM()
      ELSE
         OBJ_MENU:UP()
      ENDIF
   ELSEIF TECLA = T_BAIXO
      IF OP_CAO = LEN( DADOS_MENU )
         OBJ_MENU:GOTOP()
      ELSE
         OBJ_MENU:DOWN()
      ENDIF
   ELSEIF TECLA = T_HOME
      OBJ_MENU:GOTOP()
   ELSEIF TECLA = T_END
      OBJ_MENU:GOBOTTOM()
   ELSEIF TECLA = T_PGUP
      OBJ_MENU:PAGEUP()
   ELSEIF TECLA = T_PGDN
      OBJ_MENU:PAGEDOWN()
   ENDIF
ENDDO
SETCURSOR( ULT_CURSOR )
RETURN OP_CAO

FUNCTION SKIPMENU( SALTO, ULT_OPCAO, OP_CAO )
LOCAL TOT_SALTO := 0
IF SALTO + OP_CAO < 1
   TOT_SALTO := ( OP_CAO - 1 ) * ( -1 )
   OP_CAO := 1
ELSEIF SALTO + OP_CAO > ULT_OPCAO
   TOT_SALTO := ULT_OPCAO - OP_CAO
   OP_CAO := ULT_OPCAO
ELSE
   TOT_SALTO := SALTO
   OP_CAO += SALTO
ENDIF
RETURN TOT_SALTO
 
FUNCTION AJUSTE
LOCAL MAXIMO, REDUCAO, MARGEM, CONTAR, CONTADOR, NUM_FORMULARIO
PARA LARGURA, FORMULARIO
IF VALTYPE( LARGURA ) = "C"
   FORMULARIO := LARGURA
   LARGURA := 150
ENDIF
REDUCAO := ""
MAXIMO := 0
IF FORMULARIO = "80"
   NUM_FORMULARIO := 1
ELSE
   NUM_FORMULARIO := 2
ENDIF
FOR CONTAR := 1 TO LEN( IMPRESSORA )
   IF LARGURA <= IMPRESSORA[ CONTAR ][ 1 ][ NUM_FORMULARIO ]
      MAXIMO := IMPRESSORA[ CONTAR ][ 1 ][ NUM_FORMULARIO ]
      FOR CONTADOR := 1 TO LEN( IMPRESSORA[ CONTAR ][ 2 ] )
         REDUCAO += CHR( IMPRESSORA[ CONTAR ][ 2 ][ CONTADOR ] )
      NEXT
      EXIT
   ENDIF
NEXT
IF FORMULARIO = "ETIQUETA"
   FOR CONTADOR := 1 TO LEN( IMPRESSORA[ REDUCAO_ETQ ][ 2 ] )
      REDUCAO += CHR( IMPRESSORA[ REDUCAO_ETQ ][ 2 ][ CONTADOR ] )
   NEXT
   ?? REDUCAO
   SET MARG TO 0
ELSE
   IF MAXIMO = 0
      @ 00, 01 SAY "SEM AJUSTE"
      RETURN .F.
   ENDIF
   MARGEM := INT( ( MAXIMO - LARGURA ) / 2 ) + relatorio:COL_INICIAL - 1
   IF MARGEM < 0; MARGEM := 0; ENDIF
   SET MARG TO MARGEM
   @ PROW(), PCOL() + 1 SAY REDUCAO
ENDIF
RETURN .T.
 
FUNCTION GETREADER( GET )
//
// -> Funcao de leitura de um GET (modo padrao) 
LOCAL TECLA, BO_TAO, COL, LIN, RETORNE := 0, CONTAR
//
// -> Leitura do GET se WHEN for satisfeito
IF ( GETPREVALIDADE( GET ) )
   //
   // -> Ativa o GET para leitura
   GET:SETFOCUS()
   WHILE ( GET:EXITSTATE == GE_NOEXIT )
      //
      // -> Checagem para tipo de saida inicial (posicoes nao editaveis)
      IF ( GET:TYPEOUT )
         GET:EXITSTATE := GE_ENTER
      ENDIF
      //
      // -> Aguarda acionamento de teclas (mouse ou teclado) e executa uma acao
      WHILE ( GET:EXITSTATE == GE_NOEXIT )
         WHILE( TECLA := INKEY() ) == 0
            MOUSE( @BO_TAO, @LIN, @COL )
            IF BO_TAO = M_ESQUERDO .OR. BO_TAO = M_OS_DOIS
               DADO_CUR := SUBS( SAVESCREEN( LIN, COL, LIN, COL ), 1, 1 )
               IF DADO_CUR = CHR( 254 ) .OR. BO_TAO = M_OS_DOIS
                  KEYBOARD CHR( T_ESC )
                  TECLA := INKEY( 0 )
               ELSEIF LIN = 24 .AND. ( COL >= 71 .AND. COL <= 78 )
                  TECLA := T_F1
               ELSE
                  FOR CONTAR := 1 TO LEN( DADOS_MOUSE )
                     IF DADOS_MOUSE[ CONTAR ][ 1 ] = LIN .AND.;
                        ( COL >= DADOS_MOUSE[ CONTAR ][ 2 ] .AND.;
                          COL <= DADOS_MOUSE[ CONTAR ][ 3 ] )
                        RETORNE := DADOS_MOUSE[ CONTAR ][ 4 ]
                        KEYBOARD CHR( RETORNE )
                        TECLA := INKEY( 0 )
                        EXIT
                     ENDIF
                  NEXT
                  IF RETORNE = 0
                     BEEP_MOUSE()
                     LOOP
                  ENDIF
               ENDIF
               EXIT
            ELSEIF BO_TAO = M_DIREITO
               KEYBOARD CHR( T_ENTER )
               TECLA := INKEY( 0 )
               EXIT
            ENDIF
         ENDDO
         MOUSE( DESLIGA )
         GETAPPLYKEY( GET, TECLA )
         MOUSE( LIGA )
      ENDDO
      //
      // -> Desabilita saida se a condicao VALID nao for satisfeita
      IF ( !GETPOSTVALIDADE( GET ) )
         GET:EXITSTATE := GE_NOEXIT
      ENDIF
   ENDDO
   //
   // ->Desativa o GET
   GET:KILLFOCUS()
ENDIF
RETURN NIL

FUNCTION MOUSE( BOTAO, LIN, COL )
//
// MOUSE() -> Inicializa mouse
// MOUSE( LIGA ) -> Liga cursor
// MOUSE( DESLIGA ) -> Desativa cursor
// MOUSE( @BOTAO, @LINHA, @COLUNA )  ->;
//       -> Le o status do mouse retornando as variaveis passadas
//          como parametros, os respectivos resultados.
// MOUSE( LINHA, COLUNA ) -> Move o cursor do mouse para posicao indicada
//
LOCAL REGISTRADORES := {}, NUM_PAR := PCOUNT()
IF NUM_PAR = 0
   REGISTRADORES := { M_INICIALIZA, 0, 0, 0, 0, 0, 0 }
ELSEIF NUM_PAR = 1
   IF BOTAO = LIGA
      REGISTRADORES := { M_CURSOR_ON, 0, 0, 0, 0, 0, 0 }
   ELSE
      REGISTRADORES := { M_CURSOR_OFF, 0, 0, 0, 0, 0, 0 }
   ENDIF
ELSEIF NUM_PAR = 2
   REGISTRADORES := { M_POS_CURSOR, 0, LIN * 8, BOTAO * 8, 0, 0, 0 }
ELSEIF NUM_PAR = 3
   REGISTRADORES := { M_LER_STATUS, 0, 0, 0, 0, 0, 0 }
ELSE
   RETURN NIL
ENDIF
cint86( M_INTERRUPCAO, REGISTRADORES, REGISTRADORES )
IF NUM_PAR = 0
   RETURN REGISTRADORES[ AX ] = -1
ELSEIF NUM_PAR = 3
   //
   // -> ESQUERDO = 1, DIREITO = 2, OS DOIS = 3
   BOTAO := REGISTRADORES[ BX ]
   LIN := INT( REGISTRADORES[ DX ] / 8 )
   COL := INT( REGISTRADORES[ CX ] / 8 )
   IF BOTAO != 0
      //
      // -> Tempo para o mouse nao ser clicado 2 vezes na mesma pressionada
      INKEY( 0.2 )
   ENDIF
ENDIF
RETURN NIL

//
// -> Aguarda uma tecla ou click do mouse
FUNCTION TEC_MOU( SEGUNDOS )
LOCAL TECLA := 0, BO_TAO := 0, LIN := 0, COL := 0, DADO_CUR,;
      SEG_INI := SECONDS()
IF SEGUNDOS = NIL; SEGUNDOS := 0; ENDIF
WHILE( TECLA := INKEY() ) == 0
   IF SEGUNDOS != 0
      IF SECONDS() - SEG_INI >= SEGUNDOS; EXIT; ENDIF
   ENDIF
   IF TECLA = 0
      MOUSE( @BO_TAO, @LIN, @COL )
   ENDIF
   IF BO_TAO != 0
      IF BO_TAO = M_DIREITO; TECLA := T_ENTER; ENDIF
      IF BO_TAO = M_OS_DOIS; TECLA := T_ESC; ENDIF
      EXIT
   ENDIF
ENDDO
RETURN TECLA


FUNCTION INDICES
LOCAL CONTAR, OPCAO_INDEX := PCOUNT(), TODOS, NUM_INDICE,;
      MARCADOR
IF OPCAO_INDEX = 0
   DECLARE ARQ_NTX[ ADIR( "*.NTX" ) ]
   ADIR( "*.NTX", ARQ_NTX )
   AADD( ARQ_NTX, "AGEND.RNX" )
ELSEIF OPCAO_INDEX = 1
   COR( "MENU" )
   @ LIN_MENU, 00
   @ LIN_MENU, 01 SAY "Utilit rios ³ Organiza‡„o de arquivos"
   MENU_IND := {}
   AADD( MENU_IND, " AGENDA   -> Agenda de Telefones        [ ] " )
   JANELA( 04, 12, 20, 67, "Organiza‡„o de arquivos" )
   COR( "MENU" )
   @ 07, 17 CLEAR TO 15, 62
   NUM_INDICE := 1
   POS_JANELA := 1
   TODOS := .T.
   WHILE NUM_INDICE != 0
      botao:ADD( 17, 27, "Todos    " )
      botao:ADD( 17, 43, "Organizar" )
      botao:MOSTRA()
      KEYBOARD CHR( 32 )
      COR( "MENU" )
      MOUSE( DESLIGA )
      SOS_MENU := "INDICES"
      NUM_INDICE := ACHOICE( 08, 18, 14, 61, MENU_IND, .T., "IND_ACHO",;
                             NUM_INDICE, POS_JANELA )
      SOS_MENU := " "
      MOUSE( LIGA )
      IF LASTKEY() = ASC( "T" ) .OR. LASTKEY() = ASC( "t" )
         botao:MOVIMENTA( 17, 27, "Todos    " )
         FOR CONTAR := 1 TO LEN( MENU_IND )
            MENU_IND[ CONTAR ] := SUBS( MENU_IND[ CONTAR ], 1, 41 ) +;
                                  IIF( TODOS, "x", " " ) + "] "
         NEXT
         TODOS = IIF( TODOS, .F. ,.T. )
         NUM_INDICE := 1
         POS_JANELA := 1
      ELSEIF LASTKEY() = ASC( "O" ) .OR. LASTKEY() = ASC( "o" )
         botao:MOVIMENTA( 17, 43, "Organizar" )
         EXIT
      ELSEIF NUM_INDICE != 0
         MARCADOR := IIF( SUBS( MENU_IND[ NUM_INDICE ], 42, 1 ) = " ", "x",;
                          " " )
         MENU_IND[ NUM_INDICE ] := SUBS( MENU_IND[ NUM_INDICE ], 1, 41 ) +;
                                   MARCADOR + "] "
         IF NUM_INDICE < LEN( MENU_IND )
            NUM_INDICE++
            IF POS_JANELA < 7
               POS_JANELA++
            ENDIF
         ENDIF
      ENDIF
   ENDDO
   FUNDO()
   IF NUM_INDICE = 0
      RETURN NIL
   ENDIF
   ARQS_DBF := {}
   AEVAL( MENU_IND, { | MATRIZ | IIF( SUBS( MATRIZ, 42, 1 ) <> " ",;
                AADD( ARQS_DBF, TRIM( SUBS( MATRIZ, 2, 8 ) ) ), NIL ) } )
   IF LEN( ARQS_DBF ) = 0
   BEEP()
   MENSAGEM( "N„o h  arquivos marcados para organiza‡„o", 4 )
      RETURN NIL
   ENDIF
ENDIF
IF OPCAO_INDEX <> 0
   MENSAGEM( "Aguarde organiza‡„o dos arquivos" )
ENDIF
AEVAL( IN_DICES, { | MATRIZ | IN_DICE( MATRIZ[ 1 ], MATRIZ[ 2 ], MATRIZ[ 3 ],;
                   OPCAO_INDEX ) } )
RETURN NIL

FUNCTION IN_DICE( AQ_IND, AQ_DBF, AQ_EXP, OPCAO_INDEX )
LOCAL OK_IND := .F.
IF OPCAO_INDEX = 0
   IF ASCAN( ARQ_NTX, AQ_IND ) = 0; OK_IND := .T.; ENDIF
ELSEIF OPCAO_INDEX = 1
   IF ASCAN( ARQS_DBF, AQ_DBF ) <> 0; OK_IND := .T.; ENDIF
ELSEIF OPCAO_INDEX = 2
   OK_IND := .T.
ENDIF
IF OK_IND
   IF !USEREDE( AQ_DBF, .T., 10 )
      BEEP()
      MENSAGEM( "N„o foi poss¡vel acesso ao arquivo", 5 )
      SETCOLOR( "W" )
      SET CURSOR OFF
      CLEAR
      QUIT
   ENDIF
   MENSAGEM( "Organizando o arquivo " + AQ_IND )
   INDEX ON &AQ_EXP TO &AQ_IND
   USE
ENDIF
RETURN NIL

FUNCTION IND_ACHO
PARA P_MODO, P_ELE, P_JAN
POS_JANELA := P_JAN
IF LASTKEY() = 13
   RETURN 1
ELSEIF LASTKEY() = 27
   RETURN 0
ELSEIF LASTKEY() = ASC( "T" ) .OR. LASTKEY() = ASC( "t" ) .OR.;
       LASTKEY() = ASC( "O" ) .OR. LASTKEY() = ASC( "o" )
   RETURN 1
ENDIF
RETURN 2
 
FUNCTION CIC( C_IC )
M->D_1 := 0; M->D_2 := 0; M->X_X := 1
FOR M->CON_TA = 1 TO LEN( C_IC ) - 2
   IF AT( SUBS( C_IC, M->CON_TA, 1 ), "/-." ) = 0
      M->D_1 += ( 11 - M->X_X ) * VAL( SUBS( C_IC, M->CON_TA, 1 ) )
      M->D_2 += ( 12 - M->X_X ) * VAL( SUBS( C_IC, M->CON_TA, 1 ) )
      M->X_X++
   ENDIF
NEXT
M->RES_TO := M->D_1 - ( INT( M->D_1 / 11 ) * 11 )
M->DIG_ITO := IIF( M->RES_TO < 2, 0, 11 - M->RES_TO )
M->D_2 += 2 * M->DIG_ITO
M->RES_TO := M->D_2 - ( INT( M->D_2 / 11 ) * 11 )
M->DIG_ITO := VAL( STR( M->DIG_ITO, 1 ) + STR( IIF( M->RES_TO < 2, 0, 11 - M->RES_TO ), 1 ) )
IF M->DIG_ITO != VAL( SUBS( C_IC, LEN( C_IC ) - 1, 2 ) )
   RETURN .F.
ELSE
   RETURN .T.
ENDIF

FUNCTION SET_CONF
LOCAL CFG_X, CFG_Y, CFG_COR, TEL_CONF, CUR_CFG := SETCURSOR(),;
      TECLA := 0, M_BUFFER
MOUSE( LIGA )
TEC_CONF := 1
SETKEY( T_F6, NIL )
M->CFG_X := ROW(); M->CFG_Y := COL(); M->CFG_COR := SETCOLOR()
SOMBRA( L_CFG := L_SOM, C_CFG := C_SOM, .T. )
MOUSE( DESLIGA )
M->TEL_CONF := SAVESCREEN( 06, 16, 19, 62 )
MOUSE( LIGA )
CURSOR( DESLIGA )
JANELA( 06, 18, 18, 62, "Configura‡„o" )
COR( "MENU" )
@ 09, 23 CLEAR TO 13, 57
botao:ADD( 15, 44, "Esc     " )
AADD( DADOS_MOUSE, { 15, 44, 53, T_ESC } )
AADD( DADOS_MOUSE, { 15, 27, 36, T_ENTER } )
AADD( DADOS_MOUSE, { 10, 25, 55, 1 } )
AADD( DADOS_MOUSE, { 11, 25, 55, 2 } )
AADD( DADOS_MOUSE, { 12, 25, 55, 3 } )
WHILE .T.
   botao:ADD( 15, 27, "Enter   " )
   botao:MOSTRA()
   SETCOLOR( CONTECOR[ 2 ] + "," + CONTECOR[ 7 ] )
   MOUSE( DESLIGA )
   @ 10, 25 PROMPT "[" + IIF( CNF_CON, "x", " " ) + "] Confirma‡„o para entradas  "
   @ 11, 25 PROMPT "[" + IIF( CNF_REP, "x", " " ) + "] Repeti‡„o de registros     "
   @ 12, 25 PROMPT "[" + IIF( CNF_DEL = "  ", " ", "x" ) + "] Delimitadores para entradas"
   IF TECLA = 0 .OR. TECLA = T_ENTER
      M_BUFFER := CHR( T_ENTER )
   ELSEIF TECLA = T_ESC
      M_BUFFER := CHR( T_ESC )
   ELSE
      M_BUFFER := CHR( TECLA ) + CHR( T_ENTER )
   ENDIF
   KEYBOARD M_BUFFER
   MENU TO M->TEC_CONF
   MOUSE( LIGA )
   IF TECLA != T_ENTER .AND. TECLA != T_ESC
      WHILE( TECLA := INKEY() ) == 0
         IF TECLA = 0
            //
            // -> Lˆ buffer do mouse
            TECLA := ACAO_MOUSE()
            IF TECLA != 0; EXIT; ENDIF
         ENDIF
      ENDDO
      IF TECLA >= 1 .AND. TECLA <= 3
         M->TEC_CONF := TECLA
         TECLA := 0
      ELSE
         LOOP
      ENDIF
   ELSE
      TECLA := 0
   ENDIF
   IF M->TEC_CONF = 0
      botao:MOVIMENTA( 15, 44, "Esc     " )
      EXIT
   ELSE
      botao:MOVIMENTA( 15, 27, "Enter   " )
   ENDIF
   IF M->TEC_CONF = 1
      M->CNF_CON := IIF( M->CNF_CON, .F., .T. )
      IF M->CNF_CON
         SET CONFIRM ON
      ELSE
         SET CONFIRM OFF
      ENDIF
   ELSEIF M->TEC_CONF = 2
      M->CNF_REP := IIF( M->CNF_REP, .F., .T. )
      M->RE_PETICAO := IIF( M->CNF_REP, .F., .T. )
   ELSEIF M->TEC_CONF = 3
      M->CNF_DEL := IIF( M->CNF_DEL = "  ", "[]", "  " )
      IF M->CNF_DEL = "  "
         SET DELIMITERS OFF
      ELSE
         SET DELIMITERS ON
         SET DELIMITERS TO M->CNF_DEL
      ENDIF
   ENDIF
ENDDO
DADOS_MOUSE := {}
MOUSE( DESLIGA )
RESTSCREEN( 06, 16, 19, 62, M->TEL_CONF )
MOUSE( LIGA )
SETCOLOR( M->CFG_COR )
SETCURSOR( CUR_CFG )
SOMBRA( L_CFG, C_CFG )
SETPOS( M->CFG_X, M->CFG_Y )
SETKEY( T_F6, { || SET_CONF() } )
 
FUNCTION HELP_TEC
//
// -> Monta HELP das teclas com caracteres acentuados
LOCAL CUR_THEL := SETCURSOR(), TECLA
MOUSE( LIGA )
SOMBRA( L_THEL := L_SOM, C_THEL := C_SOM, .T. )
M->THEL_COR := SETCOLOR()
MOUSE( DESLIGA )
M->TEL_HPTC := SAVESCREEN( 02 + LIN_MENU, 06, 22 + LIN_MENU, 71 )
MOUSE( LIGA )
M->THEL_X := ROW(); M->THEL_Y := COL()
CURSOR( DESLIGA )
JANELA( 02 + LIN_MENU, 08, 21 + LIN_MENU, 71, "Teclas com caracteres acentuados" )
COR( "MENU" )
@ 04 + LIN_MENU, 11 SAY "ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿"
@ 05 + LIN_MENU, 11 SAY "³ Tecla   Caracter ³ Tecla   Caracter ³ Tecla   Caracter ³"
@ 06 + LIN_MENU, 11 SAY "ÃÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´"
@ 07 + LIN_MENU, 11 SAY "³ Shift F2    Ž    ³ Ctrl F1         ³ Alt F1      ¢    ³"
@ 08 + LIN_MENU, 11 SAY "³ Shift F3        ³ Ctrl F2     ‚    ³ Alt F2      ™    ³"
@ 09 + LIN_MENU, 11 SAY "³ Shift F4    „    ³ Ctrl F3     ˆ    ³ Alt F3      ”    ³"
@ 10 + LIN_MENU, 11 SAY "³ Shift F5         ³ Ctrl F4     ‰    ³ Alt F4      •    ³"
@ 11 + LIN_MENU, 11 SAY "³ Shift F6    …    ³ Ctrl F5     Š    ³ Alt F5      £    ³"
@ 12 + LIN_MENU, 11 SAY "³ Shift F7    †    ³ Ctrl F6     ¡    ³ Alt F6      š    ³"
@ 13 + LIN_MENU, 11 SAY "³ Shift F8    ƒ    ³ Ctrl F7     ‹    ³ Alt F7          ³"
@ 14 + LIN_MENU, 11 SAY "³ Shift F9    €    ³ Ctrl F8     Œ    ³ Alt F8      –    ³"
@ 15 + LIN_MENU, 11 SAY "³ Shift F10   ‡    ³ Ctrl F9         ³ Alt F9      ¦    ³"
@ 16 + LIN_MENU, 11 SAY "³                  ³ Ctrl F10    “    ³ Alt F10     §    ³"
@ 17 + LIN_MENU, 11 SAY "ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ"
botao:ADD( 19 + LIN_MENU, 35, "Esc     " )
botao:MOSTRA()
AADD( DADOS_MOUSE, { 19 + LIN_MENU, 35, 44, T_ESC } )
WHILE( TECLA := INKEY() ) != T_ESC
   IF TECLA = 0
      //
      // -> Lˆ buffer do mouse
      TECLA := ACAO_MOUSE()
      IF TECLA = T_ESC; EXIT; ENDIF
   ENDIF
ENDDO
DADOS_MOUSE := {}
botao:MOVIMENTA( 19 + LIN_MENU, 35, "Esc     " )
MOUSE( DESLIGA )
RESTSCREEN( 02 + LIN_MENU, 06, 22 + LIN_MENU, 71, M->TEL_HPTC )
MOUSE( LIGA )
SETCOLOR( M->THEL_COR )
SETCURSOR( CUR_THEL )
SOMBRA( L_THEL, C_THEL )
SETPOS( M->THEL_X, M->THEL_Y )
 
FUNCTION CALEN
//
// -> Fun‡„o que ativa o calend rio
STATIC MES, ANO, DATA
LOCAL ULT_CURSOR := SETCURSOR(), C_CALEN, L_CALEN, LINHA := ROW(),;
      COLUNA := COL(), ULT_COR := SETCOLOR(), LIN, COL, NOVO_ANO,;
      TELA, ES_COLHA := 1, ULT_DIA_MES, CONTAR, GETLIST := {}
IF MES = NIL
   MES := MONTH( M->DAT_HOJE )
   ANO := YEAR( M->DAT_HOJE )
   DATA := CTOD( "01/" + STR( MES, 2 ) + "/" + STR( ANO, 4 ) )
ENDIF
MOUSE( LIGA )
CURSOR( DESLIGA )
SET CENTURY ON
SOMBRA( L_CALEN := L_SOM, C_CALEN := C_SOM, .T. )
MOUSE( DESLIGA )
TELA := SAVESCREEN( 04, 11, 21, 66 )
MOUSE( LIGA )
JANELA( 04, 13, 20, 66, "Calend rio" )
M->SOS_MENU := "CALENDARIO"
WHILE .T.
   COR( "JANELA DE DIALOGO" )
   @ 06, 16 SAY "Dom  Seg  Ter  Qua  Qui  Sex  Sab"
   SETCOLOR( SUBS( CONTECOR[ 6 ], 4, 2 ) + "/" + SUBS( CONTECOR[ 4 ], 4, 2 ) )
   FOR CONTAR = 8 TO 18 STEP 2
      @ CONTAR + 0, 16 SAY "ÛÛÛÛ ÛÛÛÛ ÛÛÛÛ ÛÛÛÛ ÛÛÛÛ ÛÛÛÛ ÛÛÛÛ"
      @ CONTAR + 1, 16 SAY "ßßßß ßßßß ßßßß ßßßß ßßßß ßßßß ßßßß"
   NEXT
   IF AT( SUBS( STR( MES + 100, 3 ), 2 ), "01 03 05 07 08 10 12" ) != 0
      ULT_DIA_MES := 31
   ELSE
      ULT_DIA_MES := IIF( MES != 2, 30, IIF( MOD( ANO, 4 ) = 0, 29, 28 ) )
   ENDIF
   COL := DOW( DATA )
   LIN := 8
   COR( "BOTOES" )
   FOR CONTAR = 1 TO ULT_DIA_MES
      IF COL = 1
         COR( "BOTAO EM DESTAQUE" )
         @ LIN, ( COL * 5 ) + 13 SAY STR( CONTAR, 2 )
         COR( "BOTOES" )
      ELSE
         @ LIN, ( COL * 5 ) + 13 SAY STR( CONTAR, 2 )
      ENDIF
      COL++
      IF COL > 7
         COL := 1
         LIN += 2
      ENDIF
   NEXT
   COR( "BOTOES" )
   @ 06, 53 CLEAR TO 07, 63
   @ 06, 57 SAY SUBS( "JanFevMarAbrMaiJunJulAgoSetOutNovDez", MONTH( DATA ) * 3 - 2, 3 )
   @ 07, 56 SAY TRAN( YEAR( DATA ), "@E 9,999" )
botao:ADD( 10, 53, "(+) Mˆs " )
botao:ADD( 12, 53, "(-) Mˆs " )
botao:ADD( 14, 53, "(+) Ano " )
botao:ADD( 16, 53, "(-) Ano " )
botao:ADD( 18, 53, "Ano     " )
   ES_COLHA := botao:RODA( ES_COLHA )
   IF ES_COLHA = 0
      EXIT
   ELSEIF ES_COLHA = 5
      @ 07, 54 SAY CHR( 26 ) COLOR CONTECOR[ 2 ]
      NOVO_ANO := ANO
      @ 07, 56 GET NOVO_ANO PICT "@E 9,999"
      CURSOR( LIGA )
      READ
      CURSOR( DESLIGA )
      IF LASTKEY() != T_ESC
         ANO := NOVO_ANO
      ENDIF
   ENDIF
   ANO += IIF( ES_COLHA = 4, -1, IIF( ES_COLHA = 3, 1, 0 ) )
   ANO := IIF( ANO < 100, 100, IIF( ANO > 2999, 2999, ANO ) )
   MES += IIF( ES_COLHA = 2, -1, IIF( ES_COLHA = 1, 1, 0 ) )
   MES := IIF( MES < 1, 12, IIF( MES > 12, 1, MES ) )
   DATA := CTOD( "01/" + STR( MES, 2 ) + "/" + STR( ANO, 4 ) )
ENDDO
M->SOS_MENU := ""
MOUSE( DESLIGA )
RESTSCREEN( 04, 11, 21, 66, TELA )
MOUSE( LIGA )
SOMBRA( L_CALEN, C_CALEN )
SETCOLOR( ULT_COR )
SETCURSOR( ULT_CURSOR )
SET CENTURY OFF
SETPOS( LINHA, COLUNA )
 
FUNCTION EDITOR
PARA ME_VAR, ME_COM, ALTE_RA
//
// -> Funcao que edita campos do tipo "MEMO"
IF ALTE_RA = NIL; ALTE_RA := .T.; ENDIF
IF M->ME_MO != "[memo]"
   M->ME_MO := "[memo]"
   RETURN .F.
ENDIF
IF LASTKEY() = T_ENTER .OR. !ALTE_RA
   MOUSE( DESLIGA )
   SAVE SCREEN TO TELA
   MOUSE( LIGA )
   SOMBRA( L_EDITOR := L_SOM, C_EDITOR := C_SOM, .T. )
   MENSAGEM( "Tecle <ESC> para finalizar a edi‡„o" )
   JANELA( 12, 02, 21, 77, ALLTRIM( ME_COM ) )
   @ 21, 05 SAY "Linha"
   @ 21, 19 SAY "Coluna"
   M->INS_ERT := READINSERT()
   IF M->INS_ERT
      @ 21, 31 SAY "Insert"
   ENDIF
   ME_VAR = MEMOEDIT( ME_VAR, 13, 03, 20, 76, ALTE_RA, "FUNMEMO" )
   COR( "GETS" )
   L_SOM := L_EDITOR; C_SOM := C_EDITOR
   MOUSE( DESLIGA )
   RESTORE SCREEN FROM TELA
   MOUSE( LIGA )
ENDIF
RETURN .T.

FUNCTION FUNMEMO( MODO, LINHA, COLUNA )
//
// -> Funcao de usuario para campo memo
IF LASTKEY() = T_ESC .AND. ALTE_RA
   BEEP()
   IF PERG( "Confirma atualiza‡„o do campo memo ?" ) = "S"
      MENSAGEM( "Tecle <ESC> para retornar" )
      RETURN T_CTRL_W
   ELSE
      MENSAGEM( "Tecle <ESC> para retornar" )
      RETURN T_ESC
   ENDIF
ENDIF
COR( "BOX DA JANELA DE DIALOGO" )
IF LASTKEY() = T_INSERT .AND. ALTE_RA
   IF M->INS_ERT
      M->INS_ERT := .F.
      @ 21, 31 SAY "      "
   ELSE
      M->INS_ERT := .T.
      @ 21, 31 SAY "Insert"
   ENDIF
ENDIF
@ 21, 11 SAY STRZERO( LINHA, 5 )
@ 21, 26 SAY STRZERO( COLUNA + 1, 2 )
COR( "JANELA DE DIALOGO" )
RETURN 0
 
FUNCTION MES_ANO
LOCAL RETORNO
//
// -> Retorna o mes e o ano de uma data no formato caracter (mm/aa)
//    ou muda o formato de uma variavel caracter de (mm/aa) para (aa/mm)
PARA CONTEUDO
IF TYPE( "CONTEUDO" ) = "D"
   RETORNO := SUBS( STR( YEAR( CONTEUDO ), 4 ), 3 ) + "/"
   RETORNO += STRZERO( MONTH( CONTEUDO ), 2 )
ELSE
   RETORNO := SUBS( CONTEUDO, 4, 2 ) + "/" + SUBS( CONTEUDO, 1, 2 )
ENDIF
RETURN RETORNO
 
//
// -> Retorna o ano de uma data no formato caracter contendo 2 bytes
FUNCTION ANO( CONTEUDO )
RETURN SUBS( STR( YEAR( CONTEUDO ), 4 ), 3 )
 
FUNCTION MENSAGEM( TEXTO, PAUSA )
//
// -> Funcao que imprime mensagens na tela
//
// TEXTO => Recebe o texto a ser impresso na linha de mensagem.
// TEMPO => Recebe o tempo de espera para a mensagem.
//
STATIC ULT_MENSAGEM := ""
LOCAL ULT_CURSOR := SETCURSOR()
IF TEXTO = NIL; TEXTO := ""; ENDIF
CURSOR( DESLIGA )
@ MAXROW(), 11 SAY PADC( TEXTO, 58 ) COLOR CONTECOR[ 2 ]
IF PAUSA = NIL
   ULT_MENSAGEM := TEXTO
ELSE
   TEC_MOU( PAUSA )
   @ MAXROW(), 11 SAY PADC( ULT_MENSAGEM, 58 ) COLOR CONTECOR[ 2 ]
ENDIF
SETCURSOR( ULT_CURSOR )
RETURN NIL
 
FUNCTION DELE_TAR
RETURN IIF( DELETED(), "*", " " )
 
FUNCTION PERGUNTA( TEX_TO, RES_POSTA )
//
// -> Funcao que executa uma pergunta
IF RES_POSTA = NIL; RES_POSTA="S"; ENDIF
PER_COR := SETCOLOR()
CURSOR( DESLIGA )
MOUSE( DESLIGA )
SAVE SCREEN TO PER_TELA
MOUSE( LIGA )
M->SIM_NAO := IIF( RES_POSTA ="N", 2, 1 )
M->LAR_G := LEN( TEX_TO )
IF M->LAR_G < 37
   M->LAR_G := 51
ELSE
   M->LAR_G += 14
ENDIF
COL_SUP := INT( ( 80 - M->LAR_G ) / 2 )
COL_INF := COL_SUP + LAR_G - 1
JANELA( 08, COL_SUP, 16, COL_INF )
COR( "JANELA DE DIALOGO" )
@ 11, ( 80 - LEN( TEX_TO ) ) / 2 SAY TEX_TO
botao:ADD( 13, 25, "Sim     " )
botao:ADD( 13, 42, "N„o     " )
SIM_NAO := botao:RODA()
MOUSE( DESLIGA )
RESTORE SCREEN FROM PER_TELA
MOUSE( LIGA )
SETCOLOR( PER_COR )
RETURN IIF( M->SIM_NAO = 1, "S", "N" )

FUNCTION BOTAO( LINHA_SUPERIOR, COLUNA_ESQUERDA, NOME_BOTAO )
LOCAL BOTAO_MOUSE, COLUNA_MOUSE, LINHA_MOUSE, LEITURA_MOUSE,;
      TIPO_OPERACAO, LARGURA_BOTAO, CONTAR, TECLA, PONTEIRO := 1
IF PCOUNT() = 0
   TIPO_OPERACAO := EDITA_BOTOES
ELSEIF PCOUNT() = 1
   TIPO_OPERACAO := EDITA_BOTOES
   PONTEIRO := LINHA_SUPERIOR
ELSEIF PCOUNT() = 2
   TIPO_OPERACAO := MOSTRA_BOTOES
ELSEIF PCOUNT() = 3
   TIPO_OPERACAO := MOVIMENTA_BOTAO
ENDIF
IF TIPO_OPERACAO = MOVIMENTA_BOTAO
   LARGURA_BOTAO := LEN( NOME_BOTAO ) + 2
   COR( "JANELA DE DIALOGO" )
   @ LINHA_SUPERIOR, COLUNA_ESQUERDA SAY " "
   @ LINHA_SUPERIOR + 1, COLUNA_ESQUERDA - 1 SAY SPACE( LARGURA_BOTAO )
   @ LINHA_SUPERIOR, COLUNA_ESQUERDA + LARGURA_BOTAO - 1 SAY " "
   COR( "BOTAO EM DESTAQUE" )
   @ LINHA_SUPERIOR, COLUNA_ESQUERDA - 1 SAY " " + NOME_BOTAO + " "
   INKEY( .2 )
   COR( "BOTOES" )
   @ LINHA_SUPERIOR, COLUNA_ESQUERDA SAY " " + NOME_BOTAO + " "
   SETCOLOR( "N/" + ALLTRIM( SUBS( CONTECOR[ 4 ], 4 ) ) )
   @ LINHA_SUPERIOR, COLUNA_ESQUERDA - 1 SAY "Ü"
   @ LINHA_SUPERIOR + 1, COLUNA_ESQUERDA - 1 SAY REPL( "ß", LARGURA_BOTAO ) + " "
   INKEY( .2 )
ENDIF
IF TIPO_OPERACAO = EDITA_BOTOES .OR. TIPO_OPERACAO = MOSTRA_BOTOES
   FOR CONTAR := 1 TO LEN( ObjBotao )
      LARGURA_BOTAO := LEN( ObjBotao[ CONTAR ][ 3 ] ) + 2
      COR( "BOTOES" )
      @ ObjBotao[ CONTAR ][ 1 ], ObjBotao[ CONTAR ][ 2 ]  SAY " " + ;
        ObjBotao[ CONTAR ][ 3 ] + " "
      SETCOLOR( "N/" + ALLTRIM( SUBS( CONTECOR[ 4 ], 4 ) ) )
      @ ObjBotao[ CONTAR ][ 1 ], ObjBotao[ CONTAR ][ 2 ] - 1 SAY "Ü"
      @ ObjBotao[ CONTAR ][ 1 ] + 1, ObjBotao[ CONTAR ][ 2 ] - 1 SAY;
        REPL( "ß", LARGURA_BOTAO ) + " "
   NEXT
ENDIF
IF TIPO_OPERACAO = EDITA_BOTOES
   TECLA := 0
   WHILE .T.
      LARGURA_BOTAO := LEN( ObjBotao[ PONTEIRO ][ 3 ] ) + 2
      COR( "BOTAO EM DESTAQUE" )
      @ ObjBotao[ PONTEIRO ][ 1 ], ObjBotao[ PONTEIRO ][ 2 ] SAY;
        " " + ObjBotao[ PONTEIRO ][ 3 ] + " "
      SETCOLOR( "N/" + ALLTRIM( SUBS( CONTECOR[ 4 ], 4 ) ) )
      @ ObjBotao[ PONTEIRO ][ 1 ], ObjBotao[ PONTEIRO ][ 2 ] - 1 SAY "Ü"
      @ ObjBotao[ PONTEIRO ][ 1 ] + 1, ObjBotao[ PONTEIRO ][ 2 ] - 1 SAY;
        REPL( "ß", LARGURA_BOTAO ) + " "
      IF TECLA = T_ENTER
         INKEY( .2 )
         botao:LIMPA()
         RETURN PONTEIRO
      ENDIF
      TECLA := 0
      WHILE TECLA = 0
         TECLA := INKEY()
         MOUSE( @BOTAO_MOUSE, @LINHA_MOUSE, @COLUNA_MOUSE )
         IF BOTAO_MOUSE = M_ESQUERDO
            LEITURA_MOUSE := SUBS( SAVESCREEN( LINHA_MOUSE, COLUNA_MOUSE, LINHA_MOUSE, COLUNA_MOUSE ), 1, 1 )
            IF LEITURA_MOUSE = CHR( 254 )
               TECLA := T_ESC
               EXIT
            ELSEIF LINHA_MOUSE = 24 .AND. ( COLUNA_MOUSE >= 71 .AND. COLUNA_MOUSE <= 78 )
               TECLA := T_F1
               EXIT
            ENDIF
            FOR CONTAR = 1 TO LEN( ObjBotao )
               IF ObjBotao[ CONTAR ][ 1 ] = LINHA_MOUSE .AND.;
                  ( COLUNA_MOUSE >= ObjBotao[ CONTAR ][ 2 ] .AND.;
                  COLUNA_MOUSE <= ObjBotao[ CONTAR ][ 2 ] +;
                  LEN( ObjBotao[ CONTAR ][ 3 ] ) + 1 )
                     TECLA := T_ENTER; PONTEIRO := CONTAR
               ENDIF
            NEXT
            IF TECLA != T_ENTER
               BEEP_MOUSE()
            ENDIF
         ELSEIF BOTAO_MOUSE = M_OS_DOIS
            TECLA := T_ESC
         ELSEIF BOTAO_MOUSE = M_DIREITO
            TECLA := T_ENTER
         ENDIF
      ENDDO
      IF TECLA = T_ESC
         botao:LIMPA()
         RETURN 0
      ENDIF
      IF TECLA = T_F1
         HELP( "CALENDARIO", 1, "" )
      ENDIF
      COR( "BOTOES" )
      @ ObjBotao[ PONTEIRO ][ 1 ], ObjBotao[ PONTEIRO ][ 2 ] + 1 SAY;
        ObjBotao[ PONTEIRO ][ 3 ]
      FOR CONTAR = 1 TO LEN( ObjBotao )
         IF SUBS( ObjBotao[ CONTAR ][ 3 ], 1, 1 ) = UPPER( CHR( TECLA ) )
            PONTEIRO := CONTAR
            TECLA := T_ENTER
            EXIT
         ENDIF
      NEXT
      IF TECLA = T_ENTER
         LARGURA_BOTAO := LEN( ObjBotao[ PONTEIRO ][ 3 ] ) + 2
         COR( "JANELA DE DIALOGO" )
         @ ObjBotao[ PONTEIRO ][ 1 ], ObjBotao[ PONTEIRO ][ 2 ] SAY " "
         @ ObjBotao[ PONTEIRO ][ 1 ] + 1, ObjBotao[ PONTEIRO ][ 2 ] - 1 SAY;
           SPACE( LARGURA_BOTAO )
         @ ObjBotao[ PONTEIRO ][ 1 ], ObjBotao[ PONTEIRO ][ 2 ] +;
           LARGURA_BOTAO - 1 SAY " "
         COR( "BOTAO EM DESTAQUE" )
         @ ObjBotao[ PONTEIRO ][ 1 ], ObjBotao[ PONTEIRO ][ 2 ] - 1 SAY ;
           " " + ObjBotao[ PONTEIRO ][ 3 ] + " "
         INKEY( .2 )
         LOOP
      ENDIF
      IF TECLA = T_ESQUERDA .OR. TECLA = T_CIMA
         PONTEIRO--
      ELSEIF TECLA = T_DIREITA .OR. TECLA = T_BAIXO
         PONTEIRO++
      ENDIF
      PONTEIRO := IIF( PONTEIRO < 1, LEN( ObjBotao ),;
                  IIF( PONTEIRO > LEN( ObjBotao ), 1, PONTEIRO ) )
   ENDDO
ENDIF
botao:LIMPA()
RETURN NIL
**
**BI [INI] FUN.B03
**BI [FIM] FUN.B03
**
 
/* Final do programa AGENDFU1.PRG */