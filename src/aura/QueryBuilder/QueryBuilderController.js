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
        var types = [];
        var action = component.get("c.getFields");
        action.setParams({objectName: event.getParam("value")});
        console.log(event.getParam("value"));
        action.setCallback(this, function (resp) {
            var arr = resp.getReturnValue();
            for (const arrElement in arr) {
                options.push({label: arrElement, value: arrElement});
                types.push({label: arrElement, value: arr[arrElement]});
            }
            component.set('v.fieldList', options);
            component.set('v.fieldsWithTypes', types);
        });
        component.set("v.mainObject", event.getParam("value"));

        const findInp = component.find("sendFields");
        findInp.inputFieldsFromParent(component.get("v.fieldsWithTypes"));

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
        $A.createComponent(
            "c:Inputs",
            {
                "inpFieldList": component.get("v.fieldsWithTypes"),
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
        component.set("v.setOfInputIds", arr);
        const child = component.find("sendFields");
        child.inputFieldsFromParent(component.get("v.fieldList"));
    },


    executeQuery: function (component, event) {
        const getArrayOfIds = component.get("v.setOfInputIds");
        for (const getIds of getArrayOfIds) {
            const getComponentById = component.find(getIds);
            if (getComponentById) {
                const getComboById = getComponentById.find("fieldsInput");
                const getComboValue = getComboById.get("v.value");
                const labelForValue = component.get("v.fieldsWithTypes")
                    .reduce((acc, val) => acc || (val.value == getComboValue ? val.label : ""), "");

                const getOperatorById = getComponentById.find("operatorsInput");
                const getOperatorValue = getOperatorById.get("v.value");

                const getInputById = getComponentById.find("valueInput");
                const getInputValue = getInputById.get("v.value");

                const getDateById = getComponentById.find("dateOperatorsInput");
                const getDateValue = getDateById.get("v.value");

                const getCustomDateById = getComponentById.find("expdate");
                const getCustomDateValue = getCustomDateById.get("v.value");

                const getBooleanId = getComponentById.find("booleanValues");
                const getBooleanValue = getBooleanId.get("v.value");

                console.log(getCustomDateValue);

                const arr = component.get("v.finalString");

                if (labelForValue && getOperatorValue) {                    //field and operation true
                    if (getDateValue && getDateValue !== 'Custom Date') {   // date value not custom
                        arr.push(labelForValue + ' ' + getOperatorValue + ' ' + getDateValue);
                        component.set("v.finalString", arr);
                    } else if (getDateValue && getCustomDateValue) {        //custom date
                        arr.push(labelForValue + ' ' + getOperatorValue + ' ' + getCustomDateValue
                            + 'T00:00:00Z');
                        component.set("v.finalString", arr);
                    } else if (getBooleanValue) {                       //boolean
                        arr.push(labelForValue + ' ' + getOperatorValue + ' ' + getBooleanValue);
                    } else if (getInputValue) {                         //just value
                        arr.push(labelForValue + ' ' + getOperatorValue + ' \''
                            + getInputValue + '\'');
                        component.set("v.finalString", arr);
                    }
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