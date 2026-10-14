CLASS zcl_jr_task_generate_range DEFINITION PUBLIC FINAL CREATE PUBLIC .

  PUBLIC SECTION.
  METHODS:
      create_range   IMPORTING iv_object TYPE cl_numberrange_intervals=>nr_object,
      get_range      IMPORTING iv_object       TYPE cl_numberrange_intervals=>nr_object
                     RETURNING VALUE(ev_range) TYPE cl_numberrange_runtime=>nr_number,
      validate_range IMPORTING iv_object        TYPE cl_numberrange_intervals=>nr_object
                     RETURNING VALUE(rv_status) TYPE abap_boolean ,
      delete_range   IMPORTING iv_object TYPE cl_numberrange_intervals=>nr_object.

    INTERFACES if_oo_adt_classrun .

  PROTECTED SECTION.

  PRIVATE SECTION.

ENDCLASS.


CLASS zcl_jr_task_generate_range IMPLEMENTATION.

  METHOD if_oo_adt_classrun~main.
   me->create_range( iv_object =  'ZJR_TASK_N' ).
  ENDMETHOD.

  METHOD create_range.
    TRY.
        cl_numberrange_intervals=>create(
          EXPORTING
            interval  =  VALUE #( ( nrrangenr = '01'
                                    fromnumber = '0000000001'
                                    tonumber   = '0999999999' ) )
            object    = iv_object
          IMPORTING
             error     = DATA(lv_error)
             error_inf = DATA(lt_error_inf)
             error_iv  = DATA(lv_error_iv)
             warning   = DATA(lv_warning)
        ).
      CATCH cx_nr_object_not_found INTO DATA(lv_err_object).
      CATCH cx_number_ranges INTO DATA(lv_err_range).
    ENDTRY.

  ENDMETHOD.

  METHOD delete_range.
    TRY.
        cl_numberrange_intervals=>delete(
          EXPORTING
                interval  =  VALUE #( ( nrrangenr = '01'
                                        fromnumber = '0000000001'
                                        tonumber   = '0999999999' ) )
                object    = iv_object
          IMPORTING
                 error     = DATA(lv_error)
                 error_inf = DATA(lt_error_inf)
                 error_iv  = DATA(lv_error_iv)
                 warning   = DATA(lv_warning)
        ).
      CATCH cx_nr_object_not_found INTO DATA(lv_err_object).
      CATCH cx_number_ranges INTO DATA(lv_err_range).
    ENDTRY.

  ENDMETHOD.

  METHOD get_range.
    TRY.
        cl_numberrange_runtime=>number_get(
          EXPORTING
            nr_range_nr       = '01'
            object            = iv_object
          IMPORTING
            number            = ev_range
            returncode        = DATA(ld_retcode)
        ).

      CATCH cx_nr_object_not_found INTO DATA(lv_err_object).
      CATCH cx_number_ranges INTO DATA(lv_err_range).
    ENDTRY.
  ENDMETHOD.

  METHOD validate_range.
    TRY.
        cl_numberrange_intervals=>read(
          EXPORTING
            object    = iv_object
            subobject = ''
          IMPORTING
            interval  = DATA(lt_intervals)
        ).

        IF line_exists( lt_intervals[ nrrangenr = '01' ] ).
          DATA(ls_range) = lt_intervals[ nrrangenr = '01' ].
          rv_status = 'X'.
        ELSE.
          rv_status = ''.
        ENDIF.

      CATCH cx_number_ranges INTO DATA(lx_nr).
        " Ocurre si el Number Range Object en sí no existe en la base de datos
        " lx_nr->get_text( )
    ENDTRY.
  ENDMETHOD.

ENDCLASS.
