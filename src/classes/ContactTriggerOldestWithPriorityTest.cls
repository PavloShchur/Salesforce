@isTest(SeeAllData=false)
public class ContactTriggerOldestWithPriorityTest {
    
    
  @testSetup static void setup() {
        
        Account testAccount = new Account(Name = 'TestSetup');
        insert testAccount;
        
        List<Contact> contacts = new List<Contact>{};
            
            for (Integer i = 1; i < 200; i++) {
                
                contacts.add(new Contact(
                    LastName = 'Test Contact',
                    AccountId = testAccount.Id,
                    Birthdate = Date.today().addYears(-i)
                ));
            }
        
        insert contacts;
    } 
    
    static testmethod void verifyPriority_1_ContactUpdate() {
        
        Account testAccount = [SELECT Name FROM Account WHERE Name = 'TestSetup'];
        
        List<Contact> contacts = [
            SELECT Id, AccountId
            FROM Contact
            WHERE AccountId = :testAccount.Id
            ORDER BY Birthdate ASC
        ];
        
        System.assertEquals('1', [
            SELECT Priority__c
            FROM Contact
            WHERE AccountId = :testAccount.Id
            ORDER BY Birthdate ASC LIMIT 1
        ].Priority__c);
        
        List<Contact> contactsList = [SELECT Id, LastName FROM Contact WHERE LastName = 'Test Contact'];
        
        for (Contact c : contactsList) {
            c.Birthdate = Date.today().addYears(-301);
        }
        
        Test.startTest();
        
        update contactsList;
        
        System.assertEquals('1', [
            SELECT Priority__c
            FROM Contact
            WHERE AccountId = :testAccount.Id
            ORDER BY Birthdate ASC LIMIT 1
        ].Priority__c);
        
        Test.stopTest();
        
    }
    
    static testmethod void verifyPriority_2_ContactUpdate() {
        
        Account testAccount = [SELECT Name FROM Account WHERE Name = 'TestSetup'];
        
        List<Contact> contacts = [
            SELECT Id, AccountId
            FROM Contact
            WHERE AccountId = :testAccount.Id
            ORDER BY Birthdate ASC
        ];
        
        
        List<Contact> contactsList = [SELECT Id, LastName FROM Contact WHERE LastName = 'Test Contact'];
        
        for (Contact c : contactsList) {
            c.Birthdate = Date.today().addYears(-301);
        }
        
        Test.startTest();
        
        update contactsList;
        
        List<Contact> contactList = [
            SELECT Priority__c
            FROM Contact
            WHERE AccountId = :testAccount.Id
            ORDER BY Birthdate ASC LIMIT 2
        ];
        
        for(Integer i = 0; i < contactList.size(); i++) {
            
            System.assertEquals('2', contactList.get(contactList.size() - 1).Priority__c);             
            
        }
        
        Test.stopTest();
        
    }
    
    static testmethod void verifyPriority_3_ContactUpdate() {
        
        Account testAccount = [SELECT Name FROM Account WHERE Name = 'TestSetup'];
        
        List<Contact> contacts = [
            SELECT Id, AccountId
            FROM Contact
            WHERE AccountId = :testAccount.Id
            ORDER BY Birthdate ASC
        ];
        
        
        List<Contact> contactsList = [SELECT Id, LastName FROM Contact WHERE LastName = 'Test Contact'];
        
        for (Contact c : contactsList) {
            c.Birthdate = Date.today().addYears(-301);
        }
        
        Test.startTest();
        
        update contactsList;
        
        List<Contact> contactList = [
            SELECT Priority__c
            FROM Contact
            WHERE AccountId = :testAccount.Id
            ORDER BY Birthdate ASC LIMIT 3
        ];
        
        for(Integer i = 0; i < contactList.size(); i++) {
            
            System.assertEquals('3', contactList.get(contactList.size() - 1).Priority__c);             
            
        }
        
        Test.stopTest();
        
    }
    
