trigger CaseTriggerStatusCompleted on Case (after insert, after update, before delete,  after delete, after undelete) {
    
    CaseTriggerStatusCompletedHelper caseTriggerStatusCompletedHelper = new CaseTriggerStatusCompletedHelper();
    
    if(Trigger.isBefore) {
        
        caseTriggerStatusCompletedHelper.verifyContactStatus(
            caseTriggerStatusCompletedHelper.getContactIds(Trigger.oldMap, Trigger.new));    
    }
    
    if(Trigger.IsAfter){
        
        caseTriggerStatusCompletedHelper.verifyContactStatus(
            caseTriggerStatusCompletedHelper.getContactIds(Trigger.oldMap, Trigger.new)); 
    }
    
    
}