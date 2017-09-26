trigger ContactTriggerSumOfContacts on Contact (after insert, after update, after delete, after undelete) {
    
    
    ContactTriggerHelperClass contactTriggerHelperClass = new ContactTriggerHelperClass();
    
            if(Trigger.isAfter){
                
                contactTriggerHelperClass
                    .performCalculation(
                        contactTriggerHelperClass.getAccountIdsForCountCalculation(Trigger.oldMap, Trigger.new)
                    );
                
                contactTriggerHelperClass
                    .performCalculation(
                        contactTriggerHelperClass.getAccountIdsForSumCalculation(Trigger.oldMap, Trigger.new)
                    );
                
            }
}