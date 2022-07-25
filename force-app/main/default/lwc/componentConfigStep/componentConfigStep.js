import { LightningElement } from 'lwc';
import saveData from "@salesforce/apex/SetupAssistant.saveData";


export default class ComponentConfigStep extends LightningElement {
    constructor() {

        super();

        this.template.addEventListener('next', this.next.bind(this));

    }

    next(event) {
        //debugger
        let setupData = {
            Steps_Completed__c : JSON.stringify({'C-COMPONENT-CONFIG-STEP' : 1})
        }
        console.log("it works");

        saveData({setupData:setupData}).then(res => {
            let parsedRes = JSON.parse(res);
            if (parsedRes.isSuccess) {
                //let results = responseData.results;
            } else {
                this.showToast('error', parsedRes.error);
            }
        }).catch(error => {
            this.showToast('error', error.message ? error.message : error.body.message);
        });
    }
}