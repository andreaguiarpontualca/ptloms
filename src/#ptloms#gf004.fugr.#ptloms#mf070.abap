FUNCTION /ptloms/mf070.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  CHANGING
*"     VALUE(IT_USUARIOS_ASSOCIAR) TYPE  /PTLOMS/CT106
*"----------------------------------------------------------------------

  SELECT * FROM
    /ptloms/tb013
    INTO CORRESPONDING FIELDS OF TABLE it_usuarios_associar
    WHERE bloqueado = '' AND
          matricula <> '00000000' AND
            associa = 'X'.

ENDFUNCTION.
