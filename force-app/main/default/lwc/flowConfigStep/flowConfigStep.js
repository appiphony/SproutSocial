import { LightningElement } from 'lwc';
import saveData from "@salesforce/apex/SetupAssistant.saveData";


export default class FlowConfigStep extends LightningElement {
    constructor() {

        super();

        this.template.addEventListener('next', this.next.bind(this));

    }

    next(event) {
        let setupData = {
            Steps_Completed__c : JSON.stringify({'C-FLOW-CONFIG-STEP' : 1})
        }

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