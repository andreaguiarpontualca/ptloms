FUNCTION /ptloms/mf147.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(I_DATA_INI) TYPE  /PTLOMS/ET195-DATA_INI OPTIONAL
*"     VALUE(I_DATA_FIM) TYPE  /PTLOMS/ET195-DATA_FIM OPTIONAL
*"  EXPORTING
*"     VALUE(E_ASSOCIACOES) TYPE  /PTLOMS/CT166
*"     VALUE(E_RETORNO) TYPE  /PTLOMS/CT156
*"----------------------------------------------------------------------

  DATA: o_oms TYPE REF TO /ptloms/cl014.

  CREATE OBJECT o_oms.

  CALL METHOD o_oms->obter_lista_associ_prg_desasss
    EXPORTING
      i_data_ini     = i_data_ini
      i_data_fim     = i_data_fim
    IMPORTING
      et_associacoes = e_associacoes.

ENDFUNCTION.
