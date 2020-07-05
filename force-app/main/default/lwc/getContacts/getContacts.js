import { LightningElement, track, wire, api } from 'lwc';
//import getContacts from '@salesforce/apex/Adddynamically.getContract';

export default class GetContacts extends LightningElement {
    @track searchKey = '';
    @api recordId;
    
    // @wire(getContacts, { searchKey: '$searchKey' })
    // contacts;

    connectedCallback(){
        this.searchKey = this.recordId;
    }
}