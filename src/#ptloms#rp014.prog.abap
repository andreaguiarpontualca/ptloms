*&---------------------------------------------------------------------*
*&          PONTUAL    CONSULTORES    ASSOCIADOS     LTDA.             *
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Módulo          : PM                                                *
*& Tipo            :                                                   *
*& Nome            :                                                   *
*& Transação       : /PTLOMS/TB084                                     *
*& Autor           : Iury Silva/Ramon Gomes                            *
*& Responsável     : Andre Aguiar                                      *
*& Objetivo        : OMS-Atualização massiva tabela /PTLOMS/TB084      *
*&---------------------------------------------------------------------*
*&                     Controle de Alterações                          *
*&---------------------------------------------------------------------*
*& Data      |Responsável|Request   |Descrição                         *
*&           |           |          |                                  *
*&---------------------------------------------------------------------*

REPORT  /ptloms/rp014 MESSAGE-ID /ptloms/cm001 NO STANDARD PAGE HEADING.

TABLES: /ptloms/tb084.  "OMS - Tabela de Skills

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
      it_tb084  LIKE /ptloms/tb084  OCCURS 0 WITH HEADER LINE,
      t_status  TYPE jstat OCCURS 0 WITH HEADER LINE,
      wa_status TYPE jstat.

*data: begin of gt_local occurs 0.
*        include structure /ptloms/tb084.
*      data: end of gt_local.
*data: gs_local   like gt_local,

DATA: vl_answer  TYPE char1,
      vl_lines   TYPE numc7,
      vl_message TYPE char_65,
      vl_subrc   LIKE sy-subrc.

TYPES: BEGIN OF ty_local,
         skill_id  TYPE /ptloms/ed071,
         descricao TYPE /ptloms/ed072,
         ativo     TYPE /ptloms/ed073,
         ernam     TYPE ernam,
         erdat     TYPE erdat,
         erzeit    TYPE erzeit,
         aenam     TYPE aenam,
         aedat     TYPE aedat,
         aezeit    TYPE aezeit,
       END OF ty_local.

DATA: gt_local TYPE STANDARD TABLE OF ty_local,
      gs_local TYPE ty_local.

*DATA: BEGIN OF gt_local OCCURS 0,
***      Tabela excel possue 06 colunas
*        DESCRICAO_skill TYPE /ptloms/tb084-DESCRICAO_skill,    "A-SGMR - Modelo Equipamento
*        componente       TYPE /ptloms/tb084-componente,          "B-SGMR - Componente Medido do Material Rodante
*        posmed           TYPE /ptloms/tb084-posmed,              "C-SGMR - Posição de Medição
*        codi_fabr        TYPE /ptloms/tb084-codi_fabr,           "D-SGMR - Código do fabricante do componente
**       medida_mm        type /ptloms/tb084-medida_mm,           "D-SGMR - Medida Referência Desgaste
*        medida_mm        TYPE char7,                             "E-SGMR - Medida Referência Desgaste
**       perc_desgaste    type /ptloms/tb084-perc_desgaste,       "E-SGMR - Percentual de desgaste
*        perc_desgaste    TYPE char3,                             "F-SGMR - Percentual de desgaste
*        alerta           TYPE /ptloms/tb084-alerta,              "G-SGMR - Alerta
*      END OF gt_local.

*DATA: gs_local LIKE gt_local.

DATA: BEGIN OF t_log OCCURS 0,
        descricao TYPE /ptloms/tb084-descricao,    "B-OMS - Descrição Skill
        msn(200),                                  "Mensagem
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
*                   ,
*           p_line  TYPE sy-macol         "N.linhas da planilha excel
*                   OBLIGATORY.
SELECTION-SCREEN END OF BLOCK blc1.
************************************************************************
* Eventos
************************************************************************
INITIALIZATION.
  FREE it_tb084.
  CLEAR vl_lines.
  SELECT * FROM /ptloms/tb084 APPENDING TABLE it_tb084.
  DESCRIBE TABLE it_tb084 LINES vl_lines.
  FREE it_tb084.

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

*  perform: f_conf_elimi,
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
      i_end_col               = 07
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

**Despreza as inhas de cabeçalho
*  DELETE it_xls WHERE row LE p_line.

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

      IF gs_local-skill_id IS NOT INITIAL.
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

      WHEN '0001'. "A-OMS - Skill
        MOVE it_xls-value TO gs_local-skill_id.

      WHEN '0002'. "B-OMS - Descrição
        MOVE it_xls-value TO gs_local-descricao.

      WHEN '0003'. "C-OMS - Ativo
        MOVE it_xls-value TO gs_local-ativo.

    ENDCASE.

  ENDLOOP.

  "Grava a última linha processada
  IF gs_local-skill_id IS NOT INITIAL.
    gs_local-ernam  = sy-uname.
    gs_local-erdat  = sy-datum.
    gs_local-erzeit = sy-uzeit.
    gs_local-aenam  = sy-uname.
    gs_local-aedat  = sy-datum.
    gs_local-aezeit = sy-uzeit.

    APPEND gs_local TO gt_local.
  ENDIF.

