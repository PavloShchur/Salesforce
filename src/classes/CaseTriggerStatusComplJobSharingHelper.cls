public class CaseTriggerStatusComplJobSharingHelper {

    public Set<Id> getContactIds(Map<Id, Case> oldMap, List<Case> newList) {

        Set<Id> contactIds = new Set<Id>();

        if (oldMap != null && newList != null) {

            for (Case caseNew : newList) {

                Case caseOld = oldMap.get(caseNew.Id);

                if (caseNew.Status != caseOld.Status) {
                    contactIds.add(caseNew.ContactId);
                }

                if (caseNew.ContactId != caseOld.ContactId) {

                    contactIds.add(caseNew.ContactId);
                    contactIds.add(caseOld.ContactId);
                }

            }

        } else if (newList == null) {

            for (Case caseNew : oldMap.values()) {
                contactIds.add(caseNew.ContactId);
            }

        } else if (oldMap == null) {

            for (Case caseNew : newList) {
                contactIds.add(caseNew.ContactId);
            }
        }

        contactIds.remove(null);

        return contactIds;

    }

    public Map<Id, List<Case>> verifyContactStatusJobSharing(Set<Id> contactIds) {

        if (contactIds.isEmpty()) {

            return new Map<Id, List<Case>>();

        }

        Map<Id, List<Case>> contactJobSharingMap = new Map<Id, List<Case>>();
        
        for (AggregateResult aggrResult :caseDAO.fromCaseGroupByIdStatusContactId(contactIds)) {

            Id caseId = (Id) aggrResult.get('Id');
            Id contactId = (Id) aggrResult.get('ContactId');
            
            List<Case> caseList = contactJobSharingMap.get(contactId);

            if (caseList == null) {
                caseList = new List<Case>();
            }

            caseList.add(new Case(
                    Id = caseId,
                	ContactId = contactId
            ));

            contactJobSharingMap.put(
                    contactId,
                    caseList
            );

        }

        return contactJobSharingMap;

    }

    public void startRecalculation(Set<Id> contactIds) {

        Map<Id, String> contactManualSharingMap = new Map<Id, String>();

        List<User> userList = [SELECT Id, Name FROM User];

        if (contactIds.isEmpty()) {
            return;
        }

        Map<Id, List<Case>> contactJobSharingMap = verifyContactStatusJobSharing(contactIds);
        
        for (List<Case> cases : contactJobSharingMap.values()) {
            
            if(!contactJobSharingMap.values().isEmpty()) {
                                
            Integer counter = 0;

            for (Case caseItem :cases) {
                
                    contactManualSharingMap.put(caseItem.ContactId, BaseUtilities.READ);
                    
                    counter++;
                                    
                if (counter > 3) {

                    contactManualSharingMap.put(caseItem.ContactId, BaseUtilities.EDIT);

                }

            }
                
            } else {
                
            }
            

        }

        for (Id contactId : contactManualSharingMap.keySet()) {

            for (Integer j = 0; j < userList.size(); j++) {

                ContactSharing.manualShare(contactId, userList.get(j).Id, contactManualSharingMap.get(contactId));

            }

        }

    }

}