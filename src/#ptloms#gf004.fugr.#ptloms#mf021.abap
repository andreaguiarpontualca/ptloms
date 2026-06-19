FUNCTION /ptloms/mf021.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(RT_POINT) TYPE  /IWBEP/T_COD_SELECT_OPTIONS
*"     VALUE(RT_USUARIO_APP) TYPE  /IWBEP/T_COD_SELECT_OPTIONS
*"  EXPORTING
*"     VALUE(IT_DOCUMENTO_MEDICAO) TYPE  /PTLOMS/CT004
*"----------------------------------------------------------------------

*********************************************************************************************************
***  Trecho do código abaixo REVISADO em 30/04/2024 em função da incompatibilidade de versão com a SOLAR.
*********************************************************************************************************
***  INICIO - Vidal
*********************************************************************************************************

  DATA: o_oms TYPE REF TO /ptloms/cl001.

* Busca perfil do usuário
  IF rt_usuario_app[] IS NOT INITIAL.
*    SELECT usuario, perfil
*      FROM /ptloms/tb013
*      INTO TABLE @DATA(lt_tb013)
*      WHERE usuario IN @rt_usuario_app.

    DATA: lt_tb013 TYPE TABLE OF /ptloms/tb013,
          ls_tb013 TYPE /ptloms/tb013.

    SELECT usuario perfil
      FROM /ptloms/tb013
      INTO CORRESPONDING FIELDS OF TABLE lt_tb013
      WHERE usuario IN rt_usuario_app.

    IF lt_tb013[] IS NOT INITIAL.
*      READ TABLE lt_tb013 INTO DATA(ls_tb013) INDEX 1.
      READ TABLE lt_tb013 INTO ls_tb013 INDEX 1.

* Verfica se Usuário possui Confg. "Habilitar Histórico Doc.Medição"
*      SELECT SINGLE configuracao FROM /ptloms/tb044 INTO @DATA(lv_configuracao) WHERE perfil EQ @ls_tb013-perfil AND configuracao EQ '09'.
      DATA: lv_configuracao TYPE /ptloms/tb044-configuracao.
      CLEAR lv_configuracao.
      SELECT SINGLE configuracao FROM /ptloms/tb044 INTO lv_configuracao WHERE perfil EQ ls_tb013-perfil AND configuracao EQ '09'.
    ENDIF.
  ENDIF.

  IF lv_configuracao = '09'.

*    SELECT ult_doc_medicao
*      UP TO 1 ROWS
*      FROM /ptloms/tb033 INTO @DATA(lv_qtde).
*    ENDSELECT.

    DATA: lv_qtde TYPE /ptloms/tb033-ult_doc_medicao.
    CLEAR lv_qtde.
    SELECT ult_doc_medicao
      UP TO 1 ROWS
      FROM /ptloms/tb033 INTO lv_qtde.
    ENDSELECT.

    CREATE OBJECT o_oms.
    it_documento_medicao = o_oms->out_documento_medicao( rt_point       = rt_point
                                                         rt_usuario_app = rt_usuario_app
                                                         im_qtde        = lv_qtde ).
  ENDIF.

ENDFUNCTION.
