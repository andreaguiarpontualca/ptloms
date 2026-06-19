class /PTLOMS/CL002 definition
  public
  final
  create public .

public section.

  methods CONSTRUCTOR .
  methods GET_TB001
    returning
      value(RT_TB001) type /PTLOMS/CT100 .
  methods SET_TB001 .
  methods SET_INIT
    importing
      value(IM_INIT) type CHAR1 .
  methods GET_INIT
    returning
      value(RE_INIT) type CHAR1 .
protected section.
private section.

  data GT_TB001 type /PTLOMS/CT100 .
  data GV_INIT type CHAR1 .
ENDCLASS.



CLASS /PTLOMS/CL002 IMPLEMENTATION.


  METHOD constructor.

    me->set_tb001( ).

  ENDMETHOD.


  METHOD get_init.

    re_init = gv_init.

  ENDMETHOD.


  METHOD get_tb001.

    rt_tb001[] = gt_tb001[].

  ENDMETHOD.


  METHOD SET_INIT.

  gv_init = im_init.

  ENDMETHOD.


  METHOD set_tb001.

* O range estará sempre vazio para buscar todos os registros da tabela
    DATA: r_nivel_pai TYPE RANGE OF /ptloms/tb001-nivel_pai,
          lv_laiso    TYPE t002-laiso.

***    CALL FUNCTION 'CONVERSION_EXIT_ISOLA_OUTPUT'
***      EXPORTING
***        input  = sy-langu
***      IMPORTING
***        output = lv_laiso.

    SELECT *
      FROM /ptloms/tb001
      INTO TABLE gt_tb001
      WHERE spras     EQ sy-langu
        AND nivel_pai IN r_nivel_pai.

  ENDMETHOD.
ENDCLASS.
