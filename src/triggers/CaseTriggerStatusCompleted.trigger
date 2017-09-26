trigger CaseTriggerStatusCompleted on Case (after insert, after update, before delete,  after delete, after undelete) {
    
    	CaseTriggerStatusCompletedHelper caseTriggerStatusCompletedHelper = new CaseTriggerStatusCompletedHelper();
    
            if(Trigger.isBefore) {
                
                if(Trigger.isDelete) {
                    
                    for(Case c : Trigger.Old){
                        if(c.ContactId != null){   
                            CaseTriggerStatusCompletedHelper.saveContactIds(c.ContactId);
                        }
                    }
                }
            }
    		
            if(Trigger.IsAfter){
                
                if(Trigger.IsInsert || Trigger.IsUndelete || Trigger.IsUpdate){

                    for(Case c : Trigger.new){
                        if(c.ContactId != null){
                            CaseTriggerStatusCompletedHelper.saveContactIds(c.ContactId);
                        }
                    }
                }
            
            if(Trigger.IsDelete){
                
                System.debug('Trigger.IsDelete');
                for(Case c : Trigger.Old){
                    if(c.ContactId != null){   
                        CaseTriggerStatusCompletedHelper.saveContactIds(c.ContactId);
                        }
                }
            }
        }
    
    		caseTriggerStatusCompletedHelper.verifyContactStatus();    
}