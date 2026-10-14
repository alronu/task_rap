@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Task Objects Interface View'
@Metadata.ignorePropagatedAnnotations: true
define view entity ZI_JR_TASK_OBJECTS
  as select from zjr_task_objects
  association to parent ZI_JR_TASK as _Task on $projection.TaskUUID = _Task.TaskUUID
{
  key task_uuid   as TaskUUID,
  key object_uuid as ObjectUUID,
      object_type as ObjectType,
      object_name as ObjectName,
      created_by      as CreatedBy,
      created_at      as CreatedAt,
      last_changed_by as LastChangedBy,
      last_changed_at as LastChangedAt,      
//Associations    
    _Task      
}
