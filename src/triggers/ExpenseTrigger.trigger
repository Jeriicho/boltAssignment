/**
 * Created by markokullam on 05.05.2025.
 */

trigger ExpenseTrigger on Expense__c (before update, after update) {

    new ExpenseTriggerHandler().handle(Trigger.newMap, Trigger.oldMap, Trigger.operationType);

}
