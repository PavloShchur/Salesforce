@isTest
private class ContactTriggerMore5Cont_CompletedTest {
    
    static testMethod void verifyAccountStatus(){
        
        Account testAccount = new Account (Name = 'Test');
        insert testAccount;
        
        List<Contact> contacts = new List<Contact>{};
            
            for(Integer i = 0; i < 100; i++){
                Contact c = new Contact(LastName = 'Test Account ' + i, Birthdate = Date.ValueOf('1968-09-21'), AccountId = testAccount.Id);
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
        
        
            System.assertEquals('Completed', [SELECT  Status__c 
                                          FROM Account 
                                          WHERE Id = :testAccount.Id].Status__c);

    }
    
    static testMethod void verifyAccountStatusDraft_withoutAge(){
        
        Account testAccount = new Account (Name = 'Test');
        insert testAccount;
        
        List<Contact> contacts = new List<Contact>{};
            
            for(Integer i = 0; i < 100; i++){
                Contact c = new Contact(LastName = 'Test Account ' + i, Birthdate = Date.ValueOf('2008-09-21'), AccountId = testAccount.Id);
                contacts.add(c);
            }
        
        test.startTest();
        
        	insert contacts; 
        
        test.stopTest();
        
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
            
            for(Integer i = 0; i < 100; i++){
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
            
            for(Integer i = 0; i < 100; i++){
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