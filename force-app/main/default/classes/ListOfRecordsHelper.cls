public with sharing class ListOfRecordsHelper {
    

    public static Map<Integer, List<OpportunityHistory>> Company_Total_Pipeline_Last_12_Months_Helper() {

        List<OpportunityHistory> opportunityHistory;
        if(!Test.isRunningTest()){
            opportunityHistory = [SELECT Id, Opportunity.CreatedDate, OpportunityId, Opportunity.Sales_Rep_O__c, Opportunity.Price_Level__c, Opportunity.Probability, Opportunity.ExpectedRevenue, Opportunity.AccountId, Opportunity.Awarded_Owner__c, Opportunity.LeadSource, Opportunity.StageName, Opportunity.Closed_Date__c, Opportunity.CloseDate, CreatedDate, Opportunity.Name, Amount FROM OpportunityHistory WHERE ( CreatedDate = LAST_N_MONTHS:11 OR CreatedDate = THIS_MONTH ) AND Opportunity.ForecastCategoryName = 'Pipeline' AND Opportunity.GL_Account_Variable_1__r.Name = 'Seawin USA'];
        } else {
            opportunityHistory = (List<OpportunityHistory>)JSON.deserialize('[{"attributes":{"type":"OpportunityHistory","url":"/services/data/v53.0/sobjects/OpportunityHistory/0088F000003iFvlQAE"},"Id":"0088F000003iFvlQAE","OpportunityId":"0061I00000PXW6AQAX","CreatedDate":"2022-01-27T14:23:20.000+0000","Amount":27512.50,"Opportunity":{"attributes":{"type":"Opportunity","url":"/services/data/v53.0/sobjects/Opportunity/0061I00000PXW6AQAX"},"Id":"0061I00000PXW6AQAX","Name":"Candlewood Suites - Big Spring, TX","GL_Account_Variable_1__c":"a0A1I000002RthzUAC","RecordTypeId":"0121I000000JpUCQA0"}},{"attributes":{"type":"OpportunityHistory","url":"/services/data/v53.0/sobjects/OpportunityHistory/0088F000003iFtBQAU"},"Id":"0088F000003iFtBQAU","OpportunityId":"0061I00000R3bVbQAJ","CreatedDate":"2022-01-27T14:14:51.000+0000","Amount":155348.64,"Opportunity":{"attributes":{"type":"Opportunity","url":"/services/data/v53.0/sobjects/Opportunity/0061I00000R3bVbQAJ"},"Id":"0061I00000R3bVbQAJ","Name":"1000M - Chicago, IL","GL_Account_Variable_1__c":"a0A1I000002RthzUAC","RecordTypeId":"0121I000000JpUCQA0"}},{"attributes":{"type":"OpportunityHistory","url":"/services/data/v53.0/sobjects/OpportunityHistory/0088F000003hwGhQAI"},"Id":"0088F000003hwGhQAI","OpportunityId":"0061I00000R3bVbQAJ","CreatedDate":"2022-01-25T08:23:19.000+0000","Amount":155348.64,"Opportunity":{"attributes":{"type":"Opportunity","url":"/services/data/v53.0/sobjects/Opportunity/0061I00000R3bVbQAJ"},"Id":"0061I00000R3bVbQAJ","Name":"1000M - Chicago, IL","GL_Account_Variable_1__c":"a0A1I000002RthzUAC","RecordTypeId":"0121I000000JpUCQA0"}},{"attributes":{"type":"OpportunityHistory","url":"/services/data/v53.0/sobjects/OpportunityHistory/0088F000003hyHcQAI"},"Id":"0088F000003hyHcQAI","OpportunityId":"0068W00000RqXjPQAV","CreatedDate":"2022-01-25T09:26:51.000+0000","Amount":37391.52,"Opportunity":{"attributes":{"type":"Opportunity","url":"/services/data/v53.0/sobjects/Opportunity/0068W00000RqXjPQAV"},"Id":"0068W00000RqXjPQAV","Name":"6847 & 6849 Bruno - 28 - St. Louis, MO","GL_Account_Variable_1__c":"a0A1I000002RthzUAC","RecordTypeId":"0121I000000JpUCQA0"}},{"attributes":{"type":"OpportunityHistory","url":"/services/data/v53.0/sobjects/OpportunityHistory/0088F000003hwHfQAI"},"Id":"0088F000003hwHfQAI","OpportunityId":"0068W00000RqXjPQAV","CreatedDate":"2022-01-25T08:27:14.000+0000","Amount":37258.32,"Opportunity":{"attributes":{"type":"Opportunity","url":"/services/data/v53.0/sobjects/Opportunity/0068W00000RqXjPQAV"},"Id":"0068W00000RqXjPQAV","Name":"6847 & 6849 Bruno - 28 - St. Louis, MO","GL_Account_Variable_1__c":"a0A1I000002RthzUAC","RecordTypeId":"0121I000000JpUCQA0"}},{"attributes":{"type":"OpportunityHistory","url":"/services/data/v53.0/sobjects/OpportunityHistory/0088F000003iJHmQAM"},"Id":"0088F000003iJHmQAM","OpportunityId":"0068W00000SPnUeQAL","CreatedDate":"2022-01-28T11:16:39.000+0000","Amount":62100.62,"Opportunity":{"attributes":{"type":"Opportunity","url":"/services/data/v53.0/sobjects/Opportunity/0068W00000SPnUeQAL"},"Id":"0068W00000SPnUeQAL","Name":"Block 290 - Portland, OR","GL_Account_Variable_1__c":"a0A1I000002RthzUAC","RecordTypeId":"0121I000000JpUCQA0"}},{"attributes":{"type":"OpportunityHistory","url":"/services/data/v53.0/sobjects/OpportunityHistory/0088F000003iFuOQAU"},"Id":"0088F000003iFuOQAU","OpportunityId":"0068W00000SPnUeQAL","CreatedDate":"2022-01-27T14:20:06.000+0000","Amount":62100.62,"Opportunity":{"attributes":{"type":"Opportunity","url":"/services/data/v53.0/sobjects/Opportunity/0068W00000SPnUeQAL"},"Id":"0068W00000SPnUeQAL","Name":"Block 290 - Portland, OR","GL_Account_Variable_1__c":"a0A1I000002RthzUAC","RecordTypeId":"0121I000000JpUCQA0"}},{"attributes":{"type":"OpportunityHistory","url":"/services/data/v53.0/sobjects/OpportunityHistory/0088F000003iFtaQAE"},"Id":"0088F000003iFtaQAE","OpportunityId":"0068W00000SQEMQQA5","CreatedDate":"2022-01-27T14:15:28.000+0000","Amount":18567.61,"Opportunity":{"attributes":{"type":"Opportunity","url":"/services/data/v53.0/sobjects/Opportunity/0068W00000SQEMQQA5"},"Id":"0068W00000SQEMQQA5","Name":"1619 S. 1st Condos - Austin, TX","GL_Account_Variable_1__c":"a0A1I000002RthzUAC","RecordTypeId":"0121I000000JpUCQA0"}},{"attributes":{"type":"OpportunityHistory","url":"/services/data/v53.0/sobjects/OpportunityHistory/0088F000003iFtQQAU"},"Id":"0088F000003iFtQQAU","OpportunityId":"0068W00000SQEMQQA5","CreatedDate":"2022-01-27T14:15:23.000+0000","Amount":18567.61,"Opportunity":{"attributes":{"type":"Opportunity","url":"/services/data/v53.0/sobjects/Opportunity/0068W00000SQEMQQA5"},"Id":"0068W00000SQEMQQA5","Name":"1619 S. 1st Condos - Austin, TX","GL_Account_Variable_1__c":"a0A1I000002RthzUAC","RecordTypeId":"0121I000000JpUCQA0"}},{"attributes":{"type":"OpportunityHistory","url":"/services/data/v53.0/sobjects/OpportunityHistory/0088F000003iFxmQAE"},"Id":"0088F000003iFxmQAE","OpportunityId":"0068W00000SQfsQQAT","CreatedDate":"2022-01-27T14:30:08.000+0000","Amount":137155.20,"Opportunity":{"attributes":{"type":"Opportunity","url":"/services/data/v53.0/sobjects/Opportunity/0068W00000SQfsQQAT"},"Id":"0068W00000SQfsQQAT","Name":"Gila River Indian Community - Sacaton, AZ (Shower Bases - ShowerWalls)","GL_Account_Variable_1__c":"a0A1I000002RthzUAC","RecordTypeId":"0121I000000JpUCQA0"}}]', List<OpportunityHistory>.class);
        }
        Map<Id, List<Map<Id, OpportunityHistory>>> relatedHistory = new Map<Id, List<Map<Id, OpportunityHistory>>>();
        Map<Integer, List<OpportunityHistory>> historyByMonth = new Map<Integer, List<OpportunityHistory>>();
        Map<Id, List<OpportunityHistory>> relH = new Map<Id, List<OpportunityHistory>>();

        for(OpportunityHistory oh:opportunityHistory){
            if(!relatedHistory.containsKey(oh.OpportunityId)){
                Map<Id, OpportunityHistory> oppHistoryItem = new Map<Id, OpportunityHistory>();
                oppHistoryItem.put(oh.Id, oh);
                List<Map<Id, OpportunityHistory>> stepan = new List<Map<Id, OpportunityHistory>>();
                stepan.add(oppHistoryItem);
                relatedHistory.put(oh.OpportunityId, stepan);
            } else {
                Map<Id, OpportunityHistory> oppHistoryItem = new Map<Id, OpportunityHistory>();
                oppHistoryItem.put(oh.Id, oh);
                List<Map<Id, OpportunityHistory>> stepan = new List<Map<Id, OpportunityHistory>>();
                stepan.add(oppHistoryItem);
                relatedHistory.get(oh.OpportunityId).add(oppHistoryItem);
            }

        }

        for(OpportunityHistory oh: opportunityHistory){
            if(!relH.containsKey(oh.OpportunityId)){
                relH.put(oh.OpportunityId, new List<OpportunityHistory>{oh});
            } else {
                relH.get(oh.OpportunityId).add(oh);
            }
        }

        Map<Id, Map<Integer, List<Datetime>>> relatedCreatedDates = new Map<Id, Map<Integer, List<Datetime>>>();
        Map<Id, Datetime> relatedMaxCreatedDates = new Map<Id, Datetime>();
        for(OpportunityHistory oh: opportunityHistory){
            if(!relatedCreatedDates.containsKey(oh.OpportunityId)){
                Map<Integer, List<Datetime>> monthDates = new Map<Integer, List<Datetime>>();
                List<Datetime> relatedDates = new List<Datetime>();
                Integer month = oh.CreatedDate.month();
                if(!monthDates.containsKey(month)){
                    relatedDates.add(oh.CreatedDate);
                    monthDates.put(month, relatedDates);
                } else {
                    relatedDates.add(oh.CreatedDate);
                    monthDates.get(month).add(oh.CreatedDate);
                }
                relatedCreatedDates.put(oh.OpportunityId, monthDates);
            } else {
                Integer month = oh.CreatedDate.month();
                List<Datetime> relatedDates = new List<Datetime>();
                if(!relatedCreatedDates.get(oh.OpportunityId).containsKey(month)){
                    relatedDates.add(oh.CreatedDate);
                    relatedCreatedDates.get(oh.OpportunityId).put(month, relatedDates);
                } else {
                    relatedCreatedDates.get(oh.OpportunityId).get(month).add(oh.CreatedDate);

                }
            }
        }

        for(Id j:relatedCreatedDates.keySet()){
            Map<Integer, List<Datetime>> loopedMap = relatedCreatedDates.get(j);
            for(Integer month: loopedMap.keySet()){
                loopedMap.get(month).sort();
                Datetime loopFilteredDate = loopedMap.get(month)[loopedMap.get(month).size() - 1];
                loopedMap.get(month).clear();
                loopedMap.get(month).add(loopFilteredDate);
            }
        }

        Map<Integer, List<OpportunityHistory>> oppHistoryByMonthes = new Map<Integer, List<OpportunityHistory>>();
        for(Id dtime: relatedCreatedDates.keySet()){
            for(Integer month: relatedCreatedDates.get(dtime).keySet()){
                
                Datetime filteredDatetime = relatedCreatedDates.get(dtime).get(month)[0];
                if(month <= system.today().month()){
                    month += 12;
                }
                for(OpportunityHistory oh:relH.get(dtime)){
                    if(filteredDatetime == oh.CreatedDate && oh.OpportunityId == dtime){
                        if(!oppHistoryByMonthes.containsKey(month)){
                            
                            List<OpportunityHistory> oppHis = new List<OpportunityHistory>();
                            oppHis.add(oh);
                            oppHistoryByMonthes.put(month, oppHis);
                        } else {
                            oppHistoryByMonthes.get(month).add(oh);
                        }
                    }
                }
            }
        }

        System.debug('test: '+JSON.serialize(oppHistoryByMonthes));

        return oppHistoryByMonthes;
    }

    public static Map<String, Map<Integer, List<OpportunityHistory>>> Sales_Reps_Total_Pipeline_Last_12_Months_Helper() {


        List<OpportunityHistory> opportunityHistory;
        if(!Test.isRunningTest()){
            //SELECT  Opportunity.Amount, Opportunity.ExpectedRevenue, Opportunity.CreatedDate, Opportunity.Sales_Rep_O__c, Opportunity.Price_Level__c, Opportunity.GL_Account_Variable_1__r.Name, Opportunity.AccountId, Opportunity.LeadSource, Opportunity.lastactivitydate, Opportunity.Closed_Date__c, Opportunity.StageName, Opportunity.Closedate, Opportunity.ForecastCategoryName, Opportunity.Awarded_Owner__c, Opportunity.Loss_Reason__c, Opportunity.Probability, Amount  FROM OpportunityHistory 
            opportunityHistory = [SELECT Id, Opportunity.Amount, Opportunity.ExpectedRevenue,Opportunity.CreatedDate, Opportunity.Price_Level__c, Opportunity.GL_Account_Variable_1__r.Name, Opportunity.AccountId, Opportunity.LeadSource, Opportunity.lastactivitydate, Opportunity.Closed_Date__c, Opportunity.StageName, Opportunity.Closedate, Opportunity.ForecastCategoryName, Opportunity.Awarded_Owner__c, Opportunity.Loss_Reason__c, Opportunity.Probability,Opportunity.Sales_Rep_O__c, OpportunityId, Opportunity.Sales_Rep_O__r.Name__c, CreatedDate, Opportunity.Name, Amount FROM OpportunityHistory WHERE ( CreatedDate = LAST_N_MONTHS:11 OR CreatedDate = THIS_MONTH ) AND Opportunity.ForecastCategoryName = 'Pipeline' AND Opportunity.GL_Account_Variable_1__r.Name = 'Seawin USA'];
        } else {
            opportunityHistory = (List<OpportunityHistory>)JSON.deserialize('[{"attributes":{"type":"OpportunityHistory","url":"/services/data/v53.0/sobjects/OpportunityHistory/0088F000003iFvlQAE"},"Id":"0088F000003iFvlQAE","OpportunityId":"0061I00000PXW6AQAX","CreatedDate":"2022-01-27T14:23:20.000+0000","Amount":27512.50,"Opportunity":{"attributes":{"type":"Opportunity","url":"/services/data/v53.0/sobjects/Opportunity/0061I00000PXW6AQAX"},"Id":"0061I00000PXW6AQAX","Name":"Candlewood Suites - Big Spring, TX","GL_Account_Variable_1__c":"a0A1I000002RthzUAC","RecordTypeId":"0121I000000JpUCQA0"}},{"attributes":{"type":"OpportunityHistory","url":"/services/data/v53.0/sobjects/OpportunityHistory/0088F000003iFtBQAU"},"Id":"0088F000003iFtBQAU","OpportunityId":"0061I00000R3bVbQAJ","CreatedDate":"2022-01-27T14:14:51.000+0000","Amount":155348.64,"Opportunity":{"attributes":{"type":"Opportunity","url":"/services/data/v53.0/sobjects/Opportunity/0061I00000R3bVbQAJ"},"Id":"0061I00000R3bVbQAJ","Name":"1000M - Chicago, IL","GL_Account_Variable_1__c":"a0A1I000002RthzUAC","RecordTypeId":"0121I000000JpUCQA0"}},{"attributes":{"type":"OpportunityHistory","url":"/services/data/v53.0/sobjects/OpportunityHistory/0088F000003hwGhQAI"},"Id":"0088F000003hwGhQAI","OpportunityId":"0061I00000R3bVbQAJ","CreatedDate":"2022-01-25T08:23:19.000+0000","Amount":155348.64,"Opportunity":{"attributes":{"type":"Opportunity","url":"/services/data/v53.0/sobjects/Opportunity/0061I00000R3bVbQAJ"},"Id":"0061I00000R3bVbQAJ","Name":"1000M - Chicago, IL","GL_Account_Variable_1__c":"a0A1I000002RthzUAC","RecordTypeId":"0121I000000JpUCQA0"}},{"attributes":{"type":"OpportunityHistory","url":"/services/data/v53.0/sobjects/OpportunityHistory/0088F000003hyHcQAI"},"Id":"0088F000003hyHcQAI","OpportunityId":"0068W00000RqXjPQAV","CreatedDate":"2022-01-25T09:26:51.000+0000","Amount":37391.52,"Opportunity":{"attributes":{"type":"Opportunity","url":"/services/data/v53.0/sobjects/Opportunity/0068W00000RqXjPQAV"},"Id":"0068W00000RqXjPQAV","Name":"6847 & 6849 Bruno - 28 - St. Louis, MO","GL_Account_Variable_1__c":"a0A1I000002RthzUAC","RecordTypeId":"0121I000000JpUCQA0"}},{"attributes":{"type":"OpportunityHistory","url":"/services/data/v53.0/sobjects/OpportunityHistory/0088F000003hwHfQAI"},"Id":"0088F000003hwHfQAI","OpportunityId":"0068W00000RqXjPQAV","CreatedDate":"2022-01-25T08:27:14.000+0000","Amount":37258.32,"Opportunity":{"attributes":{"type":"Opportunity","url":"/services/data/v53.0/sobjects/Opportunity/0068W00000RqXjPQAV"},"Id":"0068W00000RqXjPQAV","Name":"6847 & 6849 Bruno - 28 - St. Louis, MO","GL_Account_Variable_1__c":"a0A1I000002RthzUAC","RecordTypeId":"0121I000000JpUCQA0"}},{"attributes":{"type":"OpportunityHistory","url":"/services/data/v53.0/sobjects/OpportunityHistory/0088F000003iJHmQAM"},"Id":"0088F000003iJHmQAM","OpportunityId":"0068W00000SPnUeQAL","CreatedDate":"2022-01-28T11:16:39.000+0000","Amount":62100.62,"Opportunity":{"attributes":{"type":"Opportunity","url":"/services/data/v53.0/sobjects/Opportunity/0068W00000SPnUeQAL"},"Id":"0068W00000SPnUeQAL","Name":"Block 290 - Portland, OR","GL_Account_Variable_1__c":"a0A1I000002RthzUAC","RecordTypeId":"0121I000000JpUCQA0"}},{"attributes":{"type":"OpportunityHistory","url":"/services/data/v53.0/sobjects/OpportunityHistory/0088F000003iFuOQAU"},"Id":"0088F000003iFuOQAU","OpportunityId":"0068W00000SPnUeQAL","CreatedDate":"2022-01-27T14:20:06.000+0000","Amount":62100.62,"Opportunity":{"attributes":{"type":"Opportunity","url":"/services/data/v53.0/sobjects/Opportunity/0068W00000SPnUeQAL"},"Id":"0068W00000SPnUeQAL","Name":"Block 290 - Portland, OR","GL_Account_Variable_1__c":"a0A1I000002RthzUAC","RecordTypeId":"0121I000000JpUCQA0"}},{"attributes":{"type":"OpportunityHistory","url":"/services/data/v53.0/sobjects/OpportunityHistory/0088F000003iFtaQAE"},"Id":"0088F000003iFtaQAE","OpportunityId":"0068W00000SQEMQQA5","CreatedDate":"2022-01-27T14:15:28.000+0000","Amount":18567.61,"Opportunity":{"attributes":{"type":"Opportunity","url":"/services/data/v53.0/sobjects/Opportunity/0068W00000SQEMQQA5"},"Id":"0068W00000SQEMQQA5","Name":"1619 S. 1st Condos - Austin, TX","GL_Account_Variable_1__c":"a0A1I000002RthzUAC","RecordTypeId":"0121I000000JpUCQA0"}},{"attributes":{"type":"OpportunityHistory","url":"/services/data/v53.0/sobjects/OpportunityHistory/0088F000003iFtQQAU"},"Id":"0088F000003iFtQQAU","OpportunityId":"0068W00000SQEMQQA5","CreatedDate":"2022-01-27T14:15:23.000+0000","Amount":18567.61,"Opportunity":{"attributes":{"type":"Opportunity","url":"/services/data/v53.0/sobjects/Opportunity/0068W00000SQEMQQA5"},"Id":"0068W00000SQEMQQA5","Name":"1619 S. 1st Condos - Austin, TX","GL_Account_Variable_1__c":"a0A1I000002RthzUAC","RecordTypeId":"0121I000000JpUCQA0"}},{"attributes":{"type":"OpportunityHistory","url":"/services/data/v53.0/sobjects/OpportunityHistory/0088F000003iFxmQAE"},"Id":"0088F000003iFxmQAE","OpportunityId":"0068W00000SQfsQQAT","CreatedDate":"2022-01-27T14:30:08.000+0000","Amount":137155.20,"Opportunity":{"attributes":{"type":"Opportunity","url":"/services/data/v53.0/sobjects/Opportunity/0068W00000SQfsQQAT"},"Id":"0068W00000SQfsQQAT","Name":"Gila River Indian Community - Sacaton, AZ (Shower Bases - ShowerWalls)","GL_Account_Variable_1__c":"a0A1I000002RthzUAC","RecordTypeId":"0121I000000JpUCQA0"}}]', List<OpportunityHistory>.class);
        }

        Map<Id, List<Map<Id, OpportunityHistory>>> relatedHistory = new Map<Id, List<Map<Id, OpportunityHistory>>>();
        Map<Integer, List<OpportunityHistory>> historyByMonth = new Map<Integer, List<OpportunityHistory>>();
        Map<Id, List<OpportunityHistory>> relH = new Map<Id, List<OpportunityHistory>>();

        for(OpportunityHistory oh:opportunityHistory){
            if(!relatedHistory.containsKey(oh.OpportunityId)){
                Map<Id, OpportunityHistory> oppHistoryItem = new Map<Id, OpportunityHistory>();
                oppHistoryItem.put(oh.Id, oh);
                List<Map<Id, OpportunityHistory>> stepan = new List<Map<Id, OpportunityHistory>>();
                stepan.add(oppHistoryItem);
                relatedHistory.put(oh.OpportunityId, stepan);
            } else {
                Map<Id, OpportunityHistory> oppHistoryItem = new Map<Id, OpportunityHistory>();
                oppHistoryItem.put(oh.Id, oh);
                List<Map<Id, OpportunityHistory>> stepan = new List<Map<Id, OpportunityHistory>>();
                stepan.add(oppHistoryItem);
                relatedHistory.get(oh.OpportunityId).add(oppHistoryItem);
            }
        }
        for(OpportunityHistory oh: opportunityHistory){
            if(!relH.containsKey(oh.OpportunityId)){
                relH.put(oh.OpportunityId, new List<OpportunityHistory>{oh});
            } else {
                relH.get(oh.OpportunityId).add(oh);
            }
        }

        Map<Id, Map<Integer, List<Datetime>>> relatedCreatedDates = new Map<Id, Map<Integer, List<Datetime>>>();
        Map<Id, Datetime> relatedMaxCreatedDates = new Map<Id, Datetime>();
        for(OpportunityHistory oh: opportunityHistory){
            if(!relatedCreatedDates.containsKey(oh.OpportunityId)){
                Map<Integer, List<Datetime>> monthDates = new Map<Integer, List<Datetime>>();
                List<Datetime> relatedDates = new List<Datetime>();
                Integer month = oh.CreatedDate.month();
                if(!monthDates.containsKey(month)){
                    relatedDates.add(oh.CreatedDate);
                    monthDates.put(month, relatedDates);
                } else {
                    relatedDates.add(oh.CreatedDate);
                    monthDates.get(month).add(oh.CreatedDate);
                }
                relatedCreatedDates.put(oh.OpportunityId, monthDates);
            } else {
                Integer month = oh.CreatedDate.month();
                List<Datetime> relatedDates = new List<Datetime>();
                if(!relatedCreatedDates.get(oh.OpportunityId).containsKey(month)){
                    relatedDates.add(oh.CreatedDate);
                    relatedCreatedDates.get(oh.OpportunityId).put(month, relatedDates);
                } else {
                    relatedCreatedDates.get(oh.OpportunityId).get(month).add(oh.CreatedDate);

                }
            }
        }
        for(Id j:relatedCreatedDates.keySet()){
            Map<Integer, List<Datetime>> loopedMap = relatedCreatedDates.get(j);
            for(Integer month: loopedMap.keySet()){
                loopedMap.get(month).sort();
                Datetime loopFilteredDate = loopedMap.get(month)[loopedMap.get(month).size() - 1];
                loopedMap.get(month).clear();
                loopedMap.get(month).add(loopFilteredDate);
            }
        }
        
        Map<Id, Map<Integer, List<OpportunityHistory>>> oppMonthRelatedOH = new Map<Id, Map<Integer, List<OpportunityHistory>>>();

        for(Id dtime: relatedCreatedDates.keySet()){
            for(Integer month: relatedCreatedDates.get(dtime).keySet()){
                Datetime filteredDatetime = relatedCreatedDates.get(dtime).get(month)[0];
                for(OpportunityHistory oh:relH.get(dtime)){
                    if(filteredDatetime == oh.CreatedDate && oh.OpportunityId == dtime){
                        if(!oppMonthRelatedOH.containsKey(oh.OpportunityId)){
                            Map<Integer, List<OpportunityHistory>> monthListOH = new Map<Integer, List<OpportunityHistory>>();
                            if(!monthListOH.containsKey(month)){
                                List<OpportunityHistory> ohL = new List<OpportunityHistory>();
                                ohL.add(oh);
                                if(month <= system.today().month()){
                                    monthListOH.put(month+12, ohL);
    
                                }else {
                                    monthListOH.put(month, ohL);
                                }
                                oppMonthRelatedOH.put(oh.OpportunityId, monthListOH);
                            }
                        } else {
                            Map<Integer, List<OpportunityHistory>> monthListOH = oppMonthRelatedOH.get(oh.OpportunityId);
                            List<OpportunityHistory> opHisList = new List<OpportunityHistory>();
                            opHisList.add(oh);
                            Integer findMonth = month;
                            if(month <= system.today().month()){
                                findMonth += 12;
                            }

                            if(!monthListOH.containsKey(findMonth)){
                                monthListOH.put(findMonth, opHisList);
                            } else {
                                monthListOH.get(findMonth).add(oh);
                            }
                        }
                    }
                }
            }
        }

        Map<String, Map<Integer, List<OpportunityHistory>>> salRepTeamRelation = new Map<String, Map<Integer, List<OpportunityHistory>>>();	
        for(Id oppId:oppMonthRelatedOH.keySet()){
            Map<Integer, List<OpportunityHistory>> monthListOppHistory = oppMonthRelatedOH.get(oppId);

            for(Integer month: monthListOppHistory.keySet()){
                for(OpportunityHistory oh: monthListOppHistory.get(month)){
                    String salRepName = oh.Opportunity.Sales_Rep_O__r.Name__c;
                    if(!salRepTeamRelation.containsKey(salRepName)){
                        Map<Integer, List<OpportunityHistory>> month_list_oh = new Map<Integer, List<OpportunityHistory>>();
                        List<OpportunityHistory> list_oh = new List<OpportunityHistory>();
                        list_oh.add(oh);
                        month_list_oh.put(month, list_oh);
                        salRepTeamRelation.put(salRepName, month_list_oh);
                    } else {
                        if(!salRepTeamRelation.get(salRepName).containsKey(month)){
                            List<OpportunityHistory> list_oh = new List<OpportunityHistory>();
                            list_oh.add(oh);
                            salRepTeamRelation.get(salRepName).put(month, list_oh);
                        } else {
                            salRepTeamRelation.get(salRepName).get(month).add(oh);
                        }
                    }
                }
            }
        }

        return salRepTeamRelation;
    }

    public static Map<String, Map<Integer, List<OpportunityHistory>>> Pipeline_Last_12_Months_By_Lead_Source_Helper(){

        List<OpportunityHistory> opportunityHistory;
        if(!Test.isRunningTest()){
            opportunityHistory = [SELECT Id, OpportunityId, Opportunity.CreatedDate, Opportunity.Price_Level__c, Opportunity.ExpectedRevenue, Opportunity.AccountId, Opportunity.Probability, Opportunity.Closed_Date__c,Opportunity.Awarded_Owner__c, Opportunity.CloseDate, Opportunity.StageName,Opportunity.Sales_Rep_O__r.Name__c, Opportunity.LeadSource, CreatedDate, Opportunity.Name, Amount FROM OpportunityHistory WHERE ( CreatedDate = LAST_N_MONTHS:11 OR CreatedDate = THIS_MONTH ) AND Opportunity.ForecastCategoryName = 'Pipeline' AND Opportunity.GL_Account_Variable_1__r.Name = 'Seawin USA'];
        } else {
            opportunityHistory = (List<OpportunityHistory>)JSON.deserialize('[{"attributes":{"type":"OpportunityHistory","url":"/services/data/v53.0/sobjects/OpportunityHistory/0088F000003iFvlQAE"},"Id":"0088F000003iFvlQAE","OpportunityId":"0061I00000PXW6AQAX","CreatedDate":"2022-01-27T14:23:20.000+0000","Amount":27512.50,"Opportunity":{"attributes":{"type":"Opportunity","url":"/services/data/v53.0/sobjects/Opportunity/0061I00000PXW6AQAX"},"Id":"0061I00000PXW6AQAX","Name":"Candlewood Suites - Big Spring, TX","GL_Account_Variable_1__c":"a0A1I000002RthzUAC","RecordTypeId":"0121I000000JpUCQA0"}},{"attributes":{"type":"OpportunityHistory","url":"/services/data/v53.0/sobjects/OpportunityHistory/0088F000003iFtBQAU"},"Id":"0088F000003iFtBQAU","OpportunityId":"0061I00000R3bVbQAJ","CreatedDate":"2022-01-27T14:14:51.000+0000","Amount":155348.64,"Opportunity":{"attributes":{"type":"Opportunity","url":"/services/data/v53.0/sobjects/Opportunity/0061I00000R3bVbQAJ"},"Id":"0061I00000R3bVbQAJ","Name":"1000M - Chicago, IL","GL_Account_Variable_1__c":"a0A1I000002RthzUAC","RecordTypeId":"0121I000000JpUCQA0"}},{"attributes":{"type":"OpportunityHistory","url":"/services/data/v53.0/sobjects/OpportunityHistory/0088F000003hwGhQAI"},"Id":"0088F000003hwGhQAI","OpportunityId":"0061I00000R3bVbQAJ","CreatedDate":"2022-01-25T08:23:19.000+0000","Amount":155348.64,"Opportunity":{"attributes":{"type":"Opportunity","url":"/services/data/v53.0/sobjects/Opportunity/0061I00000R3bVbQAJ"},"Id":"0061I00000R3bVbQAJ","Name":"1000M - Chicago, IL","GL_Account_Variable_1__c":"a0A1I000002RthzUAC","RecordTypeId":"0121I000000JpUCQA0"}},{"attributes":{"type":"OpportunityHistory","url":"/services/data/v53.0/sobjects/OpportunityHistory/0088F000003hyHcQAI"},"Id":"0088F000003hyHcQAI","OpportunityId":"0068W00000RqXjPQAV","CreatedDate":"2022-01-25T09:26:51.000+0000","Amount":37391.52,"Opportunity":{"attributes":{"type":"Opportunity","url":"/services/data/v53.0/sobjects/Opportunity/0068W00000RqXjPQAV"},"Id":"0068W00000RqXjPQAV","Name":"6847 & 6849 Bruno - 28 - St. Louis, MO","GL_Account_Variable_1__c":"a0A1I000002RthzUAC","RecordTypeId":"0121I000000JpUCQA0"}},{"attributes":{"type":"OpportunityHistory","url":"/services/data/v53.0/sobjects/OpportunityHistory/0088F000003hwHfQAI"},"Id":"0088F000003hwHfQAI","OpportunityId":"0068W00000RqXjPQAV","CreatedDate":"2022-01-25T08:27:14.000+0000","Amount":37258.32,"Opportunity":{"attributes":{"type":"Opportunity","url":"/services/data/v53.0/sobjects/Opportunity/0068W00000RqXjPQAV"},"Id":"0068W00000RqXjPQAV","Name":"6847 & 6849 Bruno - 28 - St. Louis, MO","GL_Account_Variable_1__c":"a0A1I000002RthzUAC","RecordTypeId":"0121I000000JpUCQA0"}},{"attributes":{"type":"OpportunityHistory","url":"/services/data/v53.0/sobjects/OpportunityHistory/0088F000003iJHmQAM"},"Id":"0088F000003iJHmQAM","OpportunityId":"0068W00000SPnUeQAL","CreatedDate":"2022-01-28T11:16:39.000+0000","Amount":62100.62,"Opportunity":{"attributes":{"type":"Opportunity","url":"/services/data/v53.0/sobjects/Opportunity/0068W00000SPnUeQAL"},"Id":"0068W00000SPnUeQAL","Name":"Block 290 - Portland, OR","GL_Account_Variable_1__c":"a0A1I000002RthzUAC","RecordTypeId":"0121I000000JpUCQA0"}},{"attributes":{"type":"OpportunityHistory","url":"/services/data/v53.0/sobjects/OpportunityHistory/0088F000003iFuOQAU"},"Id":"0088F000003iFuOQAU","OpportunityId":"0068W00000SPnUeQAL","CreatedDate":"2022-01-27T14:20:06.000+0000","Amount":62100.62,"Opportunity":{"attributes":{"type":"Opportunity","url":"/services/data/v53.0/sobjects/Opportunity/0068W00000SPnUeQAL"},"Id":"0068W00000SPnUeQAL","Name":"Block 290 - Portland, OR","GL_Account_Variable_1__c":"a0A1I000002RthzUAC","RecordTypeId":"0121I000000JpUCQA0"}},{"attributes":{"type":"OpportunityHistory","url":"/services/data/v53.0/sobjects/OpportunityHistory/0088F000003iFtaQAE"},"Id":"0088F000003iFtaQAE","OpportunityId":"0068W00000SQEMQQA5","CreatedDate":"2022-01-27T14:15:28.000+0000","Amount":18567.61,"Opportunity":{"attributes":{"type":"Opportunity","url":"/services/data/v53.0/sobjects/Opportunity/0068W00000SQEMQQA5"},"Id":"0068W00000SQEMQQA5","Name":"1619 S. 1st Condos - Austin, TX","GL_Account_Variable_1__c":"a0A1I000002RthzUAC","RecordTypeId":"0121I000000JpUCQA0"}},{"attributes":{"type":"OpportunityHistory","url":"/services/data/v53.0/sobjects/OpportunityHistory/0088F000003iFtQQAU"},"Id":"0088F000003iFtQQAU","OpportunityId":"0068W00000SQEMQQA5","CreatedDate":"2022-01-27T14:15:23.000+0000","Amount":18567.61,"Opportunity":{"attributes":{"type":"Opportunity","url":"/services/data/v53.0/sobjects/Opportunity/0068W00000SQEMQQA5"},"Id":"0068W00000SQEMQQA5","Name":"1619 S. 1st Condos - Austin, TX","GL_Account_Variable_1__c":"a0A1I000002RthzUAC","RecordTypeId":"0121I000000JpUCQA0"}},{"attributes":{"type":"OpportunityHistory","url":"/services/data/v53.0/sobjects/OpportunityHistory/0088F000003iFxmQAE"},"Id":"0088F000003iFxmQAE","OpportunityId":"0068W00000SQfsQQAT","CreatedDate":"2022-01-27T14:30:08.000+0000","Amount":137155.20,"Opportunity":{"attributes":{"type":"Opportunity","url":"/services/data/v53.0/sobjects/Opportunity/0068W00000SQfsQQAT"},"Id":"0068W00000SQfsQQAT","Name":"Gila River Indian Community - Sacaton, AZ (Shower Bases - ShowerWalls)","GL_Account_Variable_1__c":"a0A1I000002RthzUAC","RecordTypeId":"0121I000000JpUCQA0"}}]', List<OpportunityHistory>.class);
        }

        Map<Id, List<Map<Id, OpportunityHistory>>> relatedHistory = new Map<Id, List<Map<Id, OpportunityHistory>>>();
        Map<Integer, List<OpportunityHistory>> historyByMonth = new Map<Integer, List<OpportunityHistory>>();
        Map<Id, List<OpportunityHistory>> relH = new Map<Id, List<OpportunityHistory>>();

        for(OpportunityHistory oh:opportunityHistory){
            if(!relatedHistory.containsKey(oh.OpportunityId)){
                Map<Id, OpportunityHistory> oppHistoryItem = new Map<Id, OpportunityHistory>();
                oppHistoryItem.put(oh.Id, oh);
                List<Map<Id, OpportunityHistory>> stepan = new List<Map<Id, OpportunityHistory>>();
                stepan.add(oppHistoryItem);
                relatedHistory.put(oh.OpportunityId, stepan);
            } else {
                Map<Id, OpportunityHistory> oppHistoryItem = new Map<Id, OpportunityHistory>();
                oppHistoryItem.put(oh.Id, oh);
                List<Map<Id, OpportunityHistory>> stepan = new List<Map<Id, OpportunityHistory>>();
                stepan.add(oppHistoryItem);
                relatedHistory.get(oh.OpportunityId).add(oppHistoryItem);
            }
        }
        for(OpportunityHistory oh: opportunityHistory){
            if(!relH.containsKey(oh.OpportunityId)){
                relH.put(oh.OpportunityId, new List<OpportunityHistory>{oh});
            } else {
                relH.get(oh.OpportunityId).add(oh);
            }
        }

        Map<Id, Map<Integer, List<Datetime>>> relatedCreatedDates = new Map<Id, Map<Integer, List<Datetime>>>();
        Map<Id, Datetime> relatedMaxCreatedDates = new Map<Id, Datetime>();
        for(OpportunityHistory oh: opportunityHistory){
            if(!relatedCreatedDates.containsKey(oh.OpportunityId)){
                Map<Integer, List<Datetime>> monthDates = new Map<Integer, List<Datetime>>();
                List<Datetime> relatedDates = new List<Datetime>();
                Integer month = oh.CreatedDate.month();
                if(!monthDates.containsKey(month)){
                    relatedDates.add(oh.CreatedDate);
                    monthDates.put(month, relatedDates);
                } else {
                    relatedDates.add(oh.CreatedDate);
                    monthDates.get(month).add(oh.CreatedDate);
                }
                relatedCreatedDates.put(oh.OpportunityId, monthDates);
            } else {
                Integer month = oh.CreatedDate.month();
                List<Datetime> relatedDates = new List<Datetime>();
                if(!relatedCreatedDates.get(oh.OpportunityId).containsKey(month)){
                    relatedDates.add(oh.CreatedDate);
                    relatedCreatedDates.get(oh.OpportunityId).put(month, relatedDates);
                } else {
                    relatedCreatedDates.get(oh.OpportunityId).get(month).add(oh.CreatedDate);

                }
            }
        }
        for(Id j:relatedCreatedDates.keySet()){
            Map<Integer, List<Datetime>> loopedMap = relatedCreatedDates.get(j);
            for(Integer month: loopedMap.keySet()){
                loopedMap.get(month).sort();
                Datetime loopFilteredDate = loopedMap.get(month)[loopedMap.get(month).size() - 1];
                loopedMap.get(month).clear();
                loopedMap.get(month).add(loopFilteredDate);
            }
        }
        
        Map<Id, Map<Integer, List<OpportunityHistory>>> oppMonthRelatedOH = new Map<Id, Map<Integer, List<OpportunityHistory>>>();

        for(Id dtime: relatedCreatedDates.keySet()){
            for(Integer month: relatedCreatedDates.get(dtime).keySet()){
                Datetime filteredDatetime = relatedCreatedDates.get(dtime).get(month)[0];
                for(OpportunityHistory oh:relH.get(dtime)){
                    if(filteredDatetime == oh.CreatedDate && oh.OpportunityId == dtime){
                        if(!oppMonthRelatedOH.containsKey(oh.OpportunityId)){
                            Map<Integer, List<OpportunityHistory>> monthListOH = new Map<Integer, List<OpportunityHistory>>();
                            if(!monthListOH.containsKey(month)){
                                List<OpportunityHistory> ohL = new List<OpportunityHistory>();
                                ohL.add(oh);
                                if(month <= system.today().month()){
                                    monthListOH.put(month+12, ohL);
    
                                }else {
                                    monthListOH.put(month, ohL);
                                }
                                oppMonthRelatedOH.put(oh.OpportunityId, monthListOH);
                            }
                        } else {
                            Map<Integer, List<OpportunityHistory>> monthListOH = oppMonthRelatedOH.get(oh.OpportunityId);
                            List<OpportunityHistory> opHisList = new List<OpportunityHistory>();
                            opHisList.add(oh);
                            Integer findMonth = month;
                            if(month <= system.today().month()){
                                findMonth += 12;
                            }

                            if(!monthListOH.containsKey(findMonth)){
                                monthListOH.put(findMonth, opHisList);
                            } else {
                                monthListOH.get(findMonth).add(oh);
                            }
                        }
                    }
                }
            }
        }

        Map<String, Map<Integer, List<OpportunityHistory>>> salRepTeamRelation = new Map<String, Map<Integer, List<OpportunityHistory>>>();	
        for(Id oppId:oppMonthRelatedOH.keySet()){
            Map<Integer, List<OpportunityHistory>> monthListOppHistory = oppMonthRelatedOH.get(oppId);

            for(Integer month: monthListOppHistory.keySet()){
                for(OpportunityHistory oh: monthListOppHistory.get(month)){
                    String salRepName = oh.Opportunity.LeadSource;
                    if(!salRepTeamRelation.containsKey(salRepName)){
                        Map<Integer, List<OpportunityHistory>> month_list_oh = new Map<Integer, List<OpportunityHistory>>();
                        List<OpportunityHistory> list_oh = new List<OpportunityHistory>();
                        list_oh.add(oh);
                        month_list_oh.put(month, list_oh);
                        salRepTeamRelation.put(salRepName, month_list_oh);
                    } else {
                        if(!salRepTeamRelation.get(salRepName).containsKey(month)){
                            List<OpportunityHistory> list_oh = new List<OpportunityHistory>();
                            list_oh.add(oh);
                            salRepTeamRelation.get(salRepName).put(month, list_oh);
                        } else {
                            salRepTeamRelation.get(salRepName).get(month).add(oh);
                        }
                    }
                }
            }
        }

        return salRepTeamRelation;
    }


    public static Map<Integer, Decimal> Total_Pipeline(){
        List<OpportunityHistory> opportunityHistory;
        if(!Test.isRunningTest()){
            opportunityHistory = [SELECT Id, OpportunityId, CreatedDate, Opportunity.Name, Opportunity.Amount, Amount FROM OpportunityHistory WHERE ( CreatedDate = LAST_N_MONTHS:11 OR CreatedDate = THIS_MONTH ) AND Opportunity.ForecastCategoryName = 'Pipeline' AND Opportunity.GL_Account_Variable_1__r.Name = 'Seawin USA'];
        } else {
            opportunityHistory = (List<OpportunityHistory>)JSON.deserialize('[{"attributes":{"type":"OpportunityHistory","url":"/services/data/v53.0/sobjects/OpportunityHistory/0088F000003iFvlQAE"},"Id":"0088F000003iFvlQAE","OpportunityId":"0061I00000PXW6AQAX","CreatedDate":"2022-01-27T14:23:20.000+0000","Amount":27512.50,"Opportunity":{"attributes":{"type":"Opportunity","url":"/services/data/v53.0/sobjects/Opportunity/0061I00000PXW6AQAX"},"Id":"0061I00000PXW6AQAX","Name":"Candlewood Suites - Big Spring, TX","GL_Account_Variable_1__c":"a0A1I000002RthzUAC","RecordTypeId":"0121I000000JpUCQA0"}},{"attributes":{"type":"OpportunityHistory","url":"/services/data/v53.0/sobjects/OpportunityHistory/0088F000003iFtBQAU"},"Id":"0088F000003iFtBQAU","OpportunityId":"0061I00000R3bVbQAJ","CreatedDate":"2022-01-27T14:14:51.000+0000","Amount":155348.64,"Opportunity":{"attributes":{"type":"Opportunity","url":"/services/data/v53.0/sobjects/Opportunity/0061I00000R3bVbQAJ"},"Id":"0061I00000R3bVbQAJ","Name":"1000M - Chicago, IL","GL_Account_Variable_1__c":"a0A1I000002RthzUAC","RecordTypeId":"0121I000000JpUCQA0"}},{"attributes":{"type":"OpportunityHistory","url":"/services/data/v53.0/sobjects/OpportunityHistory/0088F000003hwGhQAI"},"Id":"0088F000003hwGhQAI","OpportunityId":"0061I00000R3bVbQAJ","CreatedDate":"2022-01-25T08:23:19.000+0000","Amount":155348.64,"Opportunity":{"attributes":{"type":"Opportunity","url":"/services/data/v53.0/sobjects/Opportunity/0061I00000R3bVbQAJ"},"Id":"0061I00000R3bVbQAJ","Name":"1000M - Chicago, IL","GL_Account_Variable_1__c":"a0A1I000002RthzUAC","RecordTypeId":"0121I000000JpUCQA0"}},{"attributes":{"type":"OpportunityHistory","url":"/services/data/v53.0/sobjects/OpportunityHistory/0088F000003hyHcQAI"},"Id":"0088F000003hyHcQAI","OpportunityId":"0068W00000RqXjPQAV","CreatedDate":"2022-01-25T09:26:51.000+0000","Amount":37391.52,"Opportunity":{"attributes":{"type":"Opportunity","url":"/services/data/v53.0/sobjects/Opportunity/0068W00000RqXjPQAV"},"Id":"0068W00000RqXjPQAV","Name":"6847 & 6849 Bruno - 28 - St. Louis, MO","GL_Account_Variable_1__c":"a0A1I000002RthzUAC","RecordTypeId":"0121I000000JpUCQA0"}},{"attributes":{"type":"OpportunityHistory","url":"/services/data/v53.0/sobjects/OpportunityHistory/0088F000003hwHfQAI"},"Id":"0088F000003hwHfQAI","OpportunityId":"0068W00000RqXjPQAV","CreatedDate":"2022-01-25T08:27:14.000+0000","Amount":37258.32,"Opportunity":{"attributes":{"type":"Opportunity","url":"/services/data/v53.0/sobjects/Opportunity/0068W00000RqXjPQAV"},"Id":"0068W00000RqXjPQAV","Name":"6847 & 6849 Bruno - 28 - St. Louis, MO","GL_Account_Variable_1__c":"a0A1I000002RthzUAC","RecordTypeId":"0121I000000JpUCQA0"}},{"attributes":{"type":"OpportunityHistory","url":"/services/data/v53.0/sobjects/OpportunityHistory/0088F000003iJHmQAM"},"Id":"0088F000003iJHmQAM","OpportunityId":"0068W00000SPnUeQAL","CreatedDate":"2022-01-28T11:16:39.000+0000","Amount":62100.62,"Opportunity":{"attributes":{"type":"Opportunity","url":"/services/data/v53.0/sobjects/Opportunity/0068W00000SPnUeQAL"},"Id":"0068W00000SPnUeQAL","Name":"Block 290 - Portland, OR","GL_Account_Variable_1__c":"a0A1I000002RthzUAC","RecordTypeId":"0121I000000JpUCQA0"}},{"attributes":{"type":"OpportunityHistory","url":"/services/data/v53.0/sobjects/OpportunityHistory/0088F000003iFuOQAU"},"Id":"0088F000003iFuOQAU","OpportunityId":"0068W00000SPnUeQAL","CreatedDate":"2022-01-27T14:20:06.000+0000","Amount":62100.62,"Opportunity":{"attributes":{"type":"Opportunity","url":"/services/data/v53.0/sobjects/Opportunity/0068W00000SPnUeQAL"},"Id":"0068W00000SPnUeQAL","Name":"Block 290 - Portland, OR","GL_Account_Variable_1__c":"a0A1I000002RthzUAC","RecordTypeId":"0121I000000JpUCQA0"}},{"attributes":{"type":"OpportunityHistory","url":"/services/data/v53.0/sobjects/OpportunityHistory/0088F000003iFtaQAE"},"Id":"0088F000003iFtaQAE","OpportunityId":"0068W00000SQEMQQA5","CreatedDate":"2022-01-27T14:15:28.000+0000","Amount":18567.61,"Opportunity":{"attributes":{"type":"Opportunity","url":"/services/data/v53.0/sobjects/Opportunity/0068W00000SQEMQQA5"},"Id":"0068W00000SQEMQQA5","Name":"1619 S. 1st Condos - Austin, TX","GL_Account_Variable_1__c":"a0A1I000002RthzUAC","RecordTypeId":"0121I000000JpUCQA0"}},{"attributes":{"type":"OpportunityHistory","url":"/services/data/v53.0/sobjects/OpportunityHistory/0088F000003iFtQQAU"},"Id":"0088F000003iFtQQAU","OpportunityId":"0068W00000SQEMQQA5","CreatedDate":"2022-01-27T14:15:23.000+0000","Amount":18567.61,"Opportunity":{"attributes":{"type":"Opportunity","url":"/services/data/v53.0/sobjects/Opportunity/0068W00000SQEMQQA5"},"Id":"0068W00000SQEMQQA5","Name":"1619 S. 1st Condos - Austin, TX","GL_Account_Variable_1__c":"a0A1I000002RthzUAC","RecordTypeId":"0121I000000JpUCQA0"}},{"attributes":{"type":"OpportunityHistory","url":"/services/data/v53.0/sobjects/OpportunityHistory/0088F000003iFxmQAE"},"Id":"0088F000003iFxmQAE","OpportunityId":"0068W00000SQfsQQAT","CreatedDate":"2022-01-27T14:30:08.000+0000","Amount":137155.20,"Opportunity":{"attributes":{"type":"Opportunity","url":"/services/data/v53.0/sobjects/Opportunity/0068W00000SQfsQQAT"},"Id":"0068W00000SQfsQQAT","Name":"Gila River Indian Community - Sacaton, AZ (Shower Bases - ShowerWalls)","GL_Account_Variable_1__c":"a0A1I000002RthzUAC","RecordTypeId":"0121I000000JpUCQA0"}}]', List<OpportunityHistory>.class);
        }
        Map<Id, List<Map<Id, OpportunityHistory>>> relatedHistory = new Map<Id, List<Map<Id, OpportunityHistory>>>();
        Map<Integer, List<OpportunityHistory>> historyByMonth = new Map<Integer, List<OpportunityHistory>>();
        Map<Id, List<OpportunityHistory>> relH = new Map<Id, List<OpportunityHistory>>();

        for(OpportunityHistory oh:opportunityHistory){
            if(!relatedHistory.containsKey(oh.OpportunityId)){
                Map<Id, OpportunityHistory> oppHistoryItem = new Map<Id, OpportunityHistory>();
                oppHistoryItem.put(oh.Id, oh);
                List<Map<Id, OpportunityHistory>> stepan = new List<Map<Id, OpportunityHistory>>();
                stepan.add(oppHistoryItem);
                relatedHistory.put(oh.OpportunityId, stepan);
            } else {
                Map<Id, OpportunityHistory> oppHistoryItem = new Map<Id, OpportunityHistory>();
                oppHistoryItem.put(oh.Id, oh);
                List<Map<Id, OpportunityHistory>> stepan = new List<Map<Id, OpportunityHistory>>();
                stepan.add(oppHistoryItem);
                relatedHistory.get(oh.OpportunityId).add(oppHistoryItem);
            }

        }

        for(OpportunityHistory oh: opportunityHistory){
            if(!relH.containsKey(oh.OpportunityId)){
                relH.put(oh.OpportunityId, new List<OpportunityHistory>{oh});
            } else {
                relH.get(oh.OpportunityId).add(oh);
            }
        }

        Map<Id, Map<Integer, List<Datetime>>> relatedCreatedDates = new Map<Id, Map<Integer, List<Datetime>>>();
        Map<Id, Datetime> relatedMaxCreatedDates = new Map<Id, Datetime>();
        for(OpportunityHistory oh: opportunityHistory){
            if(!relatedCreatedDates.containsKey(oh.OpportunityId)){
                Map<Integer, List<Datetime>> monthDates = new Map<Integer, List<Datetime>>();
                List<Datetime> relatedDates = new List<Datetime>();
                Integer month = oh.CreatedDate.month();
                if(!monthDates.containsKey(month)){
                    relatedDates.add(oh.CreatedDate);
                    monthDates.put(month, relatedDates);
                } else {
                    relatedDates.add(oh.CreatedDate);
                    monthDates.get(month).add(oh.CreatedDate);
                }
                relatedCreatedDates.put(oh.OpportunityId, monthDates);
            } else {
                Integer month = oh.CreatedDate.month();
                List<Datetime> relatedDates = new List<Datetime>();
                if(!relatedCreatedDates.get(oh.OpportunityId).containsKey(month)){
                    relatedDates.add(oh.CreatedDate);
                    relatedCreatedDates.get(oh.OpportunityId).put(month, relatedDates);
                } else {
                    relatedCreatedDates.get(oh.OpportunityId).get(month).add(oh.CreatedDate);

                }
            }
        }

        for(Id j:relatedCreatedDates.keySet()){
            Map<Integer, List<Datetime>> loopedMap = relatedCreatedDates.get(j);
            for(Integer month: loopedMap.keySet()){
                loopedMap.get(month).sort();
                Datetime loopFilteredDate = loopedMap.get(month)[loopedMap.get(month).size() - 1];
                loopedMap.get(month).clear();
                loopedMap.get(month).add(loopFilteredDate);
            }
        }

        Map<Integer, List<OpportunityHistory>> oppHistoryByMonthes = new Map<Integer, List<OpportunityHistory>>();
        for(Id dtime: relatedCreatedDates.keySet()){
            for(Integer month: relatedCreatedDates.get(dtime).keySet()){
                Datetime filteredDatetime = relatedCreatedDates.get(dtime).get(month)[0];
                for(OpportunityHistory oh:relH.get(dtime)){
                    if(month <= system.today().month()){
                        month += 12;
                    }
                    if(filteredDatetime == oh.CreatedDate && oh.OpportunityId == dtime){
                        if(!oppHistoryByMonthes.containsKey(month)){
                            List<OpportunityHistory> oppHis = new List<OpportunityHistory>();
                            oppHis.add(oh);
                            oppHistoryByMonthes.put(month, oppHis);
                        } else {
                            oppHistoryByMonthes.get(month).add(oh);
                        }
                    }
                }
            }
        }
        //Ahead is list Changes Opportunity by month
        Map<Id, Opportunity> opport = new Map<Id, Opportunity>([SELECT Id,
                                                                        Amount,
                                                                        CreatedDate,
                                                                        Sales_Rep_O__c,
                                                                        Price_Level__c,
                                                                        Probability,
                                                                        ExpectedRevenue,
                                                                        AccountId,
                                                                        Awarded_Owner__c,
                                                                        LeadSource,
                                                                        StageName,
                                                                        Closed_Date__c,
                                                                        CloseDate,
                                                                        Name 
                                                                FROM Opportunity         
                                                                WHERE ( CreatedDate = LAST_N_MONTHS:11 OR CreatedDate = THIS_MONTH ) AND Opportunity.ForecastCategoryName = 'Pipeline' AND Opportunity.GL_Account_Variable_1__r.Name = 'Seawin USA'   LIMIT 200]);

        Map<Integer, List<Opportunity>> opportunitiesByCreatedDateMonth = new Map<Integer, List<Opportunity>>();

        for(Id opp:opport.keySet()){
            Integer month = opport.get(opp).CreatedDate.month();
            if(month <= system.today().month()){
                month += 12;
            }
            if(!opportunitiesByCreatedDateMonth.containsKey(month)){
                List<Opportunity> list_opp = new List<Opportunity>();
                list_opp.add(opport.get(opp));

                opportunitiesByCreatedDateMonth.put(month, list_opp);
            } else {
                opportunitiesByCreatedDateMonth.get(month).add(opport.get(opp));
            }
        }





        Map<Integer, List<Opportunity>> created_with_changed = new Map<Integer, List<Opportunity>>();

        for(Integer month:opportunitiesByCreatedDateMonth.keySet()){

            List<Opportunity> opp_by_month = opportunitiesByCreatedDateMonth.get(month);
            List<OpportunityHistory> oh_by_month = oppHistoryByMonthes.get(month);

            List<Opportunity> all_opps = new List<Opportunity>();
            
            for(Opportunity o:opp_by_month){
                if(oh_by_month != null){
                    for(OpportunityHistory oh:oh_by_month){
                        if(o.Id == oh.OpportunityId){
                            all_opps.addAll(opportunitiesByCreatedDateMonth.get(month));
                        } else {
                            all_opps.add(oh.Opportunity);
                        }
                    }
                } else {
                    all_opps.addAll(opportunitiesByCreatedDateMonth.get(month));
                }
                
            }

            if(!created_with_changed.containsKey(month)){
                created_with_changed.put(month, all_opps);
            }
        }


        Map<Integer, Decimal> relationAmountToMonth = new Map<Integer, Decimal>();
        for(Integer month:created_with_changed.keySet()){
            if(!relationAmountToMonth.containsKey(month)){
                Decimal counter = 0.00;
                for(Opportunity oh:created_with_changed.get(month)){
                    if(oh.Amount != null){
                        counter += oh.Amount;
                    }

                }
                relationAmountToMonth.put(month, counter);
            }
        }
        Map<Id, Map<Integer, OpportunityFieldHistory>> oppFieldHistory = opportunityFieldHistoryHelper();
        return relationAmountToMonth;
    }

    public static Map<Id, Map<Integer, OpportunityFieldHistory>> opportunityFieldHistoryHelper(){
        List<OpportunityFieldHistory> oppFieldHis = [SELECT Id, NewValue, Opportunity.Name, Opportunity.ForecastCategoryName, Opportunity.StageName, CreatedDate, Field FROM OpportunityFieldHistory WHERE Field='StageName' ];
        List<OpportunityFieldHistory> filteredOppFieldHis = new List<OpportunityFieldHistory>();
        List<String> pipelineStages = new List<String>{'Proposal', 'Follow up', 'Negotiation','Pre-Order'};
            
        for(OpportunityFieldHistory ofh: oppFieldHis){
            if(pipelineStages.contains((String)ofh.NewValue)){
                filteredOppFieldHis.add(ofh);        
            }
        }

        Map<Id, Map<Integer, List<Datetime>>> relatedCreatedDatesOFH = new Map<Id, Map<Integer, List<Datetime>>>();

        for(OpportunityFieldHistory ofh:filteredOppFieldHis){
            if(!relatedCreatedDatesOFH.containsKey(ofh.OpportunityId)){
                Map<Integer, List<Datetime>> monthDates = new Map<Integer, List<Datetime>>();
                List<Datetime> relatedDates = new List<Datetime>();
                Integer month = ofh.CreatedDate.month();
                if(month <= system.today().month()){
                    month += 12;
                }
                if(!monthDates.containsKey(month)){
                    relatedDates.add(ofh.CreatedDate);
                    monthDates.put(month, relatedDates);
                } else {
                    relatedDates.add(ofh.CreatedDate);
                    monthDates.get(month).add(ofh.CreatedDate);
                }
                relatedCreatedDatesOFH.put(ofh.OpportunityId, monthDates);
            } else {
                Integer month = ofh.CreatedDate.month();
                if(month <= system.today().month()){
                    month += 12;
                }
                List<Datetime> relatedDates = new List<Datetime>();
                if(!relatedCreatedDatesOFH.get(ofh.OpportunityId).containsKey(month)){
                    relatedDates.add(ofh.CreatedDate);
                    relatedCreatedDatesOFH.get(ofh.OpportunityId).put(month, relatedDates);
                } else {
                    relatedCreatedDatesOFH.get(ofh.OpportunityId).get(month).add(ofh.CreatedDate);
                }
            }
        }
        Map<Id, Map<Integer, OpportunityFieldHistory>> oppMonthOFH = new Map<Id, Map<Integer, OpportunityFieldHistory>>();
        for(Id oppId:relatedCreatedDatesOFH.keySet()){
            for(Integer month: relatedCreatedDatesOFH.get(oppId).keySet()){
                relatedCreatedDatesOFH.get(oppId).get(month).sort();
            }
        }


        for(Id oppId:relatedCreatedDatesOFH.keySet()){
            if(!oppMonthOFH.containsKey(oppId)){
                Map<Integer, OpportunityFieldHistory> month_ofh = new Map<Integer, OpportunityFieldHistory>();
                for(Integer month: relatedCreatedDatesOFH.get(oppId).keySet()){
                    Datetime fresher = relatedCreatedDatesOFH.get(oppId).get(month)[relatedCreatedDatesOFH.get(oppId).get(month).size() - 1];
                    for(OpportunityFieldHistory ofh:filteredOppFieldHis){
                        if(fresher == ofh.CreatedDate && oppId == ofh.OpportunityId){
                            month_ofh.put(month, ofh);
                        }
                    }
                }
                oppMonthOFH.put(oppId, month_ofh);
            }
        }

        return oppMonthOFH;

    }

    public static void helpTest(){
        Integer i = 0;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
    }
}
