/**
 * Created by markokullam on 07.05.2025.
 */

@IsTest
private class TaskOverdueBatchTest {

    @IsTest
    public static void testPastTaskToOverdue() {
        List<Task> tasks = TestDataFactory.createOverdueTasks(20, 2);
        Test.startTest();
        TaskOverdueBatch taskOverdueBatch = new TaskOverdueBatch();
        Database.executeBatch(taskOverdueBatch, 200);
        Test.stopTest();
        List<Task> updatedTasks = [SELECT Status FROM Task WHERE Id IN :tasks];
        for (Task t : updatedTasks) {
            System.assertEquals('Overdue', t.Status);
        }
    }

    @IsTest
    public static void testFutureTasksNotChanged() {
        List<Task> tasks = TestDataFactory.createOverdueTasks(20, -2);
        Test.startTest();
        TaskOverdueBatch taskOverdueBatch = new TaskOverdueBatch();
        Database.executeBatch(taskOverdueBatch, 200);
        Test.stopTest();
        List<Task> updatedTasks = [SELECT Status FROM Task WHERE Id IN :tasks];
        for (Task t : updatedTasks) {
            System.assertEquals('In Progress', t.Status);
        }
    }

}
