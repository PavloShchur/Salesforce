public class ContactTriggerOldestWithPriorityHelper {

    public Set<Id> getAccountIds(Map<Id, Contact> oldMap, List<Contact> newList) {

        Set<Id> accountIds = new Set<Id>();

        if (oldMap != null && newList != null) {

            for (Contact contactNew : newList) {

                Contact contactOld = oldMap.get(contactNew.Id);

                if (contactNew.Birthdate != contactOld.Birthdate) {
                    accountIds.add(contactNew.AccountId);
                }

                if (contactNew.AccountId != contactOld.AccountId) {

                    accountIds.add(contactNew.AccountId);
                    accountIds.add(contactOld.AccountId);
                }

            }

        } else if (newList == null) {

            for (Contact contactNew : oldMap.values()) {
                accountIds.add(contactNew.AccountId);
            }

        } else if (oldMap == null) {

            for (Contact contactNew : newList) {
                accountIds.add(contactNew.AccountId);
            }
        }

        accountIds.remove(null);

        return accountIds;

    }
    
    private Map<Id, String> findContactWithClosestBirthday(Set<Id> accountIds) {

        if (accountIds.isEmpty()) {
            return new Map<Id, String>();
        }
        
        Map<Id, String> contactPriorityMap = new Map<Id, String>();
        

                    
        for(AggregateResult r : 
            [SELECT MAX(Age__c), Id contId,Priority__c priority
             FROM Contact
             WHERE AccountId IN :accountIds
             GROUP BY AccountId, Id, Priority__c
             HAVING COUNT(LastName) = 3 
             AND (Priority__c = '1' OR Priority__c = '2' OR Priority__c = '3')
             ORDER BY AccountId, MAX(Age__c) DESC]
        ){
            
            Id contactId = (Id) r.get('contId');
            String priority = (String) r.get('priority');
             
            contactPriorityMap.put(
                    contactId,
                	'1'
                    
            );
            
        } 
        

         return contactPriorityMap;
    }
   
        public void performCalculation(Set<Id> accountIds) {

        if (accountIds.isEmpty()) {
            return;
        }

        Map<Id, String> contactPrioriyMap = findContactWithClosestBirthDay(accountIds);

        List<Contact> updateContacts = new List<Contact>();

        for (Id contactId : contactPrioriyMap.keySet()) {

            updateContacts.add(
                new Contact(
                    Id = contactId,
                    Priority__c = contactPrioriyMap.get(contactId)
                )
            );

        }

        update updateContacts;

    }


}