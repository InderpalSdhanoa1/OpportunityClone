@isTest
public class CloneOpportunityControllerTest {
    @testSetup 
    static void setup() 
    {
        Account acct = new Account();
        acct.Name = 'Salesforce.com';
        acct.Industry = 'Technology';
        insert acct;
        
        Opportunity opp = new Opportunity();
        opp.AccountId = acct.Id;
        opp.Name = 'Salesforce.com';
        opp.StageName = 'Draft';
        opp.CloseDate = date.today();
        insert opp;
        
        Product2 prdt = new Product2();
        prdt.Description = 'Temp';
        prdt.Name = 'Product 1';
        prdt.ProductCode = 'Test';
        prdt.IsActive = True;
        insert prdt;
        
        OpportunityLineItem oppLine = new OpportunityLineItem();
        oppLine.Quantity = 10;
        oppLine.UnitPrice = 10;
        //oppLine.ListPrice = 12;
        oppLine.ServiceDate = Date.Today();
        oppLine.Description = 'test';
        oppLine.OpportunityId = opp.Id;
        oppLine.Product2Id = prdt.Id;
        //insert oppLine;
        
    }
    
    @isTest
    public static void checkCoverage(){
        Opportunity opp = [SELECT Id FROM Opportunity LIMIT 1];
        test.startTest();
        CloneOpportunityController.cloneOpportunityFunction(opp.Id); 
        CloneOpportunityController.returnOpportunityDetails(opp.Id);
        CloneOpportunityController.saveOpportunity(opp);
        CloneOpportunityController.getPickListValues('Opportunity', 'StageName');
        test.stopTest();
    }
}