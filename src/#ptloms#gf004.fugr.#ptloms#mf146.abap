FUNCTION /ptloms/mf146.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(I_USUARIO) TYPE  /PTLOMS/ET194-USUARIO OPTIONAL
*"     VALUE(I_DATA_INI) TYPE  /PTLOMS/ET194-DATA_INI OPTIONAL
*"     VALUE(I_DATA_FIM) TYPE  /PTLOMS/ET194-DATA_FIM OPTIONAL
*"     VALUE(I_MATRICULA) TYPE  /PTLOMS/ET194-MATRICULA OPTIONAL
*"  EXPORTING
*"     VALUE(E_RETORNO) TYPE  /PTLOMS/CT156
*"     VALUE(E_DADOS_RASTREA_USR) TYPE  /PTLOMS/CT165
*"----------------------------------------------------------------------

  DATA: o_oms TYPE REF TO /ptloms/cl016.

  CREATE OBJECT o_oms.

  o_oms->busca_dados_rastrea_usr(
    EXPORTING
     i_usuario      = i_usuario
     i_matricula    = i_matricula
     i_data_ini     = i_data_ini
     i_data_fim     = i_data_fim
    IMPORTING
      e_dados_rastrea_usr = e_dados_rastrea_usr
      e_retorno = e_retorno
    ).

ENDFUNCTION.
