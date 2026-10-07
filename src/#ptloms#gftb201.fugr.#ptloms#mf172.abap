FUNCTION /ptloms/mf172.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IV_USUARIO) TYPE  /PTLOMS/ED108
*"  EXPORTING
*"     VALUE(ET_CONFIG_PERFIL) TYPE  /PTLOMS/CT078
*"     VALUE(ES_RESULT) TYPE  /PTLOMS/ET213
*"----------------------------------------------------------------------

  DATA:
    lo_contexto TYPE REF TO /ptloms/cl031.

*---------------------------------------------------------------------*
* Inicialização
*---------------------------------------------------------------------*
  CLEAR es_result.

  REFRESH et_config_perfil.

*---------------------------------------------------------------------*
* A Function Module atua somente como façade.
*
* Responsabilidade:
* - receber o usuário;
* - delegar a recuperação das configurações do perfil para
*   /PTLOMS/CL031;
* - retornar /PTLOMS/CT078;
* - retornar resultado funcional /PTLOMS/ET213.
*---------------------------------------------------------------------*
  CREATE OBJECT lo_contexto.

  CALL METHOD lo_contexto->buscar_config_perfil
    EXPORTING
      iv_usuario       = iv_usuario
    IMPORTING
      et_config_perfil = et_config_perfil
      es_result        = es_result.

ENDFUNCTION.
