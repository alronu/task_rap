@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Task Attachments Interface View'
//@Metadata.ignorePropagatedAnnotations: true
define view entity ZI_JR_TASK_ATTACHMENT
  as select from zjr_task_attach
  association to parent ZI_JR_TASK as _Task on $projection.TaskUUID = _Task.TaskUUID
{
  key task_uuid       as TaskUUID,
  key attach_uuid     as AttachUUID,

      @Semantics.largeObject : {
                                  mimeType: 'Mimetype',
                                  fileName: 'Filename',
                                  contentDispositionPreference: #ATTACHMENT
                                }
      attachment      as Attachment,
      
      @Semantics.mimeType: true
      mimetype        as Mimetype,
      
      filename        as Filename,
      texto           as Texto,
      created_by      as CreatedBy,
      created_at      as CreatedAt,
      last_changed_by as LastChangedBy,
      last_changed_at as LastChangedAt,

      //Associations
      _Task
}