    static testmethod void verifyPriority_NULL_ContactUpdate() {
        
        Account testAccount = [SELECT Name FROM Account WHERE Name = 'TestSetup'];
        
        List<Contact> contacts = [
            SELECT Id, AccountId
            FROM Contact
            WHERE AccountId = :testAccount.Id
            ORDER BY Birthdate ASC
        ];
        
        
        List<Contact> contactsList = [SELECT Id, LastName FROM Contact WHERE LastName = 'Test Contact'];
        
        for (Contact c : contactsList) {
            c.Birthdate = Date.today().addYears(-301);
        }
        
        Test.startTest();
        
        update contactsList;
        
        List<Contact> contactList = [
            SELECT Priority__c
            FROM Contact
            WHERE AccountId = :testAccount.Id
            ORDER BY Birthdate ASC LIMIT 4
        ];
        
        for(Integer i = 0; i < contactList.size(); i++) {
            
            System.assertEquals(null, contactList.get(contactList.size() - 1).Priority__c);             
            
        }
        
        Test.stopTest();
        
    }  
    
 
    static testmethod void verifyPriorityContactDelete() {
        
        Account testAccount = [SELECT Name FROM Account WHERE Name = 'TestSetup'];
        
        List<Contact> contacts = [
            SELECT Id, AccountId
            FROM Contact
            WHERE AccountId = :testAccount.Id
            ORDER BY Birthdate ASC
        ];
        
        
        List<Contact> contactsList = [SELECT Id, LastName FROM Contact WHERE LastName = 'Test Contact' LIMIT 150];
        
        Test.startTest();
        
        delete contactsList;
        
        List<Contact> contactList = [
            SELECT Priority__c
            FROM Contact
            WHERE AccountId = :testAccount.Id
            ORDER BY Birthdate ASC LIMIT 4
        ];
        
        for(Integer i = 0; i < contactList.size(); i++) {
            
            System.assertEquals(null, contactList.get(contactList.size() - 1).Priority__c);             
            
        }
        
        Test.stopTest();
        
    } 
    
    static testmethod void manyAccounts() {
        
        Account testAccount_1 = new Account(Name = 'TestSetup1');
        Account testAccount_2 = new Account(Name = 'TestSetup2');
        Account testAccount_3 = new Account(Name = 'TestSetup3');
        
        insert new List<Account>{
            	testAccount_1,
                testAccount_2,
                testAccount_3
                };
                    
           //related to account 1
                    
   		Contact cont_1_1 = new Contact(
              LastName = 'test1',
              Birthdate = Date.today().addYears(-1).addDays(-2),
              AccountId = testAccount_1.Id
        );
        
        Contact cont_1_2 = new Contact(
            LastName = 'test1',
            Birthdate = Date.today().addYears(-2).addDays(-3),
            AccountId = testAccount_1.Id
        );
        
        Contact cont_1_3 = new Contact(
            LastName = 'test1',
            Birthdate = Date.today().addYears(-3).addDays(-1),
            AccountId = testAccount_1.Id
        );
        
        //related to account 2
              
        Contact cont_2_1 = new Contact(
            LastName = 'test2',
            Birthdate = Date.today().addYears(-6).addDays(-2), 
            AccountId = testAccount_2.Id
        );
        
        Contact cont_2_2 = new Contact(
            LastName = 'test2',
            Birthdate = Date.today().addYears(-7).addDays(-3),
            AccountId = testAccount_2.Id
        );
        
        Contact cont_2_3 = new Contact(
            LastName = 'test2',
            Birthdate = Date.today().addYears(-8).addDays(-1),
            AccountId = testAccount_2.Id
        );        
   
           //related to account 3
                    
   		Contact cont_3_1 = new Contact(
              LastName = 'test3',
              Birthdate = Date.today().addYears(-11).addDays(-2),
              AccountId = testAccount_3.Id
        );
        
        Contact cont_3_2 = new Contact(
            LastName = 'test3',
            Birthdate = Date.today().addYears(-12).addDays(-3),
            AccountId = testAccount_3.Id
        );
        
        Contact cont_3_3 = new Contact(
            LastName = 'test3',
            Birthdate = Date.today().addYears(-13).addDays(-1),
            AccountId = testAccount_3.Id
        );    
        
        Test.startTest();
        
        insert new List<Contact>{
            	cont_1_1,
                cont_1_2,
                cont_1_3,
                cont_2_1,
                cont_2_2,
                cont_2_3,
                cont_3_1,
                cont_3_2,
                cont_3_3
                };
                    
        Test.stopTest();
        
        Account testAcct_1 = [SELECT Id FROM Account WHERE Id = : testAccount_1.Id];
        Account testAcct_2 = [SELECT Id FROM Account WHERE Id = : testAccount_2.Id];
        Account testAcct_3 = [SELECT Id FROM Account WHERE Id = : testAccount_3.Id];
               
        System.assertEquals('1', [
            SELECT Priority__c
            FROM Contact
            WHERE AccountId = :testAcct_1.Id
            ORDER BY Birthdate ASC LIMIT 1
        ].Priority__c);
      
        System.assertEquals('1', [
            SELECT Priority__c
            FROM Contact
            WHERE AccountId = :testAcct_2.Id
            ORDER BY Birthdate ASC LIMIT 1
        ].Priority__c);  
      
        System.assertEquals('1', [
            SELECT Priority__c
            FROM Contact
            WHERE AccountId = :testAcct_3.Id
            ORDER BY Birthdate ASC LIMIT 1
        ].Priority__c);          
        
    }
    
}