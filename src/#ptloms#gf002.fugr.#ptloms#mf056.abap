FUNCTION /ptloms/mf056.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     VALUE(AUFNR) TYPE  AUFNR OPTIONAL
*"     VALUE(VORNR) TYPE  VORNR OPTIONAL
*"     VALUE(SUBOPER) TYPE  UVORN OPTIONAL
*"     VALUE(USUARIO) TYPE  XUBNAME OPTIONAL
*"----------------------------------------------------------------------
  DATA : v_jobhead LIKE tbtcjob.
  DATA : v_jobcount LIKE tbtcjob-jobcount.
  DATA : v_eventparm LIKE tbtcjob-eventparm.
  DATA : v_flg_released TYPE c.
  DATA : e_error.
  DATA : running LIKE tbtcv-run.

  TYPES: esp1_boolean LIKE boole-boole.

  CONSTANTS: esp1_false TYPE esp1_boolean VALUE ' ',
             esp1_true  TYPE esp1_boolean VALUE 'X'.

  CONSTANTS: true  TYPE boolean VALUE esp1_true,
             false TYPE boolean VALUE esp1_false.

  DATA: v_jobnam LIKE tbtcjob-jobname VALUE '/PTLOMS/MP005',
        v_report LIKE sy-repid VALUE '/PTLOMS/MP005',
        v_varian LIKE  raldb-variant,
        v_uname  LIKE sy-uname.

  DATA: lt_041 TYPE TABLE OF /ptloms/tb041.
  DATA: ls_041 LIKE LINE OF lt_041.
  DATA: lv_horainicio TYPE sy-uzeit.

  v_uname = sy-uname.

  ls_041-aufnr = aufnr.
  ls_041-vornr = vornr.
  ls_041-suboper = suboper.
  ls_041-usuario = usuario.

  MODIFY /ptloms/tb041 FROM ls_041.

  COMMIT WORK AND WAIT.

* add the new job
  CALL FUNCTION 'JOB_OPEN'
    EXPORTING
*     delanfrep        = 'X'
      jobname          = v_jobnam
    IMPORTING
      jobcount         = v_jobcount
    EXCEPTIONS
      cant_create_job  = 1
      invalid_job_data = 2
      jobname_missing  = 3
      OTHERS           = 4.
  IF sy-subrc <> 0.
    e_error = true.
  ELSE.
    CALL FUNCTION 'JOB_SUBMIT'
      EXPORTING
        authcknam               = v_uname
        jobcount                = v_jobcount
        jobname                 = v_jobnam
        report                  = v_report
        variant                 = v_varian
      EXCEPTIONS
        bad_priparams           = 1
        bad_xpgflags            = 2
        invalid_jobdata         = 3
        jobname_missing         = 4
        job_notex               = 5
        job_submit_failed       = 6
        lock_failed             = 7
        program_missing         = 8
        prog_abap_and_extpg_set = 9
        OTHERS                  = 10.
    IF sy-subrc <> 0.
      e_error = true.
    ELSE.

      lv_horainicio = sy-uzeit + 10.

      CALL FUNCTION 'JOB_CLOSE'
        EXPORTING
*         EVENT_ID             = IC_WWI_WORKPROCESS_EVENT
*         EVENT_PARAM          = V_EVENTPARM
*         EVENT_PERIODIC       = 'X'
          jobcount             = v_jobcount
          sdlstrtdt            = sy-datum
          sdlstrttm            = lv_horainicio
          jobname              = v_jobnam
          strtimmed            = ''
        IMPORTING
          job_was_released     = v_flg_released
        EXCEPTIONS
          cant_start_immediate = 1
          invalid_startdate    = 2
          jobname_missing      = 3
          job_close_failed     = 4
          job_nosteps          = 5
          job_notex            = 6
          lock_failed          = 7
          OTHERS               = 8.
      IF sy-subrc <> 0.
        e_error = true.
      ELSE.
        DO.
          CALL FUNCTION 'SHOW_JOBSTATE'
            EXPORTING
              jobcount         = v_jobcount
              jobname          = v_jobnam
*            IMPORTING
*             ABORTED          =
*             FINISHED         =
*             PRELIMINARY      =
*             READY            =
*             running          =
*             SCHEDULED        =
            EXCEPTIONS
              jobcount_missing = 1
              jobname_missing  = 2
              job_notex        = 3
              OTHERS           = 4.

          IF sy-subrc <> 0.
            e_error = true.
            MESSAGE ID sy-msgid TYPE sy-msgty NUMBER sy-msgno
                    WITH sy-msgv1 sy-msgv2 sy-msgv3 sy-msgv4.
          ENDIF.
          IF running = space.
            EXIT.
          ENDIF.
        ENDDO.
      ENDIF.
    ENDIF.
  ENDIF.

ENDFUNCTION.
