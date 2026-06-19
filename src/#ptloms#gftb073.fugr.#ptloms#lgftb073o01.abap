*----------------------------------------------------------------------*
***INCLUDE /PTLOMS/LGFTB073O01.
*----------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*&      Module  Z_BUSCA_DESCRICAO  OUTPUT
*&---------------------------------------------------------------------*
MODULE z_busca_descricao OUTPUT.

  SELECT SINGLE descricao
    INTO vg_desc_aplic
    FROM /ptloms/tb069
    WHERE id = /ptloms/tb073-aplicacao.

ENDMODULE.
