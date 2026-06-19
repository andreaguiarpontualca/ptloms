class /PTLOMS/CL007 definition
  public
  final
  create public .

public section.

  types:
    BEGIN OF ty_eqst,
        equnr TYPE eqst-equnr,
        werks TYPE eqst-werks,
        stlan TYPE eqst-stlan,
        stlnr TYPE eqst-stlnr,
        stlal TYPE eqst-stlal,
        stlty TYPE stpo-stlty,
        stlkn TYPE stpo-stlkn,
        stpoz TYPE stpo-stpoz,
        idnrk TYPE stpo-idnrk,
        postp TYPE stpo-postp,
        posnr TYPE stpo-posnr,
        meins TYPE stpo-meins,
        menge TYPE stpo-menge,
        maktx TYPE makt-maktx,
      END OF ty_eqst .
  types:
    ct_eqst TYPE TABLE OF ty_eqst .
  types:
    BEGIN OF ty_tpst,
        tplnr TYPE tpst-tplnr,
        werks TYPE tpst-werks,
        stlan TYPE tpst-stlan,
        stlnr TYPE tpst-stlnr,
        stlal TYPE tpst-stlal,
        stlty TYPE stpo-stlty,
        stlkn TYPE stpo-stlkn,
        stpoz TYPE stpo-stpoz,
        idnrk TYPE stpo-idnrk,
        postp TYPE stpo-postp,
        posnr TYPE stpo-posnr,
        meins TYPE stpo-meins,
        menge TYPE stpo-menge,
        maktx TYPE makt-maktx,
      END OF ty_tpst .
  types:
    ct_tpst TYPE TABLE OF ty_tpst .
  types:
    BEGIN OF ty_mast,
        matnr TYPE mast-matnr,
        werks TYPE mast-werks,
        stlan TYPE mast-stlan,
        stlnr TYPE mast-stlnr,
        stlal TYPE mast-stlal,
        stlty TYPE stpo-stlty,
        stlkn TYPE stpo-stlkn,
        stpoz TYPE stpo-stpoz,
        idnrk TYPE stpo-idnrk,
        postp TYPE stpo-postp,
        posnr TYPE stpo-posnr,
        meins TYPE stpo-meins,
        menge TYPE stpo-menge,
      END OF ty_mast .
  types:
    ct_mast TYPE TABLE OF ty_mast .
  types:
    BEGIN OF ty_ihpa,
        objnr   TYPE ihpa-objnr,
        parvw   TYPE ihpa-parvw,
        counter TYPE ihpa-counter,
        obtyp   TYPE ihpa-obtyp,
        parnr   TYPE ihpa-parnr,
        lifnr   TYPE lfa1-lifnr,
        kunnr   TYPE kna1-kunnr,
        pernr   TYPE pa0001-pernr,
      END OF ty_ihpa .
  types:
    ct_ihpa TYPE TABLE OF ty_ihpa .
  types:
    BEGIN OF ty_imrg,
        mdocm TYPE imrg-mdocm,
        point TYPE imrg-point,
        idate TYPE imrg-idate,
        itime TYPE imrg-itime,
        recdv TYPE imrg-recdv,
        codct TYPE imrg-codct,
        codgr TYPE imrg-codgr,
        vlcod TYPE imrg-vlcod,
        mdtxt TYPE imrg-mdtxt,
        readr TYPE imrg-readr,
        cntrr TYPE imrg-cntrr,
        readg TYPE imrg-readg,
      END OF ty_imrg .
  types:
    ct_imrg TYPE TABLE OF ty_imrg .
  types:
    BEGIN OF ty_imptt,
        point TYPE imptt-point,
        mpobj TYPE imptt-mpobj,
        psort TYPE imptt-psort,
        pttxt TYPE imptt-pttxt,
        atinn TYPE imptt-atinn,
        mrngu TYPE imptt-mrngu,
        codgr TYPE imptt-codgr,
        desir TYPE imptt-desir,
        mrmin TYPE imptt-mrmin,
        mrmax TYPE imptt-mrmax,
        codct TYPE imptt-codct,
      END OF ty_imptt .
  types:
    ct_imptt TYPE TABLE OF ty_imptt .
  types:
    BEGIN OF ty_t352c,
        rbnr     TYPE t352c-rbnr,
        qkatart  TYPE t352c-qkatart,
        qcodegrp TYPE t352c-qcodegrp,
        qmart    TYPE tq80-qmart,
      END OF ty_t352c .
  types:
    ct_t352c TYPE TABLE OF ty_t352c .
  types:
    BEGIN OF ty_inob,
        cuobj      TYPE inob-cuobj,
        objek      TYPE inob-objek,
        objek_conv TYPE inob-objek,
      END OF ty_inob .
  types:
    ct_inob TYPE TABLE OF ty_inob .
  types:
    BEGIN OF ty_equi,
        equnr TYPE equi-equnr,
      END OF ty_equi .
  types:
    ct_equi TYPE TABLE OF ty_equi .
  types:
    BEGIN OF ty_iflot,
        tplnr TYPE iflot-tplnr,
      END OF ty_iflot .
  types:
    ct_iflot TYPE TABLE OF ty_iflot .
  types:
    BEGIN OF ty_ausp,
        objek TYPE ausp-objek,
        atinn TYPE ausp-atinn,
        atzhl TYPE ausp-atzhl,
        mafid TYPE ausp-mafid,
        klart TYPE ausp-klart,
        adzhl TYPE ausp-adzhl,
        atwrt TYPE ausp-atwrt,
        atflv TYPE ausp-atflv,
      END OF ty_ausp .
  types:
    ct_ausp TYPE TABLE OF ty_ausp .

  class-data C_MAX type I value 2000. "#EC NOTEXT

  class-methods SELECT_T352C
    importing
      !RT_TABLE_IN type /IWBEP/T_COD_SELECT_OPTIONS
    exporting
      value(RT_TABLE_OUT) type CT_T352C .
  class-methods SELECT_IFLOT
    importing
      !RT_TABLE_IN type /IWBEP/T_COD_SELECT_OPTIONS
    exporting
      value(RT_TABLE_OUT) type CT_IFLOT .
  class-methods SELECT_IMRG
    importing
      !RT_TABLE_IN type /IWBEP/T_COD_SELECT_OPTIONS
    exporting
      value(RT_TABLE_OUT) type CT_IMRG .
  class-methods SELECT_IHPA
    importing
      !RT_TABLE_IN type /IWBEP/T_COD_SELECT_OPTIONS
    exporting
      value(RT_TABLE_OUT) type CT_IHPA .
  class-methods SELECT_MAST
    importing
      !RT_TABLE_IN type /IWBEP/T_COD_SELECT_OPTIONS
    exporting
      value(RT_TABLE_OUT) type CT_MAST .
  class-methods SELECT_TPST
    importing
      !RT_TABLE_IN type /IWBEP/T_COD_SELECT_OPTIONS
    exporting
      value(RT_TABLE_OUT) type CT_TPST .
  class-methods SELECT_EQST
    importing
      !RT_TABLE_IN type /IWBEP/T_COD_SELECT_OPTIONS
    exporting
      value(RT_TABLE_OUT) type CT_EQST .
  class-methods SELECT_EQUI
    importing
      !RT_TABLE_IN type /IWBEP/T_COD_SELECT_OPTIONS
    exporting
      value(RT_TABLE_OUT) type CT_EQUI .
  class-methods SELECT_INOB
    importing
      !RT_TABLE_IN type /IWBEP/T_COD_SELECT_OPTIONS
    exporting
      value(RT_TABLE_OUT) type CT_INOB .
  class-methods SELECT_IMPTT
    importing
      !RT_TABLE_IN type /IWBEP/T_COD_SELECT_OPTIONS
      !RT_ATINN type RSDSSELOPT_T optional
    exporting
      value(RT_TABLE_OUT) type CT_IMPTT .
  class-methods SELECT_AUSP
    importing
      !RT_TABLE_IN type /IWBEP/T_COD_SELECT_OPTIONS
    exporting
      value(RT_TABLE_OUT) type CT_AUSP .
