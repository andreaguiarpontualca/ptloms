FUNCTION /ptloms/mf134.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(I_OPERACOES) TYPE  /PTLOMS/CT058
*"  EXPORTING
*"     VALUE(E_LISTA) TYPE  /PTLOMS/CT123
*"----------------------------------------------------------------------

  DATA: o_oms TYPE REF TO /ptloms/cl016.
  DATA: ls_operacoes TYPE LINE OF /ptloms/ct058,
        lt_lista     TYPE /ptloms/ct123,
        ls_lista     TYPE LINE OF /ptloms/ct123.

  CONSTANTS: c_tpret TYPE char1 VALUE 'P'.

  LOOP AT i_operacoes INTO ls_operacoes.
    ls_lista-chave = ls_operacoes-chave.
    ls_lista-guid = ls_operacoes-guid.
    ls_lista-aufnr = ls_operacoes-aufnr.
    ls_lista-vornr = ls_operacoes-vornr.
    ls_lista-uname = ls_operacoes-usuario.
    ls_lista-tiporetorno = c_tpret.
    APPEND ls_lista TO lt_lista.
    CLEAR ls_lista.
  ENDLOOP.

  CREATE OBJECT o_oms.

  CALL METHOD o_oms->busca_lista_associar
    EXPORTING
      it_lista = lt_lista
    IMPORTING
      et_lista = e_lista.

ENDFUNCTION.
