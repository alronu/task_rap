@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Task Consumption View'
//@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define root  view entity ZC_JR_TASK
  provider contract transactional_query as projection on ZI_JR_TASK
{
    key TaskUUID,
    TaskID,
    Name,
    Description_,
    Ticket,
    CreatedDate,
    DeliveryDate,
    Package_,
    Leader, 
    
    @ObjectModel.text.element: [ 'StatusText' ]
    @Consumption.valueHelpDefinition: [{ 
                                        entity: { name: 'ZI_JR_STATUS_VH', 
                                                  element: 'StatusCode'  } 
                                       }]   
    Status,
    _Status.StatusName as StatusText,
    
    StatusCriticality,
    @ObjectModel.text.element: [ 'AreaName' ]
    @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_JR_AREA_VH', 
                                         element: 'AreaCode' } 
                                       }]
    Area,
    _Area.AreaName,
    
    @ObjectModel.text.element: [ 'PriorityText' ]
    @Consumption.valueHelpDefinition: [{ entity: { name: 'ZI_JR_PRIORITY_VH', 
                                                   element: 'PriorityCode' } 
                                                  }]
    Priority,
    _Priority.PriorityText as PriorityText,
    
    CancelReason,    
    
    //@Semantics.imageUrl: true
    Attachment,
    Mimetype,
    Filename,
    
    @Semantics.user.createdBy: true
    CreatedBy,    
    @Semantics.systemDateTime.createdAt: true
    CreatedAt,    
    @Semantics.user.lastChangedBy: true
    LastChangedBy,    
    @Semantics.systemDateTime.lastChangedAt: true
    LastChangedAt,
    /* Associations */
    _Details: redirected to composition child ZC_JR_TASK_DETAILS ,
    _Objects: redirected to composition child ZC_JR_TASK_OBJECTS,
    _Attachment: redirected to composition child ZC_JR_TASK_ATTACHMENT
}
