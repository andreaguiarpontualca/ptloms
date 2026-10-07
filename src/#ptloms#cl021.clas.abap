CLASS /ptloms/cl021 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC.

  PUBLIC SECTION.

    TYPES:
      BEGIN OF ty_license,
        werks          TYPE werks_d,
        license_id     TYPE sysuuid_c32,
        active         TYPE boole_d,
        valid_from     TYPE dats,
        valid_to       TYPE dats,
        customer_id    TYPE char20,
        environment    TYPE char10,
        product_id     TYPE char10,
        format_version TYPE char2,
        token          TYPE string,
        installed_by   TYPE syuname,
        installed_on   TYPE sydatum,
        installed_at   TYPE syuzeit,
        changed_by     TYPE syuname,
        changed_on     TYPE sydatum,
        changed_at     TYPE syuzeit,
      END OF ty_license.

    TYPES:
      BEGIN OF ty_result,
        success     TYPE boole_d,
        reason_code TYPE char40,
        message     TYPE string,
      END OF ty_result.

    METHODS get_active_by_plant
      IMPORTING
        iv_werks   TYPE werks_d
      EXPORTING
        es_license TYPE ty_license
        es_result  TYPE ty_result.

    METHODS install
      IMPORTING
        is_license       TYPE ty_license
      RETURNING
        VALUE(rs_result) TYPE ty_result.

  PRIVATE SECTION.

    METHODS deactivate_current
      IMPORTING
        iv_werks         TYPE werks_d
      RETURNING
        VALUE(rs_result) TYPE ty_result.

ENDCLASS.



CLASS /PTLOMS/CL021 IMPLEMENTATION.


  METHOD deactivate_current.

    CLEAR rs_result.

    UPDATE /ptloms/tb098
       SET active     = abap_false
           changed_by = sy-uname
           changed_on = sy-datum
           changed_at = sy-uzeit
     WHERE werks  = iv_werks
       AND active = abap_true.

    IF sy-subrc <> 0 AND sy-subrc <> 4.
      rs_result-success     = abap_false.
      rs_result-reason_code = 'DATABASE_ERROR'.
      rs_result-message     = 'Erro ao desativar a licença anterior'.
      RETURN.
    ENDIF.

    rs_result-success     = abap_true.
    rs_result-reason_code = 'OK'.
    rs_result-message     = 'Licença anterior desativada'.

  ENDMETHOD.


  METHOD get_active_by_plant.

    CLEAR:
      es_license,
      es_result.

    IF iv_werks IS INITIAL.
      es_result-success     = abap_false.
      es_result-reason_code = 'PLANT_REQUIRED'.
      es_result-message     = 'Centro de manutenção não informado'.
      RETURN.
    ENDIF.

    SELECT SINGLE
           werks
           license_id
           active
           valid_from
           valid_to
           customer_id
           environment
           product_id
           format_version
           token
           installed_by
           installed_on
           installed_at
           changed_by
           changed_on
           changed_at
      FROM /ptloms/tb098
      INTO CORRESPONDING FIELDS OF es_license
      WHERE werks  = iv_werks
        AND active = abap_true.

    IF sy-subrc <> 0.
      es_result-success     = abap_false.
      es_result-reason_code = 'LICENSE_NOT_FOUND'.
      es_result-message     = 'Não existe licença ativa para o centro informado'.
      RETURN.
    ENDIF.

    es_result-success     = abap_true.
    es_result-reason_code = 'OK'.
    es_result-message     = 'Licença localizada'.

  ENDMETHOD.


  METHOD install.

    DATA:
      ls_db_license TYPE /ptloms/tb098,
      ls_result     TYPE ty_result.

    CLEAR rs_result.

    IF is_license-werks IS INITIAL
       OR is_license-license_id IS INITIAL
       OR is_license-valid_to IS INITIAL
       OR is_license-token IS INITIAL.

      rs_result-success     = abap_false.
      rs_result-reason_code = 'INVALID_LICENSE_DATA'.
      rs_result-message     = 'Dados obrigatórios da licença não informados'.
      RETURN.
    ENDIF.

    CALL FUNCTION 'ENQUEUE_/PTLOMS/ELIC'
      EXPORTING
        mandt          = sy-mandt
        werks          = is_license-werks
        _scope         = '2'
        _wait          = abap_true
      EXCEPTIONS
        foreign_lock   = 1
        system_failure = 2
        OTHERS         = 3.

    IF sy-subrc <> 0.
      rs_result-success     = abap_false.
      rs_result-reason_code = 'LICENSE_LOCKED'.
      rs_result-message     = 'O centro está sendo atualizado por outro usuário'.
      RETURN.
    ENDIF.

    ls_result = deactivate_current(
      iv_werks = is_license-werks ).

    IF ls_result-success <> abap_true.
      rs_result = ls_result.

      CALL FUNCTION 'DEQUEUE_/PTLOMS/ELIC'
        EXPORTING
          mandt = sy-mandt
          werks = is_license-werks.

      RETURN.
    ENDIF.

    CLEAR ls_db_license.

    MOVE-CORRESPONDING is_license TO ls_db_license.

    ls_db_license-mandt        = sy-mandt.
    ls_db_license-active       = abap_true.
    ls_db_license-installed_by = sy-uname.
    ls_db_license-installed_on = sy-datum.
    ls_db_license-installed_at = sy-uzeit.
    ls_db_license-changed_by   = sy-uname.
    ls_db_license-changed_on   = sy-datum.
    ls_db_license-changed_at   = sy-uzeit.

    INSERT /ptloms/tb098 FROM ls_db_license.

    IF sy-subrc <> 0.
      ROLLBACK WORK.

      rs_result-success     = abap_false.
      rs_result-reason_code = 'DATABASE_ERROR'.
      rs_result-message     = 'Erro ao gravar a licença'.

      CALL FUNCTION 'DEQUEUE_/PTLOMS/ELIC'
        EXPORTING
          mandt = sy-mandt
          werks = is_license-werks.

      RETURN.
    ENDIF.

    COMMIT WORK AND WAIT.

    CALL FUNCTION 'DEQUEUE_/PTLOMS/ELIC'
      EXPORTING
        mandt = sy-mandt
        werks = is_license-werks.

    rs_result-success     = abap_true.
    rs_result-reason_code = 'OK'.
    rs_result-message     = 'Licença instalada com sucesso'.

  ENDMETHOD.
ENDCLASS.
