
/*
TITULO     : Agenda de Telefone
DATA       : 13/02/25
PROGRAMA   : AGENDCON.PRG
COMENTARIO : MENU DE MANUTENCOES
*/
 
#include "AGEND.CH"
#include "AGENDMOU.CH"
**
**BI [INI] MCO.B01
**BI [FIM] MCO.B01
**
PARA R_CA
MENSAGEM( "Tecle <ESC> para sair" )
menu:ADD( "Consulta por Codigo", AGENDC01() )
menu:ADD( "Consulta por CPF", AGENDC02() )
menu:ADD( "Consulta por Nome", AGENDC03() )
menu:ADD( "Consulta por Celular", AGENDC04() )
menu:ADD( "Consulta por Contato", AGENDC05() )
menu:RODA()
CLOSE DATABASES
**
**BI [INI] MCO.B02
**BI [FIM] MCO.B02
**

FUNCTION  EDIT_JAN( D_JAN )
LOCAL TA_MANHO, MAI_OR, COL_SUP, COL_INF, LIN_SUP, LIN_INF,;
      L_EDJAN, C_EDJAN, CONTAR, TEL_EDJAN
TEL_EDJAN := SAVESCREEN( 00, 00, MAXROW(), MAXCOL() )
MENSAGEM( "Tecle <ESC> para sair" )
SOMBRA( L_EDJAN := L_SOM, C_EDJAN := C_SOM, .T. )
//
// -> Determina o maior tamanho de linha
MAI_OR := 0
FOR CONTAR = 1 TO LEN( D_JAN )
   TA_MANHO := LEN( D_JAN[ CONTAR ][ 1 ] ) + D_JAN[ CONTAR ][ 4 ] + 1
   IF MAI_OR < TA_MANHO; MAI_OR := TA_MANHO; ENDIF
NEXT
//
// -> Calcula a linha superior da janela
LIN_SUP := INT( ( ( MAXROW() + 1 ) - ( ( LEN( D_JAN ) * 2 ) + 3 ) ) / 2 )
//
// -> Calcula a linha inferior da janela
LIN_INF := LIN_SUP + ( LEN( D_JAN ) * 2 ) + 2
//
// -> Calcula a coluna superior da janela
COL_SUP := INT( ( ( MAXCOL() + 1 ) - ( MAI_OR + 6 ) ) / 2 )
//
// -> Calcula a coluna inferior da janela
COL_INF := COL_SUP + MAI_OR + 5
JANELA( LIN_SUP, COL_SUP, LIN_INF, COL_INF )
COR( "GETS" )
//
// -> Monta os GET'S para edicao
FOR CONTAR = 1 TO LEN( D_JAN )
   IF LEN( D_JAN ) = 5
      //
      // -> Se nao houver utilizacao de validacoes
      IF D_JAN[ CONTAR ][ 3 ] = NIL
         //
         // -> Se nao houver utilizacao de mascaras
         @ LIN_SUP + ( CONTAR * 2 ), COL_SUP + 3 SAY D_JAN[ CONTAR ][ 1 ];
         GET D_JAN[ CONTAR ][ 2 ]
      ELSE
         //
         // -> Se houver utilizacao de mascaras
         @ LIN_SUP + ( CONTAR * 2 ), COL_SUP + 3 SAY D_JAN[ CONTAR ][ 1 ];
         GET D_JAN[ CONTAR ][ 2 ] PICT D_JAN[ CONTAR ][ 3 ]
      ENDIF
   ELSE
      //
      // -> Se houver utilizacao de validacoes
      IF D_JAN[ CONTAR ][ 3 ] = NIL
         //
         // -> Se nao houver utilizacao de mascaras
         @ LIN_SUP + ( CONTAR * 2 ), COL_SUP + 3 SAY D_JAN[ CONTAR ][ 1 ];
         GET D_JAN[ CONTAR ][ 2 ]
      ELSE
         //
         // -> Se houver utilizacao de mascaras
         @ LIN_SUP + ( CONTAR * 2 ), COL_SUP + 3 SAY D_JAN[ CONTAR ][ 1 ];
         GET D_JAN[ CONTAR ][ 2 ] PICT D_JAN[ CONTAR ][ 3 ]
      ENDIF
   ENDIF
