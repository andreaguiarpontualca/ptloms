*----------------------------------------------------------------------*
***INCLUDE /PTLOMS/LGF001F03.
*----------------------------------------------------------------------*
FORM f_valida_centro.

  "GELOESCHT: Entry flagged for deletion
  "NEUER_EINTRAG: Entry is newly created
  "AENDERN: Entry changed
  "UPDATE_GELOESCHT: Entry was first changed and then flagged for deletion
  "NEUER_GELOESCHT: Entry was first newly created, not yet saved and then flagged for deletion
  "ORIGINAL: The entry is identical with the database status
  "IF <XACT> = GELOESCHT. ... ENDIF.
  "<STATUS>-UPD_FLAG
  "The variable indicates whether a save-relevant change has been made in the maintenance dialog. It can take the following values:
  "'X': Data changed, save required
  "<space>: Data not changed, save not required


  DATA: it_tb005    TYPE TABLE OF /ptloms/tb005,
        wa_tb005    TYPE /ptloms/tb005,
        lwa_row     TYPE /ptloms/v018,
        lv_msg(100) TYPE c.

  FIELD-SYMBOLS:
    <fs_action> TYPE any,
    <fs_arbpl>  TYPE any,
    <fs_werks>  TYPE any,
    <fs_objid>  TYPE any.

  " Verificar itens duplicados em memória
  LOOP AT total.

*    ASSIGN COMPONENT 'ACTION' OF STRUCTURE total TO FIELD-SYMBOL(<fs_action>).
    ASSIGN COMPONENT 'ACTION' OF STRUCTURE total TO <fs_action>.

    IF <fs_action> = 'N'.

      READ TABLE extract WITH KEY <vim_xtotal_key>.

      IF sy-subrc EQ 0.

        MOVE-CORRESPONDING total TO wa_tb005.

        APPEND wa_tb005 TO it_tb005.

      ENDIF.

    ENDIF.

  ENDLOOP.

*  DATA(it_tb005_aux) = it_tb005.
  DATA it_tb005_aux type TABLE OF /ptloms/tb005.
  it_tb005_aux[] = it_tb005[].

  LOOP AT it_tb005 INTO wa_tb005.

    LOOP AT it_tb005 TRANSPORTING NO FIELDS WHERE arbpl = wa_tb005-arbpl AND
                                                  werks = wa_tb005-werks AND
                                                 objid <> wa_tb005-objid.

*      DATA(arbpl) = |Centro de trabalho | && |{ wa_tb005-arbpl }|.
      DATA arbpl  TYPE c LENGTH 40.
      CLEAR arbpl.
      CONCATENATE 'Centro de trabalho' wa_tb005-arbpl INTO arbpl SEPARATED BY space.

      MESSAGE i000(su) WITH arbpl 'centro' wa_tb005-werks 'já existe' DISPLAY LIKE 'E'.

      vim_abort_saving = 'X'.
      sy-subrc = 4.
      EXIT.

    ENDLOOP.

  ENDLOOP.

  IF vim_abort_saving <> 'X'.

    LOOP AT total.

      ASSIGN COMPONENT 'ACTION' OF STRUCTURE total TO <fs_action>.

      IF <fs_action> = 'U' OR <fs_action> = 'N'.

        READ TABLE extract WITH KEY <vim_xtotal_key>.

        IF sy-subrc EQ 0.

*          ASSIGN COMPONENT 'ARBPL' OF STRUCTURE extract TO FIELD-SYMBOL(<fs_arbpl>).
*          ASSIGN COMPONENT 'WERKS' OF STRUCTURE extract TO FIELD-SYMBOL(<fs_werks>).
          ASSIGN COMPONENT 'ARBPL' OF STRUCTURE extract TO <fs_arbpl>.
          ASSIGN COMPONENT 'WERKS' OF STRUCTURE extract TO <fs_werks>.

          IF <fs_arbpl> IS ASSIGNED AND <fs_werks> IS ASSIGNED.

*            SELECT * FROM
*              /ptloms/tb005
*              INTO TABLE @DATA(it_centro)
*              WHERE arbpl = @<fs_arbpl> AND
*                    werks = @<fs_werks>.
            DATA it_centro TYPE TABLE OF /ptloms/tb005.
            SELECT * FROM /ptloms/tb005
              INTO TABLE it_centro
              WHERE arbpl = <fs_arbpl> AND
                    werks = <fs_werks>.

            IF sy-subrc IS INITIAL.

*              ASSIGN COMPONENT 'OBJID' OF STRUCTURE extract TO FIELD-SYMBOL(<fs_objid>).
              ASSIGN COMPONENT 'OBJID' OF STRUCTURE extract TO <fs_objid>.

              IF <fs_objid> IS ASSIGNED.

                DELETE it_centro WHERE objid = <fs_objid>.

                IF it_centro IS NOT INITIAL.

