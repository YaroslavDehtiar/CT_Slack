/**
 * Created by YaroslavDehtiar on 16.10.2019.
 */

import {api, LightningElement, track} from 'lwc';

export default class Filters extends LightningElement {
// <aura:handler name="init" value="{!this}" action="{!c.doInit}"/>
    @api inpFieldList;
    @track inpFieldsForFilter = [];
    @track types;
    @track typesForValidate;
    @track operators = [];
    @track booleanValues;
    @track typeList;
    // @track operatorsDateValue;
    @track booleanValuesForExecute;
    @track pickOperators;
    @track newInputValue;
    @track today;
    @track operatorDateValue = [];
    @track newInputs;
    @track comboboxValue;
    @track typeForExecute;
    @track operatorsValue;
    @track operatorDateValuesForExecute;

    // <aura:registerEvent name="sendInput" type="c:setInputs"/>

    connectedCallback() {
        const operatorValue = ["=", "!=", "<", "<=", ">", ">=", "LIKE"];
        const operatorLabel = ["Equals", "Not equals", "Less than", "Less or equal",
            "Greater than", "Greater or equal", "Like"];
        for (let index = 0; index < operatorValue.length; index++) {
            this.operators = [...this.operators, {
                value: operatorValue[index],
                label: operatorLabel[index]
            }];
        }
        const dateOperators = ["Custom Date", "YESTERDAY", "TODAY", "TOMORROW", "LAST_WEEK",
            "THIS_WEEK", "NEXT_WEEK", "LAST_MONTH", "NEXT_MONTH", "LAST_90_DAYS", "NEXT_90_DAYS"];
        this.operatorDateValue = dateOperators.map(function (values) {
            return {label:values, value:values}
        });
        const today = new Date();
        let month = today.getMonth() + 1;
        let day = today.getDate();
        if(month < 10){
            month = "0" + month;
        }
        if(day < 10){
            day = "0" + day;
        }
        this.today = today.getFullYear() + "-" + month + "-" + day;
    }

    inpPickedFieldsForFilter(event){
        this.inpFieldsForFilter = this.inpFieldsForFilter
            .reduce((acc, val) => acc || (val.value == event.detail.value ? val.label : ""), "");
        console.log(event.detail.value);
        console.log("1");
        console.log(this.inpFieldList.find(function (element) {
            return element.value === event.detail.value;
        }));
    }
//
//     inpPickedFieldsForFilter: function (component, event) {
//         const values = event.getSource().get("v.value");
//         const labelFields = component.get("v.inpFieldList")
//             .reduce((acc, val) => acc || (val.value == values ? val.label : ""), "");
//         component.set("v.inpFieldsForFilter", labelFields);
//         component.set("v.typesForValidate", event.getParam("value"));
//         component.set("v.comboboxValue", event.getParam("value"));
//     },
//
//     pickOperator: function (component, event) {
//         event.getParam("value");
//         component.set("v.operatorsValue", event.getParam('value'));
//     },
//
//     pickDateOperator: function (component, event) {
//         event.getParam('value');
//         component.set("v.operatorDateValuesForExecute", event.getParam('value'));
//         if (component.get("v.operatorDateValuesForExecute") === 'Custom Date') {
//             $A.util.removeClass(component.find('calendar'), 'slds-hide');
//         } else {
//             $A.util.addClass(component.find('calendar'), 'slds-hide');
//         }
//     },
//     pickBoolean: function (component, event) {
//         event.getParam('value');
//         component.set("v.booleanValuesForExecute", event.getParam('value'));
//     },
//
//     checkValidation: function (component, event) {
//         const value = event.getParam("value");
//         const type = component.get("v.typesForValidate");
//         const getInput = component.find('valueInput');
//
//         if (type.includes("ID")) {
//             if (value.length === 15 || value.length === 18 || value.length === 0) {
//                 $A.util.removeClass(getInput, 'slds-has-error');
//             } else {
//                 $A.util.addClass(getInput, 'slds-has-error');
//             }
//         }
//     },
//
//     pickType: function (component, event) {
//         event.getParam("value");
//         component.set("v.typeForExecute", event.getParam('value'));
//     },
//
//     removeLastInput: function (component, event, helper) {
//         helper.closeMe(component, event, helper);
//
//     },
//
//     updateInputValue: function (component, event) {
//         component.set("v.inputValue", event.getParam('value'));
//     },
//
//     cloneInputs: function (component, event) {
//         $A.createComponent(
//             "c:Inputs",
//             {
//                 "inpFieldList": component.get("v.inpFieldList"),
//             },
//             function (newInput, status, errorMessage) {
//                 if (status === "SUCCESS") {
//                     const body = component.get("v.newInputs");
//                     body.push(newInput);
//                     component.set("v.newInputs", body);
//                 } else if (status === "INCOMPLETE") {
//                     console.log("No response from server or client is offline.")
//                 } else if (status === "ERROR") {
//                     console.log("Error: " + errorMessage);
//                 }
//             }
//         );
//         const cmpEvent = component.getEvent("sendInput");
//         cmpEvent.fire();
//     },
// });
// closeMe : function (component, event, helper) {
//     component.destroy();
// }
}