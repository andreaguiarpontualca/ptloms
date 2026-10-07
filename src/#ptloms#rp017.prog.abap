*&---------------------------------------------------------------------*
*&          PONTUAL    CONSULTORES    ASSOCIADOS     LTDA.             *
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Módulo          : PM                                                *
*& Tipo            :                                                   *
*& Nome            :                                                   *
*& Transação       : /PTLOMS/TB087                                     *
*& Autor           : Iury Silva/Ramon Gomes                            *
*& Responsável     : Andre Aguiar                                      *
*& Objetivo        : OMS-Atualização massiva tabela /PTLOMS/TB087      *
*&---------------------------------------------------------------------*
*&                     Controle de Alterações                          *
*&---------------------------------------------------------------------*
*& Data      |Responsável|Request   |Descrição                         *
*&           |           |          |                                  *
*&---------------------------------------------------------------------*
REPORT  /ptloms/rp017 MESSAGE-ID /ptloms/cm001 NO STANDARD PAGE HEADING.

TABLES: /ptloms/tb087.  "OMS - Tabela de Restrições Operacionais

*---------------------------------------------------------------------*
* Tabelas internas                                                    *
*---------------------------------------------------------------------*
DATA: BEGIN OF bdc_tab OCCURS 0.
        INCLUDE STRUCTURE bdcdata.
      DATA: END OF bdc_tab.

DATA: BEGIN OF t_arq OCCURS 0,
        texto(300) TYPE c,
      END OF t_arq.

DATA: it_xls    LIKE alsmex_tabline OCCURS 0 WITH HEADER LINE,
      it_tb087  LIKE /ptloms/tb087  OCCURS 0 WITH HEADER LINE,
      t_status  TYPE jstat OCCURS 0 WITH HEADER LINE,
      wa_status TYPE jstat.

DATA: vl_answer  TYPE char1,
      vl_lines   TYPE numc7,
      vl_message TYPE char_65,
      vl_subrc   LIKE sy-subrc.

TYPES: BEGIN OF ty_local,
         restr_id  TYPE /ptloms/ed076,
         descricao TYPE /ptloms/ed072,
         ernam     TYPE ernam,
         erdat     TYPE erdat,
         erzeit    TYPE erzeit,
         aenam     TYPE aenam,
         aedat     TYPE aedat,
         aezeit    TYPE aezeit,
       END OF ty_local.

DATA: gt_local TYPE STANDARD TABLE OF ty_local,
      gs_local TYPE ty_local.

DATA: BEGIN OF t_log OCCURS 0,
        restr_id  TYPE /ptloms/ed076,
        descricao TYPE /ptloms/ed072,
        msn(200),                                                "Mensagem
      END OF t_log.

DATA f_carrega_dados_server.

************************************************************************
* Parâmetros de seleção
************************************************************************
SELECTION-SCREEN BEGIN OF BLOCK blc1 WITH FRAME TITLE text-001.
PARAMETER: p_path  TYPE rlgrap-filename
                   OBLIGATORY,
           p_path1 TYPE rlgrap-filename
                   OBLIGATORY,
           p_modo  TYPE c DEFAULT 'N'
                   NO-DISPLAY.
SELECTION-SCREEN END OF BLOCK blc1.
************************************************************************
* Eventos
************************************************************************
INITIALIZATION.
  FREE it_tb087.
  CLEAR vl_lines.
  SELECT * FROM /ptloms/tb087 APPENDING TABLE it_tb087.
  DESCRIBE TABLE it_tb087 LINES vl_lines.
  FREE it_tb087.

AT SELECTION-SCREEN.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_path.

  CALL FUNCTION 'WS_FILENAME_GET'
    EXPORTING
      def_filename     = ' '
      def_path         = p_path  " Caminho
      mask             = ',*.*.'  " Tipo de arquivo
      mode             = 'O'  " Modo (open)
      title            = text-001
    IMPORTING
      filename         = p_path  " Caminho
    EXCEPTIONS
      inv_winsys       = 01
      no_batch         = 02
      selection_cancel = 03
      selection_error  = 04.

AT SELECTION-SCREEN ON VALUE-REQUEST FOR p_path1.

  CALL FUNCTION 'WS_FILENAME_GET'
    EXPORTING
      def_filename     = ' '
      def_path         = p_path1  " Caminho log
      mask             = ',*.*.'  " Tipo de arquivo
      mode             = 'O'  " Modo (open)
      title            = text-002
    IMPORTING
      filename         = p_path1  " Caminho
    EXCEPTIONS
      inv_winsys       = 01
      no_batch         = 02
      selection_cancel = 03
      selection_error  = 04.

