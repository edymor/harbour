
/*
TITULO     : Agenda de Telefone
DATA       : 13/02/25
PROGRAMA   : AGEND.PRG
COMENTARIO : MENU PRINCIPAL
*/
 
#include "AGEND.CH"
#include "AGENDMOU.CH"
**
**BI [INI] MENU.B01
**BI [FIM] MENU.B01
**
//
// -> Matriz utilizada pelo objeto menu
ObjMenu := menu:LIMPA()
//
// -> Matriz utilizada pelo objeto botao
ObjBotao := botao:LIMPA()
//
// -> Matriz utilizada pelo objeto relatorio
ObjRelatorio := relatorio:LIMPA()
//
// -> Matriz utilizada pelo mouse
DADOS_MOUSE := {}
//
// -> Variaveis para senha de acesso
SENHAS_MENU := .F.
ALTERA_NIVEL := .F.
ACESSO_MENUS := { {}, {}, {}, {}, {}, {}, {} }
ULT_ACESSO := {}
REG_SENHA := 1  // Num. registro para alteracao de senha
M->SENHA_ENTRADA := SPACE( 9 )
M->REG_ENTRADA := 0
M->CODSENHA := SPACE( 9 )
M->USUARIO := SPACE( 20 )
//
// ->            Arq. NTX, Arq. DBF, Chave, Area, Ordem
IN_DICES := {}
AADD( IN_DICES, { "AGEND001.NTX", "AGENDA", "CELULAR", 1, 1 } )
AADD( IN_DICES, { "AGEND002.NTX", "AGENDA", "CPF", 1, 2 } )
AADD( IN_DICES, { "AGEND003.NTX", "AGENDA", "NOMECONTAT", 1, 3 } )
AADD( IN_DICES, { "AGEND004.NTX", "AGENDA", "SEQ_CODIGO", 1, 4 } )
AADD( IN_DICES, { "AGEND.RNX", "AGEND.RED", "DADOS", 100, 1 } )
**
**BI [INI] FUN.B02
**BI [FIM] FUN.B02
**
//
AMBIENTE()
//
// -> Posicao do ultimo menu
POS_ULT_MENU := 0
//
// -> Variavel de controle do papel de parede
FUNDO := 1
//
// -> Controle de cores
NOMECOR := { "FUNDO DA TELA",;
             "MENU",;
             "DESTAQUE DO MENU",;
             "JANELA DE DIALOGO",;
             "BOX DA JANELA DE DIALOGO",;
             "BOTOES",;
             "BOTAO EM DESTAQUE",;
             "GETS",;
             "GET EM DESTAQUE",;
             "TELA DE APRESENTACAO",;
             "CARACTERES AVULSOS",;
             "CERCADURAS",;
             "TITULO" }
CONTECOR := {}
M->AL_TERAR := .F.
//
// -> Ativa o calendario na tecla F3
SETKEY( T_F3, { || CALEN() } )
//
// -> Ativa a calculadora na tecla F4
SETKEY( T_F4, { || CALCU() } )
MOV_LINHA := 5; MOV_COLUNA := 9
//
// -> Ativa saida ao DOS na tecla F5
SETKEY( T_F5, { || SHELLDOS() } )
//
// -> Ativa configuracao na tecla F6
SETKEY( T_F6, { || SET_CONF() } )
CNF_REP := .F.; CNF_CON := .F.; CNF_DEL := "  "
//
// -> Ativa caracteres acentuados nas teclas de funcoes
SETKEY( T_F7, { || HELP_TEC() } )
VAR_TEC := "Ž„ …†ƒ€‡‚ˆ‰Š¡‹Œ“¢™”•£š–¦§"
FOR CONTAR = 1 TO LEN( VAR_TEC )
   SET FUNCTION CONTAR + 11 TO SUBS( VAR_TEC, CONTAR, 1 )
NEXT
M->DRI_VE := "A"
CON_ARQ := "EPSON_FX.IMP"
TIPO_FORMULARIO := "0"
DECLARE FOR_MULARIO[ 99 ]
AFILL( FOR_MULARIO, "0" )
IF FILE( "AGEND.CFG" )
   //
   // -> Restaurando configuracao
   VAR := MEMOREAD( "AGEND.CFG" )
   //
   // -> Cores
   FOR CONTAR = 1 TO 12
      AADD( CONTECOR, SUBS( VAR, ( CONTAR * 5 ) - 4, 5 ) )
   NEXT
   //
   // -> Posicao da Calculadora
   MOV_LINHA := VAL( SUBS( VAR, 61, 2 ) )
   MOV_COLUNA := VAL( SUBS( VAR, 63, 2 ) )
   //
   // -> Configuracao para Entrada de Dados (Tecla F6)
   CNF_REP := IIF( SUBS( VAR, 65, 1 ) = "F", .F., .T. )
   CNF_CON := IIF( SUBS( VAR, 66, 1 ) = "F", .F., .T. )
   CNF_DEL := SUBS( VAR, 67, 2 )
   //
   // -> Fundo da tela
   FUNDO := VAL( SUBS( VAR, 69, 2 ) )
   //
   // -> Unidade de saida do back-up
   M->DRI_VE := SUBS( VAR, 71, 1 )
   //
   // -> Cor do titulo
   AADD( CONTECOR, SUBS( VAR, 72, 5 ) )
   //
   // -> Dados de impressao
   IF LEN( TRIM( SUBS( VAR, 77, 12 ) ) ) > 0
      CON_ARQ := TRIM( SUBS( VAR, 77, 12 ) )
   ENDIF
   FOR CONTAR := 1 TO 99
      FOR_MULARIO[ CONTAR ] := SUBS( VAR, 88 + CONTAR, 1 )
   NEXT
ELSE
   PADRAO()
ENDIF
REDUCAO_ETQ := 1
IMPRESSORA := {}
IMP_ARQ := {}
NOME_IMP := ""
CONTADOR := ADIR( "*.IMP" )
IF CONTADOR != 0
   DECLARE ARQS_IMP[ CONTADOR ]
   ADIR( "*.IMP", ARQS_IMP )
   FOR CONTADOR := 1 TO LEN( ARQS_IMP )
      VAR := TRIM( MEMOLINE( MEMOREAD( ARQS_IMP[ CONTADOR ] ), 80, 1 ) )
      AADD( IMP_ARQ, { VAR, ARQS_IMP[ CONTADOR ] } )
   NEXT
