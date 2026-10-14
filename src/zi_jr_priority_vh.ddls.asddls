@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Products Value Help'
@Metadata.ignorePropagatedAnnotations: true
@ObjectModel.resultSet.sizeCategory: #XS
define view entity ZI_JR_PRIORITY_VH
  as select from DDCDS_CUSTOMER_DOMAIN_VALUE( p_domain_name: 'ZJR_DM_PRIORITY' )   as values
    inner join   DDCDS_CUSTOMER_DOMAIN_VALUE_T( p_domain_name: 'ZJR_DM_PRIORITY' ) as texts on  texts.domain_name = values.domain_name
                                                                                            and texts.value_low   = values.value_low
                                                                                            and texts.language    = $session.system_language
{
      @ObjectModel.text.element: [ 'PriorityText' ]
  key values.value_low as PriorityCode,
      texts.text       as PriorityText
}
