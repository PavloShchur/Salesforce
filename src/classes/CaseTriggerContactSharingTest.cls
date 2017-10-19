@isTest
public class CaseTriggerContactSharingTest {
    
    @testSetup static void setup() {
        
        List<User> users = [SELECT Id FROM User WHERE IsActive = true LIMIT 2];

        Id User1Id = users[0].Id;
        Id User2Id = users[1].Id;

        Contact cont_1 = new Contact(
                LastName = 'Test Job',
                OwnerId = user1Id,
            	Email = 'cont_1@gmail.com'
        );

        Contact cont_2 = new Contact(
                LastName = 'Test Job',
                OwnerId = user1Id,
            	Email = 'cont_2@gmail.com'
        );
        
        Contact cont_3 = new Contact(
                LastName = 'Test Job',
                OwnerId = user1Id,
            	Email = 'cont_3@gmail.com'
        );

        insert new List<Contact> {
                cont_1,
                cont_2,
                cont_3
        };

        // for cont_1

        Case cs_1_1 = new Case(
                ContactId = cont_1.Id,
                Status = 'Completed',
                Origin = 'Phone');

        Case cs_1_2 = new Case(
                ContactId = cont_1.Id,
                Status = 'Completed',
                Origin = 'Phone');

        Case cs_1_3 = new Case(
                ContactId = cont_1.Id,
                Status = 'Completed',
                Origin = 'Phone');

        insert new List<Case> {
                cs_1_1,
                cs_1_2,
                cs_1_3
        };

        // for cont_2

        Case cs_2_1 = new Case(
                ContactId = cont_2.Id,
                Status = 'Completed',
                Origin = 'Phone');

        Case cs_2_2 = new Case(
                ContactId = cont_2.Id,
                Status = 'Completed',
                Origin = 'Phone');

        Case cs_2_3 = new Case(
                ContactId = cont_2.Id,
                Status = 'Completed',
                Origin = 'Phone');

        
        insert new List<Case> {
                cs_2_1,
                cs_2_2,
                cs_2_3
        };
            
        // for cont_3

        Case cs_3_1 = new Case(
                ContactId = cont_3.Id,
                Status = 'Completed',
                Origin = 'Phone');

        Case cs_3_2 = new Case(
                ContactId = cont_3.Id,
                Status = 'Completed',
                Origin = 'Phone');

        Case cs_3_3 = new Case(
                ContactId = cont_3.Id,
                Status = 'Completed',
                Origin = 'Phone');

        
        insert new List<Case> {
                cs_3_1,
                cs_3_2,
                cs_3_3
        };
                
    }

    static testMethod void testContactWithOneCaseSharingReadInsert() {

        List<User> users = [SELECT Id FROM User WHERE IsActive = true LIMIT 2];

        Id User1Id = users[0].Id;
        Id User2Id = users[1].Id;

        List<Contact> contactList = [SELECT Id FROM Contact WHERE LastName = 'Test Job'];

        Contact contact_1 = [SELECT Id FROM Contact WHERE Email = 'cont_1@gmail.com'];
        Contact contact_2 = [SELECT Id FROM Contact WHERE Email = 'cont_2@gmail.com'];

        System.assertEquals(ContactSharing.manualShare(contact_1.Id, user2Id, 'read'), true);
        System.assertEquals(ContactSharing.manualShare(contact_2.Id, user2Id, 'read'), true);

        List<ContactShare> jShrs = [SELECT Id, UserOrGroupId, ContactAccessLevel,
                RowCause FROM ContactShare WHERE ContactId IN :contactList AND UserOrGroupId= :user2Id];

        System.assertEquals(jShrs.size(), 2, 'Set the object\'s sharing model to Private.');

        System.assertEquals(jShrs[0].ContactAccessLevel, 'Read');
        System.assertEquals(jShrs[0].RowCause, 'Manual');
        System.assertEquals(jShrs[0].UserOrGroupId, user2Id);

    }

