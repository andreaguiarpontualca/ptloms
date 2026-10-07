*********************************************************************************************************
***  Trecho do código abaixo REVISADO em 20/07/2026 em função da incompatibilidade de versão com a SOLAR.
*********************************************************************************************************
***  INICIO - Iury Silva
*********************************************************************************************************
FUNCTION /ptloms/mf145.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(I_USUARIO) TYPE /PTLOMS/ET192-USUARIO OPTIONAL
*"     VALUE(I_DATA_INI) TYPE /PTLOMS/ET192-DATA_INI OPTIONAL
*"     VALUE(I_DATA_FIM) TYPE /PTLOMS/ET192-DATA_FIM OPTIONAL
*"  EXPORTING
*"     VALUE(E_RETORNO) TYPE /PTLOMS/CT138
*"----------------------------------------------------------------------

  TYPES:
    BEGIN OF ty_ordem,
      aufnr TYPE /ptloms/tb065-aufnr,
      guid  TYPE /ptloms/tb065-guid,
      vornr TYPE /ptloms/tb066-vornr,
    END OF ty_ordem.

  DATA: lt_ordens  TYPE STANDARD TABLE OF ty_ordem,
        ls_ordem   TYPE ty_ordem,
        ls_retorno LIKE LINE OF e_retorno.

  REFRESH: lt_ordens, e_retorno.

  CLEAR: ls_ordem, ls_retorno.

*---------------------------------------------------------------------*
* Selecionar ordens no período informado
*---------------------------------------------------------------------*
  SELECT t1~aufnr
         t1~guid
         t2~vornr
    INTO TABLE lt_ordens
    FROM /ptloms/tb065 AS t1
    INNER JOIN /ptloms/tb066 AS t2
      ON t2~guid = t1~guid
    WHERE t2~datacriacao BETWEEN i_data_ini AND i_data_fim.

*---------------------------------------------------------------------*
* Montar retorno
*---------------------------------------------------------------------*
  LOOP AT lt_ordens INTO ls_ordem.

    CLEAR ls_retorno.

    ls_retorno-chave = '1'.
    ls_retorno-guid  = ls_ordem-guid.
    ls_retorno-aufnr = ls_ordem-aufnr.
    ls_retorno-vornr = ls_ordem-vornr.

    APPEND ls_retorno TO e_retorno.

  ENDLOOP.

ENDFUNCTION.
***FUNCTION /ptloms/mf145.
****"----------------------------------------------------------------------
****"*"Interface local:
****"  IMPORTING
****"     VALUE(I_USUARIO) TYPE  /PTLOMS/ET192-USUARIO OPTIONAL
****"     VALUE(I_DATA_INI) TYPE  /PTLOMS/ET192-DATA_INI OPTIONAL
****"     VALUE(I_DATA_FIM) TYPE  /PTLOMS/ET192-DATA_FIM OPTIONAL
****"  EXPORTING
****"     VALUE(E_RETORNO) TYPE  /PTLOMS/CT138
****"----------------------------------------------------------------------
***
***  SELECT t1~aufnr, t1~guid, t2~vornr
***    FROM /ptloms/tb065      AS t1
***   INNER JOIN /ptloms/tb066 AS t2
***      ON t1~guid = t2~guid
***    INTO TABLE @DATA(ordens)
***   WHERE t2~datacriacao BETWEEN @I_DATA_INI AND @I_DATA_FIM.
***
***  LOOP AT ordens ASSIGNING FIELD-SYMBOL(<ordem>).
***    APPEND INITIAL LINE TO E_RETORNO ASSIGNING FIELD-SYMBOL(<retorno>).
***    <retorno>-chave    = '1'.
***    <retorno>-guid     = <ordem>-guid.
***    <retorno>-aufnr    = <ordem>-aufnr.
***    <retorno>-vornr    = <ordem>-vornr.
***  ENDLOOP.
***
***ENDFUNCTION.

*********************************************************************************************************
***  FIM - Iury Silva
*********************************************************************************************************