ENDIF
LER_IMP( CON_ARQ )
TITU_LO := "Agenda de Telefone"
**
**BI [INI] MENU.B08
**BI [FIM] MENU.B08
**
LIN_MENU := 1
COR( "TITULO" )
@ 00, 00
@ 00, ( 80 - LEN( TITU_LO ) ) / 2 SAY TITU_LO
COR( "MENU" )
@ LIN_MENU, 00
@ 24, 00
@ 24, 01 SAY DATE()
@ 24, 10 SAY "³"
@ 24, 69 SAY "³"
@ 24, 71 SAY "F1-Ajuda"
FUNDO()
PUBL MENU_POS
MENU_P := 1; X := 1
M->SOS_MENU := " "
***
*** Inicio do bloco de substitui‡„o MENUPRI1.B
BUFFER := CHR( T_ENTER )
MENU_PRI := { "Cadastros",;
              "Manuten‡”es",;
              "Relat¢rios",;
              "Utilit rios",;
              "Saida" }
COL_MENU := 2
COR( "MENU" )
MENU_POS := {}
AEVAL( MENU_PRI, { | MATRIZ | AADD( MENU_POS, COL_MENU),;
       SETPOS( LIN_MENU, COL_MENU ), QQOUT( " " + MATRIZ + " " ),;
       COL_MENU += LEN( MATRIZ ) + 2 } )
*** Final do bloco de substitui‡„o MENUPRI1.B
***
MOUSE( DESLIGA )
TELA_PRI := SAVESCREEN( LIN_MENU + 1, 00, 23, 79 )
MOUSE( LIGA )
//
// - > Grava a ultima sombra
C_SOM := ""; L_SOM := ""
***
*** Inicio do bloco de substitui‡„o ACESSO.B
//
// -> Rotina de senha para acesso
TENTATIVA := 1
OK_SENHA := .F.
WHILE !OK_SENHA .AND. TENTATIVA < 4
   OK_SENHA := SENHA()
   IF !OK_SENHA .AND. TENTATIVA < 3
      BEEP()
      MENSAGEM( "Senha n„o confere, tente novamente", 2 )
   ENDIF
   TENTATIVA++
ENDDO
MOUSE( DESLIGA )
RESTSCREEN( LIN_MENU + 1, 00, 23, 79, TELA_PRI )
MOUSE( LIGA )
IF !OK_SENHA
   SET CURSOR OFF
   BEEP()
   MENSAGEM( "Acesso n„o permitido", 3 )
   SET CURSOR ON
   SETCOLOR( "W" )
   CLEAR
   QUIT
ENDIF
*** Final do bloco de substitui‡„o ACESSO.B
***
//
// Desativa acesso exclusivo permitindo acesso multiusuario
SET EXCLUSIVE OFF
M->DAT_HOJE := DATE()
***
*** Inicio do bloco de substitui‡„o AT_DATA.B
//
// -> Rotina de atualiza‡„o de data
MENSAGEM( "Digite a data" )
JANELA( 06, 17, 18, 61, "Atualiza‡„o de data" )
botao:ADD( 15, 34, "Enter   " )
botao:MOSTRA()
COR( "MENU" )
@ 09, 22 CLEAR TO 13, 56
M->SEM_ANA := "DomingoSegundaTerca  Quarta Quinta Sexta  S bado "
M->DIA_EXT := TRIM( SUBS( M->SEM_ANA, DOW( M->DAT_HOJE ) * 7 - 6 , 7 ) ) +;
              ", " + ALLTRIM( STR (DAY( M->DAT_HOJE ), 2 ) )
M->ME_SES := "Janeiro  FevereiroMar‡o    Abril    Maio     Junho    " +;
             "Julho    Agosto   Setembro Outubro  Novembro Dezembro "
M->DIA_EXT += " de " + TRIM( SUBS( ME_SES, MONTH( DAT_HOJE ) * 9 - 8 , 9 ) ) +;
              " de " + TRAN( YEAR( M->DAT_HOJE ), "@E 9,999" ) + "."
@ 12, 22 SAY SPACE( 35 )
@ 12, ( 80 - LEN( M->DIA_EXT ) ) / 2 SAY M->DIA_EXT
@ 10, 29 SAY "Data de hoje " GET M->DAT_HOJE
CURSOR( LIGA )
AADD( DADOS_MOUSE, { 15, 34, 43, T_ENTER } )
READ
DADOS_MOUSE := {}
CURSOR( DESLIGA )
IF LASTKEY() = T_ENTER
   botao:MOVIMENTA( 15, 34, "Enter   " )
