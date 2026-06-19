FUNCTION /PTLOMS/MF100.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(RT_DATUM) TYPE  /IWBEP/T_COD_SELECT_OPTIONS
*"     VALUE(RT_USUARIO_APP) TYPE  /IWBEP/T_COD_SELECT_OPTIONS
*"  EXPORTING
*"     VALUE(ET_LOG_RESERVA) TYPE  /PTLOMS/CT117
*"----------------------------------------------------------------------

  DATA: o_oms TYPE REF TO /ptloms/cl001.

  CREATE OBJECT o_oms.

  o_oms->out_log_reserva(
    EXPORTING
      rt_datum       = rt_datum
      rt_usuario_app = rt_usuario_app
    IMPORTING
      et_log_reserva = et_log_reserva ).

ENDFUNCTION.
