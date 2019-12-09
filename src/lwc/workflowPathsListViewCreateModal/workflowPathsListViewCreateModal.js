import {LightningElement, track, api} from 'lwc';
import getObjectOptions from '@salesforce/apex/WorkflowPathsListViewCreateController.getObjectOptions';
import getObjectInfo from '@salesforce/apex/WorkflowPathsListViewCreateController.getObjectInfo';
import {ShowToastEvent} from "lightning/platformShowToastEvent";

export default class WorkflowPathsListViewCreateModal extends LightningElement {

    @track isModalOpened;
    @track showSpinner;

    @track objectOptions;
    @track controllingFieldOptions;
    @track recordTypeOptions;

    get hasRecordType() {
        return (this.recordTypeOptions != null && this.recordTypeOptions.length > 0);
    }

    @api
    open() {
        this.isModalOpened = true;
        let modal = this.template.querySelector('.modal');
        modal.open();

        this.runAsyncAction(getObjectOptions).then(result => {
            this.objectOptions = this.prepareComboboxOptions(result);
        }).catch(error => {
            this.showToast(error);
        });
    }

    handleObjectSelected(event) {
        let objectName = event.target.value;
        if (objectName) {
            let resetableInputs = this.template.querySelectorAll('.resetable-input');
            if (resetableInputs) {
                resetableInputs.forEach(input => {
                    input.value = undefined;
                })
            }
            this.runAsyncAction(getObjectInfo, {sobjectTypeName: objectName}).then(result => {
                this.controllingFieldOptions = this.prepareComboboxOptions(result.controllingFieldOptions);
                this.recordTypeOptions = this.prepareComboboxOptions(result.recordTypeOptions);
            }).catch(error => {
                this.showToast(error);
            })
        }
    }

    handleCloseModal(event) {
        this.isModalOpened = false;
        let modal = this.template.querySelector('.modal');
        modal.close();
    }

    handlePathCreate(event) {
        let inputs = this.template.querySelectorAll('lightning-input, lightning-combobox');
        if (!inputs) return;

        let areFieldsValid = true;
        let result = {};
        inputs.forEach((input) => {
            let isInputValid = input.reportValidity();
            if (areFieldsValid) areFieldsValid = isInputValid;
            if (input.value) {
                result[input.name] = input.value
            }
        });
        const replace = /__/g;
        result.developerName = (result.sObjectName + ((result.recordType) ? '_' + result.recordType : '')).replace(replace, '_') ;

        if (areFieldsValid) {
            this.dispatchEvent(new CustomEvent('create', {
                detail: result
            }))
        } else {
            this.showToast('Please correct all invalid field values.');
        }
    }

    prepareComboboxOptions(value) {
        if (!value) return [];

        return Object.keys(value).map((key) => {
            return {value: key, label: value[key]};
        });
    }

    runAsyncAction(asyncFunction, parameters) {
        if (asyncFunction) {
            this.showSpinner = true;
            return asyncFunction(parameters).finally(() => {
                this.showSpinner = false;
            })
        }
    }

    showToast(error) {
        let message = (error && error.body) ? error.body.message : error;
        const event = new ShowToastEvent({
            title: 'Error',
            message: message,
            variant: 'error'
        });
        this.dispatchEvent(event);
    }
}