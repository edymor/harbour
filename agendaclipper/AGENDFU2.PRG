
/*
TITULO     : Agenda de Telefone
DATA       : 13/02/25
PROGRAMA   : AGENDFU2.PRG
COMENTARIO : FUNCOES - PARTE 2
*/

#include "AGEND.CH"
#include "AGENDMOU.CH"
**
**BI [INI] FUN.B04
**BI [FIM] FUN.B04
**

FUNCTION SOMBRA( LIN_SUP, COL_SUP, LIN_INF, COL_INF )
MOUSE( DESLIGA )
IF PCOUNT() = 2 .OR. PCOUNT() = 3
   C_SOM := COL_SUP; L_SOM := LIN_SUP
   LIN_SUP := VAL( SUBS( C_SOM, 1, 2 ) )
   COL_SUP := VAL( SUBS( C_SOM, 3, 2 ) )
   LIN_INF := VAL( SUBS( C_SOM, 5, 2 ) )
   COL_INF := VAL( SUBS( C_SOM, 7, 2 ) )
   COL_SOM := SUBS( C_SOM, 9 )
   LIN_SOM := L_SOM
ENDIF
IF COL_SUP < 2 .OR. LIN_INF > 22
   C_SOM := ""; L_SOM := ""
   MOUSE( LIGA )
   RETURN .F.
ENDIF
IF PCOUNT() = 3
   RESTSCREEN( LIN_SUP + 1, COL_SUP - 2, LIN_INF + 1, COL_SUP - 1, COL_SOM )
   RESTSCREEN( LIN_INF + 1, COL_SUP - 2, LIN_INF + 2, COL_INF - 2, LIN_SOM )
   MOUSE( LIGA )
   RETURN .F.
ENDIF
IF PCOUNT() != 2
   COL_SOM := SAVESCREEN( LIN_SUP + 1, COL_SUP - 2, LIN_INF + 1, COL_SUP - 1 )
   LIN_SOM := SAVESCREEN( LIN_INF + 1, COL_SUP - 2, LIN_INF + 2, COL_INF - 2 )
ENDIF
IF SUBS( COL_SOM, 2, 1 ) != CHR( 8 )
   C_SOM := STR( LIN_SUP, 2 ) + STR( COL_SUP, 2 ) + STR( LIN_INF, 2 ) +;
            STR( COL_INF, 2 ) + COL_SOM
   L_SOM := LIN_SOM
ENDIF
FOR I = 2 TO LEN( COL_SOM ) STEP 2
   COL_SOM := STUFF( COL_SOM, I, 1, CHR( 8 ) )
NEXT
FOR I = 2 TO LEN( LIN_SOM ) / 2 STEP 2
   LIN_SOM := STUFF( LIN_SOM, I, 1, CHR( 8 ) )
NEXT
RESTSCREEN( LIN_SUP + 1, COL_SUP - 2, LIN_INF + 1, COL_SUP - 1, COL_SOM )
RESTSCREEN( LIN_INF + 1, COL_SUP - 2, LIN_INF + 2, COL_INF - 2, LIN_SOM )
MOUSE( LIGA )
RETURN .T.
 
FUNCTION CONFCOR
menu:TIPO_MENU := SUB_MENU
menu:ADD( "~Papel de parede" )
menu:ADD( "~Menu" )
menu:ADD( "~Destaque do menu" )
menu:ADD( "~Janela de dialogo" )
menu:ADD( "~Box da janela de dialogo" )
menu:ADD( "B~otoes" )
menu:ADD( "Bo~tao em destaque" )
menu:ADD( "~Get's" )
menu:ADD( "G~et em destaque" )
menu:ADD( "Te~la de apresentacao" )
menu:ADD( "~Caracteres avulsos" )
menu:ADD( "Ce~rcaduras" )
menu:ADD( "T~itulo" )
ME_NU := menu:CONTEUDO()
OPC_COR := menu:RODA()
IF OPC_COR = 0
   RETURN.T.
ENDIF
SETCOLOR( "W" )
MOUSE( DESLIGA )
RESTSCREEN( LIN_MENU + 1, 00, 23, 79, TELA_PRI )
MOUSE( LIGA )
COR( "MENU" )
@ LIN_MENU, 00
@ LIN_MENU, 01 SAY "ConfiguraáÑo de cores ≥ "+ME_NU[ _OPCOES_MENU ][ OPC_COR ]
COR( "FUNDO DA TELA" )
IF FUNDO = 10
   FUN_DO := "∞∞∞∞"
ELSE
   FUN_DO := "¿ø¿ø"
ENDIF
MENSAGEM( "Utilize as setas para configurar as cores" )
IF OPC_COR != 10
   SOMBRA( 03, 20, 21, 79 )
   FOR F = 1 + LIN_MENU TO 17
      @ F + 3, 20 SAY REPL( SUBS( FUN_DO, 1, 2 ), 30 )
      FUN_DO := SUBS( FUN_DO, 3 ) + SUBS( FUN_DO, 1, 2 )
   NEXT
   FUN_DO := SUBS( FUN_DO, 3 ) + SUBS( FUN_DO, 1, 2 )
   COR( "TITULO" )
   @ 03, 20 SAY "                    Titulo do aplicativo                    "
   COR( "MENU" )
   @ LIN_MENU + 3, 20 SAY "   Cadastros  Manutenáîes  Relat¢rios  Utilit†rios  Sair    "
   @ 21, 20 SAY SPACE( 60 )
   @ 21, 21 SAY DTOC( M->DAT_HOJE ) + " ≥"
   @ 21, 38 SAY "Escolha a opáÑo desejada"
   @ 21, 69 SAY "≥ F1-Ajuda"
ENDIF
IF OPC_COR = 3
   @ LIN_MENU + 4,22 SAY " ⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø "
   @ LIN_MENU + 5,22 SAY " ≥ OpáÑo um            ≥ "
   @ LIN_MENU + 6,22 SAY " √ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥ "
   @ LIN_MENU + 7,22 SAY " ≥ OpáÑo dois          ≥ "
   @ LIN_MENU + 8,22 SAY " ≥ OpáÑo tres          ≥ "
   @ LIN_MENU + 9,22 SAY " ¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ "
ENDIF
IF OPC_COR = 4 .OR. OPC_COR = 5 .OR. OPC_COR = 6 .OR. OPC_COR = 7
   JANELA( 08, 28, 16, 71 )
   @ 11, 38 SAY "Confirma o encerramento ?"
   botao:ADD( 13, 36, "Sim     " )
   botao:ADD( 13, 53, "NÑo     " )
   botao:MOSTRA()
   COR( "BOTAO EM DESTAQUE" )
   @ 13, 37 SAY "Sim"
ENDIF
IF OPC_COR = 8 .OR. OPC_COR = 9 .OR. OPC_COR = 11 .OR. OPC_COR = 12
   JANELA( 06, 23, 18, 76, "Cadastro de clientes" )
   COR( "CERCADURAS" )
   @ 11, 27 TO 11, 48
   @ 11, 52 TO 11, 72
   @ 15, 27 TO 15, 48
   @ 15, 52 TO 15, 63
   @ 15, 66 TO 15, 72
   COR( "CARACTERES AVULSOS" )
   @ 10, 27 SAY "Nome"
   @ 10, 52 SAY "Empresa"
   @ 14, 27 SAY "Endereáo"
   @ 14, 52 SAY "Bairro"
   @ 14, 66 SAY "Cep"
   COR( "GET EM DESTAQUE" )
   @ 12, 27 SAY "TESTE" + SPACE( 17 )
   SETCOLOR( CONTECOR[ 8 ] )
   @ 12, 52 SAY "TESTE" + SPACE( 16 )
   @ 16, 27 SAY "TESTE" + SPACE( 17 )
   @ 16, 52 SAY "TESTE" + SPACE( 7 )
   @ 16, 66 SAY "9999999"
ENDIF
X_COR := 07; Y_COR := 0
CURSOR( DESLIGA )
SETCOLOR( "BG/RB" )
@ X_COR, Y_COR, X_COR + 9, Y_COR + 17 BOX "€"
FOR F_COR = 0 TO 7
   FOR C_COR = 0 TO 15
      SETCOLOR( ALLTRIM( STR( C_COR, 2 ) ) + "/" + ALLTRIM( STR( F_COR, 2 ) ) )
      @ F_COR + X_COR + 1, C_COR + Y_COR + 1 SAY "˛"
   NEXT
