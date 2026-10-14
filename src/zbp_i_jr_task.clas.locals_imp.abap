CLASS lhc_Task DEFINITION INHERITING FROM cl_abap_behavior_handler.
  PRIVATE SECTION.

    METHODS:  get_instance_authorizations FOR INSTANCE AUTHORIZATION keys REQUEST requested_authorizations FOR Task RESULT result,
      get_global_authorizations   FOR GLOBAL AUTHORIZATION REQUEST requested_authorizations FOR Task RESULT result,
      set_default_values          FOR DETERMINE ON SAVE keys FOR Task~set_default_values,
      validate_delivery_date      FOR VALIDATE ON SAVE keys FOR Task~validate_delivery_date,
      set_task_id                 FOR DETERMINE ON SAVE keys FOR Task~set_task_id,
      cancel_request              FOR MODIFY keys FOR ACTION Task~cancel_request,
      finish_request              FOR MODIFY keys FOR ACTION Task~finish_request RESULT result.

ENDCLASS.

CLASS lhc_Task IMPLEMENTATION.

  METHOD get_instance_authorizations.
  ENDMETHOD.

  METHOD get_global_authorizations.
    result-%create = if_abap_behv=>auth-allowed.
  ENDMETHOD.

  METHOD set_default_values.
    READ ENTITIES OF zi_jr_task
        IN LOCAL MODE
        ENTITY Task
        ALL FIELDS
        WITH CORRESPONDING #( keys )
        RESULT DATA(lt_task).
    IF sy-subrc = 0.
      MODIFY ENTITIES OF zi_jr_task
          IN LOCAL MODE
          ENTITY Task
          UPDATE FIELDS ( Status Priority  CreatedDate )
          WITH VALUE #( FOR ls_task IN lt_task ( %key           = ls_task-%key
                                                 Status         = '100'
                                                 Priority       = '3'
                                                 CreatedDate    = cl_abap_context_info=>get_system_date( )
              ) )
          REPORTED DATA(lt_result).
    ENDIF.

  ENDMETHOD.

  METHOD validate_delivery_date.
    READ ENTITIES OF zi_jr_task
        IN LOCAL MODE
        ENTITY Task
        ALL FIELDS
        WITH CORRESPONDING #( keys )
        RESULT DATA(lt_task).

    IF sy-subrc = 0.
      LOOP AT lt_task INTO DATA(ls_task).
        IF  ls_task-DeliveryDate IS NOT INITIAL
        AND ls_task-DeliveryDate LT cl_abap_context_info=>get_system_date( ).
          APPEND VALUE #( taskuuid = ls_task-TaskUUID ) TO failed-task.

          APPEND VALUE #( taskuuid = ls_task-TaskUUID
                          %msg     = new_message(
                                       id       = 'ZJR_MC_TASK'
                                       number   = '000'
                                       severity =  if_abap_behv_message=>severity-error
                                       v1       = ls_task-DeliveryDate
                                       v2       = cl_abap_context_info=>get_system_date( )
                                     )
                        ) TO reported-task.

        ENDIF.
      ENDLOOP.
    ENDIF.

  ENDMETHOD.

  METHOD set_task_id.
    CONSTANTS c_object TYPE cl_numberrange_objects=>nr_attribute-object VALUE 'ZTASK_NRO'.

    DATA(lo_range) = NEW zcl_jr_task_generate_range( ).

    lo_range->get_range( EXPORTING
                            iv_object = c_object
                          RECEIVING
                            ev_range  = DATA(lv_range)
                        ).

    IF lv_range IS NOT INITIAL.
      MODIFY ENTITIES OF zi_jr_task
          IN LOCAL MODE
          ENTITY Task
          UPDATE FIELDS ( TaskID  )
          WITH VALUE #( FOR row IN keys ( %tky    = row-%tky
                                          TaskID  = lv_range
          ) )
          REPORTED DATA(lt_result).
    ENDIF.
  ENDMETHOD.

  METHOD cancel_request.

    READ ENTITIES OF zi_jr_task
        IN LOCAL MODE
        ENTITY Task
        ALL FIELDS
        WITH CORRESPONDING #( keys )
        RESULT DATA(lt_task).

    IF sy-subrc = 0.
      MODIFY ENTITIES OF zi_jr_task
          IN LOCAL MODE
          ENTITY Task
          UPDATE FIELDS ( Status CancelReason )
          WITH VALUE #( FOR ls_task IN lt_task ( %key         = ls_task-%key
                                                 Status       = '104'
                                                 CancelReason = keys[ TaskUUID = ls_task-TaskUUID ]-%param-cancel_reason
          ) )
          REPORTED DATA(lt_result).
    ENDIF.


  ENDMETHOD.

  METHOD finish_request.

    TRY.
        READ ENTITIES OF zi_jr_task
        IN LOCAL MODE
        ENTITY Task
        ALL FIELDS
        WITH CORRESPONDING #( keys )
        RESULT DATA(lt_task).

        IF  sy-subrc = 0.
          MODIFY ENTITIES OF zi_jr_task
              IN LOCAL MODE
              ENTITY Task
              UPDATE FIELDS ( Status  )
              WITH VALUE #( FOR row IN keys ( %tky    = row-%tky
                                              status  = '103'
                          ) )
              REPORTED DATA(lt_result).
        ENDIF.

      CATCH cx_root INTO DATA(lx_ex).
*       APPEND value #(  ) to  failed-task.
    ENDTRY.


  ENDMETHOD.

ENDCLASS.
