/**
 * Created by YaroslavDehtiar on 21.08.2019.
 */

public with sharing class UpdateChannelLink {

    @InvocableMethod(label = 'Channel Link')
    public static List<String> updateChannelLink(List<String> channelLink) {
        SlackAPIToolKit getLink = new SlackAPIToolKit();
        String link = getLink.getChannelLink();
        List<String> fullLink = new List<String>();
        fullLink.add('https://app.slack.com/client/TMGDE2LQ0/' + link);
        System.debug(fullLink);
        return fullLink;
    }
}