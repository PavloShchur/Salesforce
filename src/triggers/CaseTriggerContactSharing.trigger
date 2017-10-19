trigger CaseTriggerContactSharing on Case (after insert, after update, before delete,  after delete, after undelete) {
    
    CaseTriggerContactSharingHelper caseTriggerContactSharingHelper = new CaseTriggerContactSharingHelper();
    
    if(Trigger.isBefore) {
        
        caseTriggerContactSharingHelper.verifyContactStatusJobSharing(
            caseTriggerContactSharingHelper.getContactIds(Trigger.oldMap, Trigger.new));    
    }
    
    if(Trigger.IsAfter){
        
        caseTriggerContactSharingHelper.verifyContactStatusJobSharing(
            caseTriggerContactSharingHelper.getContactIds(Trigger.oldMap, Trigger.new)); 
    }
    
    
}