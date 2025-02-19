
/*
TITULO     : Agenda de Telefone
DATA       : 13/02/25
PROGRAMA   : AGENDFU3.PRG
COMENTARIO : FUNCOES - PARTE 3
*/

#include "AGEND.CH"
#include "AGENDMOU.CH"

FUNCTION GERA_REL
LOCAL OPCAO_BOTAO, ARQUIVO, CONTAR, COR_GETS
COR_GETS := CONTECOR[ 8 ]
IF SUBS( CONTECOR[ 4 ], 4, 5 ) = SUBS( CONTECOR[ 8 ], 4, 5 )
   CONTECOR[ 8 ] := CONTECOR[ 2 ]
ENDIF
TEC_F10 := .F.
NOME_REL := SPACE( 8 )
GerRelatorio := ZERA_REL()
COR( "MENU" )
@ LIN_MENU, 00
@ LIN_MENU, 01 SAY "Utilitario ³ Gerador de relatorios"
JANELA( 02, 00, 23, 79, "Gerador de relatorios" )
COR( "GETS" )
@ 04, 04 SAY "Arq. Rel"
@ 04, 14 SAY "Nome relatorio"
@ 04, 36 SAY "Arq. DBF"
@ 04, 46 SAY "Cabecalho"
@ 07, 04 SAY "Indices"
@ 07, 28 SAY "Quebras"
@ 07, 37 SAY "Filtro"
@ 08, 46 SAY "Set filter"
@ 11, 46 SAY "Margem :"
@ 11, 63 SAY "Resumir :"
@ 14, 04 SAY "Ordem"
@ 14, 11 SAY "Descricao"
@ 14, 37 SAY "Conteudo"
@ 14, 54 SAY "Mascara"
@ 14, 68 SAY "Totaliza"
WHILE .T.
   EDITA_REL( .T. )
   @ 05, 04 GET NOME_REL PICT "@!" VALID V_NOMEREL()     // Arquivo de relatorio
   CURSOR( LIGA )
   READ
   CURSOR( DESLIGA )
   IF LASTKEY() = T_ESC
      FUNDO()
      EXIT
   ENDIF
   WHILE .T.
      SET KEY T_F10 TO TECLA_F10
      EDITA_REL()
      SET KEY T_F10 TO
      OPCAO_BOTAO := 1
      WHILE .T.
         botao:ADD( 21, 04, "Salvar  " )
         botao:ADD( 21, 16, "Abortar " )
         botao:ADD( 21, 28, "Imprimir" )
         botao:ADD( 21, 40, "Inserir menu [" + IIF( GerRelatorio[ 1 ], "Sim]",;
                    "N„o]" ) )
         botao:ADD( 21, 62, "Excluir menu" )
         OPCAO_BOTAO := botao:RODA( OPCAO_BOTAO )
         IF OPCAO_BOTAO = 0
            EXIT
         ENDIF
         IF OPCAO_BOTAO = 1
            ARQUIVO := TRIM( NOME_REL ) + ".REL"
            SET CONSOLE OFF
            SET ALTERNATE TO &ARQUIVO
            SET ALTERNATE ON
            ? "//"
            ? "// -> Se innsere no menu de relatorios"
            ? "[INS] " + IIF( GerRelatorio[ 1 ] = .T., "SIM", "NAO" )
            ? "//"
            ? "// -> Arquivo DBF"
            ? "[DBF] " + GerRelatorio[ 2 ]
            ? "//"
            ? "// -> Nome do relatorio"
            ? "[NOM] " + GerRelatorio[ 3 ]
            ? "//"
            ? "// -> Cabecalhos"
            FOR CONTAR := 1 TO 2
               ? "[CAB] " + GerRelatorio[ 4 ][ CONTAR ]
            NEXT
            ? "//"
            ? "// -> Indices"
            FOR CONTAR := 1 TO 5
               ? "[IND] " + GerRelatorio[ 5 ][ CONTAR ]
            NEXT
            ? "//"
            ? "// -> Quebras"
            ? "//    Ativar    Sub titulo                         Sub-totalizacao"
            FOR CONTAR := 1 TO 5
               ? "[QUE] " + IIF( GerRelatorio[ 6 ][ CONTAR ][ 1 ] = "A",;
                 "ATIVAR   ", "DESATIVAR" ) + " " +;
                 GerRelatorio[ 6 ][ CONTAR ][ 2 ] + " " +;
                 IIF( GerRelatorio[ 6 ][ CONTAR ][ 3 ] = "S", "SIM", "NAO" )
            NEXT
            ? "//"
            ? "// -> Filtragens"
            ? "//    Ativar    Sub titulo                Perguta ou filtro fixo        Operador logico"
            FOR CONTAR := 1 TO 5
               ? "[FIL] " + IIF( GerRelatorio[ 7 ][ CONTAR ][ 1 ] = "A",;
                 "ATIVAR   ", "DESATIVAR" ) + " " +;
                 GerRelatorio[ 7 ][ CONTAR ][ 2 ] + " " +;
                 GerRelatorio[ 7 ][ CONTAR ][ 3 ] + " " +;
                 GerRelatorio[ 7 ][ CONTAR ][ 4 ]
            NEXT
            ? "//"
            ? "// -> Set Filter"
            ? "[SET] " + GerRelatorio[ 8 ]
            ? "//"
            ? "// -> Margem"
            ? "[MAR] " + STRZERO( GerRelatorio[ 9 ], 3 )
            ? "//"
            ? "// -> Resumir"
            ? "[RES] " + IIF( GerRelatorio[ 10 ] = "S", "SIM", "NAO" )
            ? "//"
            ? "// -> Conteudo"
            ? "//    Descricao                      Conteudo                                 Mascara                   Totaliza"
            FOR CONTAR := 1 TO LEN( GerRelatorio[ 11 ] )
               ? "[CON] " + GerRelatorio[ 11 ][ CONTAR ][ 2 ] + " " +;
                 GerRelatorio[ 11 ][ CONTAR ][ 3 ] + " " +;
                 GerRelatorio[ 11 ][ CONTAR ][ 4 ] + " " +;
                 IIF( GerRelatorio[ 11 ][ CONTAR ][ 5 ] = "S", "SIM", "NAO" )
            NEXT
            ? "//"
            ? "// -> Fim do relatorio"
            SET ALTERNATE OFF
            SET ALTERNATE TO
            SET CONSOLE OFF
            FUNDO()
            CONTECOR[ 8 ] := COR_GETS
            RETURN NIL
         ENDIF
         IF OPCAO_BOTAO = 2
            FUNDO()
            CONTECOR[ 8 ] := COR_GETS
            RETURN NIL
         ENDIF
         IF OPCAO_BOTAO = 3
            RODA_REL()
         ENDIF
         IF OPCAO_BOTAO = 4
            GerRelatorio[ 1 ] := .T.
         ENDIF
         IF OPCAO_BOTAO = 5
            GerRelatorio[ 1 ] := .F.
         ENDIF
      ENDDO
   ENDDO
