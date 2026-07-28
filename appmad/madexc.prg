*//////////////////////////////////////
* Programa......: Madexc.prg
* Programadores.: Edvaldo E Jean
* Data E Hora...: 01/12/94 15:55:40
* Linguagem.....: Clipper Summer'87
* Objetivo......: Exclus„o De Registros
*//////////////////////////////////////
*
*
#INCLUDE "inkey.ch"
memvar Xal
********************************
procedure madexc()
********************************
Local GETLIST := {}
Local lOk := .t. 
Local telexc, telmens, telconf
Local Vopxe, vreg

Set Color To N/w
Telexc := Savescreen(08,08,19,70)
Set Cursor On

If File ('madmov.cdx')
   Use MADMOV
   SELECT MADMOV 
   SET Index To MADMOV
Else
   Telmens:=savescreen(16,14,20,49)
   Relevo(16,14,20,47,.f.)
   @ 17,16 Say 'Indice N„o Encontrado !!!     '
   @ 18,16 Say 'Entre No Menu De Utilitarios  '
   @ 19,16 Say 'e Execute REORGANIZAR.        '
   Tone(300,3)
   Tone(400,2)
   Inkey(4)
   Restscreen(16,14,20,49,telmens)
   Restscreen(08,08,19,70,telexc)
   lOk := .f.
Endif

if lOk
   SELECT MADMOV
   Relevo(08,08,19,70,.t.)
   @ 09,14 Say 'Registro....:'
   @ 09,40 Say 'Espessura...:'
   @ 11,14 Say 'Comprimento.:'
   @ 13,14 Say 'Largura.....:'
   @ 13,40 Say 'Volume......:'
   Do While lOk      
      Go Top
      Vreg:=space(4)
      @ 11,28 Clear To 11,37
      @ 13,28 Clear To 13,37
      @ 13,54 Clear To 13,63
      @ 09,28 Get Vreg Pict[@R 9999]
      Read
      *
      If Empty(vreg) .or. Lastkey() = 27
         lOk := .f.
      Endif
      *
      if lOk
         @ 09,28 Say Strzero(val(vreg),4)
         Seek Strzero(val(vreg),4)
         If Found()        &&.not. Eof()
            @ 09,58 Say Xal Pict [@R 999.99]
            @ 11,28 Say MADMOV->Compriment Pict [@R 999,999.99]
            @ 13,28 Say MADMOV->Largura Pict [@R 999,999.99]
            @ 13,54 Say MADMOV->Volume Pict [@R 9,999.9999]
            Tone(5000,2)
            Telconf:=savescreen(15,20,18,65)
            @ 15,28 Say 'Confirma Exclus„o ?'
            Vopxe:=2
            Set Color To W+/w
            Relevo(16,22,18,32,.f.)
            Relevo(16,44,18,54,.f.)
            @ 17,26 Prompt [Sim]
            @ 17,48 Prompt [N„o]
            Menu To Vopxe
            Do Case
               Case Vopxe == 1
                    Relevo(16,22,18,32,.t.)
                    Tone(30,2)
                    Inkey(0.1)
                    Relevo(16,22,18,32,.f.)
                    Inkey(0.2)
                    Delete
                    Pack
                    Set Color To N/w
                    Restscreen(15,20,18,65,telconf)
                    Loop
               Case Vopxe == 2
                    Relevo(16,44,18,54,.t.)
                    Tone(30,2)
                    Inkey(0.1)
                    Relevo(16,44,18,54,.f.)
                    Inkey(0.2)
                    Set Color To N/w
                    Restscreen(15,20,18,65,telconf)
                    lOk := .f.
                    loop
            Endcase
         Else
            Set Color To N/w
            @ 22,04 Say 'Mensagens: Registro N„o Encontrado !!!             '
            Inkey(4)
            @ 22,04 Say 'Mensagens: Ä Seta P/Esq. Seta P/Dir. Ä E ENTER Ù'
            Loop
         Endif
      Endif   
   Enddo
Endif
Close Data
Set Color To W+/w
Set Cursor Off
Restscreen(08,08,19,70,telexc)
Return