NEXT
CURSOR( LIGA )
READ
CURSOR( DESLIGA )
SOMBRA( L_EDJAN, C_EDJAN )
RESTSCREEN( 00, 00, MAXROW(), MAXCOL(), TEL_EDJAN )
IF LASTKEY() = T_ESC
   RETURN .F.
ENDIF
//
// -> Faz atualizacao das variaveis atraves dos blocos de codigo
FOR CONTAR = 1 TO LEN( D_JAN )
   EVAL( D_JAN[ CONTAR ][ 5 ], D_JAN[ CONTAR ][ 2 ] )
NEXT
RETURN .T.

FUNCTION BRO_WSE( MOS_TRA )
STATIC ES_COLHA := 1, UL_TIMO := { 1, .F. }
LOCAL AL_TERA, CONTAR, COLUNA_MEM, TECLA, RE_FAZ, TE_LA, DADO_CUR,;
      LIN := 0, COL :=0 , BO_TAO :=0
IF MOS_TRA = NIL
   MOS_TRA := .F.
ENDIF
//
// -> Definicao do BROWSE
OBJETO := TBROWSEDB( 06, 05, 19, 74 )
//
// -> Separador do cabecalho
OBJETO:HEADSEP := TB_SEP_CAB
//
// -> Separador de colunas
OBJETO:COLSEP := TB_SEP_LIN
//
// -> Cor do browse     (1)                   (2)                   (3)
OBJETO:COLORSPEC := CONTECOR[ 2 ] + "," + CONTECOR[ 3 ] + "," + TB_COR_DEL
FOR CONTAR = 1 TO LEN( OB_COLUN )
   OB_COLUNA := OB_COLUN[ CONTAR ]
   //
   // -> Adicionando as colunas ao browse
   OBJETO:ADDCOLUMN( OB_COLUNA )
   //
   // -> Separador de rodape
   OB_COLUNA:FOOTSEP := TB_RODAPE
   //
   // -> Definicao das cores do BROWSE e registros DELETADOS
   OB_COLUNA:COLORBLOCK := { || IIF( DELETED(), { 3, 2 }, { 1, 2 } ) }
