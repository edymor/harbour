
/*
TITULO     : Agenda de Telefone
DATA       : 13/02/25
PROGRAMA   : AGENDREL.PRG
COMENTARIO : MENU DE RELATORIOS
*/
 
#include "AGEND.CH"
#include "AGENDMOU.CH"
**
**BI [INI] REL.B01
**BI [FIM] REL.B01
**
LOCAL TAM_MENU, CONTADOR, OPCAO_REL, VAR, TEXTO
CONTADOR := ADIR( "*.REL" )
NOMES_REL := {}
ARQS_REL := {}
DADOS := {}
IF CONTADOR != 0
   DECLARE DADOS[ CONTADOR ]
   ADIR( "*.REL", DADOS )
   FOR CONTADOR := 1 TO LEN( DADOS )
      TEXTO := MEMOREAD( DADOS[ CONTADOR ] )
      VAR := MEMOLINE( TEXTO, 80, 4 )
      IF SUBS( VAR, 7, 1 ) = "S"
         VAR := MEMOLINE( TEXTO, 80, 10 )
         AADD( NOMES_REL, SUBS( VAR, 7, 30 ) )
         VAR := TRIM( DADOS[ CONTADOR ] )
         VAR := PADR( SUBS( VAR, 1, LEN( VAR ) - 4 ), 8 )
         AADD( ARQS_REL, VAR )
      ENDIF
   NEXT
ENDIF
MENSAGEM( "Tecle <ESC> para sair" )
menu:ADD( "Por Codigo", AGENDR01() )
menu:ADD( "Por Cpf", AGENDR02() )
menu:ADD( "Por Nome", AGENDR03() )
menu:ADD( "Por Celular", AGENDR04() )
menu:ADD( "Por Contato", AGENDR05() )
IF LEN( NOMES_REL ) > 0
   menu:ADD( "-" )
ENDIF
TAM_MENU := LEN( ObjMenu[ 2 ] )
FOR CONTADOR := 1 TO LEN( NOMES_REL )
   menu:ADD( NOMES_REL[ CONTADOR ] )
NEXT
OPCAO_REL := menu:RODA()
IF OPCAO_REL > TAM_MENU .AND. OPCAO_REL < 999
   OPCAO_REL -= TAM_MENU
   NOME_REL := ARQS_REL[ OPCAO_REL ]
   MENSAGEM( "Aguarde carregando relatorio " + TRIM( NOME_REL ) + ".REL" )
   GerRelatorio := ZERA_REL()
   LER_REL()
   RODA_REL()
ENDIF
CLOSE DATABASES
**
**BI [INI] REL.B02
**BI [FIM] REL.B02
**

FUNCTION IMP_REL
//
// -> Variaveis e vetores locais
LOCAL SAIDA := "S", LARGURA := 0, CONTAR, TAMANHO, TIPO, RESULTADO,;
      MAS_CARA, POSICAO, CORINGA, DIFERENCA, LOCALIZA, ADD_MASCARA,;
      FIL_TRA, CONTADOR, ACAO_MEMO := 1, INICIO, MAIOR_MEMO
//
// -> Variaveis e vetores private
PARA PROGRAMA, LINHA_PROG
TO_TALIZA := {}; CO_LUNAS := {}; RE_SUMO := {}; QUE_BRAS := {}
TOTALIZADOR := {}; CAMPOS_MEMO := {}; TAM_MEMO := {}; TOT_QUEBRA := {}
FOR CONTAR := 1 TO LEN( relatorio:QUEBRA )
   AADD( TOT_QUEBRA, {} )
NEXT
IF relatorio:TIPO = COLUNAR
   //
   // -> Ordena matriz de conteudo pelo posicionamento
   ASORT( relatorio:CONTEUDO,,, { | X, Y | X[ _COLUNA ] < Y[ _COLUNA ] } )
