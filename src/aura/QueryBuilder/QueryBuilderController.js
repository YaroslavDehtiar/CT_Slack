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
        $A.enqueueAction(action);

        var typeOptions = [];
        var typeAction = component.get('c.getAllTypesFromObject');
        typeAction.setParams({getObject: event.getParam("value")});
        typeAction.setCallback(this, function (resp) {
            var array = resp.getReturnValue();
            array.forEach(function (el) {
                typeOptions.push({value: el, label: el})
            });
            component.set('v.listOfTypes', typeOptions);
        });
        $A.enqueueAction(typeAction);
        const button = component.find("button");
        button.set("v.disabled", false);
        const removeClass = component.find("inputClass");
        $A.util.removeClass(removeClass, 'sendFields');
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
        const comparison = component.find("comparison");
        comparison.set("v.disabled", false);
        const getIds = component.get("v.inputIds");
        $A.createComponent(
            "c:Inputs",
            {
                "inpFieldList": component.get("v.fieldsWithTypes"),
                "aura:id": getIds + 1,
                "typeList": component.get("v.listOfTypes"),
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

    createComparisonOperator: function (component) {
        $A.createComponent(
            "lightning:input",
            {
                "aura:id": "comparisonInput",
                "label": "Insert operators \"AND\", \"OR\"",
            },
            function (newField, status) {
                if (status === "SUCCESS") {
                    const body = component.get("v.comparisonField");
                    body.push(newField);
                    component.set("v.comparisonField", body);
                }
            }
        )
    },


    executeQuery: function (component, event) {
        const getArrayOfIds = component.get("v.setOfInputIds");
        const finalArr = [];
        let comparisonValue;
        const comparisonArray = [];
        const comparisonId = component.find("comparisonInput");
        if (comparisonId) {
            comparisonValue = comparisonId.get("v.value");
            // console.log(comparisonValue);
            for (const getIds of getArrayOfIds) {
                const getComponentById = component.find(getIds);

                if (getComponentById) {
                    const allComponents = getComponentById.find("fieldsInput");
                    const arr = [];
                    if (finalArr.length > 1) {
                        finalArr.push('AND');
                    }
                    for (let currentComponent of allComponents) {
                        const getValue = currentComponent.get("v.value");
                        const labelForValue = component.get("v.fieldsWithTypes")
                            .reduce((acc, val) => acc || (val.value == getValue ? val.label : ""), "");
                        if (getValue !== 'Custom Date') {
                            arr.push(getValue);
                        }
                        if (labelForValue) {
                            arr.push(labelForValue);
                        }
                    }
                    if (arr[0] === 'DATETIME') {
                        arr[3] = arr[3] + 'T00:00:00Z';
                    }
                    if (arr[0] !== "DATETIME" && arr[0] !== "BOOLEAN") {
                        arr[3] = '\'' + arr[3] + '\'';
                    }
                    arr.splice(0, 1);
                    comparisonArray.push(arr);
                    console.log(arr);
                    console.log(comparisonArray);
                }
                component.set("v.finalString", finalArr);
            }
        }

        function replacer(match, p1, p2, p3) {
            return [p1, p2, p3].join(' ');
        }

        if (comparisonValue) {
            const newArr = [];
            let newString = comparisonValue.replace(/([^\d]*)(\d*)([^\w]*)/gm, replacer).split(' ');
            for (let newStringElement of newString) {
                if (newStringElement !== '') {
                    if (Number.isInteger(parseInt(newStringElement))) {
                        for (let argument of comparisonArray[newStringElement - 1]) {
                            newArr.push(argument)
                        }
                    } else {
                        newArr.push(newStringElement);
                    }
                }
            }
            console.log(newArr);
            component.set("v.finalString", newArr);
        }

        const action = component.get("c.finalExecute");
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
        console.log(component.get("v.finalString"));
        $A.enqueueAction(action);
    }
});