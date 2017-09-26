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
        
        for(AggregateResult r : [SELECT AccountId AcctId, SUM(Amount__c) Amount FROM Contact 
             WHERE AccountId IN :accountIds 
             GROUP BY AccountId]) {
            
                Account account = new Account();
                 
                account.Id = (Id) r.get('AcctId');
                account.SumOfPrequalifiedAmount__c = (Decimal) r.get('Amount');        		
               
               prequalifiedAmountMap.put(account.Id, account.SumOfPrequalifiedAmount__c);           
        }
      
        System.debug(Limits.getQueries() +', '+ Limits.getLimitQueries());
        
        return prequalifiedAmountMap;
        
    }


    //WRITE UNIT TEST WHEN LAST CONTACT ON ACCOOUNT IS DELETED

    public  Map<Id, Decimal> getNumberOfContacts (Set<Id> accountIds) {
        System.debug('getNumberOfContacts()');
        
        if ( accountIds.isEmpty() ){
            return new Map<Id, Decimal>();
        }
        
        Map<Id, Decimal> numberOfContactsMap = new Map<Id, Decimal>();
                       
        for(AggregateResult r : 
            
            [SELECT AccountId AcctId, Count(id) ContactCount 
             FROM Contact 
             WHERE AccountId IN :accountIds 
             GROUP BY AccountId]
            
         ){

             Account account = new Account(); 
                          
             account.Id = (Id) r.get('AcctId');
             account.NumberOfContacts__c = (Integer) r.get('ContactCount');

             
             numberOfContactsMap.put(account.Id, account.NumberOfContacts__c);
             
         }
        		
        System.debug('numberOfContactsMap = ' + numberOfContactsMap);			        
        return numberOfContactsMap;
        
    }
        

    public void performCalculation(Set<Id> accountIds) {
                
        if ( accountIds.isEmpty() ){
            return;
        }

        
        List<Account> updateAccounts = new List<Account>();
            
        Map<Id, Decimal> prequalifiedAmountMap = getSumOfPrequalifiedAmount(accountIds);
        Map<Id, Decimal> numberOfContactsMap = getNumberOfContacts(accountIds);
        
        if(!prequalifiedAmountMap.isEmpty() 
          ||
           !numberOfContactsMap.isEmpty()
          ) {
    

            for(Id accountId : accountIds){
                
                Account account = new Account();
                
                    account.Id = accountId;
                
                    account.NumberOfContacts__c = numberOfContactsMap.get( account.Id );
                
                    account.SumOfPrequalifiedAmount__c =  prequalifiedAmountMap.get( account.Id );  
                
                updateAccounts.add(account); 
    
            }
          }

        update updateAccounts; 
     
    } 
    
}