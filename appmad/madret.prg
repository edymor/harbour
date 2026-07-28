*////////////////////////////////////////
* Programa......: Madreor.prg
* Programadores.: Edvaldo E Jean
* Data E Hora...: 02.12.94   11:03:05
* Linguagem.....: Clipper Summer'87
* Objetivo......: Efetua O Restore
*////////////////////////////////////////
*
Set Color To N/w
Telret=savescreen(03,02,19,22)
Telconf=savescreen(08,14,20,48)
Private Vdir[adir("*.ZOO")]
Adir("*.zoo",vdir)
Relevo(08,14,20,48,.t.)
Relevo(17,20,19,26,.f.)
Relevo(17,34,19,40,.f.)
Vopxr=2
@ 09,16 Say '          Aten‡„o !!!          '
@ 10,16 Say '    Esta Op‡„o Ira Restaurar A '
@ 11,16 Say ' Copia De Seguran‡a Do Arquivo '
@ 12,16 Say ' Em Caso Se Acontecer Algo...  '
@ 15,16 Say '    Confirma Restaura‡„o ?     '
Set Color To W+/w
@ 18,22 Prompt 'Sim'
@ 18,36 Prompt 'N„o'
Menu To Vopxr
Do Case
   Case Vopxr = 1
        Relevo(17,20,19,26,.t.)
        Tone(30,2)
        Inkey(0.1)
        Relevo(17,20,19,26,.f.)
        Inkey(0.1)
        Restscreen(08,14,20,48,telconf)
        Set Color To R/w
        Relevo(07,04,18,20,.t.)
        @ 08,06 Say 'Arquivo(s)'
        Vop=achoice(09,06,17,18,vdir)
        If Vop=0
           Restscreen(08,14,20,48,telconf)
           *restscreen(00,00,24,79,telbk)
           Restscreen(03,02,19,22,telret)
           Return
        Endif
        Ww=vdir[vop]
        Set Console Off
        Telbk=savescreen(00,00,24,79)
        If File('madmov.fdb')
           Delete File Madmov.fdb
        Endif
        If File('madmov.dbf')
           Rename Madmov.dbf To Madmov.fdb
        Endif
        If File('&ww.zoo')
           Run Zoo -e &ww > Nul
        Endif
        Restscreen(00,00,24,79,telbk)
        Delete File Madmovx.ntx
        Set Console On
   Case Vopxr=2
        Relevo(17,34,19,40,.t.)
        Tone(30,2)
        Inkey(0.1)
        Relevo(17,34,19,40,.f.)
        Inkey(0.1)
        Set Color To N/w
        Restscreen(08,14,20,48,telconf)
Endcase
Restscreen(03,02,19,22,telret)
*tone(3000,4)
Set Color To W+/w
Return
