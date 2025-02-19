
/*
TITULO     : Agenda de Telefone
DATA       : 13/02/25
PROGRAMA   : AGENDI01.PRG
COMENTARIO : CADASTRO (Agenda)
*/
 
#include "AGEND.CH"
#include "AGENDMOU.CH"
**
**BI [INI] I01.B01
**BI [FIM] I01.B01
**
LOCAL CONTAR
RE_GISTROS := {}
MENSAGEM( "Aguarde abertura de arquivos" )
SELE 1
IF !USEREDE( "AGENDA", .F., 10 )
   BEEP()
   MENSAGEM( "O arquivo AGENDA n„o est  dispon¡vel", 3 )
   RETURN
ELSE
   SET INDEX TO AGEND001, AGEND002, AGEND003, AGEND004
ENDIF
IF !REDE_CONTROLE()
   BEEP()
   MENSAGEM( "O arquivo AGEND.RED n„o est  dispon¡vel", 3 )
   RETURN
ENDIF
SELE AGENDA  
**
**BI [INI] I01.B02
**BI [FIM] I01.B02
**
***
*** Inicio do bloco de substitui‡„o I01.B
COR( "MENU" )
@ LIN_MENU, 00
@ LIN_MENU, 01 SAY "Cadastro ³ Agenda"
M->DU_PLICIDADE := .F.; M->MOSTRA_RESULTADO := .F.
M->RE_PETICAO := .T.
M->IN_CLUIR := .T.
PRIVATE ME_MO, SEQ_CODIGO, NOME, CPF, CELULAR, NOMECONTAT, CELULAR1, OBSERVACAO
WHILE .T.
   **
   **BI [INI] I01.B03
   **BI [FIM] I01.B03
   **
   MENSAGEM( "Tecle <ESC> para retornar" )
   IF !( M->DU_PLICIDADE )
      **
      **BI [INI] I01.B04
      **BI [FIM] I01.B04
      **
      IF M->RE_PETICAO
         IF M->CNF_REP
            M->RE_PETICAO := .F.
         ENDIF
         //
         // -> Inicializa variaveis
         CARREG01( INCLUSAO )
      ELSE
         M->MOSTRA_RESULTADO := .T.
      ENDIF
   ELSE
      M->MOSTRA_RESULTADO := .T.
      **
      **BI [INI] I01.B05
      **BI [FIM] I01.B05
      **
   ENDIF
   //
   // -> Carrega tela de cadastro
   IF CARGET01( IIF( M->AL_TERAR, ALTERACAO, INCLUSAO ) ) = .F.
      IF M->AL_TERAR
         **
         **BI [INI] I01.B06
         **BI [FIM] I01.B06
         **
         CARREG01( ALTERACAO )
         M->MOSTRA_RESULTADO = .T.
         CARGET01( MOSTRA_PAG_1 )
         BEEP()
         IF PERG( "Registro j  cadastrado. Deseja alterar ?" ) = "S"
            **
            **BI [INI] I01.B07
            **BI [FIM] I01.B07
            **
            M->IN_CLUIR := .F.; M->DU_PLICIDADE := .T.
         ELSE
            **
            **BI [INI] I01.B08
            **BI [FIM] I01.B08
            **
            M->AL_TERAR := .F.
         ENDIF
         LOOP
      ENDIF
      **
      **BI [INI] I01.B09
      **BI [FIM] I01.B09
      **
      EXIT
   ENDIF
   **
   **BI [INI] I01.B10
   **BI [FIM] I01.B10
   **
   IF PERG( "Confirma as informa‡”es ?" ) = "N"
      //
      // -> Faz reedicao
      M->DU_PLICIDADE := .T.
      **
      **BI [INI] I01.B11
      **BI [FIM] I01.B11
      **
      LOOP
   ENDIF
   M->DU_PLICIDADE := .F.
   M->MOSTRA_RESULTADO := .F.
   **
   **BI [INI] I01.B12
   **BI [FIM] I01.B12
   **
   IF M->IN_CLUIR
      IF !ADIREG( 0 )
         M->DU_PLICIDADE := .T.
         MENSAGEM( "Inclus„o n„o foi bem sucedida", 3 )
         LOOP
      ENDIF
   ELSE
      IF !REGLOCK( 20 )
         BEEP()
         MENSAGEM( "Atualiza‡„o n„o foi bem sucedida", 5 )
         LOOP
      ENDIF
   ENDIF
   //
   // -> Atualiza o banco de dados
   SALVAR01()
   COMMIT
   UNLOCK
   IF !( M->IN_CLUIR )
      M->IN_CLUIR := .T.
   ENDIF
