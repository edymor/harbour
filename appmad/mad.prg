*/////////////////////////////////////////
* Programa......: Mad.prg
* Programadores.: Edvaldo E Jean
* Data E Hora...: 30.11.94  15:45:00
* Linguagem.....: Clipper Summer'87
* Objetivo......: Calculo De Espessuras
* //////////////////////////////////////
*
#INCLUDE "inkey.ch"
#INCLUDE "hbgtinfo.ch"
#INCLUDE "dbinfo.ch"

REQUEST HB_GT_WVT_DEFAULT

REQUEST HB_CODEPAGE_PT850
REQUEST HB_CODEPAGE_PTISO
REQUEST HB_LANG_PT_BR

STATIC pNewGT,pGT 

********************************
procedure main()
********************************
LOCAL GETLIST := {}
Local opc, opcut
Local Vopx
Local Xx := "N"
Local telsom, teluti
Local lOk := .t.
Local lOkm := .t.
Local lContinua := .t.

Public Xal
Private vl

REQUEST DBFCDX
RDDSETDEFAULT("DBFCDX")
RDDINFO(RDDI_MEMOTYPE,DB_MEMO_DBT,"DBFCDX")

pNewGT := hb_GtCreate("WVT")
hb_gtSelect(pNewGT)
hb_GtInfo( HB_GTI_CODEPAGE, "PT850" )
hb_GtInfo( HB_GTI_FONTNAME, "Lucida Console" )
hb_GtInfo( HB_GTI_FONTSIZE, 10 )
hb_GtInfo( HB_GTI_WINTITLE, "Sistema de Administracao de Lojas" )
hb_GtInfo( HB_GTI_CLOSABLE, .F. )
hb_GtInfo( HB_GTI_RESIZABLE, .T. )
hb_GtInfo( HB_GTI_MOUSESTATUS, 0 )
*hb_Gtinfo( HB_GTI_CODEPAGE, 255 )
hb_GtInfo( HB_GTI_ISFULLSCREEN, .F. ) // , "we should be on full screen"
hb_GtInfo( HB_GTI_ALTENTER, .F. ) // , "Alt+Enter is now enabled, try it"
hb_GtInfo( HB_GTI_ISFULLSCREEN, .F. )
hb_GtInfo( HB_GTI_MAXIMIZED, .F. )
hb_GtInfo( HB_GTI_COMPATBUFFER, .T. )
hb_GtInfo( HB_GTI_FONTWIDTH, 10 )
hb_GtInfo( HB_GTI_FONTSIZE , 20 )
hb_GtInfo( HB_GTI_RESIZEMODE, HB_GTI_RESIZEMODE_FONT )
*
IF hb_GtInfo( HB_GTI_DESKTOPWIDTH ) > 1024
   hb_GtInfo( HB_GTI_FONTWIDTH, 12 )
   hb_GtInfo( HB_GTI_FONTSIZE, 24 )
ENDIF

*-> Limpa Tela
Clear
*
* -> Setando O Programa
*
Set Score Off
set epoch to 1980
set century on
Set Console Off
Set Confirm On
Set Wrap On
Set Date Brit
Set Status Off
Set Deci To 4
*
*
*-> Inicio Do Programa
*

