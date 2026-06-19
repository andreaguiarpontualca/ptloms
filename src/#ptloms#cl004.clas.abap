class /PTLOMS/CL004 definition
  public
  final
  create public .

public section.

  methods CONSTRUCTOR
    importing
      !I_SUBOBJECT type BALSUBOBJ
      !I_EXTNUMBER type BALNREXT
      !I_USER type SY-UNAME optional .
  methods ADD
    importing
      !I_TYPE type SYMSGTY
      !I_TEXT type BAPI_MSG .
protected section.
private section.

  data GV_USER type SY-UNAME .
  data GV_BALLOGHNDL type BALLOGHNDL .
  data WA_BAL_S_LOG type BAL_S_LOG .

  methods CRIAR
    importing
      !I_SUBOBJECT type BALSUBOBJ
      !I_EXTNUMBER type BALNREXT .
ENDCLASS.



CLASS /PTLOMS/CL004 IMPLEMENTATION.


  METHOD add.

    DATA: lt_handle TYPE bal_t_logh.

    CALL FUNCTION 'BAL_LOG_MSG_ADD_FREE_TEXT'
      EXPORTING
        i_log_handle     = gv_balloghndl
        i_msgty          = i_type
        i_text           = i_text
      EXCEPTIONS
        log_not_found    = 1
        msg_inconsistent = 2
        log_is_full      = 3
        OTHERS           = 4.

    APPEND gv_balloghndl TO lt_handle.

* Salvar log
    CALL FUNCTION 'BAL_DB_SAVE'
      EXPORTING
        i_t_log_handle   = lt_handle
*        i_save_all       = 'X'
      EXCEPTIONS
        log_not_found    = 1
        save_not_allowed = 2
        numbering_error  = 3
        OTHERS           = 4.

** Limpar memória
*    CALL FUNCTION 'BAL_LOG_REFRESH'
*      EXPORTING
*        i_log_handle  = gv_balloghndl
*      EXCEPTIONS
*        log_not_found = 1
*        OTHERS        = 2.

** Limpar Memória
*    CALL FUNCTION 'BAL_GLB_MEMORY_REFRESH'
*      EXPORTING
**       i_refresh_all            = 'X'
*        i_t_logs_to_be_refreshed = lt_handle.

  ENDMETHOD.


  METHOD constructor.

    IF i_user IS NOT INITIAL.
      gv_user = i_user.
    ELSE.
      gv_user = sy-uname.
    ENDIF.

    me->criar( EXPORTING i_extnumber = i_extnumber
                         i_subobject = i_subobject ).

  ENDMETHOD.


  METHOD criar.

** Limpar Memória
*    CALL FUNCTION 'BAL_GLB_MEMORY_REFRESH'
*      EXPORTING
*        i_refresh_all = 'X'.

* Carrega parâmetros para criação de Log
    wa_bal_s_log-aluser    = gv_user."sy-uname.
    wa_bal_s_log-alprog    = sy-repid.
    wa_bal_s_log-object    = '/PTLOMS/OMS'.
    wa_bal_s_log-subobject = i_subobject.
    wa_bal_s_log-extnumber = i_extnumber.

* Criar Log
    CALL FUNCTION 'BAL_LOG_CREATE'
      EXPORTING
        i_s_log      = wa_bal_s_log
      IMPORTING
        e_log_handle = gv_balloghndl
      EXCEPTIONS
        OTHERS       = 1.

  ENDMETHOD.
ENDCLASS.
