import { LightningElement, track } from 'lwc';
import saveData from "@salesforce/apex/SetupAssistant.saveData";


export default class PackageLogConfigStep extends LightningElement {

    @track loggedActivitySelection = 'errorsOnly';
    @track currentLogRecordCount = 500;
    @track logRecordsRetainedLimit = '1000'
    @track capturedActivityValue = 'errorsOnly';
    @track capturedActivityType = [
        {
            label: 'Errors Only',
            value: 'errorsOnly'
        },
        {
            label: 'All Activity',
            value: 'allActivity'
        }
    ]

    constructor() {

        super();

        this.template.addEventListener('next', this.next.bind(this));

    }

    get disableDeletelogs() {
        return this.currentLogRecordCount === 0;
    }

    updateCapturedActivityValue(event) {
        this.capturedActivityValue = event.detail.value;
    }

    handleDeleteLogModal(event) {
        const currentClick = event.currentTarget.label;
        if (currentClick === 'Delete All') {
            this.template.querySelector('.strike-delete-logs').show();
        } else {
            if (currentClick === 'Confirm') {
                // Delete All Records
                this.currentLogRecordCount = 0;
            }
            this.template.querySelector('.strike-delete-logs').hide();
        }
    }

    next(event) {
        //debugger
        let setupData = {
            Steps_Completed__c : JSON.stringify({'C-PACKAGE-LOG-CONFIG-STEP' : 1})
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