public class CaseTriggerStatusCompletedHelper {
    
    Set<Id> contactIdsSet = new Set<Id>();
    List<Contact> contactListToUpdate = new List<Contact>();
    
    public void saveContactIds(Id contactId) {
        contactIdsSet.add(contactId);
    }
    
    public void verifyContactStatus() {
        
        List<Contact> tempList = new List<Contact>();
        List<User> userList = [SELECT Id, Name from User];
        List<Contact> contactList = new List<Contact>();
        List<Case> caseList = new List<Case>();
        
        for(Contact contact: [SELECT id, Name, Age__c, Adult__c,
                              (SELECT id, Status FROM Cases)
                              FROM Contact WHERE id in:contactIdsSet]) {
                                  
                                  contactList.add(contact);                           
                                  caseList = contact.Cases;
                                  
                              }  
        
        if(caseList.size() > 0) {
            
            List<Contact> tempContactList = [SELECT id, Name, Age__c, Adult__c
                                             FROM Contact 
                                             WHERE Id IN :contactList];
            
            for(Integer i = 0; i < caseList.size(); i++) {
                
                if(caseList.get(i).Status == 'Completed') {
                    
                    for(Integer j = 0; j < userList.size(); j++) {
                        
                        JobSharing.manualShare(tempContactList, userList.get(j).Id, 'Read');
                        
                    }
                    
                } 
                
                if(caseList.size() > 3) {
                    
                    for(Integer j = 0; j < userList.size(); j++) {
                        JobSharing.manualShare(tempContactList, userList.get(j).Id, 'Edit');
                    }
                }
                
            }
            
            for(Contact contact : contactList) {
                
                for(Integer j = 0; j < caseList.size(); j++) {
                    
                    if(caseList.get(j).Status == 'Completed' && contact.Age__c > 18) {
                        
                        tempList.add(contact);
                        
                    } 
                    
                }
                
                if(tempList.size() > 0) {
                    
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
        
        try{
            System.debug('contactListToUpdate 91 = ' + contactListToUpdate);
            update contactListToUpdate;
            System.debug('contactListToUpdate 93 = ' + contactListToUpdate);
        } catch(DMLException e) {
            System.debug('An unexpected error has occurred ' + e.getMessage());
        }
        
    }
    
}