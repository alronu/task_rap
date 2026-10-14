@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Task Attachment Consumption View'
//@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define view entity ZC_JR_TASK_ATTACHMENT as projection on ZI_JR_TASK_ATTACHMENT
{
    key TaskUUID,
    key AttachUUID,
    Attachment,
    Mimetype,
    Filename,
    Texto,
    CreatedBy,
    CreatedAt,
    LastChangedBy,
    LastChangedAt,
    _Task : redirected to parent ZC_JR_TASK 
}
