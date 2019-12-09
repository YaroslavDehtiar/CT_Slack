import {createElement} from 'lwc';
import DatatableToggle from 'c/datatableToggle';

describe('datatable-toggle', () => {

    afterEach(() => {
        while (document.body.firstChild) {
            document.body.removeChild(document.body.firstChild);
        }
        jest.clearAllMocks();
    });
    
    it('template test', () => {
        const toggle = createElement('c-datatable-toggle', {is: DatatableToggle});
        document.body.appendChild(toggle);

        return Promise.resolve().then(() => {
            let elements = toggle.shadowRoot.querySelectorAll('lightning-input');
            expect(elements).toBeTruthy();
            expect(elements.length).toBe(1);
        });
    });

    it('default attributes test', () => {
        const toggle = createElement('c-datatable-toggle', {is: DatatableToggle});
        document.body.appendChild(toggle);

        return Promise.resolve().then(() => {
            expect(toggle.checked).toBe(false);
            expect(toggle.required).toBe(false);
        });
    });

    it('toggle change event test', () => {
        const toggle = createElement('c-datatable-toggle', {is: DatatableToggle});
        toggle.name = 'testName';
        toggle.rowId = 'testRowId';
        document.body.appendChild(toggle);

        let changeListener = jest.fn();
        document.body.addEventListener('togglechange', changeListener);

        let element = toggle.shadowRoot.querySelector('lightning-input');
        element.checked = true;
        element.dispatchEvent(new CustomEvent('change'));

        return Promise.resolve().then(() => {
            expect(changeListener).toHaveBeenCalled();
            expect(changeListener.mock.calls[0][0].detail.name).toBe('testName');
            expect(changeListener.mock.calls[0][0].detail.rowId).toBe('testRowId');
            expect(changeListener.mock.calls[0][0].detail.isChecked).toBe(true);
        });
    });
});
