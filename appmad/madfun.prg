*/////////////////////////////////////////
* Programa......: Madfun.prg
* Programadores.: Edvaldo E Jean
* Data E Hora...: 30.11.94  16:48:39
* Linguagem.....: Clipper Summer'87
* Objetivo....... Funcoes E Procedures
*/////////////////////////////////////////
*
#INCLUDE "inkey.ch"
#INCLUDE "hbgtinfo.ch"

********************************
Function Relevo(Arg1,arg2,arg3,arg4,arg5)
********************************

Private Local1, Local2, Local3, Local4
Local4 := Setcolor()
Local2 := "+W/W"
Local3 := "N/W"
If (arg5)
   Set Color To (local2)
Else
   Set Color To (local3)
Endif
@ Arg1, Arg2 Say "Ú"
@ Arg3, Arg2 Say "À" + Replicate("Ä", Arg4 - Arg2 - 1)
If (arg3 - Arg1 == 2)
   @ Arg1 + 1, Arg2 Say "³"
Else
   @ Arg1 + 1, Arg2 To Arg3 - 1, Arg2
Endif
If (arg5)
   Set Color To (local3)
Else
   Set Color To (local2)
Endif
If (arg3 - Arg1 == 2)
   @ Arg1 + 1, Arg4 Say "³"
Else
   @ Arg1 + 1, Arg4 To Arg3 - 1, Arg4
Endif
@ Arg1, Arg2 + 1 Say Replicate("Ä", Arg4 - Arg2 - 1) + "¿"
@ Arg3, Arg4 Say "Ù"
Set Color To (local4)
Return NIL