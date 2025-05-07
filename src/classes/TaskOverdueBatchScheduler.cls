/**
 * Created by markokullam on 07.05.2025.
 */

public class TaskOverdueBatchScheduler implements Schedulable {

    public void execute(SchedulableContext sc) {
        Database.executeBatch(new TaskOverdueBatch(), 200);
    }

}