NEXT
C_COR := VAL( SUBS( CONTECOR[ OPC_COR ], 1, 2 ) )
F_COR := VAL( SUBS( CONTECOR[ OPC_COR ], 4 ) )
OK := .T.
WHILE .T.
   SETCOLOR( "N/BG" )
   @ X_COR, Y_COR, X_COR + 9, Y_COR + 17 BOX " "
   @ F_COR + X_COR + 1, Y_COR + 17 SAY CHR( 17 )
   @ X_COR, Y_COR + C_COR + 1 SAY CHR( 31 )
   SETCOLOR( ALLTRIM( STR( C_COR, 3 ) ) + "/" + ALLTRIM( STR( F_COR, 3 ) ) )
   CONTECOR[ OPC_COR ] := STRZERO( C_COR, 2 ) + "/" + STRZERO( F_COR, 2 )
   IF OPC_COR = 1
      FOR F= 1 + LIN_MENU TO 17
         @ F + 3, 20 SAY REPL( SUBS( FUN_DO, 1, 2 ), 30 )
         FUN_DO := SUBS( FUN_DO, 3 ) + SUBS( FUN_DO, 1, 2 )
      NEXT
      FUN_DO := SUBS( FUN_DO, 3 ) + SUBS( FUN_DO, 1, 2 )
   ELSEIF OPC_COR = 2
      @ LIN_MENU + 3, 20 SAY "   Cadastros  Manutenáîes  Relat¢rios  Utilit†rios  Sair    "
      @ 21, 20 SAY SPACE( 60 )
      @ 21, 21 SAY DTOC( M->DAT_HOJE ) + " ≥"
      @ 21, 38 SAY "Escolha a opáÑo desejada"
      @ 21, 69 SAY "≥ F1-Ajuda"
      IF OPC_COR = 2
         @ LIN_MENU + 4,22 SAY " ⁄ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒø "
         @ LIN_MENU + 5,22 SAY " ≥ OpáÑo um            ≥ "
         @ LIN_MENU + 6,22 SAY " √ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒ¥ "
         @ LIN_MENU + 7,22 SAY " ≥ OpáÑo dois          ≥ "
         @ LIN_MENU + 8,22 SAY " ≥ OpáÑo tres          ≥ "
         @ LIN_MENU + 9,22 SAY " ¿ƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒƒŸ "
         COR( "DESTAQUE DO MENU" )
         @ LIN_MENU + 3, 22 SAY " Cadastros "
         @ LIN_MENU + 5, 24 SAY " OpáÑo um            "
      ENDIF
   ELSEIF OPC_COR = 3
      @ LIN_MENU + 3, 22 SAY " Cadastros "
      @ LIN_MENU + 5, 24 SAY " OpáÑo um            "
   ELSEIF OPC_COR = 5
      @ 08, 28, 16, 71 BOX " "
      @ 08, 28 SAY "˛"
   ELSEIF OPC_COR = 4
      @ 09, 29 CLEAR TO 15, 70
      @ 11, 38 SAY "Confirma o encerramento ?"
      botao:ADD( 13, 36, "Sim     " )
      botao:ADD( 13, 53, "NÑo     " )
      botao:MOSTRA()
      COR( "BOTAO EM DESTAQUE" )
      @ 13, 37 SAY "Sim     "
   ELSEIF OPC_COR = 6
      botao:ADD( 13, 53, "NÑo     " )
      botao:MOSTRA()
   ELSEIF OPC_COR = 7
      botao:ADD( 13, 36, "Sim     " )
      botao:MOSTRA()
      COR( "BOTAO EM DESTAQUE" )
      @ 13, 36 SAY " Sim       "
   ELSEIF OPC_COR = 12
      @ 11, 27 TO 11, 48
      @ 11, 52 TO 11, 72
      @ 15, 27 TO 15, 48
      @ 15, 52 TO 15, 63
      @ 15, 66 TO 15, 72
   ELSEIF OPC_COR = 11
      @ 10, 27 SAY "Nome"
      @ 10, 52 SAY "Empresa"
      @ 14, 27 SAY "Endereáo"
      @ 14, 52 SAY "Bairro"
      @ 14, 66 SAY "Cep"
   ELSEIF OPC_COR = 9
      @ 12, 27 SAY "TESTE" + SPACE( 17 )
   ELSEIF OPC_COR = 8
      @ 12, 52 SAY "TESTE" + SPACE( 16 )
      @ 16, 27 SAY "TESTE" + SPACE( 17 )
      @ 16, 52 SAY "TESTE" + SPACE( 7 )
      @ 16, 66 SAY "9999999"
   ELSEIF OPC_COR = 10
      COR( "TELA DE APRESENTACAO" )
      @ 03, 20 SAY "∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞"
      @ 04, 20 SAY "∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞"
      @ 05, 20 SAY "∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞"
      @ 06, 20 SAY "∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞"
      @ 07, 20 SAY "∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞"
      @ 08, 20 SAY "∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞"
      @ 09, 20 SAY "∞∞∞∞∞∞∞∞∞∞∞€€€€€€€∞€€€€€€€∞€€€€€€€∞€€€€€€€∞€€€€€€€∞∞∞∞∞∞∞∞∞∞"
      @ 10, 20 SAY "∞∞∞∞∞∞∞∞∞     € ∞  €    ∞  €    ∞€    € ∞  €    ∞∞∞∞∞∞∞∞∞∞∞∞"
      @ 11, 20 SAY "∞∞∞∞∞∞∞∞∞∞∞∞ ∞€∞∞ ∞€∞∞∞∞∞ ∞€∞∞∞ ∞∞∞∞ ∞€∞∞ ∞€∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞"
      @ 12, 20 SAY "∞∞∞∞∞∞∞∞∞∞∞∞ ∞€€∞ ∞€€€€€€€∞€€€€€€€∞∞ ∞€€∞ ∞€€€€€€€∞∞∞∞∞∞∞∞∞∞"
      @ 13, 20 SAY "∞∞∞∞∞∞∞∞∞∞∞∞  €€∞  €€∞∞∞∞       €€∞∞  €€∞  €€   ∞∞∞∞∞∞∞∞∞∞∞∞"
      @ 14, 20 SAY "∞∞∞∞∞∞∞∞∞∞∞∞  €€∞  €€∞∞∞∞∞∞€∞∞  €€∞∞  €€∞  €€∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞"
      @ 15, 20 SAY "∞∞∞∞∞∞∞∞∞∞∞∞  €€∞  €€€€€€€ €€€€€€€∞∞  €€∞  €€€€€€€∞∞∞∞∞∞∞∞∞∞"
      @ 16, 20 SAY "∞∞∞∞∞∞∞∞∞∞∞∞  ∞∞∞       ∞       ∞∞∞∞  ∞∞∞       ∞∞∞∞∞∞∞∞∞∞∞∞"
      @ 17, 20 SAY "∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞"
      @ 18, 20 SAY "∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞"
      @ 19, 20 SAY "∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞"
      @ 20, 20 SAY "∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞"
      @ 21, 20 SAY "∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞"
      IF OK
         OK := .F.
         SOMBRA( 03, 20, 21, 79 )
      ENDIF
   ELSEIF OPC_COR = 13
      @ 03, 20 SAY "                    Titulo do aplicativo                    "
   ENDIF
   TECLA := INKEY( 0 )
   SETCOLOR( "W/BG" )
   @ X_COR + F_COR + 1, Y_COR + 17 SAY " "
   @ X_COR, C_COR + Y_COR + 1 SAY " "
   F_COR += IIF( TECLA = T_CIMA, -1, IIF( TECLA = T_BAIXO, 1, 0 ) )
   C_COR += IIF( TECLA = T_ESQUERDA, -1, IIF( TECLA = T_DIREITA, 1, 0 ) )
   F_COR = IIF( F_COR < 0, 7, IIF( F_COR > 7, 0, F_COR ) )
   C_COR = IIF( C_COR < 0, 15, IIF( C_COR > 15, 0, C_COR ) )
   IF TECLA = T_ESC .OR. TECLA = T_ENTER
      EXIT
   ENDIF
ENDDO
CONTECOR[ OPC_COR ] := STRZERO( C_COR, 2 ) + "/" + STRZERO( F_COR, 2 )
COR( "TITULO" )
@ 00, 00
@ 00, ( 80 - LEN( TITU_LO ) ) / 2 SAY TITU_LO
FUNDO()
COR( "MENU" )
@ LIN_MENU, 00
FOR F_MENU = 1 TO LEN( MENU_PRI )
   @ LIN_MENU, MENU_POS[ F_MENU ] + 1 SAY MENU_PRI[ F_MENU ]
