
/*
TITULO     : Agenda de Telefone
DATA       : 13/02/25
PROGRAMA   : AGENDSOS.PRG
COMENTARIO : ROTINA DE HELP
*/
 
#include "AGEND.CH"
#include "AGENDMOU.CH"
//
FUNCTION HELP( PROG, LIN, VAR )
//
// -> Rotina de auxilio ao usuario
IF PROG == "HELP" .OR. PROG == "MEMOEDIT" .OR. PROG == "__XHELP"
   RETURN .F.
ENDIF
CUR_SOS := SETCURSOR()
MOUSE( LIGA )
**
**BI [INI] SOS.B01
**BI [FIM] SOS.B01
**
SETKEY( T_F3, NIL )
SETKEY( T_F4, NIL )
SETKEY( T_F6, NIL )
IF SUBS(PROG,1,6) == "CARGET"
   ***
   *** Inicio do bloco de substitui‡„o SOS07.B
   SOS := ""
   SOS( "" )
   SOS( "        TECLAS DE CONTROLE DO PROGRAMA" )
   SOS( "        ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ" )
   SOS( "" )
   SOS( "  F1 >  Aux¡lio ao Usu rio - Apresenta ao usu rio informa‡”es para ma-" )
   SOS( "        nuseio do aplicativo." )
   SOS( "" )
   SOS( "  F3 >  Apresenta Calend rio." )
   SOS( "" )
   SOS( "  F4 >  Calculadora - Possibilta c lculos com as quatro  opera‡”es ma-" )
   SOS( "        tem ticas." )
   SOS( "" )
   SOS( "  F5 >  Possibilita acesso tempor rio ao sistema operacional (DOS),re-" )
   SOS( "        tornando com EXIT." )
   SOS( "" )
   SOS( "  F6 >  Possibilita acesso ao menu de configura‡„o." )
   SOS( "" )
   SOS( "  F7 >  Apresenta tabela para acentua‡„o de caracteres." )
   SOS( "" )
   SOS( "" )
   SOS( "        TECLAS DE CONTROLE DE EDI€O" )
   SOS( "        ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ" )
   SOS( "" )
   SOS( "  Enter  :  Efetua a entrada de dados." )
   SOS( "  Setas  :  Movimentam o cursor para a dire‡„o indicada." )
   SOS( "  Home   :  Move o cursor para o in¡cio do campo." )
   SOS( "  End    :  Move o cursor para o final do campo." )
   SOS( "  <--    :  Apaga o caracter a esquerda do cursor." )
   SOS( "  Ins    :  Liga ou Desliga o modo de inser‡„o de caracteres." )
   SOS( "  Del    :  Apaga o caracter sob o cursor." )
   SOS( "  CTRL T :  Apaga a palavra … direita do cursor." )
   SOS( "  CTRL Y :  Apaga todo o conte£do de um campo." )
   SOS( "  Esc    :  Abandona a Edi‡„o." )
ELSEIF PROG == "ACHOICE"
   ***
   *** Inicio do bloco de substitui‡„o SOS08.B
   SOS := ""
   SOS( "" )
   SOS( "        TECLAS DE CONTROLE DO PROGRAMA" )
   SOS( "        ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ" )
   SOS( "" )
   SOS( "  F1 >  Aux¡lio ao Usu rio - Apresenta ao usu rio informa‡”es para ma-" )
   SOS( "        nuseio do aplicativo." )
   SOS( "" )
   SOS( "  F3 >  Apresenta Calend rio." )
   SOS( "" )
   SOS( "  F4 >  Calculadora - Possibilta c lculos com as quatro  opera‡”es ma-" )
   SOS( "        tem ticas." )
   SOS( "" )
   SOS( "  F5 >  Possibilita acesso tempor rio ao sistema operacional (DOS),re-" )
   SOS( "        tornando com EXIT." )
   SOS( "" )
   SOS( "  F6 >  Possibilita acesso ao menu de configura‡„o." )
   SOS( "" )
   SOS( "  F7 >  Apresenta tabela para acentua‡„o de caracteres." )
   SOS( "" )
   SOS( "" )
   SOS( "        TECLAS DE NAVEGA€O DO MENU" )
   SOS( "        ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ" )
   SOS( "" )
   SOS( "  Seta p/cima  :  Retorna a op‡„o anterior." )
   SOS( "" )
   SOS( "  Seta p/baixo :  Acesso a op‡„o seguinte." )
   SOS( "" )
   SOS( "  PgUp         :  Retorna a p gina anterior." )
   SOS( "" )
   SOS( "  PgDn         :  Acesso a p gina seguinte." )
   SOS( "" )
   SOS( "  Enter        :  Confirma op‡„o escolhida." )
   SOS( "" )
   SOS( "  Esc          :  Retorna." )
   *** Final do bloco de substitui‡„o SOS08.B
   ***
