public class ContactTriggerHelperClass {
    
    public Set<Id> getAccountIdsForCountCalculation( Map<Id, Contact> oldMap, List<Contact> newList ){

        Set<Id> accountIds = new Set<Id>();

        if ( oldMap == null && !newList.isEmpty()){
            
            for ( Contact contactNew : newList ){
                accountIds.add( contactNew.AccountId );
            }
            
        } else if ( newList == null && !oldMap.values().isEmpty()){
            
            for ( Contact contactNew : oldMap.values() ){
                accountIds.add( contactNew.AccountId );
            }
            
        }

        accountIds.remove( null );

        return accountIds;
    }


    public Set<Id> getAccountIdsForSumCalculation( Map<Id, Contact> oldMap, List<Contact> newList ){

        Set<Id> accountIds = new Set<Id>();
        
        if ( oldMap != null && newList != null ){
            
            for ( Contact contactNew : newList ){
                
                Contact contactOld = oldMap.get(contactNew.Id);
                
                if ( contactNew.AccountId != null
                    &&
                    contactNew.Amount__c != contactOld.Amount__c
                   ){
                       accountIds.add( contactNew.AccountId );
                   }
                
                if ( contactNew.AccountId != contactOld.AccountId ){
                    
                    accountIds.add( contactNew.AccountId );
                    accountIds.add( contactOld.AccountId );
                }
                
            }
            
        } else if ( newList == null && !oldMap.values().isEmpty()){
            
            for ( Contact contactNew : oldMap.values() ){
                accountIds.add( contactNew.AccountId );
            }
            
        } else if ( oldMap == null && !newList.isEmpty()) {
            
            for ( Contact contactNew : newList ){
                accountIds.add( contactNew.AccountId );
            }
        }
        
        accountIds.remove( null );

        return accountIds;

    }

        
    public Map<Id, Decimal> getSumOfPrequalifiedAmount(Set<Id> accountIds) {
    
        if ( accountIds.isEmpty() ){
            return new Map<Id, Decimal>(); 
        }

        Map<Id, Decimal> prequalifiedAmountMap = new Map<Id, Decimal>();
        
        for(AggregateResult r : 
            [SELECT AccountId AcctId, SUM(Amount__c) SumAmount 
             FROM Contact 
             WHERE AccountId IN :accountIds 
             GROUP BY AccountId]
        ){
            
            Id accountId = (Id) r.get('AcctId');
            Decimal sumAmount = (Decimal) r.get('SumAmount');		               

            prequalifiedAmountMap.put(
                accountId, 
                sumAmount
            );
        }

        //process those accounts with last contact removed
        for (Id accountId :accountIds) {
            if ( ! prequalifiedAmountMap.containsKey( accountId ) ){

                prequalifiedAmountMap.put(
                    accountId, 
                    0
                );

            }
        }        
    
        
        return prequalifiedAmountMap;
        
    }



    public  Map<Id, Decimal> getNumberOfContacts (Set<Id> accountIds) {       
        
        if ( accountIds.isEmpty() ){
            return new Map<Id, Decimal>();
        }
        
        Map<Id, Decimal> accountId2ContactCountMap = new Map<Id, Decimal>();
                       
        for(AggregateResult r : 
            
            [SELECT AccountId AcctId, Count(id) ContactCount 
             FROM Contact 
             WHERE AccountId IN :accountIds 
             GROUP BY AccountId]
            
        ){
  
            Id accountId = (Id) r.get('AcctId');
            Decimal contactCountNumber = (Integer) r.get('ContactCount');


            accountId2ContactCountMap.put(
                accountId, 
                contactCountNumber
            );
        }


        //process those accounts with last contact removed
        for (Id accountId :accountIds) {
            if ( ! accountId2ContactCountMap.containsKey( accountId ) ){

                accountId2ContactCountMap.put(
                    accountId, 
                    0
                );

            }
        }


        return accountId2ContactCountMap;
        
    }
        

    public void performCalculation(Set<Id> accountIds) {
                
        if ( accountIds.isEmpty() ){
            return;
        }

        Map<Id, Decimal> prequalifiedAmountMap = getSumOfPrequalifiedAmount(accountIds);
        Map<Id, Decimal> numberOfContactsMap = getNumberOfContacts(accountIds);        

        
        List<Account> updateAccounts = new List<Account>();
        
        for(Id accountId : accountIds){
            
            updateAccounts.add(
                new Account(
                    Id = accountId,
                    NumberOfContacts__c = numberOfContactsMap.get( accountId ),
                    SumOfPrequalifiedAmount__c = prequalifiedAmountMap.get( accountId )
                )
            ); 

        }

        update updateAccounts; 
     
    } 
    
}