public class CaseDAO {
    
    public static AggregateResult[] fromCaseGroupByIdStatusContactId(Set<Id> contactIds) {
         
        return [SELECT Id, Status, ContactId
                FROM Case
                WHERE ContactId IN :contactIds
                	AND Status = 'Completed'
                GROUP BY Id, Status, ContactId];
    }

}