ENDIF
MOUSE( DESLIGA )
RESTSCREEN( LIN_MENU + 1, 00, 23, 79, TELA_PRI )
MOUSE( LIGA )
COR( "MENU" )
@ 24, 01 SAY M->DAT_HOJE
*** Final do bloco de substitui‡„o AT_DATA.B
***
MENSAGEM( "Aguarde acesso aos arquivos" )
//
// -> Funcao que cria DBF'S inexistentes
CRIARQ()
//
// -> Funcao que cria indices inexistentes
INDICES()
M->EX_T := 0
M->OPC_ACHO := 0
**
**BI [INI] MENU.B02
**BI [FIM] MENU.B02
**
WHILE .T.
   **
   **BI [INI] MENU.B03
   **BI [FIM] MENU.B03
   **
   ***
   *** Inicio do bloco de substitui‡„o MENUPRI2.B
   COR( "MENU" ); @ LIN_MENU, 00
   MOUSE( DESLIGA )
   FOR F_MENU = 1 TO LEN( MENU_PRI )
      @ LIN_MENU, MENU_POS[ F_MENU ] PROMPT " " + MENU_PRI[ F_MENU ] + " "
   NEXT
   KEYBOARD BUFFER
   MENU TO MENU_P
   MOUSE( LIGA )
   BUFFER := CHR( T_ENTER )
   *** Final do bloco de substitui‡„o MENUPRI2.B
   ***
   **
   **BI [INI] MENU.B04
   **BI [FIM] MENU.B04
   **
   IF MENU_P = 1
      AGENDINC()
   ELSEIF MENU_P = 2
      AGENDCON()
   ELSEIF MENU_P = 3
      AGENDREL()
   ELSEIF MENU_P = 4
      MENSAGEM( "Tecle <ESC> para sair" )
      menu:ADD( "~Reorganizar", INDICES( .T. ) )
      menu:ADD( "~Exclus„o fisica", EXCLUIR() )
      menu:ADD( "-" )
      menu:ADD( ">~Papel de parede", FUNDO( 1 ) )
      menu:ADD( ">~Configura‡„o de cores", CONFCOR() )
      menu:ADD( "C~onfigura‡„o padr„o", CONFPADRAO() )
      menu:ADD( "-" )
      menu:ADD( "Co~nfigura‡„o de back-up", CONFBACKUP() )
      menu:ADD( "~Back-up", RODABACKUP() )
      menu:ADD( "Res~taura", RESTBACKUP() ) 
      menu:ADD( "-" )
      menu:ADD( ">~Senhas", EDITA_SENHA() )
      menu:ADD( "~Gerador de relatorios", GERA_REL() )
      **
      **BI [INI] MENU.B05
      **BI [FIM] MENU.B05
      **
      menu:RODA()
   ELSEIF MENU_P = 5
      menu:ADD( "~Fim de execu‡„o" )
      IF menu:RODA() = 1
         IF PERGUNTA( "Confirma o encerramento ?" ) = "S"
            EXIT
         ENDIF
      ENDIF
   ENDIF
ENDDO
MOUSE( DESLIGA )
//
// -> Salvando configuracao
VAR := ""
//
// -> Cores
FOR CONTAR = 1 TO 12
   VAR += CONTECOR[ CONTAR ]
NEXT
//
// -> Posicao da Calculadora
VAR += STR( MOV_LINHA, 2 ) + STR( MOV_COLUNA, 2 )
//
// -> Configuracao para Entrada de dados (Tecla F6)
VAR += IIF( CNF_REP, "T", "F" ) + IIF( CNF_CON, "T", "F" ) + CNF_DEL
//
// -> Fundo da tela
VAR += STR( FUNDO, 2 )
//
// -> Unidade de saida do back-up
VAR += M->DRI_VE
//
// -> Cor do titulo
VAR += CONTECOR[ 13 ]
//
// -> Dados de impressao
VAR += PADR( CON_ARQ, 12 )
FOR CONTAR := 1 TO 99
   VAR += FOR_MULARIO[ CONTAR ]
NEXT
//
// -> Gravando configuracao
MEMOWRIT( "AGEND.CFG", VAR )
SETCOLOR( "W" )
CLS
**
**BI [INI] MENU.B06
**BI [FIM] MENU.B06
**

FUNCTION EDITA_DADOS( DADOS, TEXTO )
LOCAL COL_ESQUERDA, COL_DIREITA, LARGURA := 24, CONTAR, ULT_COR := SETCOLOR(),;
      ULT_CURSOR := SETCURSOR(), ULT_TELA := SAVESCREEN( 00, 00, 24, 79 ),;
      LIN_SUPERIOR, LIN_INFERIOR, ALTURA
FOR CONTAR := 1 TO LEN( DADOS )
   IF LEN( DADOS[ CONTAR ] ) > LARGURA
      LARGURA := LEN( DADOS[ CONTAR ] )
   ENDIF
NEXT
LARGURA += 10
IF LARGURA < LEN( TEXTO ) + 4
   LARGURA := LEN( TEXTO ) + 4
ENDIF
COL_ESQUERDA := INT( ( 80 - LARGURA ) / 2 )
COL_DIREITA := LARGURA + COL_ESQUERDA - 1
ALTURA := LEN( DADOS )
IF ALTURA > 7
   ALTURA := 7
ENDIF
ALTURA += 8
LIN_SUPERIOR := INT( ( 25 - ALTURA ) / 2 )
LIN_INFERIOR := ALTURA + LIN_SUPERIOR - 1
JANELA( LIN_SUPERIOR, COL_ESQUERDA, LIN_INFERIOR, COL_DIREITA, TEXTO )
botao:ADD( LIN_INFERIOR - 2, 27, "Enter   " )
botao:ADD( LIN_INFERIOR - 2, 43, "Esc     " )
botao:MOSTRA()
COR( "MENU" )
@ LIN_SUPERIOR + 2, COL_ESQUERDA + 4 CLEAR TO LIN_INFERIOR - 4, COL_DIREITA - 4
KEYBOARD CHR( T_CIMA )
CURSOR( DESLIGA )
CONTAR := ACHOICE( LIN_SUPERIOR + 3, COL_ESQUERDA + 5, LIN_INFERIOR - 5,;
                   COL_DIREITA - 5, DADOS )
SETCOLOR( ULT_COR )
SETCURSOR( ULT_CURSOR )
IF CONTAR = 0
   botao:MOVIMENTA( LIN_INFERIOR - 2, 43, "Esc     " )
   RESTSCREEN( 00, 00, 24, 79, ULT_TELA )
   RETURN 0
ENDIF
botao:MOVIMENTA( LIN_INFERIOR - 2, 27, "Enter   " )
RESTSCREEN( 00, 00, 24, 79, ULT_TELA )
RETURN CONTAR

FUNCTION ACAO_MOUSE
LOCAL RETORNE := 0, DADO_CUR, BO_TAO, LIN, COL, CONTAR
MOUSE( @BO_TAO, @LIN, @COL )
//
// -> Verifica se os botoes do mouse foram pressionados para ativar
//    a acao equivalente a posicao do cursor do mouse
IF BO_TAO = M_OS_DOIS
   RETORNE := T_ESC
ELSEIF BO_TAO = M_DIREITO
   RETORNE := T_ENTER
