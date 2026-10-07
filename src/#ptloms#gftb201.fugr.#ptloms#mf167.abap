FUNCTION /ptloms/mf167.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IV_USUARIO) TYPE  /PTLOMS/ED108
*"     VALUE(IV_SENHA) TYPE  CHAR32
*"     VALUE(IS_CLIENT_INFO) TYPE  /PTLOMS/ET211
*"  EXPORTING
*"     VALUE(ES_RESULT) TYPE  /PTLOMS/ET210
*"----------------------------------------------------------------------

  DATA:
    lo_login TYPE REF TO /ptloms/cl031.

*---------------------------------------------------------------------*
* Inicialização
*---------------------------------------------------------------------*
  CLEAR es_result.

*---------------------------------------------------------------------*
* Instanciar serviço de Login V2
*---------------------------------------------------------------------*
  CREATE OBJECT lo_login.

*---------------------------------------------------------------------*
* Delegar regra de negócio para a classe
*
* A Function Module atua somente como façade.
* Toda a lógica de autenticação OMS, situação cadastral,
* licenciamento e auditoria permanece centralizada na /PTLOMS/CL031.
*---------------------------------------------------------------------*
  CALL METHOD lo_login->validar_login_oms
    EXPORTING
      iv_usuario     = iv_usuario
      iv_senha       = iv_senha
      is_client_info = is_client_info
    IMPORTING
      es_result      = es_result.

ENDFUNCTION.
