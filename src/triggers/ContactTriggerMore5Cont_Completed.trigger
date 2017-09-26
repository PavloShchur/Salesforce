/*
тригер 3
у акаунта создай поле статус (draft, completed).
если у акаунта больше 5 контактов, поле должно быть completed, если их станет меньше 5 - то draft
тригер 3+
у акаунта создай поле статус (draft, completed).
если у акаунта больше 5 полнолетних контактов  , поле должно быть completed, если их станет меньше 5 - то draft.
Контакт есть полнолетний, если ему 18 лет и у него есть хотя бы один рекорд Case (status=completed)
тригер 4
Шаринг сетинг для контактов - прайват.
Если у контакта есть хотя бы 1 Case рекорд (status=completed), он автоматом становится видимым всем юзерам (read only)
Если у контакта больше 3 Case рекордов - он становится editable
*/

trigger ContactTriggerMore5Cont_Completed on Contact (after insert, after update, after delete, after undelete) {
    
    System.debug('ContactTriggerMore5Cont_Completed');
        
        
    ContactTriggerMore5Cont_CompletedProcess contactTriggerMore5Cont_CompletedProcess = new ContactTriggerMore5Cont_CompletedProcess();
            
            if(Trigger.IsAfter){
                
                
                contactTriggerMore5Cont_CompletedProcess
                    .verifyAdultContactListMethod(
                            contactTriggerMore5Cont_CompletedProcess.getContactIds(Trigger.oldMap, Trigger.new)
                                        );
                
                contactTriggerMore5Cont_CompletedProcess
                    .accountStatus_Completed_Draft(
                            contactTriggerMore5Cont_CompletedProcess.getAccountIds(Trigger.oldMap, Trigger.new)
                                        );
                
            }
      
}