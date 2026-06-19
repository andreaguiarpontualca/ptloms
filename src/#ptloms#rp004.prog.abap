*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*&          PONTUAL    CONSULTORES    ASSOCIADOS     LTDA.             *
*&---------------------------------------------------------------------*
*&---------------------------------------------------------------------*
*& Módulo          : PM                                                *
*& Tipo            : Report                                            *
*& Nome            : /PTLOMS/RP004                                     *
*& Transação       :                                                   *
*& Objetivo        : Envio de E-mail para Notificadores da Nota        *
*&---------------------------------------------------------------------*
*&                     Controle de Alterações                          *
*&---------------------------------------------------------------------*
*& Data      |Responsável|Request   |Descrição                         *
*&---------------------------------------------------------------------*
REPORT /ptloms/rp004 MESSAGE-ID /ptloms/cm001.

*&---------------------------------------------------------------------*
*& Tipos
*&---------------------------------------------------------------------*
TYPES: BEGIN OF ty_aufk,
         aufnr     TYPE viaufks-aufnr,
         objnr     TYPE viaufks-objnr,
         qmnum     TYPE viaufks-qmnum,
         qmnan     TYPE qmel-qmnam,
         smtp_addr TYPE ad_smtpadr,
       END OF ty_aufk.
*&---------------------------------------------------------------------*
*& Tabelas Interna
*&---------------------------------------------------------------------*
DATA: it_aufk TYPE STANDARD TABLE OF ty_aufk.

*&---------------------------------------------------------------------*
*& Variável
*&---------------------------------------------------------------------*
DATA: gv_data TYPE sy-datum.

*&---------------------------------------------------------------------*
*& Processamento Principal
*&---------------------------------------------------------------------*
START-OF-SELECTION.

  PERFORM f_verifica_permissao.
  PERFORM f_busca_dados.
  PERFORM f_monta_dados.
  PERFORM f_envia_email.
  PERFORM f_mantem_tabela_controle.
  MESSAGE s000 WITH 'Transação executada com sucesso.'.

END-OF-SELECTION.
*&---------------------------------------------------------------------*
*&      Form  F_BUSCA_DADOS
*&---------------------------------------------------------------------*
FORM f_busca_dados .

  gv_data = sy-datum.

  DATA: lt_tb037 TYPE TABLE OF /ptloms/tb037.
* Busca E-mails já enviados
  SELECT *
    FROM /ptloms/tb037
    INTO CORRESPONDING FIELDS OF TABLE lt_tb037
    WHERE data = gv_data.

* Busca ordens encerradas tecnicamente e que tenha nota associada (nota deve possuir notificador)
  SELECT a~aufnr a~objnr a~qmnum c~qmnam
    FROM viaufks AS a INNER JOIN jest AS b ON a~objnr = b~objnr
    INNER JOIN qmel AS c ON a~qmnum = c~qmnum
    INTO TABLE it_aufk
    WHERE a~idat2 = gv_data
      AND a~qmnum <> space  "Nota associada
      AND b~stat = 'I0045'   "Encerrado Tecnicamente
      AND b~inact = space
      AND c~qmnam <> space. "Possui Notificador

* Elimina e-mails já enviados
*** LOOP AT it_aufk INTO DATA(ls_aufk).
  DATA: ls_aufk LIKE LINE OF it_aufk.
  LOOP AT it_aufk INTO ls_aufk.

*   DATA(lv_tabix) = sy-tabix.
    DATA: lv_tabix TYPE sy-tabix.
    READ TABLE lt_tb037 TRANSPORTING NO FIELDS WITH KEY aufnr = ls_aufk-aufnr
                                                        data  = gv_data
                                                        qmnam = ls_aufk-qmnan.
    IF sy-subrc EQ 0.
      DELETE it_aufk INDEX lv_tabix.
    ENDIF.
  ENDLOOP.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_ENVIA_EMAIL
*&---------------------------------------------------------------------*
FORM f_envia_email .

* Definições para enviar o email
  DATA: lt_text    TYPE bcsy_text, "Conterá o conteúdo do email
        ls_text    TYPE soli, "Work Area de lt_text
        lv_sent    TYPE os_boolean, "Receberá a confirmação de envio
        lv_data    TYPE sy-datum,
        lv_subject TYPE so_obj_des,
        lv_aufnr   TYPE aufnr,
        lv_qmnum   TYPE qmnum.

  DATA: go_request    TYPE REF TO cl_bcs,
        go_document   TYPE REF TO cl_document_bcs,
        go_sender     TYPE REF TO cl_sapuser_bcs,
        go_sender_ext TYPE REF TO cl_cam_address_bcs,
        go_recipient  TYPE REF TO if_recipient_bcs,
        go_exception  TYPE REF TO cx_bcs.

