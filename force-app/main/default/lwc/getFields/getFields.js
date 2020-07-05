import { LightningElement, wire, track } from 'lwc';
import getObjecttFields from '@salesforce/apex/filedsClass.getObjecttFields';
import getType from '@salesforce/apex/filedsClass.getType';

export default class GetFields extends LightningElement {
    filedOptions;
    ObjName;
    fieldname;

    get options() {
        return [
            { label: 'Account', value: 'Account' },
            { label: 'Contact', value: 'Contact' },
            { label: 'Lead', value: 'Lead' },
        ];
    }

    handelObject(event) {
        console.log(event.detail.value);
        this.ObjName = event.detail.value;
        getObjecttFields({ objectname: this.ObjName }).then((data) => {
            this.filedOptions = data;
        }).catch((error) => {
            console.log(error);
        });
    }

    handelFileds(event) {
        this.fieldname = event.detail.value;
    }

    handleClick() {
        console.log(this.ObjName);
        console.log(this.fieldname);
        getType({ type: this.fieldname, objectname: this.ObjName }).then(() => {

        }).catch(() => {

        });
    }
}