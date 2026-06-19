FUNCTION /ptloms/mf057.
*"----------------------------------------------------------------------
*"*"Interface local:
*"  IMPORTING
*"     REFERENCE(I_LINE) TYPE  SO_RAW255
*"     REFERENCE(I_FILETYPE) TYPE  CHAR3
*"  EXPORTING
*"     REFERENCE(E_EXTENSAO) TYPE  CHAR4
*"----------------------------------------------------------------------


  DATA: lv_xstring      TYPE xstring,

        lv_valid        TYPE xfeld,

        lv_temp_xstring TYPE string.

  lv_xstring = i_line.

  CASE i_filetype.
    WHEN 'XLS' OR 'xls'.
*Encontra tipo excel
      MOVE lv_xstring+0(4) TO lv_temp_xstring.

      IF lv_xstring+0(7) EQ '09081000000605' OR

      lv_temp_xstring+0(8) EQ 'FDFFFFFF' OR

      lv_temp_xstring+0(8) EQ 'D0CF11E0'.

        e_extensao = 'XLS'.

      ELSE.

        MOVE lv_xstring+0(9) TO lv_temp_xstring.

        IF lv_temp_xstring+0(17) EQ '504B0304140006000'.

          e_extensao = 'XLSX'.

        ENDIF.

      ENDIF.

    WHEN 'DOC' OR 'doc'.
*Encontra tipo word
      MOVE lv_xstring+0(4) TO lv_temp_xstring.

      IF lv_xstring+0(4) EQ 'ECA5C100' OR lv_xstring+0(4) EQ 'D0CF11E0'.

        e_extensao = 'DOC'.

      ELSE.

        MOVE lv_xstring+0(9) TO lv_temp_xstring.

        IF lv_temp_xstring+0(17) EQ '504B0304140006000'.

          e_extensao = 'DOCX'.

        ENDIF.

      ENDIF.
    WHEN 'PPT' OR 'ppt'.
*Encontra tipo power point
      MOVE lv_xstring+0(4) TO lv_temp_xstring.

      IF lv_xstring+0(4) EQ '006E1EF0' OR
      lv_xstring+0(4) EQ '0F00E803' OR
      lv_xstring+0(4) EQ 'A0461DF0' OR
      lv_xstring+0(4) EQ 'D0CF11E0'.

        e_extensao = 'PPT'.

      ELSE.

        MOVE lv_xstring+0(9) TO lv_temp_xstring.

        IF lv_temp_xstring+0(17) EQ '504B0304140006000'.

          e_extensao = 'PPTX'.

        ENDIF.

      ENDIF.

  ENDCASE.

ENDFUNCTION.