* Montagem do E-mail
*** LOOP AT it_aufk INTO DATA(ls_aufks).
  DATA: ls_aufks LIKE LINE OF it_aufk.
  LOOP AT it_aufk INTO ls_aufks.

    REFRESH: lt_text[].

    CLEAR: lv_aufnr, lv_qmnum.

*    lv_aufnr = |{ ls_aufks-aufnr ALPHA = OUT }|.
    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUPUT'
      EXPORTING
        input  = ls_aufks-aufnr
      IMPORTING
        output = lv_aufnr.

*    lv_qmnum = |{ ls_aufks-qmnum ALPHA = OUT }|.
    CALL FUNCTION 'CONVERSION_EXIT_ALPHA_OUTPUT'
      EXPORTING
        input  = ls_aufks-qmnum
      IMPORTING
        output = lv_qmnum.


* Preenchendo o conteúdo do email
    CLEAR ls_text.
*    ls_text-line = |A Ordem | && lv_aufnr && | foi Encerrada Tecnicamente|.
    CONCATENATE 'A Ordem' lv_aufnr 'foi Encerrada Tecnicamente' INTO ls_text-line SEPARATED BY space.
    APPEND: ls_text TO lt_text.

    CLEAR ls_text.
*    ls_text-line = |Nota Associada: | && lv_qmnum.
    CONCATENATE 'Nota Associada:' lv_qmnum INTO ls_text-line SEPARATED BY space.
    APPEND: ls_text TO lt_text.

*É necessário o tratamento de erros com try...catch
    TRY.

*Método utilizado para criar um pedido de envio persistente
        go_request = cl_bcs=>create_persistent( ).

* Sub-Título
*        lv_subject = |Ordem | && lv_aufnr && | Encerrada Tecnicamente|.
        CONCATENATE 'Ordem' lv_aufnr 'Encerrada Tecnicamente' INTO lv_subject SEPARATED BY space.

*Monta e adiciona a estrutura do e-mail
        DATA: co_document TYPE REF TO cl_document_bcs.

        co_document = cl_document_bcs=>create_document(
          i_type = 'RAW'"'HTM'
          i_text = lt_text
          i_language = sy-langu"P - Português
          i_subject = lv_subject ). " Assunto do E-mail
        go_request->set_document( co_document ).

*Remetente do e-mail
        DATA: ls_email TYPE /ptloms/tb040.

        SELECT SINGLE *
          FROM  /ptloms/tb040
          INTO ls_email.

        IF sy-subrc IS NOT INITIAL.
*obs: por default, o envio é feito pelo usuário logado.
          go_sender = cl_sapuser_bcs=>create( sy-uname ).
          CALL METHOD go_request->set_sender
            EXPORTING
              i_sender = go_sender.
        ELSE.
          DATA lv_email TYPE adr6-smtp_addr.
          DATA lv_nome TYPE adr6-smtp_addr.

          lv_email = ls_email-email.
          lv_nome = ls_email-nome.

          go_sender_ext = cl_cam_address_bcs=>create_internet_address(
          i_address_string = lv_email
          i_address_name = lv_nome ).

          CALL METHOD go_request->set_sender
            EXPORTING
              i_sender = go_sender_ext.
        ENDIF.

*Adicionando o destinatário ao e-mail
        go_recipient =
        cl_cam_address_bcs=>create_internet_address( ls_aufks-smtp_addr ).
        CALL METHOD go_request->add_recipient
          EXPORTING
            i_recipient = go_recipient
            i_express   = 'X'.

*Marca o envio como imediato ('X') ou não (space)
        CALL METHOD go_request->set_send_immediately( 'X').

*Envia email, e retorna true ('X') ou false ('') na lv_sent
        CALL METHOD go_request->send(
          EXPORTING
            i_with_error_screen = 'X'
          RECEIVING
            result              = lv_sent ).
        COMMIT WORK.

      CATCH cx_bcs INTO go_exception.
*Tratamento do erro try... catch
    ENDTRY.

* Limpa objetos
    FREE: go_request,
          go_document,
          go_sender,
          go_recipient,
          go_exception.

  ENDLOOP.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_MONTA_EMAIL
