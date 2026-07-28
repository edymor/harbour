*//////////////////////////////////////
* Programa......: Madalt.prg
* Programadores.: Edvaldo E Jean
* Data E Hora...: 01/12/94 15:53:52
* Linguagem.....: Clipper Summer'87
* Objetivo......: Altera‡„o De Registros
*//////////////////////////////////////
*
*
#INCLUDE "inkey.ch"

memvar Xal
********************************
procedure madalt()
********************************
Local GETLIST := {}
Local telalt, telmens, telconf
Local lOk := .t.
Local Vcomp,Vlarg,Vvol
Local Vopxa, vreg
*
Set Color To N/w
Telalt := Savescreen(08,08,19,70)
Set Cursor On
*
If File ('madmov.cdx')
   Use MADMOV 
   Select MADMOV
   Set Index to MADMOV
Else
   Telmens:= savescreen(16,14,20,49)
   Relevo(16,14,20,47,.f.)
   @ 17,16 Say 'Indice N„o Encontrado !!!     '
   @ 18,16 Say 'Entre No Menu De Utilitarios  '
   @ 19,16 Say 'e Execute REORGANIZAR.        '
   Tone(300,3)
   Tone(400,2)
   Inkey(4)
   Restscreen(16,14,20,47,telmens)
   Restscreen(08,08,19,70,telalt)
   lOk := .f.
Endif
*
if lOk
   Select MADMOV
   Relevo(08,08,19,70,.t.)
   @ 09,14 Say 'Registro....:'
   @ 09,40 Say 'Espessura...:'
   @ 11,14 Say 'Comprimento.:'
   @ 13,14 Say 'Largura.....:'
   @ 13,40 Say 'Volume......:'
   Do While lOk
      Go Top
      Vreg := space(4)
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
         If Found()    &&.not. Eof()
            Vcomp:=madmov->compriment
            Vlarg:=madmov->largura
            Vvol :=madmov->volume
            @ 09,58 Say Xal Pict [@R 999.99]
            @ 11,28 Get Vcomp Pict [@R 999,999.99] Valid .not.empty(vcomp)
            @ 13,28 Get Vlarg Pict [@R 999,999.99] Valid .not.empty(vlarg)
            Read
            Vvol:=vlarg/100*vcomp*xal/100
            @ 13,54 Say Vvol Pict [@R 9,999.9999]
            Tone(5000,2)
            Telconf:=savescreen(15,20,18,65)
            @ 15,28 Say 'Confirma Altera‡„o ?'
            Vopxa:=2
            Set Color To W+/w
            Relevo(16,22,18,32,.f.)
            Relevo(16,44,18,54,.f.)
            @ 17,26 Prompt [Sim]
            @ 17,48 Prompt [N„o]
            Menu To Vopxa
            Do Case
               Case Vopxa == 1
                    Relevo(16,22,18,32,.t.)
                    Tone(30,2)
                    Inkey(0.1)
                    Relevo(16,22,18,32,.f.)
                    Inkey(0.2)
                    Replace Compriment With Vcomp
                    Replace Largura    With Vlarg
                    Replace Volume     With Vvol
                    Commit
                    Set Color To N/w
                    Restscreen(15,20,18,65,telconf)
                    Loop
               Case Vopxa == 2
                    Relevo(16,44,18,54,.t.)
                    Tone(30,2)
                    Inkey(0.1)
                    Relevo(16,44,18,54,.f.)
                    Inkey(0.2)
                    Set Color To N/w
                    Restscreen(15,20,18,65,telconf)
                    //lOk := .f.
                    Loop
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
Set Color To R/w
Set Cursor Off
Restscreen(08,08,19,70,telalt)
Return
