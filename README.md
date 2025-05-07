
# Instructions and limitations

## Triggers
- Handling triggered expense updates (updating Total Amount) in before trigger, handling related Expense Item updates in after trigger. Although this requires looping over the same records twice in one trigger, it saves us a DML operation.
- Classes with suffix ```TriggerHandler``` contain only handling logic (determining the type of operation and delegating business process handling to service)
- Did not add a separate ```Repository``` layer as the use-case was too simple.
- Classes with suffix ```Service``` are responsible for business logic implementation and don't know anything about trigger contexts.
- Tests are created using the ```Factory``` pattern. In a more complex scenario a generic ```Builder``` that all objects override should be preferred.

## To activate scheduler
```
String cronExp = '0 0 0 * * ?'; // Every day at 00:00
System.schedule('TaskOverdueBatchScheduler Midnight Run', cronExp, new TaskOverdueBatchScheduler());
```