ENDDO
CONTECOR[ 8 ] := COR_GETS
RETURN NIL

FUNCTION RODA_REL
LOCAL ARQUIVO, CONTAR, TELA_REL, VAR, DADOS, CHAVE_INDICE := "", CONTADOR,;
      ORDEM := 0, AREA := 0, NTXS := "", FILTROS := {}, TIPO, DECIMAL,;
      LARGURA, ALTURA, TIPO_DATA := 0, LIN_SUPERIOR, LIN_INFERIOR, TAMANHO,;
      COL_ESQUERDA, COL_DIREITA, MASCARA, ULT_OPERADOR, OPERADORES
TELA_REL := SAVESCREEN( 00, 00, 24, 79 )
FOR CONTAR := 1 TO 5
   IF LEN( TRIM( GerRelatorio[ 5 ][ CONTAR ] ) ) > 0
      CHAVE_INDICE += TRIM( GerRelatorio[ 5 ][ CONTAR ] ) + "+"
   ENDIF
NEXT
IF LEN( TRIM( CHAVE_INDICE ) ) > 0
   CHAVE_INDICE := SUBS( CHAVE_INDICE, 1, LEN( CHAVE_INDICE ) - 1 )
   CONTAR := 0
   FOR CONTADOR := 1 TO LEN( IN_DICES )
      IF TRIM( IN_DICES[ CONTADOR ][ 2 ] ) == TRIM( GerRelatorio[ 2 ] ) .AND.;
         TRIM( IN_DICES[ CONTADOR ][ 3 ] ) == TRIM( CHAVE_INDICE )
         CONTAR := CONTADOR
         EXIT
      ENDIF
   NEXT
   IF CONTAR = 0
      FOR CONTADOR := 1 TO LEN( IN_DICES )
         IF TRIM( IN_DICES[ CONTADOR ][ 2 ] ) == TRIM( GerRelatorio[ 2 ] )
            ORDEM := IN_DICES[ CONTADOR ][ 5 ]
            AREA := IN_DICES[ CONTADOR ][ 4 ]
         ENDIF
      NEXT
      ORDEM++
      AADD( IN_DICES, { TRIM( NOME_REL ) + ".NTX",;
            TRIM( GerRelatorio[ 2 ] ), TRIM( CHAVE_INDICE ),;
            AREA, ORDEM } )
      NTXS += TRIM( NOME_REL )
   ELSE
      ORDEM := CONTAR
   ENDIF
ENDIF
VAR := TRIM( NOME_REL ) + ".NTX"
IF FILE( VAR )
   DELE FILE &VAR
ENDIF
INDICES()
MENSAGEM( "Aguarde abertura de arquivos" )
SELE 1
IF !USEREDE( "AGENDA", .F., 10 )
   BEEP()
   MENSAGEM( "O arquivo AGENDA n„o est  dispon¡vel", 3 )
   RETURN NIL
ELSE
   SET INDEX TO AGEND001,AGEND002,AGEND003,AGEND004
ENDIF
ARQUIVO := TRIM( GerRelatorio[ 2 ] )
SELE &ARQUIVO
IF LEN( TRIM( NTXS ) ) > 0
   DBSETINDEX( NTXS )
ENDIF
SET ORDER TO ORDEM
IF LEN( TRIM( GerRelatorio[ 8 ] ) ) > 0
   VAR := TRIM( GerRelatorio[ 8 ] )
   SET FILTER TO &VAR
ENDIF
FUNDO()
MENSAGEM( "Tecle <ESC> para retornar" )
COR( "MENU" )
@ LIN_MENU, 00
@ LIN_MENU, 01 SAY "Relat¢rio ³ " + GerRelatorio[ 3 ]
GOTO TOP
//
// -> Filtragem
FOR CONTAR := 1 TO 5
   IF GerRelatorio[ 7 ][ CONTAR ][ 1 ] = "A"
      IF !EMPTY( GerRelatorio[ 5 ][ CONTAR ] )
         DADOS := { TRIM( GerRelatorio[ 5 ][ CONTAR ] ),;
                    TRIM( GerRelatorio[ 7 ][ CONTAR ][ 2 ] ),;
                    TRIM( GerRelatorio[ 7 ][ CONTAR ][ 3 ] ),;
                    TRIM( GerRelatorio[ 7 ][ CONTAR ][ 4 ] ) }
         VAR := DADOS[ 1 ]
         TIPO := "C"
         DECIMAL := 0
         TIPO_DATA = 0
         IF SUBS( VAR, 1, 8 ) = "MES_ANO("
            TIPO_DATA = 0
            TIPO = "D"
         ELSEIF SUBS( VAR, 1, 5 ) = "DTOS("
            TIPO_DATA = 1
            TIPO = "D"
         ELSEIF SUBS( VAR, 1, 10 ) = "SUBS(DTOC(" .AND. AT( "),1,5)", VAR )
            TIPO_DATA = 2
            TIPO = "D"
         ELSEIF SUBS( VAR, 1, 10 ) = "SUBS(DTOC(" .AND. AT( "),4,2)", VAR )
            TIPO_DATA = 3
            TIPO = "D"
         ELSEIF SUBS( VAR, 1, 4 ) = "ANO("
            TIPO_DATA = 4
            TIPO = "D"
         ELSEIF SUBS( VAR, 1, 5 ) = "DTOC("
            TIPO_DATA = 5
            TIPO = "D"
         ELSEIF SUBS( VAR, 1, 4 ) = "IIF("
            TIPO = "L"
         ELSEIF SUBS( VAR, 1, 4 ) = "STR("
            TIPO = "N"
            CONTADOR := AT( ",", VAR )
            IF CONTADOR != 0
               VAR := SUBS( VAR, CONTADOR + 1 )
               CONTADOR := AT( ",", VAR )
               IF CONTADOR != 0
                  VAR := SUBS( VAR, CONTADOR + 1 )
                  DECIMAL := VAL( SUBS( VAR, 1, LEN( VAR ) - 1 ) )
               ENDIF
            ENDIF
         ENDIF
         VAR := DADOS[ 1 ]
         CONTADOR := LEN( &VAR )
         AADD( DADOS, TIPO )
         AADD( DADOS, CONTADOR )
         AADD( DADOS, DECIMAL )
         AADD( DADOS, TIPO_DATA )
         AADD( FILTROS, DADOS )
      ENDIF
   ENDIF
NEXT
LARGURA := 0
FOR CONTAR := 1 TO LEN( FILTROS )
   VAR := "FILTRO_" + STR( CONTAR, 1 )
   TIPO := FILTROS[ CONTAR ][ 5 ]
   CONTADOR := LEN( TRIM( FILTROS[ CONTAR ][ 3 ] ) ) + ;
               FILTROS[ CONTAR ][ 6 ] + 1
   IF CONTADOR > LARGURA
      LARGURA := CONTADOR
   ENDIF
   IF TIPO = "N"
      &VAR := 0
   ELSEIF TIPO = "D"
      &VAR := CTOD( "  /  /  " )
   ELSEIF TIPO = "L"
      &VAR = .T.
   ELSE
      &VAR := SPACE( FILTROS[ CONTAR ][ 6 ] )
   ENDIF
