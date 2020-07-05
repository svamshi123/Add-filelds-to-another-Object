import { LightningElement,track } from 'lwc';
import { NavigationMixin } from 'lightning/navigation';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
//import getContract from '@salesforce/apex/Adddynamically.getContract';

export default class Adddynamically extends NavigationMixin(LightningElement) {
    connectedCallback(){
        this.getContact();
    }
    ContactValues = {
        "firstname":'',
        "lastname":'',
        "title":'',
        "email":'',
        "accountid":''
    }
    keyIndex = 0;
    contacts;
    @track itemList = [
        {
            id: 0
        }
    ];
    addRow() {
        ++this.keyIndex;
        var newItem = [{ id: this.keyIndex }];
        this.itemList = this.itemList.concat(newItem);
    }
    removeRow(event) {
        if (this.contacts.length >= 2) {
            this.contacts = this.contacts.filter(function (element) {
                return parseInt(element.id) !== parseInt(event.target.accessKey);
            });
        }
        if (this.itemList.length >= 2) {
            this.itemList = this.itemList.filter(function (element) {
                return parseInt(element.id) !== parseInt(event.target.accessKey);
            });
        }
    }
    handleSubmit() {
        var isVal = true;
        this.template.querySelectorAll('lightning-input-field').forEach(element => {
            isVal = isVal && element.reportValidity();

        });
        if (isVal) {
            this.template.querySelectorAll('lightning-input-field').forEach(function(element) {
                if(element.name == "input1"){
                    this.ContactValues.firstname = element.value;
                }else if(element.name == "input2"){
                    this.ContactValues.lastname = element.value;
                }else if(element.name == "input3"){
                    this.ContactValues.title = element.value;
                }else if(element.name == "input4"){
                    this.ContactValues.email = element.value;
                }else if(element.name == "input5"){
                    this.ContactValues.accountid = element.value;
                }
               // element.submit();
            },this);
          //  console.log(this.ContactValues);
                //console.log(element);
                
               // element.submit();
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Success',
                    message: 'Contacts successfully created',
                    variant: 'success',
                }),
            );
            // this[NavigationMixin.Navigate]({
            //     type: 'standard__objectPage',
            //     attributes: {
            //         objectApiName: 'Contact',
            //         actionName: 'home',
            //     },
            // });
        } else {
            this.dispatchEvent(
                new ShowToastEvent({
                    title: 'Error creating record',
                    message: 'Please enter all the required fields',
                    variant: 'error',
                }),
            );
        }
    }
    getContact(){
        // getContract().then((data) =>{
           
        //    // console.log(data);
        //     this.contacts = data;
        //    // console.log(this.contacts);
        // })
    }
}