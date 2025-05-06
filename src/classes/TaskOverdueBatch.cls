/**
 * Created by markokullam on 07.05.2025.
 */

public class TaskOverdueBatch implements Database.Batchable<SObject> {

    public Database.QueryLocator start(Database.BatchableContext bc) {
        return Database.getQueryLocator([
                SELECT Id, Status, ActivityDate
                FROM Task
                WHERE IsClosed = false
                AND ActivityDate < TODAY
                AND Status != 'Overdue'
        ]);
    }

    public void execute(Database.BatchableContext bc, List<SObject> scope) {
        List<Task> tasksToUpdate = new List<Task>();
        for (Task t : (List<Task>) scope) {
            t.Status = 'Overdue';
            tasksToUpdate.add(t);
        }
        update tasksToUpdate;
    }

    public void finish(Database.BatchableContext BC) {
        // no-op
    }

}