ELSEIF BO_TAO = M_ESQUERDO
   DADO_CUR := SUBS( SAVESCREEN( LIN, COL, LIN, COL ), 1, 1 )
   IF DADO_CUR = CHR( 254 )
      RETORNE := T_ESC
   ELSEIF LIN = 24 .AND. ( COL >= 71 .AND. COL <= 78 )
      RETORNE := T_F1
   ELSE
      FOR CONTAR := 1 TO LEN( DADOS_MOUSE )
         IF DADOS_MOUSE[ CONTAR ][ 1 ] = LIN .AND.;
            ( COL >= DADOS_MOUSE[ CONTAR ][ 2 ] .AND.;
            COL <= DADOS_MOUSE[ CONTAR ][ 3 ] )
            RETORNE := DADOS_MOUSE[ CONTAR ][ 4 ]
            EXIT
         ENDIF
      NEXT
   ENDIF
ENDIF
IF BO_TAO != 0 .AND. RETORNE = 0
   BEEP_MOUSE()
ENDIF
RETURN RETORNE

FUNCTION REDE_CONTROLE
SELE 100
IF USEREDE( "AGEND.RED", .T., 2 )
   ZAP
   INDEX ON DADOS TO AGEND.RNX
   USE
ENDIF
IF !USEREDE( "AGEND.RED", .F., 10 )
   RETURN .F.
ELSE
   SET INDEX TO AGEND.RNX
ENDIF
RETURN .T.
 
FUNCTION LER_IMP( ARQUIVO )
IF FILE( ARQUIVO  )
   DADOS := MEMOREAD( ARQUIVO )
ELSE
   RETURN .F.
ENDIF
IMPRESSORA := {}
TAMANHO := MLCOUNT( DADOS, 70 )
NOME_IMP := ALLTRIM( MEMOLINE( DADOS, 80, 1 ) )
FOR CONTAR := 2 TO TAMANHO
   DADO_IMP := {}
   VAR := MEMOLINE( DADOS, 70, CONTAR )
   POSICAO := AT( "[", VAR )
   LARGURA := { VAL( SUBS( VAR, 1, 3 ) ), VAL( SUBS( VAR, 5, 3 ) ) }
   VAR := SUBS( VAR, POSICAO + 1 )
   VAR := SUBS( VAR, 1, LEN( VAR ) - 1 )
   WHILE AT( ",", VAR ) != 0
      POSICAO := AT( ",", VAR )
      AADD( DADO_IMP, VAL( ALLTRIM( SUBS( VAR, 1, POSICAO - 1 ) ) ) )
      VAR := SUBS( VAR, POSICAO + 1 )
   ENDDO
   AADD( DADO_IMP, VAL( ALLTRIM( VAR ) ) )
   AADD( IMPRESSORA, { LARGURA, DADO_IMP } )
NEXT
RETURN .T.
 
FUNCTION EXCLUIR
IF PERGUNTA( "Confirma a exclus„o fisica dos registros ?", "N" ) = "N"
   RETURN .F.
ELSE
   CLOSE DATABASES
   AQ_PACK := { "AGENDA" }
   AEVAL( AQ_PACK, { | MATRIZ | FUN_PACK( MATRIZ ) } )
   INDICES( .T., .T. )
ENDIF
RETURN NIL
 
FUNCTION FUN_PACK( AQ_DBF )
MENSAGEM( "Compactando o arquivo " + AQ_DBF )
IF USEREDE( AQ_DBF, .T., 10 )
   PACK
   USE
ELSE
   BEEP()
   MENSAGEM( "O arquivo " + AQ_DBF + " n„o esta dispon¡vel", 3 )
ENDIF
RETURN NIL
 
FUNCTION EDITA_SENHA
M_SENHA()
MOUSE( DESLIGA )
RESTSCREEN( LIN_MENU + 1, 00, 23, 79, TELA_PRI )
MOUSE( LIGA )
RETURN NIL
 
FUNCTION CONFBACKUP
JANELA( 06, 21, 17, 59, "Configura‡„o de back-up" )
COR( "MENU" )
@ LIN_MENU, 00
@ LIN_MENU, 01 SAY "Utilit rios ³ Configura‡„o de back-up"
@ 09, 26 CLEAR TO 12, 54
botao:ADD( 14, 35, "Enter   " )
botao:MOSTRA()
MENU_CFG := { "     ("+CHR(7)+") Unidade A:",;
              "     ("+CHR(7)+") Unidade B:" }
SETCOLOR( CONTECOR[ 2 ] + "," + CONTECOR[ 7 ] )
KEYBOARD CHR( 32 )
M->TEC_CONF := IIF( M->DRI_VE = "A", 1, 2 )
M->TEC_CONF := ACHOICE( 10, 28, 11, 52, MENU_CFG, .T., "FUN_CFG",;
               M->TEC_CONF )
IF M->TEC_CONF != 0
   botao:MOVIMENTA( 14, 35, "Enter" )
   M->DRI_VE := IIF( M->TEC_CONF = 1, "A", "B" )
ENDIF
MOUSE( DESLIGA )
RESTSCREEN( LIN_MENU + 1, 00, 23, 79, TELA_PRI )
MOUSE( LIGA )
RETURN NIL
 
FUNCTION RODABACKUP
NOMARQ := { "AGENDA.DBF",;
            "AGENDA.DBT" }
BACKUP( "AGEND" )
RETURN NIL
 
FUNCTION RESTBACKUP
RESTAURA( "AGEND" )
MENSAGEM( "Aguarde organiza‡„o dos arquivos" )
INDICES( .T. )
RETURN NIL
 
FUNCTION CONFPADRAO
IF PERGUNTA( "Ativar configura‡„o padr„o de cores ?" ) = "S"
   PADRAO()
   FUNDO()
   COR( "TITULO" )
   @ 00, 00
   @ 00, ( 80 - LEN( TITU_LO ) ) / 2 SAY TITU_LO
   COR( "MENU" )
   @ LIN_MENU, 00
   FOR F_MENU = 1 TO LEN( MENU_PRI )
      @ LIN_MENU, MENU_POS[ F_MENU ] + 1 SAY MENU_PRI[ F_MENU ]
   NEXT
   @ 24, 00
   @ 24, 01 SAY "F1-Ajuda ³"
   @ 24, 69 SAY "³"
   @ 24, 71 SAY M->DAT_HOJE
   MOUSE( DESLIGA )
   TELA_PRI := SAVESCREEN( LIN_MENU + 1, 00, 23, 79 )
   MOUSE( LIGA )