protected section.
private section.
ENDCLASS.



CLASS /PTLOMS/CL007 IMPLEMENTATION.


  METHOD select_ausp.

*********************************************************************************************************
***  Trecho do código abaixo REVISADO em 02/05/2024 em função da incompatibilidade de versão com a SOLAR.
*********************************************************************************************************
***  Bretz
*********************************************************************************************************

    DATA: rt_table_in_aux TYPE /iwbep/t_cod_select_options.

    DATA: ls_table_in LIKE LINE OF rt_table_in.

    DATA: lv_times TYPE i,
          lv_ini   TYPE i,
          lv_fim   TYPE i.

*** DESCRIBE TABLE rt_table_in LINES DATA(lv_qtd).
    DATA: lv_qtd TYPE i.
    DESCRIBE TABLE rt_table_in LINES lv_qtd.

*** DATA(lv_div) = lv_qtd DIV c_max.
    DATA: lv_div TYPE i.
    lv_div = lv_qtd DIV c_max.

*** DATA(lv_mod) = lv_qtd MOD c_max.
    DATA: lv_mod TYPE i.
    lv_mod = lv_qtd MOD c_max.

*   Atualiza quantidade de iteração e início e fim do range
    lv_ini = 1.
    IF lv_div IS INITIAL AND lv_mod IS NOT INITIAL.
      lv_times = 1.
      lv_fim   = lv_mod.
    ELSEIF lv_div IS NOT INITIAL AND lv_mod IS INITIAL.
      lv_times = lv_div.
      lv_fim   = c_max.
    ELSEIF lv_div IS NOT INITIAL AND lv_mod IS NOT INITIAL.
      lv_times = lv_div + 1.
      lv_fim   = c_max.
    ENDIF.

    DO lv_times TIMES.

***   DATA(lv_index) = sy-index.
      DATA: lv_index TYPE sy-index.
      lv_index = sy-index.

*     Monta tabela de Range (Com limite máximo de 2000 registros)
      REFRESH rt_table_in_aux[].
      LOOP AT rt_table_in INTO ls_table_in FROM lv_ini TO lv_fim.
        APPEND ls_table_in TO rt_table_in_aux.
      ENDLOOP.

*     Busca dados na tabela
      SELECT objek atinn atzhl mafid klart adzhl atwrt atflv
        FROM ausp
        APPENDING CORRESPONDING FIELDS OF TABLE rt_table_out
        WHERE objek IN rt_table_in_aux.

***      SELECT objek, atinn, atzhl, mafid, klart, adzhl, atwrt, atflv
***        FROM ausp
***        APPENDING TABLE @rt_table_out
***        WHERE objek IN @rt_table_in_aux.

*     Atualiza Início e Fim para montagem do range
      lv_ini = lv_fim + 1.
      IF lv_index = lv_div.
        lv_fim = lv_fim + lv_mod.
      ELSE.
        lv_fim = lv_fim * 2.
      ENDIF.
    ENDDO.

  ENDMETHOD.


  METHOD select_eqst.