ENDIF
POSICAO := 01
//
// -> Inicia linha de impressao na margem superior
relatorio:LINHA := relatorio:LIN_SUPERIOR
MAS_CARA := IIF( relatorio:TIPO = COLUNAR, 5, 4 )
//
// -> Prepara dados recebidos no objeto para impressao
FOR CONTAR := 1 TO LEN( relatorio:CONTEUDO )
   IF relatorio:TIPO = COLUNAR
      IF relatorio:CONTEUDO[ CONTAR ][ _COLUNA ] +;
         LEN( relatorio:CONTEUDO[ CONTAR ][ _CABECALHO ] ) - 1 > LARGURA
         LARGURA := relatorio:CONTEUDO[ CONTAR ][ _COLUNA ] +;
                    LEN( relatorio:CONTEUDO[ CONTAR ][ _CABECALHO ] ) - 1
      ENDIF
   ENDIF
   IF NUM_RELATORIO = 0
      MACRO := relatorio:CONTEUDO[ CONTAR ][ _DADOS ]
      TIPO := VALTYPE( &MACRO )
   ELSE
      TIPO := VALTYPE( EVAL( relatorio:CONTEUDO[ CONTAR ][ _DADOS ] ) )
   ENDIF
   IF LEN( relatorio:CONTEUDO[ CONTAR ] ) = MAS_CARA
      IF NUM_RELATORIO = 0
         MACRO := relatorio:CONTEUDO[ CONTAR ][ _DADOS ]
         TAMANHO := LEN( TRANS( &MACRO, relatorio:CONTEUDO[ CONTAR ][ MAS_CARA ] ) )
      ELSE
         TAMANHO := LEN( TRANS( EVAL( relatorio:CONTEUDO[ CONTAR ][ _DADOS ] ),;
                         relatorio:CONTEUDO[ CONTAR ][ MAS_CARA ] ) )
      ENDIF
   ELSE
      IF TIPO = "N"
         TAMANHO := 10
      ELSEIF TIPO = "D"
         TAMANHO := 8
      ELSEIF TIPO = "L"
         TAMANHO := 3
      ELSEIF TIPO = "M"
         TAMANHO := relatorio:MEMO_LARGURA
      ELSE
         IF NUM_RELATORIO = 0
            MACRO := relatorio:CONTEUDO[ CONTAR ][ _DADOS ]
            TAMANHO := LEN( &MACRO )
         ELSE
            TAMANHO := LEN( EVAL( relatorio:CONTEUDO[ CONTAR ][ _DADOS ] ) )
         ENDIF
      ENDIF
   ENDIF
   IF relatorio:TIPO = COLUNAR
      IF relatorio:CONTEUDO[ CONTAR ][ _COLUNA ] + TAMANHO - 1 > LARGURA
         LARGURA := relatorio:CONTEUDO[ CONTAR ][ _COLUNA ] + TAMANHO - 1
      ENDIF
      AADD( CO_LUNAS, relatorio:CONTEUDO[ CONTAR ][ _COLUNA ] )
   ELSE
      IF TAMANHO < LEN( relatorio:CONTEUDO[ CONTAR ][ _CABECALHO ] )
         TAMANHO := LEN( relatorio:CONTEUDO[ CONTAR ][ _CABECALHO ] )
      ENDIF
      LARGURA += TAMANHO
      AADD( CO_LUNAS, POSICAO )
      POSICAO += relatorio:SEPARADOR + TAMANHO
   ENDIF
   //
   // -> Definicao de campos a serem resumidos (numericos)
   IF relatorio:RESUMO != NIL .AND. TIPO = "N"
      DIFERENCA := 0
      CORINGA := NIL
      IF LEN( relatorio:CONTEUDO[ CONTAR ] ) = MAS_CARA
         CORINGA := relatorio:CONTEUDO[ CONTAR ][ MAS_CARA ]
         CORINGA := STRTRAN( CORINGA, "#", "9" )
         LOCALIZA := AT( "9", CORINGA )
         IF LOCALIZA != 0
            IF AT( ",", CORINGA ) != 0
               ADD_MASCARA := SUBS( CORINGA, LOCALIZA, AT( ",",;
                                    CORINGA ) - LOCALIZA )
               IF LEN( ADD_MASCARA ) = 1
                  ADD_MASCARA := "99"; DIFERENCA := 2
               ELSEIF LEN( ADD_MASCARA ) = 2 .OR.;
                      LEN( ADD_MASCARA ) = 3
                  ADD_MASCARA := "9,9"; DIFERENCA := 3
               ENDIF
               IF DIFERENCA != 0
                  CORINGA := STUFF( CORINGA, LOCALIZA, 0, ADD_MASCARA )
               ENDIF
            ELSE
               IF LOCALIZA != 0
                  CORINGA := STUFF( CORINGA, LOCALIZA, 0, "99" )
                  DIFERENCA := 2
               ENDIF
            ENDIF
         ENDIF
      ENDIF
      CO_LUNAS[ CONTAR ] -= DIFERENCA
      IF CORINGA != NIL
         relatorio:CONTEUDO[ CONTAR ][ MAS_CARA ] := CORINGA
      ENDIF
      IF relatorio:CONTEUDO[ CONTAR ][ _CABECALHO ] != NIL
         relatorio:CONTEUDO[ CONTAR ][ _CABECALHO ] :=;
           SPACE( DIFERENCA ) + relatorio:CONTEUDO[ CONTAR ][ _CABECALHO ]
      ENDIF
      AADD( RE_SUMO, { relatorio:CONTEUDO[ CONTAR ][ _DADOS ], 0 } )
   ENDIF
NEXT
IF relatorio:TIPO = COLUNAR_AUTOMATICO
   LARGURA += ( LEN( relatorio:CONTEUDO ) - 1 ) * relatorio:SEPARADOR
ENDIF
IF LEN( relatorio:TITULOS ) > 1
   IF NUM_RELATORIO = 0
      IF LEN( relatorio:TITULOS[ 1 ] ) > LEN( relatorio:TITULOS[ 2 ] )
         TAMANHO := LEN( relatorio:TITULOS[ 1 ] )
      ELSE
         TAMANHO := LEN( relatorio:TITULOS[ 2 ] )
      ENDIF
   ELSE
      IF LEN( EVAL( relatorio:TITULOS[ 1 ] ) ) > LEN( EVAL( relatorio:TITULOS[ 2 ] ) )
         TAMANHO := LEN( EVAL( relatorio:TITULOS[ 1 ] ) )
      ELSE
         TAMANHO := LEN( EVAL( relatorio:TITULOS[ 2 ] ) )
      ENDIF
   ENDIF
