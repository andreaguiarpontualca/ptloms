FUNCTION /ptloms/mf108.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  EXPORTING
*"     VALUE(E_RFC) TYPE  BDBAPIDST
*"  EXCEPTIONS
*"      SEM_AUT_RFC
*"      RFC_NAO_EXISTENTE
*"      RFC_NAO_CADASTRADA
*"      RFC_INCOMPATIVEL
*"----------------------------------------------------------------------

  DATA: lv_rfcdest     TYPE bdbapidst,
        lv_msgv1(50)   TYPE c,
        lv_msgv2(50)   TYPE c,
        lv_subrc       TYPE sy-subrc,
        lv_mensagem    TYPE bapi_msg,
        lv_same_user   TYPE rfcdisplay-rfcsameusr,
        lv_usuario_sap TYPE flag.


* Busca Conexão
  SELECT SINGLE rfcdest FROM /ptloms/tb036 INTO lv_rfcdest.
  IF sy-subrc EQ 0.
*Verifica se conexão está ativa
    CALL FUNCTION 'CAT_CHECK_RFC_DESTINATION'
      EXPORTING
        rfcdestination = lv_rfcdest
      IMPORTING
        msgv1          = lv_msgv1
        msgv2          = lv_msgv2
        rfc_subrc      = lv_subrc.
    IF lv_subrc NE 0.
      IF lv_subrc = 3.
*          lv_mensagem = 'Usuário Sem Autorização par RFC'(001) && lv_rfcdest.
        CONCATENATE 'Usuário Sem Autorização par RFC'(001) lv_rfcdest INTO lv_mensagem SEPARATED BY space.
        MESSAGE lv_mensagem TYPE 'E' RAISING sem_aut_rfc.
      ELSE.
*          lv_mensagem = 'RFC' && lv_rfcdest && 'não existe ou indisponível'(002).
        CONCATENATE 'RFC' lv_rfcdest 'não existe ou indisponível'(002) INTO lv_mensagem SEPARATED BY space.
        MESSAGE lv_mensagem TYPE 'E' RAISING rfc_nao_existente.
      ENDIF.
    ENDIF.
  ELSE.
    lv_mensagem = 'Não foi cadastrada RFC para acesso ao ECC'(003).
    MESSAGE lv_mensagem TYPE 'E' RAISING rfc_nao_cadastrada.
  ENDIF.

* Valida Configuração RFC (Verifica se possui usuário fixo)
  CALL FUNCTION 'RFC_READ_R3_DESTINATION'
    EXPORTING
      destination             = lv_rfcdest
    IMPORTING
      same_user               = lv_same_user
    EXCEPTIONS
      authority_not_available = 1
      destination_not_exist   = 2
      information_failure     = 3
      internal_failure        = 4
      OTHERS                  = 5.

* Verifica se é Usuário SAP
  CALL FUNCTION '/PTLOMS/MF049'
    DESTINATION lv_rfcdest
    IMPORTING
      ex_usuario_sap = lv_usuario_sap.

  IF ( lv_usuario_sap IS NOT INITIAL AND lv_same_user IS INITIAL ) OR "Se usuário SAP, então SAME_USER deve estar marcado
     ( lv_usuario_sap IS INITIAL     AND lv_same_user IS NOT INITIAL ). "Se usuário não SAP, então SAME_USER deve estar vazio

    lv_mensagem = 'RFC incompatível com modo de usuário selecionado. Rever configuração SM59'(004).
    MESSAGE lv_mensagem TYPE 'E' RAISING rfc_incompativel.
  ENDIF.

  e_rfc = lv_rfcdest.


ENDFUNCTION.
