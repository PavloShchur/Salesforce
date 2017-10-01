trigger ContactTriggerClosestBirthdate
        on Contact (after insert, after update, after delete, after undelete) {
            



    if (Trigger.isAfter) {
        
                         ContactTriggerClosestBirthdateHelper birthdateHandler =
            new ContactTriggerClosestBirthdateHelper();

        birthdateHandler.performCalculation(
            birthdateHandler.getAccountIds(
                Trigger.oldMap, 
                Trigger.new
            )
        );

    }

}