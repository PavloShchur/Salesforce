@isTest
private class CaseTriggerStatusCompletedTest {
    
    @testSetup static void setup() {
        
        Contact testContact_1 = new Contact(
            LastName = 'Test Contact_1', 
            Birthdate = Date.ValueOf('1968-09-21')
        );
        
        Contact testContact_2 = new Contact(
            LastName = 'Test Contact_2', 
            Birthdate = Date.ValueOf('1968-09-21')
        );
        
        
        Contact testContact_3 = new Contact(
            LastName = 'Test Contact_3', 
            Birthdate = Date.ValueOf('1968-09-21')
        );
        
        
        insert new List<Contact> {
            testContact_1,
            testContact_2,
            testContact_3
        };
            
            
       // for testContact_1
		
         Case testCase_1_1 = new Case(
           
            ContactId = testContact_1.Id,
            Status = 'Completed',
            Origin = 'Phone'
         
         );
        
        Case testCase_1_2 = new Case(
            
            ContactId = testContact_1.Id,
            Status = 'Completed',
            Origin = 'Phone'
            
        );
        
        Case testCase_1_3 = new Case(
            
            ContactId = testContact_1.Id,
            Status = 'Completed',
            Origin = 'Phone'
            
        );
        
       // for testContact_2
		
         Case testCase_2_1 = new Case(
           
            ContactId = testContact_2.Id,
            Status = 'Completed',
            Origin = 'Phone'
         
         );
        
        Case testCase_2_2 = new Case(
            
            ContactId = testContact_2.Id,
            Status = 'Completed',
            Origin = 'Phone'
            
        );
        
        Case testCase_2_3 = new Case(
            
            ContactId = testContact_2.Id,
            Status = 'Completed',
            Origin = 'Phone'
            
        );
        
       // for testContact_3
		
         Case testCase_3_1 = new Case(
           
            ContactId = testContact_3.Id,
            Status = 'Completed',
            Origin = 'Phone'
         
         );
        
        Case testCase_3_2 = new Case(
            
            ContactId = testContact_3.Id,
            Status = 'Completed',
            Origin = 'Phone'
            
        );
        
        Case testCase_3_3 = new Case(
            
            ContactId = testContact_3.Id,
            Status = 'Completed',
            Origin = 'Phone'
            
        );
        
        insert new List<Case> {
            
            testCase_1_1,
            testCase_1_2,
            testCase_1_3,
            testCase_2_1,
            testCase_2_2,
            testCase_2_3,
            testCase_3_1,
            testCase_3_2,
            testCase_3_3
                
        };
        
    }
    
    static testmethod void verifyContactAdultCheckboxTrueInsert(){
        
        Contact testContact_1 = [SELECT Id, Adult__c FROM Contact WHERE LastName = 'Test Contact_1'];
        List<Case> testCaseList = [SELECT Id, ContactId FROM Case WHERE ContactId = :testContact_1.Id];
       
        for(Case caseItem :testCaseList) {
 
            System.assertEquals(true, [SELECT Id, Adult__c
                                     FROM Contact
                                     WHERE Id = :caseItem.ContactId].Adult__c);      
            
        }
 		
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