ELSEIF LEN( relatorio:TITULOS ) = 1
   IF NUM_RELATORIO = 0
      TAMANHO := LEN( relatorio:TITULOS[ 1 ] )
   ELSE
      TAMANHO := LEN( EVAL( relatorio:TITULOS[ 1 ] ) )
   ENDIF
ELSE
   TAMANHO := 18
ENDIF
IF TAMANHO + 17 > LARGURA; LARGURA := TAMANHO + 17; ENDIF
relatorio:LARGURA := LARGURA
//
// -> Prepara dados referentes a campos do tipo MEMO
FOR CONTAR := 1 TO LEN( relatorio:CONTEUDO )
   IF NUM_RELATORIO = 0
       MACRO := relatorio:CONTEUDO[ CONTAR ][ _DADOS ]
      TIPO := VALTYPE( &MACRO )
   ELSE
      TIPO := VALTYPE( EVAL( relatorio:CONTEUDO[ CONTAR ][ _DADOS ] ) )
   ENDIF
   IF TIPO = "M"
      AADD( CAMPOS_MEMO,;
            { relatorio:CONTEUDO[ CONTAR ][ _DADOS ], CO_LUNAS[ CONTAR ] } )
   ENDIF
NEXT
//
// -> Prepara dados para totalizacao de campo numericos
IF LEN( relatorio:TOTALIZA ) = 0
   FOR CONTAR := 1 TO LEN( relatorio:CONTEUDO )
      IF NUM_RELATORIO = 0
         MACRO := relatorio:CONTEUDO[ CONTAR ][ _DADOS ]
         TIPO := VALTYPE( &MACRO )
      ELSE
         TIPO := VALTYPE( EVAL( relatorio:CONTEUDO[ CONTAR ][ _DADOS ] ) )
      ENDIF
      IF TIPO = "N"
         CORINGA := {}
         AADD( CORINGA, relatorio:CONTEUDO[ CONTAR ][ _DADOS ] )
         AADD( CORINGA, relatorio:CONTEUDO[ CONTAR ][ _DADOS + 1 ] )
         AADD( CORINGA, CO_LUNAS[ CONTAR ] )
         IF LEN( relatorio:CONTEUDO[ CONTAR ] ) = MAS_CARA
            AADD( CORINGA, relatorio:CONTEUDO[ CONTAR ][ MAS_CARA ] )
         ENDIF
         AADD( TOTALIZADOR, CORINGA )
      ENDIF
   NEXT
ELSE
   TOTALIZADOR := relatorio:TOTALIZA
ENDIF
FOR CONTAR := 1 TO LEN( TOTALIZADOR )
   IF NUM_RELATORIO = 0
      MACRO := TOTALIZADOR[ CONTAR ][ 1 ]
      TIPO := VALTYPE( &MACRO )
   ELSE
      TIPO := VALTYPE( EVAL( TOTALIZADOR[ CONTAR ][ 1 ] ) )
   ENDIF
   IF TIPO != "N"
      SETCOLOR( "W" )
      CLS
      ?
      ? "Tentativa de totalizar campo nao numerico"
      ?
      ? "Rotina -> " + PROGRAMA
      ? "Linha --> " + ALLTRIM( STR( LINHA_PROG ) )
      ?
      QUIT
   ENDIF
   IF relatorio:TIPO = COLUNAR_AUTOMATICO
      POSICAO := ASCAN( relatorio:CONTEUDO, { | X | UPPER( X[ 3 ] ) ==;
                 UPPER( TOTALIZADOR[ CONTAR ][ 2 ] ) } )
      IF POSICAO = 0
         SETCOLOR( "W" )
         CLS
         ?
         ? "Tentativa de totalizar campo nao posicionado para impressao"
         ?
         ? "Rotina -> " + PROGRAMA
         ? "Linha --> " + ALLTRIM( STR( LINHA_PROG ) )
         ?
         QUIT
      ENDIF
      DIFERENCA := 0; CORINGA := NIL
      IF LEN( relatorio:CONTEUDO[ POSICAO ] ) = MAS_CARA
         CORINGA := relatorio:CONTEUDO[ POSICAO ][ MAS_CARA ]
         CORINGA := STRTRAN( CORINGA, "#", "9" )
         LOCALIZA := AT( "9", CORINGA )
         IF LOCALIZA != 0
            IF AT( ",", CORINGA ) != 0
               ADD_MASCARA := SUBS( CORINGA, LOCALIZA, AT( ",",;
                                    CORINGA ) - LOCALIZA )
               IF LEN( ADD_MASCARA ) = 1
                  ADD_MASCARA := "99"; DIFERENCA := 2
               ELSEIF LEN( ADD_MASCARA ) = 2 .OR.;
                      LEN( ADD_MASCARA ) = 3
                  ADD_MASCARA := "9,9"; DIFERENCA := 3
               ENDIF
               IF DIFERENCA != 0
                  CORINGA := STUFF( CORINGA, LOCALIZA, 0, ADD_MASCARA )
               ENDIF
            ELSE
               IF LOCALIZA != 0
                  CORINGA := STUFF( CORINGA, LOCALIZA, 0, "99" )
                  DIFERENCA := 2
               ENDIF
            ENDIF
         ENDIF
      ENDIF
      AADD( TOTALIZADOR[ CONTAR ], CO_LUNAS[ POSICAO ] - DIFERENCA )
      IF CORINGA != NIL
         AADD( TOTALIZADOR[ CONTAR ], CORINGA )
      ENDIF
   ENDIF
   AADD( TO_TALIZA, 0 )
   FOR CONTADOR := 1 TO LEN( relatorio:QUEBRA )
      AADD( TOT_QUEBRA[ CONTADOR ], 0 )
   NEXT
