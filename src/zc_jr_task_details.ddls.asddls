@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Task Details Consumption View'
@Metadata.ignorePropagatedAnnotations: true
@Metadata.allowExtensions: true
define view entity ZC_JR_TASK_DETAILS as projection on ZI_JR_TASK_DETAILS
{
    key TaskUUID,
    key DetailUUID,
    OrderNumber,
    
    @ObjectModel.text.element: [ 'OrderTypeText' ]
    @Consumption.valueHelpDefinition: [{ entity:{ name: 'ZI_JR_ORDER_TYPE_VH', 
                                                  element: 'OrderTypeCode' } 
                                      }]
    OrderType,
    _OrderType.OrderTypeText,
    
    @ObjectModel.text.element: [ 'StatusDetText' ]
    @Consumption.valueHelpDefinition: [{ entity:{ name: 'ZI_JR_STATUS_DET_HV', 
                                                  element: 'StatusDetCode' } 
                                      }]
    Status,
    _Status.StatusDetText,
    
    StatusCriticality,
    Description,
    CreatedDate,
    Ticket,
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
