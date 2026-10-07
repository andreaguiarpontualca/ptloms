REPORT /ptlom/rp029.

PARAMETERS:
  p_user TYPE syuname DEFAULT sy-uname OBLIGATORY.

DATA:
  lo_service TYPE REF TO /ptloms/cl024,
  ls_result  TYPE /ptloms/cl024=>ty_check_result,
  lv_ssf_app TYPE ssfappl.

START-OF-SELECTION.

  lv_ssf_app = 'ZOMSLI'.

  CREATE OBJECT lo_service
    EXPORTING
      iv_ssf_application = lv_ssf_app.

  IF lo_service IS NOT BOUND.
    WRITE: / 'Não foi possível criar o serviço de licenciamento.'.
    RETURN.
  ENDIF.

  ls_result =
    lo_service->check_user(
      iv_user = p_user ).

  WRITE:
    / 'Licença válida.......:', ls_result-valid,
    / 'Código...............:', ls_result-reason_code,
    / 'Mensagem.............:', ls_result-message.

  ULINE.

  WRITE:
    / 'Usuário..............:', ls_result-user_name,
    / 'Centro...............:', ls_result-maintenance_plant,
    / 'Produto..............:', ls_result-product,
    / 'Versão...............:', ls_result-version,
    / 'Cliente..............:', ls_result-customer_id,
    / 'Ambiente.............:', ls_result-environment,
    / 'Validade.............:', ls_result-valid_to,
    / 'Dias restantes.......:', ls_result-days_remaining,
    / 'GUID da licença......:', ls_result-license_id.

  ULINE.

  WRITE:
    / 'SSF SUBRC............:', ls_result-ssf_subrc,
    / 'SSF CRC..............:', ls_result-ssf_crc,
    / 'Signatários..........:', ls_result-signer_count,
    / 'Certificados.........:', ls_result-certificate_count.