ENDIF
RETURN NIL
 
FUNCTION JANELA( PJAN1, PJAN2, PJAN3, PJAN4, PJAN5 )
IF PCOUNT() != 5
   PJAN5 := ""
ENDIF
SOMBRA( PJAN1, PJAN2, PJAN3, PJAN4 )
SETCOLOR( CONTECOR[ 4 ] )
@ PJAN1, PJAN2 CLEAR TO PJAN3, PJAN4
SETCOLOR( CONTECOR[ 5 ] )
@ PJAN1, PJAN2, PJAN3, PJAN4 BOX " "
@ PJAN1, PJAN2 SAY "þ"
IF LEN( TRIM( PJAN5 ) ) > 0
   @ PJAN1, PJAN2 + ( ( ( PJAN4 + 1 - PJAN2 ) - LEN( PJAN5 ) ) / 2 ) SAY PJAN5
ENDIF
 
FUNCTION AMBIENTE
SET DATE BRIT
SET BELL OFF
SET SCORE OFF
SET WRAP ON
CURSOR( DESLIGA )
SET DELETED ON
SETKEY( T_INSERT, { || INS_CUR() } )
//
// -> Inicializa mouse
MOUSE()
//
// -> Liga cursor do mouse
MOUSE( LIGA )
**
**BI [INI] MENU.B07
**BI [FIM] MENU.B07
**
RETURN .F.

FUNCTION INS_CUR
//
// -> Funcao de manipulacao do cursor ( NORMAL / INSERCAO )
IF SETCURSOR() != 0
   READINSERT( !READINSERT() )
   CURSOR( LIGA )
ENDIF

FUNCTION PADRAO
CONTECOR := { "09/01",;
              "00/07",;
              "15/04",;
              "07/01",;
              "00/03",;
              "01/07",;
              "15/07",;
              "00/07",;
              "15/04",;
              "15/01",;
              "07/01",;
              "07/01",;
              "00/03" }
RETURN .T.

FUNCTION M_SENHA
M->SEN_OPC := 0
MENSAGEM( "Tecle <ESC> para retornar" )
menu:TIPO := SUB_MENU
menu:ADD( "~Credenciar novo operador" )
menu:ADD(  "~Descredenciar operador" )
menu:ADD(  "~Mudan‡a de n¡vel de acesso" )
menu:ADD(  "~Listagem de operadores" )
menu:ADD(  "M~udan‡a de senhas" )
M->SEN_OPC := menu:RODA()
IF M->SEN_OPC = 0
   RETURN .F.
ENDIF
BUFFER := CHR(13) + "S"
COR( "MENU" )
@ LIN_MENU, 00
@ LIN_MENU, 01 SAY "Utilit rios ³ Senhas"
IF M->SEN_OPC = 1
   JANELA( 07, 13, 17, 66, "Credenciamento de operadores" )
   COR( "MENU" )
   @ 10, 18 CLEAR TO 14, 61
   @ 11, 20 SAY "Operador ....... :"
   @ 13, 20 SAY "Senha .......... :"
   M->USUARIO := SPACE( 20 )
   M->ACESSO := "1"
   @ 11, 40 GET M->USUARIO PICT "@!" VALID;
            !PESENHA( "U", M->USUARIO, .T., "Operador j  cadastrado") .AND.;
            !EMPTY( M->USUARIO )
   SET CURSOR ON
   READ
   SET CURSOR OFF
   IF LASTKEY() = 27; RETURN .F.; ENDIF
   MENSAGEM( "Digite a senha de acesso" )
   M->CODSENHA := GET_COD( 13, 40 )
   IF M->CODSENHA = CHR(27); RETURN .F.; ENDIF
   RESTSCREEN( LIN_MENU+1, 00, 23, 79, TELA_PRI )
   SENHAS_MENU := .T.
   MENU_P := 1
   JANELA( 09, 10, 16, 68 )
   COR( "JANELA DE DIALOGO" )
   @ 12, 17 SAY "Marque as opcoes que deseja bloquear o acesso"
   @ 13, 17 SAY "e depois tecle F10 para salvar."
   TELA_PRI := SAVESCREEN( LIN_MENU+1, 00, 23, 79 )
   ULT_ACESSO := ACESSO_MENUS
   ACESSO_MENUS := { {}, {}, {}, {}, {}, {}, {} }
   RETURN .F.
ELSEIF M->SEN_OPC = 2
   JANELA( 08, 14, 16, 64, "Descredenciamento de operadores" )
   COR( "MENU" )
   @ 11, 18 CLEAR TO 13, 60
   M->USUARIO := SPACE( 20 )
   @ 12, 20 SAY "Nome do operador :" GET M->USUARIO PICT "@!" VALID;
            PESENHA( "U", M->USUARIO, .F., "Operador n„o cadastrado" )
   SET CURSOR ON
   READ
   SET CURSOR OFF
   IF LASTKEY() = 27; RETURN .F.; ENDIF
   M->NOM_ARQ := "AGEND.SNH"
      IF !USEREDE( M->NOM_ARQ, .F., 10 )
         BEEP()
         MENSAGEM( "Acesso mal sucedido ao arquivo", 3 )
         RETURN .F.
      ENDIF
   GOTO TOP
   WHILE !EOF()
      IF USUARIO == M->USUARIO
         MENSAGEM( "Descredenciando o operador " + TRIM( M->USUARIO ) )
         IF !REGLOCK( 5 )
            BEEP()
            MENSAGEM( "Descredenciamento mal sucedido", 3 )
            MOUSE( DESLIGA )
            RESTORE SCREEN FROM TE_LA
            MOUSE( LIGA )
            RETURN .F.
         ENDIF
         DELETE
         UNLOCK
         EXIT
      ENDIF
      SKIP
   ENDDO
   USE
