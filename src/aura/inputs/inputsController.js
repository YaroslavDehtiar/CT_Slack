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

    inpPickedFieldsForFilter: function (component, event) {
        event.getParam("value");
        console.log(event.getParam("value"));
        component.set("v.inpFieldsForFilter", event.getParam("value"));
    },

    pickOperator: function (component, event) {
        event.getParam("value");
        component.set("v.pickOperators", event.getParam('value'));
    },
    removeLastInput: function (component, event, helper) {
        component.find("inputsId");
        component.set("v.inputs", []);

    },

    updateInputValue: function(component, event){
        component.set("v.inputValue", event.getParam('value'));
    },

    cloneInputs: function (component, event) {
        let count = component.get("v.countIds");
        let firstInput = component.find("fieldsInput");
            $A.createComponent(
                "c:Inputs",
                {
                    "aura:id" : "aura:id" + count
                },
                function (newInput, status, errorMessage) {
                    if (status === "SUCCESS") {
                        var body = component.get("v.inputs");
                        body.push(newInput);
                        component.set("v.inputs", body);
                    }
                }
            );
            count++;
            component.set("v.countIds", count);
        },
});