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

    handleOptionSelected: function (cmp, event) {
        var action = cmp.get("c.getFields");
        action.setParams({str: event.getParam("value")});
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                cmp.set("v.picklist", response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },

    choiceFields: function (cmp, event) {
        event.getParam("value");
    }

});