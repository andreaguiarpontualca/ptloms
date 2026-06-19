FUNCTION /ptloms/mf004.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     REFERENCE(IM_COMPONENTE) TYPE  /PTLOMS/ET039
*"  TABLES
*"      IT_RETURN STRUCTURE  BAPIRET2
*"----------------------------------------------------------------------
************************************************************************
***  Programa REVISADO em 06/05/2024 em função da
***  incompatibilidade de versão com a SOLAR.
************************************************************************
***  Consultora ABAP - Nádia Rodrigues
************************************************************************

* Declaração de tabelas interna
  DATA: lt_methods   TYPE STANDARD TABLE OF bapi_alm_order_method,
        lt_component TYPE STANDARD TABLE OF bapi_alm_order_component,
        lt_return    TYPE STANDARD TABLE OF bapiret2.

* Declaração de estruturas
  DATA: ls_methods   LIKE LINE OF lt_methods,
        ls_component LIKE LINE OF lt_component.

* Declaração de variáveis
  DATA: lv_aufnr    TYPE aufnr,
        lv_usuario  TYPE /ptloms/tb013-usuario,
        lv_contador TYPE i,
        lv_continua TYPE c LENGTH 1 VALUE 'X'.

* Verifica se COMPONENTE foi preenchido
  IF im_componente IS INITIAL.
    RETURN.
  ENDIF.

*  lv_aufnr = |{ im_componente-orderid ALPHA = IN }|.
  CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
    EXPORTING
      input  = im_componente-orderid
    IMPORTING
      output = lv_aufnr.

* Seleciona Centro da Ordem
*  SELECT SINGLE werks FROM aufk INTO @DATA(lv_werks) WHERE aufnr = @lv_aufnr.
  DATA: lv_werks   TYPE aufk-werks.
  SELECT SINGLE werks FROM aufk INTO lv_werks WHERE aufnr = lv_aufnr.

* Monta matrícula
  IF im_componente-usuario_app IS NOT INITIAL.
    lv_usuario = im_componente-usuario_app.
  ELSE.
    lv_usuario = sy-uname.
  ENDIF.

* Busca matrícula do usuário
*  SELECT SINGLE matricula FROM /ptloms/tb013 INTO @DATA(lv_matricula) WHERE usuario = @lv_usuario.
  DATA:  lv_matricula   TYPE /ptloms/tb013-matricula.
  SELECT SINGLE matricula FROM /ptloms/tb013 INTO lv_matricula WHERE usuario = lv_usuario.

* Carrega parâmetros da BAPI
  CLEAR ls_methods.
  ls_methods-refnumber = 1.
  ls_methods-objecttype = 'COMPONENT'.
  ls_methods-method     = 'CREATE'.
  ls_methods-objectkey  = im_componente-orderid.
  APPEND ls_methods TO lt_methods.

  CLEAR ls_methods.
  ls_methods-refnumber = 1.
  ls_methods-objecttype = space.
  ls_methods-method     = 'SAVE'.
  ls_methods-objectkey  = im_componente-orderid.
  APPEND ls_methods TO lt_methods.

  MOVE-CORRESPONDING im_componente TO ls_component.

  IF im_componente-plant IS INITIAL.
    ls_component-plant = lv_werks.
  ELSE.
    ls_component-plant = im_componente-plant.
  ENDIF.
  ls_component-item_cat = 'L'.

*  SELECT SINGLE rsnum FROM afko INTO @DATA(lv_rsnum) WHERE aufnr = @lv_aufnr.
  DATA: lv_rsnum   TYPE afko-rsnum.
  SELECT SINGLE rsnum FROM afko INTO lv_rsnum WHERE aufnr = lv_aufnr.

  IF sy-subrc EQ 0.
*    SELECT rsnum, rspos, rsart, posnr
*      FROM resb
*      INTO TABLE @DATA(lt_resb)
*      WHERE rsnum = @lv_rsnum.

    DATA:
      lt_resb TYPE TABLE OF resb,
      ls_resb TYPE resb.

    REFRESH:
      lt_resb.

    SELECT rsnum rspos rsart posnr
      FROM resb
      APPENDING CORRESPONDING FIELDS OF TABLE lt_resb
      WHERE rsnum = lv_rsnum.

    SORT lt_resb BY posnr DESCENDING.
*    READ TABLE lt_resb INTO DATA(ls_resb) INDEX 1.
    READ TABLE lt_resb INTO ls_resb INDEX 1.
    IF sy-subrc EQ 0.
      ls_component-item_number = ls_resb-posnr + 10.
      CALL FUNCTION 'CONVERSION_EXIT_NUMCV_INPUT'
        EXPORTING
          input  = ls_component-item_number
        IMPORTING
          output = ls_component-item_number.
    ENDIF.
  ENDIF.

  IF lv_matricula IS NOT INITIAL.
    ls_component-gr_rcpt = lv_matricula.
  ELSEIF lv_usuario IS NOT INITIAL.
    ls_component-gr_rcpt = lv_usuario.
  ENDIF.

*  ls_component-material = |{ ls_component-material ALPHA = IN }|.
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

*  ls_component-material = |{ ls_component-material ALPHA = IN }|.

* Verifica retorno
*  READ TABLE lt_return INTO DATA(ls_return) WITH KEY type = 'E'.
  DATA ls_return LIKE LINE OF lt_return.
  READ TABLE lt_return INTO ls_return WITH KEY type = 'E'.
  IF sy-subrc NE 0.
    CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
      EXPORTING
        wait = 'X'.
  ENDIF.

  it_return[] = lt_return[].

ENDFUNCTION.
