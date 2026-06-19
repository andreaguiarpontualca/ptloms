FUNCTION /ptloms/mf103.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(I_AUFNR) TYPE  CHAR12
*"     VALUE(I_VORNR) TYPE  CHAR4
*"  EXPORTING
*"     VALUE(E_CONFIRMADA) TYPE  FLAG
*"----------------------------------------------------------------------
  DATA: lv_objnr LIKE afvc-objnr.
  DATA: lt_status TYPE STANDARD TABLE OF jstat.
  DATA: ls_status LIKE LINE OF lt_status.

  DATA: lv_aufnr TYPE char12.
  DATA: lv_vornr TYPE char4.

  CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
    EXPORTING
      input  = i_aufnr
    IMPORTING
      output = lv_aufnr.

  CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
    EXPORTING
      input  = i_vornr
    IMPORTING
      output = lv_vornr.

  SELECT SINGLE b~objnr
    FROM afko AS a INNER JOIN afvc AS b ON a~aufpl = b~aufpl
    INTO lv_objnr
    WHERE a~aufnr = lv_aufnr
      AND b~vornr = lv_vornr.

  IF sy-subrc IS INITIAL.

* Busca status da Ordem
* I0009 = CONF
    CALL FUNCTION 'STATUS_READ'
      EXPORTING
        client           = sy-mandt
        objnr            = lv_objnr
        only_active      = 'X'
      TABLES
        status           = lt_status
      EXCEPTIONS
        object_not_found = 1
        OTHERS           = 2.

    IF sy-subrc IS INITIAL.

      READ TABLE lt_status INTO ls_status WITH KEY stat = 'I0009' inact = ''.

      IF sy-subrc IS INITIAL.

        e_confirmada = 'X'.

      ENDIF.

    ENDIF.

  ENDIF.

ENDFUNCTION.
