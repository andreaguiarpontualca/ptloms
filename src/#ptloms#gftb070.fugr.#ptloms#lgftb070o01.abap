*----------------------------------------------------------------------*
***INCLUDE /PTLOMS/LGFTB070O01.
*----------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&      Module  Z_DESC_APLICACAO  OUTPUT
*&---------------------------------------------------------------------*
MODULE z_desc_aplicacao OUTPUT.

  SELECT SINGLE descricao
    INTO desc_aplic
    FROM /ptloms/tb069
    WHERE id = /ptloms/tb070-aplicacao.

ENDMODULE.
