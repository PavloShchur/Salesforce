trigger ContactTriggerOldestWithPriority on Contact (after insert, after update, after delete, after undelete) {


    if (Trigger.isAfter) {

        ContactTriggerOldestWithPriorityHelper priorityHandler =
                new ContactTriggerOldestWithPriorityHelper();

        priorityHandler.performCalculation(
                priorityHandler.getAccountIds(
                        Trigger.oldMap,
                        Trigger.new
                )
        );

    }
    

}