*Public Frame[3]
* Box Simples
*Frame[1]=chr(218)+chr(196)+chr(191)+chr(179)+chr(217)+chr(196)+chr(192)+chr(179)
* Box Duplo
*Frame[2]=chr(201)+chr(205)+chr(187)+chr(186)+chr(188)+chr(205)+chr(200)+chr(186)
* Box Achuriado
*Frame[3]=chr(177)+chr(177)+chr(177)+chr(177)+chr(177)+chr(177)+chr(177)+chr(177)+chr(177)
*
*-> Tela Do Programa
*
Set Color To W+/b
@ 00,00 Say "ÚÂÂÂÂÂÂÂÂÂÂÂÂÂÂÂÂÂÂÂÂÂÂÂÂÂÂÂÂÂÂÂÂÂÂÂÂÂÂÂÂÂÂÂÂÂÂÂÂÂÂÂÂÂÂÂÂÂÂÂÂÂÂÂÂÂÂÂÂÂÂÂÂÂÂÂÂÂÂ¿"
@ 01,00 Say "ÃÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÁÁÁÁÁÁÁÁÁÁÁÁÁÁÁÁÁÁÁÁÁÁÁÁÁÁÁÁÁÁÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅ´"
@ 02,00 Say "ÃÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅ´ -=- Controle De Madeiras -=- ÃÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅ´"
@ 03,00 Say "ÃÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÂÂÂÂÂÂÂÂÂÂÂÂÂÂÂÂÂÂÂÂÂÂÂÂÂÂÂÂÂÂÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅ´"
@ 04,00 Say "ÃÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅ´"
@ 05,00 Say "ÃÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÁÁÁÁÅÅÅÅÅÅÁÁÁÁÅÅÅÅÅÁÁÁÁÁÁÁÁÁÁÁÁÅÅÅÅÅÁÁÁÁÁÁÁÁÁÁÁÁÁÅÅÅÅÅÅÅÅÅÅÅÅÅÅ´"
@ 06,00 Say "ÃÅÅÅÅÅÅÅÅÅÅÅÅÅÅ´ÛÛÛÛÃÅÅÅÅ´ÛÛÛÛÃÅÅÅ´ÛÛÛÛÛÛÛÛÛÛÛÛÃÅÅÅ´ÛÛÛÛÛÛÛÛÛÛÛÛÛÃÅÅÅÅÅÅÅÅÅÅÅÅÅ´"
@ 07,00 Say "ÃÅÅÅÅÅÅÅÅÅÅÅÅÅÅ´ÛÛÛÛÀÅÅÅÅÙÛÛÛÛÃÅÅÅ´ÛÛÛÛÛÛÛÛÛÛÛÛÃÅÅÅ´ÛÛÛÛÛÛÛÛÛÛÛÛÛÃÅÅÅÅÅÅÅÅÅÅÅÅÅ´"
@ 08,00 Say "ÃÅÅÅÅÅÅÅÅÅÅÅÅÅÅ´ÛÛÛÛÛÀÅÅÙÛÛÛÛÛÃÅÅÅ´ÛÛÛÛÚÂÂ¿ÛÛÛÛÃÅÅÅÅ¿ÛÛÛÛÚÂÂ¿ÛÛÛÛÃÅÅÅÅÅÅÅÅÅÅÅÅÅ´"
@ 09,00 Say "ÃÅÅÅÅÅÅÅÅÅÅÅÅÅÅ´ÛÛÛÛÛÛÀÙÛÛÛÛÛÛÃÅÅÅ´ÛÛÛÛÃÅÅ´ÛÛÛÛÃÅÅÅÅ´ÛÛÛÛÃÅÅ´ÛÛÛÛÃÅÅÅÅÅÅÅÅÅÅÅÅÅ´"
@ 10,00 Say "ÃÅÅÅÅÅÅÅÅÅÅÅÅÅÅ´ÛÛÛÛÛÛÛÛÛÛÛÛÛÛÃÅÅÅ´ÛÛÛÛÃÅÅ´ÛÛÛÛÃÅÅÅÅ´ÛÛÛÛÃÅÅ´ÛÛÛÛÃÅÅÅÅÅÅÅÅÅÅÅÅÅ´"
@ 11,00 Say "ÃÅÅÅÅÅÅÅÅÅÅÅÅÅÅ´ÛÛÛÛ ÛÛÛÛ ÛÛÛÛÃÅÅÅ´ÛÛÛÛÀÁÁÙÛÛÛÛÃÅÅÅÅ´ÛÛÛÛÃÅÅ´ÛÛÛÛÃÅÅÅÅÅÅÅÅÅÅÅÅÅ´"
@ 12,00 Say "ÃÅÅÅÅÅÅÅÅÅÅÅÅÅÅ´ÛÛÛÛÚ¿ÛÛÚ¿ÛÛÛÛÃÅÅÅ´ÛÛÛÛÛÛÛÛÛÛÛÛÃÅÅÅÅ´ÛÛÛÛÃÅÅ´ÛÛÛÛÃÅÅÅÅÅÅÅÅÅÅÅÅÅ´"
@ 13,00 Say "ÃÅÅÅÅÅÅÅÅÅÅÅÅÅÅ´ÛÛÛÛÃÅÂÂÅ´ÛÛÛÛÃÅÅÅ´ÛÛÛÛÛÛÛÛÛÛÛÛÃÅÅÅÅ´ÛÛÛÛÃÅÅ´ÛÛÛÛÃÅÅÅÅÅÅÅÅÅÅÅÅÅ´"
@ 14,00 Say "ÃÅÅÅÅÅÅÅÅÅÅÅÅÅÅ´ÛÛÛÛÃÅÅÅÅ´ÛÛÛÛÃÅÅÅ´ÛÛÛÛÚÂÂ¿ÛÛÛÛÃÅÅÅÅ´ÛÛÛÛÃÅÅ´ÛÛÛÛÃÅÅÅÅÅÅÅÅÅÅÅÅÅ´"
@ 15,00 Say "ÃÅÅÅÅÅÅÅÅÅÅÅÅÅÅ´ÛÛÛÛÃÅÅÅÅ´ÛÛÛÛÃÅÅÅ´ÛÛÛÛÃÅÅ´ÛÛÛÛÃÅÅÅÅ´ÛÛÛÛÃÅÅ´ÛÛÛÛÃÅÅÅÅÅÅÅÅÅÅÅÅÅ´"
@ 16,00 Say "ÃÅÅÅÅÅÅÅÅÅÅÅÅÅÅ´ÛÛÛÛÃÅÅÅÅ´ÛÛÛÛÃÅÅÅ´ÛÛÛÛÃÅÅ´ÛÛÛÛÃÅÅÅÅ´ÛÛÛÛÃÅÅ´ÛÛÛÛÃÅÅÅÅÅÅÅÅÅÅÅÅÅ´"
@ 17,00 Say "ÃÅÅÅÅÅÅÅÅÅÅÅÅÅÅ´ÛÛÛÛÃÅÅÅÅ´ÛÛÛÛÃÅÅÅ´ÛÛÛÛÃÅÅ´ÛÛÛÛÃÅÅÅÅÙÛÛÛÛÀÁÁÙÛÛÛÛÃÅÅÅÅÅÅÅÅÅÅÅÅÅ´"
@ 18,00 Say "ÃÅÅÅÅÅÅÅÅÅÅÅÅÅÅ´ÛÛÛÛÃÅÅÅÅ´ÛÛÛÛÃÅÅÅ´ÛÛÛÛÃÅÅ´ÛÛÛÛÃÅÅÅ´ÛÛÛÛÛÛÛÛÛÛÛÛÛÃÅÅÅÅÅÅÅÅÅÅÅÅÅ´"
@ 19,00 Say "ÃÅÅÅÅÅÅÅÅÅÅÅÅÅÅ´ÛÛÛÛÃÅÅÅÅ´ÛÛÛÛÃÅÅÅ´ÛÛÛÛÃÅÅ´ÛÛÛÛÃÅÅÅ´ÛÛÛÛÛÛÛÛÛÛÛÛÛÃÅÅÅÅÅÅÅÅÅÅÅÅÅ´"
@ 20,00 Say "ÃÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÂÂÂÂÅÅÅÅÅÅÂÂÂÂÅÅÅÅÅÂÂÂÂÅÅÅÅÂÂÂÂÅÅÅÅÅÂÂÂÂÂÂÂÂÂÂÂÂÂÅÅÅÅÅÅÅÅÅÅÅÅÅÅ´"
@ 21,00 Say "ÃÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅ´"
@ 22,00 Say "ÃÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅ´"
@ 23,00 Say "ÃÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅÅ´"
@ 24,00 Say "ÀÁÁÁÁÁÁÁÁÁÁÁÁÁÁÁÁÁÁÁÁÁÁÁÁÁÁÁÁÁÁÁÁÁÁÁÁÁÁÁÁÁÁÁÁÁÁÁÁÁÁÁÁÁÁÁÁÁÁÁÁÁÁÁÁÁÁÁÁÁÁÁÁÁÁÁÁÁÁÙ"
Inkey(7)
*
*-> Cabecalho Do Programa
*
hb_cdpSelect("PT850")
hb_langSelect("pt_BR", "PT850")
*
Clear
*
Set Color To N/w
@ 00,00 Clear To 24,79
Relevo(00,00,24,79,.f.)
Relevo(01,02,03,77,.t.)
Relevo(21,02,23,77,.t.)
Set Color To B/w
@ 02,10 Say 'Controle De Madeira - V 2.0'
Set Color To N/w
@ 22,04 Say 'Mensagens: - Seta P/Esq. Seta P/Dir. - E ENTER Ù'
*
If .not.file('param.mem')
   vl := 0.00
   telsom := Savescreen(03,10,07,62)
   Relevo(04,12,06,60,.t.)
   @ 05,14 Say 'Entre Com O Valor Da Espessura.: ' Get vl Pict [@R 999.99] Valid .not. Empty(vl)
   Read
   Save All Like vl To param
   Restscreen(03,10,07,62,telsom)
