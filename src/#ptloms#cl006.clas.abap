class /PTLOMS/CL006 definition
  public
  final
  create public .

public section.

  class-methods BUSCA_USUARIO
    importing
      !IM_USUARIO type XUBNAME
    returning
      value(RM_USUARIO) type XUBNAME .
  class-methods BUSCA_DADOS_EQUI
    importing
      !IM_EQUNR type EQUNR
    exporting
      !EX_SUBMT type SUBMT
      !EX_IWERK type IWERK .
  class-methods BUSCA_DADOS_LOCL
    importing
      !IM_TPLNR type TPLNR
    exporting
      !EX_SUBMT type SUBMT
      !EX_IWERK type IWERK .
  class-methods BUSCA_DADOS_MATNR
    importing
      !IM_MATNR type MATNR
    exporting
      !EX_MAKTX type MAKTX .
  class-methods BUSCA_DADOS_USUARIO
    importing
      !IM_USUARIO type XUBNAME
    exporting
      !EX_NOME type AD_NAMTEXT .
  class-methods BUSCA_DADOS_CENTRO_PERFIL
    importing
      value(RT_PERFIL) type /IWBEP/T_COD_SELECT_OPTIONS
    exporting
      value(ET_DADO_CENTRO_PERFIL) type /PTLOMS/CT160 .
  class-methods VERIFICA_USUARIO_SAP
    exporting
      value(EX_USUARIO_SAP) type FLAG .
  class-methods VERIFICA_PERMISSAO_CENTRO
    importing
      !IM_TCODE type BP_TCODE
      !IM_WERKS type WERKS_D
    exporting
      value(EX_POSSUI_PERMISSAO) type CHAR1 .
  class-methods VERIFICA_CENTRO_PERFIL
    importing
      !IM_PERFIL type /PTLOMS/ED006
      !IM_WERKS type WERKS_D
    exporting
      value(EX_SUBRC) type SY-SUBRC .
protected section.
private section.
ENDCLASS.



CLASS /PTLOMS/CL006 IMPLEMENTATION.


  METHOD busca_dados_centro_perfil.

    DATA: lt_tb014              TYPE TABLE OF /ptloms/tb014,
          ls_tb014              TYPE /ptloms/tb014,
          ls_dado_centro_perfil LIKE LINE OF et_dado_centro_perfil.

    IF rt_perfil IS NOT INITIAL.

      SELECT *
        FROM /ptloms/tb014
        INTO TABLE lt_tb014
        WHERE perfil IN rt_perfil.

      IF lt_tb014 IS NOT INITIAL.

        CLEAR ls_tb014.
        LOOP AT lt_tb014 INTO ls_tb014.

          CLEAR ls_dado_centro_perfil.
          MOVE-CORRESPONDING ls_tb014 TO ls_dado_centro_perfil.
          ls_dado_centro_perfil-chave = 'X'.
          APPEND ls_dado_centro_perfil TO et_dado_centro_perfil.

        ENDLOOP.

      ENDIF.

    ENDIF.

  ENDMETHOD.


  METHOD busca_dados_equi.

*********************************************************************************************************
***  Trecho do código abaixo REVISADO em 02/05/2024 em função da incompatibilidade de versão com a SOLAR.
*********************************************************************************************************
***  INICIO - André Aguiar
*********************************************************************************************************

    DATA: lv_equnr TYPE equnr.

    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
      EXPORTING
        input  = im_equnr
      IMPORTING
        output = lv_equnr.

*    lv_equnr = |{ im_equnr ALPHA = IN }|.

***    SELECT SINGLE submt iwerk FROM equz INTO ( ex_submt, ex_iwerk ) WHERE equnr = lv_equnr
***                                                                      AND datbi = '99991231'.

    SELECT SINGLE submt iwerk FROM equz INTO (ex_submt, ex_iwerk) WHERE equnr = lv_equnr
                                                                    AND datbi = '99991231'.
  ENDMETHOD.


  METHOD busca_dados_locl.

*********************************************************************************************************
***  Trecho do código abaixo REVISADO em 02/05/2024 em função da incompatibilidade de versão com a SOLAR.
*********************************************************************************************************
***  INICIO - André Aguiar
*********************************************************************************************************

    DATA: lv_tplnr TYPE tplnr.

    CALL FUNCTION 'CONVERSION_EXIT_TPLNR_INPUT'
      EXPORTING
        input  = im_tplnr
*       I_FLG_CHECK_INTERNAL       = 'X'
      IMPORTING
        output = lv_tplnr.

    SELECT SINGLE submt iwerk FROM iflot INTO (ex_submt, ex_iwerk) WHERE tplnr = lv_tplnr.
*    SELECT SINGLE submt iwerk FROM iflot INTO ( ex_submt, ex_iwerk ) WHERE tplnr = lv_tplnr.
  ENDMETHOD.


  METHOD busca_dados_matnr.

*********************************************************************************************************
***  Trecho do código abaixo REVISADO em 02/05/2024 em função da incompatibilidade de versão com a SOLAR.
*********************************************************************************************************
***  INICIO - André Aguiar
*********************************************************************************************************

    DATA: lv_matnr TYPE matnr.

    CALL FUNCTION 'CONVERSION_EXIT_MATN1_INPUT'
      EXPORTING
        input  = im_matnr
      IMPORTING
        output = lv_matnr.

    SELECT SINGLE maktx
      FROM makt
      INTO ex_maktx
      WHERE matnr = lv_matnr
        AND spras = sy-langu.

  ENDMETHOD.


  METHOD busca_dados_usuario.

    SELECT SINGLE nome FROM /ptloms/tb013 INTO ex_nome WHERE usuario = im_usuario.

  ENDMETHOD.


  METHOD busca_usuario.

    DATA: lv_usuario_sap TYPE /ptloms/tb033.

    SELECT SINGLE usuario_sap FROM /ptloms/tb033 INTO CORRESPONDING FIELDS OF lv_usuario_sap.
    IF lv_usuario_sap = 'X'.
      rm_usuario = sy-uname.
    ELSE.
      rm_usuario = im_usuario.
    ENDIF.

  ENDMETHOD.


  METHOD verifica_centro_perfil.

*********************************************************************************************************
***  Trecho do código abaixo REVISADO em 02/05/2024 em função da incompatibilidade de versão com a SOLAR.
*********************************************************************************************************
***  INICIO - André Aguiar
*********************************************************************************************************

    DATA: ls_tb014 TYPE /ptloms/tb014.

    SELECT *
      FROM /ptloms/tb014
      INTO CORRESPONDING FIELDS OF ls_tb014
      UP TO 1 ROWS
      WHERE perfil EQ im_perfil
        AND werks  EQ im_werks.
    ENDSELECT.

    IF sy-subrc EQ 0.
      ex_subrc = 0.
    ELSE.
      ex_subrc = 4.
    ENDIF.

  ENDMETHOD.


  METHOD verifica_permissao_centro.

    AUTHORITY-CHECK OBJECT '/PTLOMS/07'
             ID 'TCD'   FIELD im_tcode
             ID 'WERKS' FIELD im_werks.
    IF sy-subrc EQ 0.
      ex_possui_permissao = 'X'.
    ENDIF.

  ENDMETHOD.


  METHOD verifica_usuario_sap.

    SELECT SINGLE usuario_sap FROM /ptloms/tb033 INTO ex_usuario_sap.

  ENDMETHOD.
ENDCLASS.