************************************************************************************************************
******  Trecho do código abaixo REVISADO em 03/05/2024 em função da incompatibilidade de versão com a SOLAR.
************************************************************************************************************
    DATA: rt_table_in_aux TYPE /iwbep/t_cod_select_options.

    DATA: ls_table_in  LIKE LINE OF rt_table_in,
          ls_table_dec LIKE LINE OF rt_table_in.

    DATA: lv_times TYPE i,
          lv_qtd   TYPE i,
          lv_equnr TYPE equi-equnr.

    TYPES: BEGIN OF ty_makt,
             matnr TYPE makt-matnr,
             maktx TYPE makt-maktx,
           END OF ty_makt.

    DATA: lt_makt TYPE TABLE OF ty_makt.
    DATA: ls_makt  LIKE LINE OF lt_makt.

    DATA: r_equnr TYPE /iwbep/t_cod_select_options.

    FIELD-SYMBOLS: <fs_equnr> LIKE LINE OF rt_table_out.

    CLEAR: ls_table_in, lv_qtd.
    REFRESH: rt_table_in_aux.

    IF rt_table_in[] IS NOT INITIAL.

      READ TABLE rt_table_in INTO ls_table_in INDEX 1.

      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
        EXPORTING
          input  = ls_table_in-low
        IMPORTING
          output = lv_equnr.

      ls_table_in-low = lv_equnr.

      DESCRIBE TABLE rt_table_in LINES lv_qtd.

      READ TABLE rt_table_in INTO ls_table_dec INDEX lv_qtd.

      CALL FUNCTION 'CONVERSION_EXIT_ALPHA_INPUT'
        EXPORTING
          input  = ls_table_dec-low
        IMPORTING
          output = lv_equnr.

      ls_table_in-high   = lv_equnr.
      ls_table_in-sign   = 'I'.
      ls_table_in-option = 'BT'.

      APPEND ls_table_in TO r_equnr.

      IF r_equnr[] IS NOT INITIAL.

        SELECT a~equnr a~werks a~stlan a~stlnr a~stlal
               b~stlty b~stlkn b~stpoz b~idnrk b~postp
               b~posnr b~meins b~menge "m~maktx
          FROM eqst AS a
          INNER JOIN stpo AS b ON b~stlnr = a~stlnr
*         INNER JOIN makt AS m ON m~matnr = b~idnrk
          INTO TABLE rt_table_out
          WHERE a~equnr IN r_equnr
            AND b~stlty = 'E'.
           "AND m~spras = sy-langu.

        LOOP AT rt_table_out ASSIGNING <fs_equnr>.
          CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
            EXPORTING
              input  = <fs_equnr>-equnr
            IMPORTING
              output = <fs_equnr>-equnr.
        ENDLOOP.

        IF sy-subrc EQ 0.

          DELETE rt_table_out WHERE equnr NOT IN rt_table_in.

          IF rt_table_out[] IS NOT INITIAL.
            SELECT matnr maktx
             FROM makt
             INTO TABLE lt_makt
             FOR ALL ENTRIES IN rt_table_out
             WHERE matnr = rt_table_out-idnrk
               AND spras = sy-langu.

            FIELD-SYMBOLS: <fs_table_ou> LIKE LINE OF rt_table_out.

            LOOP AT rt_table_out ASSIGNING <fs_table_ou>.
              CLEAR ls_makt.
              READ TABLE lt_makt INTO ls_makt WITH KEY matnr = <fs_table_ou>-idnrk.
              IF sy-subrc EQ 0.
                <fs_table_ou>-maktx = ls_makt-maktx.
              ENDIF.
            ENDLOOP.

          ENDIF.
        ENDIF.
      ENDIF.
    ENDIF.

************************************************************************************************************
******  Trecho do código abaixo REVISADO em 03/05/2024 em função da incompatibilidade de versão com a SOLAR.
************************************************************************************************************
******  INICIO - Nádia Rodrigues
************************************************************************************************************
***
***    DATA: rt_table_in_aux TYPE /iwbep/t_cod_select_options.
***
***    DATA: ls_table_in LIKE LINE OF rt_table_in.
***
***    DATA: lv_times TYPE i,
***          lv_ini   TYPE i,
***          lv_fim   TYPE i.
****   DESCRIBE TABLE rt_table_in LINES DATA(lv_qtd).
***    DATA lv_qtd TYPE i.
***    DESCRIBE TABLE rt_table_in LINES lv_qtd.
****    DATA(lv_div) = lv_qtd DIV c_max.
****    DATA(lv_mod) = lv_qtd MOD c_max.
***    DATA:  lv_div, lv_mod TYPE i.
***    lv_div = lv_qtd DIV c_max.
***    lv_mod = lv_qtd MOD c_max.
***
**** Atualiza quantidade de iteração e início e fim do range
***    lv_ini = 1.
***    IF lv_div IS INITIAL AND lv_mod IS NOT INITIAL.
***      lv_times = 1.
***      lv_fim   = lv_mod.
***    ELSEIF lv_div IS NOT INITIAL AND lv_mod IS INITIAL.
***      lv_times = lv_div.
***      lv_fim   = c_max.
***    ELSEIF lv_div IS NOT INITIAL AND lv_mod IS NOT INITIAL.
***      lv_times = lv_div + 1.
***      lv_fim   = c_max.
***    ENDIF.
***
***    DATA lv_index TYPE sy-index.
***    DO lv_times TIMES.
****       DATA(lv_index) = sy-index.
***      lv_index = sy-index.
***
**** Monta tabela de Range (Com limite máximo de 2000 registros)
***      REFRESH rt_table_in_aux[].
***      LOOP AT rt_table_in INTO ls_table_in FROM lv_ini TO lv_fim.
***        APPEND ls_table_in TO rt_table_in_aux.
***      ENDLOOP.
***
**** Busca dados na tabela
****      SELECT a~equnr, a~werks, a~stlan, a~stlnr, a~stlal,
****             b~stlty, b~stlkn, b~stpoz, b~idnrk, b~postp,
****             b~posnr, b~meins, b~menge
****        FROM eqst AS a INNER JOIN stpo AS b ON a~stlnr = b~stlnr
****        APPENDING TABLE @rt_table_out
****        WHERE a~equnr IN @rt_table_in_aux
****          AND b~stlty = 'E'.
***      SELECT a~equnr a~werks a~stlan a~stlnr a~stlal
***             b~stlty b~stlkn b~stpoz b~idnrk b~postp
***             b~posnr b~meins b~menge
***        FROM eqst AS a INNER JOIN stpo AS b ON a~stlnr = b~stlnr
***        APPENDING TABLE  rt_table_out
***        WHERE a~equnr IN rt_table_in_aux
***          AND b~stlty = 'E'.
************************************************************************************************************
******  FIM - Nádia Rodrigues
************************************************************************************************************
**** Atualiza Início e Fim para montagem do range
***      lv_ini = lv_fim + 1.
***      IF lv_index = lv_div.
***        lv_fim = lv_fim + lv_mod.
***      ELSE.
***        lv_fim = lv_fim * 2.
***      ENDIF.
***    ENDDO.

  ENDMETHOD.


  METHOD select_equi.