NEXT
IF LEN( FILTROS ) > 0
   ALTURA := LEN( FILTROS )
   ALTURA += ALTURA - 1
   ALTURA += 8
   LARGURA += 14
   IF LARGURA > 75; LARGURA := 76; ENDIF
   LIN_SUPERIOR := INT( ( 25 - ALTURA ) / 2 )
   LIN_INFERIOR := LIN_SUPERIOR + ALTURA - 1
   COL_ESQUERDA := INT( ( 80 - LARGURA ) / 2 )
   COL_DIREITA := COL_ESQUERDA + LARGURA - 1
   JANELA( LIN_SUPERIOR, COL_ESQUERDA, LIN_INFERIOR, COL_DIREITA )
   COR( "MENU" )
   @ LIN_SUPERIOR+3, COL_ESQUERDA+4 CLEAR TO LIN_INFERIOR-3, COL_DIREITA-4
   CONTADOR := LIN_SUPERIOR + 4
   FOR CONTAR := 1 TO LEN( FILTROS )
      VAR := "FILTRO_" + STR( CONTAR, 1 )
      MASCARA := ""
      TAMANHO := LEN( TRIM( FILTROS[ CONTAR ][ 3 ] ) ) + ;
                 FILTROS[ CONTAR ][ 6 ] + 1
      IF FILTROS[ CONTAR ][ 5 ] = "N"
         IF FILTROS[ CONTAR ][ 7 ] > 0
            MASCARA := REPL( "9", FILTROS[ CONTAR ][ 6 ] -;
                       FILTROS[ CONTAR ][ 7 ] - 1 ) + "." +;
                       REPL( "9", FILTROS[ CONTAR ][ 7 ] )
         ELSE
            MASCARA := REPL( "9", FILTROS[ CONTAR ][ 6 ] )
         ENDIF
      ELSEIF FILTROS[ CONTAR ][ 5 ] = "C"
         IF TAMANHO > LARGURA
            TAMANHO := TAMANHO - ( LEN( TRIM( FILTROS[ CONTAR ][ 3 ] ) ) - 15 )
            MASCARA := "@S" + ALLTRIM( STR( TAMANHO, 3 ) )
         ENDIF
      ENDIF
      IF LEN( TRIM( MASCARA ) ) = 0
         @ CONTADOR, COL_ESQUERDA + 7 SAY TRIM( FILTROS[ CONTAR ][ 3 ] );
           GET &VAR
      ELSE
         @ CONTADOR, COL_ESQUERDA + 7 SAY TRIM( FILTROS[ CONTAR ][ 3 ] );
           GET &VAR PICT MASCARA
      ENDIF
      CONTADOR += 2
   NEXT
   CURSOR( LIGA )
   READ
   CURSOR( DESLIGA )
   IF LASTKEY() = T_ESC
      IF LEN( TRIM( GerRelatorio[ 8 ] ) ) > 0
         ARQUIVO := TRIM( GerRelatorio[ 2 ] )
         SELE &ARQUIVO
         SET FILTER TO
   ENDIF
   CLOSE ALL
   RESTSCREEN( 00, 00, 24, 79, TELA_REL )
   COR( "GETS" )
   relatorio:LIMPA()
   RETURN NIL
   ENDIF
   NTXS := ""
   ULT_OPERADOR := ""
   CHAVE_INDICE := ""
   OPERADORES := ""
   FOR CONTAR := 1 TO LEN( FILTROS )
      VAR := "FILTRO_" + STR( CONTAR, 1 )
      CHAVE_INDICE += ULT_OPERADOR + TRIM( FILTROS[ CONTAR ][ 1 ] ) + " = "
      TIPO := FILTROS[ CONTAR ][ 5 ]
      IF TIPO = "D"
         IF TIPO_DATA = 0
            NTXS += MES_ANO( &VAR )
            CHAVE_INDICE += "MES_ANO( " + VAR + " )"
         ELSEIF TIPO_DATA = 1
            NTXS += DTOS( &VAR )
            CHAVE_INDICE += "DTOS( " + VAR + " )"
         ELSEIF TIPO_DATA = 2
            NTXS += SUBS(DTOC(&VAR),1,5)
            CHAVE_INDICE += "SUBS(DTOC(" + VAR + "),1,5)"
         ELSEIF TIPO_DATA = 3
            NTXS += SUBS(DTOC(&VAR ),4,2)
            CHAVE_INDICE += "SUBS(DTOC(" + VAR + " ),4,2)"
         ELSEIF TIPO_DATA = 4
            NTXS += ANO( &VAR )
            CHAVE_INDICE += "ANO( " + VAR + " )"
         ELSEIF NTXS += DTOC( &VAR )
            NTXS += DTOC( &VAR )
            CHAVE_INDICE += "DTOC( " + VAR + " )"
         ENDIF
      ELSEIF TIPO = "L"
         NTXS += IIF( &VAR, "T", "F" )
         CHAVE_INDICE += 'IIF( ' + VAR + ', "T", "F" )'
      ELSEIF TIPO = "N"
         NTXS += STR( &VAR, FILTROS[ CONTAR ][ 6 ], FILTROS[ CONTAR ][ 7 ] )
         CHAVE_INDICE += "STR( " + VAR + ", " +;
                      ALLTRIM( STR( FILTROS[ CONTAR ][ 6 ], 3 ) ) + ", " +;
                      ALLTRIM( STR( FILTROS[ CONTAR ][ 7 ], 3 ) ) + " )"
      ELSE
         NTXS += &VAR
         CHAVE_INDICE += VAR
      ENDIF
      ULT_OPERADOR := " " + TRIM( FILTROS[ CONTAR ][ 4 ] ) + " "
      OPERADORES := SUBS( FILTROS[ CONTAR ][ 4 ], 2, 1 )
   NEXT
   relatorio:FILTRO := CHAVE_INDICE
   OPERADORES := SUBS( OPERADORES, 1, LEN( OPERADORES ) - 1 )
   IF LEN( TRIM( OPERADORES ) ) > 0
      IF OPERADORES == REPL( "A", LEN( OPERADORES ) )
         SEEK NTXS
         IF EOF()
            BEEP(); MENSAGEM( "Registro n„o encontrado", 3 )
            IF LEN( TRIM( GerRelatorio[ 8 ] ) ) > 0
               ARQUIVO := TRIM( GerRelatorio[ 2 ] )
               SELE &ARQUIVO
               SET FILTER TO
            ENDIF
            CLOSE ALL
            RESTSCREEN( 00, 00, 24, 79, TELA_REL )
            COR( "GETS" )
            RETURN NIL
         ENDIF
      ELSE
         IF LEN( TRIM( GerRelatorio[ 8 ] ) ) > 0
            CHAVE_INDICE += " .AND. " + TRIM( GerRelatorio[ 8 ] )
         ENDIF
         SET FILTER TO &CHAVE_INDICE
         GO TOP
      ENDIF
   ELSE
      SEEK NTXS
      IF EOF()
         BEEP(); MENSAGEM( "Registro n„o encontrado", 3 )
         IF LEN( TRIM( GerRelatorio[ 8 ] ) ) > 0
            ARQUIVO := TRIM( GerRelatorio[ 2 ] )
            SELE &ARQUIVO
            SET FILTER TO
         ENDIF
         CLOSE ALL
         RESTSCREEN( 00, 00, 24, 79, TELA_REL )
         COR( "GETS" )
         RETURN NIL
      ENDIF
   ENDIF
