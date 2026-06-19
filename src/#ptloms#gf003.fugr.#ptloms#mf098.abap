FUNCTION /ptloms/mf098.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  TABLES
*"      IT_RETURN STRUCTURE  BAPIRET2
*"  CHANGING
*"     VALUE(IM_COMPONENTE) TYPE  /PTLOMS/ET134 OPTIONAL
*"----------------------------------------------------------------------

*********************************************************************************************************
***  Trecho do código abaixo REVISADO em 30/04/2024 em função da incompatibilidade de versão com a SOLAR.
*********************************************************************************************************
***  INICIO - Renato Costa
*********************************************************************************************************

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
        lv_continua TYPE c LENGTH 1 VALUE 'X',
        lv_msg      TYPE char20,
        ls_tb060    TYPE /ptloms/tb060.

* Verifica se COMPONENTE foi preenchido
  IF im_componente IS INITIAL.
    RETURN.
  ENDIF.

  " Ordem não informada
  IF im_componente-orderid IS INITIAL.

    DATA: ls_return LIKE LINE OF lt_return.

    ls_return-type = 'E'.
    ls_return-message = 'Não foi possível gerar a reserva. Ordem não informada, verificar os sincronismos pendentes de Ordem e Nota com Ordem.'(033).
    ls_return-message_v1 = ''.

    INSERT ls_return INTO TABLE lt_return.

*    APPEND VALUE #( type = 'E' message = 'Não foi possível gerar a reserva. Ordem não informada, verificar os sincronismos pendentes de Ordem e Nota com Ordem.'(033) message_v1 = '' ) TO lt_return.
    it_return[] = lt_return[].
    EXIT.

  ENDIF.

  DATA lv_quantity TYPE bapi_alm_order_component_e-requirement_quantity_unit.
  lv_quantity = im_componente-requirement_quantity_unit.
*  DATA(lv_quantity) = im_componente-requirement_quantity_unit.
  " 13/04/2023 - No TILE de "Correções pendentes" estava enviando a UM e gerando erro na BAPI para criação do componente
  "CLEAR: im_componente-requirement_quantity_unit.

  CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
    EXPORTING
      input  = im_componente-orderid
    IMPORTING
      output = lv_aufnr.

*  lv_aufnr = |{ im_componente-orderid ALPHA = IN }|.

* Seleciona Centro da Ordem
  DATA lv_werks TYPE aufk-werks.
  SELECT SINGLE werks FROM aufk INTO lv_werks WHERE aufnr = lv_aufnr.
*  SELECT SINGLE werks FROM aufk INTO @DATA(lv_werks) WHERE aufnr = @lv_aufnr.

* Monta matrícula
  IF im_componente-usuario_app IS NOT INITIAL.
    lv_usuario = im_componente-usuario_app.
  ELSE.
    lv_usuario = sy-uname.
  ENDIF.

* Busca matrícula do usuário
  DATA lv_matricula TYPE /ptloms/tb013-matricula.
  SELECT SINGLE matricula FROM /ptloms/tb013 INTO lv_matricula WHERE usuario = lv_usuario.
*  SELECT SINGLE matricula FROM /ptloms/tb013 INTO @DATA(lv_matricula) WHERE usuario = @lv_usuario.

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
*  IF sy-subrc EQ 0.
*    SELECT rsnum, rspos, rsart, posnr
*      FROM resb
*      INTO TABLE @DATA(lt_resb)
*      WHERE rsnum = @lv_rsnum.

  DATA lv_rsnum TYPE afko-rsnum.
  SELECT SINGLE rsnum FROM afko INTO lv_rsnum WHERE aufnr = lv_aufnr.

  IF sy-subrc EQ 0.
*    SELECT rsnum, rspos, rsart, posnr
*      FROM resb
*      INTO TABLE @DATA(lt_resb)
*      WHERE rsnum = @lv_rsnum.
    DATA lt_resb TYPE TABLE OF resb.
    SELECT rsnum rspos rsart posnr
      FROM resb
      INTO CORRESPONDING FIELDS OF TABLE lt_resb
      WHERE rsnum = lv_rsnum.

    SORT lt_resb BY posnr DESCENDING.
    DATA ls_resb LIKE LINE OF lt_resb.
    READ TABLE lt_resb INTO ls_resb INDEX 1.
