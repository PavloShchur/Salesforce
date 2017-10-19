public class ContactTriggerOldestWithPriorityHelper {
    
    public static final Integer MAX_PRIORITY = 3;
    
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
    
    private Map<Id, List<Contact>> sortContactsBybirthdateAndPriority(Set<Id> accountIds) {
        
        if (accountIds.isEmpty()) {
            return new Map<Id, List<Contact>>();
        }
        
        Map<Id, List<Contact>> contactPriorityMap = new Map<Id, List<Contact>>();
        
        for (AggregateResult r : [  SELECT MIN(Birthdate), AccountId, Id, Priority__c
                                    FROM Contact
                                    WHERE AccountId IN :accountIds 
                                    AND Birthdate <> NULL
                                    GROUP BY AccountId, Id, Priority__c
                                    ORDER BY AccountId, MIN(Birthdate) ASC]
            ) {
                
                Id accountId = (Id) r.get('AccountId');
                Id contactId = (Id) r.get('Id');
                
                List<Contact> contactList = contactPriorityMap.get(accountId);
                
                if(contactList == null) {
                    contactList = new List<Contact>();
                }
                
                contactList.add(new Contact(
                    Id = contactId
                ));
                
                contactPriorityMap.put(
                    accountId,
                    contactList
                );
                
            }
        
        for (Id accountId : accountIds) {
            if (!contactPriorityMap.containsKey(accountId)) {
                contactPriorityMap.put(
                    accountId,
                    null
                );
                
            }
            
        } 
        
        return contactPriorityMap;
    }

    
    
    public void performCalculation(Set<Id> accountIds) {
        
        if (accountIds.isEmpty()) {
            return;
        }
        
        Map<Id, List<Contact>> contactPriorityMap = sortContactsBybirthdateAndPriority(accountIds);
        
        List<Contact> contactsToUpdate = new List<Contact>();

        for(List<Contact> contacts : contactPriorityMap.values()) {
            
            Integer counter = 1;
            
            for ( Contact contactItem : contacts ){

                if ( counter <= MAX_PRIORITY ){

                    contactItem.Priority__c = String.valueOf( counter++ );

                } else {

                    contactItem.Priority__c = null;

                }

                contactsToUpdate.add( contactItem );
            }

        }
        
		update contactsToUpdate;
    }   
}