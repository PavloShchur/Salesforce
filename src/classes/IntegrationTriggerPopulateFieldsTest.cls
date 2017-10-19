@isTest(seeAllData = false)
public class IntegrationTriggerPopulateFieldsTest {
    
    
    static testmethod void manyAccounts() {
        
        Account testAccount_1 = new Account(Name = 'N');
        Account testAccount_2 = new Account(Name = 'N');
        Account testAccount_3 = new Account(Name = 'N');
        
        insert new List<Account> {
            testAccount_1,
                testAccount_2,
                testAccount_3   
                };
                    
                    // for testAccount_1
                    
                    Contact testContact_1_1 = new Contact(
                        LastName = 'N',
                        City__c = 'C',
                        State__c = 'S',
                        Country__c = 'C',
                        AccountId = testAccount_1.Id
                    );
        
        
        Contact testContact_1_2 = new Contact(
            LastName = 'N',
            City__c = 'NOT_C',
            State__c = 'S',
            Country__c = 'C',
            AccountId = testAccount_1.Id
        );
        
        Contact testContact_1_3 = new Contact(
            LastName = 'N',
            City__c = 'C',
            State__c = 'NOT_S',
            Country__c = 'C',
            AccountId = testAccount_1.Id
        );
        
        // for testAccount_2        
        
        Contact testContact_2_1 = new Contact(
            LastName = 'N',
            City__c = 'C',
            State__c = 'S',
            Country__c = 'NOT_C',
            AccountId = testAccount_2.Id
        );
        
        
        Contact testContact_2_2 = new Contact(
            LastName = 'N',
            City__c = 'NOT_C',
            State__c = 'NOT_S',
            Country__c = 'C',
            AccountId = testAccount_2.Id
        );
        
        Contact testContact_2_3 = new Contact(
            LastName = 'N',
            City__c = 'C',
            State__c = 'State',
            Country__c = 'C',
            AccountId = testAccount_2.Id
        );
        
        // for testAccount_3
        
        Contact testContact_3_1 = new Contact(
            LastName = 'N',
            City__c = 'NOT_C',
            State__c = 'S',
            Country__c = 'C',
            AccountId = testAccount_3.Id
        );
        
        Contact testContact_3_2 = new Contact(
            LastName = 'N',
            City__c = 'City',
            State__c = 'S',
            Country__c = 'C',
            AccountId = testAccount_3.Id
        );
        
        
        Contact testContact_3_3 = new Contact(
            LastName = 'N',
            City__c = 'NOT_C',
            State__c = 'S',
            Country__c = 'C',
            AccountId = testAccount_3.Id
        );
        
        Test.startTest();
        
        insert new List<Contact> {
            testContact_1_1,
                testContact_1_2,
                testContact_1_3,
                testContact_2_1,
                testContact_2_2,
                testContact_2_3,
                testContact_3_1,
                testContact_3_2,
                testContact_3_3
        };
                    
        Test.StopTest();
        
        Integration__c integration_1 = new Integration__c(
            Name = 'N',
            City__c = 'C',
            State__c = 'S',
            Country__c = 'C'
        );
        
        Integration__c integration_2 = new Integration__c(
            Name = 'N',
            City__c = 'C',
            State__c = 'State',
            Country__c = 'C'
        );
        
        Integration__c integration_3 = new Integration__c(
            Name = 'N',
            City__c = 'City',
            State__c = 'S',
            Country__c = 'C'
        );
        
        insert new List<Integration__c> {
            integration_1,
                integration_2  ,
                integration_3
                };
                    
        Contact cont_1 = [SELECT id, City__c, State__c, Country__c, Account.Name FROM Contact WHERE Id = :testContact_1_1.Id];
        Contact cont_2 = [SELECT id, City__c, State__c, Country__c, Account.Name FROM Contact WHERE Id = :testContact_2_3.Id];
        Contact cont_3 = [SELECT id, City__c, State__c, Country__c, Account.Name FROM Contact WHERE Id = :testContact_3_2.Id];
        
        Integration__c integr_1 = [SELECT Contact__c FROM Integration__c WHERE Id =:integration_1.Id];
        Integration__c integr_2 = [SELECT Contact__c FROM Integration__c WHERE Id =:integration_2.Id];
        Integration__c integr_3 = [SELECT Contact__c FROM Integration__c WHERE Id =:integration_3.Id];
        
        
        System.assertEquals(cont_1.Id, integr_1.Contact__c);
        System.assertEquals(cont_2.Id, integr_2.Contact__c);
        System.assertEquals(cont_3.Id, integr_3.Contact__c);
        
        
    }
    
}