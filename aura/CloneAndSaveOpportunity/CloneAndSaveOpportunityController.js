({
    onSave : function(component, event, helper) {
        if(component.get("v.recordId").startsWith("006")){
            var action = component.get("c.cloneOpportunityFunction");
            action.setParams({ opptyId : component.get("v.recordId") });
            // Create a callback that is executed after 
            // the server-side action returns with the new Cloned Oppty Id
            action.setCallback(this, function(response) {
                var state = response.getState();
                if(state === "SUCCESS") {
                    var opptyId = response.getReturnValue();
                    var navEvt = $A.get("e.force:navigateToSObject");
                    navEvt.setParams({ "recordId": opptyId , "slideDevName": "detail" }); 
                    navEvt.fire();
                }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    if(errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + errors[0].message);
                        }
                    } else {
                        console.log("Unknown error");
                    }
                }
            });
            $A.enqueueAction(action);    
        }else {
            	alert('The Source Record is not an Opportunity');
        }
    }
})