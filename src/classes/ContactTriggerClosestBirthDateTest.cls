@isTest(SeeAllData=false)
public class ContactTriggerClosestBirthDateTest {

    @testSetup static void setup() {

        Account testAccount = new Account(Name = 'TestSetup');
        insert testAccount;

        List<Contact> contacts = new List<Contact>{
        };

        for (Integer i = 1; i < 29; i++) {
            contacts.add(new Contact(
                    LastName = 'Test Contact',
                    AccountId = testAccount.Id,
                    Birthdate = Date.ValueOf('1968-09-' + i)
            ));
        }

        insert contacts;
    }

    static testmethod void verifyClosestBirthdateContactUpdate() {

        Account testAccount = [SELECT Name FROM Account WHERE Name = 'TestSetup'];

        List<Contact> contacts = [
                SELECT Id, AccountId
                FROM Contact
                WHERE AccountId = :testAccount.Id
                ORDER BY Days__c ASC
        ];


        System.assertEquals(contacts.get(0).Id, [
                SELECT ClosestBirthdayContact__c
                FROM Account
                WHERE Id = :testAccount.Id
        ].ClosestBirthdayContact__c);


        List<Contact> contactsList = [SELECT Id, LastName FROM Contact WHERE LastName = 'Test Contact 27'];

        for (Contact c : contactsList) {
            c.Birthdate = Date.ValueOf('1968-11-26');
        }

        Test.startTest();

        update contactsList;

        System.assertEquals(contacts.get(0).Id, [
                SELECT ClosestBirthdayContact__c
                FROM Account
                WHERE Id = :testAccount.Id]
                            .ClosestBirthdayContact__c);
        
        Test.stopTest();

    }

    static testmethod void verifyClosestBirthdateContactDeleteOne() {

        Account testAccount = [SELECT Name FROM Account WHERE Name = 'TestSetup'];

        List<Contact> contacts = [
                SELECT Id, AccountId
                FROM Contact
                WHERE LastName = 'Test Contact'
                ORDER BY Days__c ASC
                LIMIT 1
        ];


        System.assertEquals(contacts.get(0).Id, [
                SELECT ClosestBirthdayContact__c
                FROM Account
                WHERE Id = :testAccount.Id
        ].ClosestBirthdayContact__c);


        List<Contact> contactsList = [SELECT Id, LastName FROM Contact WHERE LastName = 'Test Contact 27'];

        for (Contact c : contactsList) {
            c.Birthdate = Date.ValueOf('1968-11-26');
        }

        Test.startTest();

        delete contactsList;

        System.assertEquals(contacts.get(0).Id, [SELECT ClosestBirthdayContact__c
                                                FROM Account
                                                WHERE Id = :testAccount.Id]
                                  .ClosestBirthdayContact__c);
        
        Test.stopTest();

    }

    static testmethod void verifyClosestBirthdateContactDeleteAll() {

        Account testAccount = [SELECT Name FROM Account WHERE Name = 'TestSetup'];

        List<Contact> contacts = [
                SELECT Id, AccountId
                FROM Contact
                WHERE LastName = 'Test Contact'
                ORDER BY Days__c ASC
                LIMIT 1
        ];


        System.assertEquals(contacts.get(0).Id, [
                SELECT ClosestBirthdayContact__c
                FROM Account
                WHERE Id = :testAccount.Id
        ].ClosestBirthdayContact__c);


        List<Contact> contactsList = [SELECT Id, LastName FROM Contact WHERE AccountId = :testAccount.Id];

        Test.startTest();

        delete contactsList;

        System.assertEquals(null, [SELECT ClosestBirthdayContact__c
                                                FROM Account
                                                WHERE Id = :testAccount.Id]
                                  .ClosestBirthdayContact__c);
        
        Test.stopTest();
    }

    static testmethod void verifyClosestBirthdateContactAccountIdNull() {

        Account testAccount = [SELECT Name FROM Account WHERE Name = 'TestSetup'];


        List<Contact> contactsList = [SELECT Id FROM CONTACT WHERE AccountId = : testAccount.Id];

        for (Contact c : contactsList) {
            c.AccountId = null;
        }

        Test.startTest();

        update contactsList;

        System.assertEquals(null, [
                SELECT ClosestBirthdateContact__c
                FROM Account
                WHERE Id = :testAccount.Id
        ]
                .ClosestBirthdateContact__c);

        Test.stopTest();

    }


    static testmethod void test() {

        Account testAccount_1 = new Account(Name = 'TestSetup1');
        Account testAccount_2 = new Account(Name = 'TestSetup2');

        insert new List<Account>{
                testAccount_1,
                testAccount_2
        };

        //related to account 1

        Contact cont_1_3 = new Contact(
                LastName = 'test2',
                Birthdate = Date.today().addYears(-9).addDays(-1), //364
                AccountId = testAccount_1.Id
        );

        Contact cont_1_1 = new Contact(
                LastName = 'test1',
                Birthdate = Date.today().addYears(-1).addDays(-2), //CLOSEST !!!!!!!!!   //363
                AccountId = testAccount_1.Id
        );

        Contact cont_1_2 = new Contact(
                LastName = 'test2',
                Birthdate = Date.today().addYears(-11).addDays(-3), //362
                AccountId = testAccount_1.Id
        );

        //related to account 2

        Contact cont_2_3 = new Contact(
                LastName = 'test4',
                Birthdate = Date.today().addYears(-20).addDays(-1),//364
                AccountId = testAccount_2.Id
        );  

        Contact cont_2_1 = new Contact(
                LastName = 'test3',
                Birthdate = Date.today().addYears(-10).addDays(-2),  //CLOSEST !!!!!!!!! //363
                AccountId = testAccount_2.Id
        );

        Contact cont_2_2 = new Contact(
                LastName = 'test4',
                Birthdate = Date.today().addYears(-40).addDays(-3), //362
                AccountId = testAccount_2.Id
        );

      

        Test.startTest();

        insert new List<Contact>{
                cont_1_1,
                cont_1_2,
                cont_1_3,
                cont_2_1,
                cont_2_2,
                cont_2_3
        };

        Test.stopTest();

        //ASSERT

        testAccount_1 = [SELECT ClosestBirthdayContact__c FROM Account WHERE Id = : testAccount_1.Id];
        testAccount_2 = [SELECT ClosestBirthdayContact__c FROM Account WHERE Id = : testAccount_2.Id];

        System.assertEquals(
            cont_1_3.Id,
            testAccount_1.ClosestBirthdayContact__c,
            'valid contact populated for acc 1'
        );

        System.assertEquals(
            cont_2_3.Id,
            testAccount_2.ClosestBirthdayContact__c,
            'valid contact populated for acc 2'
        );

    }

}