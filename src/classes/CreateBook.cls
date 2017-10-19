global class CreateBook {
    
    webservice static void createBook(String name) {
        
        Book__c book = new Book__c (
            
            Name = name
            
        );
        
        insert book;
        
    }
    
}