ENDDO
SELE 100
FOR CONTAR := 1 TO LEN( RE_GISTROS )
   GOTO RE_GISTROS[ CONTAR ]
   IF REGLOCK( 2 )
      DELE
      UNLOCK
   ENDIF
NEXT
MOUSE( DESLIGA )
RESTSCREEN( LIN_MENU + 1, 00, 23, 79, TELA_PRI )
MOUSE( LIGA )
**
**BI [INI] I01.B13
**BI [FIM] I01.B13
**
*** Final do bloco de substitui‡„o I01.B
***
 
FUNCTION VERI001( TIPO_ACAO )
//
// -> Funcao que verifica duplicidade no arquivo "AGENDA"
LOCAL REGISTRO := RECN(), ORDEM := INDEXORD()
IF LASTKEY() = T_CIMA; RETURN .T.; ENDIF
SET ORDER TO 4
SEEK M->SEQ_CODIGO
IF REGISTRO = RECN() .AND. TIPO_ACAO = ALTERACAO
   SET ORDER TO ORDEM
   RETURN .T.
ENDIF
IF !EOF()
   IF TIPO_ACAO = ALTERACAO
      BEEP(); MENSAGEM( "Registro j  cadastrado", 3 )
      GOTO REGISTRO
      RETURN .F.
   ELSE
      M->AL_TERAR := .T.
      CLEAR GETS
      SET ORDER TO ORDEM
      RETURN .T.
   ENDIF
ELSE
   IF TIPO_ACAO = INCLUSAO
      AREA_ARQ := ALLTRIM( STR( SELECT(), 5 ) )
      SELE 100
      SEEK PADR( "001" + M->SEQ_CODIGO, 100 )
      IF EOF()
         IF ADIREG( 0 )
            REPLACE DADOS WITH PADR( "001" + M->SEQ_CODIGO, 100 )
            COMMIT
            UNLOCK
            AADD( RE_GISTROS, RECN() )
         ENDIF
      ELSE
         IF ASCAN( RE_GISTROS, RECN() ) = 0
            BEEP(); MENSAGEM( "Registro sendo cadastrado em outro terminal", 3 )
            SELE &AREA_ARQ
            RETURN .F.
         ENDIF
      ENDIF
      SELE &AREA_ARQ
   ENDIF
ENDIF
SET ORDER TO ORDEM
GOTO REGISTRO
RETURN .T.
 
FUNCTION IFU01002( VALIDA )
//
// -> Pos validacao ( Valid ) para o campo NOME
IF VALIDA = NIL; VALIDA := .T.; ENDIF
IF VALIDA
   IF !( .NOT.EMPTY(M->NOME)) .AND. LASTKEY() != T_CIMA
      BEEP()
      MENSAGEM( "Nome no pode ser vazio", 3 )
      RETURN .F.
   ENDIF
ENDIF
RETURN .T.
 
FUNCTION IFU01003( VALIDA )
//
// -> Pos validacao ( Valid ) para o campo CPF
IF VALIDA = NIL; VALIDA := .T.; ENDIF
IF VALIDA
   IF !( .NOT.EMPTY(M->CPF) .AND. CIC(M->CPF)) .AND. LASTKEY() != T_CIMA
      BEEP()
      MENSAGEM( "Cpf nao pode ser vazio ou CPF Invalido", 3 )
      RETURN .F.
   ENDIF
ENDIF
RETURN .T.
 
FUNCTION CARREG01( TIPO_ACAO )
//
// -> Carrega variaveis para entrada ou altercao de dados
**
**BI [INI] I01.B14
**BI [FIM] I01.B14
**
M->ME_MO := "[memo]"
IF TIPO_ACAO = INCLUSAO
   GOTO BOTT
   SKIP