*&---------------------------------------------------------------------*
*       text
*----------------------------------------------------------------------*
*  -->  p1        text
*  <--  p2        text
*----------------------------------------------------------------------*
FORM f_monta_email USING p_notificador TYPE qmnam
                CHANGING p_email       TYPE ad_smtpadr.

* Declaração de tabela interna
  DATA lt_p0105 LIKE p0105 OCCURS 0 WITH HEADER LINE.

* Declaração de variáveis
  DATA: lv_pernr TYPE prelp-pernr,
        lv_bname TYPE xubname.

* Verifica se notificador foi preenchido
  IF p_notificador IS INITIAL.
    RETURN.
  ENDIF.

* Verifica se notificador possui email no HR
  MOVE p_notificador TO lv_pernr.

  CALL FUNCTION 'HR_READ_INFOTYPE'
    EXPORTING
      pernr           = lv_pernr
      infty           = '0105'
    TABLES
      infty_tab       = lt_p0105
    EXCEPTIONS
      infty_not_found = 1
      OTHERS          = 2.

  DATA: ls_p0105 LIKE LINE OF lt_p0105.
  IF sy-subrc EQ 0 AND lt_p0105[] IS NOT INITIAL.
    READ TABLE lt_p0105 INTO ls_p0105 INDEX 1.
    p_email = ls_p0105-usrid_long.
  ENDIF.

* Verifica se email foi encontrado no HR
  IF p_email IS INITIAL.
* Se email não foi encontrado no HR, então tenta buscar no cadastro do usuário SAP
    MOVE p_notificador TO lv_bname.
    SELECT SINGLE b~smtp_addr
      FROM usr21 AS a INNER JOIN adr6 AS b ON a~persnumber = b~persnumber
                                          AND a~addrnumber = b~addrnumber
      INTO p_email
      WHERE a~bname = lv_bname.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_MONTA_DADOS
*&---------------------------------------------------------------------*
FORM f_monta_dados .

  FIELD-SYMBOLS: <fs_aufk> LIKE LINE OF it_aufk.
  LOOP AT it_aufk ASSIGNING <fs_aufk>.
    PERFORM f_monta_email USING <fs_aufk>-qmnan CHANGING <fs_aufk>-smtp_addr.
  ENDLOOP.

  DELETE it_aufk WHERE smtp_addr IS INITIAL.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_ATUALIZA_TABELA_CONTROLE
*&---------------------------------------------------------------------*
FORM f_atualiza_tabela_controle .

* Declaração de tabela interna.
  DATA: lt_tb037 TYPE STANDARD TABLE OF /ptloms/tb037.

* Declaração de estrutura
  DATA: ls_tb037 TYPE /ptloms/tb037.

* Atualiza tabela de controle
  DATA: ls_aufk LIKE LINE OF it_aufk.
  LOOP AT it_aufk INTO ls_aufk.
    CLEAR ls_tb037.
    ls_tb037-aufnr = ls_aufk-aufnr.
    ls_tb037-data = gv_data.
    ls_tb037-qmnam = ls_aufk-qmnan.
    APPEND ls_tb037 TO lt_tb037.
  ENDLOOP.

  IF lt_tb037[] IS NOT INITIAL.
    MODIFY /ptloms/tb037 FROM TABLE lt_tb037.
    IF sy-subrc EQ 0.
      COMMIT WORK.
    ELSE.
      ROLLBACK WORK.
    ENDIF.
  ENDIF.
ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_MANTEM_TABELA_CONTROLE
*&---------------------------------------------------------------------*
FORM f_mantem_tabela_controle .

  PERFORM f_atualiza_tabela_controle.
  PERFORM f_elimina_registros_obsoletos.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_ELIMINA_REGISTROS_OBSOLETOS
*&---------------------------------------------------------------------*
FORM f_elimina_registros_obsoletos .

  DELETE FROM /ptloms/tb037 WHERE data < gv_data.
  IF sy-subrc EQ 0.
    COMMIT WORK.
  ELSE.
    ROLLBACK WORK.
  ENDIF.

ENDFORM.
*&---------------------------------------------------------------------*
*&      Form  F_VERIFICA_PERMISSAO
*&---------------------------------------------------------------------*
FORM f_verifica_permissao .

  AUTHORITY-CHECK OBJECT '/PTLOMS/01'
           ID 'TCD' FIELD sy-tcode
           ID 'ACTVT' FIELD '02'.

  IF sy-subrc <> 0.
    MESSAGE e001(/ptloms/cm001) WITH '/PTLOMS/01'.
  ENDIF.

ENDFORM.
