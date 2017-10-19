public class IntegrationTriggerPopulateFieldsHelper {
    
    public  List<Integration__c> getIntegrationAfterInsert(List<Integration__c> integrationList) {
        
        List<Integration__c> integrList = integrationList;
        
        return integrList;
    }
    
    
    public void findContactAndAccountWithRespectiveFields(List<Integration__c> integrationList) {
                
        Map<String, Integration__c> integrationMap = new Map<String, Integration__c>();
        
        List<String> cityList = new List<String>();
        List<String> stateList = new List<String>();
        List<String> countryList = new List<String>();
        List<String> nameList = new List<String>();
        
        for(Integration__c integr : integrationList){
            
            cityList.add(integr.City__c);
            stateList.add(integr.State__c);
            countryList.add(integr.Country__c);
            nameList.add(integr.Name);
            
            String key = integr.City__c + integr.State__c + integr.Country__c + integr.Name;
            
            integrationMap.put(key, integr);
                        
        }
        
        List<Contact> contList = [
            SELECT Id, Name, AccountId, City__c, State__c, Country__c, Account.Name
            FROM Contact 
            WHERE City__c IN :cityList 
            AND State__c IN :stateList
            AND Country__c IN :countryList
            AND Account.Name IN :nameList
        ];
                      
        List<Integration__c> integrationListToUpdate = new List<Integration__c>();
        
        if(!contList.isEmpty()) {
            
            for(Contact c :contList) {
               
                String key = c.City__c + c.State__c + c.Country__c + c.Name;

                Integration__c integr = integrationMap.get(key);
                                
                Integration__c newIntegrationToUpdate = new Integration__c(
                	Id = integr.Id,
                    Contact__c = c.Id
                );
                
                integrationListToUpdate.add(newIntegrationToUpdate);
                                
            }
            
            update integrationListToUpdate;
            
        }
    }
}