Else
   Restore From param Additive
   Xal:= vl
   telsom := Savescreen(03,10,12,62)
   Relevo(04,12,12,60,.t.)
   @ 05, 18 Say 'Deseja Alterar O Valor Da Espessura ?'
   @ 07, 18 Say 'Valor Atual (cm).: '
   @ 07, 39 Say Xal Pict [@R 999.99]
   Vopx := 2
   Do While lContinua
      Set Color To W+/w
      Relevo(09,22,11,32,.f.)
      Relevo(09,40,11,50,.f.)
      @ 10,26 Prompt [Sim]
      @ 10,44 Prompt [N„o]
      Menu To Vopx
      Do Case
         Case Vopx == 1
              Relevo(09,22,11,32,.t.)
              Tone(30,2)
              Inkey(0.1)
              Relevo(09,22,11,32,.f.)
              Inkey(0.2)
              @ 07, 39 Get Xal Pict [@R 999.99] Valid .not. Empty(xal)
              Read
              vl :=xal
              Save All Like vl To param
              Set Color To N/w
              Restscreen(03,10,12,62,telsom)
              lContinua:= .f.
              loop
         Case Vopx == 2
              Relevo(09,40,11,50,.t.)
              Tone(30,2)
              Inkey(0.1)
              Relevo(09,40,11,50,.f.)
              Inkey(0.2)
              Set Color To N/w
              Restscreen(03,10,12,62,telsom)
              lContinua := .f.
              loop
      Endcase
   Enddo
