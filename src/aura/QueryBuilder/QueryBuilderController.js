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
        const button = component.find("button");
        button.set("v.disabled", false);
        $A.enqueueAction(action);
    },

    choiceFields: function (component, event) {
        event.getParam("value");
        component.set("v.newFields", event.getParam("value"));
    },

    createFilter: function (component, event, helper) {
        $A.createComponent(
            "c:Inputs",
            {
                "inpFieldList": component.get("v.fieldList")
            },
            function (newInput, status, errorMessage) {
                if (status === "SUCCESS") {
                    var body = component.get("v.inputs");
                        body.push(newInput);
                    component.set("v.inputs", body);
                } else if (status === "INCOMPLETE") {
                    console.log("No response from server or client is offline.")
                } else if (status === "ERROR") {
                    console.log("Error: " + errorMessage);
                }
            }
        );

    },


    executeQuery: function (component, event) {
        var action = component.get("c.finalExecute");
        action.setParams({
            objectName: component.get("v.mainObject"),
            fieldList: component.get("v.newFields"),
            filterField: component.get("v.pickedFieldsForFilter"),
            operator: component.get("v.pickOperator"),
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