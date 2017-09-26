@isTest
public class CreateContactCalloutClassTest {
    
    public static final String APEX_SPECIALIST_URL = 'https://eu11.salesforce.com/services/data/v40.0/sobjects/Contact/'; 
    
    @isTest static void testCallout() {
        
        CreateContact c = new CreateContact();
                
        Contact con = new Contact(LastName = 'TestLastName');
        insert con;
        
        Test.startTest();
            
            Test.setMock(HttpCalloutMock.class, new CreateContactMockHttpResponseGenerator());
                
                HttpRequest__c h = [SELECT body__c,  method__c,
                    ClassNameHandler__c,
                    contact_id__c,
                    endPoint__c
                    FROM HttpRequest__c
                    WHERE contact_id__c = :con.Id];
                	
                        HttpRequest__c httpRequest = 
                    SyncService.getHttpRequestById( h.Id );
                
                Type typeItem = 
                    Type.forName( httpRequest.ClassNameHandler__c );
                
                HttpRequestResponseInterface instance = 
                    ( HttpRequestResponseInterface ) typeItem.newInstance();
        
                System.debug('httpRequest 32 = ' + httpRequest);
        
                HttpResponse res = instance.performRequest( httpRequest );
        
        		System.debug('CreateContactCalloutClassTest res 37 = ' + res);        		
        		instance.processResponse(res, httpRequest.contact_id__c);
        
        Contact contact = [SELECT sync_id__c FROM Contact WHERE Id = :httpRequest.contact_id__c];
        System.assertNotEquals(null, contact.sync_id__c);
        
        Test.stopTest();
         
        String contentType = res.getHeader('Content-Type');
        System.assert(contentType == 'application/json');
        System.assertEquals(200, res.getStatusCode());
   
        
    }
}