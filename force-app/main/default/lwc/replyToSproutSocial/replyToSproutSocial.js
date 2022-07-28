import { LightningElement, track } from 'lwc';
import sproutSocialIcon from '@salesforce/resourceUrl/sproutSocialIcon';
import sproutSocialEmptyState from '@salesforce/resourceUrl/sproutSocialEmptyState';


export default class ReplyToSproutSocial extends LightningElement {
    sproutSocialIcon = sproutSocialIcon;
    sproutSocialEmptyState = sproutSocialEmptyState;
    @track isClassic = false;
    @track hasError = true;
    @track setupComplete = false; 
    
    get errorMessage() {
        return !this.setupComplete ? 'Complete the Sprout Social Setup Assistant to use this component.' : 'This user does not have permission to use this component. Please contact your admin.';
    }
}