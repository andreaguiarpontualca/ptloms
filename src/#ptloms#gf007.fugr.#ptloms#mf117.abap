FUNCTION /ptloms/mf117.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IT_FILTER_SELECT_OPTIONS) TYPE  /IWBEP/T_MGW_SELECT_OPTION
*"----------------------------------------------------------------------

*  DATA: wa_filter      TYPE /iwbep/s_mgw_select_option,
*        wa_range_aufnr TYPE /iwbep/s_mgw_select_option,
*        linha          TYPE /iwbep/s_mgw_select_option,
*        lv_range_aufnr TYPE TABLE OF /iwbep/s_mgw_select_option,
*        it_range_aufnr TYPE TABLE OF /iwbep/t_cod_select_options,
*        wa             LIKE LINE OF it_range_aufnr,
*        linhas_range   TYPE LINE OF /iwbep/t_cod_select_options.
*
*
*  IF it_filter_select_options[] IS NOT INITIAL.
*
*    LOOP AT it_filter_select_options INTO wa_filter
*                  WHERE property = 'Aufnr'.
*
*      APPEND wa_filter-select_options TO aufnr.
*
*    ENDLOOP.
*
*
*  ENDIF.

ENDFUNCTION.
