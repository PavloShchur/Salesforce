@isTest
private class ContactTriggerMore5Cont_CompletedTest {
    
    @testSetup static void setup() {
        
        Account testAccount_1 = new Account (Name = 'Test_1');
        Account testAccount_2 = new Account (Name = 'Test_2');
        Account testAccount_3 = new Account (Name = 'Test_3');
        Account testAccount_4 = new Account (Name = 'Test_4');
        Account testAccount_5 = new Account (Name = 'Test_5');
        
        insert new List<Account>{
            
            testAccount_1,
            testAccount_2,
            testAccount_3,
            testAccount_4,
            testAccount_5
                    
       };

    }
    
    static testMethod void verifyAccountStatus(){
        
        Account testAccount_1 = new Account (Name = 'Test_1');
        Account testAccount_2 = new Account (Name = 'Test_2');
        Account testAccount_3 = new Account (Name = 'Test_3');
        Account testAccount_4 = new Account (Name = 'Test_4');
        Account testAccount_5 = new Account (Name = 'Test_5');
        
        insert new List<Account>{
            testAccount_1,
                testAccount_2,
                testAccount_3,
                testAccount_4,
                testAccount_5
                
                };
                    
        Account acct_1 = [SELECT Id FROM Account WHERE Id = :testAccount_1.Id];
        Account acct_2 = [SELECT Id FROM Account WHERE Id = :testAccount_2.Id];
        Account acct_3 = [SELECT Id FROM Account WHERE Id = :testAccount_3.Id];
        Account acct_4 = [SELECT Id FROM Account WHERE Id = :testAccount_4.Id];
        Account acct_5 = [SELECT Id FROM Account WHERE Id = :testAccount_5.Id];
        
        // for acct_1
        
        List<Contact> contactsForAcct_1 = new List<Contact>{};
            
            for(Integer i = 0; i < 200; i++){
                Contact c = new Contact(
                    LastName = 'Test Account ' + i,
                    Birthdate = Date.ValueOf('1968-09-21'),
                    AccountId = acct_1.Id);
                contactsForAcct_1.add(c);
            }
        
        Test.startTest();
        
        insert contactsForAcct_1;
        
        test.stopTest();
        
        List<Case> caseTestListForAcct_1 = new List<Case>();
        
        for(Integer i = 0; i < contactsForAcct_1.size(); i++) {
            Case testCase = new Case(
                ContactId = contactsForAcct_1.get(i).Id,
                Status = 'Completed',
                Origin = 'Phone');
            caseTestListForAcct_1.add(testCase);
        }
        
        insert caseTestListForAcct_1;
        
        // for acct_2
        
        List<Contact> contactsForAcct_2 = new List<Contact>{};
            
            for(Integer i = 0; i < 200; i++){
                Contact c = new Contact(
                    LastName = 'Test Account ' + i,
                    Birthdate = Date.ValueOf('1968-09-21'),
                    AccountId = acct_2.Id
                );
                contactsForAcct_2.add(c);
            }
        
        insert contactsForAcct_2;
        
        List<Case> caseTestListForAcct_2 = new List<Case>();
        
        for(Integer i = 0; i < contactsForAcct_2.size(); i++) {
            Case testCase = new Case(
                ContactId = contactsForAcct_2.get(i).Id,
                Status = 'Completed',
                Origin = 'Phone');
            caseTestListForAcct_2.add(testCase);
        }
        
        insert caseTestListForAcct_2;
        
        
        // for acct_3
        
        List<Contact> contactsForAcct_3 = new List<Contact>{};
            
            for(Integer i = 0; i < 200; i++){
                Contact c = new Contact(
                    LastName = 'Test Account ' + i,
                    Birthdate = Date.ValueOf('1968-09-21'),
                    AccountId = acct_3.Id
                );
                contactsForAcct_3.add(c);
            }
        
        insert contactsForAcct_3;
        
        List<Case> caseTestListForAcct_3 = new List<Case>();
        
        for(Integer i = 0; i < contactsForAcct_3.size(); i++) {
            Case testCase = new Case(
                ContactId = contactsForAcct_3.get(i).Id,
                Status = 'Completed',
                Origin = 'Phone');
            caseTestListForAcct_3.add(testCase);
        }
        
        insert caseTestListForAcct_3;
        
        // for acct_4
        
        List<Contact> contactsForAcct_4 = new List<Contact>{};
            
            for(Integer i = 0; i < 200; i++){
                Contact c = new Contact(
                    LastName = 'Test Account ' + i,
                    Birthdate = Date.ValueOf('1968-09-21'),
                    AccountId = acct_4.Id
                );
                contactsForAcct_4.add(c);
            }
        
        insert contactsForAcct_4;
        
        List<Case> caseTestListForAcct_4 = new List<Case>();
        
        for(Integer i = 0; i < contactsForAcct_4.size(); i++) {
            Case testCase = new Case(
                ContactId = contactsForAcct_4.get(i).Id,
                Status = 'Completed',
                Origin = 'Phone');
            caseTestListForAcct_4.add(testCase);
        }
        
        insert caseTestListForAcct_4;
        
        // for acct_5
        
        List<Contact> contactsForAcct_5 = new List<Contact>{};
            
            for(Integer i = 0; i < 200; i++){
                Contact c = new Contact(
                    LastName = 'Test Account ' + i,
                    Birthdate = Date.ValueOf('1968-09-21'),
                    AccountId = acct_5.Id
                );
                contactsForAcct_5.add(c);
            }
        
        insert contactsForAcct_5;
        
        List<Case> caseTestListForAcct_5 = new List<Case>();
        
        for(Integer i = 0; i < contactsForAcct_5.size(); i++) {
            Case testCase = new Case(
                ContactId = contactsForAcct_5.get(i).Id,
                Status = 'Draft',
                Origin = 'Phone');
            caseTestListForAcct_5.add(testCase);
        }
        
        insert caseTestListForAcct_5;
        
        System.assertEquals('Completed', [SELECT  Status__c
                                          FROM Account
                                          WHERE Id = :acct_1.Id].Status__c);
        
        System.assertEquals('Completed', [SELECT  Status__c
                                          FROM Account
                                          WHERE Id = :acct_2.Id].Status__c);
        
        
        System.assertEquals('Completed', [SELECT  Status__c
                                          FROM Account
                                          WHERE Id = :acct_3.Id].Status__c);
        
        System.assertEquals('Completed', [SELECT  Status__c
                                          FROM Account
                                          WHERE Id = :acct_4.Id].Status__c);
        
        System.assertEquals('Draft', [SELECT  Status__c
                                      FROM Account
                                      WHERE Id = :acct_5.Id].Status__c);
        
        
    }
    
    
    static testMethod void verifyAccountStatusDraft_withoutAge(){
        
        Account testAccount = new Account (Name = 'Test');
        insert testAccount;
        
        List<Contact> contacts = new List<Contact>{};
            
            for(Integer i = 0; i < 200; i++){
                Contact c = new Contact(LastName = 'Test Account ' + i, Birthdate = Date.ValueOf('2008-09-21'), AccountId = testAccount.Id);
                contacts.add(c);
            }
        
        Test.startTest();
        
        insert contacts; 
        
        Test.stopTest();
        
        List<Case> caseTestList = new List<Case>();
        
        for(Contact c: contacts) {
            Case testCase = new Case(
                ContactId = c.Id,
                AccountId = testAccount.Id,
                Status = 'Completed',
                Origin = 'Phone');
            caseTestList.add(testCase);
        }
        
        insert caseTestList;        
        
        
        System.assertEquals('Draft', [SELECT  Status__c 
                                      FROM Account 
                                      WHERE Id = :testAccount.Id].Status__c);
        
        List<Contact> conList = [SELECT Birthdate FROM Contact WHERE Id IN :contacts];
        
        for(Contact c: conList) {
            c.Birthdate = Date.ValueOf('1988-09-21');
        }
        
        update conList;
        
        System.assertEquals('Completed', [SELECT  Status__c 
                                          FROM Account 
                                          WHERE Id = :testAccount.Id].Status__c);
        
        
        for(Case c: caseTestList) {
            c.Status = 'Working';
        }
        
        update caseTestList;
        
        System.assertEquals('Draft', [SELECT  Status__c 
                                      FROM Account 
                                      WHERE Id = :testAccount.Id].Status__c);
        
        delete caseTestList;
        
        System.assertEquals('Draft', [SELECT  Status__c 
                                      FROM Account 
                                      WHERE Id = :testAccount.Id].Status__c);
        
    }
    
