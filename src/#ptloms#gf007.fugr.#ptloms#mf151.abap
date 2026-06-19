FUNCTION /PTLOMS/MF151.
*"--------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IV_QMNUM) TYPE  CHAR12 OPTIONAL
*"     VALUE(IV_AUFNR) TYPE  CHAR12 OPTIONAL
*"  EXPORTING
*"     VALUE(ET_TIMELINE) TYPE  /PTLOMS/CT169
*"--------------------------------------------------------------------

  " Chamada corrigida com sintaxe completa
  /ptloms/cl013=>obter_timeline_fiori(
    EXPORTING
      iv_qmnum    = iv_qmnum
      iv_aufnr    = iv_aufnr
    IMPORTING
      et_timeline = et_timeline
  ).

ENDFUNCTION.