ENDFORM.

****&---------------------------------------------------------------------*
****&      Form  f_estrutura_dados
****&---------------------------------------------------------------------*
****       text
****----------------------------------------------------------------------*
***FORM f_estrutura_dados .
***
***  FREE  gt_local.
***
***  "Recebendo a data e hora do arquivo de importação
****  LOOP AT it_xls.
****
****    CASE it_xls-col.
****
****      WHEN '0001'.     "A-OMS - Skill
****        MOVE it_xls-value TO gs_local-skill_id.
****        CONTINUE.
****
****      WHEN '0002'.     "B-OMS - Descrição
****        MOVE it_xls-value TO gs_local-descricao.
****        CONTINUE.
****
****      WHEN '0003'.     "C-OMS - Ativo
****        MOVE it_xls-value TO gs_local-ativo.
****        CONTINUE.
****
****      WHEN '0004'.     "D-OMS - Nome do responsável que criou o objeto
****        MOVE it_xls-value TO gs_local-ernam.
****        CONTINUE.
****
****      WHEN '0005'.     "E-OMS - Data de criação do registro
****        MOVE it_xls-value TO gs_local-erdat.
****        CONTINUE.
****
****      WHEN '0006'.     "F-OMS - Hora da criação do registro
****        MOVE it_xls-value TO gs_local-erzeit.
****        CONTINUE.
****
****      WHEN '0007'.     "G-OMS - Nome do responsável pela modificação do objeto
****        MOVE it_xls-value TO gs_local-aenam.
****        CONTINUE.
****
****      WHEN '0008'.     "H-OMS - Data da última modificação
****        MOVE it_xls-value TO gs_local-aedat.
****        CONTINUE.
****
****      WHEN '0009'.     "I-OMS - Hora de modificação
****        MOVE it_xls-value TO gs_local-aezeit.
****        APPEND gs_local TO gt_local.
****        CLEAR gs_local.
****
****    ENDCASE.
****
****  ENDLOOP.
***
***  LOOP AT it_xls.
***
***    CASE it_xls-col.
***
***      WHEN '0001'.     "A-OMS - Skill
***        MOVE it_xls-value TO gs_local-skill_id.
***        CONTINUE.
***
***      WHEN '0002'.     "B-OMS - Descrição
***        MOVE it_xls-value TO gs_local-descricao.
***        CONTINUE.
***
***      WHEN '0003'.     "C-OMS - Ativo
***        MOVE it_xls-value TO gs_local-ativo.
***
***        "Preenche automaticamente os campos de auditoria
***        gs_local-ernam  = sy-uname.
***        gs_local-erdat  = sy-datum.
***        gs_local-erzeit = sy-uzeit.
***
***        gs_local-aenam  = sy-uname.
***        gs_local-aedat  = sy-datum.
***        gs_local-aezeit = sy-uzeit.
***
***        APPEND gs_local TO gt_local.
***        CLEAR gs_local.
***
***    ENDCASE.
***
***  ENDLOOP.
***
***ENDFORM.                    " f_estrutura_dados

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
    CLEAR: /ptloms/tb084.

****D-SGMR - Medida Referência Desgaste
*    REPLACE ALL OCCURRENCES OF ',' IN gs_local-medida_mm WITH '.'.
*    CONDENSE gs_local-medida_mm NO-GAPS.
*
****E-SGMR - Percentual de desgaste
*    REPLACE ALL OCCURRENCES OF ',' IN gs_local-perc_desgaste WITH '.'.
*    CONDENSE gs_local-perc_desgaste NO-GAPS.

*    gs_local-

    MOVE-CORRESPONDING gs_local TO /ptloms/tb084.

    MODIFY: /ptloms/tb084.

  ENDLOOP.

  CALL FUNCTION 'BAPI_TRANSACTION_COMMIT'
    EXPORTING
      wait = 'X'.


ENDFORM.

*&---------------------------------------------------------------------*
*&      Form  F_CONF_ELIMI
*&---------------------------------------------------------------------*
* Confirma eliminação de registros da tabela /ptloms/tb084
*----------------------------------------------------------------------*
FORM f_conf_elimi .

  CHECK vl_lines GT 0.
  CLEAR vl_message.
  CONCATENATE: 'Confirma eliminação de' vl_lines
               'registros tabela /ptloms/tb084 ?' INTO vl_message SEPARATED BY space.
  CALL FUNCTION 'POPUP_TO_CONFIRM_STEP'
    EXPORTING
      defaultoption  = 'N'
      textline1      = vl_message
*     TEXTLINE2      = ' '
      titel          = 'Eliminação registros !!'
      start_column   = 25
      start_row      = 6
      cancel_display = 'X'
    IMPORTING
      answer         = vl_answer.

  CHECK vl_answer EQ 'J'.
  CALL FUNCTION 'DB_TRUNCATE_TABLE'
    EXPORTING
      tabname          = '/ptloms/tb084'
      prid             = 0
      save_views       = 'X'
      set_init_storage = space
    IMPORTING
      subrc            = vl_subrc.

ENDFORM.
