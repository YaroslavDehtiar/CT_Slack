/**
 * Created by YaroslavDehtiar on 28.11.2019.
 */

import {api, LightningElement} from 'lwc';

export default class ContextActionOrder extends LightningElement {
    @api rowId;
    @api order;
    @api increaseButton;
    @api decreaseButton;

    increaseOrder() {
        this.dispatchEvent(new CustomEvent('increaseorder', {
            composed: true,
            bubbles: true,
            cancelable: true,
            detail: {
                order: this.order,
                rowId: this.rowId,
            }
        }));
    }
    decreaseOrder() {
        this.dispatchEvent(new CustomEvent('decreaseorder', {
            composed: true,
            bubbles: true,
            cancelable: true,
            detail: {
                order: this.order,
                rowId: this.rowId,
            }
        }));
    }
}