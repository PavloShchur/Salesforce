public class ContactTriggerMore5Cont_CompletedProcess {
        
    public Set<Id> getAccountIds( Map<Id, Contact> oldMap, List<Contact> newList ) {
        
        Set<Id> accountIds = new Set<Id>();
        
        if ( oldMap != null && newList != null ){
            
            for ( Contact contactNew : newList ){
                
                Contact contactOld = oldMap.get(contactNew.Id);
                
                if ( contactNew.AccountId != null
                    &&
                    (
                        contactNew.Age__c != contactOld.Age__c
                        ||
                        contactNew.Adult__c != contactOld.Adult__c
                    )
                   ){
                       accountIds.add( contactNew.AccountId );
                   }
                
                if ( contactNew.AccountId != contactOld.AccountId ){
                    
                    accountIds.add( contactNew.AccountId );
                    accountIds.add( contactOld.AccountId );
                }
                
            }
            
        } else  if ( oldMap == null ){
            
            for ( Contact contactNew : newList ){
                accountIds.add( contactNew.AccountId );
            }
            
        } else if ( newList == null ){
            
            for ( Contact contactNew : oldMap.values() ){
                accountIds.add( contactNew.AccountId );
            }
            
        }
        
        accountIds.remove( null );
        
        return accountIds;
    }
    
    public Set<Id> getContactIds( Map<Id, Contact> oldMap, List<Contact> newList ){
        
        Set<Id> contactIds = new Set<Id>();
        
        if ( oldMap != null && newList != null ){
            
            for ( Contact contactNew : newList ){
                
                Contact contactOld = oldMap.get(contactNew.Id);
                
                if ( 
                    contactNew.Age__c != contactOld.Age__c
                    ||
                    contactNew.Adult__c != contactOld.Adult__c
                )
                {
                    contactIds.add( contactNew.Id );
                }
                
                if ( contactNew.AccountId != contactOld.AccountId ){
                    
                    contactIds.add( contactNew.AccountId );
                    contactIds.add( contactOld.AccountId );
                }
                
            }
            
        } else if ( oldMap == null ){
            
            for ( Contact contactNew : newList ){
                contactIds.add( contactNew.Id );
            }
            
        } else if ( newList == null ){
            
            for ( Contact contactNew : oldMap.values() ){
                contactIds.add( contactNew.Id );
            }
            
        }
        
        contactIds.remove( null );
        
        return contactIds;
    }
    
    
    public void verifyAdultContactList(Set<Id> contactIdsSet) {
        
        List<Contact> verifyAdultContactList = new List<Contact>();
        
        if(!contactIdsSet.isEmpty()) {
            
            for(Contact c : [SELECT Age__c,
                             (SELECT Id, Status 
                              FROM Cases 
                              WHERE Status = 'Completed') 
                             FROM Contact WHERE Id IN :contactIdsSet]) {
                                 
                                 if(!c.Cases.isEmpty() && c.Age__c >= 18) {
                                     
                                     c.Adult__c = true;
                                     
                                 } else {
                                     
                                     c.Adult__c = false;
                                     
                                 }
                                 
                                 verifyAdultContactList.add(c);
                             }
            
            update verifyAdultContactList;
            
        }
                                            
    }
    
    
    public void accountStatus_Completed_Draft(Set<Id> accountIdsSet) {
                
        if ( accountIdsSet.isEmpty() ){
            return;
        }
        
        
        List<Account> accountListToUpdate = new List<Account>();
        
        
        for(Account acc : [SELECT Name, Status__c,
                           (SELECT LastName, Adult__c
                            FROM Contacts)
                           FROM Account 
                           WHERE Id IN :accountIdsSet]
           ){
                              
               Integer adultContactCount = 0;
               
               for ( Contact cont: acc.Contacts ) {
                   
                   if ( cont.Adult__c ) {
                       adultContactCount++;
                   }
                   
               }
               
               
               String status =
                   adultContactCount >= 5
                   ?
                   'Completed'
                   :
               		'Draft';
               
               
               if ( status != acc.Status__c ){
                   
                   acc.Status__c = status;
                   
                   accountListToUpdate.add(acc);
                   
               }
               
           }
        
        update accountListToUpdate;
        
    }
    
}