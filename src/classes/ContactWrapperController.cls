public class ContactWrapperController {
    
    public List<cContact> contactList { get; set; }
    
        public List<cContact> getContacts() {
            
            if(contactList == null) {
                
                contactList = new List<cContact>();
                
                    for(Contact c :
                                    [SELECT FirstName, 
                                     LastName, 
                                     SyncStatus__c 
                                    FROM Contact]) {
                                        
                        contactList.add(new cContact(c));
                    }
            }
            
            	System.debug(Limits.getQueries() +', '+ Limits.getLimitQueries());
            
            return contactList;
            
        }
        
        public PageReference processSelected() {
            
            List<Contact> selectedContacts = new List<Contact>();
            
                for(cContact cCon :getContacts()) {
                    
                    if(cCon.selectedContact == true) {
                        
                        selectedContacts.add(cCon.con);
                        
                    }
                }

                    contactList = null;
                    
                    return null;
        }
    
       public void runBatch(){
            
                  ExternalContactBatch batch = new ExternalContactBatch();
                  Database.executeBatch(batch);
            
   }
        
        
        public class cContact {
            
            public Contact con { get; set; }
            public Boolean selectedContact { get; set; }
            
            public cContact(Contact contact) {
                con = contact;
                selectedContact = false;
            }
            
        }
    
    

}