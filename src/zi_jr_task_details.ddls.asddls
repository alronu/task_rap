@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Task Details Interface View'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZI_JR_TASK_DETAILS
  as select from zjr_task_details
  association to parent ZI_JR_TASK as _Task on $projection.TaskUUID = _Task.TaskUUID
  association [0..1] to ZI_JR_STATUS_DET_HV as _Status on $projection.Status = _Status.StatusDetCode
  association [0..1] to ZI_JR_ORDER_TYPE_VH as _OrderType on $projection.OrderType = _OrderType.OrderTypeCode
{
  key task_uuid       as TaskUUID,
  key detail_uuid     as DetailUUID,
      order_number    as OrderNumber,
      order_type      as OrderType,
      
      status          as Status,
      
      case status
        when 'DEV' then 5   //Negro
        when 'QAS' then 2   //Orange    Critical
        when 'PRD' then 3   //Green     Positive
        when 'ERR' then 1   //Red       Negative
        else 0              //Blue      New Item
      end                  as StatusCriticality,
      
      description     as Description,
      created_date    as CreatedDate,
      ticket          as Ticket,
      created_by      as CreatedBy,
      created_at      as CreatedAt,
      last_changed_by as LastChangedBy,
      last_changed_at as LastChangedAt,
      
      //Associations
      _Task,
      _Status,
      _OrderType
}
