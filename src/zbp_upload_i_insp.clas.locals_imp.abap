CLASS lhc_inspection DEFINITION INHERITING FROM cl_abap_behavior_handler.

  PRIVATE SECTION.



    METHODS get_instance_authorizations FOR INSTANCE AUTHORIZATION

      IMPORTING keys REQUEST requested_authorizations FOR inspection RESULT result.



    METHODS validatevendor FOR VALIDATE ON SAVE

      IMPORTING keys FOR inspection~validatevendor.



ENDCLASS.



CLASS lhc_inspection IMPLEMENTATION.



  METHOD get_instance_authorizations.

  ENDMETHOD.



  METHOD validatevendor.

**********************************************************************

*   reading entities from CDS view

    Read ENTITIES OF zupload_i_insp in LOCAL MODE

    ENTITY Inspection

    ALL FIELDS

    WITH CORRESPONDING #( keys )

    RESULT DATA(inspectations)

    FAILED DATA(inspectation_failed).

    if inspectation_failed is not INITIAL.

*    if the above read fails then return the error message

        failed = CORRESPONDING #( Deep inspectation_failed ).

        RETURN.

    ENDIF.

    LOOP AT inspectations ASSIGNING FIELD-SYMBOL(<inspectation>).

        if <inspectation>-Vendor <> '9999999999'.

            DATA(lv_msg) = |Vendor must be '9999999999'|.

            lv_msg = COND #( WHEN <inspectation>-ExcelRowNumber is INITIAL

            THEN lv_msg

            ELSE |Row { <inspectation>-ExcelRowNumber } : { lv_msg }| ).

            APPEND VALUE #( %tky = <inspectation>-%tky ) to failed-inspection.

            APPEND VALUE #( %tky = <inspectation>-%tky

                            %state_area = 'Validate Vendor'

                            %msg = new_message_with_text(

                                severity = if_abap_behv_message=>severity-error

                                text = lv_msg )

                             %element-vendor = if_abap_behv=>mk-on ) TO reported-inspection.



        ENDIF.

        CLEAR lv_msg.

    ENDLOOP.



**********************************************************************

  ENDMETHOD.



ENDCLASS.
