*----------------------------------------------------------------------*
***INCLUDE /PTLOMS/LGFTB074O01.
*----------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*&      Module  Z_DESCRICOES  OUTPUT
*&---------------------------------------------------------------------*
MODULE z_descricoes OUTPUT.

  SELECT SINGLE descricao
    INTO vg_desc_aplic
    FROM /ptloms/tb069
    WHERE id = /ptloms/tb074-aplicacao.

  SELECT SINGLE descricao
    INTO vg_desc_opcao
    FROM /ptloms/tb072
    WHERE aplicacao = /ptloms/tb074-aplicacao
      and opcao = /ptloms/tb074-opcao.

ENDMODULE.
