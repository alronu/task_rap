@AbapCatalog.viewEnhancementCategory: [#NONE]
@AccessControl.authorizationCheck: #NOT_REQUIRED
@EndUserText.label: 'Order Type Value Help'
@ObjectModel.resultSet.sizeCategory: #XS
define view entity ZI_JR_ORDER_TYPE_VH
  as select from DDCDS_CUSTOMER_DOMAIN_VALUE( p_domain_name: 'ZJR_DM_ORDER_TYPE' )   as values
    inner join   DDCDS_CUSTOMER_DOMAIN_VALUE_T( p_domain_name: 'ZJR_DM_ORDER_TYPE' ) as texts on  texts.domain_name = values.domain_name
                                                                                              and texts.value_low   = values.value_low
                                                                                              and texts.language    = $session.system_language
{
      @ObjectModel.text.element: [ 'OrderTypeText' ]
  key values.value_low as OrderTypeCode,
      texts.text       as OrderTypeText
}
