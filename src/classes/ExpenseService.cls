/**
 * Created by markokullam on 06.05.2025.
 */

public virtual class ExpenseService {

    public void summarizeExpenseItemsAmountWhenAllApprovedChanged(Map<Id, Expense__c> newExpensesByIds, Map<Id, Expense__c> oldExpensesByIds) {
        Set<Id> expensesToRecalculate = ObjectFieldHelper.detectObjectsToRecalculate(newExpensesByIds, oldExpensesByIds, 'All_Approved__c', 'Id');
        List<Expense__c> expensesAndExpenseItemsToRecalculate = this.getExpensesWithExpenseItems(expensesToRecalculate);
        this.recalculateExpenses(expensesAndExpenseItemsToRecalculate, newExpensesByIds);
    }

    public void updateApprovedFieldForExpenseItems(Map<Id, Expense__c> newExpensesByIds, Map<Id, Expense__c> oldExpensesByIds) {
        Set<Id> expensesToRecalculate = ObjectFieldHelper.detectObjectsToRecalculate(newExpensesByIds, oldExpensesByIds, 'All_Approved__c', 'Id');
        List<Expense__c> expensesAndExpenseItemsToRecalculate = this.getExpensesWithExpenseItems(expensesToRecalculate);
        this.recalculateExpenseItems(expensesAndExpenseItemsToRecalculate, oldExpensesByIds);
    }

    public void processExpenseItemFieldChanges(Map<Id, Expense_Item__c> newExpenseItemsByIds, Map<Id, Expense_Item__c> oldExpenseItemsByIds) {
        Set<Id> expenseIdsToRecalculate =
                ObjectFieldHelper.detectObjectsToRecalculate(newExpenseItemsByIds, oldExpenseItemsByIds, 'Approved__c', 'Expense__c');
        List<Expense__c> expensesAndExpenseItemsToRecalculate = this.getExpensesWithExpenseItems(expenseIdsToRecalculate);
        this.recalculateExpenses(expensesAndExpenseItemsToRecalculate);
    }

    @TestVisible
    private List<Expense__c> getExpensesWithExpenseItems(Set<Id> expenseIds) {
        if (expenseIds.isEmpty()) {
            return new List<Expense__c>();
        }
        return [
                SELECT Id, Total_Amount__c, All_Approved__c, (SELECT Id, Amount__c, Approved__c FROM Expense_Items__r)
                FROM Expense__c
                WHERE Id IN :expenseIds
        ];
    }

    @TestVisible
    private void recalculateExpenses(List<Expense__c> expenses, Map<Id, Expense__c> newExpensesByIds) {
        for (Expense__c expense : expenses) {
            Expense__c newExpense = newExpensesByIds.get(expense.Id);
            Boolean allApprovedChangedToTrue = !expense.All_Approved__c && newExpense.All_Approved__c;
            Decimal totalAmount = 0;
            for (Expense_Item__c expenseItem : expense.Expense_Items__r) {
                if (allApprovedChangedToTrue) {
                    totalAmount += expenseItem.Amount__c;
                }
            }
            newExpense.Total_Amount__c = totalAmount;
        }
    }

    @TestVisible
    private void recalculateExpenses(List<Expense__c> expenses) {
        Set<Expense__c> expensesToUpdate = new Set<Expense__c>();
        for (Expense__c expense : expenses) {
            Boolean approved = true;
            Decimal totalAmount = 0;
            for (Expense_Item__c expenseItem : expense.Expense_Items__r) {
                approved &= expenseItem.Approved__c;
                if (expenseItem.Approved__c) {
                    totalAmount += expenseItem.Amount__c;
                }
            }
            if (!expense.Expense_Items__r.isEmpty()) {
                expense.All_Approved__c = approved;
            }
            expense.Total_Amount__c = totalAmount;
            expensesToUpdate.add(expense);
        }
        update new List<Expense__c>(expensesToUpdate);
    }

    @TestVisible
    private void recalculateExpenseItems(List<Expense__c> expenses, Map<Id, Expense__c> oldExpensesByIds) {
        List<Expense_Item__c> expenseItemsToUpdate = new List<Expense_Item__c>();
        for (Expense__c expense : expenses) {
            Expense__c oldExpense = oldExpensesByIds.get(expense.Id);
            Boolean allApprovedChangedToTrue = expense.All_Approved__c && !oldExpense.All_Approved__c;
            for (Expense_Item__c expenseItem : expense.Expense_Items__r) {
                if (allApprovedChangedToTrue) {
                    expenseItem.Approved__c = true;
                    expenseItemsToUpdate.add(expenseItem);
                } else {
                    expenseItem.Approved__c = false;
                    expenseItemsToUpdate.add(expenseItem);
                }
            }
        }
        update expenseItemsToUpdate;
    }

}
