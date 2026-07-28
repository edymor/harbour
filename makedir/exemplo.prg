#include "hb.ch"

PROCEDURE MAIN
    LOCAL cDir
    
    IF MakeDir( cDir := hb_DirSepToOS( "./mydir" ) ) == 0
       ? "Directory", cDir, "successfully created"
    ENDIF

RETURN