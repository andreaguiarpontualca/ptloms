FUNCTION /ptloms/mf005.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     REFERENCE(IM_COMPONENTE) TYPE  /PTLOMS/ET039
*"  TABLES
*"      IT_RETURN STRUCTURE  BAPIRET2
*"----------------------------------------------------------------------

* Declaração de tabelas interna
  DATA: lt_methods   TYPE STANDARD TABLE OF bapi_alm_order_method,
        lt_component TYPE STANDARD TABLE OF bapi_alm_order_component,
        lt_return    TYPE STANDARD TABLE OF bapiret2.

* Declaração de estruturas
  DATA: ls_methods    LIKE LINE OF lt_methods,
        ls_component  LIKE LINE OF lt_component,
        ls_return_aux LIKE LINE OF it_return.

  DATA: lv_contador TYPE i,
        lv_continua TYPE c LENGTH 1 VALUE 'X'.

* Verifica se COMPONENTE foi preenchido
  IF im_componente IS INITIAL.
    RETURN.
  ENDIF.

* Verifica se reserva foi utilizada
***  SELECT SINGLE enmng FROM resb INTO @DATA(lv_enmng) WHERE rsnum = @im_componente-reserv_no
***                                                       AND rspos = @im_componente-res_item
***                                                       AND enmng <> 0.

  DATA: lv_enmng TYPE resb-enmng.
  SELECT SINGLE enmng FROM resb INTO lv_enmng WHERE rsnum = im_componente-reserv_no
                                                AND rspos = im_componente-res_item
                                                AND enmng <> 0.

  IF sy-subrc EQ 0.
    ls_return_aux-type = 'E'.
    ls_return_aux-message = 'Componente já foi utilizada. Não pode ser removido'(013).
    APPEND ls_return_aux TO it_return.
    RETURN.
  ENDIF.

* Carrega parâmetros da BAPI
  CLEAR ls_methods.
  ls_methods-refnumber = 1.
  ls_methods-objecttype = 'COMPONENT'.
  ls_methods-method     = 'DELETE'.
  ls_methods-objectkey  = im_componente-orderid.
  APPEND ls_methods TO lt_methods.

  CLEAR ls_methods.
  ls_methods-refnumber = 1.
  ls_methods-objecttype = space.
  ls_methods-method     = 'SAVE'.
  ls_methods-objectkey  = im_componente-orderid.
  APPEND ls_methods TO lt_methods.

  MOVE-CORRESPONDING im_componente TO ls_component.

***  ls_component-material = |{ ls_component-material ALPHA = IN }|.

  CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
    EXPORTING
      input  = ls_component-material
    IMPORTING
      output = ls_component-material.


  APPEND ls_component TO lt_component.

*  WHILE lv_continua = 'X'.

* Chama BAPI para criação da Ordem
  CALL FUNCTION 'BAPI_ALM_ORDER_MAINTAIN'
    TABLES
      it_methods   = lt_methods
      it_component = lt_component
      return       = lt_return.

*    READ TABLE lt_return TRANSPORTING NO FIELDS WITH KEY type   = 'E'
*                                                         id     = 'IWO_BAPI'
*                                                         number = 124.
*    IF sy-subrc NE 0.
*      CLEAR lv_continua.
*    ENDIF.
*    IF lv_contador = 1000.
*      CLEAR lv_continua.
*    ENDIF.
*    lv_contador = lv_contador + 1.
*  ENDWHILE.

* Verifica retorno

***  READ TABLE lt_return INTO DATA(ls_return) WITH KEY type = 'E'.
  DATA: ls_return LIKE LINE OF lt_return.
  READ TABLE lt_return INTO ls_return WITH KEY type = 'E'.

  IF sy-subrc NE 0.
    CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
      EXPORTING
        wait = 'X'.
  ENDIF.

  it_return[] = lt_return[].

ENDFUNCTION.
