FUNCTION /ptloms/mf169.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IV_USUARIO) TYPE  /PTLOMS/ED108
*"  EXPORTING
*"     VALUE(ES_USUARIO) TYPE  /PTLOMS/ET212
*"     VALUE(ES_RESULT) TYPE  /PTLOMS/ET213
*"----------------------------------------------------------------------

  DATA:
    lo_contexto TYPE REF TO /ptloms/cl031.

*---------------------------------------------------------------------*
* Inicialização
*---------------------------------------------------------------------*
  CLEAR:
    es_usuario,
    es_result.

*---------------------------------------------------------------------*
* A Function Module atua somente como façade.
*
* Responsabilidade:
* - receber o usuário;
* - delegar a recuperação dos dados funcionais para /PTLOMS/CL031;
* - retornar os dados sanitizados do usuário e o resultado.
*
* Não recupera:
* - autorizações;
* - configurações de perfil;
* - configurações de sistema.
*
* Esses blocos são tratados pelas funções MF171, MF172 e MF173.
*---------------------------------------------------------------------*
  CREATE OBJECT lo_contexto.

  CALL METHOD lo_contexto->buscar_dados_usuario
    EXPORTING
      iv_usuario = iv_usuario
    IMPORTING
      es_usuario = es_usuario
      es_result  = es_result.

ENDFUNCTION.
