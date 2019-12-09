/**
 * Created by YaroslavDehtiar on 11.10.2019.
 */

({
    doInit: function (component, event, helper) {
        component.set("v.subscription", []);
        console.log(component.get('v.channel'));
        component.set("v.notifications", 'Start');
        let options = [];
        const action = component.get("c.notificationMessage");
        action.setCallback(this, function (resp) {
            let callback = resp.getReturnValue();
            options.push(callback);
            component.set("v.notifications", options);
        });
        $A.enqueueAction(action);
        helper.subscribe(component, event, helper);
    },
});