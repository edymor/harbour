*//////////////////////////////////////
* Programa......: Madinc.prg
* Programadores.: Edvaldo E Jean
* Data E Hora...: 01/12/94 10:30:05
* Linguagem.....: Clipper Summer'87
* Objetivo......: Inclusao De Registros
*//////////////////////////////////////
*
*
#INCLUDE "inkey.ch"

memvar Xal
********************************
procedure madinc()
********************************
LOCAL GETLIST := {}
Local Vcomp,Vlarg,Vvol
Local telmens,telinc, telconf
Local Vreg, Vopx1
Local lOk := .t.

Set Color To N/w
Telinc := Savescreen(08,08,19,70)
Set Cursor On
If File ('madmov.cdx')
   Use MADMOV 
   Select MADMOV
   Set Index TO MADMOV
Else
   telmens:=savescreen(16,14,20,47)
   Relevo(16,14,20,47,.f.)
   @ 17,16 Say 'Indice N„o Encontrado !!!     '
   @ 18,16 Say 'Entre No Menu De Utilitarios  '
   @ 19,16 Say 'e Execute REORGANIZAR.        '
   Tone(300,3)
   Tone(400,2)
   Inkey(4)
   Restscreen(16,14,20,47,telmens)
   Restscreen(08,08,19,70,telinc)
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
      Go Bottom
      Vcomp := 0.00
      Vlarg := 0.00
      Vvol  := 0.0000
      @ 14,54 Clear To 14,63
      Vreg := strzero(val(MADMOV->REGISTRA)+1,4)
      @ 09,28 Say Vreg
      @ 09,58 Say Xal Pict [@R 999.99]
      @ 11,28 Get Vcomp Pict [@R 999,999.99] Valid .not. Empty(vcomp)
      @ 13,28 Get Vlarg Pict [@R 999,999.99] Valid .not. Empty(vlarg)
      Read
      If Lastkey() == 27
         lOk := .f.
      Endif
      
      if lOk
         Vvol:= vlarg/100*vcomp*xal/100
         @ 13,54 Say Vvol Pict [@R 9,999.9999]
         Tone(5000,2)
         telconf:=savescreen(15,20,18,65)
         @ 15,28 Say 'Confirma Lan‡amento ?'
         Vopx1 := 0
         Set Color To W+/w
         Relevo(16,22,18,32,.f.)
         Relevo(16,44,18,54,.f.)
         @ 17,26 Prompt [Sim]
         @ 17,48 Prompt [N„o]
         Menu To Vopx1
         Do Case
            Case Vopx1 == 1 
                 Relevo(16,22,18,32,.t.)
                 Tone(30,2)
                 Inkey(0.1)
                 Relevo(16,22,18,32,.f.)
                 Inkey(0.2)
                 *
                 Append Blank
                 Replace Registra   With Vreg
                 Replace Compriment With Vcomp
                 Replace Volume     With Vvol
                 Replace Largura    With Vlarg
                 Commit
                 *
                 Vreg := strzero(val(MADMOV->REGISTRA)+1,4)
                 Set Color To N/w
                 Restscreen(15,20,18,65,telconf)
                 Loop
            Case Vopx1=2
                 Relevo(16,44,18,54,.t.)
                 Tone(30,2)
                 Inkey(0.1)
                 Relevo(16,44,18,54,.f.)
                 Inkey(0.2)
                 Set Color To N/w
                 @ 22,04 Say 'Mensagens: Registro N„o Incluido !!!               '
                 Inkey(4)
                 @ 22,04 Say 'Mensagens: Ä Seta P/Esq. Seta P/Dir. Ä E ENTER Ù'
                 Restscreen(15,20,18,65,telconf)
                 Loop
         Endcase
      endif   
   Enddo
   Close Data
   Set Color To W+/w
   Set Cursor Off
   Restscreen(08,08,19,70,telinc)
endif
Return 