*********************************************************************************************************
***  Trecho do código abaixo REVISADO em 02/05/2024 em função da incompatibilidade de versão com a SOLAR.
*********************************************************************************************************
***  Bretz
*********************************************************************************************************

    DATA: rt_table_in_aux TYPE /iwbep/t_cod_select_options.

    DATA: ls_table_in LIKE LINE OF rt_table_in.

    DATA: lv_times TYPE i,
          lv_ini   TYPE i,
          lv_fim   TYPE i.

*** DESCRIBE TABLE rt_table_in LINES DATA(lv_qtd).
    DATA: lv_qtd TYPE i.
    DESCRIBE TABLE rt_table_in LINES lv_qtd.

*** DATA(lv_div) = lv_qtd DIV c_max.
    DATA: lv_div TYPE i.
    lv_div = lv_qtd DIV c_max.

*** DATA(lv_mod) = lv_qtd MOD c_max.
    DATA: lv_mod TYPE i.
    lv_mod = lv_qtd MOD c_max.

*   Atualiza quantidade de iteração e início e fim do range
    lv_ini = 1.
    IF lv_div IS INITIAL AND lv_mod IS NOT INITIAL.
      lv_times = 1.
      lv_fim   = lv_mod.
    ELSEIF lv_div IS NOT INITIAL AND lv_mod IS INITIAL.
      lv_times = lv_div.
      lv_fim   = c_max.
    ELSEIF lv_div IS NOT INITIAL AND lv_mod IS NOT INITIAL.
      lv_times = lv_div + 1.
      lv_fim   = c_max.
    ENDIF.

    DO lv_times TIMES.

***   DATA(lv_index) = sy-index.
      DATA: lv_index TYPE sy-index.
      lv_index = sy-index.

*     Monta tabela de Range (Com limite máximo de 2000 registros)
      REFRESH rt_table_in_aux[].
      LOOP AT rt_table_in INTO ls_table_in FROM lv_ini TO lv_fim.
        APPEND ls_table_in TO rt_table_in_aux.
      ENDLOOP.

*     Busca dados na tabela
      SELECT equnr
        FROM equi
        APPENDING TABLE rt_table_out
        WHERE equnr IN rt_table_in_aux.

*     Atualiza Início e Fim para montagem do range
      lv_ini = lv_fim + 1.
      IF lv_index = lv_div.
        lv_fim = lv_fim + lv_mod.
      ELSE.
        lv_fim = lv_fim * 2.
      ENDIF.
    ENDDO.

  ENDMETHOD.


  METHOD select_iflot.
*********************************************************************************************************
***  Trecho do código abaixo REVISADO em 03/05/2024 em função da incompatibilidade de versão com a SOLAR.
*********************************************************************************************************
***  INICIO - Nádia Rodrigues
*********************************************************************************************************
    DATA: rt_table_in_aux TYPE /iwbep/t_cod_select_options.

    DATA: ls_table_in LIKE LINE OF rt_table_in.

    DATA: lv_times TYPE i,
          lv_ini   TYPE i,
          lv_fim   TYPE i.

*   DESCRIBE TABLE rt_table_in LINES DATA(lv_qtd).
    DATA lv_qtd TYPE i.
    DESCRIBE TABLE rt_table_in LINES lv_qtd.

*    DATA(lv_div) = lv_qtd DIV c_max.
*    DATA(lv_mod) = lv_qtd MOD c_max.
    DATA: lv_div, lv_mod TYPE i.
    lv_div = lv_qtd DIV c_max.
    lv_mod = lv_qtd MOD c_max.

* Atualiza quantidade de iteração e início e fim do range
    lv_ini = 1.
    IF lv_div IS INITIAL AND lv_mod IS NOT INITIAL.
      lv_times = 1.
      lv_fim   = lv_mod.
    ELSEIF lv_div IS NOT INITIAL AND lv_mod IS INITIAL.
      lv_times = lv_div.
      lv_fim   = c_max.
    ELSEIF lv_div IS NOT INITIAL AND lv_mod IS NOT INITIAL.
      lv_times = lv_div + 1.
      lv_fim   = c_max.
    ENDIF.

    DATA lv_index TYPE sy-index.
    DO lv_times TIMES.
*      DATA(lv_index) = sy-index.
       lv_index = sy-index.

* Monta tabela de Range (Com limite máximo de 2000 registros)
      REFRESH rt_table_in_aux[].
      LOOP AT rt_table_in INTO ls_table_in FROM lv_ini TO lv_fim.
        APPEND ls_table_in TO rt_table_in_aux.
      ENDLOOP.

* Busca dados na tabela
*      SELECT tplnr
*        FROM iflot
*        APPENDING TABLE @rt_table_out
*        WHERE tplnr IN @rt_table_in_aux.
      SELECT tplnr
        FROM iflot
        APPENDING TABLE rt_table_out
        WHERE tplnr IN rt_table_in_aux.
