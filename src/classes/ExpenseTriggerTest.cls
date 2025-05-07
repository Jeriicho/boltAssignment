/**
 * Created by markokullam on 07.05.2025.
 */

@IsTest
private class ExpenseTriggerTest {

    @IsTest
    public static void testUpdate_allApprovedChangedToTrue() {
        List<Expense__c> expenses = TestDataFactory.createExpenses(1);
        TestDataFactory.createExpenseItems(1, expenses.get(0).Id, 0, false);
        TestDataFactory.createExpenseItems(1, expenses.get(0).Id, 10, false);
        expenses.get(0).All_Approved__c = true;
        Test.startTest();
        TestUtils.resetTriggerControl();
        update expenses;
        List<Expense_Item__c> updatedExpenseItems = [SELECT Approved__c FROM Expense_Item__c WHERE Expense__c = :expenses.get(0).Id];
        List<Expense__c> updatedExpenses = [SELECT Total_Amount__c FROM Expense__c WHERE Id = :expenses.get(0).Id];
        Test.stopTest();
        System.assertEquals(10, updatedExpenses.get(0).Total_Amount__c);
        for (Expense_Item__c expenseItem : updatedExpenseItems) {
            System.assertEquals(true, expenseItem.Approved__c);
        }
    }

    @IsTest
    public static void testUpdate_allApprovedChangedToFalse() {
        List<Expense__c> expenses = TestDataFactory.createExpenses(1);
        TestDataFactory.createExpenseItems(1, expenses.get(0).Id, 0, true);
        TestDataFactory.createExpenseItems(1, expenses.get(0).Id, 10, true);
        expenses.get(0).All_Approved__c = false;
        Test.startTest();
        TestUtils.resetTriggerControl();
        update expenses;
        List<Expense_Item__c> updatedExpenseItems = [SELECT Approved__c FROM Expense_Item__c WHERE Expense__c = :expenses.get(0).Id];
        List<Expense__c> updatedExpenses = [SELECT Total_Amount__c FROM Expense__c WHERE Id = :expenses.get(0).Id];
        Test.stopTest();
        System.assertEquals(0, updatedExpenses.get(0).Total_Amount__c);
        for (Expense_Item__c expenseItem : updatedExpenseItems) {
            System.assertEquals(false, expenseItem.Approved__c);
        }
    }

}
