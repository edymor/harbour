*//////////////////////////////////////
* Programa......: Madrel.prg
* Programadores.: Edvaldo E Jean
* Data E Hora...: 01/12/94   16:13:34
* Linguagem.....: Clipper Summer'87
* Objetivo......: Relatorio Do Sistema
*//////////////////////////////////////
**
Set Color To N/w
Sele 1
If File ('Madmovx.ntx')
   Use Madmov Index Madmovx
Else
   Telmens=savescreen(16,14,20,49)
   Relevo(16,14,20,47,.f.)
   @ 17,16 Say 'Indice N„o Encontrado !!!     '
   @ 18,16 Say 'Entre No Menu De Utilitarios  '
   @ 19,16 Say 'e Execute REORGANIZAR.        '
   Tone(300,3)
   Tone(400,2)
   Inkey(4)
   Restscreen(16,14,20,49,telmens)
   Return
Endif
Do While .t.
   If Lastkey() = 27
      Return
   Else
      If .not. Isprinter()
         Tone(3000,4)
         Telimp=savescreen(08,10,10,67)
         Relevo(08,10,10,67,.f.)
         @ 09,11 Clear To 09,66
         @ 09,12 Say 'Impressora Desligada Ou Desconectada !!! Ou ESC P/sair'
         Inkey(6)
         Restscreen(08,10,10,67,telimp)
         Loop
      Else
         Exit
      Endif
   Endif
Enddo
Telagu=savescreen(09,18,11,43)
Relevo(09,18,11,43,.f.)
@ 10,19 Clear To 10,42
@ 10,20 Say 'Aguarde Imprimindo...'
Set Device To Print
Linha=1
Pag=1
*
* -> Inicializa Variaveis De Totalizacao
*Tot0001=0
*Tot0002=0
Tot0003=0
Do While .not. Eof()
   If Linha=1
      Cab1="GRUPO J. RECAMONDE          RELATORIO DE MADEIRAS"
      Cab2="J. RECAMONDE & CIA. LTDA.   ESPESSURA.:"
      **
      ** Bloco De Inser‡„o R01.b22
      **
      @ 01,01 Say Cab1
      @ 01, 61 Say "PAGINA: "+subs(str(pag+10000,5),2)
      Pag=pag+1
      @ 02,01 Say Cab2
      @ 02,41 Say Xal Pict [@R 999.99]
      @ 02,48 Say 'cm'
      @ 02, 61 Say "DATA: "
      @ 02, 67 Say Date()
      @ 04,01 Say Repl("-", 74)
      @ 05,001 Say "REG"
      @ 05,013 Say "COMP M"
      @ 05,039 Say "LARG Cm"
      @ 05,064 Say "VOL M3"
      @ 06,01 Say Repl("-", 74)
      Linha=07
   Endif
   @ Linha,001 Say Registra Picture "9999"
   @ Linha,013 Say Compriment Picture "9,999,999.99"
   @ Linha,039 Say Largura Picture "9,999,999.99"
   @ Linha,064 Say Volume Picture "99,999.9999"
   *
   * -> Totalizacao De Campo Numericos
   *Tot0001=Tot0001+Compriment
   *Tot0002=Tot0002+Largura
   Tot0003=tot0003+volume
   Linha=linha+1
   Skip
   If Linha>58 .or. Eof()
      If Eof()
         Tot_01(2)
      Else
         Tot_01(1)
      Endif
      Linha=1
   Endif
Enddo
Eject
Set Devi To Screen
Restscreen(09,18,11,43,telagu)
Set Color To W+/w
Close Data
Return
****************
Function Tot_01
****************
*
* -> Funcao De Impressao Da Totalizacao
Para Par1
If Par1=2
   Linha=59
Endif
@ Linha+0,01 Say Repl("-", 74)
If Par1=2
   @ Linha+1,001 Say "TOTAL"
Else
   @ Linha+1,001 Say "SUBTOTAL"
Endif
*@ Linha+1,011 Say Tot0001 Picture "999,999,999.99"
*@ Linha+1,037 Say Tot0002 Picture "999,999,999.99"
@ Linha+1,061 Say Tot0003 Picture "9,999,999.9999"
@ Linha+2,01 Say Repl("-", 74)

* Final Do Programa MMR01.PRG
