import LightningDatatable from 'lightning/datatable';
import toggleInput from './toggleInput.html';
import checkBoxCell from './checkboxInput.html';
import contextActionOrder from './contextActionOrder.html'

export default class CustomDatatable extends LightningDatatable {
    static customTypes = {
        checkBoxCell: {
            template: checkBoxCell,
            typeAttributes: ['isChecked', 'isDisabled', 'recordId'],
        },
        toggle: {
            template: toggleInput,
            typeAttributes: ['rowId', 'label', 'name', 'required', 'messageToggleActive', 'messageToggleInactive']
        },
        contextActionOrder: {
            template: contextActionOrder,
            typeAttributes: ['recordId', 'order', 'rowId']
        }
    };
}