FUNCTION /ptloms/mf144.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(I_USUARIO) TYPE  /PTLOMS/ET192-USUARIO OPTIONAL
*"     VALUE(I_DATA_INI) TYPE  /PTLOMS/ET192-DATA_INI OPTIONAL
*"     VALUE(I_DATA_FIM) TYPE  /PTLOMS/ET192-DATA_FIM OPTIONAL
*"     VALUE(I_MATRICULA) TYPE  /PTLOMS/ET192-MATRICULA OPTIONAL
*"     VALUE(I_GUID) TYPE  /PTLOMS/ET192-GUID OPTIONAL
*"     VALUE(I_PERFIL) TYPE  /PTLOMS/ET192-PERFIL OPTIONAL
*"  EXPORTING
*"     VALUE(E_HISTORICO_RASTREA_USR) TYPE  /PTLOMS/CT164
*"     VALUE(E_RETORNO) TYPE  /PTLOMS/CT156
*"----------------------------------------------------------------------

  DATA: o_oms TYPE REF TO /ptloms/cl016.

  CREATE OBJECT o_oms.

  o_oms->busca_historico_rastrea_usr(
    EXPORTING
     i_usuario      = i_usuario
     i_guid         = i_guid
     i_matricula    = i_matricula
     i_perfil       = i_perfil
     i_data_ini     = i_data_ini
     i_data_fim     = i_data_fim
    IMPORTING
      e_historico_rastrea_usr = e_historico_rastrea_usr
      e_retorno = e_retorno
    ).

ENDFUNCTION.
