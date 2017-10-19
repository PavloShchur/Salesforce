trigger DeleteThisTrigger on Account (before insert, before update, before delete, after insert, after update, after delete) {
    
    
    if(Trigger.isAfter) {
        
        System.debug('DeleteThisTrigger');
        
    }
    
    
    
    
    

}