NEXT
@ 24, 00
@ 24, 01 SAY M->DAT_HOJE
@ 24, 10 SAY "≥"
@ 24, 69 SAY "≥"
@ 24, 71 SAY "F1-Ajuda"
MOUSE( DESLIGA )
TELA_PRI := SAVESCREEN( LIN_MENU + 1, 00, 23, 79 )
MOUSE( LIGA )
BUFFER := CHR( T_ENTER ) + "C"
RETURN .T.

FUNCTION FUNDO( EDITA_FUNDO )
//
// -> Monta papel de parede
LOCAL CONTAR, MONTA_TELA
IF EDITA_FUNDO = NIL
   EDITA_FUNDO := 0
ENDIF
menu:LIMPA()
menu:TIPO_MENU := SUB_MENU
menu:ADD( "[~1]  MS Sistemas" )
menu:ADD( "[~2]  ∞∞∞∞∞∞∞∞∞∞±±±±±±±±±≤≤≤≤≤≤≤≤≤≤±±±±±±±±±±" )
menu:ADD( "[~3]  ∞∞∞∞∞∞∞∞∞∞±±±±±±±±±∞∞∞∞∞∞∞∞∞∞≤≤≤≤≤≤≤≤≤≤" )
menu:ADD( "[~4]  ≤≤≤≤≤≤≤≤≤≤∞∞∞∞∞∞∞∞∞≤≤≤≤≤≤≤≤≤≤±±±±±±±±±±" )
menu:ADD( "[~5]  ≤≤≤≤≤≤≤≤≤≤         ∞∞∞∞∞∞∞∞∞∞±±±±±±±±±±" )
menu:ADD( "[~6]  ∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞±±±±±±±±±±±±±±±±±±±±" )
menu:ADD( "[~7]  ∞∞∞∞∞∞∞∞∞∞±±±±±±±±±≤≤≤≤≤≤≤≤≤≤±±±±±±±±±" )
menu:ADD( "[~8]  ∞∞∞∞∞∞∞∞∞∞±±±±±±±±±∞∞∞∞∞∞∞∞∞∞≤≤≤≤≤≤≤≤≤" )
menu:ADD( "[~9]  ≤≤≤≤≤≤≤≤≤≤∞∞∞∞∞∞∞∞∞≤≤≤≤≤≤≤≤≤≤±±±±±±±±±" )
menu:ADD( "[~A]  ≤≤≤≤≤≤≤≤≤≤         ∞∞∞∞∞∞∞∞∞∞±±±±±±±±±" )
menu:ADD( "[~B]  ∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞∞±±±±±±±±±±±±±±±±±±" )
menu:ADD( "[~C]  ∞" )
menu:ADD( "[~D]  ±" )
menu:ADD( "[~E]  ≤" )
menu:ADD( "[~F]  €" )
menu:ADD( "[~G]  ¿ø¿ø" )
menu:ADD( "[~H]   ÀÀ " )
menu:ADD( "[~I]  ¡¬¬¡" )
menu:ADD( "[~J]  √¥¥√" )
menu:ADD( "[~K]  πÃÃπ" )
menu:ADD( "[~L]  ∞∞∞∞∞±±±±±∞∞∞∞∞≤≤≤≤≤" )
menu:ADD( "[~M]  Õ ÕÀÕÀÕ " )
menu:ADD( "[~N]  ƒ¡ƒ¬ƒ¬ƒ¡" )
ME_NU := menu:CONTEUDO()
IF EDITA_FUNDO = 1
   S_MENU := menu:RODA()
   IF S_MENU = 0
      RETURN .F.
   ENDIF
   FUNDO := S_MENU
ELSE
   menu:LIMPA()
ENDIF
COR( "FUNDO DA TELA" )
IF FUNDO = 21
   MONTA_TELA := 0
   FOR CONTAR = LIN_MENU + 1 TO 23
      MONTA_TELA++
      IF MONTA_TELA < 3
         @ CONTAR, 00 SAY REPL( "∞∞∞∞∞±±±±±", 8 )
      ELSE
         @ CONTAR, 00 SAY REPL( "≤≤≤≤≤∞∞∞∞∞", 8 )
         IF MONTA_TELA=4; MONTA_TELA := 0; ENDIF
      ENDIF
   NEXT
   MOUSE( DESLIGA )
   TELA_PRI := SAVESCREEN( LIN_MENU + 1, 00, 23, 79 )
   MOUSE( LIGA )
   RETURN .T.
ENDIF
IF FUNDO = 1
   FUN_DO := " MS Sistemas                                      "
ELSE
   FUN_DO := TRIM( SUBS( ME_NU[ _OPCOES_MENU ][ FUNDO ], 7 ) )
ENDIF
IF FUNDO < 16
   FUN_DO := SUBS( FUN_DO + REPL( FUN_DO, 1840 / LEN( FUN_DO ) ), 1, 1840 )
ENDIF
FOR CONTAR := LIN_MENU + 1 TO 23
   IF FUNDO < 16
      @ CONTAR, 00 SAY SUBS( FUN_DO, CONTAR * 80 - 79, 80 )
   ELSEIF FUNDO = 22 .OR. FUNDO = 23
      @ CONTAR, 00 SAY REPL( SUBS( FUN_DO, 1, 4 ), 20 )
      FUN_DO := SUBS( FUN_DO, 5 ) + SUBS( FUN_DO, 1, 4 )
   ELSE
      @ CONTAR, 00 SAY REPL( SUBS( FUN_DO, 1, 2 ), 40 )
      FUN_DO := SUBS( FUN_DO, 3 ) + SUBS( FUN_DO, 1, 2 )
   ENDIF
NEXT
IF EDITA_FUNDO = 1
   MOUSE( DESLIGA )
   TELA_PRI := SAVESCREEN( LIN_MENU + 1, 00, 23, 79 )
   MOUSE( LIGA )
ENDIF
RETURN .T.

FUNCTION COR( NOM_COR )
QUAL_COR := ASCAN( NOMECOR, UPPER( NOM_COR ) )
IF QUAL_COR != 0
   IF QUAL_COR = 2
      SETCOLOR( CONTECOR[ 2 ] + "," + CONTECOR[ 3 ] + ",,," + CONTECOR[ 2 ] )
   ELSEIF QUAL_COR = 8
      SETCOLOR( CONTECOR[ 11 ] + "," + CONTECOR[ 9 ] + ",,," + CONTECOR[ 8 ] )
   ELSE
      SETCOLOR( CONTECOR[ QUAL_COR ] )
   ENDIF
ENDIF
RETURN .T.

FUNCTION FUN_CFG( PAR1, PAR2 )
LOCAL TECLA := 0
IF LASTKEY() = T_ENTER
   RETURN 1
ELSEIF LASTKEY() = T_ESC
   RETURN 0
ELSEIF AT( UPPER( CHR( LASTKEY() ) ), "IFRSC" ) > 0 .OR.;
       LASTKEY() = T_TAB .OR. LASTKEY() = T_SH_TAB
   RETURN 0
ELSEIF PAR1 = 1
   KEYBOARD CHR( T_CTRL_PGDN )
ELSEIF PAR1 = 2
   KEYBOARD CHR( T_CTRL_PGUP )
ENDIF
CFG_COR := SETCOLOR()
COR( "MENU" )
FOR F_CFG = 1 TO LEN( MENU_CFG )
   @ 09 + F_CFG, 34 SAY " "
NEXT
SETCOLOR( CFG_COR )
IF LASTKEY() = 32
   @ PAR2 + 9, 28 SAY PADR( MENU_CFG[ PAR2 ], 25 ) COLOR CONTECOR[ 7 ]
   WHILE( TECLA := INKEY() ) == 0
      IF TECLA = 0
         //
         // -> Là buffer do mouse
         TECLA := ACAO_MOUSE()
         IF TECLA != 0; EXIT; ENDIF
      ENDIF
   ENDDO
   @ PAR2 + 9, 28 SAY PADR( MENU_CFG[ PAR2 ], 25 ) COLOR CONTECOR[ 2 ]
   IF TECLA >= 1 .AND. TECLA <= 3
      IF TECLA = PAR2
         KEYBOARD CHR( T_ENTER )
      ELSEIF TECLA < PAR2
         KEYBOARD REPL( CHR( T_CIMA ), PAR2 - TECLA ) + CHR( T_ENTER )
      ELSEIF TECLA > PAR2
         KEYBOARD REPL( CHR( T_BAIXO ), TECLA - PAR2 ) + CHR( T_ENTER )
      ENDIF
      @ PAR2 + 9, 34 SAY " " COLOR CONTECOR[ 2 ]
      @ TECLA + 9, 28 SAY PADR( MENU_CFG[ TECLA ], 25 ) COLOR CONTECOR[ 7 ]
      RETURN 2
   ENDIF
