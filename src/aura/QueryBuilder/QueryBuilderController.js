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
        const removeClass = component.find("inputClass");
        $A.util.removeClass(removeClass, 'sendFields');
        $A.enqueueAction(action);
    },

    choiceFields: function (component, event) {
        event.getParam("value");
        component.set("v.newFields", event.getParam("value"));
        const button = component.find("executeButton");
        if (component.get("v.newFields") != '') {
            button.set("v.disabled", false);
        } else {
            button.set("v.disabled", true);
        }
    },

    createFilter: function (component, event, helper) {
        const getIds = component.get("v.inputIds");
        console.log(component.get("v.inputIds"));
        $A.createComponent(
            "c:Inputs",
            {
                "inpFieldList": component.get("v.fieldList"),
                "aura:id": getIds + 1
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
        component.set("v.inputIds", getIds + 1);
        const arr = component.get("v.setOfInputIds");
        arr.push(getIds + 1);
        console.log(arr + " Value");
        component.set("v.setOfInputIds", arr);
        const child = component.find("sendFields");
        child.inputFieldsFromParent(component.get("v.fieldList"));
    },


    executeQuery: function (component, event) {
        const getArrayOfIds = component.get("v.setOfInputIds");
        console.log(getArrayOfIds + " Ids");
        for (const getIds of getArrayOfIds) {
            // const getIds = component.get("v.inputIds");
            const getComponentById = component.find(getIds);
            if (getComponentById) {
                const getComboById = getComponentById.find("fieldsInput");
                const getComboValue = getComboById.get("v.value");
                console.log(getComboValue + " Combo Value");
                const getOperatorById = getComponentById.find("operatorsInput");
                const getOperatorValue = getOperatorById.get("v.value");
                console.log(getOperatorValue + " Combo Value");
                const getInputById = getComponentById.find("valueInput");
                const getInputValue = getInputById.get("v.value");
                console.log(getInputValue + " Value");
                if(getComboValue && getOperatorValue && getInputValue){
                    const arr = component.get("v.finalString");
                    arr.push(getComboValue + ' ' + getOperatorValue + ' \''
                        + getInputValue + '\'');
                    component.set("v.finalString", arr);
                }
                console.log(component.get("v.finalString"));
            }
        }

        var action = component.get("c.finalExecute");
        action.setParams({
            objectName: component.get("v.mainObject"),
            fieldList: component.get("v.newFields"),
            filterStrings: component.get("v.finalString")
        });

        action.setCallback(this, function (resp) {
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
        component.set("v.finalString", []);
        $A.enqueueAction(action);
    }
});