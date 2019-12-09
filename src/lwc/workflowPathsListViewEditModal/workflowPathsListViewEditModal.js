import {LightningElement, api, track} from 'lwc';
import {ShowToastEvent} from 'lightning/platformShowToastEvent';

export default class WorkflowPathsListViewEditModal extends LightningElement {

    @track isModalOpened;
    @track editedPathLabel;
    editedPathDeveloperName;

    @api
    open(editedPathLabel, editedPathDeveloperName) {
        this.isModalOpened = true;
        this.editedPathLabel = editedPathLabel;
        this.editedPathDeveloperName = editedPathDeveloperName;

        let modal = this.template.querySelector('.edit-modal');
        modal.open();
    }

    handleCloseModal(event) {
        this.isModalOpened = false;
        let modal = this.template.querySelector('.edit-modal');
        modal.close();
    }

    handlePathEdit(event) {
        let nameInput = this.template.querySelector('.path-name');
        if (this.validateForm(nameInput)) {
            this.dispatchEvent(new CustomEvent('edit', {
                detail: {
                    masterLabel: nameInput.value,
                    developerName: this.editedPathDeveloperName
                }
            }));
        }
    }

    validateForm(input) {
        input.reportValidity();
        if (input.value) return true;

        this.showToast('Please correct all invalid field values.');
        return false;
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