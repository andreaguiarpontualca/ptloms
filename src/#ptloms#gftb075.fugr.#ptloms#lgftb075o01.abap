*----------------------------------------------------------------------*
***INCLUDE /PTLOMS/LGFTB075O01.
*----------------------------------------------------------------------*

*&---------------------------------------------------------------------*
*&      Module  Z_BUSCA_DESCRICOES  OUTPUT
*&---------------------------------------------------------------------*
MODULE z_busca_descricoes OUTPUT.

  SELECT SINGLE descricao
    INTO vg_desc_aplic
    FROM /ptloms/tb069
    WHERE id = /ptloms/tb075-aplicacao.

  SELECT SINGLE descricao
    INTO vg_desc_form
    FROM /ptloms/tb070
    WHERE aplicacao  = /ptloms/tb075-aplicacao
      and formulario = /ptloms/tb075-formulario.

  SELECT SINGLE descricao
    INTO vg_desc_opcao
    FROM /ptloms/tb072
    WHERE aplicacao = /ptloms/tb075-aplicacao
      and opcao = /ptloms/tb075-opcao.

  SELECT SINGLE descricao
    INTO vg_desc_grupo
    FROM /ptloms/tb073
    WHERE aplicacao = /ptloms/tb075-aplicacao
      and grupo = /ptloms/tb075-grupo.

ENDMODULE.
