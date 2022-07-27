import { api, LightningElement, track } from 'lwc';
import saveData from "@salesforce/apex/SetupAssistant.saveData";
import getData from "@salesforce/apex/SetupAssistant.getData";
import executeDeleteBatch from '@salesforce/apex/debugLogStep.executeDeleteBatch';
import { getDataConnector } from 'lightning/analyticsWaveApi';


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

    @api
    show(){
        //debugger
        return new Promise((resolve, reject) => {
            getData().then(res => {
                let parsedRes = JSON.parse(res);
                if(parsedRes.isSuccess){
                    let setupMetadata = parsedRes.results.setupData;
                    this.currentLogRecordCount = parsedRes.results.currentLogRecordCount;

                    if(setupMetadata.Retention_Value__c){
                        this.capturedActivityValue = setupMetadata.Retention_Type__c;
                        this.logRecordsRetainedLimit = setupMetadata.Retention_Value__c;
                    }
                } else {
                    this.showToast('error', parsedRes.error);
                }

            }).catch(error => {
                this.showToast('error', error.message ? error.message : error.body.message);
            }).finally(() => {
                resolve();
            })
        })
    }

    get disableDeletelogs() {
        return this.currentLogRecordCount === 0;
    }

    updateCapturedActivityValue(event) {
        this.capturedActivityValue = event.detail.value;
    }

    updateLogLimit(event){
        this.logRecordsRetainedLimit = event.currentTarget.value;
    }

    handleDeleteLogModal(event) {
        const currentClick = event.currentTarget.label;
        if (currentClick === 'Delete All') {
            this.template.querySelector('.strike-delete-logs').show();
        } else {
            if (currentClick === 'Confirm') {
                executeDeleteBatch().then(res => {
                    let parsedRes = JSON.parse(res);
                    if(parsedRes.isSuccess) {
                        this.showToast('success', 'Deletion batch job has been queued.');
                    } else {
                        this.showToast('error', parsedRes.error);
                    }
                })
                this.currentLogRecordCount = 0;
            }
            this.template.querySelector('.strike-delete-logs').hide();
        }
    }

    next(event) {
        //debugger
        event.stopPropagation();
        let setupData = {
            Steps_Completed__c : JSON.stringify({'C-PACKAGE-LOG-CONFIG-STEP' : 1}),
            Retention_Type__c : this.capturedActivityValue,
            Retention_Value__c : this.logRecordsRetainedLimit
        }

        saveData({setupData:setupData}).then(res => {
            let parsedRes = JSON.parse(res);
            if (parsedRes.isSuccess) {
                this.dispatchEvent(new CustomEvent('next', {
                    bubbles: true,
                    composed: true
                }));
            } else {
                this.showToast('error', parsedRes.error);
            }
        }).catch(error => {
            packageLogger.create();
            this.showToast('error', error.message ? error.message : error.body.message);
        });
    }

    showToast(type, message) {
        this.dispatchEvent(new CustomEvent('showtoast', {
            detail: {
                message : message,
                variant : type
            },
            bubbles: true,
            composed: true
        }));
    }
}