/**
 * Created by YaroslavDehtiar on 17.09.2019.
 */

({

    // cloneInputs: function (component, event, helper) {
    //     $A.createComponents([
    //             ["lightning:combobox", {
    //                 "name": "field", "class": "picklist", "label": "Pick Field",
    //                 "value": "inProgress", "placeholder": "Fields",
    //                 "options": component.get("{!v.fieldList}"),
    //                 "onchange": component.get("{!c.pickFieldForFilter}")
    //             }],
    //             ["lightning:combobox", {
    //                 "name": "operator", "class": "picklist", "label": "Pick Operator",
    //                 "value": "inProgress", "placeholder": "Operator",
    //                 "options": component.get("{!v.operators}"),
    //                 "onchange": component.get("{!c.pickOperator}")
    //             }],
    //             ["lightning:input", {
    //                 "name": "value", "class": "picklist", "label": "Pick Value",
    //                 "value": component.get("{!v.inputValue}"),
    //                 "placeholder": "Value",
    //             }],
    //             ["lightning:button", {
    //                 "class": "buttons", "iconName": "utility:add", "title": "Add Filter",
    //                 "onclick": component.get("{!c.cloneInputs}")
    //             }],
    //             ["lightning:button", {
    //                 "class": "buttons", "iconName": "utility:dash", "title": "Remove Filter",
    //                 "onclick": component.get("{!c.removeLastInput}")
    //             }
    //             ]
    //         ],
    //         function (newInput, status, errorMessage) {
    //             if (status === "SUCCESS") {
    //                 var body = component.get("v.inputs");
    //                 newInput.forEach(function (item) {
    //                     body.push(item);
    //                 });
    //                 component.set("v.inputs", body);
    //             } else if (status === "INCOMPLETE") {
    //                 console.log("No response from server or client is offline.")
    //             } else if (status === "ERROR") {
    //                 console.log("Error: " + errorMessage);
    //             }
    //         }
    //     );
    // }

});