FUNCTION /ptloms/mf008.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IM_OBJNR) TYPE  J_OBJNR
*"  EXPORTING
*"     VALUE(EX_DESPREZAR) TYPE  CHAR1
*"----------------------------------------------------------------------
* Descrição: Exclui as Ordens ENCE, ENTE e CONF, MREL, BLOQ

* Declaração de Tabela interma
  DATA: lt_status TYPE STANDARD TABLE OF jstat.

* Verifica se OBJNR está preenchido
  IF im_objnr IS INITIAL.
    RETURN.
  ENDIF.

* Busca status
  CALL FUNCTION 'STATUS_READ'
    EXPORTING
      client           = sy-mandt
      objnr            = im_objnr
      only_active      = 'X'
    TABLES
      status           = lt_status
    EXCEPTIONS
      object_not_found = 1
      OTHERS           = 2.

* Verifica se a Ordem possui o status ENTE I0045 (Encerrado Tecnicamente)
  READ TABLE lt_status WITH KEY stat = 'I0045' TRANSPORTING NO FIELDS.
  IF sy-subrc EQ 0.
    ex_desprezar = 'X'.
  ELSE.
* Verifica se a Ordem possui o status ENCE I0046 (Encerrado)
    READ TABLE lt_status WITH KEY stat = 'I0046' TRANSPORTING NO FIELDS.
    IF sy-subrc EQ 0.
      ex_desprezar = 'X'.
    ELSE.
* Verifica se a Ordem possui o status CONF I0009 (Confirmado)
      READ TABLE lt_status WITH KEY stat = 'I0009' TRANSPORTING NO FIELDS.
      IF sy-subrc EQ 0.
        ex_desprezar = 'X'.
      ELSE.
* Verifica se a Ordem possui o status MREL I0076 (Marcação para eliminação)
        READ TABLE lt_status WITH KEY stat = 'I0076' TRANSPORTING NO FIELDS.
        IF sy-subrc EQ 0.
          ex_desprezar = 'X'.
        ELSE.
* Verifica se a Ordem possui o status BLOQ I0190 (bloqueado)
          READ TABLE lt_status WITH KEY stat = 'I0190' TRANSPORTING NO FIELDS.
          IF sy-subrc EQ 0.
            ex_desprezar = 'X'.
          ENDIF.
        ENDIF.
      ENDIF.
    ENDIF.
  ENDIF.



ENDFUNCTION.