    static testMethod void testContactWithOneCaseSharingReadUpdate() {


        List<User> users = [SELECT Id FROM User WHERE IsActive = true LIMIT 2];

        Id User1Id = users[0].Id;
        Id User2Id = users[1].Id;

        List<Contact> contactList = [SELECT Id FROM Contact WHERE LastName = 'Test Job'];

        Contact contact_1 = [SELECT Id FROM Contact WHERE Email = 'cont_1@gmail.com'];
        Contact contact_2 = [SELECT Id FROM Contact WHERE Email = 'cont_2@gmail.com'];

        System.assertEquals(ContactSharing.manualShare(contact_1.Id, user2Id, 'read'), true);
        System.assertEquals(ContactSharing.manualShare(contact_2.Id, user2Id, 'read'), true);

        List<ContactShare> jShrs = [SELECT Id, UserOrGroupId, ContactAccessLevel,
                RowCause FROM ContactShare WHERE ContactId IN :contactList AND UserOrGroupId= :user2Id];

        System.assertEquals(jShrs.size(), 2, 'Set the object\'s sharing model to Private.');

        System.assertEquals(jShrs[0].ContactAccessLevel, 'Read');
        System.assertEquals(jShrs[0].RowCause, 'Manual');
        System.assertEquals(jShrs[0].UserOrGroupId, user2Id);

        List<Case> caseListToDeleteForCont_2 = [SELECT Id FROM Case WHERE ContactId = :contact_2.Id];

        for(Case caseToUpdate :caseListToDeleteForCont_2) {

            caseToUpdate.Status = 'Completed';

        }

        update caseListToDeleteForCont_2;

        System.assertEquals(ContactSharing.manualShare(contact_2.Id, user2Id, 'read'), true);


    }

    static testMethod void testContactWithOneCaseSharingReadDelete() {

        List<User> users = [SELECT Id FROM User WHERE IsActive = true LIMIT 2];

        Id User1Id = users[0].Id;
        Id User2Id = users[1].Id;

        List<Contact> contactList = [SELECT Id FROM Contact WHERE LastName = 'Test Job'];

        Contact contact_1 = [SELECT Id FROM Contact WHERE Email = 'cont_1@gmail.com'];
        Contact contact_2 = [SELECT Id FROM Contact WHERE Email = 'cont_2@gmail.com'];
        Contact contact_3 = [SELECT Id FROM Contact WHERE Email = 'cont_3@gmail.com'];
        
        System.assertEquals(ContactSharing.manualShare(contact_1.Id, user2Id, 'read'), true);
        System.assertEquals(ContactSharing.manualShare(contact_2.Id, user2Id, 'read'), true);
        System.assertEquals(ContactSharing.manualShare(contact_3.Id, user2Id, 'read'), true);

        List<ContactShare> jShrs = [SELECT Id, UserOrGroupId, ContactAccessLevel,
                RowCause FROM ContactShare WHERE ContactId IN :contactList AND UserOrGroupId= :user2Id];

        System.assertEquals(jShrs.size(), 3, 'Set the object\'s sharing model to Private.');

        System.assertEquals(jShrs[0].ContactAccessLevel, 'Read');
        System.assertEquals(jShrs[0].RowCause, 'Manual');
        System.assertEquals(jShrs[0].UserOrGroupId, user2Id);
        
        List<Case> caseListToDelete = [SELECT Id FROM Case WHERE ContactId = :contact_2.Id];
        List<Contact> contactListToDelete = [SELECT Id FROM Contact WHERE Id = :contact_2.Id];

        delete caseListToDelete;
        delete contactListToDelete;

        System.assertEquals(ContactSharing.manualShare(contact_2.Id, user2Id, 'read'), false);


    }
    
    
        static testMethod void testContactWithOneCaseSharingEditInsert() {

      
        List<User> users = [SELECT Id FROM User WHERE IsActive = true LIMIT 2];

        Id User1Id = users[0].Id;
        Id User2Id = users[1].Id;

        List<Contact> contactList = [SELECT Id FROM Contact WHERE LastName = 'Test Job'];

        Contact contact_1 = [SELECT Id FROM Contact WHERE Email = 'cont_1@gmail.com'];
        Contact contact_2 = [SELECT Id FROM Contact WHERE Email = 'cont_2@gmail.com'];
        Contact contact_3 = [SELECT Id FROM Contact WHERE Email = 'cont_3@gmail.com'];
       

        System.assertEquals(ContactSharing.manualShare(contact_1.Id, user2Id, 'edit'), true);
        System.assertEquals(ContactSharing.manualShare(contact_2.Id, user2Id, 'edit'), true);

        List<ContactShare> jShrs = [SELECT Id, UserOrGroupId, ContactAccessLevel,
                RowCause FROM ContactShare WHERE ContactId IN :contactList AND UserOrGroupId= :user2Id];

        System.assertEquals(jShrs.size(), 2, 'Set the object\'s sharing model to Private.');

        System.assertEquals(jShrs[0].ContactAccessLevel, 'Edit');
        System.assertEquals(jShrs[0].RowCause, 'Manual');
        System.assertEquals(jShrs[0].UserOrGroupId, user2Id);

    }
    