*    READ TABLE lt_resb INTO DATA(ls_resb) INDEX 1.
    IF sy-subrc EQ 0.
      ls_component-item_number = ls_resb-posnr + 10.
      CALL FUNCTION 'CONVERSION_EXIT_NUMCV_INPUT'
        EXPORTING
          input  = ls_component-item_number
        IMPORTING
          output = ls_component-item_number.
    ELSE.
      CALL FUNCTION 'CONVERSION_EXIT_NUMCV_INPUT'
        EXPORTING
          input  = '0010'
        IMPORTING
          output = ls_component-item_number.
    ENDIF.
  ENDIF.

  IF lv_matricula IS NOT INITIAL.
    ls_component-gr_rcpt = lv_matricula.
  ELSEIF lv_usuario IS NOT INITIAL.
    ls_component-gr_rcpt = lv_usuario.
  ENDIF.

  CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
    EXPORTING
      input  = ls_component-material
    IMPORTING
      output = ls_component-material.

* ls_component-material = |{ ls_component-material ALPHA = IN }|.

  CALL FUNCTION 'CONVERSION_EXIT_CUNIT_INPUT'
    EXPORTING
      input          = ls_component-requirement_quantity_unit
      language       = sy-langu
    IMPORTING
      output         = ls_component-requirement_quantity_unit
    EXCEPTIONS
      unit_not_found = 1
      OTHERS         = 2.

** IF sy-subrc <> 0.
*** Implement suitable error handling here
** ENDIF.

  APPEND ls_component TO lt_component.

* Chama BAPI para criação da Ordem
  CALL FUNCTION 'BAPI_ALM_ORDER_MAINTAIN'
    TABLES
      it_methods   = lt_methods
      it_component = lt_component
      return       = lt_return.

* Verifica retorno
  READ TABLE lt_return INTO ls_return WITH KEY type = 'E'.
*  READ TABLE lt_return INTO DATA(ls_return) WITH KEY type = 'E'.
  IF sy-subrc NE 0.
    CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
      EXPORTING
        wait = 'X'.
    IF lv_rsnum IS NOT INITIAL.
      DATA lv_number TYPE aposn.
      lv_number = ls_component-item_number / 10.
*      DATA(lv_number) = ls_component-item_number / 10.
*      lv_msg = |{ lv_rsnum ALPHA = OUT }| && |{ '/' }| && |{ lv_number }|.
      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
        EXPORTING
          input  = lv_rsnum
        IMPORTING
          output = lv_rsnum.

      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
        EXPORTING
          input  = lv_number
        IMPORTING
          output = lv_number.

      lv_msg = |{ lv_rsnum }| && |{ '/' }| && |{ lv_number }|.

      CONDENSE lv_msg NO-GAPS.
*      APPEND VALUE #( type = 'S' message = 'Reserva criada' message_v1 = lv_msg ) TO lt_return.

      ls_return-type = 'S'.
      ls_return-message = 'Reserva criada'.
      ls_return-message_v1 = lv_msg. " Supondo que lv_msg seja uma variável que contém a mensagem apropriada.

      INSERT ls_return INTO TABLE lt_return.


      " Gravar dados da reserva
      ls_tb060-rsnum                     = lv_rsnum.
      ls_tb060-rspos                     = ls_component-item_number.
      ls_tb060-aufnr                     = im_componente-orderid.
      ls_tb060-vornr                     = im_componente-activity.
      ls_tb060-usuario_app               = lv_usuario.
*      ls_tb060-matnr                     = |{ im_componente-material ALPHA = IN }|.
      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
        EXPORTING
          input  = im_componente-material
        IMPORTING
          output = ls_tb060-matnr.
      ls_tb060-uzeit                     = sy-uzeit.
      ls_tb060-datum                     = sy-datum.
      ls_tb060-equipament                = im_componente-equipment.
      ls_tb060-functloc                  = im_componente-functloc.
      ls_tb060-requirement_quantity      = im_componente-requirement_quantity.

*      CALL FUNCTION 'CONVERSION_EXIT_CUNIT_OUTPUT'
*        EXPORTING
*          input    = lv_quantity
*          language = sy-langu
*        IMPORTING
*          output   = lv_quantity.

      ls_tb060-requirement_quantity_unit = lv_quantity.

      MODIFY /ptloms/tb060 FROM ls_tb060.

    ENDIF.
  ENDIF.

  it_return[] = lt_return[].

ENDFUNCTION.
