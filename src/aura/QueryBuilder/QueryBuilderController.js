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
        $A.enqueueAction(action);
    },

    choiceFields: function (component, event) {
        event.getParam("value");
        component.set("v.newFields", event.getParam("value"));
    },

    executeQuery: function (component, event) {
        var action = component.get("c.finalExecute");
        action.setParams({objectName: component.get("v.mainObject"), fieldList: component.get("v.newFields")});
        action.setCallback(this, function (resp) {
            /*var arr = resp.getReturnValue();
            let item = [];

            for (const arrElement of arr) {
                    const newItem = {
                        label: arrElement[Object.keys(arrElement)[0]],
                        expanded: true,
                        disabled: false,
                        items: []
                    };
                let tmp = [];
                tmp.label = arrElement[Object.keys(arrElement)[0]];
                tmp.expand = true;
                tmp.items = [newItem];

                item.push(tmp);
                console.log(tmp);
            }
            console.log(item);
            component.set("v.fieldForExecute", item);
            console.log(component.get("v.fieldForExecute"));*/
            var data = resp.getReturnValue();
            var parentBranches = [];
        	var parentKeys = Object.keys(data);
        	for(var i = 0; i < parentKeys.length; i++){
            	var parentValue = data[parentKeys[i]];
                var childBranches = [];
            	var childKeys = Object.keys(parentValue);
            	for(var j = 0; j < childKeys.length; j++){
                    var childValue = parentValue[childKeys[j]];
                    var secondChildLabel = childKeys[j] + ": " + childValue;
                    childBranches.push( {
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