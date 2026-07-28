#include "hb.ch"

PROCEDURE Main()
    LOCAL cArquivo := "relatorio.bak"

    // Executa a rotina de exclus∆o baseada na DeleteFile()
    ExcluirComDeleteFile( cArquivo )
RETURN

/*
 * Rotina para exclus∆o de arquivo usando DeleteFile()
 */
FUNCTION ExcluirComDeleteFile( cNomeArquivo )
    LOCAL nResultado
    LOCAL lOK := .T.

    // Verifica se o nome do arquivo foi preenchido
    IF Empty( cNomeArquivo )
        ? "Erro: Nome do arquivo nao informado."
        lOK := .F.
    ENDIF
    
    IF lOk
        // Executa a funá∆o DeleteFile() e captura o c¢digo de retorno
        nResultado := DeleteFile( cNomeArquivo )

        // Analisa o retorno numÇrico da funá∆o
        IF nResultado == 0
            ? "Sucesso: O arquivo '" + cNomeArquivo + "' foi excluido de forma segura."
        ELSE
            ? "Erro ao excluir o arquivo '" + cNomeArquivo + "'. Codigo de retorno: " + AllTrim(Str(nResultado))
            lOk := .F.    
            // Tratamento comum de erros para esta funá∆o
            DO CASE
            CASE nResultado == -2
                ? "Motivo: Arquivo nao encontrado."
            CASE nResultado == -5
                ? "Motivo: Acesso negado! O arquivo pode estar aberto ou e apenas de leitura."
            OTHERWISE
                ? "Motivo: Erro desconhecido do Sistema Operacional."
            ENDCASE
        ENDIF
    ENDIF
    
RETURN lOk
