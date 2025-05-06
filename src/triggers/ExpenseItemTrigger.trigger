/**
 * Created by markokullam on 06.05.2025.
 */

trigger ExpenseItemTrigger on Expense_Item__c (after insert, after update, after delete, after undelete) {

    new ExpenseItemTriggerHandler().handle(Trigger.newMap, Trigger.oldMap, Trigger.operationType);

}