************************************************************************
* Logica de processamento
************************************************************************
START-OF-SELECTION.

  PERFORM: f_carrega_dados,
           f_estrutura_dados,
           f_record_files.

  PERFORM f_descarrega_log.
  FREE MEMORY.

END-OF-SELECTION.

*&---------------------------------------------------------------------*
*&      Form  f_carrega_dados
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM f_carrega_dados .

  CALL FUNCTION 'ALSM_EXCEL_TO_INTERNAL_TABLE'
    EXPORTING
      filename                = p_path
      i_begin_col             = 1
      i_begin_row             = 1
      i_end_col               = 08
      i_end_row               = 50000
    TABLES
      intern                  = it_xls
    EXCEPTIONS
      inconsistent_parameters = 1
      upload_ole              = 2
      OTHERS                  = 3.

* Consiste sucesso da carga do arquivo
  IF sy-subrc NE 0 OR it_xls[] IS INITIAL.
    MESSAGE e002(zg) DISPLAY LIKE 'E'
    WITH 'Erro ao carregar dados ou arquivo vazio.'.
    STOP.
  ENDIF.

ENDFORM.                    " f_carrega_dados

*&---------------------------------------------------------------------*
*&      Form  f_estrutura_dados
*&---------------------------------------------------------------------*
*       text
**---------------------------------------------------------------------*
FORM f_estrutura_dados .

  DATA: lv_row TYPE i.

  REFRESH gt_local.
  CLEAR gs_local.

  SORT it_xls BY row col.

  LOOP AT it_xls.

    "Ignora cabeçalho, se a primeira linha for título
    IF it_xls-row = 1.
      CONTINUE.
    ENDIF.

    "Quando mudar de linha, grava o registro anterior
    IF lv_row IS NOT INITIAL AND lv_row <> it_xls-row.

      IF gs_local-restr_id IS NOT INITIAL.
        gs_local-ernam  = sy-uname.
        gs_local-erdat  = sy-datum.
        gs_local-erzeit = sy-uzeit.
        gs_local-aenam  = sy-uname.
        gs_local-aedat  = sy-datum.
        gs_local-aezeit = sy-uzeit.

        APPEND gs_local TO gt_local.
      ENDIF.

      CLEAR gs_local.

    ENDIF.

    lv_row = it_xls-row.

    CASE it_xls-col.

      WHEN '0001'.     "A-OMS - ID Restrição
        MOVE it_xls-value TO gs_local-restr_id.

      WHEN '0002'.     "B-OMS - Descrição
        MOVE it_xls-value TO gs_local-descricao.

    ENDCASE.

  ENDLOOP.

  "Grava a última linha processada
  IF gs_local-restr_id IS NOT INITIAL.
    gs_local-ernam  = sy-uname.
    gs_local-erdat  = sy-datum.
    gs_local-erzeit = sy-uzeit.
    gs_local-aenam  = sy-uname.
    gs_local-aedat  = sy-datum.
    gs_local-aezeit = sy-uzeit.

    APPEND gs_local TO gt_local.
  ENDIF.

ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  f_descarrega_log
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
FORM f_descarrega_log .

  CALL FUNCTION 'WS_DOWNLOAD'
    EXPORTING
      filename            = p_path1
      filetype            = 'ASC'
    TABLES
      data_tab            = t_log
    EXCEPTIONS
      conversion_error    = 1
      file_open_error     = 2
      file_read_error     = 3
      invalid_table_width = 4
      invalid_type        = 5
      no_batch            = 6
      unknown_error       = 7
      OTHERS              = 8.

  CLEAR   t_log.
  REFRESH t_log.
ENDFORM.                    " f_descarrega_log

*&---------------------------------------------------------------------*
*&      Form  F_RECORD_FILES
*&---------------------------------------------------------------------*
*  Gravar arquivos
*----------------------------------------------------------------------*
FORM f_record_files.

  LOOP AT gt_local INTO gs_local.
    CLEAR: /ptloms/tb087.

    MOVE-CORRESPONDING gs_local TO /ptloms/tb087.

    MODIFY: /ptloms/tb087.

  ENDLOOP.

  CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
    EXPORTING
      wait = 'X'.

ENDFORM.
