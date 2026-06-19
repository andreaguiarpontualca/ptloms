FUNCTION /ptloms/mf080.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(RT_USUARIO_APP) TYPE  /IWBEP/T_COD_SELECT_OPTIONS OPTIONAL
*"  EXPORTING
*"     VALUE(IT_ORDENS) TYPE  /PTLOMS/CT109
*"----------------------------------------------------------------------

  DATA: o_oms TYPE REF TO /ptloms/cl001.

  CREATE OBJECT o_oms.

  o_oms->out_ordem_perfil_usuario( EXPORTING  rt_usuario_app = rt_usuario_app
                                    IMPORTING et_ordens      = it_ordens ).

ENDFUNCTION.
