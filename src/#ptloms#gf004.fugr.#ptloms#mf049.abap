FUNCTION /ptloms/mf049.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  EXPORTING
*"     VALUE(EX_USUARIO_SAP) TYPE  FLAG
*"----------------------------------------------------------------------

  /ptloms/cl006=>verifica_usuario_sap( IMPORTING ex_usuario_sap = ex_usuario_sap ).

ENDFUNCTION.
