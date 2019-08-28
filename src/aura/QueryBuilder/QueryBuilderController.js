({

    doInit : function (component, event) {
        var options = [];
        var action = component.get('c.getObjects');
        action.setCallback(this, function (resp) {
            var arr = resp.getReturnValue();
            arr.forEach(function (el) {
                options.push({value:el, label:el})
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
                options.push({value:el, label:el})
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
        // var options = [];
        var action = component.get("c.finalExecute");
        action.setParams({objectName: component.get("v.mainObject"), fieldList: component.get("v.newFields")});
        action.setCallback(this, function (resp) {
            var arr = resp.getReturnValue();
            // arr.forEach(function (element) {
            //     options.push(element);
            // });
            console.log(arr[0]);
            // console.log(options);
            component.set("v.fieldForExecute", arr);
            console.log(component.get("v.fieldForExecute"));
        });
        $A.enqueueAction(action);
    }
});