*********************************************************************************************************
***  Fim - Nádia Rodrigues
*********************************************************************************************************

* Atualiza Início e Fim para montagem do range
      lv_ini = lv_fim + 1.
      IF lv_index = lv_div.
        lv_fim = lv_fim + lv_mod.
      ELSE.
        lv_fim = lv_fim * 2.
      ENDIF.
    ENDDO.

  ENDMETHOD.


  METHOD select_ihpa.
*********************************************************************************************************
***  Trecho do código abaixo REVISADO em 03/05/2024 em função da incompatibilidade de versão com a SOLAR.
*********************************************************************************************************
***  INICIO - Nádia Rodrigues
*********************************************************************************************************

    DATA: rt_table_in_aux TYPE /iwbep/t_cod_select_options.

    DATA: ls_table_in LIKE LINE OF rt_table_in.

    DATA: lv_times TYPE i,
          lv_ini   TYPE i,
          lv_fim   TYPE i.

*    DESCRIBE TABLE rt_table_in LINES DATA(lv_qtd).
    DATA lv_qtd TYPE i.
    DESCRIBE TABLE rt_table_in LINES lv_qtd.
*    DATA(lv_div) = lv_qtd DIV c_max.
*    DATA(lv_mod) = lv_qtd MOD c_max.
    DATA: lv_div, lv_mod TYPE i.
    lv_div = lv_qtd DIV c_max.
    lv_mod = lv_qtd MOD c_max.


* Atualiza quantidade de iteração e início e fim do range
    lv_ini = 1.
    IF lv_div IS INITIAL AND lv_mod IS NOT INITIAL.
      lv_times = 1.
      lv_fim   = lv_mod.
    ELSEIF lv_div IS NOT INITIAL AND lv_mod IS INITIAL.
      lv_times = lv_div.
      lv_fim   = c_max.
    ELSEIF lv_div IS NOT INITIAL AND lv_mod IS NOT INITIAL.
      lv_times = lv_div + 1.
      lv_fim   = c_max.
    ENDIF.

    DATA lv_index TYPE sy-index.
    DO lv_times TIMES.
*      DATA(lv_index) = sy-index.
       lv_index = sy-index.

* Monta tabela de Range (Com limite máximo de 2000 registros)
      REFRESH rt_table_in_aux[].
      LOOP AT rt_table_in INTO ls_table_in FROM lv_ini TO lv_fim.
        APPEND ls_table_in TO rt_table_in_aux.
      ENDLOOP.

* Busca dados na tabela
*      SELECT objnr, parvw, counter, obtyp, parnr
*        FROM ihpa
*        APPENDING TABLE @rt_table_out
*        WHERE objnr IN @rt_table_in_aux
*          AND kzloesch <> 'X'.
      SELECT objnr parvw counter obtyp parnr
        FROM ihpa
        APPENDING CORRESPONDING FIELDS OF TABLE rt_table_out
        WHERE objnr IN  rt_table_in_aux
          AND kzloesch <> 'X'.
*********************************************************************************************************
***  FIM - Nádia Rodrigues
*********************************************************************************************************
* Atualiza Início e Fim para montagem do range
      lv_ini = lv_fim + 1.
      IF lv_index = lv_div.
        lv_fim = lv_fim + lv_mod.
      ELSE.
        lv_fim = lv_fim * 2.
      ENDIF.
    ENDDO.

  ENDMETHOD.


  METHOD select_imptt.

*********************************************************************************************************
***  Trecho do código abaixo REVISADO em 02/05/2024 em função da incompatibilidade de versão com a SOLAR.
*********************************************************************************************************
***  Bretz
*********************************************************************************************************

    DATA: rt_table_in_aux TYPE /iwbep/t_cod_select_options.

    DATA: ls_table_in  LIKE LINE OF rt_table_in,
          ls_table_dec LIKE LINE OF rt_table_in.

    DATA: lv_times TYPE i,
          lv_ini   TYPE i,
          lv_fim   TYPE i,
          lv_qtd   TYPE i.

    CLEAR: ls_table_in, lv_qtd.
    REFRESH: rt_table_in_aux.

    IF rt_table_in[] IS NOT INITIAL.

      READ TABLE rt_table_in INTO ls_table_in INDEX 1.

      DESCRIBE TABLE rt_table_in LINES lv_qtd.

      READ TABLE rt_table_in INTO ls_table_dec INDEX lv_qtd.
      ls_table_in-high   = ls_table_dec-low.

      ls_table_in-sign   = 'I'.
      ls_table_in-option = 'BT'.

      APPEND ls_table_in TO rt_table_in_aux.

      IF rt_table_in_aux[] IS NOT INITIAL.
        SELECT point mpobj psort pttxt atinn
               mrngu codgr desir mrmin mrmax
               codct
          FROM imptt
          INTO TABLE rt_table_out
          WHERE mpobj IN rt_table_in_aux
            AND inact EQ space
            AND atinn IN rt_atinn.

        IF sy-subrc EQ 0.
          DELETE rt_table_out WHERE mpobj NOT IN rt_table_in.
        ENDIF.
      ENDIF.

    ENDIF.

