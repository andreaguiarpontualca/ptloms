FUNCTION /ptloms/mf036.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     REFERENCE(IM_AUFNR) TYPE  AUFNR
*"     REFERENCE(IM_VORNR) TYPE  VORNR
*"     REFERENCE(IM_USUARIO) TYPE  XUBNAME
*"     REFERENCE(IM_DESASSOCIAR) TYPE  CHAR1 OPTIONAL
*"  TABLES
*"      IT_RETURN STRUCTURE  BAPIRET2
*"----------------------------------------------------------------------
*********************************************************************************************************
***  Trecho do código abaixo REVISADO em 06/05/2024 em função da incompatibilidade de versão com a SOLAR.
*********************************************************************************************************
***  Bretz
*********************************************************************************************************

* Declaração de estrutura
  DATA: ls_return LIKE LINE OF it_return.

* Declaração de variáveis
  DATA: lv_aufnr   TYPE aufnr,
        lv_vornr   TYPE vornr,
        lv_usuario TYPE xubname.

* Declarações para a BAPI

* Declaração de tabelas interna
  DATA: lt_methods      TYPE STANDARD TABLE OF bapi_alm_order_method,
        lt_operation    TYPE STANDARD TABLE OF bapi_alm_order_operation,
        lt_operation_up TYPE STANDARD TABLE OF bapi_alm_order_operation_up,
        lt_return       TYPE STANDARD TABLE OF bapiret2.

* Declaração de estruturas
  DATA: ls_methods      LIKE LINE OF lt_methods,
        ls_operation    LIKE LINE OF lt_operation,
        ls_operation_up LIKE LINE OF lt_operation_up.

* Declaração de variáveis
  DATA: lv_objecttype TYPE objidext.

* Validações iniciais
  IF im_aufnr IS INITIAL OR im_vornr IS INITIAL.
    CLEAR ls_return.
    ls_return-type    = 'E'.
    ls_return-message = 'Ordem e/ou Operação não preenchido'(014).
    APPEND ls_return TO it_return.
    RETURN.
  ENDIF.

* Monta parâmetros
*** lv_aufnr = |{ im_aufnr ALPHA = IN }|.
  CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
    EXPORTING
      input  = im_aufnr
    IMPORTING
      output = lv_aufnr.

  CALL FUNCTION 'CONVERSION_EXIT_NUMCV_INPUT'
    EXPORTING
      input  = im_vornr
    IMPORTING
      output = lv_vornr.

  IF im_desassociar IS INITIAL.

    IF im_usuario IS NOT INITIAL.
      lv_usuario = im_usuario.
    ELSE.
*      lv_usuario = sy-uname.
      lv_usuario = ''.
    ENDIF.

*   Busca dados do usuário
    DATA: ls_013 TYPE /ptloms/tb013.
    SELECT SINGLE usuario associa matricula
      FROM /ptloms/tb013
      INTO CORRESPONDING FIELDS OF ls_013
      WHERE usuario = lv_usuario.

***    SELECT SINGLE usuario, associa, matricula
***      FROM /ptloms/tb013
***      INTO @DATA(ls_013)
***      WHERE usuario = @lv_usuario.

* Verifica se no cadastro do usuário está configura para associar a Matrícula à Operação
    IF ls_013-associa IS INITIAL.
      CLEAR ls_return.
      ls_return-type    = 'W'.
*      ls_return-type    = 'E'.

      CONCATENATE 'Usuário'(015) lv_usuario 'não possui configuração para'(016) 'associar Matrícula à Operação'(017) INTO ls_return-message SEPARATED BY space.

      APPEND ls_return TO it_return.
      RETURN.
    ENDIF.

* Verifica se no cadastro do usuário está configura para associar a Matrícula à Operação
    IF ls_013-matricula IS INITIAL.
      CLEAR ls_return.
      ls_return-type    = 'E'.

      CONCATENATE 'Usuário'(015) lv_usuario 'não possui matrícula configurada'(018) INTO ls_return-message SEPARATED BY space.
      APPEND ls_return TO it_return.
      RETURN.
    ENDIF.
  ENDIF.

* Monta OBJECTTYPE
  lv_objecttype = lv_aufnr && lv_vornr.

* Carrega parâmetros da BAPI
  ls_methods-refnumber = 1.
  ls_methods-objecttype = space.
  ls_methods-method     = 'SAVE'.
  ls_methods-objectkey  = lv_objecttype.
  APPEND ls_methods TO lt_methods.

  CLEAR ls_methods.
  ls_methods-refnumber = 1.
  ls_methods-objecttype = 'OPERATION'.
  ls_methods-method     = 'CHANGE'.
  ls_methods-objectkey  = lv_objecttype.
  APPEND ls_methods TO lt_methods.

  CLEAR ls_operation.
  ls_operation-activity     = lv_vornr.
  IF im_desassociar IS INITIAL.
    ls_operation-pers_no = ls_013-matricula.
  ENDIF.
  APPEND ls_operation TO lt_operation.

  CLEAR ls_operation_up.
  ls_operation_up-pers_no = 'X'.
  APPEND ls_operation_up TO lt_operation_up.

* Chama BAPI Associar Matrícula à Opeação da Ordem
  CALL FUNCTION 'BAPI_ALM_ORDER_MAINTAIN'
    TABLES
      it_methods      = lt_methods
      it_operation    = lt_operation
      it_operation_up = lt_operation_up
      return          = lt_return.

* Verifica retorno
  DATA ls_return_aux LIKE LINE OF lt_return.
  READ TABLE lt_return INTO ls_return_aux WITH KEY type = 'E'.
  IF sy-subrc NE 0.
    CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
      EXPORTING
        wait = 'X'.
  ENDIF.

***  LOOP AT lt_return ASSIGNING FIELD-SYMBOL(<fs_return>).
  FIELD-SYMBOLS: <fs_return> LIKE LINE OF lt_return.
  LOOP AT lt_return ASSIGNING <fs_return>.

*** lv_aufnr = |{ lv_aufnr ALPHA = OUT }|.

    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
      EXPORTING
        input  = lv_aufnr
      IMPORTING
        output = lv_aufnr.

    CONDENSE lv_aufnr NO-GAPS.
    <fs_return>-message_v3 = |{ text-021 }| & | | & |{ lv_aufnr }|.
    <fs_return>-message_v4 = |{ text-022 }| & | | & |{ lv_vornr }|.

  ENDLOOP.

  APPEND LINES OF lt_return TO it_return.

ENDFUNCTION.
