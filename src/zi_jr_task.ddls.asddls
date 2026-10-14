@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Task Interface root View'
//@Metadata.ignorePropagatedAnnotations: true
define root view entity ZI_JR_TASK
  as select from zjr_task
  composition [0..*] of ZI_JR_TASK_DETAILS    as _Details
  composition [0..*] of ZI_JR_TASK_OBJECTS    as _Objects
  composition [0..*] of ZI_JR_TASK_ATTACHMENT as _Attachment
  association [0..1] to ZI_JR_STATUS_VH       as _Status   on $projection.Status = _Status.StatusCode
  association [0..1] to ZI_JR_AREA_VH         as _Area     on $projection.Area = _Area.AreaCode
  association [0..1] to ZI_JR_PRIORITY_VH     as _Priority on $projection.Priority = _Priority.PriorityCode
{

  key task_uuid       as TaskUUID,
      task_id         as TaskID,
      name            as Name,
      description_    as Description_,
      ticket          as Ticket,
      created_date    as CreatedDate,
      delivery_date   as DeliveryDate,
      package_        as Package_,
      leader          as Leader,
      status          as Status,

      case status
        when '100' then 5   //Negro
        when '106' then 5   //Negro
        when '101' then 2   //Orange    Critical
        when '102' then 3   //Green     Positive
        when '103' then 1   //Red       Negative
        when '104' then 1   //Red       Negative
        when '105' then 1   //Red       Negative
        else 0              //Blue      New Item
      end             as StatusCriticality,

      area            as Area,
      priority        as Priority,
      cancel_reason   as CancelReason,

      @Semantics.largeObject : {
                                  mimeType: 'Mimetype',
                                  fileName: 'Filename',
                                  contentDispositionPreference: #ATTACHMENT
                                }
      attachment      as Attachment,
      
      @Semantics.mimeType: true
      mimetype        as Mimetype,
      
      filename        as Filename,

      created_by      as CreatedBy,
      created_at      as CreatedAt,
      last_changed_by as LastChangedBy,
      last_changed_at as LastChangedAt,


      //Associations
      _Details,
      _Objects,
      _Attachment,
      _Status,
      _Area,
      _Priority

}
