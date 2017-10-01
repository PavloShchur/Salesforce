public class ContactTriggerClosestBirthdateHelper {

    public Set<Id> getAccountIds(Map<Id, Contact> oldMap, List<Contact> newList) {

        Set<Id> accountIds = new Set<Id>();

        if (oldMap != null && newList != null) {

            for (Contact contactNew :newList) {

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


    private Map<Id, Id> findContactWithClosestBirthday(Set<Id> accountIds) {

        if (accountIds.isEmpty()) {
            return new Map<Id, String>();
        }
        
        Map<Id, Id> contactWithClosestBirthDay = new Map<Id, Id>();
        
        for(Contact c :[SELECT Id, Days__c, AccountId 
                        FROM Contact  
                        WHERE AccountId = :accountIds
                        ORDER BY AccountId, Days__c DESC]) {
                            	
                            Id accountId = c.AccountId;
            				Id contactId = c.Id;
             
            contactWithClosestBirthDay.put(
                    accountId,
                    contactId
                    
            );
                        }
                    
 /*       for(AggregateResult r : 
            [SELECT MIN(Days__c), AccountId acctId, Id contId
             FROM Contact
             WHERE AccountId IN :accountIds
             GROUP BY AccountId, Id
             ORDER BY AccountId, MIN(Days__c) DESC]
        ){
            
			Id accountId = (Id) r.get('acctId');
            Id contactId = (Id) r.get('contId');
             
            contactWithClosestBirthDay.put(
                    accountId,
                    contactId
                    
            );
            
        } */
        
        for (Id accountId : accountIds) {
            if (!contactWithClosestBirthDay.containsKey(accountId)) {
					System.debug('NOT');
                contactWithClosestBirthDay.put(
                        accountId,
                        null
                );

            }

        } 
        
        System.debug('contactWithClosestBirthDay = ' + contactWithClosestBirthDay);
        return contactWithClosestBirthDay;
    }
   
        public void performCalculation(Set<Id> accountIds) {

        if (accountIds.isEmpty()) {
            return;
        }

        Map<Id, Id> contactWithClosestBirthDay = findContactWithClosestBirthDay(accountIds);
            System.debug('AAAAA = ' + contactWithClosestBirthDay);

        List<Account> updateAccounts = new List<Account>();

        for (Id accountId : accountIds) {

            updateAccounts.add(
                new Account(
                    Id = accountId,
                    ClosestBirthdayContact__c = contactWithClosestBirthDay.get(accountId)
                )
            );

        }

        update updateAccounts;
        System.debug('updateAccounts = ' + updateAccounts);

    }

}