ENDIF
IF TECLA != 0
   KEYBOARD CHR( TECLA ) + CHR( 32 )
ELSE
   KEYBOARD CHR( 32 )
ENDIF
RETURN 2

FUNCTION CALCU
//
// -> FunáÑo que ativa a calculadora
LOCAL ULT_CURSOR := SETCURSOR(), ULT_COR := SETCOLOR(), LINHA := ROW(),;
      COLUNA := COL(), TELA, RESULTADO := 0, CONTADOR, CONTAR, LIN, COL,;
      ALGARISMOS := SPACE( 14 ), DECIMAIS := "", TECLA := CHR( 0 ),;
      MOV_TELA, ALG_OU_DEC := "A", PERCENTAGEM := " ", ULT_OPERADOR := "",;
      OK_OPERADOR := .F., CALCULO, TRANSPORTE, BO_TAO, TELA_CALCU,;
      L_CALCU, C_CALCU, TIPO_SAIDA := NIL, BOTOES := {;
      { 6, 4, " 7 ", { "7", CHR( T_HOME ) } },;
      { 6, 9, " 8 ", { "8", CHR( T_CIMA ) } },;
      { 6, 14, " 9 ", { "9", CHR( T_PGUP ) } },;
      { 6, 20, " - ", { "-" } },;
      { 6, 25, " + ", { "+" } },;
      { 8, 4, " 4 ", { "4", CHR( T_ESQUERDA ) } },;
      { 8, 9, " 5 ", { "5", CHR( 76 ) } },;
      { 8, 14, " 6 ", { "6", CHR( T_DIREITA ) } },;
      { 8, 20, " / ", { "/" } },;
      { 8, 25, " * ", { "*" } },;
      { 10, 4, " 1 ", { "1", CHR( T_END ) } },;
      { 10, 9, " 2 ", { "2", CHR( T_BAIXO ) } },;
      { 10, 14, " 3 ", { "3", CHR( T_PGDN ) } },;
      { 10, 20, " = ", { "=", CHR( T_ENTER ) } },;
      { 10, 25, " % ", { "%" } },;
      { 12, 4, " 0 ", { "0", CHR( T_INSERT ) } },;
      { 12, 9, " . ", { ".", CHR( T_DEL ) } },;
      { 12, 14, "Get", { "G" } },;
      { 12, 20, " C ", { "C", " " } },;
      { 12, 25, "cE ", { "E" } },;
      { 12, 41, " Imprime  ", { "I" } } }
DADOS_CALCU := {}
MOUSE( LIGA )
SOMBRA( L_CALCU := L_SOM, C_CALCU := C_SOM, .T. )
MOUSE( DESLIGA )
TELA := SAVESCREEN( 00, 00, MAXROW(), MAXCOL() )
MOUSE( LIGA )
CURSOR( DESLIGA )
JANELA( MOV_LINHA, MOV_COLUNA, MOV_LINHA + 15, MOV_COLUNA + 61, "Calculadora" )
COR( "BOX DA JANELA DE DIALOGO" )
@ MOV_LINHA + 1, MOV_COLUNA + 30, MOV_LINHA + 14, MOV_COLUNA + 30 BOX SPACE( 8 )
COR( "MENU" )
@ MOV_LINHA + 2, MOV_COLUNA + 33 CLEAR TO MOV_LINHA + 10, MOV_COLUNA + 58
SETCOLOR( ALLTRIM( SUBS( CONTECOR[ 5 ], 4 ) ) + "/" + ALLTRIM( SUBS( CONTECOR[ 4 ], 4 ) ) )
@ MOV_LINHA + 2, MOV_COLUNA + 4, MOV_LINHA + 4, MOV_COLUNA + 26 BOX "‹‹‹€ﬂﬂﬂ€"
FOR CONTAR := 1 TO LEN( BOTOES )
   BOT_CALC( MOV_LINHA + BOTOES[ CONTAR ][ 1 ],;
             MOV_COLUNA + BOTOES[ CONTAR ][ 2 ], BOTOES[ CONTAR ][ 3 ] )
