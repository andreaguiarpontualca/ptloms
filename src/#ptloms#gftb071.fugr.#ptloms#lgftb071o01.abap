*----------------------------------------------------------------------*
***INCLUDE /PTLOMS/LGFTB071O01.
*----------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*&      Module  Z_BUSCA_DESCRICAO  OUTPUT
*&---------------------------------------------------------------------*
MODULE z_busca_descricao OUTPUT.

  SELECT SINGLE descricao
    INTO vg_desc_aplic
    FROM /ptloms/tb069
    WHERE id = /ptloms/tb071-aplicacao.

  SELECT SINGLE descricao
    INTO vg_desc_form
    FROM /ptloms/tb070
    WHERE aplicacao  = /ptloms/tb071-aplicacao
      and formulario = /ptloms/tb071-formulario.

ENDMODULE.