ELSEIF M->SEN_OPC = 3
   JANELA( 08, 14, 16, 66, "Mudan‡a do n¡vel de acesso" )
   COR( "MENU" )
   @ 11, 18 CLEAR TO 13, 61
   @ 12, 20 SAY "Operador ....... :"
   M->USUARIO := SPACE( 20 )
   @ 12,40 GET M->USUARIO PICT "@!" VALID;
           PESENHA( "U", M->USUARIO, .F., "Operador n„o cadastrado" )
   SET CURSOR ON
   READ
   SET CURSOR OFF
   IF LASTKEY() = 27; RETURN .F.; ENDIF
   M->NOM_ARQ := "AGEND.SNH"
      IF !USEREDE( M->NOM_ARQ, .F., 10 )
         BEEP()
         MENSAGEM( "Acesso mal sucedido ao arquivo", 3 )
         RETURN .F.
      ENDIF
   GOTO TOP
   WHILE !EOF()
      IF USUARIO == M->USUARIO
         RESTSCREEN( LIN_MENU+1, 00, 23, 79, TELA_PRI )
         SENHAS_MENU := .T.
         MENU_P := 1
         JANELA( 09, 10, 16, 68 )
         COR( "JANELA DE DIALOGO" )
         @ 12, 17 SAY "Marque as opcoes que deseja bloquear o acesso"
         @ 13, 17 SAY "e depois tecle F10 para salvar."
         TELA_PRI := SAVESCREEN( LIN_MENU+1, 00, 23, 79 )
         ULT_ACESSO := ACESSO_MENUS
         ACESSO_MENUS := { {}, {}, {}, {}, {}, {}, {} }
         FOR CONTADOR := 1 TO 6
            IF CONTADOR = 1
               M->VAR := ACESSO_INC
            ELSEIF CONTADOR = 2
               M->VAR := ACESSO_CON
            ELSEIF CONTADOR = 3
               M->VAR := ACESSO_ALT
            ELSEIF CONTADOR = 4
               M->VAR := ACESSO_EXC
            ELSEIF CONTADOR = 5
               M->VAR := ACESSO_REL
            ELSEIF CONTADOR = 6
               M->VAR := ACESSO_UTI
            ENDIF
            FOR CONTAR := 1 TO LEN( M->VAR ) STEP 3
               IF LEN( TRIM( SUBS( M->VAR, CONTAR, 3 ) ) ) > 0
                  AADD( ACESSO_MENUS[ CONTADOR ], SUBS( M->VAR, CONTAR, 3 ) )
               ENDIF
            NEXT
         NEXT
         ALTERA_NIVEL := .T.
         REG_SENHA := RECN()
         USE
         RETURN .F.
      ENDIF
      SKIP
   ENDDO
   USE
ELSEIF M->SEN_OPC = 4
   JANELA( 05, 23, 19, 56, "Listagem de operadores" )
   COR( "MENU" )
   @ 08, 27 CLEAR TO 16, 52
   @ 09, 27 TO 16, 52
   @ 08, 30 SAY " Operador "
   M->NOM_ARQ := "AGEND.SNH"
      IF !USEREDE( M->NOM_ARQ, .F., 10 )
         BEEP()
         MENSAGEM( "Acesso mal sucedido ao arquivo", 3 )
         RETURN .F.
      ENDIF
   GOTO TOP
   DECLARE EDI_TAR[1]
   EDI_TAR[1] := '" "+USUARIO+" "'
   KEYBOARD CHR(0)
   DBEDIT( 10, 29, 15, 50, EDI_TAR, "", "", "", "", "" )
ELSEIF M->SEN_OPC = 5
   JANELA( 07, 20, 17, 59, "Mudan‡a de senhas" )
   COR( "MENU" )
   @ 10, 24 CLEAR TO 14, 55
   @ 11, 28 SAY "Senha atual"
   @ 13, 28 SAY "Nova senha"
   M->TENTATIVA := 1
   WHILE M->TENTATIVA < 4
      MENSAGEM( "Digite a senha atual" )
      M->ATUSENHA := GET_COD( 11, 41 )
      IF M->ATUSENHA <> CHR(27)
         IF M->ATUSENHA != M->SENHA_ENTRADA
            IF M->TENTATIVA <> 3
               BEEP()
               MENSAGEM( "A senha atual n„o confere, tente novamente", 3 )
            ENDIF
         ELSE
            EXIT
         ENDIF
      ELSE
         EXIT
      ENDIF
      M->TENTATIVA++
   ENDDO
   IF M->TENTATIVA = 4
      BEEP()
      MENSAGEM( "A senha atual n„o confere", 3 )
      RETURN .F.
   ENDIF
   IF M->ATUSENHA = CHR(27); RETURN .F.; ENDIF
   MENSAGEM( "Digite a nova senha" )
   M->NOVSENHA := GET_COD( 13, 41 )
   IF M->NOVSENHA = CHR(27); RETURN .F.; ENDIF
   M->NOM_ARQ := "AGEND.SNH"
      IF !USEREDE( M->NOM_ARQ, .F., 10 )
         BEEP()
         MENSAGEM( "Acesso mal sucedido ao arquivo", 3 )
         RETURN .F.
      ENDIF
   GOTO M->REG_ENTRADA
   IF !REGLOCK( 20 )
      BEEP()
      MENSAGEM( "Troca de senha mal sucedida", 3 )
   ELSE
      REPLACE CODSENHA WITH M->NOVSENHA
      M->SENHA_ENTRADA := M->NOVSENHA
      MENSAGEM( "Troca de senha conclu¡da ", 3 )
   ENDIF
   USE
ENDIF
RETURN .T.