NEXT
@ MOV_LINHA + 3, MOV_COLUNA + 5 SAY " " + STR( RESULTADO, 19, 4 ) + " " COLOR "W"
WHILE TECLA != CHR( T_ESC )
   TECLA := CHR( 0 )
   WHILE TECLA = CHR( 0 )
      TECLA := CHR( INKEY() )
      MOUSE( @BO_TAO, @LIN, @COL )
      IF BO_TAO = M_ESQUERDO
         DADO_CUR := SUBS( SAVESCREEN( LIN, COL, LIN, COL ), 1, 1 )
         IF DADO_CUR = CHR( 254 )
            TECLA := CHR( T_ESC )
            EXIT
         ELSEIF LIN = 24 .AND. ( COL >= 71 .AND. COL <= 78 )
            TECLA := CHR( T_F1 )
            EXIT
         ENDIF
         FOR CONTAR = 1 TO LEN( BOTOES )
            IF LIN = BOTOES[ CONTAR ][ 1 ] + MOV_LINHA .AND.;
               ( COL >= BOTOES[ CONTAR ][ 2 ] + MOV_COLUNA .AND.;
                 COL <= MOV_COLUNA + BOTOES[ CONTAR ][ 2 ] +;
                 LEN( BOTOES[ CONTAR ][ 3 ] ) - 1 )
               TECLA := BOTOES[ CONTAR ][ 4 ][ 1 ]
               EXIT
            ENDIF
         NEXT
         IF TECLA = CHR( 0 ); BEEP_MOUSE(); ENDIF
      ELSEIF BO_TAO = M_OS_DOIS
         TECLA := CHR( T_ESC )
      ELSEIF BO_TAO = M_DIREITO
         TECLA := CHR( T_ENTER )
      ENDIF
   ENDDO
   TECLA := UPPER( TECLA )
   FOR CONTAR := 1 TO LEN( BOTOES )
      FOR CONTADOR := 1 TO LEN( BOTOES[ CONTAR ][ 4 ] )
         IF TECLA = BOTOES[ CONTAR ][ 4 ][ CONTADOR ]
            EXIT
         ENDIF
      NEXT
      IF CONTADOR <= LEN( BOTOES[ CONTAR ][ 4 ] )
         BOT_CALC( MOV_LINHA + BOTOES[ CONTAR ][ 1 ],;
                   MOV_COLUNA + BOTOES[ CONTAR ][ 2 ], BOTOES[ CONTAR ][ 3 ],;
                   .T. )
         TECLA := BOTOES[ CONTAR ][ 4 ][ 1 ]
         EXIT
      ENDIF
   NEXT
   SETCOLOR( "W" )
   IF AT( TECLA, CHR( 26 ) + CHR( 2 ) + CHR( 141 ) + CHR( 145 ) ) != 0
      MOUSE( DESLIGA )
      MOV_TELA := SAVESCREEN( MOV_LINHA, MOV_COLUNA, MOV_LINHA + 15, MOV_COLUNA + 61 )
      RESTSCREEN( 00, 00, MAXROW(), MAXCOL(), TELA )
      MOUSE( LIGA )
      IF TECLA = CHR( 26 )
         MOV_COLUNA--
      ELSEIF TECLA = CHR( 2 )
         MOV_COLUNA++
      ELSEIF TECLA = CHR( 141 )
         MOV_LINHA--
      ELSEIF TECLA = CHR( 145 )
         MOV_LINHA++
      ENDIF
      IF MOV_LINHA < 0
         MOV_LINHA := 0
      ELSEIF MOV_LINHA > 9
         MOV_LINHA := 9
      ELSEIF MOV_COLUNA < 0
         MOV_COLUNA := 0
      ELSEIF MOV_COLUNA > 20
         MOV_COLUNA := 20
      ENDIF
      MOUSE( DESLIGA )
      SOMBRA( MOV_LINHA, MOV_COLUNA, MOV_LINHA + 15, MOV_COLUNA + 61 )
      RESTSCREEN( MOV_LINHA, MOV_COLUNA, MOV_LINHA + 15, MOV_COLUNA + 61, MOV_TELA )
      MOUSE( LIGA )
   ENDIF
   IF TECLA = CHR( T_F1 )
      HELP( "CALCULADORA" )
   ENDIF
   IF TECLA = CHR( T_ESC )
      EXIT
   ENDIF
   IF TECLA = "."; ALG_OU_DEC := "D"; ENDIF
   ALGARISMOS := IIF( TECLA = "." .AND. ALGARISMOS = SPACE( 14 ),;
               SPACE( 13 ) + "0", ALGARISMOS )
   IF TECLA = "%"
      IF RESULTADO != 0 .AND. ULT_OPERADOR $ "+-/*"
         PERCENTAGEM := IIF( PERCENTAGEM = "%", " ", "%" )
         SETCOLOR( ALLTRIM( SUBS( CONTECOR[ 6 ], 1, 2 ) ) + "/" +;
                   ALLTRIM( SUBS( CONTECOR[ 5 ], 4 ) ) )
         @ MOV_LINHA + 3, MOV_COLUNA + 26 SAY PERCENTAGEM
         IMP_CALCU( ALGARISMOS + "." + SUBS( DECIMAIS + "00000", 1, 4 ) + "%" )
      ELSE
         @ MOV_LINHA + 3, MOV_COLUNA + 5 SAY SPACE( 13 ) + "0.0000" COLOR "W"
         RESULTADO := 0; ALGARISMOS := SPACE( 14 ); DECIMAIS := ""
      ENDIF
   ELSEIF TECLA $ "0123456789" .AND.;
          IIF( ALG_OU_DEC = "A", LEN( LTRIM( ALGARISMOS ) ) != 14,;
               LEN( LTRIM( DECIMAIS ) ) != 4 )
      OK_OPERADOR := .T.
      IF ULT_OPERADOR = "="
         ULT_OPERADOR = " "
         RESULTADO = 0
      ENDIF
      IF ALG_OU_DEC = "A"
         ALGARISMOS = SUBS( ALGARISMOS + TECLA, 2 )
      ELSE
         DECIMAIS += TECLA
      ENDIF
      @ MOV_LINHA + 3, MOV_COLUNA + 6 SAY ALGARISMOS + "." + SUBS( DECIMAIS +;
                       "00000", 1, 4 ) COLOR "W"
   ELSEIF TECLA $ "+-/*="
      IF TECLA != "="
         IF !OK_OPERADOR
            LOOP
         ENDIF
         OK_OPERADOR := .F.
      ENDIF
      IF RESULTADO != 0
         IF VAL( ALGARISMOS + "." + DECIMAIS ) != 0
            IF ULT_OPERADOR != "="
               IF PERCENTAGEM = "%"
                  CALCULO := STR( RESULTADO, 19, 4 ) + ULT_OPERADOR + "(" +;
                             STR( RESULTADO, 19, 4 ) + "*" + ALGARISMOS +;
                             "." + SUBS( DECIMAIS + "00000" , 1, 4 ) + ")/100.000"
               ELSE
                  CALCULO := STR( RESULTADO, 19, 4 ) + ULT_OPERADOR +;
                             ALGARISMOS + "." + SUBS( DECIMAIS + "00000", 1, 4 )
               ENDIF
               RESULTADO := &CALCULO
               IF STR( RESULTADO, 19, 4 ) = REPL( "*", 19 )
                  @ MOV_LINHA + 3, MOV_COLUNA + 6 SAY "    * E R R O *    " COLOR "W"
                  RESULTADO := 0
                  SETCOLOR( ALLTRIM( SUBS( CONTECOR[ 6 ], 1, 2 ) ) + "/" +;
                            ALLTRIM( SUBS( CONTECOR[ 5 ], 4 ) ) )
                  @ MOV_LINHA + 3, MOV_COLUNA + 4 SAY " "
                  @ MOV_LINHA + 3, MOV_COLUNA + 26 SAY " "
                  IMP_CALCU()
                  IMP_CALCU( "E R R O        " )
                  IMP_CALCU()
               ELSE
                  @ MOV_LINHA + 3, MOV_COLUNA + 6 SAY STR( RESULTADO, 19, 4 ) COLOR "W"
                  IF TECLA != "=" .AND. PERCENTAGEM != "%"
                     IMP_CALCU( TRAN( VAL( ALGARISMOS + "." + SUBS( DECIMAIS +;
                         "00000", 1, 4 ) ), "@E 99,999,999,999,999.9999" ) + TECLA )
                  ENDIF
               ENDIF
            ENDIF
         ELSE
            IF TECLA != "="
               IMP_CALCU( TRAN( RESULTADO, "@E 99,999,999,999,999.9999" ) +;
                          TECLA )
            ENDIF
         ENDIF
      ELSEIF TECLA $ "+-/*"
         RESULTADO := VAL( ALGARISMOS + "." + DECIMAIS )
         IMP_CALCU( TRAN( VAL( ALGARISMOS + "." + SUBS( DECIMAIS + "00000", 1,;
                    4 ) ), "@E 99,999,999,999,999.9999" ) + TECLA )
      ENDIF
      SETCOLOR( ALLTRIM( SUBS( CONTECOR[ 6 ], 1 , 2 ) ) + "/" +;
                ALLTRIM( SUBS( CONTECOR[ 5 ], 4 ) ) )
      @ MOV_LINHA + 3, MOV_COLUNA + 4 SAY IIF( TECLA $ "+-/*", TECLA, " " )
      @ MOV_LINHA + 3, MOV_COLUNA + 26 SAY " "
      IF TECLA = "="
         IF VAL( ALGARISMOS + "." + DECIMAIS ) != 0 .AND. PERCENTAGEM != "%"
            IMP_CALCU( TRAN( VAL( ALGARISMOS + "." + SUBS( DECIMAIS + "00000",;
                       1, 4 ) ), "@E 99,999,999,999,999.9999" ) + " " )
         ENDIF
         IMP_CALCU( "=" )
         IMP_CALCU( TRAN( RESULTADO, "@E 99,999,999,999,999.9999" ) +;
                    " " )
         IMP_CALCU()
      ENDIF
      ALG_OU_DEC := "A"
      ALGARISMOS := SPACE( 14 )
      DECIMAIS := ""
      ULT_OPERADOR := TECLA
      PERCENTAGEM := " "
   ELSEIF TECLA $ "EC"
      ALG_OU_DEC := "A"
      ALGARISMOS := SPACE( 14 )
      DECIMAIS := ""
      PERCENTAGEM := " "
      IF TECLA $ "C"
         RESULTADO := 0
         SETCOLOR( ALLTRIM( SUBS( CONTECOR[ 6 ], 1, 2 ) ) + "/" +;
                   ALLTRIM( SUBS( CONTECOR[ 5 ], 4 ) ) )
         @ MOV_LINHA + 3, MOV_COLUNA + 4 SAY " "
         @ MOV_LINHA + 3, MOV_COLUNA + 26 SAY " "
         IMP_CALCU()
         IMP_CALCU( REPL( "ƒ", 24 ) )
         IMP_CALCU()
      ENDIF
      @ MOV_LINHA + 3, MOV_COLUNA + 6 SAY SPACE( 13 ) + "0.0000" COLOR "W"
   ELSEIF TECLA = "G"
      IF RESULTADO != 0
         TRANSPORTE := ALLTRIM( STR( RESULTADO ) )
      ELSE
         TRANSPORTE := ALLTRIM( STR( VAL( ALGARISMOS  + "." +  DECIMAIS ) ) )
      ENDIF
      IF "." $ TRANSPORTE
         FOR CONTADOR := LEN( TRANSPORTE ) TO 1 STEP -1
            IF SUBS( TRANSPORTE, CONTADOR, 1 ) != "0"
               TRANSPORTE := SUBS( TRANSPORTE, 1, CONTADOR )
               EXIT
            ENDIF
         NEXT
         IF SUBS( TRANSPORTE, LEN( TRANSPORTE ), 1 ) = "."
            TRANSPORTE := SUBS( TRANSPORTE, 1, LEN( TRANSPORTE ) - 1 )
         ENDIF
      ENDIF
      KEYBOARD TRANSPORTE
      EXIT
   ELSEIF TECLA = "I"
      MOUSE( DESLIGA )
      TELA_CALCU := SAVESCREEN( 00, 00, MAXROW(), MAXCOL() )
      MOUSE( LIGA )
      COR( "MENU" )
      @ LIN_MENU, 00
      @ LIN_MENU, 01 SAY "Calculadora ≥ ImpressÑo do conteudo da fita"
      NUM_RELATORIO := 0
      TIPO_SAIDA := MENU_PRN()
      IF TIPO_SAIDA = NIL
         MOUSE( DESLIGA )
         RESTSCREEN( 00, 00, MAXROW(), MAXCOL(), TELA_CALCU )
         MOUSE( LIGA )
         LOOP
      ENDIF
      SET DEVI TO PRINT
      @ 00, 00 SAY ""
      FOR CONTADOR := 1 TO LEN( DADOS_CALCU )
         @ PROW() + 1, 00 SAY DADOS_CALCU[ CONTADOR ]
         IF PROW() > 62
            @ 00, 00 SAY ""
         ENDIF
      NEXT
      EJECT
      SET DEVI TO SCREEN
      IF TIPO_SAIDA = "A"
         SET PRINTER TO
      ELSEIF TIPO_SAIDA = "T"
         SET PRINTER TO
         IMP_TELA( 30 )
      ENDIF
      MOUSE( DESLIGA )
      RESTSCREEN( 00, 00, MAXROW(), MAXCOL(), TELA_CALCU )
      MOUSE( LIGA )
   ENDIF
