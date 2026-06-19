FUNCTION /ptloms/mf053.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IM_AUFNR) TYPE  AUFNR
*"     REFERENCE(IM_ENDMLFNDATE) TYPE  AUSBS
*"     REFERENCE(IM_ENDMLFNTIME) TYPE  AUZTB
*"  TABLES
*"      IT_RETURN STRUCTURE  BAPIRET2
*"----------------------------------------------------------------------

*********************************************************************************************************
***  Trecho do código abaixo REVISADO em 30/04/2024 em função da incompatibilidade de versão com a SOLAR.
*********************************************************************************************************
***  INICIO - Vidal
*********************************************************************************************************

* Declarações para a BAPI
  DATA: lv_number               TYPE bapi2080_nothdre-notif_no,
        ls_notifheader          TYPE bapi2080_nothdri,
        ls_notifheader_x        TYPE bapi2080_nothdri_x,
        ls_notifheader_export   TYPE bapi2080_nothdre,
        lv_maintactytype_export TYPE ila,
        ls_notifheader_save     TYPE bapi2080_nothdre,
        lt_return	              TYPE STANDARD TABLE OF bapiret2.

* Declaração de variável
  DATA: lv_aufnr TYPE aufnr.

* Verifica se Parâmetros de entrada estão preenchidos
  IF im_aufnr IS INITIAL OR im_endmlfndate IS INITIAL OR im_endmlfntime IS INITIAL.
    RETURN.
  ENDIF.

* Atribuição
*  lv_aufnr = |{ im_aufnr ALPHA = IN }|.

  CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
    EXPORTING
      input  = im_aufnr
    IMPORTING
      output = lv_aufnr.

* Busca a Nota associada da Ordem
**  SELECT SINGLE qmnum
**    FROM viaufks
**    INTO @DATA(lv_qmnum)
**    WHERE aufnr = @lv_aufnr.

  DATA lv_qmnum TYPE viaufks-qmnum.
  CLEAR lv_qmnum.
  SELECT SINGLE qmnum
    FROM viaufks
    INTO lv_qmnum
    WHERE aufnr = lv_aufnr.

  IF lv_qmnum IS INITIAL.
    RETURN.
  ENDIF.

  MOVE lv_qmnum TO lv_number.

  ls_notifheader-endmlfndate = im_endmlfndate.
  ls_notifheader-endmlfntime = im_endmlfntime.

  ls_notifheader_x-endmlfndate = 'X'.
  ls_notifheader_x-endmlfntime = 'X'.

  CALL FUNCTION 'BAPI_ALM_NOTIF_DATA_MODIFY'
    EXPORTING
      number             = lv_number
      notifheader        = ls_notifheader
      notifheader_x      = ls_notifheader_x
*     NO_BUFFER_REFRESH_ON_ERROR       = ' '
*     MAINTACTYTYPE      =
    IMPORTING
      notifheader_export = ls_notifheader_export
*     maintactytype_export = lv_maintactytype_export
    TABLES
      return             = lt_return.

  CALL FUNCTION 'BAPI_ALM_NOTIF_SAVE'
    EXPORTING
      number      = lv_number
    IMPORTING
      notifheader = ls_notifheader_save
    TABLES
      return      = lt_return.

*  READ TABLE  lt_return INTO DATA(ls_return) WITH KEY type = 'E'.
  DATA ls_return LIKE LINE OF lt_return.
  READ TABLE  lt_return INTO ls_return WITH KEY type = 'E'.
  IF sy-subrc NE 0.
    CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
      EXPORTING
        wait = 'X'.
  ENDIF.

  it_return[] = lt_return[].
ENDFUNCTION.
