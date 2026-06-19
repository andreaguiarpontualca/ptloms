FUNCTION /ptloms/mf132.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     REFERENCE(IM_AUFNR) TYPE  AUFNR
*"     REFERENCE(IM_VORNR) TYPE  VORNR
*"  TABLES
*"      IT_RETURN STRUCTURE  BAPIRET2
*"----------------------------------------------------------------------

*********************************************************************************************************
***  Trecho do código abaixo REVISADO em 11/12/2025 em função da incompatibilidade de versão com a SOLAR.
*********************************************************************************************************
***  INICIO - Iury Silva
*********************************************************************************************************

  DATA: lv_objecttype TYPE objidext.

  DATA: lt_methods      TYPE STANDARD TABLE OF bapi_alm_order_method,
        lt_operation    TYPE STANDARD TABLE OF bapi_alm_order_operation,
        lt_operation_up TYPE STANDARD TABLE OF bapi_alm_order_operation_up,
        lt_return       TYPE STANDARD TABLE OF bapiret2,
        ti_tb066        TYPE TABLE OF /ptloms/tb066.

  DATA: ls_methods      LIKE LINE OF lt_methods,
        ls_operation    LIKE LINE OF lt_operation,
        ls_operation_up LIKE LINE OF lt_operation_up,
        ls_return       LIKE LINE OF it_return.

  DATA lv_aufnr TYPE char12.

  CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
    EXPORTING
      input  = im_aufnr
    IMPORTING
      output = lv_aufnr.

*  SELECT *
*    FROM /ptloms/tb065
*    INTO TABLE @DATA(ti_tb065)
*    WHERE aufnr = @lv_aufnr AND
*          vornr = @im_vornr.
  SELECT *
    FROM /ptloms/tb066
    INTO TABLE ti_tb066
    WHERE aufnr = lv_aufnr AND
          vornr = im_vornr AND
          ( status NE 4 AND status NE 5 ).

  IF sy-subrc IS INITIAL.

**    DATA(qtde) = lines( ti_tb065 ).
*    DATA(qtde) = lines( ti_tb066 ).

    DATA qtde TYPE i.
    DESCRIBE TABLE ti_tb066 LINES qtde.

* monta objecttype
*    lv_objecttype = |{ im_aufnr ALPHA = IN }| && im_vornr.

    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
      EXPORTING
        input  = im_aufnr
      IMPORTING
        output = lv_objecttype.

    CONCATENATE lv_objecttype im_vornr INTO lv_objecttype.

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
    ls_operation-activity             = im_vornr.
    ls_operation-number_of_capacities = qtde.
    APPEND ls_operation TO lt_operation.

    CLEAR ls_operation_up.
    ls_operation_up-number_of_capacities = 'X'.
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

    LOOP AT lt_return INTO ls_return_aux .
      MOVE-CORRESPONDING ls_return_aux TO ls_return.
      APPEND ls_return TO it_return.
    ENDLOOP.

  ENDIF.

*********************************************************************************************************
***  FIM - Iury Silva
*********************************************************************************************************

ENDFUNCTION.
