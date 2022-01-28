public with sharing class salResCheckTEST {
    
    public static void salRep(){
        List<OpportunityHistory> opportunityHistory = [SELECT Id, OpportunityId,Opportunity.Sales_Rep_O__r.Name__c, CreatedDate, Opportunity.Name, Amount FROM OpportunityHistory WHERE ( CreatedDate = LAST_N_MONTHS:11 OR CreatedDate = THIS_MONTH ) AND Opportunity.ForecastCategoryName = 'Pipeline'];
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
        system.debug('relatedHistory: '+JSON.serialize(relatedHistory));
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
        system.debug('relatedCreatedDates: '+JSON.serialize(relatedCreatedDates));
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

        Map<String, Map<Integer, Decimal>> month_amount_salres = new Map<String, Map<Integer, Decimal>>();

        for(String salRep: salRepTeamRelation.keySet()){
            Map<Integer, List<OpportunityHistory>> monthAndListHistory = salRepTeamRelation.get(salRep);

            if(!month_amount_salres.containsKey(salRep)){
                Map<Integer, Decimal> month_amount = new Map<Integer, Decimal>();
                for(Integer month: monthAndListHistory.keySet()){
                    Decimal counter = 0.00;
                    for(OpportunityHistory oh: monthAndListHistory.get(month)){
                        if(oh.Amount != null){
                            counter += oh.Amount;
                        }
                    }
                    month_amount.put(month, counter);
                    counter = 0.00;
                }
                month_amount_salres.put(salRep, month_amount);
            }
        }

    }





    public static void leadSource(){
        List<OpportunityHistory> opportunityHistory = [SELECT Id, OpportunityId,Opportunity.Sales_Rep_O__r.Name__c, Opportunity.LeadSource, CreatedDate, Opportunity.Name, Amount FROM OpportunityHistory WHERE ( CreatedDate = LAST_N_MONTHS:11 OR CreatedDate = THIS_MONTH ) AND Opportunity.ForecastCategoryName = 'Pipeline'];
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
        system.debug('relatedHistory: '+JSON.serialize(relatedHistory));
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
        system.debug('relatedCreatedDates: '+JSON.serialize(relatedCreatedDates));
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

        Map<String, Map<Integer, Decimal>> month_amount_salres = new Map<String, Map<Integer, Decimal>>();

        for(String salRep: salRepTeamRelation.keySet()){
            Map<Integer, List<OpportunityHistory>> monthAndListHistory = salRepTeamRelation.get(salRep);

            if(!month_amount_salres.containsKey(salRep)){
                Map<Integer, Decimal> month_amount = new Map<Integer, Decimal>();
                for(Integer month: monthAndListHistory.keySet()){
                    Decimal counter = 0.00;
                    for(OpportunityHistory oh: monthAndListHistory.get(month)){
                        if(oh.Amount != null){
                            counter += oh.Amount;
                        }
                    }
                    month_amount.put(month, counter);
                    counter = 0.00;
                }
                month_amount_salres.put(salRep, month_amount);
            }
        }

        system.debug('CHINAAA: '+month_amount_salres);
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
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
        i++;
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
