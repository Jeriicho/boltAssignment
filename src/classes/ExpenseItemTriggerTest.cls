/**
 * Created by markokullam on 07.05.2025.
 */

@IsTest
private class ExpenseItemTriggerTest {

    @IsTest
    public static void testInsert_approved() {
        List<Expense__c> expenses = TestDataFactory.createExpenses(1);
        Test.startTest();
        TestUtils.resetTriggerControl();
        TestDataFactory.createExpenseItems(1, expenses.get(0).Id, 10, true);
        Test.stopTest();
        List<Expense__c> updatedExpenses = [SELECT Total_Amount__c, All_Approved__c FROM Expense__c WHERE Id IN :expenses];
        System.assertEquals(10, updatedExpenses.get(0).Total_Amount__c);
        System.assertEquals(true, updatedExpenses.get(0).All_Approved__c);
    }

    @IsTest
    public static void testInsert_notApproved() {
        List<Expense__c> expenses = TestDataFactory.createExpenses(1);
        Test.startTest();
        TestUtils.resetTriggerControl();
        TestDataFactory.createExpenseItems(1, expenses.get(0).Id, 10, false);
        Test.stopTest();
        List<Expense__c> updatedExpenses = [SELECT Total_Amount__c, All_Approved__c FROM Expense__c WHERE Id IN :expenses];
        System.assertEquals(0, updatedExpenses.get(0).Total_Amount__c);
        System.assertEquals(false, updatedExpenses.get(0).All_Approved__c);
    }

    @IsTest
    public static void testUpdate_approved() {
        List<Expense__c> expenses = TestDataFactory.createExpenses(1);
        List<Expense_Item__c> expenseItems = TestDataFactory.createExpenseItems(1, expenses.get(0).Id, 10, false);
        expenseItems.get(0).Amount__c = 20;
        expenseItems.get(0).Approved__c = true;
        Test.startTest();
        TestUtils.resetTriggerControl();
        update expenseItems;
        Test.stopTest();
        List<Expense__c> updatedExpenses = [SELECT Total_Amount__c, All_Approved__c FROM Expense__c WHERE Id IN :expenses];
        System.assertEquals(20, updatedExpenses.get(0).Total_Amount__c);
        System.assertEquals(true, updatedExpenses.get(0).All_Approved__c);
    }

    @IsTest
    public static void testUpdate_notApproved() {
        List<Expense__c> expenses = TestDataFactory.createExpenses(1);
        List<Expense_Item__c> expenseItems = TestDataFactory.createExpenseItems(1, expenses.get(0).Id, 10, true);
        expenseItems.get(0).Amount__c = 20;
        expenseItems.get(0).Approved__c = false;
        Test.startTest();
        TestUtils.resetTriggerControl();
        update expenseItems;
        Test.stopTest();
        List<Expense__c> updatedExpenses = [SELECT Total_Amount__c, All_Approved__c FROM Expense__c WHERE Id IN :expenses];
        System.assertEquals(0, updatedExpenses.get(0).Total_Amount__c);
        System.assertEquals(false, updatedExpenses.get(0).All_Approved__c);
    }

    @IsTest
    public static void testDelete_approved() {
        List<Expense__c> expenses = TestDataFactory.createExpenses(1);
        List<Expense_Item__c> expenseItems = TestDataFactory.createExpenseItems(1, expenses.get(0).Id, 10, true);
        TestDataFactory.createExpenseItems(1, expenses.get(0).Id, 10, false);
        Test.startTest();
        TestUtils.resetTriggerControl();
        delete expenseItems;
        Test.stopTest();
        List<Expense__c> updatedExpenses = [SELECT Total_Amount__c, All_Approved__c FROM Expense__c WHERE Id IN :expenses];
        System.assertEquals(0, updatedExpenses.get(0).Total_Amount__c);
        System.assertEquals(false, updatedExpenses.get(0).All_Approved__c);
    }

    @IsTest
    public static void testDelete_notApproved() {
        List<Expense__c> expenses = TestDataFactory.createExpenses(1);
        List<Expense_Item__c> expenseItems = TestDataFactory.createExpenseItems(1, expenses.get(0).Id, 10, false);
        TestDataFactory.createExpenseItems(1, expenses.get(0).Id, 10, true);
        Test.startTest();
        TestUtils.resetTriggerControl();
        delete expenseItems;
        Test.stopTest();
        List<Expense__c> updatedExpenses = [SELECT Total_Amount__c, All_Approved__c FROM Expense__c WHERE Id IN :expenses];
        System.assertEquals(10, updatedExpenses.get(0).Total_Amount__c);
        System.assertEquals(true, updatedExpenses.get(0).All_Approved__c);
    }

    @IsTest
    public static void testUndelete_approved() {
        List<Expense__c> expenses = TestDataFactory.createExpenses(1);
        List<Expense_Item__c> expenseItems = TestDataFactory.createExpenseItems(1, expenses.get(0).Id, 10, true);
        delete expenseItems;
        Test.startTest();
        TestUtils.resetTriggerControl();
        undelete expenseItems;
        Test.stopTest();
        List<Expense__c> updatedExpenses = [SELECT Total_Amount__c, All_Approved__c FROM Expense__c WHERE Id IN :expenses];
        System.assertEquals(10, updatedExpenses.get(0).Total_Amount__c);
        System.assertEquals(true, updatedExpenses.get(0).All_Approved__c);
    }

    @IsTest
    public static void testUndelete_notApproved() {
        List<Expense__c> expenses = TestDataFactory.createExpenses(1);
        List<Expense_Item__c> expenseItems = TestDataFactory.createExpenseItems(1, expenses.get(0).Id, 10, false);
        delete expenseItems;
        Test.startTest();
        TestUtils.resetTriggerControl();
        undelete expenseItems;
        Test.stopTest();
        List<Expense__c> updatedExpenses = [SELECT Total_Amount__c, All_Approved__c FROM Expense__c WHERE Id IN :expenses];
        System.assertEquals(0, updatedExpenses.get(0).Total_Amount__c);
        System.assertEquals(false, updatedExpenses.get(0).All_Approved__c);
    }

}
