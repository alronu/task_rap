@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Task Objects Consumption View'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define view entity ZC_JR_TASK_OBJECTS as projection on ZI_JR_TASK_OBJECTS
{
    key TaskUUID,
    key ObjectUUID,
    ObjectType,
    ObjectName,
    @Semantics.user.createdBy: true
    CreatedBy,    
    @Semantics.systemDateTime.createdAt: true
    CreatedAt,    
    @Semantics.user.lastChangedBy: true
    LastChangedBy,    
    @Semantics.systemDateTime.lastChangedAt: true
    LastChangedAt,    
    /* Associations */
    _Task: redirected to parent ZC_JR_TASK
}
