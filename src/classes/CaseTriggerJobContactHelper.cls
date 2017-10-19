public class CaseTriggerJobContactHelper {
    
    public Set<Id> getContactIds(Map<Id, Case> oldMap, List<Case> newList) {
        
        Set<Id> contactIds = new Set<Id>();
        
        if (oldMap != null && newList != null) {
            
            for (Case caseNew : newList) {
                
                Case caseOld = oldMap.get(caseNew.Id);
                
                if (caseNew.Status != caseOld.Status) {
                    contactIds.add(caseNew.ContactId);
                }
                
                if (caseNew.ContactId != caseOld.ContactId) {
                    
                    contactIds.add(caseNew.ContactId);
                    contactIds.add(caseOld.ContactId);
                    
                }
                
            }
            
        } else if (newList == null) {
            
            for (Case caseNew : oldMap.values()) {
                contactIds.add(caseNew.ContactId);
            }
            
        } else if (oldMap == null) {
            
            for (Case caseNew : newList) {
                contactIds.add(caseNew.ContactId);
            }
        }
        
        contactIds.remove(null);
        
        return contactIds;
        
    }
    
    public void verifyContactStatus(Set<Id> contactIdsSet) {
        
        List<Contact> contactListToUpdate = new List<Contact>();
        
        List<Contact> contactList = new List<Contact>();
               
        List<Case> caseList = new List<Case>();
        
        for(Contact contact: [SELECT Age__c, Adult__c,
                              	(SELECT Status FROM Cases)
                              FROM Contact WHERE id in:contactIdsSet]) {
                                                                    
                                  contactList.add(contact);                           
                                  caseList = contact.Cases;
                                  
                              }  
        
        if(caseList.size() > 0) {
            
            for(Contact contact : contactList) {
                
                Integer counter = 0;
                
                for(Integer j = 0; j < caseList.size(); j++) {
                    
                    if(caseList.get(j).Status == 'Completed' && contact.Age__c >= 18) {
                                                
                        counter++;
                        
                    } 
                    
                }
                
                if(counter > 0) {
                    
                    contact.Adult__c = true;
                    
                } else {
                    
                    contact.Adult__c = false;
                    
                }
                                
                contactListToUpdate.add(contact);
                
            }
            
        } else {
            
            for(Contact contact : contactList) {
                
                contact.Adult__c = false;
                contactListToUpdate.add(contact);
                
            }
            
        }

            update contactListToUpdate;
            
        
    }
    
    
}