ENDIF
NUM_RELATORIO := 0
relatorio:TIPO := COLUNAR_AUTOMATICO
AADD( ObjRelatorio[ _TITULOS ], TRIM( GerRelatorio[ 4 ][ 1 ] ) )
AADD( ObjRelatorio[ _TITULOS ], TRIM( GerRelatorio[ 4 ][ 2 ] ) )
FOR CONTAR := 1 TO 5
   IF !EMPTY( GerRelatorio[ 5 ][ CONTAR ] )
      IF GerRelatorio[ 6 ][ CONTAR ][ 1 ] = "A"
         DADOS := { TRIM( GerRelatorio[ 5 ][ CONTAR ] ),;
                    SALTA_2_LINHAS }
         IF LEN( TRIM( GerRelatorio[ 6 ][ CONTAR ][ 2 ] ) ) > 0
            AADD( DADOS, TRIM( GerRelatorio[ 6 ][ CONTAR ][ 2 ] ) )
         ENDIF
         IF GerRelatorio[ 6 ][ CONTAR ][ 3 ] = "S"
            AADD( DADOS, TOTALIZA_QUEBRA )
         ENDIF
         AADD( ObjRelatorio[ _QUEBRA ], DADOS )
      ENDIF
   ENDIF
NEXT
FOR CONTAR := 1 TO LEN( GerRelatorio[ 11 ] )
IF GerRelatorio[ 11 ][ CONTAR ][ 5 ] = "S"
   AADD( ObjRelatorio[ _TOTALIZA ],;
         { TRIM( GerRelatorio[ 11 ][ CONTAR ][ 3 ] ),;
           TRIM( GerRelatorio[ 11 ][ CONTAR ][ 3 ] ) } )
ENDIF
NEXT
IF GerRelatorio[ 10 ] = "S"
   IF LEN( TRIM( CHAVE_INDICE ) ) > 0
      relatorio:RESUMO := TRIM( CHAVE_INDICE )
   ENDIF
ENDIF
relatorio:COL_INICIAL := GerRelatorio[ 9 ]
FOR CONTAR := 1 TO 5
   IF GerRelatorio[ 7 ][ CONTAR ][ 1 ] = "A"
      AADD( ObjRelatorio[ _TITULOS ], "" )
      EXIT
   ENDIF
NEXT
FOR CONTAR := 1 TO 5
   VAR := "FILTRO_" + STR( CONTAR, 1 )
   IF GerRelatorio[ 7 ][ CONTAR ][ 1 ] = "A"
      AADD( ObjRelatorio[ _TITULOS ],;
            {  TRIM( GerRelatorio[ 7 ][ CONTAR ][ 2 ] ), VAR } )
   ENDIF
NEXT
FOR CONTAR := 1 TO LEN( GerRelatorio[ 11 ] )
   IF LEN( TRIM( GerRelatorio[ 11 ][ CONTAR ][ 4 ] ) ) > 0
      AADD( ObjRelatorio[ _CONTEUDO ], {;
            TRIM( GerRelatorio[ 11 ][ CONTAR ][ 2 ] ),;
            TRIM( GerRelatorio[ 11 ][ CONTAR ][ 3 ] ),;
            TRIM( GerRelatorio[ 11 ][ CONTAR ][ 3 ] ),;
            TRIM( GerRelatorio[ 11 ][ CONTAR ][ 4 ] ) } )
   ELSE
      AADD( ObjRelatorio[ _CONTEUDO ], {;
            TRIM( GerRelatorio[ 11 ][ CONTAR ][ 2 ] ),;
            TRIM( GerRelatorio[ 11 ][ CONTAR ][ 3 ] ),;
            TRIM( GerRelatorio[ 11 ][ CONTAR ][ 3 ] ) } )
   ENDIF
NEXT
relatorio:RODA()
ARQUIVO := TRIM( GerRelatorio[ 2 ] )
SELE &ARQUIVO
SET FILTER TO
CLOSE ALL
RESTSCREEN( 00, 00, 24, 79, TELA_REL )
COR( "GETS" )
RETURN NIL

FUNCTION TECLA_F10
TEC_F10 := .T.
KEYBOARD CHR( T_ENTER )
RETURN NIL

FUNCTION V_INDICES( NUM_VALID, PONTEIRO )
LOCAL ARQUIVOS, DADOS := {}, ESTRUTURA, VAR, INDICE := ROW() - 7,;
      OPCAO_FORMATO, GETLIST := {}, TELA_IND := SAVESCREEN( 00, 00, 24, 79 )
IF LASTKEY() = T_CIMA
   RETURN .T.
ENDIF
IF NUM_VALID = NIL; NUM_VALID := 0; ENDIF
IF NUM_VALID = 0
   VAR := "NAO EDITA"
ELSE
   VAR := CONTEUDO[ PONTEIRO ][ 3 ]