FUNCTION PERG( TEX_TO, RES_POSTA )
//
// -> Funcao que executa uma pergunta
LOCAL LI, SIM_NAO, CUR_PERG := SETCURSOR()
COR( "MENU" )
CURSOR( DESLIGA )
IF PCOUNT() = 1; RES_POSTA := "S"; ENDIF
SIM_NAO := IIF( RES_POSTA = "N", 2, 1 )
@ 24, 11 SAY SPACE( 58 )
LI := ( 80 - ( LEN( TEX_TO ) + 11 ) ) / 2
@ 24, LI SAY TEX_TO
LI += LEN( TEX_TO ) + 2
WHILE .T.
   @ 24, LI     PROMPT "Sim"
   @ 24, LI + 6 PROMPT "N„o"
   @ 24, LI + 4 SAY "-"
   MENU TO SIM_NAO
   IF SIM_NAO != 0
      EXIT
   ENDIF
ENDDO
SETCURSOR( CUR_PERG )
RETURN IIF( SIM_NAO = 1, "S", "N" )
 
FUNCTION BACKUP
PARA NOMEBAK
COR( "MENU" )
@ LIN_MENU, 00
@ LIN_MENU, 01 SAY "Utilit rios ³ Back-up"
ESP_ACO := 0; TOT_BYTE := 0; BAK_PONT := 0
L_SOM := ""; C_SOM := ""
NOMEBAK := DRI_VE + ":\" + NOMEBAK
ARQCRIA := CRIABAK( NOMEBAK + ".CTR" )
IF ARQCRIA = -1
   RETURN .F.
ENDIF
MENSAGEM( "Processando back-up" )
JANELA( 06, 08, 18, 71, "Back-up" )
COR( "MENU" )
@ 09, 12 CLEAR TO 15, 67
@ 10, 12 SAY "  0%       20%       40%       60%       80%       100% "
@ 11, 12 SAY "  ÃÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÁ¿  "
@ 12, 12 SAY "  ³                                                  ³  "
@ 13, 12 SAY "  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ  "
FOR NUMARQ = 1 TO LEN( NOMARQ )
   ARQLER := FOPEN( NOMARQ[ NUMARQ ] )
   FIMARQ := FSEEK( ARQLER, 0, 2 )
   BAK := SUBS( NOMARQ[ NUMARQ ] + SPACE( 15 ), 1, 15 )
   BAK += STR( FIMARQ, 10 ) + CHR( 13 ) + CHR( 10 )
   TOT_BYTE += FIMARQ
   FWRITE( ARQCRIA, BAK, 27 )
   FCLOSE( ARQLER )
NEXT
FCLOSE( ARQCRIA )
NUMDISCO := 1
ARQCRIA := CRIABAK( NOMEBAK, @NUMDISCO )
IF ARQCRIA = -1
   MOUSE( DESLIGA )
   RESTSCREEN( LIN_MENU + 1, 00, 23, 79, TELA_PRI )
   MOUSE( LIGA )
   RETURN .F.
ENDIF
FOR NUMARQ = 1 TO LEN( NOMARQ )
   ARQLER := FOPEN( NOMARQ[ NUMARQ ] )
   FIMARQ := FSEEK( ARQLER, 0, 2 )
   FOR PONTEIRO = 0 TO FIMARQ STEP 5000
      BAK := SPACE( 5000 )
      IF PONTEIRO + 5000 > FIMARQ
         BAK := SPACE( FIMARQ - PONTEIRO )
      ENDIF
      FSEEK( ARQLER, PONTEIRO )
      FREAD( ARQLER, @BAK, LEN( BAK ) )
      BAK_PONT += LEN( BAK )
      IF GRAVABAK( ARQCRIA, BAK ) = .F.
         MOUSE( DESLIGA )
         RESTSCREEN( LIN_MENU + 1, 00, 23, 79, TELA_PRI )
         MOUSE( LIGA )
         FCLOSE( ARQLER )
         RETURN .F.
      ENDIF
   NEXT
   FCLOSE( ARQLER )
NEXT
FCLOSE( ARQCRIA )
MOUSE( DESLIGA )
RESTSCREEN( LIN_MENU + 1, 00, 23, 79, TELA_PRI )
MOUSE( LIGA )

FUNCTION CRIABAK
PARA NOMECRIA, EXTCRIA
IF PCOUNT() = 1
   EXTCRIA := 0
ENDIF
IF EXTCRIA > 1
   FCLOSE( ARQCRIA )
ENDIF
IF EXTCRIA != 1
   IF JANMENS( "Insira o disco " + SUBS( STR( IIF( EXTCRIA = 0, 1, EXTCRIA ) +;
               1000, 4 ), 2 ) + " na unidade " + DRI_VE + ":" ) = 0
      RETURN -1
   ENDIF
ENDIF
IF EXTCRIA = 0
   ARQ_NOM := NOMECRIA
   ARQ_DEL := SUBS( NOMECRIA, 1, LEN( NOMECRIA ) - 3 ) + "001"
   IF FILE( ARQ_DEL )
      ERASE &ARQ_DEL
   ENDIF
ELSE
   ARQ_NOM := NOMECRIA + "." + SUBS( STR( EXTCRIA + 1000, 4 ), 2 )
ENDIF
WHILE .T.
   AR_Q := FCREATE( ARQ_NOM )
   IF FERROR() != 0
      FCLOSE( AR_Q )
      IF JANMENS( "Disquete inexistente ou n„o formatado." ) = 0
         RETURN -1
      ELSE
         LOOP
      ENDIF
   ENDIF
   ESP_ACO := DISKSPACE( IIF( DRI_VE = "A", 1, 2 ) )
   IF ESP_ACO < IIF( EXTCRIA = 0, 6000, 5000 )
      IF JANMENS( "Disco sem espa‡o dispon¡vel para gerar BACK-UP." ) = 0
         FCLOSE( M->AR_Q )
         RETURN -1
      ENDIF
   ELSE
      ESP_ACO -= 4000
      EXIT
   ENDIF
ENDDO
EXTCRIA++
RETURN AR_Q

FUNCTION JANMENS
PER_COR := SETCOLOR()
CURSOR( DESLIGA )
MOUSE( DESLIGA )
SAVE SCREEN TO PER_TELA
MOUSE( LIGA )
PARA TEX_TO
SOMBRA( L_JAN := L_SOM, C_JAN := C_SOM, .T. )
M->SIM_NAO := 1
M->LAR_G := LEN( M->TEX_TO )
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
BEEP()
botao:ADD( 13, 25, "Continua" )
botao:ADD( 13, 42, "Sair    " )
SIM_NAO := botao:RODA()
MOUSE( DESLIGA )
RESTORE SCREEN FROM PER_TELA
MOUSE( LIGA )
SETCOLOR( PER_COR )
SOMBRA( L_JAN, C_JAN )
RETURN IIF( SIM_NAO = 2, 0, SIM_NAO )

