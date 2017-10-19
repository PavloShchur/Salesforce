public with sharing class ExpenseController {
    
    @AuraEnabled
    public static List<Expense__c> getExpenses() {
        
        String[] fieldsToCheck = new String[] {
            'Id', 'Name', 'Amount__c', 'Client__c', 'Date__c', 
                'Reimbursed__c', 'CreatedDate'
                };
                    
                    Map<String,Schema.SObjectField> fieldDescribeTokens = 
                    Schema.SObjectType.Expense__c.fields.getMap();
        
        for(String field : fieldsToCheck) {
            if( ! fieldDescribeTokens.get(field).getDescribe().isAccessible()) {
                throw new System.NoAccessException();
                return null;
            }
        }
        
        return [SELECT Id, Name, Amount__c, Client__c, Date__c, 
                Reimbursed__c, CreatedDate 
                FROM Expense__c];
    }
    
    @AuraEnabled
    public static Expense__c saveExpense (Expense__c expense) {
        
        System.debug('expense = ' + expense);
        upsert expense;
        System.debug('expense = ' + expense);
        
        return expense;
    }
    
}