/**
 * Created by YaroslavDehtiar on 19.08.2019.
 */

public with sharing class SlackAPIToolKit {

    public static String linkId;

    public class Slack {
        @InvocableVariable(label='Channel' required=true)
        public String channel;
        @InvocableVariable(label='Channel Link')
        public String channel1;
    }

    @InvocableMethod(label='Publish to Slack')
    public static void publishToSlack(List<Slack> requests) {
        String req = String.valueOf(requests[0]);
        List<String> channelName = new List<String>();
        String replace = req.replaceAll('\\W', ' ').replaceAll('\\s+', ' ').trim();
        String[] strings = replace.split('\\s');
        for (Integer i = 0; i < strings.size(); i++) {
            if (strings[i].equals('channel') && (i + 1) <= strings.size()) {
                channelName.add(strings[i + 1]);
            }
        }
        HttpRequest request = new HttpRequest();
        request.setEndpoint('callout:Connect_To_Slack');
        request.setMethod('POST');
        request.setHeader('Content-Type', 'application/json;charset=UTF-8');
        request.setHeader('Authorization', 'Bearer {!$Credential.Password}');
        String jsonBody = '{"name" : "' + channelName[0] + '"}';
        request.setBody(jsonBody);
        System.debug(request.getBody());

        Http http = new Http();
        HttpResponse response = http.send(request);
        System.debug(response.getBody());
    }


//        String token = ' {!$Credential.Password} ';
//        String token = '';
//
//        List<AuthProvider> tokenList = Database.query('SELECT ConsumerSecret FROM AuthProvider');
//        for (AuthProvider obj : tokenList) {
//            token = (String)obj.get('ConsumerSecret');
//        }
//
//        Map<String, String> parameters = new Map<String, String>();
//        parameters.put('token', token);
//        parameters.put('name', channelName[0]);
//        parameters.put('variable', 'true');
//        System.debug(parameters);
//
//        Map<String, String> header = new Map<String, String>();
//        header.put('Content-Type', 'application/json;charset=UTF-8');
//
//        String body = '';
//
//        HttpResponse response = new Http().send(createRequest('callout:Connect_To_Slack',
//                'POST', parameters, header, body));
//        System.debug(response);
//
//        if (response.getStatusCode() == 200) {
//            System.debug(response.getBody());
//            Map<String, Object> deserialize = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
//            Map<String, Object> deserialize2 = (Map<String, Object>) deserialize.get('channel');
//            linkId = deserialize2.get('id').toString();
//            System.debug(linkId);
//        }
//    }
//
//    private static HttpRequest createRequest(String endpoint, String requestMethod, Map<String, String> parameters,
//            Map<String, String> headers, String body) {
//        HttpRequest request = new HttpRequest();
//        if (parameters != null && !parameters.isEmpty()) {
//            endpoint = endpoint + '?';
//            Integer counter = 1;
//            for (String key : parameters.keySet()) {
//                if (counter < parameters.size()) {
//                    endpoint = endpoint + key + '=' + parameters.get(key) + '&';
//                    counter++;
//                } else {
//                    endpoint = endpoint + key + '=' + parameters.get(key);
//                }
//            }
//        }
//        if (headers != null && !headers.isEmpty()) {
//            for (String key : headers.keySet()) {
//                request.setHeader(key, headers.get(key));
//            }
//        }
//        if (String.isNotBlank(body)) {
//            request.setBody(body);
//        }
//        request.setEndpoint(endpoint);
//        request.setMethod(requestMethod);
//        request.setTimeout(20000);
//        return request;
//    }

    public String getChannelLink() {
        return linkId;
    }

}