******* DESCRIBE TABLE rt_table_in LINES DATA(lv_qtd).
****    DATA: lv_qtd TYPE i.
****    DESCRIBE TABLE rt_table_in LINES lv_qtd.
****
******* DATA(lv_div) = lv_qtd DIV c_max.
****    DATA: lv_div TYPE i.
****    lv_div = lv_qtd DIV c_max.
****
******* DATA(lv_mod) = lv_qtd MOD c_max.
****    DATA: lv_mod TYPE i.
****    lv_mod = lv_qtd MOD c_max.
****
***** Atualiza quantidade de iteração e início e fim do range
****    lv_ini = 1.
****    IF lv_div IS INITIAL AND lv_mod IS NOT INITIAL.
****      lv_times = 1.
****      lv_fim   = lv_mod.
****    ELSEIF lv_div IS NOT INITIAL AND lv_mod IS INITIAL.
****      lv_times = lv_div.
****      lv_fim   = c_max.
****    ELSEIF lv_div IS NOT INITIAL AND lv_mod IS NOT INITIAL.
****      lv_times = lv_div + 1.
****      lv_fim   = c_max.
****    ENDIF.
****
****    DO lv_times TIMES.
****
*******   DATA(lv_index) = sy-index.
****      DATA: lv_index TYPE sy-index.
****      lv_index = sy-index.
****
*****     Monta tabela de Range (Com limite máximo de 2000 registros)
****      REFRESH rt_table_in_aux[].
****      LOOP AT rt_table_in INTO ls_table_in FROM lv_ini TO lv_fim.
****        APPEND ls_table_in TO rt_table_in_aux.
****      ENDLOOP.
****
*****     Busca dados na tabela
****      IF rt_table_in_aux[] IS NOT INITIAL.
****        SELECT point mpobj psort pttxt atinn
****               mrngu codgr desir mrmin mrmax
****               codct
****          FROM imptt
****          APPENDING TABLE rt_table_out
****          WHERE mpobj IN rt_table_in_aux
****            AND inact EQ space
****            AND atinn IN rt_atinn.
****      ENDIF.
****
*******      SELECT point, mpobj, psort, pttxt, atinn,
*******             mrngu, codgr, desir, mrmin, mrmax,
*******             codct
*******        FROM imptt
*******        APPENDING TABLE @rt_table_out
*******        WHERE mpobj IN @rt_table_in_aux
*******          AND inact EQ @space
*******          AND atinn IN @rt_atinn.
****
*****     Atualiza Início e Fim para montagem do range
****      lv_ini = lv_fim + 1.
****      IF lv_index = lv_div.
****        lv_fim = lv_fim + lv_mod.
****      ELSE.
****        lv_fim = lv_fim + 2000.
****      ENDIF.
****    ENDDO.

  ENDMETHOD.


  METHOD select_imrg.
*********************************************************************************************************
***  Trecho do código abaixo REVISADO em 03/05/2024 em função da incompatibilidade de versão com a SOLAR.
*********************************************************************************************************
***  INICIO - Nádia Rodrigues
*********************************************************************************************************
    DATA: rt_table_in_aux TYPE /iwbep/t_cod_select_options.

    DATA: ls_table_in LIKE LINE OF rt_table_in.

    DATA: lv_times TYPE i,
          lv_ini   TYPE i,
          lv_fim   TYPE i.

    DATA lv_qtd TYPE i.
    DESCRIBE TABLE rt_table_in LINES lv_qtd.

    DATA: lv_div, lv_mod TYPE i.
    lv_div = lv_qtd DIV c_max.
    lv_mod = lv_qtd MOD c_max.

*   Atualiza quantidade de iteração e início e fim do range
    lv_ini = 1.
    IF lv_div IS INITIAL AND lv_mod IS NOT INITIAL.
      lv_times = 1.
      lv_fim   = lv_mod.
    ELSEIF lv_div IS NOT INITIAL AND lv_mod IS INITIAL.
      lv_times = lv_div.
      lv_fim   = c_max.
    ELSEIF lv_div IS NOT INITIAL AND lv_mod IS NOT INITIAL.
      lv_times = lv_div + 1.
      lv_fim   = c_max.
    ENDIF.

    DATA lv_index TYPE sy-index.
    DO lv_times TIMES.

      lv_index = sy-index.

*     Monta tabela de Range (Com limite máximo de 2000 registros)
      REFRESH rt_table_in_aux[].
      LOOP AT rt_table_in INTO ls_table_in FROM lv_ini TO lv_fim.
        APPEND ls_table_in TO rt_table_in_aux.
      ENDLOOP.

      IF rt_table_in_aux[] IS NOT INITIAL.
        SELECT mdocm point idate itime recdv
               codct codgr vlcod mdtxt readr
               cntrr readg
          FROM imrg
          APPENDING TABLE rt_table_out
          WHERE point IN rt_table_in_aux
            AND cancl EQ space.
      ENDIF.

*     Atualiza Início e Fim para montagem do range
      lv_ini = lv_fim + 1.
      IF lv_index = lv_div.
        lv_fim = lv_fim + lv_mod.
      ELSE.
*       lv_fim = lv_fim * 2.
*       23/12/2022 - Alterado por motivo de dump na Rebic
        lv_fim = lv_fim + 2000.
      ENDIF.
    ENDDO.

  ENDMETHOD.


  METHOD select_inob.

*********************************************************************************************************
***  Trecho do código abaixo REVISADO em 02/05/2024 em função da incompatibilidade de versão com a SOLAR.
*********************************************************************************************************
***  Bretz
*********************************************************************************************************

    DATA: rt_table_in_aux TYPE /iwbep/t_cod_select_options.

    DATA: ls_table_in LIKE LINE OF rt_table_in.

    DATA: lv_times TYPE i,
          lv_ini   TYPE i,
          lv_fim   TYPE i.

*** DESCRIBE TABLE rt_table_in LINES DATA(lv_qtd).
    DATA: lv_qtd TYPE i.
    DESCRIBE TABLE rt_table_in LINES lv_qtd.

*** DATA(lv_div) = lv_qtd DIV c_max.
    DATA: lv_div TYPE i.
    lv_div = lv_qtd DIV c_max.

*** DATA(lv_mod) = lv_qtd MOD c_max.
    DATA: lv_mod TYPE i.
    lv_mod = lv_qtd MOD c_max.


