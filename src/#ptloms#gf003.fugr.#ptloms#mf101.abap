FUNCTION /ptloms/mf101.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(IT_USUARIOS) TYPE  /PTLOMS/CT106
*"  EXPORTING
*"     VALUE(ET_USUARIOS) TYPE  /PTLOMS/CT106
*"----------------------------------------------------------------------


  TYPES: BEGIN OF ty_hrp,
           sobid  TYPE sobid,
           objid  TYPE hrp1001-objid,
           objid_ TYPE hrp1001-objid,
         END OF ty_hrp.

  DATA lt_usuarios TYPE /ptloms/ct106.
  DATA ls_usuario  LIKE LINE OF lt_usuarios.
  DATA lt_hrp      TYPE TABLE OF ty_hrp.
  DATA lt_hrp_     TYPE TABLE OF ty_hrp.

  lt_usuarios = it_usuarios.

  " Obtem a tabela de descrição do centro de trabalho
  SELECT sobid objid
    FROM hrp1001
    INTO TABLE lt_hrp
    FOR ALL ENTRIES IN lt_usuarios
    WHERE otype = 'P'                AND
          objid = lt_usuarios-matricula AND
          sclas = 'A'.

  IF sy-subrc IS INITIAL.

    FIELD-SYMBOLS: <fs_hrp> LIKE LINE OF lt_hrp.
    LOOP AT lt_hrp ASSIGNING <fs_hrp>.
      <fs_hrp>-objid_ = <fs_hrp>-sobid.
    ENDLOOP.

    SORT lt_hrp BY objid.

    SELECT sobid objid FROM
      hrp1001
      INTO TABLE lt_hrp_
      FOR ALL ENTRIES IN lt_hrp
      WHERE otype = 'A'          AND
            objid = lt_hrp-objid_ AND
            sclas = 'LA'.

    IF sy-subrc IS INITIAL.

      LOOP AT lt_hrp_ ASSIGNING <fs_hrp>.
        <fs_hrp>-objid_ = <fs_hrp>-sobid.
      ENDLOOP.

      SORT lt_hrp_ BY objid.

      DATA: lt_crhdr TYPE TABLE OF crhd.
      SELECT * FROM
        crhd
        INTO TABLE lt_crhdr
        FOR ALL ENTRIES IN lt_hrp_
        WHERE objty = 'A'         AND
              objid = lt_hrp_-objid_.

    ENDIF.

  ENDIF.

  IF sy-subrc EQ 0.
    FIELD-SYMBOLS: <fs_grupo_planejamento> LIKE LINE OF lt_usuarios.
    LOOP AT lt_usuarios ASSIGNING <fs_grupo_planejamento>.

      READ TABLE lt_hrp ASSIGNING <fs_hrp> WITH KEY objid = <fs_grupo_planejamento>-matricula BINARY SEARCH.

      IF sy-subrc IS INITIAL.

        FIELD-SYMBOLS: <fs_hrp_> LIKE LINE OF lt_hrp_.
        READ TABLE lt_hrp_ ASSIGNING <fs_hrp_> WITH KEY objid = <fs_hrp>-objid_ BINARY SEARCH.

        IF sy-subrc IS INITIAL.

          DATA ls_crhd LIKE LINE OF lt_crhdr.
          READ TABLE lt_crhdr INTO ls_crhd WITH KEY objid = <fs_hrp_>-objid_ BINARY SEARCH.

          IF sy-subrc IS INITIAL.
            <fs_grupo_planejamento>-arbpl = ls_crhd-arbpl.


          ENDIF.

        ENDIF.

      ELSE.

        CLEAR: ls_crhd-arbpl.

      ENDIF.

    ENDLOOP.
  ENDIF.

  et_usuarios = lt_usuarios.

ENDFUNCTION.
