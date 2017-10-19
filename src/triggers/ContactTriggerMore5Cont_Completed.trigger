trigger ContactTriggerMore5Cont_Completed on Contact (after insert, after update, after delete, after undelete) {
          
    if(Trigger.IsAfter){
        
        ContactTriggerMore5Cont_CompletedProcess 
            contactTriggerMore5Cont_CompletedProcess 
                = new ContactTriggerMore5Cont_CompletedProcess();
        
        contactTriggerMore5Cont_CompletedProcess
            .verifyAdultContactList(
                contactTriggerMore5Cont_CompletedProcess.getContactIds(Trigger.oldMap, Trigger.new)
            );
        
        contactTriggerMore5Cont_CompletedProcess
            .accountStatus_Completed_Draft(
                contactTriggerMore5Cont_CompletedProcess.getAccountIds(Trigger.oldMap, Trigger.new)
            );
        
    }
    
}