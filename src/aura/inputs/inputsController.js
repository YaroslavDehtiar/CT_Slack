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
        const dateOperators = ["Custom Date", "YESTERDAY", "TODAY", "TOMORROW", "LAST_WEEK",
            "THIS_WEEK", "NEXT_WEEK", "LAST_MONTH", "NEXT_MONTH", "LAST_90_DAYS", "NEXT_90_DAYS"];
        const dateOpers = dateOperators.map(function (op) {
            return {label: op, value: op}
        });
        var today = new Date();
        let day;
        if(today.getDate() < 10){
           day = '0' + today.getDate();
        }
        component.set('v.today', today.getFullYear() + "-" + (today.getMonth() + 1) + "-" + day);
        component.set('v.operators', opers);
        component.set('v.operatorsDateValue', dateOpers);
    },

    inpPickedFieldsForFilter: function (component, event) {
        const values = event.getSource().get("v.value");
        const labelFields = component.get("v.inpFieldList")
            .reduce((acc, val) => acc || (val.value == values ? val.label : ""), "");
        component.set("v.inpFieldsForFilter", labelFields);
        component.set("v.typesForValidate", event.getParam("value"));
        component.set("v.comboboxValue", event.getParam("value"));
    },

    pickOperator: function (component, event) {
        event.getParam("value");
        component.set("v.operatorsValue", event.getParam('value'));
    },

    pickDateOperator: function (component, event) {
        event.getParam('value');
        component.set("v.operatorDateValuesForExecute", event.getParam('value'));
        if (component.get("v.operatorDateValuesForExecute") === 'Custom Date') {
            $A.util.removeClass(component.find('calendar'), 'slds-hide');
        } else {
            $A.util.addClass(component.find('calendar'), 'slds-hide');
        }
    },
    pickBoolean: function (component, event) {
        event.getParam('value');
        component.set("v.booleanValuesForExecute", event.getParam('value'));
    },

    checkValidation: function (component, event) {
        const value = event.getParam("value");
        const type = component.get("v.typesForValidate");
        const getInput = component.find('valueInput');

        if (type.includes("ID")) {
            if (value.length === 15 || value.length === 18 || value.length === 0) {
                $A.util.removeClass(getInput, 'slds-has-error');
            } else {
                $A.util.addClass(getInput, 'slds-has-error');
            }
        }
    },

    pickType: function (component, event) {
        event.getParam("value");
        component.set("v.typeForExecute", event.getParam('value'));
    },

    removeLastInput: function (component, event, helper) {
        helper.closeMe(component, event, helper);

    },

    updateInputValue: function (component, event) {
        component.set("v.inputValue", event.getParam('value'));
    },

    cloneInputs: function (component, event) {
        $A.createComponent(
            "c:inputs",
            {
                "inpFieldList": component.get("v.inpFieldList"),
            },
            function (newInput, status, errorMessage) {
                if (status === "SUCCESS") {
                    const body = component.get("v.newInputs");
                    body.push(newInput);
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