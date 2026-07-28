*////////////////////////////////////////
* Programa......: Madreor.prg
* Programadores.: Edvaldo E Jean
* Data E Hora...: 02.12.94   09:45:50
* Linguagem.....: Clipper Summer'87
* Objetivo......: Criar E Reorganizar
*                 Os Indices
*////////////////////////////////////////
*

******************************
procedure madreor()
******************************
Local telareo

telareo:=savescreen(09,18,11,43)
Relevo(09,18,11,43,.t.)
Set Color To N/w
@ 10,20 Say 'Gerando Indices...'
Set Color To W+/w
Use MADMOV ALIAS MADMOV NEW EXCLUSIVE
Select MADMOV
Index On MADMOV->REGISTRA TAG REGISTRA To madmov
Close Data
Restscreen(09,18,11,43,telareo)
*tone(3000,4)
Return 
