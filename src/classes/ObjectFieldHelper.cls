/**
 * Created by markokullam on 06.05.2025.
 */

public class ObjectFieldHelper {

    public static Set<Id> detectObjectsToRecalculate(
            Map<Id, SObject> newObjectsByIds,
            Map<Id, SObject> oldObjectsByIds,
            String checkboxFieldApiName,
            String resultFieldApiName
    ) {
        Set<Id> changedIds = new Set<Id>();
        if (newObjectsByIds == null) {
            for (SObject oldObj : oldObjectsByIds.values()) {
                changedIds.add((Id) oldObj.get(resultFieldApiName));
                return changedIds;
            }
        }
        for (SObject newObj : newObjectsByIds.values()) {
            if (oldObjectsByIds == null) {
                changedIds.add((Id) newObj.get(resultFieldApiName));
                continue;
            }

            SObject oldObj = oldObjectsByIds.get(newObj.Id);
            Boolean newVal = (Boolean) newObj.get(checkboxFieldApiName);
            Boolean oldVal = (Boolean) oldObj.get(checkboxFieldApiName);

            if (newVal != oldVal) {
                changedIds.add((Id) newObj.get(resultFieldApiName));
            }
        }

        return changedIds;
    }

}