*   Atualiza quantidade de iteração e início e fim do range
    lv_ini = 1.
    IF lv_div IS INITIAL AND lv_mod IS NOT INITIAL.
      lv_times = 1.
      lv_fim   = lv_mod.
    ELSEIF lv_div IS NOT INITIAL AND lv_mod IS INITIAL.
      lv_times = lv_div.
      lv_fim   = c_max.
    ELSEIF lv_div IS NOT INITIAL AND lv_mod IS NOT INITIAL.
      lv_times = lv_div + 1.
      lv_fim   = c_max.
    ENDIF.

    DO lv_times TIMES.

***   DATA(lv_index) = sy-index.
      DATA: lv_index TYPE sy-index.
      lv_index = sy-index.

*     Monta tabela de Range (Com limite máximo de 2000 registros)
      REFRESH rt_table_in_aux[].
      LOOP AT rt_table_in INTO ls_table_in FROM lv_ini TO lv_fim.
        APPEND ls_table_in TO rt_table_in_aux.
      ENDLOOP.

*     Busca dados na tabela
      SELECT cuobj objek
        FROM inob
        APPENDING CORRESPONDING FIELDS OF TABLE rt_table_out
        WHERE objek IN rt_table_in_aux.

***      SELECT cuobj, objek
***        FROM inob
***        APPENDING CORRESPONDING FIELDS OF TABLE @rt_table_out
***        WHERE objek IN @rt_table_in_aux.

*     Atualiza Início e Fim para montagem do range
      lv_ini = lv_fim + 1.
      IF lv_index = lv_div.
        lv_fim = lv_fim + lv_mod.
      ELSE.
        lv_fim = lv_fim * 2.
      ENDIF.
    ENDDO.

  ENDMETHOD.


  METHOD select_mast.
*********************************************************************************************************
***  Trecho do código abaixo REVISADO em 03/05/2024 em função da incompatibilidade de versão com a SOLAR.
*********************************************************************************************************
***  INICIO - Nádia Rodrigues
*********************************************************************************************************

    DATA: rt_table_in_aux TYPE /iwbep/t_cod_select_options.

    DATA: ls_table_in LIKE LINE OF rt_table_in.

    DATA: lv_times TYPE i,
          lv_ini   TYPE i,
          lv_fim   TYPE i.

*    DESCRIBE TABLE rt_table_in LINES DATA(lv_qtd).
    DATA lv_qtd TYPE i.
    DESCRIBE TABLE rt_table_in LINES lv_qtd.

*    DATA(lv_div) = lv_qtd DIV c_max.
*    DATA(lv_mod) = lv_qtd MOD c_max.
    DATA: lv_div, lv_mod TYPE i.
    lv_div = lv_qtd DIV c_max.
    lv_mod = lv_qtd MOD c_max.

* Atualiza quantidade de iteração e início e fim do range
    lv_ini = 1.
    IF lv_div IS INITIAL AND lv_mod IS NOT INITIAL.
      lv_times = 1.
      lv_fim   = lv_mod.
    ELSEIF lv_div IS NOT INITIAL AND lv_mod IS INITIAL.
      lv_times = lv_div.
      lv_fim   = c_max.
    ELSEIF lv_div IS NOT INITIAL AND lv_mod IS NOT INITIAL.
      lv_times = lv_div + 1.
      lv_fim   = c_max.
    ENDIF.

    DATA lv_index TYPE sy-index.
    DO lv_times TIMES.
*      DATA(lv_index) = sy-index.
      lv_index = sy-index.

* Monta tabela de Range (Com limite máximo de 2000 registros)
      REFRESH rt_table_in_aux[].
      LOOP AT rt_table_in INTO ls_table_in FROM lv_ini TO lv_fim.
        APPEND ls_table_in TO rt_table_in_aux.
      ENDLOOP.

* Busca dados na tabela
*      SELECT a~matnr, a~werks, a~stlan, a~stlnr, a~stlal,
*             b~stlty, b~stlkn, b~stpoz, b~idnrk, b~postp,
*             b~posnr, b~meins, b~menge
*        FROM mast AS a INNER JOIN stpo AS b ON a~stlnr = b~stlnr
*        APPENDING TABLE @rt_table_out
*        WHERE a~matnr IN @rt_table_in_aux
*          AND a~stlan = '4'
*          AND b~stlty = 'M'.
      SELECT a~matnr a~werks a~stlan a~stlnr a~stlal
             b~stlty b~stlkn b~stpoz b~idnrk b~postp
             b~posnr b~meins b~menge
        FROM mast AS a INNER JOIN stpo AS b ON a~stlnr = b~stlnr
        APPENDING TABLE rt_table_out
        WHERE a~matnr IN rt_table_in_aux
          AND a~stlan = '4'
          AND b~stlty = 'M'.
*********************************************************************************************************
***  FIM - Nádia Rodrigues
*********************************************************************************************************
* Atualiza Início e Fim para montagem do range
      lv_ini = lv_fim + 1.
      IF lv_index = lv_div.
        lv_fim = lv_fim + lv_mod.
      ELSE.
        lv_fim = lv_fim * 2.
      ENDIF.
    ENDDO.

  ENDMETHOD.


  METHOD select_t352c.
*********************************************************************************************************
***  Trecho do código abaixo REVISADO em 30/04/2024 em função da incompatibilidade de versão com a SOLAR.
*********************************************************************************************************
***  INICIO - André Aguiar
*********************************************************************************************************
    DATA: rt_table_in_aux TYPE /iwbep/t_cod_select_options.

    DATA: ls_table_in LIKE LINE OF rt_table_in.

    DATA: lv_times TYPE i,
          lv_ini   TYPE i,
          lv_fim   TYPE i,
          lv_qtd   TYPE i,
          lv_div   TYPE i,
          lv_mod   TYPE i,
          lv_index TYPE i.

    DESCRIBE TABLE rt_table_in LINES lv_qtd.
    lv_div = lv_qtd DIV c_max.
    lv_mod = lv_qtd MOD c_max.

