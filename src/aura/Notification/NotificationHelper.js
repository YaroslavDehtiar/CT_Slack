/**
 * Created by YaroslavDehtiar on 11.10.2019.
 */

({
    subscribe: function (component, event, helper) {
        const empApi = component.find('empApi');
        const channel = component.get('v.channel');
        const replayId = -1;

        empApi.subscribe(channel, replayId, $A.getCallback(
            eventReceived => (console.log("eventReceived" + eventReceived))))
            .then($A.getCallback(function (newSubscription) {
                component.set('v.subscription', newSubscription)
            }));
        console.log('Start');
        const newNotification = {message: message.data.payload.Message__c};
        console.log('Middle');
        const notification = component.get("v.notification");
        console.log(newNotification.message);
        notification.push(newNotification);
        component.set('v.notification', notification);
        console.log(component.get('v.notification'));
    }
});