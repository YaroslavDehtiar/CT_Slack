import { LightningElement, track, api } from 'lwc';

export default class Modal extends LightningElement {

    @track isModalOpen = false;
    @track modalStyle = 'display : none;';
    @track bodyStyle = '';
    @track modalSectionStyle;
    @api size = 'small';


    connectedCallback(){
        this.setModalSize();
    }

    @api
    open() {
        this.modalStyle = '';
    }

    @api
    close() {
        this.dispatchEvent(new CustomEvent("modalclose"));
        this.modalStyle = 'display : none;';
    }

    @api
    overflowFix() {
        this.bodyStyle = 'overflow: visible; overflow-y: visible';
    }

    @api
    overflowScroll() {
        this.bodyStyle = 'overflow: visible; overflow-y: auto';
    }

    setModalSize() {
        let baseCss = 'slds-modal slds-fade-in-open ';

        switch (this.size) {
            case 'small':
            this.modalSectionStyle = baseCss + 'slds-modal_small';
            break;

            case 'medium':
            this.modalSectionStyle = baseCss + 'slds-modal_medium';
            break;

            case 'large':
            this.modalSectionStyle = baseCss + 'slds-modal_large';
            break;
        }
    }
}