NEXT
IF LEN( TOTALIZADOR ) > 0
   //
   // -> Em casos positivos de totalizacao diminuir 3 linhas da margem
   //    inferior para impressao dos totais
   relatorio:LIN_INFERIOR -= 3
ENDIF
FOR CONTAR := 1 TO LEN( relatorio:QUEBRA )
   IF NUM_RELATORIO = 0
      MACRO := relatorio:QUEBRA[ CONTAR ][ 1 ]
      AADD( QUE_BRAS, &MACRO )
   ELSE
      AADD( QUE_BRAS, EVAL( relatorio:QUEBRA[ CONTAR ][ 1 ] ) )
   ENDIF
NEXT
//
// -> Menu que permite direcionar a saida de impressao
relatorio:SAIDA := MENU_PRN()
IF relatorio:SAIDA = NIL
   MOUSE( DESLIGA )
   RESTSCREEN( LIN_MENU + 1, 00, 23, 79, TELA_PRI )
   MOUSE( LIGA )
   relatorio:LIMPA()
   RETURN
ENDIF
SET DEVI TO PRINT
//
// -> Executa funcao do usuario de inicio de relatorio
IF relatorio:INICIO_RELATORIO != NIL
   EVAL( relatorio:INICIO_RELATORIO )
ENDIF
//
// -> Inicio da impressao do relatorio
WHILE !EOF()
   //
   // -> Verifica se houve tentativa de interromper a impressao
   IF INKEY() = T_ESC
      SET DEVI TO SCREEN
      //
      // -> Permite interromper a impressao
      SAIDA := PERG( "Continua a impress„o ?" )
      MENSAGEM( "Tecle <ESC> para pausa ou interrup‡„o" )
      SET DEVI TO PRINT
      IF SAIDA = "N"; EXIT; ENDIF
   ENDIF
   IF relatorio:FILTRO != NIL
      IF NUM_RELATORIO = 0
         MACRO := relatorio:FILTRO
         IF !( &MACRO )
            TOTALIZE( .T. )
            EXIT
         ENDIF
      ELSE
         IF !( EVAL( relatorio:FILTRO ) )
            TOTALIZE( .T. )
            EXIT
         ENDIF
      ENDIF
   ENDIF
   //
   // -> Verifica se esta sendo impressa a primeira linha do relatorio
   IF relatorio:LINHA = relatorio:LIN_SUPERIOR
      IF relatorio:BLOCO_CABECALHO != NIL
         //
         // -> Executa bloco de desvio de cabecalho
         EVAL( relatorio:BLOCO_CABECALHO )
      ELSE
         //
         // -> Determina o tipo de caracter para impressao
         IF relatorio:SAIDA != "T"
            IF relatorio:REDUCAO != NIL
               @ 00, 01 SAY relatorio:REDUCAO
            ENDIF
            AJUSTE( relatorio:LARGURA, IIF( TIPO_FORMULARIO = "0", "80", "132" ) )
         ENDIF
         //
         // -> Imprime o cabecalho do relatorio
         IF LEN( relatorio:TITULOS ) > 0
            IF NUM_RELATORIO = 0
               @ relatorio:LINHA, 01 SAY relatorio:TITULOS[ 1 ]
            ELSE
               @ relatorio:LINHA, 01 SAY EVAL( relatorio:TITULOS[ 1 ] )
            ENDIF
         ENDIF
         @ relatorio:LINHA, relatorio:LARGURA - 13 SAY;
           "Pagina: " + STRZERO( relatorio:PAGINA, 4 )
         relatorio:PAGINA++
         IF LEN( relatorio:TITULOS ) > 1
            IF NUM_RELATORIO = 0
               @ ++relatorio:LINHA, 01 SAY relatorio:TITULOS[ 2 ]
            ELSE
               @ ++relatorio:LINHA, 01 SAY EVAL( relatorio:TITULOS[ 2 ] )
            ENDIF
         ENDIF
         @ relatorio:LINHA, relatorio:LARGURA - 13 SAY;
           "Data: " + DTOC( DAT_HOJE )
         //
         // -> Verifica se existem mais titulos a serem impresso
         FOR CONTAR := 3 TO LEN( relatorio:TITULOS )
            IF NUM_RELATORIO = 0
               IF VALTYPE( relatorio:TITULOS[ CONTAR ] ) = "A"
                  MACRO := relatorio:TITULOS[ CONTAR ][ 2 ]
                  @ ++relatorio:LINHA, 01 SAY relatorio:TITULOS[ CONTAR ][ 1 ]
                  @ relatorio:LINHA, LEN( relatorio:TITULOS[ CONTAR ][ 1 ] ) +;
                    2 SAY &MACRO
               ELSE
                  @ ++relatorio:LINHA, 01 SAY relatorio:TITULOS[ CONTAR ]
               ENDIF
            ELSE
               @ ++relatorio:LINHA, 01 SAY EVAL( relatorio:TITULOS[ CONTAR ] )
            ENDIF
         NEXT
         relatorio:LINHA++
         @ ++relatorio:LINHA, 01 SAY;
           REPL( relatorio:SEP_CABECALHO, relatorio:LARGURA )
         relatorio:LINHA++
         FOR CONTAR := 1 TO LEN( relatorio:CONTEUDO )
            IF relatorio:CONTEUDO[ CONTAR ][ _CABECALHO ] != NIL
               @ relatorio:LINHA, CO_LUNAS[ CONTAR ] SAY;
                 relatorio:CONTEUDO[ CONTAR ][ _CABECALHO ]
            ENDIF
         NEXT
         @ ++relatorio:LINHA, 01 SAY;
           REPL( relatorio:SEP_CABECALHO, relatorio:LARGURA )
         relatorio:LINHA++
         CORINGA := .F.
         //
         // -> Verifica a existencias de QUEBRAS com sub-titulos
         IF LEN( relatorio:QUEBRA ) > 0
            FOR CONTAR := 1 TO LEN( relatorio:QUEBRA )
               IF LEN( relatorio:QUEBRA[ CONTAR ] ) > 2
                  IF VALTYPE( relatorio:QUEBRA[ CONTAR ][ 3 ] ) = "C"
                     @ ++relatorio:LINHA, 01 SAY;
                       relatorio:QUEBRA[ CONTAR ][ 3 ]
                     @ relatorio:LINHA, LEN( relatorio:QUEBRA[ CONTAR ][ 3 ] ) + 2 SAY;
                       QUE_BRAS[ CONTAR ]
                     CORINGA := .T.
                  ENDIF
               ENDIF
            NEXT
            IF CORINGA; relatorio:LINHA += 2; ENDIF
         ENDIF
      ENDIF
   ENDIF
   //
   // -> Imprime a primeira linha de conteudo do registro. No caso de
   //    registros que contenham campos do tipo MEMO serao impressas
   //    linhas de acordo com o tamanho do maior campo MEMO
   IF ACAO_MEMO = 1
      TAM_MEMO := {}
      //
      // -> Verifica se o relatorio e' sintetico ( Resumido )
      IF relatorio:RESUMO != NIL
         IF NUM_RELATORIO = 0
            MACRO := relatorio:RESUMO
            FIL_TRA := &MACRO
         ELSE
            FIL_TRA := EVAL( relatorio:RESUMO )
         ENDIF
         FOR CONTAR := 1 TO LEN( RE_SUMO )
            RE_SUMO[ CONTAR ][ 2 ] := 0
         NEXT
         //
         // -> Processa resumo
         MACRO := relatorio:RESUMO
         WHILE FIL_TRA = IIF( NUM_RELATORIO > 0, EVAL( relatorio:RESUMO ),;
                              &MACRO ) .AND. !EOF()
            //
            // -> Pre conteudo
            FOR CONTAR := 1 TO LEN( relatorio:PRE_CONTEUDO )
               EVAL( relatorio:PRE_CONTEUDO[ CONTAR ] )
            NEXT
            //
            // -> Atualiza resumo
            FOR CONTAR := 1 TO LEN( RE_SUMO )
               IF NUM_RELATORIO = 0
                  MACRO := RE_SUMO[ CONTAR ][ 1 ]
                  RE_SUMO[ CONTAR ][ 2 ] += &MACRO
               ELSE
                  RE_SUMO[ CONTAR ][ 2 ] += EVAL( RE_SUMO[ CONTAR ][ 1 ] )
               ENDIF
            NEXT
            //
            // -> Atualiza totalizacao de relatorios resumidos
            FOR CONTAR := 1 TO LEN( TOTALIZADOR )
               IF NUM_RELATORIO = 0
                  MACRO := TOTALIZADOR[ CONTAR ][ _DADOS -1 ]
                  TO_TALIZA[ CONTAR ] += &MACRO
               ELSE
                  TO_TALIZA[ CONTAR ] += EVAL( TOTALIZADOR[ CONTAR ][ _DADOS -1 ] )
               ENDIF
               //
               // -> Atualiza sub-totalizacao das quebras
               FOR CONTADOR := 1 TO LEN( relatorio:QUEBRA )
                  IF NUM_RELATORIO = 0
                     MACRO := TOTALIZADOR[ CONTAR ][ _DADOS -1 ]
                     TOT_QUEBRA[ CONTADOR ][ CONTAR ] += &MACRO
                  ELSE
                     TOT_QUEBRA[ CONTADOR ][ CONTAR ] +=;
                       EVAL( TOTALIZADOR[ CONTAR ][ _DADOS -1 ] )
                  ENDIF
               NEXT
            NEXT
            IF NUM_RELATORIO = 0
               MACRO := relatorio:RESUMO
               FIL_TRA := &MACRO
            ENDIF
            SKIP
         ENDDO
         SKIP -1
         POSICAO := 1
         //
         // -> Imprime conteudo
         FOR CONTAR := 1 TO LEN( relatorio:CONTEUDO )
            IF NUM_RELATORIO = 0
               MACRO := relatorio:CONTEUDO[ CONTAR ][ _DADOS ]
               RESULTADO := &MACRO
               TIPO := VALTYPE( &MACRO )
            ELSE
               RESULTADO := EVAL( relatorio:CONTEUDO[ CONTAR ][ _DADOS ] )
               TIPO := VALTYPE( EVAL( relatorio:CONTEUDO[ CONTAR ][ _DADOS ] ) )
            ENDIF
            IF TIPO = "N"
               RESULTADO := RE_SUMO[ POSICAO ][ 2 ]
               POSICAO++
            ENDIF
            IF TIPO = "M"
               AADD( TAM_MEMO, MLCOUNT( RESULTADO, relatorio:MEMO_LARGURA ) )
               @ relatorio:LINHA, CO_LUNAS[ CONTAR ] SAY;
                 MEMOLINE( RESULTADO, relatorio:MEMO_LARGURA, 1 )
            ELSE
               IF LEN( relatorio:CONTEUDO[ CONTAR ] ) = MAS_CARA
                  @ relatorio:LINHA, CO_LUNAS[ CONTAR ] SAY;
                    RESULTADO PICT relatorio:CONTEUDO[ CONTAR ][ MAS_CARA ]
               ELSE
                  @ relatorio:LINHA, CO_LUNAS[ CONTAR ] SAY RESULTADO
               ENDIF
            ENDIF
         NEXT
      ELSE
         //
         // -> Pre conteudo
         FOR CONTAR := 1 TO LEN( relatorio:PRE_CONTEUDO )
            EVAL( relatorio:PRE_CONTEUDO[ CONTAR ] )
         NEXT
         //
         // -> Imprime o conteudo de relatorios nao resumidos
         FOR CONTAR := 1 TO LEN( relatorio:CONTEUDO )
            IF NUM_RELATORIO = 0
               MACRO := relatorio:CONTEUDO[ CONTAR ][ _DADOS ]
               RESULTADO := &MACRO
               TIPO := VALTYPE( &MACRO )
            ELSE
               RESULTADO := EVAL( relatorio:CONTEUDO[ CONTAR ][ _DADOS ] )
               TIPO := VALTYPE( EVAL( relatorio:CONTEUDO[ CONTAR ][ _DADOS ] ) )
            ENDIF
            IF TIPO = "M"
               AADD( TAM_MEMO, MLCOUNT( RESULTADO, relatorio:MEMO_LARGURA ) )
               @ relatorio:LINHA, CO_LUNAS[ CONTAR ] SAY;
                 MEMOLINE( RESULTADO, relatorio:MEMO_LARGURA, 1 )
            ELSE
               IF LEN( relatorio:CONTEUDO[ CONTAR ] ) = MAS_CARA
                  @ relatorio:LINHA, CO_LUNAS[ CONTAR ] SAY;
                    RESULTADO PICT relatorio:CONTEUDO[ CONTAR ][ MAS_CARA ]
               ELSE
                  @ relatorio:LINHA, CO_LUNAS[ CONTAR ] SAY;
                    RESULTADO
               ENDIF
            ENDIF
         NEXT
      ENDIF
      //
      // -> Somente para campos do tipo MEMO
      IF LEN( CAMPOS_MEMO ) != 0
         ACAO_MEMO++; INICIO := 2
      ENDIF
   ENDIF
   //
   // -> Em caso de campos do tipo MEMO imprime o restante do seu conteudo
   IF ACAO_MEMO = 2
      MAIOR_MEMO := 0
      FOR CONTAR := 1 TO LEN( TAM_MEMO )
         IF TAM_MEMO[ CONTAR ] > MAIOR_MEMO
            MAIOR_MEMO := TAM_MEMO[ CONTAR ]
         ENDIF
      NEXT
      FOR CONTADOR := INICIO TO MAIOR_MEMO
         relatorio:LINHA++
         FOR CONTAR := 1 TO LEN( CAMPOS_MEMO )
            IF NUM_RELATORIO = 0
               MACRO := CAMPOS_MEMO[ CONTAR ][ 1 ]
               RESULTADO := &MACRO
            ELSE
               RESULTADO := EVAL( CAMPOS_MEMO[ CONTAR ][ 1 ] )
            ENDIF
            @ relatorio:LINHA, CAMPOS_MEMO[ CONTAR ][ 2 ] SAY;
              MEMOLINE( RESULTADO, relatorio:MEMO_LARGURA, CONTADOR )
         NEXT
         IF relatorio:LINHA > relatorio:LIN_INFERIOR
            EXIT
         ENDIF
      NEXT
      IF CONTADOR < MAIOR_MEMO
         INICIO := CONTADOR + 1
      ELSE
         ACAO_MEMO := 3
      ENDIF
   ENDIF
   //
   // -> Atualiza Totalizacao de relatorios nao resumidos
   IF relatorio:RESUMO = NIL
      FOR CONTAR := 1 TO LEN( TOTALIZADOR )
         IF NUM_RELATORIO = 0
            MACRO := TOTALIZADOR[ CONTAR ][ _DADOS - 1 ]
            TO_TALIZA[ CONTAR ] += &MACRO
         ELSE
            TO_TALIZA[ CONTAR ] += EVAL( TOTALIZADOR[ CONTAR ][ _DADOS - 1 ] )
         ENDIF
         //
         // -> Atualizacao sub-totalizacao das quebras
         FOR CONTADOR := 1 TO LEN( relatorio:QUEBRA )
            IF NUM_RELATORIO = 0
               MACRO := TOTALIZADOR[ CONTAR ][ _DADOS - 1 ]
               TOT_QUEBRA[ CONTADOR ][ CONTAR ] += &MACRO
            ELSE
               TOT_QUEBRA[ CONTADOR ][ CONTAR ] +=;
                 EVAL( TOTALIZADOR[ CONTAR ][ _DADOS - 1 ] )
            ENDIF
         NEXT
      NEXT
   ENDIF
   IF LEN( CAMPOS_MEMO ) = 0
      //
      // -> Caso nao exista campos do tipo MEMO sendo impresso
      relatorio:LINHA++
      //
      // -> Funcao de usuario para pre skip
      IF relatorio:PRE_SKIP != NIL
         EVAL( relatorio:PRE_SKIP )
      ENDIF
      //
      SKIP
      //
      // -> Funcao de usuario para pos skip
      IF relatorio:POS_SKIP != NIL
         EVAL( relatorio:POS_SKIP )
      ENDIF
   ELSE
      //
      // -> Somente para campos do tipo MEMO
      IF ACAO_MEMO = 3
         relatorio:LINHA++
         // -> Funcao de usuario para pre skip
         IF relatorio:PRE_SKIP != NIL
            EVAL( relatorio:PRE_SKIP )
         ENDIF
         //
         SKIP
         //
         // -> Funcao de usuario para pos skip
         IF relatorio:POS_SKIP != NIL
            EVAL( relatorio:POS_SKIP )
         ENDIF
         ACAO_MEMO := 1
      ENDIF
   ENDIF
   //
   // -> Processa as quebras
   FOR CONTAR := LEN( relatorio:QUEBRA ) TO 1 STEP -1
      //
      // -> Verifica se houve uma quebra
      IF NUM_RELATORIO = 0
         MACRO := relatorio:QUEBRA[ CONTAR ][ 1 ]
      ENDIF
      IF QUE_BRAS[ CONTAR ] != IIF( NUM_RELATORIO = 0, &MACRO,;
         EVAL( relatorio:QUEBRA[ CONTAR ][ 1 ] ) )
         CORINGA := .F.
         RESULTADO := ""
         IF LEN( relatorio:QUEBRA[ CONTAR ] ) = 4
            CORINGA := .T.
            RESULTADO := relatorio:QUEBRA[ CONTAR ][ 3 ]
         ELSEIF LEN( relatorio:QUEBRA[ CONTAR ] ) = 3
            IF NUM_RELATORIO = 0
               MACRO := relatorio:QUEBRA[ CONTAR ][ 3 ]
               TIPO := VALTYPE( MACRO )
            ELSE
               TIPO := VALTYPE( relatorio:QUEBRA[ CONTAR ][ 3 ] )
            ENDIF
            IF TIPO = "L"
               CORINGA := .T.
            ELSE
               RESULTADO := relatorio:QUEBRA[ CONTAR ][ 3 ]
            ENDIF
         ENDIF
         IF CORINGA = .T.
            //
            // -> Imprime subtotalizacao da quebra
            @ relatorio:LINHA, 01 SAY REPL( relatorio:SEP_CABECALHO, relatorio:LARGURA )
            @ ++relatorio:LINHA, 01 SAY relatorio:TIT_SUBTOTAL_QUEBRA
            FOR CONTADOR := 1 TO LEN( TOTALIZADOR )
               IF LEN( TOTALIZADOR[ CONTADOR ] ) = 4
                  @ relatorio:LINHA, TOTALIZADOR[ CONTADOR ][ _COLUNA - 1 ] SAY;
                    TOT_QUEBRA[ CONTAR ][ CONTADOR ];
                    PICT TOTALIZADOR[ CONTADOR ][ 4 ]
               ELSE
                  @ relatorio:LINHA, TOTALIZADOR[ CONTADOR ][ _COLUNA - 1 ] SAY;
                    TOT_QUEBRA[ CONTAR ][ CONTADOR ]
               ENDIF
               //
               // -> Zera sub-total da quebra
               TOT_QUEBRA[ CONTAR ][ CONTADOR ] := 0
            NEXT
         ENDIF
         IF relatorio:QUEBRA[ CONTAR ][ 2 ] = SALTA_PAGINA
            relatorio:LINHA := relatorio:LIN_INFERIOR + 1
         ELSE
            relatorio:LINHA += relatorio:QUEBRA[ CONTAR ][ 2 ]
            IF LEN( TRIM( RESULTADO ) ) > 0 .AND. !EOF()
               @ ++relatorio:LINHA, 01 SAY RESULTADO
               IF NUM_RELATORIO = 0
                  MACRO := relatorio:QUEBRA[ CONTAR ][ 1 ]
                  @ relatorio:LINHA, LEN( RESULTADO ) + 2 SAY &MACRO
               ELSE
                  @ relatorio:LINHA, LEN( RESULTADO ) + 2;
                    SAY EVAL( relatorio:QUEBRA[ CONTAR ][ 1 ] )
               ENDIF
               relatorio:LINHA += 2
            ENDIF
         ENDIF
         //
         // -> Reatualiza vetores para reiniciar uma quebra
         FOR CONTADOR := CONTAR TO LEN( relatorio:QUEBRA )
            IF NUM_RELATORIO = 0
               MACRO := relatorio:QUEBRA[ CONTADOR ][ 1 ]
               QUE_BRAS[ CONTADOR ] = &MACRO
            ELSE
               QUE_BRAS[ CONTADOR ] = EVAL( relatorio:QUEBRA[ CONTADOR ][ 1 ] )
            ENDIF
            AFILL( TOT_QUEBRA[ CONTADOR ], 0 )
         NEXT
      ENDIF
   NEXT
   //
   // -> Verifica se a impressao ultrapassa a margem inferior ou se o
   //    final do arquivo foi encontrado
   IF relatorio:LINHA > relatorio:LIN_INFERIOR .OR. EOF()
      //
      // Imprime a totalizacao
      TOTALIZE()
      //
      // -> Reinicia controle de linha
      relatorio:LINHA := relatorio:LIN_SUPERIOR
   ENDIF
