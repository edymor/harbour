*////////////////////////////////////////
* Programa......: Madreor.prg
* Programadores.: Edvaldo E Jean
* Data E Hora...: 02.12.94   11:03:05
* Linguagem.....: Clipper Summer'87
* Objetivo......: Efetua O Backup
*////////////////////////////////////////
*
Telabak=savescreen(08,16,20,45)
Telconf=savescreen(08,14,20,48)
Set Color To N/w
Vopxb=2
Relevo(08,14,20,48,.t.)
Relevo(17,20,19,26,.f.)
Relevo(17,34,19,40,.f.)
@ 09,16 Say '          Aten‡„o !!!          '
@ 10,16 Say '    Esta Op‡„o Ira Efetuar Uma '
@ 11,16 Say ' Copia De Seguran‡a Do Arquivo '
@ 12,16 Say ' Em Caso Se Acontecer Algo...  '
@ 15,16 Say '      Confirma Backup ?        '
Set Color To W+/w
@ 18,22 Prompt 'Sim'
@ 18,36 Prompt 'N„o'
Menu To Vopxb
Do Case
   Case Vopxb = 1
        Relevo(17,20,19,26,.t.)
        Tone(30,2)
        Inkey(0.1)
        Relevo(17,20,19,26,.f.)
        Inkey(0.1)
        Ww=space(6)
        Set Color To N/w
        @ 15,16 Clear To 19,46
        @ 16,16 Say ' Data De Hoje.: 'get Ww Pict[999999] Valid .not.empty(ww)
        Read
        Restscreen(08,14,20,48,telconf)
        Relevo(09,18,11,43,.f.)
        @ 10,20 Say 'Aguarde...        '
        Set Console Off
        Telbk=savescreen(00,00,24,79)
        If .not.file('&ww.zoo')
           Run Zoo -a &ww *.dbf > Nul
        Else
           Delete File &ww.zoo
           Run Zoo -a &ww *.dbf > Nul
        Endif
        Restscreen(00,00,24,79,telbk)
        Delete File Madmovx.ntx
        Set Console On
        Set Color To N/w
   Case Vopxb = 2
        Relevo(17,34,19,40,.t.)
        Tone(30,2)
        Inkey(0.1)
        Relevo(17,34,19,40,.f.)
        Inkey(0.1)
        Set Color To N/w
        Restscreen(08,14,20,48,telconf)
Endcase
Restscreen(08,16,20,45,telabak)
Set Color To W+/w
*tone(3000,4)
Return
