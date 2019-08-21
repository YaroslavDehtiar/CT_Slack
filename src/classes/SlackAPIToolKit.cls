/**
 * Created by YaroslavDehtiar on 19.08.2019.
 */

public with sharing class SlackAPIToolKit {

    private static final String slackURL = 'https://slack.com/api/channels.create';
    private static final String token = 'xoxp-730456088816-729990865092-732783034006-9cdf7c554d5edb18bc9bd65a5d4ff67d';
    public static String linkId;

    public class Slack {
        @InvocableVariable(label='Channel' required=true)
        public String channel;
    }

    @InvocableMethod(label='Publish to Slack')
    public static void publishToSlack(List<Slack> requests) {
        String req = String.valueOf(requests[0]);
        System.debug(req);

        Map<String, String> parameters = new Map<String, String>();
        parameters.put('token', token);
        parameters.put('name', req);
        parameters.put('variable', 'true');

        Map<String, String> header = new Map<String, String>();
        header.put('Content-Type', 'application/json;charset=UTF-8');

        String body = '';

        HttpResponse response = new Http().send(createRequest(slackURL, 'POST', parameters, header, body));

        if (response.getStatusCode() == 200) {
            System.debug(response.getBody());
            Map<String, Object> deserialize = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
            Map<String, Object> deserialize2 = (Map<String, Object>) deserialize.get('channel');
            linkId = deserialize2.get('id').toString();
            System.debug(linkId);
        }
    }

    private static HttpRequest createRequest(String endpoint, String requestMethod, Map<String, String> parameters,
            Map<String, String> headers, String body) {
        HttpRequest request = new HttpRequest();
        if (parameters != null && !parameters.isEmpty()) {
            endpoint = endpoint + '?';
            Integer counter = 1;
            for (String key : parameters.keySet()) {
                if (counter < parameters.size()) {
                    endpoint = endpoint + key + '=' + parameters.get(key) + '&';
                    counter++;
                } else {
                    endpoint = endpoint + key + '=' + parameters.get(key);
                }
            }
        }
        if (headers != null && !headers.isEmpty()) {
            for (String key : headers.keySet()) {
                request.setHeader(key, headers.get(key));
            }
        }
        if (String.isNotBlank(body)) {
            request.setBody(body);
        }
        request.setEndpoint(endpoint);
        request.setMethod(requestMethod);
        request.setTimeout(20000);
        return request;
    }

    public String getChannelLink(){
        return linkId;
    }

}