ENDDO
//
// -> Funcao do usuario para saida do relatorio
IF relatorio:FIM_RELATORIO != NIL
   EVAL( relatorio:FIM_RELATORIO )
ENDIF
//
EJECT
SET DEVI TO SCREEN
IF relatorio:SAIDA = "A"
   SET PRINTER TO
ELSEIF relatorio:SAIDA = "T" .AND. SAIDA = "S"
   SET PRINTER TO
   //
   // -> Mostra relatorio na tela
   IMP_TELA( relatorio:LARGURA + 1 )
ENDIF
relatorio:LIMPA()
RETURN NIL

FUNCTION TOTALIZE( TOT_OU_SUB )
IF LEN( relatorio:TOTALIZA ) = 0; RETURN NIL; ENDIF
IF TOT_OU_SUB = NIL; TOT_OU_SUB := EOF(); ENDIF
//
// -> Verifica se esta configuarada a impressao de sub-totais
IF !TOT_OU_SUB .AND. relatorio:SUB_TOTALIZACAO = NAO
   RETURN NIL
ENDIF
//
// -> Em caso de total final salta para o fim da folha
IF TOT_OU_SUB .AND. relatorio:LINHA < relatorio:LIN_INFERIOR + 1
   relatorio:LINHA := relatorio:LIN_INFERIOR + 1