ELSEIF SOS_MENU == "CALENDARIO"
   ***
   *** Inicio do bloco de substitui‡„o SOS01.B
   SOS := ""
   SOS( " " )
   SOS( " " )
   SOS( "   MANUSEIO DO CALENDARIO" )
   SOS( "   ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ" )
   SOS( " " )
   SOS( "   (+) Mˆs : Passa para o pr¢ximo mˆs." )
   SOS( " " )
   SOS( "   (-) Mˆs : Volta para o mˆs anterior." )
   SOS( " " )
   SOS( "   (+) Ano : Passa para o pr¢ximo ano." )
   SOS( " " )
   SOS( "   (-) Ano : Volta para o ano anteiror." )
   SOS( " " )
   SOS( "   Ano     : Permite definir o ano desejado." )
   *** Final do bloco de substitui‡„o SOS01.B
   ***
ELSEIF PROG == "CALCULADORA"
   ***
   *** Inicio do bloco de substitui‡„o SOS02.B
   SOS := ""
   SOS( " " )
   SOS( "  TECLAS DE CONTROLE DA CALCULADORA" )
   SOS( "  ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ" )
   SOS( " " )
   SOS( "  *  :  Sinal de multiplica‡„o." )
   SOS( " " )
   SOS( "  /  :  Sinal de divis„o." )
   SOS( " " )
   SOS( "  +  :  Sinal de soma." )
   SOS( " " )
   SOS( "  -  :  Sinal de subtra‡„o." )
   SOS( " " )
   SOS( "  E  :  Cancela o £ltimo valor digitado na calculadora." )
   SOS( " " )
   SOS( "  C  :  Zera a calculadora." )
   SOS( " " )
   SOS( "  Get: Traz para o GET corrente o conte£do do visor da calculadora." )
   SOS( " " )
   SOS( "  Imprime: Imprime o conteudo da fita da impressora." )
   SOS( " " )
   SOS( "  Esc    :  Abandona o manuseio da calculadora." )
   SOS( " " )
   SOS( "  <Enter> ou =  : Sinal de igualdade." )
   SOS( " " )
   SOS( "  Ctrl + setas  : Move a calculadora na tela." )
   *** Final do bloco de substitui‡„o SOS02.B
   ***
ELSEIF PROG == "SET_CONF"
   ***
   *** Inicio do bloco de substitui‡„o SOS03.B
   SOS := ""
   SOS( " " )
   SOS( "  CONFIGURACAO PARA ENTRADAS DE DADOS" )
   SOS( "  ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ" )
   SOS( " " )
   SOS( "  Confirma‡„o para entradas  : Quando ativada, o  comando  SET CONFIRM" )
   SOS( "                               passa a ser 'ON', isto ‚: faz-se neces-" )
   SOS( "                               s rio teclar <Enter>  para  confirmar o" )
   SOS( "                               conte£do dos campos em digita‡„o." )
   SOS( " " )
   SOS( "  Repeti‡„o de registros     : Quando ativado, efetiva a  repeti‡„o do" )
   SOS( "                               £ltimo registro digitado." )
   SOS( " " )
   SOS( "  Delimitadores para entradas: Quando ativado, apresenta os  delimita-" )
   SOS( "                               dores ' [ ] ' nos campos de  entrada de" )
   SOS( "                               dados." )
   *** Final do bloco de substitui‡„o SOS03.B
   ***
ELSEIF PROG == "BRO_WSE"
   ***
   *** Inicio do bloco de substitui‡„o SOS05.B
   SOS := ""
   SOS( "" )
   SOS( "        TECLAS DE CONTROLE DO PROGRAMA" )
   SOS( "        ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ" )
   SOS( "" )
   SOS( "  F1 >  Aux¡lio ao Usu rio - Apresenta ao usu rio informa‡”es para ma-" )
   SOS( "        nuseio do aplicativo." )
   SOS( "" )
   SOS( "  F3 >  Apresenta Calend rio." )
   SOS( "" )
   SOS( "  F4 >  Calculadora - Possibilta c lculos com as quatro  opera‡”es ma-" )
   SOS( "        tem ticas." )
   SOS( "" )
   SOS( "  F5 >  Possibilita acesso tempor rio ao sistema operacional (DOS),re-" )
   SOS( "        tornando com EXIT." )
   SOS( "" )
   SOS( "  F6 >  Possibilita acesso ao menu de configura‡„o." )
   SOS( "" )
   SOS( "  F7 >  Apresenta tabela para acentua‡„o de caracteres." )
   SOS( "" )
   SOS( "" )
   SOS( "        TECLAS DE CONTROLE DA MANUTENCOES" )
   SOS( "        ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ" )
   SOS( "" )
   SOS( "  Seta p/cima  :  Move para o registro anterior." )
   SOS( "" )
   SOS( "  Seta p/baixo :  Move para o registro seguinte." )
   SOS( "" )
   SOS( "  PgUp         :  Move para a p gina anterior." )
   SOS( "" )
   SOS( "  PgDn         :  Move para a p gina seguinte." )
   SOS( "" )
   SOS( "  Home         :  Move para o in¡cio do arquivo." )
   SOS( "" )
   SOS( "  End          :  Move para o final do arquivo." )
   SOS( "" )
   SOS( "  Enter        :  Apresenta o conte£do do registro." )
   SOS( "" )
   SOS( "  Esc          :  Finaliza manuten‡„o." )
   *** Final do bloco de substitui‡„o SOS05.B
   ***
