*////////////////////////////////////////
* Programa......: Madreor.prg
* Programadores.: Edvaldo E Jean
* Data E Hora...: 02.12.94   10:41:05
* Linguagem.....: Clipper Summer'87
* Objetivo......: Zera Todos Os Lan‡a-
*                 Mentos
*////////////////////////////////////////
*
Set Color To N/w
Telaenc=savescreen(08,16,12,45)
Telconf=savescreen(08,14,20,48)
Relevo(08,14,20,48,.t.)
Relevo(17,20,19,26,.f.)
Relevo(17,34,19,40,.f.)
Vopxenc=2
@ 09,16 Say '          Aten‡„o !!!          '
@ 10,16 Say '    Esta Op‡„o Ira Apagar Todo '
@ 11,16 Say ' O Movimento, Execute  A Op‡„o '
@ 12,16 Say ' De Backup...                  '
@ 15,16 Say '    Confirma Encerramento ?    '
Set Color To W+/w
@ 18,22 Prompt 'Sim'
@ 18,36 Prompt 'N„o'
Menu To Vopxenc
Do Case
   Case Vopxenc = 1
        Relevo(17,20,19,26,.t.)
        Tone(30,2)
        Inkey(0.1)
        Relevo(17,20,19,26,.f.)
        Inkey(0.1)
        Restscreen(08,14,20,48,telconf)
        Set Color To R/w
        Relevo(09,18,11,43,.t.)
        @ 10,20 Say 'Encerrando...     '
        Select 1
        Use Madmov Index Madmovx
        Zap
        Index On Registra To Madmovx
        Close Data
   Case Vopxenc = 2
        Relevo(17,34,19,40,.t.)
        Tone(30,2)
        Inkey(0.1)
        Relevo(17,34,19,40,.f.)
        Inkey(0.1)
        Set Color To N/w
        Restscreen(08,14,20,48,telconf)
Endcase
Restscreen(08,16,12,45,telaenc)
*tone(3000,4)
Set Color To W+/w
Return