ENDIF
@ relatorio:LINHA, 01 SAY;
  REPL( relatorio:SEP_CABECALHO, relatorio:LARGURA )
relatorio:LINHA++
//
// -> Imprime os sub-titulos de totalizacao
IF TOT_OU_SUB
   @ relatorio:LINHA, 01 SAY relatorio:TITULO_TOTAL
ELSE
   @ relatorio:LINHA, 01 SAY relatorio:TITULO_SUB_TOTAL
ENDIF
//
// -> Imprime o conteudo da totalizacao
FOR CONTAR := 1 TO LEN( TOTALIZADOR )
   IF LEN( TOTALIZADOR[ CONTAR ] ) = 4
      @ relatorio:LINHA, TOTALIZADOR[ CONTAR ][ _COLUNA - 1 ] SAY;
        TO_TALIZA[ CONTAR ] PICT TOTALIZADOR[ CONTAR ][ 4 ]
   ELSE
      @ relatorio:LINHA, TOTALIZADOR[ CONTAR ][ _COLUNA - 1 ] SAY;
        TO_TALIZA[ CONTAR ]
   ENDIF
NEXT
@ ++relatorio:LINHA, 01 SAY;
  REPL( relatorio:SEP_CABECALHO, relatorio:LARGURA )
RETURN NIL

FUNCTION IMP_FICHA
RETURN NIL

FUNCTION IMP_ETQ
RETURN NIL
 
/* Final do programa AGENDREL.PRG */