NEXT
COR( "MENU" )
WHILE .T.
   //
   // -> Loop de estabilizacao do browse
   MOUSE( DESLIGA )
   WHILE ( !OBJETO:STABILIZE() )
      IF ( TECLA := INKEY() ) = 0
          MOUSE( @BO_TAO, @LIN, @COL )
      ENDIF
      IF BO_TAO = M_ESQUERDO .OR. BO_TAO = M_OS_DOIS
         DADO_CUR := SUBS( SAVESCREEN( LIN, COL, LIN, COL ), 1, 1 )
         IF DADO_CUR = CHR( 254 ) .OR. BO_TAO = M_OS_DOIS
            TECLA := T_ESC
         ELSEIF LIN = 24 .AND. ( COL >= 71 .AND. COL <= 78 )
            TECLA := T_F1
         ELSEIF ( LIN = 5 .OR. LIN = 7 ) .AND. ( COL >= 5 .AND. COL <= 74 )
            TECLA := T_CIMA
         ELSEIF LIN = 19 .AND. ( COL >= 5 .AND. COL <= 74 )
            TECLA := T_BAIXO
         ELSEIF COL = 4 .AND. ( LIN >= 6 .AND. LIN <= 18 )
            TECLA := T_ESQUERDA
         ELSEIF COL = 75 .AND. ( LIN >= 6 .AND. LIN <= 18 )
            TECLA := T_DIREITA
         ELSE
            BEEP_MOUSE()
         ENDIF
      ELSEIF BO_TAO = M_DIREITO
         TECLA := T_ENTER
      ENDIF
      //
      // -> Se alguma tecla for pressionada sai sem estabilizar
      IF TECLA != 0
         EXIT
      ENDIF
   ENDDO
   MOUSE( LIGA )
   //
   // -> Se MOS_TRA = .T. abandona o BROWSE sem editar. E' utilizado para
   //    mostrar uma tela cheia do BROWSE e sair
   IF MOS_TRA
      RETURN .T.
   ENDIF
   //
   // -> Se o browse estiver estabilizado espera uma o pressionamento
   //    de uma tecla
   IF OBJETO:STABLE
      SETCOLOR( CONTECOR[ 5 ] )
      @ 21, 04 SAY STRZERO( RECN(), 7 ) + "   " + IIF( DELETED(), "Del", "   " )
      WHILE( TECLA := INKEY() ) == 0
         IF TECLA = 0
            MOUSE( @BO_TAO, @LIN, @COL )
         ENDIF
         IF BO_TAO = M_ESQUERDO .OR. BO_TAO = M_OS_DOIS
            C_COL := COL()
            C_ROW := ROW()
            DADO_CUR := SUBS( SAVESCREEN( LIN, COL, LIN, COL ), 1, 1 )
            IF DADO_CUR = CHR( 254 ) .OR. BO_TAO = M_OS_DOIS
               TECLA := T_ESC
            ELSEIF LIN = 24 .AND. ( COL >= 71 .AND. COL <= 78 )
               TECLA := T_F1
            ELSEIF ( LIN = 5 .OR. LIN = 7 ) .AND. ( COL >= 5 .AND. COL <= 74 )
               TECLA := T_CIMA
            ELSEIF LIN = 19 .AND. ( COL >= 5 .AND. COL <= 74 )
               TECLA := T_BAIXO
            ELSEIF COL = 4 .AND. ( LIN >= 6 .AND. LIN <= 18 )
               TECLA := T_ESQUERDA
            ELSEIF COL = 75 .AND. ( LIN >= 6 .AND. LIN <= 18 )
               TECLA := T_DIREITA
            ELSEIF ( COL >= 6 .AND. COL <= 73 ) .AND. ( LIN >= 8 .AND. LIN <= 18 )
               OBJETO:ROWPOS := LIN - 7
               OBJETO:REFRESHALL()
               WHILE ( !OBJETO:STABILIZE() )
               ENDDO
               TECLA := T_ENTER
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
   ENDIF
   IF TECLA == T_CIMA
      OBJETO:UP()
   ELSEIF TECLA == T_BAIXO
      OBJETO:DOWN()
   ELSEIF TECLA == T_ESQUERDA
      OBJETO:LEFT()
   ELSEIF TECLA == T_DIREITA
      OBJETO:RIGHT()
   ELSEIF TECLA == T_F1
      HELP( "BRO_WSE" )
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
   ELSEIF TECLA == T_HOME
      GO TOP
      OBJETO:REFRESHALL()
   ELSEIF TECLA == T_END
      GO BOTT
      OBJETO:REFRESHALL()
   ELSEIF TECLA == T_PGUP
      OBJETO:PAGEUP()
   ELSEIF TECLA == T_PGDN
      OBJETO:PAGEDOWN()
   ELSEIF TECLA == T_CTRL_PGUP
      OBJETO:GOTOP()
   ELSEIF TECLA == T_CTRL_PGDN
      OBJETO:GOBOTTOM()
   ELSEIF TECLA == T_CTRL_HOME
      OBJETO:PANHOME()
   ELSEIF TECLA == T_CTRL_END
      OBJETO:PANEND()
   ELSEIF TECLA == T_CTRL_ESQUERDA
      OBJETO:PANLEFT()
   ELSEIF TECLA == T_CTRL_DIREITA
      OBJETO:PANRIGHT()
   ELSEIF TECLA == T_ESC
      RETURN .T.
   ELSEIF TECLA = T_ENTER
      MOUSE( DESLIGA )
      SAVE SCREEN TO TE_LA
      MOUSE( LIGA )
      FUNDO()
      RE_FAZ := .F.
      WHILE .T.
         MENSAGEM( "Tecle <ESC> para sair" )
         //
         // -> Carrega o conteudo do registro em variaveis de memoria
         EVAL( ROTI_NAS[ 1 ], ALTERACAO )
         //
         // -> Mostra em detalhe o registro atual
         EVAL( ROTI_NAS[ 2 ], MOSTRA_PAG_1 )
         ME_NU := {}
         ES_COLHA := UL_TIMO[ 1 ]
         IF !DELETED()
            //
            // -> Se o registro nao estiver DELETADO permite fazer
            //    altercao de exclusao dos dados
            AADD( ME_NU, "Altera" )
            AADD( ME_NU, "Exclui" )
            AL_TERA := 1
            IF UL_TIMO[ 2 ] = .T.
               UL_TIMO[ 2 ] := .F.
               ES_COLHA++
            ENDIF
         ELSE
            //
            // -> Se o registro estiver deletado permite sua recuperacao
            AADD( ME_NU, "Recupera" )
            AL_TERA := 0
            IF UL_TIMO[ 2 ] = .F.
               UL_TIMO[ 2 ] := .T.
               ES_COLHA--
            ENDIF
         ENDIF
         AADD( ME_NU, "Anterior" )
         AADD( ME_NU, "Proximo" )
         AADD( ME_NU, "Retorna" )
         //
         // -> Prepara MENU
         COR( "MENU" ); @ LIN_MENU, 14
         TECLA := 0
         WHILE .T.
            COLUNA_MEN := 14
            MOUSE( DESLIGA )
            FOR CONTAR := 1 TO LEN( ME_NU )
               @ LIN_MENU, COLUNA_MEN PROMPT " " + ME_NU[ CONTAR ] + " "
               COLUNA_MEN += LEN( ME_NU[ CONTAR ] ) + 3
            NEXT
            IF TECLA = 0 .OR. TECLA = T_ENTER .OR. TECLA = T_ESC
               M_BUFFER := CHR( T_ENTER )
            ELSE
               M_BUFFER := CHR( TECLA ) + CHR( T_ENTER )
            ENDIF
            KEYBOARD M_BUFFER
            MENU TO ES_COLHA
            MOUSE( LIGA )
            IF TECLA = T_ENTER .OR. TECLA = T_ESC
               EXIT
            ENDIF
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
                     HELP( "MENU_BROWSE")
                     LOOP
                  ELSEIF LIN = LIN_MENU
                     COLUNA_MEN := 14
                     FOR CONTAR := 1 TO LEN( ME_NU )
                        IF COL >= COLUNA_MEN .AND.;
                           COL <= COLUNA_MEN + LEN( ME_NU[ CONTAR ] ) + 1
                           ES_COLHA := CONTAR
                           TECLA := T_ENTER
                           EXIT
                        ENDIF
                        COLUNA_MEN += LEN( ME_NU[ CONTAR ] ) + 3
                     NEXT
                     IF CONTAR > LEN( ME_NU ); LOOP; ENDIF
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
            IF TECLA = T_ESC
               ES_COLHA := 0
               EXIT
            ENDIF
         ENDDO
         //
         // -> Atualiza matriz quem contem a ultima a‡„o
         IF ES_COLHA != 0
            UL_TIMO[ 1 ] := ES_COLHA
         ENDIF
         //
         // -> Retorna ao BROWSE
         IF ES_COLHA = LEN( ME_NU ) .OR. ES_COLHA = 0
            L_SOM := L_CON; C_SOM := C_CON
            COR( "MENU" )
            MOUSE( DESLIGA )
            RESTORE SCREEN FROM TE_LA
            MOUSE( LIGA )
            EXIT
         ENDIF
         //
         // -> Volta um registro
         IF ES_COLHA = 2 + AL_TERA
            RE_FAZ := .T.
            SKIP -1
            IF BOF()
               BEEP()
            ENDIF
            LOOP
         ENDIF
         //
         // -> Avan‡a um registro
         IF ES_COLHA = 3 + AL_TERA
            RE_FAZ := .T.
            SKIP 1
            IF EOF()
               BEEP()
               SKIP -1
            ENDIF
            LOOP
         ENDIF
         M->TIPO_ACAO := SUBS( "AE", ES_COLHA + IIF( AL_TERA = 0, 1, 0 ), 1 )
         IF M->TIPO_ACAO = ALTERACAO
            IF !REGLOCK( 5 )
               BEEP()
               MENSAGEM( "Registro bloqueado, tente novamente", 3 )
               MOUSE( DESLIGA )
               RESTORE SCREEN FROM TE_LA
               MOUSE( LIGA )
               RETURN 1
            ENDIF
            //
            // -> Edita a tela de cadastro indicada
            OK_GETS := EVAL( ROTI_NAS[ 2 ], ALTERACAO )
            IF OK_GETS
               IF PERG( "Confirma altera‡”es ?" ) = "S"
                  //
                  // -> Retira dados para atualizacao
                  FOR CONTAR = 1 TO LEN( GRA_VAR )
                     EVAL( GRA_VAR[ CONTAR ][ 1 ] )
                  NEXT
                  //
                  // -> Atualiza o banco de dados
                  EVAL( ROTI_NAS[ 3 ] )
                  COMMIT
                  UNLOCK
                  COR( "MENU" )
                  MOUSE( DESLIGA )
                  RESTORE SCREEN FROM TE_LA
                  MOUSE( LIGA )
                  L_SOM := L_CON; C_SOM := C_CON
                  RE_FAZ := .T.
               ELSE
                  UNLOCK
                  LOOP
               ENDIF
            ELSE
               UNLOCK
               COR( "MENU" )
               MOUSE( DESLIGA )
               RESTORE SCREEN FROM TE_LA
               MOUSE( LIGA )
               L_SOM := L_CON; C_SOM := C_CON
            ENDIF
         ELSEIF M->TIPO_ACAO = EXCLUSAO
            //
            // -> Mostra registro detalhadamente
            EVAL( ROTI_NAS[ 2 ], EXCLUSAO )
            L_SOM := L_CON; C_SOM := C_CON
            CLEAR GETS
            IF !DELETED()
               //
               // -> Marca registro para exclusao
               IF !REGLOCK(5)
                  BEEP()
                  MENSAGEM( "Dele‡„o mal sucedida", 3 )
                  MOUSE( DESLIGA )
                  RESTORE SCREEN FROM TE_LA
                  MOUSE( LIGA )
                  EXIT
               ENDIF
               FOR CONTAR = 1 TO LEN( GRA_VAR )
                  IF EVAL( GRA_VAR[ CONTAR ][ 1 ] ) = .F.
                     UNLOCK
                     MOUSE( DESLIGA )
                     RESTORE SCREEN FROM TE_LA
                     MOUSE( LIGA )
                     RETURN 1
                  ENDIF
               NEXT
               DELE
            ELSE
               //
               // -> Recupera registro marcado para exclusao
               IF !REGLOCK( 5 )
                  BEEP()
                  MENSAGEM( "Recupera‡„o mal sucedida", 3 )
                  MOUSE( DESLIGA )
                  RESTORE SCREEN FROM TE_LA
                  MOUSE( LIGA )
                  EXIT
               ENDIF
               FOR CONTAR = 1 TO LEN( GRA_VAR )
                  IF EVAL( GRA_VAR[ CONTAR ][ 2 ] ) = .F.
                     UNLOCK
                     MOUSE( DESLIGA )
                     RESTORE SCREEN FROM TE_LA
                     MOUSE( LIGA )
                     RETURN 1
                  ENDIF
               NEXT
               RECALL
            ENDIF
            UNLOCK
            COR( "MENU" )
            MOUSE( DESLIGA )
            RESTORE SCREEN FROM TE_LA
            MOUSE( LIGA )
            RE_FAZ = .T.
         ENDIF
         EXIT
      ENDDO
      //
      // -> Forca a reorganizacao do BROWSE
      IF RE_FAZ
         OBJETO:REFRESHALL()
      ENDIF
   ENDIF
ENDDO
 
/* Final do programa AGENDCON.PRG */