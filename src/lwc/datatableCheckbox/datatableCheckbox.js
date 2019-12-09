import { LightningElement, api, track} from 'lwc';

export default class DatatableCheckbox extends LightningElement {
    @api recordId;
    @api isDisabled = false;
    @api isChecked = false;

    onChange(event) {
        this.isChecked = event.target.checked;
        this.dispatchEvent(new CustomEvent('select', {
            composed: true,
            bubbles: true,
            cancelable: true,
            detail: {
                recordId: this.recordId,
                isChecked: this.isChecked
            },
        }));
    }


}