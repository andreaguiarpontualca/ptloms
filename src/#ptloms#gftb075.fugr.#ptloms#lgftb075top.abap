FUNCTION-POOL /PTLOMS/GFTB075            MESSAGE-ID SV.

* INCLUDE /PTLOMS/LGFTB075D...               " Local class definition
  INCLUDE LSVIMDAT                                . "general data decl.
  INCLUDE /PTLOMS/LGFTB075T00                     . "view rel. data dcl.

    DATA: vg_desc_aplic TYPE /ptloms/tb069-descricao,
          vg_desc_form  TYPE /ptloms/tb070-descricao,
          vg_desc_opcao TYPE /ptloms/tb072-descricao,
          vg_desc_grupo TYPE /ptloms/tb073-descricao.
