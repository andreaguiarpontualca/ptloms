FUNCTION /ptloms/mf173.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IV_USUARIO) TYPE  /PTLOMS/ED108
*"  EXPORTING
*"     VALUE(ET_CONFIG_SISTEMA) TYPE  /PTLOMS/CT074
*"     VALUE(ES_RESULT) TYPE  /PTLOMS/ET213
*"----------------------------------------------------------------------

  DATA:
    lo_contexto TYPE REF TO /ptloms/cl031.

*---------------------------------------------------------------------*
* Inicialização
*---------------------------------------------------------------------*
  CLEAR es_result.

  REFRESH et_config_sistema.

*---------------------------------------------------------------------*
* A Function Module atua somente como façade.
*
* Responsabilidade:
* - receber o usuário;
* - delegar a recuperação das configurações do sistema para
*   /PTLOMS/CL031;
* - aplicar, pela classe, as configurações específicas do perfil;
* - retornar /PTLOMS/CT074;
* - retornar resultado funcional /PTLOMS/ET213.
*---------------------------------------------------------------------*
  CREATE OBJECT lo_contexto.

  CALL METHOD lo_contexto->buscar_config_sistema
    EXPORTING
      iv_usuario        = iv_usuario
    IMPORTING
      et_config_sistema = et_config_sistema
      es_result         = es_result.

ENDFUNCTION.
