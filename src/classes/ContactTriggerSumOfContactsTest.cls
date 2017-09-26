@isTest
private class ContactTriggerSumOfContactsTest {
    
    
    @testSetup static void setup() {
        
        Account testAccount = new Account (Name = 'TestSetup');
        insert testAccount;
        
        List<Contact> contacts = new List<Contact>{};
            
            for(Integer i = 0; i < 500; i++){
                contacts.add(new Contact(
                    LastName = 'Test Contact ' + i, 
                    AccountId = testAccount.Id, 
                    Amount__c = i * 100
                ));
            }
        
        insert contacts;       
    }
    
    
    static testmethod void verifySumOfPrequalifiedAmountCreateUpdateDelete() {
        
        Account testAccount = [SELECT Name FROM Account WHERE Name = 'TestSetup'];
        
            
                System.assertEquals(12475000, [SELECT SumOfPrequalifiedAmount__c, NumberOfContacts__c  
                                              FROM Account 
                                              WHERE Id = :testAccount.Id].SumOfPrequalifiedAmount__c);
        
        
        List<Contact> contactsList = [SELECT Id FROM CONTACT WHERE AccountId = :testAccount.Id];
        
        for(Contact c :contactsList) {
            c.Amount__c = 50;
        }
        
        	update contactsList;
        
                System.assertEquals(25000, [SELECT SumOfPrequalifiedAmount__c, NumberOfContacts__c  
                                              FROM Account 
                                              WHERE Id = :testAccount.Id].SumOfPrequalifiedAmount__c);   
        
        for(Contact c :contactsList) {
            c.Amount__c = null;
        }
        
        	update contactsList;
        
                System.assertEquals(null, [SELECT SumOfPrequalifiedAmount__c, NumberOfContacts__c  
                                              FROM Account 
                                              WHERE Id = :testAccount.Id].SumOfPrequalifiedAmount__c);
        
        for(Contact c :contactsList) {
            c.Amount__c = null;
            c.AccountId = null;
        }
        
        	update contactsList;
        
                System.assertEquals(null, [SELECT SumOfPrequalifiedAmount__c, NumberOfContacts__c  
                                              FROM Account 
                                              WHERE Id = :testAccount.Id].SumOfPrequalifiedAmount__c);      
        
        	delete contactsList;
            
                System.assertEquals(null, [SELECT SumOfPrequalifiedAmount__c, NumberOfContacts__c  
                                              FROM Account 
                                              WHERE Id = :testAccount.Id].SumOfPrequalifiedAmount__c);
            
    }
    
    
    static testmethod void verifySumOfContactsCreateUpdateDelete() {
        
        Account testAccount = [SELECT Name FROM Account WHERE Name = 'TestSetup'];
        
        List<Account> insertedAccounts = [SELECT NumberOfContacts__c  
                                          FROM Account 
                                          WHERE Id = :testAccount.Id];
        
        List<Contact> contacts = [SELECT Id, LastName FROM Contact WHERE AccountId =:testAccount.Id];
        
            for(Account account: insertedAccounts){
                System.assertEquals(500, account.NumberOfContacts__c);
            }
        
        
        List<Contact> contactsToAdd = new List<Contact>{};
            
            for(Integer i = 0; i < 500; i++){
                contactsToAdd.add(new Contact(
                    LastName = 'Test Contact A', 
                    AccountId = testAccount.Id, 
                    Amount__c = i * 100
                ));
            }
        
        	insert contactsToAdd;
        
        for(Contact c :contactsToAdd) {
            contacts.add(c);
        }
        
        update contacts;
        
        
                System.assertEquals(1000, [SELECT NumberOfContacts__c  
                                                            FROM Account 
                                                            WHERE Id = :testAccount.Id].NumberOfContacts__c);
        
        	Savepoint sp = Database.setSavepoint();
        
        Database.delete([SELECT Id FROM Contact WHERE LastName = 'Test Contact A'], true);


                 System.assertEquals(500, [SELECT NumberOfContacts__c  
                                                            FROM Account 
                                                            WHERE Id = :testAccount.Id].NumberOfContacts__c);
        
        	Database.rollback(sp);
        
        delete contacts;
        
        System.assertEquals(null, [SELECT NumberOfContacts__c  
                                FROM Account 
                                WHERE Id = :testAccount.Id].NumberOfContacts__c);
        
    }
    
    static testmethod void verifySumOfContactsUpdate() {
        
        Account testAccount = [SELECT Name FROM Account WHERE Name = 'TestSetup'];
        
        List<Contact> contacts = [SELECT LastName FROM Contact WHERE AccountId =:testAccount.Id];

        
        System.assertEquals(500, [SELECT SumOfPrequalifiedAmount__c, NumberOfContacts__c  
                                          FROM Account 
                                          WHERE Id = :testAccount.Id].NumberOfContacts__c);
        
       List<Contact> contactsToUpdate = [SELECT LastName FROM Contact WHERE ID In :contacts];
            
            for(Contact c: contactsToUpdate) {
                    c.Amount__c = 50;
                    c.LastName = 'TestName';
                }
        
        	update contactsToUpdate;
        
        List<Account> insertedAccountsAfterUpdateContact = [SELECT NumberOfContacts__c, SumOfPrequalifiedAmount__c  
                                                            FROM Account 
                                                            WHERE Id = :testAccount.Id];
        
            for(Account account: insertedAccountsAfterUpdateContact){
                System.assertEquals(500, account.NumberOfContacts__c);
                System.assertEquals(25000, account.SumOfPrequalifiedAmount__c);
            }
        
    }
    
    static testmethod void contactWithEmptyAmountField() {
        
        Account testAccount = new Account (Name = 'Test');
        
            try{
                insert testAccount;  
            } catch(DMLException e) {
                System.debug('An unexpected error occurred ' + e.getMessage());
            }
        
        List<Contact> contacts = new List<Contact>{};
            
            for(Integer i = 0; i < 200; i++){
                Contact c = new Contact(LastName = 'Test Account ' + i, AccountId = testAccount.Id);
                contacts.add(c);
            }
        
        Test.startTest();
        
        insert contacts; 
        
        Test.stopTest();
        
        
        System.assertEquals(200, [SELECT SumOfPrequalifiedAmount__c, NumberOfContacts__c  
                                  FROM Account 
                                  WHERE Id = :testAccount.Id].NumberOfContacts__c);
        System.assertEquals(null, [SELECT SumOfPrequalifiedAmount__c, NumberOfContacts__c  
                                   FROM Account 
                                   WHERE Id = :testAccount.Id].SumOfPrequalifiedAmount__c);
                        
    }
    
}