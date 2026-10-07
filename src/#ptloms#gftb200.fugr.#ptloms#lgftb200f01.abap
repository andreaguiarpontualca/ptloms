*----------------------------------------------------------------------*
***INCLUDE /PTLOMS/LGFTB200F01.
*----------------------------------------------------------------------*
FORM z_preencher_criacao.

  IF /ptloms/tb200-installed_by IS INITIAL.
    /ptloms/tb200-installed_by = sy-uname.
    /ptloms/tb200-installed_on = sy-datum.
    /ptloms/tb200-installed_at = sy-uzeit.
  ENDIF.

  IF /ptloms/tb200-changed_by IS INITIAL.
    /ptloms/tb200-changed_by = sy-uname.
    /ptloms/tb200-changed_on = sy-datum.
    /ptloms/tb200-changed_at = sy-uzeit.
  ENDIF.

ENDFORM.

FORM z_antes_salvar.

  LOOP AT total.

    CHECK <action> = aendern.

    MOVE <vim_total_struc> TO /ptloms/tb200.

    IF /ptloms/tb200-product_id IS INITIAL.
      MESSAGE 'Produto deve ser informado' TYPE 'E'.
    ENDIF.

    IF /ptloms/tb200-description IS INITIAL.
      MESSAGE 'Descrição do produto deve ser informada' TYPE 'E'.
    ENDIF.

    IF /ptloms/tb200-ssf_sign_app IS INITIAL.
      MESSAGE 'Aplicação SSF de assinatura deve ser informada' TYPE 'E'.
    ENDIF.

    IF /ptloms/tb200-ssf_verify_app IS INITIAL.
      MESSAGE 'Aplicação SSF de verificação deve ser informada' TYPE 'E'.
    ENDIF.

    /ptloms/tb200-changed_by = sy-uname.
    /ptloms/tb200-changed_on = sy-datum.
    /ptloms/tb200-changed_at = sy-uzeit.

    MOVE /ptloms/tb200 TO <vim_total_struc>.

    MODIFY total.

  ENDLOOP.

ENDFORM.
