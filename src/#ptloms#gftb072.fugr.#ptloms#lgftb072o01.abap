*----------------------------------------------------------------------*
***INCLUDE /PTLOMS/LGFTB072O01.
*----------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*&      Module  Z_BUSCA_DESCRICAO  OUTPUT
*&---------------------------------------------------------------------*
MODULE z_busca_descricao OUTPUT.

  SELECT SINGLE descricao
    INTO vg_desc_aplic
    FROM /ptloms/tb069
    WHERE id = /ptloms/tb072-aplicacao.

ENDMODULE.