FUNCTION GRAVABAK
PARA P_ARQ, P_GRAV
IF ESP_ACO < LEN( P_GRAV ) + 10
   ARQCRIA := CRIABAK( NOMEBAK, @NUMDISCO )
   IF ARQCRIA = -1
      RETURN .F.
   ENDIF
ENDIF
FWRITE( P_ARQ, P_GRAV )
ESP_ACO -= LEN( P_GRAV )
COR( "MENU" )
PERCENT := ( BAK_PONT * 100 ) / TOT_BYTE
IF PERCENT > 0
   @ 12, 15 SAY REPL( CHR( 176 ), INT( ( PERCENT / 2) + .5 ) )
ENDIF
RETURN .T.
 
FUNCTION RESTAURA
PARA NOMEBAK
COR( "MENU" )
@ LIN_MENU, 00
@ LIN_MENU, 01 SAY "Utilit rios ³ Restaura‡„o"
FIM := 0
L_SOM := ""
C_SOM := ""
NOMEBAK := DRI_VE + ":\" + NOMEBAK
ARQLER := LERBAK( NOMEBAK + ".CTR" )
FCLOSE( ARQLER )
IF ARQLER = -1
   RETURN .F.
ENDIF
BAK := MEMOREAD( NOMEBAK + ".CTR" )
NUMLINHA=MLCOUNT(BAK,25)
NOMARQ := {}
TOT_BYTE := 0
FOR FLINHA = 1 TO NUMLINHA
   AADD( NOMARQ, MEMOLINE( BAK, 25, FLINHA ) )
   TOT_BYTE += VAL( SUBS( NOMARQ[ FLINHA ], 16 ) )
NEXT
NUMDISCO := 1
ARQLER := LERBAK( NOMEBAK, @NUMDISCO )
IF ARQLER = -1
   RETURN .F.
ENDIF
MENSAGEM( "Processando restaura‡„o" )
JANELA( 06, 08, 18, 71, "Restaura‡„o de back-up" )
COR( "MENU" )
@ 09, 12 CLEAR TO 15, 67
@ 10, 12 SAY "  0%       20%       40%       60%       80%       100% "
@ 11, 12 SAY "  ÃÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÁ¿  "
@ 12, 12 SAY "  ³                                                  ³  "
@ 13, 12 SAY "  ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ  "
PONTLER := 0; BAK_PONT := 0
FOR NUMARQ = 1 TO LEN( NOMARQ )
   NOMECRIA := TRIM( SUBS( NOMARQ[ NUMARQ ], 1, 15 ) )
   ARQCRIA := FCREATE( NOMECRIA )
   PONTBAK := 0
   FIMARQ := VAL( TRIM( SUBS( NOMARQ[ NUMARQ ], 16 ) ) )
   WHILE PONTBAK < FIMARQ
      IF PONTLER >= FIM
         ARQLER := LERBAK( NOMEBAK, @NUMDISCO )
         IF ARQLER = -1
            FCLOSE( ARQLER )
            MOUSE( DESLIGA )
            RESTSCREEN( LIN_MENU + 1, 00, 23, 79, TELA_PRI )
            MOUSE( LIGA )
            RETURN .F.
         ENDIF
         PONTLER := 0
      ENDIF
      FSEEK( ARQLER, PONTLER )
      BAK := SPACE( 5000 )
      IF PONTBAK + 5000 > FIMARQ
         BAK := SPACE( FIMARQ - PONTBAK )
      ENDIF
      IF PONTLER + LEN( BAK ) > FIM
         BAK := SPACE( FIM - PONTLER )
      ENDIF
      FREAD( ARQLER, @BAK, LEN( BAK ) )
      FWRITE( ARQCRIA, BAK, LEN( BAK ) )
      PONTLER += LEN( BAK ); PONTBAK += LEN( BAK ); BAK_PONT += LEN( BAK )
      PERCENT := ( BAK_PONT * 100 ) / TOT_BYTE
      IF PERCENT > 0
         @ 12, 15 SAY REPL( CHR( 176 ), INT( ( PERCENT / 2 ) + .5 ) )
      ENDIF
      IF PERCENT = 100
         EXIT
      ENDIF
   ENDDO
   FCLOSE( ARQCRIA )
NEXT
FCLOSE( ARQLER )
MOUSE( DESLIGA )
RESTSCREEN( LIN_MENU + 1, 00, 23, 79, TELA_PRI )
MOUSE( LIGA )

FUNCTION LERBAK
PARA NOMECRIA, EXTCRIA
IF PCOUNT() = 1
   EXTCRIA = 0
ENDIF
IF EXTCRIA > 1
   FCLOSE( ARQLER )
ENDIF
IF EXTCRIA != 1
   IF JANMENS( "Insira o disco " + SUBS( STR( IIF( EXTCRIA = 0, 1, EXTCRIA) +;
               1000, 4 ), 2 ) + " na unidade " + DRI_VE + ":" ) = 0
      RETURN -1
   ENDIF
ENDIF
IF EXTCRIA = 0
   ARQ_NOM := NOMECRIA
ELSE
   ARQ_NOM := NOMECRIA + "." + SUBS( STR( EXTCRIA + 1000, 4 ), 2 )
ENDIF
WHILE .T.
   AR_Q := FOPEN( ARQ_NOM )
   IF FERROR() != 0
      FCLOSE( AR_Q )
      IF JANMENS( "Disquete incorreto, inexistente ou n„o formatado." ) = 0
         RETURN -1
      ELSE
         LOOP
      ENDIF
   ELSE
      EXIT
   ENDIF
ENDDO
FIM := FSEEK( AR_Q, 0, 2 )
EXTCRIA++
RETURN AR_Q
 
/* Final do programa AGEND.PRG */