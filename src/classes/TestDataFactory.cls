/**
 * Created by markokullam on 07.05.2025.
 */

@IsTest
public class TestDataFactory {

    public static List<Task> createOverdueTasks(Integer count, Integer daysInPast) {
        List<Task> tasks = new List<Task>();
        for (Integer i = 0; i < count; i++) {
            tasks.add(new Task(
                    Subject = 'Task ' + i,
                    ActivityDate = Date.today().addDays(-daysInPast),
                    Status = 'In Progress'
            ));
        }
        insert tasks;
        return tasks;
    }

    public static List<Expense__c> createExpenses(Integer count) {
        List<Expense__c> expenses = new List<Expense__c>();
        for (Integer i = 0; i < count; i++) {
            expenses.add(new Expense__c(
                    Name = 'Expense ' + i
            ));
        }
        insert expenses;
        return expenses;
    }

    public static List<Expense_Item__c> createExpenseItems(Integer count, Id expenseId, Decimal amount, Boolean approved) {
        List<Expense_Item__c> expenseItems = new List<Expense_Item__c>();
        for (Integer i = 0; i < count; i++) {
            expenseItems.add(new Expense_Item__c(
                    Name = 'Expense ' + i,
                    Expense__c = expenseId,
                    Amount__c = amount,
                    Approved__c = approved
            ));
        }
        insert expenseItems;
        return expenseItems;
    }

}
