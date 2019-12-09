@isTest
public with sharing class SlackAPIToolKitTest {
    @isTest
    public static void checkRightChannel() {
        SlackAPIToolKit.Slack s = new SlackAPIToolKit.Slack();
        s.channel = 'asd';
        List<SlackAPIToolKit.Slack> slacksList = new List<SlackAPIToolKit.Slack>();
        slacksList.add(s);
        String body = '{"ok":true,"channel":{"id":"CMLS2AY21","name":"'+s.channel+'",' +
                '"is_channel":true,"created":1566479459,"is_archived":false,"is_general":false,' +
                '"unlinked":0,"creator":"UMFV4RF2Q","name_normalized":"jhgf","is_shared":false,' +
                '"is_org_shared":false,"is_member":true,"is_private":false,"is_mpim":false,' +
                '"last_read":"0000000000.000000","latest":null,"unread_count":0,"unread_count_display":0,' +
                '"members":["UMFV4RF2Q"],"topic":{"value":"","creator":"","last_set":0},' +
                '"purpose":{"value":"","creator":"","last_set":0},"previous_names":[],"priority":0}}';

        SingleRequestMock fakeResponse = new SingleRequestMock(200,
                'Complete',
                body,
                null);
        Test.setMock(HttpCalloutMock.class, fakeResponse);
        SlackAPIToolKit.publishToSlack(slacksList);
        System.assertEquals('CMLS2AY21', SlackAPIToolKit.linkId);
    }
}