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

    executeFromParent : function(component, event, handler){
        const data = event.getParam("arguments");
        component.set("v.inpFieldList", data.data);
        console.log(data + " data");
        console.log(component.get("v.inpFieldList") + " inputfield");
    },

    // handleComponent : function (component, event) {
    //     console.log("1");
    //     var inputFields = event.getParam("listOfFields");
    //     component.set("v.inpFieldList", inputFields);
    //     console.log(component.get("v.inpFieldList") + "cmp list");
    // },

    inpPickFieldForFilter: function (component, event) {
        event.getParam("value");
        component.set("v.inpPickedFieldsForFilter", event.getParam('value'));
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

    // cloneInputs: function (component, event) {
    //     let count = component.get("v.countIds");
    //     let firstInput = component.find("fieldsInput");
    //         $A.createComponent(
    //             "c:Inputs",
    //             {
    //                 "aura:id" : "aura:id" + count
    //             },
    //             function (newInput, status, errorMessage) {
    //                 if (status === "SUCCESS") {
    //                     var body = component.get("v.inputs");
    //                     body.push(newInput);
    //                     component.set("v.inputs", body);
    //                 } else if (status === "INCOMPLETE") {
    //                     console.log("No response from server or client is offline.")
    //                 } else if (status === "ERROR") {
    //                     console.log("Error: " + errorMessage);
    //                 }
    //             }
    //         );
    //         count++;
    //         component.set("v.countIds", count);
    //     },
});