Endif
*@ 03,00 Clear To 08,79
Restore From param Additive
Xal:=vl
Do While lOk
   Set Color To W+/w
   * @ 00, 65 Say Xal Pict [@r 999.99]
   Set Cursor Off
   Relevo(04,02,06,12,.f.)
   Relevo(04,13,06,23,.f.)
   Relevo(04,24,06,34,.f.)
   Relevo(04,35,06,45,.f.)
   Relevo(04,46,06,56,.f.)
   Relevo(04,57,06,67,.f.)
   Relevo(04,68,06,77,.f.)
   @ 05,03 Prompt 'Incluir  '
   @ 05,14 Prompt 'Alterar  '
   @ 05,25 Prompt 'Consulta '
   @ 05,36 Prompt 'Excluir  '
   @ 05,47 Prompt 'Relatorio'
   @ 05,58 Prompt 'Util     '
   @ 05,69 Prompt 'Fim     '
   Opc := 0
   Menu To Opc
   Do Case
      * Case Opc = 0
      *      Relevo(04,68,06,77,.t.)
      *      Tone(30,2)
      *      Inkey(0.1)
      *      Relevo(04,68,06,77,.f.)
      *      Inkey(0.2)
      *      Exit
      Case Opc == 1
           Relevo(04,02,06,12,.t.)
           Tone(30,2)
           Inkey(0.1)
           Relevo(04,02,06,12,.f.)
           Inkey(0.2)
           Do Madinc
      Case Opc == 2
           Relevo(04,13,06,23,.t.)
           Tone(30,2)
           Inkey(0.1)
           Relevo(04,13,06,23,.f.)
           Inkey(0.2)
           Do Madalt
      Case Opc == 3
           Relevo(04,24,06,34,.t.)
           Tone(30,2)
           Inkey(0.1)
           Relevo(04,24,06,34,.f.)
           Inkey(0.2)
           Do Madcon
      Case Opc == 4
           Relevo(04,35,06,45,.t.)
           Tone(30,2)
           Inkey(0.1)
           Relevo(04,35,06,45,.f.)
           Inkey(0.2)
           Do Madexc
      Case Opc == 5
           Relevo(04,46,06,56,.t.)
           Tone(30,2)
           Inkey(0.1)
           Relevo(04,46,06,56,.f.)
           Inkey(0.2)
           *Do Madrel
      Case Opc == 6
           Relevo(04,57,06,67,.t.)
           Tone(30,2)
           Inkey(0.1)
           Relevo(04,57,06,67,.f.)
           Inkey(0.2)
           Teluti:=savescreen(06,54,22,70)
           Relevo(06,54,22,70,.f.)
           @ 07,55 Clear To 21,69
           Relevo(07,56,09,68,.f.)
           Relevo(10,56,12,68,.f.)
           Relevo(13,56,15,68,.f.)
           Relevo(16,56,18,68,.f.)
           Relevo(19,56,21,68,.f.)
           Opcut := 0
           Do While lOkm
              @ 08,57 Prompt 'Organizar  '
              @ 11,57 Prompt 'Backup     '
              @ 14,57 Prompt 'Restore    '
              @ 17,57 Prompt 'Apagar Arqs'
              @ 20,57 Prompt 'Zerar Lanc.'
              Menu To Opcut
              Do Case
                 Case Opcut == 1
                      Relevo(07,56,09,68,.t.)
                      Tone(30,2)
                      Inkey(0.1)
                      Relevo(07,56,09,68,.f.)
                      Inkey(0.2)
                      Do Madreor
                 Case Opcut == 2
                      Relevo(10,56,12,68,.t.)
                      Tone(30,2)
                      Inkey(0.1)
                      Relevo(10,56,12,68,.f.)
                      Inkey(0.2)
                      *Do Madbak
                 Case Opcut == 3
                      Relevo(13,56,15,68,.t.)
                      Tone(30,2)
                      Inkey(0.1)
                      Relevo(13,56,15,68,.f.)
                      Inkey(0.2)
                      *Do Madret
                 Case Opcut == 4
                      Relevo(16,56,18,68,.t.)
                      Tone(30,2)
                      Inkey(0.1)
                      Relevo(16,56,18,68,.f.)
                      Inkey(0.2)
                      *Do Madapa
                 Case Opcut == 5
                      Relevo(19,56,21,68,.t.)
                      Tone(30,2)
                      Inkey(0.1)
                      Relevo(19,56,21,68,.f.)
                      Inkey(0.2)
                      *Do Madenc
                 Otherwise
                      Relevo(06,54,22,70,.t.)
                      Tone(30,2)
                      Inkey(0.1)
                      Relevo(06,54,22,70,.f.)
                      Inkey(0.2)
                      lOkm:=.f.
                      loop
              Endcase
           Enddo
           Restscreen(06,54,22,70,teluti)
      Case Opc == 7
           Relevo(04,68,06,77,.t.)
           Tone(30,2)
           Inkey(0.1)
           Relevo(04,68,06,77,.f.)
           Inkey(0.2)
           lOk := .f.
           loop
   Endcase
Enddo
Set Color To
Clear
Set Cursor On
Quit
