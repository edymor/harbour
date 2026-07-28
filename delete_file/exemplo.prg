#include "Directry.ch"

PROCEDURE Main()
  LOCAL aDir := Directory( "*.ntx" )
  LOCAL i, imax := Len( aDir )

  FOR i:=1 TO imax
     DELETE FILE ( aDir[i,F_NAME] )
  NEXT
  
RETURN
