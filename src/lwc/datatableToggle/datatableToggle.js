import {LightningElement, api} from 'lwc';

export default class DatatableToggle extends LightningElement {

    @api rowId;
    @api label;
    @api name;
    @api checked = false;
    @api required = false;
    @api messageToggleActive;
    @api messageToggleInactive;

    handleChange(event) {
        this.dispatchEvent(new CustomEvent('togglechange', {
            composed: true,
            bubbles: true,
            cancelable: true,
            detail: {
                name: this.name,
                rowId: this.rowId,
                isChecked: event.target.checked
            },
        }));
    }
}