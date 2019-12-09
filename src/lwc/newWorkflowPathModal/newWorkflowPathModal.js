/**
 * Created by joel.smith on 11/5/19.
 */

import { LightningElement, api } from 'lwc';

export default class NewWorkflowPathModal extends LightningElement {

    @api
    handleNewPathButtonClick() {
        this.template.querySelector('c-modal').open();
    }

    handleNewPathModalCancelButtonClick() {
        this.template.querySelector('c-modal').close();
    }
}