*                  arbpl = |Centro de trabalho | && |{ <fs_arbpl> }|.
                  CLEAR arbpl.
                  CONCATENATE 'Centro de trabalho' <fs_arbpl> INTO arbpl SEPARATED BY space.

                  MESSAGE i000(su) WITH arbpl 'centro' <fs_werks> 'já existe' DISPLAY LIKE 'E'.

                  vim_abort_saving = 'X'.
                  sy-subrc = 4.
                  EXIT.

                ENDIF.

              ENDIF.

            ENDIF.

          ENDIF.

        ENDIF.

      ENDIF.

    ENDLOOP.

  ENDIF.

* Busca centro de trabalho vinculado ao perfil
**  SELECT *
**    FROM /ptloms/tb017
**    INTO TABLE @DATA(lt_tb017).
  DATA lt_tb017 TYPE TABLE OF /ptloms/tb017.
  DATA ls_017 TYPE /ptloms/tb017.
  SELECT *
    FROM /ptloms/tb017
    INTO TABLE lt_tb017.

  SORT lt_tb017 BY objid.

  LOOP AT total.

    CLEAR: lwa_row.

    IF <vim_total_struc> IS ASSIGNED.

      MOVE-CORRESPONDING <vim_total_struc> TO lwa_row.

      IF <action> EQ 'D'.

*        READ TABLE lt_tb017 INTO DATA(ls_017)
        READ TABLE lt_tb017 INTO ls_017
        WITH KEY objid = lwa_row-objid BINARY SEARCH.

        IF sy-subrc EQ 0.
          vim_abort_saving = 'X'.
          CONCATENATE 'utilizado no Perfil'(079) ls_017-perfil INTO lv_msg SEPARATED BY space.
          MESSAGE i000(su) WITH 'Centro de Trabalho:'(128) lwa_row-arbpl lv_msg DISPLAY LIKE 'E'.
          EXIT.
        ENDIF.
      ENDIF.
    ENDIF.

  ENDLOOP.

ENDFORM.

*----------------------------------------------------------------------*
*
*----------------------------------------------------------------------*
FORM f_preencher_dados.

*  SELECT SINGLE arbpl, werks FROM
*    crhd
*    INTO ( @/ptloms/v018-arbpl, @/ptloms/v018-werks )
*    WHERE objty = 'A' AND
*          objid = @/ptloms/v018-objid.

  SELECT SINGLE arbpl werks FROM
    crhd
    INTO (/ptloms/v018-arbpl, /ptloms/v018-werks)
    WHERE objty = 'A' AND
          objid = /ptloms/v018-objid.

  IF sy-subrc IS INITIAL.

    SELECT SINGLE name1
      FROM t001w
      INTO /ptloms/v018-name1
    WHERE werks = /ptloms/v018-werks.

  ENDIF.

ENDFORM.

FORM f_eliminar_dados.

  DATA: lwa_row     TYPE /ptloms/v018,
        lv_msg(100) TYPE c.

* Busca centro de trabalho vinculado ao perfil
*  SELECT *
*    FROM /ptloms/tb017
*    INTO TABLE @DATA(lt_tb017).

  DATA lt_tb017 TYPE TABLE OF /ptloms/tb017.
  DATA ls_017 TYPE /ptloms/tb017.
  SELECT *
    FROM /ptloms/tb017
    INTO TABLE lt_tb017.

  SORT lt_tb017 BY objid.

  FIELD-SYMBOLS <fs_mark> TYPE any.
  FIELD-SYMBOLS <fs_objid> TYPE any.
  FIELD-SYMBOLS <fs_arbpl> TYPE any.

  LOOP AT total.

*    ASSIGN COMPONENT 'MARK' OF STRUCTURE total TO FIELD-SYMBOL(<fs_mark>).
    ASSIGN COMPONENT 'MARK' OF STRUCTURE total TO <fs_mark>.

    CHECK <fs_mark> IS ASSIGNED AND <fs_mark> = 'M'.

*    ASSIGN COMPONENT 'OBJID' OF STRUCTURE total TO FIELD-SYMBOL(<fs_objid>).
    ASSIGN COMPONENT 'OBJID' OF STRUCTURE total TO <fs_objid>.

    CHECK <fs_objid> IS ASSIGNED.

*    READ TABLE lt_tb017 INTO DATA(ls_017)
    READ TABLE lt_tb017 INTO ls_017
    WITH KEY objid = <fs_objid> BINARY SEARCH.

    IF sy-subrc EQ 0.
      vim_abort_saving = 'X'.
      ASSIGN COMPONENT 'ARBPL' OF STRUCTURE total TO <fs_arbpl>.
*      ASSIGN COMPONENT 'ARBPL' OF STRUCTURE total TO FIELD-SYMBOL(<fs_arbpl>).
      CONCATENATE 'utilizado no Perfil'(079) ls_017-perfil INTO lv_msg SEPARATED BY space.
      MESSAGE i000(su) WITH 'Centro de Trabalho:'(128) <fs_arbpl> lv_msg DISPLAY LIKE 'E'.
      EXIT.
    ENDIF.

  ENDLOOP.

ENDFORM.
