FUNCTION /ptloms/mf083.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  EXPORTING
*"     VALUE(IT_STATUS_ASSOCIACAO) TYPE  /PTLOMS/CT113
*"----------------------------------------------------------------------

  DATA: it_values TYPE re_t_rsdomaval.
  DATA: ls_value LIKE LINE OF it_values.
  DATA: ls_status_associacao LIKE LINE OF it_status_associacao.

  cl_reca_ddic_doma=>get_values(
    EXPORTING
      id_name   = '/PTLOMS/DM013'
      id_langu  = sy-langu
    IMPORTING
      et_values = it_values
    EXCEPTIONS
      not_found = 1
      OTHERS    = 2
         ).
  IF sy-subrc <> 0.

    MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.

  ENDIF.

  LOOP AT it_values INTO ls_value.

    MOVE-CORRESPONDING ls_value TO ls_status_associacao.
    ls_status_associacao-codigo    = ls_value-valpos.
    ls_status_associacao-descricao = ls_value-ddtext.

    APPEND ls_status_associacao TO it_status_associacao.

  ENDLOOP.

*  it_status_associacao = CORRESPONDING #( it_values MAPPING codigo = valpos descricao = ddtext ).

*  LOOP AT it_values ASSIGNING FIELD-SYMBOL(<fs_values>).
*
*    APPEND VALUE #( codigo = <fs_values>-valpos descricao = <fs_values>-ddtext ) TO it_status_associacao.
*
*  ENDLOOP.

ENDFUNCTION.
