FUNCTION /ptloms/mf081.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(RT_USUARIO_APP) TYPE  /IWBEP/T_COD_SELECT_OPTIONS OPTIONAL
*"  EXPORTING
*"     VALUE(IT_NOTAS) TYPE  /PTLOMS/CT110
*"----------------------------------------------------------------------

  DATA: o_oms TYPE REF TO /ptloms/cl001.

  CREATE OBJECT o_oms.

  o_oms->out_nota_perfil_usuario( EXPORTING  rt_usuario_app = rt_usuario_app
                                   IMPORTING et_notas      = it_notas
                                     ).

ENDFUNCTION.
