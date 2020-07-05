public with sharing class Adddynamically {


    @AuraEnabled(cacheable=true)
     public static List<OptionWrapper> getAllObjects(){
        List<OptionWrapper> sobjectname = new List<OptionWrapper>();
        List<String> sObjectList = new List<String>();
        for(Schema.SObjectType objTyp : Schema.getGlobalDescribe().Values()){
            Schema.DescribeSObjectResult res = objTyp.getDescribe();
            sobjectname.add(new OptionWrapper(res.getLabel(),objTyp.getDescribe().getName()));
        }
        return sobjectname;
    }
     @AuraEnabled(cacheable=true)
    public static List<FildWrapper> getAccounts(String objectName){
        List<FildWrapper> accList = new List<FildWrapper>();
        String str = 'select Id,name from '+ objectName;
        List<SObject> accoutList = Database.query(str);
        for(SObject c :accoutList){
            accList.add(new FildWrapper((String)c.get('Name'),(Id)c.get('Id')));
        }
        system.debug(accList);
        return accList;
    }
    
     @AuraEnabled
    public static  List<ChildObjectWrapper> cloneAccont(String accountid){
        List<ChildObjectWrapper> childObjWrapperList = new List<ChildObjectWrapper>();
        String parentObjName = '';
        parentObjName = getObjectNameFromId(accountid);
        List<Schema.ChildRelationship> childObjList = getChildRelationshipsFromId(accountid);
        for(Schema.ChildRelationship child : childObjList){
            if(child.getChildSObject().getDescribe().isQueryable()){
                if(child.getField().getDescribe().isCreateable()){
                    childObjWrapperList.add(new ChildObjectWrapper(child.getChildSObject().getDescribe().getName(),false,accountid,String.valueOf(child.getField())));
                }
            }
        }
        return childObjWrapperList;
    }

    public static String getObjectNameFromId(Id recordId){
        Schema.DescribeSObjectResult dr = getDescribeSObjectResultFromId(recordId);
        return dr.getName(); 
    }
     public static List<Schema.ChildRelationship> getChildRelationshipsFromId(Id recordId){
        Schema.DescribeSObjectResult dr = getDescribeSObjectResultFromId(recordId);
        return dr.getChildRelationships();
    }
     public static Schema.DescribeSObjectResult getDescribeSObjectResultFromId(Id recordId){
        Schema.SObjectType token = recordId.getSObjectType();
        return token.getDescribe();
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

     public class FildWrapper {
        @AuraEnabled
        public String label {get; set;}
        @AuraEnabled
        public Id value {get; set;}
       
        public FildWrapper(String label, id value) {
            this.label = label;
            this.value = value;
        }
    } 

    public class ChildObjectWrapper{
        @AuraEnabled
        public String objName {get;set;}
        @AuraEnabled
        public boolean isSelected {get;set;}
        @AuraEnabled
        public String recordId {get;set;}
        @AuraEnabled
        public String relationshipName {get;set;}
        
        ChildObjectWrapper(String objName, Boolean isSelected,String recordId, String relationshipName){

            this.objName = objName;
            this.isSelected = isSelected;
            this.recordId = recordId;
            this.relationshipName = relationshipName;
        }
     }      
}
