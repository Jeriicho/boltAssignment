/**
 * Created by markokullam on 05.05.2025.
 */

public class ExpenseTriggerHandler {

    @TestVisible
    private ExpenseService expenseService = new ExpenseService();

    public void handle(Map<Id, Expense__c> newExpensesMap, Map<Id, Expense__c> oldExpensesMap, System.TriggerOperation operationType) {
        switch on operationType {
            when BEFORE_UPDATE {
                if (!TriggerControl.isInitializedByChildren) {
                    this.expenseService.summarizeExpenseItemsAmountWhenAllApprovedChanged(newExpensesMap, oldExpensesMap);
                }
            }
            when AFTER_UPDATE {
                if (!TriggerControl.hasRun) {
                    TriggerControl.hasRun = true;
                    this.expenseService.updateApprovedFieldForExpenseItems(newExpensesMap, oldExpensesMap);
                }
            }
        }
    }

}
