@RestResource(urlMapping='/sprout/SocialPost')
global class SocialPostResource {
    
    @HttpPost
    global static void doPost(Social_Post_Request_Param postData, Social_Persona_Request_Param personaData, SocialPostOptions options) {     
        
        

        insert new Sprout_Social_Data_Event__c(
            Raw_Post_Data__c = JSON.serialize(postData),
            Raw_Persona_Data__c = JSON.serialize(personaData),
            Unsent_Parent__c = options.unsentParent,
            Skip_Create_Case__c = options.skipCreateCase,            
            Media_Provider__c = translateProvider(personaData.provider),
            Message_Type__c = postData.messageType,
            Sprout_Message_Type__c = postData.sproutMessageType,
            Persona_Author_Labels__c = personaData.authorLabels,
            Persona_External_Picture_URL__c = personaData.externalPictureURL,
            Persona_Followers__c = personaData.followers,
            Persona_Profile_URL__c = personaData.profileURL,
            Persona_Provider__c = personaData.provider,
            Persona_Real_Name__c = personaData.realName,
            Post_Content__c = postData.content,
            Post_External_ID__c = postData.externalPostId,
            Post_Handle__c = postData.handle,
            Post_Name__c = postData.name,
            Post_Provider__c = translateProvider(postData.provider),
            Post_Tags__c = postData.postTags,
            Post_URL__c = postData.postUrl,
            Posted_At__c = DateTime.valueOfGMT(postData.posted.replace('T', ' ')),
            Customer_Profile_Id__c = postData.customerProfileId,
            Parent_GUID__c = postData.parentGuid,
            Persona_Name__c = personaData.name,
            Persona_External_Id__c = personaData.externalId,
            Persona_First_Name__c = personaData.firstName,
            Persona_Last_Name__c = personaData.lastName,
            Post_Recipient__c = postData.recipient
        );
            
    }

    global class Social_Post_Request_Param {
        String name;
        String content;
        String externalPostId;        
        String messageType; //formerly Message_Type
        String sproutMessageType;
        String customerProfileId; //formerly Customer_Profile_Id
        String handle;        
        String provider;
        String postTags;
        String posted;
        String postUrl;
        String parentGuid; //formerly Parent_GUID
        String recipient;
    }

    global class Social_Persona_Request_Param {
        String name;
        String realName;
        String provider;
        //String mediaProvider;
        String externalId;
        String externalPictureURL;
        String profileURL;
        Integer followers;
        String authorLabels;
        String firstName;
        String lastName;
    }

    global class SocialPostOptions {
        Boolean skipCreateCase;
        Boolean unsentParent;
        private Map<String, Object> getMap() {
            return new Map<String, Object> {
                'skipCreateCase' => this.skipCreateCase,
                'unsentParent' => this.unsentParent
            };
        }
    }

    private static String translateProvider(String providerName) {        
        if (providerName.contains('instagram')) {
           return 'Instagram';
        } else if (providerName.contains('twitter')) {
           return 'Twitter';
        } else if (providerName.contains('whatsapp')) {
           return 'Whatsapp';
        } else if (providerName.contains('linkedin')) {
           return 'LinkedIn';
        } else if (providerName.contains('facebook')) {
           return 'Facebook';
        } else {
           return 'Other';
        }
    }
}