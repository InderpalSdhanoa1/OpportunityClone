({
    doInit : function(component, event, helper) {
        
        var action = component.get("c.returnOpportunityDetails");
        action.setParams({ opptyId : component.get("v.recordId") });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === "SUCCESS") {
                var oldOppty = response.getReturnValue();
                component.set("v.oldOpp",oldOppty);
                component.set("v.opptyStageNames",oldOppty.StageName);
                console.log('Current Stage'+component.get("v.opptyStageNames"));
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
        
        // Make the Call to get the Stages
        var action2 = component.get("c.getPickListValues");
        
        action2.setParams({ ObjectApi_name : "Opportunity", Field_name : "StageName" });
        action2.setCallback(this, function(response2) {
            var state2 = response2.getState();
            if(state2 === "SUCCESS") {
                component.set("v.opptyStageNames", response2.getReturnValue());
                console.log('Success response'+response2.getReturnValue());
            }
            else if (state2 === "ERROR") {
                var errors = response2.getError();
                if(errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action2);
    },
    
    closeModel : function(component, event, helper) {
        component.set("v.isOpen", false);
    },
    
    onCancel : function(component, event, helper) {
        // Navigate back to the record view
        component.set("v.isOpen", false);
        var navigateEvent = $A.get("e.force:navigateToSObject");
        navigateEvent.setParams({ "recordId": component.get('v.recordId') });
        navigateEvent.fire();
    },
    
    onSave : function(component, event, helper) {
        // Navigate back to the record view
        
        var action = component.get("c.saveOpportunity");
        action.setParams({ oldOppty : component.get("v.oldOpp")});
        action.setCallback(this, function(response) {
            var state = response.getState();
            if(state === "SUCCESS") {
                var navigateEvent = $A.get("e.force:navigateToSObject");
                navigateEvent.setParams({ "recordId" : response.getReturnValue() });
                navigateEvent.fire();
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if(errors) {
                    if(errors[0] && errors[0].message) {
                        console.log("Error message: " + errors[0].message);
                    }
                } else {
                    console.log("Unknown error");
                }
            }
        });
        $A.enqueueAction(action);
    }
})