ENDIF
IF TEC_F10 .OR. EMPTY( VAR )
   TEC_F10 := .F.
   IF GerRelatorio[ 2 ] = "AGENDA  "
      ESTRUTURA := {}
      AADD( ESTRUTURA, { "SEQ_CODIGO", "C", 10,  0, "Id Sequencia" } )
      AADD( ESTRUTURA, { "NOME      ", "C", 40,  0, "Nome Completo" } )
      AADD( ESTRUTURA, { "CPF       ", "C", 11,  0, "CPF" } )
      AADD( ESTRUTURA, { "CELULAR   ", "C", 11,  0, "Celular" } )
      AADD( ESTRUTURA, { "NOMECONTAT", "C", 20,  0, "Pessoa Contato" } )
      AADD( ESTRUTURA, { "CELULAR1  ", "C", 11,  0, "Celular" } )
      AADD( ESTRUTURA, { "OBSERVACAO", "M", 10,  0, "Observacoes" } )
   ENDIF
   FOR CONTAR := 1 TO LEN( ESTRUTURA )
      VAR := ESTRUTURA[ CONTAR ][ 1 ] + " " + ESTRUTURA[ CONTAR ][ 2 ] + " " +;
             STRZERO( ESTRUTURA[ CONTAR ][ 3 ], 3 ) + " " +;
             STRZERO( ESTRUTURA[ CONTAR ][ 4 ], 3 )
      IF LEN( TRIM( ESTRUTURA[ CONTAR ][ 5 ] ) ) > 0
         VAR += " -> " + ESTRUTURA[ CONTAR ][ 5 ]
      ENDIF
      AADD( DADOS, " " + VAR + " " )
   NEXT
   CONTAR := EDITA_DADOS( DADOS, "Sele‡„o de ¡ndices" )
   IF CONTAR = 0
      RETURN .F.
   ENDIF
   VAR := TRIM( ESTRUTURA[ CONTAR ][ 1 ] )
   IF NUM_VALID = 0
      IF ESTRUTURA[ CONTAR ][ 2 ] = "D"
         OPCAO_FORMATO := EDITA_DADOS( { " Dia/Mes/Ano ", " Mes/Ano ",;
                          " Dia/Mes ", " Somente Mes ", " Somente Ano " },;
                          "Formato data" )
         IF OPCAO_FORMATO = 1
            VAR := "DTOS(" + VAR + ")"
         ELSEIF OPCAO_FORMATO = 2
            VAR := "MES_ANO(" + VAR + ")"
         ELSEIF OPCAO_FORMATO = 3
            VAR := "SUBS(DTOC(" + VAR + "),1,5)"
         ELSEIF OPCAO_FORMATO = 4
            VAR := "SUBS(DTOC(" + VAR + "),4,2)"
         ELSEIF OPCAO_FORMATO = 5
            VAR := "ANO(" + VAR + ")"
         ENDIF
      ELSEIF ESTRUTURA[ CONTAR ][ 2 ] = "N"
         VAR := "STR(" + VAR + "," +;
                ALLTRIM( STR( ESTRUTURA[ CONTAR ][ 3 ], 3 ) ) + "," +;
                ALLTRIM( STR( ESTRUTURA[ CONTAR ][ 4 ], 3 ) ) + ")"
      ELSEIF ESTRUTURA[ CONTAR ][ 2 ] = "L"
         VAR := 'IIF(' + VAR + ',"T","F")'
      ENDIF
      GerRelatorio[ 5 ][ INDICE ] := PADR( VAR, 25 )
      @ 07 + INDICE, 04 SAY GerRelatorio[ 5 ][ INDICE ] PICT "@S21";
                        COLOR CONTECOR[ 8 ]
   ELSE
      CONTEUDO[ PONTEIRO ][ 3 ] := PADR( VAR, 40 )
   ENDIF
ENDIF
IF NUM_VALID = 0
   IF !EMPTY( GerRelatorio[ 5 ][ INDICE ] )
      JANELA( 07, 07, 17, 73, "Edi‡„o de quebras e filtragens" )
      COR( "GETS" )
      VAR := "Indice : " + TRIM( GerRelatorio[ 5 ][ INDICE ] )
      @ 09, INT( ( 80 - LEN( VAR ) ) / 2 ) SAY VAR
      @ 11, 11 SAY "Quebra"
      @ 11, 22 SAY "Sub titulo"
      @ 11, 58 SAY "Sub totaliza"
      @ 14, 11 SAY "Filtragem"
      @ 14, 22 SAY "Sub titulo"
      @ 14, 39 SAY "Pergunta da filtragem"
      @ 14, 62 SAY "Operador"
      @ 12, 11 SAY IIF( GerRelatorio[ 6 ][ INDICE ][ 1 ] = "A", "Ativar   ",;
                        "Desativar" ) COLOR CONTECOR[ 8 ]
      @ 12, 62 SAY IIF( GerRelatorio[ 6 ][ INDICE ][ 3 ] = "S", "Sim", "N„o" );
                        COLOR CONTECOR[ 8 ]
      @ 15, 11 SAY IIF( GerRelatorio[ 7 ][ INDICE ][ 1 ] = "A", "Ativar   ",;
                        "Desativar" ) COLOR CONTECOR[ 8 ]
      @ 15, 62 SAY GerRelatorio[ 7 ][ INDICE ][ 4 ] COLOR CONTECOR[ 8 ]
      GerRelatorio[ 7 ][ INDICE ][ 4 ] :=;
                  IIF( GerRelatorio[ 7 ][ INDICE ][ 4 ] = ".AND.", "A", "O" )
      @ 12, 11 GET GerRelatorio[ 6 ][ INDICE ][ 1 ] PICT "!";
               VALID V_TABELAS( INDICE, 1 )
      @ 12, 22 GET GerRelatorio[ 6 ][ INDICE ][ 2 ];
               WHEN GerRelatorio[ 6 ][ INDICE ][ 1 ] = "A"
      @ 12, 62 GET GerRelatorio[ 6 ][ INDICE ][ 3 ] PICT "!";
               WHEN GerRelatorio[ 6 ][ INDICE ][ 1 ] = "A";
               VALID V_TABELAS( INDICE, 3 )
      @ 15, 11 GET GerRelatorio[ 7 ][ INDICE ][ 1 ] PICT "!";
               VALID V_TABELAS( INDICE, 4 )
      @ 15, 22 GET GerRelatorio[ 7 ][ INDICE ][ 2 ] PICT "@S15";
               WHEN GerRelatorio[ 7 ][ INDICE ][ 1 ] = "A"
      @ 15, 39 GET GerRelatorio[ 7 ][ INDICE ][ 3 ] PICT "@S21";
               WHEN GerRelatorio[ 7 ][ INDICE ][ 1 ] = "A";
               VALID V_TABELAS( INDICE, 5 )
      @ 15, 63 GET GerRelatorio[ 7 ][ INDICE ][ 4 ] PICT "!";
               WHEN GerRelatorio[ 7 ][ INDICE ][ 1 ] = "A";
               VALID V_TABELAS( INDICE, 6 )
      READ
      RESTSCREEN( 00, 00, 24, 79, TELA_IND )
      IF LASTKEY() = T_ESC
         RETURN .F.
      ENDIF
      GerRelatorio[ 7 ][ INDICE ][ 4 ] :=;
              IIF( GerRelatorio[ 7 ][ INDICE ][ 4 ] = "A", ".AND.", ".OR." )
      @ 07 + INDICE, 28 SAY IIF( GerRelatorio[ 6 ][ INDICE ][ 1 ] = "A",;
                        "Ativar ", "Desati." ) COLOR CONTECOR[ 8 ]
      @ 07 + INDICE, 36 SAY IIF( GerRelatorio[ 7 ][ INDICE ][ 1 ] = "A",;
                        "Ativar  ", "Desativ." ) COLOR CONTECOR[ 8 ]
   ENDIF
ENDIF
RETURN .T.

