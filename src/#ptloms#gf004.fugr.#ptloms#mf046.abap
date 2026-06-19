FUNCTION /ptloms/mf046.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IM_TPLNR) TYPE  CHAR30
*"  EXPORTING
*"     VALUE(EX_SUBMT) TYPE  CHAR18
*"     VALUE(EX_IWERK) TYPE  CHAR18
*"----------------------------------------------------------------------

  DATA: lv_tplnr TYPE tplnr,
        lv_submt TYPE submt,
        lv_iwerk TYPE iwerk.

  lv_tplnr = im_tplnr.

  /ptloms/cl006=>busca_dados_locl( EXPORTING im_tplnr = lv_tplnr
                                   IMPORTING ex_submt = lv_submt
                                             ex_iwerk = lv_iwerk ).

  ex_submt = lv_submt.
  ex_iwerk = lv_iwerk.

ENDFUNCTION.
