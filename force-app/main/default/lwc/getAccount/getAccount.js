import { LightningElement,wire } from 'lwc';
import getAccounts from '@salesforce/apex/Adddynamically.getAccounts';
import cloneAccont from '@salesforce/apex/Adddynamically.cloneAccont';
import getAllObjects from '@salesforce/apex/Adddynamically.getAllObjects';
//import cloneWithChildren from '@salesforce/apex/Adddynamically.cloneWithChildren';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class GetAccount extends LightningElement {
    accountOptions;
    accid;
    valid;
    childlist;
    
    @wire(getAllObjects)
        AllObjects;

        get AllObjectsOptions() {
            return this.AllObjects.data;
        }




    handleObjects(event){
        console.log("hai");
        console.log(event.detail.value);
        getAccounts({objectName : event.detail.value}).then((data) => {
            this.accountOptions = data;
        })
    }
    handleChange(event){
       var inp = this.template.querySelectorAll("lightning-combobox");
       inp.forEach(function(element){
           if(element.name == "input1"){
               this.accid = element.value;
           }
       },this);
       console.log(this.accid);
       cloneAccont({accountid :this.accid}).then((data) =>{
           console.log(data.objName);
           console.log(data);
           this.childlist = data;
           console.log(this.childlist);
       });
    }
    hanndlecheck(event){
        var inp = this.template.querySelectorAll("lightning-input");
        inp.forEach(function(element){
           console.log(element.name);
        },this);

    }
    viewRecord(){
        // cloneWithChildren().then(() =>{

        // }).catch(() =>{

        // })
    }

    handlevalidation(){
        var inp = this.template.querySelectorAll("lightning-combobox");
        inp.forEach(function(element){
            if(element.name == "inputObj"){
                this.valid = element.value;
            }
        },this);
        if(this.valid == undefined){
            const errortoast = new ShowToastEvent({
                'title':'Error!',
                'message' : 'Enter valid Values',
                'variant' : 'error'
            });
            this.dispatchEvent(errortoast); 
        }
    }
}