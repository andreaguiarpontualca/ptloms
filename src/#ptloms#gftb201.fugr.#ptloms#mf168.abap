FUNCTION /ptloms/mf168.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IS_CLIENT_INFO) TYPE  /PTLOMS/ET211 OPTIONAL
*"  EXPORTING
*"     VALUE(ES_RESULT) TYPE  /PTLOMS/ET210
*"----------------------------------------------------------------------

  DATA:
    lo_login TYPE REF TO /ptloms/cl031.

  CLEAR es_result.

  CREATE OBJECT lo_login.

  CALL METHOD lo_login->validar_login_sap
    EXPORTING
      is_client_info = is_client_info
    IMPORTING
      es_result      = es_result.

ENDFUNCTION.
