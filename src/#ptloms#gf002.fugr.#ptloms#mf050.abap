FUNCTION /ptloms/mf050.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     REFERENCE(IM_NOTA) TYPE  QMNUM
*"----------------------------------------------------------------------
************************************************************************
***  Programa REVISADO em 06/05/2024 em função da
***  incompatibilidade de versão com a SOLAR.
************************************************************************
***  Consultora ABAP - Nádia Rodrigues
************************************************************************
* Declaração de tabelas
  DATA: lt_status TYPE STANDARD TABLE OF jstat.

* Declaração de estrutura
  DATA: ls_status TYPE jstat.

*Declaraçãode Variável
  DATA lv_nota TYPE qmnum.

* Verifica se nota foi preenchida
  IF im_nota IS INITIAL.
    RETURN.
  ENDIF.

* Rotinha de conversão
***  lv_nota = |{ im_nota ALPHA = IN }|.
  CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
    EXPORTING
      input  = im_nota
    IMPORTING
      output = lv_nota.

* Busca objnr da Nota
* SELECT SINGLE objnr FROM qmel INTO @DATA(lv_objnr) WHERE qmnum = @lv_nota.
  DATA lv_objnr TYPE qmel-objnr.
  SELECT SINGLE objnr FROM qmel INTO lv_objnr WHERE qmnum = lv_nota.
  IF lv_objnr IS INITIAL.
    RETURN.
  ENDIF.

  CLEAR ls_status.
  ls_status-stat  = 'I0070'.
  ls_status-inact = 'X'.
  APPEND ls_status TO lt_status.

  CLEAR ls_status.
  ls_status-stat  = 'I0076'.
  APPEND ls_status TO lt_status.

  CLEAR ls_status.
  ls_status-stat  = 'I0072'.
  APPEND ls_status TO lt_status.

  CALL FUNCTION 'STATUS_CHANGE_INTERN'
    EXPORTING
      objnr               = lv_objnr
    TABLES
      status              = lt_status
    EXCEPTIONS
      object_not_found    = 1
      status_inconsistent = 2
      status_not_allowed  = 3
      OTHERS              = 4.

  COMMIT WORK.

ENDFUNCTION.
