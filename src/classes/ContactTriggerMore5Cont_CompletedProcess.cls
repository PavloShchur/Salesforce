public class ContactTriggerMore5Cont_CompletedProcess {
    
        public Set<Id> getAccountIds( Map<Id, Contact> oldMap, List<Contact> newList ){
            
            Set<Id> accountIds = new Set<Id>();
            
                   if ( oldMap != null && newList != null ){
    
                for ( Contact contactNew : newList ){
                    
                    Contact contactOld = oldMap.get(contactNew.Id);
    				System.debug('FIX');
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
            
            System.debug('accountIds 48 = ' + accountIds);

        return accountIds;
    }
    
       public Set<Id> getContactIds( Map<Id, Contact> oldMap, List<Contact> newList ){

            Set<Id> contactIds = new Set<Id>();
    
                    if ( oldMap == null ){
            
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
        
        
        public void verifyAdultContactListMethod(Set<Id> contactIdsSet) {
                        
            List<Contact> verifyAdultContactList = new List<Contact>();
                
                if(!contactIdsSet.isEmpty()) {
                                
                        for(Contact c : [SELECT Age__c,
                                                 (SELECT Id, Status 
                                                  FROM Cases 
                                                  WHERE Status = 'Completed') 
                                         FROM Contact WHERE Id In :contactIdsSet]) {
                                            
                                             
                                             
                                             if(!c.Cases.isEmpty() && c.Age__c > 18) {
                                                        
                                        c.Adult__c = true;
                                    
                            } else {
                                
                                c.Adult__c = false;
                                
                            }
                            
                            verifyAdultContactList.add(c);
                        }
                    }
            
            try{
                
                update verifyAdultContactList;
                System.debug('verifyAdultContactList = ' + verifyAdultContactList);
                
               		System.debug(Limits.getQueries() +', '+ Limits.getLimitQueries());
                
            }catch( DMLException e ) {
                
                System.debug('An unexpected error has occurred ' + e.getMessage());
                
            }
        }
        
    
        public void accountStatus_Completed_Draft(Set<Id> accountIdsSet) {
            
            List<Account> accountListToUpdate = new List<Account>();
            List<Contact> tempContactList = new List<Contact>();
                        
                for(Account acc : [SELECT Name,
                                           (SELECT LastName, Adult__c
                                            FROM Contacts)
                                   FROM Account WHERE id IN :accountIdsSet]){
                                      
                                       System.debug('acc.Contacts = ' + acc.Contacts);
                                       
                                       for(Contact c: acc.Contacts) {
                                                                                      
                                           if(c.Adult__c == true) {
                                               
                                               tempContactList.add(c);
                                               
                                               if(tempContactList.size() > 4) {
                                                                                                  
                                                   acc.Status__c = 'Completed';
                                                   
                                               } 
                                               
                                           } else {
                                               
                                               acc.Status__c = 'Draft';
                                               
                                           }
                                           
                                       } 
                                           accountListToUpdate.add(acc);
                                   }
            
        try{
            
            update accountListToUpdate;
            System.debug('accountListToUpdate = ' + accountListToUpdate);
            
            	System.debug(Limits.getQueries() +', '+ Limits.getLimitQueries());
            
        } catch(DMLException e) {
            
            	System.debug('An unexpected error has occurred ' + e.getMessage());
            
        }
        
    }
    
}