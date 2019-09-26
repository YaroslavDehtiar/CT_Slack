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
        component.set('v.today', today.getFullYear() + "-" + (today.getMonth() + 1) + "-" + today.getDate());
        component.set('v.operators', opers);
        component.set('v.operatorsDateValue', dateOpers);

    },
    updateFieldList: function (component, event, helper) {
        const params = event.getParam('arguments');
        const something = params.newFields;
        component.set("v.types", something);
        // console.log(component.get("v.types") + ' Start');
    },

    inpPickedFieldsForFilter: function (component, event) {
        const values = event.getSource().get("v.value");
        const labelForValue = component.get("v.inpFieldList")
            .reduce((acc, val) => acc || (val.value == values ? val.label : ""), "");

        component.set("v.inpFieldsForFilter", labelForValue);
        console.log(event.getParam("value") + ' event value');
        if (event.getParam("value").includes("DATE")) {
            if (component.get("v.operatorDateValuesForExecute") === 'Custom Date') {
                $A.util.removeClass(component.find('calendar'), 'slds-hide');
            }
            $A.util.removeClass(component.find('dateOperatorsInput'), 'slds-hide');
            $A.util.addClass(component.find('valueInput'), 'slds-hide');
        } else {
            $A.util.addClass(component.find('calendar'), 'slds-hide');
            $A.util.addClass(component.find('dateOperatorsInput'), 'slds-hide');
            $A.util.removeClass(component.find('valueInput'), 'slds-hide');
        }
        component.set("v.comboboxValue", event.getParam("value"));
    },

    pickOperator: function (component, event) {
        console.log(component.get("v.types") + ' oper');
        event.getParam("value");
        // component.set("v.pickOperators", event.getParam('value'));
        component.set("v.operatorsValue", event.getParam('value'));
    },

    pickDateOperator: function (component, event) {
        event.getParam("value");
        component.set("v.operatorDateValuesForExecute", event.getParam('value'));
        // component.set("v.operatorDateValue", event.getParam('value'));
        if (component.get("v.operatorDateValuesForExecute") === 'Custom Date') {
            $A.util.removeClass(component.find('calendar'), 'slds-hide');
        } else {
            $A.util.addClass(component.find('calendar'), 'slds-hide');
        }
    },

    removeLastInput: function (component, event, helper) {
        helper.closeMe(component, event, helper);

    },

    updateInputValue: function (component, event) {
        component.set("v.inputValue", event.getParam('value'));
    },

    cloneInputs: function (component, event) {
        $A.createComponent(
            "c:Inputs",
            {
                "inpFieldList": component.get("v.inpFieldList"),
            },
            function (newInput, status, errorMessage) {
                if (status === "SUCCESS") {
                    const body = component.get("v.newInputs");
                    body.push(newInput);
                    console.log(body);
                    console.log("====================================");
                    component.set("v.newInputs", body);
                    console.log(component.get("v.newInputs"));
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