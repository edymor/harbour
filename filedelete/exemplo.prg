#include "hb.ch"

PROCEDURE Main()
    LOCAL cArquivo := "dados.txt"
    
    ExcluirArquivo( cArquivo )
RETURN

/*
 * Rotina para exclus∆o de arquivos
 */
FUNCTION ExcluirArquivo( cNomeArquivo )
    LOCAL lOK := .T.
    
    // Verifica se o nome do arquivo foi passado e n∆o est† vazio
    IF Empty( cNomeArquivo )
        ? "Erro: Nenhum nome de arquivo foi informado."
        lOK := .F.
    ENDIF

    // Verifica se o arquivo realmente existe no disco
    IF .NOT. File( cNomeArquivo ) .AND. lOK
        ? "Aviso: O arquivo '" + cNomeArquivo + "' nao foi encontrado."
        lOK := .F.
    ENDIF

    // Tenta excluir o arquivo usando a funá∆o FileDelete()
    IF FileDelete( cNomeArquivo ) .AND. lOK
        ? "Sucesso: O arquivo '" + cNomeArquivo + "' foi excluido com exito."
    ELSE
        // Caso a funá∆o retorne .F., exibe uma mensagem de erro genÇrica
        ? "Erro: Nao foi possivel excluir o arquivo '" + cNomeArquivo + "'."
        ? "Verifique se ele esta sendo usado por outro programa ou se voce tem permissoes."
        lOK := .F.
    ENDIF

RETURN lOK
