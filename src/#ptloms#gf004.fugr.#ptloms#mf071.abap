FUNCTION /ptloms/mf071.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  CHANGING
*"     VALUE(IT_MOTIVO_DESSASSOCIAR) TYPE  /PTLOMS/CT107
*"----------------------------------------------------------------------
*********************************************************************************************************
***  Trecho do código abaixo REVISADO em 02/05/2024 em função da incompatibilidade de versão com a SOLAR.
*********************************************************************************************************
***  Bretz
*********************************************************************************************************
  DATA: it_values TYPE re_t_rsdomaval.

  cl_reca_ddic_doma=>get_values(
    EXPORTING
      id_name   = '/PTLOMS/DM006'
       id_langu = sy-langu
    IMPORTING
      et_values = it_values
    EXCEPTIONS
      not_found = 1
      OTHERS    = 2
         ).

  IF sy-subrc <> 0.
*   Implement suitable error handling here
  ENDIF.

***  LOOP AT it_values ASSIGNING FIELD-SYMBOL(<fs_values>).
  FIELD-SYMBOLS: <fs_values> LIKE LINE OF it_values.
  DATA: wa_motivo_dessassociar LIKE LINE OF it_motivo_dessassociar.

  LOOP AT it_values ASSIGNING <fs_values>.

*** APPEND VALUE #( codigo = <fs_values>-domvalue_l descricao = <fs_values>-ddtext ) TO it_motivo_dessassociar.

    wa_motivo_dessassociar-codigo = <fs_values>-domvalue_l.
    wa_motivo_dessassociar-descricao = <fs_values>-ddtext.
    APPEND wa_motivo_dessassociar TO it_motivo_dessassociar.

  ENDLOOP.

ENDFUNCTION.
