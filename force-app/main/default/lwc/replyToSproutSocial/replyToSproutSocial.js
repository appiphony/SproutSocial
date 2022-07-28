import { LightningElement, track } from 'lwc';
import sproutSocialIcon from '@salesforce/resourceUrl/sproutSocialIcon';
import sproutSocialEmptyState from '@salesforce/resourceUrl/sproutSocialEmptyState';


export default class ReplyToSproutSocial extends LightningElement {
    sproutSocialIcon = sproutSocialIcon;
    sproutSocialEmptyState = sproutSocialEmptyState;
    @track isClassic = false;
    @track hasError = true;
    @track setupComplete = true; 
    
    get errorMessage() {
        return !this.setupComplete ? 'Complete the Sprout Social Setup Assistant to use this component.' : 'A System Administrator must assign the "Sprout Social User" permission set to you in order for you to use this component.';
    }
}