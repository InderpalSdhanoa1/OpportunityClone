public class CloneOpportunityController {
    
    @AuraEnabled
    public static Id cloneOpportunityFunction(Id opptyId){
        
        if(opptyId != NULL){
            String finalQuery = formQuery(opptyId); 
            List<Opportunity> existingOppty = database.query(finalQuery);
            
            // Clone the Opportunity
            Opportunity cloneOpty = existingOppty[0].clone(false, false, false, false);
            cloneOpty.StageName = 'Draft';
            cloneOpty.CloseDate = Date.today().addMonths(1);
            insert cloneOpty;
            
            // relate all the Active products
            
            String finalLineItemQuery = 'SELECT Quantity, UnitPrice, ServiceDate, Description FROM OpportunityLineItem WHERE Product2.isActive = True AND OpportunityId = \'' + opptyId + '\'';
            List<OpportunityLineItem> activeOppLineItem= database.query(finalLineItemQuery);
            
            List<OpportunityLineItem> clonedOpptyLineItems = new List<OpportunityLineItem>();
            for(OpportunityLineItem oppItem : activeOppLineItem){
                OpportunityLineItem temp = oppItem.clone(false, false, false, false);
                temp.OpportunityId = cloneOpty.Id;
                clonedOpptyLineItems.add(temp);
            } 
            
            if(!clonedOpptyLineItems.isEmpty()){
                insert clonedOpptyLineItems;    
            }
            return cloneOpty.Id;
        }
        return NULL;
    }
    
    public static string formQuery(Id opptyId){
        Schema.DescribeSObjectResult res = Opportunity.sObjectType.getDescribe();
        String query = 'SELECT ';
        for(string apiName : res.fields.getMap().keySet()){
            query = query + apiName + ',';
        }
        //Remove Last "," from the String
        Integer length = query.lastIndexOf(',');
        String finalQuery = query.substring(0,length);
        finalQuery = finalQuery + ' FROM Opportunity WHERE Id = \'' + opptyId + '\'';
        return finalQuery;
    } 
    
    @AuraEnabled
    public static Opportunity returnOpportunityDetails(Id opptyId){
        String query = formQuery(opptyId);
        Opportunity opp = database.query(query);
        opp.CloseDate = opp.CloseDate.addMonths(1);
        opp.StageName = 'Draft';
        return opp;
    }
    
    @AuraEnabled
    public static Id saveOpportunity(Opportunity oldOppty){
        Opportunity newopp = oldOppty.clone(false, false, false, false);
        if(newopp != NULL){
            try{
                insert newopp;    
            }catch(Exception e){
                system.debug('The Error is'+e);    
            }
            return newopp.Id;
        }
        return NULL;
    } 
    
    @AuraEnabled
    public static List<String> getPickListValues(String ObjectApi_name, String Field_name){ 
        List<String> lstPickvals=new List<String>();
        Schema.SObjectType targetType = Schema.getGlobalDescribe().get(ObjectApi_name);//From the Object Api name retrieving the SObject
        Sobject Object_name = targetType.newSObject();
        Schema.sObjectType sobject_type = Object_name.getSObjectType(); //grab the sobject that was passed
        Schema.DescribeSObjectResult sobject_describe = sobject_type.getDescribe(); //describe the sobject
        Map<String, Schema.SObjectField> field_map = sobject_describe.fields.getMap(); //get a map of fields for the passed sobject
        List<Schema.PicklistEntry> pick_list_values = field_map.get(Field_name).getDescribe().getPickListValues(); //grab the list of picklist values for the passed field on the sobject
        for (Schema.PicklistEntry a : pick_list_values) { //for all values in the picklist list
            lstPickvals.add(a.getValue());//add the value  to our final list
        }
        return lstPickvals;
    }
}