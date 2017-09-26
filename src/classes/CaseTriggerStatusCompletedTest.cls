@isTest
private class CaseTriggerStatusCompletedTest {
    
    static testmethod void verifyContactAdultCheckboxTrue(){
        
        Contact testContact = new Contact(
           
            LastName = 'Test Contact', 
            Birthdate = Date.ValueOf('1968-09-21'));
        
        	insert testContact;
        
        Case testCase = new Case(
           
            ContactId = testContact.Id,
            Status = 'Completed',
            Origin = 'Phone');
        
        	insert testCase;
        
 		System.assertEquals(true, [SELECT Id, Adult__c
                                     FROM Contact
                                     WHERE Id = :testCase.ContactId].Adult__c);
    }	
    
    
    static testmethod void verifyContactAdultCheckboxFalse(){
        
        Contact testContact = new Contact(
            LastName = 'Test Contact', 
            Birthdate = Date.ValueOf('2008-09-21'));
        
        	insert testContact;
        
        Case testCase = new Case(
            ContactId = testContact.Id,
            Status = 'Completed',
            Origin = 'Phone');
        
        	insert testCase;
        
        
        System.assertEquals(false, [SELECT Id, Adult__c
                                                      FROM Contact
                                                      WHERE Id = :testCase.ContactId].Adult__c);
        
    }
    
        static testmethod void verifyContactAdultCheckboxFalseDelete(){
        
            Contact testContact = new Contact(
                LastName = 'Test Contact', 
                Birthdate = Date.ValueOf('2008-09-21'));
            
                insert testContact;
            
            Case testCase = new Case(
                ContactId = testContact.Id,
                Status = 'Completed',
                Origin = 'Phone');
            
                insert testCase;
            
            List<Case> caseList = [SELECT Id FROM Case WHERE ContactId = :testContact.Id];
                
             Test.startTest();
                
                delete caseList;
                
             Test.stopTest();
                            
            System.assertEquals(false, [SELECT Id, Adult__c
                                                          FROM Contact
                                                          WHERE LastName = 'Test Contact'].Adult__c);
    }
    
}