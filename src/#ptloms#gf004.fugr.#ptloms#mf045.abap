FUNCTION /ptloms/mf045.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IM_EQUNR) TYPE  CHAR18
*"  EXPORTING
*"     VALUE(EX_SUBMT) TYPE  CHAR18
*"     VALUE(EX_IWERK) TYPE  CHAR18
*"----------------------------------------------------------------------

  DATA: lv_equnr TYPE equnr,
        lv_submt TYPE submt,
        lv_iwerk TYPE iwerk.

  lv_equnr = im_equnr.

  /ptloms/cl006=>busca_dados_equi( EXPORTING im_equnr = lv_equnr
                                   IMPORTING ex_submt = lv_submt
                                             ex_iwerk = lv_iwerk ).

  ex_submt = lv_submt.
  ex_iwerk = lv_iwerk.

ENDFUNCTION.