ENDDO
SETCOLOR( ULT_COR )
MOUSE( DESLIGA )
RESTSCREEN( 00, 00, MAXROW(), MAXCOL(), TELA )
MOUSE( LIGA )
SETCURSOR( ULT_CURSOR )
SOMBRA( L_CALCU, C_CALCU )
SETPOS( LINHA, COLUNA )

FUNCTION IMP_CALCU( CONTEUDO )
IF CONTEUDO = NIL; CONTEUDO := ""; ENDIF
COR( "MENU" )
SCROLL( MOV_LINHA + 2, MOV_COLUNA + 33, MOV_LINHA + 10, MOV_COLUNA + 58, 1 )
@ MOV_LINHA + 10, MOV_COLUNA + 33 SAY PADL( CONTEUDO, 25 )
IF CONTEUDO = REPL( "ƒ", 24 )
   AADD( DADOS_CALCU, REPL( "-", 24 ) )
ELSEIF CONTEUDO = "="
   AADD( DADOS_CALCU, SPACE( 23 ) + "=" )
ELSE
   AADD( DADOS_CALCU, CONTEUDO )
ENDIF
RETURN NIL

FUNCTIO BOT_CALC( BOT_X, BOT_Y, BOT_N )
LOCAL TEMPO := SECONDS()
IF PCOUNT() = 4
   SETCOLOR( "N/" + ALLTRIM( SUBS( CONTECOR[ 4 ], 4 ) ) )
   @ BOT_X, BOT_Y + LEN( BOT_N ) - 1 SAY " "
   @ BOT_X + 1, BOT_Y - 1 SAY REPL( " ", LEN( BOT_N ) )
   IF BOT_Y = 20 + MOV_COLUNA .OR. BOT_Y = 25 + MOV_COLUNA
      COR( "BOTAO EM DESTAQUE" )
   ELSE
      COR( "BOTOES" )
   ENDIF
   @ BOT_X, BOT_Y - 1 SAY BOT_N
   WHILE ( SECONDS() - TEMPO ) < .1; ENDDO
   SETCOLOR( "N/" + ALLTRIM( SUBS( CONTECOR[ 4 ], 4 ) ) )
   @ BOT_X, BOT_Y - 1 SAY "‹"
   @ BOT_X + 1, BOT_Y - 1 SAY REPL( "ﬂ", LEN( BOT_N ) )
ENDIF
IF BOT_Y = 20 + MOV_COLUNA .OR. BOT_Y = 25 + MOV_COLUNA
   COR( "BOTAO EM DESTAQUE" )
ELSE
   COR( "BOTOES" )
ENDIF
@ BOT_X, BOT_Y SAY BOT_N
SETCOLOR( "N/" + ALLTRIM( SUBS( CONTECOR[ 4 ], 4 ) ) )
@ BOT_X, BOT_Y - 1 SAY "‹"
@ BOT_X + 1, BOT_Y - 1 SAY REPL( "ﬂ", LEN( BOT_N ) )
RETURN .T.
 
FUNCTION MENU_PRN
//
// -> Menu de direcionamento de impressao
ARQ_PRN := "REPORT"
FUNDO()
JANELA( 06, 21, 19, 59, TRIM( SUBS( NOME_IMP, 1, 33 ) ) )
COR( "MENU" )
@ 09, 26 CLEAR TO 13, 54
IF NUM_RELATORIO = 0
   TIPO_FORMULARIO := "0"
ELSE
   TIPO_FORMULARIO := FOR_MULARIO[ NUM_RELATORIO ]
ENDIF
WHILE .T.
   @ 06, 23 SAY PADC( TRIM( SUBS( NOME_IMP, 1, 33 ) ), 35 ) COLOR CONTECOR[ 5 ]
   botao:ADD( 15, 33, "Impressoras   " )
   botao:ADD( 17, 33, "Formulario " + IIF( TIPO_FORMULARIO = "1",;
              "132", "080" ) )
   botao:MOSTRA()
   MENU_CFG := { "     (" + CHR( 7 ) + ") Impressora",;
                 "     (" + CHR( 7 ) + ") Tela      ",;
                 "     (" + CHR( 7 ) + ") Arquivo   " }
   SETCOLOR( CONTECOR[ 2 ] + "," + CONTECOR[ 7 ] )
   KEYBOARD CHR( 32 )
   AADD( DADOS_MOUSE, { 15, 33, 48, ASC( "I" ) } )
   AADD( DADOS_MOUSE, { 17, 33, 48, ASC( "F" ) } )
   AADD( DADOS_MOUSE, { 10, 28, 52, 1 } )
   AADD( DADOS_MOUSE, { 11, 28, 52, 2 } )
   AADD( DADOS_MOUSE, { 12, 28, 52, 3 } )
   M->SOS_MENU := "MENU_PRN"
   OPC_PRN := ACHOICE( 10, 28, 12, 52, MENU_CFG, .T., "FUN_CFG" )
   M->SOS_MENU := " "
   DADOS_MOUSE := {}
   IF LASTKEY() = T_TAB .OR. LASTKEY() = T_SH_TAB
      botao:ADD( 15, 33, "Impressoras   " )
      botao:ADD( 17, 33, "Formulario " + IIF( TIPO_FORMULARIO = "1",;
                 "132", "080" ) )
      IF LASTKEY() = T_TAB
         OPCAO_BOTAO := 1
      ELSE
         OPCAO_BOTAO := 2
      ENDIF
      OPCAO_BOTAO := botao:RODA( OPCAO_BOTAO )
      IF OPCAO_BOTAO = 0
         LOOP
      ELSEIF OPCAO_BOTAO = 1
         KEYBOARD "I"
      ELSE
         KEYBOARD "F"
      ENDIF
      INKEY( 0 )
   ENDIF
   IF LASTKEY() = ASC( "I" ) .OR. LASTKEY() = ASC( "i" )
      botao:MOVIMENTA( 15, 33, "Impressoras   " )
      TELA_PRN := SAVESCREEN( 00, 00, 24, 79 )
      IF LEN( IMP_ARQ ) != 0
         ME_NU := {}
         FOR CONTADOR := 1 TO LEN( IMP_ARQ )
            AADD( ME_NU, " " + TRIM( IMP_ARQ[ CONTADOR ][ 1 ] ) )
         NEXT
         JANELA( 03, 08, 21, 72, "SeleáÑo de impressora" )
         botao:ADD( 19, 28, "Enter   " )
         botao:ADD( 19, 44, "Esc     " )
         botao:MOSTRA()
         COR( "MENU" )
         @ 05, 12 CLEAR TO 17, 68
         KEYBOARD CHR( T_CIMA )
         SELECAO_IMP := 1
         MOUSE( DESLIGA )
         SELECAO_IMP := ACHOICE( 06, 13, 16, 67, ME_NU )
         MOUSE( LIGA )
         IF SELECAO_IMP = 0
            botao:MOVIMENTA( 19, 44, "Esc     " )
            RESTSCREEN( 00, 00, 24, 79, TELA_PRN )
            LOOP
         ENDIF
         botao:MOVIMENTA( 19, 44, "Enter   " )
         CON_ARQ := IMP_ARQ[ SELECAO_IMP ][ 2 ]
         LER_IMP( CON_ARQ )
      ENDIF
      RESTSCREEN( 00, 00, 24, 79, TELA_PRN )
      LOOP
   ENDIF
   IF LASTKEY() = ASC( "F" ) .OR. LASTKEY() = ASC( "f" )
      botao:MOVIMENTA( 17, 33, "Formulario " +;
                       IIF( TIPO_FORMULARIO = "1", "132", "080" ) )
      TIPO_FORMULARIO := IIF( TIPO_FORMULARIO = "1", "0", "1" )
      IF NUM_RELATORIO > 0
         FOR_MULARIO[ NUM_RELATORIO ] := TIPO_FORMULARIO
      ENDIF
      LOOP
   ENDIF
   IF AT( UPPER( CHR( LASTKEY() ) ), "SCR" ) > 0
      LOOP
   ENDIF
   IF OPC_PRN = 0
      RETURN NIL
   ELSEIF OPC_PRN = 1
      TIPO_PRN := "I"
      IF !ISPRINTER()
         BEEP()
         MENSAGEM( "Impressora desligada ou desconectada", 3 )
         LOOP
      ENDIF
   ELSEIF OPC_PRN = 2
      TIPO_PRN := "T"
      EX_T := ( VAL( SUBS( TIME(), 4, 2 ) ) * 10 ) + VAL( SUBS( TIME(), 7, 2 ) )
      ARQ_PRN += "." + STRZERO( EX_T, 3 )
      SET PRINTER TO &ARQ_PRN
   ELSEIF OPC_PRN = 3
      MOUSE( DESLIGA )
      RESTSCREEN( LIN_MENU + 1, 00, 23, 79, TELA_PRI )
      MOUSE( LIGA )
      JANELA( 07, 16, 17, 62, "Saidas" )
      COR( "MENU" )
      @ 10, 20 CLEAR TO 14, 58
      @ 11, 23 SAY "Digite o nome do arquivo de saida"
      ARQ_PRN := SPACE( 20 )
      WHILE .T.
         @ 13,29 GET ARQ_PRN PICT "@!" VALID ISALPHA( ARQ_PRN )
         CURSOR( LIGA )
         READ
         CURSOR( DESLIGA )
         IF LASTKEY() = T_ESC
            RETURN NIL
         ENDIF
         IF AT(".",ARQ_PRN) != 0
            BEEP()
            MENSAGEM( "Digite o nome do arquivo sem extensÑo", 3 )
            LOOP
         ENDIF
         EXIT
      ENDDO
      ARQ_PRN := ALLTRIM( ARQ_PRN ) + ".PRN"
      TIPO_PRN := "A"
      SET PRINTER TO &ARQ_PRN
   ENDIF
   MENSAGEM( "Tecle <ESC> para pausa ou interrupáÑo" )
   RETURN TIPO_PRN
