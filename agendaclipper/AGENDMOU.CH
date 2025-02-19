
/*
TITULO     : Agenda de Telefone
DATA       : 13/02/25
PROGRAMA   : AGENDMOU.CH
COMENTARIO : DIRETIVAS DE PRE-PROCESSADOR ( MOUSE )
*/
 
#define GE_NOEXIT 0
#define GE_ENTER  5
#define M_INICIALIZA       0   // Reseta o drive do mouse e retorna
                               // status
                               // AX tem status, -1 se hardware e software
                               // instalado, 0 se nao instalado.  BX tem
                               // numeros de botoes
#define M_CURSOR_ON        1   // Torna o cusror do mouse visivel
#define M_CURSOR_OFF       2   // Esconde o cursor do mouse
#define M_LER_STATUS       3   // Ler botao e status do posicao do mouse
                               // BX tem status do botao, bit 0 botao esq.,
                               // bit 1 botao dir. Se bits esta 0
                               // botao para cima, se 1 para baixo.
#define M_POS_CURSOR      4    // Seta posicao do cursor
#define M_INTERRUPCAO    51    // 0x33, vetor de interrupcao do mouse.
//
// -> Registradores
#define AX                1
#define BX                2
#define CX                3
#define DX                4
#define SI                5
#define DI                6
#define CFLAG             7
//
// -> Botoes do MOUSE
#define M_ESQUERDO  1
#define M_DIREITO   2
#define M_OS_DOIS   3
//
// -> Beep mouse
#define BEEP_MOUSE()   TONE( 200, 1 )
//
#command @ <row>, <col>                                                 ;
      => MOUSE( DESLIGA )                                               ;
       ; Scroll( <row>, <col>, <row> )                                  ;
       ; SetPos( <row>, <col> )                                         ;
       ; MOUSE( LIGA )

#command @ <top>, <left> CLEAR                                          ;
      => MOUSE( DESLIGA )                                               ;
       ; Scroll( <top>, <left> )                                        ;
       ; SetPos( <top>, <left> )                                        ;
       ; MOUSE( LIGA )


#command @ <top>, <left> CLEAR TO <bottom>, <right>                     ;
      => MOUSE( DESLIGA )                                               ;
       ; Scroll( <top>, <left>, <bottom>, <right> )                     ;
       ; SetPos( <top>, <left> )                                        ;
       ; MOUSE( LIGA )

#command @ <top>, <left>, <bottom>, <right> BOX <string>                ;
                                            [COLOR <color>]             ;
      => MOUSE( DESLIGA )                                               ;
       ; DispBox(                                                       ;
                  <top>, <left>, <bottom>, <right>, <string>            ;
                  [, <color> ]                                          ;
                )                                                       ;
       ; MOUSE( LIGA )


#command @ <top>, <left> TO <bottom>, <right> [DOUBLE]                  ;
                                              [COLOR <color>]           ;
      => MOUSE( DESLIGA )                                               ;
       ; DispBox(                                                       ;
                  <top>, <left>, <bottom>, <right>, 2                   ;
                  [, <color> ]                                          ;
                )                                                       ;
       ; MOUSE( LIGA )


#command @ <top>, <left> TO <bottom>, <right> [COLOR <color>]           ;
                                                                        ;
      => MOUSE( DESLIGA )                                               ;
       ; DispBox(                                                       ;
                  <top>, <left>, <bottom>, <right>, 1                   ;
                  [, <color> ]                                          ;
                )                                                       ;
       ; MOUSE( LIGA )

#command @ <row>, <col> SAY <xpr>                                       ;
                        [PICTURE <pic>]                                 ;
                        [COLOR <color>]                                 ;
                                                                        ;
      => MOUSE( DESLIGA )                                               ;
       ; DevPos( <row>, <col> )                                         ;
       ; DevOutPict( <xpr>, <pic> [, <color>] )                         ;
       ; MOUSE( LIGA )


#command @ <row>, <col> SAY <xpr>                                       ;
                        [COLOR <color>]                                 ;
                                                                        ;
      => MOUSE( DESLIGA )                                               ;
       ; DevPos( <row>, <col> )                                         ;
       ; DevOut( <xpr> [, <color>] )                                    ;
       ; MOUSE( LIGA )
**
**BI [INI] MOUSE.B01
**BI [FIM] MOUSE.B01
**
 
/* Final AGENDMOU.CH */