/**
 * Created by YaroslavDehtiar on 17.09.2019.
 */

({
    doInit: function (component, events) {
        const operators = ["=", "!=", "<", "<=",
            ">", ">=", "LIKE"];
        const opers = operators.map(function (op) {
            return {label: op, value: op}
        });
        component.set('v.operators', opers);

    },
    updateFieldList: function (component, event, helper) {
        const params = event.getParam('arguments');
        const something = params.newFields;
        component.set("v.inpFieldList", something);
    },

    inpPickedFieldsForFilter: function (component, event) {
        event.getParam("value");
        component.set("v.inpFieldsForFilter", event.getParam("value"));
        component.set("v.comboboxValue", event.getParam("value"));
    },

    pickOperator: function (component, event) {
        event.getParam("value");
        component.set("v.pickOperators", event.getParam('value'));
        component.set("v.operatorValue", event.getParam('value'));
    },

    removeLastInput: function (component, event, helper) {
        helper.closeMe(component, event, helper);

    },

    updateInputValue: function (component, event) {
        component.set("v.inputValue", event.getParam('value'));
    },

    // setNewIds: function (components, event, helper) {
    //     const params = event.getParam('arguments');
    //     const something = params.newIds;
    //     console.log("something " + something);
    //     components.set("v.newInputIds", something);
    // },

    cloneInputs: function (component, event) {
        $A.createComponent(
            "c:Inputs",
            {
                "inpFieldList": component.get("v.inpFieldList"),
                "aura:id": "auraId" + component.get("v.newInputIds")
            },
            function (newInput, status, errorMessage) {
                if (status === "SUCCESS") {
                    const body = component.get("v.newInputs");
                    body.push(newInput);
                    console.log(body);
                    console.log("====================================");
                    component.set("v.newInputs", body);
                } else if (status === "INCOMPLETE") {
                    console.log("No response from server or client is offline.")
                } else if (status === "ERROR") {
                    console.log("Error: " + errorMessage);
                }
            }
        );
        const cmpEvent = component.getEvent("sendInput");
        cmpEvent.fire();
    },
});