FUNCTION V_TABELAS( INDICE, NUM_VALID )
LOCAL CONTAR, VAR, DADOS, OK, LIN := ROW(), COL := COL() - 1,;
      TEXTO, BLOCO, L_IND, C_IND
IF NUM_VALID = 6; COL--; ENDIF
IF NUM_VALID = 1
   VAR := GerRelatorio[ 6 ][ INDICE ][ 1 ]
   DADOS := { " Ativar    ", " Desativar " }
   TEXTO := "Quebra"
   BLOCO := { | X | GerRelatorio[ 6 ][ INDICE ][ 1 ] := X }
ELSEIF NUM_VALID = 3
   VAR := GerRelatorio[ 6 ][ INDICE ][ 3 ]
   DADOS := { " Sim ", " N„o " }
   TEXTO := "Sub totaliza"
   BLOCO := { | X | GerRelatorio[ 6 ][ INDICE ][ 3 ] := X }
ELSEIF NUM_VALID = 4
   VAR := GerRelatorio[ 7 ][ INDICE ][ 1 ]
   DADOS := { " Ativar    ", " Desativar " }
   TEXTO := "Filtragem"
   BLOCO := { | X | GerRelatorio[ 7 ][ INDICE ][ 1 ] := X }
ELSEIF NUM_VALID = 5
   IF LASTKEY() != T_CIMA
      IF EMPTY( GerRelatorio[ 7 ][ INDICE ][ 3 ] )
         BEEP()
         MENSAGEM( "Preenchimento obrigatorio", 3 )
         RETURN .F.
      ENDIF
   ENDIF
   RETURN .T.
ELSEIF NUM_VALID = 6
   DADOS := { " .AND. ", " .OR.  " }
   VAR := GerRelatorio[ 7 ][ INDICE ][ 4 ]
   TEXTO := "Operador logico"
   BLOCO := { | X | GerRelatorio[ 7 ][ INDICE ][ 4 ] := X }
ELSEIF NUM_VALID = 7
   DADOS := { " Sim ", " N„o " }
   VAR := GerRelatorio[ 10 ]
   TEXTO := "Resumir"
   BLOCO := { | X | GerRelatorio[ 10 ] := X }
ELSEIF NUM_VALID = 8
   DADOS := { " Sim ", " N„o " }
   VAR := CONTEUDO[ INDICE ][ 5 ]
   TEXTO := "Totaliza‡„o"
   BLOCO := { | X | CONTEUDO[ INDICE ][ 5 ] := X }
ENDIF
IF NUM_VALID != 2 .AND. NUM_VALID != 5
   OK := .T.
   FOR CONTAR := 1 TO LEN( DADOS )
      IF VAR = SUBS( DADOS[ CONTAR ], IIF( NUM_VALID = 6, 3, 2 ), 1 )
         OK := .F.
         EXIT
      ENDIF
   NEXT
ENDIF
IF OK
   VAR := ""
ELSE
   @ LIN, COL SAY SUBS( DADOS[ CONTAR ] , 2, LEN( DADOS[ CONTAR ] ) - 2 );
              COLOR CONTECOR[ 8 ]
ENDIF
IF EMPTY( VAR ) .OR. TEC_F10
   TEC_F10 := .F.
   IF NUM_VALID < 7
      SOMBRA( L_IND := L_SOM, C_IND := C_SOM, .T. )
   ENDIF
   CONTAR := EDITA_DADOS( DADOS, TEXTO )
   IF NUM_VALID < 7
      SOMBRA( L_IND, C_IND )
   ENDIF
   IF CONTAR = 0
      RETURN .F.
   ENDIF
   EVAL( BLOCO, SUBS( DADOS[ CONTAR ], IIF( NUM_VALID = 6, 3, 2 ), 1 ) )
   @ LIN, COL SAY SUBS( DADOS[ CONTAR ] , 2, LEN( DADOS[ CONTAR ] ) - 2 );
              COLOR CONTECOR[ 8 ]
ENDIF
RETURN .T.

FUNCTION V_ARQDBF
LOCAL ARQUIVOS, NOM_ARQS
ARQUIVOS := { "AGENDA" }
NOM_ARQS := { " AGENDA.DBF -> Agenda de Telefones " }
IF EMPTY( GerRelatorio[ 2 ] ) .OR. TEC_F10
   TEC_F10 := .F.
   CONTAR := EDITA_DADOS( NOM_ARQS, "Sele‡„o de arquivos DBF" )
   IF CONTAR = 0
      RETURN .F.
   ENDIF
   GerRelatorio[ 2 ] := PADR( ARQUIVOS[ CONTAR ], 8 )
ELSE
   IF ASCAN( ARQUIVOS, TRIM( GerRelatorio[ 2 ] ) ) = 0
      BEEP()
      MENSAGEM( "Arquivo n„o faz parte deste aplicativo", 3 )
      RETURN .F.
   ENDIF
ENDIF
IF AT( ".", GerRelatorio[ 2 ] ) != 0
   BEEP()
   MENSAGEM( 'N„o pode existir o caracter "." no nome dos arquivos', 3 )
   RETURN .F.
ENDIF
RETURN .T.

FUNCTION V_NOMEREL
LOCAL CONTAR, VAR, CONTADOR, NOMES_REL
IF EMPTY( NOME_REL ) .OR. TEC_F10
   TEC_F10 := .F.
   CONTADOR := ADIR( "*.REL" )
   NOMES_REL := {}
   IF CONTADOR = 0
      BEEP()
      MENSAGEM( "N„o existem relatorios definidos", 3 )
      RETURN .F.
   ELSE
      DECLARE ARQS_REL[ CONTADOR ]
      ADIR( "*.REL", ARQS_REL )
      FOR CONTADOR := 1 TO LEN( ARQS_REL )
         VAR := MEMOLINE( MEMOREAD( ARQS_REL[ CONTADOR ] ), 80, 10 )
         AADD( NOMES_REL, " " + SUBS( VAR, 7, 30 ) + " " )
      NEXT
   ENDIF
   CONTAR := EDITA_DADOS( NOMES_REL, "Sele‡„o de relatorios" )
   IF CONTAR = 0
      RETURN .F.
   ENDIF
   NOME_REL := ARQS_REL[ CONTAR ]
   NOME_REL := PADR( SUBS( NOME_REL, 1, LEN( NOME_REL ) - 4 ), 8 )
   CLEAR GETS
ENDIF
IF !EMPTY( NOME_REL )
   LER_REL()
ENDIF
IF AT( ".", NOME_REL ) != 0
   BEEP()
   MENSAGEM( 'N„o pode existir o caracter "." no nome dos arquivos', 3 )
   RETURN .F.
ENDIF
RETURN .T.

FUNCTION LER_REL
LOCAL TAMANHO, DADOS, CONTAR, ARQUIVO, VAR, FUNCAO, G_CAB := 0,;
      G_IND := 0, G_QUE := 0, G_FIL := 0
