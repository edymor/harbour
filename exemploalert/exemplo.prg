#include "hb.ch"

#define MSG_INFO  1
#define MSG_WARN  2
#define MSG_ERR   3
#define MSG_CONF  4
#define _QL       CHR(010)


request HB_CODEPAGE_PT850
request HB_CODEPAGE_PTISO
request HB_LANG_PT_BR

PROCEDURE Main()
   LOCAL lContinuar := .F.
   
   hb_cdpSelect("PT850")
   hb_langSelect("pt_BR", "PT850")
   
   // 1. Mensagem de Informaá∆o
   ExibirMsg( "O processo foi conclu°do com sucesso!", MSG_INFO, "Informaá∆o" )

   // 2. Mensagem de Alerta
   ExibirMsg( "O arquivo DBT antigo ser† sobrescrito.", MSG_WARN,"Atená∆o" )
   
   ExibirMsg( "Existe backup pendente.", MSG_WARN,"Aviso" )

   // 3. Mensagem de Erro
   ExibirMsg( "N∆o foi poss°vel abrir o banco de dados!", MSG_ERR, "Erro" )
   
   // sem titulo
   ExibirMsg( "Mensagem sem titulo.", MSG_INFO )
   
   // com opcao
   altd()
   lContinuar := ExibirMsg( "Deseja realmente excluir os arquivos *.DBT?", MSG_CONF, "Confirmaá∆o" )

   IF lContinuar
      ? "Usu†rio escolheu SIM. Executando exclus∆o..."
   ELSE
      ? "Usu†rio escolheu N«O ou cancelou. Operaá∆o abortada."
   ENDIF
RETURN


FUNCTION ExibirMsg( cMensagem, nTipo, cTitulo )
   LOCAL cCores     := "W+/B" // Padr∆o: Branco brilhante no Azul
   LOCAL aOpcoes    := { "OK" }
   LOCAL nDefault   := 1        // Foco no primeiro bot∆o por padr∆o
   LOCAL nRetorno   := 0
   LOCAL lRetorna   := .T.
      
   HB_DEFAULT (@cTitulo, "Informaá∆o")
   HB_DEFAULT( @nTipo, MSG_INFO )

   DO CASE
      CASE nTipo == MSG_INFO
         cCores  := "W+/B"          // Branco no Azul
         //cTitulo := "INFORMAÄ«O"

      CASE nTipo == MSG_WARN
         cCores  := "N/GR*"         // Preto no Amarelo
         //cCores  := "N/GR*,GR+/N,N,,N/GR*"     
         //cTitulo := "ATENÄ«O / AVISO"

      CASE nTipo == MSG_ERR
         cCores  := "W+/R"          // Branco no Vermelho
         //cTitulo := "ERRO CR÷TICO"
      
      CASE nTipo == MSG_CONF
         //cCores  := "W+/N"      // Branco no Preto (ou escolha a cor de sua preferància)
         cCores  := "W+/BG"
         //cTitulo := "CONFIRMAÄ«O"
         aOpcoes := { "Sim", "N∆o" }
         nDefault := 2  
   ENDCASE

   // Executa o alerta passando a mensagem, bot‰es, paleta de cores e a posiá∆o padr∆o do foco
   nRetorno := Alert( cTitulo + _QL + _QL +  cMensagem, aOpcoes, cCores, nDefault )

   // Aá∆o autom†tica para o tipo Confirmaá∆o
   IF nTipo == MSG_CONF
      // Se selecionou "N∆o" (opá∆o 2) ou pressionou ESC (retorna 0)
      IF nRetorno != 1
         lRetorna   := .F.   
      ENDIF
      
   ENDIF
   
RETURN lRetorna

/*  trecho forma antiga   
   // Se for do tipo confirmaá∆o, retorna .T. apenas se o usu†rio selecionar explicitamente "Sim" (posiá∆o 1)
   IF nTipo == MSG_CONF
      RETURN ( nRetorno == 1 )
   ENDIF
   
   RETURN nRetorno



    public aMostraCor:= {;
        "B+/B",;
        "N/W",;
        "W+/R",;
        "W/B",;
        "N/BG",;
        "N/W",;
        "W+/W",;
        "N/W",;
        "W+/R",;
        "W+/B",;
        "W/B",;
        "W/B",;
        "W+/BG"}    

LOCAL V_TAB := { { "00","N   "},;    // preto
                 { "01","B   "},;    // azul
                 { "02","G   "},;    // verde
                 { "03","BG  "},;    // ciano
                 { "04","R   "},;    // vermelho
                 { "05","RB  "},;    // magenta
                 { "06","GR  "},;    // marrom
                 { "07","W   "},;    // branco
                 { "08","N+  "},;    // cinza
                 { "09","B+  "},;    // azul-claro
                 { "10","G+  "},;    // verde-claro
                 { "11","BG+ "},;    // ciano-claro
                 { "12","R+  "},;    // vermelho-claro
                 { "13","RB+ "},;    // magenta-claro
                 { "14","GR+ "},;    // amarelo
                 { "15","W+  "}}     // branco-intenso

*/