*   Atualiza quantidade de iteração e início e fim do range
    lv_ini = 1.
    IF lv_div IS INITIAL AND lv_mod IS NOT INITIAL.
      lv_times = 1.
      lv_fim   = lv_mod.
    ELSEIF lv_div IS NOT INITIAL AND lv_mod IS INITIAL.
      lv_times = lv_div.
      lv_fim   = c_max.
    ELSEIF lv_div IS NOT INITIAL AND lv_mod IS NOT INITIAL.
      lv_times = lv_div + 1.
      lv_fim   = c_max.
    ENDIF.

    DO lv_times TIMES.
      lv_index = sy-index.

*     Monta tabela de Range (Com limite máximo de 2000 registros)
      REFRESH rt_table_in_aux[].
      LOOP AT rt_table_in INTO ls_table_in FROM lv_ini TO lv_fim WHERE low IS NOT INITIAL.
        APPEND ls_table_in TO rt_table_in_aux.
      ENDLOOP.

*     Busca dados na tabela
      IF rt_table_in_aux[] IS NOT INITIAL.
        SELECT rbnr qkatart qcodegrp
          FROM t352c
          APPENDING CORRESPONDING FIELDS OF TABLE rt_table_out
          WHERE rbnr IN rt_table_in_aux
          AND ( qkatart EQ 'B' OR
                qkatart EQ 'C' OR
                qkatart EQ '2' OR    "Vidal - 21/05/2025
                qkatart EQ '5' ).
      ENDIF.

*     Atualiza Início e Fim para montagem do range
      lv_ini = lv_fim + 1.
      IF lv_index = lv_div.
        lv_fim = lv_fim + lv_mod.
      ELSE.
        lv_fim = lv_fim * 2.
      ENDIF.
    ENDDO.

  ENDMETHOD.


  METHOD select_tpst.
*********************************************************************************************************
***  Trecho do código abaixo REVISADO em 03/05/2024 em função da incompatibilidade de versão com a SOLAR.
*********************************************************************************************************
***  INICIO - Nádia Rodrigues
*********************************************************************************************************
    DATA: rt_table_in_aux TYPE /iwbep/t_cod_select_options.

    DATA: ls_table_in LIKE LINE OF rt_table_in.

    DATA: lv_times TYPE i,
          lv_ini   TYPE i,
          lv_fim   TYPE i.

*    DESCRIBE TABLE rt_table_in LINES DATA(lv_qtd).
    DATA lv_qtd TYPE i.
    DESCRIBE TABLE rt_table_in LINES lv_qtd.
*    DATA(lv_div) = lv_qtd DIV c_max.
*    DATA(lv_mod) = lv_qtd MOD c_max.
    DATA: lv_div, lv_mod TYPE i.
    lv_div = lv_qtd DIV c_max.
    lv_mod = lv_qtd MOD c_max.

* Atualiza quantidade de iteração e início e fim do range
    lv_ini = 1.
    IF lv_div IS INITIAL AND lv_mod IS NOT INITIAL.
      lv_times = 1.
      lv_fim   = lv_mod.
    ELSEIF lv_div IS NOT INITIAL AND lv_mod IS INITIAL.
      lv_times = lv_div.
      lv_fim   = c_max.
    ELSEIF lv_div IS NOT INITIAL AND lv_mod IS NOT INITIAL.
      lv_times = lv_div + 1.
      lv_fim   = c_max.
    ENDIF.

    DATA lv_index TYPE sy-index.
    DO lv_times TIMES.
*      DATA(lv_index) = sy-index.
      lv_index = sy-index.

* Monta tabela de Range (Com limite máximo de 2000 registros)
      REFRESH rt_table_in_aux[].
      LOOP AT rt_table_in INTO ls_table_in FROM lv_ini TO lv_fim WHERE low IS NOT INITIAL.
        APPEND ls_table_in TO rt_table_in_aux.
      ENDLOOP.

* Busca dados na tabela
*      SELECT a~tplnr, a~werks, a~stlan, a~stlnr, a~stlal,
*             b~stlty, b~stlkn, b~stpoz, b~idnrk, b~postp,
*             b~posnr, b~meins, b~menge, c~maktx
*                    FROM tpst AS a
*              INNER JOIN stpo AS b ON a~stlnr = b~stlnr
*              INNER JOIN makt AS c ON c~matnr = b~idnrk
*                                  AND c~spras = @sy-langu
*          APPENDING TABLE @rt_table_out
*        WHERE a~tplnr  IN @rt_table_in_aux
*          AND b~stlty = 'T'.
      SELECT a~tplnr a~werks a~stlan a~stlnr a~stlal
             b~stlty b~stlkn b~stpoz b~idnrk b~postp
             b~posnr b~meins b~menge c~maktx
             FROM tpst AS a
              INNER JOIN stpo AS b ON a~stlnr = b~stlnr
              INNER JOIN makt AS c ON c~matnr = b~idnrk
                                  AND c~spras = sy-langu
          APPENDING TABLE rt_table_out
        WHERE a~tplnr  IN rt_table_in_aux
          AND b~stlty = 'T'.
*********************************************************************************************************
***  Fim - Nádia Rodrigues
*********************************************************************************************************
* Atualiza Início e Fim para montagem do range
      lv_ini = lv_fim + 1.
      IF lv_index = lv_div.
        lv_fim = lv_fim + lv_mod.
      ELSE.
        lv_fim = lv_fim * 2.
      ENDIF.
    ENDDO.

  ENDMETHOD.
ENDCLASS.