    static testMethod void verifyAccountStatusOverwrittenDelete(){
        
        Account testAccount = new Account (Name = 'Test');
        insert testAccount;
        
        List<Contact> contacts = new List<Contact>{};
            
            for(Integer i = 0; i < 200; i++){
                Contact c = new Contact(LastName = 'Test Account ' + i, AccountId = testAccount.Id);
                contacts.add(c);
            }
        
        test.startTest();
        
        insert contacts; 
        
        test.stopTest();
        
        List<Case> caseTestList = new List<Case>();
        
        for(Integer i = 0; i < contacts.size(); i++) {
            Case testCase = new Case(
                ContactId = contacts.get(i).Id,
                Status = 'Completed',
                Origin = 'Phone');
            caseTestList.add(testCase);
        }
        
        insert caseTestList;        
        
        List<Contact> contactsToDelete = [SELECT Id, LastName, AccountId FROM Contact WHERE AccountId = :testAccount.Id];
        
        delete caseTestList;
        delete contactsToDelete;
        
        List<Account> insertedAccounts = [SELECT  Status__c 
                                          FROM Account 
                                          WHERE Id = :testAccount.Id];
        
        for(Integer i = 0; i <  insertedAccounts.size(); i++){
            
            System.assertEquals('Draft', insertedAccounts.get(i).Status__c);
            
        }
        
    }
    
    static testMethod void verifyAccountStatusOverwrittenLess18(){
        
        Account testAccount = new Account (Name = 'Test');
        insert testAccount;
        
        List<Contact> contacts = new List<Contact>{};
            
            for(Integer i = 0; i < 200; i++){
                Contact c = new Contact(LastName = 'Test Account ' + i, Birthdate = Date.ValueOf('1968-09-21'), AccountId = testAccount.Id);
                contacts.add(c);
            }
        
        test.startTest();
        
        insert contacts; 
        
        test.stopTest();
        
        System.assertEquals(
            'Draft',
            [SELECT Status__c 
             FROM Account 
             WHERE Id = : testAccount.Id
            ].Status__c
        );
        
        
        List<Case> caseTestList = new List<Case>();
        
        for(Integer i = 0; i < contacts.size(); i++) {
            Case testCase = new Case(
                ContactId = contacts.get(i).Id,
                Status = 'Completed',
                Origin = 'Phone');
            caseTestList.add(testCase);
        }
        
        insert caseTestList;
        
        System.assertEquals('Completed', [SELECT  Status__c 
                                          FROM Account 
                                          WHERE Id = :testAccount.Id].Status__c);
        
    }
}