
public class ShareOpportunityAccessBatch implements Database.Batchable<sObject>, Database.stateful{

    public List<SObject> insertableList { get; set; }

    public ShareOpportunityAccessBatch(List<SObject> toInsert) {
        insertableList = toInsert;
    }

    public List<SObject> start(Database.BatchableContext bc) {
        
        return insertableList;
    }

    public void execute(Database.BatchableContext bc, List<SObject> records){

        try{
            Database.insert(records,false);
        }catch(Exception e){
            System.debug('ShareOpportunityAccessBatch error: '+e.getMessage());
        }
    }

    public void finish(Database.BatchableContext bc){
        System.debug('ShareOpportunityAccessBatch completed.');
    }
}