ELSEIF SOS_MENU == "MENU_PRN"
   ***
   *** Inicio do bloco de substitui‡„o SOS07.B
   SOS := ""
   SOS( "" )
   SOS( "  TECLAS DE CONTROLE DO MENU DE IMPRESSAO" )
   SOS( "  ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ" )
   SOS( "" )
   SOS( "  IMPRESSORA: O relat¢rio ser  impresso na impressora corrente, iden-" )
   SOS( "  tificada na linha superior do menu de impress„o." )
   SOS( "" )
   SOS( [  - Para selecionar outra impressora tecle a letra "I";] )
   SOS( [  - Para mudar o formul rio corrente tecle a letra "F";] )
   SOS( [  - Para acessar o menu de impress„o tecle "TAB"] )
   SOS( "" )
   SOS( "  TELA: O relat¢rio ser  impresso na tela do micro." )
   SOS( "" )
   SOS( [  ARQUIVO: O relat¢rio ser  gravado em um arquivo "PRN".] )
   *** Final do bloco de substitui‡„o SOS07.B
   ***
ELSEIF SOS_MENU == "INDICES"
   ***
   *** Inicio do bloco de substitui‡„o SOS08.B
   SOS := ""
   SOS( "" )
   SOS( "" )
   SOS( "" )
   SOS( "" )
   SOS( "  ORGANIZA€AO DE ARQUIVOS" )
   SOS( "  ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ" )
   SOS( "" )
   SOS( "  TODOS    : Marca e desmarca todos os arquivos (.DBF) do sistema." )
   SOS( "" )
   SOS( "  ORGANIZAR: Organiza os arquivos selecionados." )
   SOS( "" )
   SOS( "  - Utilize as setas para selecionar o arquivo desejado e tecle" )
   SOS( "    <ENTER> para marcar ou desmarcar." )
   *** Final do bloco de substitui‡„o SOS08.B
   ***
ELSE
   ***
   *** Inicio do bloco de substitui‡„o SOS06.B
   SOS := ""
   SOS( "" )
   SOS( "     TECLAS DE CONTROLE DO PROGRAMA" )
   SOS( "     ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ" )
   SOS( "" )
   SOS( "  F1 >  Aux¡lio ao Usu rio - Apresenta ao usu rio informa‡”es para ma-" )
   SOS( "        nuseio do aplicativo." )
   SOS( "" )
   SOS( "  F3 >  Apresenta Calend rio." )
   SOS( "" )
   SOS( "  F4 >  Calculadora - Possibilta c lculos com as quatro  opera‡”es ma-" )
   SOS( "        tem ticas." )
   SOS( "" )
   SOS( "  F5 >  Possibilita acesso tempor rio ao sistema operacional (DOS),re-" )
   SOS( "        tornando com EXIT." )
   SOS( "" )
   SOS( "  F6 >  Possibilita acesso ao menu de configura‡„o." )
   SOS( "" )
   SOS( "  F7 >  Apresenta tabela para acentua‡„o de caracteres." )
   *** Final do bloco de substitui‡„o SOS06.B
   ***
ENDIF
SOMBRA( L_HEL := L_SOM, C_HEL := C_SOM, .T. )
MOUSE( DESLIGA )
SAVE SCREEN
MOUSE( LIGA )
COR := SETCOLOR()
CURSOR( DESLIGA )
JANELA( 03, 02, 21, 77, "Auxilio ao usu rio" )
SETCOLOR( CONTECOR[ 4 ] + "," + CONTECOR[ 4 ] )
**
**BI [INI] SOS.B08
**BI [FIM] SOS.B08
**
MOUSE( DESLIGA )
MEMOEDIT( SOS, 04, 04, 20, 75, .F. )
MOUSE( LIGA )
SETCOLOR( COR )
SETCURSOR( CUR_SOS )
MOUSE( DESLIGA )
RESTORE SCREEN
MOUSE( LIGA )
SOMBRA( L_HEL, C_HEL )
SETKEY( T_F3, { || CALEN() } )
SETKEY( T_F4, { || CALCU() } )
SETKEY( T_F6, { || SET_CONF() } )
**
**BI [INI] SOS.B09
**BI [FIM] SOS.B09
**

FUNCTION SOS( TEX_TO )
SOS += TEX_TO + CHR( 13 ) + CHR( 10 )
RETURN NIL
 
/* Final do programa AGENDSOS.PRG */