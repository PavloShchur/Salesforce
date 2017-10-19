trigger Status on Contact (before insert, before update, before delete, after insert, after update, after delete) {
    
    
    
    if(Trigger.isAfter) {
        
        System.debug('ContactDeleteThisTrigger');
        
        for(Contact c :[SELECT Status__c FROM Contact WHERE Id IN :Trigger.new]) {
            c.Status__c = 1;
            
            update c;
            System.debug('c = ' + c);
        }
        
        
        
    }
}