ENDIF
M->SEQ_CODIGO := AGENDA->SEQ_CODIGO
M->NOME := AGENDA->NOME
M->CPF := AGENDA->CPF
M->CELULAR := AGENDA->CELULAR
M->NOMECONTAT := AGENDA->NOMECONTAT
M->CELULAR1 := AGENDA->CELULAR1
M->OBSERVACAO := AGENDA->OBSERVACAO
//
// -> Codigo automatico
IF TIPO_ACAO = INCLUSAO
AREA_ARQ := ALLTRIM( STR( SELECT(), 5 ) )
   SET ORDER TO 4
   GOTO BOTT
   M->SEQ_CODIGO := STRZERO( VAL( FIELD->SEQ_CODIGO ) + 1, 10 )
   SELE 100
   WHILE .T.
      SEEK PADR( "001" + M->SEQ_CODIGO, 100 )
      IF EOF()
         IF ADIREG( 0 )
            REPLACE DADOS WITH PADR( "001" + M->SEQ_CODIGO, 100 )
            COMMIT
            UNLOCK
            AADD( RE_GISTROS, RECN() )
         ENDIF
         EXIT
      ELSE
         M->SEQ_CODIGO := STRZERO( VAL( M->SEQ_CODIGO ) + 1, 10 )
      ENDIF
   ENDDO
   SELE &AREA_ARQ
ENDIF
**
**BI [INI] I01.B16
**BI [FIM] I01.B16
**
 
FUNCTION CARGET01( TIPO_ACAO )
//
// -> Formata a tela para entrada ou alteracao de dados
IF TIPO_ACAO != MOSTRA_PAG_1
   M->AL_TERAR := .F.
ENDIF
**
**BI [INI] I01.B17
**BI [FIM] I01.B17
**
JANELA( 3, 3, 21, 77, "Agenda" )
**
**BI [INI] I01.B18
**BI [FIM] I01.B18
**
COR( "GETS" )
**
**BI [INI] I01.B21
**BI [FIM] I01.B21
**
//
// -> Monta tela de cadastro
@  6,  9 SAY "C¢digo" GET M->SEQ_CODIGO PICTURE "9999999999" VALID VERI001( TIPO_ACAO )
@  7, 11 SAY "Nome" GET M->NOME PICTURE "@!" VALID IFU01002()
@  8, 12 SAY "Cpf" GET M->CPF PICTURE "@R 999.999.999-99" VALID IFU01003()
@  9,  8 SAY "Celular" GET M->CELULAR PICTURE "@R (#99#) #99.9999"
@ 10,  8 SAY "Contato" GET M->CELULAR1 PICTURE "@R (#99#) #99.9999"
@ 10, 32 SAY "Nome Contato" GET M->NOMECONTAT PICTURE "@!"
@ 11,  4 SAY "Observacoes" GET ME_MO PICT "9memo]" VALID EDITOR( @OBSERVACAO, "Observacoes" )
**
**BI [INI] I01.B24
**BI [FIM] I01.B24
**
IF TIPO_ACAO = MOSTRA_PAG_1
   CLEAR GETS
   RETURN .F.
ENDIF
IF TIPO_ACAO = CONSULTA .OR. TIPO_ACAO = EXCLUSAO
   CLEAR GETS
   IF TIPO_ACAO = EXCLUSAO
      RETURN .T.
   ENDIF
   MENSAGEM( "Tecle algo para continuar" )
   IF TEC_MOU( 0 ) = T_ESC
      RETURN .F.
   ENDIF
   EDITOR( OBSERVACAO, "Observacoes", .F. )
ELSE
   CURSOR( LIGA )
   READ
   CURSOR( DESLIGA )
   IF M->AL_TERAR
      RETURN .F.
   ENDIF
   IF LASTKEY() = T_ESC
      RETURN .F.
   ENDIF
ENDIF
RETURN .T.
 
FUNCTION SALVAR01
//
// -> Salva o conteudo das variaveis de entrada no arquivo
**
**BI [INI] I01.B27
**BI [FIM] I01.B27
**
AGENDA->SEQ_CODIGO := M->SEQ_CODIGO
AGENDA->NOME := M->NOME
AGENDA->CPF := M->CPF
AGENDA->CELULAR := M->CELULAR
AGENDA->NOMECONTAT := M->NOMECONTAT
AGENDA->CELULAR1 := M->CELULAR1
AGENDA->OBSERVACAO := M->OBSERVACAO
**
**BI [INI] I01.B28
**BI [FIM] I01.B28
**
 
/* Final do programa AGENDI01.PRG */