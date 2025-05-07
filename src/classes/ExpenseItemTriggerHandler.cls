/**
 * Created by markokullam on 06.05.2025.
 */

public with sharing class ExpenseItemTriggerHandler {

    @TestVisible
    private ExpenseService expenseService = new ExpenseService();

    public void handle(Map<Id, Expense_Item__c> newExpenseItemsMap, Map<Id, Expense_Item__c> oldExpenseItemsMap, System.TriggerOperation operationType) {
        if (operationType == System.TriggerOperation.AFTER_INSERT
                || operationType == System.TriggerOperation.AFTER_UPDATE
                || operationType == System.TriggerOperation.AFTER_DELETE
                || operationType == System.TriggerOperation.AFTER_UNDELETE) {
            if (!TriggerControl.hasRun) {
                TriggerControl.hasRun = true;
                TriggerControl.isInitializedByChildren = true;
                this.expenseService.processExpenseItemFieldChanges(newExpenseItemsMap, oldExpenseItemsMap);
            }
        }
    }

}
