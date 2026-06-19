FUNCTION /ptloms/mf145.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(I_USUARIO) TYPE  /PTLOMS/ET192-USUARIO OPTIONAL
*"     VALUE(I_DATA_INI) TYPE  /PTLOMS/ET192-DATA_INI OPTIONAL
*"     VALUE(I_DATA_FIM) TYPE  /PTLOMS/ET192-DATA_FIM OPTIONAL
*"  EXPORTING
*"     VALUE(E_RETORNO) TYPE  /PTLOMS/CT138
*"----------------------------------------------------------------------

  SELECT t1~aufnr, t1~guid, t2~vornr
    FROM /ptloms/tb065      AS t1
   INNER JOIN /ptloms/tb066 AS t2
      ON t1~guid = t2~guid
    INTO TABLE @DATA(ordens)
   WHERE t2~datacriacao BETWEEN @I_DATA_INI AND @I_DATA_FIM.

  LOOP AT ordens ASSIGNING FIELD-SYMBOL(<ordem>).
    APPEND INITIAL LINE TO E_RETORNO ASSIGNING FIELD-SYMBOL(<retorno>).
    <retorno>-chave    = '1'.
    <retorno>-guid     = <ordem>-guid.
    <retorno>-aufnr    = <ordem>-aufnr.
    <retorno>-vornr    = <ordem>-vornr.
  ENDLOOP.

ENDFUNCTION.
