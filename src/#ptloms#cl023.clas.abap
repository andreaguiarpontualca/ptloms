CLASS /ptloms/cl023 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.

    TYPES:
      BEGIN OF ty_read_result,
        success      TYPE abap_bool,
        reason_code  TYPE char30,
        message      TYPE string,
        license_data TYPE /ptloms/tb098,
      END OF ty_read_result.

    METHODS get_active_by_plant
      IMPORTING
        iv_werks         TYPE werks_d
      RETURNING
        VALUE(rs_result) TYPE ty_read_result.

  PRIVATE SECTION.

ENDCLASS.



CLASS /PTLOMS/CL023 IMPLEMENTATION.


  METHOD get_active_by_plant.

    DATA:
      lt_license TYPE STANDARD TABLE OF /ptloms/tb098
                 WITH DEFAULT KEY,
      lv_count   TYPE i.

    CLEAR rs_result.
    rs_result-success = abap_false.

    IF iv_werks IS INITIAL.
      rs_result-reason_code = 'EMPTY_PLANT'.
      rs_result-message =
        'Centro não informado para consulta da licença.'.
      RETURN.
    ENDIF.

*---------------------------------------------------------------------*
* Buscar no máximo duas licenças ativas.
* Mais de uma licença ativa representa inconsistência de dados.
*---------------------------------------------------------------------*
    SELECT *
      FROM /ptloms/tb098
      INTO TABLE lt_license
      UP TO 2 ROWS
      WHERE werks  = iv_werks
        AND active = abap_true
      ORDER BY PRIMARY KEY.

    IF sy-subrc <> 0 OR lt_license IS INITIAL.
      rs_result-reason_code = 'LICENSE_NOT_FOUND'.
      rs_result-message =
        |Não existe licença OMS ativa para o centro { iv_werks }.|.
      RETURN.
    ENDIF.

    DESCRIBE TABLE lt_license LINES lv_count.

    IF lv_count > 1.
      rs_result-reason_code = 'MULTIPLE_ACTIVE_LICENSES'.
      rs_result-message =
        |Existe mais de uma licença OMS ativa para o centro { iv_werks }.|.
      RETURN.
    ENDIF.

    READ TABLE lt_license INDEX 1
      INTO rs_result-license_data.

    IF sy-subrc <> 0.
      rs_result-reason_code = 'LICENSE_READ_ERROR'.
      rs_result-message =
        'Não foi possível recuperar o registro da licença.'.
      RETURN.
    ENDIF.

    rs_result-success     = abap_true.
    rs_result-reason_code = 'SUCCESS'.
    rs_result-message     =
      'Licença ativa localizada.'.

  ENDMETHOD.
ENDCLASS.
