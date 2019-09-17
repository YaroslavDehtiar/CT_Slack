({

    doInit: function (component, event) {
        var options = [];
        var action = component.get('c.getObjects');
        action.setCallback(this, function (resp) {
            var arr = resp.getReturnValue();
            arr.forEach(function (el) {
                options.push({value: el, label: el})
            });
            component.set('v.objects', options);
            const operators = ["=", "!=", "<", "<=",
                ">", ">=", "LIKE"];
            const opers = operators.map(function (op) {
                return {label: op, value: op}
            });
            component.set('v.operators', opers);
        });
        $A.enqueueAction(action);
    },

    handleOptionSelected: function (component, event) {
        var options = [];
        var action = component.get("c.getFields");
        action.setParams({objectName: event.getParam("value")});
        action.setCallback(this, function (resp) {
            var arr = resp.getReturnValue();
            arr.forEach(function (el) {
                options.push({value: el, label: el})
            });
            component.set('v.fieldList', options);
        });
        component.set("v.mainObject", event.getParam("value"));
        $A.enqueueAction(action);


    },

    choiceFields: function (component, event) {
        event.getParam("value");
        component.set("v.newFields", event.getParam("value"));
    },

    pickFieldForFilter: function (component, event) {
        event.getParam("value");
        component.set("v.pickedFieldsForFilter", event.getParam('value'));
    },

    pickOperator: function (component, event) {
        event.getParam("value");
        component.set("v.pickOperator", event.getParam('value'));
    },

    // cloneInputs: function (component, event, helper) {
    //     const asd = component.find('filter123');
    //     $A.createComponent(
    //         "c:Inputs",
    //         {},
    //         function (newInput, status, errorMessage) {
    //             if (status === "SUCCESS") {
    //                 var body = component.get("v.inputs");
    //                 body.push(newInput);
    //                 component.set("v.inputs", body);
    //             } else if (status === "INCOMPLETE") {
    //                 console.log("No response from server or client is offline.")
    //             } else if (status === "ERROR") {
    //                 console.log("Error: " + errorMessage);
    //             }
    //         }
    //     );
    // },
    cloneInputs: function (component, event, helper) {
        $A.createComponents([
                ["lightning:combobox", {
                    "name": "field",
                    "class": "picklist",
                    "label": "Pick Field",
                    "value": "inProgress",
                    "placeholder": "Fields",
                    "options": component.get("{!v.fieldList}"),
                    "onchange": component.get("{!c.pickFieldForFilter}")
                }],
                ["lightning:combobox", {
                    "name": "operator",
                    "class": "picklist",
                    "label": "Pick Operator",
                    "value": "inProgress",
                    "placeholder": "Operator",
                    "options": component.get("{!v.operators}"),
                    "onchange": component.get("{!c.pickOperator}")
                }],
                ["lightning:input", {
                    "name": "value",
                    "class": "picklist",
                    "label": "Pick Value",
                    "value": component.get("{!v.inputValue}"),
                    "placeholder": "Value",
                }]
            ],
            function (newInput, status, errorMessage) {
                if (status === "SUCCESS") {
                    var body = component.get("v.inputs");
                    newInput.forEach(function (item) {
                        body.push(item);
                    });
                    component.set("v.inputs", body);
                } else if (status === "INCOMPLETE") {
                    console.log("No response from server or client is offline.")
                } else if (status === "ERROR") {
                    console.log("Error: " + errorMessage);
                }
            }
        );
    },

    // inpEvent: function (cmp, event) {
    //     var cmpEvent = cmp.getEvent("inputEvent");
    //     cmpEvent.setParams({
    //         "fieldsInInput": cmp.get("v.inputvalue"),
    //         "inputOperations": cmp.get("v.operators"),
    //     });
    //     cmpEvent.fire();
    //     console.log("1");
    //     $A.createComponent(
    //         "c:Inputs",
    //         {
    //
    //         },
    //         function (newInput, status, errorMessage) {
    //             if (status === "SUCCESS") {
    //                 var body = component.get("v.inputs");
    //                 body.push(newInput);
    //                 console.log("2");
    //                 component.set("v.inputs", body);
    //             }
    //         })
    //     console.log("3");
    //
    // },

    removeLastInputs :  function(cmp, event, helper){
      cmp.find("inputsId").set("v.inputs", []);
    },

    executeQuery: function (component, event) {
        var action = component.get("c.finalExecute");
        action.setParams({
            objectName: component.get("v.mainObject"), fieldList: component.get("v.newFields"),
            filterField: component.get("v.pickedFieldsForFilter"), operator: component.get("v.pickOperator"),
            value: component.get("v.inputValue")
        });

        action.setCallback(this, function (resp) {
            console.log(resp.getReturnValue());
            var data = resp.getReturnValue();
            var parentBranches = [];
            var parentKeys = Object.keys(data);
            for (var i = 0; i < parentKeys.length; i++) {
                var parentValue = data[parentKeys[i]];
                var childBranches = [];
                var childKeys = Object.keys(parentValue);
                for (var j = 0; j < childKeys.length; j++) {
                    var childValue = parentValue[childKeys[j]];
                    var secondChildLabel = childKeys[j] + ": " + childValue;
                    childBranches.push({
                        label: secondChildLabel,
                        name: parentValue.Id + childKeys[j],
                        items: []
                    });
                }
                var parentLabel = parentValue.Id;
                var parentName = parentValue.Id;
                parentBranches.push({
                    label: parentLabel,
                    name: parentName,
                    items: childBranches
                });
            }
            component.set("v.fieldForExecute", parentBranches);
        });
        $A.enqueueAction(action);
    }
});