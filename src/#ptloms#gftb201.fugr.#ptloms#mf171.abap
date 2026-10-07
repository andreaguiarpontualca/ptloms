FUNCTION /ptloms/mf171.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IV_USUARIO) TYPE  /PTLOMS/ED108
*"  EXPORTING
*"     VALUE(ET_AUTORIZACAO) TYPE  /PTLOMS/CT076
*"     VALUE(ES_RESULT) TYPE  /PTLOMS/ET213
*"----------------------------------------------------------------------

  DATA:
    lo_contexto TYPE REF TO /ptloms/cl031.

*---------------------------------------------------------------------*
* Inicialização
*---------------------------------------------------------------------*
  CLEAR es_result.

  REFRESH et_autorizacao.

*---------------------------------------------------------------------*
* A Function Module atua somente como façade.
*
* Responsabilidade:
* - receber o usuário;
* - delegar a recuperação das autorizações para /PTLOMS/CL031;
* - retornar /PTLOMS/CT076;
* - retornar resultado funcional /PTLOMS/ET213.
*---------------------------------------------------------------------*
  CREATE OBJECT lo_contexto.

  CALL METHOD lo_contexto->buscar_autorizacoes
    EXPORTING
      iv_usuario     = iv_usuario
    IMPORTING
      et_autorizacao = et_autorizacao
      es_result      = es_result.

ENDFUNCTION.
