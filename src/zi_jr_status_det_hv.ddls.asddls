@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Status Details value help'
@ObjectModel.resultSet.sizeCategory: #XS
define view entity ZI_JR_STATUS_DET_HV
  as select from DDCDS_CUSTOMER_DOMAIN_VALUE( p_domain_name: 'ZJR_DM_STATUS_DET' )   as values
    inner join   DDCDS_CUSTOMER_DOMAIN_VALUE_T( p_domain_name: 'ZJR_DM_STATUS_DET' ) as texts on  texts.domain_name = values.domain_name
                                                                                              and texts.value_low   = values.value_low
                                                                                              and texts.language    = $session.system_language
{
      @ObjectModel.text.element: [ 'StatusDetText' ]
  key values.value_low as StatusDetCode,
      texts.text       as StatusDetText
}
