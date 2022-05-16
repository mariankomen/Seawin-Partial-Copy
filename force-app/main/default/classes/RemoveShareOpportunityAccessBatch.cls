public class RemoveShareOpportunityAccessBatch implements Database.Batchable<sObject>, Database.stateful{

    public List<SObject> deletableList { get; set; }

    public RemoveShareOpportunityAccessBatch(List<SObject> toInsert) {
        deletableList = toInsert;
    }

    public List<SObject> start(Database.BatchableContext bc) {
        
        return deletableList;
    }

    public void execute(Database.BatchableContext bc, List<SObject> records){

        try{
            delete records;
        }catch(Exception e){
            System.debug('RemoveShareOpportunityAccessBatch error: '+e.getMessage());
        }
    }

    public void finish(Database.BatchableContext bc){
        System.debug('RemoveShareOpportunityAccessBatch completed.');
    }
}