        static testMethod void testContactWithOneCaseSharingEditUpdate() {

        List<User> users = [SELECT Id FROM User WHERE IsActive = true LIMIT 2];

        Id User1Id = users[0].Id;
        Id User2Id = users[1].Id;

        List<Contact> contactList = [SELECT Id FROM Contact WHERE LastName = 'Test Job'];

        Contact contact_1 = [SELECT Id FROM Contact WHERE Email = 'cont_1@gmail.com'];
        Contact contact_2 = [SELECT Id FROM Contact WHERE Email = 'cont_2@gmail.com'];
            
        System.assertEquals(ContactSharing.manualShare(contact_1.Id, user2Id, 'edit'), true);
        System.assertEquals(ContactSharing.manualShare(contact_2.Id, user2Id, 'edit'), true);

        List<ContactShare> jShrs = [SELECT Id, UserOrGroupId, ContactAccessLevel,
                RowCause FROM ContactShare WHERE ContactId IN :contactList AND UserOrGroupId= :user2Id];

        System.assertEquals(jShrs.size(), 2, 'Set the object\'s sharing model to Private.');

        System.assertEquals(jShrs[0].ContactAccessLevel, 'Edit');
        System.assertEquals(jShrs[0].RowCause, 'Manual');
        System.assertEquals(jShrs[0].UserOrGroupId, user2Id);

        List<Case> caseListToDeleteForCont_2 = [SELECT Id FROM Case WHERE ContactId = :contact_2.Id];

        for(Case caseToUpdate :caseListToDeleteForCont_2) {

            caseToUpdate.Status = 'Completed';

        }

        update caseListToDeleteForCont_2;

        System.assertEquals(ContactSharing.manualShare(contact_2.Id, user2Id, 'edit'), true);


    }
    
        static testMethod void testContactWithOneCaseSharingEditDelete() {

               List<User> users = [SELECT Id FROM User WHERE IsActive = true LIMIT 2];

        Id User1Id = users[0].Id;
        Id User2Id = users[1].Id;

        List<Contact> contactList = [SELECT Id FROM Contact WHERE LastName = 'Test Job'];

        Contact contact_1 = [SELECT Id FROM Contact WHERE Email = 'cont_1@gmail.com'];
        Contact contact_2 = [SELECT Id FROM Contact WHERE Email = 'cont_2@gmail.com'];
        Contact contact_3 = [SELECT Id FROM Contact WHERE Email = 'cont_3@gmail.com'];
            
        System.assertEquals(ContactSharing.manualShare(contact_1.Id, user2Id, 'edit'), true);
        System.assertEquals(ContactSharing.manualShare(contact_2.Id, user2Id, 'edit'), true);
        System.assertEquals(ContactSharing.manualShare(contact_3.Id, user2Id, 'edit'), true);

        List<ContactShare> jShrs = [SELECT Id, UserOrGroupId, ContactAccessLevel,
                RowCause FROM ContactShare WHERE ContactId IN :contactList AND UserOrGroupId= :user2Id];

        System.assertEquals(jShrs.size(), 3, 'Set the object\'s sharing model to Private.');

        System.assertEquals(jShrs[0].ContactAccessLevel, 'Edit');
        System.assertEquals(jShrs[0].RowCause, 'Manual');
        System.assertEquals(jShrs[0].UserOrGroupId, user2Id);
        
        List<Case> caseListToDelete = [SELECT Id FROM Case WHERE ContactId = :contact_2.Id];
        List<Contact> contactListToDelete = [SELECT Id FROM Contact WHERE Id = :contact_2.Id];

        delete caseListToDelete;
        delete contactListToDelete;

        System.assertEquals(ContactSharing.manualShare(contact_2.Id, user2Id, 'edit'), false);


    }

}