GerRelatorio := ZERA_REL()
ARQUIVO := TRIM( NOME_REL ) + ".REL"
IF FILE( ARQUIVO  )
   DADOS := MEMOREAD( ARQUIVO )
ELSE
   RETURN .T.
ENDIF
TAMANHO := MLCOUNT( DADOS, 70 )
FOR CONTAR := 1 TO TAMANHO
   VAR := MEMOLINE( DADOS, 150, CONTAR )
   FUNCAO := SUBS( VAR, 1, 5 )
   IF FUNCAO = "[INS]"
      VAR := SUBS( VAR, 7, 3 )
      IF VAR = "SIM"
         GerRelatorio[ 1 ] := .T.
      ELSE
         GerRelatorio[ 1 ] := .F.
      ENDIF
   ELSEIF FUNCAO = "[DBF]"
      GerRelatorio[ 2 ] := SUBS( VAR, 7, 8 )
   ELSEIF FUNCAO = "[NOM]"
      GerRelatorio[ 3 ] := SUBS( VAR, 7, 30 )
   ELSEIF FUNCAO = "[CAB]"
      G_CAB++
      IF G_CAB <= 2
         GerRelatorio[ 4 ][ G_CAB ] := SUBS( VAR, 7, 60 )
      ENDIF
   ELSEIF FUNCAO = "[IND]"
      G_IND++
      IF G_IND <= 5
         GerRelatorio[ 5 ][ G_IND ] := SUBS( VAR, 7, 25 )
      ENDIF
   ELSEIF FUNCAO = "[QUE]"
      G_QUE++
      IF G_QUE <= 5
         GerRelatorio[ 6 ][ G_QUE ][ 1 ] := SUBS( VAR, 7, 1 )
         GerRelatorio[ 6 ][ G_QUE ][ 2 ] := SUBS( VAR, 17, 34 )
         GerRelatorio[ 6 ][ G_QUE ][ 3 ] := SUBS( VAR, 52, 1 )
      ENDIF
   ELSEIF FUNCAO = "[FIL]"
      G_FIL++
      IF G_FIL <= 5
         GerRelatorio[ 7 ][ G_FIL ][ 1 ] := SUBS( VAR, 7, 1 )
         GerRelatorio[ 7 ][ G_FIL ][ 2 ] := SUBS( VAR, 17, 25 )
         GerRelatorio[ 7 ][ G_FIL ][ 3 ] := SUBS( VAR, 43, 30 )
         GerRelatorio[ 7 ][ G_FIL ][ 4 ] := TRIM( SUBS( VAR, 74, 5 ) )
      ENDIF
   ELSEIF FUNCAO = "[SET]"
      GerRelatorio[ 8 ] := SUBS( VAR, 7, 40 )
   ELSEIF FUNCAO = "[MAR]"
      GerRelatorio[ 9 ] := VAL( SUBS( VAR, 7, 3 ) )
   ELSEIF FUNCAO = "[RES]"
      GerRelatorio[ 10 ] := SUBS( VAR, 7, 1 )
   ELSEIF FUNCAO = "[CON]"
      AADD( GerRelatorio[ 11 ], { LEN( GerRelatorio[ 11 ] ) + 1,;
            SUBS( VAR, 7, 30 ), SUBS( VAR, 38, 40 ), SUBS( VAR, 79, 25 ),;
            SUBS( VAR, 105, 1 ) } )
   ENDIF
NEXT
RETURN .T.

FUNCTION ZERA_REL
RETURN { .F.,;                             // 01 Se insere no menu
         SPACE( 8 ),;                      // 02 Arquivo DBF
         SPACE( 30 ),;                     // 03 Nome do relatorio
         { SPACE( 60 ), SPACE( 60 ) },;    // 04 Cabecalhos
         { SPACE( 25 ), SPACE( 25 ), SPACE( 25 ),;
         SPACE( 25 ), SPACE( 25 ) },;    // 05 Indices
         { { "D", SPACE( 34 ), "N" }, { "D", SPACE( 34 ), "N" },;
           { "D", SPACE( 34 ), "N" }, { "D", SPACE( 34 ), "N" },;
           { "D", SPACE( 34 ), "N" } },;   // 06 Quebras
         { { "D", SPACE( 25 ), SPACE( 30 ), ".AND." },;
           { "D", SPACE( 25 ), SPACE( 30 ), ".AND." },;
           { "D", SPACE( 25 ), SPACE( 30 ), ".AND." },;
           { "D", SPACE( 25 ), SPACE( 30 ), ".AND." },;
           { "D", SPACE( 25 ), SPACE( 30 ), ".AND." } },; // 07 Filtragem
         SPACE( 40 ),;                     // 08 Set Filter
         0,;                               // 09 Margem
         "N",;                             // 10 Resumir
         {} }                              // 11 Conteudo

FUNCTION EDITA_REL( EDITAR )
LOCAL CONTAR, PONTEIRO, POSICAO, DADOS
botao:ADD( 21, 04, "Salvar  " )
botao:ADD( 21, 16, "Abortar " )
botao:ADD( 21, 28, "Imprimir" )
botao:ADD( 21, 40, "Inserir menu [" + IIF( GerRelatorio[ 1 ], "Sim]",;
           "N„o]" ) )