ENDDO
 
FUNCTION IMP_TELA
PARA TAM_LIN
MARG_ESQ := 1
IF MARG_ESQ = NIL
   MARG_ESQ := 0
ENDIF
ARQ_PRN := "REPORT"
MARG_ESQ++
MENSAGEM( "Aguarde processamento" )
SELE 100
PUBL QUAN_REG, ULT_POS
ARQ_PRN1 := ARQ_PRN + "." + STRZERO( EX_T, 3 )
ARQ_PRN2 := ARQ_PRN + "." + STRZERO( EX_T + 100, 3 )
DBCREATE( ARQ_PRN2, { { "LI_NHA", "C", TAM_LIN + 1, 0 } } )
IF !USEREDE(ARQ_PRN2,.T.,10)
   BEEP()
   MENSAGEM( "Nao foi possivel acesso, tente novamente", 5 )
   RETURN .F.
ENDIF
APPEND FROM &ARQ_PRN1 SDF
QUAN_REG := LASTREC()
IF QUAN_REG = 0
   QUAN_REG := 1
ENDIF
GOTO TOP
JANELA( LIN_MENU + 3, 02, 21, 77 )
@ LIN_MENU + 4, 77 SAY CHR( 30 )
@ 20, 77 SAY CHR( 31 )
IF TAM_LIN < 72
   EDI_TAR := { "SUBS( LI_NHA, MARG_ESQ )" }
ELSE
   IF INT( TAM_LIN / 36 ) = TAM_LIN / 36
      NUM_COL := TAM_LIN / 36
   ELSE
      NUM_COL := INT( TAM_LIN / 36 ) + 1
   ENDIF
   X=1
   EDI_TAR := {}
   FOR CONTAR = 1 TO NUM_COL - 1
      NUM_MAT := ( CONTAR * 36 ) - 34
      AADD( EDI_TAR, "SUBS( LI_NHA, "+STR(NUM_MAT,3)+", 36 )" )
   NEXT
   NUM_MAT := ( CONTAR * 36 ) - 34
   AADD( EDI_TAR, "SUBS( LI_NHA, " + STR( NUM_MAT, 3 ) + ") + SPACE(" + STR( ( NUM_COL * 36 ) - TAM_LIN, 2 ) + ")" )
ENDIF
KEYBOARD CHR( 65 )
ULT_POS := LIN_MENU + 5
MENSAGEM( "Tecle <ESC> para sair" )
SOS_MENU := "RELATORIO"
SETCOLOR( CONTECOR[ 4 ] + "," + CONTECOR[ 7 ] )
MOUSE( DESLIGA )
DBEDIT( LIN_MENU + 4, 04, 20, 75, EDI_TAR, "FUN_IMP", "", "", "", "" )
MOUSE( LIGA )
SOS_MENU := " "
USE
FERASE( ARQ_PRN1 )
FERASE( ARQ_PRN2 )
RELEASE QUAN_REG, ULT_POS

FUNCTION FUN_IMP
IF LASTKEY() = T_ESC
   RETURN 0
ELSEIF LASTKEY() = T_HOME
   GOTO TOP
ELSEIF LASTKEY() = T_END
   GOTO BOTT
ENDIF
COR( "BOX DA JANELA DE DIALOGO" )
@ ULT_POS, 77 SAY " "
ULT_POS := LIN_MENU + 5 + ( ( ( RECN() * 100 ) / QUAN_REG ) /;
           ( 100 / ( 19 - ( LIN_MENU + 5 ) ) ) )
IF RECN() = 1
   ULT_POS := LIN_MENU + 5
ENDIF
@ ULT_POS, 77 SAY CHR( 4 )
SETCOLOR( CONTECOR[ 4 ] + "," + CONTECOR[ 7 ] )
RETURN 1
 
FUNCTION SHELLDOS
//
// -> Permite sair ao sistema operacional retornado com (EXIT)
LOCAL ULT_CURSOR := SETCURSOR(), ULT_LIN := ROW(), ULT_COL := COL(),;
      ULT_COR := SETCOLOR(), ULT_TELA
MOUSE( LIGA )
MOUSE( DESLIGA )
SAVE SCREEN TO ULT_TELA
SETCOLOR( "W" )
CLS
? "NÑo instale nem desinstale programas residentes."
? "Digite EXIT e tecle <ENTER> para retornar."
?
SET CURSOR ON
RUN COMMAND.COM
SET CURSOR OFF
RESTORE SCREEN FROM ULT_TELA
MOUSE( LIGA )
SETCURSOR( ULT_CURSOR )
SETPOS( ULT_LIN, ULT_COL )
SETCOLOR( ULT_COR )

FUNCTION SENHA
//
// -> Funcao para entrada e checagem de senha
MENSAGEM( "Digite o nome do operador" )
JANELA( 07, 16, 17, 62, "Acesso ao sistema" )
COR( "MENU" )
@ 10, 22 CLEAR TO 14, 56
@ 11, 24 SAY "Operador :"
@ 13, 24 SAY "Senha    : [˙˙˙˙˙˙˙˙˙]"
M->SENHA := ""; M->OPERADOR := SPACE( 20 ); M->TEC := 0
@ 11, 35 GET M->OPERADOR PICT "@!" VALID !EMPTY( M->OPERADOR )
CURSOR( LIGA )
READ
CURSOR( DESLIGA )
MENSAGEM( "Digite a senha para acesso ao sistema" )
SETCOLOR( CONTECOR[ 3 ] )
@ 13, 35 SAY "[˙˙˙˙˙˙˙˙˙]"
FOR M->P_SENHA = 36 TO 44
   M->TEC := INKEY( 0 )
   IF M->TEC = T_BACKSPACE
      IF M->P_SENHA > 36
         M->P_SENHA--
         @ 13, M->P_SENHA SAY "˙"
         M->SENHA := SUBS( M->SENHA, 1, LEN( M->SENHA ) - 1 )
      ENDIF
      M->P_SENHA--
   ELSE
      M->SENHA += CHR( M->TEC )
      IF M->TEC = T_ENTER .OR. M->TEC = T_ESC
         EXIT
      ENDIF
      @ 13, M->P_SENHA SAY "˛"
   ENDIF
