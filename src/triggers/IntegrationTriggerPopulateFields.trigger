trigger IntegrationTriggerPopulateFields on Integration__c (after insert) {
    
    if (Trigger.isAfter) {
        
        IntegrationTriggerPopulateFieldsHelper integrationHelper = new IntegrationTriggerPopulateFieldsHelper();
        
        integrationHelper.findContactAndAccountWithRespectiveFields(
            integrationHelper.getIntegrationAfterInsert(Trigger.new)
        );
        
        
    }
    
}