*////////////////////////////////////////
* Programa......: Madapa.prg
* Programadores.: Edvaldo E Jean
* Data E Hora...: 02.12.94   14:39:05
* Linguagem.....: Clipper Summer'87
* Objetivo......: Apaga Arquivos Backup
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
Vopxpa=2
@ 09,16 Say '          Aten‡„o !!!          '
@ 10,16 Say '    Esta Op‡„o Ira Deletar A(s)'
@ 11,16 Say ' Copia(s) De Seguran‡a Da Lista'
@ 12,16 Say ' De Backup...                  '
@ 15,16 Say '      Continua Processo ?      '
Set Color To W+/w
@ 18,22 Prompt 'Sim'
@ 18,36 Prompt 'N„o'
Menu To Vopxpa
Do Case
   Case Vopxpa = 1
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
           Restscreen(03,02,19,22,telret)
           Return
        Endif
        Ww=vdir[vop]
        Set Console Off
        Delete File &ww
        Delete File Madmovx.ntx
        Set Console On
   Case Vopxpa = 2
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