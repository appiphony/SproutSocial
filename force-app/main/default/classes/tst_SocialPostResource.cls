@isTest
public with sharing class tst_SocialPostResource {
    
    @isTest
    static void testPost(){
        Map<String, Object> postData = new Map<String, Object>();
        postData.put('name', 'Post From me');
        postData.put('content', 'test');
        postData.put('externalPostId', 'test');
        postData.put('messageType', 'post');
        postData.put('SproutMessageType', 'tweet');
        postData.put('customerProfileId', '');
        postData.put('handle', 'test');
        postData.put('provider', 'twitter');
        postData.put('postTags', 'test');
        postData.put('posted', '2019-04-23T16:01:42');
        postData.put('postURL', 'test');
        postData.put('parentGuid', null);
        postData.put('recipient', 'test');

        Map<String, Object> personaData = new Map<String, Object>();
        personaData.put('name', 'David');
        personaData.put('realName', 'David B');
        personaData.put('provider', 'TWITTER');
        personaData.put('mediaProvider', 'TWITTER');
        personaData.put('externalId', '123421');
        personaData.put('externalPictureURL', 'David');
        personaData.put('profileURL', '123qwe');
        personaData.put('followers', '123');
        personaData.put('authorLabels', '123qwe');
        personaData.put('firstName', 'dave');
        personaData.put('lastName', 'de');

        Map<String, Object> options = new Map<String, Object>();
        options.put('unsentParent', false);
        options.put('skipCreateCase', false);



        //SocialPostResource.doPost((SocialPostResource.Social_Post_Request_Param) postData, (SocialPostResource.Social_Persona_Request_Param)personaData, options);
    }
}