NEXT
M->SENHA := UPPER( M->SENHA )
COD_FICA( @SENHA )
M->NOM_ARQ := "AGEND.SNH"
IF !FILE( M->NOM_ARQ )
   CURSOR( DESLIGA )
   BEEP()
   MENSAGEM( "Arquivo de senhas nÑo se encontra dispon°vel", 3 )
   SETCOLOR( "W" )
   CLS
   QUIT
ENDIF
IF !USEREDE( M->NOM_ARQ, .F., 10 )
   BEEP()
   MENSAGEM( "Acesso mal sucedido ao arquivo", 3 )
   RETURN .F.
ENDIF
GOTO TOP
WHILE !EOF()
   IF CODSENHA==M->SENHA .AND. USUARIO==M->OPERADOR
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
      M->SENHA_ENTRADA := CODSENHA
      M->REG_ENTRADA := RECN()
      USE
      RETURN .T.
   ENDIF
   SKIP
ENDDO
USE
CURSOR( LIGA )
RETURN .F.

FUNCTION PESENHA( PAR1, PAR2, PAR3, PAR4 )
//
// -> Pesquisa a existencia de uma senha ou de um usuario
NOM_ARQ := "AGEND.SNH"
IF !USEREDE( NOM_ARQ, .F., 10 )
   BEEP()
   MENSAGEM( "Acesso mal sucedido ao arquivo", 3 )
   RETURN .F.
ENDIF
GOTO TOP
WHILE !EOF()
   IF PAR1 = "C" .AND. PAR2 = CODSENHA
      RETURN .T.
   ENDIF
   IF PAR1 = "U" .AND. PAR2 = USUARIO
      IF PAR3
         BEEP()
         MENSAGEM( PAR4, 3 )
      ENDIF
      SETCOLOR( "N/W,W+/R,,,N/W" )
      RETURN .T.
   ENDIF
   SKIP
ENDDO
USE
IF PAR1 = "U"
   IF !PAR3
      BEEP()
      MENSAGEM( PAR4, 3 )
   ENDIF
ENDIF
SETCOLOR( "N/W,W+/R,,,N/W" )
RETURN .F.

FUNCTION COD_FICA( CODI_GO )
//
// -> Codifica um senha
IF LEN( M->SENHA ) < 9
M->SENHA += SPACE( 9 - LEN( M->SENHA ) )
ENDIF
M->COD := CODI_GO
CODI_GO := ""
FOR M->X = 9 TO 1 STEP -1
   CODI_GO += SUBS( M->COD, M->X, 1 )
NEXT
CODI_GO := SUBS( CODI_GO, 4, 3 ) + SUBS( CODI_GO, 1, 3 ) + SUBS( CODI_GO, 7, 3 )
M->COD := ""
FOR M->X = 1 TO 9
   IF M->X / 2 = INT( M->X / 2 )
      IF ASC( SUBS( CODI_GO, M->X, 1 ) ) = 255
         M->COD += CHR( 0 )
      ELSE
         M->COD += CHR( ASC( SUBS( CODI_GO, M->X, 1 ) ) + 1)
      ENDIF
   ELSE
      IF ASC( SUBS( CODI_GO, M->X, 1 ) ) = 0
         M->COD += CHR( 255 )
      ELSE
         M->COD += CHR( ASC( SUBS( CODI_GO, M->X, 1 ) ) - 1)
      ENDIF
   ENDIF
NEXT
CODI_GO := M->COD

FUNCTION NIV_ACES( PARX )
//
// -> Discrimina o nivel de acesso
IF M->ACESSO = "1"
   @ PARX, 42 SAY "- Operacional"
ELSEIF M->ACESSO = "2"
   @ PARX, 42 SAY "- Gerencial  "
ELSEIF M->ACESSO = "3"
   @ PARX, 42 SAY "- Executivo  "
ELSE
   BEEP()
   @ PARX, 42 SAY "-            "
   MENSAGEM( "Os n°veis de acesso sÑo: 1, 2 ou 3", 3 )
   RETURN .F.
ENDIF
RETURN .T.

FUNCTION GET_COD( PARX, PARY )
//
// -> Permite editar uma senha na posicao desejada
//    retornando a senha codificada
SETCOLOR( CONTECOR[ 3 ] )
@ PARX, PARY SAY "[˙˙˙˙˙˙˙˙˙]"
M->SENHA := ""; M->TEC := 0
CURSOR( DESLIGA )
FOR M->P_SENHA = 1 TO 9
   M->TEC := INKEY( 0 )
   IF M->TEC = T_BACKSPACE
      IF M->P_SENHA > 1
         M->P_SENHA--
         @ PARX, PARY + M->P_SENHA SAY "˙"
         M->SENHA := SUBS( M->SENHA, 1, LEN( M->SENHA ) - 1 )
      ENDIF
      M->P_SENHA--
   ELSE
      M->SENHA += CHR( M->TEC )
      IF M->TEC = T_ENTER .OR. M->TEC = T_ESC
         EXIT
      ENDIF
      @  PARX, PARY + M->P_SENHA SAY "˛"
   ENDIF
NEXT
IF M->TEC = T_ESC
   RETURN CHR( T_ESC )
ENDIF
M->SENHA := UPPER( M->SENHA )
COD_FICA( @SENHA )
CURSOR( LIGA )
RETURN M->SENHA
 
FUNCTION USEREDE( ARQ, EXUSE, TEMPO )
//
// -> Efetua tentativas para abrir o arquivo durante um determinado tempo en-
//    viado atraves do parametro tempo ou indefinidamente, caso tempo=0. Se a
//    tecla <Esc> for precionada pela usuario, as tentaivas sao interrompidas.
//
PRIVATE SEMPRE
SEMPRE := ( TEMPO = 0 )
MENSAGEM( "Aguarde tentativa de acesso aos arquivos" )
WHILE ( SEMPRE .OR. TEMPO > 0 )
   IF EXUSE
      USE &ARQ EXCLUSIVE
      //
      // -> Uso exclusivo
   ELSE
      USE &ARQ
      //
      // -> Uso compartilhado
   ENDIF
   IF !NETERR()
      RETURN .T.
   ENDIF
   IF INKEY( 1 ) = T_ESC
      EXIT
   ENDIF
   TEMPO--
ENDDO
RETURN .F.
 
FUNCTION REGLOCK( TEMPO )
//
// -> Efetua  tentativas  para  bloquear o registro durante um determinado tempo
//    enviado  atraves  do  parametro  tempo  ou indefinidamente caso, tyempo=0.
//    Se a tecla <Esc> for pressionada pelo usuario, as tentativas sao interrom-
//    pidas.
//
PRIVATE SEMPRE
IF RLOCK()
   RETURN .T.
ENDIF
MOUSE( DESLIGA )
SAVE SCREEN
MOUSE( LIGA )
MENSAGEM( "Aguarde tentativa de acesso ao arquivo" )
SEMPRE := ( TEMPO = 0 )
WHILE ( SEMPRE .OR. TEMPO > 0 )
   IF RLOCK()
MOUSE( DESLIGA )
      RESTORE SCREEN
MOUSE( LIGA )
      RETURN .T.
   ENDIF
   IF INKEY( 0.5 ) = T_ESC
      EXIT
   ENDIF
   TEMPO -= 0.5
ENDDO
MOUSE( DESLIGA )
RESTORE SCREEN
MOUSE( LIGA )
RETURN .F.
 
FUNCTION ADIREG( TEMPO )
//
// -> Efetua tentaivas para  adicionar o  registro durante um determinado tempo
//    enviando  atraves  do  paramentro  tempo ou indefinidamente, caso tempo=0.
//    Se a tecla <Esc> for pressionada pelo usuario, as tentativas sao interrom-
//    pidas.
//
PRIVATE SEMPRE
APPEND BLANK
IF !NETERR()
   RETURN .T.
ENDIF
MOUSE( DESLIGA )
SAVE SCREEN
MOUSE( LIGA )
MENSAGEM( "Aguarde tentativa de acesso ao arquivo" )
SEMPRE := ( TEMPO = 0 )
WHILE ( SEMPRE .OR. TEMPO > 0 )
   APPEND BLANK
   IF !NETERR()
MOUSE( DESLIGA )
      RESTORE SCREEN
MOUSE( LIGA )
      RETURN .T.
   ENDIF
   IF INKEY( 0.5 ) = T_ESC
      EXIT
   ENDIF
   TEMPO -= 0.5
ENDDO
MOUSE( DESLIGA )
RESTORE SCREEN
MOUSE( LIGA )
RETURN .F.
**
**BI [INI] FUN.B05
**BI [FIM] FUN.B05
**
 
/* Final do programa AGENDFU2.PRG */