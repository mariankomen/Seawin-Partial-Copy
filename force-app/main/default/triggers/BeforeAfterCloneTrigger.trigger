trigger BeforeAfterCloneTrigger on Opportunity (before insert, after insert) {
    if(trigger.isInsert){
        if(trigger.isBefore){
            for(Opportunity opp : Trigger.New) {   
                //System.debug('trigger.New before is: ' + Trigger.New);
                if(opp.isClone() && opp.Type == 'Template'){
                    BeforeAfterCloneHandler.ProcessBefore(Trigger.New);
                  //  System.debug('trigger.New 2 before is: ' + Trigger.New);
                }
            }  
        }
        else if(trigger.isAfter){
            
            for(Opportunity opp : Trigger.New) {
                
                if(opp.isClone() && opp.Type == 'Template'){
                    BeforeAfterCloneHandler.ProcessAfter(Trigger.New);
                    System.debug('after if');
                }
                else{
                    System.debug('after else');
                    BeforeAfterCloneHandler.ProcessAfterNotClonedAndTemplate(Trigger.New);
                }
            }
        }
    }
}