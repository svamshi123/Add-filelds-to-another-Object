public with sharing class filedsClass {

    @AuraEnabled(cacheable=true)
    public static List<OptionWrapper> getObjecttFields(String objectname){
        List<OptionWrapper> optionlist = new List<OptionWrapper>();
        SObjectType contactType = Schema.getGlobalDescribe().get(objectname);
        Map<String,Schema.SObjectField> mfields = contactType.getDescribe().fields.getMap();
        for(String s : mfields.keySet()){
           optionlist.add(new OptionWrapper(String.valueOf(mfields.get(s)),String.valueOf(mfields.get(s))));
        }
        return optionlist;
    }
    @AuraEnabled
    public static void getType(String type,String objectname){
        String objName = objectname;
        String fieldName = type;
        String fieldLabel = type;
        String word = '__c';
        if (fieldLabel.contains(word)) { 
            String tempWord = word + ''; 
            fieldLabel = fieldLabel.replaceAll(tempWord, ''); 
            tempWord = '' + word; 
            fieldLabel = fieldLabel.replaceAll(tempWord, ''); 
        }
        System.debug('string'+fieldLabel);
        System.debug(fieldName);
        Schema.DisplayType f = Schema.getGlobalDescribe().get(objName).getDescribe().fields.getMap().get(fieldName).getDescribe().getType();
        generateTextField('A__c', fieldName, 'Text Field created by apex', fieldLabel,f);
        System.debug(f);
    }

     public static void generateTextField(String objectAPIName, String fieldAPIName, String fieldDescription, String fieldLabel,Schema.DisplayType fieldtype){
         System.debug(fieldAPIName);
         String metadata = '';
        if(fieldtype == Schema.DisplayType.String){
             metadata = '{"Metadata" : {"type" : "Text","description" : "'+fieldDescription+'", "inlineHelpText" : "","precision" : null,"label" : "'+fieldLabel+'","length" : 255,"required" : false}, "FullName" : "'+objectAPIName+'.'+fieldAPIName+'"}';
        }else if(fieldtype == Schema.DisplayType.Phone){
            metadata = '{"Metadata" : {"type" :"Phone","description" : "phone field","label" : "'+fieldLabel+'","required" : false},"FullName" : "'+objectAPIName+'.'+fieldAPIName+'"}';
        }else if(fieldtype ==  Schema.DisplayType.Boolean){
            metadata = '{"Metadata" : {"type" :"Checkbox","description" : "Check field","label" : "'+fieldLabel+'","defaultValue" : false},"FullName" : "'+objectAPIName+'.'+fieldAPIName+'"}';
        }
        
        String responseBody = createField(metadata);
        System.debug(responseBody);
    }

    public static String createField(String metadata) {
        System.debug(metadata);

        HttpRequest request = new HttpRequest();
        request.setHeader('Authorization', 'Bearer ' + Page.GenerateSessionIdForLWC.getContent().toString());
        request.setHeader('Content-Type', 'application/json');
        request.setEndpoint(URL.getSalesforceBaseUrl().toExternalForm()+'/services/data/v46.0/tooling/sobjects/CustomField');
        request.setMethod('POST');
        
        request.setBody(metadata);
        
        Http http = new Http();
        HTTPResponse res = http.send(request);
        return res.getBody();
    }
      public class OptionWrapper {
        @AuraEnabled
        public String label {get; set;}
        @AuraEnabled
        public String value {get; set;}
    
        public OptionWrapper(String label, String value) {
            this.label = label;
            this.value = value;
        }
    }
}
