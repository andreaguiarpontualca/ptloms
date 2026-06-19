FUNCTION /ptloms/mf047.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IM_MATNR) TYPE  CHAR18
*"  EXPORTING
*"     VALUE(EX_MAKTX) TYPE  CHAR40
*"----------------------------------------------------------------------

  DATA: lv_matnr TYPE matnr,
        lv_maktx TYPE maktx.

  lv_matnr = im_matnr.

  /ptloms/cl006=>busca_dados_matnr( EXPORTING im_matnr = lv_matnr
                                    IMPORTING ex_maktx = lv_maktx ).

  ex_maktx = lv_maktx.

ENDFUNCTION.
