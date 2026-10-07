FUNCTION /ptloms/mf160.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IR_KOSTL) TYPE  /IWBEP/T_COD_SELECT_OPTIONS OPTIONAL
*"     VALUE(IR_KOKRS) TYPE  /IWBEP/T_COD_SELECT_OPTIONS OPTIONAL
*"     VALUE(IR_KTEXT) TYPE  /IWBEP/T_COD_SELECT_OPTIONS OPTIONAL
*"     VALUE(IV_TOP) TYPE  INT4 OPTIONAL
*"     VALUE(IV_SKIP) TYPE  INT4 OPTIONAL
*"     VALUE(IV_SEARCH) TYPE  STRING OPTIONAL
*"  EXPORTING
*"     VALUE(ET_CENTRO_CUSTO) TYPE  /PTLOMS/CT174
*"----------------------------------------------------------------------

  CALL METHOD /ptloms/cl013=>buscar_centro_custo
    EXPORTING
      ir_kostl        = ir_kostl
      ir_kokrs        = ir_kokrs
      ir_ktext        = ir_ktext
      iv_search       = iv_search
      iv_top          = iv_top
      iv_skip         = iv_skip
    IMPORTING
      et_centro_custo = et_centro_custo.

ENDFUNCTION.
