({

    doInit: function (component, event) {
        var action = component.get('c.getObjects');
        action.setCallback(this, function (resp) {
            component.set('v.getObjects', resp.getReturnValue());
            console.log(resp.getReturnValue());
        });
        // event.getParam("value");
        $A.enqueueAction(action);
    },

    choiceFields: function (cmp, event) {
        event.getParam("value");
    }

});