botao:ADD( 21, 62, "Excluir menu" )
OPCAO_BOTAO := botao:MOSTRA()
WHILE .T.
   @ 05, 14 GET GerRelatorio[ 3 ] PICT "@S20" VALID;
                !EMPTY( GerRelatorio[ 3 ] )                   // Nome do relatorio
   @ 05, 36 GET GerRelatorio[ 2 ] PICT "@!" VALID V_ARQDBF()  // Arquivo DBF
   @ 05, 46 GET GerRelatorio[ 4 ][ 1 ] PICT "@S30"            // Cabecalho (1)
   @ 06, 46 GET GerRelatorio[ 4 ][ 2 ] PICT "@S30"            // Cabecalho (2)
   FOR CONTAR := 1 TO 5
      @ 07 + CONTAR, 04 GET GerRelatorio[ 5 ][ CONTAR ] PICT "@S21" VALID;
                        V_INDICES()                              // Indice
      IF LEN( TRIM( GerRelatorio[ 5 ][ CONTAR ] ) ) > 0
         @ 07 + CONTAR, 28 SAY IIF( GerRelatorio[ 6 ][ CONTAR ][ 1 ] = "A",;
                     "Ativar ", "Desati." ) COLOR CONTECOR[ 8 ]     // Quebra
         @ 07 + CONTAR, 36 SAY IIF( GerRelatorio[ 7 ][ CONTAR ][ 1 ] = "A",;
                     "Ativar  ", "Desativ." ) COLOR CONTECOR[ 8 ]   // Filtro
      ELSE
         @ 07 + CONTAR, 28 SAY SPACE( 7 ) COLOR CONTECOR[ 8 ]
         @ 07 + CONTAR, 36 SAY SPACE( 8 ) COLOR CONTECOR[ 8 ]
      ENDIF
   NEXT
   @ 09, 46 GET GerRelatorio[ 8 ] PICT "@S30"                     // Set Filter
   @ 11, 55 GET GerRelatorio[ 9 ] PICT "999" VALID;
            GerRelatorio[ 9 ] >= 0 .AND. GerRelatorio[ 9 ] <= 10  // Margem
   @ 11, 73 SAY IIF( GerRelatorio[ 10 ] = "S", "Sim",;
                "N„o" ) COLOR CONTECOR[ 8 ]                       // Resumir
   @ 11, 73 GET GerRelatorio[ 10 ] PICT "!" VALID V_TABELAS( 1, 7 )
   FOR CONTAR := 1 TO 5
      IF CONTAR <= LEN( GerRelatorio[ 11 ] )
         @ 14 + CONTAR, 04 SAY STRZERO( GerRelatorio[ 11 ][ CONTAR ][ 1 ], 5 );
                           COLOR CONTECOR[ 8 ]            // Ordem conteudo
         @ 14 + CONTAR, 11 SAY SUBS( GerRelatorio[ 11 ][ CONTAR ][ 2 ], 1, 24 );
                           COLOR CONTECOR[ 8 ]            // Descricao conteudo
         @ 14 + CONTAR, 37 SAY SUBS( GerRelatorio[ 11 ][ CONTAR ][ 3 ], 1, 15 );
                           COLOR CONTECOR[ 8 ]            // Conteudo
         @ 14 + CONTAR, 54 SAY SUBS( GerRelatorio[ 11 ][ CONTAR ][ 4 ], 1, 12 );
                           COLOR CONTECOR[ 8 ]            // Mascara
         @ 14 + CONTAR, 70 SAY IIF( GerRelatorio[ 11 ][ CONTAR ][ 5 ] = "S", "Sim",;
                           "N„o" ) COLOR CONTECOR[ 8 ]    // Totalizacao
      ELSE
         @ 14 + CONTAR, 04 SAY SPACE( 5 ) COLOR CONTECOR[ 8 ]
         @ 14 + CONTAR, 11 SAY SPACE( 24 ) COLOR CONTECOR[ 8 ]
         @ 14 + CONTAR, 37 SAY SPACE( 15 ) COLOR CONTECOR[ 8 ]
         @ 14 + CONTAR, 54 SAY SPACE( 12 ) COLOR CONTECOR[ 8 ]
         @ 14 + CONTAR, 70 SAY SPACE( 3 ) COLOR CONTECOR[ 8 ]
      ENDIF
   NEXT
   IF EDITAR = NIL
      CURSOR( LIGA )
      MOUSE( DESLIGA )
      READ
      MOUSE( LIGA )
      CURSOR( DESLIGA )
      IF LASTKEY() = T_ESC
         RETURN .F.
      ENDIF
   ELSE
      CLEAR GETS
      EXIT
   ENDIF
   PONTEIRO := 1
   POSICAO := 15
   CONTEUDO := {}
   FOR CONTAR := 1 TO LEN( GerRelatorio[ 11 ] )
      AADD( CONTEUDO, { GerRelatorio[ 11 ][ CONTAR ][ 1 ],;
                        GerRelatorio[ 11 ][ CONTAR ][ 2 ],;
                        GerRelatorio[ 11 ][ CONTAR ][ 3 ],;
                        GerRelatorio[ 11 ][ CONTAR ][ 4 ],;
                        GerRelatorio[ 11 ][ CONTAR ][ 5 ] } )
   NEXT
   WHILE .T.
      IF LEN( CONTEUDO ) < PONTEIRO
         AADD( CONTEUDO, { LEN( CONTEUDO ) + 1, SPACE( 30 ), SPACE( 40 ),;
                           SPACE( 25 ), "N" } )
      ENDIF
      @ POSICAO, 70 SAY IIF( CONTEUDO[ PONTEIRO ][ 5 ] = "S", "Sim", "N„o" );
                    COLOR CONTECOR[ 8 ]
      @ POSICAO, 04 SAY STRZERO( CONTEUDO[ PONTEIRO ][ 1 ], 5 );
                    COLOR CONTECOR[ 8 ]
      @ POSICAO, 11 GET CONTEUDO[ PONTEIRO ][ 2 ] PICT "@S24";
                    VALID !EMPTY( CONTEUDO[ PONTEIRO ][ 2 ] ) .OR.;
                    LASTKEY() = T_CIMA
      @ POSICAO, 37 GET CONTEUDO[ PONTEIRO ][ 3 ] PICT "@!S15";
                    VALID V_INDICES( 1, PONTEIRO  )
      @ POSICAO, 54 GET CONTEUDO[ PONTEIRO ][ 4 ] PICT "@S12"
      @ POSICAO, 70 GET CONTEUDO[ PONTEIRO ][ 5 ] PICT "!";
                    VALID V_TABELAS( PONTEIRO, 8 )
      CURSOR( LIGA )
      READEXIT( .T. )
      MOUSE( DESLIGA )
      READ
      MOUSE( LIGA )
      READEXIT( .F. )
      CURSOR( DESLIGA )
      IF LASTKEY() = T_ESC
         DADOS := {}
         FOR CONTAR := 1 TO LEN( CONTEUDO )
            IF LEN( TRIM( CONTEUDO[ CONTAR ][ 2 ] ) ) > 0 .AND.;
               LEN( TRIM( CONTEUDO[ CONTAR ][ 3 ] ) ) > 0
               AADD( DADOS, CONTEUDO[ CONTAR ] )
            ENDIF
         NEXT
         GerRelatorio[ 11 ] := DADOS
         RETURN .F.
      ENDIF
      IF LASTKEY() = T_CIMA
         IF PONTEIRO = 1
            DADOS := {}
            FOR CONTAR := 1 TO LEN( CONTEUDO )
               IF LEN( TRIM( CONTEUDO[ CONTAR ][ 2 ] ) ) > 0 .AND.;
                  LEN( TRIM( CONTEUDO[ CONTAR ][ 3 ] ) ) > 0
                  AADD( DADOS, CONTEUDO[ CONTAR ] )
               ENDIF
            NEXT
            GerRelatorio[ 11 ] := DADOS
            EXIT
         ENDIF
         POSICAO--
         PONTEIRO--
      ELSE
         POSICAO++
         PONTEIRO++
      ENDIF
      IF POSICAO > 19
         POSICAO := 19
         SCROLL( 15, 03, 19, 72, 1 )
         @ 19, 03 SAY SPACE( 70 ) COLOR CONTECOR[ 4 ]
      ENDIF
      IF POSICAO < 15
         POSICAO := 15
         SCROLL( 15, 03, 19, 72, -1 )
         @ 15, 03 SAY SPACE( 70 ) COLOR CONTECOR[ 4 ]
      ENDIF
   ENDDO
ENDDO
RETURN .T.
 
/* Final do programa AGENDFU3.PRG */