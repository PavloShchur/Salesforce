@isTest
private class JobSharingTest {
    
   static testMethod void testManualShareRead(){

      List<User> users = [SELECT Id FROM User WHERE IsActive = true LIMIT 2];
       
          Id User1Id = users[0].Id;
          Id User2Id = users[1].Id;
   
          Contact c = new Contact();
          c.LastName = 'Test Job';
          c.OwnerId = user1Id;
       
      insert c;
       
      	List<Contact> contactList = new List<Contact>();
       	contactList.add(c);
                
      System.assertEquals(JobSharing.manualShare(contactList, user2Id, 'read'), true);
   
          List<ContactShare> jShrs = [SELECT Id, UserOrGroupId, ContactAccessLevel, 
             RowCause FROM ContactShare WHERE ContactId IN :contactList AND UserOrGroupId= :user2Id];
          
      System.assertEquals(jShrs.size(), 1, 'Set the object\'s sharing model to Private.');
      
      System.assertEquals(jShrs[0].ContactAccessLevel, 'Read');
      System.assertEquals(jShrs[0].RowCause, 'Manual');
      System.assertEquals(jShrs[0].UserOrGroupId, user2Id);
      
      	delete c;   
   
      System.assertEquals(JobSharing.manualShare(contactList, user2Id, 'read'), false);
   }  
}