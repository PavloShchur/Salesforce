public class CreateContact implements HttpRequestResponseInterface {
    
    public static final String APEX_SPECIALIST_URL = 'https://eu11.salesforce.com/services/data/v40.0/sobjects/Contact/';
    
    public CreateContact( ) {        
    }    
    
    public HttpRequest__c getRequestObject( Id objectId ) {
        
        Contact cont = 
            [SELECT Id,
             FirstName,
             LastName
             FROM Contact 
             WHERE Id = :objectId];
        
        SyncDTO createContact = new SyncDTO();        
        
        httpRequest = new HttpRequest__c(
            method__c = 'POST',
            ClassNameHandler__c = 'CreateContact',
            contact_id__c = cont.id,
            endPoint__c = APEX_SPECIALIST_URL,
            body__c = createContact.toMap(cont.FirstName, cont.LastName)
        );
        
        try{
            insert httpRequest;
        } catch(Exception e) {
            System.debug(e.getMessage());
        }
        
        return httpRequest;
    }  
    
    HttpRequest__c httpRequest;
    
    public HttpResponse performRequest (HttpRequest__c httpRequest) {
            
            System.debug('performRequest httpRequest = ' + httpRequest);
            Http http = new Http();
            HttpRequest request = new HttpRequest();
            HttpResponse response = new HttpResponse();
            
    /*        response = GetSecurityTokenClass.getSecurityToken();
            
            AccessTokenDTO tokenDTO = 
                (AccessTokenDTO) JSON.deserialize(response.getBody(), AccessTokenDTO.class );
            
                request.setHeader('Authorization',
                                  'Bearer ' + tokenDTO.access_token);
    */
                request.setHeader('Authorization',
                                  'Bearer ' + 'auf253100vbnc45I25vY5eRCPSPnQxXCmNgrhbW');
                request.setHeader('Content-Type',
                                  'application/json');
                request.setMethod(httpRequest.method__c);
                request.setEndpoint(httpRequest.endPoint__c);
                request.setBody(httpRequest.body__c);
                System.debug('performRequest');
            
            response = http.send(request);
            System.debug('performRequest response = ' + response);
        
        return response;  
    } 
    
    public void processResponse(HttpResponse someHttpResponse, Id contactId) {
        AccessIdDTO responseDTO = 
            (AccessIdDTO) 
            JSON.deserialize(
                someHttpResponse.getBody(), 
                AccessIdDTO.class
            );
        
        Contact contactItem = [SELECT Id,
                               sync_id__c,
                               SyncStatus__c
                               FROM Contact
                               WHERE Id = :contactId];
        contactItem.sync_id__c = responseDTO.id;
        
        if(isSuccessStatus(someHttpResponse.getStatusCode())) {  
            
            HttpRequest__c httpRequest = [SELECT Id, Synchronized__c FROM HttpRequest__c WHERE contact_id__c = :contactId];
            httpRequest.Synchronized__c = true;
            
            try{
                update httpRequest;            
            } catch(DMLException e) {
                System.debug('An unexpected error has occurred: ' + e.getMessage());
            } 
            
            contactItem.SyncStatus__c = 'Completed';
            
            try{
                update contactItem;
            } catch(DMLException e) {
                System.debug('An unexpected error has occurred: ' + e.getMessage());
            }  
            
        } else {
            System.debug('Strart Batch');
        }       
    }
    
    private Boolean isSuccessStatus( Integer statusNumber ){
        return 
            statusNumber >= 200
            ||
            statusNumber <= 204;
    }
    
    
    private class AccessIdDTO {
        public String id;
    }
    private class AccessTokenDTO {
        public String access_token;
    }
}